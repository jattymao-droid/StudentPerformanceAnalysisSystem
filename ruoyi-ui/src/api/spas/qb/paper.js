import request from '@/utils/request'

export function listQbPaper(query) {
  return request({ url: '/spas/qb/paper/list', method: 'get', params: query })
}

export function getQbPaper(paperId) {
  return request({ url: '/spas/qb/paper/' + paperId, method: 'get' })
}

export function addQbPaper(data) {
  return request({ url: '/spas/qb/paper', method: 'post', data })
}

export function updateQbPaper(data) {
  return request({ url: '/spas/qb/paper', method: 'put', data })
}

export function delQbPaper(paperId) {
  return request({ url: '/spas/qb/paper/' + paperId, method: 'delete' })
}

export function saveQbPaperItems(paperId, data) {
  return request({ url: '/spas/qb/paper/' + paperId + '/items', method: 'put', data })
}

export function publishQbPaper(paperId, data) {
  return request({ url: '/spas/qb/paper/' + paperId + '/publish', method: 'post', data })
}

/** Class weak-top coverage for a bank paper */
export function weakCoverQbPaper(paperId, params) {
  return request({ url: '/spas/qb/paper/' + paperId + '/weak-cover', method: 'get', params })
}

/** Pre-publish annotation issues (unbound / weight) */
export function annotationCheckQbPaper(paperId) {
  return request({ url: '/spas/qb/paper/' + paperId + '/annotation-check', method: 'get' })
}
