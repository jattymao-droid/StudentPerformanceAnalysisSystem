<template>
  <div class="app-container spas-quality">
    <el-alert class="mb8" type="warning" :closable="false" show-icon title="优先处理：未绑知识点、权重和≠1、未选题型、未标认知层级。这些直接影响薄弱分析与 Bloom/题型维度可信度。依赖边请在「知识点」页维护。" />
    <el-tabs v-model="activeTab" @tab-click="onTabClick">
      <el-tab-pane label="看板" name="board">
        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
          <el-form-item label="班级" prop="deptId" class="class-row">
            <template v-if="boundClassMode">
              <div class="bound-class-wrap">
                <span class="bound-class-name">{{ currentDeptName || '未绑定班级' }}</span>
                <el-tag v-if="boundClassRoleLabel" size="mini" type="info">{{ boundClassRoleLabel }}</el-tag>
                <el-button-group v-if="myDepts.length > 1">
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

        <el-alert :title="alertTitle" type="warning" :closable="false" show-icon class="mb8" />
        <el-alert
          v-if="scopeHint"
          :title="scopeHint"
          type="info"
          :closable="false"
          show-icon
          class="mb8"
        />

        <el-row :gutter="12" v-loading="loading">
          <el-col :xs="12" :sm="8" :md="6" v-for="m in metrics" :key="m.code" style="margin-bottom: 12px">
            <div
              class="metric-card"
              :class="['level-' + m.level, { active: activeMetric === m.code, empty: !m.count }]"
              @click="loadDetail(m)"
            >
              <div class="metric-code">{{ m.code }}</div>
              <div class="metric-title">{{ metricTitle(m.code) }}</div>
              <div class="metric-count">{{ m.count }}</div>
              <div class="metric-extra" v-if="m.ratio">{{ m.ratio }}</div>
              <div class="metric-extra" v-else-if="!m.count">暂无此类问题</div>
            </div>
          </el-col>
        </el-row>

        <el-card shadow="never" style="margin-top: 8px">
          <div slot="header" class="card-header">
            <span>下钻明细<template v-if="activeMetric"> · {{ metricTitle(activeMetric) }}</template></span>
            <div class="card-header-actions">
              <el-button
                v-if="activeMetric"
                type="text"
                size="mini"
                icon="el-icon-document-add"
                @click="createTicketFromMetric"
                v-hasPermi="['spas:quality:ticket:add']"
              >创建工单</el-button>
              <el-button v-if="canFix" type="text" size="mini" icon="el-icon-right" @click="goFix">前往修复</el-button>
            </div>
          </div>
          <el-empty v-if="!activeMetric" description="请点击上方指标卡片查看下钻明细" />
          <el-empty
            v-else-if="!detailLoading && !(detailRows && detailRows.length)"
            :description="detailEmptyText"
          />
          <el-table v-else :data="detailRows" v-loading="detailLoading" empty-text="暂无明细" max-height="420">
            <el-table-column v-for="col in detailColumns" :key="col.prop" :label="col.label" :prop="col.prop" :min-width="col.width || 100" :show-overflow-tooltip="true" />
            <el-table-column label="操作" width="90" align="center" fixed="right" v-if="canFix">
              <template slot-scope="scope">
                <el-button type="text" size="mini" @click="goFixRow(scope.row)">修复</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>

      <el-tab-pane label="工单" name="ticket">
        <el-form :model="ticketQuery" size="small" :inline="true" label-width="68px">
          <el-form-item label="指标">
            <el-select v-model="ticketQuery.metricCode" clearable placeholder="全部" style="width: 200px">
              <el-option v-for="(title, code) in metricTitleMap" :key="code" :label="code" :value="code" />
            </el-select>
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="ticketQuery.status" clearable placeholder="全部" style="width: 120px">
              <el-option v-for="d in dict.type.spas_quality_ticket_status" :key="d.value" :label="d.label" :value="d.value" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="loadTickets" v-hasPermi="['spas:quality:ticket:list']">查询</el-button>
            <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="openTicketForm()" v-hasPermi="['spas:quality:ticket:add']">新增</el-button>
          </el-form-item>
        </el-form>
        <el-table v-loading="ticketLoading" :data="ticketList">
          <el-table-column label="ID" prop="ticketId" width="70" />
          <el-table-column label="指标" prop="metricCode" width="180" :show-overflow-tooltip="true" />
          <el-table-column label="标题" prop="title" min-width="160" :show-overflow-tooltip="true" />
          <el-table-column label="优先级" width="90" align="center">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_quality_ticket_priority" :value="scope.row.priority" />
            </template>
          </el-table-column>
          <el-table-column label="状态" width="100" align="center">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_quality_ticket_status" :value="scope.row.status" />
            </template>
          </el-table-column>
          <el-table-column label="负责人" prop="ownerBy" width="100" />
          <el-table-column label="班级" prop="deptName" width="120" :show-overflow-tooltip="true" />
          <el-table-column label="学科" prop="subjectName" width="100" />
          <el-table-column label="操作" width="140" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click="openTicketForm(scope.row)" v-hasPermi="['spas:quality:ticket:edit']">修改</el-button>
              <el-button size="mini" type="text" @click="removeTicket(scope.row)" v-hasPermi="['spas:quality:ticket:remove']">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="ticketTotal > 0" :total="ticketTotal" :page.sync="ticketQuery.pageNum" :limit.sync="ticketQuery.pageSize" @pagination="loadTickets" />
      </el-tab-pane>
    </el-tabs>

    <el-dialog :title="ticketFormTitle" :visible.sync="ticketOpen" width="520px" append-to-body>
      <el-form ref="ticketFormRef" :model="ticketForm" label-width="90px">
        <el-form-item label="指标" prop="metricCode" :rules="[{ required: true, message: '必填' }]">
          <el-select v-model="ticketForm.metricCode" style="width: 100%">
            <el-option v-for="(title, code) in metricTitleMap" :key="code" :label="code + ' - ' + title" :value="code" />
          </el-select>
        </el-form-item>
        <el-form-item label="标题" prop="title" :rules="[{ required: true, message: '必填' }]">
          <el-input v-model="ticketForm.title" />
        </el-form-item>
        <el-form-item label="优先级">
          <el-radio-group v-model="ticketForm.priority">
            <el-radio v-for="d in dict.type.spas_quality_ticket_priority" :key="d.value" :label="d.value">{{ d.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="ticketForm.status">
            <el-radio v-for="d in dict.type.spas_quality_ticket_status" :key="d.value" :label="d.value">{{ d.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="负责人">
          <el-input v-model="ticketForm.ownerBy" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="ticketForm.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="submitTicket">确定</el-button>
        <el-button @click="ticketOpen = false">取消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import { deptTreeSelect } from '@/api/system/user'
import { optionselectSubject } from '@/api/spas/subject'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { boundClassRoleFromDepts } from '@/utils/spasTeacherRole'
import { applyTeachingDeptContext, canLoadSystemDeptTree } from '@/utils/spasDeptTree'
import { qualityOverview, qualityDetail, listQualityTicket, addQualityTicket, updateQualityTicket, delQualityTicket } from '@/api/spas/quality'

const METRIC_TITLE = {
  'Q_NO_KNOWLEDGE': '题目未绑定知识点',
  'Q_NO_QUESTION_TYPE': '题目未选题型',
  'Q_NO_BLOOM': '题目未标认知层级',
  'Q_WEIGHT_SUM': '知识点权重和≠1',
  'Q_ORPHAN_SCORE': '异常成绩/草稿卷',
  'Q_HIGH_FREQ_LOW_MASTERY': '高频低掌握',
  'Q_LOW_ATTEMPT': '样本不足仍展示',
  'Q_WEAK_LOW_EVIDENCE': '样本不足的薄弱结论',
  'Q_MISSING_EXAM_DATE': '试卷缺考试日期',
  'Q_PARTIAL_PAPER': '作答题数不完整',
  'Q_BLANK_ZERO': '空分按0计入(启发)'
}

export default {
  name: 'SpasQuality',
  components: { Treeselect },
  dicts: ['spas_quality_ticket_status', 'spas_quality_ticket_priority'],
  data() {
    return {
      activeTab: 'board',
      loading: false,
      detailLoading: false,
      deptOptions: [],
      myDepts: [],
      subjectOptions: [],
      metrics: [],
      alertCount: 0,
      minAttempts: 3,
      questionMin: 2,
      weakRate: 0.6,
      paperCount: 0,
      questionCount: 0,
      boundQuestionCount: 0,
      scoreTotal: 0,
      activeMetric: '',
      detailRows: [],
      queryParams: { deptId: undefined, subjectId: undefined },
      ticketLoading: false,
      ticketList: [],
      ticketTotal: 0,
      ticketQuery: { pageNum: 1, pageSize: 10, metricCode: undefined, status: undefined },
      ticketOpen: false,
      ticketForm: {},
      ticketFormTitle: '',
      ticketsLoaded: false
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
    metricTitleMap() { return METRIC_TITLE },
    canFix() {
      const m = this.activeMetric
      return ['Q_NO_KNOWLEDGE', 'Q_NO_QUESTION_TYPE', 'Q_NO_BLOOM', 'Q_WEIGHT_SUM', 'Q_MISSING_EXAM_DATE', 'Q_PARTIAL_PAPER', 'Q_ORPHAN_SCORE', 'Q_BLANK_ZERO'].indexOf(m) >= 0
    },
    alertTitle() {
      return '质量告警 ' + this.alertCount + ' 项 · min-attempts=' + this.minAttempts
        + ' · 高频题次≥' + this.questionMin
        + ' · 低掌握<' + Math.round(this.weakRate * 100) + '%'
    },
    scopeHint() {
      if (!this.questionCount && !this.paperCount) return ''
      const bound = this.boundQuestionCount || 0
      const total = this.questionCount || 0
      const pct = total > 0 ? Math.round(bound * 1000 / total) / 10 : 100
      return '扫描范围：试卷 ' + (this.paperCount || 0)
        + ' · 题目 ' + total
        + '（已绑知识点 ' + bound + ' / ' + pct + '%）'
        + ' · 成绩明细 ' + (this.scoreTotal || 0)
        + '。计数为 0 表示该类问题未检出（数据健康），不是接口无数据。'
    },
    detailEmptyText() {
      if (!this.activeMetric) return '请点击指标卡片'
      const m = (this.metrics || []).find(x => x.code === this.activeMetric)
      if (m && !m.count) return '当前范围暂无此类问题（健康）'
      return '暂无下钻明细'
    },
    detailColumns() {
      const map = {
        Q_NO_KNOWLEDGE: [
          { prop: 'paperName', label: '试卷', width: 160 },
          { prop: 'questionNo', label: '题号', width: 80 },
          { prop: 'questionId', label: 'QID', width: 80 },
          { prop: 'fullScore', label: '满分', width: 80 }
        ],
        Q_NO_QUESTION_TYPE: [
          { prop: 'paperName', label: '试卷', width: 160 },
          { prop: 'questionNo', label: '题号', width: 80 },
          { prop: 'questionId', label: 'QID', width: 80 },
          { prop: 'fullScore', label: '满分', width: 80 }
        ],
        Q_NO_BLOOM: [
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
        Q_WEAK_LOW_EVIDENCE: [
          { prop: 'studentNo', label: '学号', width: 110 },
          { prop: 'studentName', label: '姓名', width: 90 },
          { prop: 'knowledgeName', label: '知识点', width: 140 },
          { prop: 'attemptCount', label: '练习次数', width: 90 },
          { prop: 'weightedRate', label: '得分率', width: 90 },
          { prop: 'weakLevel', label: '等级', width: 80 }
        ],
        Q_HIGH_FREQ_LOW_MASTERY: [
          { prop: 'knowledgeName', label: '知识点', width: 160 },
          { prop: 'questionCount', label: '题次数', width: 90 },
          { prop: 'avgRate', label: '班均得分率', width: 110 },
          { prop: 'studentCount', label: '人数', width: 80 },
          { prop: 'attemptAvg', label: '均练习', width: 80 }
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
    this.loadSubjects()
    const q = this.$route.query || {}
    const qDept = q.deptId != null && q.deptId !== '' ? Number(q.deptId) : undefined
    const qSubject = q.subjectId != null && q.subjectId !== '' ? Number(q.subjectId) : undefined
    this.loadMyDepts().then(() => {
      if (qDept && !isNaN(qDept)) {
        this.queryParams.deptId = qDept
      } else if (!this.queryParams.deptId && this.preferredDeptId) {
        this.queryParams.deptId = this.preferredDeptId
      }
      if (qSubject && !isNaN(qSubject)) {
        this.queryParams.subjectId = qSubject
      }
      this.handleQuery()
    })
  },
  methods: {
    metricTitle(code) { return METRIC_TITLE[code] || code },
    onTabClick(tab) {
      if (tab.name === 'ticket' && !this.ticketsLoaded) {
        this.loadTickets()
        this.ticketsLoaded = true
      }
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
      this.handleQuery()
    },
    loadSubjects() {
      return optionselectSubject().then(res => {
        this.subjectOptions = res.data || []
      }).catch(() => {
        this.subjectOptions = []
      })
    },
    handleQuery() {
      this.loading = true
      qualityOverview(this.queryParams).then(res => {
        const data = res.data || {}
        this.metrics = data.metrics || []
        this.alertCount = data.alertCount || 0
        this.minAttempts = data.minAttempts || 3
        this.questionMin = data.questionMin || 2
        this.weakRate = data.weakRate != null ? Number(data.weakRate) : 0.6
        this.paperCount = data.paperCount || 0
        this.questionCount = data.questionCount || 0
        this.boundQuestionCount = data.boundQuestionCount || 0
        this.scoreTotal = data.scoreTotal || 0
        const prefer = (this.metrics || []).find(m => Number(m.count) > 0)
        if (prefer) {
          this.loadDetail(prefer)
        } else {
          this.activeMetric = ''
          this.detailRows = []
        }
      }).finally(() => { this.loading = false })
    },
    resetQuery() {
      this.queryParams = { deptId: this.boundClassMode ? this.preferredDeptId : undefined, subjectId: undefined }
      this.activeMetric = ''
      this.detailRows = []
      this.handleQuery()
    },
    loadDetail(m) {
      this.activeMetric = m.code
      this.detailLoading = true
      qualityDetail({ metric: m.code, deptId: this.queryParams.deptId, subjectId: this.queryParams.subjectId }).then(res => {
        this.detailRows = res.data || []
      }).finally(() => { this.detailLoading = false })
    },
    goFix(row) {
      const m = this.activeMetric
      const target = row || ((this.detailRows && this.detailRows.length) ? this.detailRows[0] : null)
      const paperId = target && (target.paperId != null ? target.paperId : null)
      const questionId = target && (target.questionId != null ? target.questionId : null)
      const query = {}
      if (paperId != null) query.paperId = paperId
      if (questionId != null) query.questionId = questionId
      if (this.queryParams.subjectId) query.subjectId = this.queryParams.subjectId
      if (m === 'Q_PARTIAL_PAPER' || m === 'Q_ORPHAN_SCORE' || m === 'Q_BLANK_ZERO') {
        if (target && target.batchId != null) query.batchId = target.batchId
        this.$router.push({ path: '/spas/biz/score', query })
        return
      }
      this.$router.push({ path: '/spas/biz/paper', query })
    },
    goFixRow(row) {
      this.goFix(row)
    },
    createTicketFromMetric() {
      if (!this.activeMetric) return
      this.openTicketForm({
        metricCode: this.activeMetric,
        title: this.metricTitle(this.activeMetric) + ' 工单',
        status: '0',
        priority: '2',
        deptId: this.queryParams.deptId,
        subjectId: this.queryParams.subjectId,
        remark: 'from metric ' + this.activeMetric + ', rows=' + (this.detailRows || []).length
      })
    },
    loadTickets() {
      this.ticketLoading = true
      listQualityTicket(this.ticketQuery).then(res => {
        this.ticketList = res.rows || []
        this.ticketTotal = res.total || 0
      }).catch(() => {
        this.ticketList = []
        this.ticketTotal = 0
      }).finally(() => { this.ticketLoading = false })
    },
    openTicketForm(row) {
      if (row && row.ticketId) {
        this.ticketForm = Object.assign({}, row)
        this.ticketFormTitle = '修改工单'
      } else {
        this.ticketForm = Object.assign({
          metricCode: undefined,
          title: '',
          status: '0',
          priority: '2',
          ownerBy: undefined,
          remark: ''
        }, row || {})
        this.ticketFormTitle = '新增工单'
      }
      this.ticketOpen = true
    },
    submitTicket() {
      this.$refs.ticketFormRef.validate(valid => {
        if (!valid) return
        const req = this.ticketForm.ticketId ? updateQualityTicket : addQualityTicket
        req(this.ticketForm).then(() => {
          this.$modal.msgSuccess('保存成功')
          this.ticketOpen = false
          this.activeTab = 'ticket'
          this.ticketsLoaded = true
          this.loadTickets()
        })
      })
    },
    removeTicket(row) {
      this.$modal.confirm('确认删除工单 ' + row.ticketId + ' ?').then(() => {
        return delQualityTicket(row.ticketId)
      }).then(() => {
        this.$modal.msgSuccess('已删除')
        this.loadTickets()
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.spas-quality >>> .el-form--inline .class-row.el-form-item {
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
.metric-card {
  border: 1px solid #E2E8F0;
  border-radius: 10px;
  padding: 14px 16px;
  cursor: pointer;
  background: #fff;
  min-height: 118px;
  box-shadow: 0 1px 2px rgba(15,23,42,0.04), 0 6px 16px rgba(15,23,42,0.04);
  transition: border-color 0.15s ease, box-shadow 0.15s ease, transform 0.15s ease;
}
.metric-card:hover {
  border-color: #99F6E4;
  box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08);
  transform: translateY(-1px);
}
.metric-card.active {
  border-color: #2442ED;
  box-shadow: 0 0 0 1px rgba(36, 66, 237, 0.25), 0 8px 20px rgba(15, 23, 42, 0.08);
}
.metric-card.empty .metric-count { color: #94A3B8; }
.metric-card.level-severe { border-left: 3px solid #FF5A5F; background: linear-gradient(180deg, #FEF2F2 0%, #fff 48%); }
.metric-card.level-watch { border-left: 3px solid #D97706; background: linear-gradient(180deg, #FFFBEB 0%, #fff 48%); }
.metric-card.level-info { border-left: 3px solid #2442ED; background: linear-gradient(180deg, #F0F3FF 0%, #fff 48%); }
.metric-code { font-size: 11px; color: #64748B; letter-spacing: 0.04em; font-weight: 600; text-transform: uppercase; }
.metric-title { margin-top: 6px; font-size: 14px; color: #0F172A; font-weight: 500; }
.metric-count { margin-top: 12px; font-size: 30px; font-weight: 700; color: #0F172A; letter-spacing: -0.03em; font-variant-numeric: tabular-nums; }
.metric-extra { margin-top: 4px; font-size: 12px; color: #64748B; }
.card-header { font-weight: 600; letter-spacing: 0.01em; display: flex; align-items: center; justify-content: space-between; }
.card-header-actions { display: flex; align-items: center; gap: 4px; }
</style>
