<template>
  <div class="app-container tree-sidebar-manage-wrap">
    <tree-panel
      title="组织部门"
      :tree-data="deptOptions"
      search-placeholder="请输入部门名称"
      storage-key="spas-teacher-sidebar-width"
      :defaultExpandAll="true"
      @node-click="handleNodeClick"
      @refresh="getDeptTree"
    />
    <div class="tree-sidebar-content">
      <div class="content-inner">
        <el-alert
          title="新建教师将自动创建登录账号并分配对应角色权限。主属部门按类型选择：任课/班主任→班级，年级负责人→年级，校级领导→学校。"
          type="info"
          :closable="false"
          show-icon
          class="mb8"
        />

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
          <el-table-column label="角色" prop="roleKey" width="140" align="center" />
          <el-table-column label="主属部门" prop="deptName" min-width="120" :show-overflow-tooltip="true" />
          <el-table-column label="附加班级" prop="extraDeptNames" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span v-if="scope.row.teacherType === '1'">{{ scope.row.extraDeptNames || '—' }}</span>
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
        <el-form-item label="主属部门" prop="deptId">
          <treeselect v-model="form.deptId" :options="enabledDeptOptions" :show-count="true" :placeholder="deptPlaceholder" />
        </el-form-item>
        <el-form-item v-if="form.teacherType === '1'" label="附加班级">
          <treeselect
            v-model="form.extraDeptIds"
            :options="enabledDeptOptions"
            :multiple="true"
            :show-count="true"
            placeholder="可多选其他任课班级（不含主属部门）"
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
import { listTeacher, getTeacher, addTeacher, updateTeacher, delTeacher, resetTeacherPwd, listTeacherRoleOptions } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
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
      deptOptions: [],
      enabledDeptOptions: [],
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
        deptId: [{ required: true, message: '请选择部门', trigger: 'change' }]
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
      return '请选择班级部门'
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
      deptTreeSelect().then(res => {
        this.deptOptions = res.data
        this.enabledDeptOptions = this.filterDisabledDept(JSON.parse(JSON.stringify(res.data || [])))
      })
    },
    filterDisabledDept(list) {
      return list.filter(dept => {
        if (dept.disabled) return false
        if (dept.children && dept.children.length) dept.children = this.filterDisabledDept(dept.children)
        return true
      })
    },
    handleNodeClick(data) {
      this.queryParams.deptId = data.id
      this.handleQuery()
    },
    handleTypeChange() {
      this.form.deptId = this.queryParams.deptId
      if (this.form.teacherType !== '1') {
        this.form.extraDeptIds = []
      }
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
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.teacherId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '添加教师'
    },
    handleUpdate(row) {
      this.reset()
      const teacherId = row.teacherId || this.ids
      getTeacher(teacherId).then(res => {
        this.form = res.data
        if (!this.form.extraDeptIds) {
          this.form.extraDeptIds = []
        }
        this.open = true
        this.title = '修改教师'
      })
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

