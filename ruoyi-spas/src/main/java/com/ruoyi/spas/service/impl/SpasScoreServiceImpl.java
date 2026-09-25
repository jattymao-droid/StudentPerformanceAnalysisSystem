package com.ruoyi.spas.service.impl;

import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.DataScope;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.spas.domain.SpasPaper;
import com.ruoyi.spas.domain.SpasPaperQuestion;
import com.ruoyi.spas.domain.SpasScoreBatch;
import com.ruoyi.spas.domain.SpasScoreDetail;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.analysis.KnowledgeStatCalculator;
import com.ruoyi.spas.mapper.SpasPaperMapper;
import com.ruoyi.spas.mapper.SpasScoreMapper;
import com.ruoyi.spas.mapper.SpasStudentMapper;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.service.ISpasScoreService;
import com.ruoyi.spas.service.ISpasStudentService;
import com.ruoyi.spas.service.ISpasInterveneService;
import com.ruoyi.spas.config.SpasPaperProperties;
import com.ruoyi.spas.support.PaperAnnotationInspector;
import com.ruoyi.spas.support.SpasAccessService;
import com.ruoyi.spas.support.SpasTeacherScopeService;
import com.ruoyi.spas.warning.WarningEngine;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.system.service.ISysDeptService;

/**
 * Score import service implementation
 */
@Service
public class SpasScoreServiceImpl implements ISpasScoreService
{
    @Autowired
    private SpasScoreMapper scoreMapper;

    @Autowired
    private SpasPaperMapper paperMapper;

    @Autowired
    private SpasAnalysisMapper analysisMapper;

    @Autowired
    private SpasStudentMapper studentMapper;

    @Autowired
    private ISpasStudentService studentService;

    @Autowired
    private WarningEngine warningEngine;

    @Autowired
    private KnowledgeStatCalculator knowledgeStatCalculator;

    @Autowired
    private ISpasInterveneService interveneService;

    @Value("${spas.intervene.auto-evaluate-after-recalc:true}")
    private boolean autoEvaluateIntervene;

    @Value("${spas.intervene.async-evaluate:true}")
    private boolean asyncEvaluateIntervene;

    @Autowired
    private SpasTeacherScopeService teacherScopeService;

    @Autowired
    private SpasPaperProperties paperProperties;

    @Autowired
    private SpasAccessService accessService;

    @Autowired
    private ISysDeptService deptService;

    @Value("${spas.score.blank-as-zero:true}")
    private boolean blankAsZero;

    @Value("${spas.score.rate-scale:6}")
    private int rateScale;

    @Override
    public List<SpasScoreBatch> selectSpasScoreBatchList(SpasScoreBatch batch)
    {
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(batch);
            return scoreMapper.selectSpasScoreBatchList(batch);
        }
        return SpringUtils.getAopProxy(this).selectSpasScoreBatchListScoped(batch);
    }

    @DataScope(deptAlias = "d")
    public List<SpasScoreBatch> selectSpasScoreBatchListScoped(SpasScoreBatch batch)
    {
        return scoreMapper.selectSpasScoreBatchList(batch);
    }

    @Override
    public List<SpasScoreDetail> selectSpasScoreDetailList(SpasScoreDetail detail)
    {
        if (teacherScopeService.useTeacherDeptFilter())
        {
            teacherScopeService.applyTeacherDeptFilter(detail);
            return scoreMapper.selectSpasScoreDetailList(detail);
        }
        return SpringUtils.getAopProxy(this).selectSpasScoreDetailListScoped(detail);
    }

    @DataScope(deptAlias = "d")
    public List<SpasScoreDetail> selectSpasScoreDetailListScoped(SpasScoreDetail detail)
    {
        return scoreMapper.selectSpasScoreDetailList(detail);
    }

    @Override
    public SpasScoreDetail selectSpasScoreDetailById(Long detailId)
    {
        SpasScoreDetail detail = scoreMapper.selectSpasScoreDetailById(detailId);
        if (detail == null)
        {
            return null;
        }
        SpasPaper paper = paperMapper.selectSpasPaperById(detail.getPaperId());
        if (paper != null)
        {
            accessService.checkDeptAccess(paper.getDeptId());
        }
        return detail;
    }

    @Override
    @Transactional
    public int insertSpasScoreDetail(SpasScoreDetail detail)
    {
        accessService.assertCanWrite();
        if (detail == null || detail.getPaperId() == null)
        {
            throw new ServiceException("试卷不能为空");
        }
        if (detail.getScore() == null)
        {
            throw new ServiceException("得分不能为空");
        }
        SpasPaper paper = paperMapper.selectSpasPaperById(detail.getPaperId());
        if (paper == null)
        {
            throw new ServiceException("试卷不存在");
        }
        accessService.checkDeptAccess(paper.getDeptId());

        SpasStudent student = resolveStudent(detail, paper);
        SpasPaperQuestion question = resolveQuestion(detail);
        BigDecimal score = detail.getScore();
        BigDecimal fullScore = question.getFullScore();
        if (score.compareTo(BigDecimal.ZERO) < 0 || score.compareTo(fullScore) > 0)
        {
            throw new ServiceException("得分须在 0～" + fullScore + " 之间");
        }
        int scale = rateScale > 0 ? rateScale : 6;
        BigDecimal rate = BigDecimal.ZERO;
        if (fullScore.compareTo(BigDecimal.ZERO) > 0)
        {
            rate = score.divide(fullScore, scale, RoundingMode.HALF_UP);
        }
        SpasScoreDetail row = new SpasScoreDetail();
        row.setPaperId(detail.getPaperId());
        row.setQuestionId(question.getQuestionId());
        row.setStudentId(student.getStudentId());
        row.setBatchId(null);
        row.setScore(score);
        row.setFullScore(fullScore);
        row.setRate(rate);
        row.setScoreSource(StringUtils.isNotEmpty(detail.getScoreSource()) ? detail.getScoreSource() : "1");
        int rows = scoreMapper.upsertSpasScoreDetail(row);
        afterScoreWrite(detail.getPaperId(), student.getStudentId());
        return rows > 0 ? rows : 1;
    }

    @Override
    @Transactional
    public int updateSpasScoreDetail(SpasScoreDetail detail)
    {
        accessService.assertCanWrite();
        if (detail == null || detail.getDetailId() == null)
        {
            throw new ServiceException("明细不存在");
        }
        SpasScoreDetail exist = scoreMapper.selectSpasScoreDetailById(detail.getDetailId());
        if (exist == null)
        {
            throw new ServiceException("明细不存在");
        }
        SpasPaper paper = paperMapper.selectSpasPaperById(exist.getPaperId());
        if (paper == null)
        {
            throw new ServiceException("试卷不存在");
        }
        accessService.checkDeptAccess(paper.getDeptId());
        if (detail.getScore() == null)
        {
            throw new ServiceException("得分不能为空");
        }
        BigDecimal fullScore = exist.getFullScore();
        if (fullScore == null)
        {
            throw new ServiceException("满分缺失，无法修改");
        }
        BigDecimal score = detail.getScore();
        if (score.compareTo(BigDecimal.ZERO) < 0 || score.compareTo(fullScore) > 0)
        {
            throw new ServiceException("得分须在 0～" + fullScore + " 之间");
        }
        int scale = rateScale > 0 ? rateScale : 6;
        BigDecimal rate = BigDecimal.ZERO;
        if (fullScore.compareTo(BigDecimal.ZERO) > 0)
        {
            rate = score.divide(fullScore, scale, RoundingMode.HALF_UP);
        }
        exist.setScore(score);
        exist.setRate(rate);
        exist.setScoreSource("1");
        int rows = scoreMapper.updateSpasScoreDetail(exist);
        afterScoreWrite(exist.getPaperId(), exist.getStudentId());
        return rows;
    }

    @Override
    @Transactional
    public int deleteSpasScoreDetailByIds(Long[] detailIds)
    {
        accessService.assertCanWrite();
        if (detailIds == null || detailIds.length == 0)
        {
            return 0;
        }
        Long paperId = null;
        Set<Long> studentIds = new HashSet<Long>();
        for (Long detailId : detailIds)
        {
            SpasScoreDetail exist = scoreMapper.selectSpasScoreDetailById(detailId);
            if (exist == null)
            {
                continue;
            }
            SpasPaper paper = paperMapper.selectSpasPaperById(exist.getPaperId());
            if (paper != null)
            {
                accessService.checkDeptAccess(paper.getDeptId());
            }
            paperId = exist.getPaperId();
            if (exist.getStudentId() != null)
            {
                studentIds.add(exist.getStudentId());
            }
        }
        int rows = scoreMapper.deleteSpasScoreDetailByIds(detailIds);
        if (rows > 0 && paperId != null)
        {
            knowledgeStatCalculator.recalculateByPaper(paperId);
            warningEngine.evaluateAfterPaper(paperId);
            if (autoEvaluateIntervene && !studentIds.isEmpty())
            {
                List<Long> sids = new java.util.ArrayList<Long>(studentIds);
                if (asyncEvaluateIntervene)
                {
                    interveneService.evaluateOpenForStudentsAsync(sids);
                }
                else
                {
                    interveneService.evaluateOpenForStudents(sids);
                }
            }
        }
        return rows;
    }

    private SpasStudent resolveStudent(SpasScoreDetail detail, SpasPaper paper)
    {
        SpasStudent student = null;
        if (detail.getStudentId() != null)
        {
            student = studentMapper.selectSpasStudentById(detail.getStudentId());
        }
        else if (StringUtils.isNotEmpty(detail.getStudentNo()))
        {
            student = studentMapper.selectSpasStudentByStudentNo(detail.getStudentNo().trim());
        }
        if (student == null)
        {
            throw new ServiceException("学生不存在");
        }
        if (!isStudentUnderPaperDept(paper.getDeptId(), student.getDeptId()))
        {
            throw new ServiceException("学生班级与试卷所属班级不一致：" + student.getStudentNo());
        }
        return student;
    }

    private SpasPaperQuestion resolveQuestion(SpasScoreDetail detail)
    {
        List<SpasPaperQuestion> questions = paperMapper.selectQuestionsByPaperId(detail.getPaperId());
        if (questions == null || questions.isEmpty())
        {
            throw new ServiceException("试卷尚未维护题目");
        }
        if (detail.getQuestionId() != null)
        {
            for (SpasPaperQuestion q : questions)
            {
                if (detail.getQuestionId().equals(q.getQuestionId()))
                {
                    return q;
                }
            }
            throw new ServiceException("题目不在该试卷中");
        }
        if (StringUtils.isEmpty(detail.getQuestionNo()))
        {
            throw new ServiceException("题号不能为空");
        }
        String qno = detail.getQuestionNo().trim();
        for (SpasPaperQuestion q : questions)
        {
            if (qno.equals(q.getQuestionNo()))
            {
                return q;
            }
        }
        throw new ServiceException("题号不存在：" + qno);
    }

    private void afterScoreWrite(Long paperId, Long studentId)
    {
        knowledgeStatCalculator.recalculateByPaper(paperId);
        warningEngine.evaluateAfterPaper(paperId);
        if (autoEvaluateIntervene && studentId != null)
        {
            List<Long> sids = java.util.Collections.singletonList(studentId);
            if (asyncEvaluateIntervene)
            {
                interveneService.evaluateOpenForStudentsAsync(sids);
            }
            else
            {
                interveneService.evaluateOpenForStudents(sids);
            }
        }
    }

    @Override
    public void downloadTemplate(Long paperId, HttpServletResponse response)
    {
        SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
        if (paper == null)
        {
            throw new ServiceException("试卷不存在");
        }
        accessService.checkDeptAccess(paper.getDeptId());
        List<SpasPaperQuestion> questions = paperMapper.selectQuestionsByPaperId(paperId);
        try (XSSFWorkbook workbook = new XSSFWorkbook())
        {
            XSSFSheet sheet = workbook.createSheet("scores");
            XSSFRow header = sheet.createRow(0);
            header.createCell(0).setCellValue("\u5b66\u53f7");
            header.createCell(1).setCellValue("\u59d3\u540d");
            int col = 2;
            for (SpasPaperQuestion q : questions)
            {
                header.createCell(col++).setCellValue(q.getQuestionNo());
            }
            // Prefill class students when paper has dept
            if (paper.getDeptId() != null)
            {
                SpasStudent query = new SpasStudent();
                query.setDeptId(paper.getDeptId());
                query.setStatus("0");
                List<SpasStudent> students = studentService.selectSpasStudentList(query);
                int rowIdx = 1;
                int maxRows = 500;
                for (SpasStudent st : students)
                {
                    if (rowIdx > maxRows)
                    {
                        break;
                    }
                    XSSFRow dataRow = sheet.createRow(rowIdx++);
                    dataRow.createCell(0).setCellValue(st.getStudentNo());
                    dataRow.createCell(1).setCellValue(st.getStudentName());
                }
            }
            String fileName = "score_template_" + paperId + ".xlsx";
            FileUtils.setAttachmentResponseHeader(response, fileName);
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            workbook.write(response.getOutputStream());
        }
        catch (Exception e)
        {
            throw new ServiceException("下载模板失败：" + e.getMessage());
        }
    }

    @Override
    @Transactional
    public SpasScoreBatch importScores(Long paperId, MultipartFile file, String operName)
    {
        accessService.assertCanWrite();
        SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
        if (paper == null)
        {
            throw new ServiceException("试卷不存在");
        }
        accessService.checkDeptAccess(paper.getDeptId());
        List<SpasPaperQuestion> questions = paperMapper.selectQuestionsByPaperId(paperId);
        if (questions == null || questions.isEmpty())
        {
            throw new ServiceException("试卷尚未维护题目");
        }
        PaperAnnotationInspector.assertReady(questions, paperMapper.selectKnowledgeByPaperId(paperId),
            paperProperties.isRequireQuestionType(), paperProperties.isRequireBloomLevel());
        Map<String, SpasPaperQuestion> questionMap = new HashMap<String, SpasPaperQuestion>();
        for (SpasPaperQuestion q : questions)
        {
            questionMap.put(q.getQuestionNo(), q);
        }

        SpasScoreBatch batch = new SpasScoreBatch();
        batch.setPaperId(paperId);
        batch.setFileName(file.getOriginalFilename());
        batch.setStatus("0");
        batch.setCreateBy(operName);
        batch.setTotalRows(0);
        batch.setSuccessRows(0);
        batch.setFailRows(0);
        scoreMapper.insertSpasScoreBatch(batch);

        int totalRows = 0;
        int successRows = 0;
        int failRows = 0;
        StringBuilder errorLog = new StringBuilder();
        DataFormatter formatter = new DataFormatter();

        try (InputStream is = file.getInputStream(); Workbook workbook = new XSSFWorkbook(is))
        {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rows = sheet.iterator();
            if (!rows.hasNext())
            {
                throw new ServiceException("Excel 内容为空");
            }
            Row headerRow = rows.next();
            Map<Integer, SpasPaperQuestion> colQuestionMap = new HashMap<Integer, SpasPaperQuestion>();
            int studentNoCol = -1;
            int studentNameCol = -1;
            for (Cell cell : headerRow)
            {
                String header = formatter.formatCellValue(cell).trim();
                int idx = cell.getColumnIndex();
                if (isStudentNoHeader(header))
                {
                    studentNoCol = idx;
                }
                else if (isStudentNameHeader(header))
                {
                    studentNameCol = idx;
                }
                else if (questionMap.containsKey(header))
                {
                    colQuestionMap.put(idx, questionMap.get(header));
                }
            }
            if (studentNoCol < 0)
            {
                throw new ServiceException("缺少学号列（学号/studentNo）");
            }
            if (colQuestionMap.isEmpty())
            {
                throw new ServiceException("表头题号与试卷题目不匹配");
            }

            while (rows.hasNext())
            {
                Row row = rows.next();
                if (isRowEmpty(row, formatter))
                {
                    continue;
                }
                totalRows++;
                int rowNum = row.getRowNum() + 1;
                try
                {
                    String studentNo = formatter.formatCellValue(row.getCell(studentNoCol)).trim();
                    if (StringUtils.isEmpty(studentNo))
                    {
                        throw new ServiceException("学号为空");
                    }
                    if (isIgnorableStudentNo(studentNo))
                    {
                        totalRows--;
                        continue;
                    }
                    SpasStudent student = studentMapper.selectSpasStudentByStudentNo(studentNo);
                    if (student == null)
                    {
                        throw new ServiceException("找不到学生：" + studentNo);
                    }
                    accessService.checkStudentAccess(student.getStudentId());
                    if (!isStudentUnderPaperDept(paper.getDeptId(), student.getDeptId()))
                    {
                        throw new ServiceException("学生班级与试卷所属班级不一致：" + studentNo);
                    }
                    if (studentNameCol >= 0)
                    {
                        String nameInFile = formatter.formatCellValue(row.getCell(studentNameCol)).trim();
                        if (StringUtils.isNotEmpty(nameInFile) && StringUtils.isNotEmpty(student.getStudentName())
                            && !nameInFile.equals(student.getStudentName()))
                        {
                            throw new ServiceException("学号与姓名不匹配：" + studentNo);
                        }
                    }
                    for (Map.Entry<Integer, SpasPaperQuestion> entry : colQuestionMap.entrySet())
                    {
                        String scoreText = formatter.formatCellValue(row.getCell(entry.getKey())).trim();
                        SpasPaperQuestion question = entry.getValue();
                        com.ruoyi.spas.support.SpasScoreCellParser.Result parsed;
                        try
                        {
                            parsed = com.ruoyi.spas.support.SpasScoreCellParser.parse(scoreText, blankAsZero);
                        }
                        catch (IllegalArgumentException ex)
                        {
                            throw new ServiceException("题目得分非法 Q" + question.getQuestionNo() + ": " + scoreText);
                        }
                        if (parsed == null)
                        {
                            continue;
                        }
                        BigDecimal score = parsed.getScore();
                        String scoreSource = parsed.getScoreSource();
                        if (score.compareTo(BigDecimal.ZERO) < 0 || score.compareTo(question.getFullScore()) > 0)
                        {
                            throw new ServiceException("题目得分超出满分 Q" + question.getQuestionNo()
                                + ": " + score + " (0.." + question.getFullScore() + ")");
                        }
                        int scale = rateScale > 0 ? rateScale : 6;
                        BigDecimal rate = BigDecimal.ZERO;
                        if (question.getFullScore().compareTo(BigDecimal.ZERO) > 0)
                        {
                            rate = score.divide(question.getFullScore(), scale, RoundingMode.HALF_UP);
                        }
                        SpasScoreDetail detail = new SpasScoreDetail();
                        detail.setPaperId(paperId);
                        detail.setQuestionId(question.getQuestionId());
                        detail.setStudentId(student.getStudentId());
                        detail.setBatchId(batch.getBatchId());
                        detail.setScore(score);
                        detail.setFullScore(question.getFullScore());
                        detail.setRate(rate);
                        detail.setScoreSource(scoreSource);
                        scoreMapper.upsertSpasScoreDetail(detail);
                    }
                    successRows++;
                }
                catch (Exception e)
                {
                    failRows++;
                    errorLog.append("Row ").append(rowNum).append(": ").append(e.getMessage()).append("\n");
                }
            }
        }
        catch (ServiceException e)
        {
            batch.setStatus("2");
            batch.setErrorLog(e.getMessage());
            batch.setTotalRows(totalRows);
            batch.setSuccessRows(successRows);
            batch.setFailRows(failRows);
            scoreMapper.updateSpasScoreBatch(batch);
            throw e;
        }
        catch (Exception e)
        {
            batch.setStatus("2");
            batch.setErrorLog("Parse failed: " + e.getMessage());
            scoreMapper.updateSpasScoreBatch(batch);
            throw new ServiceException("导入失败：" + e.getMessage());
        }

        batch.setTotalRows(totalRows);
        batch.setSuccessRows(successRows);
        batch.setFailRows(failRows);
        batch.setStatus(failRows > 0 && successRows == 0 ? "2" : "1");
        batch.setErrorLog(errorLog.length() > 0 ? errorLog.toString() : null);
        scoreMapper.updateSpasScoreBatch(batch);
        if (successRows > 0)
        {
            knowledgeStatCalculator.recalculateByPaper(paperId);
            warningEngine.evaluateAfterPaper(paperId);
            if (autoEvaluateIntervene)
            {
                List<Long> sids = analysisMapper.selectStudentIdsByPaperId(paperId);
                if (asyncEvaluateIntervene)
                {
                    interveneService.evaluateOpenForStudentsAsync(sids);
                }
                else
                {
                    interveneService.evaluateOpenForStudents(sids);
                }
            }
        }
        return batch;
    }

    @Override
    public void exportScoreDetail(SpasScoreDetail detail, HttpServletResponse response)
    {
        List<SpasScoreDetail> list = selectSpasScoreDetailList(detail);
        ExcelUtil<SpasScoreDetail> util = new ExcelUtil<SpasScoreDetail>(SpasScoreDetail.class);
        util.exportExcel(response, list, "score_detail");
    }

    @Override
    @Transactional
    public int revokeBatch(Long batchId)
    {
        accessService.assertCanWrite();
        SpasScoreBatch batch = scoreMapper.selectSpasScoreBatchById(batchId);
        if (batch == null)
        {
            throw new ServiceException("导入批次不存在");
        }
        Long paperId = batch.getPaperId();
        if (paperId != null)
        {
            SpasPaper paper = paperMapper.selectSpasPaperById(paperId);
            if (paper == null)
            {
                throw new ServiceException("试卷不存在");
            }
            accessService.checkDeptAccess(paper.getDeptId());
        }
        List<Long> studentIds = scoreMapper.selectStudentIdsByBatchId(batchId);
        // Restore scores overwritten by this batch, then delete first-time rows of this batch
        scoreMapper.restoreDetailFromPrevByBatchId(batchId);
        scoreMapper.deleteDetailByBatchId(batchId);
        scoreMapper.deleteBatchById(batchId);
        if (paperId != null)
        {
            knowledgeStatCalculator.recalculateByPaper(paperId);
            warningEngine.evaluateAfterPaper(paperId);
        }
        else if (studentIds != null)
        {
            Set<Long> unique = new HashSet<>(studentIds);
            for (Long studentId : unique)
            {
                knowledgeStatCalculator.recalculateByStudent(studentId);
            }
        }
        if (autoEvaluateIntervene && studentIds != null && !studentIds.isEmpty())
        {
            if (asyncEvaluateIntervene)
            {
                interveneService.evaluateOpenForStudentsAsync(studentIds);
            }
            else
            {
                interveneService.evaluateOpenForStudents(studentIds);
            }
        }
        return 1;
    }

    private boolean isStudentNoHeader(String header)
    {
        return "studentNo".equalsIgnoreCase(header) || "\u5b66\u53f7".equals(header);
    }

    private boolean isStudentNameHeader(String header)
    {
        return "studentName".equalsIgnoreCase(header) || "\u59d3\u540d".equals(header);
    }

    /**
     * Paper may hang on grade/school; students hang on class. Allow exact match
     * or student dept under paper dept (ancestors contains paperDeptId).
     */
    private boolean isStudentUnderPaperDept(Long paperDeptId, Long studentDeptId)
    {
        if (paperDeptId == null || studentDeptId == null)
        {
            return true;
        }
        if (paperDeptId.equals(studentDeptId))
        {
            return true;
        }
        SysDept studentDept = deptService.selectDeptById(studentDeptId);
        if (studentDept == null || StringUtils.isEmpty(studentDept.getAncestors()))
        {
            return false;
        }
        String paperIdText = String.valueOf(paperDeptId);
        for (String part : studentDept.getAncestors().split(","))
        {
            if (paperIdText.equals(part.trim()))
            {
                return true;
            }
        }
        return false;
    }

    private boolean isIgnorableStudentNo(String studentNo)
    {
        if (StringUtils.isEmpty(studentNo))
        {
            return false;
        }
        String v = studentNo.trim();
        return "-".equals(v) || "—".equals(v) || "–".equals(v)
            || "合计".equals(v) || "小计".equals(v) || "平均".equals(v);
    }

    private boolean isRowEmpty(Row row, DataFormatter formatter)
    {
        if (row == null)
        {
            return true;
        }
        for (Cell cell : row)
        {
            if (StringUtils.isNotEmpty(formatter.formatCellValue(cell).trim()))
            {
                return false;
            }
        }
        return true;
    }
}
