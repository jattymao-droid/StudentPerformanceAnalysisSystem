<template>
  <div class="app-container">
    <el-alert class="mb8" type="info" :closable="false" show-icon :title="welcome" />
    <div class="mb8 toolbar-row">
      <el-button size="mini" @click="openPinDialog">{{ pinSet ? '修改一体机 PIN' : '设置一体机 PIN' }}</el-button>
      <el-tag v-if="pinSet" type="success" size="mini">已设置 PIN</el-tag>
      <el-tag v-else type="info" size="mini">未设置 PIN</el-tag>
    </div>

    <el-card v-if="form.subjectId" shadow="never" class="mb8 prescription-mine" v-loading="prescriptionLoading">
      <div slot="header" class="board-head">
        <span>{{ minePrescription.title }}</span>
        <el-button
          v-if="minePrescription.status === 'ready' && minePrescription.knowledgeIds.length"
          type="primary"
          plain
          size="mini"
          @click="applyPrescriptionToForm"
        >填入加练主题</el-button>
      </div>
      <p class="hint">{{ minePrescription.subtitle }}</p>
      <p v-if="minePrescription.passRule" class="hint pass-rule">{{ minePrescription.passRule }}</p>
      <el-alert
        class="mb8"
        type="warning"
        :closable="false"
        show-icon
        title="自主练为行为登记，不等于掌握度过关；过关以小题复测后正式薄弱退出为准。"
      />
      <el-table v-if="minePrescription.items.length" :data="minePrescription.items" size="mini" max-height="220">
        <el-table-column label="#" width="44" align="center">
          <template slot-scope="scope">{{ scope.$index + 1 }}</template>
        </el-table-column>
        <el-table-column label="本周优先" min-width="150" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.suggestFirst" size="mini" type="success" effect="plain" style="margin-right:4px">建议先练</el-tag>
            {{ scope.row.knowledgeName }}
          </template>
        </el-table-column>
        <el-table-column label="先修提示" min-width="140" :show-overflow-tooltip="true">
          <template slot-scope="scope">{{ scope.row.prereq || '—' }}</template>
        </el-table-column>
        <el-table-column label="得分率" width="80" align="center" prop="rateLabel" />
      </el-table>
      <p v-else class="hint">{{ minePrescription.status === 'none' ? '当前无正式薄弱，可自选主题加练。' : '选择学科后加载本周要点。' }}</p>
    </el-card>

    <el-card
      v-if="checkoutBundle.assignment || (checkoutBundle.pendingAck || []).length"
      shadow="never"
      class="mb8"
      :class="{ 'ack-priority': (checkoutBundle.pendingAck || []).length }"
    >
      <div slot="header">
        <span>组长线下检查（当日确认）</span>
        <el-tag v-if="(checkoutBundle.pendingAck || []).length" type="warning" size="mini" style="margin-left:8px">
          {{ (checkoutBundle.pendingAck || []).length }} 条待确认
        </el-tag>
      </div>
      <el-alert
        v-if="(checkoutBundle.pendingAck || []).length"
        title="请先确认检查结果（属实可获积分）；加练与积分区已暂时收起"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-table v-if="(checkoutBundle.pendingAck || []).length" :data="checkoutBundle.pendingAck" size="mini">
        <el-table-column prop="studentName" label="检查对象" width="90" />
        <el-table-column label="状态" width="90">
          <template slot-scope="scope">{{ finishLabel(scope.row.finishStatus) }}</template>
        </el-table-column>
        <el-table-column label="知识主题" min-width="140" :show-overflow-tooltip="true">
          <template slot-scope="scope">{{ (scope.row.knowledgeNames || []).join('、') || '-' }}</template>
        </el-table-column>
        <el-table-column prop="difficultyNote" label="卡点" />
        <el-table-column label="操作" width="200">
          <template slot-scope="scope">
            <el-button type="primary" size="mini" @click="ackCheck(scope.row, true)">属实</el-button>
            <el-button type="danger" plain size="mini" @click="ackCheck(scope.row, false)">异议</el-button>
          </template>
        </el-table-column>
      </el-table>
      <p v-else-if="checkoutBundle.myItem" class="hint">
        今日检查状态：已记录，{{ ackLabel(checkoutBundle.myItem.memberAck) }}
        <span v-if="(checkoutBundle.myKnowledgeNames || []).length"> · 主题 {{ (checkoutBundle.myKnowledgeNames || []).join('、') }}</span>
      </p>
      <p v-else-if="checkoutBundle.assignment" class="hint">
        今日已布置（{{ checkoutBundle.assignment.subjectName || '本学科' }}）
        <span v-if="assignHintText"> · {{ assignHintText }}</span>
        ，等待组长座位检查后上机登记。
      </p>
      <p v-if="checkoutBundle.assignment && checkoutBundle.assignment.completeDefinition" class="hint">
        已完成定义：{{ checkoutBundle.assignment.completeDefinition }}
      </p>
      <p v-else class="hint">等待组长在座位检查后上机登记。加练请用下方表单（不计入组达标）。</p>
    </el-card>

    <el-row v-show="!(checkoutBundle.pendingAck || []).length" :gutter="12" class="mb8 points-row">
      <el-col :xs="24" :md="10">
        <el-card shadow="never" class="points-card">
          <div class="points-head">
            <span class="lv">Lv.{{ pointAccount.levelNo || 1 }}</span>
            <div>
              <div class="pts">{{ pointAccount.totalPoints || 0 }} 积分</div>
              <div class="sub">今日 +{{ pointAccount.todayPoints || 0 }} · 连打 {{ pointAccount.dayStreak || 0 }} 天</div>
            </div>
          </div>
          <el-progress
            :percentage="levelPct"
            :stroke-width="10"
            :show-text="false"
            color="#7c5cfc"
          />
          <div class="sub mt4">距下一级还需 {{ pointAccount.pointsToNext != null ? pointAccount.pointsToNext : '-' }}</div>
          <div class="sub mt4">
            植物阶段：{{ pointAccount.farmStageLabel || '萌芽' }}
            <template v-if="pointAccount.farmStage !== 'tree' && pointAccount.pointsToNextFarmStage != null">
              · 距下阶段 {{ pointAccount.pointsToNextFarmStage }}
            </template>
          </div>
          <div v-if="farmThresholdHint" class="sub">{{ farmThresholdHint }}</div>
          <div class="sub mt4">本周班榜：{{ weekRank ? ('第 ' + weekRank + ' 名') : '暂未上榜' }}</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="14">
        <el-card shadow="never" class="points-card">
          <div slot="header" class="board-head">
            <span>本班积分榜 · {{ boardRange === 'week' ? '本周' : '累计' }}</span>
            <el-radio-group v-model="boardRange" size="mini" @change="loadBoard">
              <el-radio-button label="week">周榜</el-radio-button>
              <el-radio-button label="all">总榜</el-radio-button>
            </el-radio-group>
          </div>
          <el-table :data="boardList" size="mini" max-height="180" empty-text="暂无上榜" :row-class-name="boardRowClass">
            <el-table-column prop="rankNo" label="#" width="50" />
            <el-table-column label="姓名">
              <template slot-scope="scope">
                {{ scope.row.studentName }}{{ isBoardMe(scope.row) ? '（我）' : '' }}
              </template>
            </el-table-column>
            <el-table-column label="积分" width="90">
              <template slot-scope="scope">{{ boardRange === 'week' ? (scope.row.weekPoints || 0) : (scope.row.totalPoints || 0) }}</template>
            </el-table-column>
            <el-table-column prop="levelNo" label="等级" width="70" />
          </el-table>
          <div class="sub mt4">我的名次：{{ myBoardRank ? ('第 ' + myBoardRank + ' 名') : '暂未上榜' }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-card v-show="!(checkoutBundle.pendingAck || []).length && ledgerList.length" shadow="never" class="mb8">
      <div slot="header">最近积分流水</div>
      <el-table :data="ledgerList" size="mini" max-height="200">
        <el-table-column prop="createTime" label="时间" width="160" />
        <el-table-column prop="reasonLabel" label="原因" width="100" />
        <el-table-column label="分值" width="70">
          <template slot-scope="scope">
            <span :class="{ 'pts-pos': scope.row.points > 0, 'pts-neg': scope.row.points < 0 }">
              {{ scope.row.points > 0 ? '+' : '' }}{{ scope.row.points }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" :show-overflow-tooltip="true" />
      </el-table>
    </el-card>

    <el-form v-show="!(checkoutBundle.pendingAck || []).length" :model="form" size="small" label-width="90px" style="max-width: 720px">
      <el-form-item label="学科" required>
        <el-select v-model="form.subjectId" placeholder="选择学科" style="width: 100%" @change="onSubjectChange">
          <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
        </el-select>
      </el-form-item>
      <el-form-item label="知识主题" required>
        <el-select v-model="form.knowledgeIds" multiple filterable placeholder="优先选薄弱主题，也可自选" style="width: 100%">
          <el-option v-for="k in knowledgeOptions" :key="k.knowledgeId" :label="k.knowledgeName + (k.weak ? '（薄弱）' : '')" :value="k.knowledgeId" />
        </el-select>
      </el-form-item>
      <el-form-item label="书本名称" required>
        <el-autocomplete v-model="form.bookName" :fetch-suggestions="queryBooks" placeholder="如：《五三》物理必修一" style="width: 100%" />
      </el-form-item>
      <el-form-item label="页码">
        <el-input-number v-model="form.pageFrom" :min="1" controls-position="right" />
        <span class="sep">至</span>
        <el-input-number v-model="form.pageTo" :min="1" controls-position="right" />
      </el-form-item>
      <el-form-item label="题号" required>
        <el-input v-model="form.questionText" placeholder="如：1,2,5 或 练习 B 第 4 题" />
      </el-form-item>
      <el-form-item label="完成情况" required>
        <el-radio-group v-model="form.finishStatus">
          <el-radio label="1">已完成</el-radio>
          <el-radio label="2">部分完成</el-radio>
          <el-radio label="3">有困难</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item v-if="form.finishStatus === '3'" label="卡点说明" required>
        <el-input v-model="form.difficultyNote" type="textarea" :rows="2" placeholder="写清卡在第几题、什么不会" />
      </el-form-item>
      <el-form-item label="轻反馈">
        <el-input v-model="form.hardestQuestion" placeholder="可选：最卡的一题" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" :loading="submitting" @click="submitSelf">加练（不计入达标）</el-button>
      </el-form-item>
    </el-form>

    <el-divider content-position="left">今日记录</el-divider>
    <el-table :data="todayLogs" size="small">
      <el-table-column prop="bookName" label="书名" />
      <el-table-column prop="questionText" label="题号" />
      <el-table-column prop="knowledgeNames" label="主题" />
      <el-table-column label="状态" width="90">
        <template slot-scope="scope">{{ { '1': '已完成', '2': '部分', '3': '有困难' }[scope.row.finishStatus] }}</template>
      </el-table-column>
      <el-table-column label="来源" width="110">
        <template slot-scope="scope">
          <span v-if="scope.row.proxyFlag === '1'" class="proxy">历史代提·{{ confirmLabel(scope.row.confirmStatus) }}</span>
          <span v-else-if="scope.row.sourceType === 'checkout' || scope.row.fromCheckout === true">检查单</span>
          <span v-else>本人加练</span>
        </template>
      </el-table-column>
    </el-table>

    <div v-if="groupProgress.length" class="mt16">
      <el-divider content-position="left">本组检查进度</el-divider>
      <el-tag v-for="m in groupProgress" :key="m.studentId" :type="progressTagType(m)" class="mr8">
        {{ m.studentName }} {{ progressLabel(m) }}
      </el-tag>
    </div>

    <el-dialog :title="pinSet ? '修改一体机 PIN' : '设置一体机 PIN'" :visible.sync="pinOpen" width="420px">
      <el-form size="small" label-width="90px">
        <el-form-item v-if="pinSet" label="原 PIN">
          <el-input v-model="pinForm.oldPin" maxlength="6" show-password placeholder="4～6 位数字" />
        </el-form-item>
        <el-form-item label="新 PIN" required>
          <el-input v-model="pinForm.pin" maxlength="6" show-password placeholder="4～6 位数字" />
        </el-form-item>
        <el-form-item label="确认 PIN" required>
          <el-input v-model="pinForm.pin2" maxlength="6" show-password placeholder="再输一次" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" :loading="pinSaving" @click="savePin">保存</el-button>
        <el-button @click="pinOpen = false">取消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { minePracticeToday, suggestPracticeWeak, suggestPracticeBooks, addPractice, practicePinStatus, setPracticePin, practicePointsMine, practicePointsLedger, practicePointsLeaderboard, checkoutToday, ackCheckoutItem } from '@/api/spas/practice'
import { optionselectSubject } from '@/api/spas/subject'
import { treeKnowledge } from '@/api/spas/knowledge'
import { buildStudentPrescription } from '@/utils/spasAnalysisScope'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'MyPractice',
  data() {
    return {
      subjectOptions: [],
      knowledgeOptions: [],
      prescriptionLoading: false,
      prescriptionRows: [],
      todayLogs: [],
      groupProgress: [],
      leader: false,
      submitting: false,
      studentName: '',
      pinSet: false,
      pinOpen: false,
      pinSaving: false,
      pinForm: { pin: '', pin2: '', oldPin: '' },
      pointAccount: {},
      farmThresholds: {},
      ledgerList: [],
      boardList: [],
      boardRange: 'week',
      myBoardRank: null,
      myStudentId: null,
      weekRank: null,
      checkoutBundle: {},
      form: {
        subjectId: undefined,
        knowledgeIds: [],
        bookName: '',
        pageFrom: undefined,
        pageTo: undefined,
        questionText: '',
        finishStatus: '1',
        difficultyNote: '',
        hardestQuestion: ''
      }
    }
  },
  computed: {
    welcome() {
      const name = this.studentName || '同学'
      return name + '，主路径是组长座位检查后上机登记；本页可确认检查结果，或提交加练（不加组达标）。'
    },
    assignHintText() {
      const a = this.checkoutBundle && this.checkoutBundle.assignment
      if (!a) return ''
      const page = a.pageFrom
        ? ('p.' + a.pageFrom + (a.pageTo && a.pageTo !== a.pageFrom ? ('-' + a.pageTo) : ''))
        : ''
      return [a.bookName, page, a.questionText ? ('题 ' + a.questionText) : ''].filter(Boolean).join(' · ')
    },
    levelPct() {
      const a = this.pointAccount || {}
      const total = Number(a.totalPoints || 0)
      const min = Number(a.levelMinPoints || 0)
      const max = Number(a.levelMaxPoints || 50)
      const span = Math.max(1, max - min)
      return Math.max(0, Math.min(100, Math.round(((total - min) / span) * 100)))
    },
    farmThresholdHint() {
      const t = this.farmThresholds || {}
      const a = Number(t.seedling)
      const b = Number(t.sapling)
      const c = Number(t.tree)
      if (!(a > 0 && b > a && c > b)) return ''
      return '植物阶段按累计积分 ' + a + ' / ' + b + ' / ' + c + '（与 Lv 独立）'
    },
    minePrescription() {
      if (!this.form.subjectId) {
        return buildStudentPrescription({ empty: true })
      }
      return buildStudentPrescription({
        weakRows: this.prescriptionRows,
        limit: 5,
        minAttempts: 3,
        targetRate: 0.6
      })
    }
  },
  created() {
    optionselectSubject().then(r => { this.subjectOptions = r.data || [] })
    this.loadToday()
    this.loadPinStatus()
    this.loadPoints()
    this.loadBoard()
  },
  methods: {
    parseTime,
    loadPoints() {
      practicePointsMine().then(r => {
        const d = r.data || {}
        this.pointAccount = d.account || {}
        this.farmThresholds = d.farmThresholds || {}
        this.weekRank = d.weekRank != null ? d.weekRank : null
        if (d.studentId != null) this.myStudentId = d.studentId
      }).catch(() => { this.pointAccount = {}; this.farmThresholds = {}; this.weekRank = null })
      practicePointsLedger({ limit: 20 }).then(r => {
        this.ledgerList = r.data || []
      }).catch(() => { this.ledgerList = [] })
    },
    loadBoard() {
      practicePointsLeaderboard({ range: this.boardRange, limit: 10 }).then(res => {
        const data = res.data || {}
        this.boardList = data.list || []
        this.myBoardRank = data.myRank != null ? data.myRank : null
        if (data.myStudentId != null) this.myStudentId = data.myStudentId
        if (this.boardRange === 'week') this.weekRank = this.myBoardRank
      }).catch(() => {
        this.boardList = []
        this.myBoardRank = null
      })
    },
    isBoardMe(row) {
      return this.myStudentId != null && row && Number(row.studentId) === Number(this.myStudentId)
    },
    boardRowClass({ row }) {
      return this.isBoardMe(row) ? 'board-me' : ''
    },
    loadPinStatus() {
      practicePinStatus().then(r => {
        this.pinSet = !!(r.data && r.data.pinSet)
      }).catch(() => {})
    },
    openPinDialog() {
      this.pinForm = { pin: '', pin2: '', oldPin: '' }
      this.pinOpen = true
    },
    savePin() {
      if (!/^\d{4,6}$/.test(this.pinForm.pin || '')) {
        this.$modal.msgError('PIN 须为 4～6 位数字')
        return
      }
      if (this.pinForm.pin !== this.pinForm.pin2) {
        this.$modal.msgError('两次输入的 PIN 不一致')
        return
      }
      this.pinSaving = true
      setPracticePin({ pin: this.pinForm.pin, oldPin: this.pinForm.oldPin || undefined }).then(() => {
        this.$modal.msgSuccess('PIN 已保存')
        this.pinOpen = false
        this.pinSaving = false
        this.loadPinStatus()
      }).catch(() => { this.pinSaving = false })
    },
    confirmLabel(v) {
      return ({ '0': '本人', '1': '待确认', '2': '已确认', '3': '已驳回' })[v] || ''
    },
    loadToday() {
      const subjectId = this.form.subjectId
      Promise.all([
        minePracticeToday({ subjectId }),
        checkoutToday({ subjectId }).catch(() => ({ data: {} }))
      ]).then(([mineRes, coRes]) => {
        const d = (mineRes && mineRes.data) || {}
        this.todayLogs = d.logs || []
        this.leader = !!d.leader
        this.studentName = (d.student && d.student.studentName) || ''
        this.checkoutBundle = (coRes && coRes.data) || {}
        const members = this.checkoutBundle.members || []
        if (members.length) {
          this.groupProgress = members.map(m => ({
            studentId: m.studentId,
            studentName: m.studentName,
            roleInGroup: m.roleInGroup,
            finishStatus: m.finishStatus,
            memberAck: m.memberAck,
            submitted: !!(m.finishStatus && m.finishStatus !== '0')
          }))
        } else {
          this.groupProgress = d.groupProgress || []
        }
      }).catch(() => {
        this.checkoutBundle = {}
      })
    },
    finishLabel(v) {
      return { '1': '已完成', '2': '部分', '3': '有困难', '0': '未做', 'L': '请假', 'A': '未到/没带本' }[v] || v
    },
    ackLabel(v) {
      return { '1': '已确认属实', '2': '已提异议', '3': '超时未确认', '0': '待确认' }[v] || '待确认'
    },
    progressLabel(m) {
      if (!m) return '未登记'
      if (m.memberAck === '2') return '有异议'
      if (m.memberAck === '3') return '超时未确认'
      if (m.memberAck === '0' && m.finishStatus && !['0', 'L', 'A'].includes(m.finishStatus)) return '待确认'
      if (m.finishStatus === '1') return m.memberAck === '1' ? '已确认' : '已完成'
      if (m.finishStatus === '2') return m.memberAck === '1' ? '已确认·部分' : '部分'
      if (m.finishStatus === '3') return m.memberAck === '1' ? '已确认·困难' : '有困难'
      if (m.finishStatus === '0') return '未做'
      if (m.finishStatus === 'L') return '请假'
      if (m.finishStatus === 'A') return '未到'
      if (m.submitted) return '已登记'
      return '未登记'
    },
    progressTagType(m) {
      if (!m) return 'info'
      if (m.memberAck === '2' || m.finishStatus === '3') return 'danger'
      if (m.memberAck === '3') return 'warning'
      if (m.memberAck === '0' && m.finishStatus && !['0', 'L', 'A'].includes(m.finishStatus)) return 'warning'
      if (m.finishStatus === '0' || m.finishStatus === 'L' || m.finishStatus === 'A') return 'info'
      if (m.finishStatus === '1' || m.finishStatus === '2') return 'success'
      if (m.submitted) return 'success'
      return 'info'
    },
    ackCheck(row, accept) {
      const run = () => {
        ackCheckoutItem(row.itemId, accept).then(r => {
          const pts = r && r.awardedPoints
          this.$modal.msgSuccess(accept ? ('已确认属实' + (pts ? ('，积分 +' + pts) : '')) : '已提出异议，等待老师抽检')
          this.loadToday()
          this.loadPoints()
          this.loadBoard()
        })
      }
      if (!accept) {
        this.$confirm('提出异议后将进入教师抽检，确认继续？', '提出异议', { type: 'warning' })
          .then(run)
          .catch(() => {})
        return
      }
      run()
    },
    onSubjectChange() {
      this.form.knowledgeIds = []
      this.knowledgeOptions = []
      this.prescriptionRows = []
      this.loadToday()
      if (!this.form.subjectId) return
      this.prescriptionLoading = true
      const weakReq = suggestPracticeWeak({ subjectId: this.form.subjectId, limit: 8 })
      const treeReq = treeKnowledge(this.form.subjectId)
      Promise.all([weakReq, treeReq]).then(([weakRes, treeRes]) => {
        const raw = weakRes.data || []
        this.prescriptionRows = raw
        const weak = raw.map(k => ({
          knowledgeId: k.knowledgeId,
          knowledgeName: k.knowledgeName,
          weak: true
        }))
        const extra = []
        this.flattenTree(treeRes.data || [], extra)
        const seen = {}
        const merged = []
        weak.concat(extra).forEach(k => {
          if (!k.knowledgeId || seen[k.knowledgeId]) return
          seen[k.knowledgeId] = true
          merged.push(k)
        })
        this.knowledgeOptions = merged.slice(0, 80)
      }).finally(() => { this.prescriptionLoading = false })
    },
    applyPrescriptionToForm() {
      const ids = (this.minePrescription.knowledgeIds || []).slice()
      if (!ids.length) {
        this.$modal.msgWarning('暂无正式薄弱主题可填入')
        return
      }
      this.form.knowledgeIds = ids
      this.$modal.msgSuccess('已填入本周优先 ' + ids.length + ' 个主题（自主练≠掌握度过关）')
    },
    flattenTree(nodes, out) {
      (nodes || []).forEach(n => {
        if (n.nodeType !== 'chapter' && n.knowledgeId) {
          out.push({ knowledgeId: n.knowledgeId, knowledgeName: n.knowledgeName, weak: false })
        }
        if (n.children && n.children.length) this.flattenTree(n.children, out)
      })
    },
    queryBooks(q, cb) {
      if (!this.form.subjectId) {
        cb([])
        return
      }
      suggestPracticeBooks({ subjectId: this.form.subjectId, q }).then(r => {
        cb((r.data || []).map(i => ({ value: i.bookName })))
      }).catch(() => cb([]))
    },
    buildPayload() {
      if (!this.form.subjectId || !this.form.bookName || !this.form.questionText || !(this.form.knowledgeIds || []).length) {
        this.$modal.msgError('请完整填写学科、主题、书名和题号')
        return null
      }
      if (this.form.finishStatus === '3' && !this.form.difficultyNote) {
        this.$modal.msgError('有困难时请填写卡点说明')
        return null
      }
      return { ...this.form, clientType: 'web' }
    },
    submitSelf() {
      const payload = this.buildPayload()
      if (!payload) return
      this.submitting = true
      addPractice(payload).then((res) => {
        const awarded = res && res.awardedPoints
        this.$modal.msgSuccess(awarded ? ('提交成功，积分 +' + awarded) : '提交成功')
        this.submitting = false
        this.loadToday()
        this.loadPoints()
        this.loadBoard()
      }).catch(() => { this.submitting = false })
    }
  }
}
</script>

<style scoped>
.sep { margin: 0 8px; }
.mr8 { margin-right: 8px; margin-bottom: 8px; }
.mt16 { margin-top: 16px; }
.mt4 { margin-top: 4px; }
.toolbar-row { display: flex; align-items: center; gap: 8px; }
.pending-card { max-width: 900px; }
.hint { color: #909399; font-size: 12px; }
.pass-rule { color: #334155; background: #EEF2FF; padding: 6px 10px; border-radius: 8px; }
.prescription-mine { border: 1px solid #E0E7FF; }
.proxy { color: #E6A23C; }
.points-row { max-width: 960px; }
.points-card { margin-bottom: 8px; }
.points-head { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
.points-head .lv {
  min-width: 56px; height: 40px; border-radius: 10px;
  background: linear-gradient(145deg, #7c5cfc, #5b3df0); color: #fff;
  display: flex; align-items: center; justify-content: center; font-weight: 800;
}
.points-head .pts { font-size: 18px; font-weight: 800; }
.sub { color: #909399; font-size: 12px; }
.board-head { display: flex; justify-content: space-between; align-items: center; gap: 8px; }
.pts-pos { color: #67c23a; font-weight: 600; }
.pts-neg { color: #f56c6c; font-weight: 600; }
.ack-priority {
  border: 1px solid #f5dab1 !important;
  background: #fffaf2;
  box-shadow: 0 2px 10px rgba(230, 162, 60, 0.12);
}
.ack-priority ::v-deep .el-card__header {
  font-weight: 700;
  color: #b88230;
}
</style>
<style>
.board-me > td { background: #f3efff !important; font-weight: 600; }
</style>
