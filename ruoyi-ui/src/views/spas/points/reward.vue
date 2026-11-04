<template>
  <div class="app-container">
    <el-empty description="积分兑换尚未开放">
      <p class="hint">奖品目录、兑换流水与扣分接口仍在规划中。当前积分仅用于等级与班内榜激励。</p>
      <el-button type="primary" size="small" @click="$router.push('/spas/point-rule')">查看积分规则</el-button>
    </el-empty>
  </div>
</template>

<script>
export default {
  name: 'SpasPointReward'
}
</script>

<style scoped>
.hint {
  color: #909399;
  font-size: 13px;
  line-height: 1.6;
  max-width: 420px;
  margin: 0 auto 16px;
}
</style>
