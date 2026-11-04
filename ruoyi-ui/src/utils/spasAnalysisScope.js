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
  let extra = ''
  const win = o.analysisMode === 'papers' ? 'papers' : (o.window || o.defaultWindow || 'semester')
  if (win === 'all') {
    extra += ' · 改标注后请重算，否则「全部」可能仍是上次快照'
  }
  if (o.empiricalEnabled) {
    extra += ' · 难度含班级实测校正'
  }
  if (o.allocationMode === 'proportional' || !o.allocationMode) {
    extra += ' · 一题多点为辅助定位，非分技能实测'
  }
  return core + ' · ' + recency + mode + calc + extra
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

/**
 * One-glance verdict for analysis pages (student or class).
 * @param {Object} opts
 * @param {'student'|'class'} opts.scope
 * @param {Object} opts.summary overview/summary map
 * @param {boolean} [opts.empty]
 * @param {boolean} [opts.blocked]
 * @param {string} [opts.blockReason]
 * @param {Function} [opts.formatRate]
 */
export function buildAnalysisVerdict(opts) {
  const o = opts || {}
  const s = o.summary || {}
  const formatRate = typeof o.formatRate === 'function' ? o.formatRate : (v => {
    if (v == null || v === '') return '-'
    const n = Number(v)
    if (isNaN(n)) return '-'
    return (n <= 1 ? n * 100 : n).toFixed(1) + '%'
  })
  if (o.empty || s.emptyKnowledge) {
    return {
      level: 'empty',
      title: o.scope === 'class' ? String.fromCharCode(26412,29677,26412,23398,31185,26242,26080,23567,39064,25104,32489) : String.fromCharCode(26412,23398,31185,26242,26080,23567,39064,25104,32489),
      subtitle: String.fromCharCode(25484,25569,24230,19982,27491,24335,34180,24369,19981,21487,29992,65307,21487,20808,30475,23454,32771,26657,27425,25110,23548,20837,23567,39064,25104,32489,12290),
      metrics: []
    }
  }
  if (o.blocked || s.formalWeakBlocked) {
    return {
      level: 'blocked',
      title: String.fromCharCode(26631,27880,19981,36275,65292,26242,19981,23450,27491,24335,34180,24369),
      subtitle: o.blockReason || s.formalWeakBlockReason || String.fromCharCode(35831,20808,34917,40784,35797,21367,30693,35782,28857,26631,27880,21518,20877,35835,23450,32423,32467,35770,12290),
      metrics: []
    }
  }
  const rateRaw = s.overallRate != null ? s.overallRate : s.avgRate
  const rateNum = Number(rateRaw)
  const ratePct = isNaN(rateNum) ? null : (rateNum <= 1 ? rateNum * 100 : rateNum)
  const weak = Number(o.scope === 'class'
    ? (s.weakStudentCount != null ? s.weakStudentCount : s.weakCount)
    : s.weakCount) || 0
  const severe = Number(o.scope === 'class'
    ? (s.severeStudentCount != null ? s.severeStudentCount : s.severeCount)
    : s.severeCount) || 0
  const thin = Number(o.scope === 'class'
    ? (s.thinSampleStudentCount != null ? s.thinSampleStudentCount : s.thinSampleCount)
    : s.thinSampleCount) || 0
  const low = Number(o.scope === 'class'
    ? (s.lowRateStudentCount != null ? s.lowRateStudentCount : s.lowRateCount)
    : s.lowRateCount) || 0

  let level = 'ok'
  let title = o.scope === 'class' ? String.fromCharCode(29677,32423,25972,20307,25484,25569,36739,22909) : String.fromCharCode(25972,20307,25484,25569,36739,22909)
  let subtitle = String.fromCharCode(27491,24335,34180,24369,20026,32,48,65292,21487,37325,28857,30475,36235,21183,19982,26657,27425,36827,36864,12290)
  if (severe > 0) {
    level = 'severe'
    title = o.scope === 'class'
      ? (String.fromCharCode(26377,32) + severe + String.fromCharCode(32,20154,27491,24335,20005,37325,65292,24314,35758,20248,20808,24178,39044))
      : (String.fromCharCode(26377,32) + severe + String.fromCharCode(32,20010,27491,24335,20005,37325,30693,35782,28857,65292,24314,35758,20248,20808,24178,39044))
    subtitle = String.fromCharCode(27491,24335,20005,37325,32,61,32,20302,25484,25569,19988,20316,31572,27425,25968,36798,26631,65307,21487,20808,34917,24369,25110,24314,24178,39044,12290)
  } else if (weak > 0) {
    level = 'weak'
    title = o.scope === 'class'
      ? (String.fromCharCode(26377,32) + weak + String.fromCharCode(32,20154,27491,24335,34180,24369))
      : (String.fromCharCode(26377,32) + weak + String.fromCharCode(32,20010,27491,24335,34180,24369,30693,35782,28857))
    subtitle = thin > 0
      ? (String.fromCharCode(21478,26377,26679,26412,19981,36275,32) + thin + (o.scope === 'class' ? String.fromCharCode(32,20154) : String.fromCharCode(32,39033)) + String.fromCharCode(65292,19981,23450,32423,65292,21247,19982,27491,24335,34180,24369,28151,35835,12290))
      : String.fromCharCode(21487,29992,19979,26041,34180,24369,21015,34920,19979,38075,39064,30446,65292,25110,19968,38190,34917,24369,32,47,32,24314,24178,39044,12290)
  } else if (thin > 0 || low > 0) {
    level = 'watch'
    title = o.scope === 'class'
      ? (String.fromCharCode(27491,24335,34180,24369,20026,32,48,65292,20294,26377,32508,21512,20302,20998,47,26679,26412,19981,36275))
      : (String.fromCharCode(27491,24335,34180,24369,20026,32,48,65292,20294,26377,32508,21512,20302,20998,25110,26679,26412,19981,36275))
    subtitle = String.fromCharCode(32508,21512,20302,20998,32,8800,32,27491,24335,34180,24369,65307,32451,20064,19981,36275,26102,21247,19979,23450,32423,32467,35770,65292,24314,35758,22686,21152,32771,26597,21518,20877,30475,12290)
  } else if (ratePct != null && ratePct < 60) {
    level = 'watch'
    title = String.fromCharCode(32508,21512,24471,20998,29575,20559,20302,65292,20294,26410,36798,27491,24335,23450,32423)
    subtitle = String.fromCharCode(21487,33021,26679,26412,20559,23569,25110,26410,36798,27425,25968,38376,27099,65307,35831,32467,21512,36235,21183,19982,23567,39064,26126,32454,35299,35835,12290)
  }

  const metrics = [
    {
      key: 'rate',
      label: o.scope === 'class' ? String.fromCharCode(29677,22343,24471,20998,29575) : String.fromCharCode(32508,21512,24471,20998,29575),
      value: formatRate(rateRaw),
      bar: ratePct,
      tone: ratePct != null && ratePct < 60 ? 'orange' : 'green',
      hint: String.fromCharCode(32451,20064,27425,25968,21152,26435)
    },
    {
      key: 'weak',
      label: o.scope === 'class' ? String.fromCharCode(27491,24335,34180,24369,20154,25968) : String.fromCharCode(27491,24335,34180,24369),
      value: String(weak),
      tone: weak > 0 ? 'orange' : 'green',
      hint: String.fromCharCode(36798,27425,25968,38376,27099,25165,23450,32423)
    },
    {
      key: 'severe',
      label: o.scope === 'class' ? String.fromCharCode(27491,24335,20005,37325,20154,25968) : String.fromCharCode(27491,24335,20005,37325),
      value: String(severe),
      tone: severe > 0 ? 'red' : 'green',
      hint: String.fromCharCode(20248,20808,24178,39044,23545,35937)
    },
    {
      key: 'thin',
      label: o.scope === 'class' ? String.fromCharCode(26679,26412,19981,36275,20154,25968) : String.fromCharCode(26679,26412,19981,36275),
      value: String(thin),
      tone: thin > 0 ? 'purple' : 'blue',
      hint: String.fromCharCode(19981,23450,32423)
    }
  ]
  return { level, title, subtitle, metrics }
}

/**
 * One-glance verdict for knowledge-scope analysis page.
 * weakStudentCount here includes 关注/薄弱/严重 (旁路)，非班级页正式薄弱人数。
 */
export function buildKnowledgeVerdict(opts) {
  const o = opts || {}
  const s = o.overview || {}
  const formatRate = typeof o.formatRate === 'function' ? o.formatRate : (v => {
    if (v == null || v === '') return '-'
    const n = Number(v)
    if (isNaN(n)) return '-'
    return (n <= 1 ? n * 100 : n).toFixed(1) + '%'
  })
  const studentCount = Number(s.studentCount != null ? s.studentCount : s.totalStudents) || 0
  const weak = Number(s.weakStudentCount != null ? s.weakStudentCount : s.weakCount) || 0
  const rateRaw = s.avgRate != null ? s.avgRate : (s.averageRate != null ? s.averageRate : s.weightedRate)
  const rateNum = Number(rateRaw)
  const ratePct = isNaN(rateNum) ? null : (rateNum <= 1 ? rateNum * 100 : rateNum)
  const attemptAvg = s.avgAttemptCount != null ? s.avgAttemptCount : s.attemptCount
  const scopeLabel = o.scopeLabel || '当前范围'

  if (!studentCount && (ratePct == null)) {
    return {
      level: 'empty',
      title: '该范围暂无学生掌握度数据',
      subtitle: '可切换版本/章节，或确认学科与时间窗内有小题成绩。',
      metrics: []
    }
  }

  let level = 'ok'
  let title = scopeLabel + '整体掌握较好'
  let subtitle = '薄弱学生为 0（含关注档）；可下钻下级或查看得分分布。'
  if (weak > 0 && ratePct != null && ratePct < 45) {
    level = 'severe'
    title = '有 ' + weak + ' 名学生处于偏低档，建议优先看名单'
    subtitle = '本页「薄弱学生」含关注/薄弱/严重，不等于班级页正式薄弱人数。'
  } else if (weak > 0) {
    level = 'weak'
    title = '有 ' + weak + ' 名学生需关注或已定级偏低'
    subtitle = '点击下方学生分布或班级对比下钻；补弱请从学生/班级分析进入正式薄弱。'
  } else if (ratePct != null && ratePct < 60) {
    level = 'watch'
    title = '平均得分率偏低，但名单未标薄弱档'
    subtitle = '可能练习次数不足或门槛未达；请结合分布与练习次数解读。'
  }

  const metrics = [
    {
      key: 'avg',
      label: '平均得分率',
      value: rateRaw != null ? formatRate(rateRaw) : '-',
      bar: ratePct,
      tone: ratePct != null && ratePct < 60 ? 'orange' : 'green',
      hint: '所选范围学生均值'
    },
    {
      key: 'stu',
      label: '覆盖学生',
      value: String(studentCount),
      tone: 'blue',
      hint: '有统计记录'
    },
    {
      key: 'weak',
      label: '偏低档学生',
      value: String(weak),
      tone: weak > 0 ? 'orange' : 'green',
      hint: '关注/薄弱/严重·旁路'
    },
    {
      key: 'att',
      label: '平均练习次数',
      value: attemptAvg != null && !isNaN(Number(attemptAvg)) ? Number(attemptAvg).toFixed(1) : '-',
      tone: 'purple',
      hint: '关联题目作答'
    }
  ]
  return { level, title, subtitle, metrics }
}

/**
 * One-glance verdict for frequency × mastery page.
 */
export function buildFrequencyVerdict(opts) {
  const o = opts || {}
  const sum = o.summary || {}
  const pri = o.priority || {}
  const paperCount = Number(sum.paperCount) || 0
  const kp = Number(sum.knowledgeCount) || 0
  const q = Number(sum.questionLinkCount) || 0
  const priority = Number(pri.priorityCount) || 0
  const lowEv = Number(pri.lowEvidenceCount) || 0
  const solid = Number(pri.solidCount) || 0

  if (o.empty) {
    return {
      level: 'empty',
      title: '请选择试卷后查询考查频次',
      subtitle: '可单选或勾选多卷，对比知识点考查分布与掌握交叉。',
      metrics: []
    }
  }
  if (o.blocked) {
    return {
      level: 'blocked',
      title: '标注不足，交叉结论需谨慎',
      subtitle: o.blockReason || '请先补齐试卷知识点标注，再读优先干预象限。',
      metrics: [
        { key: 'papers', label: '所选试卷', value: String(paperCount), tone: 'blue', hint: '单次或多卷' },
        { key: 'kp', label: '涉及知识点', value: String(kp), tone: 'blue', hint: '叶子知识点' },
        { key: 'q', label: '题次合计', value: String(q), tone: 'orange', hint: '各知识点题次数之和' },
        { key: 'pri', label: '优先干预', value: String(priority), tone: 'red', hint: '非正式薄弱' }
      ]
    }
  }

  let level = 'ok'
  let title = '考查分布正常，优先干预为 0'
  let subtitle = '象限为考查×掌握交叉，不等同正式薄弱定级；可点柱条下钻知识点。'
  if (priority > 0) {
    level = 'severe'
    title = '有 ' + priority + ' 个知识点属优先干预'
    subtitle = '考得多且掌握偏低（非正式薄弱）。可导出补弱包或下钻分析。'
  } else if (lowEv > 0) {
    level = 'watch'
    title = '优先干预为 0，但有 ' + lowEv + ' 项证据不足'
    subtitle = '练习次数未达交叉门槛，勿与正式薄弱混读；可增加考查后再看。'
  } else if (kp === 0) {
    level = 'empty'
    title = '所选试卷暂无知识点关联'
    subtitle = '请检查试卷标注，或换一组已发布试卷。'
  }

  return {
    level,
    title,
    subtitle,
    metrics: [
      { key: 'papers', label: '所选试卷', value: String(paperCount), tone: 'blue', hint: '单次或多卷' },
      { key: 'kp', label: '涉及知识点', value: String(kp), tone: 'green', hint: '叶子知识点' },
      {
        key: 'pri',
        label: '优先干预',
        value: String(priority),
        tone: priority > 0 ? 'red' : 'green',
        hint: '非正式薄弱'
      },
      {
        key: 'solid',
        label: '稳固 / 证据不足',
        value: solid + ' / ' + lowEv,
        tone: lowEv > 0 ? 'orange' : 'blue',
        hint: '交叉象限'
      }
    ]
  }
}

/**
 * Collect knowledgeIds from formal-weak rows for batch remediate (选题中心 knowledgeIds).
 * @param {Array} rows weak / priority rows
 * @param {number} limit max ids (default 5)
 */
export function formalWeakKnowledgeIds(rows, limit) {
  const max = limit != null && Number(limit) > 0 ? Number(limit) : 5
  const ids = []
  const seen = {}
  if (!Array.isArray(rows)) return ids
  for (let i = 0; i < rows.length && ids.length < max; i++) {
    const r = rows[i]
    if (!r || !isFormalWeak(r)) continue
    // Skip thin-sample rows even if weak_level was stamped elsewhere
    if (isLowEvidence(r)) continue
    const id = r.knowledgeId != null ? r.knowledgeId : r.id
    if (id == null || id === '') continue
    const key = String(id)
    if (seen[key]) continue
    seen[key] = true
    ids.push(id)
  }
  return ids
}

/**
 * One-line "为什么弱" tip from question-type / Bloom dim tables.
 * Skips unlabeled rows and low coverage; requires a few attempts.
 * @param {Function} formatRate (rate) => '42%' style string
 */
export function buildDimWeakTip(questionTypeItems, bloomItems, questionTypeSummary, bloomSummary, formatRate) {
  const qtCov = questionTypeSummary && questionTypeSummary.coverageRate != null
    ? Number(questionTypeSummary.coverageRate) : null
  const bloomCov = bloomSummary && bloomSummary.coverageRate != null
    ? Number(bloomSummary.coverageRate) : null
  if ((qtCov != null && qtCov < 0.6) && (bloomCov != null && bloomCov < 0.6)) {
    return ''
  }
  const pickLowest = (rows, labelKeys, codeKeys) => {
    if (!Array.isArray(rows) || !rows.length) return null
    let best = null
    let bestRate = null
    for (let i = 0; i < rows.length; i++) {
      const r = rows[i]
      if (!r) continue
      const code = String((codeKeys.map(k => r[k]).find(v => v != null && v !== '') || ''))
      if (!code || code === '_unlabeled' || code === 'unlabeled') continue
      const attempts = Number(r.attemptCount != null ? r.attemptCount : r.questionCount)
      if (!isNaN(attempts) && attempts < 2) continue
      const rate = Number(r.avgRate != null ? r.avgRate : r.rate)
      if (isNaN(rate)) continue
      if (bestRate == null || rate < bestRate) {
        bestRate = rate
        const label = labelKeys.map(k => r[k]).find(v => v != null && v !== '') || code
        best = { label: String(label), rate }
      }
    }
    return best
  }
  const parts = []
  if (qtCov == null || qtCov >= 0.6) {
    const qt = pickLowest(questionTypeItems, ['typeName', 'typeLabel'], ['typeCode', 'questionType'])
    if (qt && formatRate) {
      parts.push('题型短板「' + qt.label + '」' + formatRate(qt.rate))
    }
  }
  if (bloomCov == null || bloomCov >= 0.6) {
    const bl = pickLowest(bloomItems, ['bloomLabel', 'bloomName'], ['bloomLevel', 'bloom'])
    if (bl && formatRate) {
      parts.push('能力层短板「' + bl.label + '」' + formatRate(bl.rate))
    }
  }
  if (!parts.length) return ''
  return '为什么弱：' + parts.join('；') + '。详见下方多维表。'
}

/**
 * Build a weekly learning prescription from formal-weak rows (student analysis).
 * Only formalWeak; soft-sort by prerequisite rootHint when present.
 * @param {Object} opts
 * @param {Array} opts.weakRows
 * @param {boolean} [opts.blocked]
 * @param {string} [opts.blockReason]
 * @param {boolean} [opts.empty]
 * @param {number} [opts.limit=5]
 * @param {number} [opts.minAttempts=3]
 * @param {number} [opts.targetRate=0.6]
 * @param {Function} [opts.formatRate]
 */
export function buildStudentPrescription(opts) {
  const o = opts || {}
  const limit = o.limit != null && Number(o.limit) > 0 ? Number(o.limit) : 5
  const minAttempts = o.minAttempts != null ? Number(o.minAttempts) : 3
  const targetRate = o.targetRate != null ? Number(o.targetRate) : 0.6
  const formatRate = typeof o.formatRate === 'function' ? o.formatRate : (v => {
    if (v == null || v === '') return '-'
    const n = Number(v)
    if (isNaN(n)) return '-'
    return (n <= 1 ? n * 100 : n).toFixed(1) + '%'
  })
  const targetLabel = formatRate(targetRate)

  if (o.empty) {
    return {
      status: 'empty',
      title: '\u6682\u65e0\u5b66\u4e60\u5904\u65b9',
      subtitle: '\u672c\u5b66\u79d1\u6682\u65e0\u5c0f\u9898\u6210\u7ee9\uff0c\u638c\u63e1\u5ea6\u4e0d\u53ef\u7528\uff1b\u8bf7\u5148\u5bfc\u5165\u5c0f\u9898\u6216\u67e5\u770b\u5b9e\u8003\u6821\u6b21\u3002',
      passRule: '',
      items: [],
      knowledgeIds: []
    }
  }
  if (o.blocked) {
    return {
      status: 'blocked',
      title: '\u6807\u6ce8\u4e0d\u8db3\uff0c\u6682\u4e0d\u751f\u6210\u5904\u65b9',
      subtitle: o.blockReason || '\u8bf7\u5148\u8865\u9f50\u8bd5\u5377\u77e5\u8bc6\u70b9\u6807\u6ce8\u540e\u518d\u5b9a\u7ea7\u3001\u4e0b\u53d1\u6307\u5bfc\u3002',
      passRule: '',
      items: [],
      knowledgeIds: []
    }
  }

  const rows = Array.isArray(o.weakRows) ? o.weakRows.filter(r => r && isFormalWeak(r) && !isLowEvidence(r)) : []
  const rowId = (r) => {
    const id = r && (r.knowledgeId != null ? r.knowledgeId : r.id)
    return id == null || id === '' ? '' : String(id)
  }
  const prereqFromIds = (r) => {
    const ids = []
    if (Array.isArray(r.dependencyHints)) {
      for (let i = 0; i < r.dependencyHints.length; i++) {
        const h = r.dependencyHints[i]
        if (h && h.fromKnowledgeId != null) ids.push(String(h.fromKnowledgeId))
      }
    }
    if (r.rootHintDetail && r.rootHintDetail.fromKnowledgeId != null) {
      ids.push(String(r.rootHintDetail.fromKnowledgeId))
    }
    return ids
  }
  const idSet = {}
  rows.forEach(r => {
    const id = rowId(r)
    if (id) idSet[id] = true
  })
  // G6: prereq (from) before dependent (to); fewer in-set prereqs first
  rows.sort((a, b) => {
    const aId = rowId(a)
    const bId = rowId(b)
    const aPre = prereqFromIds(a).filter(id => idSet[id])
    const bPre = prereqFromIds(b).filter(id => idSet[id])
    if (aPre.indexOf(bId) >= 0) return 1
    if (bPre.indexOf(aId) >= 0) return -1
    if (aPre.length !== bPre.length) return aPre.length - bPre.length
    const as = Number(a.weakLevel != null ? a.weakLevel : 9)
    const bs = Number(b.weakLevel != null ? b.weakLevel : 9)
    if (as !== bs) return bs - as
    return 0
  })

  // Mark ids that are prerequisites of another formal-weak item in this set
  const isPrereqOfOther = {}
  rows.forEach(r => {
    prereqFromIds(r).forEach(pid => {
      if (idSet[pid]) isPrereqOfOther[pid] = true
    })
  })

  const items = []
  const knowledgeIds = []
  const seen = {}
  for (let i = 0; i < rows.length && items.length < limit; i++) {
    const r = rows[i]
    const id = r.knowledgeId != null ? r.knowledgeId : r.id
    if (id == null || id === '') continue
    const key = String(id)
    if (seen[key]) continue
    seen[key] = true
    knowledgeIds.push(id)
    const name = r.knowledgeName || r.name || ('#' + id)
    const rate = r.weightedRate != null ? r.weightedRate : (r.rate != null ? r.rate : r.avgRate)
    const attempts = r.attemptCount != null ? r.attemptCount : r.attempts
    let prereq = ''
    if (r.rootHint) prereq = String(r.rootHint)
    else if (Array.isArray(r.dependencyHints) && r.dependencyHints.length) {
      prereq = r.dependencyHints.map(h => (h && (h.fromKnowledgeName || h.rootHint || h)) || '').filter(Boolean).join('\u3001')
    }
    items.push({
      knowledgeId: id,
      knowledgeName: String(name),
      rateLabel: formatRate(rate),
      attemptCount: attempts != null ? Number(attempts) : null,
      weakLevel: r.weakLevel != null ? String(r.weakLevel) : '',
      prereq,
      suggestFirst: !!isPrereqOfOther[key],
      passHint: '\u5efa\u8bae\u4f5c\u7b54\u2265' + minAttempts + '\u6b21\uff0c\u590d\u6d4b\u5f97\u5206\u7387\u2265' + targetLabel + '\u4e14\u9000\u51fa\u6b63\u5f0f\u8584\u5f31'
    })
  }

  if (!items.length) {
    return {
      status: 'none',
      title: '\u6682\u65e0\u6b63\u5f0f\u8584\u5f31\u5904\u65b9',
      subtitle: '\u6b63\u5f0f\u8584\u5f31\u4e3a 0\u3002\u82e5\u4ec5\u6709\u7efc\u5408\u4f4e\u5206/\u6837\u672c\u4e0d\u8db3\uff0c\u8bf7\u5148\u589e\u52a0\u8003\u67e5\u518d\u5b9a\u7ea7\uff0c\u52ff\u76f4\u63a5\u6279\u91cf\u8865\u5f31\u3002',
      passRule: '\u8fc7\u5173\u53e3\u5f84\uff1a\u4f5c\u7b54\u2265' + minAttempts + '\u6b21\u4e14\u8be5\u70b9\u9000\u51fa\u6b63\u5f0f\u8584\u5f31\uff08\u76ee\u6807\u7387 ' + targetLabel + '\uff09',
      items: [],
      knowledgeIds: []
    }
  }

  return {
    status: 'ready',
    title: '\u672c\u5468\u5b66\u4e60\u5904\u65b9\uff08' + items.length + '\u4e2a\u6b63\u5f0f\u8584\u5f31\u70b9\uff09',
    subtitle: '\u4ec5 formalWeak\uff1b\u5148\u4fee\u70b9\uff08\u88ab\u4f9d\u8d56\uff09\u6392\u5728\u524d\uff0c\u4f9d\u8d56\u70b9\u6392\u540e\u3002\u81ea\u4e3b\u7ec3\u4e0d\u7b49\u4e8e\u638c\u63e1\u5ea6\u8fc7\u5173\u3002',
    passRule: '\u8fc7\u5173\uff1a\u6bcf\u70b9\u4f5c\u7b54\u2265' + minAttempts + '\u6b21\uff0c\u590d\u6d4b\u5f97\u5206\u7387\u2265' + targetLabel + '\uff0c\u4e14\u9000\u51fa\u6b63\u5f0f\u8584\u5f31\u3002',
    items,
    knowledgeIds
  }
}

