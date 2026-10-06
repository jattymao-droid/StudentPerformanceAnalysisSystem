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
        <el-date-picker v-model="query.practiceDate" type="date" value-format="yyyy-MM-dd" placeholder="日期" style="width: 150px" />
      </el-form-item>
      <el-form-item label="学科">
        <el-select v-model="query.subjectId" clearable placeholder="全部" style="width: 140px">
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
        <span>
          <el-button size="mini" @click="copyLast" v-hasPermi="['spas:practice:edit']">复制上次</el-button>
          <el-button type="primary" size="mini" @click="saveAssign" v-hasPermi="['spas:practice:edit']">保存布置</el-button>
        </span>
      </div>
      <el-form :model="assignForm" size="mini" :inline="true">
        <el-form-item label="书名">
          <el-input v-model="assignForm.bookName" placeholder="本班统一书名" style="width: 200px" />
        </el-form-item>
        <el-form-item label="页码">
          <el-input-number v-model="assignForm.pageFrom" :min="0" controls-position="right" style="width: 110px" />
          -
          <el-input-number v-model="assignForm.pageTo" :min="0" controls-position="right" style="width: 110px" />
        </el-form-item>
        <el-form-item label="题号">
          <el-input v-model="assignForm.questionText" placeholder="如 1,2,5" style="width: 160px" />
        </el-form-item>
        <el-form-item label="主题">
          <el-select v-model="assignForm.knowledgeId" filterable clearable placeholder="知识点" style="width: 180px">
            <el-option v-for="k in knowledgeOptions" :key="k.knowledgeId" :label="k.knowledgeName" :value="k.knowledgeId" />
          </el-select>
        </el-form-item>
        <el-form-item label="本周应查">
          <el-input-number v-model="assignForm.dueCountWeek" :min="1" :max="7" style="width: 100px" />
        </el-form-item>
        <el-form-item label="已完成定义">
          <el-input v-model="assignForm.completeDefinition" style="width: 360px" />
        </el-form-item>
      </el-form>
      <p class="tip">组长在座位翻本抽问，一体机只登记结果，不要在机器前做检查。未选学科则无法布置。</p>
    </el-card>

    <el-tabs v-model="activeTab">
      <el-tab-pane label="抽检队列" name="spotq">
        <p class="tip">按风险排序：异议必抽；全员已完成、从未抽到、曾偏松的检查员提高权重。点一致 / 偏松 / 偏严即可。</p>
        <el-table :data="spotQueue" size="mini" empty-text="今日暂无待抽或尚未有检查单">
          <el-table-column prop="groupName" label="组" width="90" />
          <el-table-column prop="studentName" label="学生" width="90" />
          <el-table-column label="线下结果" width="90">
            <template slot-scope="scope">{{ finishLabel(scope.row.finishStatus) }}</template>
          </el-table-column>
          <el-table-column label="书/页/题" min-width="180" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.bookName }} {{ scope.row.pageFrom }}-{{ scope.row.pageTo }} / {{ scope.row.questionText }}</template>
          </el-table-column>
          <el-table-column prop="weight" label="权重" width="60" />
          <el-table-column label="操作" width="220" v-hasPermi="['spas:practice:spot']">
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
        <p class="tip" v-if="(coAlerts.pendingAck || []).length">待确认 {{ coAlerts.pendingAck.length }} 人；异议 {{ (coAlerts.disputes || []).length }} 人</p>
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
              <el-button v-if="scope.row.followStatus !== '1'" type="text" size="mini" @click="followHard(scope.row)">已知晓</el-button>
              <el-button v-if="scope.row.followStatus !== '1'" type="text" size="mini" @click="hardToIntervene(scope.row)" v-hasPermi="['spas:intervene:add']">转干预</el-button>
              <span v-else class="tip">已跟进</span>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="旧看板" name="alerts">
        <el-row :gutter="12">
          <el-col :span="8">
            <h4>未交 <el-button type="text" size="mini" @click="copyMissing">复制名单</el-button></h4>
            <el-table :data="alerts.missing || []" size="mini" height="280">
              <el-table-column prop="studentNo" label="学号" width="90" />
              <el-table-column prop="studentName" label="姓名" />
              <el-table-column prop="groupName" label="组" width="80" />
            </el-table>
            <p class="tip" v-if="(alerts.continuousMissing || []).length">连续 2 天未交 {{ alerts.continuousMissing.length }} 人</p>
          </el-col>
          <el-col :span="8">
            <h4>有困难</h4>
            <el-table :data="alerts.difficulty || []" size="mini" height="280">
              <el-table-column prop="studentName" label="姓名" width="80" />
              <el-table-column prop="difficultyNote" label="卡点" :show-overflow-tooltip="true" />
              <el-table-column label="操作" width="70">
                <template slot-scope="scope">
                  <el-button type="text" size="mini" @click="toIntervene(scope.row)" v-hasPermi="['spas:intervene:add']">转干预</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-col>
          <el-col :span="8">
            <h4>代提过多</h4>
            <el-table :data="alerts.proxyHeavy || []" size="mini" height="280">
              <el-table-column prop="studentNo" label="学号" width="90" />
              <el-table-column prop="studentName" label="姓名" />
              <el-table-column prop="proxyDays" label="天数" width="70" />
            </el-table>
          </el-col>
        </el-row>
        <el-divider content-position="left">练了仍弱（近 7 天练过但掌握度仍 &lt; 60%）</el-divider>
        <el-table :data="alerts.stillWeak || []" size="mini" max-height="240">
          <el-table-column prop="studentNo" label="学号" width="90" />
          <el-table-column prop="studentName" label="姓名" width="90" />
          <el-table-column prop="stillWeakCount" label="仍弱主题数" width="100" />
          <el-table-column prop="knowledgeNames" label="主题" :show-overflow-tooltip="true" />
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="明细" name="list">
        <el-table v-loading="loading" :data="logList" size="mini">
          <el-table-column prop="studentNo" label="学号" width="90" />
          <el-table-column prop="studentName" label="姓名" width="80" />
          <el-table-column prop="groupName" label="组" width="90" />
          <el-table-column prop="subjectName" label="学科" width="80" />
          <el-table-column prop="bookName" label="书名" min-width="140" :show-overflow-tooltip="true" />
          <el-table-column label="页码" width="80">
            <template slot-scope="scope">{{ scope.row.pageFrom || '-' }}-{{ scope.row.pageTo || '-' }}</template>
          </el-table-column>
          <el-table-column prop="questionText" label="题号" min-width="100" :show-overflow-tooltip="true" />
          <el-table-column prop="knowledgeNames" label="主题" min-width="120" :show-overflow-tooltip="true" />
          <el-table-column label="状态" width="90">
            <template slot-scope="scope">{{ finishLabel(scope.row.finishStatus) }}</template>
          </el-table-column>
          <el-table-column label="代提" width="60">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.proxyFlag === '1'" type="danger" size="mini">代</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="抽查" width="140">
            <template slot-scope="scope">
              <el-button type="text" size="mini" @click="spot(scope.row, '1')" v-hasPermi="['spas:practice:spot']">通过</el-button>
              <el-button type="text" size="mini" @click="spot(scope.row, '2')" v-hasPermi="['spas:practice:spot']">存疑</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" :page.sync="query.pageNum" :limit.sync="query.pageSize" @pagination="loadList" />
      </el-tab-pane>
      <el-tab-pane label="周重合度" name="overlap">
        <el-table :data="overlap" size="mini">
          <el-table-column prop="studentNo" label="学号" width="90" />
          <el-table-column prop="studentName" label="姓名" />
          <el-table-column prop="themeCount" label="练过主题" width="90" />
          <el-table-column prop="weakCount" label="薄弱Top" width="90" />
          <el-table-column label="重合度" width="100">
            <template slot-scope="scope">
              <span :class="{ warn: overlapLow(scope.row) }">{{ overlapText(scope.row.overlapRate) }}</span>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="抽查" name="spot">
        <el-button size="mini" type="primary" plain class="mb8" @click="loadSpot" v-hasPermi="['spas:practice:spot']">生成本周随机名单</el-button>
        <el-table :data="spotRows" size="mini">
          <el-table-column prop="studentName" label="姓名" width="90" />
          <el-table-column prop="bookName" label="书名" />
          <el-table-column label="页/题" min-width="140">
            <template slot-scope="scope">{{ scope.row.pageFrom }}-{{ scope.row.pageTo }} / {{ scope.row.questionText }}</template>
          </el-table-column>
          <el-table-column label="操作" width="140">
            <template slot-scope="scope">
              <el-button type="text" size="mini" @click="spot(scope.row, '1')">通过</el-button>
              <el-button type="text" size="mini" @click="spot(scope.row, '2')">存疑</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="积分榜" name="points">
        <div class="mb8">
          <el-radio-group v-model="boardRange" size="mini" @change="loadBoard">
            <el-radio-button label="week">本周</el-radio-button>
            <el-radio-button label="all">累计</el-radio-button>
          </el-radio-group>
        </div>
        <el-table :data="boardList" size="mini" empty-text="暂无积分数据">
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
  </div>
</template>

<script>
import { listPractice, practiceDailyStat, practiceAlerts, practiceOverlap, practiceSpotSample, updatePracticeSpot, practiceToIntervene, practicePointsLeaderboard, listPracticeAssignment, savePracticeAssignment, copyLastPracticeAssignment, practiceCheckoutAlerts, practiceSpotQueue, recordCheckoutSpot, followCheckoutItem, checkoutToIntervene } from '@/api/spas/practice'
import { optionselectSubject } from '@/api/spas/subject'
import { treeKnowledge } from '@/api/spas/knowledge'
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
      loading: false,
      total: 0,
      logList: [],
      stat: null,
      alerts: {},
      coAlerts: {},
      spotQueue: [],
      knowledgeOptions: [],
      assignForm: {
        bookName: '',
        pageFrom: undefined,
        pageTo: undefined,
        questionText: '',
        knowledgeId: undefined,
        dueCountWeek: 3,
        completeDefinition: '指定页有书写痕迹，且抽问 1 道布置题能开口说思路。没看见本子不能点已完成。'
      },
      overlap: [],
      spotRows: [],
      boardList: [],
      boardRange: 'week',
      queryParams: { deptId: undefined },
      query: {
        deptId: undefined,
        subjectId: undefined,
        practiceDate: this.parseTime(new Date(), '{y}-{m}-{d}'),
        pageNum: 1,
        pageSize: 10
      }
    }
  },
  watch: {
    activeTab(v) {
      if (v === 'points') this.loadBoard()
    },
    'query.subjectId'() {
      this.loadKnowledge()
      this.loadAssign()
    }
  },
  computed: {
    submitPct() {
      const r = this.stat && this.stat.submitRate
      if (r == null) return '-'
      return Math.round(Number(r) * 100) + '%'
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
    selectDept(id) {
      this.query.deptId = id
      this.queryParams.deptId = id
      this.refresh()
    },
    refresh() {
      if (!this.query.deptId) return
      this.loadStat()
      this.loadAlerts()
      this.loadCheckoutAlerts()
      this.loadSpotQueue()
      this.loadAssign()
      this.loadKnowledge()
      this.loadList()
      this.loadOverlap()
      if (this.activeTab === 'points') this.loadBoard()
    },
    loadAssign() {
      if (!this.query.deptId || !this.query.subjectId) return
      listPracticeAssignment({
        deptId: this.query.deptId,
        subjectId: this.query.subjectId,
        assignDate: this.query.practiceDate
      }).then(r => {
        const list = r.data || []
        const row = list[0]
        if (row) {
          this.assignForm.bookName = row.bookName
          this.assignForm.pageFrom = row.pageFrom
          this.assignForm.pageTo = row.pageTo
          this.assignForm.questionText = row.questionText
          this.assignForm.knowledgeId = row.knowledgeId
          this.assignForm.dueCountWeek = row.dueCountWeek || 3
          this.assignForm.completeDefinition = row.completeDefinition
        }
      }).catch(() => {})
    },
    loadKnowledge() {
      if (!this.query.subjectId) {
        this.knowledgeOptions = []
        return
      }
      treeKnowledge(this.query.subjectId).then(r => {
        this.knowledgeOptions = this.flattenKnow(r.data || [])
      }).catch(() => { this.knowledgeOptions = [] })
    },
    flattenKnow(nodes, acc) {
      acc = acc || []
      ;(nodes || []).forEach(n => {
        if (n.nodeType !== 'chapter' && n.knowledgeId) {
          acc.push({ knowledgeId: n.knowledgeId, knowledgeName: n.knowledgeName })
        }
        if (n.children && n.children.length) this.flattenKnow(n.children, acc)
      })
      return acc
    },
    saveAssign() {
      if (!this.query.deptId || !this.query.subjectId) {
        this.$modal.msgWarning('请先选择班级和学科')
        return
      }
      savePracticeAssignment({
        deptId: this.query.deptId,
        subjectId: this.query.subjectId,
        assignDate: this.query.practiceDate,
        ...this.assignForm
      }).then(() => {
        this.$modal.msgSuccess('布置已保存')
        this.loadAssign()
      })
    },
    copyLast() {
      if (!this.query.deptId || !this.query.subjectId) {
        this.$modal.msgWarning('请先选择班级和学科')
        return
      }
      copyLastPracticeAssignment({
        deptId: this.query.deptId,
        subjectId: this.query.subjectId,
        assignDate: this.query.practiceDate
      }).then(() => {
        this.$modal.msgSuccess('已复制上次布置')
        this.loadAssign()
      })
    },
    loadCheckoutAlerts() {
      practiceCheckoutAlerts(this.query).then(r => { this.coAlerts = r.data || {} }).catch(() => { this.coAlerts = {} })
    },
    loadSpotQueue() {
      practiceSpotQueue(this.query).then(r => { this.spotQueue = r.data || [] }).catch(() => { this.spotQueue = [] })
    },
    doSpot(row, result) {
      recordCheckoutSpot(row.itemId, { spotResult: result }).then(() => {
        this.$modal.msgSuccess(result === '2' ? '已记偏松，该次作废' : '已记录')
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
    loadBoard() {
      if (!this.query.deptId) return
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
    loadStat() {
      practiceDailyStat(this.query).then(r => { this.stat = r.data || {} })
    },
    loadAlerts() {
      practiceAlerts(this.query).then(r => { this.alerts = r.data || {} })
    },
    loadList() {
      this.loading = true
      listPractice(this.query).then(r => {
        this.logList = r.rows || []
        this.total = r.total || 0
        this.loading = false
      }).catch(() => { this.loading = false })
    },
    loadOverlap() {
      practiceOverlap({ deptId: this.query.deptId, subjectId: this.query.subjectId }).then(r => {
        this.overlap = r.data || []
      })
    },
    loadSpot() {
      practiceSpotSample({ deptId: this.query.deptId, subjectId: this.query.subjectId, limit: 3 }).then(r => {
        this.spotRows = r.data || []
      })
    },
    finishLabel(v) {
      return { '1': '已完成', '2': '部分', '3': '有困难', '0': '未做', 'L': '请假', 'A': '未到/没带本' }[v] || v
    },
    overlapText(v) {
      if (v == null || v === '') return '-'
      return Math.round(Number(v) * 100) + '%'
    },
    overlapLow(row) {
      return row.overlapRate != null && Number(row.overlapRate) < 0.3
    },
    copyMissing() {
      const lines = (this.alerts.missing || []).map(s => (s.studentNo || '') + ' ' + s.studentName)
      const text = lines.join('\n')
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(() => this.$modal.msgSuccess('已复制 ' + lines.length + ' 人'))
      } else {
        this.$modal.msgWarning(text || '无未交名单')
      }
    },
    toIntervene(row) {
      if (!row.logId) return
      practiceToIntervene(row.logId).then(() => this.$modal.msgSuccess('已转干预'))
    },
    spot(row, status) {
      updatePracticeSpot(row.logId, { spotStatus: status }).then(() => {
        this.$modal.msgSuccess(status === '1' ? '已标记通过' : '已标记存疑')
        this.loadList()
        this.loadSpot()
      })
    }
  }
}
</script>

<style scoped>
.kpi { font-size: 16px; font-weight: 600; }
.tip { color: #e6a23c; font-size: 12px; }
.warn { color: #f56c6c; font-weight: 600; }
.board-head { display: flex; justify-content: space-between; align-items: center; }
</style>
