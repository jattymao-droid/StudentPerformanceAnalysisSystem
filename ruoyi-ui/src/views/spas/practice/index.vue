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
        <treeselect v-else v-model="query.deptId" :options="deptOptions" :show-count="true" placeholder="选择班级" style="width: 220px" />
      </el-form-item>
      <el-form-item label="日期">
        <el-date-picker v-model="query.practiceDate" type="date" value-format="yyyy-MM-dd" placeholder="日期" style="width: 150px" @change="refresh" />
      </el-form-item>
      <el-form-item label="学科">
        <el-select v-model="query.subjectId" clearable placeholder="全部" style="width: 140px" @change="refresh">
          <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="refresh">刷新</el-button>
      </el-form-item>
    </el-form>

    <el-card class="mb8" shadow="never">
      <div slot="header" class="board-head">
        <span>今日布置（线下检查标准）</span>
        <el-button type="text" size="mini" v-hasPermi="['spas:practice:edit']" @click="goAssignPage">前往作业布置</el-button>
      </div>
      <el-empty v-if="!query.subjectId" description="请选择学科以查看布置" :image-size="48" />
      <el-empty v-else-if="!currentAssign || !currentAssign.assignmentId" description="当日尚未布置" :image-size="48">
        <el-button type="primary" size="mini" v-hasPermi="['spas:practice:edit']" @click="goAssignPage">去布置</el-button>
      </el-empty>
      <p v-else class="assign-summary">
        当日已布置（{{ query.practiceDate }}）
        <span v-if="currentAssign.subjectName"> · {{ currentAssign.subjectName }}</span>
        <span v-if="assignStandardText"> · {{ assignStandardText }}</span>
        <span v-if="assignThemeText"> · 主题 {{ assignThemeText }}</span>
      </p>
      <p v-if="currentAssign && currentAssign.completeDefinition" class="tip">已完成定义：{{ currentAssign.completeDefinition }}</p>
      <p class="tip">组长在座位翻本抽问，一体机只登记结果。新建/修改请用「作业布置」。</p>
    </el-card>

    <el-row :gutter="12" class="mb8 kpi-row">
      <el-col :span="6">
        <div class="kpi-card" @click="activeTab = 'checkout'">
          <div class="kpi-num warn">{{ (coAlerts.missingCheckout || []).length }}</div>
          <div class="kpi-label">未结账组</div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="kpi-card" @click="activeTab = 'spotq'" title="异议须先抽检，再在「组未结账」补确认">
          <div class="kpi-num danger">{{ (coAlerts.disputes || []).length }}</div>
          <div class="kpi-label">异议</div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="kpi-card" @click="activeTab = 'checkout'">
          <div class="kpi-num warn">{{ (coAlerts.timeouts || []).length }}</div>
          <div class="kpi-label">超时未确认</div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="kpi-card" @click="activeTab = 'hard'">
          <div class="kpi-num">{{ unfollowedHardCount }}</div>
          <div class="kpi-label">困难未跟进</div>
        </div>
      </el-col>
    </el-row>

    <el-tabs v-model="activeTab">
      <el-tab-pane label="抽检队列" name="spotq">
        <p class="tip">按风险排序：异议/超时优先抽。请对照「抽检标准」书页题提问。异议须先抽检再补确认；点一致 / 偏松 / 偏严即可。</p>
        <el-table :data="spotQueue" size="mini" empty-text="今日暂无待抽或尚未有检查单">
          <el-table-column prop="groupName" label="组" width="80" />
          <el-table-column prop="studentName" label="学生" width="80" />
          <el-table-column label="线下结果" width="80">
            <template slot-scope="scope">{{ finishLabel(scope.row.finishStatus) }}</template>
          </el-table-column>
          <el-table-column label="确认" width="72">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.memberAck === '2'" type="danger" size="mini">异议</el-tag>
              <el-tag v-else-if="scope.row.memberAck === '3'" type="warning" size="mini">超时</el-tag>
              <span v-else-if="scope.row.memberAck === '1'">已确认</span>
              <span v-else class="tip">待确认</span>
            </template>
          </el-table-column>
          <el-table-column label="抽检标准" min-width="180" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ spotAssignText(scope.row) }}</template>
          </el-table-column>
          <el-table-column prop="knowledgeNames" label="主题" min-width="110" :show-overflow-tooltip="true" />
          <el-table-column label="卡点" min-width="100" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.difficultyNote || '-' }}</template>
          </el-table-column>
          <el-table-column prop="weight" label="权重" width="56" />
          <el-table-column label="操作" width="200" v-hasPermi="['spas:practice:spot']">
            <template slot-scope="scope">
              <el-button type="text" size="mini" @click="doSpot(scope.row, '1')">一致</el-button>
              <el-button type="text" size="mini" style="color:#E6A23C" @click="doSpot(scope.row, '2')">偏松</el-button>
              <el-button type="text" size="mini" @click="doSpot(scope.row, '3')">偏严</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="组未结账" name="checkout">
        <el-button type="text" size="mini" @click="copyMissingGroups">复制未交组</el-button>
        <el-table :data="coAlerts.missingCheckout || []" size="mini">
          <el-table-column prop="groupName" label="组" />
          <el-table-column prop="leaderStudentName" label="组长" width="100" />
          <el-table-column prop="memberCount" label="人数" width="70" />
        </el-table>
        <el-divider content-position="left">待确认 / 异议 / 超时</el-divider>
        <p class="tip mb8">
          待确认 {{ (coAlerts.pendingAck || []).length }} ·
          异议 {{ (coAlerts.disputes || []).length }} ·
          超时未确认 {{ (coAlerts.timeouts || []).length }}
        </p>
        <el-row :gutter="12">
          <el-col :span="8">
            <h4>待确认</h4>
            <el-table :data="coAlerts.pendingAck || []" size="mini" max-height="260" empty-text="无">
              <el-table-column prop="groupName" label="组" width="70" />
              <el-table-column prop="studentName" label="学生" width="70" />
              <el-table-column label="结果" width="70">
                <template slot-scope="scope">{{ finishLabel(scope.row.finishStatus) }}</template>
              </el-table-column>
            </el-table>
          </el-col>
          <el-col :span="8">
            <h4>异议 <el-button type="text" size="mini" @click="copyAckList(coAlerts.disputes, '异议')">复制</el-button></h4>
            <p class="tip">异议须先到「抽检队列」判定，再补确认或作废</p>
            <el-table :data="coAlerts.disputes || []" size="mini" max-height="280" empty-text="无">
              <el-table-column prop="groupName" label="组" width="60" />
              <el-table-column prop="studentName" label="学生" width="60" />
              <el-table-column label="结果" width="60">
                <template slot-scope="scope">{{ finishLabel(scope.row.finishStatus) }}</template>
              </el-table-column>
              <el-table-column label="处置" width="120" v-hasPermi="['spas:practice:edit', 'spas:practice:spot']">
                <template slot-scope="scope">
                  <el-button type="text" size="mini" @click="resolveItem(scope.row, 'ack')">补确认</el-button>
                  <el-button type="text" size="mini" style="color:#E6A23C" @click="resolveItem(scope.row, 'dismiss')">已阅</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-col>
          <el-col :span="8">
            <h4>超时未确认 <el-button type="text" size="mini" @click="copyAckList(coAlerts.timeouts, '超时')">复制</el-button></h4>
            <el-table :data="coAlerts.timeouts || []" size="mini" max-height="280" empty-text="无">
              <el-table-column prop="groupName" label="组" width="55" />
              <el-table-column prop="studentName" label="学生" width="55" />
              <el-table-column label="结果" width="55">
                <template slot-scope="scope">{{ finishLabel(scope.row.finishStatus) }}</template>
              </el-table-column>
              <el-table-column label="处置" min-width="150" v-hasPermi="['spas:practice:edit', 'spas:practice:spot']">
                <template slot-scope="scope">
                  <el-button type="text" size="mini" @click="resolveItem(scope.row, 'ack')">补确认</el-button>
                  <el-button type="text" size="mini" style="color:#F56C6C" @click="resolveItem(scope.row, 'void')">作废</el-button>
                  <el-button type="text" size="mini" style="color:#E6A23C" @click="resolveItem(scope.row, 'dismiss')">已阅</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-col>
        </el-row>
        <el-divider content-position="left">组周达标</el-divider>
        <el-table :data="coAlerts.groupWeek || []" size="mini">
          <el-table-column prop="groupName" label="组" />
          <el-table-column label="本周交单" width="100">
            <template slot-scope="scope">{{ scope.row.submittedCount }}/{{ scope.row.dueCount }}</template>
          </el-table-column>
          <el-table-column prop="looseCount" label="偏松" width="70" />
          <el-table-column label="达标" width="90">
            <template slot-scope="scope">
              <el-tag :type="scope.row.qualified ? 'success' : 'info'" size="mini">{{ scope.row.qualified ? '达标' : '未达标' }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="reason" label="说明" :show-overflow-tooltip="true" />
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="困难摘要" name="hard">
        <el-table :data="coAlerts.difficultySummary || []" size="mini" class="mb8">
          <el-table-column prop="knowledgeName" label="主题" />
          <el-table-column prop="studentCount" label="人数" width="80" />
        </el-table>
        <el-table :data="coAlerts.difficultyItems || []" size="mini">
          <el-table-column prop="studentName" label="姓名" width="90" />
          <el-table-column prop="groupName" label="组" width="90" />
          <el-table-column prop="difficultyNote" label="卡点" :show-overflow-tooltip="true" />
          <el-table-column label="操作" width="160">
            <template slot-scope="scope">
              <el-button v-if="scope.row.followStatus !== '1'" type="text" size="mini" @click="followHard(scope.row)" v-hasPermi="['spas:practice:edit', 'spas:practice:spot']">已知晓</el-button>
              <el-button v-if="scope.row.followStatus !== '1'" type="text" size="mini" @click="hardToIntervene(scope.row)" v-hasPermi="['spas:intervene:add']">转干预</el-button>
              <span v-else class="tip">已跟进</span>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="积分榜" name="points">
        <div class="mb8 row-between">
          <el-radio-group v-model="boardRange" size="mini" @change="loadBoard">
            <el-radio-button label="week">本周</el-radio-button>
            <el-radio-button label="all">累计</el-radio-button>
          </el-radio-group>
          <div>
            <el-button
              type="warning"
              size="mini"
              icon="el-icon-present"
              plain
              :disabled="!boardSelection.length"
              v-hasPermi="['spas:practice:edit', 'spas:practice:list', 'spas:point:account:list', 'spas:point:award']"
              @click="openBoardAward"
            >给选中发分（{{ boardSelection.length }}）</el-button>
          </div>
        </div>
        <el-table :data="boardList" size="mini" empty-text="暂无积分数据" @selection-change="rows => boardSelection = rows || []">
          <el-table-column type="selection" width="42" align="center" />
          <el-table-column prop="rankNo" label="名次" width="70" />
          <el-table-column prop="studentNo" label="学号" width="100" />
          <el-table-column prop="studentName" label="姓名" width="100" />
          <el-table-column label="积分" width="100">
            <template slot-scope="scope">{{ boardRange === 'week' ? (scope.row.weekPoints || 0) : (scope.row.totalPoints || 0) }}</template>
          </el-table-column>
          <el-table-column prop="levelNo" label="等级" width="80" />
          <el-table-column prop="dayStreak" label="连打天数" width="90" />
        </el-table>
      </el-tab-pane>
    </el-tabs>

    <el-dialog title="给选中学生发分" :visible.sync="boardAwardOpen" width="420px" append-to-body>
      <el-form label-width="88px" size="small">
        <el-form-item label="已选学生">
          <span>{{ boardSelection.length }} 人</span>
        </el-form-item>
        <el-form-item label="每人分数">
          <el-input-number v-model="boardAwardPoints" :min="1" :max="20" />
          <span class="tip ml8">计入日封顶 40</span>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="boardAwardRemark" maxlength="180" show-word-limit placeholder="如：抽检表现好" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button size="small" @click="boardAwardOpen = false">取消</el-button>
        <el-button type="primary" size="small" :loading="boardAwardSaving" @click="submitBoardAward">确认发放</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { practicePointsLeaderboard, practicePointsBatchAward, listPracticeAssignment, practiceCheckoutAlerts, practiceSpotQueue, recordCheckoutSpot, followCheckoutItem, checkoutToIntervene, resolveCheckoutItem } from '@/api/spas/practice'
import { optionselectSubject } from '@/api/spas/subject'
import { deptTreeSelect } from '@/api/system/user'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { applyTeachingDeptContext } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  name: 'PracticeBoard',
  components: { Treeselect },
  data() {
    return {
      myDepts: [],
      deptOptions: [],
      subjectOptions: [],
      activeTab: 'spotq',
      coAlerts: {},
      spotQueue: [],
      currentAssign: null,
      boardList: [],
      boardRange: 'week',
      boardSelection: [],
      boardAwardOpen: false,
      boardAwardSaving: false,
      boardAwardPoints: 5,
      boardAwardRemark: '',
      queryParams: { deptId: undefined },
      query: {
        deptId: undefined,
        subjectId: undefined,
        practiceDate: this.parseTime(new Date(), '{y}-{m}-{d}')
      }
    }
  },
  watch: {
    activeTab(v) {
      if (v === 'points') this.loadBoard()
    },
    'query.subjectId'() {
      this.loadAssign()
    }
  },
  computed: {
    unfollowedHardCount() {
      return (this.coAlerts.difficultyItems || []).filter(x => x.followStatus !== '1').length
    },
    assignThemeText() {
      const a = this.currentAssign
      if (!a) return ''
      if (a.knowledgeName) return a.knowledgeName
      const n = (a.knowledgeIdList || []).length
      return n ? (n + ' 个') : ''
    },
    assignStandardText() {
      return this.spotAssignText(this.currentAssign)
    }
  },
  created() {
    optionselectSubject().then(r => { this.subjectOptions = r.data || [] })
    applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).then(() => {
      if (this.queryParams && this.queryParams.deptId) this.query.deptId = this.queryParams.deptId
      this.refresh()
    })
  },
  methods: {
    goAssignPage() {
      this.$router.push({
        path: '/spas/biz/hw-task',
        query: {
          deptId: this.query.deptId || undefined,
          subjectId: this.query.subjectId || undefined,
          assignDate: this.query.practiceDate || undefined
        }
      })
    },
    spotAssignText(row) {
      if (!row) return '-'
      const page = row.pageFrom
        ? ('p.' + row.pageFrom + (row.pageTo && row.pageTo !== row.pageFrom ? ('-' + row.pageTo) : ''))
        : ''
      const parts = [row.bookName, page, row.questionText ? ('题 ' + row.questionText) : ''].filter(Boolean)
      return parts.length ? parts.join(' · ') : '-'
    },
    selectDept(id) {
      this.query.deptId = id
      this.queryParams.deptId = id
      this.refresh()
    },
    refresh() {
      if (!this.query.deptId) return
      this.loadCheckoutAlerts()
      this.loadSpotQueue()
      this.loadAssign()
      if (this.activeTab === 'points') this.loadBoard()
    },
    loadAssign() {
      if (!this.query.deptId || !this.query.subjectId) {
        this.currentAssign = null
        return
      }
      listPracticeAssignment({
        deptId: this.query.deptId,
        subjectId: this.query.subjectId,
        assignDate: this.query.practiceDate
      }).then(r => {
        this.currentAssign = (r.data || [])[0] || null
      }).catch(() => { this.currentAssign = null })
    },
    loadCheckoutAlerts() {
      practiceCheckoutAlerts(this.query).then(r => { this.coAlerts = r.data || {} }).catch(() => { this.coAlerts = {} })
    },
    loadSpotQueue() {
      practiceSpotQueue(this.query).then(r => { this.spotQueue = r.data || [] }).catch(() => { this.spotQueue = [] })
    },
    doSpot(row, result) {
      recordCheckoutSpot(row.itemId, { spotResult: result }).then(() => {
        if (result === '2') {
          this.$modal.msgSuccess('已记偏松，该次作废')
        } else if (row && row.memberAck === '2') {
          this.$modal.msgSuccess('已抽检，请到「组未结账」补确认或作废')
          this.activeTab = 'checkout'
        } else {
          this.$modal.msgSuccess('已记录')
        }
        this.loadSpotQueue()
        this.loadCheckoutAlerts()
      })
    },
    followHard(row) {
      followCheckoutItem(row.itemId).then(() => {
        this.$modal.msgSuccess('已标记跟进')
        this.loadCheckoutAlerts()
      })
    },
    hardToIntervene(row) {
      checkoutToIntervene(row.itemId).then(() => {
        this.$modal.msgSuccess('已转干预并标记跟进')
        this.loadCheckoutAlerts()
      })
    },
    copyMissingGroups() {
      const lines = (this.coAlerts.missingCheckout || []).map(g => (g.groupName || '') + ' ' + (g.leaderStudentName || ''))
      const text = lines.join('\n')
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(() => this.$modal.msgSuccess('已复制 ' + lines.length + ' 组'))
      }
    },
    copyAckList(rows, label) {
      const lines = (rows || []).map(r => (r.groupName || '') + ' ' + (r.studentNo || '') + ' ' + (r.studentName || ''))
      const text = lines.join('\n')
      if (!lines.length) {
        this.$modal.msgWarning('暂无' + (label || '') + '名单')
        return
      }
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(() => this.$modal.msgSuccess('已复制 ' + lines.length + ' 人'))
      } else {
        this.$modal.msgWarning(text)
      }
    },
    resolveItem(row, action) {
      if (!row || !row.itemId) return
      const tip = {
        ack: '补确认并写入练习流水？（异议须已抽检，否则会失败）',
        void: '作废该记录？',
        dismiss: '标记已阅（不计流水）？'
      }[action]
      this.$modal.confirm(tip || '确认处置？').then(() => {
        return resolveCheckoutItem(row.itemId, action)
      }).then(r => {
        const pts = r && r.awardedPoints
        this.$modal.msgSuccess(action === 'ack'
          ? ('已补确认' + (pts ? ('，积分 +' + pts) : ''))
          : (action === 'void' ? '已作废' : '已标记已阅'))
        this.loadCheckoutAlerts()
        this.loadSpotQueue()
      }).catch(() => {})
    },
    loadBoard() {
      if (!this.query.deptId) return
      this.boardSelection = []
      practicePointsLeaderboard({
        deptId: this.query.deptId,
        subjectId: this.query.subjectId,
        range: this.boardRange,
        limit: 30
      }).then(r => {
        const d = r.data || {}
        this.boardList = d.list || []
      }).catch(() => { this.boardList = [] })
    },
    openBoardAward() {
      if (!this.boardSelection.length) {
        this.$modal.msgWarning('请先勾选学生')
        return
      }
      this.boardAwardPoints = 5
      this.boardAwardRemark = ''
      this.boardAwardOpen = true
    },
    submitBoardAward() {
      const ids = this.boardSelection.map(r => r.studentId).filter(Boolean)
      if (!ids.length || !this.query.deptId) return
      const pts = Number(this.boardAwardPoints) || 0
      this.$modal.confirm('确认给 ' + ids.length + ' 人每人 +' + pts + ' 分？').then(() => {
        this.boardAwardSaving = true
        return practicePointsBatchAward({
          deptId: this.query.deptId,
          subjectId: this.query.subjectId || undefined,
          studentIds: ids,
          points: pts,
          remark: this.boardAwardRemark || undefined,
          batchId: 'board_' + Date.now()
        })
      }).then(res => {
        const data = (res && res.data) || {}
        const total = data.awardedTotal != null ? data.awardedTotal : (res.awardedTotal || 0)
        this.$modal.msgSuccess('发放完成，合计 +' + total)
        this.boardAwardOpen = false
        this.loadBoard()
      }).catch(() => {}).finally(() => {
        this.boardAwardSaving = false
      })
    },
    finishLabel(v) {
      return { '1': '已完成', '2': '部分', '3': '有困难', '0': '未做', 'L': '请假', 'A': '未到/没带本' }[v] || v
    }
  }
}
</script>

<style scoped>
.row-between { display: flex; align-items: center; justify-content: space-between; gap: 8px; flex-wrap: wrap; }
.ml8 { margin-left: 8px; }
.tip { color: #e6a23c; font-size: 12px; }
.board-head { display: flex; justify-content: space-between; align-items: center; }
.assign-summary { margin: 0 0 4px; font-size: 13px; color: #303133; font-weight: 600; }
.kpi-row { margin-bottom: 12px; }
.kpi-card {
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 6px;
  padding: 12px 14px;
  cursor: pointer;
  text-align: center;
}
.kpi-card:hover { border-color: #c0c4cc; }
.kpi-num { font-size: 22px; font-weight: 700; color: #303133; line-height: 1.2; }
.kpi-num.warn { color: #e6a23c; }
.kpi-num.danger { color: #f56c6c; }
.kpi-label { margin-top: 4px; font-size: 12px; color: #909399; }
</style>
