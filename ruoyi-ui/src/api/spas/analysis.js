import request from '@/utils/request'

/** 学生学情综合摘要 */
export function summaryStudent(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/summary',
    method: 'get',
    params: query
  })
}

/** 学生知识点雷达 */
export function radarStudent(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/radar',
    method: 'get',
    params: query
  })
}

/** 学生成绩趋势 */
export function trendStudent(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/trend',
    method: 'get',
    params: query
  })
}

/** 学生薄弱知识点 Top */
export function weakTopStudent(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/weak-top',
    method: 'get',
    params: query
  })
}

/** 班级薄弱知识点 Top */
export function weakTopClass(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/weak-top',
    method: 'get',
    params: query
  })
}

/** 班级知识点热力图 */
export function heatmapClass(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/heatmap',
    method: 'get',
    params: query
  })
}

/** 班级学情概览 */
export function overviewClass(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/overview',
    method: 'get',
    params: query
  })
}

/** 知识点学情概览；knowledgeId 为空时按学科汇总全部知识点 */
export function overviewKnowledge(knowledgeId, query) {
  const params = Object.assign({}, query || {})
  if (knowledgeId != null && knowledgeId !== '' && knowledgeId !== 'all') {
    params.knowledgeId = knowledgeId
  }
  return request({
    url: '/spas/analysis/knowledge/overview',
    method: 'get',
    params
  })
}

/** 学生某知识点题目明细 */
export function studentKnowledgeQuestions(studentId, knowledgeId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/knowledge/' + knowledgeId + '/questions',
    method: 'get',
    params: query
  })
}

/** 按试卷重算知识点统计 */
export function recalcPaper(paperId, query) {
  return request({
    url: '/spas/analysis/recalc/paper/' + paperId,
    method: 'post',
    params: query
  })
}

/** 按学生重算知识点统计 */
export function recalcStudent(studentId, query) {
  return request({
    url: '/spas/analysis/recalc/student/' + studentId,
    method: 'post',
    params: query
  })
}

/** 按班级/部门批量重算（新算法）并刷新预警 */
export function recalcDept(deptId, query) {
  return request({
    url: '/spas/analysis/recalc/dept/' + deptId,
    method: 'post',
    params: query
  })
}

/** 分析运行时配置（默认时间窗 / 近因半衰期 / 阈值） */
export function analysisConfig() {
  return request({
    url: '/spas/analysis/config',
    method: 'get'
  })
}

/** Student chapter radar (F4) */
export function chapterRadarStudent(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/chapter-radar',
    method: 'get',
    params: query
  })
}

/** Class chapter overview (F4) */
export function chapterOverviewClass(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/chapter-overview',
    method: 'get',
    params: query
  })
}

/** Class paper trend (F6) */
/** Class knowledge x exam trend */
export function classKnowledgeExamTrend(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/knowledge-exam-trend',
    method: 'get',
    params: query
  })
}

export function trendClass(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/trend',
    method: 'get',
    params: query
  })
}

/** 知识点考查频次（单次/多次试卷） */
export function knowledgeFrequency(query) {
  return request({
    url: '/spas/analysis/knowledge-frequency',
    method: 'get',
    params: query
  })
}

/** 考查频次 × 掌握度交叉（优先干预） */
export function knowledgePriority(query) {
  return request({
    url: '/spas/analysis/knowledge-priority',
    method: 'get',
    params: query
  })
}

/** 知识点 × 考试趋势（反复薄弱下钻） */
export function knowledgeExamTrend(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/knowledge-exam-trend',
    method: 'get',
    params: query
  })
}

/** 学生反复薄弱知识点标签 */
/** Papers vs baseline scope compare */
export function scopeCompareStudent(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/scope-compare',
    method: 'get',
    params: query
  })
}

export function persistentWeak(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/persistent-weak',
    method: 'get',
    params: query
  })
}

/** 选卷集合知识点标注覆盖（未绑定题占比） */
export function paperAnnotationCoverage(query) {
  return request({
    url: '/spas/analysis/paper-annotation-coverage',
    method: 'get',
    params: query
  })
}

/** D1: 学生题型表现 */
export function questionTypeStudent(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/question-type',
    method: 'get',
    params: query
  })
}

/** D1: 班级题型表现 */
export function questionTypeClass(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/question-type',
    method: 'get',
    params: query
  })
}

/** D4: 学生能力层级（Bloom） */
export function bloomStudent(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/bloom',
    method: 'get',
    params: query
  })
}

/** D4: 班级能力层级（Bloom） */
export function bloomClass(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/bloom',
    method: 'get',
    params: query
  })
}

/** D3: 学生章节进退 */
export function chapterDeltaStudent(studentId, query) {
  return request({
    url: '/spas/analysis/student/' + studentId + '/chapter-delta',
    method: 'get',
    params: query
  })
}

/** D3: 班级章节进退 */
export function chapterDeltaClass(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/chapter-delta',
    method: 'get',
    params: query
  })
}
