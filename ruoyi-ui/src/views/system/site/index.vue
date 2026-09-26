<template>
  <div class="app-container">
    <el-card shadow="never">
      <div slot="header" class="clearfix">
        <span>站点信息</span>
      </div>
      <el-alert
        title="以下内容展示在登录页底部。版权文案建议包含产品名与年份；ICP 备案号留空则不显示备案行。"
        type="info"
        :closable="false"
        show-icon
        style="margin-bottom:16px"
      />
      <el-form ref="form" :model="form" :rules="rules" label-width="120px" v-loading="loading" style="max-width:720px">
        <el-form-item label="版权文案" prop="copyright">
          <el-input v-model="form.copyright" maxlength="200" show-word-limit placeholder="如：© 2026 知脉 · 学生学情分析系统" />
        </el-form-item>
        <el-form-item label="ICP备案号" prop="icp">
          <el-input v-model="form.icp" maxlength="64" show-word-limit placeholder="如：粤ICP备xxxxxxxx号" />
        </el-form-item>
        <el-form-item label="备案链接" prop="icpUrl">
          <el-input v-model="form.icpUrl" maxlength="256" placeholder="https://beian.miit.gov.cn/" />
          <div class="tip">备案号点击后跳转的地址，默认工信部查询页</div>
        </el-form-item>
        <el-form-item label="预览">
          <div class="site-preview">
            <div v-if="form.copyright" class="preview-copy">{{ form.copyright }}</div>
            <div v-if="form.icp" class="preview-icp">
              <a :href="previewIcpUrl" target="_blank" rel="noopener noreferrer">{{ form.icp }}</a>
            </div>
            <div v-if="!form.copyright && !form.icp" class="preview-empty">（登录页底部将为空）</div>
          </div>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="saving" @click="submit" v-hasPermi="['system:site:edit']">保 存</el-button>
          <el-button @click="load">重 置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { getSiteInfo, updateSiteInfo } from '@/api/system/config'

export default {
  name: 'SysSite',
  data() {
    return {
      loading: false,
      saving: false,
      form: {
        copyright: '',
        icp: '',
        icpUrl: 'https://beian.miit.gov.cn/'
      },
      rules: {
        icpUrl: [
          {
            validator: (rule, value, callback) => {
              if (!value || !String(value).trim()) {
                callback()
                return
              }
              if (!/^https?:\/\//i.test(String(value).trim())) {
                callback(new Error('链接需以 http:// 或 https:// 开头'))
                return
              }
              callback()
            },
            trigger: 'blur'
          }
        ]
      }
    }
  },
  computed: {
    previewIcpUrl() {
      const u = (this.form.icpUrl || '').trim()
      return u || 'https://beian.miit.gov.cn/'
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.loading = true
      getSiteInfo().then(res => {
        const d = (res && res.data) || {}
        this.form = {
          copyright: d.copyright || '',
          icp: d.icp || '',
          icpUrl: d.icpUrl || 'https://beian.miit.gov.cn/'
        }
      }).finally(() => {
        this.loading = false
      })
    },
    submit() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        this.saving = true
        updateSiteInfo({
          copyright: (this.form.copyright || '').trim(),
          icp: (this.form.icp || '').trim(),
          icpUrl: (this.form.icpUrl || '').trim() || 'https://beian.miit.gov.cn/'
        }).then(() => {
          this.$modal.msgSuccess('保存成功，登录页将使用最新文案')
          this.load()
        }).finally(() => {
          this.saving = false
        })
      })
    }
  }
}
</script>

<style scoped>
.tip {
  margin-top: 4px;
  color: #909399;
  font-size: 12px;
  line-height: 1.4;
}
.site-preview {
  padding: 12px 16px;
  background: #1a33c7;
  border-radius: 6px;
  color: rgba(255, 255, 255, 0.88);
  font-size: 12px;
  text-align: center;
  letter-spacing: 0.06em;
  min-height: 48px;
}
.preview-copy + .preview-icp {
  margin-top: 6px;
}
.preview-icp a {
  color: rgba(255, 255, 255, 0.92);
  text-decoration: underline;
  text-underline-offset: 2px;
}
.preview-empty {
  opacity: 0.65;
}
</style>
