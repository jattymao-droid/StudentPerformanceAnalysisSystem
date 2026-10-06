import request from '@/utils/request'

export function listStudyGroup(query) {
  return request({ url: '/spas/group/list', method: 'get', params: query })
}

export function getStudyGroup(groupId) {
  return request({ url: '/spas/group/' + groupId, method: 'get' })
}

export function addStudyGroup(data) {
  return request({ url: '/spas/group', method: 'post', data })
}

export function updateStudyGroup(data) {
  return request({ url: '/spas/group', method: 'put', data })
}

export function delStudyGroup(groupIds) {
  return request({ url: '/spas/group/' + groupIds, method: 'delete' })
}

export function saveStudyGroupMembers(groupId, data) {
  return request({ url: '/spas/group/' + groupId + '/members', method: 'put', data })
}

export function listUnassignedStudents(query) {
  return request({ url: '/spas/group/unassigned', method: 'get', params: query })
}
