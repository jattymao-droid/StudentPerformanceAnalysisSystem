<template>
  <div class="app-container">
    <el-form :model="query" size="small" :inline="true" label-width="68px">
      <el-form-item label="班级">
        <el-button-group v-if="myDepts.length">
          <el-button
            v-for="d in myDepts"
            :key="d.deptId"
            size="mini"
            :type="query.deptId === d.deptId ? 'primary' : 'default'"
            @click="selectDept(d.deptId)"
          >{{ d.deptName }}</el-button>
        </el-button-group>
        <treeselect
          v-else
          v-model="query.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="选择班级"
          style="width: 240px"
          @input="loadBoard"
        />
      </el-form-item>
      <el-form-item label="范围">
        <el-radio-group v-model="query.range" size="mini" @change="loadBoard">
          <el-radio-button label="week">本周</el-radio-button>
          <el-radio-button label="all">累计</el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="loadBoard">刷新</el-button>
        <el-button
          type="warning"
          icon="el-icon-present"
          size="mini"
          :disabled="!query.deptId"
          v-hasPermi="['spas:practice:edit', 'spas:practice:list', 'spas:point:account:list', 'spas:point:award']"
          @click="openAward()"
        >一键发分</el-button>
        <el-button
          type="success"
          plain
          icon="el-icon-present"
          size="mini"
          :disabled="!selection.length"
          v-hasPermi="['spas:practice:edit', 'spas:practice:list', 'spas:point:account:list', 'spas:point:award']"
          @click="openAward(selection)"
        >给选中学生发分</el-button>
      </el-form-item>
    </el-form>

    <el-alert
      class="mb8"
      type="info"
      :closable="false"
      show-icon
      title="可勾选学生后「给选中学生发分」，或点「一键发分」按学生/科目小组选人。奖励计入日封顶 40；同批次不可重复发放。"
    />

    <el-table
      v-loading="loading"
      :data="boardList"
      size="small"
      border
      empty-text="请先选择班级，或暂无积分数据"
      @selection-change="onSelectionChange"
    >
      <el-table-column type="selection" width="45" align="center" />
      <el-table-column prop="rankNo" label="名次" width="70" />
      <el-table-column prop="studentNo" label="学号" width="120" />
      <el-table-column prop="studentName" label="姓名" width="120" />
      <el-table-column label="积分" width="100">
        <template slot-scope="scope">
          {{ query.range === 'week' ? (scope.row.weekPoints || 0) : (scope.row.totalPoints || 0) }}
        </template>
      </el-table-column>
      <el-table-column prop="totalPoints" label="累计积分" width="100" />
      <el-table-column prop="levelNo" label="等级" width="80" />
      <el-table-column label="植物" width="80">
        <template slot-scope="scope">{{ scope.row.farmStageLabel || '-' }}</template>
      </el-table-column>
      <el-table-column prop="dayStreak" label="连打天数" width="100" />
      <el-table-column prop="weekPoints" label="本周积分" width="100" />
    </el-table>

    <el-dialog title="一键发放积分" :visible.sync="awardOpen" width="580px" append-to-body @closed="resetAward">
      <el-form ref="awardForm" :model="awardForm" :rules="awardRules" label-width="88px" size="small">
        <el-form-item label="班级">
          <span>{{ currentDeptName }}</span>
        </el-form-item>
        <el-form-item label="选人方式">
          <el-radio-group v-model="awardPickMode" size="mini" @change="onAwardPickModeChange">
            <el-radio-button label="student">按学生</el-radio-button>
            <el-radio-button label="group">按科目小组</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <template v-if="awardPickMode === 'group'">
          <el-form-item label="科目">
            <el-select
              v-model="awardSubjectId"
              filterable
              placeholder="选择科目"
              style="width: 100%"
              @change="onAwardSubjectChange"
            >
              <el-option label="通用组（不分科）" value="" />
              <el-option
                v-for="s in subjectOptions"
                :key="s.subjectId"
                :label="s.subjectName"
                :value="s.subjectId"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="学习小组">
            <el-select
              v-model="awardGroupIds"
              multiple
              filterable
              collapse-tags
              placeholder="选择小组（可多选）"
              style="width: 100%"
              :loading="groupLoading"
              @change="onAwardGroupsChange"
            >
              <el-option
                v-for="g in awardGroupOptions"
                :key="g.groupId"
                :label="(g.groupName || ('组#' + g.groupId)) + ' · ' + (g.memberCount || 0) + '人'"
                :value="g.groupId"
              />
            </el-select>
            <div class="tip mt4">选中小组后自动填入成员；可多选合并发分</div>
          </el-form-item>
        </template>
        <el-form-item label="学生" prop="studentIds">
          <div class="award-toolbar mb8">
            <el-button v-if="awardPickMode === 'student'" type="text" size="mini" @click="selectAllRoster">全选本班</el-button>
            <el-button v-else type="text" size="mini" :loading="groupMemberLoading" @click="fillStudentsFromGroups">重新填入组成员</el-button>
            <el-button type="text" size="mini" @click="awardForm.studentIds = []">清空</el-button>
            <span class="tip">已选 {{ awardForm.studentIds.length }} 人（最多 80）</span>
          </div>
          <el-select
            v-model="awardForm.studentIds"
            multiple
            filterable
            collapse-tags
            placeholder="选择学生"
            style="width: 100%"
            :loading="rosterLoading || groupMemberLoading"
          >
            <el-option
              v-for="s in roster"
              :key="s.studentId"
              :label="(s.studentName || '-') + (s.studentNo ? ('（' + s.studentNo + '）') : '')"
              :value="s.studentId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="每人分数" prop="points">
          <el-input-number v-model="awardForm.points" :min="1" :max="20" :step="1" />
          <span class="tip ml8">1～20，计入当日封顶 40</span>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="awardForm.remark" maxlength="180" show-word-limit placeholder="如：课堂表现优秀 / 小组合作优秀" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button size="small" @click="awardOpen = false">取消</el-button>
        <el-button type="primary" size="small" :loading="awardSaving" @click="submitAward">确认发放</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { practicePointsLeaderboard, practicePointsFarm, practicePointsBatchAward } from '@/api/spas/practice'
import { listStudyGroup, getStudyGroup } from '@/api/spas/group'
import { optionselectSubject } from '@/api/spas/subject'
import { deptTreeSelect } from '@/api/system/user'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { applyTeachingDeptContext } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  name: 'SpasPointAccount',
  components: { Treeselect },
  data() {
    return {
      loading: false,
      myDepts: [],
      deptOptions: [],
      subjectOptions: [],
      boardList: [],
      selection: [],
      roster: [],
      rosterLoading: false,
      awardOpen: false,
      awardSaving: false,
      awardPickMode: 'student',
      awardSubjectId: '',
      awardGroupIds: [],
      awardGroupOptions: [],
      groupLoading: false,
      groupMemberLoading: false,
      awardForm: {
        studentIds: [],
        points: 5,
        remark: ''
      },
      awardRules: {
        studentIds: [{ type: 'array', required: true, min: 1, message: '请选择学生', trigger: 'change' }],
        points: [{ required: true, message: '请填写分数', trigger: 'blur' }]
      },
      queryParams: { deptId: undefined },
      query: {
        deptId: undefined,
        range: 'week',
        limit: 50
      }
    }
  },
  computed: {
    currentDeptName() {
      const d = (this.myDepts || []).find(x => Number(x.deptId) === Number(this.query.deptId))
      return d ? d.deptName : (this.query.deptId ? ('班级 #' + this.query.deptId) : '-')
    }
  },
  created() {
    optionselectSubject().then(r => { this.subjectOptions = r.data || [] }).catch(() => { this.subjectOptions = [] })
    applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).then(() => {
      if (this.queryParams.deptId) this.query.deptId = this.queryParams.deptId
      this.loadBoard()
    })
  },
  methods: {
    selectDept(id) {
      this.query.deptId = id
      this.queryParams.deptId = id
      this.selection = []
      this.loadBoard()
    },
    onSelectionChange(rows) {
      this.selection = rows || []
    },
    loadBoard() {
      if (!this.query.deptId) {
        this.boardList = []
        return
      }
      this.loading = true
      practicePointsLeaderboard({
        deptId: this.query.deptId,
        range: this.query.range,
        limit: this.query.limit
      }).then(res => {
        const data = res.data || {}
        this.boardList = data.list || []
      }).catch(() => {
        this.boardList = []
      }).finally(() => {
        this.loading = false
      })
    },
    loadRoster() {
      if (!this.query.deptId) {
        this.roster = []
        return Promise.resolve()
      }
      this.rosterLoading = true
      return practicePointsFarm({ deptId: this.query.deptId }).then(res => {
        const list = (res.data && res.data.list) || []
        this.roster = list.slice().sort((a, b) =>
          String(a.studentName || '').localeCompare(String(b.studentName || ''), 'zh'))
        if (!this.roster.length && this.boardList.length) {
          this.roster = this.boardList.slice()
        }
      }).catch(() => {
        this.roster = (this.boardList || []).slice()
      }).finally(() => {
        this.rosterLoading = false
      })
    },
    openAward(preselectRows) {
      if (!this.query.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      const ids = (preselectRows || []).map(r => r.studentId).filter(Boolean)
      this.awardPickMode = ids.length ? 'student' : 'student'
      this.awardSubjectId = ''
      this.awardGroupIds = []
      this.awardGroupOptions = []
      this.awardForm = {
        studentIds: ids.slice(0, 80),
        points: 5,
        remark: ''
      }
      this.awardOpen = true
      this.loadRoster().then(() => {
        if (!this.awardForm.studentIds.length && ids.length) {
          this.awardForm.studentIds = ids.slice(0, 80)
        }
      })
    },
    onAwardPickModeChange(mode) {
      this.awardGroupIds = []
      this.awardGroupOptions = []
      if (mode === 'group') {
        this.awardForm.studentIds = []
        this.loadAwardGroups()
      }
    },
    onAwardSubjectChange() {
      this.awardGroupIds = []
      this.awardForm.studentIds = []
      this.loadAwardGroups()
    },
    loadAwardGroups() {
      if (!this.query.deptId) {
        this.awardGroupOptions = []
        return Promise.resolve()
      }
      this.groupLoading = true
      const params = {
        deptId: this.query.deptId,
        status: '0',
        pageNum: 1,
        pageSize: 200
      }
      if (this.awardSubjectId !== '' && this.awardSubjectId != null) {
        params.subjectId = this.awardSubjectId
      } else {
        params['params[requireNullSubject]'] = true
      }
      return listStudyGroup(params).then(res => {
        this.awardGroupOptions = res.rows || []
      }).catch(() => {
        this.awardGroupOptions = []
      }).finally(() => {
        this.groupLoading = false
      })
    },
    onAwardGroupsChange() {
      this.fillStudentsFromGroups()
    },
    fillStudentsFromGroups() {
      const ids = (this.awardGroupIds || []).filter(Boolean)
      if (!ids.length) {
        this.awardForm.studentIds = []
        return Promise.resolve()
      }
      this.groupMemberLoading = true
      return Promise.all(ids.map(id => getStudyGroup(id).then(res => res.data || {}).catch(() => ({}))))
        .then(groups => {
          const seen = {}
          const studentIds = []
          const names = []
          const rosterMap = {}
          ;(this.roster || []).forEach(s => { rosterMap[s.studentId] = s })
          groups.forEach(g => {
            if (g.groupName) names.push(g.groupName)
            ;(g.members || []).forEach(m => {
              if (!m || !m.studentId || seen[m.studentId]) return
              seen[m.studentId] = true
              studentIds.push(m.studentId)
              if (!rosterMap[m.studentId]) {
                this.roster.push({
                  studentId: m.studentId,
                  studentNo: m.studentNo,
                  studentName: m.studentName
                })
              }
            })
          })
          this.awardForm.studentIds = studentIds.slice(0, 80)
          if (!this.awardForm.remark && names.length) {
            this.awardForm.remark = '科目小组：' + names.slice(0, 4).join('、') + (names.length > 4 ? '等' : '')
          }
          if (!studentIds.length) {
            this.$modal.msgWarning('所选小组暂无成员')
          } else if (studentIds.length > 80) {
            this.$modal.msgWarning('合并后超过 80 人，已截取前 80 人')
          }
        })
        .finally(() => { this.groupMemberLoading = false })
    },
    selectAllRoster() {
      this.awardForm.studentIds = (this.roster || []).map(s => s.studentId).filter(Boolean).slice(0, 80)
    },
    resetAward() {
      this.awardSaving = false
      this.awardPickMode = 'student'
      this.awardSubjectId = ''
      this.awardGroupIds = []
      this.awardGroupOptions = []
      this.groupLoading = false
      this.groupMemberLoading = false
      if (this.$refs.awardForm) this.$refs.awardForm.clearValidate()
    },
    submitAward() {
      this.$refs.awardForm.validate(valid => {
        if (!valid) return
        const ids = (this.awardForm.studentIds || []).slice(0, 80)
        if (!ids.length) {
          this.$modal.msgWarning('请选择学生')
          return
        }
        const pts = Number(this.awardForm.points) || 0
        const via = this.awardPickMode === 'group' ? '（按科目小组）' : ''
        this.$modal.confirm(
          '确认给 ' + ids.length + ' 名学生每人发放 +' + pts + ' 分' + via + '？计入日封顶，同批次不可重复。'
        ).then(() => {
          this.awardSaving = true
          return practicePointsBatchAward({
            deptId: this.query.deptId,
            studentIds: ids,
            points: pts,
            remark: this.awardForm.remark || undefined,
            batchId: 'web_' + Date.now()
          })
        }).then(res => {
          const data = (res && res.data) || {}
          const total = data.awardedTotal != null ? data.awardedTotal : (res.awardedTotal || 0)
          const ok = data.successCount != null ? data.successCount : 0
          const cap = data.cappedCount != null ? data.cappedCount : 0
          const skip = data.skippedCount != null ? data.skippedCount : 0
          this.$modal.msgSuccess(
            '发放完成：合计 +' + total + '（成功 ' + ok +
            (cap ? '，封顶/部分 ' + cap : '') +
            (skip ? '，跳过 ' + skip : '') + '）'
          )
          this.awardOpen = false
          this.loadBoard()
        }).catch(() => {}).finally(() => {
          this.awardSaving = false
        })
      })
    }
  }
}
</script>

<style scoped>
.award-toolbar { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.tip { color: #909399; font-size: 12px; }
.ml8 { margin-left: 8px; }
.mb8 { margin-bottom: 8px; }
.mt4 { margin-top: 4px; }
</style>
