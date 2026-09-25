<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="卷名" prop="paperTitle">
        <el-input v-model="queryParams.paperTitle" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="学科" prop="subjectId">
        <el-select v-model="queryParams.subjectId" clearable filterable>
          <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['spas:qb:paper:add']">新建组卷</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-shopping-cart-2" size="mini" :disabled="!basketCount" @click="handleAddFromBasket">从试题篮组卷 ({{ basketCount }})</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['spas:qb:paper:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-magic-stick" size="mini" @click="openSmartCompose" v-hasPermi="['spas:qb:paper:add']">智能/细目表组卷</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="paperList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" prop="paperId" width="70" />
      <el-table-column label="卷名" prop="paperTitle" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="学科" prop="subjectName" width="100" />
      <el-table-column label="题量" prop="itemCount" width="70" align="center" />
      <el-table-column label="总分" prop="totalScore" width="80" align="center" />
      <el-table-column label="操作" width="360" align="center">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['spas:qb:paper:edit']">选题</el-button>
          <el-button size="mini" type="text" icon="el-icon-view" @click="openPreview(scope.row)">预览</el-button>
          <el-button size="mini" type="text" icon="el-icon-s-promotion" @click="openPublish(scope.row)" v-hasPermi="['spas:qb:paper:publish']">发布分析卷</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['spas:qb:paper:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="980px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-row :gutter="12">
          <el-col :span="14">
            <el-form-item label="卷名" prop="paperTitle">
              <el-input v-model="form.paperTitle" />
            </el-form-item>
          </el-col>
          <el-col :span="10">
            <el-form-item label="学科" prop="subjectId">
              <el-select v-model="form.subjectId" filterable style="width:100%" @change="onSubjectChange">
                <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="大题分区">
          <el-button size="mini" plain @click="addSection">添加分区</el-button>
          <el-button size="mini" type="text" @click="autoSections">按题型自动分区</el-button>
          <el-table :data="sections" size="mini" style="margin-top:6px" v-if="sections.length">
            <el-table-column label="分区名" min-width="120">
              <template slot-scope="scope"><el-input v-model="scope.row.name" size="mini" /></template>
            </el-table-column>
            <el-table-column label="题型" width="130">
              <template slot-scope="scope">
                <el-select v-model="scope.row.questionType" size="mini" clearable>
                  <el-option v-for="o in typeFilterOptions" :key="o.value" :label="o.label" :value="o.value" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column label="起序" width="80">
              <template slot-scope="scope"><el-input-number v-model="scope.row.fromOrder" :min="1" size="mini" controls-position="right" style="width:70px" /></template>
            </el-table-column>
            <el-table-column label="止序" width="80">
              <template slot-scope="scope"><el-input-number v-model="scope.row.toOrder" :min="1" size="mini" controls-position="right" style="width:70px" /></template>
            </el-table-column>
            <el-table-column label="操作" width="60">
              <template slot-scope="scope">
                <el-button type="text" icon="el-icon-delete" @click="sections.splice(scope.$index,1)" />
              </template>
            </el-table-column>
          </el-table>
        </el-form-item>

        <el-form-item label="卷内题目">
          <el-button size="mini" type="primary" plain @click="openPick" :disabled="!form.subjectId">从题库选题</el-button>
          <el-button size="mini" type="success" plain @click="importBasket" :disabled="!form.subjectId || !basketCount">导入试题篮</el-button>
          <el-button size="mini" plain @click="openPreviewCurrent" :disabled="!(form.items && form.items.length)">卷面预览</el-button>
          <el-button size="mini" plain @click="goSelectCenter" :disabled="!form.subjectId">去选题中心</el-button>
          <span style="margin-left:12px;font-size:13px">实时总分：<b>{{ liveTotal }}</b></span>
          <el-table :data="form.items" size="mini" style="margin-top:8px">
            <el-table-column label="序" width="70">
              <template slot-scope="scope">
                <el-input-number v-model="scope.row.orderNum" :min="1" size="mini" controls-position="right" style="width:60px" />
              </template>
            </el-table-column>
            <el-table-column label="题号" width="80">
              <template slot-scope="scope"><el-input v-model="scope.row.questionNo" size="mini" /></template>
            </el-table-column>
            <el-table-column label="题干摘要" min-width="220">
              <template slot-scope="scope">
                <qb-rich-content compact :content="scope.row.content || scope.row.contentPreview" />
              </template>
            </el-table-column>
            <el-table-column label="题型" width="80" align="center">
              <template slot-scope="scope">{{ typeLabel(scope.row.questionType) }}</template>
            </el-table-column>
            <el-table-column label="知识点" width="80" align="center">
              <template slot-scope="scope">
                <el-tag v-if="scope.row.knowledgeCount > 0" size="mini" type="success">{{ scope.row.knowledgeCount }}</el-tag>
                <el-tag v-else size="mini" type="warning">未绑</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="分值" width="100">
              <template slot-scope="scope">
                <el-input-number v-model="scope.row.scoreValue" :min="0" :step="1" size="mini" style="width:90px" />
              </template>
            </el-table-column>
            <el-table-column label="操作" width="100">
              <template slot-scope="scope">
                <el-button type="text" icon="el-icon-top" :disabled="scope.$index===0" @click="moveItem(scope.$index,-1)" />
                <el-button type="text" icon="el-icon-bottom" :disabled="scope.$index===form.items.length-1" @click="moveItem(scope.$index,1)" />
                <el-button type="text" icon="el-icon-delete" @click="form.items.splice(scope.$index,1)" />
              </template>
            </el-table-column>
          </el-table>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="submitForm">保 存</el-button>
        <el-button @click="open=false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="选题" :visible.sync="pickOpen" width="800px" append-to-body>
      <el-input v-model="pickQuery.content" size="small" placeholder="题干关键词" style="width:220px;margin-right:8px" @keyup.enter.native="loadPick(true)" />
      <el-checkbox v-model="pickQuery.boundOnly" style="margin-right:8px" @change="loadPick(true)">仅已绑知识点</el-checkbox>
      <el-button size="mini" type="primary" @click="loadPick(true)">搜索</el-button>
      <el-table :data="pickList" @selection-change="onPickSelect" height="360" style="margin-top:8px" v-loading="pickLoading">
        <el-table-column type="selection" width="45" />
        <el-table-column label="ID" prop="questionId" width="70" />
        <el-table-column label="题干" min-width="260">
          <template slot-scope="scope">
            <qb-rich-content compact :content="scope.row.content" />
          </template>
        </el-table-column>
        <el-table-column label="题型" width="80" align="center">
          <template slot-scope="scope">{{ typeLabel(scope.row.questionType) }}</template>
        </el-table-column>
        <el-table-column label="来源" width="120">
          <template slot-scope="scope">
            <span v-if="scope.row.sourceYear">{{ scope.row.sourceYear }} {{ scope.row.sourceRegion || '' }}</span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="知识点" width="80" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.knowledgeCount > 0" size="mini" type="success">{{ scope.row.knowledgeCount }}</el-tag>
            <el-tag v-else size="mini" type="info">0</el-tag>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="pickTotal > 0"
        :total="pickTotal"
        :page.sync="pickQuery.pageNum"
        :limit.sync="pickQuery.pageSize"
        @pagination="loadPick(false)"
      />
      <div slot="footer">
        <el-button type="primary" @click="confirmPick">加入组卷</el-button>
        <el-button @click="pickOpen=false">取消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="发布为分析卷" :visible.sync="pubOpen" width="560px" append-to-body>
      <el-form :model="pubForm" label-width="110px">
        <el-form-item label="班级">
          <treeselect v-model="pubForm.deptId" :options="deptOptions" :show-count="true" placeholder="选择班级" @input="onPubDeptChange" />
        </el-form-item>
        <el-form-item label="考试日期">
          <el-date-picker v-model="pubForm.examDate" type="date" value-format="yyyy-MM-dd" style="width:100%" />
        </el-form-item>
        <el-form-item label="试卷名称">
          <el-input v-model="pubForm.paperName" />
        </el-form-item>
        <el-form-item label="仅同步知识点">
          <el-switch v-model="pubForm.knowledgeOnly" />
          <span style="margin-left:8px;color:#909399;font-size:12px">已有成绩时只能开此开关</span>
        </el-form-item>
        <el-form-item v-if="pubIssueCount > 0" label="标注问题">
          <el-alert :closable="false" type="warning" :title="pubIssueTitle" />
          <div v-if="pubIssues.length" style="margin-top:6px;font-size:12px;color:#909399;max-height:88px;overflow:auto">
            <div v-for="(m, i) in pubIssues.slice(0, 6)" :key="i">{{ m }}</div>
          </div>
          <el-checkbox v-model="pubForm.force" style="margin-top:8px">仍强制发布（将带病进入分析卷）</el-checkbox>
        </el-form-item>
        <el-form-item v-if="weakCover" label="薄弱覆盖">
          <el-alert
            :closable="false"
            :type="weakCover.coverageRate >= 0.5 ? 'success' : 'warning'"
            :title="'班级薄弱 Top' + weakCover.weakTotal + ' 中已覆盖 ' + weakCover.covered + '（' + Math.round((weakCover.coverageRate||0)*100) + '%）'"
          />
          <div v-if="(weakCover.uncovered||[]).length" style="margin-top:8px;font-size:12px;color:#909399">
            未覆盖：{{ (weakCover.uncovered||[]).slice(0,5).map(r => r.knowledgeName || r.knowledge_name || r.knowledgeId).join('、') }}
            <el-button type="text" size="mini" @click="goSelectForWeak">去选题中心补题</el-button>
          </div>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="doPublish">发布</el-button>
        <el-button @click="pubOpen=false">取消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="发布成功" :visible.sync="doneOpen" width="520px" append-to-body>
      <p>已生成分析卷 ID={{ donePaperId }}</p>
      <el-alert
        v-if="doneNeedBloom"
        style="margin-top:8px"
        type="error"
        :closable="false"
        show-icon
        :title="doneHint || ('有 ' + doneNoBloom + ' 题未标认知层级，导分前请先补全 Bloom')"
      />
      <el-alert
        v-else-if="requireBloomLevel"
        style="margin-top:8px"
        type="success"
        :closable="false"
        show-icon
        title="认知层级已齐全（或无需补标）。可继续导入成绩。"
      />
      <el-alert
        v-if="doneNoType > 0"
        style="margin-top:8px"
        type="warning"
        :closable="false"
        show-icon
        :title="'另有 ' + doneNoType + ' 题未选题型，建议一并补全。'"
      />
      <div slot="footer">
        <el-button type="primary" @click="goPaperEdit">去试卷补 Bloom</el-button>
        <el-button :disabled="doneNeedBloom" @click="goScore">去导入成绩</el-button>
        <el-button @click="doneOpen=false">关闭</el-button>
      </div>
    </el-dialog>

    <el-dialog title="卷面预览" :visible.sync="previewOpen" width="860px" append-to-body class="qb-preview-dlg">
      <div ref="previewBody" class="qb-preview-body">
        <h2 class="qb-preview-title">{{ previewPaper.paperTitle || form.paperTitle }}</h2>
        <p class="qb-preview-meta">总分：{{ previewTotal }}</p>
        <div v-for="(sec, si) in previewSections" :key="'sec-'+si" class="qb-preview-sec">
          <h3>{{ sec.name }}</h3>
          <div v-for="it in sec.items" :key="it.questionId" class="qb-preview-q">
            <div class="qb-preview-qno">{{ it.questionNo || it.orderNum }}.（{{ it.scoreValue }}分）</div>
            <div class="qb-preview-stem"><qb-rich-content :content="it.content || it.contentPreview || ''" /></div>
            <div v-if="it.options" class="qb-preview-opts"><qb-rich-content :content="it.options" /></div>
            <div v-if="it.stemImage" class="qb-preview-img"><img :src="mediaUrl(it.stemImage)" alt="" /></div>
            <div v-if="it.optionsImage" class="qb-preview-img"><img :src="mediaUrl(it.optionsImage)" alt="" /></div>
          </div>
        </div>
        <div v-if="!previewSections.length">
          <div v-for="it in (previewPaper.items || form.items || [])" :key="it.questionId" class="qb-preview-q">
            <div class="qb-preview-qno">{{ it.questionNo || it.orderNum }}.（{{ it.scoreValue }}分）</div>
            <div class="qb-preview-stem"><qb-rich-content :content="it.content || it.contentPreview || ''" /></div>
            <div v-if="it.options" class="qb-preview-opts"><qb-rich-content :content="it.options" /></div>
            <div v-if="it.stemImage" class="qb-preview-img"><img :src="mediaUrl(it.stemImage)" alt="" /></div>
            <div v-if="it.optionsImage" class="qb-preview-img"><img :src="mediaUrl(it.optionsImage)" alt="" /></div>
          </div>
        </div>
      </div>
      <div slot="footer">
        <el-button type="primary" icon="el-icon-printer" @click="printPreview">打印/导出</el-button>
        <el-button @click="previewOpen=false">关闭</el-button>
      </div>
    </el-dialog>

    <el-dialog title="智能/细目表组卷" :visible.sync="smartOpen" width="640px" append-to-body>
      <el-form label-width="100px" size="small">
        <el-form-item label="学科" required>
          <el-select v-model="smartForm.subjectId" filterable style="width:100%">
            <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
          </el-select>
        </el-form-item>
        <el-form-item label="卷名">
          <el-input v-model="smartForm.paperTitle" placeholder="智能组卷" />
        </el-form-item>
        <el-tabs v-model="smartTab">
          <el-tab-pane label="题型配额" name="quota">
            <el-form-item label="选择"><el-input-number v-model="smartForm.choice" :min="0" :max="30" /></el-form-item>
            <el-form-item label="填空"><el-input-number v-model="smartForm.blank" :min="0" :max="30" /></el-form-item>
            <el-form-item label="简答"><el-input-number v-model="smartForm.short" :min="0" :max="30" /></el-form-item>
          </el-tab-pane>
          <el-tab-pane label="细目表" name="blueprint">
            <el-button size="mini" @click="smartForm.blueprint.push({ knowledgeId: null, questionType: 'choice', count: 1, score: 5 })">加行</el-button>
            <el-table :data="smartForm.blueprint" size="mini" style="margin-top:8px">
              <el-table-column label="知识点ID" width="140">
                <template slot-scope="scope"><el-input v-model.number="scope.row.knowledgeId" size="mini" placeholder="knowledgeId" /></template>
              </el-table-column>
              <el-table-column label="题型" width="130">
                <template slot-scope="scope">
                  <el-select v-model="scope.row.questionType" size="mini">
                    <el-option v-for="o in typeFilterOptions" :key="o.value" :label="o.label" :value="o.value" />
                  </el-select>
                </template>
              </el-table-column>
              <el-table-column label="题量" width="90">
                <template slot-scope="scope"><el-input-number v-model="scope.row.count" :min="1" :max="20" size="mini" style="width:80px" /></template>
              </el-table-column>
              <el-table-column label="分值" width="90">
                <template slot-scope="scope"><el-input-number v-model="scope.row.score" :min="0" size="mini" style="width:80px" /></template>
              </el-table-column>
              <el-table-column width="50">
                <template slot-scope="scope"><el-button type="text" icon="el-icon-delete" @click="smartForm.blueprint.splice(scope.$index,1)" /></template>
              </el-table-column>
            </el-table>
          </el-tab-pane>
          <el-tab-pane label="学情组卷" name="weak">
            <el-form-item label="班级">
              <treeselect v-model="smartForm.deptId" :options="deptOptions" :show-count="true" placeholder="选择班级" />
            </el-form-item>
            <el-alert type="info" :closable="false" title="按班级薄弱 Top 知识点各抽 1 题（需已绑知识点的校本库题）" />
          </el-tab-pane>
        </el-tabs>
      </el-form>
      <div slot="footer">
        <el-button type="primary" :loading="smartLoading" @click="doSmartCompose">生成并打开</el-button>
        <el-button @click="smartOpen=false">取消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import { mapGetters } from 'vuex'
import { listQbPaper, getQbPaper, addQbPaper, updateQbPaper, delQbPaper, publishQbPaper, weakCoverQbPaper, annotationCheckQbPaper } from '@/api/spas/qb/paper'
import { listQbQuestion, smartPickQbQuestion } from '@/api/spas/qb/question'
import { optionselectSubject } from '@/api/spas/subject'
import { deptTreeSelect } from '@/api/system/user'
import { weakTopClass } from '@/api/spas/analysis'
import { analysisConfig } from '@/api/spas/analysis'
import QbRichContent from '@/components/spas/QbRichContent'
import { qbTypeLabel, qbTypeOptions } from '@/utils/qbTypeLabel'

export default {
  name: 'SpasQbPaper',
  components: { Treeselect, QbRichContent },
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      paperList: [],
      subjectOptions: [],
      deptOptions: [],
      ids: [],
      multiple: true,
      open: false,
      title: '',
      pickOpen: false,
      pickLoading: false,
      pickList: [],
      pickSelected: [],
      pickTotal: 0,
      pickQuery: { content: undefined, boundOnly: false, pageNum: 1, pageSize: 10 },
      pubOpen: false,
      pubForm: {},
      pubUnbound: 0,
      pubWeightBad: 0,
      pubIssueCount: 0,
      pubIssues: [],
      weakCover: null,
      doneOpen: false,
      donePaperId: null,
      doneNeedBloom: false,
      doneNoBloom: 0,
      doneNoType: 0,
      doneHint: '',
      requireBloomLevel: true,
      typeFilterOptions: qbTypeOptions(),
      previewOpen: false,
      previewPaper: { items: [] },
      sections: [],
      smartOpen: false,
      smartLoading: false,
      smartTab: 'quota',
      smartForm: {
        subjectId: undefined,
        paperTitle: '智能组卷',
        choice: 5,
        blank: 3,
        short: 2,
        deptId: undefined,
        blueprint: []
      },
      queryParams: { pageNum: 1, pageSize: 10, paperTitle: undefined, subjectId: undefined },
      form: { items: [] },
      rules: {
        paperTitle: [{ required: true, message: '卷名不能为空', trigger: 'blur' }],
        subjectId: [{ required: true, message: '请选择学科', trigger: 'change' }]
      }
    }
  },
  computed: {
    pubIssueTitle() {
      const parts = []
      if (this.pubUnbound > 0) parts.push('未绑知识点 ' + this.pubUnbound + ' 题')
      if (this.pubWeightBad > 0) parts.push('权重异常 ' + this.pubWeightBad + ' 题')
      if (!parts.length && this.pubIssueCount > 0) parts.push('标注问题 ' + this.pubIssueCount + ' 处')
      return parts.join('；') + '，发布后薄弱分析可能缺证据'
    },
    ...mapGetters(['qbBasketCount', 'qbBasketItems', 'qbBasketSubjectId']),
    basketCount() { return this.qbBasketCount },
    liveTotal() {
      return (this.form.items || []).reduce((s, i) => s + Number(i.scoreValue || 0), 0)
    },
    previewTotal() {
      const items = this.previewPaper.items || this.form.items || []
      return items.reduce((s, i) => s + Number(i.scoreValue || 0), 0)
    },
    previewSections() {
      const items = [...(this.previewPaper.items || this.form.items || [])].sort((a, b) => (a.orderNum || 0) - (b.orderNum || 0))
      let secs = this.sections
      if ((!secs || !secs.length) && this.previewPaper.sectionJson) {
        try { secs = JSON.parse(this.previewPaper.sectionJson) } catch (e) { secs = [] }
      }
      if (!secs || !secs.length) return []
      return secs.map(sec => ({
        name: sec.name,
        items: items.filter(it => {
          const o = Number(it.orderNum || 0)
          return o >= Number(sec.fromOrder || 1) && o <= Number(sec.toOrder || 999)
        })
      })).filter(s => s.items.length)
    }
  },
  created() {
    optionselectSubject().then(r => { this.subjectOptions = r.data || [] })
    deptTreeSelect().then(r => { this.deptOptions = r.data || [] }).catch(() => {})
    analysisConfig().then(res => {
      const annot = (res.data && res.data.annotationCoverage) || {}
      if (annot.requireBloomLevel != null) this.requireBloomLevel = !!annot.requireBloomLevel
    }).catch(() => {})
    this.getList()
    this.consumeBasketQuery()
  },
  activated() {
    this.consumeBasketQuery()
  },
  watch: {
    '$route.query.fromBasket'(val) {
      if (val === '1') this.consumeBasketQuery()
    }
  },
  methods: {
    consumeBasketQuery() {
      const q = this.$route.query || {}
      if (q.fromBasket !== '1') return
      if (!this.basketCount) {
        this.$modal.msgWarning('试题篮为空，请先去选题中心加题')
        return
      }
      // avoid double-open on same navigation stamp
      const stamp = String(q.t || q._t || '') + ':' + this.basketCount
      if (this._lastBasketStamp === stamp && this.open) return
      this._lastBasketStamp = stamp
      this.$nextTick(() => this.handleAddFromBasket())
    },
    getList() {
      this.loading = true
      listQbPaper(this.queryParams).then(res => {
        this.paperList = res.rows || []
        this.total = res.total || 0
        this.loading = false
      }).catch(() => { this.loading = false })
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() { this.resetForm('queryForm'); this.handleQuery() },
    handleSelectionChange(sel) {
      this.ids = sel.map(i => i.paperId)
      this.multiple = !sel.length
    },
    reset() {
      this.form = { paperId: undefined, paperTitle: '', subjectId: undefined, items: [], sectionJson: '' }
      this.sections = []
      this.resetForm('form')
    },
    parseSections(json) {
      if (!json) return []
      try {
        const arr = typeof json === 'string' ? JSON.parse(json) : json
        return Array.isArray(arr) ? arr : []
      } catch (e) { return [] }
    },
    syncSectionJson() {
      this.form.sectionJson = this.sections.length ? JSON.stringify(this.sections) : ''
    },
    addSection() {
      const n = this.sections.length + 1
      this.sections.push({ name: '第' + n + '大题', questionType: '', fromOrder: 1, toOrder: 10 })
    },
    autoSections() {
      const byType = {}
      ;(this.form.items || []).forEach(it => {
        const t = it.questionType || 'other'
        if (!byType[t]) byType[t] = []
        byType[t].push(it)
      })
      const nameMap = {
        choice: '一、选择题', single: '一、选择题', multi: '一、选择题',
        blank: '二、填空题', fill: '二、填空题', judge: '三、判断题',
        short: '四、简答题', calc: '五、计算题', experiment: '六、实验题', other: '七、其他'
      }
      const secs = []
      Object.keys(byType).forEach(t => {
        const orders = byType[t].map(i => Number(i.orderNum || 0)).filter(Boolean)
        if (!orders.length) return
        secs.push({
          name: nameMap[t] || t,
          questionType: t,
          fromOrder: Math.min(...orders),
          toOrder: Math.max(...orders)
        })
      })
      this.sections = secs
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '新建组卷'
    },
    handleAddFromBasket() {
      if (!this.basketCount) {
        this.$modal.msgWarning('试题篮为空，请先去选题中心加题')
        return
      }
      this.reset()
      this.form.subjectId = this.qbBasketSubjectId || (this.qbBasketItems[0] && this.qbBasketItems[0].subjectId)
      this.form.paperTitle = '试题篮组卷'
      this.importBasket()
      this.open = true
      this.title = '从试题篮新建组卷'
    },
    importBasket() {
      const exist = new Set((this.form.items || []).map(i => i.questionId))
      let order = (this.form.items || []).length + 1
      ;(this.qbBasketItems || []).forEach(q => {
        if (exist.has(q.questionId)) return
        if (this.form.subjectId && q.subjectId && String(q.subjectId) !== String(this.form.subjectId)) return
        this.form.items.push({
          questionId: q.questionId,
          orderNum: order,
          questionNo: String(order),
          scoreValue: q.scoreValue != null ? Number(q.scoreValue) : 5,
          contentPreview: q.contentPreview || (q.content || '').slice(0, 80),
          content: q.content,
          options: q.options,
          stemImage: q.stemImage,
          optionsImage: q.optionsImage,
          questionType: q.questionType,
          difficulty: q.difficulty,
          knowledgeCount: q.knowledgeCount || 0
        })
        order++
      })
    },
    handleUpdate(row) {
      this.reset()
      getQbPaper(row.paperId).then(res => {
        this.form = Object.assign({ items: [] }, res.data || {})
        if (!this.form.items) this.form.items = []
        this.sections = this.parseSections(this.form.sectionJson)
        this.open = true
        this.title = '编辑组卷 / 选题'
      })
    },
    onSubjectChange() {
      this.form.items = []
    },
    openPick() {
      this.pickQuery = { content: undefined, boundOnly: false, pageNum: 1, pageSize: 10 }
      this.pickSelected = []
      this.loadPick(true)
      this.pickOpen = true
    },
    loadPick(resetPage) {
      if (resetPage) this.pickQuery.pageNum = 1
      this.pickLoading = true
      const params = {
        subjectId: this.form.subjectId,
        content: this.pickQuery.content,
        pageNum: this.pickQuery.pageNum,
        pageSize: this.pickQuery.pageSize
      }
      if (this.pickQuery.boundOnly) params.boundOnly = true
      listQbQuestion(params).then(res => {
        this.pickList = res.rows || []
        this.pickTotal = res.total || 0
        this.pickLoading = false
      }).catch(() => { this.pickLoading = false })
    },
    onPickSelect(rows) { this.pickSelected = rows },
    confirmPick() {
      const exist = new Set((this.form.items || []).map(i => i.questionId))
      let order = (this.form.items || []).length + 1
      this.pickSelected.forEach(q => {
        if (exist.has(q.questionId)) return
        this.form.items.push({
          questionId: q.questionId,
          orderNum: order,
          questionNo: String(order),
          scoreValue: 5,
          contentPreview: (q.content || '').slice(0, 80),
          content: q.content,
          options: q.options,
          stemImage: q.stemImage,
          optionsImage: q.optionsImage,
          questionType: q.questionType,
          difficulty: q.difficulty,
          knowledgeCount: q.knowledgeCount || 0,
          sourceYear: q.sourceYear,
          sourceRegion: q.sourceRegion
        })
        order++
      })
      this.pickOpen = false
    },
    moveItem(index, delta) {
      const arr = this.form.items
      const j = index + delta
      if (j < 0 || j >= arr.length) return
      const tmp = arr[index]
      this.$set(arr, index, arr[j])
      this.$set(arr, j, tmp)
      arr.forEach((it, i) => {
        it.orderNum = i + 1
        if (!it.questionNo || String(it.questionNo) === String(i) || String(it.questionNo) === String(i + 2) || String(it.questionNo) === String(i + delta + 1)) {
          it.questionNo = String(i + 1)
        }
      })
    },
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        this.syncSectionJson()
        const req = this.form.paperId ? updateQbPaper(this.form) : addQbPaper(this.form)
        req.then(() => {
          this.$modal.msgSuccess('保存成功')
          this.open = false
          this.getList()
          if (this.$route.query.fromBasket === '1') {
            this.$store.dispatch('qbBasket/clear')
          }
        })
      })
    },
    handleDelete(row) {
      const ids = row.paperId || this.ids
      this.$modal.confirm('确认删除题库卷？').then(() => delQbPaper(ids)).then(() => {
        this.$modal.msgSuccess('已删除')
        this.getList()
      }).catch(() => {})
    },
    openPublish(row) {
      this.pubUnbound = 0
      this.pubWeightBad = 0
      this.pubIssueCount = 0
      this.pubIssues = []
      this.weakCover = null
      this.pubForm = {
        bankPaperId: row.paperId,
        deptId: undefined,
        examDate: undefined,
        paperName: row.paperTitle,
        paperType: '1',
        subjectId: row.subjectId,
        knowledgeOnly: false,
        force: false
      }
      this.pubOpen = true
      Promise.all([
        getQbPaper(row.paperId),
        annotationCheckQbPaper(row.paperId)
      ]).then(([paperRes, checkRes]) => {
        const paper = (paperRes && paperRes.data) || {}
        const items = paper.items || []
        const check = (checkRes && checkRes.data) || {}
        this.pubUnbound = check.unbound != null ? check.unbound : items.filter(i => !(i.knowledgeCount > 0)).length
        this.pubWeightBad = check.weightBad || 0
        this.pubIssueCount = check.issueCount || 0
        this.pubIssues = check.issues || []
      }).catch(() => {})
    },
    onPubDeptChange(deptId) {
      if (!deptId || !this.pubForm.bankPaperId) {
        this.weakCover = null
        return
      }
      weakCoverQbPaper(this.pubForm.bankPaperId, {
        deptId,
        subjectId: this.pubForm.subjectId,
        limit: 15
      }).then(res => {
        this.weakCover = res.data || null
      }).catch(() => { this.weakCover = null })
    },
    goSelectForWeak() {
      const uncovered = (this.weakCover && this.weakCover.uncovered) || []
      const ids = uncovered.map(r => r.knowledgeId || r.knowledge_id).filter(Boolean)
      this.pubOpen = false
      const query = { subjectId: this.pubForm.subjectId }
      if (ids.length > 1) {
        query.knowledgeIds = ids.slice(0, 20).join(',')
      } else if (ids.length === 1) {
        query.knowledgeId = ids[0]
      }
      this.$router.push({ path: '/spas/qb/select', query }).catch(() => {})
    },
    doPublish() {
      if (!this.pubForm.deptId) {
        this.$modal.msgError('请选择班级')
        return
      }
      if (this.pubIssueCount > 0 && !this.pubForm.force && !this.pubForm.knowledgeOnly) {
        this.$modal.msgWarning('存在标注问题（未绑或权重不等于1），请勾选「仍强制发布」或先回题目管理完成人审')
        return
      }
      publishQbPaper(this.pubForm.bankPaperId, this.pubForm).then(res => {
        this.pubOpen = false
        const d = (res && res.data) || {}
        this.donePaperId = d.paperId
        this.doneNoBloom = Number(d.noBloomCount || 0)
        this.doneNoType = Number(d.noQuestionTypeCount || 0)
        this.doneNeedBloom = !!d.needBloomBeforeScore || this.doneNoBloom > 0
        this.doneHint = d.nextStep || ''
        this.doneOpen = true
      })
    },
    goPaperEdit() {
      this.doneOpen = false
      this.$router.push({ path: '/spas/biz/paper', query: { paperId: this.donePaperId } }).catch(() => {})
    },
    goPaperList() {
      this.goPaperEdit()
    },
    goScore() {
      if (this.doneNeedBloom) {
        this.$modal.msgWarning('请先补全认知层级再导分')
        return
      }
      this.doneOpen = false
      this.$router.push({ path: '/spas/biz/score', query: { paperId: this.donePaperId } }).catch(() => {})
    },
    goSelectCenter() {
      this.$router.push({ path: '/spas/qb/select', query: { subjectId: this.form.subjectId } }).catch(() => {})
    },
    openPreview(row) {
      getQbPaper(row.paperId).then(res => {
        this.previewPaper = res.data || { items: [] }
        this.sections = this.parseSections(this.previewPaper.sectionJson)
        this.previewOpen = true
      })
    },
    openPreviewCurrent() {
      this.syncSectionJson()
      this.previewPaper = Object.assign({}, this.form)
      this.previewOpen = true
    },
    printPreview() {
      const html = this.$refs.previewBody && this.$refs.previewBody.innerHTML
      if (!html) return
      const w = window.open('', '_blank')
      if (!w) {
        this.$modal.msgWarning('请允许弹窗以打印/导出')
        return
      }
      w.document.write('<html><head><title>' + (this.previewPaper.paperTitle || '试卷预览') + '</title>')
      // Reuse already-bundled styles (KaTeX etc.) — no CDN
      Array.from(document.querySelectorAll('link[rel="stylesheet"], style')).forEach(node => {
        w.document.write(node.outerHTML)
      })
      w.document.write('<style>body{font-family:SimSun,"Songti SC",serif;padding:24px;line-height:1.7}.qb-preview-title{text-align:center}.qb-preview-q{margin:12px 0}.qb-preview-qno{font-weight:600}.qb-preview-img img{max-width:100%;margin-top:6px}.qb-preview-opts{margin-top:6px}</style>')
      w.document.write('</head><body>' + html + '</body></html>')
      w.document.close()
      setTimeout(() => { w.focus(); w.print() }, 500)
    },
    mediaUrl(url) {
      if (!url) return ''
      if (url.indexOf('http') === 0 || url.indexOf('data:') === 0) return url
      return process.env.VUE_APP_BASE_API + url
    },
    typeLabel(code) {
      return qbTypeLabel(code)
    },
    openSmartCompose() {
      this.smartForm.subjectId = this.queryParams.subjectId || (this.subjectOptions[0] && this.subjectOptions[0].subjectId)
      this.smartOpen = true
    },
    doSmartCompose() {
      if (!this.smartForm.subjectId) {
        this.$modal.msgWarning('请选择学科')
        return
      }
      this.smartLoading = true
      const finish = (rows) => {
        this.reset()
        this.form.subjectId = this.smartForm.subjectId
        this.form.paperTitle = this.smartForm.paperTitle || '智能组卷'
        let order = 1
        ;(rows || []).forEach(q => {
          const score = 5
          this.form.items.push({
            questionId: q.questionId,
            orderNum: order,
            questionNo: String(order),
            scoreValue: score,
            contentPreview: (q.content || '').slice(0, 80),
            content: q.content,
            options: q.options,
            stemImage: q.stemImage,
            optionsImage: q.optionsImage,
            questionType: q.questionType,
            difficulty: q.difficulty,
            knowledgeCount: q.knowledgeCount || 0
          })
          order++
        })
        this.autoSections()
        this.open = true
        this.title = '智能组卷结果'
        this.smartOpen = false
        this.smartLoading = false
      }
      if (this.smartTab === 'blueprint') {
        const blueprint = (this.smartForm.blueprint || []).filter(r => r.count > 0)
        if (!blueprint.length) {
          this.$modal.msgWarning('请添加细目表行')
          this.smartLoading = false
          return
        }
        smartPickQbQuestion({
          subjectId: this.smartForm.subjectId,
          boundOnly: true,
          blueprint
        }).then(res => finish(res.data || [])).catch(() => { this.smartLoading = false })
        return
      }
      if (this.smartTab === 'weak') {
        if (!this.smartForm.deptId) {
          this.$modal.msgWarning('请选择班级')
          this.smartLoading = false
          return
        }
        weakTopClass(this.smartForm.deptId, { subjectId: this.smartForm.subjectId, limit: 10 }).then(res => {
          const weak = res.data || []
          const blueprint = weak.map(w => ({
            knowledgeId: w.knowledgeId || w.knowledge_id,
            questionType: undefined,
            count: 1,
            score: 5
          })).filter(r => r.knowledgeId)
          if (!blueprint.length) {
            this.$modal.msgWarning('该班暂无薄弱知识点数据')
            this.smartLoading = false
            return
          }
          return smartPickQbQuestion({
            subjectId: this.smartForm.subjectId,
            boundOnly: true,
            blueprint
          }).then(r => finish(r.data || []))
        }).catch(() => { this.smartLoading = false })
        return
      }
      const typeQuotas = {}
      if (this.smartForm.choice > 0) typeQuotas.choice = this.smartForm.choice
      if (this.smartForm.blank > 0) typeQuotas.blank = this.smartForm.blank
      if (this.smartForm.short > 0) typeQuotas.short = this.smartForm.short
      smartPickQbQuestion({
        subjectId: this.smartForm.subjectId,
        boundOnly: true,
        typeQuotas,
        totalCount: 10
      }).then(res => finish(res.data || [])).catch(() => { this.smartLoading = false })
    }
  }
}
</script>

<style scoped>
.mb8 { margin-bottom: 8px; }
.qb-preview-body { padding: 8px 12px; max-height: 70vh; overflow: auto; }
.qb-preview-title { text-align: center; margin: 0 0 8px; }
.qb-preview-meta { text-align: center; color: #909399; margin-bottom: 16px; }
.qb-preview-sec { margin-bottom: 16px; }
.qb-preview-q { margin: 10px 0; }
.qb-preview-qno { font-weight: 600; margin-bottom: 4px; }
.qb-preview-stem >>> .katex { font-size: 1em; }
.qb-preview-stem >>> .qb-rich-text { font-size: 14px; }
.qb-preview-opts { margin-top: 6px; color: #606266; }
.qb-preview-opts >>> .qb-rich-text { font-size: 13px; }
.qb-preview-img img { max-width: 100%; margin-top: 6px; border-radius: 4px; }
</style>
