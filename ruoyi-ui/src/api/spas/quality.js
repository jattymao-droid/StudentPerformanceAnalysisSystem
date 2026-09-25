import request from '@/utils/request'

export function qualityOverview(query) {
  return request({
    url: '/spas/quality/overview',
    method: 'get',
    params: query
  })
}

export function qualityDetail(query) {
  return request({
    url: '/spas/quality/detail',
    method: 'get',
    params: query
  })
}

export function listQualityTicket(query) {
  return request({
    url: '/spas/quality/ticket/list',
    method: 'get',
    params: query
  })
}

export function addQualityTicket(data) {
  return request({
    url: '/spas/quality/ticket',
    method: 'post',
    data
  })
}

export function updateQualityTicket(data) {
  return request({
    url: '/spas/quality/ticket',
    method: 'put',
    data
  })
}

export function delQualityTicket(ticketIds) {
  return request({
    url: '/spas/quality/ticket/' + ticketIds,
    method: 'delete'
  })
}
