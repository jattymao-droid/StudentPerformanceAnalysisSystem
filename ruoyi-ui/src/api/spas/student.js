import request from '@/utils/request'

export function listStudent(query) {
  return request({ url: '/spas/student/list', method: 'get', params: query })
}

export function getStudent(studentId) {
  return request({ url: '/spas/student/' + studentId, method: 'get' })
}

export function addStudent(data) {
  return request({ url: '/spas/student', method: 'post', data: data })
}

export function updateStudent(data) {
  return request({ url: '/spas/student', method: 'put', data: data })
}

export function delStudent(studentId) {
  return request({ url: '/spas/student/' + studentId, method: 'delete' })
}

export function resetStudentPwd(studentId) {
  return request({ url: '/spas/student/resetPwd/' + studentId, method: 'put' })
}

export function importStudent(data) {
  return request({
    url: '/spas/student/importData',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data: data
  })
}
