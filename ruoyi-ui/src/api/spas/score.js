import request from '@/utils/request'

export function listScoreBatch(query) {
  return request({
    url: '/spas/score/batch/list',
    method: 'get',
    params: query
  })
}

export function listScoreDetail(query) {
  return request({
    url: '/spas/score/detail/list',
    method: 'get',
    params: query
  })
}

export function revokeScoreBatch(batchId) {
  return request({
    url: '/spas/score/batch/' + batchId,
    method: 'delete'
  })
}
