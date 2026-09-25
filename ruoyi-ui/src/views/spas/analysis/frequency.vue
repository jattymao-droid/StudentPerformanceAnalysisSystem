<template>
  <div class="app-container spas-analysis">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
      <el-form-item label="班级" prop="deptId" class="class-row">
        <template v-if="boundClassMode">
          <div class="bound-class-wrap">
            <span class="bound-class-name">{{ currentDeptName || '未绑定班级' }}</span>
            <el-tag v-if="boundClassRoleLabel" size="mini" type="info">{{ boundClassRoleLabel }}</el-tag>
            <el-button-group v-if="myDepts.length > 1" class="bound-class-switch">
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
          placeholder="可选，交叉掌握度时按班筛选"
          style="width: 220px"
        />
      </el-form-item>
      <el-form-item label="学科" prop="subjectId">
        <el-select
          v-model="queryParams.subjectId"
          placeholder="请选择学科"
          clearable
          filterable
          style="width: 180px"
          @change="handleSubjectChange"
        >
          <el-option
            v-for="item in subjectOptions"
            :key="item.subjectId"
            :label="item.subjectName"
            :value="item.subjectId"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="试卷" prop="paperIds">
        <el-select
          v-model="queryParams.paperIds"
          multiple
          filterable
          collapse-tags
          clearable
          placeholder="选择一次或多次考试"
          style="width: 420px"
          :disabled="!queryParams.subjectId && !paperOptions.length"
        >
          <el-option
            v-for="item in paperOptions"
            :key="item.paperId"
            :label="paperLabel(item)"
            :value="item.paperId"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="指标" prop="metric">
        <el-select v-model="queryParams.metric" style="width: 140px">
          <el-option label="题次数" value="questionCount" />
          <el-option label="权重合计" value="weightSum" />
          <el-option label="加权分值" value="weightedScoreSum" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['spas:analysis:frequency','spas:analysis:knowledge']">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="可单选一份试卷，或勾选多份对比考查分布。优先干预默认 masteryScope=papers：掌握度与所选试卷同源（加权引擎），不再混用全量快照。"
    />

    <el-alert
      v-if="scopeHint"
      :title="scopeHint"
      type="warning"
      :closable="false"
      show-icon
      class="mb8"
    />

    <el-alert
      v-if="annotationHint"
      type="error"
      :closable="false"
      show-icon
      class="mb8"
      :title="annotationHint"
    />

    <el-empty v-if="!queried" description="请选择试卷后查询考查频次">
      <div class="empty-actions">
        <el-button type="primary" size="mini" icon="el-icon-search" @click="handleQuery" :disabled="!(queryParams.paperIds && queryParams.paperIds.length)">立即查询</el-button>
        <el-button size="mini" @click="$router.push('/spas/biz/paper')">去试卷管理</el-button>
      </div>
    </el-empty>

    <template v-else>
      <el-row :gutter="16" class="overview-row" v-loading="loading">
        <el-col :xs="12" :sm="8" :md="6" v-for="card in overviewCards" :key="card.key">
          <div class="stat-card" :class="'tone-' + card.tone">
            <div class="stat-label">{{ card.label }}</div>
            <div class="stat-value">{{ card.value }}</div>
            <div class="stat-hint" v-if="card.hint">{{ card.hint }}</div>
          </div>
        </el-col>
      </el-row>

      <el-card shadow="never" class="chart-card" v-loading="loading">
        <div slot="header" class="card-header">
          {{ queryParams.paperIds.length > 1 ? '多卷对比（按试卷堆叠）' : '知识点考查频次' }}
          <span class="card-sub">Top {{ chartLimit }}</span>
          <span class="chart-hint">点击柱条可下钻</span>
        </div>
        <spas-chart :option="barOption" height="420px" @chart-click="onFreqBarClick" />
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" v-loading="loading">
        <div slot="header" class="card-header">明细列表</div>
        <el-table :data="tableRows" max-height="480" @sort-change="onSortChange">
          <el-table-column label="知识点" prop="knowledgeName" min-width="160" :show-overflow-tooltip="true" />
          <el-table-column label="所属章节" prop="parentName" min-width="140" :show-overflow-tooltip="true" />
          <el-table-column label="题次数" prop="questionCount" width="100" align="center" sortable="custom" />
          <el-table-column label="出现卷数" prop="paperCount" width="100" align="center" sortable="custom" />
          <el-table-column label="权重合计" prop="weightSum" width="110" align="center" sortable="custom">
            <template slot-scope="scope">{{ formatNum(scope.row.weightSum, 4) }}</template>
          </el-table-column>
          <el-table-column label="加权分值" prop="weightedScoreSum" width="110" align="center" sortable="custom">
            <template slot-scope="scope">{{ formatNum(scope.row.weightedScoreSum, 2) }}</template>
          </el-table-column>
          <el-table-column label="操作" width="90" align="center" fixed="right">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click.stop="goKnowledge(scope.row)" v-hasPermi="['spas:analysis:knowledge']">分析</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" v-loading="priorityLoading">
        <div slot="header" class="card-header card-header-row">
          <span>考查×掌握交叉（优先干预）</span>
          <span>
            <el-button type="text" size="mini" icon="el-icon-download" :disabled="!priorityRows.length" @click="exportRemediationPack">导出补弱包</el-button>
            <el-button type="text" size="mini" icon="el-icon-refresh" @click="loadPriority">刷新交叉</el-button>
          </span>
        </div>
        <el-alert
          type="info"
          :closable="false"
          show-icon
          class="mb8"
          :title="priorityHint"
        />
        <el-row :gutter="12" class="overview-row">
          <el-col :span="6"><div class="stat-card tone-warn"><div class="stat-label">优先干预</div><div class="stat-value">{{ prioritySummary.priorityCount || 0 }}</div></div></el-col>
          <el-col :span="6"><div class="stat-card tone-info"><div class="stat-label">证据不足</div><div class="stat-value">{{ prioritySummary.lowEvidenceCount || 0 }}</div></div></el-col>
          <el-col :span="6"><div class="stat-card tone-ok"><div class="stat-label">稳固</div><div class="stat-value">{{ prioritySummary.solidCount || 0 }}</div></div></el-col>
          <el-col :span="6"><div class="stat-card tone-info"><div class="stat-label">关注</div><div class="stat-value">{{ watchCount }}</div></div></el-col>
        </el-row>
        <el-table :data="priorityRows" max-height="360" highlight-current-row class="clickable-table" @row-click="goKnowledge">
          <el-table-column label="知识点" prop="knowledgeName" min-width="140" :show-overflow-tooltip="true" />
          <el-table-column label="象限" width="110" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="quadrantTag(scope.row.quadrant)">{{ quadrantLabel(scope.row.quadrant) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="题次数" prop="questionCount" width="90" align="center" />
          <el-table-column label="班均得分率" width="120" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
          </el-table-column>
          <el-table-column label="置信度" width="100" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="scope.row.confidenceLabel === '样本不足' ? 'danger' : (scope.row.confidenceLabel === '高' ? 'success' : 'warning')">{{ scope.row.confidenceLabel || '-' }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="参与人数" prop="studentCount" width="90" align="center" />
          <el-table-column label="操作" width="180" align="center" fixed="right">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click.stop="goKnowledge(scope.row)" v-hasPermi="['spas:analysis:knowledge']">分析</el-button>
              <el-button size="mini" type="text" @click.stop="goInterveneHint(scope.row)" v-hasPermi="['spas:intervene:add']">干预</el-button>
              <el-button size="mini" type="text" @click.stop="batchWeakIntervene(scope.row)" v-hasPermi="['spas:intervene:add']" :disabled="!queryParams.deptId">批量</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </template>
  </div>
</template>

<script>
import { knowledgeFrequency, knowledgePriority, paperAnnotationCoverage, analysisConfig } from '@/api/spas/analysis'
import { batchWeakIntervene as batchWeakInterveneApi } from '@/api/spas/intervene'
import { deptTreeSelect } from '@/api/system/user'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import { listPaper } from '@/api/spas/paper'
import { optionselectSubject } from '@/api/spas/subject'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { boundClassRoleFromDepts } from '@/utils/spasTeacherRole'
import { applyTeachingDeptContext, canLoadSystemDeptTree } from '@/utils/spasDeptTree'
import SpasChart from '@/components/spas/charts/SpasChart'

export default {
  name: 'AnalysisFrequency',
  components: { SpasChart, Treeselect },
  data() {
    return {
      loading: false,
      queried: false,
      subjectOptions: [],
      paperOptions: [],
      deptOptions: [],
      myDepts: [],
      priorityLoading: false,
      priorityRows: [],
      prioritySummary: { priorityCount: 0, solidCount: 0, lowEvidenceCount: 0 },
      priorityThresholds: {},
      annotationHint: '',
      unboundRatioThreshold: 0.20,
      items: [],
      byPaper: [],
      papers: [],
      summary: {
        knowledgeCount: 0,
        paperCount: 0,
        questionLinkCount: 0,
        weightSum: 0
      },
      sortProp: 'questionCount',
      sortOrder: 'descending',
      chartLimit: 20,
      queryParams: {
        subjectId: undefined,
        paperIds: [],
        deptId: undefined,
        metric: 'questionCount'
      }
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
      const id = this.queryParams.deptId
      if (!id) return ''
      const mine = (this.myDepts || []).find(d => d.deptId === id)
      if (mine && mine.deptName) return mine.deptName
      const node = this.findDeptNode(this.deptOptions, id)
      return node ? (node.label || node.deptName || '') : ''
    },
    boundClassRoleLabel() {
      return boundClassRoleFromDepts(this.myDepts, this.queryParams.deptId)
    },
    watchCount() {
      const n = (this.prioritySummary && this.prioritySummary.knowledgeCount) || (this.priorityRows || []).length
      const p = this.prioritySummary.priorityCount || 0
      const s = this.prioritySummary.solidCount || 0
      const l = this.prioritySummary.lowEvidenceCount || 0
      return Math.max(n - p - s - l, 0)
    },
    scopeHint() {
      const id = this.queryParams.deptId
      if (!id) return ''
      if (this.boundClassMode) {
        return '当前为班级范围（仅本班）'
      }
      const node = this.findDeptNode(this.deptOptions, id)
      if (!node) return ''
      const hasChild = !!(node.children && node.children.length)
      return hasChild
        ? '当前为年级/校级范围，掌握度统计含下级班级'
        : '当前为班级范围（仅本班）'
    },
    priorityHint() {
      const t = this.priorityThresholds || {}
      const q = t.questionMin != null ? t.questionMin : 2
      const w = t.weakRate != null ? Math.round(Number(t.weakRate) * 100) : 60
      const a = t.attemptMid != null ? t.attemptMid : 3
      return '阈值：题次≥' + q + ' 且得分率<' + w + '% 且练习次数≥' + a + ' → 优先干预；练习<' + a + ' → 证据不足'
    },
    overviewCards() {
      return [
        { key: 'papers', label: '所选试卷', value: this.summary.paperCount || 0, tone: 'info', hint: '单次或多卷' },
        { key: 'kp', label: '涉及知识点', value: this.summary.knowledgeCount || 0, tone: 'ok', hint: '叶子知识点' },
        { key: 'q', label: '题次合计', value: this.summary.questionLinkCount || 0, tone: 'warn', hint: '各知识点题次数之和' },
        { key: 'w', label: '权重合计', value: this.formatNum(this.summary.weightSum, 2), tone: 'info', hint: '考查强度参考' }
      ]
    },
    tableRows() {
      const rows = (this.items || []).slice()
      const prop = this.sortProp || 'questionCount'
      const desc = this.sortOrder !== 'ascending'
      rows.sort((a, b) => {
        const av = Number(a[prop] != null ? a[prop] : 0)
        const bv = Number(b[prop] != null ? b[prop] : 0)
        return desc ? bv - av : av - bv
      })
      return rows
    },
    barOption() {
      const metric = this.queryParams.metric || 'questionCount'
      const metricLabel = metric === 'weightSum' ? '权重合计' : (metric === 'weightedScoreSum' ? '加权分值' : '题次数')
      const top = this.tableRows.slice(0, this.chartLimit).reverse()
      const names = top.map(r => r.knowledgeName || ('#' + r.knowledgeId))
      const multi = (this.queryParams.paperIds || []).length > 1

      if (!multi) {
        return {
          tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
          grid: { left: 120, right: 24, top: 24, bottom: 24 },
          xAxis: { type: 'value', name: metricLabel },
          yAxis: { type: 'category', data: names, axisLabel: { width: 110, overflow: 'truncate' } },
          series: [{
            type: 'bar',
            name: metricLabel,
            data: top.map(r => Number(r[metric] != null ? r[metric] : 0)),
            itemStyle: { color: '#2442ED' }
          }]
        }
      }

      const paperMeta = {}
      ;(this.papers || []).forEach(p => {
        paperMeta[String(p.paperId)] = p.paperName || ('试卷' + p.paperId)
      })
      const seriesMap = {}
      ;(this.byPaper || []).forEach(row => {
        const pid = String(row.paperId)
        if (!seriesMap[pid]) {
          seriesMap[pid] = { name: paperMeta[pid] || ('试卷' + pid), map: {} }
        }
        seriesMap[pid].map[String(row.knowledgeId)] = Number(row[metric] != null ? row[metric] : 0)
      })
      const series = Object.keys(seriesMap).map(pid => ({
        name: seriesMap[pid].name,
        type: 'bar',
        stack: 'total',
        emphasis: { focus: 'series' },
        data: top.map(r => seriesMap[pid].map[String(r.knowledgeId)] || 0)
      }))
      return {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        legend: { type: 'scroll', top: 0 },
        grid: { left: 120, right: 24, top: 40, bottom: 24 },
        xAxis: { type: 'value', name: metricLabel },
        yAxis: { type: 'category', data: names, axisLabel: { width: 110, overflow: 'truncate' } },
        series
      }
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.deptId) {
      this.queryParams.deptId = Number(q.deptId) || q.deptId
    }
    analysisConfig().then(res => {
      const cfg = (res && res.data) || {}
      const annot = cfg.annotationCoverage || {}
      if (annot.unboundRatioThreshold != null) {
        this.unboundRatioThreshold = Number(annot.unboundRatioThreshold) || 0.20
      }
    }).catch(() => {})
    this.loadSubjects()
    this.loadPapers()
    this.loadMyDepts().then(() => {
      if (!this.queryParams.deptId && this.preferredDeptId) {
        this.queryParams.deptId = this.preferredDeptId
      }
    }).catch(() => {})
  },
  methods: {
    paperLabel(item) {
      const date = item.examDate ? String(item.examDate).substring(0, 10) : ''
      return date ? (item.paperName + '（' + date + '）') : item.paperName
    },
    formatNum(v, digits) {
      if (v == null || v === '') return '-'
      const n = Number(v)
      if (Number.isNaN(n)) return '-'
      return n.toFixed(digits == null ? 2 : digits)
    },
    loadSubjects() {
      optionselectSubject().then(res => {
        this.subjectOptions = res.data || []
      })
    },
    loadPapers() {
      const query = { pageNum: 1, pageSize: 200 }
      if (this.queryParams.subjectId) {
        query.subjectId = this.queryParams.subjectId
      }
      return listPaper(query).then(res => {
        this.paperOptions = res.rows || []
      }).catch(() => {
        this.paperOptions = []
      })
    },
    handleSubjectChange() {
      this.queryParams.paperIds = []
      this.loadPapers()
    },

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
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      this.loadPapers()
      if (this.queried) {
        this.handleQuery()
      }
    },
    findDeptNode(nodes, id) {
      for (const n of nodes || []) {
        if (n.id === id || n.deptId === id) return n
        const c = this.findDeptNode(n.children, id)
        if (c) return c
      }
      return null
    },
    formatRate(v) {
      if (v == null || v === '') return '-'
      const n = Number(v)
      if (Number.isNaN(n)) return '-'
      return (n * 100).toFixed(1) + '%'
    },
    quadrantLabel(q) {
      const map = { priority: '优先干预', low_evidence: '证据不足', solid: '稳固', watch: '关注' }
      return map[q] || q || '-'
    },
    onFreqBarClick(params) {
      const name = params && (params.name || (params.data && params.data.name))
      if (!name) return
      const row = (this.tableRows || []).find(r => (r.knowledgeName || ('#' + r.knowledgeId)) === name)
        || (this.tableRows || []).find(r => r.knowledgeName === name)
      if (row) this.goKnowledge(row)
    },
    goKnowledge(row) {
      const knowledgeId = row.knowledgeId || row.id
      if (!knowledgeId) {
        this.$modal.msgWarning('无法定位知识点')
        return
      }
      const query = { knowledgeId }
      if (this.queryParams.subjectId) query.subjectId = this.queryParams.subjectId
      if (this.queryParams.deptId) query.deptId = this.queryParams.deptId
      this.$router.push({ path: '/spas/analysis/knowledge', query })
    },
    goInterveneHint(row) {
      const knowledgeId = row.knowledgeId || row.id
      if (!knowledgeId) {
        this.$modal.msgWarning('无法定位知识点')
        return
      }
      const query = {
        knowledgeId,
        knowledgeName: row.knowledgeName || row.name || '',
        openAdd: '1'
      }
      if (this.queryParams.subjectId) query.subjectId = this.queryParams.subjectId
      if (this.queryParams.deptId) query.deptId = this.queryParams.deptId
      this.$router.push({ path: '/spas/intervene', query }).catch(() => {
        this.$router.push({ path: '/spas/warning/intervene', query })
      })
    },
    batchWeakIntervene(row) {
      const knowledgeId = row.knowledgeId || row.id
      if (!knowledgeId || !this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      const name = row.knowledgeName || row.name || knowledgeId
      this.$modal.confirm('为当前班级（含下级）中「' + name + '」仍薄弱的学生批量创建干预？已有进行中任务会跳过。').then(() => {
        return batchWeakInterveneApi({
          deptId: this.queryParams.deptId,
          subjectId: this.queryParams.subjectId,
          knowledgeId: knowledgeId,
          title: '薄弱干预：' + name,
          targetRate: 0.6
        })
      }).then(res => {
        const d = (res && res.data) || {}
        this.$modal.msgSuccess('已创建 ' + (d.created || 0) + ' 条，跳过 ' + (d.skipped || 0) + ' 条')
      }).catch(() => {})
    },
    quadrantTag(q) {
      const map = { priority: 'danger', low_evidence: 'info', solid: 'success', watch: 'warning' }
      return map[q] || 'info'
    },
    exportRemediationPack() {
      const rows = (this.priorityRows || []).filter(r => r.quadrant === 'priority')
      const source = rows.length ? rows : (this.priorityRows || [])
      if (!source.length) {
        this.$modal.msgWarning('请先查询考查交叉')
        return
      }
      const header = ['知识点', '象限', '题次数', '班均得分率', '置信度', '建议']
      const lines = [header.join(',')]
      source.forEach(r => {
        const name = (r.knowledgeName || r.name || '').replace(/,/g, ' ')
        const rate = r.avgRate == null ? '' : Math.round(Number(r.avgRate) * 1000) / 10 + '%'
        const advice = r.quadrant === 'priority' ? '优先补弱：考得多且掌握偏低，建议针对该知识点安排复测' : '持续观察'
        lines.push([name, this.quadrantLabel(r.quadrant), r.questionCount || 0, rate, r.confidenceLabel || '', advice].join(','))
      })
      const blob = new Blob(['\ufeff' + lines.join('\n')], { type: 'text/csv;charset=utf-8' })
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = 'remediation_pack.csv'
      a.click()
      URL.revokeObjectURL(url)
    },
    loadPriority() {
      if (!this.queryParams.paperIds || !this.queryParams.paperIds.length) return
      this.priorityLoading = true
      knowledgePriority({
        subjectId: this.queryParams.subjectId,
        deptId: this.queryParams.deptId,
        paperIds: this.queryParams.paperIds.join(','),
        masteryScope: 'papers'
      }).then(res => {
        const data = res.data || {}
        this.priorityRows = data.items || []
        this.priorityThresholds = data.thresholds || {}
        this.prioritySummary = {
          priorityCount: data.priorityCount || 0,
          solidCount: data.solidCount || 0,
          lowEvidenceCount: data.lowEvidenceCount || 0,
          knowledgeCount: data.knowledgeCount || 0
        }
      }).finally(() => { this.priorityLoading = false })
    },
    handleQuery() {
      if (!this.queryParams.paperIds || !this.queryParams.paperIds.length) {
        this.$modal.msgWarning('请至少选择一份试卷')
        return
      }
      this.loading = true
      this.queried = true
      knowledgeFrequency({
        subjectId: this.queryParams.subjectId,
        paperIds: this.queryParams.paperIds.join(',')
      }).then(res => {
        const data = res.data || {}
        this.items = data.items || []
        this.byPaper = data.byPaper || []
        this.papers = data.papers || []
        this.summary = {
          knowledgeCount: data.knowledgeCount || 0,
          paperCount: data.paperCount || 0,
          questionLinkCount: data.questionLinkCount || 0,
          weightSum: data.weightSum || 0
        }
        this.sortProp = this.queryParams.metric || 'questionCount'
        this.sortOrder = 'descending'
        this.loadPriority()
        this.loadAnnotationCoverage()
      }).finally(() => {
        this.loading = false
      })
    },
    loadAnnotationCoverage() {
      if (!this.queryParams.paperIds || !this.queryParams.paperIds.length) {
        this.annotationHint = ''
        return
      }
      paperAnnotationCoverage({ paperIds: this.queryParams.paperIds.join(',') }).then(res => {
        const d = (res && res.data) || {}
        const unbound = Number(d.unboundCount || 0)
        const total = Number(d.questionCount || 0)
        const ratio = Number(d.unboundRatio || 0)
        const thr = Number(this.unboundRatioThreshold) || 0.20
        if (total > 0 && ratio > thr) {
          this.annotationHint = '未标注占比 ' + Math.round(ratio * 1000) / 10 + '%（阈值 ' + Math.round(thr * 100) + '%），'
            + unbound + '/' + total + ' 题未标：优先干预结论不可作正式定级，请先补齐标注。'
        } else if (total > 0 && unbound > 0) {
          this.annotationHint = '所选试卷有 ' + unbound + '/' + total + ' 题未标注知识点（'
            + Math.round(ratio * 1000) / 10 + '%），优先干预结论请谨慎使用。'
        } else {
          this.annotationHint = ''
        }
        const noType = Number(d.noTypeCount || 0)
        const noBloom = Number(d.noBloomCount || 0)
        const metaParts = []
        if (noType > 0) metaParts.push(noType + ' 题缺题型')
        if (noBloom > 0) metaParts.push(noBloom + ' 题缺认知层级')
        if (metaParts.length) {
          this.annotationHint = (this.annotationHint ? this.annotationHint + '；' : '') + metaParts.join('，')
        }
      }).catch(() => { this.annotationHint = '' })
    },
    resetQuery() {
      const subjectId = this.queryParams.subjectId
      this.queryParams = {
        subjectId: subjectId,
        paperIds: [],
        deptId: this.boundClassMode ? this.preferredDeptId : undefined,
        metric: 'questionCount'
      }
      this.priorityRows = []
      this.prioritySummary = { priorityCount: 0, solidCount: 0, lowEvidenceCount: 0 }
      this.annotationHint = ''
      this.queried = false
      this.items = []
      this.byPaper = []
      this.papers = []
      this.loadPapers()
    },
    onSortChange({ prop, order }) {
      if (!prop) return
      this.sortProp = prop
      this.sortOrder = order || 'descending'
    }
  }
}
</script>

<style scoped>
.spas-analysis >>> .el-form--inline .class-row.el-form-item {
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
.bound-class-switch {
  margin-left: 4px;
}
.mb8 { margin-bottom: 8px; }
.overview-row { margin-bottom: 16px; }
.stat-card {
  background: #fff;
  border: 1px solid #E2E8F0;
  border-radius: 10px;
  padding: 14px 16px;
  margin-bottom: 12px;
  border-left: 3px solid #2442ED;
  box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04), 0 6px 16px rgba(15, 23, 42, 0.04);
}
.stat-card.tone-ok { border-left-color: #10B981; }
.stat-card.tone-warn { border-left-color: #D97706; }
.stat-card.tone-info { border-left-color: #0E7490; }
.stat-label {
  color: #64748B;
  font-size: 12px;
  letter-spacing: 0.03em;
  font-weight: 600;
}
.stat-value {
  margin-top: 8px;
  font-size: 24px;
  font-weight: 700;
  color: #0F172A;
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.02em;
  line-height: 1.15;
}
.stat-hint {
  margin-top: 4px;
  color: #94A3B8;
  font-size: 11px;
}
.card-header { font-weight: 600; color: #0F172A; }
.card-header-row { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
.card-sub { margin-left: 8px; font-weight: 400; color: #94A3B8; font-size: 12px; }
.chart-card { margin-bottom: 8px; }
</style>
