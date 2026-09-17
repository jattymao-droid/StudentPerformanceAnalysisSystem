import request from '@/utils/request'

// ��ѯ֪ʶ���б�
export function listKnowledge(query) {
  return request({
    url: '/spas/knowledge/list',
    method: 'get',
    params: query
  })
}

// ��ѯ֪ʶ����
export function treeKnowledge(subjectId) {
  return request({
    url: '/spas/knowledge/tree/' + subjectId,
    method: 'get'
  })
}

// ��ѯ֪ʶ����ϸ
export function getKnowledge(knowledgeId) {
  return request({
    url: '/spas/knowledge/' + knowledgeId,
    method: 'get'
  })
}

// ����֪ʶ��
export function addKnowledge(data) {
  return request({
    url: '/spas/knowledge',
    method: 'post',
    data: data
  })
}

// �޸�֪ʶ��
export function updateKnowledge(data) {
  return request({
    url: '/spas/knowledge',
    method: 'put',
    data: data
  })
}

// ɾ��֪ʶ��
export function delKnowledge(knowledgeId) {
  return request({
    url: '/spas/knowledge/' + knowledgeId,
    method: 'delete'
  })
}
