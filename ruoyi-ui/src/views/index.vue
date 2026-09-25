<template>
  <div class="app-container spas-home" v-loading="loading">
    <el-row :gutter="16">
      <el-col :span="24">
        <el-card shadow="never" class="hero-card">
          <div class="hero-layout">
            <div class="hero-main">
              <div class="hero-brand">知脉</div>
              <div class="hero-greet">{{ greeting }}，{{ displayName }}</div>
              <div class="hero-sub">成绩采集 · 知识点诊断 · 预警干预 · 一生一册，串联完整教学闭环。</div>
              <div class="hero-actions">
                <el-button
                  v-if="isStudent"
                  type="primary"
                  size="small"
                  icon="el-icon-notebook-2"
                  @click="go('/myspas/mine')"
                >进入我的学情</el-button>
                <template v-else>
                  <el-button
                    v-hasPermi="['spas:score:list']"
                    type="primary"
                    size="small"
                    icon="el-icon-upload2"
                    @click="go('/spas/biz/score')"
                  >成绩导入</el-button>
                  <el-button
                    v-hasPermi="['spas:analysis:student']"
                    plain
                    size="small"
                    icon="el-icon-data-analysis"
                    @click="go('/spas/analysis/student')"
                  >学生分析</el-button>
                  <el-button
                    v-hasPermi="['spas:warning:record']"
                    plain
                    size="small"
                    icon="el-icon-bell"
                    @click="go('/spas/warning/record')"
                  >预警记录</el-button>
                  <el-button
                    v-hasPermi="['spas:qb:question:list']"
                    plain
                    size="small"
                    icon="el-icon-files"
                    @click="go('/spas/qb/select')"
                  >选题组卷</el-button>
                  <el-button
                    v-hasPermi="['spas:portfolio:list']"
                    plain
                    size="small"
                    icon="el-icon-collection"
                    @click="go('/spas/portfolio')"
                  >一生一册</el-button>
                </template>
              </div>
            </div>
            <div v-if="!isStudent && dashboardLoaded" class="hero-aside">
              <div class="pulse-chip" :class="{ 'is-alert': hasAlerts }">
                <span class="pulse-dot" />
                <span>{{ statusLine }}</span>
              </div>
              <div class="pulse-meta">{{ pulseMeta }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <template v-if="!isStudent && dashboardLoaded">
      <div class="section-label">运行概览</div>
      <el-row :gutter="14">
        <el-col :xs="12" :sm="8" :md="4" v-for="card in visibleKpiCards" :key="card.key">
          <el-card shadow="hover" class="kpi-card" :class="['tone-' + card.tone, { 'is-alert': card.alert }]" @click.native="goIfPerm(card)">
            <div class="kpi-top">
              <div class="kpi-label">{{ card.label }}</div>
              <i :class="card.icon" class="kpi-icon" />
            </div>
            <div class="kpi-value">{{ card.value }}</div>
            <div class="kpi-hint">{{ card.hint }}</div>
          </el-card>
        </el-col>
      </el-row>

      <div class="section-label">近期动态</div>
      <el-row :gutter="16">
        <el-col :xs="24" :md="14">
          <el-card shadow="never" class="panel-card">
            <div slot="header" class="card-header">
              <span>最近成绩导入</span>
              <div class="card-header-actions">
                <el-button type="text" size="mini" icon="el-icon-refresh" @click="loadDashboard">刷新</el-button>
                <el-button type="text" size="mini" @click="goIfPerm({ path: '/spas/biz/score', perms: ['spas:score:list'] })">全部</el-button>
              </div>
            </div>
            <el-table :data="recentBatches" size="small" empty-text="暂无导入记录" highlight-current-row @row-click="goRecentBatch" class="clickable-table">
              <el-table-column label="试卷" prop="paperName" min-width="140" :show-overflow-tooltip="true" />
              <el-table-column label="成功" prop="successRows" width="70" align="center" />
              <el-table-column label="失败" width="70" align="center">
                <template slot-scope="scope">
                  <span :class="{ 'fail-hot': Number(scope.row.failRows) > 0 }">{{ scope.row.failRows != null ? scope.row.failRows : 0 }}</span>
                </template>
              </el-table-column>
              <el-table-column label="导入人" prop="createBy" width="90" align="center" />
              <el-table-column label="时间" width="150" align="center">
                <template slot-scope="scope">{{ parseTime(scope.row.createTime) }}</template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>
        <el-col :xs="24" :md="10">
          <el-card shadow="never" class="panel-card">
            <div slot="header" class="card-header">
              <span>薄弱知识点 Top3</span>
              <el-button type="text" size="mini" @click="goIfPerm({ path: '/spas/analysis/knowledge', perms: ['spas:analysis:knowledge'] })">详情</el-button>
            </div>
            <div v-if="!weakTop.length" class="empty-block">暂无薄弱数据</div>
            <div v-else class="weak-list">
              <div
                v-for="(row, idx) in weakTop"
                :key="row.knowledgeId || row.id || idx"
                class="weak-row"
                @click="goWeakKnowledge(row)"
              >
                <div class="weak-rank">{{ idx + 1 }}</div>
                <div class="weak-body">
                  <div class="weak-name" :title="row.name">{{ row.name || '-' }}</div>
                  <div class="weak-bar">
                    <div class="weak-bar-fill" :style="{ width: ratePercent(row.rate) + '%', background: rateColor(row.rate) }" />
                  </div>
                </div>
                <div class="weak-rate" :style="{ color: rateColor(row.rate) }">{{ formatRate(row.rate) }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </template>

    <template v-if="!isStudent">
      <div class="section-label">教学闭环</div>
      <el-row :gutter="14">
        <el-col :xs="24" :sm="12" :md="6" v-for="(item, i) in visibleGuideCards" :key="item.title">
          <el-card shadow="hover" class="guide-card" @click.native="goIfPerm(item)">
            <div class="guide-step">{{ String(i + 1).padStart(2, '0') }}</div>
            <div class="guide-icon"><i :class="item.icon"></i></div>
            <div class="guide-title">{{ item.title }}</div>
            <div class="guide-desc">{{ item.desc }}</div>
          </el-card>
        </el-col>
      </el-row>
    </template>

    <el-card shadow="never" class="panel-card student-tip" v-else>
      <div slot="header" class="card-header">使用说明</div>
      <p class="tip-text">登录后可查看本人知识点掌握、成绩趋势与预警信息。如页面无数据，请等待教师导入成绩。</p>
      <el-button type="primary" size="small" @click="go('/myspas/mine')">打开一生一册</el-button>
    </el-card>
  </div>
</template>

<script>
import { checkPermi } from '@/utils/permission'
import { getDashboardOverview } from '@/api/spas/dashboard'
import { mapGetters } from 'vuex'

export default {
  name: 'Index',
  data() {
    return {
      loading: false,
      dashboardLoaded: false,
      dashboard: {},
      guideCards: [
        {
          title: '维护基础数据',
          desc: '学科、知识点、学生档案',
          icon: 'el-icon-s-grid',
          path: '/spas/base/student',
          perms: ['spas:student:list']
        },
        {
          title: '组卷与导分',
          desc: '题库组卷、发布分析卷、导入成绩',
          icon: 'el-icon-document',
          path: '/spas/qb/paper',
          perms: ['spas:qb:paper:list']
        },
        {
          title: '分析与预警',
          desc: '班级/学生掌握度与预警处理',
          icon: 'el-icon-pie-chart',
          path: '/spas/analysis/class',
          perms: ['spas:analysis:class']
        },
        {
          title: '质量与报告',
          desc: '数据质量巡检、学期对比导出',
          icon: 'el-icon-data-board',
          path: '/spas/report',
          perms: ['spas:report:export']
        }
      ]
    }
  },
  computed: {
    ...mapGetters(['nickName', 'name', 'roles']),
    isStudent() {
      return (this.roles || []).includes('spas_student')
    },
    displayName() {
      return this.nickName || this.name || '老师'
    },
    greeting() {
      const h = new Date().getHours()
      if (h < 6) return '夜深了'
      if (h < 11) return '上午好'
      if (h < 13) return '中午好'
      if (h < 18) return '下午好'
      return '晚上好'
    },
    hasAlerts() {
      const d = this.dashboard || {}
      return Number(d.openWarningCount || 0) > 0 || Number(d.qualityAlertCount || 0) > 0
    },
    statusLine() {
      const d = this.dashboard || {}
      const warn = Number(d.openWarningCount || 0)
      const quality = Number(d.qualityAlertCount || 0)
      if (warn > 0 || quality > 0) {
        const parts = []
        if (warn > 0) parts.push(warn + ' 条待处理预警')
        if (quality > 0) parts.push(quality + ' 项质量告警')
        return parts.join(' · ')
      }
      return '运行平稳，暂无待办告警'
    },
    pulseMeta() {
      const at = this.dashboard && this.dashboard.generatedAt
      const time = at ? this.parseTime(at, '{h}:{i}') : ''
      return time ? ('按权限汇总 · 更新于 ' + time) : '数据按您的班级/学科权限汇总'
    },
    visibleKpiCards() {
      return this.kpiCards.filter(c => !c.perms || !c.perms.length || checkPermi(c.perms))
    },
    visibleGuideCards() {
      return this.guideCards.filter(c => !c.perms || !c.perms.length || checkPermi(c.perms))
    },
    kpiCards() {
      const d = this.dashboard || {}
      const warn = Number(d.openWarningCount || 0)
      const quality = Number(d.qualityAlertCount || 0)
      const intervene = Number(d.openInterveneCount || 0)
      return [
        { key: 'stu', label: '在读学生', value: d.studentCount != null ? d.studentCount : '-', tone: 'blue', icon: 'el-icon-user', hint: '学生档案', path: '/spas/base/student', perms: ['spas:student:list'] },
        { key: 'warn', label: '待处理预警', value: d.openWarningCount != null ? d.openWarningCount : '-', tone: 'orange', icon: 'el-icon-bell', hint: warn > 0 ? '需跟进' : '暂无积压', alert: warn > 0, path: '/spas/warning/record', perms: ['spas:warning:record'] },
        { key: 'paper', label: '已发布试卷', value: d.publishedPaperCount != null ? d.publishedPaperCount : '-', tone: 'green', icon: 'el-icon-document-checked', hint: '分析卷', path: '/spas/biz/paper', perms: ['spas:paper:list'] },
        { key: 'intervene', label: '进行中干预', value: d.openInterveneCount != null ? d.openInterveneCount : '-', tone: 'orange', icon: 'el-icon-s-flag', hint: intervene > 0 ? '进行中' : '可新建', alert: intervene > 0, path: '/spas/intervene', perms: ['spas:intervene:list'] },
        { key: 'quality', label: '质量告警', value: d.qualityAlertCount != null ? d.qualityAlertCount : '-', tone: 'orange', icon: 'el-icon-warning-outline', hint: quality > 0 ? '建议排查' : '质量良好', alert: quality > 0, path: '/spas/quality', perms: ['spas:quality:list'] },
        { key: 'batch', label: '最近导入', value: (d.recentBatches && d.recentBatches.length) || 0, tone: 'teal', icon: 'el-icon-upload2', hint: '近 5 批', path: '/spas/biz/score', perms: ['spas:score:list'] }
      ]
    },
    recentBatches() {
      return (this.dashboard && this.dashboard.recentBatches) || []
    },
    weakTop() {
      return (this.dashboard && this.dashboard.weakKnowledgeTop) || []
    }
  },
  created() {
    if (this.isStudent) {
      this.$router.replace('/myspas/mine').catch(() => {})
    } else {
      this.loadDashboard()
    }
  },
  methods: {
    loadDashboard() {
      this.loading = true
      getDashboardOverview().then(res => {
        this.dashboard = res.data || {}
        this.dashboardLoaded = true
      }).catch(() => {
        this.dashboardLoaded = true
      }).finally(() => {
        this.loading = false
      })
    },
    formatRate(rate) {
      if (rate == null || rate === '') return '-'
      const n = Number(rate)
      if (isNaN(n)) return rate
      const p = n <= 1 ? n * 100 : n
      return p.toFixed(1) + '%'
    },
    ratePercent(rate) {
      if (rate == null || rate === '') return 0
      const n = Number(rate)
      if (isNaN(n)) return 0
      const p = n <= 1 ? n * 100 : n
      return Math.max(4, Math.min(100, p))
    },
    rateColor(rate) {
      if (rate == null || rate === '') return '#94A3B8'
      const n = Number(rate)
      if (isNaN(n)) return '#94A3B8'
      const p = n <= 1 ? n * 100 : n
      if (p < 45) return '#FF5A5F'
      if (p < 60) return '#D97706'
      if (p < 75) return '#CA8A04'
      return '#10B981'
    },
    goWeakKnowledge(row) {
      if (!row) return
      if (!checkPermi(['spas:analysis:knowledge'])) {
        this.$modal.msgWarning('暂无权限，请联系管理员')
        return
      }
      const knowledgeId = row.knowledgeId || row.id
      if (!knowledgeId) {
        this.go('/spas/analysis/knowledge')
        return
      }
      this.$router.push({
        path: '/spas/analysis/knowledge',
        query: { knowledgeId, subjectId: row.subjectId }
      }).catch(() => {})
    },
    goRecentBatch(row) {
      if (!row) return
      if (!checkPermi(['spas:score:list'])) {
        this.$modal.msgWarning('暂无权限，请联系管理员')
        return
      }
      const query = {}
      if (row.paperId != null) query.paperId = row.paperId
      if (row.batchId != null) query.batchId = row.batchId
      this.$router.push({ path: '/spas/biz/score', query }).catch(() => {})
    },
    go(path) {
      this.$router.push(path).catch(() => {})
    },
    goIfPerm(item) {
      if (!item || !item.path) return
      if (item.perms && item.perms.length && !checkPermi(item.perms)) {
        this.$modal.msgWarning('暂无权限，请联系管理员')
        return
      }
      this.go(item.path)
    }
  }
}
</script>

<style scoped>
.spas-home .hero-layout {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  position: relative;
  z-index: 1;
}
.spas-home .hero-brand {
  font-size: 34px;
  font-weight: 800;
  letter-spacing: 0.12em;
  color: #0F172A;
  line-height: 1.15;
}
.spas-home .hero-greet {
  margin-top: 10px;
  font-size: 16px;
  font-weight: 600;
  color: #334155;
}
.spas-home .hero-sub {
  margin-top: 8px;
  max-width: 560px;
  color: #64748B;
  line-height: 1.7;
  font-size: 14px;
}
.spas-home .hero-actions {
  margin-top: 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.spas-home .hero-aside {
  flex-shrink: 0;
  text-align: right;
  padding-bottom: 4px;
}
.spas-home .pulse-chip {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 14px;
  border-radius: 999px;
  background: #ECFDF5;
  border: 1px solid #A7F3D0;
  color: #047857;
  font-size: 13px;
  font-weight: 600;
}
.spas-home .pulse-chip.is-alert {
  background: #FFF7ED;
  border-color: #FDBA74;
  color: #C2410C;
}
.spas-home .pulse-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: currentColor;
  box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.18);
}
.spas-home .pulse-chip.is-alert .pulse-dot {
  box-shadow: 0 0 0 3px rgba(217, 119, 6, 0.2);
}
.spas-home .pulse-meta {
  margin-top: 8px;
  font-size: 12px;
  color: #94A3B8;
}
.spas-home .section-label {
  margin: 22px 0 10px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #94A3B8;
}
.spas-home .card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  font-weight: 600;
}
.spas-home .card-header-actions {
  display: flex;
  align-items: center;
  gap: 4px;
}
.spas-home .clickable-table {
  cursor: pointer;
}
.spas-home .fail-hot {
  color: #DC2626;
  font-weight: 700;
}
.spas-home .empty-block {
  padding: 28px 12px;
  text-align: center;
  color: #94A3B8;
  font-size: 13px;
}
.spas-home .weak-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 4px 2px 8px;
}
.spas-home .weak-row {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  padding: 6px 4px;
  border-radius: 8px;
  transition: background 0.15s ease;
}
.spas-home .weak-row:hover {
  background: #F8FAFC;
}
.spas-home .weak-rank {
  width: 22px;
  height: 22px;
  border-radius: 6px;
  background: #F0F3FF;
  color: #2442ED;
  font-size: 12px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.spas-home .weak-body {
  flex: 1;
  min-width: 0;
}
.spas-home .weak-name {
  font-size: 13px;
  font-weight: 600;
  color: #0F172A;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.spas-home .weak-bar {
  margin-top: 6px;
  height: 6px;
  border-radius: 999px;
  background: #E2E8F0;
  overflow: hidden;
}
.spas-home .weak-bar-fill {
  height: 100%;
  border-radius: 999px;
  transition: width 0.35s ease;
}
.spas-home .weak-rate {
  width: 56px;
  text-align: right;
  font-size: 13px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  flex-shrink: 0;
}
.spas-home .guide-card {
  cursor: pointer;
  min-height: 148px;
  margin-bottom: 12px;
  position: relative;
}
.spas-home .guide-step {
  position: absolute;
  top: 14px;
  right: 16px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  color: #CBD5E1;
}
.spas-home .guide-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #F0F3FF;
  border: 1px solid #C7D2FE;
  font-size: 18px;
  color: #2442ED;
  margin-bottom: 14px;
}
.spas-home .guide-title {
  font-weight: 600;
  color: #0F172A;
}
.spas-home .guide-desc {
  margin-top: 6px;
  color: #64748B;
  font-size: 13px;
  line-height: 1.55;
}
.spas-home .tip-text {
  color: #64748B;
  line-height: 1.7;
  margin: 0 0 12px;
}
.spas-home .kpi-card {
  margin-bottom: 12px;
  border-left: 3px solid #2442ED;
  cursor: pointer;
}
.spas-home .kpi-card.tone-orange { border-left-color: #D97706; }
.spas-home .kpi-card.tone-green { border-left-color: #10B981; }
.spas-home .kpi-card.tone-blue,
.spas-home .kpi-card.tone-teal { border-left-color: #2442ED; }
.spas-home .kpi-card.is-alert {
  background: linear-gradient(180deg, #FFFBF5 0%, #ffffff 70%);
}
.spas-home .kpi-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}
.spas-home .kpi-label {
  color: #64748B;
  font-size: 12px;
  letter-spacing: 0.04em;
  font-weight: 600;
}
.spas-home .kpi-icon {
  color: #94A3B8;
  font-size: 16px;
}
.spas-home .kpi-value {
  margin-top: 10px;
  font-size: 28px;
  font-weight: 700;
  color: #0F172A;
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.03em;
  line-height: 1.1;
}
.spas-home .kpi-hint {
  margin-top: 8px;
  font-size: 11px;
  color: #94A3B8;
}
.spas-home .student-tip {
  margin-top: 16px;
}
@media (max-width: 768px) {
  .spas-home .hero-layout {
    flex-direction: column;
    align-items: flex-start;
  }
  .spas-home .hero-aside {
    text-align: left;
  }
  .spas-home .hero-brand { font-size: 28px; }
  .spas-home .kpi-value { font-size: 24px; }
}
</style>
