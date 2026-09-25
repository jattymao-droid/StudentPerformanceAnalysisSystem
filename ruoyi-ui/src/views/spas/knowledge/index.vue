<template>
  <div class="app-container knowledge-manage-page">
    <div class="knowledge-subject-bar">
      <el-form size="small" :inline="true" @submit.native.prevent>
        <el-form-item label="学科">
          <el-select
            v-model="queryParams.subjectId"
            placeholder="请选择学科"
            filterable
            style="width: 200px"
            @change="onSubjectChange"
          >
            <el-option
              v-for="item in subjectOptions"
              :key="item.subjectId"
              :label="item.subjectName"
              :value="item.subjectId"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            plain
            icon="el-icon-folder-add"
            size="mini"
            :disabled="!queryParams.subjectId"
            v-hasPermi="['spas:knowledge:add']"
            @click="handleAddVersion"
          >新增版本</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="tree-sidebar-manage-wrap knowledge-body">
      <tree-panel
        title="目录"
        :tree-data="sidebarTree"
        search-placeholder="请输入版本/章节名称"
        storage-key="spas-knowledge-sidebar-width-v3"
        :default-width="340"
        :defaultExpandAll="true"
        @node-click="handleNodeClick"
        @refresh="loadSidebarTree"
        ref="knowledgeTreeRef"
      >
        <template slot="node-actions" slot-scope="{ data }">
          <template v-if="data.nodeKind === 'version'">
            <el-button
              type="text"
              icon="el-icon-folder-add"
              title="新增章节"
              v-hasPermi="['spas:knowledge:add']"
              @click="handleAddChapterFromTree(data)"
            />
            <el-button
              type="text"
              icon="el-icon-edit"
              title="修改版本"
              v-hasPermi="['spas:knowledge:edit']"
              @click="handleEditVersionFromTree(data)"
            />
            <el-button
              type="text"
              icon="el-icon-delete"
              title="删除版本"
              v-hasPermi="['spas:knowledge:remove']"
              @click="handleDeleteTreeNode(data, '版本')"
            />
          </template>
          <template v-else-if="data.nodeKind === 'chapter'">
            <el-button
              type="text"
              icon="el-icon-folder-add"
              title="新增子章节"
              v-hasPermi="['spas:knowledge:add']"
              @click="handleAddChapterFromTree(data)"
            />
            <el-button
              type="text"
              icon="el-icon-edit"
              title="修改章节"
              v-hasPermi="['spas:knowledge:edit']"
              @click="handleEditChapterFromTree(data)"
            />
            <el-button
              type="text"
              icon="el-icon-delete"
              title="删除章节"
              v-hasPermi="['spas:knowledge:remove']"
              @click="handleDeleteTreeNode(data, '章节')"
            />
          </template>
        </template>
      </tree-panel>

      <div class="tree-sidebar-content">
        <div class="content-inner">
          <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
            <el-form-item label="名称" prop="knowledgeName">
              <el-input
                v-model="queryParams.knowledgeName"
                placeholder="知识点名称"
                clearable
                style="width: 180px"
                @keyup.enter.native="handleQuery"
              />
            </el-form-item>
            <el-form-item label="状态" prop="status">
              <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 120px">
                <el-option
                  v-for="dict in dict.type.sys_normal_disable"
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
              <el-button
                type="primary"
                plain
                icon="el-icon-plus"
                size="mini"
                :disabled="!canAddKnowledge"
                @click="handleAddKnowledge()"
                v-hasPermi="['spas:knowledge:add']"
              >新增知识点</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button
                type="success"
                plain
                icon="el-icon-share"
                size="mini"
                :disabled="!queryParams.subjectId"
                @click="openSubjectEdgeDrawer"
                v-hasPermi="['spas:knowledge:list']"
              >学科依赖边{{ subjectEdgeCount != null ? ('(' + subjectEdgeCount + ')') : '' }}</el-button>
            </el-col>
            <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
          </el-row>

          <el-alert :title="scopeHint" type="info" :closable="false" show-icon class="mb8" />

          <el-table v-loading="loading" :data="knowledgeList">
            <el-table-column label="知识点" prop="knowledgeName" min-width="180" :show-overflow-tooltip="true" />
            <el-table-column label="所属章节" prop="parentName" align="center" min-width="140" :show-overflow-tooltip="true" />
            <el-table-column label="编码" prop="knowledgeCode" align="center" width="140" :show-overflow-tooltip="true" />
            <el-table-column label="默认难度" align="center" width="100">
              <template slot-scope="scope">
                <dict-tag :options="dict.type.spas_difficulty" :value="scope.row.difficultyDefault" />
              </template>
            </el-table-column>
            <el-table-column label="排序" prop="orderNum" align="center" width="80" />
            <el-table-column label="状态" align="center" width="90">
              <template slot-scope="scope">
                <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" width="240" class-name="small-padding fixed-width">
              <template slot-scope="scope">
                <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdateKnowledge(scope.row)" v-hasPermi="['spas:knowledge:edit']">修改</el-button>
                <el-button size="mini" type="text" icon="el-icon-share" @click="openEdgeDrawer(scope.row)" v-hasPermi="['spas:knowledge:list']">
                  依赖<span v-if="edgeCountMap[scope.row.knowledgeId]">({{ edgeCountMap[scope.row.knowledgeId] }})</span>
                </el-button>
                <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDeleteKnowledge(scope.row)" v-hasPermi="['spas:knowledge:remove']">删除</el-button>
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
        </div>
      </div>
    </div>

    <el-dialog :title="title" :visible.sync="open" width="560px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="所属学科" prop="subjectId">
          <el-select v-model="form.subjectId" placeholder="请选择学科" filterable style="width: 100%" disabled>
            <el-option
              v-for="item in subjectOptions"
              :key="item.subjectId"
              :label="item.subjectName"
              :value="item.subjectId"
            />
          </el-select>
        </el-form-item>
        <el-form-item v-if="form.nodeType === '0'" label="版本名称" prop="knowledgeName">
          <el-input v-model="form.knowledgeName" maxlength="100" placeholder="例如：必修一" />
        </el-form-item>
        <el-form-item v-else-if="form.nodeType === '1'" label="上级节点" prop="parentId">
          <treeselect
            v-model="form.parentId"
            :options="knowledgeOptions"
            :normalizer="normalizer"
            placeholder="选择所属版本或上级章节"
          />
        </el-form-item>
        <el-form-item v-else label="所属章节" prop="parentId">
          <treeselect
            v-model="form.parentId"
            :options="knowledgeOptions"
            :normalizer="normalizer"
            placeholder="请选择章节"
          />
        </el-form-item>
        <el-form-item v-if="form.nodeType === '1'" label="章节名称" prop="knowledgeName">
          <el-input v-model="form.knowledgeName" maxlength="100" />
        </el-form-item>
        <el-form-item v-if="form.nodeType === '2'" label="知识点名称" prop="knowledgeName">
          <el-input v-model="form.knowledgeName" maxlength="100" />
        </el-form-item>
        <el-form-item label="编码" prop="knowledgeCode">
          <el-input v-model="form.knowledgeCode" placeholder="可选编码" maxlength="64" />
        </el-form-item>
        <el-form-item v-if="form.nodeType === '2'" label="默认难度" prop="difficultyDefault">
          <el-select v-model="form.difficultyDefault" placeholder="请选择难度" style="width: 100%">
            <el-option
              v-for="dict in dict.type.spas_difficulty"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="显示排序" prop="orderNum">
          <el-input-number v-model="form.orderNum" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in dict.type.sys_normal_disable"
              :key="dict.value"
              :label="dict.value"
            >{{ dict.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-drawer
      :title="'前置依赖 · ' + (edgeTarget.knowledgeName || '')"
      :visible.sync="edgeOpen"
      size="480px"
      append-to-body
    >
      <div style="padding: 0 16px 16px">
        <el-alert
          class="mb8"
          type="info"
          :closable="false"
          show-icon
          title="添加前置知识点：该知识点依赖的前置叶子（from → 当前）。薄弱分析会据此提示根因。"
        />
        <el-alert
          v-if="!edgeList.length && !edgeLoading"
          class="mb8"
          type="warning"
          :closable="false"
          show-icon
          title="尚无前置边。建议从同章或更基础知识点中选择前置叶子，便于薄弱根因提示。"
        />
        <div class="card-header mb8" style="display:flex;align-items:center;justify-content:space-between;gap:8px">
          <span>已有前置边</span>
          <el-button type="text" size="mini" icon="el-icon-refresh" :loading="edgeLoading" @click="loadEdges">刷新</el-button>
        </div>
        <el-table v-loading="edgeLoading" :data="edgeList" size="mini" empty-text="暂无前置依赖" class="mb8">
          <el-table-column label="前置知识点" min-width="160" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.fromKnowledgeName || ('ID:' + scope.row.fromKnowledgeId) }}</template>
          </el-table-column>
          <el-table-column label="关系" prop="relation" width="90" align="center">
            <template slot-scope="scope">{{ scope.row.relation || 'prerequisite' }}</template>
          </el-table-column>
          <el-table-column label="操作" width="80" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="text" icon="el-icon-delete" @click="removeEdge(scope.row)" v-hasPermi="['spas:knowledge:edit']">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="card-header mb8">添加前置</div>
        <el-form size="small" label-width="88px">
          <el-form-item label="前置叶子">
            <el-select
              v-model="edgeFromId"
              filterable
              clearable
              placeholder="选择同学科其他叶子知识点"
              style="width: 100%"
              :loading="leafLoading"
            >
              <el-option
                v-for="item in availableLeafOptions"
                :key="item.knowledgeId"
                :label="item.knowledgeName + (item.parentName ? ('（' + item.parentName + '）') : '')"
                :value="item.knowledgeId"
              />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" size="mini" :loading="edgeSaving" :disabled="!edgeFromId" @click="addEdge" v-hasPermi="['spas:knowledge:edit']">添加依赖</el-button>
          </el-form-item>
        </el-form>
      </div>
    </el-drawer>

    <el-drawer
      :title="'学科依赖边 · ' + (currentSubjectName || '')"
      :visible.sync="subjectEdgeOpen"
      size="560px"
      append-to-body
    >
      <div style="padding: 0 16px 16px">
        <el-alert
          class="mb8"
          type="info"
          :closable="false"
          show-icon
          title="以下为当前学科全部前置依赖边。可到具体知识点行点「依赖」增删；薄弱分析依赖这些边给出根因提示。"
        />
        <el-table v-loading="subjectEdgeLoading" :data="subjectEdgeList" size="mini" empty-text="本学科暂无依赖边，请在知识点行点击「依赖」添加" max-height="480">
          <el-table-column label="前置" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.fromKnowledgeName || scope.row.fromKnowledgeId }}</template>
          </el-table-column>
          <el-table-column label="目标" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.toKnowledgeName || scope.row.toKnowledgeId }}</template>
          </el-table-column>
          <el-table-column label="关系" width="100" align="center">
            <template slot-scope="scope">{{ scope.row.relation || 'prerequisite' }}</template>
          </el-table-column>
          <el-table-column label="操作" width="80" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="text" icon="el-icon-delete" @click="removeSubjectEdge(scope.row)" v-hasPermi="['spas:knowledge:edit']">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import { listKnowledge, treeKnowledge, getKnowledge, addKnowledge, updateKnowledge, delKnowledge } from '@/api/spas/knowledge'
import { listKnowledgeEdge, addKnowledgeEdge, delKnowledgeEdge } from '@/api/spas/knowledgeEdge'
import { optionselectSubject } from '@/api/spas/subject'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import TreePanel from '@/components/TreePanel'

export default {
  name: 'SpasKnowledge',
  dicts: ['sys_normal_disable', 'spas_difficulty'],
  components: { Treeselect, TreePanel },
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      knowledgeList: [],
      knowledgeOptions: [],
      subjectOptions: [],
      sidebarTree: [],
      currentNode: null,
      title: '',
      open: false,
      edgeOpen: false,
      edgeLoading: false,
      edgeSaving: false,
      edgeList: [],
      edgeTarget: {},
      edgeFromId: undefined,
      leafOptions: [],
      leafLoading: false,
      edgeCountMap: {},
      subjectEdgeOpen: false,
      subjectEdgeLoading: false,
      subjectEdgeList: [],
      subjectEdgeCount: null,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        subjectId: undefined,
        parentId: undefined,
        nodeType: '2',
        knowledgeName: undefined,
        status: undefined
      },
      form: {},
      rules: {
        subjectId: [{ required: true, message: '所属学科不能为空', trigger: 'change' }],
        knowledgeName: [{ required: true, message: '名称不能为空', trigger: 'blur' }],
        orderNum: [{ required: true, message: '显示排序不能为空', trigger: 'blur' }]
      }
    }
  },
  computed: {
    canAddKnowledge() {
      return !!this.queryParams.subjectId && this.currentNode && this.currentNode.nodeKind === 'chapter'
    },
    currentSubjectName() {
      const subject = (this.subjectOptions || []).find(s => s.subjectId === this.queryParams.subjectId)
      return subject ? subject.subjectName : '-'
    },
    scopeHint() {
      if (!this.queryParams.subjectId) {
        return '请先在上方选择学科'
      }
      if (this.currentNode && this.currentNode.nodeKind === 'chapter') {
        return '当前：' + this.currentSubjectName + ' / ' + this.pathLabel(this.currentNode) + '（仅显示知识点）'
      }
      if (this.currentNode && this.currentNode.nodeKind === 'version') {
        return '当前版本：' + this.currentSubjectName + ' / ' + (this.currentNode.label || '') + '。点章节可筛选知识点；树上可新增章节。'
      }
      return '当前学科：' + this.currentSubjectName + '。左侧为 版本 → 章节；点章节查看知识点。'
    },
    availableLeafOptions() {
      const used = new Set((this.edgeList || []).map(e => e.fromKnowledgeId))
      return (this.leafOptions || []).filter(k =>
        k.knowledgeId !== this.edgeTarget.knowledgeId && !used.has(k.knowledgeId)
      )
    }
  },
  created() {
    this.loadSubjects()
  },
  methods: {
    pathLabel(node) {
      if (!node) return ''
      if (node.parentLabel) {
        return node.parentLabel + ' / ' + (node.label || '')
      }
      return node.label || ''
    },
    loadSubjects() {
      optionselectSubject().then(response => {
        this.subjectOptions = response.data || []
        if (!this.queryParams.subjectId && this.subjectOptions.length) {
          const physics = this.subjectOptions.find(s => s.subjectCode === 'physics' || s.subjectName === '物理')
          this.queryParams.subjectId = (physics || this.subjectOptions[0]).subjectId
        }
        this.loadSidebarTree()
      })
    },
    onSubjectChange() {
      this.currentNode = null
      this.queryParams.parentId = undefined
      this.loadSidebarTree()
    },
    loadSidebarTree() {
      const keepParentId = this.queryParams.parentId
      if (!this.queryParams.subjectId) {
        this.sidebarTree = []
        this.knowledgeList = []
        this.total = 0
        return
      }
      treeKnowledge(this.queryParams.subjectId).then(res => {
        this.sidebarTree = this.mapTreeNodes(res.data || [], this.queryParams.subjectId, null)
        if (keepParentId) {
          const found = this.findTreeNode(this.sidebarTree, keepParentId)
          if (found) {
            this.handleNodeClick(found)
            return
          }
        }
        if (this.sidebarTree.length) {
          this.handleNodeClick(this.sidebarTree[0])
        } else {
          this.currentNode = null
          this.queryParams.parentId = undefined
          this.getList()
        }
      }).catch(() => {
        this.sidebarTree = []
      })
    },
    findTreeNode(nodes, id) {
      for (const n of nodes || []) {
        if (n.knowledgeId === id || n.id === id) return n
        const child = this.findTreeNode(n.children, id)
        if (child) return child
      }
      return null
    },
    mapTreeNodes(nodes, subjectId, parentLabel) {
      const result = []
      ;(nodes || []).forEach(n => {
        const type = String(n.nodeType || '')
        if (type !== '0' && type !== '1') {
          return
        }
        const kind = type === '0' ? 'version' : 'chapter'
        const label = n.knowledgeName
        result.push({
          id: n.knowledgeId,
          label,
          subjectId,
          knowledgeId: n.knowledgeId,
          nodeType: type,
          nodeKind: kind,
          parentLabel,
          children: this.mapTreeNodes(n.children, subjectId, label)
        })
      })
      return result
    },
    handleNodeClick(data) {
      this.currentNode = data
      this.queryParams.nodeType = '2'
      this.queryParams.subjectId = data.subjectId || this.queryParams.subjectId
      if (data.nodeKind === 'version' || data.nodeKind === 'chapter') {
        this.queryParams.parentId = data.knowledgeId || data.id
      } else {
        this.queryParams.parentId = undefined
      }
      this.handleQuery()
    },
    getList() {
      if (!this.queryParams.subjectId) {
        this.knowledgeList = []
        this.total = 0
        this.edgeCountMap = {}
        this.subjectEdgeCount = null
        return
      }
      this.loading = true
      const q = Object.assign({}, this.queryParams, { nodeType: '2' })
      listKnowledge(q).then(response => {
        this.knowledgeList = response.rows || []
        this.total = response.total || 0
        this.loading = false
        this.refreshSubjectEdgeCounts()
      }).catch(() => {
        this.loading = false
      })
    },
    refreshSubjectEdgeCounts() {
      const subjectId = this.queryParams.subjectId
      if (!subjectId) {
        this.edgeCountMap = {}
        this.subjectEdgeCount = null
        return
      }
      listKnowledgeEdge({ subjectId }).then(res => {
        const list = (res && res.data) ? res.data : []
        this.subjectEdgeCount = list.length
        const map = {}
        list.forEach(e => {
          const tid = e.toKnowledgeId
          if (tid == null) return
          map[tid] = (map[tid] || 0) + 1
        })
        this.edgeCountMap = map
      }).catch(() => {
        this.subjectEdgeCount = null
        this.edgeCountMap = {}
      })
    },
    openSubjectEdgeDrawer() {
      if (!this.queryParams.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      this.subjectEdgeOpen = true
      this.loadSubjectEdges()
    },
    loadSubjectEdges() {
      const subjectId = this.queryParams.subjectId
      if (!subjectId) {
        this.subjectEdgeList = []
        return
      }
      this.subjectEdgeLoading = true
      listKnowledgeEdge({ subjectId }).then(res => {
        this.subjectEdgeList = (res && res.data) ? res.data : []
        this.subjectEdgeCount = this.subjectEdgeList.length
      }).catch(() => {
        this.subjectEdgeList = []
      }).finally(() => {
        this.subjectEdgeLoading = false
      })
    },
    removeSubjectEdge(row) {
      if (!row || !row.edgeId) return
      this.$modal.confirm('确认删除该前置依赖？').then(() => {
        return delKnowledgeEdge(row.edgeId)
      }).then(() => {
        this.$modal.msgSuccess('已删除')
        this.loadSubjectEdges()
        this.refreshSubjectEdgeCounts()
      }).catch(() => {})
    },
    normalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children
      }
      const type = String(node.nodeType || '')
      const allow = node.knowledgeId === 0 || type === '0' || type === '1'
      return {
        id: node.knowledgeId,
        label: node.knowledgeName,
        children: node.children,
        isDisabled: !allow
      }
    },
    getStructureTreeselect(subjectId) {
      const sid = subjectId || this.form.subjectId || this.queryParams.subjectId
      if (!sid) {
        this.knowledgeOptions = []
        return
      }
      treeKnowledge(sid).then(response => {
        this.knowledgeOptions = this.filterStructureTree(response.data || [])
      })
    },
    filterStructureTree(nodes) {
      const out = []
      ;(nodes || []).forEach(n => {
        const type = String(n.nodeType || '')
        if (type !== '0' && type !== '1') return
        const copy = Object.assign({}, n)
        copy.children = this.filterStructureTree(n.children)
        out.push(copy)
      })
      return out
    },
    cancel() {
      this.open = false
      this.resetFormData('2')
    },
    resetFormData(nodeType) {
      let parentId = undefined
      if (nodeType === '0') {
        parentId = 0
      } else if (this.currentNode && (this.currentNode.nodeKind === 'version' || this.currentNode.nodeKind === 'chapter')) {
        parentId = this.currentNode.knowledgeId || this.currentNode.id
      }
      this.form = {
        knowledgeId: undefined,
        subjectId: this.queryParams.subjectId,
        parentId,
        nodeType: nodeType || '2',
        knowledgeName: undefined,
        knowledgeCode: undefined,
        difficultyDefault: '2',
        orderNum: 0,
        status: '0',
        remark: undefined
      }
      this.resetForm('form')
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.queryParams.nodeType = '2'
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.queryParams.knowledgeName = undefined
      this.queryParams.status = undefined
      this.queryParams.nodeType = '2'
      if (this.currentNode) {
        this.handleNodeClick(this.currentNode)
      } else {
        this.handleQuery()
      }
    },
    handleAddVersion() {
      if (!this.queryParams.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      this.resetFormData('0')
      this.form.parentId = 0
      this.open = true
      this.title = '添加版本'
    },
    handleEditVersionFromTree(data) {
      this.currentNode = data
      getKnowledge(data.knowledgeId || data.id).then(response => {
        this.form = response.data
        this.form.nodeType = '0'
        this.form.parentId = 0
        this.open = true
        this.title = '修改版本'
      })
    },
    handleAddChapterFromTree(data) {
      this.currentNode = data
      this.queryParams.subjectId = data.subjectId
      this.resetFormData('1')
      this.form.subjectId = data.subjectId
      this.form.parentId = data.knowledgeId || data.id
      this.getStructureTreeselect(data.subjectId)
      this.open = true
      this.title = '添加章节'
    },
    handleEditChapterFromTree(data) {
      this.currentNode = data
      this.queryParams.subjectId = data.subjectId
      this.getStructureTreeselect(data.subjectId)
      getKnowledge(data.knowledgeId || data.id).then(response => {
        this.form = response.data
        this.form.nodeType = '1'
        this.open = true
        this.title = '修改章节'
      })
    },
    handleDeleteTreeNode(data, label) {
      const name = data.label || ''
      this.$modal.confirm('是否确认删除' + label + '"' + name + '"？').then(() => {
        return delKnowledge(data.knowledgeId || data.id)
      }).then(() => {
        if (this.queryParams.parentId === (data.knowledgeId || data.id)) {
          this.queryParams.parentId = undefined
          this.currentNode = null
        }
        this.loadSidebarTree()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    handleAddKnowledge() {
      if (!this.canAddKnowledge) {
        this.$modal.msgWarning('请先在左侧选择章节')
        return
      }
      this.resetFormData('2')
      this.getStructureTreeselect()
      this.open = true
      this.title = '添加知识点'
    },
    handleUpdateKnowledge(row) {
      this.getStructureTreeselect(row.subjectId || this.queryParams.subjectId)
      getKnowledge(row.knowledgeId).then(response => {
        this.form = response.data
        this.form.nodeType = '2'
        this.open = true
        this.title = '修改知识点'
      })
    },
    handleDeleteKnowledge(row) {
      this.$modal.confirm('是否确认删除知识点"' + row.knowledgeName + '"？').then(() => {
        return delKnowledge(row.knowledgeId)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    openEdgeDrawer(row) {
      this.edgeTarget = row || {}
      this.edgeFromId = undefined
      this.edgeOpen = true
      this.loadEdges()
      this.loadLeafOptions()
    },
    loadEdges() {
      if (!this.edgeTarget.knowledgeId) {
        this.edgeList = []
        return
      }
      this.edgeLoading = true
      listKnowledgeEdge({ toKnowledgeId: this.edgeTarget.knowledgeId }).then(res => {
        this.edgeList = (res && res.data) ? res.data : []
      }).catch(() => {
        this.edgeList = []
      }).finally(() => {
        this.edgeLoading = false
      })
    },
    loadLeafOptions() {
      const subjectId = this.edgeTarget.subjectId || this.queryParams.subjectId
      if (!subjectId) {
        this.leafOptions = []
        return
      }
      this.leafLoading = true
      listKnowledge({
        pageNum: 1,
        pageSize: 500,
        subjectId,
        nodeType: '2',
        status: '0'
      }).then(res => {
        this.leafOptions = (res.rows || []).filter(k => k.knowledgeId !== this.edgeTarget.knowledgeId)
      }).catch(() => {
        this.leafOptions = []
      }).finally(() => {
        this.leafLoading = false
      })
    },
    addEdge() {
      if (!this.edgeFromId || !this.edgeTarget.knowledgeId) {
        this.$modal.msgWarning('请选择前置知识点')
        return
      }
      if (this.edgeFromId === this.edgeTarget.knowledgeId) {
        this.$modal.msgWarning('不能依赖自身')
        return
      }
      this.edgeSaving = true
      addKnowledgeEdge({
        subjectId: this.edgeTarget.subjectId || this.queryParams.subjectId,
        fromKnowledgeId: this.edgeFromId,
        toKnowledgeId: this.edgeTarget.knowledgeId,
        relation: 'prerequisite'
      }).then(() => {
        this.$modal.msgSuccess('已添加依赖')
        this.edgeFromId = undefined
        this.loadEdges()
        this.refreshSubjectEdgeCounts()
      }).catch(() => {}).finally(() => {
        this.edgeSaving = false
      })
    },
    removeEdge(row) {
      if (!row || !row.edgeId) return
      this.$modal.confirm('确认删除该前置依赖？').then(() => {
        return delKnowledgeEdge(row.edgeId)
      }).then(() => {
        this.$modal.msgSuccess('已删除')
        this.loadEdges()
        this.refreshSubjectEdgeCounts()
      }).catch(() => {})
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (!valid) return
        if (this.form.nodeType === '1' && (!this.form.parentId || this.form.parentId === 0)) {
          this.$modal.msgWarning('请选择所属版本')
          return
        }
        if (this.form.nodeType === '2' && (!this.form.parentId || this.form.parentId === 0)) {
          this.$modal.msgWarning('请选择所属章节')
          return
        }
        const req = this.form.knowledgeId != undefined ? updateKnowledge(this.form) : addKnowledge(this.form)
        req.then(() => {
          this.$modal.msgSuccess(this.form.knowledgeId != undefined ? '修改成功' : '新增成功')
          this.open = false
          if (this.form.nodeType === '2') {
            this.getList()
          } else {
            this.loadSidebarTree()
          }
        })
      })
    }
  }
}
</script>

<style scoped>
.knowledge-manage-page {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px !important;
  min-height: calc(100vh - 110px);
  box-sizing: border-box;
  background: transparent;
}
.knowledge-subject-bar {
  background: var(--spas-card, #fff);
  border: 1px solid var(--spas-border, #e8e6f0);
  border-radius: var(--spas-radius, 12px);
  box-shadow: var(--spas-shadow, none);
  padding: 10px 16px 2px;
}
.knowledge-subject-bar .el-form-item {
  margin-bottom: 8px;
}
.mb8 { margin-bottom: 8px; }
.card-header { font-weight: 600; color: #303133; }
.knowledge-body {
  flex: 1;
  min-height: 0;
  padding: 0 !important;
}
</style>
