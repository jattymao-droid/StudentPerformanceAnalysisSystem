<template>
  <footer v-if="visible" class="copyright">
    <span v-if="content">{{ content }}</span>
    <template v-if="icp">
      <span v-if="content" class="sep">|</span>
      <a :href="icpUrl" target="_blank" rel="noopener noreferrer">{{ icp }}</a>
    </template>
  </footer>
</template>

<script>
import { getSiteInfo } from '@/api/system/config'

export default {
  data() {
    return {
      siteCopyright: null,
      icp: '',
      icpUrl: 'https://beian.miit.gov.cn/'
    }
  },
  computed: {
    visible() {
      return this.$store.state.settings.footerVisible
    },
    content() {
      if (this.siteCopyright != null && String(this.siteCopyright).trim() !== '') {
        return String(this.siteCopyright).trim()
      }
      return this.$store.state.settings.footerContent
    }
  },
  created() {
    if (this.visible) {
      this.loadSiteInfo()
    }
  },
  methods: {
    loadSiteInfo() {
      getSiteInfo().then(res => {
        const d = (res && res.data) || {}
        this.siteCopyright = d.copyright
        this.icp = (d.icp && String(d.icp).trim()) || ''
        const url = (d.icpUrl && String(d.icpUrl).trim()) || ''
        this.icpUrl = url || 'https://beian.miit.gov.cn/'
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.copyright {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 36px;
  padding: 10px 20px;
  text-align: right;
  background-color: #f8f8f8;
  color: #666;
  font-size: 14px;
  border-top: 1px solid #e7e7e7;
  z-index: 999;
}
.copyright .sep {
  margin: 0 8px;
  color: #bbb;
}
.copyright a {
  color: #666;
  text-decoration: none;
}
.copyright a:hover {
  color: #409eff;
  text-decoration: underline;
}
</style>
