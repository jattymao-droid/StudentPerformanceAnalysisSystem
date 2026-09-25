<template>
  <div class="app-container spas-report-hub">
    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="在此选择对象与口径后直接导出 PDF / Excel；也可跳转到分析页做更完整的预览与下钻。"
    />

    <el-card shadow="never" class="mb8">
      <el-form :inline="true" size="small" label-width="72px">
        <el-form-item label="报告类型">
          <el-radio-group v-model="form.kind" @change="onKindChange">
            <el-radio-button label="student">学生</el-radio-button>
            <el-radio-button label="class">班级</el-radio-button>
            <el-radio-button label="portfolio">一生一册</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="学科">
          <el-select v-model="form.subjectId" clearable filterable placeholder="全部学科" style="width: 160px">
            <el-option
              v-for="s in subjectOptions"
              :key="s.subjectId"
              :label="s.subjectName"
              :value="s.subjectId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="时间窗">
          <el-select v-model="form.window" style="width: 140px">
            <el-option label="本学期" value="semester" />
            <el-option label="上学期" value="prev_semester" />
            <el-option label="近 30 天" value="last30d" />
            <el-option label="近 90 天" value="last90d" />
            <el-option label="全部" value="all" />
          </el-select>
        </el-form-item>
        <el-form-item v-if="form.kind !== 'class'" label="班级">
          <treeselect
            v-model="form.deptId"
            :options="deptOptions"
            :show-count="true"
            placeholder="筛选学生所属班级"
            style="width: 220px"
            @input="onDeptChange"
          />
        </el-form-item>
        <el-form-item v-if="form.kind === 'class'" label="班级" required>
          <treeselect
            v-model="form.deptId"
            :options="deptOptions"
            :show-count="true"
            placeholder="请选择班级"
            style="width: 220px"
          />
        </el-form-item>
        <el-form-item v-if="form.kind !== 'class'" label="学生" required>
          <el-select
            v-model="form.studentId"
            filterable
            remote
            clearable
            :remote-method="remoteStudent"
            :loading="studentLoading"
            placeholder="学号/姓名"
            style="width: 240px"
          >
            <el-option
              v-for="s in studentOptions"
              :key="s.studentId"
              :label="(s.studentNo || '') + ' · ' + (s.studentName || '')"
              :value="s.studentId"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button
            type="success"
            plain
            icon="el-icon-view"
            :loading="previewLoading"
            :disabled="!canExport"
            @click="loadPreview"
          >预览</el-button>
          <el-button
            type="primary"
            icon="el-icon-download"
            :loading="exportLoading"
            :disabled="!canExport"
            @click="exportReport('pdf')"
          >导出 PDF</el-button>
          <el-button
            type="warning"
            plain
            icon="el-icon-document"
            :loading="exportLoading"
            :disabled="!canExport"
            @click="exportReport('xlsx')"
          >导出 Excel</el-button>
          <el-button type="text" @click="goAnalysis">前往分析页</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-drawer
      title="报告预览"
      :visible.sync="previewOpen"
      size="480px"
      append-to-body
      direction="rtl"
    >
      <div v-loading="previewLoading" class="preview-body">
        <template v-if="previewData">
          <el-alert
            v-if="previewHeadline"
            :title="previewHeadline"
            type="info"
            :closable="false"
            show-icon
            class="mb8"
          />
          <el-descriptions v-if="previewStudent" :column="1" size="small" border class="mb8">
            <el-descriptions-item label="学号">{{ previewStudent.studentNo || '-' }}</el-descriptions-item>
            <el-descriptions-item label="姓名">{{ previewStudent.studentName || '-' }}</el-descriptions-item>
          </el-descriptions>
          <div class="preview-section-title">薄弱 Top</div>
          <el-table :data="previewWeakTop" size="mini" empty-text="暂无薄弱" max-height="220" class="mb8">
            <el-table-column label="知识点" prop="knowledgeName" min-width="120" :show-overflow-tooltip="true" />
            <el-table-column label="得分率" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.weightedRate != null ? scope.row.weightedRate : scope.row.rate) }}</template>
            </el-table-column>
          </el-table>
          <div class="preview-section-title">章节进退</div>
          <p class="tip" v-if="previewChapterHint">{{ previewChapterHint }}</p>
          <el-button type="primary" size="mini" icon="el-icon-download" :disabled="!canExport" @click="exportReport('pdf')">确认导出 PDF</el-button>
          <el-button size="mini" @click="goAnalysis">去分析页下钻</el-button>
        </template>
        <el-empty v-else description="选择对象后点击预览" />
      </div>
    </el-drawer>

    <el-row :gutter="16">
      <el-col :xs="24" :md="8">
        <el-card shadow="hover">
          <div slot="header">学生分析报告</div>
          <p class="tip">含雷达、薄弱、趋势、标注门禁摘要</p>
          <el-button type="text" @click="quickKind('student')">填入本页表单</el-button>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="8">
        <el-card shadow="hover">
          <div slot="header">班级分析报告</div>
          <p class="tip">班级弱项、覆盖与热力概览</p>
          <el-button type="text" @click="quickKind('class')">填入本页表单</el-button>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="8">
        <el-card shadow="hover">
          <div slot="header">一生一册</div>
          <p class="tip">档案口径 + 辅导/预警同屏</p>
          <el-button type="text" @click="quickKind('portfolio')">填入本页表单</el-button>
        </el-card>
      </el-col>
    </el-row>

    <el-card shadow="never" style="margin-top: 16px">
      <div slot="header">学期对比（本学期 vs 上学期章节进退）</div>
      <p class="tip" style="margin-bottom: 8px">
        分析页已内置「章节进退」对比（基线=上学期）。导出时选择时间窗「本学期」，报告 PDF/Excel 会附带上学期对比摘要。
      </p>
      <el-button type="primary" plain size="mini" @click="goTermCompare('student')">学生学期对比</el-button>
      <el-button type="primary" plain size="mini" @click="goTermCompare('class')">班级学期对比</el-button>
    </el-card>
  </div>
</template>

<script>
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import { optionselectSubject } from '@/api/spas/subject'
import { listStudent } from '@/api/spas/student'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
import { applyTeachingDeptContext, canLoadSystemDeptTree } from '@/utils/spasDeptTree'
import { previewStudentReport, previewClassReport } from '@/api/spas/report'

export default {
  name: 'SpasReportHub',
  components: { Treeselect },
  data() {
    return {
      form: {
        kind: 'student',
        subjectId: undefined,
        window: 'semester',
        deptId: undefined,
        studentId: undefined
      },
      subjectOptions: [],
      deptOptions: [],
      myDepts: [],
      preferredDeptId: undefined,
      studentOptions: [],
      studentLoading: false,
      exportLoading: false,
      previewOpen: false,
      previewLoading: false,
      previewData: null
    }
  },
  computed: {
    canExport() {
      if (this.form.kind === 'class') return !!this.form.deptId
      return !!this.form.studentId
    },
    previewHeadline() {
      const d = this.previewData || {}
      const s = d.summary || d.overview || {}
      return s.headline || d.headline || ''
    },
    previewStudent() {
      const d = this.previewData || {}
      return d.student || null
    },
    previewWeakTop() {
      const d = this.previewData || {}
      const w = d.weakTop
      return Array.isArray(w) ? w.slice(0, 8) : []
    },
    previewChapterHint() {
      const d = this.previewData || {}
      const c = d.chapterDelta || {}
      return c.headline || c.baselineHint || ''
    }
  },
  created() {
    this.loadSubjects()
    this.loadDepts()
  },
  methods: {
    formatRate(rate) {
      if (rate == null || rate === '') return '-'
      const n = Number(rate)
      if (isNaN(n)) return rate
      const p = Math.abs(n) <= 1 ? n * 100 : n
      return p.toFixed(1) + '%'
    },
    loadSubjects() {
      return optionselectSubject().then(res => {
        this.subjectOptions = res.data || []
      }).catch(() => { this.subjectOptions = [] })
    },
    loadDepts() {
      return applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).catch(() => {
        if (!canLoadSystemDeptTree()) {
          this.deptOptions = []
          return
        }
        return deptTreeSelect().then(res => { this.deptOptions = res.data || [] }).catch(() => {
          this.deptOptions = []
        })
      })
    },
    onKindChange() {
      if (this.form.kind === 'class') {
        this.form.studentId = undefined
      }
      this.previewData = null
    },
    onDeptChange() {
      this.form.studentId = undefined
      this.studentOptions = []
      this.previewData = null
      if (this.form.deptId) this.remoteStudent('')
    },
    remoteStudent(query) {
      const params = { pageNum: 1, pageSize: this.form.deptId ? 200 : 40, status: '0' }
      if (this.form.deptId) params.deptId = this.form.deptId
      if (query) {
        if (/^\d/.test(String(query))) params.studentNo = query
        else params.studentName = query
      }
      this.studentLoading = true
      listStudent(params).then(res => {
        this.studentOptions = res.rows || res.data || []
      }).catch(() => {
        this.studentOptions = []
      }).finally(() => { this.studentLoading = false })
    },
    quickKind(kind) {
      this.form.kind = kind
      this.onKindChange()
    },
    loadPreview() {
      if (!this.canExport) {
        this.$modal.msgWarning(this.form.kind === 'class' ? '请先选择班级' : '请先选择学生')
        return
      }
      const params = { window: this.form.window }
      if (this.form.subjectId) params.subjectId = this.form.subjectId
      this.previewOpen = true
      this.previewLoading = true
      this.previewData = null
      const req = this.form.kind === 'class'
        ? previewClassReport(this.form.deptId, params)
        : previewStudentReport(this.form.studentId, params)
      req.then(res => {
        this.previewData = res.data || {}
      }).catch(() => {
        this.previewData = null
      }).finally(() => { this.previewLoading = false })
    },
    goAnalysis() {
      if (this.form.kind === 'class') {
        this.$router.push({ path: '/spas/analysis/class', query: { deptId: this.form.deptId || undefined } }).catch(() => {})
      } else if (this.form.kind === 'portfolio') {
        this.$router.push({ path: '/spas/portfolio', query: { studentId: this.form.studentId || undefined } }).catch(() => {})
      } else {
        this.$router.push({
          path: '/spas/analysis/student',
          query: { studentId: this.form.studentId || undefined, subjectId: this.form.subjectId || undefined }
        }).catch(() => {})
      }
    },
    goTermCompare(kind) {
      if (kind === 'class') {
        this.$router.push({
          path: '/spas/analysis/class',
          query: {
            deptId: this.form.deptId || undefined,
            subjectId: this.form.subjectId || undefined,
            window: 'semester',
            focus: 'chapterDelta'
          }
        }).catch(() => {})
      } else {
        this.$router.push({
          path: '/spas/analysis/student',
          query: {
            studentId: this.form.studentId || undefined,
            subjectId: this.form.subjectId || undefined,
            window: 'semester',
            focus: 'chapterDelta'
          }
        }).catch(() => {})
      }
    },
    exportReport(format) {
      if (!this.canExport) {
        this.$modal.msgWarning(this.form.kind === 'class' ? '请先选择班级' : '请先选择学生')
        return
      }
      const ext = format === 'xlsx' ? 'xlsx' : 'pdf'
      const params = { format: ext, window: this.form.window }
      if (this.form.subjectId) params.subjectId = this.form.subjectId
      let url
      let name
      if (this.form.kind === 'class') {
        url = 'spas/report/class/' + this.form.deptId
        name = `class_report_${this.form.deptId}_${Date.now()}.${ext}`
      } else if (this.form.kind === 'portfolio') {
        url = 'spas/report/student/' + this.form.studentId
        name = `portfolio_${this.form.studentId}_${Date.now()}.${ext}`
      } else {
        url = 'spas/report/student/' + this.form.studentId
        name = `student_report_${this.form.studentId}_${Date.now()}.${ext}`
      }
      this.exportLoading = true
      this.download(url, params, name).finally(() => { this.exportLoading = false })
    }
  }
}
</script>

<style scoped>
.mb8 { margin-bottom: 12px; }
.tip { color: #909399; font-size: 13px; min-height: 40px; }
.spas-report-hub ::v-deep .vue-treeselect { line-height: 28px; }
.preview-body { padding: 0 16px 24px; }
.preview-section-title { font-weight: 600; margin: 12px 0 8px; color: #0F172A; }
</style>
