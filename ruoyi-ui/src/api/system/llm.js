import request from '@/utils/request'

export function getLlmConfig() {
  return request({ url: '/system/llm', method: 'get' })
}

export function saveLlmConfig(data) {
  return request({ url: '/system/llm', method: 'put', data })
}

export function testLlmConfig(data) {
  return request({ url: '/system/llm/test', method: 'post', data, timeout: 60000 })
}
