import request from '@/utils/request'

export function getDashboardOverview() {
  return request({
    url: '/spas/dashboard/overview',
    method: 'get'
  })
}
