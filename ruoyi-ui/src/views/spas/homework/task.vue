<template>
  <div class="app-container assign-page">
    <el-alert
      class="mb8"
      type="info"
      :closable="false"
      show-icon
      title="请填写书名、页码、题号与「已完成」定义，作为组长翻本抽问与教师抽检的统一标准；默认主题可减轻一体机选题负担。"
    />

    <el-card shadow="never" class="assign-card">
      <div slot="header" class="card-head">
        <span>作业布置</span>
        <el-tag v-if="currentAssign && currentAssign.assignmentId" type="success" size="mini">已布置</el-tag>
        <el-tag v-else type="info" size="mini">未布置</el-tag>
      </div>

      <el-form :model="query" label-width="88px" size="small" class="assign-form">
        <el-form-item label="班级" required>
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
            style="width: 280px"
            @input="onFilterChange"
          />
        </el-form-item>
        <el-form-item label="学科" required>
          <el-select v-model="query.subjectId" placeholder="选择学科" style="width: 220px" @change="onSubjectChange">
            <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
          </el-select>
        </el-form-item>
        <el-form-item label="日期" required>
          <el-date-picker
            v-model="query.assignDate"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="布置日期"
            style="width: 220px"
            @change="loadCurrent"
          />
        </el-form-item>
        <el-form-item label="书名/教辅" required>
          <el-input v-model="form.bookName" maxlength="100" placeholder="如：《五三》物理必修一" style="width: 100%" />
        </el-form-item>
        <el-form-item label="页码">
          <el-input-number v-model="form.pageFrom" :min="1" controls-position="right" />
          <span class="sep">至</span>
          <el-input-number v-model="form.pageTo" :min="1" controls-position="right" />
        </el-form-item>
        <el-form-item label="题号" required>
          <el-input v-model="form.questionText" maxlength="120" placeholder="如：1,2,5 或 3-8" style="width: 100%" />
        </el-form-item>
        <el-form-item label="已完成定义" required>
          <el-input
            v-model="form.completeDefinition"
            type="textarea"
            :rows="2"
            maxlength="200"
            show-word-limit
            placeholder="组长翻本抽问时如何判定已完成，如：指定题有书写且能口述关键步骤"
          />
        </el-form-item>
        <el-form-item label="周达标次数">
          <el-input-number v-model="form.dueCountWeek" :min="1" :max="7" controls-position="right" />
          <span class="tip-inline">本周至少交几次检查单才可达标</span>
        </el-form-item>
        <el-form-item label="默认主题">
          <el-select
            v-model="form.knowledgeIdList"
            multiple
            filterable
            clearable
            collapse-tags
            placeholder="可选：一体机结账时预填给学生"
            style="width: 100%"
          >
            <el-option
              v-for="k in knowledgeOptions"
              :key="k.knowledgeId"
              :label="k.knowledgeName + (k.weak ? '（薄弱）' : '')"
              :value="k.knowledgeId"
            />
          </el-select>
          <div class="theme-actions">
            <el-button type="text" size="mini" :loading="weakLoading" @click="fillWeakTop" v-hasPermi="['spas:practice:edit']">填入班级薄弱 Top5</el-button>
            <el-button type="text" size="mini" @click="form.knowledgeIdList = []">清空主题</el-button>
          </div>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="saving" @click="saveAssign" v-hasPermi="['spas:practice:edit']">保存布置</el-button>
          <el-button :loading="saving" @click="copyLast" v-hasPermi="['spas:practice:edit']">复制上次</el-button>
        </el-form-item>
      </el-form>

      <p v-if="currentAssign && currentAssign.assignmentId" class="meta">
        已保存：{{ subjectLabel }} · {{ query.assignDate }}
        <span v-if="form.bookName"> · {{ form.bookName }}</span>
        <span v-if="form.questionText"> · 题 {{ form.questionText }}</span>
        <span v-if="themeLabel"> · 主题 {{ themeLabel }}</span>
        （{{ currentAssign.updateBy || currentAssign.createBy || '-' }}
        {{ parseTime(currentAssign.updateTime || currentAssign.createTime, '{y}-{m}-{d} {h}:{i}') }}）
      </p>
    </el-card>

    <el-card shadow="never" class="mt16">
      <div slot="header">近期布置</div>
      <el-table v-loading="historyLoading" :data="historyList" size="mini" empty-text="暂无历史布置">
        <el-table-column prop="assignDate" label="日期" width="110" />
        <el-table-column prop="subjectName" label="学科" width="80" />
        <el-table-column prop="bookName" label="书名" min-width="110" :show-overflow-tooltip="true" />
        <el-table-column label="页码" width="90">
          <template slot-scope="scope">{{ historyPage(scope.row) }}</template>
        </el-table-column>
        <el-table-column label="题号" width="100" :show-overflow-tooltip="true">
          <template slot-scope="scope">{{ scope.row.questionText || '-' }}</template>
        </el-table-column>
        <el-table-column label="完成定义" min-width="120" :show-overflow-tooltip="true">
          <template slot-scope="scope">{{ scope.row.completeDefinition || '-' }}</template>
        </el-table-column>
        <el-table-column label="默认主题" min-width="120" :show-overflow-tooltip="true">
          <template slot-scope="scope">{{ historyTheme(scope.row) }}</template>
        </el-table-column>
        <el-table-column label="状态" width="90">
          <template slot-scope="scope">
            <el-tag type="success" size="mini">已布置</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100">
          <template slot-scope="scope">
            <el-button type="text" size="mini" @click="jumpTo(scope.row)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { listPracticeAssignment, savePracticeAssignment, copyLastPracticeAssignment } from '@/api/spas/practice'
import { weakTopClass } from '@/api/spas/analysis'
import { treeKnowledge } from '@/api/spas/knowledge'
import { optionselectSubject } from '@/api/spas/subject'
import { deptTreeSelect } from '@/api/system/user'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { applyTeachingDeptContext } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'HomeworkTask',
  components: { Treeselect },
  data() {
    return {
      myDepts: [],
      deptOptions: [],
      queryParams: { deptId: undefined },
      subjectOptions: [],
      knowledgeOptions: [],
      saving: false,
      weakLoading: false,
      historyLoading: false,
      historyList: [],
      currentAssign: null,
      form: {
        knowledgeIdList: [],
        bookName: '',
        pageFrom: undefined,
        pageTo: undefined,
        questionText: '',
        completeDefinition: '指定题有书写，且能口述关键步骤或概念',
        dueCountWeek: 3
      },
      query: {
        deptId: undefined,
        subjectId: undefined,
        assignDate: parseTime(new Date(), '{y}-{m}-{d}')
      },
      pendingKnowledgeIds: []
    }
  },
  computed: {
    subjectLabel() {
      const s = this.subjectOptions.find(x => x.subjectId === this.query.subjectId)
      return s ? s.subjectName : ''
    },
    themeLabel() {
      const ids = this.form.knowledgeIdList || []
      if (!ids.length) return ''
      const names = ids.map(id => {
        const hit = this.knowledgeOptions.find(k => k.knowledgeId === id)
        return hit ? hit.knowledgeName : id
      })
      return names.join('、')
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.deptId) {
      const id = Number(q.deptId)
      this.query.deptId = id
      this.queryParams.deptId = id
    }
    if (q.subjectId) this.query.subjectId = Number(q.subjectId)
    if (q.assignDate) this.query.assignDate = String(q.assignDate)
    // From student prescription: ?knowledgeIds=1,2,3
    this.pendingKnowledgeIds = String(q.knowledgeIds || '')
      .split(',')
      .map(s => s.trim())
      .filter(Boolean)
      .map(s => Number(s) || s)
    optionselectSubject().then(r => { this.subjectOptions = r.data || [] })
    applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).then(() => {
      if (this.query.deptId) this.queryParams.deptId = this.query.deptId
      else if (this.queryParams.deptId) this.query.deptId = this.queryParams.deptId
      if (this.query.deptId) this.refreshAll()
      else if (this.query.subjectId && this.pendingKnowledgeIds.length) {
        this.loadKnowledgeOptions()
        this.$nextTick(() => this.applyPendingKnowledgeIds())
      }
    })
  },
  methods: {
    parseTime,
    selectDept(id) {
      this.query.deptId = id
      this.queryParams.deptId = id
      this.refreshAll()
    },
    onFilterChange() {
      this.queryParams.deptId = this.query.deptId
      this.refreshAll()
    },
    onSubjectChange() {
      this.loadKnowledgeOptions()
      this.loadCurrent()
      this.loadHistory()
    },
    refreshAll() {
      if (!this.query.deptId) return
      this.loadKnowledgeOptions()
      this.loadCurrent()
      this.loadHistory()
    },
    flattenTree(nodes, out) {
      (nodes || []).forEach(n => {
        if (n.nodeType !== 'chapter' && n.knowledgeId) {
          out.push({ knowledgeId: n.knowledgeId, knowledgeName: n.knowledgeName, weak: false })
        }
        if (n.children && n.children.length) this.flattenTree(n.children, out)
      })
    },
    loadKnowledgeOptions() {
      this.knowledgeOptions = []
      if (!this.query.subjectId) return
      treeKnowledge(this.query.subjectId).then(r => {
        const list = []
        this.flattenTree(r.data || [], list)
        this.knowledgeOptions = list.slice(0, 120)
      }).catch(() => { this.knowledgeOptions = [] })
    },
    applyPendingKnowledgeIds() {
      const ids = (this.pendingKnowledgeIds || []).filter(Boolean)
      if (!ids.length) return
      const numIds = ids.map(Number).filter(n => !isNaN(n))
      const merged = Array.from(new Set([...(this.form.knowledgeIdList || []), ...numIds]))
      this.form.knowledgeIdList = merged
      this.pendingKnowledgeIds = []
      if (numIds.length) {
        this.$modal.msgSuccess('已从学情处方带入 ' + numIds.length + ' 个主题')
      }
    },
    fillWeakTop() {
      if (!this.query.deptId || !this.query.subjectId) {
        this.$modal.msgWarning('请先选班级和学科')
        return
      }
      this.weakLoading = true
      weakTopClass(this.query.deptId, { subjectId: this.query.subjectId, limit: 5 }).then(r => {
        const rows = r.data || []
        const ids = rows.map(x => x.knowledgeId || x.id).filter(Boolean)
        if (!ids.length) {
          this.$modal.msgWarning('暂无班级薄弱主题可填入')
          return
        }
        const merged = Array.from(new Set([...(this.form.knowledgeIdList || []), ...ids]))
        this.form.knowledgeIdList = merged
        const extras = rows.map(x => ({
          knowledgeId: x.knowledgeId || x.id,
          knowledgeName: x.knowledgeName || x.name,
          weak: true
        })).filter(x => x.knowledgeId)
        const map = {}
        ;[...extras, ...this.knowledgeOptions].forEach(k => { map[k.knowledgeId] = k })
        this.knowledgeOptions = Object.keys(map).map(id => map[id])
        this.$modal.msgSuccess('已填入 ' + ids.length + ' 个薄弱主题')
      }).finally(() => { this.weakLoading = false })
    },
    resetFormFields() {
      this.form.knowledgeIdList = []
      this.form.bookName = ''
      this.form.pageFrom = undefined
      this.form.pageTo = undefined
      this.form.questionText = ''
      this.form.completeDefinition = '指定题有书写，且能口述关键步骤或概念'
      this.form.dueCountWeek = 3
    },
    applyAssignToForm(row) {
      if (!row) {
        this.resetFormFields()
        return
      }
      const kids = row.knowledgeIdList || []
      this.form.knowledgeIdList = kids.length
        ? kids.map(Number)
        : (row.knowledgeId ? [Number(row.knowledgeId)] : [])
      this.form.bookName = row.bookName || ''
      this.form.pageFrom = row.pageFrom != null ? Number(row.pageFrom) : undefined
      this.form.pageTo = row.pageTo != null ? Number(row.pageTo) : undefined
      this.form.questionText = row.questionText || ''
      this.form.completeDefinition = row.completeDefinition || '指定题有书写，且能口述关键步骤或概念'
      this.form.dueCountWeek = row.dueCountWeek != null ? Number(row.dueCountWeek) : 3
    },
    loadCurrent() {
      this.currentAssign = null
      if (!this.query.deptId || !this.query.subjectId || !this.query.assignDate) {
        this.applyPendingKnowledgeIds()
        return
      }
      listPracticeAssignment({
        deptId: this.query.deptId,
        subjectId: this.query.subjectId,
        assignDate: this.query.assignDate
      }).then(r => {
        this.currentAssign = (r.data || [])[0] || null
        this.applyAssignToForm(this.currentAssign)
        // Prescription deep-link: merge even if today already has an assign draft
        this.applyPendingKnowledgeIds()
      }).catch(() => {
        this.currentAssign = null
        this.resetFormFields()
        this.applyPendingKnowledgeIds()
      })
    },
    loadHistory() {
      if (!this.query.deptId) {
        this.historyList = []
        return
      }
      this.historyLoading = true
      const params = { deptId: this.query.deptId }
      if (this.query.subjectId) params.subjectId = this.query.subjectId
      listPracticeAssignment(params).then(r => {
        this.historyList = (r.data || []).slice(0, 14)
      }).catch(() => { this.historyList = [] }).finally(() => { this.historyLoading = false })
    },
    saveAssign() {
      if (!this.query.deptId || !this.query.subjectId || !this.query.assignDate) {
        this.$modal.msgWarning('请选择班级、学科和日期')
        return
      }
      const bookName = (this.form.bookName || '').trim()
      const questionText = (this.form.questionText || '').trim()
      const completeDefinition = (this.form.completeDefinition || '').trim()
      if (!bookName) {
        this.$modal.msgWarning('请填写书名/教辅')
        return
      }
      if (!questionText) {
        this.$modal.msgWarning('请填写题号范围')
        return
      }
      if (!completeDefinition) {
        this.$modal.msgWarning('请填写「已完成」定义')
        return
      }
      if (this.form.pageFrom && this.form.pageTo && this.form.pageTo < this.form.pageFrom) {
        this.$modal.msgWarning('结束页不能小于起始页')
        return
      }
      const kids = this.form.knowledgeIdList || []
      const doSave = () => {
        this.saving = true
        savePracticeAssignment({
          deptId: this.query.deptId,
          subjectId: this.query.subjectId,
          assignDate: this.query.assignDate,
          knowledgeIdList: kids,
          bookName,
          pageFrom: this.form.pageFrom || null,
          pageTo: this.form.pageTo || null,
          questionText,
          completeDefinition,
          dueCountWeek: this.form.dueCountWeek || 3
        }).then(() => {
          this.$modal.msgSuccess('布置已保存')
          this.loadCurrent()
          this.loadHistory()
        }).finally(() => { this.saving = false })
      }
      if (!kids.length) {
        this.$confirm(
          '未选默认知识主题时，组长在一体机上须为每位完成/部分/困难的组员逐一点选主题，登记更慢。是否先填入班级薄弱 Top5？',
          '建议补充主题',
          {
            confirmButtonText: '填入薄弱 Top5 并保存',
            cancelButtonText: '仍保存空主题',
            distinguishCancelAndClose: true,
            type: 'warning'
          }
        ).then(() => {
          this.weakLoading = true
          weakTopClass(this.query.deptId, { subjectId: this.query.subjectId, limit: 5 }).then(r => {
            const rows = r.data || []
            const ids = rows.map(x => x.knowledgeId || x.id).filter(Boolean)
            if (!ids.length) {
              this.$modal.msgWarning('暂无班级薄弱主题，将按空主题保存')
              doSave()
              return
            }
            this.form.knowledgeIdList = ids
            const extras = rows.map(x => ({
              knowledgeId: x.knowledgeId || x.id,
              knowledgeName: x.knowledgeName || x.name,
              weak: true
            })).filter(x => x.knowledgeId)
            const seen = {}
            this.knowledgeOptions.forEach(k => { seen[k.knowledgeId] = true })
            extras.forEach(k => {
              if (!seen[k.knowledgeId]) {
                seen[k.knowledgeId] = true
                this.knowledgeOptions.unshift(k)
              }
            })
            doSave()
          }).catch(() => {
            this.$modal.msgWarning('薄弱主题加载失败，将按空主题保存')
            doSave()
          }).finally(() => { this.weakLoading = false })
        }).catch(action => {
          if (action === 'cancel') doSave()
        })
        return
      }
      doSave()
    },
    copyLast() {
      if (!this.query.deptId || !this.query.subjectId) {
        this.$modal.msgWarning('请先选班级和学科')
        return
      }
      this.saving = true
      copyLastPracticeAssignment({
        deptId: this.query.deptId,
        subjectId: this.query.subjectId,
        assignDate: this.query.assignDate
      }).then(r => {
        if (r.needFill) {
          this.applyAssignToForm(r.data || {})
          this.$modal.msgWarning(r.msg || '已带入上次布置，请补全书名、题号与「已完成」定义后保存')
          return
        }
        this.$modal.msgSuccess('已复制上次布置到所选日期')
        this.loadCurrent()
        this.loadHistory()
      }).finally(() => { this.saving = false })
    },
    jumpTo(row) {
      if (!row) return
      this.query.assignDate = row.assignDate
      if (row.subjectId) this.query.subjectId = row.subjectId
      this.loadKnowledgeOptions()
      this.loadCurrent()
    },
    historyPage(row) {
      if (!row || !row.pageFrom) return '-'
      return 'p.' + row.pageFrom + (row.pageTo && row.pageTo !== row.pageFrom ? ('-' + row.pageTo) : '')
    },
    historyTheme(row) {
      if (!row) return '-'
      if (row.knowledgeName) return row.knowledgeName
      const n = (row.knowledgeIdList || []).length
      return n ? (n + ' 个主题') : '-'
    }
  }
}
</script>

<style scoped>
.card-head { display: flex; align-items: center; gap: 8px; }
.assign-form { max-width: 720px; }
.meta { margin: 0; color: #909399; font-size: 12px; }
.mt16 { margin-top: 16px; }
.assign-card { max-width: 800px; }
.theme-actions { margin-top: 4px; }
.sep { margin: 0 8px; color: #909399; }
.tip-inline { margin-left: 8px; color: #909399; font-size: 12px; }
</style>
