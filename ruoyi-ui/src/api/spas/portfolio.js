import request from '@/utils/request'

export function getPortfolio(studentId, query) {
  return request({
    url: '/spas/portfolio/' + studentId,
    method: 'get',
    params: query
  })
}

export function getMyPortfolio(query) {
  return request({
    url: '/spas/portfolio/mine',
    method: 'get',
    params: query
  })
}

export function addCoachLog(data) {
  return request({
    url: '/spas/portfolio/coach',
    method: 'post',
    data: data
  })
}
