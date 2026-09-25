import katex from 'katex'
import 'katex/dist/katex.min.css'

/**
 * Fix import artifact: incomplete prose + dollar-wrapped Chinese duplicated stems.
 * Unwrap Chinese mistaken as math, then drop near-duplicate adjacent segments.
 */
export function dedupeStemContent(raw) {
  if (!raw) return ''
  let s = String(raw).replace(/\r/g, '')

  const unwrap = (inner) => {
    const t = String(inner || '').trim()
    const cjk = (t.match(/[\u4e00-\u9fff]/g) || []).length
    const latex = (t.match(/\\[a-zA-Z]+/g) || []).length
    if (cjk >= 6 && latex === 0) return t
    return null
  }
  // allow multiline $...$ (import often wraps whole paragraphs)
  s = s.replace(/\$\$([\s\S]+?)\$\$/g, (m, inner) => {
    const u = unwrap(inner)
    return u != null ? ('\n' + u + '\n') : m
  })
  s = s.replace(/\$([\s\S]+?)\$/g, (m, inner) => {
    const u = unwrap(inner)
    return u != null ? ('\n' + u + '\n') : m
  })

  // Split incomplete prose + next question no. on same line
  s = s.replace(/([：:；;。])\s*(?=\d{1,3}\s*[\.．、]\s*[（(]?\s*\d+\s*分)/g, '$1\n')
  // Split before a second exam-source header on same line
  s = s.replace(/([^\n])(\d{1,3}\s*[\.．、]\s*[（(]20\d{2}[·.])/g, '$1\n$2')
  s = s.replace(/([^\n])((?:[（(]\d+\s*分[）)]\s*)?\(20\d{2}[·.])/g, (m, a, b, off, whole) => {
    // only if this is a second occurrence on the line
    const lineStart = whole.lastIndexOf('\n', off) + 1
    const before = whole.slice(lineStart, off + 1)
    if (/\(20\d{2}[·.]/.test(before)) return a + '\n' + b
    return m
  })

  const norm = (x) => String(x || '')
    .replace(/[0-9a-zA-ZθΘ°=\.\s$\\，。；、：:（）()·\uff0c\u3001\u3002\uff1b\uff1a\u00b0_/+\-*^]+/g, '')

  let parts = s.split(/\n+/).map(p => p.trim()).filter(Boolean)
  const expanded = []
  parts.forEach(p => {
    const bits = p.split(/(?<=[；;])\s*/).map(x => x.trim()).filter(Boolean)
    if (bits.length >= 2 && bits.every(b => (b.match(/[\u4e00-\u9fff]/g) || []).length >= 6)) {
      bits.forEach(b => expanded.push(b))
    } else {
      expanded.push(p)
    }
  })
  parts = expanded

  const out = []
  for (const part of parts) {
    const n = norm(part)
    if (!n) {
      out.push(part)
      continue
    }
    let merged = false
    for (let i = out.length - 1; i >= Math.max(0, out.length - 6); i--) {
      const on = norm(out[i])
      if (!on) continue
      if (n === on) {
        if (part.length >= out[i].length) out[i] = part
        merged = true
        break
      }
      if (n.includes(on) && n.length > on.length + 1) {
        out[i] = part
        merged = true
        break
      }
      if (on.includes(n) && on.length > n.length + 1) {
        merged = true
        break
      }
    }
    if (!merged) out.push(part)
  }
  return out.join('\n').replace(/\n{3,}/g, '\n\n').trim()
}

export function cleanupOcrText(raw) {
  if (!raw) return ''
  let t = String(raw)
    .replace(/\r/g, '')
    .replace(/[ \t]+\n/g, '\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim()
  return softWrapFormulas(dedupeStemContent(t))
}

export function softWrapFormulas(text) {
  if (!text) return ''
  let s = String(text)
  if (s.indexOf('$') >= 0) {
    return mapUnicodeMathOutsideDollar(s)
  }
  s = mapUnicodeMath(s)
  s = s.replace(
    /\(([A-Za-z0-9+\-*/^_\\.\s]{1,40})\)\s*\/\s*\(([A-Za-z0-9+\-*/^_\\.\s]{1,40})\)/g,
    (_, a, b) => '$\\frac{' + a.replace(/\s+/g, '') + '}{' + b.replace(/\s+/g, '') + '}$'
  )
  const pre = '[\\u4e00-\\u9fff\\s(\\uFF08\\[\\u3010,\\uFF0C:\\uFF1A;\\uFF1B]'
  const post = '[\\u4e00-\\u9fff\\s)\\uFF09\\]\\u3011,\\uFF0C\\u3002.\\uFF1B;!\\uFF01?\\uFF1F]'
  s = s.replace(
    new RegExp('(' + pre + '|^)([A-Za-z][A-Za-z0-9]*)\\/([A-Za-z][A-Za-z0-9]*)(?=' + post + '|$)', 'g'),
    (_, head, a, b) => head + '$\\frac{' + a + '}{' + b + '}$'
  )
  s = s.replace(
    new RegExp('(' + pre + ')(([A-Za-z](?:_[0-9A-Za-z]+|\\^[0-9A-Za-z]+){1,3})|([A-Za-z]\\s*=\\s*[A-Za-z0-9+\\-*/^_]{1,24}))(?=' + post + '|$)', 'g'),
    (_, head, expr) => head + '$' + String(expr).replace(/\s+/g, '') + '$'
  )
  s = s.replace(
    new RegExp('(^|\\n)(([A-Za-z](?:_[0-9A-Za-z]+|\\^[0-9A-Za-z]+){1,3})|([A-Za-z]\\s*=\\s*[A-Za-z0-9+\\-*/^_]{1,24}))(?=' + post + '|$)', 'gm'),
    (_, head, expr) => head + '$' + String(expr).replace(/\s+/g, '') + '$'
  )
  return s
}

function mapUnicodeMath(s) {
  return String(s)
    .replace(/\u00b1/g, '$\\pm$')
    .replace(/\u00d7/g, '$\\times$')
    .replace(/\u00f7/g, '$\\div$')
    .replace(/\u2260/g, '$\\neq$')
    .replace(/\u2264/g, '$\\leq$')
    .replace(/\u2265/g, '$\\geq$')
    .replace(/\u221e/g, '$\\infty$')
    .replace(/\u221a\s*\(([^)]{1,40})\)/g, (_, e) => '$\\sqrt{' + e + '}$')
    .replace(/\u221a([A-Za-z0-9]+)/g, (_, e) => '$\\sqrt{' + e + '}$')
    .replace(/\u03b1/g, '$\\alpha$')
    .replace(/\u03b2/g, '$\\beta$')
    .replace(/\u03b8/g, '$\\theta$')
    .replace(/\u03c0/g, '$\\pi$')
    .replace(/\u00b0/g, '$^{\\circ}$')
}

function mapUnicodeMathOutsideDollar(s) {
  const parts = String(s).split(/(\$\$[\s\S]+?\$\$|\$[^$\n]+\$)/)
  return parts.map((part, i) => (i % 2 === 1 ? part : mapUnicodeMath(part))).join('')
}

export function resolveMediaUrl(url) {
  if (!url) return ''
  if (url.indexOf('http') === 0 || url.indexOf('data:') === 0 || url.indexOf('blob:') === 0) return url
  const base = process.env.VUE_APP_BASE_API || ''
  if (url.indexOf('/') === 0) return base + url
  return base + '/' + url
}

/**
 * Escape HTML then render $...$ / $$...$$ with KaTeX,
 * and markdown images ![alt](url) / [[IMG:url]].
 */
export function renderFormulaHtml(text) {
  if (!text) return ''
  const src = softWrapFormulas(text)
  const escaped = src
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
  let html = escaped.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (_, alt, url) => {
    const u = resolveMediaUrl(url.trim())
    const a = alt || 'img'
    return '<img class="qb-inline-img" src="' + u + '" alt="' + a + '" />'
  })
  html = html.replace(/\[\[IMG:([^\]]+)\]\]/gi, (_, url) => {
    const u = resolveMediaUrl(String(url).trim())
    return '<img class="qb-inline-img" src="' + u + '" alt="img" />'
  })
  html = html.replace(/\$\$([\s\S]+?)\$\$/g, (_, expr) => renderOneMath(expr, true))
  html = html.replace(/\$([^\$\n]+?)\$/g, (_, expr) => renderOneMath(expr, false))
  return html.replace(/\n/g, '<br/>')
}

/** True math vs Chinese prose wrongly wrapped in $...$ */
function isMostlyChineseProse(expr) {
  const t = String(expr || '')
  const cjk = (t.match(/[\u4e00-\u9fff]/g) || []).length
  if (cjk < 2) return false
  const latex = (t.match(/\\[a-zA-Z]+/g) || []).length
  const latinMath = (t.match(/[A-Za-z0-9=+\-*/^_{}]/g) || []).length
  // Chinese-heavy and little real math/latex -> treat as text
  if (latex === 0 && cjk >= 4 && cjk >= latinMath) return true
  if (latex === 0 && cjk >= 2 && latinMath <= 2) return true
  return false
}

function renderOneMath(expr, displayMode) {
  const raw = String(expr || '')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&amp;/g, '&')
  if (isMostlyChineseProse(raw)) {
    // already HTML-escaped upstream; re-escape after unescape for safety
    return raw
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
  }
  try {
    return katex.renderToString(raw, {
      displayMode: !!displayMode,
      throwOnError: false,
      strict: 'ignore'
    })
  } catch (e) {
    return '<code>' + raw.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</code>'
  }
}

export async function recognizeImage(imageSource) {
  const { createWorker } = await import('tesseract.js')
  if (!ocrWorker) {
    if (!ocrLoading) {
      ocrLoading = (async () => {
        const worker = await createWorker('chi_sim+eng')
        try {
          await worker.setParameters({
            tessedit_pageseg_mode: '6',
            preserve_interword_spaces: '1'
          })
        } catch (e) { /* ignore */ }
        ocrWorker = worker
        return worker
      })()
    }
    await ocrLoading
  }
  const prepared = await prepareOcrSource(imageSource)
  const { data } = await ocrWorker.recognize(prepared)
  return cleanupOcrText(data && data.text)
}

async function prepareOcrSource(imageSource) {
  try {
    const img = await loadImageElement(imageSource)
    if (!img || !img.width) return imageSource
    const maxSide = Math.max(img.width, img.height)
    const scale = maxSide < 1000 ? 2 : (maxSide < 1600 ? 1.5 : 1)
    const canvas = document.createElement('canvas')
    canvas.width = Math.round(img.width * scale)
    canvas.height = Math.round(img.height * scale)
    const ctx = canvas.getContext('2d')
    ctx.imageSmoothingEnabled = true
    ctx.imageSmoothingQuality = 'high'
    ctx.fillStyle = '#fff'
    ctx.fillRect(0, 0, canvas.width, canvas.height)
    ctx.drawImage(img, 0, 0, canvas.width, canvas.height)
    try {
      const id = ctx.getImageData(0, 0, canvas.width, canvas.height)
      const d = id.data
      const contrast = 1.18
      const intercept = 128 * (1 - contrast)
      for (let i = 0; i < d.length; i += 4) {
        const g = 0.299 * d[i] + 0.587 * d[i + 1] + 0.114 * d[i + 2]
        const v = Math.max(0, Math.min(255, g * contrast + intercept))
        d[i] = d[i + 1] = d[i + 2] = v
      }
      ctx.putImageData(id, 0, 0)
    } catch (e2) { /* CORS / tainted */ }
    return canvas.toDataURL('image/png')
  } catch (e) {
    return imageSource
  }
}

function loadImageElement(src) {
  return new Promise((resolve, reject) => {
    if (!src) return reject(new Error('empty'))
    if (typeof src !== 'string') {
      const url = URL.createObjectURL(src)
      const img = new Image()
      img.onload = () => { URL.revokeObjectURL(url); resolve(img) }
      img.onerror = (e) => { URL.revokeObjectURL(url); reject(e) }
      img.src = url
      return
    }
    const img = new Image()
    img.crossOrigin = 'anonymous'
    img.onload = () => resolve(img)
    img.onerror = reject
    img.src = src
  })
}

export async function terminateOcrWorker() {
  if (ocrWorker) {
    await ocrWorker.terminate()
    ocrWorker = null
    ocrLoading = null
  }
}

export function cropPageToDataUrl(imgEl, region, naturalW, naturalH) {
  if (!imgEl || !region || !naturalW || !naturalH) return ''
  const sx = Math.max(0, Math.floor(region.x * naturalW))
  const sy = Math.max(0, Math.floor(region.y * naturalH))
  const sw = Math.max(1, Math.ceil(region.w * naturalW))
  const sh = Math.max(1, Math.ceil(region.h * naturalH))
  const canvas = document.createElement('canvas')
  const scale = (sw < 400 || sh < 400) ? 3 : ((sw < 800 || sh < 800) ? 2 : 1)
  canvas.width = sw * scale
  canvas.height = sh * scale
  const ctx = canvas.getContext('2d')
  ctx.imageSmoothingEnabled = true
  ctx.drawImage(imgEl, sx, sy, sw, sh, 0, 0, canvas.width, canvas.height)
  return canvas.toDataURL('image/png')
}
