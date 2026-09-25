import request from '@/utils/request'

export function listErrorTags(studentId) {
  return request({
    url: '/spas/errorTag/student/' + studentId,
    method: 'get'
  })
}

export function saveErrorTag(data) {
  return request({
    url: '/spas/errorTag',
    method: 'put',
    data: data
  })
}

export function removeErrorTag(studentId, questionId) {
  return request({
    url: '/spas/errorTag/student/' + studentId + '/question/' + questionId,
    method: 'delete'
  })
}
