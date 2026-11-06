/**
 * Build sidebar/treeselect options for SPAS pages.
 * Prefer teaching classes for bound teachers; admins always use the system dept tree.
 */
import { checkPermi, checkRole } from '@/utils/permission'

/** Super admin / school SPAS admin �� full org visibility */
export function isSpasFullAccess() {
  return checkPermi(['*:*:*']) || checkRole(['admin', 'spas_admin'])
}

export function canLoadSystemDeptTree() {
  return isSpasFullAccess() || checkPermi(['system:user:list'])
}

export function teachingDeptsToTree(myDepts) {
  return (myDepts || []).map(d => ({
    id: Number(d.deptId),
    label: d.deptName || String(d.deptId),
    deptId: Number(d.deptId),
    parentId: 0,
    primary: !!d.primary,
    teacherType: d.teacherType
  }))
}

export function preferredTeachingDeptId(myDepts) {
  if (!myDepts || !myDepts.length) return undefined
  const primary = myDepts.find(d => d.primary)
  return Number((primary || myDepts[0]).deptId)
}

/**
 * Heuristic: leaf org nodes like「技术组/教研组/教务处」are not classroom depts.
 * Prefer names containing「班」, or numeric leaves under a grade parent.
 */
export function isLikelyClassDeptName(name, parentLabel) {
  const n = String(name || '').trim()
  if (!n) return false
  if (/班/.test(n)) return true
  if (/(组|处|室|部|中心|办|科|委员会)$/.test(n)) return false
  if (/(教研|备课|技术|信息|行政|教务|政教|总务|后勤|财务|人事|年级组)/.test(n)) return false
  const parent = String(parentLabel || '')
  if (/(高[一二三]|初[一二三]|[一二三四五六七八九]年级)/.test(parent) && /^\d{1,2}$/.test(n)) {
    return true
  }
  return false
}

/**
 * @param {Function} listMyTeachingDepts
 * @param {Function} deptTreeSelect
 * @param {Function} [mapSystemTree] (nodes) => nodes
 */
export function loadSpasDeptTree(listMyTeachingDepts, deptTreeSelect, mapSystemTree) {
  const mapSys = typeof mapSystemTree === 'function' ? mapSystemTree : (nodes) => nodes || []
  const empty = () => Promise.resolve({ source: 'none', tree: [], myDepts: [] })
  const trySystem = () => {
    if (!canLoadSystemDeptTree() || typeof deptTreeSelect !== 'function') {
      return empty()
    }
    return deptTreeSelect().then(r => ({
      source: 'system',
      tree: mapSys(r.data || []),
      myDepts: []
    })).catch(() => empty())
  }

  // Admins: always full org tree (never bind to teaching classes)
  if (isSpasFullAccess() || canLoadSystemDeptTree()) {
    return trySystem()
  }

  return listMyTeachingDepts().then(res => {
    const mine = res.data || []
    if (mine.length) {
      return { source: 'teaching', tree: teachingDeptsToTree(mine), myDepts: mine }
    }
    return trySystem()
  }).catch(() => trySystem())
}

/**
 * Apply teaching-dept context onto a Vue page that uses myDepts + deptOptions + queryParams.deptId.
 * @returns {Promise<{source, myDepts, tree}>}
 */
export function applyTeachingDeptContext(vm, listMyTeachingDepts, deptTreeSelect, mapSystemTree) {
  return loadSpasDeptTree(listMyTeachingDepts, deptTreeSelect, mapSystemTree).then(result => {
    vm.myDepts = result.myDepts || []
    vm.deptOptions = result.tree || []
    // Only auto-select a class for bound teachers, not for full-access admins
    if (result.source === 'teaching' && !vm.queryParams.deptId) {
      const preferred = preferredTeachingDeptId(result.myDepts)
      if (preferred) {
        vm.queryParams.deptId = preferred
      }
    }
    return result
  })
}
