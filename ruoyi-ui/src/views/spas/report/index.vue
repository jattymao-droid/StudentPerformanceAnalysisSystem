<template>
  <div class="app-container">
    <el-alert type="info" :closable="false" show-icon class="mb8"
      title="学情报告从分析页导出最完整；本页为快捷入口。" />
    <el-row :gutter="16">
      <el-col :span="8">
        <el-card shadow="hover">
          <div slot="header">学生分析报告</div>
          <p class="tip">预览 / PDF / Excel（需先选学生与学科）</p>
          <el-button type="primary" size="mini" @click="go('/spas/analysis/student')">前往学生分析</el-button>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover">
          <div slot="header">班级分析报告</div>
          <p class="tip">班级弱项与覆盖概览导出</p>
          <el-button type="primary" size="mini" @click="go('/spas/analysis/class')">前往班级分析</el-button>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover">
          <div slot="header">一生一册</div>
          <p class="tip">档案口径与辅导日志同屏导出</p>
          <el-button type="primary" size="mini" @click="go('/spas/portfolio')">前往一生一册</el-button>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'SpasReportHub',
  methods: {
    go(path) {
      this.$router.push({ path }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.mb8 { margin-bottom: 12px; }
.tip { color: #909399; font-size: 13px; min-height: 40px; }
</style>
