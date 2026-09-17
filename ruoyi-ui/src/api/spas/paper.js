import request from '@/utils/request'

export function listPaper(query) {
  return request({
    url: '/spas/paper/list',
    method: 'get',
    params: query
  })
}

export function getPaper(paperId) {
  return request({
    url: '/spas/paper/' + paperId,
    method: 'get'
  })
}

export function addPaper(data) {
  return request({
    url: '/spas/paper',
    method: 'post',
    data: data
  })
}

export function updatePaper(data) {
  return request({
    url: '/spas/paper',
    method: 'put',
    data: data
  })
}

export function delPaper(paperId) {
  return request({
    url: '/spas/paper/' + paperId,
    method: 'delete'
  })
}

export function publishPaper(paperId) {
  return request({
    url: '/spas/paper/publish/' + paperId,
    method: 'put'
  })
}

export function archivePaper(paperId) {
  return request({
    url: '/spas/paper/archive/' + paperId,
    method: 'put'
  })
}

export function copyPaper(paperId) {
  return request({
    url: '/spas/paper/copy/' + paperId,
    method: 'post'
  })
}
