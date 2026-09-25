/**
 * Role label for a teaching-class option from /spas/teacher/my-depts.
 * teacherType: 1 subject, 2 homeroom, 12 dual
 */
export function teachingRoleLabel(teacherType) {
  const t = String(teacherType || '')
  if (t === '12') return '班主任·科任'
  if (t === '2') return '班主任'
  if (t === '1') return '科任'
  return '任教班级'
}

export function boundClassRoleFromDepts(myDepts, deptId) {
  const list = myDepts || []
  if (!list.length) return ''
  const mine = list.find(d => String(d.deptId) === String(deptId)) || list[0]
  return teachingRoleLabel(mine && mine.teacherType)
}
