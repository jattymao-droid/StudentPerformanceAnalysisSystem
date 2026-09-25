<template>
  <div class="qb-rich">
    <div v-if="html" class="qb-rich-text" v-html="html" />
    <div v-if="images && images.length" class="qb-rich-imgs">
      <div v-for="(img, i) in images" :key="i" class="qb-rich-img-wrap">
        <div v-if="img.label" class="qb-rich-label">{{ img.label }}</div>
        <el-image
          :src="resolve(img.url)"
          :preview-src-list="previewList"
          fit="contain"
          class="qb-rich-img"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { renderFormulaHtml } from '@/utils/qbFormula'

export default {
  name: 'QbRichContent',
  props: {
    text: { type: String, default: '' },
    content: { type: String, default: '' },
    images: { type: Array, default: () => [] }
  },
  computed: {
    html() {
      return renderFormulaHtml(this.text || this.content)
    },
    previewList() {
      return (this.images || []).map(i => this.resolve(i.url)).filter(Boolean)
    }
  },
  methods: {
    resolve(url) {
      if (!url) return ''
      if (url.indexOf('http') === 0 || url.indexOf('data:') === 0) return url
      return process.env.VUE_APP_BASE_API + url
    }
  }
}
</script>

<style scoped>
.qb-rich-text { line-height: 1.75; word-break: break-word; font-size: 14px; color: #303133; }
.qb-rich-imgs { margin-top: 8px; }
.qb-rich-img-wrap { margin-bottom: 8px; }
.qb-rich-label { font-size: 12px; color: #909399; margin-bottom: 4px; }
.qb-rich-img { max-width: 100%; max-height: 280px; border: 1px solid #ebeef5; border-radius: 4px; background: #fafafa; }
</style>

<style>
.qb-rich-text .katex { font-size: 1.08em; }
.qb-rich-text .katex-display { margin: 0.4em 0; overflow-x: auto; overflow-y: hidden; }
.qb-rich-text .qb-tex-ph { color: #909399; font-size: 12px; }
.qb-rich-text .qb-tex-err { color: #f56c6c; font-size: 12px; }
.import-formula .katex { font-size: 1.05em; }
.import-formula .katex-display { margin: 0.3em 0; }
.qb-rich-text .qb-inline-img { display:block; max-width:100%; max-height:280px; margin:8px 0; border:1px solid #ebeef5; border-radius:4px; }
</style>
