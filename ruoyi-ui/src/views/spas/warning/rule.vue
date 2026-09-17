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
        <el-button type="warning" plain icon="el-icon-video-play" size="mini" :loading="runLoading" @click="handleRun" v-hasPermi="['spas:warning:rule:run']">立即执行</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

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
                <el-option v-for="op in operatorOptions" :key="op" :label="op" :value="op" />
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
                :min="form.metric === 'CONTINUOUS_DROP' ? 2 : 1"
                :max="30"
                controls-position="right"
                style="width: 100%"
              />
              <div v-if="form.metric === 'CONTINUOUS_DROP'" class="el-form-item__tip">取最近 N 场试卷得分率，需连续逐场下降且总降幅达阈值</div>
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
import { listWarningRule, getWarningRule, addWarningRule, updateWarningRule, delWarningRule, runWarningEngine } from '@/api/spas/warning'

export default {
  name: 'SpasWarningRule',
  dicts: ['spas_warning_level'],
  data() {
    return {
      loading: true,
      runLoading: false,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      ruleList: [],
      title: '',
      open: false,
      metricOptions: [
        { value: 'AVG_RATE', label: '平均得分率' },
        { value: 'WEAK_COUNT', label: '薄弱知识点数量' },
        { value: 'BELOW_CLASS_AVG', label: '低于班级均分差值' },
        { value: 'CONTINUOUS_DROP', label: '连续下滑幅度' }
      ],
      operatorOptions: ['<', '<=', '>', '>=', '='],
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
      return this.form.metric === 'CONTINUOUS_DROP' ? '连续场次' : '考试场次'
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
      return '按所选指标填写阈值'
    }
  },
  created() {
    this.getList()
  },
  methods: {
    metricLabel(metric) {
      const hit = this.metricOptions.find(i => i.value === metric)
      return hit ? hit.label : metric
    },
    handleMetricChange(metric) {
      if (metric === 'AVG_RATE') {
        this.form.operator = '<'
        if (this.form.threshold == null) this.form.threshold = 0.6
      } else if (metric === 'BELOW_CLASS_AVG') {
        this.form.operator = '>'
        if (this.form.threshold == null) this.form.threshold = 0.1
      } else if (metric === 'WEAK_COUNT') {
        this.form.operator = '>'
        if (this.form.threshold == null) this.form.threshold = 3
      } else if (metric === 'CONTINUOUS_DROP') {
        this.form.operator = '>'
        if (this.form.threshold == null) this.form.threshold = 0.1
        if (!this.form.windowDays || this.form.windowDays < 2) this.form.windowDays = 3
      }
    },
    formatCondition(row) {
      const defaults = { AVG_RATE: '<', WEAK_COUNT: '>', BELOW_CLASS_AVG: '>', CONTINUOUS_DROP: '>' }
      const op = row.operator || defaults[row.metric] || '<'
      const n = Number(row.threshold)
      if (isNaN(n)) {
        return op + ' ' + (row.threshold == null ? '-' : row.threshold)
      }
      if (row.metric === 'AVG_RATE' || row.metric === 'BELOW_CLASS_AVG' || row.metric === 'CONTINUOUS_DROP') {
        const pct = n <= 1 ? (Math.round(n * 10000) / 100).toFixed(1) + '%' : n
        const extra = row.metric === 'CONTINUOUS_DROP' && row.windowDays ? ` / ${row.windowDays}场` : ''
        return op + ' ' + pct + extra
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
      if (this.form.metric === 'CONTINUOUS_DROP' && (!this.form.windowDays || this.form.windowDays < 2)) {
        this.$modal.msgError('连续下滑至少需要 2 场考试')
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
        operator: '<',
        threshold: 0.6,
        windowDays: 3,
        level: '1',
        enabled: '1',
        notifyChannels: 'system',
        remark: undefined
      }
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
        this.form = response.data
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
        const req = this.form.ruleId != null ? updateWarningRule(this.form) : addWarningRule(this.form)
        req.then(() => {
          this.$modal.msgSuccess('操作成功')
          this.open = false
          this.getList()
        })
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
      this.$modal.confirm('确认立即执行全部启用规则？').then(() => {
        this.runLoading = true
        return runWarningEngine()
      }).then(res => {
        this.$modal.msgSuccess(res.msg || '执行完成')
      }).catch(() => {}).finally(() => {
        this.runLoading = false
      })
    }
  }
}
</script>

