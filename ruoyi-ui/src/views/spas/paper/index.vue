<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="试卷名称" prop="paperName">
        <el-input v-model="queryParams.paperName" placeholder="请输入试卷名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="类型" prop="paperType">
        <el-select v-model="queryParams.paperType" placeholder="试卷类型" clearable>
          <el-option
            v-for="dict in dict.type.spas_paper_type"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="学科" prop="subjectId">
        <el-select v-model="queryParams.subjectId" placeholder="请选择学科" clearable filterable>
          <el-option
            v-for="item in subjectOptions"
            :key="item.subjectId"
            :label="item.subjectName"
            :value="item.subjectId"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="试卷状态" clearable>
          <el-option
            v-for="dict in dict.type.spas_paper_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
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
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['spas:paper:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['spas:paper:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="paperList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="试卷名称" align="center" prop="paperName" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="类型" align="center" prop="paperType" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.spas_paper_type" :value="scope.row.paperType" />
        </template>
      </el-table-column>
      <el-table-column label="学科" align="center" prop="subjectName" width="120" :show-overflow-tooltip="true" />
      <el-table-column label="班级" align="center" prop="deptName" width="120" :show-overflow-tooltip="true" />
      <el-table-column label="考试日期" align="center" prop="examDate" width="110" />
      <el-table-column label="总分" align="center" prop="totalScore" width="80" />
      <el-table-column label="成绩数" align="center" prop="scoreCount" width="80">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.scoreCount > 0" type="warning" size="mini">{{ scope.row.scoreCount }}</el-tag>
          <span v-else>0</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.spas_paper_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="340">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-document-copy" @click="handleCopy(scope.row)" v-hasPermi="['spas:paper:add']">复制</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['spas:paper:edit']">修改</el-button>
          <el-button
            v-if="scope.row.status === '0'"
            size="mini"
            type="text"
            icon="el-icon-s-promotion"
            @click="handlePublish(scope.row)"
            v-hasPermi="['spas:paper:edit']"
          >发布</el-button>
          <el-button
            v-if="scope.row.status === '1'"
            size="mini"
            type="text"
            icon="el-icon-folder-checked"
            @click="handleArchive(scope.row)"
            v-hasPermi="['spas:paper:edit']"
          >归档</el-button>
          <el-button
            v-if="scope.row.status === '1'"
            size="mini"
            type="text"
            icon="el-icon-upload2"
            @click="goScoreImport(scope.row)"
            v-hasPermi="['spas:score:import']"
          >导入成绩</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['spas:paper:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 新增/修改试卷（含小题） -->
    <el-dialog :title="title" :visible.sync="open" width="980px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="90px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="试卷名称" prop="paperName">
              <el-input v-model="form.paperName" placeholder="请输入试卷名称" maxlength="128" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="试卷类型" prop="paperType">
              <el-select v-model="form.paperType" placeholder="请选择类型" style="width: 100%">
                <el-option
                  v-for="dict in dict.type.spas_paper_type"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="学科" prop="subjectId">
              <el-select v-model="form.subjectId" placeholder="请选择学科" filterable style="width: 100%" :disabled="structureLocked" @change="handleFormSubjectChange">
                <el-option
                  v-for="item in subjectOptions"
                  :key="item.subjectId"
                  :label="item.subjectName"
                  :value="item.subjectId"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="班级" prop="deptId">
              <treeselect v-model="form.deptId" :options="deptOptions" :show-count="true" :disabled="structureLocked" placeholder="请选择班级/部门" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="考试日期" prop="examDate">
              <el-date-picker
                v-model="form.examDate"
                type="date"
                value-format="yyyy-MM-dd"
                placeholder="选择日期"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" placeholder="请输入备注" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>

      <el-divider content-position="left">小题设置</el-divider>
      <el-alert
        v-if="!form.subjectId"
        title="请先选择学科，再添加小题（题型随学科加载）"
        type="info"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-alert
        v-else-if="form.subjectId && !questionTypeOptions.length"
        title="当前学科暂无题型，请到「学科管理」中为该学科配置题型后再添加小题"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-alert
        v-if="structureLocked && knowledgeLocked"
        title="该试卷已有成绩明细，禁止增删题目或修改题号/满分/难度/知识点。可修改试卷名称、日期与备注；如需调整结构请复制试卷或先撤销成绩。"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-alert
        v-else-if="structureLocked && !knowledgeLocked"
        title="该试卷已有成绩，题目结构已锁定；当前配置允许调整知识点权重。保存后将自动重算学情。"
        type="info"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button type="primary" plain icon="el-icon-plus" size="mini" :disabled="structureLocked || !form.subjectId" @click="addQuestion">添加小题</el-button>
        </el-col>
      </el-row>
      <el-table :data="form.questions" border size="mini" max-height="360" empty-text="请添加小题并绑定知识点">
        <el-table-column label="题号" width="90" align="center">
          <template slot-scope="scope">
            <el-input v-model="scope.row.questionNo" size="mini" placeholder="题号" :disabled="structureLocked" />
          </template>
        </el-table-column>
        <el-table-column label="题型" width="130" align="center">
          <template slot-scope="scope">
            <el-select v-model="scope.row.questionType" size="mini" clearable placeholder="题型" style="width: 100%" :disabled="structureLocked">
              <el-option
                v-for="item in questionTypeOptions"
                :key="item.typeCode"
                :label="item.typeName"
                :value="item.typeCode"
              />
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="满分" width="110" align="center">
          <template slot-scope="scope">
            <el-input-number v-model="scope.row.fullScore" :min="0" :precision="1" :step="1" size="mini" controls-position="right" style="width: 100%" :disabled="structureLocked" />
          </template>
        </el-table-column>
        <el-table-column label="难度" width="120" align="center">
          <template slot-scope="scope">
            <el-select v-model="scope.row.difficulty" size="mini" placeholder="难度" style="width: 100%" :disabled="structureLocked">
              <el-option
                v-for="dict in dict.type.spas_difficulty"
                :key="dict.value"
                :label="dict.label"
                :value="dict.value"
              />
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="知识点" min-width="220">
          <template slot-scope="scope">
            <div>
              <el-button type="text" size="mini" icon="el-icon-connection" :disabled="knowledgeLocked" @click="openKnowledgeDialog(scope.$index)">选择知识点</el-button>
              <div v-if="scope.row.knowledgeList && scope.row.knowledgeList.length" class="knowledge-tags">
                <el-tag
                  v-for="(k, ki) in scope.row.knowledgeList"
                  :key="k.knowledgeId + '-' + ki"
                  size="mini"
                  style="margin: 2px"
                >{{ k.knowledgeName || ('ID:' + k.knowledgeId) }}({{ formatWeight(k.weight) }})</el-tag>
              </div>
              <span v-else class="text-muted">未选择</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="80" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="mini" icon="el-icon-delete" :disabled="structureLocked" @click="removeQuestion(scope.$index)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">保 存</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 知识点多选 + 权重 -->
    <el-dialog title="选择知识点" :visible.sync="knowledgeOpen" width="720px" append-to-body :close-on-click-modal="false">
      <el-alert title="按版本切换章节树，勾选末级知识点；章节仅作分组不可选。确认后设置权重，总和须为 1。" type="info" :closable="false" show-icon class="mb8" />
      <el-tabs v-if="knowledgeVersionTabs.length" :value="activeVersionId" type="card" class="knowledge-version-tabs" @tab-click="handleVersionTabClick">
        <el-tab-pane
          v-for="tab in knowledgeVersionTabs"
          :key="String(tab.id)"
          :label="tab.label"
          :name="String(tab.id)"
        />
      </el-tabs>
      <el-input
        v-model="knowledgeFilterText"
        size="small"
        clearable
        prefix-icon="el-icon-search"
        placeholder="搜索章节/知识点名称"
        class="mb8"
        @input="filterKnowledgeTree"
      />
      <el-tree
        ref="knowledgeTree"
        :data="knowledgeTree"
        show-checkbox
        node-key="knowledgeId"
        :props="{ label: 'knowledgeName', children: 'children', disabled: 'disabled' }"
        default-expand-all
        :check-strictly="true"
        :filter-node-method="filterKnowledgeNode"
        class="soft-panel knowledge-select-tree"
        @check="syncCheckedKeysFromTree"
      />
      <div style="margin-top: 12px">
        <el-button type="primary" plain size="mini" @click="applyTreeChecked">应用选中</el-button>
        <el-button type="success" plain size="mini" @click="equalSplitWeight">均分权重</el-button>
      </div>
      <el-table :data="editingKnowledgeList" border size="mini" style="margin-top: 12px" max-height="220">
        <el-table-column label="知识点" prop="knowledgeName" min-width="160" :show-overflow-tooltip="true" />
        <el-table-column label="权重" width="140" align="center">
          <template slot-scope="scope">
            <el-input-number v-model="scope.row.weight" :min="0" :max="1" :step="0.1" :precision="4" size="mini" controls-position="right" style="width: 100%" />
          </template>
        </el-table-column>
        <el-table-column label="主知识点" width="100" align="center">
          <template slot-scope="scope">
            <el-radio v-model="primaryKnowledgeId" :label="scope.row.knowledgeId">&nbsp;</el-radio>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="70" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="mini" @click="removeEditingKnowledge(scope.$index)">移除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="weight-sum" :class="{ ok: weightSumOk, bad: !weightSumOk }">
        权重合计：{{ weightSumText }}{{ weightSumOk ? '（正确）' : '（须等于 1）' }}
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" :disabled="!weightSumOk || !editingKnowledgeList.length" @click="confirmKnowledge">确 定</el-button>
        <el-button @click="knowledgeOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPaper, getPaper, addPaper, updatePaper, delPaper, publishPaper, archivePaper, copyPaper } from '@/api/spas/paper'
import { optionselectSubject } from '@/api/spas/subject'
import { optionselectQuestionType } from '@/api/spas/questionType'
import { treeKnowledge } from '@/api/spas/knowledge'
import { deptTreeSelect } from '@/api/system/user'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  name: 'SpasPaper',
  dicts: ['spas_paper_type', 'spas_paper_status', 'spas_difficulty'],
  components: { Treeselect },
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      paperList: [],
      subjectOptions: [],
      questionTypeOptions: [],
      deptOptions: [],
      title: '',
      open: false,
      knowledgeOpen: false,
      knowledgeTree: [],
      knowledgeFullTree: [],
      knowledgeVersionTabs: [],
      activeVersionId: '',
      knowledgeFilterText: '',
      knowledgeCheckedKeys: [],
      editingQuestionIndex: -1,
      editingKnowledgeList: [],
      primaryKnowledgeId: undefined,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        paperName: undefined,
        paperType: undefined,
        subjectId: undefined,
        status: undefined
      },
      form: {},
      rules: {
        paperName: [{ required: true, message: '试卷名称不能为空', trigger: 'blur' }],
        paperType: [{ required: true, message: '试卷类型不能为空', trigger: 'change' }],
        subjectId: [{ required: true, message: '学科不能为空', trigger: 'change' }],
        deptId: [{ required: true, message: '班级不能为空', trigger: 'change' }]
      }
    }
  },
  computed: {
    structureLocked() {
      return !!(this.form && this.form.scoreCount > 0)
    },
    knowledgeLocked() {
      if (!this.structureLocked) return false
      return !(this.form && this.form.allowChangeKnowledgeAfterScore)
    },
    weightSum() {
      return this.editingKnowledgeList.reduce((s, k) => s + Number(k.weight || 0), 0)
    },
    weightSumText() {
      return this.weightSum.toFixed(4)
    },
    weightSumOk() {
      return Math.abs(this.weightSum - 1) < 0.0001
    }
  },
  created() {
    this.getList()
    this.loadSubjects()
    this.loadDepts()
  },
  methods: {
    getList() {
      this.loading = true
      listPaper(this.queryParams).then(response => {
        this.paperList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    loadSubjects() {
      optionselectSubject().then(response => {
        this.subjectOptions = response.data || []
      })
    },
    loadDepts() {
      deptTreeSelect().then(response => {
        this.deptOptions = this.filterDisabledDept(JSON.parse(JSON.stringify(response.data || [])))
      })
    },
    filterDisabledDept(deptList) {
      return deptList.filter(dept => {
        if (dept.disabled) {
          return false
        }
        if (dept.children && dept.children.length) {
          dept.children = this.filterDisabledDept(dept.children)
        }
        return true
      })
    },
    formatWeight(w) {
      const n = Number(w)
      if (isNaN(n)) return '-'
      return Math.round(n * 10000) / 100 + '%'
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        paperId: undefined,
        paperName: undefined,
        paperType: '1',
        subjectId: undefined,
        deptId: undefined,
        examDate: undefined,
        remark: undefined,
        questions: []
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
      this.ids = selection.map(item => item.paperId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '添加试卷'
    },
    handleUpdate(row) {
      this.reset()
      getPaper(row.paperId).then(response => {
        const data = response.data || {}
        this.form = {
          ...data,
          questions: (data.questions || []).map(q => ({
            questionId: q.questionId,
            questionNo: q.questionNo,
            questionType: q.questionType,
            fullScore: q.fullScore,
            difficulty: q.difficulty || '2',
            knowledgeList: (q.knowledgeList || []).map(k => ({
              knowledgeId: k.knowledgeId,
              knowledgeName: k.knowledgeName,
              weight: Number(k.weight),
              isPrimary: k.isPrimary || '0'
            }))
          }))
        }
        this.open = true
        this.title = '修改试卷'
        this.loadQuestionTypes(this.form.subjectId)
      })
    },
    handleFormSubjectChange() {
      this.loadQuestionTypes(this.form.subjectId)
      if (this.form.questions && this.form.questions.length) {
        this.$modal.msgWarning('切换学科后请重新为小题选择知识点与题型')
        this.form.questions.forEach(q => {
          q.knowledgeList = []
          q.questionType = undefined
        })
      }
    },
    loadQuestionTypes(subjectId) {
      this.questionTypeOptions = []
      if (!subjectId) {
        return
      }
      optionselectQuestionType(subjectId).then(res => {
        this.questionTypeOptions = res.data || []
        if (!this.questionTypeOptions.length) {
          this.$modal.msgWarning('当前学科暂无可用题型，请先在学科管理中配置')
        }
      }).catch(() => {
        this.questionTypeOptions = []
      })
    },
    addQuestion() {
      if (!this.form.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      if (!this.questionTypeOptions.length) {
        this.$modal.msgWarning('当前学科暂无题型，请先在学科管理中配置题型')
        return
      }
      const nextNo = String((this.form.questions || []).length + 1)
      const defaultType = this.questionTypeOptions.length ? this.questionTypeOptions[0].typeCode : undefined
      this.form.questions.push({
        questionNo: nextNo,
        questionType: defaultType,
        fullScore: 10,
        difficulty: '2',
        knowledgeList: []
      })
    },
    removeQuestion(index) {
      this.form.questions.splice(index, 1)
    },
    openKnowledgeDialog(index) {
      if (!this.form.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      this.editingQuestionIndex = index
      const current = this.form.questions[index]
      this.editingKnowledgeList = JSON.parse(JSON.stringify(current.knowledgeList || []))
      const primary = this.editingKnowledgeList.find(k => k.isPrimary === '1')
      this.primaryKnowledgeId = primary ? primary.knowledgeId : (this.editingKnowledgeList[0] && this.editingKnowledgeList[0].knowledgeId)
      this.knowledgeCheckedKeys = this.editingKnowledgeList.map(k => k.knowledgeId)
      this.knowledgeFilterText = ''
      this.knowledgeOpen = true
      treeKnowledge(this.form.subjectId).then(response => {
        this.knowledgeFullTree = this.markChapterDisabled(response.data || [])
        this.knowledgeVersionTabs = this.splitKnowledgeVersions(this.knowledgeFullTree)
        this.activeVersionId = this.resolveInitialVersionId(this.knowledgeCheckedKeys)
        this.applyActiveVersionTree()
      })
    },
    splitKnowledgeVersions(nodes) {
      const list = nodes || []
      const versions = list.filter(n => String(n.nodeType || '') === '0')
      const others = list.filter(n => String(n.nodeType || '') !== '0')
      const tabs = versions.map(v => ({
        id: v.knowledgeId,
        label: v.knowledgeName,
        children: v.children || []
      }))
      if (others.length) {
        tabs.unshift({ id: 'all', label: '全部', children: others })
      }
      if (!tabs.length) {
        tabs.push({ id: 'all', label: '全部', children: list })
      }
      return tabs
    },
    resolveInitialVersionId(checkedIds) {
      const tabs = this.knowledgeVersionTabs || []
      if (!tabs.length) return ''
      const idSet = new Set((checkedIds || []).map(id => String(id)))
      if (idSet.size) {
        for (const tab of tabs) {
          if (this.treeContainsAny(tab.children, idSet)) {
            return String(tab.id)
          }
        }
      }
      return String(tabs[0].id)
    },
    treeContainsAny(nodes, idSet) {
      for (const n of nodes || []) {
        if (idSet.has(String(n.knowledgeId))) return true
        if (n.children && n.children.length && this.treeContainsAny(n.children, idSet)) return true
      }
      return false
    },
    applyActiveVersionTree() {
      const tab = (this.knowledgeVersionTabs || []).find(t => String(t.id) === String(this.activeVersionId))
      this.knowledgeTree = tab ? (tab.children || []) : []
      this.$nextTick(() => {
        if (this.$refs.knowledgeTree) {
          this.$refs.knowledgeTree.setCheckedKeys(this.knowledgeCheckedKeys || [])
          this.filterKnowledgeTree()
        }
      })
    },
    handleVersionTabClick(tab) {
      const nextId = tab && tab.name != null ? String(tab.name) : ''
      if (!nextId || nextId === String(this.activeVersionId)) {
        return
      }
      this.syncCheckedKeysFromTree()
      this.activeVersionId = nextId
      this.applyActiveVersionTree()
    },
    syncCheckedKeysFromTree() {
      if (!this.$refs.knowledgeTree) return
      const currentIdSet = new Set()
      this.collectTreeIds(this.knowledgeTree, currentIdSet)
      const kept = (this.knowledgeCheckedKeys || []).filter(id => !currentIdSet.has(id))
      const checked = this.$refs.knowledgeTree.getCheckedKeys(false) || []
      this.knowledgeCheckedKeys = Array.from(new Set(kept.concat(checked)))
    },
    collectTreeIds(nodes, set) {
      ;(nodes || []).forEach(n => {
        set.add(n.knowledgeId)
        if (n.children && n.children.length) {
          this.collectTreeIds(n.children, set)
        }
      })
    },
    filterKnowledgeNode(value, data) {
      if (!value) return true
      return (data.knowledgeName || '').indexOf(value) !== -1
    },
    filterKnowledgeTree() {
      this.$refs.knowledgeTree && this.$refs.knowledgeTree.filter(this.knowledgeFilterText)
    },
    markChapterDisabled(nodes) {
      return (nodes || []).map(n => {
        const item = Object.assign({}, n)
        const type = String(n.nodeType || '')
        item.disabled = type === '1' || type === '0'
        if (n.children && n.children.length) {
          item.children = this.markChapterDisabled(n.children)
        }
        return item
      })
    },
    collectTreeLeaves(nodes, map) {
      ;(nodes || []).forEach(n => {
        map[n.knowledgeId] = n.knowledgeName
        if (n.children && n.children.length) {
          this.collectTreeLeaves(n.children, map)
        }
      })
    },
    applyTreeChecked() {
      this.syncCheckedKeysFromTree()
      const nameMap = {}
      this.collectTreeLeaves(this.knowledgeFullTree, nameMap)
      // also scan version roots
      ;(this.knowledgeVersionTabs || []).forEach(tab => {
        this.collectTreeLeaves(tab.children, nameMap)
      })
      const oldMap = {}
      this.editingKnowledgeList.forEach(k => {
        oldMap[k.knowledgeId] = k
      })
      this.editingKnowledgeList = (this.knowledgeCheckedKeys || []).map(id => {
        const old = oldMap[id]
        return {
          knowledgeId: id,
          knowledgeName: (old && old.knowledgeName) || nameMap[id] || ('ID:' + id),
          weight: old ? old.weight : 0,
          isPrimary: old ? old.isPrimary : '0'
        }
      }).filter(k => {
        // drop non-leaf / unknown if somehow a chapter id was stored
        return !!nameMap[k.knowledgeId] || !!(oldMap[k.knowledgeId] && oldMap[k.knowledgeId].knowledgeName)
      })
      if (!this.editingKnowledgeList.find(k => k.knowledgeId === this.primaryKnowledgeId)) {
        this.primaryKnowledgeId = this.editingKnowledgeList[0] && this.editingKnowledgeList[0].knowledgeId
      }
      this.equalSplitWeight()
    },
    equalSplitWeight() {
      const n = this.editingKnowledgeList.length
      if (!n) return
      const base = Math.floor((1 / n) * 10000) / 10000
      let sum = 0
      this.editingKnowledgeList.forEach((k, i) => {
        if (i === n - 1) {
          k.weight = Number((1 - sum).toFixed(4))
        } else {
          k.weight = base
          sum += base
        }
      })
    },
    removeEditingKnowledge(index) {
      const removed = this.editingKnowledgeList.splice(index, 1)[0]
      if (removed && removed.knowledgeId === this.primaryKnowledgeId) {
        this.primaryKnowledgeId = this.editingKnowledgeList[0] && this.editingKnowledgeList[0].knowledgeId
      }
      this.knowledgeCheckedKeys = this.editingKnowledgeList.map(k => k.knowledgeId)
      if (this.$refs.knowledgeTree) {
        this.$refs.knowledgeTree.setCheckedKeys(this.knowledgeCheckedKeys)
      }
    },
    confirmKnowledge() {
      this.syncCheckedKeysFromTree()
      if (!this.editingKnowledgeList.length) {
        this.$modal.msgError('请至少选择一个知识点')
        return
      }
      const sum = this.editingKnowledgeList.reduce((s, k) => s + Number(k.weight || 0), 0)
      if (Math.abs(sum - 1) > 0.0001) {
        this.$modal.msgError('知识点权重之和必须为 1，当前为 ' + sum.toFixed(4))
        return
      }
      const list = this.editingKnowledgeList.map(k => ({
        knowledgeId: k.knowledgeId,
        knowledgeName: k.knowledgeName,
        weight: Number(k.weight),
        isPrimary: k.knowledgeId === this.primaryKnowledgeId ? '1' : '0'
      }))
      this.$set(this.form.questions[this.editingQuestionIndex], 'knowledgeList', list)
      const nodeMap = {}
      this.collectNodesById(this.knowledgeFullTree, nodeMap)
      const diffs = list.map(k => nodeMap[k.knowledgeId] && nodeMap[k.knowledgeId].difficultyDefault).filter(Boolean)
      if (diffs.length) {
        const maxDiff = diffs.sort().reverse()[0]
        this.$set(this.form.questions[this.editingQuestionIndex], 'difficulty', maxDiff)
      }
      this.knowledgeOpen = false
    },
    collectNodesById(nodes, map) {
      ;(nodes || []).forEach(n => {
        map[n.knowledgeId] = n
        if (n.children && n.children.length) {
          this.collectNodesById(n.children, map)
        }
      })
    },
    buildPayload() {
      return {
        paperId: this.form.paperId,
        paperName: this.form.paperName,
        paperType: this.form.paperType,
        subjectId: this.form.subjectId,
        deptId: this.form.deptId,
        examDate: this.form.examDate,
        remark: this.form.remark,
        questions: (this.form.questions || []).map((q, idx) => ({
          questionId: q.questionId,
          questionNo: q.questionNo,
          questionOrder: idx + 1,
          questionType: q.questionType,
          fullScore: q.fullScore,
          difficulty: q.difficulty,
          knowledgeList: (q.knowledgeList || []).map(k => ({
            knowledgeId: k.knowledgeId,
            weight: k.weight,
            isPrimary: k.isPrimary
          }))
        }))
      }
    },
    validateQuestions() {
      if (!this.form.questions || !this.form.questions.length) {
        this.$modal.msgError('请至少添加一道小题')
        return false
      }
      for (let i = 0; i < this.form.questions.length; i++) {
        const q = this.form.questions[i]
        if (!q.questionNo) {
          this.$modal.msgError('第 ' + (i + 1) + ' 题题号不能为空')
          return false
        }
        if (q.fullScore == null || q.fullScore < 0) {
          this.$modal.msgError('第 ' + (i + 1) + ' 题满分无效')
          return false
        }
        if (!q.knowledgeList || !q.knowledgeList.length) {
          this.$modal.msgError('第 ' + (i + 1) + ' 题请选择知识点')
          return false
        }
        if (!q.questionType && this.questionTypeOptions && this.questionTypeOptions.length) {
          this.$modal.msgError('第 ' + (i + 1) + ' 题请选择题型')
          return false
        }
        const sum = q.knowledgeList.reduce((s, k) => s + Number(k.weight || 0), 0)
        if (Math.abs(sum - 1) > 0.0001) {
          this.$modal.msgError('第 ' + (i + 1) + ' 题知识点权重之和必须为 1')
          return false
        }
      }
      return true
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (!valid) return
        if (!this.structureLocked && !this.validateQuestions()) return
        if (this.structureLocked && !this.knowledgeLocked && !this.validateQuestions()) return
        const payload = this.buildPayload()
        if (this.structureLocked && this.knowledgeLocked) {
          delete payload.questions
        }
        if (this.form.paperId != undefined) {
          updatePaper(payload).then(() => {
            this.$modal.msgSuccess('修改成功')
            this.open = false
            this.getList()
          })
        } else {
          addPaper(payload).then(() => {
            this.$modal.msgSuccess('新增成功')
            this.open = false
            this.getList()
          })
        }
      })
    },
    handleDelete(row) {
      const paperIds = row.paperId || this.ids
      this.$modal.confirm('是否确认删除试卷编号为"' + paperIds + '"的数据项？').then(function() {
        return delPaper(paperIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    handlePublish(row) {
      this.$modal.confirm('是否确认发布试卷"' + row.paperName + '"？').then(function() {
        return publishPaper(row.paperId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('发布成功')
      }).catch(() => {})
    },
    handleArchive(row) {
      this.$modal.confirm('是否确认归档试卷"' + row.paperName + '"？').then(function() {
        return archivePaper(row.paperId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('归档成功')
      }).catch(() => {})
    },
    handleCopy(row) {
      this.$modal.confirm('是否复制试卷「' + row.paperName + '」为草稿？').then(() => {
        return copyPaper(row.paperId)
      }).then(() => {
        this.$modal.msgSuccess('复制成功，请在列表中编辑新试卷')
        this.getList()
      }).catch(() => {})
    },
    goScoreImport(row) {
      this.$router.push({ path: '/spas/biz/score', query: { paperId: row.paperId } })
    }
  }
}
</script>

<style scoped>
.knowledge-tags {
  margin-top: 4px;
}
.mb8 {
  margin-bottom: 8px;
}
.weight-sum {
  margin-top: 10px;
  font-size: 13px;
}
.weight-sum.ok {
  color: #67c23a;
}
.weight-sum.bad {
  color: #f56c6c;
}
.knowledge-version-tabs {
  margin-bottom: 10px;
}
.knowledge-version-tabs >>> .el-tabs__header {
  margin-bottom: 8px;
}
.knowledge-select-tree {
  max-height: 280px;
  overflow: auto;
  border: 1px solid #ebeef5;
  border-radius: 6px;
  padding: 8px;
}
</style>
