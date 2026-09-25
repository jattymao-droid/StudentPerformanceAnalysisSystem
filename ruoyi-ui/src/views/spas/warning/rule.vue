<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="规则名称" prop="ruleName">
        <el-input v-model="queryParams.ruleName" placeholder="请输入规则名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="指标" prop="metric">
        <el-select v-model="queryParams.metric" placeholder="指标" clearable style="width: 160px">
          <el-option v-for="item in metricOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="启用" prop="enabled">
        <el-select v-model="queryParams.enabled" placeholder="状态" clearable style="width: 120px">
          <el-option label="启用" value="1" />
          <el-option label="停用" value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['spas:warning:rule:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['spas:warning:rule:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['spas:warning:rule:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-select v-model="runWindow" size="mini" style="width: 140px; margin-right: 8px" placeholder="执行口径">
          <el-option label="默认时间窗" value="" />
          <el-option label="本学期" value="semester" />
          <el-option label="近30天" value="last30d" />
          <el-option label="近90天" value="last90d" />
          <el-option label="全部(快照)" value="all" />
        </el-select>
        <el-button type="warning" plain icon="el-icon-video-play" size="mini" :loading="runLoading" @click="handleRun" v-hasPermi="['spas:warning:rule:run']">立即执行</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>
    <el-alert
      class="mb8"
      type="info"
      :closable="false"
      show-icon
      title="执行口径与学情分析页时间窗一致（本学期/近30天等）。校次类规则（RANK_*）仍按实考场次与规则「窗口场数」判定，不受上方时间窗过滤。"
    />

    <el-table v-loading="loading" :data="ruleList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="编号" align="center" prop="ruleId" width="80" />
      <el-table-column label="规则名称" align="center" prop="ruleName" min-width="140" :show-overflow-tooltip="true" />
      <el-table-column label="编码" align="center" prop="ruleCode" min-width="120" />
      <el-table-column label="指标" align="center" prop="metric" min-width="140">
        <template slot-scope="scope">{{ metricLabel(scope.row.metric) }}</template>
      </el-table-column>
      <el-table-column label="条件" align="center" min-width="140">
        <template slot-scope="scope">{{ formatCondition(scope.row) }}</template>
      </el-table-column>
      <el-table-column label="级别" align="center" prop="level" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.spas_warning_level" :value="scope.row.level" />
        </template>
      </el-table-column>
      <el-table-column label="通知渠道" align="center" min-width="160">
        <template slot-scope="scope">
          <template v-for="ch in channelTags(scope.row.notifyChannels)">
            <el-tag
              v-if="ch === 'webhook'"
              :key="ch"
              size="mini"
              style="margin:0 2px"
              :type="webhookConfigured ? 'warning' : 'danger'"
            >{{ webhookConfigured ? 'Webhook' : 'Webhook未配置' }}</el-tag>
            <el-tag v-else :key="ch" size="mini" style="margin:0 2px">系统</el-tag>
          </template>
        </template>
      </el-table-column>
      <el-table-column label="启用" align="center" prop="enabled" width="100">
        <template slot-scope="scope">
          <el-tag :type="scope.row.enabled === '1' ? 'success' : 'info'" size="mini">
            {{ scope.row.enabled === '1' ? '启用' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['spas:warning:rule:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['spas:warning:rule:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="620px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="规则名称" prop="ruleName">
          <el-input v-model="form.ruleName" maxlength="64" placeholder="请输入规则名称" />
        </el-form-item>
        <el-form-item label="规则编码" prop="ruleCode">
          <el-input v-model="form.ruleCode" maxlength="64" placeholder="唯一编码，如 AVG_LOW" />
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="作用范围" prop="scopeType">
              <el-select v-model="form.scopeType" style="width: 100%">
                <el-option label="全部" value="1" />
                <el-option label="班级" value="3" />
                <el-option label="学科" value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="范围ID" prop="scopeId">
              <el-input-number v-model="form.scopeId" :min="1" controls-position="right" style="width: 100%" :disabled="form.scopeType === '1'" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="指标" prop="metric">
              <el-select v-model="form.metric" style="width: 100%" @change="handleMetricChange">
                <el-option v-for="item in metricOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="运算符" prop="operator">
              <el-select v-model="form.operator" style="width: 100%">
                <el-option v-for="op in operatorOptions" :key="op.value" :label="op.label" :value="op.value" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="阈值" prop="threshold">
              <el-input-number v-model="form.threshold" :precision="4" :step="0.1" controls-position="right" style="width: 100%" />
              <div class="el-form-item__tip">{{ thresholdHint }}</div>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item :label="windowDaysLabel" prop="windowDays">
              <el-input-number
                v-model="form.windowDays"
                :min="(form.metric === 'CONTINUOUS_DROP' || form.metric === 'KNOWLEDGE_CONTINUOUS_DROP' || form.metric === 'RANK_DROP') ? 2 : 1"
                :max="30"
                controls-position="right"
                style="width: 100%"
              />
              <div v-if="form.metric === 'CONTINUOUS_DROP'" class="el-form-item__tip">取最近 N 场试卷得分率，需连续逐场下降且总降幅达阈值</div>
              <div v-if="form.metric === 'KNOWLEDGE_CONTINUOUS_DROP'" class="el-form-item__tip">取最近 N 场，统计连续下滑的知识点个数；阈值为个数</div>
              <div v-if="form.metric === 'RANK_DROP'" class="el-form-item__tip">取最近 N 场总分校次，须逐场名次变差。阈值是退步名次，例如 &gt; 10</div>
              <div v-if="form.metric === 'SUBJECT_IMBALANCE'" class="el-form-item__tip">最近一场里，单科校次比总分校次落后的最大名次。场次不参与计算</div>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="级别" prop="level">
              <el-select v-model="form.level" style="width: 100%">
                <el-option v-for="dict in dict.type.spas_warning_level" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="启用" prop="enabled">
              <el-radio-group v-model="form.enabled">
                <el-radio label="1">启用</el-radio>
                <el-radio label="0">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="通知渠道">
          <el-checkbox-group v-model="notifyChannelList">
            <el-checkbox label="system">系统通知</el-checkbox>
            <el-checkbox label="webhook">Webhook</el-checkbox>
          </el-checkbox-group>
          <el-alert
            v-if="notifyChannelList.indexOf('webhook') >= 0 && !webhookConfigured"
            style="margin-top:8px"
            type="warning"
            :closable="false"
            show-icon
            title="当前未配置 spas.warning.webhook-url（环境变量 SPAS_WARNING_WEBHOOK_URL），勾选 Webhook 不会实际推送"
          />
          <div v-else-if="notifyChannelList.indexOf('webhook') >= 0 && webhookConfigured" class="el-form-item__tip">
            Webhook 已配置，触发后将 POST JSON 到该地址
          </div>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listWarningRule, getWarningRule, addWarningRule, updateWarningRule, delWarningRule, runWarningEngine, warningNotifyStatus } from '@/api/spas/warning'

export default {
  name: 'SpasWarningRule',
  dicts: ['spas_warning_level'],
  data() {
    return {
      loading: true,
      runLoading: false,
      runWindow: '',
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      ruleList: [],
      title: '',
      open: false,
      webhookConfigured: false,
      notifyChannelList: ['system'],
      metricOptions: [
        { value: 'AVG_RATE', label: '平均得分率' },
        { value: 'WEAK_COUNT', label: '薄弱知识点数量' },
        { value: 'BELOW_CLASS_AVG', label: '低于班级均分差值' },
        { value: 'CONTINUOUS_DROP', label: '连续下滑幅度' },
        { value: 'PERSISTENT_WEAK', label: '反复薄弱知识点数' },
        { value: 'KNOWLEDGE_CONTINUOUS_DROP', label: '知识点连续下滑数' },
        { value: 'RANK_DROP', label: '总分校次连续下滑' },
        { value: 'SUBJECT_IMBALANCE', label: '单科落后总分' }
      ],
      operatorOptions: [
        { value: 'LT', label: '<' },
        { value: 'LE', label: '<=' },
        { value: 'GT', label: '>' },
        { value: 'GE', label: '>=' },
        { value: 'EQ', label: '=' }
      ],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ruleName: undefined,
        metric: undefined,
        enabled: undefined
      },
      form: {},
      rules: {
        ruleName: [{ required: true, message: '规则名称不能为空', trigger: 'blur' }],
        ruleCode: [{ required: true, message: '规则编码不能为空', trigger: 'blur' }],
        metric: [{ required: true, message: '指标不能为空', trigger: 'change' }],
        threshold: [{ required: true, message: '阈值不能为空', trigger: 'blur' }]
      }
    }
  },
  computed: {
    windowDaysLabel() {
      if (this.form.metric === 'CONTINUOUS_DROP' || this.form.metric === 'KNOWLEDGE_CONTINUOUS_DROP' || this.form.metric === 'RANK_DROP') return '连续场次'
      if (this.form.metric === 'PERSISTENT_WEAK') return '最少场次'
      return '考试场次'
    },
    thresholdHint() {
      if (this.form.metric === 'AVG_RATE') {
        return '得分率请填 0~1，默认运算符 <，例如 < 0.6 表示平均得分率低于60%'
      }
      if (this.form.metric === 'BELOW_CLASS_AVG') {
        return '指标=班级均分-学生均分（越大越低于班级）。建议运算符 >，例如 > 0.1 表示低于班级超10%'
      }
      if (this.form.metric === 'WEAK_COUNT') {
        return '薄弱知识点数量，建议运算符 >，例如 > 3'
      }
      if (this.form.metric === 'CONTINUOUS_DROP') {
        return '阈值=首场与末场得分率差值（0~1）。建议运算符 >，例如 > 0.1 表示连续下滑超10%'
      }
      if (this.form.metric === 'PERSISTENT_WEAK') {
        return '指标=反复薄弱知识点数。最少场次=判定所需有效考试场数；阈值建议 > 0（有任意反复薄弱即预警）'
      }
      if (this.form.metric === 'RANK_DROP') {
        return '指标=最近 N 场总分校次退步名次（末场-首场，名次数字变大）。须逐场变差。建议 > 10，连续场次至少 2'
      }
      if (this.form.metric === 'SUBJECT_IMBALANCE') {
        return '指标=单科校次减总分校次的最大正差距。建议运算符 >，例如 > 20 表示至少一科比总分落后超过 20 名'
      }
      return '按所选指标填写阈值'
    }
  },
  created() {
    this.getList()
    warningNotifyStatus().then(res => {
      this.webhookConfigured = !!(res.data && res.data.webhookConfigured)
    }).catch(() => { this.webhookConfigured = false })
  },
  methods: {
    channelTags(raw) {
      const list = String(raw || 'system').split(',').map(s => s.trim()).filter(Boolean)
      return list.length ? list : ['system']
    },
    metricLabel(metric) {
      const hit = this.metricOptions.find(i => i.value === metric)
      return hit ? hit.label : metric
    },
    handleMetricChange(metric) {
      if (metric === 'AVG_RATE') {
        this.form.operator = 'LT'
        if (this.form.threshold == null) this.form.threshold = 0.6
      } else if (metric === 'BELOW_CLASS_AVG') {
        this.form.operator = 'GT'
        if (this.form.threshold == null) this.form.threshold = 0.1
      } else if (metric === 'WEAK_COUNT') {
        this.form.operator = 'GT'
        if (this.form.threshold == null) this.form.threshold = 3
      } else if (metric === 'CONTINUOUS_DROP') {
        this.form.operator = 'GT'
        if (this.form.threshold == null) this.form.threshold = 0.1
        if (!this.form.windowDays || this.form.windowDays < 2) this.form.windowDays = 3
      } else if (metric === 'PERSISTENT_WEAK') {
        this.form.operator = 'GT'
        if (this.form.threshold == null) this.form.threshold = 0
        if (!this.form.windowDays || this.form.windowDays < 2) this.form.windowDays = 3
      } else if (metric === 'RANK_DROP') {
        this.form.operator = 'GT'
        if (this.form.threshold == null) this.form.threshold = 10
        if (!this.form.windowDays || this.form.windowDays < 2) this.form.windowDays = 3
      } else if (metric === 'SUBJECT_IMBALANCE') {
        this.form.operator = 'GT'
        if (this.form.threshold == null) this.form.threshold = 20
      }
    },
    toOperatorCode(op) {
      const map = { '<': 'LT', '<=': 'LE', '>': 'GT', '>=': 'GE', '=': 'EQ', LT: 'LT', LE: 'LE', GT: 'GT', GE: 'GE', EQ: 'EQ' }
      return map[op] || op || 'LT'
    },
    formatCondition(row) {
      const defaults = { AVG_RATE: '<', WEAK_COUNT: '>', BELOW_CLASS_AVG: '>', CONTINUOUS_DROP: '>', PERSISTENT_WEAK: '>', KNOWLEDGE_CONTINUOUS_DROP: '>', RANK_DROP: '>', SUBJECT_IMBALANCE: '>' }
      const code = this.toOperatorCode(row.operator || defaults[row.metric] || '<')
      const hit = this.operatorOptions.find(i => i.value === code)
      const op = hit ? hit.label : code
      const n = Number(row.threshold)
      if (isNaN(n)) {
        return op + ' ' + (row.threshold == null ? '-' : row.threshold)
      }
      if (row.metric === 'AVG_RATE' || row.metric === 'BELOW_CLASS_AVG' || row.metric === 'CONTINUOUS_DROP') {
        const pct = n <= 1 ? (Math.round(n * 10000) / 100).toFixed(1) + '%' : n
        const extra = row.metric === 'CONTINUOUS_DROP' && row.windowDays ? ` / ${row.windowDays}场` : ''
        return op + ' ' + pct + extra
      }
      if (row.metric === 'PERSISTENT_WEAK') {
        const extra = row.windowDays ? ` / 最少${row.windowDays}场` : ''
        return op + ' ' + n + '个' + extra
      }
      return op + ' ' + n
    },
    validateRuleForm() {
      if (this.form.scopeType !== '1' && (this.form.scopeId == null || this.form.scopeId === '')) {
        this.$modal.msgError('班级/学科范围必须填写范围ID')
        return false
      }
      if (this.form.threshold == null || this.form.threshold === '') {
        this.$modal.msgError('阈值不能为空')
        return false
      }
      const n = Number(this.form.threshold)
      if (['AVG_RATE', 'BELOW_CLASS_AVG', 'CONTINUOUS_DROP'].includes(this.form.metric)) {
        if (isNaN(n) || n < 0 || n > 1) {
          this.$modal.msgError('该指标阈值请填写 0~1')
          return false
        }
      }
      if (this.form.metric === 'WEAK_COUNT' && (isNaN(n) || n < 0)) {
        this.$modal.msgError('薄弱知识点数量阈值不能为负数')
        return false
      }
      if ((this.form.metric === 'CONTINUOUS_DROP' || this.form.metric === 'KNOWLEDGE_CONTINUOUS_DROP' || this.form.metric === 'RANK_DROP') && (!this.form.windowDays || this.form.windowDays < 2)) {
        this.$modal.msgError('连续下滑至少需要 2 场考试')
        return false
      }
      if ((this.form.metric === 'RANK_DROP' || this.form.metric === 'SUBJECT_IMBALANCE') && (isNaN(n) || n < 0)) {
        this.$modal.msgError('名次阈值不能为负数')
        return false
      }
      return true
    },
    getList() {
      this.loading = true
      listWarningRule(this.queryParams).then(response => {
        this.ruleList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        ruleId: undefined,
        ruleName: undefined,
        ruleCode: undefined,
        scopeType: '1',
        scopeId: undefined,
        metric: 'AVG_RATE',
        operator: 'LT',
        threshold: 0.6,
        windowDays: 3,
        level: '1',
        enabled: '1',
        notifyChannels: 'system',
        remark: undefined
      }
      this.notifyChannelList = ['system']
      this.resetForm('form')
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.ruleId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '新增预警规则'
    },
    handleUpdate(row) {
      this.reset()
      const ruleId = row.ruleId || this.ids
      getWarningRule(ruleId).then(response => {
        this.form = response.data || {}
        this.form.operator = this.toOperatorCode(this.form.operator)
        const ch = (this.form.notifyChannels || 'system').split(',').map(s => s.trim()).filter(Boolean)
        this.notifyChannelList = ch.length ? ch : ['system']
        this.open = true
        this.title = '修改预警规则'
      })
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (!valid) {
          return
        }
        if (!this.validateRuleForm()) {
          return
        }
        if (this.form.scopeType === '1') {
          this.form.scopeId = undefined
        }
        this.form.notifyChannels = (this.notifyChannelList || []).join(',') || 'system'
        const doSave = () => {
          const req = this.form.ruleId != null ? updateWarningRule(this.form) : addWarningRule(this.form)
          req.then(() => {
            this.$modal.msgSuccess('操作成功')
            this.open = false
            this.getList()
          })
        }
        if (this.notifyChannelList.indexOf('webhook') >= 0 && !this.webhookConfigured) {
          this.$modal.confirm('当前未配置 Webhook URL，勾选后不会实际推送。仍要保存？').then(doSave).catch(() => {})
          return
        }
        doSave()
      })
    },
    handleDelete(row) {
      const ruleIds = row.ruleId || this.ids
      this.$modal.confirm('是否确认删除规则编号为"' + ruleIds + '"的数据项？').then(() => {
        return delWarningRule(ruleIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    handleRun() {
      const win = this.runWindow || ''
      const tip = win
        ? ('确认按口径「' + ({ semester: '本学期', last30d: '近30天', last90d: '近90天', all: '全部(快照)' }[win] || win) + '」执行全部启用规则？')
        : '确认按系统默认时间窗执行全部启用规则？'
      this.$modal.confirm(tip).then(() => {
        this.runLoading = true
        return runWarningEngine(win || undefined)
      }).then(res => {
        this.$modal.msgSuccess(res.msg || '执行完成')
      }).catch(() => {}).finally(() => {
        this.runLoading = false
      })
    }
  }
}
</script>

