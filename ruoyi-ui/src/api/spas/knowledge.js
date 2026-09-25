import request from '@/utils/request'

// 查询知识点列表
export function listKnowledge(query) {
  return request({
    url: '/spas/knowledge/list',
    method: 'get',
    params: query
  })
}

// 查询知识点树
export function treeKnowledge(subjectId) {
  return request({
    url: '/spas/knowledge/tree/' + subjectId,
    method: 'get'
  })
}

// 查询知识点详细
export function getKnowledge(knowledgeId) {
  return request({
    url: '/spas/knowledge/' + knowledgeId,
    method: 'get'
  })
}

// 新增知识点
export function addKnowledge(data) {
  return request({
    url: '/spas/knowledge',
    method: 'post',
    data: data
  })
}

// 修改知识点
export function updateKnowledge(data) {
  return request({
    url: '/spas/knowledge',
    method: 'put',
    data: data
  })
}

// 删除知识点
export function delKnowledge(knowledgeId) {
  return request({
    url: '/spas/knowledge/' + knowledgeId,
    method: 'delete'
  })
}
