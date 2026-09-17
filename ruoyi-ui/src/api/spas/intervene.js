import request from '@/utils/request'

export function listIntervene(query) {
  return request({
    url: '/spas/intervene/list',
    method: 'get',
    params: query
  })
}

export function getIntervene(interveneId) {
  return request({
    url: '/spas/intervene/' + interveneId,
    method: 'get'
  })
}

export function addIntervene(data) {
  return request({
    url: '/spas/intervene',
    method: 'post',
    data
  })
}

export function updateIntervene(data) {
  return request({
    url: '/spas/intervene',
    method: 'put',
    data
  })
}

export function createFromWarning(warningId, data) {
  return request({
    url: '/spas/intervene/from-warning/' + warningId,
    method: 'post',
    data: data || {}
  })
}

export function evaluateIntervene(interveneId) {
  return request({
    url: '/spas/intervene/' + interveneId + '/evaluate',
    method: 'post'
  })
}

export function interveneTimeline(studentId) {
  return request({
    url: '/spas/intervene/student/' + studentId + '/timeline',
    method: 'get'
  })
}
