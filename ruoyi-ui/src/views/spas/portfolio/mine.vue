<template>
  <div class="app-container spas-portfolio-mine">
    <el-form :model="queryParams" size="small" :inline="true" label-width="68px">
      <el-form-item label="学科">
        <el-select v-model="queryParams.subjectId" placeholder="请选择学科" filterable style="width: 180px" @change="loadMine">
          <el-option
            v-for="item in subjectOptions"
            :key="item.subjectId"
            :label="item.subjectName"
            :value="item.subjectId"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-refresh" size="mini" @click="loadMine">刷新</el-button>
        <el-button
          type="success"
          plain
          icon="el-icon-download"
          size="mini"
          :disabled="!(portfolio.student && portfolio.student.studentId)"
          :loading="exportLoading"
          @click="exportMine"
        >导出学情 PDF</el-button>
      </el-form-item>
    </el-form>

    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="解读说明：雷达为知识点加权掌握；薄弱列表按得分率从低到高；预警仅展示未关闭项。数据随教师导入与重算更新。"
    />

    <div v-loading="loading">
      <el-card shadow="never">
        <div slot="header" class="card-header">我的学情</div>
        <el-descriptions :column="4" border size="small" v-if="portfolio.student">
          <el-descriptions-item label="学号">{{ portfolio.student.studentNo }}</el-descriptions-item>
          <el-descriptions-item label="姓名">{{ portfolio.student.studentName }}</el-descriptions-item>
          <el-descriptions-item label="当前预警">
            <el-tag :type="(portfolio.openWarningCount || 0) > 0 ? 'danger' : 'success'" size="mini">
              {{ portfolio.openWarningCount || 0 }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="进行中干预">
            <el-tag :type="(portfolio.openInterveneCount || 0) > 0 ? 'warning' : 'success'" size="mini">
              {{ portfolio.openInterveneCount || 0 }}
            </el-tag>
          </el-descriptions-item>
        </el-descriptions>
        <el-alert
          v-else-if="!loading"
          title="当前账号未绑定学生档案，请联系教师"
          type="warning"
          :closable="false"
          show-icon
          style="margin-top: 8px"
        />
      </el-card>

      <template v-if="portfolio.student">
        <el-alert
          v-if="summary.headline"
          :title="summary.headline"
          type="info"
          :closable="false"
          show-icon
          style="margin-top: 12px"
        />
        <el-card shadow="never" style="margin-top: 12px">
          <div slot="header" class="card-header">实考校次进退</div>
          <el-alert
            v-if="rankSummary && rankSummary.headline"
            class="mb8"
            type="info"
            :closable="false"
            show-icon
            :title="rankSummary.headline"
          />
          <el-table :data="rankSubjects" size="small" empty-text="暂无实考校次数据">
            <el-table-column label="科目" prop="subjectName" width="90" />
            <el-table-column label="校次轨迹" prop="track" min-width="160" :show-overflow-tooltip="true" />
            <el-table-column label="最近校次" width="90" align="center">
              <template slot-scope="scope">{{ scope.row.latestRank == null ? '-' : scope.row.latestRank }}</template>
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
          </el-table>
        </el-card>
        <el-card shadow="never" style="margin-top: 12px" v-if="interveneTimeline.length">
          <div slot="header" class="card-header">我的干预进度</div>
          <el-timeline>
            <el-timeline-item
              v-for="(item, idx) in interveneTimeline"
              :key="idx"
              :timestamp="parseTime(item.time)"
              placement="top"
            >
              <p><b>{{ timelineTitle(item) }}</b></p>
              <p v-if="item.type === 'intervene_create'">基线 {{ formatRate(item.baselineRate) }} → 目标 {{ formatRate(item.targetRate) }}</p>
              <p v-if="item.type === 'coach'">{{ item.createBy || '教师' }}：{{ item.content }}</p>
              <p v-if="item.type === 'intervene_effect'">当前 {{ formatRate(item.effectRate) }}，增益 {{ formatGap(item.effectDelta) }}</p>
            </el-timeline-item>
          </el-timeline>
        </el-card>
        <el-alert
          v-if="showEmptyTip"
          title="暂无成绩数据，完成考试并导入后将自动展示"
          type="info"
          :closable="false"
          show-icon
          style="margin-top: 12px"
        />
        <el-row :gutter="16" style="margin-top: 16px">
          <el-col :xs="24" :lg="12">
            <el-card shadow="never">
              <div slot="header" class="card-header">知识点掌握雷达</div>
              <spas-chart :option="radarOption" height="340px" />
            </el-card>
          </el-col>
          <el-col :xs="24" :lg="12">
            <el-card shadow="never">
              <div slot="header" class="card-header">成绩趋势</div>
              <spas-chart :option="trendOption" height="340px" />
            </el-card>
          </el-col>
        </el-row>

        <el-card shadow="never" style="margin-top: 16px">
          <div slot="header" class="card-header">薄弱知识点</div>
          <el-table :data="weakList" empty-text="暂无薄弱点">
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

        <el-card shadow="never" style="margin-top: 16px" v-if="errorCauseSummary.length">
          <div slot="header" class="card-header">错因分布</div>
          <el-table :data="errorCauseSummary" size="small">
            <el-table-column label="错因大类" min-width="120">
              <template slot-scope="scope">{{ scope.row.errorCategoryLabel || scope.row.errorLabel || '-' }}</template>
            </el-table-column>
            <el-table-column label="题数" prop="tagCount" width="90" align="center" />
          </el-table>
        </el-card>

        <el-card shadow="never" style="margin-top: 16px">
          <div slot="header" class="card-header">本学期反复薄弱</div>
          <el-table :data="persistentWeak" empty-text="暂无反复薄弱">
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

        <el-card shadow="never" style="margin-top: 16px">
          <div slot="header" class="card-header">教师辅导反馈</div>
          <el-table :data="coachLogs" empty-text="暂无辅导记录">
            <el-table-column label="辅导内容" prop="content" min-width="220" :show-overflow-tooltip="true" />
            <el-table-column label="后续计划" prop="nextPlan" min-width="160" :show-overflow-tooltip="true" />
            <el-table-column label="记录人" prop="createBy" width="100" align="center" />
            <el-table-column label="时间" width="160" align="center">
              <template slot-scope="scope">{{ parseTime(scope.row.createTime) }}</template>
            </el-table-column>
          </el-table>
        </el-card>

        <el-card shadow="never" style="margin-top: 16px">
          <div slot="header" class="card-header">我的预警</div>
          <el-table :data="openWarnings" empty-text="暂无预警">
            <el-table-column label="标题" prop="title" min-width="140" :show-overflow-tooltip="true" />
            <el-table-column label="内容" prop="content" min-width="220" :show-overflow-tooltip="true" />
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
      </template>
    </div>
  </div>
</template>

<script>
import { getMyPortfolio } from '@/api/spas/portfolio'
import { optionselectSubject } from '@/api/spas/subject'
import SpasChart from '@/components/spas/charts/SpasChart'

export default {
  name: 'SpasPortfolioMine',
  dicts: ['spas_weak_level', 'spas_warning_level'],
  components: { SpasChart },
  data() {
    return {
      loading: false,
      exportLoading: false,
      subjectOptions: [],
      portfolio: {},
      summary: {},
      interveneTimeline: [],
      weakList: [],
      persistentWeak: [],
      errorCauseSummary: [],
      coachLogs: [],
      openWarnings: [],
      rankSubjects: [],
      rankSummary: {},
      radarOption: {},
      trendOption: {},
      queryParams: {
        subjectId: undefined
      }
    }
  },
  computed: {
    showEmptyTip() {
      return !this.loading && !this.weakList.length && !Object.keys(this.radarOption || {}).length
    }
  },
  created() {
    this.loadSubjects().then(() => this.loadMine())
  },
  methods: {
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
    deltaText(v) {
      if (v == null || v === '') return '-'
      const n = Number(v)
      if (Number.isNaN(n)) return '-'
      if (n > 0) return '进步 ' + n
      if (n < 0) return '退步 ' + Math.abs(n)
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
    timelineTitle(item) {
      if (item.type === 'intervene_create') return '创建干预：' + (item.title || '')
      if (item.type === 'coach') return '教师辅导'
      if (item.type === 'intervene_effect') return '效果评估'
      return item.title || item.type
    },
    unwrapList(val) {
      if (!val) return []
      if (Array.isArray(val)) return val
      return []
    },
    exportMine() {
      const sid = this.portfolio.student && this.portfolio.student.studentId
      if (!sid) {
        this.$modal.msgWarning('未绑定学生档案')
        return
      }
      this.exportLoading = true
      this.download(
        'spas/report/student/' + sid,
        { subjectId: this.queryParams.subjectId, format: 'pdf' },
        'my_portfolio_' + sid + '.pdf'
      ).finally(() => { this.exportLoading = false })
    },
    loadSubjects() {
      return optionselectSubject().then(res => {
        this.subjectOptions = res.data || []
        if (!this.queryParams.subjectId && this.subjectOptions.length) {
          this.queryParams.subjectId = this.subjectOptions[0].subjectId
        }
      }).catch(() => {
        this.subjectOptions = []
      })
    },
    loadMine() {
      this.loading = true
      getMyPortfolio({ subjectId: this.queryParams.subjectId }).then(res => {
        const data = res.data || {}
        this.portfolio = data
        this.summary = data.summary || {}
        this.interveneTimeline = this.unwrapList(data.interveneTimeline)
        this.weakList = this.unwrapList(data.weakTop)
        this.persistentWeak = this.unwrapList(data.persistentWeak)
        this.errorCauseSummary = this.unwrapList(data.errorCauseSummary)
        this.coachLogs = this.unwrapList(data.coachLogs)
        this.openWarnings = this.unwrapList(data.openWarnings)
        const examRank = data.examRank || {}
        this.rankSubjects = this.unwrapList(examRank.subjects)
        this.rankSummary = examRank.summary || {}
        this.buildRadar(this.unwrapList(data.radar))
        this.buildTrend(this.unwrapList(data.trend))
      }).catch(() => {
        this.portfolio = {}
        this.weakList = []
        this.persistentWeak = []
        this.errorCauseSummary = []
        this.coachLogs = []
        this.openWarnings = []
        this.rankSubjects = []
        this.rankSummary = {}
        this.radarOption = {}
        this.trendOption = {}
      }).finally(() => {
        this.loading = false
      })
    },
    buildRadar(list) {
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
    }
  }
}
</script>

<style scoped>
.mb8 {
  margin-bottom: 8px;
}
</style>

