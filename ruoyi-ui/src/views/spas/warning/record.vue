<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="班级" prop="deptId">
        <treeselect
          v-model="queryParams.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="全部班级"
          style="width: 220px"
        />
      </el-form-item>
      <el-form-item label="学科" prop="subjectId">
        <el-select v-model="queryParams.subjectId" placeholder="全部学科" clearable filterable style="width: 140px">
          <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
        </el-select>
      </el-form-item>
      <el-form-item label="学号" prop="studentNo">
        <el-input v-model="queryParams.studentNo" placeholder="学号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="学生" prop="studentName">
        <el-input v-model="queryParams.studentName" placeholder="姓名" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="级别" prop="level">
        <el-select v-model="queryParams.level" placeholder="级别" clearable style="width: 120px">
          <el-option v-for="dict in dict.type.spas_warning_level" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 120px">
          <el-option v-for="dict in dict.type.spas_warning_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['spas:warning:record']">导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-check" size="mini" :disabled="!ids.length" @click="openBatchHandle('1')" v-hasPermi="['spas:warning:record:handle']">批量处理</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" plain icon="el-icon-close" size="mini" :disabled="!ids.length" @click="openBatchHandle('2')" v-hasPermi="['spas:warning:record:handle']">批量忽略</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>


    <el-empty
      v-if="!loading && (!recordList || recordList.length===0)"
      :image-size="72"
      description="暂无预警记录"
      class="mb8"
    >
      <div class="empty-actions">
        <el-button type="primary" size="mini" icon="el-icon-video-play" @click="$router.push('/spas/warning/rule')" v-hasPermi="['spas:warning:rule']">去规则立即执行</el-button>
        <el-button size="mini" @click="resetQuery">清空筛选</el-button>
      </div>
    </el-empty>
    <el-table v-loading="loading" :data="recordList" @selection-change="handleSelectionChange" v-show="loading || (recordList && recordList.length)">
      <el-table-column type="selection" width="50" align="center" :selectable="rowSelectable" />
      <el-table-column label="编号" align="center" prop="warningId" width="80" />
      <el-table-column label="学号" align="center" prop="studentNo" width="120" />
      <el-table-column label="学生" align="center" prop="studentName" width="100" />
      <el-table-column label="规则" align="center" prop="ruleName" min-width="140" :show-overflow-tooltip="true" />
      <el-table-column label="触发说明" align="center" prop="content" min-width="220" :show-overflow-tooltip="true" />
      <el-table-column label="标题" align="center" prop="title" min-width="120" :show-overflow-tooltip="true" />
      <el-table-column label="指标值" align="center" prop="metricValue" width="110">
        <template slot-scope="scope">
          <span>{{ formatMetricValue(scope.row) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="级别" align="center" prop="level" width="90">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.spas_warning_level" :value="scope.row.level" />
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.spas_warning_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="时间" align="center" prop="createTime" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="340">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button
            v-if="scope.row.status === '0'"
            size="mini"
            type="text"
            icon="el-icon-check"
            @click="openHandle(scope.row, '1')"
            v-hasPermi="['spas:warning:record:handle']"
          >处理</el-button>
          <el-button
            v-if="scope.row.status === '0'"
            size="mini"
            type="text"
            icon="el-icon-close"
            @click="openHandle(scope.row, '2')"
            v-hasPermi="['spas:warning:record:handle']"
          >忽略</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-s-flag"
            @click="goIntervene(scope.row)"
            v-hasPermi="['spas:intervene:add']"
          >发起干预</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-data-analysis"
            @click="goAnalysis(scope.row)"
            v-hasPermi="['spas:analysis:student']"
          >学情</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-user"
            @click="goPortfolio(scope.row)"
            v-hasPermi="['spas:portfolio:list']"
          >档案</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="预警详情" :visible.sync="viewOpen" width="560px" append-to-body>
      <el-descriptions :column="1" border size="small">
        <el-descriptions-item label="学生">{{ current.studentNo }} · {{ current.studentName }}</el-descriptions-item>
        <el-descriptions-item label="规则">{{ current.ruleName }}</el-descriptions-item>
        <el-descriptions-item label="标题">{{ current.title }}</el-descriptions-item>
        <el-descriptions-item label="内容">{{ current.content }}</el-descriptions-item>
        <el-descriptions-item label="指标值">{{ formatMetricValue(current) }}</el-descriptions-item>
        <el-descriptions-item v-if="reasonRows.length" label="结构化原因">
          <div v-for="row in reasonRows" :key="row.k" style="line-height: 1.6">{{ row.k }}：{{ row.v }}</div>
        </el-descriptions-item>
        <el-descriptions-item label="处理人">{{ current.handleBy || '-' }}</el-descriptions-item>
        <el-descriptions-item label="处理时间">{{ parseTime(current.handleTime) || '-' }}</el-descriptions-item>
        <el-descriptions-item label="处理备注">{{ current.handleRemark || '-' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>

    <el-dialog :title="handleTitle" :visible.sync="handleOpen" width="480px" append-to-body>
      <el-form ref="handleForm" :model="handleForm" label-width="80px">
        <el-form-item label="备注">
          <el-input v-model="handleForm.handleRemark" type="textarea" :rows="3" placeholder="请输入处理说明" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitHandle">确 定</el-button>
        <el-button @click="handleOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="关联薄弱知识点" :visible.sync="kpOpen" width="520px" append-to-body>
      <p class="mb8" style="color:#64748B;font-size:13px">
        将按该生当前薄弱知识点创建干预并冻结基线（默认全选，可取消个别项）。
      </p>
      <div v-loading="kpLoading">
        <el-empty v-if="!kpLoading && !knowledgeOptions.length" description="未找到薄弱知识点，请先在学情分析中确认数据" :image-size="64" />
        <el-select
          v-else
          v-model="kpForm.knowledgeIds"
          multiple
          filterable
          collapse-tags
          placeholder="选择薄弱知识点"
          style="width: 100%"
        >
          <el-option
            v-for="item in knowledgeOptions"
            :key="item.knowledgeId"
            :label="weakKpLabel(item)"
            :value="item.knowledgeId"
          />
        </el-select>
        <p v-if="knowledgeOptions.length" class="mt8" style="color:#94A3B8;font-size:12px;margin:8px 0 0">
          已选 {{ (kpForm.knowledgeIds || []).length }} / {{ knowledgeOptions.length }} 个
          <el-button type="text" size="mini" @click="selectAllWeakKp">全选</el-button>
          <el-button type="text" size="mini" @click="kpForm.knowledgeIds = []">清空</el-button>
        </p>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" :disabled="kpLoading || !(kpForm.knowledgeIds && kpForm.knowledgeIds.length)" @click="submitInterveneKp">创建干预</el-button>
        <el-button @click="kpOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listWarningRecord, handleWarningRecord } from '@/api/spas/warning'
import { createFromWarning } from '@/api/spas/intervene'
import { weakTopStudent } from '@/api/spas/analysis'
import { optionselectSubject } from '@/api/spas/subject'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
import { applyTeachingDeptContext, canLoadSystemDeptTree } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  name: 'SpasWarningRecord',
  components: { Treeselect },
  dicts: ['spas_warning_level', 'spas_warning_status'],
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      recordList: [],
      ids: [],
      selectedRows: [],
      deptOptions: [],
      myDepts: [],
      subjectOptions: [],
      viewOpen: false,
      handleOpen: false,
      handleTitle: '',
      current: {},
      handleForm: {
        warningId: undefined,
        status: undefined,
        handleRemark: undefined
      },
      kpOpen: false,
      kpLoading: false,
      kpForm: { knowledgeIds: [] },
      knowledgeOptions: [],
      pendingWarning: null,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deptId: undefined,
        subjectId: undefined,
        studentNo: undefined,
        studentName: undefined,
        level: undefined,
        status: '0'
      }
    }
  },
  computed: {
    reasonRows() {
      const raw = this.current && this.current.reasonJson
      if (!raw) return []
      let obj
      try {
        obj = typeof raw === 'string' ? JSON.parse(raw) : raw
      } catch (e) {
        return []
      }
      const labels = {
        metricLabel: '指标',
        operator: '运算符',
        threshold: '阈值',
        metricValue: '当前值',
        analysisWindow: '分析口径',
        windowDays: '场次窗',
        ruleCode: '规则码',
        level: '级别'
      }
      const order = ['metricLabel', 'operator', 'threshold', 'metricValue', 'analysisWindow', 'windowDays', 'ruleCode', 'level']
      const rows = []
      order.forEach(k => {
        if (obj[k] != null && obj[k] !== '') {
          rows.push({ k: labels[k] || k, v: String(obj[k]) })
        }
      })
      return rows
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.deptId) this.queryParams.deptId = isNaN(Number(q.deptId)) ? q.deptId : Number(q.deptId)
    if (q.subjectId) this.queryParams.subjectId = isNaN(Number(q.subjectId)) ? q.subjectId : Number(q.subjectId)
    if (q.status !== undefined) this.queryParams.status = q.status
    this.loadSubjects()
    this.loadDepts().then(() => this.getList())
  },
  methods: {
    loadSubjects() {
      return optionselectSubject().then(res => {
        this.subjectOptions = res.data || []
      }).catch(() => { this.subjectOptions = [] })
    },
    loadDepts() {
      return applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).catch(() => {
        if (!canLoadSystemDeptTree()) {
          this.deptOptions = []
          return Promise.resolve()
        }
        return deptTreeSelect().then(res => {
          this.deptOptions = res.data || []
        }).catch(() => { this.deptOptions = [] })
      })
    },
    getList() {
      this.loading = true
      listWarningRecord(this.queryParams).then(response => {
        this.recordList = response.rows
        this.total = response.total
        this.loading = false
      }).catch(() => { this.loading = false })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    handleExport() {
      this.download('spas/warning/record/export', { ...this.queryParams }, `warning_record_${new Date().getTime()}.xlsx`)
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.queryParams.deptId = undefined
      this.queryParams.subjectId = undefined
      this.queryParams.status = '0'
      this.handleQuery()
    },
    handleView(row) {
      this.current = row
      this.viewOpen = true
    },
    handleSelectionChange(selection) {
      this.selectedRows = selection || []
      this.ids = (selection || []).map(r => r.warningId)
    },
    rowSelectable(row) {
      return row && row.status === '0'
    },
    openBatchHandle(status) {
      const openRows = (this.selectedRows || []).filter(r => r.status === '0')
      if (!openRows.length) {
        this.$modal.msgWarning('请先勾选待处理的预警')
        return
      }
      this.handleForm = {
        warningId: undefined,
        warningIds: openRows.map(r => r.warningId),
        status: status,
        handleRemark: undefined
      }
      this.handleTitle = (status === '1' ? '批量处理' : '批量忽略') + ' (' + openRows.length + ')'
      this.handleOpen = true
    },
    openHandle(row, status) {
      this.handleForm = {
        warningId: row.warningId,
        warningIds: undefined,
        status: status,
        handleRemark: undefined
      }
      this.handleTitle = status === '1' ? '处理预警' : '忽略预警'
      this.handleOpen = true
    },
    submitHandle() {
      const ids = this.handleForm.warningIds && this.handleForm.warningIds.length
        ? this.handleForm.warningIds
        : (this.handleForm.warningId != null ? [this.handleForm.warningId] : [])
      if (!ids.length) {
        this.$modal.msgWarning('无效预警')
        return
      }
      const tasks = ids.map(id => handleWarningRecord({
        warningId: id,
        status: this.handleForm.status,
        handleRemark: this.handleForm.handleRemark
      }))
      Promise.all(tasks).then(() => {
        this.$modal.msgSuccess('操作成功 (' + ids.length + ')')
        this.handleOpen = false
        this.getList()
      }).catch(() => {})
    },
    formatMetricValue(row) {
      if (!row || row.metricValue == null || row.metricValue === '') {
        return '-'
      }
      const n = Number(row.metricValue)
      if (isNaN(n)) {
        return row.metricValue
      }
      const metric = (row.metric || row.ruleCode || '').toString()
      const isRate = metric.indexOf('RATE') >= 0 || metric.indexOf('AVG') >= 0 || (n >= 0 && n <= 1)
      if (isRate && n <= 1) {
        return (Math.round(n * 10000) / 100).toFixed(1) + '%'
      }
      return n
    },
    goPortfolio(row) {
      const query = { studentId: row.studentId }
      if (row.subjectId) {
        query.subjectId = row.subjectId
      }
      this.$router.push({ path: '/spas/portfolio', query })
    },
    goAnalysis(row) {
      const query = { studentId: row.studentId }
      if (row.subjectId) {
        query.subjectId = row.subjectId
      }
      this.$router.push({ path: '/spas/analysis/student', query })
    },
    goIntervene(row) {
      if (!row || !row.studentId) {
        this.$modal.msgWarning('预警缺少学生信息')
        return
      }
      this.pendingWarning = row
      this.kpForm = { knowledgeIds: [] }
      this.knowledgeOptions = []
      this.kpOpen = true
      this.kpLoading = true
      weakTopStudent(row.studentId, {
        subjectId: row.subjectId,
        limit: 100
      }).then(res => {
        const list = this.normalizeWeakList(res && res.data)
        // 预警已挂知识点时一并纳入，避免漏关联
        if (row.knowledgeId && !list.some(i => String(i.knowledgeId) === String(row.knowledgeId))) {
          list.unshift({
            knowledgeId: row.knowledgeId,
            knowledgeName: row.knowledgeName || ('#' + row.knowledgeId),
            rate: null,
            weakLevel: '2'
          })
        }
        this.knowledgeOptions = list
        this.kpForm.knowledgeIds = list.map(i => i.knowledgeId)
        if (!list.length) {
          this.$modal.msgWarning('该生暂无薄弱知识点，请先在学情分析中确认')
        }
      }).catch(() => {
        this.knowledgeOptions = []
        this.$modal.msgError('加载薄弱知识点失败')
      }).finally(() => {
        this.kpLoading = false
      })
    },
    normalizeWeakList(raw) {
      const rows = Array.isArray(raw) ? raw : []
      const out = []
      const seen = {}
      rows.forEach(r => {
        const id = r.knowledgeId != null ? r.knowledgeId : r.id
        if (id == null || seen[String(id)]) return
        const level = String(r.weakLevel != null ? r.weakLevel : '')
        const rate = r.rate != null ? Number(r.rate) : (r.weightedRate != null ? Number(r.weightedRate) : null)
        // 薄弱：关注/薄弱/严重，或得分率低于 60%
        const isWeak = level === '1' || level === '2' || level === '3' || (rate != null && !isNaN(rate) && rate < 0.6)
        if (!isWeak) return
        seen[String(id)] = true
        out.push({
          knowledgeId: id,
          knowledgeName: r.knowledgeName || r.name || ('#' + id),
          rate: rate,
          weakLevel: level || undefined
        })
      })
      return out
    },
    weakKpLabel(item) {
      const name = item.knowledgeName || ('#' + item.knowledgeId)
      if (item.rate == null || isNaN(Number(item.rate))) return name
      const n = Number(item.rate)
      const pct = Math.abs(n) <= 1 ? n * 100 : n
      return name + '（' + pct.toFixed(1) + '%）'
    },
    selectAllWeakKp() {
      this.kpForm.knowledgeIds = (this.knowledgeOptions || []).map(i => i.knowledgeId)
    },
    submitInterveneKp() {
      const ids = this.kpForm.knowledgeIds || []
      if (!ids.length) {
        this.$modal.msgWarning('请至少选择一个薄弱知识点')
        return
      }
      this.submitFromWarning(this.pendingWarning, ids)
    },
    submitFromWarning(row, knowledgeIdList) {
      if (!row) return
      const n = (knowledgeIdList || []).length
      this.$modal.confirm('确认为该预警创建干预任务？将关联 ' + n + ' 个知识点并冻结基线。').then(() => {
        return createFromWarning(row.warningId, {
          subjectId: row.subjectId,
          targetRate: 0.6,
          knowledgeIdList
        })
      }).then(res => {
        this.kpOpen = false
        const id = res.data && res.data.interveneId
        this.$modal.msgSuccess('干预任务已创建' + (id ? (' #' + id) : '') + '，已关联 ' + n + ' 个知识点')
        this.$router.push({ path: '/spas/intervene', query: { status: '0' } })
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.empty-actions {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 8px;
}
.mb8 { margin-bottom: 12px; }
</style>
