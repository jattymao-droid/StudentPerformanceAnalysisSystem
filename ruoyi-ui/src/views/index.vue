<template>
  <div class="app-container spas-home">
    <el-row :gutter="16">
      <el-col :span="24">
        <el-card shadow="never" class="hero-card">
          <div class="hero-eyebrow">知脉 · 学情工作台</div>
          <div class="hero-title">知脉</div>
          <div class="hero-sub">学生学情分析系统：成绩采集、知识点诊断、预警干预与一生一册，串联完整教学闭环。</div>
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
                v-hasPermi="['spas:portfolio:list']"
                plain
                size="small"
                icon="el-icon-collection"
                @click="go('/spas/portfolio')"
              >一生一册</el-button>
            </template>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <template v-if="!isStudent && dashboardLoaded">
      <div class="section-label">运行概览</div>
      <el-row :gutter="14">
        <el-col :xs="12" :sm="8" :md="4" v-for="card in kpiCards" :key="card.key">
          <el-card shadow="hover" class="kpi-card" :class="'tone-' + card.tone" @click.native="goIfPerm(card)">
            <div class="kpi-label">{{ card.label }}</div>
            <div class="kpi-value">{{ card.value }}</div>
            <div class="kpi-hint">点击进入</div>
          </el-card>
        </el-col>
      </el-row>

      <div class="section-label">近期动态</div>
      <el-row :gutter="16">
        <el-col :xs="24" :md="14">
          <el-card shadow="never" class="panel-card">
            <div slot="header" class="card-header">
              <span>最近成绩导入</span>
              <span class="card-header-meta">点击行可跳转</span>
            </div>
            <el-table :data="recentBatches" size="small" empty-text="暂无导入记录" highlight-current-row @row-click="goRecentBatch" class="clickable-table">
              <el-table-column label="试卷" prop="paperName" min-width="140" :show-overflow-tooltip="true" />
              <el-table-column label="成功" prop="successRows" width="70" align="center" />
              <el-table-column label="失败" prop="failRows" width="70" align="center" />
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
              <span class="card-header-meta">按平均得分率</span>
            </div>
            <el-table :data="weakTop" size="small" empty-text="暂无数据" @row-click="goWeakKnowledge" class="clickable-table">
              <el-table-column label="知识点" prop="name" min-width="120" :show-overflow-tooltip="true" />
              <el-table-column label="平均得分率" width="110" align="center">
                <template slot-scope="scope">
                  <span :style="{ color: rateColor(scope.row.rate), fontWeight: 600 }">{{ formatRate(scope.row.rate) }}</span>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>
      </el-row>
    </template>

    <template v-if="!isStudent">
      <div class="section-label">常用入口</div>
      <el-row :gutter="14">
        <el-col :xs="24" :sm="12" :md="6" v-for="item in guideCards" :key="item.title">
          <el-card shadow="hover" class="guide-card" @click.native="goIfPerm(item)">
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

export default {
  name: 'Index',
  data() {
    return {
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
          title: '发布试卷并导入',
          desc: '一题可绑定多知识点权重',
          icon: 'el-icon-document',
          path: '/spas/biz/paper',
          perms: ['spas:paper:list']
        },
        {
          title: '分析与预警',
          desc: '雷达/趋势/薄弱点与预警处理',
          icon: 'el-icon-pie-chart',
          path: '/spas/analysis/class',
          perms: ['spas:analysis:class']
        },
        {
          title: '数据质量',
          desc: '未绑定/缺日期/样本',
          icon: 'el-icon-warning-outline',
          path: '/spas/quality',
          perms: ['spas:quality:list']
        }
      ]
    }
  },
  computed: {
    roles() {
      return this.$store.getters.roles || []
    },
    isStudent() {
      return this.roles.includes('spas_student')
    },
    kpiCards() {
      const d = this.dashboard || {}
      return [
        { key: 'stu', label: '在读学生', value: d.studentCount != null ? d.studentCount : '-', tone: 'blue', path: '/spas/base/student', perms: ['spas:student:list'] },
        { key: 'warn', label: '待处理预警', value: d.openWarningCount != null ? d.openWarningCount : '-', tone: 'orange', path: '/spas/warning/record', perms: ['spas:warning:record'] },
        { key: 'paper', label: '已发布试卷', value: d.publishedPaperCount != null ? d.publishedPaperCount : '-', tone: 'green', path: '/spas/biz/paper', perms: ['spas:paper:list'] },
        { key: 'intervene', label: '进行中干预', value: d.openInterveneCount != null ? d.openInterveneCount : '-', tone: 'orange', path: '/spas/intervene', perms: ['spas:intervene:list'] },
        { key: 'quality', label: '质量告警', value: d.qualityAlertCount != null ? d.qualityAlertCount : '-', tone: 'orange', path: '/spas/quality', perms: ['spas:quality:list'] },
        { key: 'batch', label: '最近导入', value: (d.recentBatches && d.recentBatches.length) || 0, tone: 'teal', path: '/spas/biz/score', perms: ['spas:score:list'] }
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
      getDashboardOverview().then(res => {
        this.dashboard = res.data || {}
        this.dashboardLoaded = true
      }).catch(() => {
        this.dashboardLoaded = true
      })
    },
    formatRate(rate) {
      if (rate == null || rate === '') return '-'
      const n = Number(rate)
      if (isNaN(n)) return rate
      const p = n <= 1 ? n * 100 : n
      return p.toFixed(2) + '%'
    },
    rateColor(rate) {
      if (rate == null || rate === '') return undefined
      const n = Number(rate)
      if (isNaN(n)) return undefined
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
      const paperId = row.paperId
      const query = {}
      if (paperId != null) query.paperId = paperId
      if (row.batchId != null) query.batchId = row.batchId
      this.$router.push({ path: '/spas/biz/score', query }).catch(() => {})
    },
    go(path) {
      this.$router.push(path).catch(() => {})
    },
    goIfPerm(item) {
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
.spas-home .hero-card {
  background: transparent;
}
.spas-home .hero-eyebrow {
  display: inline-block;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: #2442ED;
  background: #F0F3FF;
  border: 1px solid #99F6E4;
  border-radius: 6px;
  padding: 3px 10px;
  margin-bottom: 12px;
}
.spas-home .hero-title {
  font-size: 28px;
  font-weight: 700;
  letter-spacing: -0.025em;
  color: #0F172A;
  line-height: 1.2;
}
.spas-home .hero-sub {
  margin-top: 10px;
  max-width: 580px;
  color: #64748B;
  line-height: 1.7;
  font-size: 14px;
}
.spas-home .hero-actions {
  margin-top: 22px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
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
  letter-spacing: 0.01em;
}
.spas-home .card-header-meta {
  font-size: 12px;
  font-weight: 500;
  color: #94A3B8;
  letter-spacing: 0;
}
.spas-home .clickable-table {
  cursor: pointer;
}
.spas-home .guide-card {
  cursor: pointer;
  min-height: 140px;
  margin-bottom: 12px;
}
.spas-home .guide-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #F0F3FF;
  border: 1px solid #99F6E4;
  font-size: 18px;
  color: #2442ED;
  margin-bottom: 14px;
}
.spas-home .guide-title {
  font-weight: 600;
  color: #0F172A;
  letter-spacing: 0.01em;
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
.spas-home .kpi-label {
  color: #64748B;
  font-size: 12px;
  letter-spacing: 0.04em;
  font-weight: 600;
}
.spas-home .kpi-value {
  margin-top: 8px;
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
  opacity: 0;
  transition: opacity 0.15s ease;
}
.spas-home .kpi-card:hover .kpi-hint {
  opacity: 1;
}
.spas-home .student-tip {
  margin-top: 16px;
}
@media (max-width: 768px) {
  .spas-home .hero-title { font-size: 22px; }
  .spas-home .kpi-value { font-size: 24px; }
}
</style>
