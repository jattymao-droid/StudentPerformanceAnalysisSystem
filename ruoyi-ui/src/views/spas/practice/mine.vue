<template>
  <div class="app-container">
    <el-alert class="mb8" type="info" :closable="false" show-icon :title="welcome" />
    <div class="mb8 toolbar-row">
      <el-button size="mini" @click="openPinDialog">{{ pinSet ? '修改一体机 PIN' : '设置一体机 PIN' }}</el-button>
      <el-tag v-if="pinSet" type="success" size="mini">已设置 PIN</el-tag>
      <el-tag v-else type="info" size="mini">未设置 PIN</el-tag>
    </div>

    <el-row :gutter="12" class="mb8 points-row">
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
        </el-card>
      </el-col>
      <el-col :xs="24" :md="14" v-if="false">
        <el-card shadow="never" class="points-card">
          <div slot="header" class="board-head">
            <span>本班积分榜 · {{ boardRange === 'week' ? '本周' : '累计' }}</span>
            <el-radio-group v-model="boardRange" size="mini" @change="loadBoard">
              <el-radio-button label="week">周榜</el-radio-button>
              <el-radio-button label="all">总榜</el-radio-button>
            </el-radio-group>
          </div>
          <el-table :data="boardList" size="mini" max-height="180" empty-text="暂无上榜">
            <el-table-column prop="rankNo" label="#" width="50" />
            <el-table-column prop="studentName" label="姓名" />
            <el-table-column label="积分" width="90">
              <template slot-scope="scope">{{ boardRange === 'week' ? (scope.row.weekPoints || 0) : (scope.row.totalPoints || 0) }}</template>
            </el-table-column>
            <el-table-column prop="levelNo" label="等级" width="70" />
          </el-table>
          <div class="sub mt4">我的名次：{{ myBoardRank ? ('第 ' + myBoardRank + ' 名') : '暂未上榜' }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-card v-if="ledgerList.length" shadow="never" class="mb8">
      <div slot="header">最近积分流水</div>
      <el-table :data="ledgerList" size="mini" max-height="200">
        <el-table-column prop="createTime" label="时间" width="160" />
        <el-table-column prop="reasonLabel" label="原因" width="100" />
        <el-table-column label="分值" width="70">
          <template slot-scope="scope">+{{ scope.row.points }}</template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" :show-overflow-tooltip="true" />
      </el-table>
    </el-card>

    <el-card v-if="checkoutBundle.assignment || (checkoutBundle.pendingAck || []).length" shadow="never" class="mb8">
      <div slot="header">组长线下检查（当日确认登记）</div>
      <p v-if="checkoutBundle.assignment" class="hint">
        今日任务：{{ checkoutBundle.assignment.bookName }}
        p.{{ checkoutBundle.assignment.pageFrom }}-{{ checkoutBundle.assignment.pageTo }}
        / {{ checkoutBundle.assignment.questionText }}
      </p>
      <el-table v-if="(checkoutBundle.pendingAck || []).length" :data="checkoutBundle.pendingAck" size="mini">
        <el-table-column prop="studentName" label="检查对象" width="90" />
        <el-table-column label="状态" width="90">
          <template slot-scope="scope">{{ finishLabel(scope.row.finishStatus) }}</template>
        </el-table-column>
        <el-table-column prop="difficultyNote" label="卡点" />
        <el-table-column label="操作" width="160">
          <template slot-scope="scope">
            <el-button type="text" size="mini" @click="ackCheck(scope.row, true)">属实</el-button>
            <el-button type="text" size="mini" style="color:#F56C6C" @click="ackCheck(scope.row, false)">异议</el-button>
          </template>
        </el-table-column>
      </el-table>
      <p v-else-if="checkoutBundle.myItem" class="hint">今日检查状态：已记录，{{ checkoutBundle.myItem.memberAck === '1' ? '已确认属实' : (checkoutBundle.myItem.memberAck === '2' ? '已提异议' : '待确认') }}</p>
      <p v-else class="hint">等待组长在座位检查后上机登记。加练请用下方表单（不计入组达标）。</p>
    </el-card>

    <el-form :model="form" size="small" label-width="90px" style="max-width: 720px">
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
      <el-table-column label="代提" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.proxyFlag === '1'" class="proxy">代提·{{ confirmLabel(scope.row.confirmStatus) }}</span>
          <span v-else>本人</span>
        </template>
      </el-table-column>
    </el-table>

    <div v-if="groupProgress.length" class="mt16">
      <el-divider content-position="left">本组进度</el-divider>
      <el-tag v-for="m in groupProgress" :key="m.studentId" :type="m.submitted ? 'success' : 'info'" class="mr8">
        {{ m.studentName }} {{ m.submitted ? '已交' : '未交' }}
      </el-tag>
    </div>

    <el-dialog title="帮组员登记" :visible.sync="proxyOpen" width="480px">
      <el-alert type="warning" :closable="false" show-icon class="mb8" title="代提后需组员次日确认；驳回将作废该记录。" />
      <el-select v-model="proxyStudentId" placeholder="选择组员" style="width: 100%">
        <el-option v-for="m in groupProgress" :key="m.studentId" :label="m.studentName" :value="m.studentId" />
      </el-select>
      <div slot="footer">
        <el-button type="primary" @click="submitProxy">代提</el-button>
        <el-button @click="proxyOpen = false">取消</el-button>
      </div>
    </el-dialog>

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
import { minePracticeToday, suggestPracticeWeak, suggestPracticeBooks, addPractice, practicePinStatus, setPracticePin, practicePointsMine, practicePointsLedger, checkoutToday, ackCheckoutItem } from '@/api/spas/practice'
import { optionselectSubject } from '@/api/spas/subject'
import { treeKnowledge } from '@/api/spas/knowledge'
import { parseTime } from '@/utils/ruoyi'

export default {
  name: 'MyPractice',
  data() {
    return {
      subjectOptions: [],
      knowledgeOptions: [],
      todayLogs: [],
      groupProgress: [],
      pendingConfirm: [],
      leader: false,
      submitting: false,
      proxyOpen: false,
      proxyStudentId: undefined,
      studentName: '',
      pinSet: false,
      pinOpen: false,
      pinSaving: false,
      pinForm: { pin: '', pin2: '', oldPin: '' },
      pointAccount: {},
      ledgerList: [],
      boardList: [],
      boardRange: 'week',
      myBoardRank: null,
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
      return name + '，针对薄弱知识点自主找题训练，提交书名、页码和题号。有困难请写清卡点。'
    },
    levelPct() {
      const a = this.pointAccount || {}
      const total = Number(a.totalPoints || 0)
      const min = Number(a.levelMinPoints || 0)
      const max = Number(a.levelMaxPoints || 50)
      const span = Math.max(1, max - min)
      return Math.max(0, Math.min(100, Math.round(((total - min) / span) * 100)))
    }
  },
  created() {
    optionselectSubject().then(r => { this.subjectOptions = r.data || [] })
    this.loadToday()
    this.loadPinStatus()
    this.loadPoints()
  },
  methods: {
    parseTime,
    loadPoints() {
      practicePointsMine().then(r => {
        const d = r.data || {}
        this.pointAccount = d.account || {}
      }).catch(() => { this.pointAccount = {} })
      practicePointsLedger({ limit: 20 }).then(r => {
        this.ledgerList = r.data || []
      }).catch(() => { this.ledgerList = [] })
    },
    loadBoard() {
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
    canConfirm(row) {
      if (!row || !row.practiceDate) return false
      const d = this.parseTime(row.practiceDate, '{y}-{m}-{d}')
      const today = this.parseTime(new Date(), '{y}-{m}-{d}')
      return d && today && d < today
    },
    confirmLabel(v) {
      return ({ '0': '本人', '1': '待确认', '2': '已确认', '3': '已驳回' })[v] || ''
    },
    doConfirm(row, accept) {
      const tip = accept ? '确认该代提记录属实？' : '驳回后记录将作废，确定？'
      this.$modal.confirm(tip).then(() => confirmProxyPractice(row.logId, accept)).then((res) => {
        const awarded = res && res.awardedPoints
        this.$modal.msgSuccess(accept ? (awarded ? ('已确认，积分 +' + awarded) : '已确认') : '已驳回')
        this.loadToday()
        this.loadPoints()
      }).catch(() => {})
    },
    loadToday() {
      minePracticeToday({ subjectId: this.form.subjectId }).then(r => {
        const d = r.data || {}
        this.todayLogs = d.logs || []
        this.groupProgress = d.groupProgress || []
        this.pendingConfirm = d.pendingConfirm || []
        this.leader = !!d.leader
        this.studentName = (d.student && d.student.studentName) || ''
      })
      checkoutToday({ subjectId: this.form.subjectId }).then(r => {
        this.checkoutBundle = r.data || {}
      }).catch(() => { this.checkoutBundle = {} })
    },
    finishLabel(v) {
      return { '1': '已完成', '2': '部分', '3': '有困难', '0': '未做', 'L': '请假', 'A': '未到/没带本' }[v] || v
    },
    ackCheck(row, accept) {
      ackCheckoutItem(row.itemId, accept).then(r => {
        const pts = r && r.awardedPoints
        this.$modal.msgSuccess(accept ? ('已确认属实' + (pts ? ('，积分 +' + pts) : '')) : '已提出异议')
        this.loadToday()
      })
    },
    onSubjectChange() {
      this.form.knowledgeIds = []
      this.knowledgeOptions = []
      this.loadToday()
      if (!this.form.subjectId) return
      const weakReq = suggestPracticeWeak({ subjectId: this.form.subjectId, limit: 8 })
      const treeReq = treeKnowledge(this.form.subjectId)
      Promise.all([weakReq, treeReq]).then(([weakRes, treeRes]) => {
        const weak = (weakRes.data || []).map(k => ({
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
      })
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
</style>
