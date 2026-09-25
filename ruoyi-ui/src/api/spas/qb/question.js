import request from '@/utils/request'

export function listQbQuestion(query) {
  return request({ url: '/spas/qb/question/list', method: 'get', params: query })
}

export function getQbQuestion(questionId) {
  return request({ url: '/spas/qb/question/' + questionId, method: 'get' })
}

export function addQbQuestion(data) {
  return request({ url: '/spas/qb/question', method: 'post', data })
}

export function updateQbQuestion(data) {
  return request({ url: '/spas/qb/question', method: 'put', data })
}

export function delQbQuestion(questionId) {
  return request({ url: '/spas/qb/question/' + questionId, method: 'delete' })
}

export function checkQbDup(params) {
  return request({ url: '/spas/qb/question/check-dup', method: 'get', params })
}

export function saveQbKnowledge(questionId, data) {
  return request({ url: '/spas/qb/question/' + questionId + '/knowledge', method: 'put', data })
}

export function aiSuggestQbKnowledge(questionId) {
  return request({ url: '/spas/qb/question/' + questionId + '/ai-suggest', method: 'post' })
}

/** Parse plain text from client OCR into candidate questions */
export function parseQbOcrText(data) {
  return request({ url: '/spas/qb/question/parse-ocr-text', method: 'post', data, timeout: 120000 })
}

/** Upload docx/pdf and parse into candidate questions */
export function parseQbPaper(data) {
  return request({
    url: '/spas/qb/question/parse-paper',
    method: 'post',
    data: data,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

/** Smart annotate: type + chapter + knowledge for import preview rows */
export function smartAnnotateQb(data) {
  return request({
    url: '/spas/qb/question/smart-annotate',
    method: 'post',
    data: data
  })
}

/** Polish stem formulas (local + optional remote LLM) */
export function polishQbFormula(data) {
  return request({
    url: '/spas/qb/question/polish-formula',
    method: 'post',
    data: data,
    timeout: 90000
  })
}

/** Batch polish stems (local + optional remote) */
export function polishQbFormulaBatch(data) {
  return request({
    url: '/spas/qb/question/polish-formula-batch',
    method: 'post',
    data: data,
    timeout: 180000
  })
}

/** Batch insert after review */
export function batchAddQbQuestion(data) {
  return request({ url: '/spas/qb/question/batch', method: 'post', data })
}

/** Rule-based smart pick / blueprint */
export function smartPickQbQuestion(data) {
  return request({ url: '/spas/qb/question/smart-pick', method: 'post', data })
}

/** Visual annotate: upload PDF/image and render page images */
export function uploadAnnotatePaper(data) {
  return request({
    url: '/spas/qb/annotate/upload',
    method: 'post',
    data: data,
    headers: { 'Content-Type': 'multipart/form-data' },
    timeout: 120000
  })
}

/** Visual annotate: commit boxed questions */
export function commitAnnotatePaper(data) {
  return request({ url: '/spas/qb/annotate/commit', method: 'post', data })
}

/** Crop + classify region (diagram/formula/text); returns imageUrl */
export function recognizeAnnotateRegion(data) {
  return request({ url: '/spas/qb/annotate/recognize', method: 'post', data })
}

/** Best-effort delete OCR page images for a parse session */
export function cleanupQbOcrSession(sessionId) {
  return request({ url: '/spas/qb/question/ocr-session/' + sessionId, method: 'delete' })
}
