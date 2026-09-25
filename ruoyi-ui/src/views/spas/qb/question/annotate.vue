<template>
  <el-dialog
    title="可视标注导入"
    :visible.sync="dialogVisible"
    width="96%"
    top="2vh"
    append-to-body
    :close-on-click-modal="false"
    custom-class="qb-annotate-dialog"
    @close="onClose"
  >
    <div v-if="!sessionId" class="ann-upload">
      <el-form inline size="small">
        <el-form-item label="学科" required>
          <el-select v-model="subjectId" filterable placeholder="请选择学科" style="width:200px">
            <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
          </el-select>
        </el-form-item>
        <el-form-item label="文件">
          <input ref="fileInput" type="file" accept=".pdf,.png,.jpg,.jpeg,image/*" @change="onFileChange" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="uploading" :disabled="!subjectId || !file" @click="doUpload">上传并渲染</el-button>
        </el-form-item>
      </el-form>
      <el-alert type="info" :closable="false" show-icon
        title="支持 PDF / JPG / PNG。框选后自动生成配图预览；可对文字区 OCR（中英），公式/插图以图片为主展示。" />
    </div>

    <div v-else class="ann-workspace">
      <div class="ann-toolbar">
        <el-radio-group v-model="drawRole" size="mini">
          <el-radio-button label="stem">题干</el-radio-button>
          <el-radio-button label="options">选项</el-radio-button>
          <el-radio-button label="answer">答案</el-radio-button>
          <el-radio-button label="analysis">解析</el-radio-button>
          <el-radio-button label="diagram">插图</el-radio-button>
        </el-radio-group>
        <span class="ann-page-nav">
          <el-button size="mini" icon="el-icon-arrow-left" :disabled="pageIndex<=0" @click="pageIndex--" />
          {{ pageIndex + 1 }} / {{ pages.length }}
          <el-button size="mini" icon="el-icon-arrow-right" :disabled="pageIndex>=pages.length-1" @click="pageIndex++" />
        </span>
        <el-button size="mini" type="warning" plain @click="removeSelectedBox" :disabled="selectedBoxIdx<0">删除选中框</el-button>
        <el-button size="mini" type="success" plain :loading="ocrBusy" :disabled="selectedBoxIdx<0" @click="recognizeSelected">识别选中框</el-button>
        <el-button size="mini" type="success" :loading="ocrBusy" @click="recognizeAllTextBoxes">识别本题文字框</el-button>
        <el-button size="mini" @click="addQuestionCard">新建题目卡</el-button>
      </div>
      <div class="ann-main">
        <div class="ann-viewer" ref="viewer">
          <div class="ann-canvas-wrap" @mousedown="onMouseDown" @mousemove="onMouseMove" @mouseup="onMouseUp" @mouseleave="onMouseUp">
            <img v-if="currentPage" :src="pageSrc(currentPage.url)" :style="{ width: displayWidth + 'px' }" @load="onImgLoad" ref="pageImg" draggable="false" />
            <canvas ref="overlay" class="ann-overlay" :width="canvasW" :height="canvasH" :style="{ width: displayWidth + 'px', height: canvasH * (displayWidth / (canvasW||1)) + 'px' }" />
          </div>
        </div>
        <div class="ann-side">
          <div class="ann-cards">
            <el-tag v-for="(q, idx) in questions" :key="idx" :type="idx===activeQ ? 'primary' : 'info'" size="mini" style="margin:2px;cursor:pointer" @click="activeQ=idx; redraw()">Q{{ idx+1 }} ({{ (q.regions||[]).length }})</el-tag>
          </div>
          <el-form v-if="currentQ" size="mini" label-width="64px">
            <el-form-item label="题型">
              <el-select v-model="currentQ.questionType" filterable clearable style="width:100%">
                <el-option v-for="t in typeOptions" :key="t.typeCode" :label="t.typeName" :value="t.typeCode" />
              </el-select>
            </el-form-item>
            <el-form-item label="难度">
              <el-select v-model="currentQ.difficulty" style="width:100%">
                <el-option label="易" value="1" /><el-option label="中" value="2" /><el-option label="难" value="3" />
              </el-select>
            </el-form-item>
            <el-form-item label="题干">
              <el-input type="textarea" :rows="3" v-model="currentQ.content" placeholder="可粘贴、OCR 填入或留空用配图" />
              <div v-if="currentQ.content" class="ann-formula-preview" v-html="formulaHtml(currentQ.content)" />
            </el-form-item>
            <el-form-item v-if="regionPreviews.length" label="配图">
              <div class="ann-preview-grid">
                <div v-for="(pv, pi) in regionPreviews" :key="pi" class="ann-preview-item" @click="selectedBoxIdx=pv.idx; redraw()">
                  <el-image :src="pv.src" :preview-src-list="previewSrcList" fit="contain" class="ann-preview-img" />
                  <div class="ann-preview-meta"><el-tag size="mini" :type="kindTagType(pv.kind)">{{ roleLabel(pv.role) }} / {{ kindLabel(pv.kind) }}</el-tag></div>
                </div>
              </div>
            </el-form-item>
            <el-form-item label="选项">
              <el-input type="textarea" :rows="2" v-model="currentQ.options" />
              <div v-if="currentQ.options" class="ann-formula-preview" v-html="formulaHtml(currentQ.options)" />
            </el-form-item>
            <el-form-item label="答案">
              <el-input v-model="currentQ.correctAnswer" />
              <div v-if="currentQ.correctAnswer" class="ann-formula-preview" v-html="formulaHtml(currentQ.correctAnswer)" />
            </el-form-item>
            <el-form-item label="解析">
              <el-input type="textarea" :rows="2" v-model="currentQ.analysis" />
              <div v-if="currentQ.analysis" class="ann-formula-preview" v-html="formulaHtml(currentQ.analysis)" />
            </el-form-item>
            <el-form-item label="知识点">
              <el-button size="mini" type="primary" plain @click="openKnowledge">树选绑定</el-button>
              <div style="margin-top:6px;font-size:12px;color:#606266">
                <div v-for="k in (currentQ.knowledgeList||[])" :key="k.knowledgeId">{{ k.knowledgeName }} ({{ k.weight }})</div>
                <span v-if="!(currentQ.knowledgeList||[]).length">未绑定</span>
              </div>
            </el-form-item>
            <el-form-item label="框选">
              <el-table :data="currentQ.regions" size="mini" max-height="200" @row-click="onRegionRowClick">
                <el-table-column label="预览" width="56">
                  <template slot-scope="scope">
                    <img v-if="scope.row.previewUrl || scope.row.imageUrl" :src="mediaSrc(scope.row.previewUrl || scope.row.imageUrl)" style="width:40px;height:40px;object-fit:contain;border:1px solid #eee" />
                  </template>
                </el-table-column>
                <el-table-column label="角色" width="58">
                  <template slot-scope="scope">{{ roleLabel(scope.row.role) }}</template>
                </el-table-column>
                <el-table-column label="类型" width="58">
                  <template slot-scope="scope">{{ kindLabel(scope.row.kind) }}</template>
                </el-table-column>
                <el-table-column label="操作" min-width="90">
                  <template slot-scope="scope">
                    <el-button type="text" size="mini" :disabled="ocrBusy" @click.stop="recognizeAt(scope.$index)">识别</el-button>
                    <el-button type="text" size="mini" @click.stop="removeRegion(scope.$index)">删</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>
    <div slot="footer">
      <el-button type="primary" :loading="saving" :disabled="!sessionId || !questions.length" @click="doCommit">确认入库</el-button>
      <el-button @click="dialogVisible=false">关闭</el-button>
    </div>
    <el-dialog title="选择知识点" :visible.sync="kpOpen" width="480px" append-to-body>
      <el-tree ref="kpTree" :data="knowledgeTree" show-checkbox node-key="knowledgeId" :props="{ label: 'knowledgeName', children: 'children', disabled: 'disabled' }" default-expand-all style="max-height:360px;overflow:auto" />
      <div slot="footer">
        <el-button type="primary" @click="confirmKp">确定</el-button>
        <el-button @click="kpOpen=false">取消</el-button>
      </div>
    </el-dialog>
  </el-dialog>
</template>

<script>
import { uploadAnnotatePaper, commitAnnotatePaper, recognizeAnnotateRegion, polishQbFormula } from '@/api/spas/qb/question'
import { cropPageToDataUrl, recognizeImage, renderFormulaHtml, terminateOcrWorker, cleanupOcrText } from '@/utils/qbFormula'
import { optionselectQuestionType } from '@/api/spas/questionType'
import { treeKnowledge } from '@/api/spas/knowledge'

const ROLE_COLOR = {
  stem: 'rgba(64,158,255,0.35)',
  options: 'rgba(103,194,58,0.35)',
  answer: 'rgba(230,162,60,0.35)',
  analysis: 'rgba(144,147,153,0.35)',
  diagram: 'rgba(245,108,108,0.35)'
}

export default {
  name: 'SpasQbAnnotate',
  props: {
    open: { type: Boolean, default: false },
    subjectOptions: { type: Array, default: () => [] },
    defaultSubjectId: { type: [Number, String], default: undefined }
  },
  data() {
    return {
      dialogVisible: false,
      subjectId: undefined,
      file: null,
      uploading: false,
      saving: false,
      ocrBusy: false,
      sessionId: null,
      pages: [],
      pageIndex: 0,
      drawRole: 'stem',
      questions: [],
      activeQ: 0,
      typeOptions: [],
      displayWidth: 720,
      canvasW: 0,
      canvasH: 0,
      drawing: false,
      startX: 0,
      startY: 0,
      curBox: null,
      selectedBoxIdx: -1,
      kpOpen: false,
      knowledgeTree: []
    }
  },
  computed: {
    currentPage() { return this.pages[this.pageIndex] || null },
    currentQ() { return this.questions[this.activeQ] || null },
    regionPreviews() {
      const q = this.currentQ
      if (!q || !q.regions) return []
      return q.regions.map((r, idx) => ({
        idx, role: r.role, kind: r.kind || 'text',
        src: this.mediaSrc(r.previewUrl || r.imageUrl)
      })).filter(p => p.src)
    },
    previewSrcList() { return this.regionPreviews.map(p => p.src) }
  },
  watch: {
    open(v) { this.dialogVisible = v; if (v) this.resetSession() },
    dialogVisible(v) { this.$emit('update:open', v) },
    pageIndex() { this.$nextTick(() => this.redraw()) },
    activeQ() { this.selectedBoxIdx = -1; this.redraw() },
    subjectId(v) { if (v) this.loadTypes(v) }
  },
  methods: {
    pageSrc(url) {
      if (!url) return ''
      if (url.indexOf('http') === 0) return url
      return process.env.VUE_APP_BASE_API + url
    },
    mediaSrc(url) {
      if (!url) return ''
      if (url.indexOf('http') === 0 || url.indexOf('data:') === 0) return url
      return process.env.VUE_APP_BASE_API + url
    },
    formulaHtml(text) { return renderFormulaHtml(text) },
    roleLabel(role) {
      return ({ stem: '题干', options: '选项', answer: '答案', analysis: '解析', diagram: '插图' })[role] || role
    },
    kindLabel(kind) {
      return ({ text: '文字', formula: '公式', diagram: '配图' })[kind] || (kind || '文字')
    },
    kindTagType(kind) {
      if (kind === 'diagram') return 'danger'
      if (kind === 'formula') return 'warning'
      return 'success'
    },
    resetSession() {
      this.sessionId = null
      this.pages = []
      this.pageIndex = 0
      this.questions = []
      this.activeQ = 0
      this.file = null
      this.subjectId = this.defaultSubjectId || undefined
      if (this.$refs.fileInput) this.$refs.fileInput.value = ''
      if (this.subjectId) this.loadTypes(this.subjectId)
    },
    onClose() { terminateOcrWorker(); this.$emit('update:open', false) },
    onFileChange(e) {
      const files = e.target.files
      this.file = files && files.length ? files[0] : null
    },
    loadTypes(subjectId) {
      optionselectQuestionType(subjectId).then(res => { this.typeOptions = res.data || [] })
    },
    doUpload() {
      if (!this.subjectId || !this.file) return
      const fd = new FormData()
      fd.append('file', this.file)
      fd.append('subjectId', this.subjectId)
      this.uploading = true
      uploadAnnotatePaper(fd).then(res => {
        const d = res.data || {}
        this.sessionId = d.sessionId
        this.pages = d.pages || []
        this.pageIndex = 0
        this.questions = [this.newCard()]
        this.activeQ = 0
        this.$modal.msgSuccess('已渲染 ' + this.pages.length + ' 页')
        this.$nextTick(() => this.fitWidth())
      }).finally(() => { this.uploading = false })
    },
    newCard() {
      return { content: '', options: '', correctAnswer: '', analysis: '', questionType: 'single', difficulty: '2', regions: [], knowledgeList: [] }
    },
    addQuestionCard() { this.questions.push(this.newCard()); this.activeQ = this.questions.length - 1 },
    fitWidth() {
      const el = this.$refs.viewer
      if (el) this.displayWidth = Math.max(480, el.clientWidth - 16)
      this.redraw()
    },
    onImgLoad() {
      const img = this.$refs.pageImg
      if (!img) return
      this.canvasW = img.naturalWidth
      this.canvasH = img.naturalHeight
      this.$nextTick(() => this.redraw())
    },
    scale() { return this.canvasW ? (this.displayWidth / this.canvasW) : 1 },
    redraw() {
      const canvas = this.$refs.overlay
      if (!canvas || !this.canvasW) return
      canvas.width = this.canvasW
      canvas.height = this.canvasH
      const ctx = canvas.getContext('2d')
      ctx.clearRect(0, 0, this.canvasW, this.canvasH)
      const pageNo = this.pageIndex + 1
      const q = this.currentQ
      if (q) {
        (q.regions || []).forEach((r, idx) => {
          if (r.pageNo !== pageNo) return
          const color = ROLE_COLOR[r.role] || 'rgba(64,158,255,0.3)'
          ctx.fillStyle = color
          ctx.strokeStyle = idx === this.selectedBoxIdx ? '#409EFF' : '#303133'
          ctx.lineWidth = idx === this.selectedBoxIdx ? 3 : 1
          const x = r.x * this.canvasW
          const y = r.y * this.canvasH
          const w = r.w * this.canvasW
          const h = r.h * this.canvasH
          ctx.fillRect(x, y, w, h)
          ctx.strokeRect(x, y, w, h)
          ctx.fillStyle = '#303133'
          ctx.font = '16px sans-serif'
          ctx.fillText(r.role, x + 4, y + 18)
        })
      }
      if (this.curBox) {
        ctx.strokeStyle = '#409EFF'
        ctx.lineWidth = 2
        ctx.strokeRect(this.curBox.x, this.curBox.y, this.curBox.w, this.curBox.h)
      }
    },
    localPos(e) {
      const canvas = this.$refs.overlay
      const rect = canvas.getBoundingClientRect()
      const s = this.scale()
      return { x: (e.clientX - rect.left) / s, y: (e.clientY - rect.top) / s }
    },
    onMouseDown(e) {
      if (!this.sessionId || !this.currentQ) return
      e.preventDefault()
      const p = this.localPos(e)
      this.drawing = true
      this.startX = p.x
      this.startY = p.y
      this.curBox = { x: p.x, y: p.y, w: 0, h: 0 }
      this.selectedBoxIdx = -1
    },
    onMouseMove(e) {
      if (!this.drawing || !this.curBox) return
      const p = this.localPos(e)
      this.curBox.w = p.x - this.startX
      this.curBox.h = p.y - this.startY
      this.redraw()
    },
    onMouseUp() {
      if (!this.drawing || !this.curBox) { this.drawing = false; return }
      this.drawing = false
      let { x, y, w, h } = this.curBox
      this.curBox = null
      if (w < 0) { x += w; w = -w }
      if (h < 0) { y += h; h = -h }
      if (w < 8 || h < 8 || !this.canvasW) { this.redraw(); return }
      const region = {
        role: this.drawRole,
        pageNo: this.pageIndex + 1,
        x: x / this.canvasW,
        y: y / this.canvasH,
        w: w / this.canvasW,
        h: h / this.canvasH
      }
      this.currentQ.regions.push(region)
      this.selectedBoxIdx = this.currentQ.regions.length - 1
      this.redraw()
      this.enrichRegion(region).then(async () => {
        if (region.role === 'diagram' || region.kind === 'diagram' || region.kind === 'formula') {
          return this.attachRegionAsImage(region)
        }
        try {
          const r = await this.ocrRegion(region)
          if (r && r.asImage) this.attachRegionAsImage(region)
          else if (r && r.text) await this.applyOcrToField(region.role, r.text)
        } catch (e) { /* ignore auto-ocr errors */ }
      })
    },
    onRegionRowClick(row) {
      this.selectedBoxIdx = this.currentQ.regions.indexOf(row)
      if (row.pageNo) this.pageIndex = row.pageNo - 1
      this.redraw()
    },
    removeSelectedBox() {
      if (this.selectedBoxIdx < 0 || !this.currentQ) return
      this.currentQ.regions.splice(this.selectedBoxIdx, 1)
      this.selectedBoxIdx = -1
      this.redraw()
    },
    removeRegion(idx) {
      this.currentQ.regions.splice(idx, 1)
      this.selectedBoxIdx = -1
      this.redraw()
    },
    buildLocalPreview(region) {
      const img = this.$refs.pageImg
      if (!img || !this.canvasW) return ''
      if (region.pageNo !== this.pageIndex + 1) return ''
      return cropPageToDataUrl(img, region, this.canvasW, this.canvasH)
    },
    async enrichRegion(region) {
      const local = this.buildLocalPreview(region)
      if (local) this.$set(region, 'previewUrl', local)
      try {
        const res = await recognizeAnnotateRegion({
          sessionId: this.sessionId,
          pageNo: region.pageNo,
          x: region.x, y: region.y, w: region.w, h: region.h,
          role: region.role
        })
        const d = res.data || {}
        if (d.imageUrl) this.$set(region, 'imageUrl', d.imageUrl)
        if (d.kind) this.$set(region, 'kind', d.kind)
        if (d.hint) this.$set(region, 'hint', d.hint)
      } catch (e) {
        if (!region.kind) this.$set(region, 'kind', region.role === 'diagram' ? 'diagram' : 'text')
      }
    },
    attachRegionAsImage(region) {
      if (!region || !this.currentQ) return
      const url = region.imageUrl || ""
      const src = url || region.previewUrl || ""
      if (!src) return
      const md = "![公式](" + (url || src) + ")"
      const role = region.role || "stem"
      if (role === "stem") {
        const cur = this.currentQ.content || ""
        if (url && cur.indexOf(url) >= 0) return
        this.currentQ.content = cur ? (cur + "\n" + md) : md
        if (url && !this.currentQ.stemImage) this.$set(this.currentQ, "stemImage", url)
      } else if (role === "analysis") {
        const cur = this.currentQ.analysis || ""
        this.currentQ.analysis = cur ? (cur + "\n" + md) : md
      }
    },
    async applyOcrToField(role, text) {
      if (!text || !this.currentQ) return
      let cleaned = cleanupOcrText(text || '')
      if (role === 'stem' || role === 'analysis') {
        try {
          const res = await polishQbFormula({ content: cleaned })
          const d = res.data || {}
          if (d.content) cleaned = d.content
        } catch (e) { /* keep cleaned */ }
      }
      const q = this.currentQ
      if (role === 'stem') q.content = q.content ? (q.content + '\n' + cleaned) : cleaned
      else if (role === 'options') q.options = q.options ? (q.options + '\n' + cleaned) : cleaned
      else if (role === 'answer') q.correctAnswer = q.correctAnswer ? (q.correctAnswer + ' ' + cleaned) : cleaned
      else if (role === 'analysis') q.analysis = q.analysis ? (q.analysis + '\n' + cleaned) : cleaned
    },
    async ocrRegion(region) {
      if (!region.previewUrl && !region.imageUrl) await this.enrichRegion(region)
      const imgSrc = region.previewUrl || this.mediaSrc(region.imageUrl)
      if (!imgSrc) throw new Error('no preview')
      const kind = region.kind || (region.role === 'diagram' ? 'diagram' : 'text')
      if (kind === 'diagram' || region.role === 'diagram' || kind === 'formula' || region.role === 'formula') {
        return { skipped: true, asImage: true, kind }
      }
      const text = await recognizeImage(imgSrc)
      return { text, kind }
    },
    async recognizeAt(idx) {
      const region = this.currentQ && this.currentQ.regions[idx]
      if (!region) return
      this.ocrBusy = true
      this.selectedBoxIdx = idx
      try {
        await this.enrichRegion(region)
        const r = await this.ocrRegion(region)
        if (r.skipped || r.asImage) {
          this.attachRegionAsImage(region)
          this.$modal.msgSuccess('公式/配图已以图片保留')
        } else if (r.text) { await this.applyOcrToField(region.role, r.text); this.$modal.msgSuccess('已识别并填入') }
        else this.$modal.msgWarning('未识别到文字')
      } catch (e) {
        this.$modal.msgError('识别失败: ' + (e.message || e))
      } finally { this.ocrBusy = false }
    },
    recognizeSelected() { if (this.selectedBoxIdx >= 0) this.recognizeAt(this.selectedBoxIdx) },
    async recognizeAllTextBoxes() {
      if (!this.currentQ || !this.currentQ.regions.length) return
      this.ocrBusy = true
      let n = 0
      try {
        for (let i = 0; i < this.currentQ.regions.length; i++) {
          const region = this.currentQ.regions[i]
          await this.enrichRegion(region)
          if (region.role === 'diagram' || region.kind === 'diagram' || region.kind === 'formula' || region.role === 'formula') {
            this.attachRegionAsImage(region)
            continue
          }
          const r = await this.ocrRegion(region)
          if (r.text) { await this.applyOcrToField(region.role, r.text); n++ }
        }
        this.$modal.msgSuccess('已识别 ' + n + ' 个文字区')
      } catch (e) {
        this.$modal.msgError('批量识别中断: ' + (e.message || e))
      } finally { this.ocrBusy = false }
    },
    openKnowledge() {
      if (!this.subjectId) { this.$modal.msgWarning('请先选择学科'); return }
      treeKnowledge(this.subjectId).then(res => {
        this.knowledgeTree = this.markChapterDisabled(res.data || [])
        this.kpOpen = true
        this.$nextTick(() => {
          const keys = (this.currentQ.knowledgeList || []).map(k => k.knowledgeId)
          this.$refs.kpTree && this.$refs.kpTree.setCheckedKeys(keys)
        })
      })
    },
    markChapterDisabled(nodes) {
      return (nodes || []).map(n => {
        const item = Object.assign({}, n)
        const type = String(n.nodeType || '')
        item.disabled = type === '1' || type === '0'
        if (n.children && n.children.length) item.children = this.markChapterDisabled(n.children)
        return item
      })
    },
    collectLeafMap(nodes, map) {
      ;(nodes || []).forEach(n => {
        const type = String(n.nodeType || '')
        if (type === '2' || (!n.children || !n.children.length)) map[n.knowledgeId] = n.knowledgeName
        if (n.children && n.children.length) this.collectLeafMap(n.children, map)
      })
    },
    confirmKp() {
      const checked = (this.$refs.kpTree && this.$refs.kpTree.getCheckedKeys(true)) || []
      const nameMap = {}
      this.collectLeafMap(this.knowledgeTree, nameMap)
      const n = checked.length || 1
      this.currentQ.knowledgeList = checked.map((id, idx) => ({
        knowledgeId: id,
        knowledgeName: nameMap[id] || String(id),
        weight: Number((1 / n).toFixed(2)),
        isPrimary: idx === 0 ? '1' : '0'
      }))
      this.kpOpen = false
    },
    doCommit() {
      const payload = {
        sessionId: this.sessionId,
        subjectId: this.subjectId,
        questions: this.questions.filter(q => (q.regions && q.regions.length) || (q.content || '').trim())
      }
      if (!payload.questions.length) { this.$modal.msgWarning('请至少框选或填写一道题'); return }
      this.saving = true
      commitAnnotatePaper(payload).then(res => {
        const d = res.data || {}
        this.$modal.msgSuccess('入库 ' + (d.inserted || 0) + ' 题，失败 ' + (d.failed || 0))
        this.dialogVisible = false
        this.$emit('success')
      }).finally(() => { this.saving = false })
    }
  }
}
</script>

<style scoped>
.ann-upload { padding: 8px 0 16px; }
.ann-workspace { display: flex; flex-direction: column; height: 78vh; }
.ann-toolbar { display: flex; align-items: center; gap: 12px; margin-bottom: 8px; flex-wrap: wrap; }
.ann-page-nav { display: inline-flex; align-items: center; gap: 6px; }
.ann-main { display: flex; flex: 1; min-height: 0; gap: 12px; }
.ann-viewer { flex: 1; overflow: auto; background: #f5f7fa; border: 1px solid #e4e7ed; border-radius: 4px; padding: 8px; }
.ann-canvas-wrap { position: relative; display: inline-block; user-select: none; }
.ann-overlay { position: absolute; left: 0; top: 0; cursor: crosshair; }
.ann-side { width: 360px; overflow: auto; border: 1px solid #e4e7ed; border-radius: 4px; padding: 8px; background: #fff; }
.ann-cards { margin-bottom: 8px; }
.ann-formula-preview { margin-top: 6px; padding: 6px 8px; background: #fafafa; border: 1px dashed #dcdfe6; border-radius: 4px; font-size: 13px; line-height: 1.6; }
.ann-preview-grid { display: flex; flex-wrap: wrap; gap: 8px; }
.ann-preview-item { width: 96px; cursor: pointer; }
.ann-preview-img { width: 96px; height: 72px; border: 1px solid #ebeef5; background: #fff; }
.ann-preview-meta { margin-top: 2px; }
</style>
