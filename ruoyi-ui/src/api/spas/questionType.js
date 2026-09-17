import request from '@/utils/request'

export function listQuestionType(query) {
  return request({
    url: '/spas/questionType/list',
    method: 'get',
    params: query
  })
}

export function optionselectQuestionType(subjectId) {
  return request({
    url: '/spas/questionType/optionselect',
    method: 'get',
    params: { subjectId }
  })
}

export function getQuestionType(typeId) {
  return request({
    url: '/spas/questionType/' + typeId,
    method: 'get'
  })
}

export function addQuestionType(data) {
  return request({
    url: '/spas/questionType',
    method: 'post',
    data: data
  })
}

export function updateQuestionType(data) {
  return request({
    url: '/spas/questionType',
    method: 'put',
    data: data
  })
}

export function delQuestionType(typeId) {
  return request({
    url: '/spas/questionType/' + typeId,
    method: 'delete'
  })
}
