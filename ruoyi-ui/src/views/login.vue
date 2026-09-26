<template>
  <div class="login" @pointermove="onAgPointer" @pointerleave="onAgPointerLeave">
    <canvas ref="agCanvas" class="ag-field" aria-hidden="true" />
    <div class="login-scene">
      <!-- Left: copy + art sit directly on the blue field (not a second card) -->
      <div class="login-hero">
        <div class="hero-copy">
          <p class="hero-brand">知脉</p>
          <p>学情数据分析</p>
          <p>可视化掌握度洞察</p>
        </div>
        <div class="hero-art" aria-hidden="true">
          <svg class="orbit-svg" viewBox="0 0 420 420">
            <defs>
              <radialGradient id="orbitCoreGrad" cx="50%" cy="50%" r="50%">
                <stop offset="0%" stop-color="#fff" stop-opacity="0.95" />
                <stop offset="42%" stop-color="#c9d4ff" stop-opacity="0.45" />
                <stop offset="100%" stop-color="#fff" stop-opacity="0" />
              </radialGradient>
              <linearGradient id="flowFade" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%" stop-color="#fff" stop-opacity="0" />
                <stop offset="35%" stop-color="#fff" stop-opacity="0.55" />
                <stop offset="100%" stop-color="#fff" stop-opacity="0.15" />
              </linearGradient>
              <filter id="ballGlow" x="-120%" y="-120%" width="340%" height="340%">
                <feGaussianBlur stdDeviation="2.2" result="blur" />
                <feMerge>
                  <feMergeNode in="blur" />
                  <feMergeNode in="SourceGraphic" />
                </feMerge>
              </filter>
              <filter id="packetGlow" x="-150%" y="-150%" width="400%" height="400%">
                <feGaussianBlur stdDeviation="1.6" result="blur" />
                <feMerge>
                  <feMergeNode in="blur" />
                  <feMergeNode in="SourceGraphic" />
                </feMerge>
              </filter>
            </defs>
            <g transform="translate(210 210)">
              <!-- Data streams feeding into the nucleus -->
              <g class="data-flow">
                <path class="flow-track" d="M -210,-52 C -130,-78 -55,-28 0,0" fill="none" stroke="url(#flowFade)" stroke-width="1.2" />
                <path class="flow-track" d="M -205,68 C -120,90 -48,36 0,0" fill="none" stroke="rgba(255,255,255,.18)" stroke-width="1" />
                <path class="flow-track" d="M 205,-60 C 130,-88 50,-34 0,0" fill="none" stroke="rgba(255,255,255,.16)" stroke-width="1" />
                <path class="flow-track" d="M 200,78 C 118,96 42,40 0,0" fill="none" stroke="rgba(255,255,255,.14)" stroke-width="1" />
                <path class="flow-track" d="M -40,200 C -28,110 -12,48 0,0" fill="none" stroke="rgba(255,255,255,.12)" stroke-width="1" />

                <path class="flow-pulse flow-pulse-a" d="M -210,-52 C -130,-78 -55,-28 0,0" fill="none" stroke="rgba(255,255,255,.9)" stroke-width="2.2" stroke-linecap="round" />
                <path class="flow-pulse flow-pulse-b" d="M -205,68 C -120,90 -48,36 0,0" fill="none" stroke="rgba(200,220,255,.85)" stroke-width="1.8" stroke-linecap="round" />
                <path class="flow-pulse flow-pulse-c" d="M 205,-60 C 130,-88 50,-34 0,0" fill="none" stroke="rgba(255,255,255,.8)" stroke-width="1.8" stroke-linecap="round" />
                <path class="flow-pulse flow-pulse-d" d="M 200,78 C 118,96 42,40 0,0" fill="none" stroke="rgba(200,220,255,.75)" stroke-width="1.6" stroke-linecap="round" />
                <path class="flow-pulse flow-pulse-e" d="M -40,200 C -28,110 -12,48 0,0" fill="none" stroke="rgba(255,255,255,.7)" stroke-width="1.5" stroke-linecap="round" />

                <g class="data-packet" filter="url(#packetGlow)">
                  <animateMotion dur="3.6s" repeatCount="indefinite" path="M -210,-52 C -130,-78 -55,-28 0,0" />
                  <g transform="rotate(45)"><rect x="-2.5" y="-2.5" width="5" height="5" rx="0.8" fill="#fff" /></g>
                </g>
                <g class="data-packet" filter="url(#packetGlow)">
                  <animateMotion dur="4.2s" begin="-1.4s" repeatCount="indefinite" path="M -205,68 C -120,90 -48,36 0,0" />
                  <circle r="2.2" fill="#e8eeff" />
                </g>
                <g class="data-packet" filter="url(#packetGlow)">
                  <animateMotion dur="3.9s" begin="-0.7s" repeatCount="indefinite" path="M 205,-60 C 130,-88 50,-34 0,0" />
                  <g transform="rotate(45)"><rect x="-2" y="-2" width="4" height="4" rx="0.6" fill="#fff" /></g>
                </g>
                <g class="data-packet" filter="url(#packetGlow)">
                  <animateMotion dur="4.6s" begin="-2.1s" repeatCount="indefinite" path="M 200,78 C 118,96 42,40 0,0" />
                  <circle r="1.8" fill="#dbe4ff" />
                </g>
                <g class="data-packet" filter="url(#packetGlow)">
                  <animateMotion dur="3.4s" begin="-1s" repeatCount="indefinite" path="M -40,200 C -28,110 -12,48 0,0" />
                  <g transform="rotate(45)"><rect x="-1.8" y="-1.8" width="3.6" height="3.6" rx="0.5" fill="#fff" /></g>
                </g>
                <!-- secondary burst packets -->
                <g class="data-packet data-packet-soft">
                  <animateMotion dur="5.2s" begin="-2.8s" repeatCount="indefinite" path="M -210,-52 C -130,-78 -55,-28 0,0" />
                  <circle r="1.4" fill="rgba(255,255,255,.55)" />
                </g>
                <g class="data-packet data-packet-soft">
                  <animateMotion dur="5s" begin="-3.5s" repeatCount="indefinite" path="M 205,-60 C 130,-88 50,-34 0,0" />
                  <circle r="1.3" fill="rgba(220,230,255,.5)" />
                </g>
              </g>

              <!-- Soft nucleus -->
              <circle class="orbit-nucleus" r="28" fill="url(#orbitCoreGrad)" />
              <circle class="orbit-nucleus-ring" r="36" fill="none" stroke="rgba(255,255,255,.28)" stroke-width="1" />

              <g class="orbit-ring" transform="rotate(-22)">
                <ellipse class="orbit-path orbit-path-a" cx="0" cy="0" rx="178" ry="62" fill="none" stroke="rgba(255,255,255,.48)" stroke-width="1.5" />
                <g class="orbit-rider">
                  <animateMotion dur="18s" repeatCount="indefinite" path="M 178,0 A 178,62 0 1,1 -178,0 A 178,62 0 1,1 178,0" />
                  <circle r="9" fill="rgba(255,255,255,.22)" />
                  <circle r="4.2" fill="#fff" filter="url(#ballGlow)" />
                </g>
                <g class="orbit-rider orbit-rider-trail">
                  <animateMotion dur="18s" begin="-3s" repeatCount="indefinite" path="M 178,0 A 178,62 0 1,1 -178,0 A 178,62 0 1,1 178,0" />
                  <circle r="2.4" fill="rgba(255,255,255,.35)" />
                </g>
              </g>

              <g class="orbit-ring" transform="rotate(48)">
                <ellipse class="orbit-path orbit-path-b" cx="0" cy="0" rx="158" ry="56" fill="none" stroke="rgba(255,255,255,.34)" stroke-width="1.35" />
                <g class="orbit-rider">
                  <animateMotion dur="24s" repeatCount="indefinite" path="M 158,0 A 158,56 0 1,0 -158,0 A 158,56 0 1,0 158,0" />
                  <circle r="7.5" fill="rgba(255,255,255,.18)" />
                  <circle r="3.5" fill="#fff" filter="url(#ballGlow)" />
                </g>
                <g class="orbit-rider orbit-rider-trail">
                  <animateMotion dur="24s" begin="-4.5s" repeatCount="indefinite" path="M 158,0 A 158,56 0 1,0 -158,0 A 158,56 0 1,0 158,0" />
                  <circle r="2" fill="rgba(255,255,255,.28)" />
                </g>
              </g>

              <g class="orbit-ring" transform="rotate(108)">
                <ellipse class="orbit-path orbit-path-c" cx="0" cy="0" rx="138" ry="50" fill="none" stroke="rgba(255,255,255,.22)" stroke-width="1.2" />
                <g class="orbit-rider">
                  <animateMotion dur="30s" repeatCount="indefinite" path="M 138,0 A 138,50 0 1,1 -138,0 A 138,50 0 1,1 138,0" />
                  <circle r="6.5" fill="rgba(255,255,255,.16)" />
                  <circle r="3" fill="#fff" filter="url(#ballGlow)" />
                </g>
              </g>
            </g>
          </svg>
          <div class="orbit-core" />
          <div class="data-bits">
            <span style="--i:0">01</span>
            <span style="--i:1">10</span>
            <span style="--i:2">11</span>
            <span style="--i:3">00</span>
            <span style="--i:4">01</span>
            <span style="--i:5">10</span>
          </div>
        </div>
        <div class="hero-dots" aria-hidden="true">
          <i /><i class="on" /><i />
        </div>
      </div>

      <!-- Right: one white form card -->
      <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-card" @submit.native.prevent>
        <div class="card-head">
          <div class="card-mark" aria-hidden="true">
            <span /><span /><span />
          </div>
          <div class="card-brand">知脉</div>
          <h1 class="card-title">学生学情分析系统</h1>
          <p class="card-desc">成绩采集 · 知识点分析 · 预警与一生一册</p>
        </div>

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
            show-password
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

    <footer class="login-foot">
      <div v-if="footerContent" class="foot-copy">{{ footerContent }}</div>
      <div v-if="icp" class="foot-icp">
        <a :href="icpUrl" target="_blank" rel="noopener noreferrer">{{ icp }}</a>
      </div>
    </footer>
  </div>
</template>

<script>
import { getCodeImg } from "@/api/login"
import { getSiteInfo } from "@/api/system/config"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'
import defaultSettings from '@/settings'

export default {
  name: "Login",
  data() {
    return {
      footerContent: defaultSettings.footerContent,
      icp: "",
      icpUrl: "https://beian.miit.gov.cn/",
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
    this.loadSiteInfo()
  },
  mounted() {
    this.initAgField()
  },
  beforeDestroy() {
    this.destroyAgField()
  },
  methods: {
    loadSiteInfo() {
      getSiteInfo().then(res => {
        const d = (res && res.data) || {}
        if (d.copyright != null && String(d.copyright).trim() !== '') {
          this.footerContent = String(d.copyright).trim()
        }
        this.icp = (d.icp && String(d.icp).trim()) || ''
        const url = (d.icpUrl && String(d.icpUrl).trim()) || ''
        this.icpUrl = url || 'https://beian.miit.gov.cn/'
      }).catch(() => { /* 匿名接口失败时保留默认版权 */ })
    },
    /** Soft rising orb field — float up; cursor creates a luminous wake. */
    initAgField() {
      if (typeof window === 'undefined') return
      if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
      const canvas = this.$refs.agCanvas
      if (!canvas) return
      const ctx = canvas.getContext('2d')
      if (!ctx) return

      this._ag = {
        canvas,
        ctx,
        particles: [],
        raf: 0,
        w: 0,
        h: 0,
        dpr: 1,
        pointer: { x: 0, y: 0, active: false },
        smooth: { x: 0, y: 0 },
        t: 0,
        lastTs: 0
      }

      this._agOnResize = () => this.resizeAgField()
      this._agTick = (ts) => this.tickAgField(ts)
      window.addEventListener('resize', this._agOnResize, { passive: true })
      this.resizeAgField()
      this._ag.raf = requestAnimationFrame(this._agTick)
    },
    destroyAgField() {
      if (this._agOnResize) {
        window.removeEventListener('resize', this._agOnResize)
        this._agOnResize = null
      }
      if (this._ag && this._ag.raf) {
        cancelAnimationFrame(this._ag.raf)
      }
      this._agTick = null
      this._ag = null
    },
    resizeAgField() {
      const ag = this._ag
      if (!ag || !ag.canvas) return
      const dpr = Math.min(window.devicePixelRatio || 1, 2)
      const w = window.innerWidth
      const h = window.innerHeight
      ag.dpr = dpr
      ag.w = w
      ag.h = h
      ag.canvas.width = Math.floor(w * dpr)
      ag.canvas.height = Math.floor(h * dpr)
      ag.canvas.style.width = w + 'px'
      ag.canvas.style.height = h + 'px'
      ag.ctx.setTransform(dpr, 0, 0, dpr, 0, 0)

      const count = Math.max(55, Math.min(120, Math.round((w * h) / 16000)))
      ag.particles = []
      for (let i = 0; i < count; i++) {
        const depth = 0.25 + Math.random() * 0.75
        ag.particles.push({
          x: Math.random() * w,
          y: Math.random() * h,
          depth,
          r: 1.2 + depth * 3.2 + Math.random() * 1.6,
          speed: 12 + depth * 28 + Math.random() * 10,
          sway: 0.4 + Math.random() * 1.2,
          phase: Math.random() * Math.PI * 2,
          hue: Math.random() < 0.35 ? 0 : 1,
          twinkle: Math.random() * Math.PI * 2
        })
      }
      ag.smooth.x = w * 0.5
      ag.smooth.y = h * 0.5
    },
    onAgPointer(e) {
      const ag = this._ag
      if (!ag || !ag.canvas) return
      const rect = ag.canvas.getBoundingClientRect()
      ag.pointer.x = e.clientX - rect.left
      ag.pointer.y = e.clientY - rect.top
      ag.pointer.active = true
    },
    onAgPointerLeave() {
      if (this._ag) this._ag.pointer.active = false
    },
    tickAgField(ts) {
      const ag = this._ag
      if (!ag) return
      const dt = ag.lastTs ? Math.min(0.05, (ts - ag.lastTs) / 1000) : 0.016
      ag.lastTs = ts
      ag.t += dt

      const { ctx, particles, w, h } = ag
      const targetX = ag.pointer.active ? ag.pointer.x : (w * 0.42 + Math.sin(ag.t * 0.25) * w * 0.12)
      const targetY = ag.pointer.active ? ag.pointer.y : (h * 0.55 + Math.cos(ag.t * 0.2) * h * 0.08)
      ag.smooth.x += (targetX - ag.smooth.x) * (ag.pointer.active ? 0.2 : 0.04)
      ag.smooth.y += (targetY - ag.smooth.y) * (ag.pointer.active ? 0.2 : 0.04)
      const mx = ag.smooth.x
      const my = ag.smooth.y
      const wakeR = Math.min(200, Math.max(130, w * 0.14))

      ctx.clearRect(0, 0, w, h)

      // Cursor wake glow
      if (ag.pointer.active) {
        const wake = ctx.createRadialGradient(mx, my, 0, mx, my, wakeR)
        wake.addColorStop(0, 'rgba(255,255,255,0.14)')
        wake.addColorStop(0.4, 'rgba(180,205,255,0.06)')
        wake.addColorStop(1, 'rgba(255,255,255,0)')
        ctx.fillStyle = wake
        ctx.beginPath()
        ctx.arc(mx, my, wakeR, 0, Math.PI * 2)
        ctx.fill()
      }

      for (let i = 0; i < particles.length; i++) {
        const p = particles[i]
        // Anti-gravity rise
        p.y -= p.speed * dt
        p.x += Math.sin(ag.t * p.sway + p.phase) * (10 + p.depth * 14) * dt
        p.twinkle += dt * (1.2 + p.depth)

        // Cursor wake: push aside + accelerate upward
        const dx = p.x - mx
        const dy = p.y - my
        const dist = Math.sqrt(dx * dx + dy * dy) || 0.001
        if (dist < wakeR) {
          const force = (1 - dist / wakeR)
          const nx = dx / dist
          const ny = dy / dist
          p.x += nx * force * force * 90 * dt
          p.y += (ny * 0.35 - 1.2) * force * force * 70 * dt
        }

        // Wrap
        if (p.y < -20) {
          p.y = h + 20 + Math.random() * 40
          p.x = Math.random() * w
        }
        if (p.x < -30) p.x = w + 30
        if (p.x > w + 30) p.x = -30

        const near = Math.max(0, 1 - dist / wakeR)
        const pulse = 0.55 + 0.45 * Math.sin(p.twinkle)
        const alpha = (0.2 + p.depth * 0.45) * pulse + near * 0.4
        const radius = p.r * (1 + near * 0.55)

        // Soft bloom
        const g = ctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, radius * 3.2)
        if (p.hue === 1) {
          g.addColorStop(0, 'rgba(255,255,255,' + Math.min(0.95, alpha) + ')')
          g.addColorStop(0.35, 'rgba(200,220,255,' + (alpha * 0.35) + ')')
          g.addColorStop(1, 'rgba(200,220,255,0)')
        } else {
          g.addColorStop(0, 'rgba(255,255,255,' + Math.min(0.9, alpha) + ')')
          g.addColorStop(0.4, 'rgba(255,255,255,' + (alpha * 0.28) + ')')
          g.addColorStop(1, 'rgba(255,255,255,0)')
        }
        ctx.fillStyle = g
        ctx.beginPath()
        ctx.arc(p.x, p.y, radius * 3.2, 0, Math.PI * 2)
        ctx.fill()

        // Core
        ctx.beginPath()
        ctx.fillStyle = 'rgba(255,255,255,' + Math.min(0.98, alpha + 0.15) + ')'
        ctx.arc(p.x, p.y, radius * 0.45, 0, Math.PI * 2)
        ctx.fill()
      }

      ag.raf = requestAnimationFrame(this._agTick)
    },
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
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  font-family: "Noto Sans SC", "PingFang SC", "Microsoft YaHei", sans-serif;
  /* Align with sidebar: #2442ED / #1A33C7 / #1C36D4 */
  background:
    radial-gradient(900px 480px at 12% 0%, rgba(255, 255, 255, 0.28), transparent 55%),
    radial-gradient(700px 420px at 85% 100%, rgba(26, 51, 199, 0.4), transparent 55%),
    linear-gradient(180deg, #4F6BFF 0%, #2442ED 55%, #1A33C7 100%);
}

.ag-field {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  pointer-events: none;
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
  animation: hero-copy-in 0.9s ease-out both;
  p {
    margin: 0;
    font-size: clamp(32px, 3.6vw, 44px);
    font-weight: 700;
    line-height: 1.4;
    letter-spacing: 0.08em;
    text-shadow: 0 6px 20px rgba(26, 51, 199, 0.28);
  }
  p.hero-brand {
    font-size: clamp(40px, 4.6vw, 56px);
    letter-spacing: 0.18em;
    margin-bottom: 10px;
  }
  p + p {
    margin-top: 4px;
    padding-left: 0.4em;
    animation: hero-copy-in 0.9s ease-out 0.12s both;
  }
  p.hero-brand + p {
    padding-left: 0;
    font-size: clamp(22px, 2.4vw, 28px);
    font-weight: 600;
    letter-spacing: 0.12em;
    opacity: 0.92;
  }
}

.hero-art {
  position: absolute;
  left: 46%;
  top: 62%;
  width: min(400px, 86%);
  aspect-ratio: 1;
  transform: translate(-50%, -50%);
  pointer-events: none;
  z-index: 1;
  animation: hero-art-in 1.15s cubic-bezier(0.22, 1, 0.36, 1) 0.15s both;
}

.orbit-svg {
  display: block;
  width: 100%;
  height: 100%;
  overflow: visible;
}

.orbit-path {
  stroke-linecap: round;
  stroke-dasharray: 6 10;
  animation: orbit-dash 14s linear infinite;
}
.orbit-path-b {
  animation-duration: 18s;
  animation-direction: reverse;
}
.orbit-path-c {
  animation-duration: 22s;
  stroke-dasharray: 4 12;
}

.orbit-nucleus {
  opacity: 0.85;
  animation: nucleus-pulse 4.2s ease-in-out infinite;
  transform-box: fill-box;
  transform-origin: center;
}
.orbit-nucleus-ring {
  animation: nucleus-ring 4.2s ease-in-out infinite;
  transform-box: fill-box;
  transform-origin: center;
}

.orbit-core {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 26%;
  height: 26%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.55) 0%, rgba(201, 212, 255, 0.22) 38%, transparent 72%);
  filter: blur(10px);
  animation: core-breathe 4.2s ease-in-out infinite;
  pointer-events: none;
}

.flow-pulse {
  stroke-dasharray: 14 220;
  animation: flow-pulse-run 3.8s linear infinite;
}
.flow-pulse-b { animation-duration: 4.4s; animation-delay: -1.2s; }
.flow-pulse-c { animation-duration: 4.1s; animation-delay: -0.6s; }
.flow-pulse-d { animation-duration: 4.8s; animation-delay: -2s; }
.flow-pulse-e { animation-duration: 3.5s; animation-delay: -0.9s; }

.data-bits {
  position: absolute;
  inset: 8% 4%;
  pointer-events: none;
  z-index: 0;
  span {
    position: absolute;
    font-family: "Outfit", "SF Mono", Menlo, monospace;
    font-size: 11px;
    letter-spacing: 0.12em;
    color: rgba(255, 255, 255, 0.28);
    animation: data-bit-drift 7.5s ease-in-out infinite;
    animation-delay: calc(var(--i) * -1.1s);
  }
  span:nth-child(1) { left: 6%; top: 18%; }
  span:nth-child(2) { left: 78%; top: 22%; }
  span:nth-child(3) { left: 12%; top: 72%; }
  span:nth-child(4) { left: 82%; top: 68%; }
  span:nth-child(5) { left: 48%; top: 8%; }
  span:nth-child(6) { left: 56%; top: 86%; }
}

.hero-dots {
  margin-top: auto;
  align-self: center;
  display: flex;
  gap: 10px;
  padding-bottom: 8px;
  z-index: 2;
  animation: hero-copy-in 0.8s ease-out 0.35s both;
  i {
    display: block;
    width: 24px;
    height: 3px;
    border-radius: 99px;
    background: rgba(255, 255, 255, 0.35);
    transition: width 0.3s ease, background 0.3s ease;
  }
  .on {
    width: 40px;
    background: #fff;
  }
}

/* —— Form card —— */
.login-card {
  position: relative;
  width: 100%;
  max-width: 400px;
  justify-self: end;
  margin: 0;
  padding: 40px 36px 36px;
  background: rgba(255, 255, 255, 0.96);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.75);
  box-shadow:
    0 1px 0 rgba(255, 255, 255, 0.9) inset,
    0 8px 28px rgba(26, 51, 199, 0.14),
    0 28px 64px rgba(36, 66, 237, 0.22);
  animation: card-in 0.9s cubic-bezier(0.22, 1, 0.36, 1) 0.18s both;
  overflow: hidden;

  &::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: linear-gradient(90deg, #6B84FF 0%, var(--blue-d) 48%, var(--blue-deep) 100%);
  }
}

.card-head {
  text-align: center;
  margin-bottom: 28px;
}

.card-mark {
  display: flex;
  justify-content: center;
  gap: 6px;
  margin-bottom: 16px;
  span {
    display: block;
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: var(--blue);
    opacity: 0.35;
    &:nth-child(2) {
      opacity: 1;
      background: var(--blue-d);
      box-shadow: 0 0 0 3px rgba(36, 66, 237, 0.14);
    }
  }
}

.card-brand {
  font-family: "Outfit", "Noto Sans SC", sans-serif;
  font-size: 40px;
  font-weight: 700;
  letter-spacing: 0.28em;
  text-indent: 0.28em;
  color: var(--blue-d);
  line-height: 1;
  margin-bottom: 14px;
  background: linear-gradient(135deg, #3B5BFF 0%, var(--blue-d) 55%, var(--blue-deep) 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

.card-title {
  margin: 0;
  font-size: 17px;
  font-weight: 700;
  color: var(--ink);
  letter-spacing: 0.06em;
}

.card-desc {
  margin: 8px 0 0;
  font-size: 12px;
  color: var(--mute);
  letter-spacing: 0.04em;
  line-height: 1.65;
}

.login-card ::v-deep .el-form-item {
  margin-bottom: 18px;
}

.login-card ::v-deep .el-form-item__error {
  padding-left: 16px;
  font-size: 12px;
}

.login-card ::v-deep .el-input__inner {
  height: 50px;
  line-height: 50px;
  border: 1px solid transparent;
  border-radius: 14px;
  background: var(--field);
  padding-left: 46px;
  font-size: 14px;
  color: var(--ink);
  transition: box-shadow 0.2s ease, background 0.2s ease, border-color 0.2s ease;
}

.login-card ::v-deep .el-input__inner::placeholder {
  color: #a8b2c2;
}

.login-card ::v-deep .el-input__inner:hover {
  background: #e8edff;
}

.login-card ::v-deep .el-input__inner:focus {
  background: #fff;
  border-color: rgba(36, 66, 237, 0.35);
  box-shadow: 0 0 0 3px rgba(36, 66, 237, 0.12);
}

.login-card ::v-deep .el-input__prefix {
  left: 16px;
}

.login-card ::v-deep .el-input__suffix {
  right: 12px;
}

.login-card ::v-deep .el-input__clear,
.login-card ::v-deep .el-input__suffix .el-icon-view,
.login-card ::v-deep .el-input__suffix .el-icon-hide {
  color: #94a3b8;
}

.field-icon {
  height: 50px !important;
  width: 16px;
  color: var(--blue-d) !important;
  fill: currentColor;
  opacity: 0.85;
}

.code-item ::v-deep .el-form-item__content {
  display: flex;
  gap: 10px;
  align-items: center;
}
.code-item .el-input {
  flex: 1;
  min-width: 0;
}

.code-btn {
  position: relative;
  flex: 0 0 128px;
  height: 50px;
  padding: 4px 6px;
  border: 1px solid rgba(36, 66, 237, 0.12);
  border-radius: 14px;
  overflow: hidden;
  background: linear-gradient(180deg, #eef2ff 0%, #e0e7ff 100%);
  cursor: pointer;
  transition: box-shadow 0.2s, background 0.2s, transform 0.15s, border-color 0.2s;
  img {
    width: 100%;
    height: 100%;
    object-fit: contain;
    object-position: center;
    display: block;
    border-radius: 10px;
    background: #fff;
    user-select: none;
    pointer-events: none;
  }
  &:hover:not(:disabled) {
    border-color: rgba(36, 66, 237, 0.35);
    box-shadow: 0 0 0 3px rgba(36, 66, 237, 0.1);
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
  display: flex;
  align-items: center;
  margin: 2px 2px 20px;
  ::v-deep .el-checkbox__inner {
    width: 16px;
    height: 16px;
    border: 1.5px solid #c5ccd6;
    border-radius: 4px;
    background: #fff;
    transition: background 0.15s, border-color 0.15s;
  }
  ::v-deep .el-checkbox__input.is-checked .el-checkbox__inner,
  ::v-deep .el-checkbox__input.is-focus .el-checkbox__inner {
    background: var(--blue-d);
    border-color: var(--blue-d);
  }
  ::v-deep .el-checkbox__label {
    color: #64748b;
    font-size: 13px;
    padding-left: 8px;
    font-weight: 500;
  }
}

.submit-btn {
  width: 100%;
  height: 50px;
  border: 0 !important;
  border-radius: 14px;
  font-size: 15px;
  font-weight: 700;
  letter-spacing: 0.32em;
  text-indent: 0.32em;
  color: #fff !important;
  background: linear-gradient(135deg, #4F6BFF 0%, var(--blue-d) 48%, var(--blue-deep) 100%) !important;
  box-shadow: 0 10px 28px rgba(36, 66, 237, 0.38);
  transition: transform 0.18s ease, box-shadow 0.18s ease, filter 0.18s ease;
}
.submit-btn:hover,
.submit-btn:focus {
  filter: brightness(1.04);
  box-shadow: 0 14px 32px rgba(36, 66, 237, 0.48);
  transform: translateY(-1px);
}
.submit-btn:active {
  transform: translateY(0);
  box-shadow: 0 8px 20px rgba(36, 66, 237, 0.32);
}

.login-foot {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 14px;
  z-index: 2;
  text-align: center;
  color: rgba(255, 255, 255, 0.88);
  font-size: 12px;
  letter-spacing: 0.08em;
  text-shadow: 0 1px 4px rgba(26, 51, 199, 0.35);
  line-height: 1.5;
}
.login-foot .foot-copy + .foot-icp {
  margin-top: 4px;
}
.login-foot .foot-icp a {
  color: rgba(255, 255, 255, 0.88);
  text-decoration: none;
  letter-spacing: 0.04em;
}
.login-foot .foot-icp a:hover {
  text-decoration: underline;
  text-underline-offset: 2px;
}

@keyframes card-in {
  from { opacity: 0; transform: translateY(22px) scale(0.98); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@keyframes hero-copy-in {
  from { opacity: 0; transform: translateY(14px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes hero-art-in {
  from { opacity: 0; transform: translate(-50%, -46%) scale(0.92); }
  to { opacity: 1; transform: translate(-50%, -50%) scale(1); }
}

@keyframes orbit-dash {
  to { stroke-dashoffset: -160; }
}

@keyframes core-breathe {
  0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 0.75; }
  50% { transform: translate(-50%, -50%) scale(1.22); opacity: 1; }
}

@keyframes nucleus-pulse {
  0%, 100% { opacity: 0.72; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.08); }
}

@keyframes nucleus-ring {
  0%, 100% { opacity: 0.35; transform: scale(1); }
  50% { opacity: 0.7; transform: scale(1.12); }
}

@keyframes flow-pulse-run {
  to { stroke-dashoffset: -234; }
}

@keyframes data-bit-drift {
  0%, 100% { opacity: 0.12; transform: translateY(0); }
  40% { opacity: 0.42; transform: translateY(-10px); }
  70% { opacity: 0.22; transform: translateY(-4px); }
}

@media (prefers-reduced-motion: reduce) {
  .hero-copy,
  .hero-copy p + p,
  .hero-art,
  .hero-dots,
  .orbit-path,
  .orbit-core,
  .orbit-nucleus,
  .orbit-nucleus-ring,
  .flow-pulse,
  .data-bits span,
  .login-card {
    animation: none !important;
  }
  .hero-art {
    opacity: 1;
    transform: translate(-50%, -50%);
  }
  .login-card {
    opacity: 1;
    transform: none;
  }
  .orbit-rider,
  .data-packet {
    display: none;
  }
  .orbit-path,
  .flow-pulse {
    stroke-dasharray: none;
  }
  .data-bits span {
    opacity: 0.22;
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
