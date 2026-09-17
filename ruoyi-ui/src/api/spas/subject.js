import request from '@/utils/request'

// 查询学科列表
export function listSubject(query) {
  return request({
    url: '/spas/subject/list',
    method: 'get',
    params: query
  })
}

// 查询学科详细
export function getSubject(subjectId) {
  return request({
    url: '/spas/subject/' + subjectId,
    method: 'get'
  })
}

// 新增学科
export function addSubject(data) {
  return request({
    url: '/spas/subject',
    method: 'post',
    data: data
  })
}

// 修改学科
export function updateSubject(data) {
  return request({
    url: '/spas/subject',
    method: 'put',
    data: data
  })
}

// 删除学科
export function delSubject(subjectId) {
  return request({
    url: '/spas/subject/' + subjectId,
    method: 'delete'
  })
}

// 学科下拉选项
export function optionselectSubject() {
  return request({
    url: '/spas/subject/optionselect',
    method: 'get'
  })
}
