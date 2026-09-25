/**
 * Shared QB / analysis question-type display labels.
 * Catalog codes: single/multi/judge/fill/short/calc; legacy: choice/blank.
 */
const TYPE_LABELS = {
  choice: '选择',
  single: '单选',
  multi: '多选',
  judge: '判断',
  blank: '填空',
  fill: '填空',
  short: '简答',
  calc: '计算',
  experiment: '实验',
  other: '其他'
}

export function qbTypeLabel(code) {
  if (code == null || code === '') return '-'
  const key = String(code)
  return TYPE_LABELS[key] || TYPE_LABELS[key.toLowerCase()] || key
}

export function qbTypeOptions() {
  return [
    { value: 'choice', label: '选择(含单选/多选)' },
    { value: 'blank', label: '填空' },
    { value: 'judge', label: '判断' },
    { value: 'short', label: '简答' },
    { value: 'calc', label: '计算' },
    { value: 'experiment', label: '实验' }
  ]
}

export default { qbTypeLabel, qbTypeOptions }
