(() => {
  const QUEUE_KEY = 'spas_desktop_queue'
  const LAST_USER_KEY = 'spas_desktop_last_user'
  const RECENT_USERS_KEY = 'spas_desktop_recent_users'
  const LAST_TPL_PREFIX = 'spas_desktop_tpl_'
  const API_TIMEOUT_MS = 20000
  const IDLE_WARN_MS = 60 * 1000
  const SUCCESS_EXIT_SEC = 3
  const VIEWS = ['viewSetup', 'viewLogin', 'viewHome', 'viewPractice', 'viewCheckout', 'viewAck', 'viewProxyPick', 'viewHistory', 'viewSuccess']

  const state = {
    config: {
      apiBase: '', deviceCode: '', title: '知脉 · 每日自主练',
      appVersion: '1.5.9', kiosk: false, autoLaunch: false, idleMinutes: 8
    },
    token: '',
    uuid: '',
    profile: null,
    subjects: [],
    weak: [],
    knowledge: [],
    books: [],
    today: null,
    lastTemplate: null,
    recentLogs: [],
    checkout: null,
    checkoutDraft: {},
    ackItem: null,
    points: null,
    boardRange: 'week',
    lastAwardedPoints: 0,
    prevLevelNo: null,
    ledger: [],
    proxyStudentId: null,
    proxyStudentName: '',
    preselectKnowledgeIds: [],
    draftReuse: null,
    dashOpen: false,
    kbTarget: null,
    idleTimer: null,
    idleWarnTimer: null,
    successTimer: null,
    online: navigator.onLine,
    pendingPayload: null,
    setupReturn: 'viewLogin',
    busy: false,
    pinAutoLogin: true
  }

  const $ = (id) => document.getElementById(id)

  function idleMs() {
    const m = Number(state.config.idleMinutes)
    const minutes = (!m || m < 2) ? 8 : Math.min(m, 60)
    return minutes * 60 * 1000
  }

  function show(id) {
    VIEWS.forEach((v) => { if ($(v)) $(v).hidden = v !== id })
    const authLike = id === 'viewLogin' || id === 'viewSetup' || id === 'viewSuccess'
    const loggedIn = !!state.token && !authLike
    document.body.classList.toggle('mode-auth', authLike || !state.token)
    document.body.classList.toggle('mode-app', loggedIn)
    if ($('appRail')) $('appRail').hidden = !loggedIn
    if ($('appAside')) $('appAside').hidden = !loggedIn
    if ($('workspaceHead')) $('workspaceHead').hidden = !loggedIn
    if ($('btnSetupBack')) $('btnSetupBack').hidden = !(id === 'viewSetup' && !!state.token)
    if (id !== 'viewPractice' && id !== 'viewSetup') hideDockKb()
    if (id !== 'viewSuccess') clearSuccessTimer()
    setNavActive(id)
    setPageMeta(id)
    const body = document.querySelector('.workspace-body')
    if (body) body.scrollTop = 0
    touchIdle()
  }

  function openPracticeSmart(proxy) {
    const tpl = state.lastTemplate || loadTemplate()
    openPractice(!!proxy, tpl && !proxy ? { reuse: true } : {})
  }

  function setNavActive(id) {
    const map = {
      viewHome: 'home',
      viewPractice: 'practice',
      viewHistory: 'history',
      viewProxyPick: 'proxy',
      viewSetup: 'settings'
    }
    const key = map[id] || 'home'
    document.querySelectorAll('.rail-btn[data-nav]').forEach((btn) => {
      btn.classList.toggle('active', btn.dataset.nav === key)
    })
  }

  function setPageMeta(id) {
    const title = $('pageTitle')
    const sub = $('pageSub')
    if (!title || !sub) return
    const meta = {
      viewHome: ['每日自主练', '检查在座位上完成，一体机只登记结果'],
      viewPractice: ['加练登记', '加练不计入组达标'],
      viewCheckout: ['登记检查结果', '先在座位翻本抽问，这里只点状态；全员有状态才能提交'],
      viewAck: ['确认检查结果', '确认的是组长在座位上看到的结果，不是网上自填'],
      viewHistory: ['近 7 日记录', '回顾本周自主练痕迹'],
      viewProxyPick: ['帮组员登记', '已停用，请改用检查单'],
      viewSetup: ['一体机设置', '配置 API 与设备编号'],
      viewSuccess: ['提交成功', '即将退出给下一位']
    }[id] || ['每日自主练', '']
    title.textContent = meta[0]
    sub.textContent = meta[1]
  }

  function toast(msg, type) {
    const el = $('toast')
    if (!el) return
    el.textContent = msg || ''
    el.className = 'toast' + (type ? (' ' + type) : '')
    el.hidden = false
    clearTimeout(toast._t)
    toast._t = setTimeout(() => { el.hidden = true }, 2800)
  }

  function setLoading(on, text) {
    state.busy = !!on
    const mask = $('loadingMask')
    if (!mask) return
    mask.hidden = !on
    if (text) $('loadingText').textContent = text
  }

  function logClient(msg) {
    if (window.spasDesktop && window.spasDesktop.writeLog) {
      window.spasDesktop.writeLog(msg).catch(() => {})
    }
  }

  function loadQueue() {
    try { return JSON.parse(localStorage.getItem(QUEUE_KEY) || '[]') } catch (e) { return [] }
  }
  function saveQueue(q) {
    localStorage.setItem(QUEUE_KEY, JSON.stringify(q || []))
    updateQueueBadge()
  }
  function updateQueueBadge() {
    const n = loadQueue().length
    const badge = $('queueBadge')
    const btn = $('btnFlushQueue')
    if (!badge || !btn) return
    badge.hidden = n === 0
    btn.hidden = n === 0 || !state.token
    badge.textContent = '离线待传 ' + n
  }

  async function api(method, path, body, opts = {}) {
    const headers = { 'Content-Type': 'application/json' }
    if (state.token && !opts.noAuth) headers.Authorization = 'Bearer ' + state.token
    const ctrl = new AbortController()
    const timer = setTimeout(() => ctrl.abort(), opts.timeout || API_TIMEOUT_MS)
    try {
      const res = await fetch(joinUrl(state.config.apiBase, path), {
        method,
        headers,
        body: body == null ? undefined : JSON.stringify(body),
        signal: ctrl.signal
      })
      const data = await res.json().catch(() => ({}))
      if (data.code === 401) {
        logout(true)
        throw new Error(data.msg || '登录已失效')
      }
      if (data.code !== 200) throw new Error(data.msg || '请求失败')
      return data
    } catch (e) {
      if (e.name === 'AbortError') throw new Error('请求超时，请检查网络')
      throw e
    } finally {
      clearTimeout(timer)
    }
  }

  function joinUrl(base, path) {
    const b = (base || '').replace(/\/$/, '')
    const p = path.startsWith('/') ? path : '/' + path
    return b + p
  }

  function setOnline(v) {
    state.online = v
    $('netBanner').hidden = v
    const dot = $('onlineDot')
    if (dot) {
      dot.classList.toggle('off', !v)
      dot.title = v ? '在线' : '离线'
    }
    if (v && state.token) {
      toast('网络已恢复，正在同步…', 'ok')
      flushQueue()
    }
  }

  function needsSetup(cfg) {
    return !cfg || !cfg.apiBase || !String(cfg.apiBase).trim() || !cfg.deviceCode || !String(cfg.deviceCode).trim()
  }

  function fillSetupForm() {
    $('cfgApiBase').value = state.config.apiBase || ''
    $('cfgDeviceCode').value = state.config.deviceCode || ''
    $('cfgTitle').value = state.config.title || '知脉 · 每日自主练'
    $('cfgIdleMinutes').value = state.config.idleMinutes || 8
    $('cfgKiosk').checked = !!state.config.kiosk
    $('cfgAutoLaunch').checked = !!state.config.autoLaunch
    $('setupMeta').textContent = state.config.configPath
      ? ('配置文件：' + state.config.configPath)
      : ''
    $('setupErr').textContent = ''
    const logBtn = $('btnOpenLog')
    if (logBtn) logBtn.hidden = !state.config.logDir
  }

  function openSetup(returnView) {
    state.setupReturn = returnView || (state.token ? 'viewHome' : 'viewLogin')
    fillSetupForm()
    show('viewSetup')
  }

  async function saveSetup() {
    $('setupErr').textContent = ''
    const apiBase = $('cfgApiBase').value.trim().replace(/\/$/, '')
    const deviceCode = $('cfgDeviceCode').value.trim()
    const title = $('cfgTitle').value.trim() || '知脉 · 每日自主练'
    const idleMinutes = Math.max(2, Math.min(60, Number($('cfgIdleMinutes').value) || 8))
    const kiosk = $('cfgKiosk').checked
    const autoLaunch = $('cfgAutoLaunch').checked
    if (!apiBase) { $('setupErr').textContent = '请填写 API 地址'; return }
    if (!deviceCode) { $('setupErr').textContent = '请填写设备编号'; return }
    try {
      setLoading(true, '保存中…')
      if (window.spasDesktop && window.spasDesktop.saveConfig) {
        state.config = Object.assign(state.config, await window.spasDesktop.saveConfig({
          apiBase, deviceCode, title, kiosk, autoLaunch, idleMinutes
        }))
      } else {
        state.config = Object.assign(state.config, { apiBase, deviceCode, title, kiosk, autoLaunch, idleMinutes })
      }
      updateDeviceMeta()
      toast('设置已保存', 'ok')
      show(state.setupReturn === 'viewHome' && state.token ? 'viewHome' : 'viewLogin')
      if (!state.token) syncLoginMode()
    } catch (e) {
      $('setupErr').textContent = e.message || '保存失败'
    } finally {
      setLoading(false)
    }
  }

  async function testApi() {
    $('setupErr').textContent = ''
    const apiBase = $('cfgApiBase').value.trim().replace(/\/$/, '')
    if (!apiBase) { $('setupErr').textContent = '请先填写 API 地址'; return }
    setLoading(true, '测试连接…')
    try {
      const ctrl = new AbortController()
      const t = setTimeout(() => ctrl.abort(), 8000)
      const res = await fetch(joinUrl(apiBase, '/captchaImage'), { signal: ctrl.signal })
      clearTimeout(t)
      const data = await res.json().catch(() => ({}))
      if (data.code === 200 || data.img) {
        $('setupErr').textContent = ''
        $('setupMeta').textContent = '连接成功：' + apiBase
        toast('连接成功', 'ok')
      } else {
        $('setupErr').textContent = '连接异常：' + (data.msg || res.status)
      }
    } catch (e) {
      $('setupErr').textContent = '无法连接：' + (e.name === 'AbortError' ? '超时' : (e.message || '网络错误'))
    } finally {
      setLoading(false)
    }
  }

  function updateDeviceMeta() {
    $('deviceMeta').textContent = '设备：' + (state.config.deviceCode || '-') +
      ' · API：' + (state.config.apiBase || '-') +
      ' · v' + (state.config.appVersion || '1.4.0')
  }

  function tickClock() {
    const el = $('clockLabel')
    if (!el) return
    const n = new Date()
    const p = (x) => String(x).padStart(2, '0')
    el.textContent = p(n.getMonth() + 1) + '-' + p(n.getDate()) + ' ' + p(n.getHours()) + ':' + p(n.getMinutes())
  }

  async function refreshCaptcha() {
    try {
      const data = await api('GET', '/captchaImage', null, { noAuth: true })
      state.uuid = data.uuid
      $('captchaImg').src = 'data:image/jpeg;base64,' + data.img
    } catch (e) {
      $('loginErr').textContent = e.message || '验证码加载失败'
    }
  }

  function loginMode() {
    const el = document.querySelector('input[name="loginMode"][value="pin"]')
    const pwd = document.querySelector('input[name="loginMode"][value="pwd"]')
    if (pwd && pwd.checked) return 'pwd'
    if (el && el.checked) return 'pin'
    return 'pin'
  }

  function setLoginMode(mode) {
    const pin = mode === 'pin'
    document.querySelectorAll('input[name="loginMode"]').forEach((el) => {
      el.checked = el.value === mode
    })
    document.querySelectorAll('#loginModeSeg .seg-item').forEach((btn) => {
      btn.classList.toggle('active', btn.dataset.mode === mode)
    })
    syncLoginMode()
  }

  function syncLoginMode() {
    const pin = loginMode() === 'pin'
    $('pinFields').hidden = !pin
    $('pwdFields').hidden = pin
    buildSoftKb(pin ? 'num' : 'full')
    $('softKb').hidden = false
    $('btnToggleKb').textContent = '隐藏软键盘'
    if (pin) {
      state.kbTarget = $('loginPin')
      updatePinDots()
    } else {
      state.kbTarget = $('loginPwd')
      refreshCaptcha()
    }
  }

  function updatePinDots() {
    const box = $('pinDots')
    if (!box) return
    const len = ($('loginPin').value || '').length
    Array.from(box.children).forEach((dot, i) => {
      dot.classList.toggle('on', i < len)
      dot.classList.toggle('next', i === len && len < 6)
    })
  }

  function shakeLogin() {
    const card = document.querySelector('.auth-card') || document.querySelector('.login-card')
    if (!card) return
    card.classList.remove('shake')
    void card.offsetWidth
    card.classList.add('shake')
  }

  function emptyHtml(text, cta) {
    return '<div class="empty"><div class="empty-ico" aria-hidden="true">◇</div><p>' +
      escapeHtml(text) + '</p>' +
      (cta ? ('<button type="button" class="btn primary" data-empty-cta="' + cta.action + '">' +
        escapeHtml(cta.label) + '</button>') : '') +
      '</div>'
  }

  function taskCardHtml(l) {
    return '<article class="task-card">' +
      '<h4>' + escapeHtml(l.bookName || '练习记录') + '</h4>' +
      '<div class="task-meta">' + escapeHtml(practiceDateStr(l.practiceDate) || '今天') +
      ' · ' + escapeHtml(l.questionText || '') +
      (l.knowledgeNames ? (' · ' + escapeHtml(l.knowledgeNames)) : '') + '</div>' +
      '<div class="task-foot">' +
      '<span class="chip">' + finishLabel(l.finishStatus) + '</span>' +
      (l.proxyFlag === '1' ? ('<span class="chip weak">代提·' + confirmLabel(l.confirmStatus) + '</span>') : '') +
      '</div></article>'
  }

  function renderWeekBars(logs) {
    const box = $('weekBars')
    if (!box) return
    const counts = [0, 0, 0, 0, 0, 0, 0]
    const today = new Date()
    const todayIdx = (today.getDay() + 6) % 7
    ;(logs || []).forEach((l) => {
      const d = practiceDateStr(l.practiceDate)
      if (!d) return
      const dt = new Date(d + 'T00:00:00')
      const idx = (dt.getDay() + 6) % 7
      counts[idx] += 1
    })
    const max = Math.max(1, ...counts)
    const daysActive = counts.filter((n) => n > 0).length
    const total = counts.reduce((a, b) => a + b, 0)
    box.innerHTML = counts.map((n, i) => {
      const h = 14 + Math.round((n / max) * 58)
      return '<i class="' + (i === todayIdx ? 'today' : '') + '" style="height:' + h + 'px" title="' +
        n + '条" data-day="' + i + '"></i>'
    }).join('')
    if ($('weekDaysText')) {
      $('weekDaysText').textContent = daysActive
        ? ('已练 ' + daysActive + ' 天 · 共 ' + total + ' 条')
        : '本周还未打卡'
    }
  }

  function renderHomeAlerts(opts) {
    const box = $('homeAlerts')
    if (!box) return
    const items = []
    if (opts.confirmable > 0) {
      items.push({
        cls: 'warn',
        text: '有 ' + opts.confirmable + ' 条代提可确认，请尽快处理',
        action: 'confirm',
        label: '去确认'
      })
    }
    if (opts.qn > 0) {
      items.push({
        cls: 'info',
        text: '离线待传 ' + opts.qn + ' 条，联网后将自动同步',
        action: 'flush',
        label: '立即同步'
      })
    }
    if (opts.isLeader && opts.groupMiss > 0) {
      items.push({
        cls: 'info',
        text: '本组还有 ' + opts.groupMiss + ' 人未交',
        action: 'proxy',
        label: '去代提'
      })
    }
    if (!opts.done && !(opts.tpl && opts.tpl.bookName)) {
      items.push({
        cls: 'ok',
        text: '今日尚未打卡，点上方按钮开始登记',
        action: 'practice',
        label: '去打卡'
      })
    }
    if (!items.length) {
      box.hidden = true
      box.innerHTML = ''
      return
    }
    box.hidden = false
    box.innerHTML = items.map((it) =>
      '<div class="home-alert ' + it.cls + '"><span>' + escapeHtml(it.text) + '</span>' +
      '<button type="button" class="btn mini primary" data-home-alert="' + it.action + '">' +
      escapeHtml(it.label) + '</button></div>'
    ).join('')
  }

  function renderHomeTodayPreview(logs) {
    const mod = $('homeTodayMod')
    const box = $('homeTodayPreview')
    if (!mod || !box) return
    if (!logs.length) {
      mod.hidden = true
      box.innerHTML = ''
      return
    }
    mod.hidden = false
    if ($('homeTodayTitle')) $('homeTodayTitle').textContent = '已交 ' + logs.length + ' 条'
    box.innerHTML = logs.slice(0, 3).map((l) =>
      '<div class="today-item">' +
      '<div>' + escapeHtml(l.bookName || '练习') +
      (l.pageFrom ? (' · p.' + l.pageFrom + (l.pageTo && l.pageTo !== l.pageFrom ? ('-' + l.pageTo) : '')) : '') +
      '</div>' +
      '<div class="muted">题号 ' + escapeHtml(l.questionText || '-') +
      ' · ' + finishLabel(l.finishStatus) +
      (l.knowledgeNames ? (' · ' + escapeHtml(l.knowledgeNames)) : '') +
      '</div></div>'
    ).join('')
  }

  function renderHomeGroup(progress, isLeader, group) {
    const mod = $('homeGroupMod')
    if (!mod) return
    if (!progress.length) {
      mod.hidden = true
      return
    }
    mod.hidden = false
    const doneN = progress.filter((m) => m.submitted).length
    const miss = progress.filter((m) => !m.submitted)
    const gName = (group && (group.groupName || group.group_name)) || '本组今日'
    if ($('homeGroupName')) $('homeGroupName').textContent = gName
    if ($('homeGroupRate')) $('homeGroupRate').textContent = doneN + ' / ' + progress.length + ' 已交'
    if ($('homeGroupPill')) {
      $('homeGroupPill').textContent = miss.length ? (miss.length + ' 人未交') : '全员已交'
      $('homeGroupPill').className = 'pill' + (miss.length ? '' : ' dark')
    }
    const box = $('homeGroupMiss')
    if (box) {
      if (!miss.length) {
        box.innerHTML = '<span class="chip ok">全员已交，棒！</span>'
      } else {
        box.innerHTML = miss.map((m) =>
          '<button type="button" class="chip tap" data-proxy-id="' + m.studentId +
          '" data-proxy-name="' + escapeHtml(m.studentName) + '"' +
          (isLeader ? '' : ' disabled') + '>' +
          escapeHtml(m.studentName) + (isLeader ? ' · 代提' : ' · 未交') + '</button>'
        ).join('')
      }
    }
    if ($('btnHomeProxy')) $('btnHomeProxy').hidden = !(isLeader && miss.length)
  }

  function renderHomeWeak(list) {
    const box = $('homeWeakList')
    if (!box) return
    if (!list.length) {
      box.innerHTML = '<span class="muted">暂无薄弱建议</span>'
      return
    }
    box.innerHTML = list.slice(0, 6).map((k) =>
      '<button type="button" class="chip weak tap" data-kid="' + k.knowledgeId + '">' +
      escapeHtml(k.knowledgeName || '') + '</button>'
    ).join('')
  }

  function loadRecentUsers() {
    try { return JSON.parse(localStorage.getItem(RECENT_USERS_KEY) || '[]') } catch (e) { return [] }
  }

  function saveRecentUser(studentNo, studentName) {
    if (!studentNo) return
    const list = loadRecentUsers().filter((u) => u.no !== studentNo)
    list.unshift({ no: studentNo, name: studentName || studentNo })
    localStorage.setItem(RECENT_USERS_KEY, JSON.stringify(list.slice(0, 6)))
    localStorage.setItem(LAST_USER_KEY, studentNo)
  }

  function renderRecentUsers() {
    const box = $('recentUsers')
    if (!box) return
    const list = loadRecentUsers()
    if (!list.length) { box.hidden = true; box.innerHTML = ''; return }
    box.hidden = false
    box.innerHTML = list.map((u) =>
      '<button type="button" class="chip tap" data-uno="' + escapeHtml(u.no) + '">' +
      escapeHtml(u.name || u.no) + '</button>'
    ).join('')
  }

  function tplKey() {
    const id = state.profile && (state.profile.studentId || state.profile.studentNo)
    return LAST_TPL_PREFIX + (id || 'anon')
  }

  function loadTemplate() {
    try {
      state.lastTemplate = JSON.parse(localStorage.getItem(tplKey()) || 'null')
    } catch (e) { state.lastTemplate = null }
    return state.lastTemplate
  }

  function saveTemplate(payload) {
    if (!payload) return
    const tpl = {
      subjectId: payload.subjectId,
      knowledgeIds: payload.knowledgeIds || [],
      bookName: payload.bookName || '',
      pageFrom: payload.pageFrom,
      pageTo: payload.pageTo,
      savedAt: Date.now()
    }
    localStorage.setItem(tplKey(), JSON.stringify(tpl))
    state.lastTemplate = tpl
  }

  function updateReuseButtons() {
    const tpl = state.lastTemplate || loadTemplate()
    const label = tpl && tpl.bookName
      ? ('复用上次：' + tpl.bookName + (tpl.pageFrom ? (' p.' + tpl.pageFrom + (tpl.pageTo && tpl.pageTo !== tpl.pageFrom ? ('-' + tpl.pageTo) : '')) : ''))
      : ''
    ;['btnReuseLast', 'btnReuseInForm'].forEach((id) => {
      const el = $(id)
      if (!el) return
      el.hidden = !tpl
      if (tpl && id === 'btnReuseLast') el.textContent = label
      if (tpl && id === 'btnReuseInForm') el.textContent = '带入上次'
    })
  }

  async function login() {
    if (state.busy) return
    $('loginErr').textContent = ''
    const username = $('loginUser').value.trim()
    if (!username) { $('loginErr').textContent = '请输入学号'; return }
    try {
      setLoading(true, '登录中…')
      let data
      if (loginMode() === 'pin') {
        const pin = $('loginPin').value.trim()
        if (!pin) { $('loginErr').textContent = '请输入 PIN'; return }
        data = await api('POST', '/spas/practice/pin/login', { studentNo: username, pin }, { noAuth: true })
      } else {
        const password = $('loginPwd').value
        const code = $('loginCode').value.trim()
        if (!password) { $('loginErr').textContent = '请输入密码'; return }
        data = await api('POST', '/login', { username, password, code, uuid: state.uuid }, { noAuth: true })
      }
      state.token = data.token
      localStorage.setItem('spas_desktop_token', state.token)
      saveRecentUser(username, username)
      $('loginPin').value = ''
      $('loginPwd').value = ''
      logClient('login ok user=' + username)
      await afterLogin()
      toast('登录成功', 'ok')
    } catch (e) {
      $('loginErr').textContent = e.message || '登录失败'
      shakeLogin()
      logClient('login fail ' + (e.message || ''))
      if (loginMode() !== 'pin') refreshCaptcha()
      else { $('loginPin').value = ''; updatePinDots() }
    } finally {
      setLoading(false)
    }
  }

  async function afterLogin() {
    const profileRes = await api('GET', '/spas/practice/session/profile')
    state.profile = profileRes.data || {}
    const name = state.profile.studentName || '同学'
    const no = state.profile.studentNo || ''
    if (no) saveRecentUser(no, name)
    if ($('userLabel')) $('userLabel').textContent = name + (no ? ('（' + no + '）') : '')
    if ($('userAvatar')) $('userAvatar').textContent = (name || '生').slice(0, 1)
    if ($('asideRole')) $('asideRole').textContent = state.profile.leader ? '组长' : '学生'
    loadTemplate()
    const subRes = await api('GET', '/spas/subject/optionselect')
    state.subjects = subRes.data || []
    heartbeat()
    await flushQueue()
    await loadHome()
    show('viewHome')
    touchIdle()
  }

  async function heartbeat() {
    if (!state.config.deviceCode || !state.token) return
    try {
      await api('POST', '/spas/practice/device/heartbeat', {
        deviceCode: state.config.deviceCode,
        deviceName: state.config.title || '一体机',
        deptId: state.profile && state.profile.deptId,
        appVersion: state.config.appVersion || '1.5.7'
      })
    } catch (e) { /* ignore */ }
  }

  function memberChipHtml(m) {
    return '<span class="chip ' + (m.submitted ? 'ok' : 'miss') + '">' +
      escapeHtml(m.studentName) + (m.roleInGroup === '1' ? '·组长' : '') +
      ' · ' + (m.submitted ? '已交' : '未交') + '</span>'
  }

  function renderAsideTips(logs, confirmable, qn, groupMiss, progress) {
    const box = $('asideTips')
    if (!box) return
    const tips = []
    const acc = state.points && state.points.account
    if (!logs.length) tips.push(['out', '今日还没打卡，点下方「去打卡」开始吧。'])
    else tips.push(['in', '今日已交 ' + logs.length + ' 条，保持节奏不错。'])
    if (acc) {
      const todayPts = acc.todayPoints || 0
      const streak = acc.dayStreak || 0
      tips.push(['in', '今日积分 +' + todayPts + (streak >= 2 ? ('，连打 ' + streak + ' 天') : '')])
      if (state.points.weekRank) tips.push(['out', '本周班榜第 ' + state.points.weekRank + ' 名，加油！'])
    }
    if (confirmable) tips.push(['out', '有 ' + confirmable + ' 条代提可确认，确认后对方可得积分。'])
    if (qn) tips.push(['in', '离线待传 ' + qn + ' 条，联网后会自动同步。'])
    if (progress.length && groupMiss > 0) tips.push(['in', '本组还有 ' + groupMiss + ' 人未交，可提醒一下。'])
    if (state.weak && state.weak.length) tips.push(['out', '建议优先练：' + (state.weak[0].knowledgeName || '薄弱主题') + '（命中薄弱可加分）'])
    if (!tips.length) tips.push(['in', '优先练薄弱主题，有困难请写清卡点题号。'])
    box.innerHTML = tips.slice(0, 5).map((t) =>
      '<div class="chat-bubble ' + t[0] + '">' + escapeHtml(t[1]) + '</div>'
    ).join('')
  }

  function setDashOpen(open) {
    state.dashOpen = !!open
    if ($('dashWrap')) $('dashWrap').hidden = !state.dashOpen
    if ($('btnToggleDash')) {
      $('btnToggleDash').textContent = state.dashOpen ? '收起明细' : '更多明细'
    }
  }

  async function loadHome() {
    const todayRes = await api('GET', '/spas/practice/mine/today')
    state.today = todayRes.data || {}
    try {
      const co = await api('GET', '/spas/practice/checkout/today')
      state.checkout = co.data || {}
    } catch (e) {
      state.checkout = {}
    }
    const name = state.profile.studentName || '同学'
    if ($('hello')) $('hello').textContent = '你好，' + name
    const logs = state.today.logs || []
    const qn = loadQueue().length
    const pending = state.today.pendingConfirm || []
    const confirmable = pending.filter((l) => practiceDateStr(l.practiceDate) < todayStr()).length
    const done = logs.length > 0
    const tpl = state.lastTemplate || loadTemplate()
    const co = state.checkout || {}
    const asg = co.assignment
    const pendingAck = co.pendingAck || []
    const myItem = co.myItem
    if ($('homeStatus')) {
      if (pendingAck.length) {
        $('homeStatus').textContent = '有待确认的检查结果，请先点属实或异议'
      } else if (co.leader && asg) {
        $('homeStatus').textContent = co.checkout
          ? '检查结果已登记，可改正后重提'
          : ('今日任务：' + (asg.bookName || '') + ' · 先在座位检查，再上机登记')
      } else if (myItem) {
        const ack = myItem.memberAck
        $('homeStatus').textContent = ack === '1' ? '今日检查已确认属实' : (ack === '2' ? '已提出异议，等待老师抽检' : '组长已在座位检查，请确认')
      } else if (asg) {
        $('homeStatus').textContent = '今日已布置，等待组长在座位上检查'
      } else {
        $('homeStatus').textContent = done
          ? ('今日已交 ' + logs.length + ' 条加练')
          : '今日教师尚未布置'
      }
    }
    if ($('btnGoPractice')) {
      if (pendingAck.length) $('btnGoPractice').textContent = '确认检查结果'
      else if (co.leader && asg) $('btnGoPractice').textContent = co.checkout ? '改正检查登记' : '登记检查结果'
      else $('btnGoPractice').textContent = asg ? '等待组长座位检查' : '今日尚未布置'
    }
    if ($('btnGoExtra')) $('btnGoExtra').hidden = false
    const wq = co.weekQualify
    if ($('weekPill')) {
      $('weekPill').textContent = wq
        ? ((wq.qualified ? '本周组达标' : '本周未达标') + ' · ' + (wq.submittedCount || 0) + '/' + (wq.dueCount || 0) + ' 次')
        : (logs.length + ' 条今日')
    }
    ;['navProxy', 'btnGoProxy', 'btnGoProxy2'].forEach((id) => {
      if ($(id)) $(id).hidden = true
    })
    if ($('weekTip')) {
      $('weekTip').textContent = wq
        ? (wq.qualified ? '本周组达标已点亮' : '本周检查 ' + (wq.submittedCount || 0) + '/' + (wq.dueCount || 0) + ' 次，抽检无偏松才达标')
        : (done ? '今日已有加练记录' : '今日待检查或加练')
    }
    if ($('todayOkBadge')) $('todayOkBadge').hidden = !done
    const isLeader = !!state.today.leader
    ;['navProxy', 'btnGoProxy', 'btnGoProxy2'].forEach((id) => {
      if ($(id)) $(id).hidden = true
    })
    const grid = $('actionGrid')
    if (grid) grid.classList.toggle('single', !isLeader)
    const progress = state.today.groupProgress || []
    const groupMiss = progress.filter((m) => !m.submitted).length
    if ($('statDone')) $('statDone').textContent = String(logs.length)
    if ($('statDoneDash')) $('statDoneDash').textContent = String(logs.length)
    if ($('statGroupMiss')) $('statGroupMiss').textContent = progress.length ? String(groupMiss) : '-'
    if ($('statConfirm')) $('statConfirm').textContent = String(pendingAck.length || confirmable)
    if ($('statConfirmDash')) $('statConfirmDash').textContent = String(pendingAck.length || confirmable)
    if ($('statConfirmTodo')) $('statConfirmTodo').textContent = String(pendingAck.length || confirmable)
    if ($('statQueue')) $('statQueue').textContent = String(qn)
    if ($('asideRole')) $('asideRole').textContent = isLeader ? '组长' : '学生'
    if ($('groupCard')) $('groupCard').hidden = !progress.length
    if ($('tabGroupBtn')) $('tabGroupBtn').hidden = !progress.length
    const chips = progress.map(memberChipHtml).join('')
    if ($('groupProgress')) $('groupProgress').innerHTML = chips
    if ($('centerGroupProgress')) {
      $('centerGroupProgress').innerHTML = chips || emptyHtml('暂无分组信息')
    }
    if ($('todayList')) {
      $('todayList').innerHTML = logs.length
        ? logs.map(taskCardHtml).join('')
        : emptyHtml('今天还没有打卡', { action: 'practice', label: '去登记' })
    }
    renderHomeTodayPreview(logs)
    renderHomeGroup(progress, isLeader, state.today.group)
    renderPendingConfirm(pending)
    loadTemplate()
    updateReuseButtons()
    if ($('quickHero')) $('quickHero').classList.toggle('is-done', done)
    if ($('homeBoardMod')) $('homeBoardMod').hidden = true
    // 明细默认收起；有待确认时仅滚动到确认模块，不强行撑开旧明细
    if (!state.dashOpen) setDashOpen(false)
    try {
      const recent = await api('GET', '/spas/practice/mine/recent?days=7')
      const list = recent.data || []
      state.recentLogs = list
      renderWeekBars(list)
      if (!state.lastTemplate && list.length) {
        const last = list[0]
        state.lastTemplate = {
          subjectId: last.subjectId,
          knowledgeIds: last.knowledgeIds || [],
          bookName: last.bookName || '',
          pageFrom: last.pageFrom,
          pageTo: last.pageTo,
          fromServer: true
        }
        updateReuseButtons()
      }
    } catch (e) {
      state.recentLogs = logs
      renderWeekBars(logs)
    }
    try {
      const sid = state.subjects[0] && state.subjects[0].subjectId
      const weakRes = await api('GET', '/spas/practice/suggest/weak?limit=8' + (sid ? ('&subjectId=' + sid) : ''))
      state.weak = weakRes.data || []
      renderHomeWeak(state.weak)
      if ($('weakList')) {
        $('weakList').innerHTML = state.weak.length
          ? state.weak.map((k) =>
            '<button type="button" class="chip weak tap" data-kid="' + k.knowledgeId + '">' +
            escapeHtml(k.knowledgeName || '') + '</button>'
          ).join('')
          : emptyHtml('暂无薄弱建议，可自行选择知识点', { action: 'practice', label: '去打卡' })
      }
    } catch (e) {
      renderHomeWeak([])
      if ($('weakList')) $('weakList').innerHTML = emptyHtml('薄弱建议暂不可用', { action: 'practice', label: '去打卡' })
    }
    renderHomeAlerts({
      confirmable, qn, groupMiss, isLeader, done,
      tpl: state.lastTemplate || loadTemplate()
    })
    updateQueueBadge()
    await loadPointsHome()
    renderAsideTips(logs, confirmable, qn, groupMiss, progress)
    if (confirmable && $('homeConfirmMod')) {
      $('homeConfirmMod').scrollIntoView({ behavior: 'smooth', block: 'nearest' })
    }
  }

  async function loadPointsHome(opts) {
    opts = opts || {}
    const prevLevel = state.prevLevelNo
    try {
      const mineRes = await api('GET', '/spas/practice/points/mine')
      state.points = mineRes.data || {}
      const lv = (state.points.account && state.points.account.levelNo) || 1
      if (prevLevel != null && lv > prevLevel) {
        state.leveledUpTo = lv
      }
      state.prevLevelNo = lv
      renderLevelBar(state.points)
      renderAsidePoints(state.points)
    } catch (e) {
      state.points = { _loadError: true, account: {} }
      renderLevelBar(state.points)
      renderAsidePoints(null)
      if (opts.toastError) toast('积分加载失败，点刷新重试', 'warn')
    }
    await loadLeaderboard(state.boardRange || 'week')
    await loadAsideLedger()
  }

  function levelProgress(acc) {
    const total = (acc && acc.totalPoints) || 0
    const min = (acc && acc.levelMinPoints) || 0
    const max = (acc && acc.levelMaxPoints) || 50
    const span = Math.max(1, max - min)
    const pct = Math.max(0, Math.min(100, Math.round(((total - min) / span) * 100)))
    const need = acc && acc.pointsToNext != null ? acc.pointsToNext : Math.max(0, max - total)
    return { total, min, max, pct, need, level: (acc && acc.levelNo) || 1, today: (acc && acc.todayPoints) || 0, streak: (acc && acc.dayStreak) || 0 }
  }

  function renderLevelBar(data) {
    const p = levelProgress(data && data.account)
    if ($('levelBadge')) {
      $('levelBadge').textContent = 'Lv.' + p.level
      if (state.leveledUpTo) {
        $('levelBadge').classList.add('pulse')
        setTimeout(() => {
          if ($('levelBadge')) $('levelBadge').classList.remove('pulse')
          state.leveledUpTo = null
        }, 800)
      }
    }
    if ($('levelPointsText')) $('levelPointsText').textContent = p.total + ' 积分'
    const week = (data && data.account && data.account.weekPoints) || 0
    if ($('levelTodayText')) {
      $('levelTodayText').textContent = '今日 +' + p.today + ' · 本周 ' + week + ' · 连打 ' + p.streak + ' 天'
    }
    if ($('levelFill')) $('levelFill').style.width = p.pct + '%'
    if ($('levelNextText')) {
      if (data && data._loadError) {
        $('levelNextText').textContent = '积分加载失败，点刷新重试'
      } else {
        $('levelNextText').textContent = p.need <= 0 ? '已满本级' : ('距下一级还需 ' + p.need)
      }
    }
  }

  function renderAsidePoints(data) {
    const p = levelProgress(data && data.account)
    if ($('asideLv')) $('asideLv').textContent = 'Lv.' + p.level
    if ($('asideTotalPts')) $('asideTotalPts').textContent = String(p.total)
    if ($('asidePtsSub')) {
      $('asidePtsSub').textContent = '今日 +' + p.today + ' · 连打 ' + p.streak + ' 天'
    }
    if ($('asideLevelFill')) $('asideLevelFill').style.width = p.pct + '%'
    const weekRank = data && data.weekRank
    const allRank = data && data.allRank
    if ($('asideRankHint')) {
      if (weekRank || allRank) {
        $('asideRankHint').textContent =
          (weekRank ? ('本周第 ' + weekRank + ' 名') : '本周未上榜') +
          ' · ' +
          (allRank ? ('累计第 ' + allRank + ' 名') : '累计未上榜')
      } else {
        $('asideRankHint').textContent = '打卡即可上榜'
      }
    }
  }

  function boardRowHtml(row, myId, range) {
    const mine = myId && Number(row.studentId) === Number(myId)
    const pts = range === 'week' ? (row.weekPoints || 0) : (row.totalPoints || 0)
    return '<li class="' + (mine ? 'me' : '') + '">' +
      '<span class="board-rank">' + (row.rankNo || '-') + '</span>' +
      '<span class="board-name">' + escapeHtml(row.studentName || '') +
      (mine ? '（我）' : '') + '</span>' +
      '<span class="board-pts">' + pts +
      ' <small>Lv.' + (row.levelNo || 1) + '</small></span></li>'
  }

  async function loadLeaderboard(range) {
    state.boardRange = range === 'all' ? 'all' : 'week'
    if ($('btnBoardWeek')) $('btnBoardWeek').classList.toggle('active', state.boardRange === 'week')
    if ($('btnBoardAll')) $('btnBoardAll').classList.toggle('active', state.boardRange === 'all')
    if ($('boardTitle')) $('boardTitle').textContent = state.boardRange === 'week' ? '本周 Top10' : '累计 Top10'
    if ($('asideBoardRangeLabel')) $('asideBoardRangeLabel').textContent = state.boardRange === 'week' ? '本周' : '累计'
    try {
      const res = await api('GET', '/spas/practice/points/leaderboard?range=' + state.boardRange + '&limit=10')
      const data = res.data || {}
      const list = data.list || []
      const myId = data.myStudentId || (state.profile && state.profile.studentId)
      const empty = '<li class="empty-row">暂无上榜同学，打卡即可获得积分</li>'
      if ($('homeBoardList')) {
        $('homeBoardList').innerHTML = list.length
          ? list.map((row) => boardRowHtml(row, myId, state.boardRange)).join('')
          : empty
      }
      if ($('asideBoardList')) {
        $('asideBoardList').innerHTML = list.length
          ? list.slice(0, 5).map((row) => boardRowHtml(row, myId, state.boardRange)).join('')
          : empty
      }
      if ($('boardMyRank')) {
        const r = data.myRank
        $('boardMyRank').textContent = r ? ('我的名次：第 ' + r + ' 名') : '我的名次：暂未上榜'
      }
      if (state.points) {
        if (state.boardRange === 'week') state.points.weekRank = data.myRank
        else state.points.allRank = data.myRank
        renderAsidePoints(state.points)
      }
    } catch (e) {
      const err = '<li class="empty-row">积分榜暂不可用</li>'
      if ($('homeBoardList')) $('homeBoardList').innerHTML = err
      if ($('asideBoardList')) $('asideBoardList').innerHTML = err
    }
  }

  async function loadAsideLedger() {
    try {
      const res = await api('GET', '/spas/practice/points/ledger?limit=6')
      state.ledger = res.data || []
      const box = $('asideLedgerList')
      const wrap = $('asideLedgerBlock')
      if (!box || !wrap) return
      if (!state.ledger.length) {
        wrap.hidden = true
        return
      }
      wrap.hidden = false
      box.innerHTML = state.ledger.map((row) => {
        const label = row.reasonLabel || row.reasonCode || '积分'
        const remark = row.remark ? (' · ' + row.remark) : ''
        return '<li><div><b>+' + (row.points || 0) + '</b> ' + escapeHtml(label) +
          '<br/><span class="muted">' + escapeHtml(String(row.createTime || '').slice(0, 16).replace('T', ' ')) +
          escapeHtml(remark) + '</span></div></li>'
      }).join('')
    } catch (e) {
      if ($('asideLedgerBlock')) $('asideLedgerBlock').hidden = true
    }
  }

  async function loadHistory() {
    if ($('historyList')) $('historyList').innerHTML = emptyHtml('加载中…')
    show('viewHistory')
    try {
      const res = await api('GET', '/spas/practice/mine/recent?days=7')
      const list = res.data || []
      $('historyList').innerHTML = list.length
        ? list.map(taskCardHtml).join('')
        : emptyHtml('近 7 日暂无打卡记录', { action: 'practice', label: '去打卡' })
      renderWeekBars(list)
    } catch (e) {
      $('historyList').innerHTML = emptyHtml(e.message || '加载失败')
    }
  }

  function switchHomeTab(tab) {
    document.querySelectorAll('#homeTabs .tab').forEach((el) => {
      el.classList.toggle('active', el.dataset.tab === tab)
    })
    ;['todo', 'weak', 'done', 'group'].forEach((k) => {
      const panel = $('tab' + k.charAt(0).toUpperCase() + k.slice(1))
      if (panel) panel.hidden = k !== tab
    })
  }

  function finishLabel(v) {
    return ({ '1': '已完成', '2': '部分', '3': '有困难', '0': '未做', 'L': '请假', 'A': '未到/没本' })[v] || v
  }
  function confirmLabel(v) {
    return ({ '0': '本人', '1': '待确认', '2': '已确认', '3': '已驳回' })[v] || ''
  }
  function practiceDateStr(d) {
    if (!d) return ''
    if (typeof d === 'string') return d.slice(0, 10)
    try { return new Date(d).toISOString().slice(0, 10) } catch (e) { return '' }
  }
  function todayStr() {
    const n = new Date()
    const m = String(n.getMonth() + 1).padStart(2, '0')
    const d = String(n.getDate()).padStart(2, '0')
    return n.getFullYear() + '-' + m + '-' + d
  }

  function confirmItemHtml(l, today) {
    const day = practiceDateStr(l.practiceDate)
    const ok = day < today
    return '<li><div>' + escapeHtml(day) + ' · ' + escapeHtml(l.bookName || '') +
      ' · ' + escapeHtml(l.questionText || '') +
      '<br/><span class="muted">代提人 ' + escapeHtml(l.submitByName || '') + '</span></div>' +
      (ok
        ? '<div class="feed-actions">' +
          '<button type="button" class="btn mini ok" data-confirm="' + l.logId + '">确认</button>' +
          '<button type="button" class="btn mini danger" data-reject="' + l.logId + '">驳回</button></div>'
        : '<span class="chip">明日可确认</span>') +
      '</li>'
  }

  function renderPendingConfirm(list) {
    const card = $('confirmCard')
    const ul = $('confirmList')
    const center = $('centerConfirmCard')
    const centerUl = $('centerConfirmList')
    const homeMod = $('homeConfirmMod')
    const homeUl = $('homeConfirmList')
    if (!list.length) {
      if (card) card.hidden = true
      if (ul) ul.innerHTML = ''
      if (center) center.hidden = true
      if (centerUl) centerUl.innerHTML = ''
      if (homeMod) homeMod.hidden = true
      if (homeUl) homeUl.innerHTML = ''
      return
    }
    const today = todayStr()
    const ready = list.filter((l) => practiceDateStr(l.practiceDate) < today)
    const hint = ready.length ? ('（' + ready.length + ' 条可确认）') : '（次日可确认）'
    const html = list.map((l) => confirmItemHtml(l, today)).join('')
    if (card) card.hidden = false
    if ($('confirmHint')) $('confirmHint').textContent = hint
    if (ul) ul.innerHTML = html
    if (center) center.hidden = false
    if ($('centerConfirmHint')) $('centerConfirmHint').textContent = hint
    if (centerUl) centerUl.innerHTML = html
    if (homeMod) homeMod.hidden = false
    if ($('homeConfirmTitle')) {
      $('homeConfirmTitle').textContent = ready.length
        ? (ready.length + ' 条可确认')
        : (list.length + ' 条待次日确认')
    }
    if (homeUl) homeUl.innerHTML = html
  }

  async function handleConfirm(logId, accept) {
    if (!accept) {
      state.rejectLogId = logId
      if ($('rejectDlg')) $('rejectDlg').hidden = false
      return
    }
    await doConfirmProxy(logId, true)
  }

  async function doConfirmProxy(logId, accept) {
    try {
      setLoading(true, accept ? '确认中…' : '驳回中…')
      const res = await api('PUT', '/spas/practice/proxy/' + logId + '/confirm', { accept })
      const awarded = res && res.awardedPoints != null ? Number(res.awardedPoints) : 0
      if (accept && awarded > 0) toast('已确认，积分 +' + awarded, 'ok')
      else toast(accept ? '已确认代提' : '已驳回并作废', accept ? 'ok' : 'warn')
      await loadHome()
    } catch (e) {
      toast(e.message || '操作失败', 'err')
    } finally {
      setLoading(false)
    }
  }

  function escapeHtml(s) {
    return String(s == null ? '' : s)
      .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
  }

  function openPractice(proxy, opts) {
    opts = opts || {}
    if (!proxy) state.proxyStudentId = null
    state.preselectKnowledgeIds = (opts.knowledgeIds || []).map(Number).filter(Boolean)
    state.draftReuse = opts.reuse ? (state.lastTemplate || loadTemplate()) : null
    if (state.draftReuse && state.draftReuse.knowledgeIds && state.draftReuse.knowledgeIds.length) {
      state.preselectKnowledgeIds = state.draftReuse.knowledgeIds.map(Number)
    }
    $('practiceTitle').textContent = proxy ? '帮组员登记' : '快速打卡'
    $('proxyHint').hidden = !proxy
    $('proxyHint').textContent = proxy
      ? ('正在为：' + state.proxyStudentName + ' 代提（组员次日需确认）')
      : ''
    fillSubjects()
    if (state.draftReuse && state.draftReuse.subjectId) {
      $('subjectId').value = String(state.draftReuse.subjectId)
    } else if (opts.subjectId) {
      $('subjectId').value = String(opts.subjectId)
    }
    $('formErr').textContent = ''
    ;['bookName', 'pageFrom', 'pageTo', 'questionText', 'difficultyNote', 'hardestQuestion', 'quickLine'].forEach((id) => {
      if ($(id)) {
        $(id).value = ''
        $(id).classList.remove('invalid')
      }
    })
    if (state.draftReuse) {
      $('bookName').value = state.draftReuse.bookName || ''
      if (state.draftReuse.pageFrom != null) $('pageFrom').value = state.draftReuse.pageFrom
      if (state.draftReuse.pageTo != null) $('pageTo').value = state.draftReuse.pageTo
      if ($('reuseBanner')) {
        $('reuseBanner').hidden = false
        $('reuseBanner').textContent = '已带入上次书名与主题，改页码/题号后直接提交'
      }
    } else if ($('reuseBanner')) {
      $('reuseBanner').hidden = true
    }
    document.querySelector('input[name="finish"][value="1"]').checked = true
    $('diffWrap').hidden = true
    if ($('moreKnowWrap')) $('moreKnowWrap').hidden = true
    if ($('btnToggleMoreKnow')) $('btnToggleMoreKnow').textContent = '选择其他主题'
    updateReuseButtons()
    show('viewPractice')
    renderQuestionChips()
    onSubjectChange(!state.preselectKnowledgeIds.length).then(() => {
      syncBookPickActive()
      updatePracticeSteps()
      scrollToField(state.draftReuse ? 'pageFrom' : 'weakQuick')
    })
  }

  function fillSubjects() {
    $('subjectId').innerHTML = state.subjects.map((s) =>
      '<option value="' + s.subjectId + '">' + escapeHtml(s.subjectName) + '</option>'
    ).join('')
  }

  function renderWeakQuick(selectedIds) {
    const box = $('weakQuick')
    if (!box) return
    const selected = selectedIds || selectedKnowledgeIds()
    const items = (state.weak || []).slice(0, 6)
    if (!items.length) {
      box.innerHTML = '<p class="hint">暂无薄弱建议，可点下方「选择其他主题」</p>'
      return
    }
    box.innerHTML = items.map((k) => {
      const on = selected.indexOf(Number(k.knowledgeId)) >= 0
      return '<button type="button" class="pick weak-tag' + (on ? ' on' : '') + '" data-kid="' + k.knowledgeId + '">' +
        escapeHtml(k.knowledgeName || '') + '</button>'
    }).join('')
  }

  function renderBookPicks(books, activeName) {
    const box = $('bookPicks')
    if (!box) return
    state.books = books || []
    const active = activeName || ($('bookName').value || '').trim()
    if (!state.books.length) {
      box.innerHTML = '<span class="muted">暂无常用书，请手输书名</span>'
      return
    }
    box.innerHTML = state.books.map((b) => {
      const name = b.bookName || b.book_name || ''
      return '<button type="button" class="chip tap' + (name === active ? ' on' : '') + '" data-book="' +
        escapeHtml(name) + '">' + escapeHtml(name) + '</button>'
    }).join('')
  }

  function syncBookPickActive() {
    const name = ($('bookName').value || '').trim()
    document.querySelectorAll('#bookPicks .chip').forEach((el) => {
      el.classList.toggle('on', el.dataset.book === name)
    })
  }

  function renderQuestionChips() {
    const box = $('qChips')
    if (!box) return
    const selected = new Set(($('questionText').value || '').split(/[,，、\s]+/).filter(Boolean))
    box.innerHTML = Array.from({ length: 12 }, (_, i) => {
      const n = String(i + 1)
      return '<button type="button" class="chip tap' + (selected.has(n) ? ' on' : '') + '" data-q="' + n + '">' + n + '</button>'
    }).join('') + '<button type="button" class="chip tap" data-q="CLR">清空</button>'
  }

  function toggleQuestionChip(q) {
    if (q === 'CLR') {
      $('questionText').value = ''
      renderQuestionChips()
      updatePracticeSteps()
      return
    }
    const parts = ($('questionText').value || '').split(/[,，、\s]+/).filter(Boolean)
    const idx = parts.indexOf(q)
    if (idx >= 0) parts.splice(idx, 1)
    else parts.push(q)
    $('questionText').value = parts.join(',')
    renderQuestionChips()
    updatePracticeSteps()
  }

  function setKnowledgeChecked(id, on) {
    const box = $('knowledgeBox')
    if (!box) return
    let input = box.querySelector('input[value="' + id + '"]')
    if (!input && on) {
      // ensure weak quick selection persists even if not in more list yet
      return
    }
    if (input) input.checked = !!on
  }

  function syncKnowledgeFromQuick(kid, on) {
    setKnowledgeChecked(kid, on)
    // if more list doesn't have it, inject hidden checked input via weakQuick state by ensuring checkbox exists
    const box = $('knowledgeBox')
    if (!box) return
    let input = box.querySelector('input[value="' + kid + '"]')
    if (!input) {
      const k = (state.weak || []).find((x) => Number(x.knowledgeId) === Number(kid))
        || (state.knowledge || []).find((x) => Number(x.knowledgeId) === Number(kid))
      if (k) {
        const lab = document.createElement('label')
        lab.className = 'check weak'
        lab.innerHTML = '<input type="checkbox" value="' + k.knowledgeId + '" checked /><span>' +
          escapeHtml(k.knowledgeName) + '（薄弱）</span>'
        box.appendChild(lab)
        input = lab.querySelector('input')
      }
    }
    if (input) input.checked = !!on
    updatePracticeSteps()
  }

  async function onSubjectChange(precheckWeak) {
    const subjectId = $('subjectId').value
    if ($('knowledgeBox')) $('knowledgeBox').innerHTML = '<div class="hint">加载知识点…</div>'
    if ($('weakQuick')) $('weakQuick').innerHTML = '<p class="hint">加载薄弱建议…</p>'
    try {
      const deptQ = state.profile && state.profile.deptId ? ('&deptId=' + state.profile.deptId) : ''
      const [weakRes, treeRes, bookRes] = await Promise.all([
        api('GET', '/spas/practice/suggest/weak?limit=10&subjectId=' + subjectId),
        api('GET', '/spas/knowledge/tree/' + subjectId),
        api('GET', '/spas/practice/books/suggest?subjectId=' + subjectId + deptQ)
      ])
      const weak = weakRes.data || []
      state.weak = weak
      const flat = []
      flattenTree(treeRes.data || [], flat)
      const seen = {}
      const merged = []
      weak.forEach((k) => {
        if (!k.knowledgeId || seen[k.knowledgeId]) return
        seen[k.knowledgeId] = true
        merged.push({ knowledgeId: k.knowledgeId, knowledgeName: k.knowledgeName, weak: true })
      })
      flat.forEach((k) => {
        if (!k.knowledgeId || seen[k.knowledgeId]) return
        seen[k.knowledgeId] = true
        merged.push(k)
      })
      state.knowledge = merged.slice(0, 60)
      const pre = state.preselectKnowledgeIds || []
      const autoWeak = !pre.length && precheckWeak
      $('knowledgeBox').innerHTML = state.knowledge.map((k, idx) => {
        const checked = pre.length
          ? pre.indexOf(Number(k.knowledgeId)) >= 0
          : (autoWeak && k.weak && idx < 3)
        return '<label class="check' + (k.weak ? ' weak' : '') + '">' +
          '<input type="checkbox" value="' + k.knowledgeId + '"' + (checked ? ' checked' : '') + ' />' +
          '<span>' + escapeHtml(k.knowledgeName) + (k.weak ? '（薄弱）' : '') + '</span></label>'
      }).join('') || '<div class="hint">暂无知识点</div>'
      // default: if nothing selected and weak exists, select top 1 weak for minimal friction
      if (!selectedKnowledgeIds().length && weak.length) {
        const first = weak[0].knowledgeId
        setKnowledgeChecked(first, true)
        if (!$('knowledgeBox').querySelector('input[value="' + first + '"]')) {
          syncKnowledgeFromQuick(first, true)
        }
      }
      state.preselectKnowledgeIds = []
      const books = bookRes.data || []
      $('bookSuggest').innerHTML = books.map((b) =>
        '<option value="' + escapeHtml(b.bookName || '') + '"></option>'
      ).join('')
      renderBookPicks(books, ($('bookName').value || '').trim())
      renderWeakQuick(selectedKnowledgeIds())
      updatePracticeSteps()
    } catch (e) {
      if ($('knowledgeBox')) $('knowledgeBox').innerHTML = '<div class="err">' + escapeHtml(e.message) + '</div>'
      if ($('weakQuick')) $('weakQuick').innerHTML = '<p class="err">' + escapeHtml(e.message) + '</p>'
    }
  }

  function flattenTree(nodes, out) {
    ;(nodes || []).forEach((n) => {
      if (n.nodeType !== 'chapter' && n.knowledgeId) {
        out.push({ knowledgeId: n.knowledgeId, knowledgeName: n.knowledgeName, weak: false })
      }
      if (n.children && n.children.length) flattenTree(n.children, out)
    })
  }

  function selectedKnowledgeIds() {
    const box = $('knowledgeBox')
    const fromBox = box
      ? Array.from(box.querySelectorAll('input[type=checkbox]:checked')).map((el) => Number(el.value))
      : []
    if (fromBox.length) return fromBox
    return Array.from(document.querySelectorAll('#weakQuick .pick.on'))
      .map((el) => Number(el.dataset.kid))
      .filter(Boolean)
  }

  function buildPayload() {
    const finishStatus = (document.querySelector('input[name="finish"]:checked') || {}).value
    const knowledgeIds = selectedKnowledgeIds()
    const payload = {
      subjectId: Number($('subjectId').value),
      knowledgeIds,
      bookName: $('bookName').value.trim(),
      pageFrom: $('pageFrom').value ? Number($('pageFrom').value) : null,
      pageTo: $('pageTo').value ? Number($('pageTo').value) : null,
      questionText: $('questionText').value.trim(),
      finishStatus,
      difficultyNote: $('difficultyNote').value.trim(),
      hardestQuestion: $('hardestQuestion').value.trim(),
      clientType: 'desktop',
      deviceCode: state.config.deviceCode || ''
    }
    ;['bookName', 'questionText', 'difficultyNote', 'pageFrom', 'pageTo'].forEach((id) => {
      if ($(id)) $(id).classList.remove('invalid')
    })
    if (!payload.subjectId || !payload.bookName || !payload.questionText || !knowledgeIds.length) {
      $('formErr').textContent = '请完整填写学科、主题、书名和题号'
      if (!knowledgeIds.length) scrollToField('weakQuick')
      else if (!payload.bookName) { $('bookName').classList.add('invalid'); scrollToField('bookName') }
      else if (!payload.questionText) { $('questionText').classList.add('invalid'); scrollToField('questionText') }
      return null
    }
    if (payload.pageFrom && payload.pageTo && payload.pageTo < payload.pageFrom) {
      $('formErr').textContent = '结束页不能小于起始页'
      $('pageTo').classList.add('invalid')
      scrollToField('pageTo')
      return null
    }
    if (finishStatus === '3' && !payload.difficultyNote) {
      $('formErr').textContent = '有困难时请填写卡点说明'
      $('difficultyNote').classList.add('invalid')
      scrollToField('difficultyNote')
      return null
    }
    return payload
  }

  function scrollToField(id) {
    const el = $(id)
    if (el && el.scrollIntoView) el.scrollIntoView({ behavior: 'smooth', block: 'center' })
  }

  function askSubmitConfirm() {
    if (state.busy) return
    $('formErr').textContent = ''
    const payload = buildPayload()
    if (!payload) {
      updatePracticeSteps()
      return
    }
    const proxy = !!state.proxyStudentId
    if (proxy) payload.studentId = state.proxyStudentId
    state.pendingPayload = { payload, proxy, path: proxy ? '/spas/practice/proxy' : '/spas/practice' }
    hideDockKb()
    // 本人提交：跳过二次确认，减少排队停留
    if (!proxy) {
      doSubmitConfirmed()
      return
    }
    const subName = ($('subjectId').selectedOptions[0] || {}).textContent || ''
    const pagePart = (payload.pageFrom || payload.pageTo)
      ? (' · p.' + (payload.pageFrom || '?') + (payload.pageTo && payload.pageTo !== payload.pageFrom ? ('-' + payload.pageTo) : ''))
      : ''
    const kids = (payload.knowledgeIds || []).slice(0, 2).map((id) => {
      const k = (state.knowledge || []).find((x) => Number(x.knowledgeId) === Number(id))
      return k ? (k.knowledgeName || id) : id
    }).filter(Boolean)
    const themePart = kids.length ? (' · ' + kids.join('、') + ((payload.knowledgeIds || []).length > 2 ? '…' : '')) : ''
    $('confirmDlgText').textContent =
      ('代提：' + state.proxyStudentName + ' · ') +
      subName + ' · ' + payload.bookName + pagePart +
      ' · 题号 ' + payload.questionText + themePart +
      ' · ' + finishLabel(payload.finishStatus) +
      '（确认后对方按 50% 得积分）'
    $('confirmDlg').hidden = false
    setTimeout(() => { if ($('btnConfirmOk')) $('btnConfirmOk').focus() }, 50)
  }

  function clearSuccessTimer() {
    if (state.successTimer) {
      clearInterval(state.successTimer)
      state.successTimer = null
    }
  }

  async function showSuccess(payload, proxy, offline, awardedPoints) {
    const text = offline
      ? ('已暂存本地' + (proxy ? '（代提）' : '') + '，联网后自动同步，可放心离开')
      : (proxy
        ? ('已代提 ' + (state.proxyStudentName || '组员') + '，待其明日确认')
        : ('已登记：' + (payload.bookName || '') + ' · 题号 ' + (payload.questionText || '')))
    if ($('successText')) $('successText').textContent = text
    const pts = Number(awardedPoints) || 0
    if ($('successPoints')) {
      if (!offline && !proxy && pts > 0) {
        $('successPoints').hidden = false
        $('successPoints').textContent = '积分 +' + pts
      } else if (!offline && proxy) {
        $('successPoints').hidden = false
        $('successPoints').textContent = '代提积分待对方确认后发放'
      } else {
        $('successPoints').hidden = true
      }
    }
    if ($('successLevelUp')) $('successLevelUp').hidden = true
    if (!offline && !proxy && pts > 0) {
      try {
        const before = state.prevLevelNo
        const mineRes = await api('GET', '/spas/practice/points/mine')
        state.points = mineRes.data || {}
        const lv = (state.points.account && state.points.account.levelNo) || 1
        if (before != null && lv > before) {
          state.leveledUpTo = lv
          if ($('successLevelUp')) {
            $('successLevelUp').hidden = false
            $('successLevelUp').textContent = '升级到 Lv.' + lv + '！'
          }
        }
        state.prevLevelNo = lv
        renderLevelBar(state.points)
      } catch (e) { /* ignore */ }
    }
    let left = SUCCESS_EXIT_SEC
    if ($('successCountdown')) $('successCountdown').textContent = String(left)
    show('viewSuccess')
    clearSuccessTimer()
    if (proxy) {
      // 代提后默认留在机边继续，不自动退出
      if ($('successCountdown')) $('successCountdown').parentElement.hidden = true
      return
    }
    if ($('successCountdown') && $('successCountdown').parentElement) {
      $('successCountdown').parentElement.hidden = false
    }
    state.successTimer = setInterval(() => {
      left -= 1
      if ($('successCountdown')) $('successCountdown').textContent = String(Math.max(0, left))
      if (left <= 0) {
        clearSuccessTimer()
        logout(true)
        toast('已退出，下一位请登录', 'ok')
      }
    }, 1000)
  }

  async function doSubmitConfirmed() {
    if (state.busy) return
    $('confirmDlg').hidden = true
    const item = state.pendingPayload
    state.pendingPayload = null
    if (!item) return
    const { payload, proxy, path } = item
    const proxyName = state.proxyStudentName
    if ($('btnSubmit')) $('btnSubmit').disabled = true

    if (!state.online) {
      enqueue({ path, payload, proxy })
      if (!proxy) saveTemplate(payload)
      state.proxyStudentId = null
      updateQueueBadge()
      await showSuccess(payload, proxy, true, 0)
      return
    }
    try {
      setLoading(true, '提交中…')
      const res = await api('POST', path, payload)
      const awarded = res && res.awardedPoints != null ? Number(res.awardedPoints) : 0
      state.lastAwardedPoints = awarded
      if (!proxy) saveTemplate(payload)
      state.proxyStudentId = null
      state.proxyStudentName = proxyName
      await showSuccess(payload, proxy, false, awarded)
      state.proxyStudentName = ''
      if (awarded > 0) toast('积分 +' + awarded, 'ok')
    } catch (e) {
      if (!navigator.onLine || /Failed to fetch|NetworkError|network|超时/i.test(e.message || '')) {
        enqueue({ path, payload, proxy })
        if (!proxy) saveTemplate(payload)
        state.proxyStudentId = null
        updateQueueBadge()
        await showSuccess(payload, proxy, true, 0)
        return
      }
      $('formErr').textContent = e.message || '提交失败'
      toast(e.message || '提交失败', 'err')
      show('viewPractice')
      updatePracticeSteps()
    } finally {
      setLoading(false)
      if ($('viewPractice') && !$('viewPractice').hidden) updatePracticeSteps()
    }
  }

  function enqueue(item) {
    const q = loadQueue()
    q.push(Object.assign({
      id: Date.now() + '_' + Math.random().toString(36).slice(2, 7),
      ts: Date.now(),
      retries: 0
    }, item))
    saveQueue(q)
    logClient('queue enqueue size=' + q.length)
  }

  async function flushQueue() {
    if (!state.token || !navigator.onLine) return
    let q = loadQueue()
    if (!q.length) return
    const remain = []
    let ok = 0
    let awardedSum = 0
    for (const item of q) {
      try {
        const res = await api('POST', item.path, item.payload)
        ok++
        if (res && res.awardedPoints) awardedSum += Number(res.awardedPoints) || 0
      } catch (e) {
        item.retries = (item.retries || 0) + 1
        if (item.retries < 8) remain.push(item)
        else logClient('queue drop after retries id=' + item.id)
      }
    }
    saveQueue(remain)
    updateQueueBadge()
    if (ok) {
      const ptsTip = awardedSum > 0 ? ('，积分 +' + awardedSum) : ''
      toast('已同步离线记录 ' + ok + ' 条' + ptsTip, 'ok')
      if ($('viewSuccess') && !$('viewSuccess').hidden) {
        if ($('successText')) {
          $('successText').textContent = '离线记录已同步' + (awardedSum > 0 ? ('，积分 +' + awardedSum) : '')
        }
        if ($('successPoints')) {
          if (awardedSum > 0) {
            $('successPoints').hidden = false
            $('successPoints').textContent = '积分 +' + awardedSum
          }
        }
      }
      try {
        if ($('viewHome') && !$('viewHome').hidden) await loadHome()
        else await loadPointsHome()
      } catch (e) { /* ignore */ }
    }
  }

  function openCheckoutFlow() {
    const co = state.checkout || {}
    const pending = co.pendingAck || []
    if (pending.length) {
      openAckView()
      return
    }
    if (co.leader && co.assignment) {
      openCheckout()
      return
    }
    toast(co.assignment ? '请等待组长在座位检查后上机登记' : '今日教师尚未布置', 'warn')
  }

  function openAckView() {
    const item = ((state.checkout && state.checkout.pendingAck) || [])[0]
    if (!item) {
      toast('没有待确认记录', 'warn')
      return
    }
    state.ackItem = item
    const asg = (state.checkout && state.checkout.assignment) || {}
    if ($('ackAssign')) {
      $('ackAssign').textContent = [asg.bookName, asg.pageFrom != null ? (asg.pageFrom + '–' + (asg.pageTo || '')) : '', asg.questionText]
        .filter(Boolean).join(' · ') || '今日布置'
    }
    if ($('ackFinish')) $('ackFinish').textContent = finishLabel(item.finishStatus)
    if ($('ackNote')) $('ackNote').textContent = item.difficultyNote ? ('卡点：' + item.difficultyNote) : '无卡点说明'
    if ($('ackErr')) $('ackErr').textContent = ''
    show('viewAck')
  }

  async function submitAck(accept) {
    const item = state.ackItem
    if (!item) return
    setLoading(true, accept ? '确认属实…' : '提交异议…')
    try {
      const res = await api('PUT', '/spas/practice/checkout/item/' + item.itemId + '/ack', { accept: !!accept })
      const pts = Number(res.awardedPoints) || 0
      toast(accept ? ('已确认属实' + (pts > 0 ? ('，积分 +' + pts) : '')) : '已提出异议，等待老师抽检', 'ok')
      await loadHome()
      const still = (state.checkout && state.checkout.pendingAck) || []
      if (still.length) openAckView()
      else show('viewHome')
    } catch (e) {
      if ($('ackErr')) $('ackErr').textContent = e.message || '确认失败'
      toast(e.message || '确认失败', 'err')
    } finally {
      setLoading(false)
    }
  }

  function openCheckout() {
    const co = state.checkout || {}
    const asg = co.assignment
    if (!asg) {
      toast('今日尚未布置', 'warn')
      return
    }
    state.checkoutDraft = {}
    ;(co.members || []).forEach((m) => {
      state.checkoutDraft[m.studentId] = {
        finishStatus: m.finishStatus || '',
        difficultyNote: m.difficultyNote || ''
      }
    })
    if ($('checkoutAssign')) {
      $('checkoutAssign').textContent = (asg.bookName || '') + '  p.' + (asg.pageFrom || '?') + '-' + (asg.pageTo || '?') + '  /  ' + (asg.questionText || '')
    }
    if ($('checkoutDef')) {
      $('checkoutDef').textContent = '检查已在座位上完成，这里只登记。' +
        (asg.completeDefinition || '指定页有书写且抽问能开口说思路，才能点已完成。')
    }
    if ($('checkoutErr')) $('checkoutErr').textContent = ''
    renderCheckoutMembers()
    show('viewCheckout')
  }

  function renderCheckoutMembers() {
    const box = $('checkoutMembers')
    if (!box) return
    const members = (state.checkout && state.checkout.members) || []
    const statuses = [
      ['1', '已完成'], ['2', '部分'], ['0', '未做'], ['3', '有困难'], ['L', '请假'], ['A', '未到/没本']
    ]
    box.innerHTML = members.map((m) => {
      const d = state.checkoutDraft[m.studentId] || {}
      const picks = statuses.map((s) =>
        '<button type="button" data-stu="' + m.studentId + '" data-st="' + s[0] + '" class="' + (d.finishStatus === s[0] ? 'on' : '') + '">' + s[1] + '</button>'
      ).join('')
      const note = d.finishStatus === '3'
        ? ('<input class="input checkout-note kb-field" data-kb="full" data-note="' + m.studentId + '" placeholder="卡点（必填）" value="' + escapeHtml(d.difficultyNote || '') + '" />')
        : ''
      return '<div class="checkout-row"><div class="name">' + escapeHtml(m.studentName || '') +
        (m.roleInGroup === '1' ? '（组长，线下勿自检已完成）' : '') + '</div><div class="st-picks">' + picks + '</div>' + note + '</div>'
    }).join('')
  }

  async function submitCheckoutSheet() {
    const co = state.checkout || {}
    if (!co.assignment) return
    const members = co.members || []
    const items = []
    for (let i = 0; i < members.length; i++) {
      const m = members[i]
      const d = state.checkoutDraft[m.studentId] || {}
      if (!d.finishStatus) {
        if ($('checkoutErr')) $('checkoutErr').textContent = '请为全员选择状态：' + (m.studentName || '')
        return
      }
      if (d.finishStatus === '3' && !(d.difficultyNote || '').trim()) {
        if ($('checkoutErr')) $('checkoutErr').textContent = '有困难必须填卡点：' + (m.studentName || '')
        return
      }
      items.push({ studentId: m.studentId, finishStatus: d.finishStatus, difficultyNote: d.difficultyNote || '' })
    }
    setLoading(true, '提交检查单…')
    try {
      const res = await api('POST', '/spas/practice/checkout', {
        assignmentId: co.assignment.assignmentId,
        deviceCode: (state.config && state.config.deviceCode) || '',
        items: items
      })
      const pts = Number(res.awardedPoints) || 0
      toast('检查单已提交，请组员当日确认' + (pts > 0 ? (' · 积分 +' + pts) : ''), 'ok')
      await loadHome()
      show('viewHome')
    } catch (e) {
      if ($('checkoutErr')) $('checkoutErr').textContent = e.message || '提交失败'
      toast(e.message || '提交失败', 'err')
    } finally {
      setLoading(false)
    }
  }

  function openProxyPick() {
    const progress = (state.today && state.today.groupProgress) || []
    const open = progress.filter((m) => !m.submitted)
    $('memberPick').innerHTML = progress.length
      ? progress.map((m) =>
        '<button type="button" class="pick' + (m.submitted ? ' disabled' : '') + '"' +
        (m.submitted ? ' disabled' : '') +
        ' data-id="' + m.studentId + '" data-name="' + escapeHtml(m.studentName) + '">' +
        escapeHtml(m.studentName) + (m.submitted ? '（已交）' : '（未交）') + '</button>'
      ).join('')
      : emptyHtml('暂无组员')
    if (progress.length && !open.length) toast('组员均已提交', 'ok')
    show('viewProxyPick')
  }

  function logout(silent) {
    state.token = ''
    state.profile = null
    state.dashOpen = false
    state.lastTemplate = null
    state.points = null
    state.ledger = []
    state.prevLevelNo = null
    state.leveledUpTo = null
    state.lastAwardedPoints = 0
    state.boardRange = 'week'
    state.today = null
    state.weak = []
    state.recentLogs = []
    state.proxyStudentId = null
    state.proxyStudentName = ''
    state.pendingPayload = null
    state.rejectLogId = null
    clearSuccessTimer()
    localStorage.removeItem('spas_desktop_token')
    clearTimeout(state.idleTimer)
    clearTimeout(state.idleWarnTimer)
    $('idleBanner').hidden = true
    $('loginPin').value = ''
    $('loginPwd').value = ''
    if ($('successPoints')) $('successPoints').hidden = true
    if ($('successLevelUp')) $('successLevelUp').hidden = true
    updatePinDots()
    show('viewLogin')
    renderRecentUsers()
    updateQueueBadge()
    syncLoginMode()
    if (!silent) toast('已退出登录', 'warn')
  }

  function hideIdleBanner() {
    $('idleBanner').hidden = true
    clearTimeout(state.idleWarnTimer)
  }

  function touchIdle() {
    clearTimeout(state.idleTimer)
    clearTimeout(state.idleWarnTimer)
    hideIdleBanner()
    if (!state.token) return
    const total = idleMs()
    const warnAt = Math.max(total - IDLE_WARN_MS, 1000)
    state.idleWarnTimer = setTimeout(() => {
      $('idleText').textContent = '约 1 分钟后将因长时间未操作退出登录'
      $('idleBanner').hidden = false
    }, warnAt)
    state.idleTimer = setTimeout(() => {
      logClient('idle logout')
      logout(false)
    }, total)
  }

  function fillKbKeys(box, mode, onKey) {
    if (!box) return
    const num = mode === 'num'
    const keys = num
      ? '1234567890'.split('')
      : '1234567890QWERTYUIOPASDFGHJKLZXCVBNM'.split('')
    box.className = 'soft-kb' + (num ? ' num' : '')
    box.innerHTML = keys.map((k) => '<button type="button" data-k="' + k + '">' + k + '</button>').join('')
      + '<button type="button" class="wide" data-k="BACK">删</button>'
      + '<button type="button" class="wide" data-k="CLR">清空</button>'
      + (num ? '' : '<button type="button" class="wide" data-k="SPC">空格</button>')
    box.onclick = (e) => {
      const b = e.target.closest('button')
      if (!b) return
      onKey(b.dataset.k)
      touchIdle()
    }
  }

  function applyKbKey(k) {
    if (!state.kbTarget) return
    const el = state.kbTarget
    const max = el.id === 'loginPin' ? 6 : (Number(el.getAttribute('maxlength')) || 0)
    if (k === 'BACK') el.value = el.value.slice(0, -1)
    else if (k === 'CLR') el.value = ''
    else if (k === 'SPC') el.value += ' '
    else {
      if (max && el.value.length >= max) return
      el.value += k
    }
    el.dispatchEvent(new Event('input', { bubbles: true }))
    if (el.id === 'loginPin') {
      updatePinDots()
      if (el.value.length >= 6 && state.pinAutoLogin) login()
    }
    try { el.focus({ preventScroll: true }) } catch (e) { el.focus() }
  }

  function buildSoftKb(mode) {
    fillKbKeys($('softKb'), mode, applyKbKey)
  }

  function showDockKb(el) {
    if (!el || !el.classList || !el.classList.contains('kb-field')) return
    state.kbTarget = el
    const mode = el.dataset.kb === 'num' ? 'num' : 'full'
    const dock = $('dockKb')
    const keys = $('dockKbKeys')
    if (!dock || !keys) return
    fillKbKeys(keys, mode, applyKbKey)
    if ($('dockKbLabel')) {
      $('dockKbLabel').textContent = (el.labels && el.labels[0] ? el.labels[0].textContent : el.placeholder) || '软键盘'
    }
    dock.hidden = false
    document.body.classList.add('has-dock-kb')
  }

  function hideDockKb() {
    const dock = $('dockKb')
    if (dock) dock.hidden = true
    document.body.classList.remove('has-dock-kb')
  }

  function getPracticeReadiness() {
    const hasTheme = selectedKnowledgeIds().length > 0
    const hasBook = !!($('bookName').value || '').trim()
    const hasQ = !!($('questionText').value || '').trim()
    const finish = (document.querySelector('input[name="finish"]:checked') || {}).value
    const hasFinish = !!finish && (finish !== '3' || !!($('difficultyNote').value || '').trim())
    const miss = []
    if (!hasTheme) miss.push('主题')
    if (!hasBook) miss.push('书名')
    if (!hasQ) miss.push('题号')
    if (!hasFinish) miss.push(finish === '3' ? '卡点说明' : '完成情况')
    return {
      hasTheme,
      hasBook,
      hasQ,
      hasFinish,
      ready: miss.length === 0,
      miss
    }
  }

  function updatePracticeSteps() {
    const steps = document.querySelectorAll('#viewPractice .step')
    const r = getPracticeReadiness()
    if (steps.length) {
      ;[r.hasTheme, r.hasBook && r.hasQ, r.hasFinish].forEach((on, i) => {
        if (steps[i]) steps[i].classList.toggle('on', on)
      })
    }
    const bar = $('readyBar')
    const text = $('readyText')
    const btn = $('btnSubmit')
    if (bar) {
      bar.classList.toggle('ok', r.ready)
      bar.classList.toggle('warn', !r.ready)
    }
    if (text) {
      text.textContent = r.ready
        ? '可以提交了，点右侧按钮即可'
        : ('还差：' + r.miss.join('、'))
    }
    document.querySelectorAll('#readyDots i').forEach((dot) => {
      const map = { theme: r.hasTheme, book: r.hasBook, q: r.hasQ, finish: r.hasFinish }
      dot.classList.toggle('on', !!map[dot.dataset.k])
    })
    if (btn && !state.busy) {
      btn.disabled = !r.ready
      btn.textContent = r.ready ? '提交打卡' : ('还差：' + r.miss.join('、'))
    }
  }

  function applyPageQuick(action) {
    const from = $('pageFrom')
    const to = $('pageTo')
    if (!from || !to) return
    if (action === 'clear') {
      from.value = ''
      to.value = ''
    } else if (action === 'same') {
      const v = from.value || to.value
      if (!v) { toast('请先填起始页', 'warn'); return }
      from.value = v
      to.value = v
    } else if (action === 'next') {
      const base = Number(to.value || from.value || 0)
      if (!base) { toast('请先填页码', 'warn'); return }
      from.value = String(base + 1)
      to.value = String(base + 1)
    }
    updatePracticeSteps()
  }

  function parseQuickLine(raw) {
    const s = String(raw || '').trim()
    if (!s) return false
    // 32-35 / 1,2,5  |  32~35 1、2、5  |  32/1,2,5  |  p32-35：1,2
    let m = s.match(/^[pP]?(\d+)\s*[-~—到至]\s*(\d+)\s*[\/：:\s]+\s*(.+)$/)
    if (m) {
      $('pageFrom').value = m[1]
      $('pageTo').value = m[2]
      $('questionText').value = m[3].replace(/[、，\s]+/g, ',').replace(/^,|,$/g, '')
      return true
    }
    m = s.match(/^[pP]?(\d+)\s*[\/：:\s]+\s*(.+)$/)
    if (m) {
      $('pageFrom').value = m[1]
      $('pageTo').value = m[1]
      $('questionText').value = m[2].replace(/[、，\s]+/g, ',').replace(/^,|,$/g, '')
      return true
    }
    // 仅题号
    if (/^[\d,\s，、]+$/.test(s)) {
      $('questionText').value = s.replace(/[、，\s]+/g, ',').replace(/^,|,$/g, '')
      return true
    }
    return false
  }

  function goHome() {
    loadHome().then(() => show('viewHome')).catch(() => show('viewHome'))
  }

  function openSettings() {
    openSetup(state.token ? 'viewHome' : 'viewLogin')
  }

  function onConfirmClick(e) {
    const ok = e.target.closest('[data-confirm]')
    const no = e.target.closest('[data-reject]')
    if (ok) handleConfirm(Number(ok.dataset.confirm), true)
    if (no) handleConfirm(Number(no.dataset.reject), false)
  }

  function onEmptyCta(e) {
    const btn = e.target.closest('[data-empty-cta]')
    if (!btn) return
    if (btn.dataset.emptyCta === 'practice') openPracticeSmart(false)
  }

  function bind() {
    $('btnLogin').onclick = login
    $('captchaImg').onclick = refreshCaptcha
    const seg = $('loginModeSeg')
    if (seg) {
      seg.onclick = (e) => {
        const btn = e.target.closest('.seg-item')
        if (!btn) return
        setLoginMode(btn.dataset.mode)
      }
    }
    if ($('navLogout')) $('navLogout').onclick = () => logout(false)
    if ($('navHome')) $('navHome').onclick = goHome
    if ($('navPractice')) $('navPractice').onclick = () => openPracticeSmart(false)
    if ($('navQuickAdd')) $('navQuickAdd').onclick = () => openPracticeSmart(false)
    if ($('btnAsidePractice')) $('btnAsidePractice').onclick = () => openPracticeSmart(false)
    if ($('navHistory')) $('navHistory').onclick = loadHistory
    if ($('navProxy')) $('navProxy').onclick = openProxyPick
    if ($('navSettings')) $('navSettings').onclick = openSettings
    if ($('btnHeadSettings')) $('btnHeadSettings').onclick = openSettings
    if ($('btnHistoryHome')) $('btnHistoryHome').onclick = goHome
    if ($('btnSetupBack')) {
      $('btnSetupBack').onclick = () => show(state.setupReturn || (state.token ? 'viewHome' : 'viewLogin'))
    }
    if ($('btnToggleDash')) {
      $('btnToggleDash').onclick = () => setDashOpen(!state.dashOpen)
    }
    if ($('homeTabs')) {
      $('homeTabs').onclick = (e) => {
        const tab = e.target.closest('.tab')
        if (!tab) return
        switchHomeTab(tab.dataset.tab)
      }
    }
    if ($('featureCard')) $('featureCard').onclick = () => openPracticeSmart(false)
    if ($('btnRefreshHome')) {
      $('btnRefreshHome').onclick = async () => {
        setLoading(true, '刷新中…')
        try { await loadHome(); toast('已刷新', 'ok') }
        catch (e) { toast(e.message || '刷新失败', 'err') }
        finally { setLoading(false) }
      }
    }
    if ($('btnHomeHistory')) $('btnHomeHistory').onclick = () => loadHistory()
    if ($('btnTodayExpand')) {
      $('btnTodayExpand').onclick = () => { setDashOpen(true); switchHomeTab('done') }
    }
    if ($('btnWeakPractice')) {
      $('btnWeakPractice').onclick = () => {
        const first = state.weak && state.weak[0]
        openPractice(false, first ? { knowledgeIds: [Number(first.knowledgeId)] } : {})
      }
    }
    if ($('btnHomeProxy')) $('btnHomeProxy').onclick = openProxyPick
    if ($('homeAlerts')) {
      $('homeAlerts').onclick = async (e) => {
        const btn = e.target.closest('[data-home-alert]')
        if (!btn) return
        const act = btn.dataset.homeAlert
        if (act === 'practice') openPracticeSmart(false)
        else if (act === 'proxy') openProxyPick()
        else if (act === 'confirm' && $('homeConfirmMod')) {
          $('homeConfirmMod').scrollIntoView({ behavior: 'smooth', block: 'center' })
        } else if (act === 'flush') {
          setLoading(true, '同步中…')
          try { await flushQueue(); await loadHome() }
          finally { setLoading(false) }
        }
      }
    }
    if ($('homeWeakList')) {
      $('homeWeakList').onclick = (e) => {
        const chip = e.target.closest('[data-kid]')
        if (!chip) return
        openPractice(false, { knowledgeIds: [Number(chip.dataset.kid)] })
      }
    }
    if ($('homeGroupMiss')) {
      $('homeGroupMiss').onclick = (e) => {
        const chip = e.target.closest('[data-proxy-id]')
        if (!chip || chip.disabled) return
        state.proxyStudentId = Number(chip.dataset.proxyId)
        state.proxyStudentName = chip.dataset.proxyName || ''
        openPractice(true)
      }
    }
    if ($('statDoneCard')) $('statDoneCard').onclick = () => { setDashOpen(true); switchHomeTab('done') }
    if ($('statConfirmCard')) {
      $('statConfirmCard').onclick = () => {
        if ($('homeConfirmMod') && !$('homeConfirmMod').hidden) {
          $('homeConfirmMod').scrollIntoView({ behavior: 'smooth', block: 'center' })
        } else {
          setDashOpen(true)
          switchHomeTab('todo')
        }
      }
    }
    if ($('weekBars')) {
      $('weekBars').onclick = () => { if (state.token) loadHistory() }
    }
    if ($('weakList')) {
      $('weakList').onclick = (e) => {
        onEmptyCta(e)
        const chip = e.target.closest('[data-kid]')
        if (!chip) return
        openPractice(false, { knowledgeIds: [Number(chip.dataset.kid)] })
      }
    }
    if ($('todayList')) $('todayList').onclick = onEmptyCta
    if ($('historyList')) $('historyList').onclick = onEmptyCta
    if ($('practiceSteps')) {
      $('practiceSteps').onclick = (e) => {
        const step = e.target.closest('[data-jump]')
        if (!step) return
        scrollToField(step.dataset.jump)
      }
    }
    $('btnFlushQueue').onclick = async () => {
      setLoading(true, '同步中…')
      try {
        await flushQueue()
        await loadHome()
      } finally {
        setLoading(false)
      }
    }
    $('btnGoPractice').onclick = () => openCheckoutFlow()
    if ($('btnGoPractice2')) $('btnGoPractice2').onclick = () => openCheckoutFlow()
    if ($('btnGoExtra')) $('btnGoExtra').onclick = () => openPracticeSmart(false)
    if ($('btnCheckoutHome')) $('btnCheckoutHome').onclick = () => show('viewHome')
    if ($('btnCheckoutCancel')) $('btnCheckoutCancel').onclick = () => show('viewHome')
    if ($('btnCheckoutSubmit')) $('btnCheckoutSubmit').onclick = submitCheckoutSheet
    if ($('btnAckHome')) $('btnAckHome').onclick = () => show('viewHome')
    if ($('btnAckYes')) $('btnAckYes').onclick = () => submitAck(true)
    if ($('btnAckNo')) $('btnAckNo').onclick = () => submitAck(false)
    if ($('checkoutMembers')) {
      $('checkoutMembers').onclick = (e) => {
        const btn = e.target.closest('[data-st]')
        if (!btn) return
        const sid = Number(btn.dataset.stu)
        if (!state.checkoutDraft[sid]) state.checkoutDraft[sid] = {}
        state.checkoutDraft[sid].finishStatus = btn.dataset.st
        renderCheckoutMembers()
      }
      $('checkoutMembers').addEventListener('input', (e) => {
        const inp = e.target.closest('[data-note]')
        if (!inp) return
        const sid = Number(inp.dataset.note)
        if (!state.checkoutDraft[sid]) state.checkoutDraft[sid] = {}
        state.checkoutDraft[sid].difficultyNote = inp.value
      })
    }
    $('btnGoProxy').onclick = openProxyPick
    if ($('btnGoProxy2')) $('btnGoProxy2').onclick = openProxyPick
    if ($('btnReuseLast')) $('btnReuseLast').onclick = () => openPractice(false, { reuse: true })
    if ($('btnReuseInForm')) $('btnReuseInForm').onclick = () => openPractice(!!state.proxyStudentId, { reuse: true })
    if ($('pageQuick')) {
      $('pageQuick').onclick = (e) => {
        const btn = e.target.closest('[data-page]')
        if (!btn) return
        applyPageQuick(btn.dataset.page)
      }
    }
    if ($('quickLine')) {
      $('quickLine').addEventListener('keydown', (e) => {
        if (e.key !== 'Enter') return
        e.preventDefault()
        if (parseQuickLine($('quickLine').value)) {
          renderQuestionChips()
          updatePracticeSteps()
          toast('已填入页码与题号', 'ok')
          scrollToField('finish')
        } else {
          toast('格式如：32-35 / 1,2,5', 'warn')
        }
      })
      $('quickLine').addEventListener('blur', () => {
        const v = ($('quickLine').value || '').trim()
        if (!v) return
        if (parseQuickLine(v)) {
          renderQuestionChips()
          updatePracticeSteps()
        }
      })
    }
    if ($('btnSuccessStay')) {
      $('btnSuccessStay').onclick = async () => {
        clearSuccessTimer()
        try { await loadHome() } catch (e) { try { await loadPointsHome() } catch (e2) { /* ignore */ } }
        openPracticeSmart(false)
      }
    }
    if ($('btnSuccessExit')) {
      $('btnSuccessExit').onclick = () => {
        clearSuccessTimer()
        logout(true)
        toast('已退出，下一位请登录', 'ok')
      }
    }
    if ($('btnToggleMoreKnow')) {
      $('btnToggleMoreKnow').onclick = () => {
        const wrap = $('moreKnowWrap')
        wrap.hidden = !wrap.hidden
        $('btnToggleMoreKnow').textContent = wrap.hidden ? '选择其他主题' : '收起其他主题'
      }
    }
    if ($('weakQuick')) {
      $('weakQuick').onclick = (e) => {
        const btn = e.target.closest('.pick[data-kid]')
        if (!btn) return
        const kid = Number(btn.dataset.kid)
        const on = !btn.classList.contains('on')
        btn.classList.toggle('on', on)
        syncKnowledgeFromQuick(kid, on)
        renderWeakQuick(selectedKnowledgeIds())
      }
    }
    if ($('bookPicks')) {
      $('bookPicks').onclick = (e) => {
        const chip = e.target.closest('[data-book]')
        if (!chip) return
        $('bookName').value = chip.dataset.book || ''
        syncBookPickActive()
        updatePracticeSteps()
        scrollToField('pageFrom')
      }
    }
    if ($('qChips')) {
      $('qChips').onclick = (e) => {
        const chip = e.target.closest('[data-q]')
        if (!chip) return
        toggleQuestionChip(chip.dataset.q)
      }
    }
    if ($('recentUsers')) {
      $('recentUsers').onclick = (e) => {
        const chip = e.target.closest('[data-uno]')
        if (!chip) return
        $('loginUser').value = chip.dataset.uno || ''
        state.kbTarget = $('loginPin')
        updatePinDots()
        if ($('softKb')) $('softKb').hidden = false
        try { $('loginPin').focus() } catch (err) { /* ignore */ }
      }
    }
    $('btnBackHome').onclick = goHome
    $('btnBackHome2').onclick = goHome
    $('btnSettingsLogin').onclick = () => openSetup('viewLogin')
    $('btnSaveSetup').onclick = saveSetup
    $('btnTestApi').onclick = testApi
    $('btnOpenLog').onclick = () => {
      if (state.config.logDir && window.spasDesktop) window.spasDesktop.openPath(state.config.logDir)
    }
    $('btnIdleKeep').onclick = () => touchIdle()
    $('btnSubmit').onclick = askSubmitConfirm
    $('btnConfirmCancel').onclick = () => { $('confirmDlg').hidden = true; state.pendingPayload = null }
    $('btnConfirmOk').onclick = doSubmitConfirmed
    $('confirmDlg').addEventListener('click', (e) => {
      if (e.target === $('confirmDlg')) {
        $('confirmDlg').hidden = true
        state.pendingPayload = null
      }
    })
    if ($('btnRejectCancel')) {
      $('btnRejectCancel').onclick = () => {
        $('rejectDlg').hidden = true
        state.rejectLogId = null
      }
    }
    if ($('btnRejectOk')) {
      $('btnRejectOk').onclick = async () => {
        const id = state.rejectLogId
        $('rejectDlg').hidden = true
        state.rejectLogId = null
        if (id) await doConfirmProxy(id, false)
      }
    }
    if ($('rejectDlg')) {
      $('rejectDlg').addEventListener('click', (e) => {
        if (e.target === $('rejectDlg')) {
          $('rejectDlg').hidden = true
          state.rejectLogId = null
        }
      })
    }
    if ($('metaDone')) {
      $('metaDone').onclick = () => {
        if ($('homeTodayMod') && !$('homeTodayMod').hidden) {
          $('homeTodayMod').scrollIntoView({ behavior: 'smooth', block: 'center' })
        } else {
          setDashOpen(true)
          switchHomeTab('done')
        }
      }
    }
    if ($('metaConfirm')) {
      $('metaConfirm').onclick = () => {
        const pending = (state.checkout && state.checkout.pendingAck) || []
        if (pending.length) {
          openAckView()
          return
        }
        if ($('homeConfirmMod') && !$('homeConfirmMod').hidden) {
          $('homeConfirmMod').scrollIntoView({ behavior: 'smooth', block: 'center' })
        } else {
          setDashOpen(true)
          switchHomeTab('todo')
        }
      }
    }
    if ($('metaMiss')) {
      $('metaMiss').onclick = () => {
        if ($('homeGroupMod') && !$('homeGroupMod').hidden) {
          $('homeGroupMod').scrollIntoView({ behavior: 'smooth', block: 'center' })
        } else if (state.today && state.today.leader) {
          openProxyPick()
        } else {
          toast('暂无分组未交信息', 'warn')
        }
      }
    }
    document.addEventListener('keydown', (e) => {
      if (e.key !== 'Escape') return
      if ($('confirmDlg') && !$('confirmDlg').hidden) {
        $('confirmDlg').hidden = true
        state.pendingPayload = null
      }
      if ($('rejectDlg') && !$('rejectDlg').hidden) {
        $('rejectDlg').hidden = true
        state.rejectLogId = null
      }
    })
    $('subjectId').onchange = () => onSubjectChange(false)
    $('btnToggleKb').onclick = () => {
      const kb = $('softKb')
      kb.hidden = !kb.hidden
      $('btnToggleKb').textContent = kb.hidden ? '显示软键盘' : '隐藏软键盘'
    }
    if ($('btnDockKbHide')) $('btnDockKbHide').onclick = hideDockKb
    buildSoftKb('num')
    ;['loginUser', 'loginPin', 'loginPwd', 'loginCode'].forEach((id) => {
      $(id).addEventListener('focus', () => { state.kbTarget = $(id) })
      $(id).addEventListener('keydown', (e) => {
        if (e.key !== 'Enter') return
        if (id === 'loginUser' && loginMode() === 'pin') {
          e.preventDefault()
          state.kbTarget = $('loginPin')
          try { $('loginPin').focus() } catch (err) { /* ignore */ }
          return
        }
        login()
      })
    })
    ;['pageFrom', 'pageTo'].forEach((id) => {
      if ($(id)) $(id).addEventListener('input', updatePracticeSteps)
    })
    if ($('pinDots')) {
      $('pinDots').onclick = () => {
        state.kbTarget = $('loginPin')
        try { $('loginPin').focus() } catch (e) { /* ignore */ }
        if ($('softKb')) $('softKb').hidden = false
        $('btnToggleKb').textContent = '隐藏软键盘'
      }
    }
    $('loginPin').addEventListener('input', () => {
      $('loginPin').value = ($('loginPin').value || '').replace(/\D/g, '').slice(0, 6)
      updatePinDots()
      if (($('loginPin').value || '').length >= 6 && state.pinAutoLogin) login()
    })
    document.addEventListener('focusin', (e) => {
      const t = e.target
      if (t && t.classList && t.classList.contains('kb-field')) showDockKb(t)
    })
    ;['bookName', 'questionText', 'difficultyNote'].forEach((id) => {
      $(id).addEventListener('input', () => {
        if (id === 'bookName') syncBookPickActive()
        if (id === 'questionText') renderQuestionChips()
        updatePracticeSteps()
      })
    })
    if ($('knowledgeBox')) {
      $('knowledgeBox').addEventListener('change', () => {
        renderWeakQuick(selectedKnowledgeIds())
        updatePracticeSteps()
      })
    }
    document.querySelectorAll('input[name="finish"]').forEach((el) => {
      el.onchange = () => {
        const v = (document.querySelector('input[name="finish"]:checked') || {}).value
        $('diffWrap').hidden = v !== '3'
        updatePracticeSteps()
      }
    })
    $('memberPick').onclick = (e) => {
      const btn = e.target.closest('.pick')
      if (!btn || btn.disabled) return
      state.proxyStudentId = Number(btn.dataset.id)
      state.proxyStudentName = btn.dataset.name
      openPractice(true)
    }
    if ($('confirmList')) $('confirmList').onclick = onConfirmClick
    if ($('centerConfirmList')) $('centerConfirmList').onclick = onConfirmClick
    if ($('homeConfirmList')) $('homeConfirmList').onclick = onConfirmClick
    if ($('btnBoardWeek')) $('btnBoardWeek').onclick = () => loadLeaderboard('week')
    if ($('btnBoardAll')) $('btnBoardAll').onclick = () => loadLeaderboard('all')
    if ($('levelBar')) {
      $('levelBar').onclick = () => {
        if ($('homeBoardMod')) $('homeBoardMod').scrollIntoView({ behavior: 'smooth', block: 'nearest' })
      }
      $('levelBar').style.cursor = 'pointer'
      $('levelBar').title = '查看本班积分榜'
    }
    if ($('pointsRules')) {
      $('pointsRules').addEventListener('click', (e) => e.stopPropagation())
    }
    if ($('asideLevelCard')) {
      $('asideLevelCard').onclick = () => {
        show('viewHome')
        setTimeout(() => {
          if ($('homeBoardMod')) $('homeBoardMod').scrollIntoView({ behavior: 'smooth', block: 'nearest' })
        }, 80)
      }
      $('asideLevelCard').style.cursor = 'pointer'
    }
    ;['click', 'keydown', 'touchstart'].forEach((ev) => {
      document.addEventListener(ev, touchIdle, { passive: true })
    })
    window.addEventListener('online', () => setOnline(true))
    window.addEventListener('offline', () => setOnline(false))
    document.addEventListener('gesturestart', (e) => e.preventDefault())
  }

  function applyLayoutScale() {
    const w = window.innerWidth || 1280
    const h = window.innerHeight || 800
    let layout = 'md'
    if (w >= 1680) layout = 'xl'
    else if (w >= 1400) layout = 'lg'
    else if (w >= 1100) layout = 'md'
    else layout = 'sm'
    document.documentElement.dataset.layout = layout
    document.documentElement.style.setProperty('--app-w', w + 'px')
    document.documentElement.style.setProperty('--app-h', h + 'px')
    // 矮屏压一点键盘高度，避免挡住提交按钮；首页卡片仍铺满中栏
    if (h < 780) {
      document.documentElement.style.setProperty('--kb-key-h', '48px')
    } else {
      document.documentElement.style.removeProperty('--kb-key-h')
    }
  }

  async function boot() {
    bind()
    applyLayoutScale()
    window.addEventListener('resize', () => {
      clearTimeout(applyLayoutScale._t)
      applyLayoutScale._t = setTimeout(applyLayoutScale, 120)
    })
    renderWeekBars([])
    tickClock()
    setInterval(tickClock, 30000)
    if (window.spasDesktop && window.spasDesktop.getConfig) {
      state.config = Object.assign(state.config, await window.spasDesktop.getConfig())
    }
    document.title = state.config.title || document.title
    updateDeviceMeta()
    setOnline(navigator.onLine)
    updateQueueBadge()
    syncLoginMode()

    const lastUser = localStorage.getItem(LAST_USER_KEY)
    if (lastUser) $('loginUser').value = lastUser
    renderRecentUsers()

    if (needsSetup(state.config)) {
      openSetup('viewLogin')
      return
    }

    const cached = localStorage.getItem('spas_desktop_token')
    if (cached) {
      state.token = cached
      try {
        setLoading(true, '恢复会话…')
        await afterLogin()
        return
      } catch (e) {
        logout(true)
      } finally {
        setLoading(false)
      }
    }
    show('viewLogin')
    syncLoginMode()
  }

  boot()
})()
