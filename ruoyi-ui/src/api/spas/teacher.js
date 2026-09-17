import request from '@/utils/request'

export function listTeacher(query) {
  return request({ url: '/spas/teacher/list', method: 'get', params: query })
}

export function getTeacher(teacherId) {
  return request({ url: '/spas/teacher/' + teacherId, method: 'get' })
}

export function addTeacher(data) {
  return request({ url: '/spas/teacher', method: 'post', data })
}

export function updateTeacher(data) {
  return request({ url: '/spas/teacher', method: 'put', data })
}

export function delTeacher(teacherId) {
  return request({ url: '/spas/teacher/' + teacherId, method: 'delete' })
}

export function resetTeacherPwd(teacherId) {
  return request({ url: '/spas/teacher/resetPwd/' + teacherId, method: 'put' })
}

export function listTeacherRoleOptions() {
  return request({ url: '/spas/teacher/role-options', method: 'get' })
}

export function listMyTeachingDepts() {
  return request({ url: '/spas/teacher/my-depts', method: 'get' })
}
