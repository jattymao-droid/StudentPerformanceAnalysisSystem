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

/** 知识点学情概览 */
export function overviewKnowledge(knowledgeId, query) {
  return request({
    url: '/spas/analysis/knowledge/' + knowledgeId + '/overview',
    method: 'get',
    params: query
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
export function recalcPaper(paperId) {
  return request({
    url: '/spas/analysis/recalc/paper/' + paperId,
    method: 'post'
  })
}

/** 按学生重算知识点统计 */
export function recalcStudent(studentId) {
  return request({
    url: '/spas/analysis/recalc/student/' + studentId,
    method: 'post'
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
export function trendClass(deptId, query) {
  return request({
    url: '/spas/analysis/class/' + deptId + '/trend',
    method: 'get',
    params: query
  })
}
