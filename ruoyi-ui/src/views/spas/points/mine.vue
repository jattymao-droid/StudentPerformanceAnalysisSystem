<template>
  <div class="app-container">
    <el-row :gutter="12" class="mb8">
      <el-col :xs="24" :md="10">
        <el-card shadow="never">
          <div class="points-head">
            <span class="lv">Lv.{{ account.levelNo || 1 }}</span>
            <div>
              <div class="pts">{{ account.totalPoints || 0 }} 积分</div>
              <div class="sub">今日 +{{ account.todayPoints || 0 }} · 连打 {{ account.dayStreak || 0 }} 天</div>
            </div>
          </div>
          <el-progress :percentage="levelPct" :stroke-width="10" :show-text="false" color="#7c5cfc" />
          <div class="sub mt4">距下一级还需 {{ account.pointsToNext != null ? account.pointsToNext : '-' }}</div>
          <div class="sub mt4">
            植物阶段：{{ account.farmStageLabel || '萌芽' }}
            <template v-if="account.farmStage !== 'tree' && account.pointsToNextFarmStage != null">
              · 距下阶段 {{ account.pointsToNextFarmStage }}
            </template>
          </div>
          <div v-if="farmThresholdHint" class="sub">{{ farmThresholdHint }}</div>
          <div class="sub mt4">本周班榜：{{ weekRank ? ('第 ' + weekRank + ' 名') : '暂未上榜' }}</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="14">
        <el-card shadow="never">
          <div slot="header" class="board-head">
            <span>本班积分榜 · {{ boardRange === 'week' ? '本周' : '累计' }}</span>
            <el-radio-group v-model="boardRange" size="mini" @change="loadBoard">
              <el-radio-button label="week">周榜</el-radio-button>
              <el-radio-button label="all">总榜</el-radio-button>
            </el-radio-group>
          </div>
          <el-table :data="boardList" size="mini" max-height="220" empty-text="暂无上榜" :row-class-name="boardRowClass">
            <el-table-column prop="rankNo" label="#" width="50" />
            <el-table-column label="姓名">
              <template slot-scope="scope">
                {{ scope.row.studentName }}{{ isBoardMe(scope.row) ? '（我）' : '' }}
              </template>
            </el-table-column>
            <el-table-column label="积分" width="90">
              <template slot-scope="scope">
                {{ boardRange === 'week' ? (scope.row.weekPoints || 0) : (scope.row.totalPoints || 0) }}
              </template>
            </el-table-column>
            <el-table-column prop="levelNo" label="等级" width="70" />
          </el-table>
          <div class="sub mt4">我的名次：{{ myRank ? ('第 ' + myRank + ' 名') : '暂未上榜' }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-card shadow="never">
      <div slot="header">最近积分流水</div>
      <el-table v-loading="loading" :data="ledgerList" size="small" empty-text="暂无流水">
        <el-table-column prop="createTime" label="时间" width="170" />
        <el-table-column prop="reasonLabel" label="原因" width="120">
          <template slot-scope="scope">{{ scope.row.reasonLabel || scope.row.reasonCode || '-' }}</template>
        </el-table-column>
        <el-table-column label="分值" width="80">
          <template slot-scope="scope">
            <span :class="{ 'pts-pos': scope.row.points > 0, 'pts-neg': scope.row.points < 0 }">
              {{ scope.row.points > 0 ? '+' : '' }}{{ scope.row.points }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" :show-overflow-tooltip="true" />
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { practicePointsMine, practicePointsLedger, practicePointsLeaderboard } from '@/api/spas/practice'

export default {
  name: 'SpasPointMine',
  data() {
    return {
      loading: false,
      account: {},
      ledgerList: [],
      boardList: [],
      boardRange: 'week',
      myRank: null,
      myStudentId: null,
      weekRank: null,
      farmThresholds: {}
    }
  },
  computed: {
    levelPct() {
      const a = this.account || {}
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
    }
  },
  created() {
    this.refresh()
  },
  methods: {
    refresh() {
      this.loading = true
      Promise.all([
        practicePointsMine(),
        practicePointsLedger({ limit: 30 })
      ]).then(([mineRes, ledgerRes]) => {
        const data = mineRes.data || {}
        this.account = data.account || {}
        this.farmThresholds = data.farmThresholds || {}
        this.weekRank = data.weekRank != null ? data.weekRank : null
        if (data.studentId != null) this.myStudentId = data.studentId
        this.ledgerList = Array.isArray(ledgerRes.data) ? ledgerRes.data : []
      }).finally(() => {
        this.loading = false
        this.loadBoard()
      })
    },
    loadBoard() {
      practicePointsLeaderboard({ range: this.boardRange, limit: 10 }).then(res => {
        const data = res.data || {}
        this.boardList = data.list || []
        this.myRank = data.myRank != null ? data.myRank : null
        if (data.myStudentId != null) this.myStudentId = data.myStudentId
        if (this.boardRange === 'week') this.weekRank = this.myRank
      }).catch(() => {
        this.boardList = []
        this.myRank = null
      })
    },
    isBoardMe(row) {
      return this.myStudentId != null && row && Number(row.studentId) === Number(this.myStudentId)
    },
    boardRowClass({ row }) {
      return this.isBoardMe(row) ? 'board-me' : ''
    }
  }
}
</script>

<style scoped>
.points-head { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
.points-head .lv {
  display: inline-flex; align-items: center; justify-content: center;
  width: 56px; height: 56px; border-radius: 14px;
  background: linear-gradient(145deg, #c4b5fd, #7c5cfc); color: #fff; font-weight: 800;
}
.points-head .pts { font-size: 18px; font-weight: 800; }
.sub { color: #909399; font-size: 12px; }
.mt4 { margin-top: 4px; }
.board-head { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
.pts-pos { color: #67c23a; font-weight: 600; }
.pts-neg { color: #f56c6c; font-weight: 600; }
</style>
<style>
.board-me > td { background: #f3efff !important; font-weight: 600; }
</style>
