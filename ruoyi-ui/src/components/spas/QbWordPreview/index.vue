<template>
  <div class="qb-word-wrap">
    <div class="qb-word-toolbar">
      <span class="qb-word-title">{{ title || fileName || 'Document' }}</span>
      <div class="qb-word-toolbar-right">
        <span class="qb-word-tip">{{ tipText }}</span>
        <button
          v-if="allowSelect"
          type="button"
          class="qb-select-btn"
          :class="{ active: selectMode }"
          @click="toggleSelectMode"
        >{{ selectMode ? '退出框选' : '框选题干' }}</button>
      </div>
    </div>
    <div
      class="qb-word-stage"
      ref="stage"
      :class="{ 'is-selecting': selectMode }"
      @mousedown="onSelectDown"
      @mousemove="onSelectMove"
      @mouseup="onSelectUp"
      @mouseleave="onSelectUp"
    >
      <div v-if="loading" class="qb-word-loading">Loading...</div>
      <div v-if="error" class="qb-word-error">{{ error }}</div>
      <div ref="host" class="qb-word-host" v-show="!loading && !error"></div>
      <div
        v-if="selectMode && (drawing || selectBox)"
        class="qb-select-layer"
        :style="selectLayerStyle"
      >
        <div v-if="selectBox" class="qb-select-rect" :style="selectBoxStyle" />
      </div>
    </div>
  </div>
</template>

<script>
import { renderAsync } from 'docx-preview'

export default {
  name: 'QbWordPreview',
  props: {
    source: { default: null },
    fileName: { type: String, default: '' },
    title: { type: String, default: '' },
    allowSelect: { type: Boolean, default: true },
    selectMode: { type: Boolean, default: false }
  },
  data() {
    return {
      loading: false,
      error: '',
      hitEl: null,
      drawing: false,
      startX: 0,
      startY: 0,
      selectBox: null,
      overlayW: 0,
      overlayH: 0
    }
  },
  computed: {
    tipText() {
      if (this.selectMode) return '在左侧拖拽框选区域，松开后写入右侧当前题目'
      return '点击右侧题目可定位；可开启「框选题干」划定区域'
    },
    selectLayerStyle() {
      return {
        width: (this.overlayW || 0) + 'px',
        height: (this.overlayH || 0) + 'px'
      }
    },
    selectBoxStyle() {
      const b = this.selectBox
      if (!b) return {}
      return {
        left: b.x + 'px',
        top: b.y + 'px',
        width: b.w + 'px',
        height: b.h + 'px'
      }
    }
  },
  watch: {
    source: {
      immediate: true,
      handler(v) {
        if (v) this.render(v)
        else this.clear()
      }
    },
    selectMode(v) {
      if (!v) {
        this.drawing = false
        this.selectBox = null
        this.clearRegionHits()
      } else {
        this.$nextTick(() => this.refreshOverlaySize())
      }
    }
  },
  beforeDestroy() {
    this.clearHit()
    this.clearRegionHits()
    this.clear()
  },
  methods: {
    toggleSelectMode() {
      this.$emit('update:selectMode', !this.selectMode)
    },
    clear() {
      const host = this.$refs.host
      if (host) host.innerHTML = ''
      this.error = ''
      this.loading = false
      this.selectBox = null
      this.drawing = false
    },
    clearHit() {
      if (this.hitEl) {
        this.hitEl.classList.remove('qb-docx-locate-hit')
        this.hitEl = null
      }
      const host = this.$refs.host
      if (host) {
        host.querySelectorAll('.qb-docx-locate-hit').forEach(el => {
          el.classList.remove('qb-docx-locate-hit')
        })
      }
    },
    clearRegionHits() {
      const host = this.$refs.host
      if (!host) return
      host.querySelectorAll('.qb-docx-region-hit').forEach(el => {
        el.classList.remove('qb-docx-region-hit')
      })
    },
    refreshOverlaySize() {
      const host = this.$refs.host
      const stage = this.$refs.stage
      if (!host || !stage) return
      this.overlayW = Math.max(host.scrollWidth, stage.scrollWidth, stage.clientWidth)
      this.overlayH = Math.max(host.scrollHeight, stage.scrollHeight, stage.clientHeight)
    },
    async toBuffer(src) {
      if (!src) return null
      if (src instanceof ArrayBuffer) return src
      if (src.arrayBuffer) return await src.arrayBuffer()
      return null
    },
    async render(src) {
      this.loading = true
      this.error = ''
      this.clearHit()
      this.clearRegionHits()
      this.selectBox = null
      await this.$nextTick()
      const host = this.$refs.host
      if (!host) {
        this.loading = false
        return
      }
      host.innerHTML = ''
      try {
        const buf = await this.toBuffer(src)
        if (!buf) {
          this.error = 'empty file'
          return
        }
        await renderAsync(buf, host, null, {
          className: 'qb-docx',
          inWrapper: true,
          ignoreWidth: false,
          ignoreHeight: false,
          breakPages: true,
          renderHeaders: true,
          renderFooters: true,
          renderFootnotes: true,
          useBase64URL: true,
          experimental: true
        })
        this.$nextTick(() => this.refreshOverlaySize())
        this.$emit('rendered')
      } catch (e) {
        this.error = (e && e.message) || 'render failed'
        this.$emit('error', e)
      } finally {
        this.loading = false
      }
    },
    normalizeText(s) {
      return String(s || '')
        .replace(/\[\[IMG:\d+\]\]/gi, '')
        .replace(/\s+/g, '')
        .replace(/[\u3000]/g, '')
        .toLowerCase()
    },
    contentPos(e) {
      const stage = this.$refs.stage
      if (!stage) return { x: 0, y: 0 }
      const r = stage.getBoundingClientRect()
      return {
        x: e.clientX - r.left + stage.scrollLeft,
        y: e.clientY - r.top + stage.scrollTop
      }
    },
    elContentBox(el) {
      const stage = this.$refs.stage
      if (!stage || !el) return null
      const er = el.getBoundingClientRect()
      const sr = stage.getBoundingClientRect()
      return {
        left: er.left - sr.left + stage.scrollLeft,
        top: er.top - sr.top + stage.scrollTop,
        right: er.right - sr.left + stage.scrollLeft,
        bottom: er.bottom - sr.top + stage.scrollTop
      }
    },
    overlapRatio(a, b) {
      const ix = Math.max(0, Math.min(a.right, b.right) - Math.max(a.left, b.left))
      const iy = Math.max(0, Math.min(a.bottom, b.bottom) - Math.max(a.top, b.top))
      const inter = ix * iy
      const area = Math.max(1, (a.right - a.left) * (a.bottom - a.top))
      return inter / area
    },
    normalizeBox(x0, y0, x1, y1) {
      const x = Math.min(x0, x1)
      const y = Math.min(y0, y1)
      const w = Math.abs(x1 - x0)
      const h = Math.abs(y1 - y0)
      return { x, y, w, h, left: x, top: y, right: x + w, bottom: y + h }
    },
    onSelectDown(e) {
      if (!this.selectMode || this.loading || this.error) return
      if (e.button !== 0) return
      e.preventDefault()
      this.refreshOverlaySize()
      const p = this.contentPos(e)
      this.drawing = true
      this.startX = p.x
      this.startY = p.y
      this.selectBox = { x: p.x, y: p.y, w: 0, h: 0 }
      this.clearHit()
      this.clearRegionHits()
    },
    onSelectMove(e) {
      if (!this.drawing || !this.selectMode) return
      const p = this.contentPos(e)
      const box = this.normalizeBox(this.startX, this.startY, p.x, p.y)
      this.selectBox = { x: box.x, y: box.y, w: box.w, h: box.h }
    },
    onSelectUp(e) {
      if (!this.drawing) return
      this.drawing = false
      if (!this.selectMode || !this.selectBox) return
      const p = e && e.clientX != null ? this.contentPos(e) : {
        x: this.selectBox.x + this.selectBox.w,
        y: this.selectBox.y + this.selectBox.h
      }
      const box = this.normalizeBox(this.startX, this.startY, p.x, p.y)
      this.selectBox = { x: box.x, y: box.y, w: box.w, h: box.h }
      if (box.w < 12 || box.h < 12) {
        this.selectBox = null
        return
      }
      const payload = this.extractRegion(box)
      if (!payload || (!payload.text && !(payload.imageUrls && payload.imageUrls.length))) {
        this.$emit('region-empty')
        return
      }
      this.$emit('region-select', payload)
    },
    extractRegion(box) {
      const host = this.$refs.host
      if (!host) return null
      const sel = { left: box.left, top: box.top, right: box.right, bottom: box.bottom }
      const textEls = Array.from(host.querySelectorAll('p, li, h1, h2, h3, h4, td')).filter(el => {
        return el.querySelectorAll('p, li').length === 0
      })
      const hitText = []
      const hitNodes = []
      for (const el of textEls) {
        const eb = this.elContentBox(el)
        if (!eb) continue
        const ratio = this.overlapRatio(eb, sel)
        if (ratio < 0.28) continue
        const raw = (el.innerText || el.textContent || '').replace(/\u00a0/g, ' ').trim()
        if (!raw) continue
        hitText.push(raw)
        hitNodes.push(el)
      }
      const imgs = Array.from(host.querySelectorAll('img'))
      const imageUrls = []
      const seen = {}
      for (const img of imgs) {
        const eb = this.elContentBox(img)
        if (!eb) continue
        const ratio = this.overlapRatio(eb, sel)
        if (ratio < 0.18) continue
        const src = img.getAttribute('src') || ''
        if (!src || seen[src]) continue
        seen[src] = true
        imageUrls.push(src)
        hitNodes.push(img)
      }
      hitNodes.forEach(el => el.classList.add('qb-docx-region-hit'))
      const text = hitText.join('\n').trim()
      return {
        text,
        imageUrls,
        box: { x: box.x, y: box.y, w: box.w, h: box.h }
      }
    },
    /**
     * Scroll left preview to the paragraph matching questionNo / content.
     * @returns {boolean} whether a hit was found
     */
    locateQuestion(item) {
      const host = this.$refs.host
      const stage = this.$refs.stage
      if (!host || this.loading) return false
      if (this.selectMode) return false
      this.clearHit()

      const no = item && item.questionNo != null ? String(item.questionNo).trim() : ''
      const content = item && item.content ? String(item.content) : ''
      const firstLine = content.split(/\r?\n/).map(s => s.trim()).filter(Boolean)[0] || ''
      let needle = this.normalizeText(firstLine)
      if (needle.length > 48) needle = needle.slice(0, 48)

      const blocks = Array.from(host.querySelectorAll('p, li, h1, h2, h3, h4, td')).filter(el => {
        return el.querySelectorAll('p, li').length === 0
      })

      const escNo = no ? no.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') : ''
      const noAtStart = escNo
        ? new RegExp('^\\s*(?:\\u7b2c)?' + escNo + '(?:\\u9898)?\\s*[\\.\\u3001\\uff0e\\)\\uff09]')
        : null

      const scored = []
      for (const el of blocks) {
        const raw = (el.innerText || el.textContent || '').trim()
        if (!raw || raw.length < 2) continue
        if (/^[A-Ha-h][\.\uFF0E\u3001\)]\s*/.test(raw) && raw.length < 80) continue
        const norm = this.normalizeText(raw)
        if (!norm) continue

        let score = 0
        const startsWithNo = noAtStart ? noAtStart.test(raw) : false
        if (startsWithNo) score += 120

        if (needle && needle.length >= 8) {
          if (norm.indexOf(needle) === 0) {
            score += 100 + Math.min(needle.length, 48)
          } else if (norm.indexOf(needle) >= 0) {
            const idx = norm.indexOf(needle)
            score += (idx < 8 ? 70 : 20) + Math.min(needle.length, 24) * 0.3
          } else if (needle.length >= 16) {
            const head = needle.slice(0, 16)
            if (norm.indexOf(head) === 0) score += 55
            else if (norm.indexOf(head) >= 0 && norm.indexOf(head) < 6) score += 30
          }
        }

        if (score > 0) {
          score += Math.max(0, 20 - Math.floor(norm.length / 80))
          scored.push({ el, score, startsWithNo, len: norm.length })
        }
      }

      if (!scored.length) return false
      scored.sort((a, b) => {
        if (b.score !== a.score) return b.score - a.score
        if (a.startsWithNo !== b.startsWithNo) return a.startsWithNo ? -1 : 1
        return a.len - b.len
      })

      const best = scored[0]
      const second = scored[1]
      if (
        second &&
        !best.startsWithNo &&
        !second.startsWithNo &&
        best.score < 90 &&
        best.score - second.score < 15
      ) {
        return false
      }
      if (best.score < 55) return false
      if (no && !best.startsWithNo && best.score < 100) {
        const withNo = scored.find(s => s.startsWithNo && s.score >= 120)
        if (withNo) return this.applyHit(withNo.el, stage)
        return false
      }
      return this.applyHit(best.el, stage)
    },
    applyHit(best, stage) {
      if (!best) return false
      best.classList.add('qb-docx-locate-hit')
      this.hitEl = best
      if (typeof best.scrollIntoView === 'function') {
        best.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'nearest' })
      } else if (stage) {
        const top = best.offsetTop - stage.clientHeight / 3
        stage.scrollTop = Math.max(0, top)
      }
      return true
    }
  }
}
</script>

<style scoped>
.qb-word-wrap {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 420px;
  background: #c7c7c7;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  overflow: hidden;
}
.qb-word-toolbar {
  flex: 0 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 6px 12px;
  background: #f3f3f3;
  border-bottom: 1px solid #d0d0d0;
  font-size: 12px;
  color: #606266;
  gap: 8px;
}
.qb-word-title {
  font-weight: 600;
  color: #303133;
  max-width: 42%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.qb-word-toolbar-right {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
}
.qb-word-tip {
  color: #909399;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.qb-select-btn {
  flex: 0 0 auto;
  border: 1px solid #dcdfe6;
  background: #fff;
  color: #606266;
  font-size: 12px;
  line-height: 1;
  padding: 5px 10px;
  border-radius: 3px;
  cursor: pointer;
}
.qb-select-btn:hover {
  color: #409eff;
  border-color: #c6e2ff;
  background: #ecf5ff;
}
.qb-select-btn.active {
  color: #fff;
  background: #f56c6c;
  border-color: #f56c6c;
}
.qb-word-stage {
  flex: 1;
  overflow: auto;
  position: relative;
}
.qb-word-stage.is-selecting {
  cursor: crosshair;
  user-select: none;
}
.qb-select-layer {
  position: absolute;
  left: 0;
  top: 0;
  pointer-events: none;
  z-index: 6;
}
.qb-select-rect {
  position: absolute;
  border: 2px solid #f56c6c;
  background: rgba(245, 108, 108, 0.14);
  box-sizing: border-box;
}
.qb-word-loading,
.qb-word-error {
  padding: 40px;
  text-align: center;
  color: #606266;
}
.qb-word-error { color: #f56c6c; }
.qb-word-host {
  padding: 16px 0 32px;
}
</style>

<style>
.qb-word-host .docx-wrapper {
  background: transparent !important;
  padding: 12px 0 !important;
}
.qb-word-host .docx-wrapper > section.docx {
  background: #fff !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.18) !important;
  margin: 12px auto !important;
  box-sizing: border-box;
  position: relative;
  min-height: 297mm;
}
.qb-word-host .docx-wrapper > section.docx::before,
.qb-word-host .docx-wrapper > section.docx::after {
  content: '';
  position: absolute;
  width: 14px;
  height: 14px;
  border-color: #909399;
  border-style: solid;
  opacity: 0.45;
  pointer-events: none;
  z-index: 2;
}
.qb-word-host .docx-wrapper > section.docx::before {
  left: 18px;
  top: 18px;
  border-width: 1px 0 0 1px;
}
.qb-word-host .docx-wrapper > section.docx::after {
  right: 18px;
  bottom: 18px;
  border-width: 0 1px 1px 0;
}
.qb-word-host img {
  max-width: 100%;
  height: auto;
}
.qb-word-host math {
  display: inline-block;
  vertical-align: middle;
  font-family: "Cambria Math", "Times New Roman", serif;
  font-size: 1.08em;
  margin: 0 0.15em;
  line-height: normal;
}
.qb-word-host math * {
  line-height: normal;
}
.qb-word-host mfrac {
  vertical-align: middle;
  margin: 0 0.1em;
}
.qb-word-host mfrac > * {
  font-size: 0.95em;
}
.qb-word-host msup, .qb-word-host msub, .qb-word-host msubsup {
  font-size: 0.85em;
}
.qb-word-host mrow {
  white-space: nowrap;
}
.qb-word-host mi, .qb-word-host mn, .qb-word-host mo {
  font-style: normal;
}
.qb-word-host .qb-docx-locate-hit {
  background: rgba(64, 158, 255, 0.22) !important;
  outline: 2px solid #409eff;
  outline-offset: 2px;
  border-radius: 2px;
  transition: background 0.2s ease, outline-color 0.2s ease;
}
.qb-word-host .qb-docx-region-hit {
  background: rgba(245, 108, 108, 0.16) !important;
  outline: 1px dashed #f56c6c;
  outline-offset: 1px;
}
</style>
