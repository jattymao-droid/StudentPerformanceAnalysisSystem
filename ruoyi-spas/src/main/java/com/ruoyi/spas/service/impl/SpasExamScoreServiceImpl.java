package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.spas.domain.SpasExam;
import com.ruoyi.spas.domain.SpasExamScore;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.mapper.SpasExamScoreMapper;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.service.ISpasExamScoreService;
import com.ruoyi.spas.support.ExamStudentResolver;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasTeacherScopeService;
import com.ruoyi.spas.warning.WarningEngine;

/**
 * Multi-subject exam score + school rank import.
 * Columns come from Excel headers; not bound to spas_subject.
 */
@Service
public class SpasExamScoreServiceImpl implements ISpasExamScoreService
{
    private static final String SUFFIX_SCORE = "\u5f97\u5206";
    private static final String SUFFIX_RANK = "\u6821\u6b21";
    private static final String COL_NO = "\u5b66\u53f7";
    private static final String COL_NAME = "\u59d3\u540d";
    private static final String TOTAL_LABEL = "\u603b\u5206";

    /** Fixed template subjects. Import accepts any score/rank column pairs from Excel. */
    private static final List<String> TEMPLATE_SUBJECTS = Collections.unmodifiableList(Arrays.asList(
        "\u8bed\u6587",
        "\u6570\u5b66",
        "\u82f1\u8bed",
        "\u7269\u7406",
        "\u5316\u5b66",
        "\u751f\u7269\u5b66"
    ));

    @Autowired
    private SpasExamScoreMapper examScoreMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private SpasPaperMapper paperMapper;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Autowired
    private WarningEngine warningEngine;

    @Override
    public List<SpasExam> selectSpasExamList(SpasExam exam)
    {
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(exam);
            return examScoreMapper.selectSpasExamList(exam);
        }
        return SpringUtils.getAopProxy(this).selectSpasExamListScoped(exam);
    }

    @DataScope(deptAlias = "d")
    public List<SpasExam> selectSpasExamListScoped(SpasExam exam)
    {
        return examScoreMapper.selectSpasExamList(exam);
    }

    @Override
    public SpasExam selectSpasExamById(Long examId)
    {
        return examScoreMapper.selectSpasExamById(examId);
    }

    @Override
    public List<SpasExamScore> selectScoresByExamId(Long examId)
    {
        return examScoreMapper.selectScoresByExamId(examId);
    }

    @Override
    public Map<String, Object> selectExamMatrix(Long examId)
    {
        SpasExam exam = examScoreMapper.selectSpasExamById(examId);
        if (exam == null)
        {
            throw new ServiceException("\u8003\u8bd5\u4e0d\u5b58\u5728");
        }
        accessService.checkDeptAccess(exam.getDeptId());
        List<SpasExamScore> scores = examScoreMapper.selectScoresByExamId(examId);
        LinkedHashSet<String> subjectOrder = new LinkedHashSet<String>();
        Map<Long, Map<String, Object>> byStudent = new LinkedHashMap<Long, Map<String, Object>>();
        for (SpasExamScore row : scores)
        {
            Long sid = row.getStudentId();
            Map<String, Object> stu = byStudent.get(sid);
            if (stu == null)
            {
                stu = new LinkedHashMap<String, Object>();
                stu.put("studentId", sid);
                stu.put("studentNo", row.getStudentNo());
                stu.put("studentName", row.getStudentName());
                byStudent.put(sid, stu);
            }
            if (SpasExamScore.TYPE_TOTAL.equals(row.getScoreType()))
            {
                stu.put("totalScore", row.getScore());
                stu.put("totalRank", row.getSchoolRank());
            }
            else if (StringUtils.isNotEmpty(row.getSubjectName()))
            {
                String label = row.getSubjectName();
                subjectOrder.add(label);
                stu.put("score_" + label, row.getScore());
                stu.put("rank_" + label, row.getSchoolRank());
            }
        }
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("exam", exam);
        result.put("subjects", new ArrayList<String>(subjectOrder));
        result.put("rows", new ArrayList<Map<String, Object>>(byStudent.values()));
        return result;
    }

    @Override
    public void downloadTemplate(Long deptId, HttpServletResponse response)
    {
        if (deptId == null)
        {
            throw new ServiceException("\u8bf7\u5148\u9009\u62e9\u73ed\u7ea7");
        }
        accessService.checkDeptAccess(deptId);
        try (XSSFWorkbook workbook = new XSSFWorkbook())
        {
            XSSFSheet sheet = workbook.createSheet("exam_scores");
            XSSFRow header = sheet.createRow(0);
            int col = 0;
            header.createCell(col++).setCellValue(COL_NO);
            header.createCell(col++).setCellValue(COL_NAME);
            for (String name : TEMPLATE_SUBJECTS)
            {
                header.createCell(col++).setCellValue(name + SUFFIX_SCORE);
                header.createCell(col++).setCellValue(name + SUFFIX_RANK);
            }
            header.createCell(col++).setCellValue(TOTAL_LABEL + SUFFIX_SCORE);
            header.createCell(col++).setCellValue(TOTAL_LABEL + SUFFIX_RANK);

            SpasStudent query = new SpasStudent();
            query.setDeptId(deptId);
            query.setStatus("0");
            List<SpasStudent> students = studentMapper.selectSpasStudentList(query);
            int rowIdx = 1;
            int limit = Math.min(students == null ? 0 : students.size(), 500);
            for (int i = 0; i < limit; i++)
            {
                SpasStudent st = students.get(i);
                if ("2".equals(st.getDelFlag()))
                {
                    continue;
                }
                XSSFRow row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(st.getStudentNo() == null ? "" : st.getStudentNo());
                row.createCell(1).setCellValue(st.getStudentName() == null ? "" : st.getStudentName());
            }
            for (int i = 0; i < col; i++)
            {
                sheet.autoSizeColumn(i);
            }
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            FileUtils.setAttachmentResponseHeader(response, "exam_score_template.xlsx");
            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("\u6a21\u677f\u4e0b\u8f7d\u5931\u8d25: " + e.getMessage());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SpasExam importScores(String examName, Date examDate, Long deptId, MultipartFile file,
        boolean overwrite, String operName) throws Exception
    {
        return importScores(examName, examDate, deptId, null, file, overwrite, operName);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SpasExam importScores(String examName, Date examDate, Long deptId, Long paperId, MultipartFile file,
        boolean overwrite, String operName) throws Exception
    {
        if (deptId == null)
        {
            throw new ServiceException("\u8bf7\u9009\u62e9\u73ed\u7ea7");
        }
        if (StringUtils.isEmpty(examName))
        {
            throw new ServiceException("\u8bf7\u586b\u5199\u8003\u8bd5\u540d\u79f0");
        }
        if (file == null || file.isEmpty())
        {
            throw new ServiceException("\u8bf7\u4e0a\u4f20Excel\u6587\u4ef6");
        }
        accessService.assertCanWrite();
        accessService.checkDeptAccess(deptId);
        if (paperId != null)
        {
            SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
            if (paper == null)
            {
                throw new ServiceException("\u5173\u8054\u8bd5\u5377\u4e0d\u5b58\u5728");
            }
            if (paper.getDeptId() != null)
            {
                accessService.checkDeptAccess(paper.getDeptId());
            }
        }

        String nameTrim = examName.trim();
        SpasExam existing = examScoreMapper.selectSpasExamByDeptAndName(deptId, nameTrim);
        SpasExam exam;
        if (existing != null)
        {
            if (!overwrite)
            {
                throw new ServiceException("\u540c\u73ed\u5df2\u5b58\u5728\u540c\u540d\u8003\u8bd5\uff0c\u8bf7\u52fe\u9009\u8986\u76d6\u6216\u66f4\u6362\u540d\u79f0");
            }
            exam = existing;
            examScoreMapper.deleteSpasExamScoreByExamId(exam.getExamId());
            exam.setExamDate(examDate);
            exam.setPaperId(paperId);
            exam.setFileName(file.getOriginalFilename());
            exam.setStatus(SpasExam.STATUS_PROCESSING);
            exam.setTotalRows(0);
            exam.setSuccessRows(0);
            exam.setFailRows(0);
            exam.setErrorLog("");
            exam.setUpdateBy(operName);
            exam.setRemark("overwrite");
            examScoreMapper.updateSpasExam(exam);
        }
        else
        {
            exam = new SpasExam();
            exam.setExamName(nameTrim);
            exam.setExamDate(examDate);
            exam.setDeptId(deptId);
            exam.setPaperId(paperId);
            exam.setFileName(file.getOriginalFilename());
            exam.setStatus(SpasExam.STATUS_PROCESSING);
            exam.setTotalRows(0);
            exam.setSuccessRows(0);
            exam.setFailRows(0);
            exam.setCreateBy(operName);
            examScoreMapper.insertSpasExam(exam);
        }

        Map<String, List<SpasStudent>> nameIndex = buildNameIndex(deptId);
        Map<String, List<SpasStudent>> noIndex = buildNoIndex(deptId);

        StringBuilder errors = new StringBuilder();
        int total = 0;
        int success = 0;
        int fail = 0;

        DataFormatter formatter = new DataFormatter();
        try (Workbook workbook = WorkbookFactory.create(file.getInputStream()))
        {
            Sheet sheet = workbook.getSheetAt(0);
            if (sheet == null || sheet.getPhysicalNumberOfRows() < 1)
            {
                throw new ServiceException("Excel\u4e3a\u7a7a");
            }
            HeaderLayout layout = parseHeader(sheet.getRow(0), formatter);

            int last = sheet.getLastRowNum();
            for (int r = 1; r <= last; r++)
            {
                Row row = sheet.getRow(r);
                if (row == null || isBlankRow(row, formatter, layout))
                {
                    continue;
                }
                total++;
                String studentNo = layout.studentNoCol >= 0 ? cellText(row.getCell(layout.studentNoCol), formatter).trim() : "";
                String name = layout.nameCol >= 0 ? cellText(row.getCell(layout.nameCol), formatter).trim() : "";
                SpasStudent student;
                try
                {
                    student = ExamStudentResolver.resolve(studentNo, name, noIndex, nameIndex);
                }
                catch (ServiceException ex)
                {
                    fail++;
                    appendError(errors, r + 1, ex.getMessage());
                    continue;
                }
                try
                {
                    examScoreMapper.deleteSpasExamScoreByExamAndStudent(exam.getExamId(), student.getStudentId());
                    for (SubjectCol sc : layout.subjects)
                    {
                        BigDecimal score = sc.scoreCol >= 0 ? parseScore(cellText(row.getCell(sc.scoreCol), formatter)) : null;
                        Integer rank = sc.rankCol >= 0 ? parseRank(cellText(row.getCell(sc.rankCol), formatter)) : null;
                        if (score == null && rank == null)
                        {
                            continue;
                        }
                        SpasExamScore es = new SpasExamScore();
                        es.setExamId(exam.getExamId());
                        es.setStudentId(student.getStudentId());
                        es.setScoreType(SpasExamScore.TYPE_SUBJECT);
                        es.setSubjectName(sc.label);
                        es.setScore(score);
                        es.setSchoolRank(rank);
                        examScoreMapper.insertSpasExamScore(es);
                    }
                    if (layout.totalScoreCol >= 0 || layout.totalRankCol >= 0)
                    {
                        BigDecimal totalScore = layout.totalScoreCol >= 0
                            ? parseScore(cellText(row.getCell(layout.totalScoreCol), formatter)) : null;
                        Integer totalRank = layout.totalRankCol >= 0
                            ? parseRank(cellText(row.getCell(layout.totalRankCol), formatter)) : null;
                        if (totalScore != null || totalRank != null)
                        {
                            SpasExamScore es = new SpasExamScore();
                            es.setExamId(exam.getExamId());
                            es.setStudentId(student.getStudentId());
                            es.setScoreType(SpasExamScore.TYPE_TOTAL);
                            es.setSubjectName(null);
                            es.setScore(totalScore);
                            es.setSchoolRank(totalRank);
                            examScoreMapper.insertSpasExamScore(es);
                        }
                    }
                    success++;
                }
                catch (Exception ex)
                {
                    fail++;
                    appendError(errors, r + 1, (StringUtils.isEmpty(name) ? studentNo : name) + ": " + ex.getMessage());
                }
            }
        }
        catch (ServiceException e)
        {
            exam.setStatus(SpasExam.STATUS_FAILED);
            exam.setErrorLog(e.getMessage());
            exam.setTotalRows(total);
            exam.setSuccessRows(success);
            exam.setFailRows(fail);
            exam.setUpdateBy(operName);
            examScoreMapper.updateSpasExam(exam);
            throw e;
        }

        exam.setTotalRows(total);
        exam.setSuccessRows(success);
        exam.setFailRows(fail);
        exam.setErrorLog(errors.length() == 0 ? null : errors.toString());
        exam.setStatus(fail > 0 && success == 0 ? SpasExam.STATUS_FAILED : SpasExam.STATUS_DONE);
        exam.setUpdateBy(operName);
        examScoreMapper.updateSpasExam(exam);
        if (success > 0)
        {
            try
            {
                warningEngine.evaluateExamRankRules();
            }
            catch (Exception ex)
            {
                appendError(errors, 0, "校次预警评估失败: " + ex.getMessage());
                exam.setErrorLog(errors.length() == 0 ? null : errors.toString());
                examScoreMapper.updateSpasExam(exam);
            }
        }
        return exam;
    }


    @Override
    public void exportExam(Long examId, HttpServletResponse response)
    {
        Map<String, Object> matrix = selectExamMatrix(examId);
        SpasExam exam = (SpasExam) matrix.get("exam");
        @SuppressWarnings("unchecked")
        List<String> subjects = (List<String>) matrix.get("subjects");
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> rows = (List<Map<String, Object>>) matrix.get("rows");
        if (subjects == null)
        {
            subjects = new ArrayList<String>();
        }
        if (rows == null)
        {
            rows = new ArrayList<Map<String, Object>>();
        }
        try (XSSFWorkbook workbook = new XSSFWorkbook())
        {
            XSSFSheet sheet = workbook.createSheet("exam_scores");
            XSSFRow header = sheet.createRow(0);
            int col = 0;
            header.createCell(col++).setCellValue(COL_NO);
            header.createCell(col++).setCellValue(COL_NAME);
            for (String name : subjects)
            {
                header.createCell(col++).setCellValue(name + SUFFIX_SCORE);
                header.createCell(col++).setCellValue(name + SUFFIX_RANK);
            }
            header.createCell(col++).setCellValue(TOTAL_LABEL + SUFFIX_SCORE);
            header.createCell(col++).setCellValue(TOTAL_LABEL + SUFFIX_RANK);

            int rowIdx = 1;
            for (Map<String, Object> stu : rows)
            {
                XSSFRow row = sheet.createRow(rowIdx++);
                int c = 0;
                Object no = stu.get("studentNo");
                Object sn = stu.get("studentName");
                row.createCell(c++).setCellValue(no == null ? "" : String.valueOf(no));
                row.createCell(c++).setCellValue(sn == null ? "" : String.valueOf(sn));
                for (String name : subjects)
                {
                    Object score = stu.get("score_" + name);
                    Object rank = stu.get("rank_" + name);
                    if (score != null)
                    {
                        row.createCell(c).setCellValue(Double.parseDouble(String.valueOf(score)));
                    }
                    c++;
                    if (rank != null)
                    {
                        row.createCell(c).setCellValue(Integer.parseInt(String.valueOf(rank)));
                    }
                    c++;
                }
                Object totalScore = stu.get("totalScore");
                Object totalRank = stu.get("totalRank");
                if (totalScore != null)
                {
                    row.createCell(c).setCellValue(Double.parseDouble(String.valueOf(totalScore)));
                }
                c++;
                if (totalRank != null)
                {
                    row.createCell(c).setCellValue(Integer.parseInt(String.valueOf(totalRank)));
                }
            }
            for (int i = 0; i < col; i++)
            {
                sheet.autoSizeColumn(i);
            }
            String fileName = "exam_score_" + (exam != null && exam.getExamId() != null ? exam.getExamId() : "export") + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            FileUtils.setAttachmentResponseHeader(response, fileName);
            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("\u5bfc\u51fa\u5931\u8d25: " + e.getMessage());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteSpasExamByIds(Long[] examIds)
    {
        if (examIds == null || examIds.length == 0)
        {
            return 0;
        }
        for (Long id : examIds)
        {
            SpasExam exam = examScoreMapper.selectSpasExamById(id);
            if (exam != null)
            {
                accessService.checkDeptAccess(exam.getDeptId());
            }
        }
        accessService.assertCanWrite();
        examScoreMapper.deleteSpasExamScoreByExamIds(examIds);
        return examScoreMapper.deleteSpasExamByIds(examIds);
    }

    private Map<String, List<SpasStudent>> buildNameIndex(Long deptId)
    {
        SpasStudent query = new SpasStudent();
        query.setDeptId(deptId);
        query.setStatus("0");
        List<SpasStudent> list = studentMapper.selectSpasStudentList(query);
        Map<String, List<SpasStudent>> index = new HashMap<String, List<SpasStudent>>();
        if (list == null)
        {
            return index;
        }
        for (SpasStudent st : list)
        {
            if (st == null || "2".equals(st.getDelFlag()) || StringUtils.isEmpty(st.getStudentName()))
            {
                continue;
            }
            String name = st.getStudentName().trim();
            List<SpasStudent> bucket = index.get(name);
            if (bucket == null)
            {
                bucket = new ArrayList<SpasStudent>();
                index.put(name, bucket);
            }
            bucket.add(st);
        }
        return index;
    }

    private Map<String, List<SpasStudent>> buildNoIndex(Long deptId)
    {
        SpasStudent query = new SpasStudent();
        query.setDeptId(deptId);
        query.setStatus("0");
        List<SpasStudent> list = studentMapper.selectSpasStudentList(query);
        Map<String, List<SpasStudent>> index = new HashMap<String, List<SpasStudent>>();
        if (list == null)
        {
            return index;
        }
        for (SpasStudent st : list)
        {
            if (st == null || "2".equals(st.getDelFlag()) || StringUtils.isEmpty(st.getStudentNo()))
            {
                continue;
            }
            String no = st.getStudentNo().trim();
            List<SpasStudent> bucket = index.get(no);
            if (bucket == null)
            {
                bucket = new ArrayList<SpasStudent>();
                index.put(no, bucket);
            }
            bucket.add(st);
        }
        return index;
    }

    /**
     * Parse Excel header. Subject labels come from column names; not bound to spas_subject.
     */
    private HeaderLayout parseHeader(Row headerRow, DataFormatter formatter)
    {
        if (headerRow == null)
        {
            throw new ServiceException("\u7f3a\u5c11\u8868\u5934");
        }
        HeaderLayout layout = new HeaderLayout();
        layout.studentNoCol = -1;
        layout.nameCol = -1;
        layout.totalScoreCol = -1;
        layout.totalRankCol = -1;
        LinkedHashMap<String, SubjectCol> pending = new LinkedHashMap<String, SubjectCol>();
        short last = headerRow.getLastCellNum();
        for (int c = 0; c < last; c++)
        {
            String h = cellText(headerRow.getCell(c), formatter).trim();
            if (StringUtils.isEmpty(h))
            {
                continue;
            }
            if (COL_NO.equals(h) || "studentNo".equalsIgnoreCase(h) || "student_no".equalsIgnoreCase(h))
            {
                layout.studentNoCol = c;
                continue;
            }
            if (COL_NAME.equals(h) || "name".equalsIgnoreCase(h))
            {
                layout.nameCol = c;
                continue;
            }
            if ((TOTAL_LABEL + SUFFIX_SCORE).equals(h))
            {
                layout.totalScoreCol = c;
                continue;
            }
            if ((TOTAL_LABEL + SUFFIX_RANK).equals(h))
            {
                layout.totalRankCol = c;
                continue;
            }
            if (h.endsWith(SUFFIX_SCORE))
            {
                String subName = h.substring(0, h.length() - SUFFIX_SCORE.length()).trim();
                if (StringUtils.isEmpty(subName) || TOTAL_LABEL.equals(subName))
                {
                    if (TOTAL_LABEL.equals(subName))
                    {
                        layout.totalScoreCol = c;
                    }
                    continue;
                }
                SubjectCol sc = pending.get(subName);
                if (sc == null)
                {
                    sc = new SubjectCol();
                    sc.label = subName;
                    sc.scoreCol = -1;
                    sc.rankCol = -1;
                    pending.put(subName, sc);
                }
                sc.scoreCol = c;
            }
            else if (h.endsWith(SUFFIX_RANK))
            {
                String subName = h.substring(0, h.length() - SUFFIX_RANK.length()).trim();
                if (TOTAL_LABEL.equals(subName))
                {
                    layout.totalRankCol = c;
                    continue;
                }
                if (StringUtils.isEmpty(subName))
                {
                    continue;
                }
                SubjectCol sc = pending.get(subName);
                if (sc == null)
                {
                    sc = new SubjectCol();
                    sc.label = subName;
                    sc.scoreCol = -1;
                    sc.rankCol = -1;
                    pending.put(subName, sc);
                }
                sc.rankCol = c;
            }
        }
        if (layout.nameCol < 0 && layout.studentNoCol < 0)
        {
            throw new ServiceException("表头须包含「姓名」或「学号」列");
        }
        for (SubjectCol sc : pending.values())
        {
            if (sc.scoreCol < 0 && sc.rankCol < 0)
            {
                continue;
            }
            layout.subjects.add(sc);
        }
        if (layout.subjects.isEmpty() && layout.totalScoreCol < 0 && layout.totalRankCol < 0)
        {
            throw new ServiceException("\u672a\u89e3\u6790\u5230\u4efb\u4f55\u5b66\u79d1\u6216\u603b\u5206\u5217");
        }
        return layout;
    }

    private static boolean isBlankRow(Row row, DataFormatter formatter, HeaderLayout layout)
    {
        String no = layout.studentNoCol >= 0 ? cellText(row.getCell(layout.studentNoCol), formatter).trim() : "";
        String name = layout.nameCol >= 0 ? cellText(row.getCell(layout.nameCol), formatter).trim() : "";
        return StringUtils.isEmpty(no) && StringUtils.isEmpty(name);
    }

    private static String cellText(Cell cell, DataFormatter formatter)
    {
        if (cell == null)
        {
            return "";
        }
        return formatter.formatCellValue(cell);
    }

    private static BigDecimal parseScore(String text)
    {
        if (StringUtils.isEmpty(text))
        {
            return null;
        }
        String t = text.trim().replace(",", "");
        if (t.isEmpty() || "-".equals(t))
        {
            return null;
        }
        try
        {
            return new BigDecimal(t);
        }
        catch (Exception e)
        {
            throw new ServiceException("\u5f97\u5206\u683c\u5f0f\u9519\u8bef: " + text);
        }
    }

    private static Integer parseRank(String text)
    {
        if (StringUtils.isEmpty(text))
        {
            return null;
        }
        String t = text.trim().replace(",", "");
        if (t.isEmpty() || "-".equals(t))
        {
            return null;
        }
        try
        {
            return Integer.valueOf(new BigDecimal(t).intValue());
        }
        catch (Exception e)
        {
            throw new ServiceException("\u6821\u6b21\u683c\u5f0f\u9519\u8bef: " + text);
        }
    }

    private static void appendError(StringBuilder sb, int rowNum, String msg)
    {
        if (sb.length() > 0)
        {
            sb.append('\n');
        }
        sb.append("\u7b2c").append(rowNum).append("\u884c: ").append(msg);
    }

    private static class HeaderLayout
    {
        int studentNoCol;
        int nameCol;
        int totalScoreCol;
        int totalRankCol;
        List<SubjectCol> subjects = new ArrayList<SubjectCol>();
    }

    private static class SubjectCol
    {
        String label;
        int scoreCol;
        int rankCol;
    }
}
