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
