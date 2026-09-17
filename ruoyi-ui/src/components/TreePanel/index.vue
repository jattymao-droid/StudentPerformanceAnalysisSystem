<template>
  <div class="tree-panel" :style="{ width: width + 'px' }">
    <div class="head-container">
      <el-input
        v-model="filterText"
        :placeholder="searchPlaceholder"
        clearable
        size="small"
        prefix-icon="el-icon-search"
        style="margin-bottom: 8px"
      />
    </div>
    <div class="head-container" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px">
      <span class="tree-panel-title">{{ title }}</span>
      <el-button type="text" icon="el-icon-refresh" @click="$emit('refresh')" />
    </div>
    <el-tree
      ref="tree"
      :data="treeData"
      :props="defaultProps"
      :expand-on-click-node="false"
      :filter-node-method="filterNode"
      :default-expand-all="defaultExpandAll"
      highlight-current
      @node-click="onNodeClick"
    >
      <span class="custom-tree-node" slot-scope="{ node, data }">
        <span class="tree-node-label">{{ node.label }}</span>
        <span v-if="$scopedSlots['node-actions']" class="tree-node-actions" @click.stop>
          <slot name="node-actions" :node="node" :data="data" />
        </span>
      </span>
    </el-tree>
  </div>
</template>

<script>
export default {
  name: 'TreePanel',
  props: {
    title: { type: String, default: '' },
    treeData: { type: Array, default: () => [] },
    searchPlaceholder: { type: String, default: 'Search' },
    storageKey: { type: String, default: 'tree-panel-width' },
    defaultWidth: { type: Number, default: 280 },
    defaultExpandAll: { type: Boolean, default: true },
    defaultProps: {
      type: Object,
      default: () => ({ children: 'children', label: 'label' })
    }
  },
  data() {
    const saved = Number(localStorage.getItem(this.storageKey) || 0)
    return {
      filterText: '',
      width: saved > 160 ? saved : this.defaultWidth
    }
  },
  watch: {
    filterText(val) {
      this.$refs.tree && this.$refs.tree.filter(val)
    }
  },
  methods: {
    filterNode(value, data) {
      if (!value) return true
      return (data.label || '').indexOf(value) !== -1
    },
    onNodeClick(data) {
      this.$emit('node-click', data)
    }
  }
}
</script>

<style scoped>
.tree-panel {
  border-right: none;
  padding-right: 0;
  margin-right: 0;
  min-width: 180px;
  max-height: calc(100vh - 120px);
  overflow: auto;
  flex-shrink: 0;
}
.tree-panel-title {
  font-weight: 600;
  color: #2C2940;
}
.custom-tree-node {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  padding-right: 4px;
  overflow: hidden;
}
.tree-node-label {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  padding-right: 6px;
}
.tree-node-actions {
  flex-shrink: 0;
}
.tree-node-actions >>> .el-button--text {
  padding: 0 2px;
  font-size: 12px;
}
</style>
