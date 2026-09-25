<template>
  <div class="app-container spas-portfolio">
    <el-form :model="queryParams" size="small" :inline="true" label-width="68px">
      <el-form-item label="班级" class="class-row">
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
          placeholder="筛选班级"
          style="width: 220px"
          @input="handleDeptChange"
        />
      </el-form-item>
      <el-form-item label="学生">
        <el-select
          v-model="queryParams.studentId"
          placeholder="输入学号/姓名搜索"
          filterable
          remote
          clearable
          :remote-method="remoteStudent"
          :loading="studentLoading"
          style="width: 240px"
        >
          <el-option
            v-for="item in studentOptions"
            :key="item.studentId"
            :label="formatStudentLabel(item)"
            :value="item.studentId"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="学科">
        <el-select v-model="queryParams.subjectId" placeholder="请选择学科" clearable filterable style="width: 180px">
          <el-option
            v-for="item in subjectOptions"
            :key="item.subjectId"
            :label="item.subjectName"
            :value="item.subjectId"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="loadPortfolio" v-hasPermi="['spas:portfolio:list']">查询</el-button>
        <el-button
          type="success"
          plain
          icon="el-icon-data-analysis"
          size="mini"
          :disabled="!queryParams.studentId"
          @click="goAnalysis"
          v-hasPermi="['spas:analysis:student']"
        >学情分析</el-button>
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          :disabled="!queryParams.studentId"
          @click="handleExportReport('pdf')"
          v-hasPermi="['spas:report:export']"
        >导出报告</el-button>
        <el-button
          type="info"
          plain
          icon="el-icon-document"
          size="mini"
          :disabled="!queryParams.studentId"
          @click="handleExportReport('xlsx')"
          v-hasPermi="['spas:report:export']"
        >导出明细</el-button>
      </el-form-item>
    </el-form>

    <el-empty v-if="!queryParams.studentId" description="请选择学生后查看一生一册" />

    <div v-else v-loading="loading">
      <el-card shadow="never" class="profile-card">
        <div slot="header" class="card-header">学生档案</div>
        <el-descriptions :column="4" border size="small" v-if="portfolio.student">
          <el-descriptions-item label="学号">{{ portfolio.student.studentNo }}</el-descriptions-item>
          <el-descriptions-item label="姓名">{{ portfolio.student.studentName }}</el-descriptions-item>
          <el-descriptions-item label="待处理预警">
            <el-tag type="danger" size="mini">{{ portfolio.openWarningCount || 0 }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="进行中干预">
            <el-tag type="warning" size="mini">{{ portfolio.openInterveneCount || 0 }}</el-tag>
          </el-descriptions-item>
        </el-descriptions>
      </el-card>

      <el-alert
        v-if="summary.headline"
        :title="summary.headline"
        type="info"
        :closable="false"
        show-icon
        style="margin-top: 12px"
      />

      <el-card shadow="never" style="margin-top: 16px">
        <div slot="header" class="card-header card-header-row">
          <span>实考校次进退</span>
          <el-button type="text" size="mini" icon="el-icon-data-analysis" @click="goAnalysis" v-hasPermi="['spas:analysis:student']">查看学情详情</el-button>
        </div>
        <el-alert
          v-if="rankSummary && rankSummary.headline"
          class="mb8"
          type="info"
          :closable="false"
          show-icon
          :title="rankSummary.headline"
        />
        <el-table :data="rankSubjects" size="small" empty-text="暂无实考校次。请先在「实考校次」导入多次成绩。">
          <el-table-column label="科目" prop="subjectName" width="90" />
          <el-table-column label="校次轨迹" prop="track" min-width="160" :show-overflow-tooltip="true" />
          <el-table-column label="最近校次" width="90" align="center">
            <template slot-scope="scope">{{ scope.row.latestRank == null ? '-' : scope.row.latestRank }}</template>
          </el-table-column>
          <el-table-column label="相对总分" width="110" align="center">
            <template slot-scope="scope">
              <span v-if="scope.row.vsTotal == null">-</span>
              <span v-else :style="{ color: scope.row.vsTotal > 0 ? '#F56C6C' : (scope.row.vsTotal < 0 ? '#67C23A' : '#909399') }">
                {{ vsTotalText(scope.row) }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="较上次" width="100" align="center">
            <template slot-scope="scope">
              <span :style="{ color: rankColor(scope.row.trend) }">{{ deltaText(scope.row.stepDelta) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="结论" width="90" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="rankTag(scope.row.trend)">{{ scope.row.trendLabel || '-' }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="薄弱解释" min-width="180" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.explain || '-' }}</template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" v-if="interveneTimeline.length">
        <div slot="header" class="card-header card-header-row">
          <span>干预时间线</span>
          <el-button type="text" size="mini" icon="el-icon-s-flag" @click="goInterveneList" v-hasPermi="['spas:intervene:list']">干预中心</el-button>
        </div>
        <el-timeline>
          <el-timeline-item
            v-for="(item, idx) in interveneTimeline"
            :key="idx"
            :timestamp="parseTime(item.time)"
            :type="timelineType(item)"
            placement="top"
          >
            <p><b>{{ timelineTitle(item) }}</b></p>
            <p v-if="item.type === 'intervene_create'">基线 {{ formatRate(item.baselineRate) }} → 目标 {{ formatRate(item.targetRate) }}</p>
            <p v-if="item.type === 'coach'">{{ item.createBy || '教师' }}：{{ item.content }}</p>
            <p v-if="item.type === 'intervene_effect'">
              当前 {{ formatRate(item.effectRate) }}，增益
              <span :style="{ color: Number(item.effectDelta) > 0 ? '#10B981' : '#FF5A5F' }">{{ formatGap(item.effectDelta) }}</span>
              <el-tag v-if="item.effectPassed === '1'" type="success" size="mini" style="margin-left: 8px">达标</el-tag>
            </p>
          </el-timeline-item>
        </el-timeline>
      </el-card>

      <el-row :gutter="16" style="margin-top: 16px">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never">
            <div slot="header" class="card-header">知识点掌握雷达<span class="card-hint">点击下钻学情</span></div>
            <spas-chart :option="radarOption" height="340px" @chart-click="onRadarClick" />
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never">
            <div slot="header" class="card-header">成绩趋势<span class="card-hint">点击查看学情</span></div>
            <spas-chart :option="trendOption" height="340px" @chart-click="goAnalysis" />
          </el-card>
        </el-col>
      </el-row>

      <el-card shadow="never" style="margin-top: 16px">
        <div slot="header" class="card-header">本学期反复薄弱</div>
        <el-table :data="persistentWeak" empty-text="暂无反复薄弱（本学期）" @row-click="onKnowledgeRow">
          <el-table-column label="知识点" align="center" min-width="160">
            <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName }}</template>
          </el-table-column>
          <el-table-column label="加权得分率" align="center" width="120">
            <template slot-scope="scope">{{ formatRate(scope.row.rate != null ? scope.row.rate : scope.row.weightedRate) }}</template>
          </el-table-column>
          <el-table-column label="偏低场次" align="center" width="110">
            <template slot-scope="scope">{{ scope.row.lowPapers || 0 }}/{{ scope.row.validPapers || 0 }}</template>
          </el-table-column>
          <el-table-column label="标签" align="center" width="110">
            <template slot-scope="scope">
              <el-tag size="mini" type="danger">{{ scope.row.persistTag || '反复薄弱' }}</el-tag>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" v-if="errorCauseSummary.length">
        <div slot="header" class="card-header">错因分布</div>
        <el-table :data="errorCauseSummary" size="small" empty-text="暂无错因标签">
          <el-table-column label="错因大类" min-width="120">
            <template slot-scope="scope">{{ scope.row.errorCategoryLabel || scope.row.errorLabel || '-' }}</template>
          </el-table-column>
          <el-table-column label="题数" prop="tagCount" width="90" align="center" />
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px">
        <div slot="header" class="card-header">薄弱知识点 Top</div>
        <el-table :data="weakList" empty-text="暂无薄弱点" @row-click="onKnowledgeRow">
          <el-table-column label="知识点" align="center" min-width="160">
            <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName }}</template>
          </el-table-column>
          <el-table-column label="加权得分率" align="center" width="120">
            <template slot-scope="scope">{{ formatRate(scope.row.rate != null ? scope.row.rate : scope.row.weightedRate) }}</template>
          </el-table-column>
          <el-table-column label="薄弱等级" align="center" width="120">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_weak_level" :value="scope.row.weakLevel" />
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-row :gutter="16" style="margin-top: 16px">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never">
            <div slot="header" class="card-header">未处理预警</div>
            <el-table :data="openWarnings" empty-text="暂无预警" @row-click="goWarning">
              <el-table-column label="标题" prop="title" min-width="120" :show-overflow-tooltip="true" />
              <el-table-column label="级别" width="90" align="center">
                <template slot-scope="scope">
                  <dict-tag :options="dict.type.spas_warning_level" :value="scope.row.level" />
                </template>
              </el-table-column>
              <el-table-column label="时间" width="160" align="center">
                <template slot-scope="scope">{{ parseTime(scope.row.createTime) }}</template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never">
            <div slot="header" class="card-header card-header-row">
              <span>辅导记录</span>
              <el-button type="text" size="mini" icon="el-icon-plus" @click="openCoach" v-hasPermi="['spas:portfolio:coach', 'spas:portfolio:list']">新增</el-button>
            </div>
            <el-timeline v-if="coachLogs.length">
              <el-timeline-item
                v-for="item in coachLogs"
                :key="item.logId"
                :timestamp="parseTime(item.createTime)"
                placement="top"
              >
                <p><b>{{ item.createBy || '教师' }}</b>：{{ item.content }}</p>
                <p v-if="item.nextPlan" class="next-plan">下一步：{{ item.nextPlan }}</p>
                <p v-if="coachLinkText(item)" class="coach-link">{{ coachLinkText(item) }}</p>
              </el-timeline-item>
            </el-timeline>
            <el-empty v-else description="暂无辅导记录" :image-size="64" />
          </el-card>
        </el-col>
      </el-row>
    </div>

    <el-dialog title="新增辅导记录" :visible.sync="coachOpen" width="560px" append-to-body>
      <el-form ref="coachForm" :model="coachForm" :rules="coachRules" label-width="100px">
        <el-form-item label="关联干预">
          <el-select v-model="coachForm.interveneId" clearable filterable placeholder="可选，关联进行中干预" style="width: 100%">
            <el-option
              v-for="item in interveneOptions"
              :key="item.interveneId"
              :label="item.title || ('干预#' + item.interveneId)"
              :value="item.interveneId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="关联预警">
          <el-select v-model="coachForm.warningId" clearable filterable placeholder="可选，关联未处理预警" style="width: 100%">
            <el-option
              v-for="item in openWarnings"
              :key="item.warningId"
              :label="item.title || ('预警#' + item.warningId)"
              :value="item.warningId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="关联知识点">
          <el-select v-model="coachForm.knowledgeId" clearable filterable placeholder="可选，关联薄弱知识点" style="width: 100%">
            <el-option
              v-for="item in knowledgeOptions"
              :key="item.knowledgeId"
              :label="item.name || item.knowledgeName"
              :value="item.knowledgeId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="辅导内容" prop="content">
          <el-input v-model="coachForm.content" type="textarea" :rows="4" placeholder="请输入辅导内容" />
        </el-form-item>
        <el-form-item label="下一步计划" prop="nextPlan">
          <el-input v-model="coachForm.nextPlan" type="textarea" :rows="2" placeholder="可选" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitCoach">确 定</el-button>
        <el-button @click="coachOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getPortfolio, addCoachLog } from '@/api/spas/portfolio'
import { optionselectSubject } from '@/api/spas/subject'
import { listStudent } from '@/api/spas/student'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { boundClassRoleFromDepts } from '@/utils/spasTeacherRole'
import { applyTeachingDeptContext, canLoadSystemDeptTree } from '@/utils/spasDeptTree'
import { deptTreeSelect } from '@/api/system/user'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import SpasChart from '@/components/spas/charts/SpasChart'

export default {
  name: 'SpasPortfolio',
  dicts: ['spas_weak_level', 'spas_warning_level'],
  components: { Treeselect, SpasChart },
  data() {
    return {
      loading: false,
      subjectOptions: [],
      deptOptions: [],
      myDepts: [],
      studentOptions: [],
      studentLoading: false,
      portfolio: {},
      summary: {},
      interveneTimeline: [],
      weakList: [],
      persistentWeak: [],
      errorCauseSummary: [],
      openWarnings: [],
      coachLogs: [],
      rankSubjects: [],
      rankSummary: {},
      radarData: [],
      radarOption: {},
      trendOption: {},
      coachOpen: false,
      coachForm: {},
      coachRules: {
        content: [{ required: true, message: '辅导内容不能为空', trigger: 'blur' }]
      },
      queryParams: {
        deptId: undefined,
        studentId: undefined,
        subjectId: undefined
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
      if (id == null || id === '') return ''
      const mine = (this.myDepts || []).find(d => String(d.deptId) === String(id))
      if (mine && mine.deptName) return mine.deptName
      const node = this.findDeptNode(this.deptOptions, id)
      return node ? (node.label || node.deptName || '') : ''
    },
    boundClassRoleLabel() {
      return boundClassRoleFromDepts(this.myDepts, this.queryParams.deptId)
    },
    interveneOptions() {
      const map = {}
      ;(this.interveneTimeline || []).forEach(item => {
        if (item && item.interveneId != null && !map[item.interveneId]) {
          map[item.interveneId] = {
            interveneId: item.interveneId,
            title: item.title || ('干预#' + item.interveneId)
          }
        }
      })
      return Object.keys(map).map(k => map[k])
    },
    knowledgeOptions() {
      const map = {}
      const push = row => {
        if (!row) return
        const id = row.knowledgeId
        if (id == null || map[id]) return
        map[id] = {
          knowledgeId: id,
          name: row.name || row.knowledgeName || ('知识点#' + id)
        }
      }
      ;(this.weakList || []).forEach(push)
      ;(this.persistentWeak || []).forEach(push)
      return Object.keys(map).map(k => map[k])
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.studentId) {
      this.queryParams.studentId = Number(q.studentId) || q.studentId
    }
    if (q.subjectId) {
      this.queryParams.subjectId = Number(q.subjectId) || q.subjectId
    }
    this.loadSubjects()
    const fromRoute = !!(this.$route.query && this.$route.query.studentId)
    this.loadMyDepts().then(() => {
      if (!this.queryParams.deptId && this.preferredDeptId) {
        this.queryParams.deptId = this.preferredDeptId
      }
      return this.loadStudents()
    }).then(() => {
      if (!this.queryParams.studentId && this.studentOptions.length && !fromRoute) {
        this.queryParams.studentId = this.studentOptions[0].studentId
      }
      if (this.queryParams.studentId) {
        this.loadPortfolio()
      }
    })
  },
  methods: {
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
      this.queryParams.studentId = undefined
      this.loadStudents().then(() => {
        if (this.studentOptions.length) {
          this.queryParams.studentId = this.studentOptions[0].studentId
          this.loadPortfolio()
        } else {
          this.portfolio = {}
          this.weakList = []
          this.persistentWeak = []
          this.errorCauseSummary = []
          this.openWarnings = []
          this.coachLogs = []
          this.rankSubjects = []
          this.rankSummary = {}
          this.radarData = []
          this.radarOption = {}
          this.trendOption = {}
        }
      })
    },
    toPercent(rate) {
      if (rate == null || rate === '') return 0
      const n = Number(rate)
      if (isNaN(n)) return 0
      return n <= 1 ? Math.round(n * 10000) / 100 : Math.round(n * 100) / 100
    },
    formatRate(rate) {
      if (rate == null || rate === '') return '-'
      return this.toPercent(rate).toFixed(1) + '%'
    },
    formatGap(gap) {
      if (gap == null || gap === '') return '-'
      const n = Number(gap)
      if (isNaN(n)) return gap
      const pct = (Math.abs(n) <= 1 ? n * 100 : n)
      return (pct > 0 ? '+' : '') + pct.toFixed(2) + '%'
    },
    timelineType(item) {
      if (item.type === 'intervene_effect') return item.effectPassed === '1' ? 'success' : 'warning'
      if (item.type === 'coach') return 'primary'
      return 'info'
    },
    timelineTitle(item) {
      if (item.type === 'intervene_create') return '创建干预：' + (item.title || '')
      if (item.type === 'coach') return '辅导记录'
      if (item.type === 'intervene_effect') return '效果评估：' + (item.title || '')
      return item.title || item.type
    },
    handleExportReport(format) {
      if (!this.queryParams.studentId) {
        this.$modal.msgWarning('请先选择学生')
        return
      }
      const ext = format === 'xlsx' ? 'xlsx' : 'pdf'
      this.download(
        'spas/report/student/' + this.queryParams.studentId,
        { subjectId: this.queryParams.subjectId, format: ext },
        `student_report_${this.queryParams.studentId}_${new Date().getTime()}.${ext}`
      )
    },
    goInterveneList() {
      this.$router.push({ path: '/spas/intervene', query: { studentId: this.queryParams.studentId, status: '' } })
    },
    goWarning(row) {
      const query = { studentId: this.queryParams.studentId }
      if (row && row.warningId) query.warningId = row.warningId
      this.$router.push({ path: '/spas/warning/record', query })
    },
    onKnowledgeRow(row) {
      this.goAnalysis(row && row.knowledgeId ? { knowledgeId: row.knowledgeId } : null)
    },
    onRadarClick(params) {
      const idx = params && (params.dataIndex != null ? params.dataIndex : params.event && params.event.dataIndex)
      const row = this.radarData[idx]
      if (row && row.knowledgeId) {
        this.goAnalysis({ knowledgeId: row.knowledgeId })
        return
      }
      this.goAnalysis()
    },
    deltaText(v) {
      if (v == null || v === '') return '-'
      const n = Number(v)
      if (Number.isNaN(n)) return '-'
      if (n > 0) return '进步 ' + n
      if (n < 0) return '退步 ' + Math.abs(n)
      return '持平'
    },
    vsTotalText(row) {
      if (!row || row.vsTotal == null || row.vsTotal === '') return '-'
      const n = Number(row.vsTotal)
      if (Number.isNaN(n)) return '-'
      const label = row.biasLabel ? ' ' + row.biasLabel : ''
      if (n > 0) return '落后 ' + n + label
      if (n < 0) return '领先 ' + Math.abs(n) + label
      return '持平'
    },
    rankColor(trend) {
      if (trend === 'up') return '#16a34a'
      if (trend === 'down') return '#dc2626'
      return '#64748b'
    },
    rankTag(trend) {
      if (trend === 'up') return 'success'
      if (trend === 'down') return 'danger'
      return 'info'
    },
    formatStudentLabel(item) {
      const no = item.studentNo || ''
      const name = item.studentName || ''
      return no ? (no + ' · ' + name) : name
    },
    unwrapList(val) {
      if (!val) return []
      if (Array.isArray(val)) return val
      return []
    },
    loadSubjects() {
      return optionselectSubject().then(res => {
        this.subjectOptions = res.data || []
        if (!this.queryParams.subjectId && this.subjectOptions.length) {
          this.queryParams.subjectId = this.subjectOptions[0].subjectId
        }
      })
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
    loadStudents(keyword) {
      const params = {
        pageNum: 1,
        pageSize: this.queryParams.deptId ? 200 : 50,
        status: '0'
      }
      if (this.queryParams.deptId) params.deptId = this.queryParams.deptId
      if (keyword) {
        if (/^\d/.test(String(keyword))) {
          params.studentNo = keyword
        } else {
          params.studentName = keyword
        }
      }
      this.studentLoading = true
      return listStudent(params).then(res => {
        this.studentOptions = res.rows || res.data || []
        if (res.total > params.pageSize && !keyword && this.queryParams.deptId) {
          this.$modal.msgWarning('当前班级学生超过 ' + params.pageSize + ' 人，请使用搜索定位')
        }
      }).catch(() => {
        this.studentOptions = []
      }).finally(() => {
        this.studentLoading = false
      })
    },
    remoteStudent(query) {
      if (this.queryParams.deptId && !query) {
        this.loadStudents()
        return
      }
      if (!query && !this.queryParams.deptId) {
        this.studentOptions = []
        return
      }
      this.loadStudents(query)
    },
    handleDeptChange() {
      this.queryParams.studentId = undefined
      this.loadStudents()
    },
    goAnalysis(extra) {
      if (!this.queryParams.studentId) {
        return
      }
      const query = { studentId: this.queryParams.studentId }
      if (this.queryParams.subjectId) {
        query.subjectId = this.queryParams.subjectId
      }
      if (this.queryParams.deptId) {
        query.deptId = this.queryParams.deptId
      }
      if (extra && typeof extra === 'object' && extra.knowledgeId) {
        query.knowledgeId = extra.knowledgeId
      }
      this.$router.push({ path: '/spas/analysis/student', query })
    },
    loadPortfolio() {
      if (!this.queryParams.studentId) {
        this.$modal.msgWarning('请先选择学生')
        return
      }
      this.loading = true
      getPortfolio(this.queryParams.studentId, { subjectId: this.queryParams.subjectId }).then(res => {
        const data = res.data || {}
        this.portfolio = data
        this.summary = data.summary || {}
        this.interveneTimeline = this.unwrapList(data.interveneTimeline)
        this.weakList = this.unwrapList(data.weakTop)
        this.persistentWeak = this.unwrapList(data.persistentWeak)
        this.errorCauseSummary = this.unwrapList(data.errorCauseSummary)
        this.openWarnings = this.unwrapList(data.openWarnings)
        this.coachLogs = this.unwrapList(data.coachLogs)
        const examRank = data.examRank || {}
        this.rankSubjects = this.unwrapList(examRank.subjects)
        this.rankSummary = examRank.summary || {}
        this.buildRadar(this.unwrapList(data.radar))
        this.buildTrend(this.unwrapList(data.trend))
      }).catch(() => {
        this.$modal.msgError('加载一生一册失败')
        this.portfolio = {}
        this.summary = {}
        this.interveneTimeline = []
        this.weakList = []
        this.persistentWeak = []
        this.errorCauseSummary = []
        this.openWarnings = []
        this.coachLogs = []
        this.rankSubjects = []
        this.rankSummary = {}
        this.radarData = []
        this.radarOption = {}
        this.trendOption = {}
      }).finally(() => {
        this.loading = false
      })
    },
    buildRadar(list) {
      this.radarData = list || []
      if (!list.length) {
        this.radarOption = { title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } } }
        return
      }
      const values = list.map(i => this.toPercent(i.rate != null ? i.rate : i.weightedRate))
      const classValues = list.map(i => {
        if (i.classAvgRate == null && i.classRate == null) return null
        return this.toPercent(i.classAvgRate != null ? i.classAvgRate : i.classRate)
      })
      const hasClass = classValues.some(v => v != null)
      const seriesData = [{ value: values, name: '本人' }]
      if (hasClass) {
        seriesData.push({ value: classValues.map(v => (v == null ? 0 : v)), name: '班级均值', lineStyle: { type: 'dashed' }, areaStyle: { opacity: 0.08 } })
      }
      this.radarOption = {
        color: ['#2442ED', '#94A3B8'],
        tooltip: {},
        legend: hasClass ? { data: ['本人', '班级均值'], bottom: 0 } : undefined,
        radar: { indicator: list.map(i => ({ name: i.name || i.knowledgeName || '-', max: 100 })), radius: '62%', center: ['50%', '48%'] },
        series: [{ type: 'radar', areaStyle: { opacity: 0.25 }, data: seriesData }]
      }
    },
    buildTrend(list) {
      if (!list.length) {
        this.trendOption = { title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } } }
        return
      }
      const sorted = list.slice().sort((a, b) => String(a.examDate || '').localeCompare(String(b.examDate || '')))
      const classData = sorted.map(i => i.classAvgRate == null ? null : this.toPercent(i.classAvgRate))
      const hasClass = classData.some(v => v != null)
      const series = [{
        name: '本人',
        type: 'line',
        smooth: true,
        data: sorted.map(i => this.toPercent(i.totalRate != null ? i.totalRate : i.avgRate != null ? i.avgRate : i.rate)),
        itemStyle: { color: '#2442ED' },
        lineStyle: { color: '#2442ED' },
        areaStyle: { opacity: 0.12, color: 'rgba(36, 66, 237, 0.18)' },
        markLine: { silent: true, data: [{ yAxis: 60, name: '60%' }] }
      }]
      if (hasClass) {
        series.push({
          name: '班级均分',
          type: 'line',
          smooth: true,
          data: classData,
          itemStyle: { color: '#94A3B8' },
          lineStyle: { color: '#94A3B8', type: 'dashed' }
        })
      }
      this.trendOption = {
        tooltip: { trigger: 'axis' },
        legend: hasClass ? { data: ['本人', '班级均分'], bottom: 0 } : undefined,
        grid: { left: '3%', right: '4%', bottom: hasClass ? 36 : 8, top: 30, containLabel: true },
        xAxis: { type: 'category', data: sorted.map(i => i.paperName || i.name || '-') },
        yAxis: { type: 'value', name: '%', min: 0, max: 100 },
        series
      }
    },
    openCoach() {
      this.coachForm = {
        studentId: this.queryParams.studentId,
        content: undefined,
        nextPlan: undefined,
        interveneId: undefined,
        warningId: undefined,
        knowledgeId: undefined
      }
      this.coachOpen = true
    },
    coachLinkText(item) {
      if (!item) return ''
      const parts = []
      if (item.interveneId) parts.push('干预#' + item.interveneId)
      if (item.warningId) parts.push('预警#' + item.warningId)
      if (item.knowledgeId) {
        const kp = (this.knowledgeOptions || []).find(k => k.knowledgeId === item.knowledgeId)
        parts.push(kp ? ('知识点：' + kp.name) : ('知识点#' + item.knowledgeId))
      }
      return parts.length ? ('关联：' + parts.join(' · ')) : ''
    },
    submitCoach() {
      this.$refs['coachForm'].validate(valid => {
        if (!valid) return
        const payload = Object.assign({}, this.coachForm)
        if (!payload.interveneId) delete payload.interveneId
        if (!payload.warningId) delete payload.warningId
        if (!payload.knowledgeId) delete payload.knowledgeId
        addCoachLog(payload).then(() => {
          this.$modal.msgSuccess('已保存')
          this.coachOpen = false
          this.loadPortfolio()
        })
      })
    }
  }
}
</script>

<style scoped>
.spas-portfolio >>> .el-form--inline .class-row.el-form-item {
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
.card-header-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
.card-hint {
  margin-left: 8px;
  color: #94a3b8;
  font-size: 12px;
  font-weight: normal;
}
.mb8 {
  margin-bottom: 8px;
}
.spas-portfolio .el-timeline-item__content p {
  margin: 0 0 4px;
  color: #334155;
  line-height: 1.55;
  font-size: 13px;
}
.spas-portfolio .coach-link,
.spas-portfolio .next-plan {
  color: #64748b;
  font-size: 12px;
}
.spas-portfolio .el-table {
  cursor: default;
}
</style>

