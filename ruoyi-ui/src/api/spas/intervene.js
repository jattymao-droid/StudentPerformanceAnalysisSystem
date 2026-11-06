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

/** 统一转干预：sourceType = warning | practice_log | checkout_item */
export function createInterveneFromSource(data) {
  return request({
    url: '/spas/intervene/from-source',
    method: 'post',
    data
  })
}

/** @deprecated 请用 createInterveneFromSource({ sourceType:'warning', sourceId }) */
export function createFromWarning(warningId, data) {
  return createInterveneFromSource(Object.assign({}, data || {}, {
    sourceType: 'warning',
    sourceId: warningId
  }))
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

export function classInterveneSummary(deptId, query) {
  return request({
    url: '/spas/intervene/class/' + deptId + '/summary',
    method: 'get',
    params: query
  })
}

export function batchWeakIntervene(data) {
  return request({
    url: '/spas/intervene/batch-weak',
    method: 'post',
    data
  })
}

export function interveneProgress(interveneId) {
  return request({
    url: '/spas/intervene/' + interveneId + '/progress',
    method: 'get'
  })
}

export function addInterveneAction(interveneId, data) {
  return request({
    url: '/spas/intervene/' + interveneId + '/actions',
    method: 'post',
    data
  })
}

export function updateInterveneAction(data) {
  return request({
    url: '/spas/intervene/actions',
    method: 'put',
    data
  })
}

export function linkInterveneAssignment(interveneId, assignmentId) {
  return request({
    url: '/spas/intervene/' + interveneId + '/link-assignment',
    method: 'post',
    data: { assignmentId }
  })
}

export function linkInterveneSelect(interveneId, refId) {
  return request({
    url: '/spas/intervene/' + interveneId + '/link-select',
    method: 'post',
    data: { refId }
  })
}
