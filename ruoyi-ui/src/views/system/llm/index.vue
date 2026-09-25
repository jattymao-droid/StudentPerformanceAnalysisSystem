<template>
  <div class="app-container">
    <el-card shadow="never">
      <div slot="header" class="clearfix">
        <span>{{ title }}</span>
      </div>
      <el-alert :title="hint" type="info" :closable="false" show-icon style="margin-bottom:16px" />
      <el-form ref="form" :model="form" :rules="rules" label-width="120px" v-loading="loading" style="max-width:720px">
        <el-form-item :label="labels.enabled" prop="enabled">
          <el-switch v-model="form.enabled" active-text="ON" inactive-text="OFF" />
        </el-form-item>
        <el-form-item :label="labels.endpoint" prop="endpoint">
          <el-input v-model="form.endpoint" placeholder="https://api.deepseek.com/v1/chat/completions" />
        </el-form-item>
        <el-form-item :label="labels.model" prop="model">
          <el-input v-model="form.model" placeholder="deepseek-chat" />
        </el-form-item>
        <el-form-item :label="labels.apiKey" prop="apiKey">
          <el-input v-model="form.apiKey" show-password :placeholder="apiKeyPlaceholder" autocomplete="new-password" />
          <div class="tip">{{ apiKeyTip }}</div>
        </el-form-item>
        <el-form-item :label="labels.timeoutMs" prop="timeoutMs">
          <el-input-number v-model="form.timeoutMs" :min="1000" :max="300000" :step="1000" />
        </el-form-item>
        <el-form-item :label="labels.topK" prop="topK">
          <el-input-number v-model="form.topK" :min="1" :max="20" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="saving" @click="submit" v-hasPermi="['system:llm:edit']">{{ labels.save }}</el-button>
          <el-button type="success" plain :loading="testing" @click="runTest" v-hasPermi="['system:llm:edit']">{{ labels.test }}</el-button>
          <el-button @click="load">{{ labels.reload }}</el-button>
        </el-form-item>
        <el-form-item v-if="testResult">
          <el-alert :title="testResultTitle" :type="testResult.ok ? 'success' : 'error'" :closable="false" show-icon />
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { getLlmConfig, saveLlmConfig, testLlmConfig } from '@/api/system/llm'

export default {
  name: 'SystemLlm',
  data() {
    return {
      loading: false,
      saving: false,
      testing: false,
      apiKeySet: false,
      testResult: null,
      form: {
        enabled: false,
        endpoint: 'https://api.deepseek.com/v1/chat/completions',
        model: 'deepseek-chat',
        apiKey: '',
        apiKeyMasked: '',
        timeoutMs: 30000,
        topK: 5
      },
      title: '\u5927\u6a21\u578b\u914d\u7f6e',
      hint: '\u7528\u4e8e\u9898\u5e93\u77e5\u8bc6\u70b9 AI \u5efa\u8bae\u4e0e\u5bfc\u5165\u667a\u80fd\u6807\u6ce8\uff08DeepSeek / OpenAI \u517c\u5bb9\uff09\u3002\u4fdd\u5b58\u540e\u7acb\u5373\u751f\u6548\uff1b\u542f\u7528\u540e\u5bfc\u5165\u667a\u80fd\u6807\u6ce8\u5728\u542f\u53d1\u5f0f\u65e0\u547d\u4e2d\u65f6\u4f1a\u8c03\u7528\u8fdc\u7a0b\uff08\u6bcf\u6279\u6700\u591a 15 \u9898\uff09\u3002',
      labels: {
        enabled: '\u542f\u7528\u8fdc\u7a0b',
        endpoint: '\u63a5\u53e3\u5730\u5740',
        model: '\u6a21\u578b\u540d',
        apiKey: 'API Key',
        timeoutMs: '\u8d85\u65f6(ms)',
        topK: 'Top-K',
        save: '\u4fdd\u5b58',
        test: '\u8fde\u901a\u6d4b\u8bd5',
        reload: '\u91cd\u65b0\u52a0\u8f7d'
      },
      rules: {
        endpoint: [{ required: true, message: '\u8bf7\u8f93\u5165\u63a5\u53e3\u5730\u5740', trigger: 'blur' }],
        model: [{ required: true, message: '\u8bf7\u8f93\u5165\u6a21\u578b\u540d', trigger: 'blur' }]
      }
    }
  },
  computed: {
    apiKeyPlaceholder() {
      return this.apiKeySet
        ? '\u5df2\u914d\u7f6e\uff0c\u7559\u7a7a\u5219\u4e0d\u4fee\u6539\uff1b\u586b\u65b0\u503c\u5219\u66ff\u6362'
        : '\u8bf7\u8f93\u5165 DeepSeek API Key'
    },
    apiKeyTip() {
      return this.apiKeySet
        ? ('\u5f53\u524d\u5df2\u8bbe\u7f6e\uff1a' + (this.form.apiKeyMasked || '********'))
        : '\u5bc6\u94a5\u4ec5\u7ba1\u7406\u5458\u53ef\u89c1\uff0c\u4e0d\u4f1a\u901a\u8fc7\u516c\u5171 configKey \u63a5\u53e3\u66b4\u9732'
    },
    testResultTitle() {
      if (!this.testResult) return ''
      if (this.testResult.ok) {
        return '\u8fde\u901a\u6210\u529f\uff08' + (this.testResult.latencyMs || 0) + ' ms\uff09: ' + (this.testResult.message || 'ok')
      }
      return '\u8fde\u901a\u5931\u8d25: ' + (this.testResult.message || '')
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.loading = true
      this.testResult = null
      getLlmConfig().then(res => {
        const d = res.data || {}
        this.apiKeySet = !!d.apiKeySet
        this.form = {
          enabled: !!d.enabled,
          endpoint: d.endpoint || '',
          model: d.model || '',
          apiKey: '',
          apiKeyMasked: d.apiKeyMasked || '',
          timeoutMs: Number(d.timeoutMs || 30000),
          topK: Number(d.topK || 5)
        }
      }).catch(e => {
        const msg = (e && e.message) || ''
        this.$modal.msgError(msg.indexOf('static resource') >= 0
          ? '后端未加载 /system/llm，请重新编译并启动 ruoyi-admin（并确保已执行 sql/spas_qb_ai_config.sql）'
          : (msg || '加载大模型配置失败'))
      }).finally(() => { this.loading = false })
    },
    buildPayload(includeMask) {
      const payload = {
        enabled: this.form.enabled,
        endpoint: this.form.endpoint,
        model: this.form.model,
        timeoutMs: this.form.timeoutMs,
        topK: this.form.topK
      }
      if (this.form.apiKey) {
        payload.apiKey = this.form.apiKey
      } else if (includeMask) {
        payload.apiKey = '********'
      }
      return payload
    },
    submit() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        this.saving = true
        saveLlmConfig(this.buildPayload(true)).then(() => {
          this.$modal.msgSuccess('\u4fdd\u5b58\u6210\u529f')
          this.load()
        }).finally(() => { this.saving = false })
      })
    },
    runTest() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        this.testing = true
        this.testResult = null
        testLlmConfig(this.buildPayload(true)).then(res => {
          this.testResult = Object.assign({ ok: true }, res.data || {})
          this.$modal.msgSuccess('\u8fde\u901a\u6210\u529f')
        }).catch(err => {
          const data = (err && err.response && err.response.data && err.response.data.data) || (err && err.data) || {}
          const msg = (err && err.response && err.response.data && err.response.data.msg) || (err && err.message) || '\u8fde\u901a\u5931\u8d25'
          this.testResult = Object.assign({ ok: false, message: msg }, data)
        }).finally(() => { this.testing = false })
      })
    }
  }
}
</script>

<style scoped>
.tip { margin-top: 4px; color: #909399; font-size: 12px; line-height: 1.4; }
</style>
