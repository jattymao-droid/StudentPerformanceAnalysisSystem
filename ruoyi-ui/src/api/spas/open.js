import request from '@/utils/request'

export function listOpenClient(query) {
  return request({ url: '/spas/open/client/list', method: 'get', params: query })
}

export function getOpenClient(clientId) {
  return request({ url: '/spas/open/client/' + clientId, method: 'get' })
}

export function addOpenClient(data) {
  return request({ url: '/spas/open/client', method: 'post', data })
}

export function updateOpenClient(data) {
  return request({ url: '/spas/open/client', method: 'put', data })
}

export function delOpenClient(clientIds) {
  return request({ url: '/spas/open/client/' + clientIds, method: 'delete' })
}

export function listOpenParent(query) {
  return request({ url: '/spas/open/parent/list', method: 'get', params: query })
}

export function getOpenParent(parentId) {
  return request({ url: '/spas/open/parent/' + parentId, method: 'get' })
}

export function addOpenParent(data) {
  return request({ url: '/spas/open/parent', method: 'post', data })
}

export function updateOpenParent(data) {
  return request({ url: '/spas/open/parent', method: 'put', data })
}

export function delOpenParent(parentIds) {
  return request({ url: '/spas/open/parent/' + parentIds, method: 'delete' })
}

export function listParentStudents(parentId) {
  return request({ url: '/spas/open/parent/' + parentId + '/students', method: 'get' })
}

export function bindParentStudent(parentId, studentId) {
  return request({ url: '/spas/open/parent/' + parentId + '/bind/' + studentId, method: 'post' })
}

export function unbindParentStudent(parentId, studentId) {
  return request({ url: '/spas/open/parent/' + parentId + '/bind/' + studentId, method: 'delete' })
}
