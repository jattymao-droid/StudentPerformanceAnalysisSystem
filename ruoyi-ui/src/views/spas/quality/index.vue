<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
      <el-form-item label="班级" prop="deptId">
        <treeselect
          v-model="queryParams.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="全部范围"
          style="width: 240px"
        />
      </el-form-item>
      <el-form-item label="学科" prop="subjectId">
        <el-select v-model="queryParams.subjectId" clearable placeholder="全部学科" style="width: 160px">
          <el-option v-for="item in subjectOptions" :key="item.subjectId" :label="item.subjectName" :value="item.subjectId" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['spas:quality:list']">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-alert
      :title="alertTitle"
      type="warning"
      :closable="false"
      show-icon
      class="mb8"
    />

    <el-row :gutter="12" v-loading="loading">
      <el-col :xs="12" :sm="8" :md="6" v-for="m in metrics" :key="m.code" style="margin-bottom: 12px">
        <div class="metric-card" :class="'level-' + m.level" @click="loadDetail(m)">
          <div class="metric-code">{{ m.code }}</div>
          <div class="metric-title">{{ metricTitle(m.code) }}</div>
          <div class="metric-count">{{ m.count }}</div>
          <div class="metric-extra" v-if="m.ratio">{{ m.ratio }}</div>
        </div>
      </el-col>
    </el-row>

    <el-card shadow="never" style="margin-top: 8px">
      <div slot="header" class="card-header">
        <span>下钻明细<template v-if="activeMetric">  - {{ activeMetric }}</template></span>
        <el-button
          v-if="canFix"
          style="float: right; padding: 3px 0"
          type="text"
          @click="goFix"
        >前往修复</el-button>
      </div>
      <el-empty v-if="!activeMetric" description="请先点击指标卡片查看下钻" />
      <el-table v-else :data="detailRows" v-loading="detailLoading" empty-text="-" max-height="420">
        <el-table-column v-for="col in detailColumns" :key="col.prop" :label="col.label" :prop="col.prop" :min-width="col.width || 100" :show-overflow-tooltip="true" />
      </el-table>
    </el-card>
  </div>
</template>

<script>
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import { deptTreeSelect } from '@/api/system/user'
import { listSubject } from '@/api/spas/subject'
import { qualityOverview, qualityDetail } from '@/api/spas/quality'

const METRIC_TITLE = {'Q_NO_KNOWLEDGE': '题目未绑定知识点', 'Q_WEIGHT_SUM': '知识点权重和≠1', 'Q_ORPHAN_SCORE': '异常成绩/草稿卷', 'Q_LOW_ATTEMPT': '样本不足仍展示', 'Q_MISSING_EXAM_DATE': '试卷缺考试日期', 'Q_PARTIAL_PAPER': '作答题数不完整', 'Q_BLANK_ZERO': '空分按0计入(启发)'}

export default {
  name: 'SpasQuality',
  components: { Treeselect },
  data() {
    return {
      loading: false,
      detailLoading: false,
      deptOptions: [],
      subjectOptions: [],
      metrics: [],
      alertCount: 0,
      minAttempts: 3,
      activeMetric: '',
      detailRows: [],
      queryParams: {
        deptId: undefined,
        subjectId: undefined
      }
    }
  },
  computed: {
    canFix() {
      const m = this.activeMetric
      return ['Q_NO_KNOWLEDGE', 'Q_WEIGHT_SUM', 'Q_MISSING_EXAM_DATE', 'Q_PARTIAL_PAPER', 'Q_ORPHAN_SCORE', 'Q_BLANK_ZERO'].indexOf(m) >= 0
    },
    alertTitle() {
      return '质量告警 ' + this.alertCount + '  · min-attempts=' + this.minAttempts
    },
    detailColumns() {
      const map = {
        Q_NO_KNOWLEDGE: [
          { prop: 'paperName', label: '试卷', width: 160 },
          { prop: 'questionNo', label: '题号', width: 80 },
          { prop: 'questionId', label: 'QID', width: 80 },
          { prop: 'fullScore', label: '满分', width: 80 }
        ],
        Q_WEIGHT_SUM: [
          { prop: 'paperName', label: '试卷', width: 160 },
          { prop: 'questionNo', label: '题号', width: 80 },
          { prop: 'weightSum', label: '权重和', width: 100 }
        ],
        Q_LOW_ATTEMPT: [
          { prop: 'studentNo', label: '学号', width: 110 },
          { prop: 'studentName', label: '姓名', width: 90 },
          { prop: 'knowledgeName', label: '知识点', width: 140 },
          { prop: 'attemptCount', label: '练习次数', width: 90 },
          { prop: 'weakLevel', label: '等级', width: 80 }
        ],
        Q_MISSING_EXAM_DATE: [
          { prop: 'paperId', label: 'ID', width: 70 },
          { prop: 'paperName', label: '试卷', width: 180 },
          { prop: 'status', label: '状态', width: 80 }
        ],
        Q_PARTIAL_PAPER: [
          { prop: 'paperName', label: '试卷', width: 160 },
          { prop: 'studentNo', label: '学号', width: 110 },
          { prop: 'studentName', label: '姓名', width: 90 },
          { prop: 'answered', label: '已作答', width: 80 },
          { prop: 'totalQuestions', label: '应作答', width: 80 }
        ],
        Q_ORPHAN_SCORE: [
          { prop: 'paperId', label: '试卷ID', width: 90 },
          { prop: 'paperName', label: '试卷', width: 140 },
          { prop: 'status', label: '状态', width: 80 },
          { prop: 'studentNo', label: '学号', width: 110 },
          { prop: 'score', label: '得分', width: 80 }
        ],
        Q_BLANK_ZERO: [
          { prop: 'paperName', label: '试卷', width: 160 },
          { prop: 'studentNo', label: '学号', width: 110 },
          { prop: 'questionNo', label: '题号', width: 80 },
          { prop: 'score', label: '得分', width: 80 },
          { prop: 'fullScore', label: '满分', width: 80 },
          { prop: 'scoreSource', label: '来源', width: 80 }
        ]
      }
      return map[this.activeMetric] || [{ prop: 'paperName', label: '-', width: 160 }]
    }
  },
  created() {
    this.loadDepts()
    this.loadSubjects()
    this.handleQuery()
  },
  methods: {
    metricTitle(code) {
      return METRIC_TITLE[code] || code
    },
    loadDepts() {
      return deptTreeSelect().then(res => {
        this.deptOptions = res.data || []
      })
    },
    loadSubjects() {
      return listSubject({ pageNum: 1, pageSize: 200 }).then(res => {
        this.subjectOptions = res.rows || res.data || []
      })
    },
    handleQuery() {
      this.loading = true
      qualityOverview(this.queryParams).then(res => {
        const data = res.data || {}
        this.metrics = data.metrics || []
        this.alertCount = data.alertCount || 0
        this.minAttempts = data.minAttempts || 3
      }).finally(() => {
        this.loading = false
      })
    },
    resetQuery() {
      this.queryParams = { deptId: undefined, subjectId: undefined }
      this.activeMetric = ''
      this.detailRows = []
      this.handleQuery()
    },
    loadDetail(m) {
      this.activeMetric = m.code
      this.detailLoading = true
      qualityDetail({ metric: m.code, deptId: this.queryParams.deptId, subjectId: this.queryParams.subjectId }).then(res => {
        this.detailRows = res.data || []
      }).finally(() => {
        this.detailLoading = false
      })
    },
    goFix() {
      const m = this.activeMetric
      if (m === 'Q_PARTIAL_PAPER' || m === 'Q_ORPHAN_SCORE' || m === 'Q_BLANK_ZERO') {
        this.$router.push({ path: '/spas/biz/score' })
        return
      }
      this.$router.push({ path: '/spas/biz/paper' })
    }
  }
}
</script>

<style scoped>
.metric-card {
  border: 1px solid #ebeef5;
  border-radius: 6px;
  padding: 12px 14px;
  cursor: pointer;
  background: #fff;
  min-height: 110px;
}
.metric-card:hover { border-color: #909399; }
.metric-card.level-severe { border-left: 4px solid #f56c6c; }
.metric-card.level-watch { border-left: 4px solid #e6a23c; }
.metric-card.level-info { border-left: 4px solid #909399; }
.metric-code { font-size: 12px; color: #909399; }
.metric-title { margin-top: 4px; font-size: 14px; color: #303133; }
.metric-count { margin-top: 10px; font-size: 28px; font-weight: 600; color: #303133; }
.metric-extra { margin-top: 4px; font-size: 12px; color: #909399; }
.card-header { font-weight: 600; }
</style>
