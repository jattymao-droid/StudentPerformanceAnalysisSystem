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
          placeholder="可选班级筛选"
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
      <el-form-item label="范围">
        <el-radio-group v-model="scopeMode" size="mini" @change="onScopeModeChange">
          <el-radio-button label="all">全部知识点</el-radio-button>
          <el-radio-button label="node">版本/章节/知识点</el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item v-if="scopeMode === 'node'" label="节点" prop="knowledgeId">
        <treeselect
          v-model="queryParams.knowledgeId"
          :options="knowledgeOptions"
          :normalizer="knowledgeNormalizer"
          :disable-branch-nodes="false"
          :clearable="true"
          placeholder="选版本/章节/知识点"
          style="width: 280px"
          @input="onKnowledgeChange"
        />
      </el-form-item>
      <el-form-item label="模式">
        <el-radio-group v-model="analysisMode" size="mini" @change="onModeChange">
          <el-radio-button label="window">时间窗</el-radio-button>
          <el-radio-button label="papers">选卷诊断</el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item v-if="analysisMode === 'window'" label="时间窗">
        <el-select v-model="queryParams.window" style="width: 140px" @change="handleQuery">
          <el-option label="全部" value="all" />
          <el-option label="近30天" value="last30d" />
          <el-option label="近90天" value="last90d" />
          <el-option label="本学期" value="semester" />
        </el-select>
      </el-form-item>
      <el-form-item v-else label="考试集合">
        <el-select
          v-model="queryParams.paperIds"
          multiple
          filterable
          collapse-tags
          clearable
          placeholder="勾选多场已发布试卷"
          style="width: 320px"
          :disabled="!queryParams.subjectId"
        >
          <el-option
            v-for="item in paperOptions"
            :key="item.paperId"
            :label="paperLabel(item)"
            :value="item.paperId"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['spas:analysis:knowledge']">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-empty v-if="!queryParams.subjectId" description="请先选择学科">
      <div class="empty-actions">
        <el-button size="mini" type="primary" @click="$router.push('/spas/base/knowledge')">去知识点管理</el-button>
        <el-button size="mini" @click="$router.push('/spas/analysis/frequency')">从考查频次进入</el-button>
      </div>
    </el-empty>

    <template v-else>
      <el-alert
        :title="scopeRangeHint"
        type="success"
        :closable="false"
        show-icon
        class="mb8"
      />
      <div v-if="versionChips.length" class="version-chip-bar mb8">
        <span class="chip-label">快捷：</span>
        <el-button
          size="mini"
          :type="scopeMode === 'all' && !queryParams.knowledgeId ? 'primary' : 'default'"
          @click="selectScopeAll"
        >全部</el-button>
        <el-button
          v-for="v in versionChips"
          :key="v.knowledgeId"
          size="mini"
          :type="String(queryParams.knowledgeId) === String(v.knowledgeId) ? 'primary' : 'default'"
          @click="drillToChild(v)"
        >{{ v.knowledgeName }}</el-button>
      </div>
      <el-alert
        v-if="overview.scopeNote"
        :title="overview.scopeNote"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
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
        v-if="overview.headline"
        :title="overview.headline"
        type="info"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-alert
        type="info"
        :closable="false"
        show-icon
        class="mb8"
        title="口径：按学生加权得分率汇总；严重&lt;45%、薄弱45–60%、关注60–75%、正常≥75%。练习不足3次标为样本不足并隐藏结论。"
      />
      <el-alert
        v-if="scopeBanner"
        type="info"
        :closable="false"
        show-icon
        class="mb8"
        :title="scopeBanner"
      />
      <el-row :gutter="16" class="overview-row" v-loading="loading">
        <el-col :xs="12" :sm="8" :md="6" v-for="card in overviewCards" :key="card.key">
          <div class="stat-card" :class="'tone-' + card.tone">
            <div class="stat-label">{{ card.label }}</div>
            <div class="stat-value">{{ card.value }}</div>
            <div class="stat-hint" v-if="card.hint">{{ card.hint }}</div>
          </div>
        </el-col>
      </el-row>

      <el-card shadow="never" class="mb8" v-if="childRows.length" v-loading="loading">
        <div slot="header" class="card-header">
          {{ childrenTitle }}
          <span class="chart-hint">点击行下钻</span>
        </div>
        <el-row :gutter="16">
          <el-col :xs="24" :lg="12">
            <spas-chart :option="childBarOption" height="340px" @chart-click="onChildBarClick" />
          </el-col>
          <el-col :xs="24" :lg="12">
            <el-table :data="childRows" size="mini" max-height="300" @row-click="drillToChild">
              <el-table-column :label="childrenTitle" prop="knowledgeName" min-width="140" :show-overflow-tooltip="true" />
              <el-table-column label="类型" width="80" align="center">
                <template slot-scope="scope">{{ nodeTypeLabel(scope.row.nodeType) }}</template>
              </el-table-column>
              <el-table-column label="平均得分率" width="110" align="center">
                <template slot-scope="scope">
                  <span :style="{ color: rateColor(scope.row.avgRate), fontWeight: 600 }">{{ formatRate(scope.row.avgRate) }}</span>
                </template>
              </el-table-column>
              <el-table-column label="覆盖学生" prop="studentCount" width="90" align="center" />
              <el-table-column label="薄弱人数" prop="weakCount" width="90" align="center" />
              <el-table-column label="操作" width="80" align="center">
                <template slot-scope="scope">
                  <el-button type="text" size="mini" @click.stop="drillToChild(scope.row)">下钻</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-col>
        </el-row>
      </el-card>

      <el-card shadow="never" style="margin-bottom: 16px" v-if="questionRows.length">
        <div slot="header" class="card-header">关联题目与权重</div>
        <el-table :data="questionRows" max-height="320">
          <el-table-column label="题号" prop="questionNo" width="80" align="center" />
          <el-table-column label="试卷" prop="paperName" min-width="140" :show-overflow-tooltip="true" />
          <el-table-column label="考试日期" prop="examDate" width="110" align="center">
            <template slot-scope="scope">{{ scope.row.examDate ? String(scope.row.examDate).substring(0, 10) : '-' }}</template>
          </el-table-column>
          <el-table-column label="难度" prop="difficulty" width="80" align="center">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_difficulty" :value="scope.row.difficulty" />
            </template>
          </el-table-column>
          <el-table-column label="满分" prop="fullScore" width="70" align="center" />
          <el-table-column label="权重" width="90" align="center">
            <template slot-scope="scope">{{ formatWeight(scope.row.weight) }}</template>
          </el-table-column>
          <el-table-column label="平均得分率" width="120" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
          </el-table-column>
          <el-table-column label="作答人数" prop="studentCount" width="100" align="center" />
        </el-table>
      </el-card>

      <el-row :gutter="16" v-loading="loading">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">得分率分布 <span class="chart-hint">点击筛选学生</span></div>
            <spas-chart :option="distOption" height="360px" @chart-click="onDistClick" />
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">班级对比 <span class="chart-hint">点击筛选班级</span></div>
            <spas-chart :option="classBarOption" height="360px" @chart-click="onClassBarClick" />
          </el-card>
        </el-col>
      </el-row>

      <div class="filter-chip-bar" v-if="studentFilterLabel">
        <el-tag type="info" effect="plain" closable @close="clearStudentFilter">{{ studentFilterLabel }}</el-tag>
        <span class="chart-hint">图表筛选已生效</span>
      </div>
      <el-card shadow="never" style="margin-top: 16px" v-if="studentRows.length" ref="studentCard">
        <div slot="header" class="card-header">学生掌握明细（{{ displayedStudentRows.length }}/{{ studentRows.length }}）</div>
        <el-table :data="displayedStudentRows" max-height="420">
          <el-table-column label="学生" align="center" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span>{{ scope.row.studentName || scope.row.name || '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="班级" align="center" prop="deptName" min-width="120" :show-overflow-tooltip="true" />
          <el-table-column label="加权得分率" align="center" width="120">
            <template slot-scope="scope">
              <span :style="{ color: rateColor(scope.row.rate != null ? scope.row.rate : scope.row.weightedRate), fontWeight: 600 }">
                {{ formatRate(scope.row.rate != null ? scope.row.rate : scope.row.weightedRate) }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="练习次数" align="center" prop="attemptCount" width="100" />
          <el-table-column label="置信度" align="center" width="100">
            <template slot-scope="scope">
              <el-tag size="mini" :type="scope.row.confidenceLabel === '样本不足' ? 'danger' : (scope.row.confidenceLabel === '高' ? 'success' : 'warning')">
                {{ scope.row.confidenceLabel || formatConfidence(scope.row.confidence) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="薄弱等级" align="center" width="120">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_weak_level" :value="scope.row.weakLevel" />
            </template>
          </el-table-column>
          <el-table-column label="难度参考" align="center" width="100" v-if="hasDifficulty">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_difficulty" :value="scope.row.difficulty" />
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="100">
            <template slot-scope="scope">
              <el-button
                size="mini"
                type="text"
                icon="el-icon-data-analysis"
                @click="goStudentAnalysis(scope.row)"
                v-hasPermi="['spas:analysis:student']"
              >学情</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </template>
  </div>
</template>

<script>
import { overviewKnowledge } from '@/api/spas/analysis'
import { listPaper } from '@/api/spas/paper'
import { optionselectSubject } from '@/api/spas/subject'
import { treeKnowledge } from '@/api/spas/knowledge'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { boundClassRoleFromDepts } from '@/utils/spasTeacherRole'
import { deptTreeSelect } from '@/api/system/user'
import { applyTeachingDeptContext, canLoadSystemDeptTree } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import SpasChart from '@/components/spas/charts/SpasChart'

export default {
  name: 'SpasAnalysisKnowledge',
  dicts: ['spas_weak_level', 'spas_difficulty'],
  components: { Treeselect, SpasChart },
  data() {
    return {
      loading: false,
      subjectOptions: [],
      knowledgeOptions: [],
      deptOptions: [],
      myDepts: [],
      overview: {},
      distOption: {},
      classBarOption: {},
      childBarOption: {},
      childRows: [],
      studentRows: [],
      studentFilterBin: null,
      studentFilterDept: null,
      distBins: [],
      questionRows: [],
      analysisMode: 'window',
      scopeMode: 'all',
      paperOptions: [],
      queryParams: {
        subjectId: undefined,
        knowledgeId: undefined,
        deptId: undefined,
        window: 'semester',
        paperIds: []
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
    scopeRangeHint() {
      const mode = (this.overview && this.overview.rollupMode) || this.inferRollupMode()
      if (mode === 'all' || !this.queryParams.knowledgeId) {
        return '当前范围：全部知识点（学科下叶子知识点汇总）· 下方可按版本/章节下钻'
      }
      if (mode === 'version') {
        return '当前范围：版本分析 · 下方列出章节，可继续下钻'
      }
      if (mode === 'chapter') {
        return '当前范围：章节分析 · 下方列出知识点，可继续下钻'
      }
      return '当前范围：单个知识点'
    },
    childrenTitle() {
      return (this.overview && this.overview.childrenLabel) || '下级明细'
    },
    versionChips() {
      const roots = this.knowledgeOptions || []
      return roots.filter(n => String(n.nodeType || '') === '0').map(n => ({
        knowledgeId: n.knowledgeId,
        knowledgeName: n.knowledgeName,
        nodeType: n.nodeType
      }))
    },
    studentFilterLabel() {
      if (this.studentFilterBin) return '得分率：' + this.studentFilterBin
      if (this.studentFilterDept) return '班级：' + this.studentFilterDept
      return ''
    },
    displayedStudentRows() {
      let rows = this.studentRows || []
      if (this.studentFilterDept) {
        rows = rows.filter(r => (r.deptName || r.className || '') === this.studentFilterDept)
      }
      if (this.studentFilterBin) {
        const bins = this.distBins || []
        let b = bins.find(x => (x.name || x.label) === this.studentFilterBin)
        if (b && (b.min == null || b.max == null)) {
          const m = String(this.studentFilterBin).match(/(\d+(?:\.\d+)?)\s*[-~–]\s*(\d+(?:\.\d+)?)/)
          if (m) b = { min: Number(m[1]), max: Number(m[2]) + 0.0001 }
        }
        if (b && b.min != null) {
          const min = b.min
          const max = b.max != null ? b.max : 100
          rows = rows.filter(r => {
            const p = this.toPercent(r.rate != null ? r.rate : r.weightedRate)
            return p >= min && p < max
          })
        }
      }
      return rows
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
        ? '当前为年级/校级范围，统计含下级班级'
        : '当前为班级范围（仅本班）'
    },
    scopeBanner() {
      const winMap = { all: '全部', last30d: '近30天', last90d: '近90天', semester: '本学期' }
      let scope
      if (this.analysisMode === 'papers') {
        const n = (this.queryParams.paperIds || []).length
        scope = '口径：选卷诊断（' + n + ' 份试卷，即时聚合）'
      } else {
        const w = this.queryParams.window
        scope = '口径：时间窗=' + (winMap[w] || w) + (w === 'all' ? '（快照）' : '（窗内即时聚合）')
      }
      const note = this.overview && this.overview.scopeNote ? ('。' + this.overview.scopeNote) : ''
      return scope + '。一题多知识点按权重分摊到叶子；可选章节看汇总。色阶：<45%严重 / 45-60%薄弱 / 60-75%关注 / >=75%正常。练习<3次标「样本不足」勿下结论。' + note
    },
    hasDifficulty() {
      return this.studentRows.some(r => r.difficulty != null && r.difficulty !== '')
    },
    overviewCards() {
      const o = this.overview || {}
      const avg = o.avgRate != null ? o.avgRate : o.averageRate != null ? o.averageRate : o.weightedRate
      const studentCount = o.studentCount != null ? o.studentCount : o.totalStudents
      const weakCount = o.weakStudentCount != null ? o.weakStudentCount : o.weakCount
      const attemptAvg = o.avgAttemptCount != null ? o.avgAttemptCount : o.attemptCount
      return [
        {
          key: 'avg',
          label: '平均得分率',
          value: avg != null ? this.formatRate(avg) : '-',
          hint: '所选范围学生均值',
          tone: 'blue'
        },
        {
          key: 'stu',
          label: '覆盖学生',
          value: studentCount != null ? studentCount : '-',
          hint: '有统计记录的学生',
          tone: 'green'
        },
        {
          key: 'weak',
          label: '薄弱学生',
          value: weakCount != null ? weakCount : '-',
          hint: '关注/薄弱/严重',
          tone: 'orange'
        },
        {
          key: 'att',
          label: '平均练习次数',
          value: attemptAvg != null ? Number(attemptAvg).toFixed(1) : '-',
          hint: '关联题目作答次数',
          tone: 'red'
        }
      ]
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.knowledgeId) {
      this.queryParams.knowledgeId = Number(q.knowledgeId) || q.knowledgeId
      this.scopeMode = 'node'
    } else {
      this.scopeMode = 'all'
    }
    if (q.subjectId) {
      this.queryParams.subjectId = Number(q.subjectId) || q.subjectId
    }
    if (q.deptId) {
      this.queryParams.deptId = Number(q.deptId) || q.deptId
    }
    this.loadPapers()
    Promise.all([
      optionselectSubject().then(response => {
        this.subjectOptions = response.data || []
        if (!this.queryParams.subjectId && this.subjectOptions.length) {
          this.queryParams.subjectId = this.subjectOptions[0].subjectId
        }
      }).catch(() => {
        this.subjectOptions = []
      }),
      this.loadMyDepts().then(() => {
        if (!this.queryParams.deptId && this.preferredDeptId) {
          this.queryParams.deptId = this.preferredDeptId
        }
      })
    ]).then(() => {
      if (!this.queryParams.subjectId) {
        return
      }
      return this.loadKnowledgeTree(true)
    }).then(() => {
      if (this.queryParams.subjectId) {
        this.loadAnalysis()
      }
    }).catch(() => {})
  },
  methods: {
    inferRollupMode() {
      const id = this.queryParams.knowledgeId
      if (id == null || id === '') return 'all'
      const node = this.findKnowledgeNode(this.knowledgeOptions, id)
      const t = node ? String(node.nodeType || '') : ''
      if (t === '0') return 'version'
      if (t === '1') return 'chapter'
      return 'leaf'
    },
    findKnowledgeNode(nodes, id) {
      for (const n of nodes || []) {
        if (String(n.knowledgeId) === String(id) || String(n.id) === String(id)) return n
        const c = this.findKnowledgeNode(n.children, id)
        if (c) return c
      }
      return null
    },
    findDeptNode(nodes, id) {
      for (const n of nodes || []) {
        if (n.id === id || n.deptId === id) return n
        const c = this.findDeptNode(n.children, id)
        if (c) return c
      }
      return null
    },
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      if (this.queryParams.subjectId) {
        this.handleQuery()
      }
    },
    toPercent(rate) {
      if (rate == null || rate === '') {
        return 0
      }
      const n = Number(rate)
      if (isNaN(n)) {
        return 0
      }
      return n <= 1 ? Math.round(n * 10000) / 100 : Math.round(n * 100) / 100
    },
    formatRate(rate) {
      if (rate == null || rate === '') {
        return '-'
      }
      return this.toPercent(rate).toFixed(2) + '%'
    },
    formatConfidence(c) {
      if (c == null || c === '') return '-'
      const n = Number(c)
      if (isNaN(n)) return c
      return (n * 100).toFixed(0) + '%'
    },
    rateColor(rate) {
      const p = this.toPercent(rate)
      if (p < 45) return '#FF5A5F'
      if (p < 60) return '#D97706'
      if (p < 75) return '#D97706'
      return '#10B981'
    },
    formatWeight(weight) {
      if (weight == null || weight === '') return '-'
      const n = Number(weight)
      if (isNaN(n)) return weight
      return (n * 100).toFixed(0) + '%'
    },
    knowledgeNormalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children
      }
      const t = String(node.nodeType || '')
      const name = node.knowledgeName || ''
      let label = name
      if (t === '0') label = '[版本] ' + name
      else if (t === '1') label = '[章节] ' + name
      else if (t === '2') label = name
      return {
        id: node.knowledgeId,
        label,
        children: node.children,
        isDisabled: false,
        nodeType: node.nodeType
      }
    },
    onKnowledgeChange() {
      if (this.queryParams.knowledgeId) {
        this.scopeMode = 'node'
      }
      if (this.queryParams.subjectId) {
        this.handleQuery()
      }
    },
    onScopeModeChange(mode) {
      if (mode === 'all') {
        this.queryParams.knowledgeId = undefined
        this.handleQuery()
      }
    },
    selectScopeAll() {
      this.scopeMode = 'all'
      this.queryParams.knowledgeId = undefined
      this.handleQuery()
    },
    nodeTypeLabel(t) {
      const v = String(t || '')
      if (v === '0') return '版本'
      if (v === '1') return '章节'
      if (v === '2') return '知识点'
      return '-'
    },
    drillToChild(row) {
      if (!row || row.knowledgeId == null) return
      this.scopeMode = 'node'
      this.queryParams.knowledgeId = Number(row.knowledgeId) || row.knowledgeId
      this.handleQuery()
    },
    onChildBarClick(params) {
      const name = params && params.name
      if (!name) return
      const row = (this.childRows || []).find(r => r.knowledgeName === name)
      if (row) this.drillToChild(row)
    },
    unwrapData(res) {
      if (!res) {
        return {}
      }
      return res.data != null ? res.data : res
    },
    loadSubjects() {
      optionselectSubject().then(response => {
        this.subjectOptions = response.data || []
        if (!this.queryParams.subjectId && this.subjectOptions.length) {
          this.queryParams.subjectId = this.subjectOptions[0].subjectId
          this.loadKnowledgeTree(false)
        }
      })
    },
    loadDepts() {
      if (!canLoadSystemDeptTree()) {
        this.deptOptions = []
        return Promise.resolve()
      }
      return deptTreeSelect().then(response => {
        this.deptOptions = response.data || []
      }).catch(() => {
        this.deptOptions = []
      })
    },
    loadMyDepts() {
      return applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).catch(() => {
        this.myDepts = []
      })
    },
    loadKnowledgeTree(preserveKnowledge) {
      const keepId = preserveKnowledge ? this.queryParams.knowledgeId : undefined
      this.knowledgeOptions = []
      if (!preserveKnowledge) {
        this.queryParams.knowledgeId = undefined
      }
      if (!this.queryParams.subjectId) {
        return Promise.resolve()
      }
      return treeKnowledge(this.queryParams.subjectId).then(response => {
        this.knowledgeOptions = response.data || []
        if (keepId != null && keepId !== '') {
          this.queryParams.knowledgeId = keepId
        }
      }).catch(() => {
        this.knowledgeOptions = []
      })
    },
    handleSubjectChange() {
      this.queryParams.paperIds = []
      this.queryParams.knowledgeId = undefined
      this.loadPapers()
      this.loadKnowledgeTree(false).then(() => {
        if (this.queryParams.subjectId) {
          this.loadAnalysis()
        }
      })
    },
    onModeChange() {
      if (this.analysisMode === 'papers') {
        this.loadPapers()
      }
      if (this.queryParams.subjectId) {
        this.handleQuery()
      }
    },
    paperLabel(item) {
      const date = item.examDate ? String(item.examDate).substring(0, 10) : ''
      return (item.paperName || ('试卷' + item.paperId)) + (date ? (' \u00b7 ' + date) : '')
    },
    loadPapers() {
      const query = { pageNum: 1, pageSize: 200, status: '1' }
      if (this.queryParams.subjectId) {
        query.subjectId = this.queryParams.subjectId
      }
      return listPaper(query).then(res => {
        this.paperOptions = res.rows || []
      }).catch(() => {
        this.paperOptions = []
      })
    },
    scopeQuery() {
      const q = {
        deptId: this.queryParams.deptId,
        subjectId: this.queryParams.subjectId
      }
      if (this.analysisMode === 'papers') {
        q.paperIds = (this.queryParams.paperIds || []).join(',')
      } else {
        q.window = this.queryParams.window || 'semester'
      }
      return q
    },
    handleQuery() {
      if (!this.queryParams.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      this.loadAnalysis()
    },
    resetQuery() {
      this.analysisMode = 'window'
      this.scopeMode = 'all'
      this.queryParams.window = 'semester'
      this.queryParams.paperIds = []
      this.queryParams.deptId = this.boundClassMode ? this.preferredDeptId : undefined
      this.queryParams.knowledgeId = undefined
      this.overview = {}
      this.distOption = {}
      this.classBarOption = {}
      this.childBarOption = {}
      this.childRows = []
      this.studentRows = []
      this.questionRows = []
      if (this.queryParams.subjectId) {
        this.loadAnalysis()
      } else {
        this.loadSubjects()
      }
    },
    clearStudentFilter() {
      this.studentFilterBin = null
      this.studentFilterDept = null
    },
    scrollToStudents() {
      this.$nextTick(() => {
        const el = this.$refs.studentCard
        const node = el && (el.$el || el)
        if (node && node.scrollIntoView) node.scrollIntoView({ behavior: 'smooth', block: 'start' })
      })
    },
    onDistClick(params) {
      const name = params && params.name
      if (!name) return
      this.studentFilterDept = null
      this.studentFilterBin = name
      this.scrollToStudents()
      this.$modal.msgSuccess('已按得分率区间「' + name + '」筛选学生')
    },
    onClassBarClick(params) {
      const name = params && params.name
      if (!name) return
      this.studentFilterBin = null
      this.studentFilterDept = name
      this.scrollToStudents()
      this.$modal.msgSuccess('已按班级「' + name + '」筛选学生')
    },
    goStudentAnalysis(row) {
      const studentId = row.studentId || row.id
      if (!studentId) {
        return
      }
      const query = { studentId }
      if (this.queryParams.subjectId) {
        query.subjectId = this.queryParams.subjectId
      }
      if (this.queryParams.deptId) {
        query.deptId = this.queryParams.deptId
      }
      if (this.analysisMode === 'papers') {
        query.mode = 'papers'
        if (this.queryParams.paperIds && this.queryParams.paperIds.length) {
          query.paperIds = this.queryParams.paperIds.join(',')
        }
      } else if (this.queryParams.window) {
        query.window = this.queryParams.window
      }
      this.$router.push({ path: '/spas/analysis/student', query })
    },
    loadAnalysis() {
      if (!this.queryParams.subjectId) {
        return
      }
      if (this.scopeMode === 'all') {
        this.queryParams.knowledgeId = undefined
      }
      const knowledgeId = this.queryParams.knowledgeId
      if (this.analysisMode === 'papers' && (!this.queryParams.paperIds || !this.queryParams.paperIds.length)) {
        this.$modal.msgWarning('请先勾选试卷')
        return
      }
      const query = this.scopeQuery()
      this.loading = true
      overviewKnowledge(knowledgeId, query).then(res => {
        const raw = this.unwrapData(res) || {}
        const data = Array.isArray(raw) ? { students: raw } : raw
        this.overview = data
        this.studentRows = data.students || data.studentList || data.details || raw || []
        this.questionRows = data.questions || []
        this.childRows = data.children || []
        this.buildChildBar(this.childRows)
        this.buildDistribution(data)
        this.buildClassCompare(data)
      }).catch(() => {
        this.overview = {}
        this.studentRows = []
        this.questionRows = []
        this.childRows = []
        this.distOption = {}
        this.classBarOption = {}
        this.childBarOption = {}
        this.$modal.msgError('加载知识点分析失败')
      }).finally(() => {
        this.loading = false
      })
    },
    buildChildBar(rows) {
      const list = rows || []
      if (!list.length) {
        this.childBarOption = {
          title: { text: '暂无下级数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } }
        }
        return
      }
      const names = list.map(r => r.knowledgeName || ('#' + r.knowledgeId))
      const rates = list.map(r => {
        const n = Number(r.avgRate)
        if (isNaN(n)) return 0
        return n <= 1 ? Math.round(n * 10000) / 100 : Math.round(n * 100) / 100
      })
      const longLabel = names.some(n => String(n).length > 4) || names.length > 4
      this.childBarOption = {
        tooltip: { trigger: 'axis', formatter: p => {
          const i = p && p[0] && p[0].dataIndex
          const row = list[i] || {}
          return (row.knowledgeName || '') + '<br/>平均得分率：' + rates[i] + '%<br/>覆盖：' + (row.studentCount || 0) + ' 人'
        } },
        grid: { left: '3%', right: '4%', bottom: longLabel ? 8 : 12, top: 36, containLabel: true },
        xAxis: {
          type: 'category',
          data: names,
          axisLabel: {
            interval: 0,
            rotate: longLabel ? 32 : 0,
            fontSize: 11,
            hideOverlap: false
          }
        },
        yAxis: { type: 'value', name: '%', max: 100 },
        series: [{
          name: '平均得分率',
          type: 'bar',
          data: rates.map((v, i) => ({
            value: v,
            itemStyle: { color: this.rateColor(list[i].avgRate) }
          })),
          barMaxWidth: 36,
          label: { show: true, position: 'top', formatter: '{c}%' }
        }]
      }
    },
    buildDistribution(data) {
      let bins = data.distribution || data.scoreDistribution || data.rateBins || []
      if ((!bins || !bins.length) && this.studentRows.length) {
        const buckets = [
          { name: '0-45%', min: 0, max: 45, count: 0 },
          { name: '45-60%', min: 45, max: 60, count: 0 },
          { name: '60-75%', min: 60, max: 75, count: 0 },
          { name: '75-90%', min: 75, max: 90, count: 0 },
          { name: '90-100%', min: 90, max: 100.0001, count: 0 }
        ]
        this.studentRows.forEach(row => {
          const p = this.toPercent(row.rate != null ? row.rate : row.weightedRate)
          const b = buckets.find(x => p >= x.min && p < x.max)
          if (b) {
            b.count += 1
          }
        })
        bins = buckets
      }
      this.distBins = Array.isArray(bins) ? bins : []
      if (!bins || !bins.length) {
        this.distOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } }
        }
        return
      }
      const names = bins.map(b => b.name || b.label || b.bucket || b.range || '-')
      const counts = bins.map(b => b.count != null ? b.count : b.value != null ? b.value : 0)
      const binColors = ['#FF5A5F', '#D97706', '#CA8A04', '#10B981', '#2442ED']
      this.distOption = {
        tooltip: { trigger: 'axis' },
        grid: { left: '3%', right: '4%', bottom: '3%', top: 30, containLabel: true },
        xAxis: { type: 'category', data: names },
        yAxis: { type: 'value', name: '人数', minInterval: 1 },
        series: [{
          name: '学生数',
          type: 'bar',
          data: counts.map((c, i) => ({
            value: c,
            itemStyle: { color: binColors[i] || '#2442ED' }
          })),
          barMaxWidth: 40,
          label: { show: true, position: 'top' }
        }]
      }
    },
    buildClassCompare(data) {
      let list = data.classComparison || data.classList || data.deptStats || data.depts || []
      if (!list.length && data.avgRateByDept) {
        list = data.avgRateByDept
      }
      if (!list.length) {
        this.classBarOption = {
          title: { text: '暂无班级对比数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } }
        }
        return
      }
      const names = list.map(item => item.deptName || item.name || item.className || '-')
      const rates = list.map(item => this.toPercent(item.avgRate != null ? item.avgRate : item.rate != null ? item.rate : item.weightedRate))
      this.classBarOption = {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '4%', bottom: '3%', top: 30, containLabel: true },
        xAxis: {
          type: 'category',
          data: names,
          axisLabel: { rotate: names.length > 6 ? 30 : 0 }
        },
        yAxis: { type: 'value', name: '得分率(%)', min: 0, max: 100 },
        series: [{
          name: '平均得分率',
          type: 'bar',
          data: rates.map(r => ({
            value: r,
            itemStyle: { color: r < 45 ? '#FF5A5F' : r < 60 ? '#D97706' : r < 75 ? '#CA8A04' : '#10B981' }
          })),
          barMaxWidth: 36,
          label: { show: true, position: 'top', formatter: '{c}%' }
        }]
      }
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
.spas-analysis .card-header {
  font-weight: 600;
  color: #0F172A;
}
.overview-row {
  margin-bottom: 8px;
}
.stat-card {
  background: #fff;
  border: 1px solid #E2E8F0;
  border-radius: 10px;
  padding: 14px 16px;
  margin-bottom: 12px;
  border-left: 3px solid #2442ED;
  box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04), 0 6px 16px rgba(15, 23, 42, 0.04);
}
.stat-card.tone-blue { border-left-color: #2442ED; }
.stat-card.tone-orange { border-left-color: #D97706; }
.stat-card.tone-green { border-left-color: #10B981; }
.stat-card.tone-red { border-left-color: #FF5A5F; }
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
.mb8 { margin-bottom: 8px; }
.version-chip-bar {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 6px;
}
.version-chip-bar .chip-label {
  color: #64748B;
  font-size: 12px;
  margin-right: 4px;
}
.chart-hint {
  margin-left: 8px;
  font-size: 12px;
  font-weight: 400;
  color: #94A3B8;
}
.filter-chip-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 8px 0;
}
</style>
