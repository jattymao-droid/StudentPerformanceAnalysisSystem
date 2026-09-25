<template>
  <div class="login">
    <div class="login-scene">
      <!-- Left: copy + art sit directly on the blue field (not a second card) -->
      <div class="login-hero">
        <div class="hero-copy">
          <p>学情数据分析</p>
          <p>可视化掌握度洞察</p>
        </div>
        <div class="hero-art" aria-hidden="true">
          <svg class="ring ring-1" viewBox="0 0 420 420">
            <ellipse cx="210" cy="210" rx="175" ry="72" fill="none" stroke="rgba(255,255,255,.42)" stroke-width="1.5" />
            <circle cx="375" cy="185" r="4.5" fill="#fff" />
          </svg>
          <svg class="ring ring-2" viewBox="0 0 420 420">
            <ellipse cx="210" cy="210" rx="145" ry="115" fill="none" stroke="rgba(255,255,255,.3)" stroke-width="1.3" />
            <circle cx="80" cy="155" r="3.8" fill="#fff" />
          </svg>
          <svg class="ring ring-3" viewBox="0 0 420 420">
            <ellipse cx="210" cy="215" rx="95" ry="150" fill="none" stroke="rgba(255,255,255,.22)" stroke-width="1.2" />
            <circle cx="255" cy="75" r="3.2" fill="#fff" />
          </svg>
          <div class="orbit-core" />
        </div>
        <div class="hero-dots" aria-hidden="true">
          <i /><i class="on" /><i />
        </div>
      </div>

      <!-- Right: one white form card -->
      <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-card" @submit.native.prevent>
        <div class="card-brand">知脉</div>
        <h1 class="card-title">学生学情分析系统</h1>
        <p class="card-desc">成绩采集 · 知识点分析 · 预警与一生一册</p>

        <el-form-item prop="username">
          <el-input v-model="loginForm.username" type="text" auto-complete="off" placeholder="请输入账号">
            <svg-icon slot="prefix" icon-class="user" class="el-input__icon field-icon" />
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            auto-complete="off"
            placeholder="请输入密码"
            @keyup.enter.native="handleLogin"
          >
            <svg-icon slot="prefix" icon-class="password" class="el-input__icon field-icon" />
          </el-input>
        </el-form-item>
        <el-form-item v-if="captchaEnabled" prop="code" class="code-item">
          <el-input
            v-model="loginForm.code"
            auto-complete="off"
            placeholder="验证码"
            @keyup.enter.native="handleLogin"
          >
            <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon field-icon" />
          </el-input>
          <button
            type="button"
            class="code-btn"
            :class="{ 'is-loading': codeLoading }"
            title="点击刷新验证码"
            aria-label="点击刷新验证码"
            :disabled="codeLoading"
            @click="getCode"
          >
            <img v-show="codeUrl && !codeLoading" :src="codeUrl" alt="验证码" draggable="false" />
            <span v-if="codeLoading" class="code-spinner" aria-hidden="true" />
          </button>
        </el-form-item>

        <div class="card-row">
          <el-checkbox v-model="loginForm.rememberMe">记住密码</el-checkbox>
        </div>

        <el-button
          :loading="loading"
          type="primary"
          class="submit-btn"
          native-type="button"
          @click.native.prevent="handleLogin"
        >
          <span v-if="!loading">登 录</span>
          <span v-else>登 录 中...</span>
        </el-button>
      </el-form>
    </div>

    <footer class="login-foot">{{ footerContent }}</footer>
  </div>
</template>

<script>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'
import defaultSettings from '@/settings'

export default {
  name: "Login",
  data() {
    return {
      footerContent: defaultSettings.footerContent,
      codeUrl: "",
      codeLoading: false,
      loginForm: {
        username: "",
        password: "",
        rememberMe: false,
        code: "",
        uuid: ""
      },
      loginRules: {
        username: [{ required: true, trigger: "blur", message: "请输入您的账号" }],
        password: [{ required: true, trigger: "blur", message: "请输入您的密码" }],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      captchaEnabled: true,
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  created() {
    this.getCode()
    this.getCookie()
  },
  methods: {
    getCode() {
      if (this.codeLoading) return
      this.codeLoading = true
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.loginForm.uuid = res.uuid
        }
      }).finally(() => {
        this.codeLoading = false
      })
    },
    getCookie() {
      const username = Cookies.get("username")
      const password = Cookies.get("password")
      const rememberMe = Cookies.get('rememberMe')
      this.loginForm = {
        username: username === undefined ? "" : username,
        password: password === undefined ? "" : decrypt(password),
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe),
        code: this.loginForm.code,
        uuid: this.loginForm.uuid
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (!valid) return
        this.loading = true
        if (this.loginForm.rememberMe) {
          Cookies.set("username", this.loginForm.username, { expires: 30 })
          Cookies.set("password", encrypt(this.loginForm.password), { expires: 30 })
          Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 })
        } else {
          Cookies.remove("username")
          Cookies.remove("password")
          Cookies.remove('rememberMe')
        }
        this.$store.dispatch("Login", this.loginForm).then(() => {
          this.$router.push({ path: this.redirect || "/" }).catch(() => {})
        }).catch(() => {
          this.loading = false
          if (this.captchaEnabled) this.getCode()
        })
      })
    }
  }
}
</script>

<style lang="scss" scoped>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@700&family=Noto+Sans+SC:wght@400;500;700&display=swap');

.login {
  --blue: #4F6BFF;
  --blue-d: #2442ED;
  --blue-deep: #1A33C7;
  --ink: #1E293B;
  --mute: #94A3B8;
  --field: #F0F3FF;
  min-height: 100%;
  position: relative;
  overflow: hidden;
  font-family: "Noto Sans SC", "PingFang SC", "Microsoft YaHei", sans-serif;
  /* Align with sidebar: #2442ED / #1A33C7 / #1C36D4 */
  background:
    radial-gradient(900px 480px at 12% 0%, rgba(255, 255, 255, 0.28), transparent 55%),
    radial-gradient(700px 420px at 85% 100%, rgba(26, 51, 199, 0.4), transparent 55%),
    linear-gradient(180deg, #4F6BFF 0%, #2442ED 55%, #1A33C7 100%);
}

.login::after {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 26%;
  background:
    radial-gradient(ellipse 55% 80% at 20% 120%, rgba(28, 54, 212, 0.45), transparent 70%),
    radial-gradient(ellipse 50% 70% at 75% 130%, rgba(15, 35, 120, 0.35), transparent 68%);
  pointer-events: none;
  z-index: 0;
}

.login-scene {
  position: relative;
  z-index: 1;
  min-height: 100vh;
  width: min(1180px, 100%);
  margin: 0 auto;
  padding: 48px 40px 64px;
  display: grid;
  grid-template-columns: 1.25fr 400px;
  align-items: center;
  gap: 48px;
  box-sizing: border-box;
}

/* —— Hero (open on blue, never a white card) —— */
.login-hero {
  position: relative;
  min-height: 520px;
  color: #fff;
  display: flex;
  flex-direction: column;
}

.hero-copy {
  position: relative;
  z-index: 2;
  padding-top: 24px;
  p {
    margin: 0;
    font-size: clamp(32px, 3.6vw, 44px);
    font-weight: 700;
    line-height: 1.4;
    letter-spacing: 0.08em;
    text-shadow: 0 6px 20px rgba(26, 51, 199, 0.28);
  }
  p + p {
    margin-top: 4px;
    padding-left: 0.4em;
  }
}

.hero-art {
  position: absolute;
  left: 50%;
  top: 52%;
  width: min(480px, 95%);
  aspect-ratio: 1;
  transform: translate(-50%, -42%);
  pointer-events: none;
}

.ring {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  animation: spin 36s linear infinite;
}
.ring-2 {
  inset: 8%;
  width: 84%;
  height: 84%;
  animation-duration: 44s;
  animation-direction: reverse;
}
.ring-3 {
  inset: 16%;
  width: 68%;
  height: 68%;
  animation-duration: 52s;
}

.orbit-core {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 28%;
  height: 28%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.55) 0%, rgba(255, 255, 255, 0.12) 45%, transparent 72%);
  filter: blur(8px);
}

.hero-dots {
  margin-top: auto;
  align-self: center;
  display: flex;
  gap: 10px;
  padding-bottom: 8px;
  z-index: 2;
  i {
    display: block;
    width: 24px;
    height: 3px;
    border-radius: 99px;
    background: rgba(255, 255, 255, 0.35);
  }
  .on {
    width: 40px;
    background: #fff;
  }
}

/* —— Form card —— */
.login-card {
  width: 100%;
  max-width: 400px;
  justify-self: end;
  margin: 0;
  padding: 48px 40px 40px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 18px 48px rgba(36, 66, 237, 0.28);
}

.card-brand {
  text-align: center;
  font-family: "Outfit", "Noto Sans SC", sans-serif;
  font-size: 38px;
  font-weight: 700;
  letter-spacing: 0.22em;
  color: var(--blue-d);
  line-height: 1;
  margin-bottom: 12px;
}

.card-title {
  margin: 0;
  text-align: center;
  font-size: 18px;
  font-weight: 700;
  color: var(--ink);
  letter-spacing: 0.04em;
}

.card-desc {
  margin: 10px 0 32px;
  text-align: center;
  font-size: 12px;
  color: var(--mute);
  letter-spacing: 0.02em;
  line-height: 1.6;
}

.login-card ::v-deep .el-form-item {
  margin-bottom: 20px;
}

.login-card ::v-deep .el-form-item__error {
  padding-left: 14px;
}

.login-card ::v-deep .el-input__inner {
  height: 48px;
  line-height: 48px;
  border: 0;
  border-radius: 999px;
  background: var(--field);
  padding-left: 46px;
  font-size: 14px;
  color: var(--ink);
  transition: box-shadow 0.2s, background 0.2s;
}

.login-card ::v-deep .el-input__inner::placeholder {
  color: #b8c0cc;
}

.login-card ::v-deep .el-input__inner:focus {
  background: #E0E7FF;
  box-shadow: 0 0 0 1.5px rgba(36, 66, 237, 0.45);
}

.login-card ::v-deep .el-input__prefix {
  left: 16px;
}

.field-icon {
  height: 48px !important;
  width: 16px;
  color: var(--blue) !important;
  fill: currentColor;
}

.code-item ::v-deep .el-form-item__content {
  display: flex;
  gap: 12px;
  align-items: center;
}
.code-item .el-input {
  flex: 1;
  min-width: 0;
}

.code-btn {
  position: relative;
  flex: 0 0 140px;
  height: 48px;
  padding: 5px 8px;
  border: 0;
  border-radius: 14px;
  overflow: hidden;
  background: #E0E7FF;
  box-shadow: inset 0 0 0 1px rgba(36, 66, 237, 0.14);
  cursor: pointer;
  transition: box-shadow 0.2s, background 0.2s, transform 0.15s;
  img {
    width: 100%;
    height: 100%;
    object-fit: contain;
    object-position: center;
    display: block;
    border-radius: 8px;
    background: #fff;
    user-select: none;
    pointer-events: none;
  }
  &:hover:not(:disabled) {
    background: #D6E0FF;
    box-shadow: 0 0 0 1.5px rgba(36, 66, 237, 0.4);
  }
  &:active:not(:disabled) {
    transform: scale(0.98);
  }
  &:disabled {
    cursor: wait;
  }
  &.is-loading img {
    opacity: 0;
  }
}

.code-spinner {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 18px;
  height: 18px;
  margin: -9px 0 0 -9px;
  border: 2px solid rgba(36, 66, 237, 0.25);
  border-top-color: var(--blue-d);
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}

.card-row {
  margin: 4px 4px 22px;
  ::v-deep .el-checkbox__inner {
    width: 16px;
    height: 16px;
    border: 1.5px solid #c5ccd6;
    border-radius: 3px;
    background: #fff;
  }
  ::v-deep .el-checkbox__input.is-checked .el-checkbox__inner {
    background: var(--blue-d);
    border-color: var(--blue-d);
  }
  ::v-deep .el-checkbox__label {
    color: #6b7280;
    font-size: 13px;
    padding-left: 8px;
  }
}

.submit-btn {
  width: 100%;
  height: 48px;
  border: 0;
  border-radius: 999px;
  font-size: 15px;
  font-weight: 700;
  letter-spacing: 0.36em;
  text-indent: 0.36em;
  background: var(--blue-d) !important;
  box-shadow: 0 10px 24px rgba(36, 66, 237, 0.4);
}
.submit-btn:hover,
.submit-btn:focus {
  background: var(--blue-deep) !important;
}

.login-foot {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 14px;
  z-index: 2;
  text-align: center;
  color: rgba(255, 255, 255, 0.9);
  font-size: 12px;
  letter-spacing: 0.08em;
  text-shadow: 0 1px 4px rgba(26, 51, 199, 0.35);
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@media (prefers-reduced-motion: reduce) {
  .ring {
    animation: none !important;
  }
  .code-spinner {
    animation: none !important;
    border-top-color: transparent;
  }
}

@media (max-width: 960px) {
  .login-scene {
    grid-template-columns: 1fr;
    padding: 28px 16px 72px;
    gap: 20px;
    min-height: auto;
  }
  .login-hero {
    min-height: 160px;
  }
  .hero-copy p {
    font-size: 26px;
  }
  .hero-art,
  .hero-dots {
    display: none;
  }
  .login-card {
    justify-self: center;
    max-width: 400px;
    padding: 36px 24px 28px;
  }
}
</style>
