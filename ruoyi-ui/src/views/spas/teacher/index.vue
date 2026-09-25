<template>
  <div class="app-container tree-sidebar-manage-wrap">
    <tree-panel
      :title="deptPanelTitle"
      :tree-data="deptOptions"
      :search-placeholder="deptTreeSource === 'teaching' ? '请输入班级名称' : '请输入部门名称'"
      storage-key="spas-teacher-sidebar-width"
      :defaultExpandAll="true"
      @node-click="handleNodeClick"
      @refresh="getDeptTree"
    />
    <div class="tree-sidebar-content">
      <div class="content-inner">
        <el-alert
          title="左侧点选具体班级后，可直接指定班主任和科任。同一人可同时选为班主任与科任（兼任）。一个班只能有一名班主任；科任可多选。主属必须是班级。"
          type="info"
          :closable="false"
          show-icon
          class="mb8"
        />

        <el-card v-if="classBind" shadow="never" class="mb8 class-bind-card">
          <div slot="header" class="card-header">{{ classBind.deptName }} · 教师绑定</div>
          <el-form size="small" label-width="88px">
            <el-form-item label="班主任">
              <el-select
                v-model="classBind.homeroomTeacherId"
                clearable
                filterable
                placeholder="未指定"
                style="width: 360px"
              >
                <el-option
                  v-for="item in classBind.homeroomOptions"
                  :key="item.teacherId"
                  :label="teacherOptionLabel(item)"
                  :value="item.teacherId"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="科任教师">
              <el-select
                v-model="classBind.subjectTeacherIds"
                multiple
                filterable
                collapse-tags
                placeholder="选择任课教师，可多选"
                style="width: 360px"
              >
                <el-option
                  v-for="item in classBind.subjectOptions"
                  :key="item.teacherId"
                  :label="teacherOptionLabel(item)"
                  :value="item.teacherId"
                />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" size="mini" :loading="classBindSaving" @click="submitClassBinding" v-hasPermi="['spas:teacher:edit']">保存绑定</el-button>
              <span class="bind-hint">同一人可同时出现在班主任与科任中。仅解除班主任且仍为科任时，会保留在本班。仅移除科任且仍为班主任时，仍留作本班班主任。两者都解除时，才会改挂到其他班或上级部门。</span>
            </el-form-item>
          </el-form>
        </el-card>

        <el-row :gutter="16" class="mb8">
          <el-col :span="24">
            <el-card shadow="never" body-style="padding: 12px 16px">
              <div slot="header" class="card-header">角色权限说明</div>
              <el-row :gutter="12">
                <el-col :xs="24" :sm="12" :md="6" v-for="item in roleOptions" :key="item.teacherType">
                  <div class="role-tip">
                    <div class="role-tip-title">{{ item.label }}</div>
                    <div class="role-tip-meta">{{ item.roleKey }} · 数据范围 {{ dataScopeLabel(item.dataScope) }}</div>
                    <div class="role-tip-desc">{{ item.description }}</div>
                  </div>
                </el-col>
              </el-row>
            </el-card>
          </el-col>
        </el-row>

        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
          <el-form-item label="工号" prop="teacherNo">
            <el-input v-model="queryParams.teacherNo" placeholder="工号" clearable style="width: 160px" @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="姓名" prop="teacherName">
            <el-input v-model="queryParams.teacherName" placeholder="姓名" clearable style="width: 160px" @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="类型" prop="teacherType">
            <el-select v-model="queryParams.teacherType" placeholder="教师类型" clearable style="width: 140px">
              <el-option v-for="dict in dict.type.spas_teacher_type" :key="dict.value" :label="dict.label" :value="dict.value" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>

        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['spas:teacher:add']">新增</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['spas:teacher:edit']">修改</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['spas:teacher:remove']">删除</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['spas:teacher:list']">导出</el-button>
          </el-col>
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
        </el-row>

        <el-table v-loading="loading" :data="teacherList" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="工号" prop="teacherNo" min-width="110" />
          <el-table-column label="姓名" prop="teacherName" min-width="100" />
          <el-table-column label="类型" prop="teacherType" width="120" align="center">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_teacher_type" :value="scope.row.teacherType" />
            </template>
          </el-table-column>
          <el-table-column label="角色" prop="roleKey" min-width="160" align="center" :show-overflow-tooltip="true" />
          <el-table-column label="主属班级" prop="deptName" min-width="120" :show-overflow-tooltip="true" />
          <el-table-column label="其他任课班" prop="extraDeptNames" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span>{{ scope.row.extraDeptNames || '—' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="班主任班" min-width="120" align="center" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span v-if="scope.row.homeroomDeptName || scope.row.homeroomDeptId">{{ scope.row.homeroomDeptName || scope.row.deptName || '—' }}</span>
              <span v-else>—</span>
            </template>
          </el-table-column>
          <el-table-column label="手机" prop="mobile" width="120" />
          <el-table-column label="状态" prop="status" width="90" align="center">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="220">
            <template slot-scope="scope">
              <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['spas:teacher:edit']">修改</el-button>
              <el-button size="mini" type="text" icon="el-icon-key" @click="handleResetPwd(scope.row)" v-hasPermi="['spas:teacher:resetPwd']">重置密码</el-button>
              <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['spas:teacher:remove']">删除</el-button>
            </template>
          </el-table-column>
        </el-table>

        <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
      </div>
    </div>

    <el-dialog :title="title" :visible.sync="open" width="560px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="工号" prop="teacherNo">
          <el-input v-model="form.teacherNo" :disabled="form.teacherId != undefined" maxlength="32" />
        </el-form-item>
        <el-form-item label="姓名" prop="teacherName">
          <el-input v-model="form.teacherName" maxlength="64" />
        </el-form-item>
        <el-form-item label="教师类型" prop="teacherType">
          <el-select v-model="form.teacherType" placeholder="请选择" style="width: 100%" @change="handleTypeChange">
            <el-option v-for="dict in dict.type.spas_teacher_type" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item :label="deptFieldLabel" prop="deptId">
          <treeselect
            v-if="open"
            :key="'dept-main-' + (form.teacherType || '') + '-' + treeselectTick"
            v-model="form.deptId"
            :options="deptTreeForForm"
            :show-count="true"
            :normalizer="deptNormalizer"
            :placeholder="deptPlaceholder"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item v-if="form.teacherType === '1' || form.teacherType === '2'" label="其他任课班">
          <treeselect
            v-if="open"
            :key="'dept-extra-' + treeselectTick"
            v-model="form.extraDeptIds"
            :options="classDeptOptions"
            :multiple="true"
            :normalizer="deptNormalizer"
            placeholder="可多选其他任课班级（不含主属班级）"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="手机" prop="mobile">
          <el-input v-model="form.mobile" maxlength="20" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-select v-model="form.gender" style="width: 100%">
            <el-option v-for="dict in dict.type.sys_user_sex" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.value">{{ dict.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-alert v-if="selectedRoleTip" :title="selectedRoleTip" type="warning" :closable="false" show-icon />
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTeacher, getTeacher, addTeacher, updateTeacher, delTeacher, resetTeacherPwd, listTeacherRoleOptions, getClassBinding, saveClassBinding, listMyTeachingDepts } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
import { loadSpasDeptTree, preferredTeachingDeptId } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import TreePanel from '@/components/TreePanel'

export default {
  name: 'SpasTeacher',
  dicts: ['sys_normal_disable', 'sys_user_sex', 'spas_teacher_type'],
  components: { Treeselect, TreePanel },
  data() {
    return {
      loading: false,
      showSearch: true,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      teacherList: [],
      roleOptions: [],
      deptPanelTitle: '组织部门',
      deptTreeSource: 'system',
      deptOptions: [],
      enabledDeptOptions: [],
      classBind: null,
      classBindSaving: false,
      treeselectTick: 0,
      title: '',
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        teacherNo: undefined,
        teacherName: undefined,
        teacherType: undefined,
        deptId: undefined,
        status: '0'
      },
      form: {},
      rules: {
        teacherNo: [{ required: true, message: '工号不能为空', trigger: 'blur' }],
        teacherName: [{ required: true, message: '姓名不能为空', trigger: 'blur' }],
        teacherType: [{ required: true, message: '请选择教师类型', trigger: 'change' }],
        deptId: [{ required: true, message: '请选择班级或部门', trigger: 'change' }]
      }
    }
  },
  computed: {
    selectedRoleTip() {
      const opt = this.roleOptions.find(o => o.teacherType === this.form.teacherType)
      return opt ? opt.label + '：' + opt.description : ''
    },
    deptPlaceholder() {
      const t = this.form.teacherType
      if (t === '3') return '请选择年级部门'
      if (t === '4') return '请选择学校部门'
      return '请选择班级'
    },
    deptFieldLabel() {
      const t = this.form.teacherType
      if (t === '1' || t === '2' || !t) return '主属班级'
      if (t === '3') return '年级'
      if (t === '4') return '学校'
      return '主属部门'
    },
    classDeptOptions() {
      const leaves = this.flattenDeptLeaves(this.enabledDeptOptions)
      return this.ensureDeptOption(leaves, this.form && this.form.deptId, this.form && this.form.deptName)
    },
    branchDeptOptions() {
      const tree = this.markDeptNodes(this.enabledDeptOptions, false)
      return this.ensureDeptOption(tree, this.form && this.form.deptId, this.form && this.form.deptName)
    },
    deptTreeForForm() {
      const t = this.form.teacherType
      if (t === '1' || t === '2' || !t) {
        return this.classDeptOptions
      }
      return this.branchDeptOptions
    }
  },
  created() {
    this.loadRoleOptions()
    this.getList()
    this.getDeptTree()
  },
  methods: {
    dataScopeLabel(v) {
      const map = { '1': '全部', '2': '自定义', '3': '本部门', '4': '本部门及以下' }
      return map[v] || v
    },
    loadRoleOptions() {
      listTeacherRoleOptions().then(res => {
        this.roleOptions = res.data || []
      })
    },
    getList() {
      this.loading = true
      listTeacher(this.queryParams).then(res => {
        this.teacherList = res.rows
        this.total = res.total
      }).finally(() => { this.loading = false })
    },
    getDeptTree() {
      return loadSpasDeptTree(listMyTeachingDepts, deptTreeSelect).then(result => {
        this.deptTreeSource = result.source
        this.deptPanelTitle = result.source === 'teaching' ? '任教班级' : '组织部门'
        this.deptOptions = result.tree || []
        this.enabledDeptOptions = this.filterDisabledDept(JSON.parse(JSON.stringify(this.deptOptions)))
        if (result.source === 'teaching' && !this.queryParams.deptId) {
          const preferred = preferredTeachingDeptId(result.myDepts)
          if (preferred) {
            this.queryParams.deptId = preferred
            this.getList()
            this.loadClassBinding(preferred)
          }
        }
      })
    },
    filterDisabledDept(list) {
      return list.filter(dept => {
        if (dept.disabled) return false
        if (dept.children && dept.children.length) dept.children = this.filterDisabledDept(dept.children)
        return true
      })
    },
    deptNormalizer(node) {
      const rawChildren = node.children
      const hasKids = Array.isArray(rawChildren) && rawChildren.length > 0
      return {
        id: node.id != null ? Number(node.id) : node.id,
        label: node.label || node.deptName || (node.id != null ? String(node.id) : ''),
        children: hasKids ? rawChildren : undefined,
        isDisabled: !!node.isDisabled
      }
    },
    flattenDeptLeaves(nodes, acc) {
      const out = acc || []
      ;(nodes || []).forEach(node => {
        const kids = node.children || []
        if (!kids.length) {
          out.push({ id: Number(node.id), label: node.label || node.deptName || String(node.id) })
        } else {
          this.flattenDeptLeaves(kids, out)
        }
      })
      return out
    },
    ensureDeptOption(options, deptId, deptName) {
      const list = (options || []).slice()
      if (deptId == null || deptId === '') return list
      const id = Number(deptId)
      const exists = this.findDeptOption(list, id)
      if (!exists) {
        list.unshift({ id: id, label: deptName || (String(id) + ' 班') })
      }
      return list
    },
    findDeptOption(nodes, id) {
      for (const n of nodes || []) {
        if (Number(n.id) === Number(id)) return n
        const c = this.findDeptOption(n.children, id)
        if (c) return c
      }
      return null
    },
    markDeptNodes(nodes, preferBranch) {
      return (nodes || []).map(node => {
        const rawChildren = node.children || []
        const children = this.markDeptNodes(rawChildren, preferBranch)
        const leaf = rawChildren.length === 0
        const copy = {
          id: Number(node.id),
          label: node.label || node.deptName || String(node.id),
          isDisabled: preferBranch ? leaf : false
        }
        if (children.length) {
          copy.children = children
        }
        return copy
      })
    },
    teacherOptionLabel(item) {
      if (!item) return ''
      let label = (item.teacherName || '') + (item.teacherNo ? '（' + item.teacherNo + '）' : '')
      if (item.status === '1') label += ' · 停用'
      else if (item.deptName && this.classBind && item.deptId !== this.classBind.deptId) label += ' · 现属' + item.deptName
      return label
    },
    handleNodeClick(data) {
      this.queryParams.deptId = data.id
      this.handleQuery()
      const leaf = !data.children || data.children.length === 0
      if (!leaf) {
        this.classBind = null
        return
      }
      this.loadClassBinding(data.id)
    },
    loadClassBinding(deptId) {
      getClassBinding(deptId).then(res => {
        const data = res.data || {}
        this.classBind = {
          deptId: data.deptId,
          deptName: data.deptName,
          homeroomTeacherId: data.homeroom ? data.homeroom.teacherId : undefined,
          loadedHomeroomId: data.homeroom ? data.homeroom.teacherId : undefined,
          subjectTeacherIds: data.subjectTeacherIds || [],
          homeroomOptions: data.homeroomOptions || [],
          subjectOptions: data.subjectOptions || []
        }
      }).catch(() => { this.classBind = null })
    },
    submitClassBinding() {
      if (!this.classBind || !this.classBind.deptId) return
      const prev = this.classBind.loadedHomeroomId
      const next = this.classBind.homeroomTeacherId || null
      const run = () => {
        this.classBindSaving = true
        saveClassBinding({
          deptId: this.classBind.deptId,
          homeroomTeacherId: next,
          subjectTeacherIds: this.classBind.subjectTeacherIds || []
        }).then(res => {
          this.$modal.msgSuccess(res.msg || '绑定已保存')
          this.loadClassBinding(this.classBind.deptId)
          this.getList()
        }).finally(() => { this.classBindSaving = false })
      }
      if (prev && prev !== next) {
        this.$modal.confirm('更换或清空班主任后，原班主任将改挂到上级部门，不再作为本班班主任。是否继续？').then(run).catch(() => {})
        return
      }
      run()
    },
    handleTypeChange() {
      if (this.queryParams.deptId != null) {
        this.form.deptId = Number(this.queryParams.deptId)
      }
      if (this.form.teacherType !== '1' && this.form.teacherType !== '2') {
        this.form.extraDeptIds = []
        this.form.homeroomDeptId = undefined
      }
      this.treeselectTick += 1
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        teacherId: undefined,
        teacherNo: undefined,
        teacherName: undefined,
        teacherType: '1',
        deptId: this.queryParams.deptId,
        extraDeptIds: [],
        mobile: undefined,
        gender: '0',
        status: '0',
        remark: undefined
      }
      this.resetForm('form')
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    handleExport() {
      this.download('spas/teacher/export', { ...this.queryParams }, `teacher_${new Date().getTime()}.xlsx`)
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.queryParams.deptId = undefined
      this.queryParams.status = '0'
      this.classBind = null
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.teacherId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.treeselectTick += 1
      this.open = true
      this.title = '添加教师'
    },
    handleUpdate(row) {
      this.reset()
      const teacherId = row.teacherId || this.ids
      const openForm = (data) => {
        const form = Object.assign({}, data || {})
        if (form.deptId != null) form.deptId = Number(form.deptId)
        if (form.homeroomDeptId != null) form.homeroomDeptId = Number(form.homeroomDeptId)
        form.extraDeptIds = (form.extraDeptIds || []).map(id => Number(id))
        this.form = form
        this.treeselectTick += 1
        this.open = true
        this.title = '修改教师'
      }
      Promise.resolve(this.enabledDeptOptions && this.enabledDeptOptions.length ? null : this.getDeptTree())
        .then(() => getTeacher(teacherId))
        .then(res => openForm(res.data))
    },
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        const req = this.form.teacherId ? updateTeacher(this.form) : addTeacher(this.form)
        req.then(() => {
          this.$modal.msgSuccess(this.form.teacherId ? '修改成功' : '新增成功，已创建账号并分配角色')
          this.open = false
          this.getList()
        })
      })
    },
    handleDelete(row) {
      const teacherIds = row.teacherId || this.ids
      this.$modal.confirm('确认删除教师编号 "' + teacherIds + '"？').then(() => delTeacher(teacherIds)).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    handleResetPwd(row) {
      this.$modal.confirm('确认将「' + row.teacherName + '」密码重置为初始密码？').then(() => resetTeacherPwd(row.teacherId)).then(() => {
        this.$modal.msgSuccess('重置成功')
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.class-bind-card >>> .el-card__header {
  padding: 10px 16px;
}
.bind-hint {
  margin-left: 12px;
  color: #64748b;
  font-size: 12px;
}
</style>

