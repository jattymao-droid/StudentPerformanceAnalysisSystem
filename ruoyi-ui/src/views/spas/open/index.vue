<template>
  <div class="app-container">
    <el-tabs v-model="activeTab" @tab-click="handleTabClick">
      <el-tab-pane label="开放客户端" name="client">
        <el-form :model="clientQuery" size="small" :inline="true" label-width="68px">
          <el-form-item label="AppId">
            <el-input v-model="clientQuery.appId" placeholder="AppId" clearable @keyup.enter.native="loadClients" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="loadClients">搜索</el-button>
            <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="openClientForm()" v-hasPermi="['spas:open:client:add']">新增</el-button>
          </el-form-item>
        </el-form>
        <el-table v-loading="clientLoading" :data="clientList">
          <el-table-column label="AppId" prop="appId" min-width="140" />
          <el-table-column label="名称" prop="appName" min-width="120" />
          <el-table-column label="Secret" prop="appSecret" min-width="160" :show-overflow-tooltip="true" />
          <el-table-column label="状态" width="90" align="center">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="140" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click="openClientForm(scope.row)" v-hasPermi="['spas:open:client:edit']">修改</el-button>
              <el-button size="mini" type="text" @click="removeClient(scope.row)" v-hasPermi="['spas:open:client:remove']">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="clientTotal > 0" :total="clientTotal" :page.sync="clientQuery.pageNum" :limit.sync="clientQuery.pageSize" @pagination="loadClients" />
      </el-tab-pane>

      <el-tab-pane label="家长账号" name="parent">
        <el-form :model="parentQuery" size="small" :inline="true" label-width="68px">
          <el-form-item label="手机号">
            <el-input v-model="parentQuery.mobile" placeholder="手机号" clearable @keyup.enter.native="loadParents" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="loadParents">搜索</el-button>
            <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="openParentForm()" v-hasPermi="['spas:open:parent:add']">新增</el-button>
          </el-form-item>
        </el-form>
        <el-table v-loading="parentLoading" :data="parentList" @row-click="selectParent">
          <el-table-column label="姓名" prop="parentName" min-width="120" />
          <el-table-column label="手机号" prop="mobile" width="130" />
          <el-table-column label="状态" width="90" align="center">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="180" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click.stop="openParentForm(scope.row)" v-hasPermi="['spas:open:parent:edit']">修改</el-button>
              <el-button size="mini" type="text" @click.stop="removeParent(scope.row)" v-hasPermi="['spas:open:parent:remove']">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="parentTotal > 0" :total="parentTotal" :page.sync="parentQuery.pageNum" :limit.sync="parentQuery.pageSize" @pagination="loadParents" />

        <el-card shadow="never" style="margin-top: 16px" v-if="selectedParent">
          <div slot="header">绑定学生 - {{ selectedParent.parentName || selectedParent.mobile }}</div>
          <el-form size="small" :inline="true">
            <el-form-item label="学生">
              <el-select
                v-model="bindStudentId"
                filterable
                remote
                clearable
                :remote-method="remoteBindStudent"
                :loading="studentLoading"
                placeholder="输入学号/姓名搜索"
                style="width: 240px"
              >
                <el-option v-for="s in studentOptions" :key="s.studentId" :label="s.studentNo + ' · ' + s.studentName" :value="s.studentId" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" size="mini" @click="doBind" v-hasPermi="['spas:open:parent:edit']">绑定</el-button>
            </el-form-item>
          </el-form>
          <el-table :data="bindStudents" size="small" empty-text="未绑定学生">
            <el-table-column label="学号" prop="studentNo" width="120" />
            <el-table-column label="姓名" prop="studentName" min-width="120" />
            <el-table-column label="操作" width="100" align="center">
              <template slot-scope="scope">
                <el-button size="mini" type="text" @click="doUnbind(scope.row)" v-hasPermi="['spas:open:parent:edit']">解绑</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
    </el-tabs>

    <el-dialog :title="clientFormTitle" :visible.sync="clientOpen" width="480px" append-to-body>
      <el-form ref="clientFormRef" :model="clientForm" label-width="90px">
        <el-form-item label="AppId" prop="appId" :rules="[{ required: true, message: '必填' }]">
          <el-input v-model="clientForm.appId" :disabled="!!clientForm.clientId" />
        </el-form-item>
        <el-form-item label="AppSecret" prop="appSecret" :rules="[{ required: true, message: '必填' }]">
          <el-input v-model="clientForm.appSecret" />
        </el-form-item>
        <el-form-item label="名称">
          <el-input v-model="clientForm.appName" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="clientForm.status">
            <el-radio v-for="d in dict.type.sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="submitClient">确定</el-button>
        <el-button @click="clientOpen = false">取消</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="parentFormTitle" :visible.sync="parentOpen" width="480px" append-to-body>
      <el-form ref="parentFormRef" :model="parentForm" label-width="90px">
        <el-form-item label="姓名">
          <el-input v-model="parentForm.parentName" />
        </el-form-item>
        <el-form-item label="手机号" prop="mobile" :rules="[{ required: true, message: '必填' }]">
          <el-input v-model="parentForm.mobile" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="parentForm.status">
            <el-radio v-for="d in dict.type.sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="submitParent">确定</el-button>
        <el-button @click="parentOpen = false">取消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  listOpenClient, addOpenClient, updateOpenClient, delOpenClient,
  listOpenParent, addOpenParent, updateOpenParent, delOpenParent,
  listParentStudents, bindParentStudent, unbindParentStudent
} from '@/api/spas/open'
import { listStudent } from '@/api/spas/student'

export default {
  name: 'SpasOpenAdmin',
  dicts: ['sys_normal_disable'],
  data() {
    return {
      activeTab: 'client',
      clientLoading: false,
      clientList: [],
      clientTotal: 0,
      clientQuery: { pageNum: 1, pageSize: 10, appId: undefined },
      clientOpen: false,
      clientForm: {},
      clientFormTitle: '',
      parentLoading: false,
      parentList: [],
      parentTotal: 0,
      parentQuery: { pageNum: 1, pageSize: 10, mobile: undefined },
      parentOpen: false,
      parentForm: {},
      parentFormTitle: '',
      selectedParent: null,
      bindStudents: [],
      bindStudentId: undefined,
      studentOptions: [],
      studentLoading: false,
      parentsLoaded: false,
      studentsLoaded: false
    }
  },
  created() {
    this.loadClients()
  },
  methods: {
    handleTabClick(tab) {
      if (tab.name === 'parent') {
        if (!this.parentsLoaded) {
          this.loadParents()
          this.parentsLoaded = true
        }
        if (!this.studentsLoaded) {
          this.loadStudentOptions()
          this.studentsLoaded = true
        }
      }
    },
    loadClients() {
      this.clientLoading = true
      listOpenClient(this.clientQuery).then(res => {
        this.clientList = res.rows || []
        this.clientTotal = res.total || 0
      }).catch(() => {
        this.clientList = []
        this.clientTotal = 0
      }).finally(() => { this.clientLoading = false })
    },
    openClientForm(row) {
      this.clientForm = row ? { ...row } : { status: '0' }
      this.clientFormTitle = row ? '修改客户端' : '新增客户端'
      this.clientOpen = true
    },
    submitClient() {
      const req = this.clientForm.clientId ? updateOpenClient(this.clientForm) : addOpenClient(this.clientForm)
      req.then(() => {
        this.$modal.msgSuccess('保存成功')
        this.clientOpen = false
        this.loadClients()
      }).catch(() => {})
    },
    removeClient(row) {
      this.$modal.confirm('确认删除客户端 ' + row.appId + '？').then(() => delOpenClient(row.clientId)).then(() => {
        this.$modal.msgSuccess('删除成功')
        this.loadClients()
      }).catch(() => {})
    },
    loadParents() {
      this.parentLoading = true
      listOpenParent(this.parentQuery).then(res => {
        this.parentList = res.rows || []
        this.parentTotal = res.total || 0
        this.parentsLoaded = true
      }).catch(() => {
        this.parentList = []
        this.parentTotal = 0
      }).finally(() => { this.parentLoading = false })
    },
    openParentForm(row) {
      this.parentForm = row ? { ...row } : { status: '0' }
      this.parentFormTitle = row ? '修改家长' : '新增家长'
      this.parentOpen = true
    },
    submitParent() {
      const req = this.parentForm.parentId ? updateOpenParent(this.parentForm) : addOpenParent(this.parentForm)
      req.then(() => {
        this.$modal.msgSuccess('保存成功')
        this.parentOpen = false
        this.loadParents()
      }).catch(() => {})
    },
    removeParent(row) {
      this.$modal.confirm('确认删除家长 ' + (row.mobile || row.parentId) + '？').then(() => delOpenParent(row.parentId)).then(() => {
        this.$modal.msgSuccess('删除成功')
        if (this.selectedParent && this.selectedParent.parentId === row.parentId) {
          this.selectedParent = null
          this.bindStudents = []
        }
        this.loadParents()
      }).catch(() => {})
    },
    selectParent(row) {
      this.selectedParent = row
      this.loadBindStudents()
    },
    loadStudentOptions(keyword) {
      const params = { pageNum: 1, pageSize: 50, status: '0' }
      if (keyword) {
        if (/^\d/.test(String(keyword))) params.studentNo = keyword
        else params.studentName = keyword
      }
      this.studentLoading = true
      listStudent(params).then(res => {
        this.studentOptions = res.rows || []
        this.studentsLoaded = true
      }).catch(() => {
        this.studentOptions = []
      }).finally(() => {
        this.studentLoading = false
      })
    },
    remoteBindStudent(query) {
      this.loadStudentOptions(query)
    },
    loadBindStudents() {
      if (!this.selectedParent) return
      listParentStudents(this.selectedParent.parentId).then(res => {
        this.bindStudents = res.data || []
      }).catch(() => {
        this.bindStudents = []
      })
    },
    doBind() {
      if (!this.selectedParent || !this.bindStudentId) return
      bindParentStudent(this.selectedParent.parentId, this.bindStudentId).then(() => {
        this.$modal.msgSuccess('绑定成功')
        this.bindStudentId = undefined
        this.loadBindStudents()
      }).catch(() => {})
    },
    doUnbind(row) {
      unbindParentStudent(this.selectedParent.parentId, row.studentId).then(() => {
        this.$modal.msgSuccess('已解绑')
        this.loadBindStudents()
      }).catch(() => {})
    }
  }
}
</script>
