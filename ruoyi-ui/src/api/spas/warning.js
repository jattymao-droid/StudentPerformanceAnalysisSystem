import request from '@/utils/request'

export function listWarningRule(query) {
  return request({ url: '/spas/warning/rule/list', method: 'get', params: query })
}

export function getWarningRule(ruleId) {
  return request({ url: '/spas/warning/rule/' + ruleId, method: 'get' })
}

export function addWarningRule(data) {
  return request({ url: '/spas/warning/rule', method: 'post', data: data })
}

export function updateWarningRule(data) {
  return request({ url: '/spas/warning/rule', method: 'put', data: data })
}

export function delWarningRule(ruleId) {
  return request({ url: '/spas/warning/rule/' + ruleId, method: 'delete' })
}

export function runWarningEngine() {
  return request({ url: '/spas/warning/rule/run', method: 'post' })
}

export function listWarningRecord(query) {
  return request({ url: '/spas/warning/record/list', method: 'get', params: query })
}

export function getWarningRecord(warningId) {
  return request({ url: '/spas/warning/record/' + warningId, method: 'get' })
}

export function handleWarningRecord(data) {
  return request({ url: '/spas/warning/record/handle', method: 'put', data: data })
}
