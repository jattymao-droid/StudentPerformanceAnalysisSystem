import request from '@/utils/request'

/** 知识依赖边列表（subjectId | toKnowledgeId | fromKnowledgeId） */
export function listKnowledgeEdge(query) {
  return request({
    url: '/spas/knowledgeEdge/list',
    method: 'get',
    params: query
  })
}

/** 新增前置依赖边 */
export function addKnowledgeEdge(data) {
  return request({
    url: '/spas/knowledgeEdge',
    method: 'post',
    data: data
  })
}

/** 删除依赖边 */
export function delKnowledgeEdge(edgeId) {
  return request({
    url: '/spas/knowledgeEdge/' + edgeId,
    method: 'delete'
  })
}
