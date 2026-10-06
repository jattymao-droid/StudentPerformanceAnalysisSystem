import request from '@/utils/request'

export function listPractice(query) {
  return request({ url: '/spas/practice/list', method: 'get', params: query })
}

export function getPractice(logId) {
  return request({ url: '/spas/practice/' + logId, method: 'get' })
}

export function addPractice(data) {
  return request({ url: '/spas/practice', method: 'post', data })
}

export function proxyPractice(data) {
  return request({ url: '/spas/practice/proxy', method: 'post', data })
}

export function updatePractice(data) {
  return request({ url: '/spas/practice', method: 'put', data })
}

export function delPractice(logId) {
  return request({ url: '/spas/practice/' + logId, method: 'delete' })
}

export function minePracticeToday(query) {
  return request({ url: '/spas/practice/mine/today', method: 'get', params: query })
}

export function suggestPracticeWeak(query) {
  return request({ url: '/spas/practice/suggest/weak', method: 'get', params: query })
}

export function suggestPracticeBooks(query) {
  return request({ url: '/spas/practice/books/suggest', method: 'get', params: query })
}

export function groupPracticeToday(query) {
  return request({ url: '/spas/practice/group/today', method: 'get', params: query })
}

export function practiceDailyStat(query) {
  return request({ url: '/spas/practice/stat/daily', method: 'get', params: query })
}

export function practiceAlerts(query) {
  return request({ url: '/spas/practice/stat/alerts', method: 'get', params: query })
}

export function practiceOverlap(query) {
  return request({ url: '/spas/practice/stat/overlap', method: 'get', params: query })
}

export function practiceSpotSample(query) {
  return request({ url: '/spas/practice/stat/spot-sample', method: 'get', params: query })
}

export function updatePracticeSpot(logId, data) {
  return request({ url: '/spas/practice/' + logId + '/spot', method: 'put', data })
}

export function practiceToIntervene(logId) {
  return request({ url: '/spas/practice/alert/' + logId + '/to-intervene', method: 'post' })
}

export function practiceSessionProfile() {
  return request({ url: '/spas/practice/session/profile', method: 'get' })
}

export function practiceDeviceHeartbeat(data) {
  return request({ url: '/spas/practice/device/heartbeat', method: 'post', data })
}

export function listPracticeDevices(query) {
  return request({ url: '/spas/practice/device/list', method: 'get', params: query })
}

export function practiceStillWeak(query) {
  return request({ url: '/spas/practice/stat/still-weak', method: 'get', params: query })
}

export function practicePinStatus() {
  return request({ url: '/spas/practice/pin/status', method: 'get' })
}

export function setPracticePin(data) {
  return request({ url: '/spas/practice/pin', method: 'put', data })
}

export function pendingProxyConfirm() {
  return request({ url: '/spas/practice/proxy/pending', method: 'get' })
}

export function confirmProxyPractice(logId, accept) {
  return request({ url: '/spas/practice/proxy/' + logId + '/confirm', method: 'put', data: { accept } })
}

export function practicePointsMine() {
  return request({ url: '/spas/practice/points/mine', method: 'get' })
}

export function practicePointsLedger(query) {
  return request({ url: '/spas/practice/points/ledger', method: 'get', params: query })
}

export function practicePointsLeaderboard(query) {
  return request({ url: '/spas/practice/points/leaderboard', method: 'get', params: query })
}

export function listPracticeAssignment(query) {
  return request({ url: '/spas/practice/assignment/list', method: 'get', params: query })
}

export function savePracticeAssignment(data) {
  return request({ url: '/spas/practice/assignment', method: 'post', data })
}

export function copyLastPracticeAssignment(data) {
  return request({ url: '/spas/practice/assignment/copy-last', method: 'post', data })
}

export function checkoutToday(query) {
  return request({ url: '/spas/practice/checkout/today', method: 'get', params: query })
}

export function submitPracticeCheckout(data) {
  return request({ url: '/spas/practice/checkout', method: 'post', data })
}

export function ackCheckoutItem(itemId, accept) {
  return request({ url: '/spas/practice/checkout/item/' + itemId + '/ack', method: 'put', data: { accept } })
}

export function followCheckoutItem(itemId) {
  return request({ url: '/spas/practice/checkout/item/' + itemId + '/follow', method: 'put' })
}

export function checkoutToIntervene(itemId) {
  return request({ url: '/spas/practice/checkout/item/' + itemId + '/to-intervene', method: 'post' })
}

export function practiceCheckoutAlerts(query) {
  return request({ url: '/spas/practice/stat/checkout-alerts', method: 'get', params: query })
}

export function practiceSpotQueue(query) {
  return request({ url: '/spas/practice/stat/spot-queue', method: 'get', params: query })
}

export function recordCheckoutSpot(itemId, data) {
  return request({ url: '/spas/practice/spot/' + itemId, method: 'put', data })
}
