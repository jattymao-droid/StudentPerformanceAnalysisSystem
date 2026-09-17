<template>
  <div class="app-container spas-analysis">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
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
      <el-form-item label="时间窗" prop="window">
        <el-select v-model="queryParams.window" style="width: 140px" @change="handleQuery">
          <el-option label="全部" value="all" />
          <el-option label="近30天" value="last30d" />
          <el-option label="近90天" value="last90d" />
          <el-option label="本学期" value="semester" />
        </el-select>
      </el-form-item>
      <el-form-item label="班级" prop="deptId">
        <treeselect
          v-model="queryParams.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="筛选班级"
          style="width: 220px"
          @input="handleDeptChange"
        />
      </el-form-item>
      <el-form-item v-if="myDepts.length" label="快捷">
        <el-button-group>
          <el-button
            v-for="d in myDepts"
            :key="d.deptId"
            size="mini"
            :type="queryParams.deptId === d.deptId ? 'primary' : 'default'"
            @click="selectMyDept(d.deptId)"
          >{{ d.deptName }}{{ d.primary ? '·主' : '' }}</el-button>
        </el-button-group>
      </el-form-item>
      <el-form-item label="学生" prop="studentId">
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
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['spas:analysis:student']">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        <el-button
          type="warning"
          plain
          icon="el-icon-refresh-right"
          size="mini"
          :loading="recalcLoading"
          :disabled="!queryParams.studentId"
          @click="handleRecalc"
          v-hasPermi="['spas:analysis:student']"
        >重新计算</el-button>
        <el-button
          type="success"
          plain
          icon="el-icon-notebook-2"
          size="mini"
          :disabled="!queryParams.studentId"
          @click="goPortfolio"
          v-hasPermi="['spas:portfolio:list']"
        >一生一册</el-button>
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          :disabled="!queryParams.studentId"
          :loading="exportLoading"
          @click="handleExportReport('pdf')"
          v-hasPermi="['spas:report:export']"
        >导出报告</el-button>
        <el-button
          type="info"
          plain
          icon="el-icon-document"
          size="mini"
          :disabled="!queryParams.studentId"
          :loading="exportLoading"
          @click="handleExportReport('xlsx')"
          v-hasPermi="['spas:report:export']"
        >导出明细</el-button>
      </el-form-item>
    </el-form>

    <el-empty v-if="!queryParams.studentId" description="请选择学生后查看学情分析" />

    <template v-else>
      <el-alert
        v-if="summary.headline"
        :title="summary.headline"
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
        title="指标说明：加权得分率 = Σ(得分率×知识点权重×难度系数×近因衰减) / Σ(权重×难度×近因)；练习次数不足时不判定薄弱；置信度随练习次数升高。"
      />
      <el-row :gutter="12" class="overview-row" v-loading="loading">
        <el-col :xs="12" :sm="8" :md="4" v-for="card in summaryCards" :key="card.key">
          <div class="stat-card" :class="'tone-' + card.tone">
            <div class="stat-label">{{ card.label }}</div>
            <div class="stat-value">{{ card.value }}</div>
            <div class="stat-hint" v-if="card.hint">{{ card.hint }}</div>
          </div>
        </el-col>
      </el-row>

      <el-row :gutter="16" v-loading="loading" style="margin-top: 8px">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">知识点掌握雷达（本人 vs 班级）</div>
            <spas-chart :option="radarOption" height="360px" />
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">成绩趋势（本人 vs 班级）</div>
            <spas-chart :option="trendOption" height="360px" />
          </el-card>
        </el-col>
      </el-row>

      <el-row :gutter="16" style="margin-top: 16px" v-loading="loading">
        <el-col :span="24">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">薄弱知识点 Top</div>
            <spas-chart :option="weakBarOption" height="320px" />
          </el-card>
      <el-card shadow="never" style="margin-top: 16px" class="chart-card chapter-radar-card">
        <div slot="header" class="card-header">章节汇总</div>

        <el-alert class="mb8 chapter-formula-tip" type="info" :closable="false" show-icon
          title="章节得分率 = attempt-weighted avg(leaf weighted_rate)" />
        <spas-chart :option="chapterRadarOption" height="320px" />
      </el-card>

        </el-col>
      </el-row>

      <el-card shadow="never" style="margin-top: 16px">
        <div slot="header" class="card-header">薄弱知识点明细</div>
        <el-table :data="weakList" v-loading="loading" empty-text="暂无薄弱知识点数据">
          <el-table-column label="知识点" align="center" prop="name" min-width="160" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span>{{ scope.row.name || scope.row.knowledgeName }}</span>
            </template>
          </el-table-column>
          <el-table-column label="加权得分率" align="center" min-width="110">
            <template slot-scope="scope">
              <span>{{ formatRate(scope.row.rate != null ? scope.row.rate : scope.row.weightedRate) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="班级均分" align="center" width="100">
            <template slot-scope="scope">{{ formatRate(scope.row.classAvgRate) }}</template>
          </el-table-column>
          <el-table-column label="与班差" align="center" width="100">
            <template slot-scope="scope">
              <span :style="{ color: gapColor(scope.row.gap) }">{{ formatGap(scope.row.gap) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="练习次数" align="center" prop="attemptCount" width="90">
            <template slot-scope="scope">
              <span>{{ scope.row.attemptCount != null ? scope.row.attemptCount : '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="置信度" align="center" width="90">
            <template slot-scope="scope">{{ formatConfidence(scope.row.confidence) }}</template>
          </el-table-column>
          <el-table-column label="薄弱等级" align="center" width="110">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_weak_level" :value="scope.row.weakLevel" />
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="160">
            <template slot-scope="scope">
              <el-button size="mini" type="text" icon="el-icon-view" @click="openKnowledgeDrill(scope.row)">题目</el-button>
              <el-button
                size="mini"
                type="text"
                icon="el-icon-s-flag"
                @click="startIntervene(scope.row)"
                v-hasPermi="['spas:intervene:add']"
              >干预</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </template>

    <el-drawer :title="drillTitle" :visible.sync="drillOpen" size="640px" append-to-body>
      <el-table v-loading="drillLoading" :data="drillRows" empty-text="暂无题目明细">
        <el-table-column label="试卷" prop="paperName" min-width="110" :show-overflow-tooltip="true" />
        <el-table-column label="题号" prop="questionNo" width="70" align="center" />
        <el-table-column label="本题知识点" min-width="160" :show-overflow-tooltip="true">
          <template slot-scope="scope">{{ scope.row.knowledgeBindings || scope.row.knowledgeName || '-' }}</template>
        </el-table-column>
        <el-table-column label="本点权重" width="80" align="center">
          <template slot-scope="scope">{{ formatWeight(scope.row.weight) }}</template>
        </el-table-column>
        <el-table-column label="分摊得分率" width="100" align="center">
          <template slot-scope="scope">{{ formatRate(scope.row.attributedRate) }}</template>
        </el-table-column>
        <el-table-column label="得分" width="70" align="center">
          <template slot-scope="scope">{{ scope.row.score != null ? scope.row.score : '-' }}</template>
        </el-table-column>
        <el-table-column label="得分率" width="80" align="center">
          <template slot-scope="scope">{{ formatRate(scope.row.rate) }}</template>
        </el-table-column>
      </el-table>
    </el-drawer>
  </div>
</template>

<script>
import { summaryStudent, radarStudent, trendStudent, weakTopStudent, recalcStudent, studentKnowledgeQuestions, chapterRadarStudent } from '@/api/spas/analysis'
import { addIntervene } from '@/api/spas/intervene'
import { optionselectSubject } from '@/api/spas/subject'
import { listStudent } from '@/api/spas/student'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import SpasChart from '@/components/spas/charts/SpasChart'

export default {
  name: 'SpasAnalysisStudent',
  dicts: ['spas_weak_level'],
  components: { Treeselect, SpasChart },
  data() {
    return {
      loading: false,
      recalcLoading: false,
      exportLoading: false,
      chapterRadar: [],
      subjectOptions: [],
      deptOptions: [],
      myDepts: [],
      studentOptions: [],
      studentLoading: false,
      weakList: [],
      summary: {},
      radarOption: {},
      trendOption: {},
      weakBarOption: {},
      drillOpen: false,
      drillLoading: false,
      drillRows: [],
      drillTitle: '题目明细',
      queryParams: {
        window: 'all',
        subjectId: undefined,
        deptId: undefined,
        studentId: undefined,
        limit: 10
      }
    }
  },
  computed: {
    chapterRadarOption() {
      const rows = this.chapterRadar || []
      const names = rows.map(r => r.name || r.knowledgeName || '-')
      const rates = rows.map(r => {
        const v = Number(r.rate)
        if (isNaN(v)) return 0
        return v <= 1 ? +(v * 100).toFixed(1) : +v.toFixed(1)
      })
      return {
        tooltip: { trigger: 'axis' },
        grid: { left: 40, right: 20, top: 30, bottom: 40 },
        xAxis: { type: 'category', data: names, axisLabel: { rotate: 30 } },
        yAxis: { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } },
        series: [{ type: 'bar', data: rates, name: '章节' }]
      }
    },
    summaryCards() {
      const s = this.summary || {}
      return [
        { key: 'rate', label: '综合得分率', value: this.formatRate(s.overallRate), hint: '练习次数加权', tone: 'blue' },
        { key: 'class', label: '班级均分', value: this.formatRate(s.classAvgRate), hint: '同班同学均值', tone: 'green' },
        { key: 'gap', label: '与班差', value: this.formatGap(s.gap), hint: '负值表示偏低', tone: 'orange' },
        { key: 'severe', label: '严重知识点', value: s.severeCount != null ? s.severeCount : '-', hint: '需优先干预', tone: 'red' },
        { key: 'weak', label: '薄弱知识点', value: s.weakCount != null ? s.weakCount : '-', hint: '薄弱等级', tone: 'orange' },
        { key: 'conf', label: '置信度', value: this.formatConfidence(s.confidence), hint: '样本充分度', tone: 'purple' }
      ]
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
    if (q.deptId) {
      this.queryParams.deptId = Number(q.deptId) || q.deptId
    }
    this.loadSubjects()
    this.loadDepts()
    const fromRoute = !!(this.$route.query && (this.$route.query.studentId || this.$route.query.deptId))
    this.loadMyDepts().then(() => {
      if (!this.queryParams.deptId && this.myDepts.length && !fromRoute) {
        this.queryParams.deptId = this.myDepts[0].deptId
      }
      return this.loadStudents()
    }).then(() => {
      if (!this.queryParams.studentId && this.studentOptions.length && !this.$route.query.studentId) {
        this.queryParams.studentId = this.studentOptions[0].studentId
      }
      if (this.queryParams.studentId) {
        this.loadAnalysis()
      }
    })
  },
  methods: {
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      this.queryParams.studentId = undefined
      this.loadStudents().then(() => {
        if (this.studentOptions.length) {
          this.queryParams.studentId = this.studentOptions[0].studentId
          this.loadAnalysis()
        } else {
          this.weakList = []
          this.radarOption = {}
          this.trendOption = {}
          this.weakBarOption = {}
        }
      })
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
    formatGap(gap) {
      if (gap == null || gap === '') return '-'
      const n = Number(gap)
      if (isNaN(n)) return gap
      const pct = (n <= 1 && n >= -1 ? n * 100 : n)
      const sign = pct > 0 ? '+' : ''
      return sign + pct.toFixed(2) + '%'
    },
    formatConfidence(c) {
      if (c == null || c === '') return '-'
      const n = Number(c)
      if (isNaN(n)) return c
      return (n * 100).toFixed(0) + '%'
    },
    gapColor(gap) {
      const n = Number(gap)
      if (isNaN(n)) return undefined
      if (n < -0.05) return '#F56C6C'
      if (n > 0.05) return '#67C23A'
      return '#909399'
    },
    formatWeight(weight) {
      if (weight == null || weight === '') return '-'
      const n = Number(weight)
      if (isNaN(n)) return weight
      return (n * 100).toFixed(0) + '%'
    },
    formatStudentLabel(item) {
      const no = item.studentNo || ''
      const name = item.studentName || ''
      return no ? (no + ' · ' + name) : name
    },
    unwrapList(res) {
      if (!res) {
        return []
      }
      if (Array.isArray(res.data)) {
        return res.data
      }
      if (Array.isArray(res.rows)) {
        return res.rows
      }
      return []
    },
    loadSubjects() {
      return optionselectSubject().then(response => {
        this.subjectOptions = response.data || []
        if (!this.queryParams.subjectId && this.subjectOptions.length) {
          this.queryParams.subjectId = this.subjectOptions[0].subjectId
        }
      })
    },
    loadDepts() {
      return deptTreeSelect().then(response => {
        this.deptOptions = response.data || []
      })
    },
    loadMyDepts() {
      return listMyTeachingDepts().then(res => {
        this.myDepts = res.data || []
      }).catch(() => {
        this.myDepts = []
      })
    },
    loadStudents(keyword) {
      const params = {
        pageNum: 1,
        pageSize: this.queryParams.deptId ? 200 : 50,
        status: '0'
      }
      if (this.queryParams.deptId) {
        params.deptId = this.queryParams.deptId
      }
      if (keyword) {
        if (/^\d/.test(String(keyword))) {
          params.studentNo = keyword
        } else {
          params.studentName = keyword
        }
      }
      this.studentLoading = true
      return listStudent(params).then(response => {
        this.studentOptions = response.rows || response.data || []
        if (response.total > params.pageSize && !keyword && this.queryParams.deptId) {
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
    handleSubjectChange() {
      // keep student; refresh charts when student is selected
      if (this.queryParams.studentId) {
        this.loadAnalysis()
      }
    },
    handleDeptChange() {
      this.queryParams.studentId = undefined
      this.loadStudents()
    },
    handleQuery() {
      if (!this.queryParams.studentId) {
        this.$modal.msgWarning('请先选择学生')
        return
      }
      this.loadAnalysis()
    },
    resetQuery() {
      this.queryParams.deptId = undefined
      this.queryParams.studentId = undefined
      this.weakList = []
      this.radarOption = {}
      this.trendOption = {}
      this.weakBarOption = {}
      this.loadSubjects()
      this.loadStudents()
    },
    handleRecalc() {
      if (!this.queryParams.studentId) {
        return
      }
      this.$modal.confirm('确认重新计算该学生的知识点统计？').then(() => {
        this.recalcLoading = true
        return recalcStudent(this.queryParams.studentId)
      }).then(() => {
        this.$modal.msgSuccess('重算完成')
        this.loadAnalysis()
      }).catch(() => {}).finally(() => {
        this.recalcLoading = false
      })
    },
    openKnowledgeDrill(row) {
      const knowledgeId = row.knowledgeId || row.id
      if (!knowledgeId || !this.queryParams.studentId) return
      this.drillTitle = (row.name || row.knowledgeName || '知识点') + ' - 题目明细'
      this.drillOpen = true
      this.drillLoading = true
      studentKnowledgeQuestions(this.queryParams.studentId, knowledgeId, {
        subjectId: this.queryParams.subjectId
      }).then(res => {
        this.drillRows = this.unwrapList(res)
      }).catch(() => {
        this.drillRows = []
      }).finally(() => {
        this.drillLoading = false
      })
    },
    goPortfolio() {
      if (!this.queryParams.studentId) {
        return
      }
      const query = { studentId: this.queryParams.studentId }
      if (this.queryParams.subjectId) {
        query.subjectId = this.queryParams.subjectId
      }
      this.$router.push({ path: '/spas/portfolio', query })
    },
    handleExportReport(format) {
      if (!this.queryParams.studentId) {
        this.$modal.msgWarning('请先选择学生')
        return
      }
      const ext = format === 'xlsx' ? 'xlsx' : 'pdf'
      this.exportLoading = true
      this.download(
        'spas/report/student/' + this.queryParams.studentId,
        { subjectId: this.queryParams.subjectId, format: ext },
        `student_report_${this.queryParams.studentId}_${new Date().getTime()}.${ext}`
      ).finally(() => {
        this.exportLoading = false
      })
    },
    startIntervene(row) {
      if (!this.queryParams.studentId) return
      const knowledgeId = row.knowledgeId || row.id
      this.$modal.confirm('为该薄弱知识点创建干预任务并冻结基线？').then(() => {
        return addIntervene({
          studentId: this.queryParams.studentId,
          subjectId: this.queryParams.subjectId,
          sourceType: '2',
          sourceId: knowledgeId,
          knowledgeIds: knowledgeId ? String(knowledgeId) : undefined,
          title: '薄弱干预：' + (row.name || row.knowledgeName || knowledgeId),
          targetRate: 0.6
        })
      }).then(res => {
        this.$modal.msgSuccess('干预任务已创建')
        this.$router.push({ path: '/spas/intervene', query: { status: '0' } })
      }).catch(() => {})
    },
    loadChapterRadar() {
      if (!this.queryParams.studentId) return
      return chapterRadarStudent(this.queryParams.studentId, {
        subjectId: this.queryParams.subjectId
      }).then(res => {
        const data = (res && res.data != null) ? res.data : res
        this.chapterRadar = Array.isArray(data) ? data : []
      }).catch(() => { this.chapterRadar = [] })
    },
    loadAnalysis() {
      const studentId = this.queryParams.studentId
      if (!studentId) {
        return
      }
      const query = {
        subjectId: this.queryParams.subjectId,
        window: this.queryParams.window,
        limit: this.queryParams.limit
      }
      this.loading = true
      Promise.all([
        summaryStudent(studentId, { subjectId: this.queryParams.subjectId, window: this.queryParams.window }),
        radarStudent(studentId, query),
        trendStudent(studentId, { subjectId: this.queryParams.subjectId, window: this.queryParams.window }),
        weakTopStudent(studentId, query)
      ]).then(([summaryRes, radarRes, trendRes, weakRes]) => {
        this.summary = (summaryRes && summaryRes.data) ? summaryRes.data : {}
        this.buildRadar(this.unwrapList(radarRes))
        this.buildTrend(this.unwrapList(trendRes))
        const weak = this.unwrapList(weakRes)
        this.weakList = weak
        this.loadChapterRadar()
        this.buildWeakBar(weak)
      }).catch(() => {
        this.summary = {}
        this.radarOption = {}
        this.trendOption = {}
        this.weakBarOption = {}
        this.weakList = []
        this.$modal.msgError('加载学生分析失败')
      }).finally(() => {
        this.loading = false
      })
    },
    buildRadar(list) {
      if (!list.length) {
        this.radarOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } }
        }
        return
      }
      const indicator = list.map(item => ({
        name: item.name || item.knowledgeName || '-',
        max: 100
      }))
      const values = list.map(item => this.toPercent(item.rate != null ? item.rate : item.weightedRate))
      const classValues = list.map(item => {
        if (item.classAvgRate == null && item.classRate == null) return null
        return this.toPercent(item.classAvgRate != null ? item.classAvgRate : item.classRate)
      })
      const hasClass = classValues.some(v => v != null)
      const seriesData = [{ value: values, name: '本人' }]
      if (hasClass) {
        seriesData.push({
          value: classValues.map(v => (v == null ? 0 : v)),
          name: '班级均值',
          lineStyle: { type: 'dashed' },
          areaStyle: { opacity: 0.08 }
        })
      }
      this.radarOption = {
        color: ['#7B6CF6', '#A8A3BD'],
        tooltip: {},
        legend: hasClass ? { data: ['本人', '班级均值'], bottom: 0 } : undefined,
        radar: { indicator, radius: '62%', center: ['50%', '48%'] },
        series: [{ type: 'radar', areaStyle: { opacity: 0.25 }, data: seriesData }]
      }
    },
    buildTrend(list) {
      if (!list.length) {
        this.trendOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } }
        }
        return
      }
      const sorted = list.slice().sort((a, b) => {
        const da = a.examDate || a.paperDate || ''
        const db = b.examDate || b.paperDate || ''
        return String(da).localeCompare(String(db))
      })
      const xData = sorted.map(item => item.paperName || item.name || item.examDate || '-')
      const yData = sorted.map(item => this.toPercent(item.totalRate != null ? item.totalRate : item.avgRate != null ? item.avgRate : item.rate))
      const classData = sorted.map(item => item.classAvgRate == null ? null : this.toPercent(item.classAvgRate))
      const hasClass = classData.some(v => v != null)
      const series = [{
        name: '本人',
        type: 'line',
        smooth: true,
        data: yData,
        itemStyle: { color: '#7B6CF6' },
        lineStyle: { color: '#7B6CF6' },
        areaStyle: { opacity: 0.12, color: 'rgba(123, 108, 246, 0.18)' },
        markLine: {
          silent: true,
          data: [{ yAxis: 60, name: '参考线60%' }]
        }
      }]
      if (hasClass) {
        series.push({
          name: '班级均分',
          type: 'line',
          smooth: true,
          data: classData,
          itemStyle: { color: '#A8A3BD' },
          lineStyle: { color: '#A8A3BD', type: 'dashed' }
        })
      }
      this.trendOption = {
        tooltip: { trigger: 'axis' },
        legend: hasClass ? { data: ['本人', '班级均分'], bottom: 0 } : undefined,
        grid: { left: '3%', right: '4%', bottom: hasClass ? 36 : 8, top: 40, containLabel: true },
        xAxis: {
          type: 'category',
          data: xData,
          axisLabel: { rotate: xData.length > 6 ? 30 : 0, interval: 0 }
        },
        yAxis: {
          type: 'value',
          name: '整卷得分率(%)',
          min: 0,
          max: 100
        },
        series
      }
    },
    buildWeakBar(list) {
      if (!list.length) {
        this.weakBarOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } }
        }
        return
      }
      const names = list.map(item => item.name || item.knowledgeName || '-').reverse()
      const rates = list.map(item => this.toPercent(item.rate != null ? item.rate : item.weightedRate)).reverse()
      this.weakBarOption = {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '6%', bottom: '3%', top: 20, containLabel: true },
        xAxis: { type: 'value', name: '%', max: 100 },
        yAxis: { type: 'category', data: names },
        series: [{
          name: '加权得分率',
          type: 'bar',
          data: rates,
          barMaxWidth: 28,
          itemStyle: {
            color: params => {
              const v = params.value
              if (v < 45) return '#F56C6C'
              if (v < 60) return '#E6A23C'
              if (v < 75) return '#F2C96D'
              return '#67C23A'
            }
          },
          label: { show: true, position: 'right', formatter: '{c}%' }
        }]
      }
    }
  }
}
</script>

<style scoped>
.spas-analysis .chart-card {
  margin-bottom: 0;
}
.spas-analysis .card-header {
  font-weight: 600;
  color: #2C2940;
}
.spas-analysis .el-card {
  border-radius: 14px;
}
.overview-row {
  margin-bottom: 8px;
}
.stat-card {
  background: #fff;
  border: 1px solid #E8E4F5;
  border-radius: 14px;
  padding: 14px 16px;
  margin-bottom: 12px;
  border-left: 3px solid #7B6CF6;
  box-shadow: 0 8px 24px rgba(91, 75, 219, 0.06);
}
.stat-card.tone-blue { border-left-color: #7B6CF6; }
.stat-card.tone-orange { border-left-color: #E6A23C; }
.stat-card.tone-green { border-left-color: #67C23A; }
.stat-card.tone-red { border-left-color: #F56C6C; }
.stat-card.tone-purple { border-left-color: #9B8AFB; }
.stat-label {
  color: #6B6685;
  font-size: 12px;
}
.stat-value {
  margin-top: 6px;
  font-size: 22px;
  font-weight: 600;
  color: #2C2940;
}
.stat-hint {
  margin-top: 4px;
  color: #A8A3BD;
  font-size: 11px;
}
.mb8 { margin-bottom: 8px; }
</style>
