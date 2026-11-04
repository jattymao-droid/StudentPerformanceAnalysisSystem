<template>
  <div v-if="visible" class="spas-verdict" :class="'level-' + level">
    <div class="spas-verdict__main">
      <div class="spas-verdict__badge">{{ levelLabel }}</div>
      <div class="spas-verdict__text">
        <div class="spas-verdict__title">{{ title }}</div>
        <div v-if="subtitle" class="spas-verdict__sub">{{ subtitle }}</div>
      </div>
      <div v-if="$slots.actions" class="spas-verdict__actions">
        <slot name="actions" />
      </div>
    </div>
    <div v-if="metrics && metrics.length" class="spas-verdict__metrics">
      <div
        v-for="m in metrics"
        :key="m.key"
        class="spas-verdict__metric"
        :class="'tone-' + (m.tone || 'blue')"
      >
        <div class="spas-verdict__metric-label">{{ m.label }}</div>
        <div class="spas-verdict__metric-value">{{ m.value }}</div>
        <div v-if="m.bar != null" class="spas-verdict__bar">
          <div class="spas-verdict__bar-fill" :style="{ width: barWidth(m.bar) }" />
        </div>
        <div v-if="m.hint" class="spas-verdict__metric-hint">{{ m.hint }}</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SpasAnalysisVerdict',
  props: {
    visible: { type: Boolean, default: true },
    level: { type: String, default: 'ok' },
    title: { type: String, default: '' },
    subtitle: { type: String, default: '' },
    metrics: { type: Array, default: () => [] }
  },
  computed: {
    levelLabel() {
      const map = {
        ok: String.fromCharCode(25972,20307,33391,22909),
        watch: String.fromCharCode(38656,20851,27880),
        weak: String.fromCharCode(26377,34180,24369),
        severe: String.fromCharCode(20248,20808,24178,39044),
        empty: String.fromCharCode(25968,25454,19981,36275),
        blocked: String.fromCharCode(26242,19981,23450,32423)
      }
      return map[this.level] || String.fromCharCode(32467,35770)
    }
  },
  methods: {
    barWidth(v) {
      const n = Number(v)
      if (isNaN(n) || n < 0) return '0%'
      const pct = n <= 1 ? n * 100 : n
      return Math.max(0, Math.min(100, pct)).toFixed(1) + '%'
    }
  }
}
</script>

<style scoped>
.spas-verdict {
  border-radius: 14px;
  border: 1px solid #E8EDF5;
  background: #fff;
  padding: 14px 16px 12px;
  margin-bottom: 12px;
  box-shadow: 0 2px 8px rgba(36, 66, 237, 0.05), 0 8px 20px rgba(30, 41, 59, 0.04);
}
.spas-verdict__main {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  flex-wrap: wrap;
}
.spas-verdict__badge {
  flex: 0 0 auto;
  padding: 6px 12px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.02em;
  line-height: 1.2;
  color: #fff;
  background: #64748B;
}
.level-ok .spas-verdict__badge { background: #10B981; }
.level-watch .spas-verdict__badge { background: #CA8A04; }
.level-weak .spas-verdict__badge { background: #D97706; }
.level-severe .spas-verdict__badge { background: #FF5A5F; }
.level-empty .spas-verdict__badge { background: #94A3B8; }
.level-blocked .spas-verdict__badge { background: #DC2626; }

.level-ok { border-color: rgba(16, 185, 129, 0.35); background: linear-gradient(180deg, #F0FDF9 0%, #fff 55%); }
.level-watch { border-color: rgba(202, 138, 4, 0.35); background: linear-gradient(180deg, #FFFBEB 0%, #fff 55%); }
.level-weak { border-color: rgba(217, 119, 6, 0.35); background: linear-gradient(180deg, #FFF7ED 0%, #fff 55%); }
.level-severe { border-color: rgba(255, 90, 95, 0.35); background: linear-gradient(180deg, #FEF2F2 0%, #fff 55%); }
.level-empty { border-color: #E2E8F0; }
.level-blocked { border-color: rgba(220, 38, 38, 0.35); background: linear-gradient(180deg, #FEF2F2 0%, #fff 55%); }

.spas-verdict__text {
  flex: 1 1 220px;
  min-width: 0;
}
.spas-verdict__title {
  font-size: 16px;
  font-weight: 700;
  color: #0F172A;
  line-height: 1.35;
}
.spas-verdict__sub {
  margin-top: 4px;
  font-size: 13px;
  color: #64748B;
  line-height: 1.45;
}
.spas-verdict__actions {
  flex: 0 0 auto;
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  align-items: center;
}
.spas-verdict__metrics {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 10px;
  margin-top: 12px;
}
.spas-verdict__metric {
  background: rgba(255, 255, 255, 0.85);
  border: 1px solid #E8EDF5;
  border-radius: 10px;
  padding: 10px 12px;
  border-left: 3px solid #2442ED;
}
.spas-verdict__metric.tone-green { border-left-color: #10B981; }
.spas-verdict__metric.tone-orange { border-left-color: #D97706; }
.spas-verdict__metric.tone-red { border-left-color: #FF5A5F; }
.spas-verdict__metric.tone-purple { border-left-color: #0E7490; }
.spas-verdict__metric-label {
  font-size: 12px;
  color: #64748B;
  font-weight: 600;
}
.spas-verdict__metric-value {
  margin-top: 4px;
  font-size: 22px;
  font-weight: 700;
  color: #0F172A;
  font-variant-numeric: tabular-nums;
  line-height: 1.15;
}
.spas-verdict__metric-hint {
  margin-top: 2px;
  font-size: 11px;
  color: #94A3B8;
}
.spas-verdict__bar {
  margin-top: 8px;
  height: 6px;
  border-radius: 999px;
  background: #E2E8F0;
  overflow: hidden;
}
.spas-verdict__bar-fill {
  height: 100%;
  border-radius: 999px;
  background: linear-gradient(90deg, #2442ED, #60A5FA);
}
.tone-green .spas-verdict__bar-fill { background: linear-gradient(90deg, #059669, #34D399); }
.tone-orange .spas-verdict__bar-fill { background: linear-gradient(90deg, #D97706, #FBBF24); }
.tone-red .spas-verdict__bar-fill { background: linear-gradient(90deg, #DC2626, #FF5A5F); }
</style>
