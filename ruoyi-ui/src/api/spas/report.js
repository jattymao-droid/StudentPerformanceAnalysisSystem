import request from '@/utils/request'
import { tansParams } from '@/utils/ruoyi'

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

/** 全班学生学情 ZIP（可带 jobId 供进度轮询；不弹全局 Loading） */
export function exportClassStudentsZip(deptId, params) {
  return request({
    url: '/spas/report/class/' + deptId + '/students',
    method: 'post',
    data: params,
    headers: { 'Content-Type': 'application/x-www-form-urlencoded', repeatSubmit: false },
    transformRequest: [(data) => tansParams(data)],
    responseType: 'blob',
    timeout: 600000
  })
}

export function getClassStudentsExportProgress(jobId) {
  return request({
    url: '/spas/report/export-progress/' + encodeURIComponent(jobId),
    method: 'get'
  })
}
