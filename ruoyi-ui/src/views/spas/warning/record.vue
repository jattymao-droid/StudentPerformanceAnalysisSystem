<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
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
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>


    <el-alert v-if="!loading && (!recordList || recordList.length===0)" type="info" :closable="false" show-icon style="margin-bottom:12px"
      title="暂无预警记录：可前往「预警规则」点击「立即执行」生成（演示规则已预置）" />
    <el-table v-loading="loading" :data="recordList">
      <el-table-column label="编号" align="center" prop="warningId" width="80" />
      <el-table-column label="学号" align="center" prop="studentNo" width="120" />
      <el-table-column label="学生" align="center" prop="studentName" width="100" />
      <el-table-column label="规则" align="center" prop="ruleName" min-width="140" :show-overflow-tooltip="true" />
      <el-table-column label="标题" align="center" prop="title" min-width="140" :show-overflow-tooltip="true" />
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
  </div>
</template>

<script>
import { listWarningRecord, handleWarningRecord } from '@/api/spas/warning'
import { createFromWarning } from '@/api/spas/intervene'

export default {
  name: 'SpasWarningRecord',
  dicts: ['spas_warning_level', 'spas_warning_status'],
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      recordList: [],
      viewOpen: false,
      handleOpen: false,
      handleTitle: '',
      current: {},
      handleForm: {
        warningId: undefined,
        status: undefined,
        handleRemark: undefined
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        studentNo: undefined,
        studentName: undefined,
        level: undefined,
        status: '0'
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listWarningRecord(this.queryParams).then(response => {
        this.recordList = response.rows
        this.total = response.total
        this.loading = false
      })
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
      this.queryParams.status = '0'
      this.handleQuery()
    },
    handleView(row) {
      this.current = row
      this.viewOpen = true
    },
    openHandle(row, status) {
      this.handleForm = {
        warningId: row.warningId,
        status: status,
        handleRemark: undefined
      }
      this.handleTitle = status === '1' ? '处理预警' : '忽略预警'
      this.handleOpen = true
    },
    submitHandle() {
      handleWarningRecord(this.handleForm).then(() => {
        this.$modal.msgSuccess('操作成功')
        this.handleOpen = false
        this.getList()
      })
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
      this.$modal.confirm('确认为该预警创建干预任务？将冻结当前知识点基线。').then(() => {
        return createFromWarning(row.warningId, {
          subjectId: row.subjectId,
          targetRate: 0.6
        })
      }).then(res => {
        const id = res.data && res.data.interveneId
        this.$modal.msgSuccess('干预任务已创建' + (id ? (' #' + id) : ''))
        this.$router.push({ path: '/spas/intervene', query: { status: '0' } })
      }).catch(() => {})
    }
  }
}
</script>
