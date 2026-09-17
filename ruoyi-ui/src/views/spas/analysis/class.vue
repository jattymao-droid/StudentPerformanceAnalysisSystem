<template>
  <div class="app-container spas-analysis">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
      <el-form-item label="班级" prop="deptId">
        <treeselect
          v-model="queryParams.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="请选择班级/部门"
          style="width: 240px"
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
      <el-form-item label="学科" prop="subjectId">
        <el-select
          v-model="queryParams.subjectId"
          placeholder="请选择学科"
          clearable
          filterable
          style="width: 180px"
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
        <el-select v-model="queryParams.window" style="width: 140px">
          <el-option label="全部" value="all" />
          <el-option label="近30天" value="last30d" />
          <el-option label="近90天" value="last90d" />
          <el-option label="本学期" value="semester" />
        </el-select>
      </el-form-item>
<el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['spas:analysis:class']">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        <el-button
          type="warning"
          plain
          icon="el-icon-refresh-right"
          size="mini"
          :loading="recalcLoading"
          :disabled="!queryParams.deptId"
          @click="handleRecalcDept"
          v-hasPermi="['spas:analysis:class']"
        >按新算法重算</el-button>
        <el-button
          type="success"
          plain
          icon="el-icon-download"
          size="mini"
          :disabled="!queryParams.deptId"
          :loading="exportLoading"
          @click="handleExportReport('pdf')"
          v-hasPermi="['spas:report:export']"
        >导出报告</el-button>
        <el-button
          type="info"
          plain
          icon="el-icon-document"
          size="mini"
          :disabled="!queryParams.deptId"
          :loading="exportLoading"
          @click="handleExportReport('xlsx')"
          v-hasPermi="['spas:report:export']"
        >导出明细</el-button>
      </el-form-item>
    </el-form>

    <el-empty v-if="!queryParams.deptId" description="请选择班级后查看班级学情" />

    <template v-else>
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
        title="班均得分率按「学生综合得分率（练习次数加权）」再求班级平均，与学生页、预警口径一致。色阶：&lt;45%严重 / 45–60%薄弱 / 60–75%关注 / ≥75%正常。"
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

            <el-row :gutter="16" style="margin-top: 8px" v-loading="loading">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card class-trend-card">
            <div slot="header" class="card-header">班级趋势</div>
            <spas-chart :option="classTrendOption" height="360px" />
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">章节汇总</div>

        <el-alert class="mb8 chapter-formula-tip" type="info" :closable="false" show-icon
          title="章节得分率 = attempt-weighted avg(leaf weighted_rate)" />
            <spas-chart :option="chapterBarOption" height="360px" />
          </el-card>
        </el-col>
      </el-row>

<el-row :gutter="16" style="margin-top: 8px" v-loading="loading">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">班级薄弱知识点 Top</div>
            <spas-chart :option="weakBarOption" height="360px" @chart-click="onWeakBarClick" />
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">学生 × 知识点热力图（点击可下钻）</div>
            <spas-chart :option="heatmapOption" height="360px" @chart-click="onHeatmapClick" />
          </el-card>
        </el-col>
      </el-row>

      <el-card shadow="never" style="margin-top: 16px" v-loading="loading">
        <div slot="header" class="card-header">学生综合排名（弱→强，点击可查看学情）</div>
        <el-table :data="studentRanking" empty-text="暂无数据" max-height="360" @row-click="onRankingClick">
          <el-table-column type="index" label="#" width="50" align="center" />
          <el-table-column label="学号" prop="studentNo" width="120" />
          <el-table-column label="姓名" prop="studentName" width="100" />
          <el-table-column label="综合得分率" width="120" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.overallRate) }}</template>
          </el-table-column>
          <el-table-column label="薄弱点数" width="90" align="center" prop="weakKnowledgeCount" />
          <el-table-column label="严重点数" width="90" align="center" prop="severeKnowledgeCount" />
          <el-table-column label="练习次数" width="90" align="center" prop="totalAttempts" />
          <el-table-column label="操作" width="90" align="center">
            <template slot-scope="scope">
              <el-button type="text" size="mini" @click.stop="goStudent(scope.row)">学情</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" v-loading="loading">
        <div slot="header" class="card-header">知识点掌握明细</div>
        <el-table :data="knowledgeRows" empty-text="暂无数据" max-height="420">
          <el-table-column label="知识点" min-width="160" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName || '-' }}</template>
          </el-table-column>
          <el-table-column label="班均得分率" width="120" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
          </el-table-column>
          <el-table-column label="参与人数" prop="studentCount" width="100" align="center" />
          <el-table-column label="关注" prop="watchCount" width="80" align="center" />
          <el-table-column label="薄弱" prop="weakCount" width="80" align="center" />
          <el-table-column label="严重" prop="severeCount" width="80" align="center" />
          <el-table-column label="操作" width="100" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click="goKnowledge(scope.row)">下钻</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </template>
  </div>
</template>

<script>
import { weakTopClass, heatmapClass, overviewClass, recalcDept, trendClass, chapterOverviewClass } from '@/api/spas/analysis'
import { optionselectSubject } from '@/api/spas/subject'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import SpasChart from '@/components/spas/charts/SpasChart'

export default {
  name: 'SpasAnalysisClass',
  components: { Treeselect, SpasChart },
  data() {
    return {
      loading: false,
      recalcLoading: false,
      exportLoading: false,
      classTrend: [],
      chapterRows: [],
      subjectOptions: [],
      deptOptions: [],
      myDepts: [],
      overview: {},
      knowledgeRows: [],
      studentRanking: [],
      weakTopRows: [],
      heatStudents: [],
      heatKnowledges: [],
      weakBarOption: {},
      heatmapOption: {},
      queryParams: {
        window: 'all',
        deptId: undefined,
        subjectId: undefined,
        limit: 10
      }
    }
  },
  computed: {
    classTrendOption() {
      const rows = this.classTrend || []
      const dates = rows.map(r => r.examDate || r.paperName || '-')
      const avgs = rows.map(r => {
        const v = Number(r.classAvgRate)
        if (isNaN(v)) return 0
        return v <= 1 ? +(v * 100).toFixed(1) : +v.toFixed(1)
      })
      const weaks = rows.map(r => {
        const v = Number(r.weakStudentRatio)
        if (isNaN(v)) return 0
        return v <= 1 ? +(v * 100).toFixed(1) : +v.toFixed(1)
      })
      return {
        tooltip: { trigger: 'axis' },
        legend: { data: ['班均', '薄弱占比'] },
        grid: { left: 40, right: 40, top: 40, bottom: 40 },
        xAxis: { type: 'category', data: dates, axisLabel: { rotate: 30 } },
        yAxis: [
          { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } },
          { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } }
        ],
        series: [
          { name: '班均', type: 'line', data: avgs },
          { name: '薄弱占比', type: 'line', yAxisIndex: 1, data: weaks }
        ]
      }
    },
    chapterBarOption() {
      const rows = this.chapterRows || []
      const names = rows.map(r => r.name || '-')
      const rates = rows.map(r => {
        const v = Number(r.avgRate)
        if (isNaN(v)) return 0
        return v <= 1 ? +(v * 100).toFixed(1) : +v.toFixed(1)
      })
      return {
        tooltip: { trigger: 'axis' },
        grid: { left: 40, right: 20, top: 30, bottom: 40 },
        xAxis: { type: 'category', data: names, axisLabel: { rotate: 30 } },
        yAxis: { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } },
        series: [{ type: 'bar', data: rates, name: '章节班均' }]
      }
    },
    overviewCards() {
      const o = this.overview || {}
      const avg = o.avgRate != null ? o.avgRate : o.averageRate
      const weakStudents = o.weakStudentCount != null ? o.weakStudentCount : o.weakCount
      const studentCount = o.studentCount != null ? o.studentCount : o.totalStudents
      const knowledgeCount = o.knowledgeCount != null ? o.knowledgeCount : o.weakKnowledgeCount
      const severeStudents = o.severeStudentCount
      return [
        {
          key: 'avg',
          label: '班均得分率',
          value: avg != null ? this.formatRate(avg) : '-',
          hint: '学生综合率再平均',
          tone: 'blue'
        },
        {
          key: 'weakStu',
          label: '薄弱学生数',
          value: weakStudents != null ? weakStudents : '-',
          hint: severeStudents != null ? ('含严重 ' + severeStudents) : '存在薄弱/严重知识点',
          tone: 'orange'
        },
        {
          key: 'stu',
          label: '学生人数',
          value: studentCount != null ? studentCount : '-',
          hint: '本班参与统计',
          tone: 'green'
        },
        {
          key: 'know',
          label: '薄弱知识点',
          value: knowledgeCount != null ? knowledgeCount : '-',
          hint: '班级平均偏低项',
          tone: 'red'
        }
      ]
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.deptId) {
      this.queryParams.deptId = Number(q.deptId) || q.deptId
    }
    if (q.subjectId) {
      this.queryParams.subjectId = Number(q.subjectId) || q.subjectId
    }
    Promise.all([this.loadSubjects(), this.loadDepts(), this.loadMyDepts()]).then(() => {
      if (!this.queryParams.deptId && this.myDepts.length) {
        this.queryParams.deptId = this.myDepts[0].deptId
      }
      if (this.queryParams.deptId) {
        this.loadAnalysis()
      }
    })
  },
  methods: {
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      this.loadAnalysis()
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
    rateColor(rate) {
      const p = this.toPercent(rate)
      if (p < 45) return '#F56C6C'
      if (p < 60) return '#E6A23C'
      if (p < 75) return '#F2C94C'
      return '#67C23A'
    },
    goStudent(row) {
      if (!row || !row.studentId) return
      this.$router.push({
        path: '/spas/analysis/student',
        query: {
          studentId: row.studentId,
          deptId: this.queryParams.deptId,
          subjectId: this.queryParams.subjectId
        }
      })
    },
    onRankingClick(row) {
      this.goStudent(row)
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
    unwrapData(res) {
      if (!res) {
        return {}
      }
      return res.data != null ? res.data : res
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
    handleQuery() {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      this.loadAnalysis()
    },
    handleExportReport(format) {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      const ext = format === 'xlsx' ? 'xlsx' : 'pdf'
      this.exportLoading = true
      this.download(
        'spas/report/class/' + this.queryParams.deptId,
        { subjectId: this.queryParams.subjectId, format: ext },
        `class_report_${this.queryParams.deptId}_${new Date().getTime()}.${ext}`
      ).finally(() => {
        this.exportLoading = false
      })
    },
    handleRecalcDept() {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      this.$modal.confirm('将按最新算法重算本班（及下级）有成绩学生的知识点快照，并刷新预警。确认继续？').then(() => {
        this.recalcLoading = true
        return recalcDept(this.queryParams.deptId, { subjectId: this.queryParams.subjectId })
      }).then(res => {
        const d = (res && res.data) || {}
        this.$modal.msgSuccess('重算完成：学生 ' + (d.studentCount != null ? d.studentCount : 0)
          + ' 人，快照 ' + (d.statRows != null ? d.statRows : 0)
          + ' 条，新增预警 ' + (d.warningCreated != null ? d.warningCreated : 0)
          + (d.interveneAsync ? '（干预评估已异步排队）' : ''))
        this.loadAnalysis()
      }).catch(() => {}).finally(() => {
        this.recalcLoading = false
      })
    },
    resetQuery() {
      this.queryParams.deptId = undefined
      this.overview = {}
      this.knowledgeRows = []
      this.heatStudents = []
      this.heatKnowledges = []
      this.weakBarOption = {}
      this.heatmapOption = {}
      this.loadSubjects()
    },
    loadClassTrend() {
      return trendClass(this.queryParams.deptId, {
        subjectId: this.queryParams.subjectId,
        window: this.queryParams.window
      }).then(res => {
        const data = (res && res.data != null) ? res.data : res
        this.classTrend = Array.isArray(data) ? data : []
      }).catch(() => { this.classTrend = [] })
    },
    loadChapterOverview() {
      return chapterOverviewClass(this.queryParams.deptId, {
        subjectId: this.queryParams.subjectId
      }).then(res => {
        const data = (res && res.data != null) ? res.data : res
        this.chapterRows = (data && data.chapters) ? data.chapters : []
      }).catch(() => { this.chapterRows = [] })
    },
    loadAnalysis() {
      const deptId = this.queryParams.deptId
      const query = {
        subjectId: this.queryParams.subjectId,
        limit: this.queryParams.limit
      }
      this.loading = true
      Promise.all([
        overviewClass(deptId, query),
        weakTopClass(deptId, query),
        heatmapClass(deptId, { subjectId: this.queryParams.subjectId })
      ]).then(([overviewRes, weakRes, heatRes]) => {
        const ov = this.unwrapData(overviewRes) || {}
        this.overview = ov
        this.knowledgeRows = Array.isArray(ov.knowledges) ? ov.knowledges : (Array.isArray(ov) ? ov : [])
        this.studentRanking = Array.isArray(ov.studentRanking) ? ov.studentRanking : []
        this.loadClassTrend()
        this.loadChapterOverview()
        this.buildWeakBar(this.unwrapList(weakRes))
        this.buildHeatmap(this.unwrapData(heatRes) || {})
      }).catch(() => {
        this.overview = {}
        this.knowledgeRows = []
        this.studentRanking = []
        this.weakBarOption = {}
        this.heatmapOption = {}
        this.$modal.msgError('加载班级分析失败')
      }).finally(() => {
        this.loading = false
      })
    },
    buildWeakBar(list) {
      this.weakTopRows = list || []
      if (!list.length) {
        this.weakBarOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } }
        }
        return
      }
      const names = list.map(item => item.name || item.knowledgeName || '-').reverse()
      const rates = list.map(item => this.toPercent(item.rate != null ? item.rate : item.avgRate != null ? item.avgRate : item.weightedRate)).reverse()
      this.weakBarOption = {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '6%', bottom: '3%', top: 20, containLabel: true },
        xAxis: { type: 'value', name: '%', max: 100 },
        yAxis: { type: 'category', data: names },
        series: [{
          name: '班级平均得分率',
          type: 'bar',
          data: rates.map(r => ({
            value: r,
            itemStyle: { color: this.rateColor(r / 100) }
          })),
          barMaxWidth: 28,
          label: { show: true, position: 'right', formatter: '{c}%' }
        }]
      }
    },
    buildHeatmap(payload) {
      const students = payload.students || []
      const knowledges = payload.knowledges || payload.knowledgeList || []
      const matrix = payload.matrix || []
      this.heatStudents = students
      this.heatKnowledges = knowledges
      if (!students.length || !knowledges.length) {
        this.heatmapOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } }
        }
        return
      }
      const yLabels = students.map(s => s.name || s.studentName || String(s.id || s.studentId))
      const xLabels = knowledges.map(k => k.name || k.knowledgeName || String(k.id || k.knowledgeId))
      const data = []
      for (let yi = 0; yi < matrix.length; yi++) {
        const row = matrix[yi] || []
        for (let xi = 0; xi < knowledges.length; xi++) {
          const raw = row[xi]
          if (raw == null || raw === '') {
            data.push({
              value: [xi, yi, -1],
              itemStyle: { color: '#EBEEF5' },
              label: { show: true, formatter: '无', color: '#C0C4CC' }
            })
          } else {
            data.push([xi, yi, this.toPercent(raw)])
          }
        }
      }
      const bottomPad = Math.max(56, (xLabels.length > 8 ? 90 : 60))
      this.heatmapOption = {
        tooltip: {
          position: 'top',
          formatter: params => {
            const x = xLabels[params.value[0]] || ''
            const y = yLabels[params.value[1]] || ''
            const v = params.value[2]
            if (v == null || v < 0) {
              return y + '<br/>' + x + '：无数据'
            }
            return y + '<br/>' + x + '：' + v + '%'
          }
        },
        grid: { left: 80, right: 40, top: 20, bottom: bottomPad },
        xAxis: {
          type: 'category',
          data: xLabels,
          splitArea: { show: true },
          axisLabel: { rotate: xLabels.length > 6 ? 40 : 0, interval: 0 }
        },
        yAxis: { type: 'category', data: yLabels, splitArea: { show: true } },
        visualMap: {
          type: 'piecewise',
          orient: 'horizontal',
          left: 'center',
          bottom: 8,
          pieces: [
            { value: -1, label: '无数据', color: '#EBEEF5' },
            { gte: 0, lt: 45, label: '<45%', color: '#F56C6C' },
            { gte: 45, lt: 60, label: '45-60%', color: '#E6A23C' },
            { gte: 60, lt: 75, label: '60-75%', color: '#E1F3D8' },
            { gte: 75, lte: 100, label: '>=75%', color: '#67C23A' }
          ]
        },
        series: [{
          name: '得分率',
          type: 'heatmap',
          data,
          label: {
            show: students.length * knowledges.length <= 80,
            formatter: p => {
              const v = p.value && p.value[2]
              if (v == null || v < 0) return '无'
              return v
            }
          },
          emphasis: { itemStyle: { shadowBlur: 8, shadowColor: 'rgba(0,0,0,0.25)' } }
        }]
      }
    },
    goKnowledge(row) {
      const knowledgeId = row && (row.knowledgeId || row.id)
      if (!knowledgeId) return
      this.$router.push({
        path: '/spas/analysis/knowledge',
        query: { knowledgeId, deptId: this.queryParams.deptId, subjectId: this.queryParams.subjectId }
      })
    },
    onWeakBarClick(params) {
      if (!params || params.componentType !== 'series') return
      const name = params.name
      const hit = (this.weakTopRows || []).find(k => (k.name || k.knowledgeName) === name)
        || (this.knowledgeRows || []).find(k => (k.name || k.knowledgeName) === name)
      if (hit) this.goKnowledge(hit)
    },
    onHeatmapClick(params) {
      if (!params || !params.value) return
      const xi = params.value[0]
      const yi = params.value[1]
      const cellVal = params.value[2]
      if (cellVal == null || cellVal < 0) {
        this.$modal.msgWarning('该单元格无数据')
        return
      }
      const student = this.heatStudents[yi]
      const knowledge = this.heatKnowledges[xi]
      this.$confirm('选择下钻目标', '热力图下钻', {
        distinguishCancelAndClose: true,
        confirmButtonText: '查看学生',
        cancelButtonText: '查看知识点'
      }).then(() => {
        const studentId = student && (student.id || student.studentId)
        if (!studentId) { this.$modal.msgWarning('无法定位学生'); return }
        this.$router.push({ path: '/spas/analysis/student', query: { studentId, deptId: this.queryParams.deptId, subjectId: this.queryParams.subjectId } })
      }).catch(action => {
        if (action === 'cancel') {
          const knowledgeId = knowledge && (knowledge.id || knowledge.knowledgeId)
          if (!knowledgeId) { this.$modal.msgWarning('无法定位知识点'); return }
          this.$router.push({ path: '/spas/analysis/knowledge', query: { knowledgeId, deptId: this.queryParams.deptId, subjectId: this.queryParams.subjectId } })
        }
      })
    }
  }
}
</script>

<style scoped>
.spas-analysis .card-header {
  font-weight: 600;
  color: #2C2940;
}
.overview-row {
  margin-bottom: 8px;
}
.stat-card {
  background: #fff;
  border: 1px solid #E8E4F5;
  border-radius: 14px;
  padding: 16px 18px;
  margin-bottom: 12px;
  border-left: 3px solid #7B6CF6;
  box-shadow: 0 8px 24px rgba(91, 75, 219, 0.06);
}
.stat-card.tone-blue { border-left-color: #7B6CF6; }
.stat-card.tone-orange { border-left-color: #E6A23C; }
.stat-card.tone-green { border-left-color: #67C23A; }
.stat-card.tone-red { border-left-color: #F56C6C; }
.stat-label {
  color: #6B6685;
  font-size: 13px;
}
.stat-value {
  margin-top: 8px;
  font-size: 26px;
  font-weight: 600;
  color: #2C2940;
  line-height: 1.2;
}
.stat-hint {
  margin-top: 6px;
  font-size: 12px;
  color: #A8A3BD;
}
</style>
