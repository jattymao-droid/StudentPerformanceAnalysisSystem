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
