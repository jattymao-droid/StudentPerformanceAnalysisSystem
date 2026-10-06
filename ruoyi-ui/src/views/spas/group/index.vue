<template>
  <div class="app-container">
    <el-form :model="queryParams" size="small" :inline="true" label-width="68px">
      <el-form-item label="班级">
        <el-button-group v-if="myDepts.length">
          <el-button
            v-for="d in myDepts"
            :key="d.deptId"
            size="mini"
            :type="queryParams.deptId === d.deptId ? 'primary' : 'default'"
            @click="selectDept(d.deptId)"
          >{{ d.deptName }}</el-button>
        </el-button-group>
        <treeselect
          v-else
          v-model="queryParams.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="选择班级"
          style="width: 240px"
          @input="getList"
        />
      </el-form-item>
      <el-form-item label="学科">
        <el-select v-model="queryParams.subjectId" clearable placeholder="不限/通用组" style="width: 160px" @change="getList">
          <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="getList">搜索</el-button>
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['spas:group:add']">新建组</el-button>
      </el-form-item>
    </el-form>

    <el-alert class="mb8" type="info" :closable="false" show-icon title="同一班级、同一学科下，一名学生只能在一个活跃组。建议每组 4～6 人。组长在座位上翻本检查，一体机只登记结果，不负责判题。" />

    <el-row :gutter="12">
      <el-col v-for="g in groupList" :key="g.groupId" :xs="24" :sm="12" :md="8">
        <el-card shadow="hover" class="mb8">
          <div slot="header" class="card-head">
            <span>{{ g.groupName }}</span>
            <el-tag size="mini" :type="g.status === '0' ? 'success' : 'info'">{{ g.status === '0' ? '启用' : '停用' }}</el-tag>
          </div>
          <p>组长：{{ g.leaderStudentName || '未指定' }}</p>
          <p>人数：{{ g.memberCount || 0 }}　学科：{{ g.subjectName || '通用' }}
            <el-tag v-if="(g.memberCount || 0) < 4 || (g.memberCount || 0) > 6" type="warning" size="mini">建议 4～6 人</el-tag>
          </p>
          <div>
            <el-button type="text" size="mini" @click="handleUpdate(g)" v-hasPermi="['spas:group:edit']">编辑成员</el-button>
            <el-button type="text" size="mini" @click="handleDelete(g)" v-hasPermi="['spas:group:remove']">解散</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <el-empty v-if="!groupList.length" description="请先选择班级并新建小组" />

    <el-dialog :title="title" :visible.sync="open" width="640px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="组名" prop="groupName">
          <el-input v-model="form.groupName" maxlength="64" placeholder="如：物理1组" />
        </el-form-item>
        <el-form-item label="学科">
          <el-select v-model="form.subjectId" clearable placeholder="空=不分科通用组" style="width: 100%">
            <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
          </el-select>
        </el-form-item>
        <el-form-item label="成员" prop="studentIds">
          <el-transfer
            v-model="form.studentIds"
            :data="transferData"
            :titles="['本班学生', '组内']"
            filterable
          />
        </el-form-item>
        <el-form-item label="组长" prop="leaderStudentId">
          <el-select v-model="form.leaderStudentId" clearable placeholder="从组内指定组长" style="width: 100%">
            <el-option
              v-for="s in selectedStudents"
              :key="s.studentId"
              :label="(s.studentNo || '') + ' ' + s.studentName"
              :value="s.studentId"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="submitForm">保 存</el-button>
        <el-button @click="open = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listStudyGroup, getStudyGroup, addStudyGroup, updateStudyGroup, delStudyGroup } from '@/api/spas/group'
import { listStudent } from '@/api/spas/student'
import { optionselectSubject } from '@/api/spas/subject'
import { deptTreeSelect } from '@/api/system/user'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { applyTeachingDeptContext } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  name: 'StudyGroup',
  components: { Treeselect },
  data() {
    return {
      myDepts: [],
      deptOptions: [],
      subjectOptions: [],
      groupList: [],
      classStudents: [],
      open: false,
      title: '',
      queryParams: { deptId: undefined, subjectId: undefined, pageNum: 1, pageSize: 50 },
      form: {},
      rules: {
        groupName: [{ required: true, message: '请填写组名', trigger: 'blur' }]
      }
    }
  },
  computed: {
    transferData() {
      return (this.classStudents || []).map(s => ({
        key: s.studentId,
        label: (s.studentNo || '') + ' ' + s.studentName
      }))
    },
    selectedStudents() {
      const ids = this.form.studentIds || []
      return (this.classStudents || []).filter(s => ids.indexOf(s.studentId) !== -1)
    }
  },
  created() {
    optionselectSubject().then(r => { this.subjectOptions = r.data || [] })
    applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).then(() => {
      if (this.queryParams.deptId) this.getList()
    })
  },
  methods: {
    selectDept(deptId) {
      this.queryParams.deptId = deptId
      this.getList()
    },
    getList() {
      if (!this.queryParams.deptId) {
        this.groupList = []
        return
      }
      listStudyGroup(this.queryParams).then(res => {
        this.groupList = res.rows || []
      })
    },
    loadClassStudents() {
      if (!this.queryParams.deptId) return Promise.resolve()
      return listStudent({ deptId: this.queryParams.deptId, pageNum: 1, pageSize: 500, status: '0' }).then(res => {
        this.classStudents = res.rows || []
      })
    },
    handleAdd() {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      this.form = {
        deptId: this.queryParams.deptId,
        subjectId: this.queryParams.subjectId,
        groupName: undefined,
        studentIds: [],
        leaderStudentId: undefined
      }
      this.title = '新建小组'
      this.loadClassStudents().then(() => { this.open = true })
    },
    handleUpdate(row) {
      getStudyGroup(row.groupId).then(res => {
        const data = res.data || {}
        this.form = {
          groupId: data.groupId,
          deptId: data.deptId,
          subjectId: data.subjectId,
          groupName: data.groupName,
          leaderStudentId: data.leaderStudentId,
          studentIds: (data.members || []).map(m => m.studentId)
        }
        this.queryParams.deptId = data.deptId
        this.title = '编辑小组'
        this.loadClassStudents().then(() => { this.open = true })
      })
    },
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        const payload = { ...this.form }
        const n = (payload.studentIds || []).length
        const save = () => {
          const req = payload.groupId ? updateStudyGroup(payload) : addStudyGroup(payload)
          return req.then(() => {
            this.$modal.msgSuccess('保存成功')
            this.open = false
            this.getList()
          })
        }
        if (n < 4 || n > 6) {
          this.$modal.confirm('建议每组 4～6 人，当前 ' + n + ' 人，仍要保存？').then(save).catch(() => {})
        } else {
          save()
        }
      })
    },
    handleDelete(row) {
      this.$modal.confirm('确认解散小组「' + row.groupName + '」？历史打卡将保留。').then(() => {
        return delStudyGroup(row.groupId)
      }).then(() => {
        this.$modal.msgSuccess('已解散')
        this.getList()
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.card-head { display: flex; justify-content: space-between; align-items: center; }
</style>
