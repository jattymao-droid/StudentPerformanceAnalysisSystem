<template>
  <div :class="className" :style="{ height: height, width: width }" />
</template>

<script>
import * as echarts from 'echarts'
require('echarts/theme/macarons')
import resize from '@/views/dashboard/mixins/resize'

export default {
  name: 'SpasChart',
  mixins: [resize],
  props: {
    className: {
      type: String,
      default: 'spas-chart'
    },
    width: {
      type: String,
      default: '100%'
    },
    height: {
      type: String,
      default: '360px'
    },
    option: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      chart: null
    }
  },
  watch: {
    option: {
      deep: true,
      handler(val) {
        this.setOption(val)
      }
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.initChart()
    })
  },
  beforeDestroy() {
    if (!this.chart) {
      return
    }
    this.chart.off('click')
    this.chart.dispose()
    this.chart = null
  },
  methods: {
    initChart() {
      this.chart = echarts.init(this.$el, 'macarons')
      this.chart.on('click', params => {
        this.$emit('chart-click', params)
      })
      this.setOption(this.option)
    },
    setOption(option) {
      if (!this.chart) {
        return
      }
      this.chart.clear()
      if (option && Object.keys(option).length) {
        this.chart.setOption(option, true)
      }
    }
  }
}
</script>
