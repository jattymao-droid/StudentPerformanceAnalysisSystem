<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="学号" prop="studentNo">
        <el-input v-model="queryParams.studentNo" placeholder="学号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="姓名" prop="studentName">
        <el-input v-model="queryParams.studentName" placeholder="姓名" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 120px">
          <el-option v-for="dict in dict.type.spas_intervene_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="来源" prop="sourceType">
        <el-select v-model="queryParams.sourceType" placeholder="来源" clearable style="width: 120px">
          <el-option v-for="dict in dict.type.spas_intervene_source" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['spas:intervene:add']">新增干预</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
    </el-row>

    <el-alert
      type="info"
      :closable="false"
      show-icon
      style="margin-bottom: 12px"
      title="从预警创建干预后，在此跟踪基线/目标得分率与辅导记录；导入成绩重算后可自动评估效果。"
    />

    <el-table v-loading="loading" :data="taskList">
      <el-table-column label="ID" prop="interveneId" width="70" align="center" />
      <el-table-column label="学号" prop="studentNo" width="110" />
      <el-table-column label="姓名" prop="studentName" width="90" />
      <el-table-column label="标题" prop="title" min-width="140" :show-overflow-tooltip="true" />
      <el-table-column label="来源" prop="sourceType" width="80" align="center">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.spas_intervene_source" :value="scope.row.sourceType" />
        </template>
      </el-table-column>
      <el-table-column label="基线" width="90" align="center">
        <template slot-scope="scope">{{ formatRate(scope.row.baselineRate) }}</template>
      </el-table-column>
      <el-table-column label="目标" width="90" align="center">
        <template slot-scope="scope">{{ formatRate(scope.row.targetRate) }}</template>
      </el-table-column>
      <el-table-column label="当前" width="90" align="center">
        <template slot-scope="scope">{{ formatRate(scope.row.effectRate) }}</template>
      </el-table-column>
      <el-table-column label="增益" width="90" align="center">
        <template slot-scope="scope">
          <span :style="{ color: deltaColor(scope.row.effectDelta) }">{{ formatGap(scope.row.effectDelta) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="status" width="90" align="center">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.spas_intervene_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="负责人" prop="ownerBy" width="90" align="center" />
      <el-table-column label="创建时间" width="160" align="center">
        <template slot-scope="scope">{{ parseTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="260" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-refresh" @click="handleEvaluate(scope.row)" v-hasPermi="['spas:intervene:handle']">评估</el-button>
          <el-button v-if="scope.row.status === '0' || scope.row.status === '1' || scope.row.status === '3'" size="mini" type="text" icon="el-icon-check" @click="handleClose(scope.row)" v-hasPermi="['spas:intervene:edit']">关闭</el-button>
          <el-button size="mini" type="text" icon="el-icon-data-analysis" @click="goAnalysis(scope.row)" v-hasPermi="['spas:analysis:student']">分析</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="620px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="学生" prop="studentId">
          <el-select
            v-model="form.studentId"
            placeholder="输入学号/姓名搜索"
            filterable
            remote
            clearable
            :remote-method="remoteStudent"
            :loading="studentLoading"
            style="width: 100%"
            :disabled="!!form.interveneId"
          >
            <el-option
              v-for="item in studentOptions"
              :key="item.studentId"
              :label="formatStudentLabel(item)"
              :value="item.studentId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="学科" prop="subjectId">
          <el-select
            v-model="form.subjectId"
            placeholder="请选择学科"
            filterable
            clearable
            style="width: 100%"
            @change="handleFormSubjectChange"
          >
            <el-option
              v-for="item in subjectOptions"
              :key="item.subjectId"
              :label="item.subjectName"
              :value="item.subjectId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" maxlength="128" placeholder="干预任务标题" />
        </el-form-item>
        <el-form-item label="知识点" prop="knowledgeIdList">
          <el-select
            v-model="form.knowledgeIdList"
            multiple
            filterable
            clearable
            collapse-tags
            placeholder="可选，留空则取当前薄弱点"
            style="width: 100%"
            :disabled="!form.subjectId"
          >
            <el-option
              v-for="item in knowledgeOptions"
              :key="item.knowledgeId"
              :label="item.knowledgeName"
              :value="item.knowledgeId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="目标得分率" prop="targetRate">
          <el-input-number v-model="form.targetRate" :min="0" :max="1" :step="0.05" :precision="2" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item label="计划完成日" prop="dueDate">
          <el-date-picker v-model="form.dueDate" type="date" value-format="yyyy-MM-dd" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="open = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="干预详情" :visible.sync="viewOpen" width="720px" append-to-body>
      <el-descriptions :column="2" border size="small" v-if="current">
        <el-descriptions-item label="学生">{{ current.studentNo }} · {{ current.studentName }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="dict.type.spas_intervene_status" :value="current.status" />
        </el-descriptions-item>
        <el-descriptions-item label="标题" :span="2">{{ current.title }}</el-descriptions-item>
        <el-descriptions-item label="基线">{{ formatRate(current.baselineRate) }}</el-descriptions-item>
        <el-descriptions-item label="目标">{{ formatRate(current.targetRate) }}</el-descriptions-item>
        <el-descriptions-item label="当前">{{ formatRate(current.effectRate) }}</el-descriptions-item>
        <el-descriptions-item label="增益">
          <span :style="{ color: deltaColor(current.effectDelta) }">{{ formatGap(current.effectDelta) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="知识点" :span="2">{{ current.knowledgeIds || '-' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ current.remark || '-' }}</el-descriptions-item>
      </el-descriptions>

      <div style="margin-top: 16px; font-weight: 600">基线明细</div>
      <el-table :data="baselineRows" size="mini" empty-text="无" style="margin-top: 8px">
        <el-table-column label="知识点" prop="knowledgeName" min-width="140" />
        <el-table-column label="得分率" width="100" align="center">
          <template slot-scope="scope">{{ formatRate(scope.row.weightedRate) }}</template>
        </el-table-column>
        <el-table-column label="练习" prop="attemptCount" width="70" align="center" />
        <el-table-column label="等级" prop="weakLevel" width="70" align="center" />
      </el-table>

      <div style="margin-top: 16px; font-weight: 600">辅导记录</div>
      <el-table :data="(current && current.coachLogs) || []" size="mini" empty-text="暂无辅导" style="margin-top: 8px">
        <el-table-column label="时间" width="160">
          <template slot-scope="scope">{{ parseTime(scope.row.createTime) }}</template>
        </el-table-column>
        <el-table-column label="教师" prop="createBy" width="90" />
        <el-table-column label="内容" prop="content" min-width="180" :show-overflow-tooltip="true" />
        <el-table-column label="下一步" prop="nextPlan" min-width="120" :show-overflow-tooltip="true" />
      </el-table>

      <div slot="footer" class="dialog-footer">
        <el-button type="primary" plain @click="openCoach" v-hasPermi="['spas:portfolio:coach', 'spas:portfolio:list']">写辅导</el-button>
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>

    <el-dialog title="新增辅导记录" :visible.sync="coachOpen" width="520px" append-to-body>
      <el-form ref="coachForm" :model="coachForm" :rules="coachRules" label-width="90px">
        <el-form-item label="辅导内容" prop="content">
          <el-input v-model="coachForm.content" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="下一步" prop="nextPlan">
          <el-input v-model="coachForm.nextPlan" type="textarea" :rows="2" />
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
import { listIntervene, getIntervene, addIntervene, updateIntervene, evaluateIntervene } from '@/api/spas/intervene'
import { addCoachLog } from '@/api/spas/portfolio'
import { listStudent } from '@/api/spas/student'
import { optionselectSubject } from '@/api/spas/subject'
import { listKnowledge } from '@/api/spas/knowledge'

export default {
  name: 'SpasIntervene',
  dicts: ['spas_intervene_status', 'spas_intervene_source'],
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      taskList: [],
      title: '',
      open: false,
      viewOpen: false,
      coachOpen: false,
      current: {},
      baselineRows: [],
      studentOptions: [],
      subjectOptions: [],
      knowledgeOptions: [],
      studentLoading: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        studentNo: undefined,
        studentName: undefined,
        status: '0',
        sourceType: undefined
      },
      form: {},
      rules: {
        studentId: [{ required: true, message: '请选择学生', trigger: 'change' }],
        title: [{ required: true, message: '标题不能为空', trigger: 'blur' }]
      },
      coachForm: {},
      coachRules: {
        content: [{ required: true, message: '辅导内容不能为空', trigger: 'blur' }]
      }
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.studentId) {
      this.queryParams.studentId = Number(q.studentId) || q.studentId
    }
    if (q.status !== undefined) {
      this.queryParams.status = q.status
    }
    this.loadSubjects()
    this.getList()
    if (q.warningId) {
      this.$nextTick(() => this.promptFromWarning(q.warningId))
    }
  },
  methods: {
    formatRate(rate) {
      if (rate == null || rate === '') return '-'
      const n = Number(rate)
      if (isNaN(n)) return rate
      const p = n <= 1 ? n * 100 : n
      return p.toFixed(2) + '%'
    },
    formatGap(gap) {
      if (gap == null || gap === '') return '-'
      const n = Number(gap)
      if (isNaN(n)) return gap
      const pct = (n <= 1 && n >= -1 ? n * 100 : n)
      return (pct > 0 ? '+' : '') + pct.toFixed(2) + '%'
    },
    deltaColor(gap) {
      const n = Number(gap)
      if (isNaN(n)) return undefined
      if (n > 0.01) return '#67C23A'
      if (n < -0.01) return '#F56C6C'
      return '#909399'
    },
    formatStudentLabel(item) {
      const no = item.studentNo || ''
      const name = item.studentName || ''
      return no ? (no + ' · ' + name) : name
    },
    loadSubjects() {
      return optionselectSubject().then(response => {
        this.subjectOptions = response.data || []
      })
    },
    loadKnowledge() {
      if (!this.form.subjectId) {
        this.knowledgeOptions = []
        return Promise.resolve()
      }
      return listKnowledge({
        subjectId: this.form.subjectId,
        nodeType: '2',
        status: '0',
        pageNum: 1,
        pageSize: 500
      }).then(response => {
        this.knowledgeOptions = response.rows || response.data || []
      }).catch(() => {
        this.knowledgeOptions = []
      })
    },
    handleFormSubjectChange() {
      this.form.knowledgeIdList = []
      this.loadKnowledge()
    },
    loadStudents(keyword) {
      const params = {
        pageNum: 1,
        pageSize: 50,
        status: '0'
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
      }).catch(() => {
        this.studentOptions = []
      }).finally(() => {
        this.studentLoading = false
      })
    },
    remoteStudent(query) {
      if (!query) {
        this.studentOptions = []
        return
      }
      this.loadStudents(query)
    },
    getList() {
      this.loading = true
      listIntervene(this.queryParams).then(res => {
        this.taskList = res.rows || []
        this.total = res.total || 0
      }).finally(() => {
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.queryParams.status = '0'
      this.handleQuery()
    },
    reset() {
      this.form = {
        interveneId: undefined,
        studentId: undefined,
        subjectId: undefined,
        title: undefined,
        knowledgeIdList: [],
        knowledgeIds: undefined,
        targetRate: 0.6,
        dueDate: undefined,
        remark: undefined,
        sourceType: '3'
      }
      this.knowledgeOptions = []
      this.studentOptions = []
      this.resetForm('form')
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '新增干预任务'
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (!valid) return
        const payload = Object.assign({}, this.form)
        const list = payload.knowledgeIdList
        if (list && list.length) {
          payload.knowledgeIds = list.join(',')
        } else {
          payload.knowledgeIds = undefined
        }
        delete payload.knowledgeIdList
        addIntervene(payload).then(() => {
          this.$modal.msgSuccess('新增成功，已拍摄基线')
          this.open = false
          this.getList()
        })
      })
    },
    handleView(row) {
      getIntervene(row.interveneId).then(res => {
        const data = res.data || {}
        if (!Array.isArray(data.coachLogs)) {
          data.coachLogs = []
        }
        this.current = data
        try {
          this.baselineRows = data.baselineJson ? JSON.parse(data.baselineJson) : []
        } catch (e) {
          this.baselineRows = []
        }
        this.viewOpen = true
      })
    },
    handleEvaluate(row) {
      this.$modal.confirm('将按当前知识点快照重新评估效果？').then(() => {
        return evaluateIntervene(row.interveneId)
      }).then(res => {
        const d = res.data || {}
        this.$modal.msgSuccess('评估完成：当前 ' + this.formatRate(d.effectRate) + '，增益 ' + this.formatGap(d.effectDelta))
        this.getList()
      }).catch(() => {})
    },
    handleClose(row) {
      this.$modal.confirm('确认关闭该干预任务？').then(() => {
        return updateIntervene({ interveneId: row.interveneId, status: '2' })
      }).then(() => {
        this.$modal.msgSuccess('已关闭')
        this.getList()
      }).catch(() => {})
    },
    goAnalysis(row) {
      this.$router.push({
        path: '/spas/analysis/student',
        query: { studentId: row.studentId, subjectId: row.subjectId }
      })
    },
    openCoach() {
      if (!this.current) return
      this.coachForm = {
        studentId: this.current.studentId,
        interveneId: this.current.interveneId,
        content: undefined,
        nextPlan: undefined
      }
      this.coachOpen = true
    },
    submitCoach() {
      this.$refs['coachForm'].validate(valid => {
        if (!valid) return
        addCoachLog(this.coachForm).then(() => {
          this.$modal.msgSuccess('辅导已保存')
          this.coachOpen = false
          this.handleView(this.current)
        })
      })
    },
    promptFromWarning(warningId) {
      this.$modal.msgSuccess('可在预警详情中一键创建干预；warningId=' + warningId)
    }
  }
}
</script>
