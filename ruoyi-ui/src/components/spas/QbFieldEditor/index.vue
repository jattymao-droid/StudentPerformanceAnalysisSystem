<template>
  <div
    class="qb-field-editor"
    :class="{ 'is-dragover': dragOver }"
    @dragenter.prevent="onDragEnter"
    @dragover.prevent="onDragOver"
    @dragleave.prevent="onDragLeave"
    @drop.prevent="onDrop"
  >
    <div class="qb-field-toolbar">
      <el-button size="mini" type="primary" plain icon="el-icon-edit-outline" @click="openFormula">{{ labels.insertFormula }}</el-button>
      <el-button size="mini" type="success" plain icon="el-icon-picture-outline" :loading="uploading" @click="pickImage">{{ labels.insertImg }}</el-button>
      <el-dropdown size="mini" trigger="click" @command="insertSnippet" style="margin-left:8px">
        <el-button size="mini" plain>{{ labels.common }}<i class="el-icon-arrow-down el-icon--right" /></el-button>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="frac">{{ labels.frac }}</el-dropdown-item>
          <el-dropdown-item command="sqrt">{{ labels.sqrt }}</el-dropdown-item>
          <el-dropdown-item command="sup">{{ labels.sup }}</el-dropdown-item>
          <el-dropdown-item command="sub">{{ labels.sub }}</el-dropdown-item>
          <el-dropdown-item command="vec">{{ labels.vec }}</el-dropdown-item>
          <el-dropdown-item command="times">{{ labels.times }}</el-dropdown-item>
          <el-dropdown-item command="pm">{{ labels.pm }}</el-dropdown-item>
          <el-dropdown-item command="deg">{{ labels.deg }}</el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
      <span class="qb-field-tip">{{ tipText }}</span>
    </div>

    <div class="qb-field-body">
      <el-input
        ref="input"
        type="textarea"
        :rows="rows"
        :value="value"
        :placeholder="placeholder"
        @input="$emit('input', $event)"
        @blur="$emit('blur', $event)"
      />
      <div v-if="livePreview && value" class="qb-field-live">
        <div class="qb-field-live-hd">{{ labels.live }}</div>
        <div class="qb-field-live-body" v-html="liveHtml" />
      </div>
      <div v-if="dragOver" class="qb-field-drop-mask">{{ labels.dropHint }}</div>
    </div>

    <input ref="file" type="file" accept="image/png,image/jpeg,image/jpg,image/gif,image/webp" style="display:none" @change="onFileChange" />

    <el-dialog :title="labels.insertFormula" :visible.sync="formulaOpen" width="520px" append-to-body :close-on-click-modal="false">
      <el-form size="small" label-width="72px">
        <el-form-item :label="labels.mode">
          <el-radio-group v-model="formulaMode">
            <el-radio label="inline">{{ labels.inline }}</el-radio>
            <el-radio label="block">{{ labels.block }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="LaTeX">
          <el-input type="textarea" :rows="3" v-model="formulaLatex" :placeholder="labels.latexPh" />
        </el-form-item>
        <el-form-item :label="labels.preview">
          <div class="qb-formula-preview" v-html="formulaPreviewHtml" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" :disabled="!formulaLatex.trim()" @click="confirmFormula">{{ labels.insert }}</el-button>
        <el-button @click="formulaOpen=false">{{ labels.cancel }}</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getToken } from '@/utils/auth'
import { renderFormulaHtml } from '@/utils/qbFormula'
import axios from 'axios'

const SNIPPETS = {
  frac: '\\frac{a}{b}',
  sqrt: '\\sqrt{x}',
  sup: 'x^{2}',
  sub: 'x_{1}',
  vec: '\\vec{F}',
  times: '\\times',
  pm: '\\pm',
  deg: '30^\\circ'
}

function u(...codes) {
  return String.fromCharCode(...codes)
}

const L = {
  insertFormula: u(0x63d2, 0x5165, 0x516c, 0x5f0f),
  insertImg: u(0x63d2, 0x5165, 0x56fe, 0x7247),
  common: u(0x5e38, 0x7528, 0x516c, 0x5f0f),
  frac: u(0x5206, 0x6570) + ' a/b',
  sqrt: u(0x6839, 0x53f7),
  sup: u(0x4e0a, 0x6807),
  sub: u(0x4e0b, 0x6807),
  vec: u(0x77e2, 0x91cf),
  times: u(0x4e58, 0x53f7),
  pm: u(0x6b63, 0x8d1f, 0x53f7),
  deg: u(0x89d2, 0x5ea6),
  tip: u(0x53ef, 0x622a, 0x56fe, 0x540e) + ' Ctrl+V ' + u(0x7c98, 0x8d34, 0x516c, 0x5f0f, 0x56fe, 0x5230, 0x5149, 0x6807, 0x5904),
  mode: u(0x6a21, 0x5f0f),
  inline: u(0x884c, 0x5185) + ' $...$',
  block: u(0x72ec, 0x7acb) + ' $$...$$',
  preview: u(0x9884, 0x89c8),
  live: u(0x9884, 0x89c8),
  insert: u(0x63d2, 0x5165),
  cancel: u(0x53d6, 0x6d88),
  latexPh: u(0x4f8b, 0x5982, 0xff1a) + '\\frac{1}{2}mv^2 ' + u(0x6216) + ' F=ma',
  previewEmpty: u(0x9884, 0x89c8, 0x533a),
  dropHint: u(0x677e, 0x5f00, 0x4ee5, 0x63d2, 0x5165, 0x56fe, 0x7247),
  imgTooBig: u(0x56fe, 0x7247, 0x8bf7, 0x5c0f, 0x4e8e) + ' 5MB',
  uploadFail: u(0x4e0a, 0x4f20, 0x5931, 0x8d25, 0xff1a, 0x672a, 0x8fd4, 0x56de, 0x5730, 0x5740),
  uploadOk: u(0x56fe, 0x7247, 0x5df2, 0x63d2, 0x5165),
  uploadErr: u(0x914d, 0x56fe, 0x4e0a, 0x4f20, 0x5931, 0x8d25),
  noImage: u(0x526a, 0x8d34, 0x677f, 0x4e2d, 0x6ca1, 0x6709, 0x56fe, 0x7247)
}

export default {
  name: 'QbFieldEditor',
  props: {
    value: { type: String, default: '' },
    rows: { type: Number, default: 4 },
    placeholder: { type: String, default: '' },
    /** Show live HTML preview under textarea (for stem) */
    livePreview: { type: Boolean, default: false },
    /** When true, pasted images emit ocr-image instead of uploading into stem */
    pasteAsOcr: { type: Boolean, default: false }
  },
  data() {
    return {
      labels: L,
      formulaOpen: false,
      formulaMode: 'inline',
      formulaLatex: '',
      uploading: false,
      dragOver: false,
      dragDepth: 0
    }
  },
  computed: {
    formulaPreviewHtml() {
      const latex = (this.formulaLatex || '').trim()
      if (!latex) return '<span style="color:#c0c4cc">' + L.previewEmpty + '</span>'
      const wrapped = this.formulaMode === 'block' ? ('$$' + latex + '$$') : ('$' + latex + '$')
      return renderFormulaHtml(wrapped)
    },
    liveHtml() {
      return renderFormulaHtml(this.value || '')
    },
    tipText() {
      if (this.pasteAsOcr) {
        return u(0x53ef) + ' Ctrl+V ' + u(0x7c98, 0x8d34, 0x622a, 0x56fe, 0x8bc6, 0x522b, 0x4e3a, 0x9898, 0x5e72, 0x6587, 0x5b57)
      }
      return L.tip
    }
  },
  mounted() {
    this.$nextTick(() => this.bindPaste())
  },
  updated() {
    this.bindPaste()
  },
  beforeDestroy() {
    this.unbindPaste()
  },
  methods: {
    getTextarea() {
      const input = this.$refs.input
      return input && (input.$refs.textarea || (input.$el && input.$el.querySelector('textarea')))
    },
    bindPaste() {
      const ta = this.getTextarea()
      if (!ta || ta._qbPasteBound) return
      ta._qbPasteBound = true
      this._pasteHandler = (e) => this.onPaste(e)
      ta.addEventListener('paste', this._pasteHandler)
    },
    unbindPaste() {
      const ta = this.getTextarea()
      if (ta && this._pasteHandler) {
        ta.removeEventListener('paste', this._pasteHandler)
        ta._qbPasteBound = false
      }
    },
    openFormula() {
      this.formulaLatex = ''
      this.formulaMode = 'inline'
      this.formulaOpen = true
    },
    confirmFormula() {
      const latex = (this.formulaLatex || '').trim()
      if (!latex) return
      const wrapped = this.formulaMode === 'block' ? ('$$' + latex + '$$') : ('$' + latex + '$')
      this.insertText(wrapped)
      this.formulaOpen = false
    },
    insertSnippet(cmd) {
      const latex = SNIPPETS[cmd]
      if (!latex) return
      this.insertText('$' + latex + '$')
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
    onPaste(e) {
      const items = e.clipboardData && e.clipboardData.items
      if (!items || !items.length) return
      for (let i = 0; i < items.length; i++) {
        const it = items[i]
        if (it.type && it.type.indexOf('image/') === 0) {
          e.preventDefault()
          const file = it.getAsFile()
          if (!file) return
          if (this.pasteAsOcr) {
            this.$emit('ocr-image', file)
          } else {
            this.uploadAndInsert(file)
          }
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
          if (this.pasteAsOcr) {
            this.$emit('ocr-image', files[i])
          } else {
            this.uploadAndInsert(files[i])
          }
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
        // Insert at cursor so formula image sits inside stem text flow
        this.insertText('\n![](' + path + ')\n')
        this.$emit('image-inserted', path)
        this.$modal.msgSuccess(L.uploadOk)
      }).catch(() => {
        this.$modal.msgError(L.uploadErr)
      }).finally(() => { this.uploading = false })
    },
    insertText(snippet) {
      const ta = this.getTextarea()
      const cur = this.value || ''
      if (!ta) {
        this.$emit('input', cur + snippet)
        return
      }
      const start = typeof ta.selectionStart === 'number' ? ta.selectionStart : cur.length
      const end = typeof ta.selectionEnd === 'number' ? ta.selectionEnd : start
      const next = cur.slice(0, start) + snippet + cur.slice(end)
      this.$emit('input', next)
      this.$nextTick(() => {
        try {
          const pos = start + snippet.length
          ta.focus()
          ta.setSelectionRange(pos, pos)
        } catch (err) { /* ignore */ }
      })
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
.qb-field-toolbar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 6px;
  margin-bottom: 6px;
}
.qb-field-tip { font-size: 12px; color: #909399; margin-left: 4px; }
.qb-field-body {
  position: relative;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  overflow: hidden;
  background: #fff;
}
.qb-field-body >>> .el-textarea__inner {
  border: none;
  border-radius: 0;
  box-shadow: none;
}
.qb-field-live {
  border-top: 1px dashed #e4e7ed;
  background: #fafbfc;
  padding: 8px 12px 10px;
}
.qb-field-live-hd {
  font-size: 12px;
  color: #909399;
  margin-bottom: 6px;
}
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
.qb-formula-preview {
  min-height: 48px;
  padding: 10px 12px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  background: #fafafa;
  line-height: 1.6;
}
</style>

<style>
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
</style>
