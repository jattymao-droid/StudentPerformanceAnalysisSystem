<template>
  <div class="app-container">
    <el-alert
      class="mb8"
      type="info"
      :closable="false"
      show-icon
      title="各科实考分与校次请用「实考校次」导入。本页仅导入单张试卷的小题得分，用于知识点分析。"
      description="导入前请确保该卷题目已绑知识点、权重之和为1、且已选题型；否则后端会拦截。导分成功后请先核对质量看板，再看分析结论。"
    />
    <el-alert
      v-if="postImportQualityTip"
      class="mb8"
      type="warning"
      show-icon
      closable
      :title="postImportQualityTip"
      @close="postImportQualityTip = ''"
    >
      <el-button type="text" size="mini" @click="goQuality" v-hasPermi="['spas:quality:list']">前往质量看板</el-button>
    </el-alert>
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="试卷" prop="paperId">
        <el-select
          v-model="queryParams.paperId"
          placeholder="请选择试卷"
          filterable
          clearable
          style="width: 280px"
          @change="handlePaperChange"
        >
          <el-option
            v-for="item in paperOptions"
            :key="item.paperId"
            :label="item.paperName"
            :value="item.paperId"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="学号" prop="studentNo">
        <el-input v-model="detailQuery.studentNo" placeholder="学号" clearable style="width: 140px" @keyup.enter.native="handleDetailQuery" />
      </el-form-item>
      <el-form-item label="姓名" prop="studentName">
        <el-input v-model="detailQuery.studentName" placeholder="姓名" clearable style="width: 120px" @keyup.enter.native="handleDetailQuery" />
      </el-form-item>
      <el-form-item label="题号" prop="questionNo">
        <el-input v-model="detailQuery.questionNo" placeholder="题号" clearable style="width: 100px" @keyup.enter.native="handleDetailQuery" />
      </el-form-item>
      <el-form-item label="来源" prop="scoreSource">
        <el-select v-model="detailQuery.scoreSource" placeholder="全部" clearable style="width: 120px">
          <el-option label="手工" value="1" />
          <el-option label="导入" value="2" />
          <el-option label="空作0" value="3" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          :disabled="!queryParams.paperId"
          @click="handleDownloadTemplate"
          v-hasPermi="['spas:score:import']"
        >下载模板</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-upload2"
          size="mini"
          :disabled="!queryParams.paperId"
          @click="handleImport"
          v-hasPermi="['spas:score:import']"
        >导入成绩</el-button>
      </el-col>
      
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-refresh"
          size="mini"
          :disabled="!queryParams.paperId"
          :loading="recalcLoading"
          @click="handleRecalc"
          v-hasPermi="['spas:score:import']"
        >按新算法重算</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" plain icon="el-icon-data-analysis" size="mini" :disabled="!queryParams.paperId" @click="goAnalysis" v-hasPermi="['spas:analysis:class']">去分析</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-s-data" size="mini" :disabled="!queryParams.paperId" @click="goQuality" v-hasPermi="['spas:quality:list']">去质量</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-bell" size="mini" @click="goWarning" v-hasPermi="['spas:warning:record']">预警记录</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          :disabled="!queryParams.paperId"
          @click="handleExport"
          v-hasPermi="['spas:score:export']"
        >导出明细</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          :disabled="!queryParams.paperId"
          @click="handleAddDetail"
          v-hasPermi="['spas:score:edit']"
        >手工录入</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDeleteDetail"
          v-hasPermi="['spas:score:remove']"
        >删除明细</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getBatchList"></right-toolbar>
    </el-row>

    <el-divider content-position="left">导入批次</el-divider>
    <el-empty v-if="!queryParams.paperId" :image-size="72" class="score-empty">
      <template slot="description">
        <div class="empty-title">请先选择试卷</div>
        <div class="empty-hint">演示可选「演示单元测」后查看批次与明细</div>
      </template>
    </el-empty>
    <template v-else>
    <el-table v-loading="batchLoading" :data="batchList" @row-click="handleBatchRowClick">
      <el-table-column label="批次号" align="center" prop="batchId" width="90" />
      <el-table-column label="文件名" align="center" prop="fileName" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="总行数" align="center" prop="totalRows" width="90" />
      <el-table-column label="成功" align="center" prop="successRows" width="90" />
      <el-table-column label="失败" align="center" prop="failRows" width="90" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === '0'" type="info" size="mini">处理中</el-tag>
          <el-tag v-else-if="scope.row.status === '1'" type="success" size="mini">成功</el-tag>
          <el-tag v-else-if="scope.row.status === '2'" type="danger" size="mini">失败</el-tag>
          <span v-else>{{ scope.row.status }}</span>
        </template>
      </el-table-column>
      <el-table-column label="导入人" align="center" prop="createBy" width="100" />
      <el-table-column label="导入时间" align="center" prop="createTime" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="220">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click.stop="loadDetail(scope.row)">明细</el-button>
          <el-button
            v-if="scope.row.errorLog"
            size="mini"
            type="text"
            icon="el-icon-warning-outline"
            @click.stop="showErrorLog(scope.row)"
          >错误日志</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click.stop="handleRevokeBatch(scope.row)"
            v-hasPermi="['spas:score:import']"
          >撤销</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="batchTotal > 0"
      :total="batchTotal"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getBatchList"
    />

    <el-divider content-position="left">成绩明细</el-divider>
    <el-table v-loading="detailLoading" :data="detailList" class="score-detail-anchor" @selection-change="handleDetailSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="学号" align="center" prop="studentNo" min-width="120" />
      <el-table-column label="姓名" align="center" prop="studentName" min-width="100" />
      <el-table-column label="题号" align="center" prop="questionNo" width="90" />
      <el-table-column label="得分" align="center" prop="score" width="90" />
      <el-table-column label="满分" align="center" prop="fullScore" width="90" />
      <el-table-column label="得分率" align="center" prop="rate" width="100">
        <template slot-scope="scope">
          <span>{{ formatRate(scope.row.rate) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="来源" align="center" prop="scoreSource" width="90">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.scoreSource === '1'" size="mini">手工</el-tag>
          <el-tag v-else-if="scope.row.scoreSource === '2'" type="success" size="mini">导入</el-tag>
          <el-tag v-else-if="scope.row.scoreSource === '3'" type="info" size="mini">空作0</el-tag>
          <span v-else>{{ scope.row.scoreSource || '-' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="批次" align="center" prop="batchId" width="90" />
      <el-table-column label="操作" align="center" width="140" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdateDetail(scope.row)" v-hasPermi="['spas:score:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDeleteDetail(scope.row)" v-hasPermi="['spas:score:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="detailTotal > 0"
      :total="detailTotal"
      :page.sync="detailQuery.pageNum"
      :limit.sync="detailQuery.pageSize"
      @pagination="getDetailList"
    />
    </template>

    <!-- 成绩导入对话框 -->
    <el-dialog title="导入成绩" :visible.sync="upload.open" width="400px" append-to-body @close="handleUploadClose">
      <el-upload
        ref="upload"
        :limit="1"
        accept=".xlsx, .xls"
        :headers="upload.headers"
        :action="upload.url"
        :disabled="upload.isUploading"
        :on-progress="handleFileUploadProgress"
        :on-success="handleFileSuccess"
        :on-error="handleFileError"
        :auto-upload="false"
        drag
      >
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip text-center" slot="tip">
          <span>仅允许导入 xls、xlsx 格式文件。</span><br>
          <span>空单元格跳过、不计入掌握度；可填「缺考」「未做」或 ABS/NA（不计入）；数字 0 为实得 0 分。</span>
          <el-link type="primary" :underline="false" style="font-size: 12px; vertical-align: baseline" @click="handleDownloadTemplate">下载模板</el-link>
          <div style="margin-top: 8px; color: #D97706; line-height: 1.5;">
            未作答请留空或填缺考/未做，不要用空单元格表示 0 分。
          </div>
        </div>
      </el-upload>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" :loading="upload.isUploading" :disabled="upload.isUploading" @click="submitFileForm">确 定</el-button>
        <el-button @click="upload.open = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="导入错误日志" :visible.sync="errorLogOpen" width="640px" append-to-body>
      <pre style="white-space: pre-wrap; max-height: 420px; overflow: auto; margin: 0; font-size: 12px; line-height: 1.6;">{{ errorLogText }}</pre>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="errorLogOpen = false">OK</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="detailFormTitle" :visible.sync="detailOpen" width="480px" append-to-body>
      <el-form ref="detailForm" :model="detailForm" :rules="detailRules" label-width="80px" size="small">
        <el-form-item label="学号" prop="studentNo">
          <el-input v-model="detailForm.studentNo" placeholder="学号" :disabled="detailForm.detailId != null" />
        </el-form-item>
        <el-form-item label="题号" prop="questionNo">
          <el-input v-model="detailForm.questionNo" placeholder="题号" :disabled="detailForm.detailId != null" />
        </el-form-item>
        <el-form-item label="得分" prop="score">
          <el-input-number v-model="detailForm.score" :min="0" :precision="2" :step="0.5" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item v-if="detailForm.fullScore != null" label="满分">
          <span>{{ detailForm.fullScore }}</span>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" :loading="detailSaving" @click="submitDetailForm">确 定</el-button>
        <el-button @click="detailOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listScoreBatch, listScoreDetail, addScoreDetail, updateScoreDetail, delScoreDetail, revokeScoreBatch } from '@/api/spas/score'
import { listPaper } from '@/api/spas/paper'
import { recalcPaper } from '@/api/spas/analysis'
import { qualityOverview } from '@/api/spas/quality'
import { getToken } from '@/utils/auth'

export default {
  name: 'SpasScore',
  data() {
    return {
      showSearch: true,
      batchLoading: false,
      detailLoading: false,
      batchList: [],
      detailList: [],
      batchTotal: 0,
      detailTotal: 0,
      paperOptions: [],
      postImportQualityTip: '',
      ids: [],
      single: true,
      multiple: true,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        paperId: undefined
      },
      detailQuery: {
        pageNum: 1,
        pageSize: 10,
        paperId: undefined,
        batchId: undefined,
        studentNo: undefined,
        studentName: undefined,
        questionNo: undefined,
        scoreSource: undefined
      },
      recalcLoading: false,
      errorLogOpen: false,
      errorLogText: '',
      detailOpen: false,
      detailSaving: false,
      detailFormTitle: '',
      detailForm: {},
      detailRules: {
        studentNo: [{ required: true, message: '学号不能为空', trigger: 'blur' }],
        questionNo: [{ required: true, message: '题号不能为空', trigger: 'blur' }],
        score: [{ required: true, message: '得分不能为空', trigger: 'blur' }]
      },
      upload: {
        open: false,
        isUploading: false,
        headers: { Authorization: 'Bearer ' + getToken() },
        url: ''
      }
    }
  },
  created() {
    this.loadPapers()
    const q = this.$route.query || {}
    if (q.paperId) {
      this.queryParams.paperId = isNaN(Number(q.paperId)) ? q.paperId : Number(q.paperId)
    }
    if (q.batchId) {
      this.detailQuery.batchId = isNaN(Number(q.batchId)) ? q.batchId : Number(q.batchId)
    }
    if (this.queryParams.paperId) {
      this.$nextTick(() => this.handleQuery())
    }
  },
  methods: {
    loadPapers() {
      listPaper({ pageNum: 1, pageSize: 200, status: '1' }).then(response => {
        this.paperOptions = response.rows || []
        // 若无已发布，也加载全部供选择
        if (!this.paperOptions.length) {
          listPaper({ pageNum: 1, pageSize: 200 }).then(res => {
            this.paperOptions = res.rows || []
          })
        }
      })
    },
    formatRate(rate) {
      if (rate == null || rate === '') return '-'
      const n = Number(rate)
      if (isNaN(n)) return rate
      return (n * 100).toFixed(1) + '%'
    },
    handlePaperChange() {
      this.detailQuery.batchId = undefined
      this.detailList = []
      this.detailTotal = 0
      this.handleQuery()
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getBatchList()
      this.detailQuery.paperId = this.queryParams.paperId
      this.detailQuery.pageNum = 1
      if (this.queryParams.paperId) {
        this.getDetailList()
      } else {
        this.detailList = []
        this.detailTotal = 0
      }
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.detailQuery.batchId = undefined
      this.detailQuery.studentNo = undefined
      this.detailQuery.studentName = undefined
      this.detailQuery.questionNo = undefined
      this.detailQuery.scoreSource = undefined
      this.handleQuery()
    },
    handleDetailQuery() {
      this.detailQuery.pageNum = 1
      this.getDetailList()
    },
    handleDetailSelectionChange(selection) {
      this.ids = selection.map(item => item.detailId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    resetDetailForm() {
      this.detailForm = {
        detailId: undefined,
        paperId: this.queryParams.paperId,
        studentNo: undefined,
        questionNo: undefined,
        score: undefined,
        fullScore: undefined
      }
      this.resetForm('detailForm')
    },
    handleAddDetail() {
      if (!this.queryParams.paperId) {
        this.$modal.msgWarning('请先选择试卷')
        return
      }
      this.resetDetailForm()
      this.detailFormTitle = '手工录入小题得分'
      this.detailOpen = true
    },
    handleUpdateDetail(row) {
      this.resetDetailForm()
      this.detailForm = {
        detailId: row.detailId,
        paperId: row.paperId,
        studentNo: row.studentNo,
        questionNo: row.questionNo,
        score: row.score != null ? Number(row.score) : undefined,
        fullScore: row.fullScore
      }
      this.detailFormTitle = '修改小题得分'
      this.detailOpen = true
    },
    submitDetailForm() {
      this.$refs.detailForm.validate(valid => {
        if (!valid) return
        this.detailSaving = true
        const req = this.detailForm.detailId != null
          ? updateScoreDetail({ detailId: this.detailForm.detailId, score: this.detailForm.score })
          : addScoreDetail({
            paperId: this.queryParams.paperId,
            studentNo: this.detailForm.studentNo,
            questionNo: this.detailForm.questionNo,
            score: this.detailForm.score
          })
        req.then(() => {
          this.$modal.msgSuccess(this.detailForm.detailId != null ? '修改成功' : '录入成功')
          this.detailOpen = false
          this.getDetailList()
        }).finally(() => {
          this.detailSaving = false
        })
      })
    },
    handleDeleteDetail(row) {
      const detailIds = row && row.detailId != null ? row.detailId : this.ids
      if (detailIds == null || (Array.isArray(detailIds) && !detailIds.length)) {
        this.$modal.msgWarning('请选择要删除的明细')
        return
      }
      this.$modal.confirm('确认删除所选小题得分？删除后将重算知识点。').then(() => {
        return delScoreDetail(detailIds)
      }).then(() => {
        this.$modal.msgSuccess('删除成功')
        this.getDetailList()
      }).catch(() => {})
    },
    getBatchList() {
      if (!this.queryParams.paperId) {
        this.batchList = []
        this.batchTotal = 0
        return
      }
      this.batchLoading = true
      listScoreBatch(this.queryParams).then(response => {
        this.batchList = response.rows || []
        this.batchTotal = response.total || 0
        this.batchLoading = false
        this.focusLinkedBatch()
      }).catch(() => {
        this.batchLoading = false
      })
    },
    focusLinkedBatch() {
      const bid = this.detailQuery.batchId
      if (bid == null || !(this.batchList || []).length) return
      const hit = this.batchList.find(b => String(b.batchId) === String(bid))
      if (!hit) return
      this.$nextTick(() => {
        this.$modal.msgSuccess('已定位导入批次 #' + bid)
        const el = document.querySelector('.score-detail-anchor')
        if (el && el.scrollIntoView) el.scrollIntoView({ behavior: 'smooth', block: 'start' })
      })
    },
    getDetailList() {
      if (!this.detailQuery.paperId) {
        this.detailList = []
        this.detailTotal = 0
        return
      }
      this.detailLoading = true
      listScoreDetail(this.detailQuery).then(response => {
        this.detailList = response.rows || []
        this.detailTotal = response.total || 0
        this.detailLoading = false
      }).catch(() => {
        this.detailLoading = false
      })
    },
    handleBatchRowClick(row) {
      this.loadDetail(row)
    },
    loadDetail(row) {
      this.detailQuery.paperId = this.queryParams.paperId
      this.detailQuery.batchId = row.batchId
      this.detailQuery.pageNum = 1
      this.getDetailList()
    },
    handleDownloadTemplate() {
      if (!this.queryParams.paperId) {
        this.$modal.msgWarning('请先选择试卷')
        return
      }
      const paperId = this.queryParams.paperId
      this.download('spas/score/template/' + paperId, {}, `score_template_${paperId}.xlsx`)
    },
    handleImport() {
      if (!this.queryParams.paperId) {
        this.$modal.msgWarning('请先选择试卷')
        return
      }
      this.upload.headers = { Authorization: 'Bearer ' + getToken() }
      this.upload.url = process.env.VUE_APP_BASE_API + '/spas/score/import/' + this.queryParams.paperId
      this.upload.open = true
    },
    handleFileUploadProgress() {
      this.upload.isUploading = true
    },
    handleFileSuccess(response) {
      this.upload.isUploading = false
      if (!response || response.code !== 200) {
        const msg = (response && response.msg) || '导入失败'
        this.$modal.msgError(msg)
        if (msg.indexOf('标注') >= 0 && this.queryParams.paperId) {
          this.$confirm(msg + '\n\n是否前往试卷编辑？', '标注问题', { type: 'warning', confirmButtonText: '前往编辑', cancelButtonText: '留在本页' }).then(() => {
            this.$router.push({ path: '/spas/biz/paper', query: { paperId: this.queryParams.paperId } }).catch(() => {})
          }).catch(() => {})
        }
        return
      }
      this.upload.open = false
      this.$refs.upload.clearFiles()
      const data = (response && response.data) || {}
      let html = '<div style="padding:8px 4px;line-height:1.7;">'
      html += '<div>成功：<strong>' + (data.successRows != null ? data.successRows : '-') + '</strong> 行</div>'
      html += '<div>失败：<strong>' + (data.failRows != null ? data.failRows : '-') + '</strong> 行</div>'
      if (Number(data.successRows) > 0) {
        html += '<div style="margin-top:8px;color:#10B981;">已自动重算该卷相关学生的知识点快照（全部口径）。本学期即时分析无需额外重算。</div>'
        html += '<div style="margin-top:6px;color:#D97706;">建议先核对质量看板（权重/题型/标注覆盖），再查看分析结论。</div>'
      }
      if (data.errorLog) {
        html += '<div style="margin-top:8px;color:#D97706;">部分行失败，可在批次中查看错误日志。</div>'
      } else if (response && response.msg) {
        html += '<div style="margin-top:8px;">' + response.msg + '</div>'
      }
      html += '</div>'
      const success = Number(data.successRows) > 0
      this.$alert(html, '导入结果', { dangerouslyUseHTMLString: true }).then(() => {
        if (success) this.afterImportQualityGate()
      }).catch(() => {
        if (success) this.afterImportQualityGate()
      })
      this.getBatchList()
      this.getDetailList()
    },
    afterImportQualityGate() {
      const paper = this.paperOptions.find(p => p.paperId === this.queryParams.paperId)
      const query = {}
      if (paper && paper.deptId) query.deptId = paper.deptId
      if (paper && paper.subjectId) query.subjectId = paper.subjectId
      qualityOverview(query).then(res => {
        const d = (res && res.data) || {}
        const alertCount = Number(d.alertCount != null ? d.alertCount : 0)
        if (alertCount > 0) {
          this.postImportQualityTip = '质量看板发现 ' + alertCount + ' 项告警，请处理后再采信正式薄弱结论。'
          this.$confirm(
            '导入成功，但质量看板仍有 ' + alertCount + ' 项告警。\n建议先处理标注/权重等问题，再查看学情分析。',
            '质量核对',
            { type: 'warning', confirmButtonText: '去质量看板', cancelButtonText: '稍后' }
          ).then(() => {
            this.goQuality()
          }).catch(() => {})
        } else {
          this.postImportQualityTip = '导入成功，质量看板暂无告警。可继续查看分析或预警。'
        }
      }).catch(() => {
        this.postImportQualityTip = '导入成功。请打开质量看板核对标注与权重后再看分析。'
        this.$confirm('导入成功。是否前往质量看板核对？', '质量核对', {
          type: 'info', confirmButtonText: '去质量看板', cancelButtonText: '稍后'
        }).then(() => {
          this.goQuality()
        }).catch(() => {})
      })
    },
    handleFileError() {
      this.upload.isUploading = false
      this.$modal.msgError('上传失败，请检查网络或登录状态后重试')
    },
    handleUploadClose() {
      this.upload.isUploading = false
      if (this.$refs.upload) {
        this.$refs.upload.clearFiles()
      }
    },

    showErrorLog(row) {
      this.errorLogText = row.errorLog || ''
      this.errorLogOpen = true
    },
    handleRecalc() {
      if (!this.queryParams.paperId) {
        this.$modal.msgWarning('请先选择试卷')
        return
      }
      this.$modal.confirm('将按最新算法（近因加权、难度权重）重算该试卷相关学生的知识点快照，确认继续？').then(() => {
        this.recalcLoading = true
        return recalcPaper(this.queryParams.paperId)
      }).then(() => {
        this.$modal.msgSuccess('已按新算法重算知识点')
      }).catch(() => {}).finally(() => {
        this.recalcLoading = false
      })
    },
    goAnalysis() {
      const paper = this.paperOptions.find(p => p.paperId === this.queryParams.paperId)
      const query = {}
      if (paper && paper.deptId) query.deptId = paper.deptId
      if (paper && paper.subjectId) query.subjectId = paper.subjectId
      this.$router.push({ path: '/spas/analysis/class', query })
    },
    goQuality() {
      const paper = this.paperOptions.find(p => p.paperId === this.queryParams.paperId)
      const query = {}
      if (paper && paper.deptId) query.deptId = paper.deptId
      if (paper && paper.subjectId) query.subjectId = paper.subjectId
      this.$router.push({ path: '/spas/quality', query }).catch(() => {})
    },
    goWarning() {
      this.$router.push({ path: '/spas/warning/record' })
    },
    submitFileForm() {
      const files = this.$refs.upload && this.$refs.upload.uploadFiles
      if (!files || !files.length) {
        this.$modal.msgWarning('请先选择要导入的文件')
        return
      }
      this.$refs.upload.submit()
    },
    handleExport() {
      if (!this.queryParams.paperId) {
        this.$modal.msgWarning('请先选择试卷')
        return
      }
      const params = { paperId: this.queryParams.paperId }
      if (this.detailQuery.batchId) {
        params.batchId = this.detailQuery.batchId
      }
      this.download('spas/score/export', params, `score_detail_${this.queryParams.paperId}.xlsx`)
    },
    handleRevokeBatch(row) {
      this.$modal.confirm('确认撤销批次 ' + row.batchId + ' 的导入成绩？将删除该批次明细并重算知识点。').then(() => {
        return revokeScoreBatch(row.batchId)
      }).then(() => {
        this.$modal.msgSuccess('批次已撤销')
        this.getBatchList()
        this.getDetailList()
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.score-empty {
  padding: 36px 16px;
  background: #fff;
  border: 1px dashed #E2E8F0;
  border-radius: 10px;
}
.empty-title {
  color: #0F172A;
  font-weight: 600;
  font-size: 14px;
}
.empty-hint {
  margin-top: 6px;
  color: #64748B;
  font-size: 12px;
}
</style>
