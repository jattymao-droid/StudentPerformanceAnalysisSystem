<template>
  <div class="app-container spas-home">
    <el-row :gutter="16">
      <el-col :span="24">
        <el-card shadow="never" class="hero-card">
          <div class="hero-title">学生学情分析系统</div>
          <div class="hero-sub">采集成绩、知识点分析、预警处理与一生一册，形成学情闭环。</div>
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
                type="success"
                plain
                size="small"
                icon="el-icon-data-analysis"
                @click="go('/spas/analysis/student')"
              >学生分析</el-button>
              <el-button
                v-hasPermi="['spas:warning:record']"
                type="warning"
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

    <el-row :gutter="16" style="margin-top: 16px" v-if="!isStudent && dashboardLoaded">
      <el-col :xs="12" :sm="6" v-for="card in kpiCards" :key="card.key">
        <el-card shadow="hover" class="kpi-card" :class="'tone-' + card.tone" @click.native="goIfPerm(card)">
          <div class="kpi-label">{{ card.label }}</div>
          <div class="kpi-value">{{ card.value }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="16" style="margin-top: 16px" v-if="!isStudent && dashboardLoaded">
      <el-col :xs="24" :md="14">
        <el-card shadow="never">
          <div slot="header" class="card-header">最近成绩导入</div>
          <el-table :data="recentBatches" size="small" empty-text="暂无导入记录">
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
        <el-card shadow="never">
          <div slot="header" class="card-header">薄弱知识点 Top3</div>
          <el-table :data="weakTop" size="small" empty-text="暂无数据" @row-click="goWeakKnowledge">
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

    <el-row :gutter="16" style="margin-top: 16px" v-if="!isStudent">
      <el-col :xs="24" :md="8" v-for="item in guideCards" :key="item.title">
        <el-card shadow="hover" class="guide-card" @click.native="goIfPerm(item)">
          <div class="guide-icon"><i :class="item.icon"></i></div>
          <div class="guide-title">{{ item.title }}</div>
          <div class="guide-desc">{{ item.desc }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-card shadow="never" style="margin-top: 16px" v-if="!isStudent">
      <div slot="header" class="card-header">演示账号与验收提示</div>
      <el-alert
        title="可使用演示数据快速验收：先查看演示试卷成绩，再执行预警与分析。"
        type="info"
        :closable="false"
        show-icon
        class="mb12"
      />
      <el-descriptions :column="1" border size="small">
        <el-descriptions-item label="管理员">admin / admin123</el-descriptions-item>
        <el-descriptions-item label="任课教师">teacher001 / 123456（初一1班+2班）</el-descriptions-item>
        <el-descriptions-item label="班主任">bzr001 / 123456（本班学生管理）</el-descriptions-item>
        <el-descriptions-item label="年级负责人">grade001 / 123456（2024级）</el-descriptions-item>
        <el-descriptions-item label="校级领导">school001 / 123456（全校只读总览）</el-descriptions-item>
        <el-descriptions-item label="学生">demo001 / 123456（1班）；demo002、demo003 / 123456（2班）</el-descriptions-item>
        <el-descriptions-item label="演示数据">1班「演示单元测」；2班「演示单元测-(2)班」含薄弱对比</el-descriptions-item>
        <el-descriptions-item label="建议路径">成绩导入 → 班级分析快捷切班 → 预警处理 → 一生一册</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <el-card shadow="never" style="margin-top: 16px" v-else>
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
      if (p < 45) return '#F56C6C'
      if (p < 60) return '#E6A23C'
      if (p < 75) return '#E6A23C'
      return '#67C23A'
    },
    goWeakKnowledge(row) {
      if (!row) return
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
  background: linear-gradient(135deg, #F4F0FF 0%, #ffffff 55%, #F8F6FF 100%);
}
.spas-home .hero-title {
  font-size: 24px;
  font-weight: 700;
  letter-spacing: 0.02em;
  color: #2C2940;
}
.spas-home .hero-sub {
  margin-top: 10px;
  max-width: 640px;
  color: #6B6685;
  line-height: 1.7;
  font-size: 14px;
}
.spas-home .hero-actions {
  margin-top: 18px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.spas-home .guide-card {
  cursor: pointer;
  min-height: 132px;
  margin-bottom: 12px;
}
.spas-home .guide-icon {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #EDE7FF;
  font-size: 18px;
  color: #7B6CF6;
  margin-bottom: 12px;
}
.spas-home .guide-title {
  font-weight: 600;
  color: #2C2940;
}
.spas-home .guide-desc {
  margin-top: 6px;
  color: #6B6685;
  font-size: 13px;
  line-height: 1.5;
}
.spas-home .card-header {
  font-weight: 600;
}
.spas-home .mb12 {
  margin-bottom: 12px;
}
.spas-home .tip-text {
  color: #6B6685;
  line-height: 1.7;
  margin: 0 0 12px;
}
.spas-home .kpi-card {
  margin-bottom: 12px;
  border-left: 3px solid #7B6CF6;
  cursor: pointer;
}
.spas-home .kpi-card.tone-orange { border-left-color: #e6a23c; }
.spas-home .kpi-card.tone-green { border-left-color: #67c23a; }
.spas-home .kpi-card.tone-blue { border-left-color: #7B6CF6; }
.spas-home .kpi-card.tone-teal { border-left-color: #7B6CF6; }
.spas-home .kpi-label {
  color: #6B6685;
  font-size: 13px;
}
.spas-home .kpi-value {
  margin-top: 8px;
  font-size: 28px;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: #2C2940;
}
</style>
