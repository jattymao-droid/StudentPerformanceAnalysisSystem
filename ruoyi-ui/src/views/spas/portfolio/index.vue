<template>
  <div class="app-container spas-portfolio">
    <el-form :model="queryParams" size="small" :inline="true" label-width="68px">
      <el-form-item label="班级">
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

      <el-card shadow="never" style="margin-top: 16px" v-if="interveneTimeline.length">
        <div slot="header" class="card-header">
          <span>干预时间线</span>
          <el-button style="float: right; padding: 3px 0" type="text" @click="goInterveneList" v-hasPermi="['spas:intervene:list']">干预中心</el-button>
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
              <span :style="{ color: Number(item.effectDelta) > 0 ? '#67C23A' : '#F56C6C' }">{{ formatGap(item.effectDelta) }}</span>
              <el-tag v-if="item.effectPassed === '1'" type="success" size="mini" style="margin-left: 8px">达标</el-tag>
            </p>
          </el-timeline-item>
        </el-timeline>
      </el-card>

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
        <div slot="header" class="card-header">薄弱知识点 Top</div>
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

      <el-row :gutter="16" style="margin-top: 16px">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never">
            <div slot="header" class="card-header">未处理预警</div>
            <el-table :data="openWarnings" empty-text="暂无预警">
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
            <div slot="header" class="card-header">
              <span>辅导记录</span>
              <el-button style="float: right; padding: 3px 0" type="text" icon="el-icon-plus" @click="openCoach" v-hasPermi="['spas:portfolio:coach', 'spas:portfolio:list']">新增</el-button>
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
              </el-timeline-item>
            </el-timeline>
            <el-empty v-else description="暂无辅导记录" :image-size="64" />
          </el-card>
        </el-col>
      </el-row>
    </div>

    <el-dialog title="新增辅导记录" :visible.sync="coachOpen" width="520px" append-to-body>
      <el-form ref="coachForm" :model="coachForm" :rules="coachRules" label-width="90px">
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
      openWarnings: [],
      coachLogs: [],
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
  created() {
    const q = this.$route.query || {}
    if (q.studentId) {
      this.queryParams.studentId = Number(q.studentId) || q.studentId
    }
    if (q.subjectId) {
      this.queryParams.subjectId = Number(q.subjectId) || q.subjectId
    }
    this.loadSubjects()
    this.loadDepts()
    const fromRoute = !!(this.$route.query && this.$route.query.studentId)
    this.loadMyDepts().then(() => {
      if (!this.queryParams.deptId && this.myDepts.length && !fromRoute) {
        this.queryParams.deptId = this.myDepts[0].deptId
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
          this.openWarnings = []
          this.coachLogs = []
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
      return deptTreeSelect().then(res => {
        this.deptOptions = res.data || []
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
    goAnalysis() {
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
        this.openWarnings = this.unwrapList(data.openWarnings)
        this.coachLogs = this.unwrapList(data.coachLogs)
        this.buildRadar(this.unwrapList(data.radar))
        this.buildTrend(this.unwrapList(data.trend))
      }).catch(() => {
        this.$modal.msgError('加载一生一册失败')
        this.portfolio = {}
        this.summary = {}
        this.interveneTimeline = []
        this.weakList = []
        this.openWarnings = []
        this.coachLogs = []
        this.radarOption = {}
        this.trendOption = {}
      }).finally(() => {
        this.loading = false
      })
    },
    buildRadar(list) {
      if (!list.length) {
        this.radarOption = { title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } } }
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
        color: ['#7B6CF6', '#A8A3BD'],
        tooltip: {},
        legend: hasClass ? { data: ['本人', '班级均值'], bottom: 0 } : undefined,
        radar: { indicator: list.map(i => ({ name: i.name || i.knowledgeName || '-', max: 100 })), radius: '62%', center: ['50%', '48%'] },
        series: [{ type: 'radar', areaStyle: { opacity: 0.25 }, data: seriesData }]
      }
    },
    buildTrend(list) {
      if (!list.length) {
        this.trendOption = { title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } } }
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
        itemStyle: { color: '#7B6CF6' },
        lineStyle: { color: '#7B6CF6' },
        areaStyle: { opacity: 0.12, color: 'rgba(123, 108, 246, 0.18)' },
        markLine: { silent: true, data: [{ yAxis: 60, name: '60%' }] }
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
        grid: { left: '3%', right: '4%', bottom: hasClass ? 36 : 8, top: 30, containLabel: true },
        xAxis: { type: 'category', data: sorted.map(i => i.paperName || i.name || '-') },
        yAxis: { type: 'value', name: '%', min: 0, max: 100 },
        series
      }
    },
    openCoach() {
      this.coachForm = { studentId: this.queryParams.studentId, content: undefined, nextPlan: undefined }
      this.coachOpen = true
    },
    submitCoach() {
      this.$refs['coachForm'].validate(valid => {
        if (!valid) return
        addCoachLog(this.coachForm).then(() => {
          this.$modal.msgSuccess('已保存')
          this.coachOpen = false
          this.loadPortfolio()
        })
      })
    }
  }
}
</script>

