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

/** 智能分组：mode=unassigned|rebuild，groupSize=3..8 */
export function smartAssignGroups(data) {
  return request({ url: '/spas/group/smart', method: 'post', data })
}

/** 小组成员成绩 + 历次考试均分/均次趋势 */
export function getGroupPerformance(groupId, query) {
  return request({ url: '/spas/group/' + groupId + '/performance', method: 'get', params: query })
}
