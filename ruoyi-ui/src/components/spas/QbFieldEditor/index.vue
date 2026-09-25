<template>
  <div
    class="qb-field-editor"
    :class="{ 'is-dragover': dragOver }"
    @dragenter.prevent="onDragEnter"
    @dragover.prevent="onDragOver"
    @dragleave.prevent="onDragLeave"
    @drop.prevent="onDrop"
  >
    <div ref="toolbar" class="qb-quill-toolbar">
      <span class="ql-formats">
        <button type="button" class="ql-bold" title="加粗" />
        <button type="button" class="ql-italic" title="斜体" />
        <button type="button" class="ql-underline" title="下划线" />
      </span>
      <span class="ql-formats">
        <button type="button" class="ql-list" value="ordered" title="有序列表" />
        <button type="button" class="ql-list" value="bullet" title="无序列表" />
      </span>
      <span class="ql-formats">
        <button type="button" class="ql-image" title="插入图片" />
        <button type="button" class="ql-formula qb-formula-btn" title="插入公式" />
      </span>
    </div>
    <div class="qb-quick-bar">
      <span class="qb-quick-label">快捷</span>
      <button
        v-for="q in quickFormulas"
        :key="q.latex"
        type="button"
        class="qb-quick-chip"
        :title="q.title"
        @mousedown.prevent
        @click="quickInsert(q.latex)"
        v-html="q.html"
      />
    </div>

    <div class="qb-field-body">
      <div ref="editor" class="qb-quill-editor" :style="{ minHeight: minHeight + 'px' }" />
      <div v-if="livePreview && plainValue" class="qb-field-live">
        <div class="qb-field-live-hd">{{ labels.live }}</div>
        <div class="qb-field-live-body" v-html="liveHtml" />
      </div>
      <div v-if="dragOver" class="qb-field-drop-mask">{{ labels.dropHint }}</div>
    </div>

    <input ref="file" type="file" accept="image/png,image/jpeg,image/jpg,image/gif,image/webp" style="display:none" @change="onFileChange" />

    <el-dialog
      :title="editingFormulaIndex >= 0 ? labels.editFormula : labels.insertFormula"
      :visible.sync="formulaOpen"
      width="720px"
      top="8vh"
      append-to-body
      :close-on-click-modal="false"
      custom-class="qb-formula-dialog"
      @opened="onFormulaOpened"
      @closed="onFormulaClosed"
    >
      <div class="qb-formula-editor">
        <div class="qb-quick-section">
          <div class="qb-quick-hd">{{ labels.oneClick }}</div>
          <div class="qb-quick-grid">
            <button
              v-for="q in panelQuickFormulas"
              :key="'p-' + q.latex"
              type="button"
              class="qb-quick-chip large"
              :title="q.title"
              @click="quickInsertAndClose(q.latex)"
              v-html="q.html"
            />
          </div>
        </div>

        <div class="qb-custom-section">
          <div class="qb-quick-hd">
            <span>{{ labels.customEdit }}</span>
            <el-button type="text" size="mini" icon="el-icon-s-grid" @click="toggleMathKeyboard">
              {{ keyboardVisible ? labels.hideKb : labels.showKb }}
            </el-button>
          </div>
          <div class="qb-mathfield-wrap">
            <math-field
              ref="mathfield"
              class="qb-mathfield"
              math-virtual-keyboard-policy="manual"
            />
          </div>
          <div v-show="keyboardVisible" class="qb-kb-panel">
            <div class="qb-kb-tabs">
              <button
                v-for="tab in kbTabs"
                :key="tab.id"
                type="button"
                class="qb-kb-tab"
                :class="{ active: kbTab === tab.id }"
                @mousedown.prevent
                @click="kbTab = tab.id"
              >{{ tab.label }}</button>
            </div>
            <div class="qb-kb-keys">
              <button
                v-for="(key, idx) in currentKbKeys"
                :key="kbTab + '-' + idx"
                type="button"
                class="qb-kb-key"
                :class="{ action: key.action, wide: key.wide }"
                :title="key.title || key.latex || key.action"
                @mousedown.prevent
                @click="onKbKey(key)"
              >
                <span v-if="key.html" v-html="key.html" />
                <span v-else>{{ key.label }}</span>
              </button>
            </div>
          </div>
          <div class="qb-formula-hint">{{ labels.formulaHint }}</div>
        </div>
      </div>
      <div slot="footer" class="qb-formula-footer">
        <el-button @click="formulaOpen=false">{{ labels.cancel }}</el-button>
        <el-button type="primary" :disabled="!formulaLatex.trim()" @click="confirmFormula">
          {{ editingFormulaIndex >= 0 ? labels.save : labels.insert }}
          <span class="qb-enter-tip">Enter</span>
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import Quill from 'quill'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import katex from 'katex'
import 'katex/dist/katex.min.css'
import 'mathlive'
import { MathfieldElement } from 'mathlive'
import 'mathlive/mathlive-static.css'
import 'mathlive/mathlive-fonts.css'
import { getToken } from '@/utils/auth'
import { renderFormulaHtml, resolveMediaUrl } from '@/utils/qbFormula'
import axios from 'axios'

if (typeof window !== 'undefined') {
  window.katex = katex
}

/** Force MathLive UI (menu / tooltips) to Simplified Chinese */
let mathliveZhApplied = false
function applyMathliveZhLocale() {
  try {
    if (!MathfieldElement || mathliveZhApplied) return
    // Only switch locale. Do NOT replace MathfieldElement.strings —
    // overwriting wiped built-in zh-cn entries and broke the menu popup.
    MathfieldElement.locale = 'zh-cn'
    mathliveZhApplied = true
  } catch (e) { /* ignore */ }
}

applyMathliveZhLocale()

function u(...codes) {
  return String.fromCharCode(...codes)
}

function katexChip(latex) {
  try {
    return katex.renderToString(latex, { throwOnError: false, strict: 'ignore' })
  } catch (e) {
    return latex
  }
}

const QUICK = [
  { title: u(0x5206, 0x6570), latex: '\\frac{a}{b}' },
  { title: u(0x6839, 0x53f7), latex: '\\sqrt{x}' },
  { title: u(0x4e0a, 0x6807), latex: 'x^{2}' },
  { title: u(0x4e0b, 0x6807), latex: 'x_{1}' },
  { title: u(0x6b63, 0x8d1f), latex: '\\pm' },
  { title: u(0x4e58, 0x53f7), latex: '\\times' },
  { title: u(0x89d2, 0x5ea6), latex: '30^{\\circ}' },
  { title: u(0x77e2, 0x91cf), latex: '\\vec{F}' }
]

const PANEL_QUICK = [
  ...QUICK,
  { title: 'sin', latex: '\\sin\\theta' },
  { title: 'cos', latex: '\\cos\\theta' },
  { title: 'pi', latex: '\\pi' },
  { title: 'infty', latex: '\\infty' },
  { title: 'leq', latex: '\\leq' },
  { title: 'geq', latex: '\\geq' },
  { title: 'neq', latex: '\\neq' },
  { title: 'sum', latex: '\\sum_{i=1}^{n}' },
  { title: 'int', latex: '\\int_{a}^{b}' },
  { title: 'lim', latex: '\\lim_{x \\to 0}' },
  { title: 'delta', latex: '\\Delta' },
  { title: 'alpha', latex: '\\alpha' }
].map(q => ({
  ...q,
  html: katexChip(q.latex)
}))

const TOOLBAR_QUICK = QUICK.map(q => ({
  ...q,
  html: katexChip(q.latex)
}))

function k(latex, title) {
  return { latex, title: title || latex, html: katexChip(latex) }
}
function a(action, label, extra) {
  return Object.assign({ action, label }, extra || {})
}

const KB_TABS = [
  {
    id: 'num',
    label: u(0x6570, 0x5b57),
    keys: [
      k('7'), k('8'), k('9'), k('+'), k('-'),
      k('4'), k('5'), k('6'), k('\\times', u(0x4e58)), k('\\div', u(0x9664)),
      k('1'), k('2'), k('3'), k('='), k('\\pm'),
      k('0'), k('.'), k(','), k('('), k(')'),
      a('left', '←'), a('right', '→'), a('backspace', u(0x5220, 0x9664), { wide: true }), a('clear', u(0x6e05, 0x7a7a), { wide: true })
    ]
  },
  {
    id: 'sym',
    label: u(0x7b26, 0x53f7),
    keys: [
      k('\\frac{a}{b}', u(0x5206, 0x6570)), k('\\sqrt{x}', u(0x6839, 0x53f7)), k('\\sqrt[n]{x}', u(0x7acb, 0x65b9, 0x6839)),
      k('x^{2}', u(0x5e73, 0x65b9)), k('x^{n}', u(0x5e42)), k('x_{i}', u(0x4e0b, 0x6807)),
      k('\\leq'), k('\\geq'), k('\\neq'), k('\\approx'), k('\\infty'),
      k('\\times'), k('\\div'), k('\\cdot'), k('\\pm'), k('\\mp'),
      k('\\angle'), k('\\perp'), k('\\parallel'), k('^\\circ', u(0x5ea6)), k('\\%'),
      a('left', '←'), a('right', '→'), a('backspace', u(0x5220, 0x9664), { wide: true }), a('clear', u(0x6e05, 0x7a7a), { wide: true })
    ]
  },
  {
    id: 'greek',
    label: u(0x5e0c, 0x814a),
    keys: [
      k('\\alpha'), k('\\beta'), k('\\gamma'), k('\\delta'), k('\\theta'),
      k('\\lambda'), k('\\mu'), k('\\pi'), k('\\rho'), k('\\sigma'),
      k('\\phi'), k('\\omega'), k('\\Delta'), k('\\Sigma'), k('\\Omega'),
      k('\\vec{a}', u(0x77e2, 0x91cf)), k('\\overline{AB}', u(0x7ebf, 0x6bb5)),
      a('left', '←'), a('right', '→'), a('backspace', u(0x5220, 0x9664), { wide: true }), a('clear', u(0x6e05, 0x7a7a), { wide: true })
    ]
  },
  {
    id: 'fn',
    label: u(0x51fd, 0x6570),
    keys: [
      k('\\sin'), k('\\cos'), k('\\tan'), k('\\cot'), k('\\sec'),
      k('\\arcsin'), k('\\arccos'), k('\\arctan'), k('\\lg'), k('\\ln'),
      k('\\log'), k('\\exp'), k('\\lim_{x \\to 0}'), k('\\sum_{i=1}^{n}'), k('\\int_{a}^{b}'),
      k('\\partial'), k('\\nabla'), k('\\mathrm{d}x'), k('\\binom{n}{k}'), k('\\begin{cases} a \\\\ b \\end{cases}'),
      a('left', '←'), a('right', '→'), a('backspace', u(0x5220, 0x9664), { wide: true }), a('clear', u(0x6e05, 0x7a7a), { wide: true })
    ]
  }
]

const L = {
  insertFormula: u(0x63d2, 0x5165, 0x516c, 0x5f0f),
  editFormula: u(0x7f16, 0x8f91, 0x516c, 0x5f0f),
  oneClick: u(0x5e38, 0x7528, 0xff08, 0x70b9, 0x4e00, 0x4e0b, 0x76f4, 0x63a5, 0x63d2, 0x5165, 0xff09),
  customEdit: u(0x81ea, 0x5b9a, 0x4e49, 0x7f16, 0x8f91),
  showKb: u(0x6253, 0x5f00, 0x865a, 0x62df, 0x952e, 0x76d8),
  hideKb: u(0x6536, 0x8d77, 0x952e, 0x76d8),
  live: u(0x9884, 0x89c8),
  insert: u(0x63d2, 0x5165),
  save: u(0x4fdd, 0x5b58),
  cancel: u(0x53d6, 0x6d88),
  formulaHint: u(0x70b9, 0x51fb, 0x4e0b, 0x65b9, 0x952e, 0x76d8, 0x63d2, 0x5165, 0x7b26, 0x53f7, 0xff1b) + ' Enter ' + u(0x786e, 0x8ba4),
  tip: u(0x5de5, 0x5177, 0x680f, 0x5feb, 0x6377, 0x516c, 0x5f0f, 0x4e00, 0x952e, 0x63d2, 0x5165),
  dropHint: u(0x677e, 0x5f00, 0x4ee5, 0x63d2, 0x5165, 0x56fe, 0x7247),
  imgTooBig: u(0x56fe, 0x7247, 0x8bf7, 0x5c0f, 0x4e8e) + ' 5MB',
  uploadFail: u(0x4e0a, 0x4f20, 0x5931, 0x8d25, 0xff1a, 0x672a, 0x8fd4, 0x56de, 0x5730, 0x5740),
  uploadOk: u(0x56fe, 0x7247, 0x5df2, 0x63d2, 0x5165),
  uploadErr: u(0x914d, 0x56fe, 0x4e0a, 0x4f20, 0x5931, 0x8d25)
}

const MEDIA_BASE = process.env.VUE_APP_BASE_API || ''

function stripMediaBase(url) {
  if (!url) return ''
  let s = String(url)
  if (MEDIA_BASE && s.indexOf(MEDIA_BASE) === 0) s = s.slice(MEDIA_BASE.length)
  return s
}

function plainToDelta(text) {
  const Delta = Quill.import('delta')
  const src = String(text || '').replace(/\r\n/g, '\n').replace(/\r/g, '\n')
  if (!src) return new Delta().insert('\n')
  const re = /(\$\$[\s\S]+?\$\$|\$[^$\n]+\$|!\[[^\]]*\]\([^)]+\)|\[\[IMG:[^\]]+\]\])/g
  const delta = new Delta()
  let last = 0
  let m
  while ((m = re.exec(src)) !== null) {
    if (m.index > last) delta.insert(src.slice(last, m.index))
    const token = m[0]
    if (token.indexOf('![') === 0) {
      const mm = token.match(/^!\[([^\]]*)\]\(([^)]+)\)$/)
      if (mm) delta.insert({ image: resolveMediaUrl(mm[2].trim()) })
    } else if (token.indexOf('[[IMG:') === 0) {
      delta.insert({ image: resolveMediaUrl(token.slice(6, -2).trim()) })
    } else if (token.indexOf('$$') === 0) {
      delta.insert({ formula: token.slice(2, -2) })
    } else if (token.charAt(0) === '$') {
      delta.insert({ formula: token.slice(1, -1) })
    } else {
      delta.insert(token)
    }
    last = m.index + token.length
  }
  if (last < src.length) delta.insert(src.slice(last))
  const ops = delta.ops || []
  const lastOp = ops[ops.length - 1]
  if (!lastOp || typeof lastOp.insert !== 'string' || !lastOp.insert.endsWith('\n')) {
    delta.insert('\n')
  }
  return delta
}

function deltaToPlain(quill) {
  if (!quill) return ''
  let out = ''
  ;(quill.getContents().ops || []).forEach(op => {
    const ins = op.insert
    if (typeof ins === 'string') {
      out += ins
    } else if (ins && typeof ins === 'object') {
      if (ins.formula != null) {
        const latex = String(ins.formula)
        out += latex.indexOf('\n') >= 0 ? ('$$' + latex + '$$') : ('$' + latex + '$')
      } else if (ins.image) {
        out += '\n![](' + stripMediaBase(ins.image) + ')\n'
      }
    }
  })
  return out.replace(/\n{3,}/g, '\n\n').replace(/^\n+|\n+$/g, '')
}

export default {
  name: 'QbFieldEditor',
  props: {
    value: { type: String, default: '' },
    rows: { type: Number, default: 4 },
    placeholder: { type: String, default: '' },
    livePreview: { type: Boolean, default: false },
    pasteAsOcr: { type: Boolean, default: false }
  },
  data() {
    return {
      labels: L,
      quickFormulas: TOOLBAR_QUICK,
      panelQuickFormulas: PANEL_QUICK,
      kbTabs: KB_TABS,
      kbTab: 'num',
      formulaOpen: false,
      formulaLatex: '',
      editingFormulaIndex: -1,
      savedSelection: null,
      keyboardVisible: true,
      uploading: false,
      dragOver: false,
      dragDepth: 0,
      plainValue: '',
      syncing: false,
      quill: null
    }
  },
  computed: {
    minHeight() {
      return Math.max(80, (this.rows || 4) * 24)
    },
    liveHtml() {
      return renderFormulaHtml(this.plainValue || '')
    },
    currentKbKeys() {
      const tab = (this.kbTabs || []).find(t => t.id === this.kbTab)
      return (tab && tab.keys) || []
    }
  },
  watch: {
    value(val) {
      const next = val == null ? '' : String(val)
      if (next === this.plainValue) return
      this.plainValue = next
      this.applyPlainToQuill(next)
    }
  },
  mounted() {
    this.plainValue = this.value || ''
    this.$nextTick(() => this.initQuill())
  },
  beforeDestroy() {
    if (this.quill && this.quill.root) {
      this.quill.root.removeEventListener('paste', this.handlePasteCapture, true)
      this.quill.root.removeEventListener('blur', this.handleBlur, true)
      this.quill.root.removeEventListener('dblclick', this.handleFormulaDblClick, true)
      this.quill.root.removeEventListener('keydown', this.handleEditorKeydown, true)
    }
    this.unbindMathField()
    this.quill = null
  },
  methods: {
    getMathFieldEl() {
      const ref = this.$refs.mathfield
      return ref && (ref.$el || ref)
    },
    readMathLatex() {
      const el = this.getMathFieldEl()
      if (!el) return (this.formulaLatex || '').trim()
      try {
        return String((typeof el.getValue === 'function' ? el.getValue('latex') : el.value) || '').trim()
      } catch (e) {
        return String(el.value || this.formulaLatex || '').trim()
      }
    },
    bindMathField() {
      const el = this.getMathFieldEl()
      if (!el || el._qbMfBound) return
      el._qbMfBound = true
      this._mfInputHandler = () => {
        this.formulaLatex = this.readMathLatex()
      }
      this._mfKeyHandler = (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
          e.preventDefault()
          e.stopPropagation()
          this.confirmFormula()
        }
      }
      el.addEventListener('input', this._mfInputHandler)
      el.addEventListener('keydown', this._mfKeyHandler, true)
    },
    unbindMathField() {
      const el = this.getMathFieldEl()
      if (el) {
        if (this._mfInputHandler) el.removeEventListener('input', this._mfInputHandler)
        if (this._mfKeyHandler) el.removeEventListener('keydown', this._mfKeyHandler, true)
        el._qbMfBound = false
      }
      this.hideMathKeyboard()
    },
    showMathKeyboard() {
      this.keyboardVisible = true
      this.$nextTick(() => {
        const el = this.getMathFieldEl()
        if (el && typeof el.focus === 'function') el.focus()
      })
    },
    hideMathKeyboard() {
      this.keyboardVisible = false
    },
    toggleMathKeyboard() {
      if (this.keyboardVisible) this.hideMathKeyboard()
      else this.showMathKeyboard()
    },
    onKbKey(key) {
      if (!key) return
      if (key.action) {
        this.runMfCommand(key.action)
        return
      }
      if (key.latex) this.insertLatexToMathField(key.latex)
    },
    runMfCommand(action) {
      const el = this.getMathFieldEl()
      if (!el) return
      try { el.focus() } catch (e) { /* ignore */ }
      const map = {
        backspace: 'deleteBackward',
        clear: 'deleteAll',
        left: 'moveToPreviousChar',
        right: 'moveToNextChar'
      }
      const cmd = map[action]
      if (!cmd) return
      try {
        if (typeof el.executeCommand === 'function') el.executeCommand(cmd)
        else if (action === 'clear') el.value = ''
      } catch (e) { /* ignore */ }
      this.formulaLatex = this.readMathLatex()
    },
    insertLatexToMathField(latex) {
      const el = this.getMathFieldEl()
      if (!el || !latex) return
      try { el.focus() } catch (e) { /* ignore */ }
      try {
        if (typeof el.executeCommand === 'function') {
          el.executeCommand(['insert', latex, { focus: true, feedback: false, mode: 'math', selectionMode: 'placeholder' }])
        } else if (typeof el.insert === 'function') {
          el.insert(latex)
        } else {
          el.value = (el.value || '') + latex
        }
      } catch (e) {
        try { el.value = (el.value || '') + latex } catch (e2) { /* ignore */ }
      }
      this.formulaLatex = this.readMathLatex()
    },
    rememberSelection() {
      if (!this.quill) return
      const range = this.quill.getSelection()
      if (range) this.savedSelection = { index: range.index, length: range.length || 0 }
    },
    restoreSelection() {
      if (!this.quill) return { index: 0, length: 0 }
      const sel = this.savedSelection || this.quill.getSelection(true) || { index: this.quill.getLength(), length: 0 }
      try {
        this.quill.setSelection(sel.index, sel.length || 0, 'silent')
      } catch (e) { /* ignore */ }
      return sel
    },
    onFormulaOpened() {
      this.kbTab = 'num'
      this.keyboardVisible = true
      applyMathliveZhLocale()
      this.$nextTick(() => {
        this.bindMathField()
        const el = this.getMathFieldEl()
        if (el) {
          try { el.mathVirtualKeyboardPolicy = 'manual' } catch (e) { /* ignore */ }
          try {
            if (typeof el.setOptions === 'function') {
              el.setOptions({ mathVirtualKeyboardPolicy: 'manual' })
            }
          } catch (e) { /* ignore */ }
          el.value = this.formulaLatex || ''
          this.formulaLatex = this.readMathLatex()
          if (typeof el.focus === 'function') el.focus()
        }
      })
    },
    onFormulaClosed() {
      this.keyboardVisible = false
      this.editingFormulaIndex = -1
      this.formulaLatex = ''
    },
    initQuill() {
      if (this.quill || !this.$refs.editor) return
      this.quill = new Quill(this.$refs.editor, {
        theme: 'snow',
        placeholder: this.placeholder || '',
        modules: {
          toolbar: {
            container: this.$refs.toolbar,
            handlers: {
              image: () => this.pickImage(),
              formula: () => this.openFormula()
            }
          }
        }
      })
      this.applyPlainToQuill(this.plainValue)
      this.quill.on('text-change', (delta, oldDelta, source) => {
        if (this.syncing) return
        if (source !== 'user') return
        this.emitFromQuill()
      })
      this.quill.on('selection-change', (range) => {
        if (range) this.savedSelection = { index: range.index, length: range.length || 0 }
      })
      this.quill.root.addEventListener('paste', this.handlePasteCapture, true)
      this.quill.root.addEventListener('blur', this.handleBlur, true)
      this.quill.root.addEventListener('dblclick', this.handleFormulaDblClick, true)
      this.quill.root.addEventListener('keydown', this.handleEditorKeydown, true)
    },
    handleEditorKeydown(e) {
      // Ctrl+/ or Alt+= open formula panel
      if ((e.ctrlKey || e.metaKey) && e.key === '/') {
        e.preventDefault()
        this.openFormula()
      }
    },
    handleFormulaDblClick(e) {
      const node = e.target && e.target.closest && e.target.closest('.ql-formula')
      if (!node || !this.quill) return
      e.preventDefault()
      e.stopPropagation()
      const blot = Quill.find(node)
      if (!blot) return
      const index = this.quill.getIndex(blot)
      const latex = node.getAttribute('data-value') || ''
      this.savedSelection = { index, length: 1 }
      this.editingFormulaIndex = index
      this.formulaLatex = latex
      this.formulaOpen = true
    },
    handleBlur(e) {
      this.$emit('blur', e)
    },
    applyPlainToQuill(text) {
      if (!this.quill) return
      this.syncing = true
      try {
        this.quill.setContents(plainToDelta(text), 'silent')
      } finally {
        this.$nextTick(() => { this.syncing = false })
      }
    },
    emitFromQuill() {
      const plain = deltaToPlain(this.quill)
      this.plainValue = plain
      this.$emit('input', plain)
    },
    openFormula() {
      this.rememberSelection()
      this.editingFormulaIndex = -1
      this.formulaLatex = ''
      this.formulaOpen = true
    },
    quickInsert(latex) {
      this.rememberSelection()
      this.insertFormula(latex, false)
    },
    quickInsertAndClose(latex) {
      this.rememberSelection()
      if (this.editingFormulaIndex >= 0) {
        this.replaceFormulaAt(this.editingFormulaIndex, latex)
      } else {
        this.insertFormula(latex, false)
      }
      this.formulaOpen = false
    },
    confirmFormula() {
      const latex = this.readMathLatex()
      if (!latex) return
      if (this.editingFormulaIndex >= 0) {
        this.replaceFormulaAt(this.editingFormulaIndex, latex)
      } else {
        this.insertFormula(latex, false)
      }
      this.formulaOpen = false
    },
    replaceFormulaAt(index, latex) {
      if (!this.quill) return
      this.quill.deleteText(index, 1, 'user')
      this.quill.insertEmbed(index, 'formula', latex, 'user')
      this.quill.setSelection(index + 1, 0, 'user')
      this.savedSelection = { index: index + 1, length: 0 }
      this.emitFromQuill()
    },
    insertFormula(latex, asBlock) {
      if (!latex) return
      if (!this.quill) {
        const wrapped = asBlock ? ('$$' + latex + '$$') : ('$' + latex + '$')
        const next = (this.plainValue || '') + wrapped
        this.plainValue = next
        this.$emit('input', next)
        return
      }
      const range = this.restoreSelection()
      const index = range.index
      if (range.length) this.quill.deleteText(index, range.length, 'user')
      if (asBlock) {
        this.quill.insertText(index, '\n', 'user')
        this.quill.insertEmbed(index + 1, 'formula', latex, 'user')
        this.quill.insertText(index + 2, '\n', 'user')
        this.quill.setSelection(index + 3, 0, 'user')
        this.savedSelection = { index: index + 3, length: 0 }
      } else {
        this.quill.insertEmbed(index, 'formula', latex, 'user')
        this.quill.setSelection(index + 1, 0, 'user')
        this.savedSelection = { index: index + 1, length: 0 }
      }
      this.emitFromQuill()
    },
    pickImage() {
      this.$refs.file && this.$refs.file.click()
    },
    onFileChange(e) {
      const files = e.target.files
      const file = files && files[0]
      e.target.value = ''
      if (file) this.uploadAndInsert(file)
    },
    handlePasteCapture(e) {
      const items = e.clipboardData && e.clipboardData.items
      if (!items || !items.length) return
      for (let i = 0; i < items.length; i++) {
        const it = items[i]
        if (it.type && it.type.indexOf('image/') === 0) {
          e.preventDefault()
          e.stopPropagation()
          const file = it.getAsFile()
          if (!file) return
          if (this.pasteAsOcr) this.$emit('ocr-image', file)
          else this.uploadAndInsert(file)
          return
        }
      }
    },
    onDragEnter() {
      this.dragDepth++
      this.dragOver = true
    },
    onDragOver() {
      this.dragOver = true
    },
    onDragLeave() {
      this.dragDepth = Math.max(0, this.dragDepth - 1)
      if (this.dragDepth === 0) this.dragOver = false
    },
    onDrop(e) {
      this.dragOver = false
      this.dragDepth = 0
      const files = e.dataTransfer && e.dataTransfer.files
      if (!files || !files.length) return
      for (let i = 0; i < files.length; i++) {
        if (files[i].type && files[i].type.indexOf('image/') === 0) {
          if (this.pasteAsOcr) this.$emit('ocr-image', files[i])
          else this.uploadAndInsert(files[i])
          return
        }
      }
    },
    uploadAndInsert(file) {
      if (!file) return
      if (file.size > 5 * 1024 * 1024) {
        this.$modal.msgWarning(L.imgTooBig)
        return
      }
      const fd = new FormData()
      fd.append('file', file)
      this.uploading = true
      axios.post(process.env.VUE_APP_BASE_API + '/common/upload', fd, {
        headers: {
          Authorization: 'Bearer ' + getToken(),
          'Content-Type': 'multipart/form-data'
        }
      }).then(res => {
        const data = res.data || {}
        if (data.code !== undefined && data.code !== 200) {
          this.$modal.msgError(data.msg || L.uploadFail)
          return
        }
        const url = data.fileName || data.url || (data.data && (data.data.fileName || data.data.url))
        if (!url) {
          this.$modal.msgError(L.uploadFail)
          return
        }
        const path = String(url)
        this.insertImageAtCursor(path)
        this.$emit('image-inserted', path)
        this.$modal.msgSuccess(L.uploadOk)
      }).catch(() => {
        this.$modal.msgError(L.uploadErr)
      }).finally(() => { this.uploading = false })
    },
    insertImageAtCursor(path) {
      this.rememberSelection()
      if (!this.quill) {
        const next = (this.plainValue || '') + '\n![](' + path + ')\n'
        this.plainValue = next
        this.$emit('input', next)
        return
      }
      const range = this.restoreSelection()
      const src = resolveMediaUrl(path)
      this.quill.insertEmbed(range.index, 'image', src, 'user')
      this.quill.setSelection(range.index + 1, 0, 'user')
      this.emitFromQuill()
    }
  }
}
</script>

<style scoped>
.qb-field-editor {
  width: 100%;
  position: relative;
}
.qb-field-editor.is-dragover .qb-field-body {
  outline: 2px dashed #409eff;
  outline-offset: 2px;
  background: #f0f9ff;
}
.qb-quill-toolbar {
  border: 1px solid #dcdfe6;
  border-bottom: none;
  border-radius: 4px 4px 0 0;
  background: #fafbfc;
  padding: 4px 6px;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
}
.qb-quick-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 4px;
  padding: 4px 8px 6px;
  border: 1px solid #dcdfe6;
  border-top: none;
  border-bottom: none;
  background: #fff;
}
.qb-quick-label {
  font-size: 12px;
  color: #909399;
  margin-right: 4px;
}
.qb-quick-chip {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 36px;
  height: 28px;
  padding: 0 8px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  background: #fff;
  cursor: pointer;
  line-height: 1;
  transition: border-color .15s, background .15s;
}
.qb-quick-chip:hover {
  border-color: #409eff;
  background: #ecf5ff;
}
.qb-quick-chip.large {
  min-width: 52px;
  height: 40px;
  padding: 4px 10px;
}
.qb-field-body {
  position: relative;
  border: 1px solid #dcdfe6;
  border-radius: 0 0 4px 4px;
  overflow: hidden;
  background: #fff;
}
.qb-quill-editor { background: #fff; }
.qb-field-live {
  border-top: 1px dashed #e4e7ed;
  background: #fafbfc;
  padding: 8px 12px 10px;
}
.qb-field-live-hd { font-size: 12px; color: #909399; margin-bottom: 6px; }
.qb-field-live-body {
  line-height: 1.75;
  font-size: 14px;
  color: #303133;
  word-break: break-word;
  min-height: 32px;
}
.qb-field-drop-mask {
  position: absolute;
  inset: 0;
  background: rgba(64, 158, 255, 0.12);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #409eff;
  font-weight: 600;
  pointer-events: none;
  z-index: 2;
}
.qb-formula-editor { min-height: 100px; }
.qb-quick-section { margin-bottom: 14px; }
.qb-custom-section { margin-top: 4px; }
.qb-quick-hd {
  font-size: 13px;
  color: #606266;
  margin-bottom: 8px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.qb-quick-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.qb-mathfield-wrap {
  border: 1px solid #dcdfe6;
  border-radius: 6px;
  background: #fff;
  padding: 8px 10px;
  min-height: 64px;
}
.qb-mathfield {
  width: 100%;
  font-size: 22px;
  min-height: 48px;
  border: none;
  outline: none;
}
.qb-kb-panel {
  margin-top: 10px;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  background: #f5f7fa;
  padding: 8px;
}
.qb-kb-tabs {
  display: flex;
  gap: 6px;
  margin-bottom: 8px;
}
.qb-kb-tab {
  border: 1px solid #dcdfe6;
  background: #fff;
  border-radius: 4px;
  padding: 4px 12px;
  font-size: 12px;
  color: #606266;
  cursor: pointer;
}
.qb-kb-tab.active {
  color: #409eff;
  border-color: #409eff;
  background: #ecf5ff;
}
.qb-kb-keys {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 6px;
}
.qb-kb-key {
  min-height: 40px;
  border: 1px solid #dcdfe6;
  border-radius: 6px;
  background: #fff;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: #303133;
  padding: 4px 2px;
  transition: background .12s, border-color .12s;
}
.qb-kb-key:hover {
  border-color: #409eff;
  background: #ecf5ff;
}
.qb-kb-key.action {
  background: #eef1f6;
  color: #606266;
  font-size: 12px;
}
.qb-kb-key.wide {
  grid-column: span 1;
}
.qb-formula-hint {
  margin-top: 8px;
  font-size: 12px;
  color: #909399;
  line-height: 1.5;
}
.qb-formula-footer { display: flex; justify-content: flex-end; align-items: center; gap: 8px; }
.qb-enter-tip {
  margin-left: 6px;
  font-size: 11px;
  opacity: 0.75;
  border: 1px solid rgba(255,255,255,0.55);
  border-radius: 3px;
  padding: 0 4px;
}
</style>

<style>
.qb-field-editor .ql-toolbar.ql-snow {
  border: none !important;
  padding: 0;
  background: transparent;
}
.qb-field-editor .ql-container.ql-snow {
  border: none !important;
  font-size: 14px;
}
.qb-field-editor .ql-editor {
  min-height: inherit;
  line-height: 1.7;
  padding: 10px 12px;
}
.qb-field-editor .ql-editor.ql-blank::before {
  font-style: normal;
  color: #c0c4cc;
  left: 12px;
  right: 12px;
}
.qb-field-editor .ql-snow .ql-formula {
  width: auto !important;
  padding: 0 8px !important;
}
.qb-field-editor .ql-snow .ql-formula::before { content: none; }
.qb-field-editor .ql-snow .ql-formula::after {
  content: '插入公式';
  font-size: 12px;
  color: #409eff;
  white-space: nowrap;
}
.qb-field-editor .ql-snow .ql-formula svg { display: none; }
.qb-quick-chip .katex { font-size: 0.95em; }
.qb-quick-chip.large .katex { font-size: 1.05em; }
.qb-field-live-body .qb-inline-img,
.qb-rich-text .qb-inline-img,
.import-formula .qb-inline-img,
.qb-list-stem .qb-inline-img {
  display: block;
  max-width: 100%;
  max-height: 280px;
  margin: 8px 0;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  background: #fff;
}
.qb-field-live-body .katex { font-size: 1.08em; }
.qb-field-editor .ql-editor .ql-formula {
  margin: 0 2px;
  cursor: pointer;
}
.qb-field-editor .ql-editor .ql-formula:hover {
  outline: 1px dashed #409eff;
  outline-offset: 2px;
}
.qb-field-editor .ql-editor img {
  max-width: 100%;
  max-height: 280px;
}
/* Hide MathLive's native keyboard toggle — we render our own panel */
.qb-mathfield::part(virtual-keyboard-toggle),
.qb-mathfield .ML__virtual-keyboard-toggle,
math-field.qb-mathfield [part='virtual-keyboard-toggle'] {
  display: none !important;
}
.qb-kb-key .katex { font-size: 0.95em; }
.qb-formula-dialog {
  margin-bottom: 40px;
  overflow: visible !important;
}
.qb-formula-dialog .el-dialog__body {
  max-height: 72vh;
  overflow-y: auto;
  overflow-x: visible;
}
/* MathLive context menu above Element dialog */
.ML__ui-menu-container,
[class*='ML__menu'],
.ui-menu-container {
  z-index: 5000 !important;
}
</style>
