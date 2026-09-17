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
      <el-form-item label="知识点" prop="knowledgeId">
        <treeselect
          v-model="queryParams.knowledgeId"
          :options="knowledgeOptions"
          :normalizer="knowledgeNormalizer"
          :disable-branch-nodes="false"
          placeholder="请选择知识点"
          style="width: 260px"
        />
      </el-form-item>
      <el-form-item label="班级" prop="deptId">
        <treeselect
          v-model="queryParams.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="可选班级筛选"
          style="width: 220px"
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
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['spas:analysis:knowledge']">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-empty v-if="!queryParams.knowledgeId" description="请选择知识点后查看分析" />

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
        title="色阶：&lt;45%严重 / 45–60%薄弱 / 60–75%关注 / ≥75%正常。可选章节查看汇总，请选择叶子知识点。"
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

      <el-card shadow="never" style="margin-bottom: 16px" v-if="questionRows.length">
        <div slot="header" class="card-header">关联题目与权重</div>
        <el-table :data="questionRows" max-height="320">
          <el-table-column label="题号" prop="questionNo" width="80" align="center" />
          <el-table-column label="试卷" prop="paperName" min-width="140" :show-overflow-tooltip="true" />
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
            <div slot="header" class="card-header">得分率分布</div>
            <spas-chart :option="distOption" height="360px" />
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">班级对比</div>
            <spas-chart :option="classBarOption" height="360px" />
          </el-card>
        </el-col>
      </el-row>

      <el-card shadow="never" style="margin-top: 16px" v-if="studentRows.length">
        <div slot="header" class="card-header">学生掌握明细</div>
        <el-table :data="studentRows" max-height="420">
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
          <el-table-column label="置信度" align="center" width="90">
            <template slot-scope="scope">{{ formatConfidence(scope.row.confidence) }}</template>
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
import { optionselectSubject } from '@/api/spas/subject'
import { treeKnowledge } from '@/api/spas/knowledge'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
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
      studentRows: [],
      questionRows: [],
      queryParams: {
        subjectId: undefined,
        knowledgeId: undefined,
        deptId: undefined
      }
    }
  },
  computed: {
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
    }
    if (q.subjectId) {
      this.queryParams.subjectId = Number(q.subjectId) || q.subjectId
    }
    if (q.deptId) {
      this.queryParams.deptId = Number(q.deptId) || q.deptId
    }
    const fromRoute = !!(q.knowledgeId || q.deptId || q.subjectId)
    this.loadDepts()
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
        if (!this.queryParams.deptId && this.myDepts.length && !fromRoute) {
          this.queryParams.deptId = this.myDepts[0].deptId
        }
      })
    ]).then(() => {
      if (!this.queryParams.subjectId) {
        return
      }
      return this.loadKnowledgeTree(true)
    }).then(() => {
      if (this.queryParams.knowledgeId) {
        this.loadAnalysis()
      }
    })
  },
  methods: {
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      if (this.queryParams.knowledgeId) {
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
      if (p < 45) return '#F56C6C'
      if (p < 60) return '#E6A23C'
      if (p < 75) return '#E6A23C'
      return '#67C23A'
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
      const isChapter = String(node.nodeType || '') === '1'
      const name = node.knowledgeName || ''
      return {
        id: node.knowledgeId,
        label: isChapter ? ('[章节] ' + name) : name,
        children: node.children,
        isDisabled: false,
        nodeType: node.nodeType
      }
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
      deptTreeSelect().then(response => {
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
    loadKnowledgeTree(preserveKnowledge) {
      const keepId = preserveKnowledge ? this.queryParams.knowledgeId : undefined
      this.knowledgeOptions = []
      this.queryParams.knowledgeId = undefined
      if (!this.queryParams.subjectId) {
        return Promise.resolve()
      }
      return treeKnowledge(this.queryParams.subjectId).then(response => {
        this.knowledgeOptions = response.data || []
        if (keepId) {
          this.queryParams.knowledgeId = keepId
        }
      }).catch(() => {
        this.knowledgeOptions = []
      })
    },
    handleSubjectChange() {
      this.loadKnowledgeTree(false)
    },
    handleQuery() {
      if (!this.queryParams.knowledgeId) {
        this.$modal.msgWarning('请先选择知识点')
        return
      }
      this.loadAnalysis()
    },
    resetQuery() {
      this.queryParams.deptId = undefined
      this.queryParams.knowledgeId = undefined
      this.overview = {}
      this.distOption = {}
      this.classBarOption = {}
      this.studentRows = []
      this.questionRows = []
      this.loadSubjects()
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
      this.$router.push({ path: '/spas/analysis/student', query })
    },
    loadAnalysis() {
      const knowledgeId = this.queryParams.knowledgeId
      const query = {
        deptId: this.queryParams.deptId,
        subjectId: this.queryParams.subjectId
      }
      this.loading = true
      overviewKnowledge(knowledgeId, query).then(res => {
        const raw = this.unwrapData(res) || {}
        const data = Array.isArray(raw) ? { students: raw } : raw
        this.overview = data
        this.studentRows = data.students || data.studentList || data.details || raw || []
        this.questionRows = data.questions || []
        this.buildDistribution(data)
        this.buildClassCompare(data)
      }).catch(() => {
        this.overview = {}
        this.studentRows = []
        this.questionRows = []
        this.distOption = {}
        this.classBarOption = {}
        this.$modal.msgError('加载知识点分析失败')
      }).finally(() => {
        this.loading = false
      })
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
      if (!bins || !bins.length) {
        this.distOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } }
        }
        return
      }
      const names = bins.map(b => b.name || b.label || b.bucket || b.range || '-')
      const counts = bins.map(b => b.count != null ? b.count : b.value != null ? b.value : 0)
      const binColors = ['#F56C6C', '#E6A23C', '#F2C94C', '#67C23A', '#409EFF']
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
            itemStyle: { color: binColors[i] || '#7B6CF6' }
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
          title: { text: '暂无班级对比数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } }
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
            itemStyle: { color: r < 45 ? '#F56C6C' : r < 60 ? '#E6A23C' : r < 75 ? '#F2C94C' : '#67C23A' }
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
.mb8 { margin-bottom: 8px; }
</style>
