import request from '@/utils/request'

export function previewStudentReport(studentId, query) {
  return request({
    url: '/spas/report/preview/student/' + studentId,
    method: 'get',
    params: query
  })
}

export function previewClassReport(deptId, query) {
  return request({
    url: '/spas/report/preview/class/' + deptId,
    method: 'get',
    params: query
  })
}
