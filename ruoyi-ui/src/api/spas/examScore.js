import request from '@/utils/request'

export function listExamScore(query) {
  return request({
    url: '/spas/examScore/list',
    method: 'get',
    params: query
  })
}

export function getExamScoreMatrix(examId) {
  return request({
    url: '/spas/examScore/' + examId + '/matrix',
    method: 'get'
  })
}

export function importExamScore(data) {
  return request({
    url: '/spas/examScore/import',
    method: 'post',
    data: data,
    headers: { 'Content-Type': 'multipart/form-data', repeatSubmit: false },
    timeout: 120000
  })
}

export function delExamScore(examIds) {
  return request({
    url: '/spas/examScore/' + examIds,
    method: 'delete'
  })
}

export function getRankTrend(studentId, query) {
  return request({
    url: '/spas/examScore/studentRankTrend',
    method: 'get',
    params: Object.assign({ studentId: studentId }, query || {})
  })
}
