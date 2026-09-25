/** Shared analysis-scope labels & banner helpers for SPAS pages. */

export const WINDOW_LABELS = {
  all: '全部 · 快照',
  last30d: '近30天 · 即时',
  last90d: '近90天 · 即时',
  semester: '本学期 · 即时',
  papers: '选卷诊断 · 即时'
}

export function windowLabel(windowKey) {
  if (!windowKey) return WINDOW_LABELS.semester
  return WINDOW_LABELS[windowKey] || String(windowKey)
}

export function dataModeLabel(dataMode) {
  if (dataMode === 'snapshot') return '快照表'
  if (dataMode === 'papers') return '选卷即时'
  if (dataMode === 'live') return '时间窗即时'
  return dataMode || '-'
}

/**
 * Primary口径 banner text shown on analysis pages.
 */
export function buildScopeBanner(opts) {
  const o = opts || {}
  const recency = o.useRecency === false ? '近因关闭' : '近因衰减'
  let core
  if (o.analysisMode === 'papers') {
    const n = (o.paperIds && o.paperIds.length) || 0
    core = '主口径：选卷诊断 · ' + n + ' 场（即时加权）'
  } else {
    core = '主口径：' + windowLabel(o.window || o.defaultWindow || 'semester')
  }
  const mode = o.dataMode ? ' · 引擎=' + dataModeLabel(o.dataMode) : ''
  const calc = o.calcTime ? ' · 最近计算 ' + formatCalcTime(o.calcTime) : ''
  return core + ' · ' + recency + mode + calc
}

export function formatCalcTime(v) {
  if (!v) return ''
  if (typeof v === 'string') return v.length > 19 ? v.slice(0, 19).replace('T', ' ') : v
  try {
    const d = new Date(v)
    if (isNaN(d.getTime())) return String(v)
    const pad = n => (n < 10 ? '0' + n : '' + n)
    return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate())
      + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes())
  } catch (e) {
    return String(v)
  }
}

/** Whether current selection differs from product default (should expand 高级). */
export function isNonDefaultScope(analysisMode, windowKey, defaultWindow, paperIds, useRecency) {
  if (analysisMode === 'papers') return true
  if (useRecency === false) return true
  const dw = defaultWindow || 'semester'
  if (windowKey && windowKey !== dw) return true
  if (paperIds && paperIds.length) return true
  return false
}

/** Formal weak = engine weak_level 1/2/3; otherwise low-rate with thin sample is 证据不足 only. */
export function isFormalWeak(row) {
  if (!row) return false
  if (row.formalWeak === true || row.formalWeak === 'true' || row.formalWeak === 1) return true
  const wl = String(row.weakLevel != null ? row.weakLevel : '')
  return wl === '1' || wl === '2' || wl === '3'
}

export function isLowEvidence(row, minAttempts) {
  if (!row) return true
  if (row.evidenceOk === false || row.evidenceOk === 'false') return true
  const min = minAttempts != null ? Number(minAttempts) : 3
  const a = Number(row.attemptCount != null ? row.attemptCount : row.attempts)
  if (!isNaN(a) && a < min) return true
  return false
}
