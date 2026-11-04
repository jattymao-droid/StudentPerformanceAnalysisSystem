<template>
  <div>
    <el-alert
      class="mb8"
      style="margin: 16px 16px 0"
      type="info"
      :closable="false"
      show-icon
      :title="tip"
    />
    <my-practice />
  </div>
</template>

<script>
import MyPractice from '@/views/spas/practice/mine.vue'

export default {
  name: 'HomeworkKiosk',
  components: { MyPractice },
  data() {
    return {
      tip: '教室一体机请用桌面端「知脉自主练」登记检查。本页可确认检查结果或提交加练（不加组达标）。'
    }
  }
}
</script>
