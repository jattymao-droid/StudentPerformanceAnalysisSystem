<template>
  <div class="app-container spas-exam-score">
    <el-alert
      class="mb8"
      type="info"
      :closable="false"
      show-icon
      title="导入各科实考得分与校次。优先按「学号」匹配所选班级学生；学号为空时才按姓名，同班重名必须填学号。模板已含学号、姓名及语文/数学/英语/物理/化学/生物学、总分列。选择考试后会关联试卷，但校次不写入小题成绩。同班同名考试默认可覆盖。"
    />
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="班级" prop="deptId" class="class-row">
        <template v-if="boundClassMode">
          <div class="bound-class-wrap">
            <span class="bound-class-name">{{ currentDeptName || '未绑定班级' }}</span>
            <el-tag v-if="boundClassRoleLabel" size="mini" type="info">{{ boundClassRoleLabel }}</el-tag>
            <el-button-group v-if="myDepts.length > 1">
              <el-button
                v-for="d in myDepts"
                :key="d.deptId"
                size="mini"
                :type="queryParams.deptId === d.deptId ? 'primary' : 'default'"
                @click="selectMyDept(d.deptId)"
              >{{ d.deptName }}{{ d.primary ? '·主' : '' }}</el-button>
            </el-button-group>
          </div>
        </template>
        <treeselect
          v-else
          v-model="queryParams.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="筛选班级"
          style="width: 220px"
        />
      </el-form-item>
      <el-form-item label="考试" prop="examName">
        <el-input v-model="queryParams.examName" placeholder="考试名称" clearable style="width: 180px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="openImport" v-hasPermi="['spas:examScore:import']">下载模板 / 导入</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-download" size="mini" :disabled="ids.length !== 1" @click="handleExport" v-hasPermi="['spas:examScore:export']">导出明细</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="!ids.length" @click="handleDelete" v-hasPermi="['spas:examScore:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="examList" @selection-change="handleSelectionChange" @row-click="openMatrix">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="考试" prop="examName" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="考试日期" prop="examDate" width="120" align="center" />
      <el-table-column label="班级" prop="deptName" min-width="120" :show-overflow-tooltip="true" />
      <el-table-column label="成功/失败" width="110" align="center">
        <template slot-scope="scope">{{ scope.row.successRows || 0 }} / {{ scope.row.failRows || 0 }}</template>
      </el-table-column>
      <el-table-column label="状态" width="90" align="center">
        <template slot-scope="scope">
          <el-tag size="mini" :type="statusType(scope.row.status)">{{ statusText(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="文件" prop="fileName" min-width="140" :show-overflow-tooltip="true" />
      <el-table-column label="导入时间" prop="createTime" width="160" align="center" />
      <el-table-column label="操作" width="180" align="center">
        <template slot-scope="scope">
          <el-button type="text" size="mini" @click.stop="openMatrix(scope.row)">明细</el-button>
          <el-button type="text" size="mini" @click.stop="handleExportRow(scope.row)" v-hasPermi="['spas:examScore:export']">导出</el-button>
          <el-button v-if="scope.row.errorLog" type="text" size="mini" @click.stop="showError(scope.row)">错误</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-empty
      v-if="!loading && examList.length === 0"
      description="暂无实考校次数据。请先选择班级，下载模板填写后导入。"
    >
      <el-button type="primary" size="small" @click="openImport" v-hasPermi="['spas:examScore:import']">去导入</el-button>
    </el-empty>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="导入实考校次" :visible.sync="importOpen" width="500px" append-to-body>
      <el-form label-width="100px" size="small">
        <el-form-item label="班级" required>
          <template v-if="boundClassMode">
            <div class="bound-class-wrap">
              <span class="bound-class-name">{{ importDeptName || '未绑定班级' }}</span>
              <el-button-group v-if="myDepts.length > 1">
                <el-button
                  v-for="d in myDepts"
                  :key="'imp-' + d.deptId"
                  size="mini"
                  :type="importForm.deptId === d.deptId ? 'primary' : 'default'"
                  @click="importForm.deptId = d.deptId"
                >{{ d.deptName }}{{ d.primary ? '·主' : '' }}</el-button>
              </el-button-group>
            </div>
          </template>
          <treeselect v-else v-model="importForm.deptId" :options="deptOptions" placeholder="匹配学生的班级" style="width: 280px" />
        </el-form-item>
        <el-form-item label="考试名称" required>
          <el-select
            v-model="importForm.paperId"
            filterable
            clearable
            placeholder="从作业考试中选择考试"
            style="width: 100%"
            @change="onPaperChange"
          >
            <el-option
              v-for="item in paperOptionsFiltered"
              :key="item.paperId"
              :label="paperLabel(item)"
              :value="item.paperId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="考试日期">
          <el-date-picker v-model="importForm.examDate" type="date" value-format="yyyy-MM-dd" placeholder="选择考试后自动带出" style="width: 100%" />
        </el-form-item>
        <el-form-item label="覆盖同名">
          <el-switch v-model="importForm.overwrite" active-text="开" inactive-text="关" />
          <span style="margin-left: 8px; color: #909399; font-size: 12px">同班同名考试将整批覆盖</span>
        </el-form-item>
        <el-form-item label="文件" required>
          <el-upload
            ref="upload"
            :limit="1"
            accept=".xlsx,.xls"
            :auto-upload="false"
            :on-change="onFileChange"
            :on-remove="() => { importForm.file = null }"
            action="#"
          >
            <el-button size="mini" type="primary" plain>选择 Excel</el-button>
            <div slot="tip" class="el-upload__tip">表头须含「学号」或「姓名」。有学号时忽略姓名。科目列为「科目名得分 / 科目名校次」。</div>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button size="small" :disabled="!importForm.deptId" @click="downloadTemplate" v-hasPermi="['spas:examScore:import']">下载模板</el-button>
        <el-button type="primary" size="small" :loading="importing" @click="submitImport">导入</el-button>
        <el-button size="small" @click="importOpen = false">取消</el-button>
      </div>
    </el-dialog>

    <el-drawer title="实考得分与校次" :visible.sync="matrixOpen" size="80%" append-to-body>
      <div v-loading="matrixLoading" style="padding: 0 16px 16px">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px">
          <p v-if="matrixExam" style="margin: 0; color: #64748b">
            {{ matrixExam.examName }} · {{ matrixExam.deptName || '' }} · {{ matrixExam.examDate || '' }}
          </p>
          <el-button size="mini" type="success" plain icon="el-icon-download" :disabled="!matrixExam" @click="handleExportRow(matrixExam)" v-hasPermi="['spas:examScore:export']">导出 Excel</el-button>
        </div>
        <el-table :data="matrixRows" size="small" max-height="560" empty-text="暂无数据">
          <el-table-column label="学号" prop="studentNo" width="110" fixed />
          <el-table-column label="姓名" prop="studentName" width="90" fixed />
          <el-table-column v-for="sub in matrixSubjects" :key="sub" :label="sub" align="center">
            <el-table-column label="得分" width="80" align="center">
              <template slot-scope="scope">{{ formatScore(scope.row['score_' + sub]) }}</template>
            </el-table-column>
            <el-table-column label="校次" width="70" align="center">
              <template slot-scope="scope">{{ formatRank(scope.row['rank_' + sub]) }}</template>
            </el-table-column>
          </el-table-column>
          <el-table-column label="总分" align="center">
            <el-table-column label="得分" width="80" align="center">
              <template slot-scope="scope">{{ formatScore(scope.row.totalScore) }}</template>
            </el-table-column>
            <el-table-column label="校次" width="70" align="center">
              <template slot-scope="scope">{{ formatRank(scope.row.totalRank) }}</template>
            </el-table-column>
          </el-table-column>
        </el-table>
      </div>
    </el-drawer>

    <el-dialog title="导入错误" :visible.sync="errorOpen" width="640px" append-to-body>
      <pre style="white-space: pre-wrap; max-height: 420px; overflow: auto; margin: 0; font-size: 12px">{{ errorText }}</pre>
    </el-dialog>
  </div>
</template>

<script>
import { listExamScore, getExamScoreMatrix, importExamScore, delExamScore } from '@/api/spas/examScore'
import { listPaper } from '@/api/spas/paper'
import { deptTreeSelect } from '@/api/system/user'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { boundClassRoleFromDepts } from '@/utils/spasTeacherRole'
import { applyTeachingDeptContext, canLoadSystemDeptTree } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  name: 'SpasExamScore',
  components: { Treeselect },
  data() {
    return {
      showSearch: true,
      loading: false,
      examList: [],
      total: 0,
      ids: [],
      deptOptions: [],
      myDepts: [],
      paperOptions: [],
      queryParams: { pageNum: 1, pageSize: 10, examName: undefined, deptId: undefined },
      importOpen: false,
      importing: false,
      importForm: { deptId: undefined, paperId: undefined, examName: '', examDate: '', file: null, overwrite: true },
      matrixOpen: false,
      matrixLoading: false,
      matrixExam: null,
      matrixSubjects: [],
      matrixRows: [],
      errorOpen: false,
      errorText: ''
    }
  },
  computed: {
    boundClassMode() {
      return Array.isArray(this.myDepts) && this.myDepts.length > 0
    },
    preferredDeptId() {
      if (!this.myDepts.length) return undefined
      const primary = this.myDepts.find(d => d.primary)
      return (primary || this.myDepts[0]).deptId
    },
    currentDeptName() {
      return this.deptLabel(this.queryParams.deptId)
    },
    importDeptName() {
      return this.deptLabel(this.importForm.deptId)
    },
    boundClassRoleLabel() {
      return boundClassRoleFromDepts(this.myDepts, this.queryParams.deptId)
    },
    paperOptionsFiltered() {
      const list = this.paperOptions || []
      const deptId = this.importForm.deptId
      if (!deptId) return list
      const matched = list.filter(p => !p.deptId || String(p.deptId) === String(deptId))
      return matched.length ? matched : list
    }
  },
  created() {
    this.loadPapers()
    this.loadMyDepts().then(() => {
      if (!this.queryParams.deptId && this.preferredDeptId) {
        this.queryParams.deptId = this.preferredDeptId
      }
      this.getList()
    })
  },
  methods: {
    loadDepts() {
      if (!canLoadSystemDeptTree()) {
        this.deptOptions = []
        return Promise.resolve()
      }
      return deptTreeSelect().then(res => {
        this.deptOptions = res.data || []
      }).catch(() => {
        this.deptOptions = []
      })
    },
    loadMyDepts() {
      return applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).catch(() => {
        this.myDepts = []
      })
    },
    findDeptNode(nodes, id) {
      for (const n of nodes || []) {
        if (n.id === id || n.deptId === id) return n
        const c = this.findDeptNode(n.children, id)
        if (c) return c
      }
      return null
    },
    deptLabel(id) {
      if (!id) return ''
      const mine = (this.myDepts || []).find(d => d.deptId === id)
      if (mine && mine.deptName) return mine.deptName
      const node = this.findDeptNode(this.deptOptions, id)
      return node ? (node.label || node.deptName || '') : ''
    },
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      this.handleQuery()
    },
    loadPapers() {
      listPaper({ pageNum: 1, pageSize: 500, paperType: '1' }).then(res => {
        const rows = res.rows || []
        if (rows.length) {
          this.paperOptions = rows
          return
        }
        return listPaper({ pageNum: 1, pageSize: 500 }).then(r => {
          this.paperOptions = r.rows || []
        })
      })
    },
    paperLabel(item) {
      if (!item) return ''
      const date = item.examDate ? String(item.examDate).slice(0, 10) : ''
      return date ? (item.paperName + ' · ' + date) : item.paperName
    },
    onPaperChange(paperId) {
      const paper = (this.paperOptions || []).find(p => p.paperId === paperId)
      if (!paper) {
        this.importForm.examName = ''
        return
      }
      this.importForm.examName = paper.paperName
      if (paper.examDate) {
        this.importForm.examDate = String(paper.examDate).slice(0, 10)
      }
      if (paper.deptId && !this.importForm.deptId) {
        this.importForm.deptId = paper.deptId
      }
    },
    getList() {
      this.loading = true
      listExamScore(this.queryParams).then(res => {
        this.examList = res.rows || []
        this.total = res.total || 0
      }).finally(() => {
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.queryParams.deptId = this.boundClassMode ? this.preferredDeptId : undefined
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.examId)
    },
    statusText(s) {
      if (s === '1') return '完成'
      if (s === '2') return '失败'
      return '处理中'
    },
    statusType(s) {
      if (s === '1') return 'success'
      if (s === '2') return 'danger'
      return 'info'
    },
    openImport() {
      this.importForm = {
        deptId: this.queryParams.deptId || this.preferredDeptId,
        paperId: undefined,
        paperId: undefined,
        examName: '',
        examDate: '',
        file: null,
        overwrite: true
      }
      this.loadPapers()
      this.importOpen = true
      this.$nextTick(() => {
        if (this.$refs.upload) this.$refs.upload.clearFiles()
      })
    },
    onFileChange(file) {
      this.importForm.file = file.raw
    },
    downloadTemplate() {
      if (!this.importForm.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      this.download('spas/examScore/template', { deptId: this.importForm.deptId }, 'exam_score_template.xlsx')
    },
    submitImport() {
      if (!this.importForm.deptId) {
        this.$modal.msgWarning('请选择班级')
        return
      }
      if (!this.importForm.paperId || !this.importForm.examName) {
        this.$modal.msgWarning('请从作业考试中选择考试')
        return
      }
      if (!this.importForm.file) {
        this.$modal.msgWarning('请选择 Excel')
        return
      }
      const fd = new FormData()
      fd.append('examName', this.importForm.examName)
      fd.append('deptId', this.importForm.deptId)
      fd.append('overwrite', this.importForm.overwrite ? 'true' : 'false')
      if (this.importForm.examDate) fd.append('examDate', this.importForm.examDate)
      if (this.importForm.paperId) fd.append('paperId', this.importForm.paperId)
      fd.append('file', this.importForm.file)
      this.importing = true
      importExamScore(fd).then(res => {
        const exam = res.data || {}
        const cover = exam.remark === 'overwrite' ? '（已覆盖同名考试）' : ''
        this.$modal.msgSuccess('导入完成' + cover + '：成功 ' + (exam.successRows || 0) + '，失败 ' + (exam.failRows || 0))
        if (exam.errorLog) {
          this.errorText = exam.errorLog
          this.errorOpen = true
        }
        this.importOpen = false
        this.getList()
      }).finally(() => {
        this.importing = false
      })
    },
    openMatrix(row) {
      this.matrixOpen = true
      this.matrixLoading = true
      this.matrixExam = row
      this.matrixSubjects = []
      this.matrixRows = []
      getExamScoreMatrix(row.examId).then(res => {
        const data = res.data || {}
        this.matrixExam = data.exam || row
        this.matrixSubjects = data.subjects || []
        this.matrixRows = data.rows || []
      }).finally(() => {
        this.matrixLoading = false
      })
    },
    showError(row) {
      this.errorText = row.errorLog || ''
      this.errorOpen = true
    },
    handleExport() {
      if (this.ids.length !== 1) {
        this.$modal.msgWarning('请勾选一条考试记录导出')
        return
      }
      this.download('spas/examScore/export/' + this.ids[0], {}, 'exam_score_' + this.ids[0] + '.xlsx')
    },
    handleExportRow(row) {
      if (!row || !row.examId) return
      this.download('spas/examScore/export/' + row.examId, {}, 'exam_score_' + row.examId + '.xlsx')
    },
    handleDelete() {
      const ids = this.ids
      this.$modal.confirm('确认删除选中的考试及校次数据？').then(() => {
        return delExamScore(ids.join(','))
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    formatScore(v) {
      if (v == null || v === '') return '-'
      return v
    },
    formatRank(v) {
      if (v == null || v === '') return '-'
      return v
    }
  }
}
</script>

<style scoped>
.spas-exam-score >>> .el-form--inline .class-row.el-form-item {
  display: flex;
  width: 100%;
  margin-right: 0;
}
.bound-class-wrap {
  display: inline-flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  min-height: 32px;
}
.bound-class-name {
  font-size: 14px;
  font-weight: 600;
  color: #2C2940;
  line-height: 32px;
}
</style>
