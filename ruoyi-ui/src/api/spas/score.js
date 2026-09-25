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

export function getScoreDetail(detailId) {
  return request({
    url: '/spas/score/detail/' + detailId,
    method: 'get'
  })
}

export function addScoreDetail(data) {
  return request({
    url: '/spas/score/detail',
    method: 'post',
    data: data
  })
}

export function updateScoreDetail(data) {
  return request({
    url: '/spas/score/detail',
    method: 'put',
    data: data
  })
}

export function delScoreDetail(detailIds) {
  return request({
    url: '/spas/score/detail/' + detailIds,
    method: 'delete'
  })
}

export function revokeScoreBatch(batchId) {
  return request({
    url: '/spas/score/batch/' + batchId,
    method: 'delete'
  })
}
