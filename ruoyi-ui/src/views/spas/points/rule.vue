<template>
  <div class="app-container">
    <el-alert
      class="mb8"
      type="info"
      :closable="false"
      show-icon
      title="当前发分规则由系统内置（与一体机一致）。修改规则需改代码发版，本页仅供查阅。"
    />

    <el-card shadow="never" class="mb8">
      <div slot="header"><span>打卡与连击</span></div>
      <el-table :data="practiceRules" size="small" border>
        <el-table-column prop="event" label="事件" min-width="220" />
        <el-table-column prop="points" label="分值" width="120" />
        <el-table-column prop="note" label="说明" min-width="280" />
      </el-table>
    </el-card>

    <el-card shadow="never" class="mb8">
      <div slot="header"><span>检查确认与抽检</span></div>
      <el-table :data="checkoutRules" size="small" border>
        <el-table-column prop="event" label="事件" min-width="220" />
        <el-table-column prop="points" label="分值" width="120" />
        <el-table-column prop="note" label="说明" min-width="280" />
      </el-table>
    </el-card>

    <el-card shadow="never">
      <div slot="header"><span>掌握度 / 封顶 / 等级</span></div>
      <el-table :data="systemRules" size="small" border>
        <el-table-column prop="event" label="规则" min-width="220" />
        <el-table-column prop="points" label="数值" width="160" />
        <el-table-column prop="note" label="说明" min-width="280" />
      </el-table>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'SpasPointRule',
  data() {
    return {
      practiceRules: [
        { event: '当日首条本人加练', points: '+10', note: '按 student + subject + date；含连击加成；检查单回写流水不占名额' },
        { event: '连续打卡 ≥2 天', points: '+2×min(streak,7)', note: '仅记在当日首条打卡上' },
        { event: '同日额外加练', points: '+3', note: '每学科每日额外最多 2 次；加练不计入组达标' }
      ],
      checkoutRules: [
        { event: '检查确认属实（完成/部分）', points: '+10', note: '组员确认检查单' },
        { event: '检查确认·有困难（如实）', points: '+8', note: '鼓励如实上报卡点' },
        { event: '组长按时提交检查单', points: '+5', note: '按单幂等' },
        { event: '抽检一致', points: '+5', note: '教师抽检通过' }
      ],
      systemRules: [
        { event: '掌握度进步', points: '+15', note: '近 14 天练过的知识点升幅 ≥0.05，每知识点每窗口一次' },
        { event: '实考导入·班级名次', points: '第 r 名 = N−r+1', note: '整场统一指标（优先总分，否则校次/科目分）；同分并列；不占日封顶额度；覆盖重导先冲销再发' },
        { event: '教师一键发分', points: '每人 1～20', note: '积分账户 / 监管积分榜多选发放；计入日封顶；同批次幂等；单次最多 80 人' },
        { event: '每日积分硬顶', points: '40', note: '日常激励超额记 0 分流水；考试名次分不计入额度' },
        { event: '等级步进', points: '每级约 50 积分累计', note: 'level = 1 + floor((sqrt(1+8*total/50)-1)/2)' }
      ]
    }
  }
}
</script>
