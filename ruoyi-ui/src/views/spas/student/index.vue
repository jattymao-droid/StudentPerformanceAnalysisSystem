<template>
  <div class="app-container tree-sidebar-manage-wrap">
    <tree-panel
      title="组织机构"
      :tree-data="deptOptions"
      search-placeholder="请输入部门名称"
      storage-key="spas-student-sidebar-width-v2"
      :default-width="300"
      :defaultExpandAll="true"
      @node-click="handleNodeClick"
      @refresh="getDeptTree"
      ref="deptTreeRef"
    >
      <template slot="node-actions" slot-scope="{ data }">
        <el-button
          type="text"
          icon="el-icon-folder-add"
          title="新增下级"
          v-hasPermi="['system:dept:add']"
          @click="handleDeptAdd(data)"
        />
        <el-button
          type="text"
          icon="el-icon-edit"
          title="修改"
          v-hasPermi="['system:dept:edit']"
          @click="handleDeptUpdate(data)"
        />
        <el-button
          v-if="data.parentId != 0"
          type="text"
          icon="el-icon-delete"
          title="删除"
          v-hasPermi="['system:dept:remove']"
          @click="handleDeptDelete(data)"
        />
      </template>
    </tree-panel>
    <div class="tree-sidebar-content">
      <div class="content-inner">
        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
          <el-form-item label="学号" prop="studentNo">
            <el-input v-model="queryParams.studentNo" placeholder="请输入学号" clearable style="width: 180px" @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="姓名" prop="studentName">
            <el-input v-model="queryParams.studentName" placeholder="请输入姓名" clearable style="width: 180px" @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 140px">
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
            <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['spas:student:add']">新增</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['spas:student:edit']">修改</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['spas:student:remove']">删除</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="info" plain icon="el-icon-upload2" size="mini" @click="handleImport" v-hasPermi="['spas:student:import']">导入</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['spas:student:export']">导出</el-button>
          </el-col>
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
        </el-row>

        <el-alert
          title="新建学生将自动创建登录账号（默认学号为用户名），并分配学生角色。"
          type="info"
          :closable="false"
          show-icon
          class="mb8"
        />

        <el-table v-loading="loading" :data="studentList" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="学号" align="center" prop="studentNo" min-width="120" :show-overflow-tooltip="true" />
          <el-table-column label="姓名" align="center" prop="studentName" min-width="100" :show-overflow-tooltip="true" />
          <el-table-column label="性别" align="center" prop="gender" width="80">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.sys_user_sex" :value="scope.row.gender" />
            </template>
          </el-table-column>
          <el-table-column label="班级/部门" align="center" prop="deptName" min-width="120" :show-overflow-tooltip="true" />
          <el-table-column label="入学年级" align="center" prop="gradeYear" width="100" />
          <el-table-column label="家长手机" align="center" prop="parentMobile" width="120" />
          <el-table-column label="状态" align="center" prop="status" width="90">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
            </template>
          </el-table-column>
          <el-table-column label="创建时间" align="center" prop="createTime" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.createTime) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="260" class-name="small-padding fixed-width">
            <template slot-scope="scope">
              <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['spas:student:edit']">修改</el-button>
              <el-button size="mini" type="text" icon="el-icon-notebook-2" @click="goPortfolio(scope.row)" v-hasPermi="['spas:portfolio:list']">档案</el-button>
              <el-button size="mini" type="text" icon="el-icon-key" @click="handleResetPwd(scope.row)" v-hasPermi="['spas:student:resetPwd']">重置密码</el-button>
              <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['spas:student:remove']">删除</el-button>
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

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="90px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="学号" prop="studentNo">
              <el-input v-model="form.studentNo" placeholder="请输入学号" maxlength="32" :disabled="form.studentId != undefined" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="姓名" prop="studentName">
              <el-input v-model="form.studentName" placeholder="请输入姓名" maxlength="64" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="性别" prop="gender">
              <el-select v-model="form.gender" placeholder="请选择性别" style="width: 100%">
                <el-option
                  v-for="dict in dict.type.sys_user_sex"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="班级" prop="deptId">
              <treeselect v-model="form.deptId" :options="enabledDeptOptions" :show-count="true" placeholder="请选择班级/部门" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="入学年级" prop="gradeYear">
              <el-input v-model="form.gradeYear" placeholder="如 2024" maxlength="16" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="家长手机" prop="parentMobile">
              <el-input v-model="form.parentMobile" placeholder="请输入家长手机" maxlength="20" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio
                  v-for="dict in dict.type.sys_normal_disable"
                  :key="dict.value"
                  :label="dict.value"
                >{{ dict.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-alert
          v-if="!form.studentId"
          title="保存后系统将自动创建登录账号，无需手工录入用户名密码。"
          type="warning"
          :closable="false"
          show-icon
          style="margin-bottom: 12px"
        />
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="deptTitle" :visible.sync="deptOpen" width="560px" append-to-body>
      <el-form ref="deptForm" :model="deptForm" :rules="deptRules" label-width="90px">
        <el-form-item v-if="deptForm.parentId !== 0" label="上级部门" prop="parentId">
          <treeselect
            v-model="deptForm.parentId"
            :options="deptParentOptions"
            :normalizer="deptNormalizer"
            placeholder="选择上级部门"
          />
        </el-form-item>
        <el-form-item label="部门名称" prop="deptName">
          <el-input v-model="deptForm.deptName" placeholder="请输入部门/班级名称" maxlength="30" />
        </el-form-item>
        <el-form-item label="显示排序" prop="orderNum">
          <el-input-number v-model="deptForm.orderNum" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="负责人" prop="leader">
          <el-input v-model="deptForm.leader" placeholder="请输入负责人" maxlength="20" />
        </el-form-item>
        <el-form-item label="联系电话" prop="phone">
          <el-input v-model="deptForm.phone" placeholder="请输入联系电话" maxlength="11" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="deptForm.status">
            <el-radio
              v-for="dict in dict.type.sys_normal_disable"
              :key="dict.value"
              :label="dict.value"
            >{{ dict.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitDeptForm">确 定</el-button>
        <el-button @click="cancelDept">取 消</el-button>
      </div>
    </el-dialog>

    <excel-import-dialog
      ref="importDialog"
      title="学生导入"
      action="/spas/student/importData"
      template-action="/spas/student/importTemplate"
      template-file-name="student_template"
      :template-params="{ deptId: queryParams.deptId }"
      update-support-label="是否更新已存在学生"
      @success="getList"
    />
  </div>
</template>

<script>
import { listStudent, getStudent, addStudent, updateStudent, delStudent, resetStudentPwd } from '@/api/spas/student'
import { listDept, getDept, addDept, updateDept, delDept, listDeptExcludeChild } from '@/api/system/dept'
import { deptTreeSelect } from '@/api/system/user'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import TreePanel from '@/components/TreePanel'
import ExcelImportDialog from '@/components/ExcelImportDialog'

export default {
  name: 'SpasStudent',
  dicts: ['sys_normal_disable', 'sys_user_sex'],
  components: { Treeselect, TreePanel, ExcelImportDialog },
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      studentList: [],
      title: '',
      open: false,
      deptOptions: undefined,
      enabledDeptOptions: undefined,
      deptOpen: false,
      deptTitle: '',
      deptForm: {},
      deptParentOptions: [],
      deptRules: {
        parentId: [{ required: true, message: '上级部门不能为空', trigger: 'change' }],
        deptName: [{ required: true, message: '部门名称不能为空', trigger: 'blur' }],
        orderNum: [{ required: true, message: '显示排序不能为空', trigger: 'blur' }],
        phone: [{
          pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/,
          message: '请输入正确的手机号码',
          trigger: 'blur'
        }]
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        studentNo: undefined,
        studentName: undefined,
        status: '0',
        deptId: undefined
      },
      form: {},
      rules: {
        studentNo: [
          { required: true, message: '学号不能为空', trigger: 'blur' }
        ],
        studentName: [
          { required: true, message: '姓名不能为空', trigger: 'blur' }
        ],
        deptId: [
          { required: true, message: '班级不能为空', trigger: 'change' }
        ],
        parentMobile: [
          {
            pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/,
            message: '请输入正确的手机号码',
            trigger: 'blur'
          }
        ]
      }
    }
  },
  created() {
    this.getList()
    this.getDeptTree()
  },
  methods: {
    getList() {
      this.loading = true
      listStudent(this.queryParams).then(response => {
        this.studentList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    getDeptTree() {
      deptTreeSelect().then(response => {
        this.deptOptions = this.attachDeptMeta(response.data || [], 0)
        this.enabledDeptOptions = this.filterDisabledDept(JSON.parse(JSON.stringify(this.deptOptions)))
      })
    },
    attachDeptMeta(nodes, parentId) {
      return (nodes || []).map(n => {
        const id = n.id
        const item = {
          id,
          label: n.label,
          deptId: id,
          parentId: parentId,
          disabled: !!n.disabled,
          children: undefined
        }
        if (n.children && n.children.length) {
          item.children = this.attachDeptMeta(n.children, id)
        }
        return item
      })
    },
    deptNormalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children
      }
      return {
        id: node.deptId,
        label: node.deptName,
        children: node.children
      }
    },
    filterDisabledDept(deptList) {
      return (deptList || []).filter(dept => {
        if (dept.disabled) {
          return false
        }
        if (dept.children && dept.children.length) {
          dept.children = this.filterDisabledDept(dept.children)
        }
        return true
      })
    },
    handleNodeClick(data) {
      this.queryParams.deptId = data.id || data.deptId
      this.handleQuery()
    },
    resetDeptForm() {
      this.deptForm = {
        deptId: undefined,
        parentId: undefined,
        deptName: undefined,
        orderNum: 0,
        leader: undefined,
        phone: undefined,
        email: undefined,
        status: '0'
      }
      this.resetForm('deptForm')
    },
    cancelDept() {
      this.deptOpen = false
      this.resetDeptForm()
    },
    handleDeptAdd(data) {
      this.resetDeptForm()
      this.deptForm.parentId = data.deptId || data.id
      this.deptOpen = true
      this.deptTitle = '新增下级部门'
      listDept().then(response => {
        this.deptParentOptions = this.handleTree(response.data || [], 'deptId')
      })
    },
    handleDeptUpdate(data) {
      this.resetDeptForm()
      const deptId = data.deptId || data.id
      getDept(deptId).then(response => {
        this.deptForm = response.data
        this.deptOpen = true
        this.deptTitle = '修改部门'
        listDeptExcludeChild(deptId).then(res => {
          this.deptParentOptions = this.handleTree(res.data || [], 'deptId')
          if (!this.deptParentOptions.length && this.deptForm.parentId) {
            this.deptParentOptions.push({
              deptId: this.deptForm.parentId,
              deptName: this.deptForm.parentName || '上级部门',
              children: []
            })
          }
        })
      })
    },
    submitDeptForm() {
      this.$refs['deptForm'].validate(valid => {
        if (!valid) return
        const req = this.deptForm.deptId != undefined ? updateDept(this.deptForm) : addDept(this.deptForm)
        req.then(() => {
          this.$modal.msgSuccess(this.deptForm.deptId != undefined ? '修改成功' : '新增成功')
          this.deptOpen = false
          this.getDeptTree()
        })
      })
    },
    handleDeptDelete(data) {
      const name = data.label || data.deptName || ''
      const deptId = data.deptId || data.id
      this.$modal.confirm('是否确认删除部门"' + name + '"？').then(() => {
        return delDept(deptId)
      }).then(() => {
        if (this.queryParams.deptId === deptId) {
          this.queryParams.deptId = undefined
          this.getList()
        }
        this.getDeptTree()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        studentId: undefined,
        studentNo: undefined,
        studentName: undefined,
        gender: '0',
        deptId: this.queryParams.deptId,
        gradeYear: undefined,
        parentMobile: undefined,
        status: '0',
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
      this.queryParams.deptId = undefined
      this.queryParams.status = '0'
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.studentId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '添加学生'
    },
    handleUpdate(row) {
      this.reset()
      const studentId = row.studentId || this.ids
      getStudent(studentId).then(response => {
        this.form = response.data
        this.open = true
        this.title = '修改学生'
      })
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          if (this.form.studentId != undefined) {
            updateStudent(this.form).then(() => {
              this.$modal.msgSuccess('修改成功')
              this.open = false
              this.getList()
            })
          } else {
            addStudent(this.form).then(() => {
              this.$modal.msgSuccess('新增成功，已自动创建登录账号')
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    handleDelete(row) {
      const studentIds = row.studentId || this.ids
      this.$modal.confirm('是否确认删除学生编号为"' + studentIds + '"的数据项？').then(function() {
        return delStudent(studentIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    goPortfolio(row) {
      this.$router.push({
        path: '/spas/portfolio',
        query: { studentId: row.studentId }
      })
    },
    handleResetPwd(row) {
      this.$modal.confirm('确认将「' + row.studentName + '」密码重置为系统初始密码？').then(() => {
        return resetStudentPwd(row.studentId)
      }).then(() => {
        this.$modal.msgSuccess('重置成功，请使用初始密码登录')
      }).catch(() => {})
    },
    handleImport() {
      this.$refs.importDialog.open()
    },
    handleExport() {
      this.download('spas/student/export', { ...this.queryParams }, `student_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>
