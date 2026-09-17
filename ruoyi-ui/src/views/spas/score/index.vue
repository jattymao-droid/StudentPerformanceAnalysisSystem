<template>
  <div class="app-container">
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
        <el-button type="info" plain icon="el-icon-data-analysis" size="mini" :disabled="!queryParams.paperId" @click="goAnalysis">去分析</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-bell" size="mini" @click="goWarning">预警记录</el-button>
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
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getBatchList"></right-toolbar>
    </el-row>

    <el-divider content-position="left">导入批次</el-divider>
    <el-empty v-if="!queryParams.paperId" :image-size="80">
      <template slot="description"><div>请先选择试卷后查看批次与明细</div><div style="margin-top:6px;color:#909399">演示可选「演示单元测」</div></template>
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
    <el-table v-loading="detailLoading" :data="detailList">
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
      <el-table-column label="批次" align="center" prop="batchId" width="90" />
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
          <span>仅允许导入 xls、xlsx 格式文件。</span>
          <el-link type="primary" :underline="false" style="font-size: 12px; vertical-align: baseline" @click="handleDownloadTemplate">下载模板</el-link>
          <div style="margin-top: 8px; color: #E6A23C; line-height: 1.5;">
            空单元格将按 0 分计入（更精确反映掌握度）；请确保整行题目均已填写，或确认未答即为 0 分。
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
  </div>
</template>

<script>
import { listScoreBatch, listScoreDetail, revokeScoreBatch } from '@/api/spas/score'
import { listPaper } from '@/api/spas/paper'
import { recalcPaper } from '@/api/spas/analysis'
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
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        paperId: undefined
      },
      detailQuery: {
        pageNum: 1,
        pageSize: 10,
        paperId: undefined,
        batchId: undefined
      },
      recalcLoading: false,
      errorLogOpen: false,
      errorLogText: '',
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
    const qid = this.$route.query && this.$route.query.paperId
    if (qid) {
      this.queryParams.paperId = isNaN(Number(qid)) ? qid : Number(qid)
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
      this.handleQuery()
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
      }).catch(() => {
        this.batchLoading = false
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
        this.$modal.msgError((response && response.msg) || '导入失败')
        return
      }
      this.upload.open = false
      this.$refs.upload.clearFiles()
      const data = (response && response.data) || {}
      let html = '<div style="padding:8px 4px;line-height:1.7;">'
      html += '<div>成功：<strong>' + (data.successRows != null ? data.successRows : '-') + '</strong> 行</div>'
      html += '<div>失败：<strong>' + (data.failRows != null ? data.failRows : '-') + '</strong> 行</div>'
      if (data.errorLog) {
        html += '<div style="margin-top:8px;color:#E6A23C;">部分行失败，可在批次中查看错误日志。</div>'
      } else if (response && response.msg) {
        html += '<div style="margin-top:8px;">' + response.msg + '</div>'
      }
      html += '</div>'
      this.$alert(html, '导入结果', { dangerouslyUseHTMLString: true })
      this.getBatchList()
      this.getDetailList()
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
