(() => {
  const QUEUE_KEY = 'spas_desktop_queue'
  const CHECKOUT_DRAFT_LS_KEY = 'spas_desktop_checkout_draft'
  const LAST_USER_KEY = 'spas_desktop_last_user'
  const RECENT_USERS_KEY = 'spas_desktop_recent_users'
  const LAST_TPL_PREFIX = 'spas_desktop_tpl_'
  const FARM_PTS_PREFIX = 'spas_desktop_farm_pts_'
  const FARM_TOUR_KEY = 'spas_desktop_farm_tour_v1'
  const AUDIO_MUTE_KEY = 'spas_desktop_audio_mute'
  /** 成长农场阶段阈值（与后端 SpasStudentPointServiceImpl 保持一致；接口可下发覆盖） */
  const FARM_STAGE = {
    seedling: 15,
    sapling: 50,
    tree: 150,
    labels: { seed: '萌芽', seedling: '浮叶', sapling: '花蕾', tree: '盛放' }
  }
  const API_TIMEOUT_MS = 20000
  const IDLE_WARN_MS = 60 * 1000
  const SUCCESS_EXIT_SEC = 3
  const PROXY_PATHS = ['/proxy', '/spas/practice/proxy']
  const VIEWS = ['viewSetup', 'viewLogin', 'viewHome', 'viewPractice', 'viewCheckout', 'viewAck', 'viewHistory', 'viewFarm', 'viewSuccess', 'viewSupervise']
  const STAFF_ROLES = ['admin', 'spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader', 'spas_school_leader']
  const FX_CYCLE = ['auto', 'full', 'lite', 'off']

  const state = {
    config: {
      apiBase: '', deviceCode: '', title: '知脉 · 每日自主练',
      appVersion: '1.6.0', kiosk: false, autoLaunch: false, idleMinutes: 8,
      farmFxMode: 'auto', audioMute: false
    },
    farmFxResolved: 'full',
    farmZoom: 1,
    farmPanMoved: false,
    farmStageFilter: 'all',
    farmReadOnly: false,
    weakSubjectId: null,
    token: '',
    uuid: '',
    mode: 'student', // student | staff
    roles: [],
    permissions: [],
    user: null,
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
    checkoutDefaultKnow: [],
    checkoutKnowledgeIds: [],
    checkoutWeak: [],
    checkoutKnowAll: [],
    checkoutKnowMoreOpen: false,
    ackItem: null,
    points: null,
    boardRange: 'week',
    farmCache: null, // { list, myId } for resize re-fit
    lastAwardedPoints: 0,
    prevLevelNo: null,
    prevFarmStage: null,
    farmStageUpTo: null,
    ledger: [],
    proxyStudentId: null,
    proxyStudentName: '',
    preselectKnowledgeIds: [],
    draftReuse: null,
    dashOpen: false,
    idleTimer: null,
    idleWarnTimer: null,
    successTimer: null,
    online: navigator.onLine,
    pendingPayload: null,
    dlgResolve: null,
    setupReturn: 'viewLogin',
    busy: false,
    supervise: {
      depts: [],
      deptId: null,
      subjectId: null,
      practiceDate: '',
      tab: 'spot',
      alerts: {},
      spotQueue: [],
      assignment: null
    }
  }

  const $ = (id) => document.getElementById(id)

  function idleMs() {
    const m = Number(state.config.idleMinutes)
    const minutes = (!m || m < 2) ? 8 : Math.min(m, 60)
    return minutes * 60 * 1000
  }

  function isStaffMode() {
    return state.mode === 'staff'
  }

  function hasStaffRole(roles) {
    const list = roles || state.roles || []
    return list.some((r) => STAFF_ROLES.indexOf(r) >= 0)
  }

  function staffRoleLabel(roles) {
    const list = roles || []
    if (list.indexOf('admin') >= 0 || list.indexOf('spas_admin') >= 0) return '管理员'
    if (list.indexOf('spas_jw') >= 0) return '教务'
    if (list.indexOf('spas_bzr') >= 0) return '班主任'
    if (list.indexOf('spas_grade_leader') >= 0) return '年级组长'
    if (list.indexOf('spas_school_leader') >= 0) return '校领导'
    if (list.indexOf('spas_teacher') >= 0) return '教师'
    return '督导'
  }

  /** 侧栏身份：姓名与学号分行，避免被右上角窗口按钮挡住 */
  function setAsideIdentity(name, no, roleText) {
    if ($('userLabel')) $('userLabel').textContent = name || '未登录'
    if ($('asideRole')) $('asideRole').textContent = roleText || ''
    const noEl = $('asideUserNo')
    if (noEl) {
      const id = (no || '').trim()
      if (id) {
        noEl.hidden = false
        noEl.textContent = id
        noEl.title = id
      } else {
        noEl.hidden = true
        noEl.textContent = ''
        noEl.removeAttribute('title')
      }
    }
  }

  function applyModeChrome() {
    const staff = isStaffMode()
    document.body.classList.toggle('mode-staff', staff)
    document.body.classList.toggle('farm-readonly', !!state.farmReadOnly)
    if ($('navHomeLabel')) $('navHomeLabel').textContent = staff ? '督察' : '首页'
    if ($('navHome')) {
      $('navHome').title = staff ? '班级督察' : '首页'
      $('navHome').setAttribute('aria-label', staff ? '督察' : '首页')
    }
    if ($('navFarm')) {
      $('navFarm').title = staff ? '巡班农场（只读）' : '班级农场'
      $('navFarm').hidden = false
    }
  }

  function show(id) {
    VIEWS.forEach((v) => { if ($(v)) $(v).hidden = v !== id })
    const authLike = id === 'viewLogin' || id === 'viewSetup' || id === 'viewSuccess'
    const loggedIn = !!state.token && !authLike
    document.body.classList.toggle('mode-auth', authLike || !state.token)
    document.body.classList.toggle('mode-app', loggedIn)
    if ($('appRail')) $('appRail').hidden = !loggedIn
    const focusForm = id === 'viewPractice' || id === 'viewCheckout' || id === 'viewAck'
    document.body.classList.toggle('focus-form', focusForm && loggedIn)
    const hideAside = !loggedIn || focusForm || isStaffMode() || id === 'viewSupervise'
    if ($('appAside')) $('appAside').hidden = hideAside
    if ($('workspaceHead')) $('workspaceHead').hidden = !loggedIn
    if ($('btnSetupBack')) $('btnSetupBack').hidden = !(id === 'viewSetup' && !!state.token)
    if (id !== 'viewSuccess') clearSuccessTimer()
    if (id !== 'viewFarm' && typeof farmFx !== 'undefined' && farmFx.stop) farmFx.stop()
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

  /** 弱项一键练：预填 top N 薄弱知识点 */
  function openWeakPractice(limit) {
    const n = Math.max(1, Math.min(6, Number(limit) || 3))
    const items = (state.weak || []).slice(0, n)
    const ids = items.map((k) => Number(k.knowledgeId)).filter(Boolean)
    const subjectId = state.weakSubjectId
      || (state.subjects[0] && state.subjects[0].subjectId)
      || null
    if (!ids.length) {
      openPractice(false, subjectId ? { subjectId } : {})
      toast('暂无薄弱建议，已打开加练表', 'info')
      return
    }
    openPractice(false, { knowledgeIds: ids, subjectId: subjectId || undefined })
    toast('已预填薄弱主题 ' + ids.length + ' 项', 'ok')
  }

  /** 统一入口：确认 → 组长结账 → 组员进度 → 无布置时加练 */
  function openTodayFlow(opts) {
    opts = opts || {}
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
    if (co.assignment) {
      // 组员：少进只读中间页，直接回首页看组进度
      show('viewHome')
      setTimeout(() => {
        const el = $('homeGroupMod') || $('groupCard') || $('centerGroupProgress')
        if (el && el.scrollIntoView) el.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
      }, 80)
      toast(co.myItem
        ? '今日检查已登记，可在首页查看进度'
        : '今日已布置，等待组长座位检查后登记', 'info')
      return
    }
    // 组长点「本组登记」且无布置：只提示，不误进加练
    if (opts.leaderOnly) {
      toast('今日教师尚未布置，暂不能帮组员登记；加练请用「加练」入口', 'warn')
      return
    }
    openPracticeSmart(false)
    toast('今日尚未布置，可先加练（不计入组达标）', 'info')
  }

  function setNavActive(id) {
    const map = {
      viewHome: 'home',
      viewSupervise: 'home',
      viewPractice: 'practice',
      viewCheckout: 'checkout',
      viewAck: 'practice',
      viewHistory: 'history',
      viewFarm: 'farm',
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
      viewHome: ['每日自主练', '今日一条路：确认 / 登记检查；加练另算'],
      viewSupervise: ['班级作业督察', '查看全班提交情况，处置异议/超时并抽检'],
      viewPractice: ['加练登记', '加练不计入组达标，与检查登记分开'],
      viewCheckout: ['今日练习 · 登记', '先在座位翻本抽问，这里只点状态；全员有状态才能提交'],
      viewAck: ['今日练习 · 确认', '确认的是组长在座位上看到的结果，不是网上自填'],
      viewHistory: ['近 7 日记录', '回顾检查确认与加练痕迹'],
      viewFarm: ['班级成长农场', '2.5D 田地：一块田一位同学，练习浇灌成长'],
      viewSetup: ['一体机设置', '配置 API 与设备编号'],
      viewSuccess: ['提交成功', '即将退出给下一位']
    }[id] || ['每日自主练', '']
    title.textContent = meta[0]
    sub.textContent = meta[1]
  }

  function qs(params) {
    return Object.keys(params || {}).filter((k) => params[k] != null && params[k] !== '')
      .map((k) => encodeURIComponent(k) + '=' + encodeURIComponent(params[k])).join('&')
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
    const q = loadQueue()
    const n = q.length
    const coN = q.filter(isCheckoutQueueItem).length
    const badge = $('queueBadge')
    const btn = $('btnFlushQueue')
    if (!badge || !btn) return
    badge.hidden = n === 0
    btn.hidden = n === 0 || !state.token
    badge.textContent = coN > 0
      ? ('离线待传 ' + n + '（检查单 ' + coN + '）')
      : ('离线待传 ' + n)
    if ($('queueDlg') && !$('queueDlg').hidden) renderQueueDlg()
  }

  function queueItemLabel(item) {
    if (!item) return '未知项'
    if (isCheckoutQueueItem(item)) {
      return '检查单' + (item.assignmentId != null ? (' #' + item.assignmentId) : '')
    }
    const p = item.payload || {}
    const book = p.bookName || ''
    const q = p.questionText || ''
    if (book || q) return (book || '加练') + (q ? (' · 题 ' + q) : '')
    return item.path || '练习提交'
  }

  function renderQueueDlg() {
    const box = $('queueDlgList')
    if (!box) return
    const q = loadQueue()
    if ($('queueDlgHint')) {
      $('queueDlgHint').textContent = q.length
        ? ('共 ' + q.length + ' 条 · 联网后可同步；单项可重试或丢弃')
        : '当前没有离线待传项'
    }
    if (!q.length) {
      box.innerHTML = '<div class="muted" style="padding:12px 4px">队列为空</div>'
      return
    }
    box.innerHTML = q.map((item) => {
      const when = item.ts ? new Date(item.ts).toLocaleString() : ''
      const retries = item.retries || 0
      return '<div class="queue-item" data-qid="' + escapeHtml(String(item.id)) + '">' +
        '<div class="queue-item-main">' +
          '<b>' + escapeHtml(queueItemLabel(item)) + '</b>' +
          '<span class="muted">' + escapeHtml(when) +
          (retries ? (' · 已重试 ' + retries + ' 次') : '') + '</span>' +
        '</div>' +
        '<div class="queue-item-actions">' +
          '<button type="button" class="btn ghost sm" data-q-act="retry">重试</button>' +
          '<button type="button" class="btn ghost sm dangerish" data-q-act="drop">丢弃</button>' +
        '</div></div>'
    }).join('')
  }

  function openQueueDlg() {
    if ($('queueDlg')) {
      renderQueueDlg()
      $('queueDlg').hidden = false
    }
  }

  function closeQueueDlg() {
    if ($('queueDlg')) $('queueDlg').hidden = true
  }

  function dropQueueItem(id) {
    const q = loadQueue().filter((x) => String(x.id) !== String(id))
    saveQueue(q)
    toast('已丢弃该项', 'warn')
    renderQueueDlg()
  }

  async function retryQueueItem(id) {
    if (!state.token) { toast('请先登录再同步', 'warn'); return }
    if (!navigator.onLine) { toast('当前离线，稍后重试', 'warn'); return }
    const q = loadQueue()
    const item = q.find((x) => String(x.id) === String(id))
    if (!item) return
    try {
      setLoading(true, '重试同步…')
      const body = Object.assign({}, item.payload || {})
      if (item.clientRequestId && !body.clientRequestId) body.clientRequestId = item.clientRequestId
      const res = await api('POST', item.path || '/spas/practice', body)
      saveQueue(q.filter((x) => String(x.id) !== String(id)))
      if (isCheckoutQueueItem(item)) clearCheckoutDraftFromDisk(item.assignmentId)
      const pts = res && res.awardedPoints ? Number(res.awardedPoints) : 0
      toast('已同步' + (pts > 0 ? ('，积分 +' + pts) : ''), 'ok')
      renderQueueDlg()
      try { await loadHome() } catch (e) { /* ignore */ }
    } catch (e) {
      item.retries = (item.retries || 0) + 1
      saveQueue(q)
      toast(e.message || '同步失败', 'err')
      renderQueueDlg()
    } finally {
      setLoading(false)
    }
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
    if ($('cfgFarmFx')) $('cfgFarmFx').value = state.config.farmFxMode || 'auto'
    $('cfgKiosk').checked = !!state.config.kiosk
    $('cfgAutoLaunch').checked = !!state.config.autoLaunch
    if ($('cfgAudioMute')) $('cfgAudioMute').checked = !!state.config.audioMute
    $('setupMeta').textContent = state.config.configPath
      ? ('配置文件：' + state.config.configPath)
      : ''
    $('setupErr').textContent = ''
    const logBtn = $('btnOpenLog')
    if (logBtn) logBtn.hidden = !state.config.logDir
    syncAudioMuteUi()
  }

  function openSetup(returnView) {
    state.setupReturn = returnView || (state.token ? (isStaffMode() ? 'viewSupervise' : 'viewHome') : 'viewLogin')
    fillSetupForm()
    show('viewSetup')
  }

  async function saveSetup() {
    $('setupErr').textContent = ''
    const apiBase = $('cfgApiBase').value.trim().replace(/\/$/, '')
    const deviceCode = $('cfgDeviceCode').value.trim()
    const title = $('cfgTitle').value.trim() || '知脉 · 每日自主练'
    const idleMinutes = Math.max(2, Math.min(60, Number($('cfgIdleMinutes').value) || 8))
    const farmFxModeRaw = ($('cfgFarmFx') && $('cfgFarmFx').value) || 'auto'
    const farmFxMode = ['auto', 'full', 'lite', 'off'].indexOf(farmFxModeRaw) >= 0 ? farmFxModeRaw : 'auto'
    const kiosk = $('cfgKiosk').checked
    const autoLaunch = $('cfgAutoLaunch').checked
    const audioMute = !!( $('cfgAudioMute') && $('cfgAudioMute').checked )
    if (!apiBase) { $('setupErr').textContent = '请填写 API 地址'; return }
    if (!deviceCode) { $('setupErr').textContent = '请填写设备编号'; return }
    try {
      setLoading(true, '保存中…')
      if (window.spasDesktop && window.spasDesktop.saveConfig) {
        state.config = Object.assign(state.config, await window.spasDesktop.saveConfig({
          apiBase, deviceCode, title, kiosk, autoLaunch, idleMinutes, farmFxMode, audioMute
        }))
      } else {
        state.config = Object.assign(state.config, { apiBase, deviceCode, title, kiosk, autoLaunch, idleMinutes, farmFxMode, audioMute })
      }
      try { localStorage.setItem(AUDIO_MUTE_KEY, audioMute ? '1' : '0') } catch (e) { /* ignore */ }
      applyFarmFxMode()
      syncAudioMuteUi()
      updateDeviceMeta()
      syncTitlebarChrome()
      toast('设置已保存', 'ok')
      const back = state.setupReturn
      if (state.token && (back === 'viewHome' || back === 'viewSupervise' || back === 'viewFarm')) show(back)
      else {
        show('viewLogin')
        prepareLoginView()
      }
    } catch (e) {
      $('setupErr').textContent = e.message || '保存失败'
    } finally {
      setLoading(false)
    }
  }

  function isAudioMuted() {
    return !!(state.config && state.config.audioMute)
  }

  function setAudioMute(on, persist) {
    state.config.audioMute = !!on
    if (persist !== false) {
      try { localStorage.setItem(AUDIO_MUTE_KEY, on ? '1' : '0') } catch (e) { /* ignore */ }
      if (window.spasDesktop && window.spasDesktop.saveConfig) {
        window.spasDesktop.saveConfig({ audioMute: !!on }).catch(() => {})
      }
    }
    syncAudioMuteUi()
  }

  function syncAudioMuteUi() {
    const muted = isAudioMuted()
    document.body.classList.toggle('audio-muted', muted)
    ;['btnQuickMute', 'btnFarmMute'].forEach((id) => {
      if (!$(id)) return
      $(id).textContent = muted ? '🔇' : '🔊'
      $(id).title = muted ? '已静音（点按恢复）' : '音效开（点按静音）'
      $(id).classList.toggle('is-on', muted)
    })
    if ($('cfgAudioMute')) $('cfgAudioMute').checked = muted
  }

  function cycleFarmFxMode() {
    const cur = state.config.farmFxMode || 'auto'
    const i = FX_CYCLE.indexOf(cur)
    const next = FX_CYCLE[(i < 0 ? 0 : i + 1) % FX_CYCLE.length]
    state.config.farmFxMode = next
    if (window.spasDesktop && window.spasDesktop.saveConfig) {
      window.spasDesktop.saveConfig({ farmFxMode: next }).catch(() => {})
    }
    if ($('cfgFarmFx')) $('cfgFarmFx').value = next
    applyFarmFxMode()
    const labels = { auto: '自动', full: '完整', lite: '轻量', off: '关闭' }
    toast('特效：' + (labels[next] || next), 'ok')
    syncFarmFxUi()
  }

  function syncFarmFxUi() {
    const mode = state.config.farmFxMode || 'auto'
    const labels = { auto: '自动', full: '完整', lite: '轻量', off: '关' }
    ;['btnQuickFx', 'btnFarmFxToggle', 'btnFarmFxCycle'].forEach((id) => {
      if (!$(id)) return
      $(id).title = '特效：' + (labels[mode] || mode) + '（点按切换）'
      if (id !== 'btnQuickFx') $(id).textContent = '特效·' + (labels[mode] || mode)
    })
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

  function prepareLoginView() {
    renderRecentUsers()
    refreshCaptcha()
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
    if (opts.pendingAck > 0) {
      items.push({
        cls: 'warn',
        text: '有 ' + opts.pendingAck + ' 条检查结果待确认（属实/异议）',
        action: 'ack',
        label: '去确认'
      })
    }
    if (opts.confirmable > 0) {
      items.push({
        cls: 'info',
        text: '有 ' + opts.confirmable + ' 条历史代提待确认（旧流程，次日确认）',
        action: 'confirm',
        label: '去处理'
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
    if (opts.isLeader && opts.hasAssign && opts.groupMiss > 0) {
      items.push({
        cls: 'info',
        text: '本组还有 ' + opts.groupMiss + ' 人待登记检查',
        action: 'checkout',
        label: '去登记'
      })
    }
    // 已有当日布置时，主路径是座位检查，不提示「去打卡」
    if (!opts.done && !opts.hasAssign && !(opts.tpl && opts.tpl.bookName)) {
      items.push({
        cls: 'ok',
        text: '今日尚未加练，可用下方加练入口登记',
        action: 'practice',
        label: '去加练'
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
    const co = state.checkout || {}
    const members = (co.members && co.members.length)
      ? co.members
      : (progress || []).map((m) => ({
        studentId: m.studentId,
        studentName: m.studentName,
        finishStatus: m.submitted ? '1' : '',
        roleInGroup: m.roleInGroup
      }))
    if (!members.length) {
      mod.hidden = true
      return
    }
    mod.hidden = false
    const doneN = members.filter((m) => !!m.finishStatus).length
    const miss = members.filter((m) => !m.finishStatus)
    const gName = (group && (group.groupName || group.group_name)) || '本组今日'
    if ($('homeGroupName')) $('homeGroupName').textContent = gName
    if ($('homeGroupRate')) {
      $('homeGroupRate').textContent = co.assignment
        ? (doneN + ' / ' + members.length + ' 已登记')
        : (doneN + ' / ' + members.length + ' 已交')
    }
    if ($('homeGroupPill')) {
      $('homeGroupPill').textContent = miss.length
        ? (miss.length + (co.assignment ? ' 人待登记' : ' 人未交'))
        : (co.checkout ? '检查单已提交' : '全员已交')
      $('homeGroupPill').className = 'pill' + (miss.length ? '' : ' dark')
    }
    renderGroupLamp(co.weekQualify)
    const box = $('homeGroupMiss')
    if (box) {
      if (!miss.length) {
        box.innerHTML = '<span class="chip ok">' + (co.checkout ? '检查单已提交，等待组员确认' : '全员已交，棒！') + '</span>'
      } else {
        box.innerHTML = miss.map((m) =>
          '<button type="button" class="chip tap" data-check-hub="1"' +
          (isLeader ? '' : ' disabled') + '>' +
          escapeHtml(m.studentName) + (isLeader ? ' · 待登记' : ' · 未交') + '</button>'
        ).join('')
      }
    }
    if ($('btnHomeCheckout')) {
      $('btnHomeCheckout').hidden = !(isLeader && co.assignment)
      $('btnHomeCheckout').textContent = co.checkout ? '改正本组登记' : '帮本组登记检查'
    }
  }

  /** 组达标灯：一体机首页醒目展示 */
  function renderGroupLamp(wq) {
    const lamp = $('groupLamp')
    if (!lamp) return
    if (!wq) {
      lamp.hidden = true
      lamp.classList.remove('is-on', 'is-off')
      return
    }
    lamp.hidden = false
    const on = !!wq.qualified
    lamp.classList.toggle('is-on', on)
    lamp.classList.toggle('is-off', !on)
    if ($('groupLampTitle')) $('groupLampTitle').textContent = on ? '本周已达标' : '组达标灯'
    if ($('groupLampText')) {
      $('groupLampText').textContent = on
        ? ('已点亮 · ' + (wq.submittedCount || 0) + '/' + (wq.dueCount || 0) + ' 次')
        : (wq.reason || ('检查 ' + (wq.submittedCount || 0) + '/' + (wq.dueCount || 0) + ' · 须抽检且无偏松'))
    }
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
    const password = $('loginPwd').value
    const code = $('loginCode').value.trim()
    if (!username) { $('loginErr').textContent = '请输入学号或工号'; return }
    if (!password) { $('loginErr').textContent = '请输入密码'; return }
    if (!code) { $('loginErr').textContent = '请输入验证码'; return }
    try {
      setLoading(true, '登录中…')
      const data = await api('POST', '/login', { username, password, code, uuid: state.uuid }, { noAuth: true })
      state.token = data.token
      localStorage.setItem('spas_desktop_token', state.token)
      saveRecentUser(username, username)
      $('loginPwd').value = ''
      $('loginCode').value = ''
      logClient('login ok user=' + username)
      await afterLogin()
      toast('登录成功', 'ok')
    } catch (e) {
      $('loginErr').textContent = e.message || '登录失败'
      shakeLogin()
      logClient('login fail ' + (e.message || ''))
      refreshCaptcha()
    } finally {
      setLoading(false)
    }
  }

  async function afterLogin() {
    const info = await api('GET', '/getInfo')
    state.roles = Array.isArray(info.roles) ? info.roles : []
    state.permissions = Array.isArray(info.permissions) ? info.permissions : []
    state.user = info.user || {}
    const staff = hasStaffRole(state.roles)

    let profile = null
    try {
      const profileRes = await api('GET', '/spas/practice/session/profile')
      profile = profileRes.data || null
    } catch (e) {
      profile = null
    }

    try {
      const subRes = await api('GET', '/spas/subject/optionselect')
      state.subjects = subRes.data || []
    } catch (e) {
      state.subjects = []
    }

    if (staff) {
      state.mode = 'staff'
      const name = state.user.nickName || state.user.userName || '教师'
      const no = state.user.userName || ''
      state.profile = { studentName: name, studentNo: no, deptId: state.user.deptId, leader: false }
      if (no) saveRecentUser(no, name)
      setAsideIdentity(name, no, staffRoleLabel(state.roles))
      if ($('userAvatar')) $('userAvatar').textContent = (name || '教').slice(0, 1)
      applyModeChrome()
      await enterStaffMode()
      touchIdle()
      return
    }

    if (!profile || !profile.studentId) {
      state.token = ''
      localStorage.removeItem('spas_desktop_token')
      throw new Error('请使用学生学号，或教师/管理员工号登录')
    }

    state.mode = 'student'
    state.profile = profile
    const name = state.profile.studentName || '同学'
    const no = state.profile.studentNo || ''
    if (no) saveRecentUser(no, name)
    setAsideIdentity(name, no, state.profile.leader ? '组长' : '学生')
    if ($('userAvatar')) $('userAvatar').textContent = (name || '生').slice(0, 1)
    applyModeChrome()
    loadTemplate()
    heartbeat()
    await flushQueue()
    await loadHome()
    show('viewHome')
    touchIdle()
  }

  function flattenDeptLeaves(nodes, out) {
    out = out || []
    ;(nodes || []).forEach((n) => {
      const kids = n.children || n.childList || []
      if (kids.length) flattenDeptLeaves(kids, out)
      else {
        const id = n.id != null ? n.id : n.deptId
        const label = n.label || n.deptName || String(id)
        if (id != null) out.push({ deptId: Number(id), deptName: label })
      }
    })
    return out
  }

  async function loadStaffDepts() {
    let depts = []
    try {
      const res = await api('GET', '/spas/teacher/my-depts')
      depts = (res.data || []).map((d) => ({
        deptId: Number(d.deptId),
        deptName: d.deptName || String(d.deptId),
        primary: !!d.primary
      }))
    } catch (e) { depts = [] }

    if (!depts.length) {
      try {
        const treeRes = await api('GET', '/system/user/deptTree')
        depts = flattenDeptLeaves(treeRes.data || [])
      } catch (e) { depts = [] }
    }
    state.supervise.depts = depts
    if (!state.supervise.deptId && depts.length) {
      const primary = depts.find((d) => d.primary)
      state.supervise.deptId = (primary || depts[0]).deptId
    }
    return depts
  }

  function fillSuperviseSubjects() {
    const sel = $('superviseSubject')
    if (!sel) return
    const list = state.subjects || []
    sel.innerHTML = '<option value="">请选择学科</option>' + list.map((s) =>
      '<option value="' + s.subjectId + '">' + escapeHtml(s.subjectName || '') + '</option>'
    ).join('')
    if (state.supervise.subjectId) sel.value = String(state.supervise.subjectId)
    else if (list.length === 1) {
      state.supervise.subjectId = list[0].subjectId
      sel.value = String(list[0].subjectId)
    }
  }

  function renderSuperviseDeptChips() {
    const box = $('superviseDeptChips')
    if (!box) return
    const depts = state.supervise.depts || []
    if (!depts.length) {
      box.innerHTML = '<span class="muted">暂无可选班级，请确认账号已绑定任课班级</span>'
      return
    }
    box.innerHTML = depts.map((d) =>
      '<button type="button" class="chip tap' + (Number(d.deptId) === Number(state.supervise.deptId) ? ' on' : '') +
      '" data-dept-id="' + d.deptId + '">' + escapeHtml(d.deptName) + '</button>'
    ).join('')
  }

  function setSuperviseTab(tab) {
    state.supervise.tab = tab || 'spot'
    document.querySelectorAll('#superviseTabs .tab').forEach((btn) => {
      btn.classList.toggle('active', btn.dataset.supTab === state.supervise.tab)
    })
    const map = {
      checkout: 'supPanelCheckout',
      ack: 'supPanelAck',
      spot: 'supPanelSpot',
      hard: 'supPanelHard',
      week: 'supPanelWeek'
    }
    Object.keys(map).forEach((k) => {
      if ($(map[k])) $(map[k]).hidden = k !== state.supervise.tab
    })
  }

  function emptySup(text) {
    return '<div class="muted" style="padding:12px 4px">' + escapeHtml(text || '暂无') + '</div>'
  }

  function renderSuperviseBoard() {
    const a = state.supervise.alerts || {}
    const missing = a.missingCheckout || []
    const pending = a.pendingAck || []
    const disputes = a.disputes || []
    const timeouts = a.timeouts || []
    const hardItems = a.difficultyItems || []
    const hardUnfollowed = hardItems.filter((r) => r.followStatus !== '1')
    if ($('kpiMissing')) $('kpiMissing').textContent = String(missing.length)
    if ($('kpiDispute')) $('kpiDispute').textContent = String(disputes.length)
    if ($('kpiTimeout')) $('kpiTimeout').textContent = String(timeouts.length)
    if ($('kpiHard')) $('kpiHard').textContent = String(hardUnfollowed.length)

    if ($('supMissingList')) {
      $('supMissingList').innerHTML = missing.length
        ? missing.map((g) =>
          '<div class="sup-row"><div class="main"><b>' + escapeHtml(g.groupName || '组') + '</b>' +
          '<div class="muted">组长 ' + escapeHtml(g.leaderStudentName || '-') +
          ' · ' + (g.memberCount != null ? g.memberCount + ' 人' : '') + '</div></div></div>'
        ).join('')
        : emptySup('各组均已结账（或当日未布置）')
    }
    if ($('supPendingHint')) $('supPendingHint').textContent = pending.length ? ('· ' + pending.length + ' 人') : ''
    if ($('supPendingList')) {
      $('supPendingList').innerHTML = pending.length
        ? pending.map((r) => supervisePersonRow(r, false)).join('')
        : emptySup('无待确认')
    }
    if ($('supDisputeList')) {
      $('supDisputeList').innerHTML = disputes.length
        ? ('<div class="muted" style="padding:4px 0 8px">异议须先到「抽检」判定，再补确认或作废</div>' +
          disputes.map((r) => supervisePersonRow(r, true, ['ack', 'void', 'dismiss'])).join(''))
        : emptySup('无异议')
    }
    if ($('supTimeoutList')) {
      $('supTimeoutList').innerHTML = timeouts.length
        ? timeouts.map((r) => supervisePersonRow(r, true, ['ack', 'void', 'dismiss'])).join('')
        : emptySup('无超时')
    }
    if ($('supSpotList')) {
      const spot = state.supervise.spotQueue || []
      $('supSpotList').innerHTML = spot.length
        ? spot.map((r) =>
          '<div class="sup-row" data-item-id="' + r.itemId + '"><div class="main"><b>' +
          escapeHtml(r.studentName || '') + '</b> · ' + escapeHtml(r.groupName || '') +
          '<div class="muted">' + finishLabel(r.finishStatus) +
          (r.memberAck === '2' ? ' · 异议' : (r.memberAck === '3' ? ' · 超时' : '')) +
          (r.knowledgeNames ? (' · ' + escapeHtml(r.knowledgeNames)) : '') +
          '</div><div class="muted spot-std">' + escapeHtml(spotAssignText(r)) + '</div>' +
          '</div><div class="sup-actions">' +
          '<button type="button" class="btn mini primary" data-spot="1">一致</button>' +
          '<button type="button" class="btn mini warn-btn" data-spot="2">偏松</button>' +
          '<button type="button" class="btn mini ghost" data-spot="3">偏严</button>' +
          '</div></div>'
        ).join('')
        : emptySup('今日暂无待抽或尚未有检查单')
    }
    if ($('supHardSummary')) {
      const sum = a.difficultySummary || []
      $('supHardSummary').innerHTML = sum.length
        ? sum.map((s) => '<span class="chip warn">' + escapeHtml(s.knowledgeName || '') + ' · ' + (s.studentCount || 0) + '人</span>').join('')
        : '<span class="muted">无困难主题汇总</span>'
    }
    if ($('supHardList')) {
      $('supHardList').innerHTML = hardItems.length
        ? hardItems.map((r) =>
          '<div class="sup-row" data-item-id="' + r.itemId + '"><div class="main"><b>' +
          escapeHtml(r.studentName || '') + '</b> · ' + escapeHtml(r.groupName || '') +
          '<div class="muted">' + escapeHtml(r.difficultyNote || '有困难') + '</div></div>' +
          (r.followStatus === '1'
            ? '<span class="chip ok">已跟进</span>'
            : '<div class="sup-actions">' +
              '<button type="button" class="btn mini primary" data-follow="1">已知晓</button>' +
              '<button type="button" class="btn mini ghost" data-intervene="1">转干预</button>' +
              '</div>') +
          '</div>'
        ).join('')
        : emptySup('无困难记录')
    }
    if ($('supWeekList')) {
      const weeks = a.groupWeek || []
      $('supWeekList').innerHTML = weeks.length
        ? weeks.map((g) =>
          '<div class="sup-row"><div class="main"><b>' + escapeHtml(g.groupName || '') + '</b>' +
          '<div class="muted">' + (g.submittedCount || 0) + '/' + (g.dueCount || 0) +
          ' · 偏松 ' + (g.looseCount || 0) +
          (g.reason ? (' · ' + escapeHtml(g.reason)) : '') + '</div></div>' +
          '<span class="chip ' + (g.qualified ? 'ok' : 'miss') + '">' + (g.qualified ? '达标' : '未达标') + '</span></div>'
        ).join('')
        : emptySup('暂无周达标数据')
    }

    const asg = state.supervise.assignment
    if ($('superviseAssignHint')) {
      if (!state.supervise.subjectId) $('superviseAssignHint').textContent = '请选择学科以查看布置与提交'
      else if (!asg) $('superviseAssignHint').textContent = '当日该学科尚未布置'
      else {
        $('superviseAssignHint').textContent = '已布置：' + formatAssign(asg, { withSubject: true, empty: '练习' })
      }
    }
  }

  function formatAssign(asg, opts) {
    opts = opts || {}
    if (!asg) return opts.empty || '无布置'
    const page = asg.pageFrom
      ? ('p.' + asg.pageFrom + (asg.pageTo && asg.pageTo !== asg.pageFrom ? ('-' + asg.pageTo) : ''))
      : ''
    const parts = []
    if (opts.withSubject && asg.subjectName) parts.push(asg.subjectName)
    if (asg.bookName) parts.push(asg.bookName)
    if (page) parts.push(page)
    if (asg.questionText) parts.push('题 ' + asg.questionText)
    return parts.length ? parts.join(' · ') : (opts.empty || '今日布置')
  }

  function spotAssignText(r) {
    return formatAssign(r, { empty: '无布置标准' })
  }

  function supervisePersonRow(r, withActions, actions) {
    const act = (actions || []).map((a) => {
      const label = a === 'ack' ? '补确认' : (a === 'void' ? '作废' : '已阅')
      const cls = a === 'void' ? 'danger' : (a === 'dismiss' ? 'ghost' : 'primary')
      return '<button type="button" class="btn mini ' + cls + '" data-resolve="' + a + '">' + label + '</button>'
    }).join('')
    return '<div class="sup-row" data-item-id="' + (r.itemId || '') + '"><div class="main"><b>' +
      escapeHtml(r.studentName || '') + '</b> · ' + escapeHtml(r.groupName || '') +
      '<div class="muted">' + finishLabel(r.finishStatus) +
      (r.studentNo ? (' · ' + escapeHtml(r.studentNo)) : '') + '</div></div>' +
      (withActions && act ? ('<div class="sup-actions">' + act + '</div>') : '') +
      '</div>'
  }

  async function refreshSupervise() {
    if ($('superviseErr')) $('superviseErr').textContent = ''
    const deptId = state.supervise.deptId
    const subjectId = state.supervise.subjectId
    const practiceDate = state.supervise.practiceDate || todayStr()
    if (!deptId) {
      state.supervise.alerts = {}
      state.supervise.spotQueue = []
      state.supervise.assignment = null
      renderSuperviseBoard()
      if ($('superviseErr')) $('superviseErr').textContent = '请先选择班级'
      return
    }
    const q = qs({ deptId, subjectId, practiceDate })
    try {
      const [alertsRes, spotRes] = await Promise.all([
        api('GET', '/spas/practice/stat/checkout-alerts?' + q),
        api('GET', '/spas/practice/stat/spot-queue?' + q)
      ])
      state.supervise.alerts = alertsRes.data || {}
      state.supervise.spotQueue = spotRes.data || []
    } catch (e) {
      state.supervise.alerts = {}
      state.supervise.spotQueue = []
      if ($('superviseErr')) $('superviseErr').textContent = e.message || '加载失败'
    }
    state.supervise.assignment = null
    if (subjectId) {
      try {
        const asgRes = await api('GET', '/spas/practice/assignment/list?' + qs({
          deptId, subjectId, assignDate: practiceDate
        }))
        const rows = asgRes.data || asgRes.rows || []
        state.supervise.assignment = rows[0] || null
      } catch (e) { state.supervise.assignment = null }
    }
    renderSuperviseBoard()
  }

  async function enterStaffMode() {
    state.supervise.practiceDate = state.supervise.practiceDate || todayStr()
    if ($('superviseDate')) $('superviseDate').value = state.supervise.practiceDate
    await loadStaffDepts()
    fillSuperviseSubjects()
    renderSuperviseDeptChips()
    setSuperviseTab(state.supervise.tab || 'spot')
    show('viewSupervise')
    await refreshSupervise()
  }

  function promptConfirm(title, text) {
    return new Promise((resolve) => {
      state.dlgResolve = resolve
      if ($('confirmDlgTitle')) $('confirmDlgTitle').textContent = title || '确认？'
      if ($('confirmDlgText')) $('confirmDlgText').textContent = text || ''
      if ($('confirmDlg')) $('confirmDlg').hidden = false
    })
  }

  function closeConfirmDlg(ok) {
    if ($('confirmDlg')) $('confirmDlg').hidden = true
    const resolve = state.dlgResolve
    state.dlgResolve = null
    if (resolve) resolve(!!ok)
    else if (!ok) state.pendingPayload = null
  }

  async function staffResolveItem(itemId, action) {
    if (!itemId) return
    const tip = {
      ack: '补确认并写入练习流水？（异议须已抽检，否则会失败）',
      void: '作废该记录？学生不计分。',
      dismiss: '标记已阅（不计流水）？'
    }[action]
    const ok = await promptConfirm('督察处置', tip || '确认处置？')
    if (!ok) return
    try {
      setLoading(true, '处置中…')
      const res = await api('PUT', '/spas/practice/checkout/item/' + itemId + '/resolve', { action })
      const pts = res && res.awardedPoints
      toast(action === 'ack'
        ? ('已补确认' + (pts ? ('，积分 +' + pts) : ''))
        : (action === 'void' ? '已作废' : '已标记已阅'), 'ok')
      await refreshSupervise()
    } catch (e) {
      toast(e.message || '处置失败', 'err')
    } finally {
      setLoading(false)
    }
  }

  async function staffSpotItem(itemId, result) {
    if (!itemId) return
    const tip = result === '2' ? '记为偏松？该次检查将作废。' : (result === '3' ? '记为偏严？' : '记为抽检一致？')
    const ok = await promptConfirm('抽检', tip)
    if (!ok) return
    const queueRow = (state.supervise.spotQueue || []).find((r) => Number(r.itemId) === Number(itemId))
    const wasDispute = queueRow && String(queueRow.memberAck) === '2'
    try {
      setLoading(true, '记录中…')
      await api('PUT', '/spas/practice/spot/' + itemId, { spotResult: result })
      if (result === '2') {
        toast('已记偏松并作废', 'ok')
      } else if (wasDispute && result !== '2') {
        toast('已抽检 · 请到「异议 / 超时」补确认或作废', 'ok')
        setSuperviseTab('ack')
      } else {
        toast('已记录抽检', 'ok')
      }
      await refreshSupervise()
    } catch (e) {
      toast(e.message || '抽检失败', 'err')
    } finally {
      setLoading(false)
    }
  }

  async function staffFollowItem(itemId) {
    if (!itemId) return
    try {
      setLoading(true, '标记中…')
      await api('PUT', '/spas/practice/checkout/item/' + itemId + '/follow')
      toast('已标记跟进', 'ok')
      await refreshSupervise()
    } catch (e) {
      toast(e.message || '操作失败', 'err')
    } finally {
      setLoading(false)
    }
  }

  async function staffInterveneItem(itemId) {
    if (!itemId) return
    const ok = await promptConfirm('转干预', '转入干预任务并标记已跟进？')
    if (!ok) return
    try {
      setLoading(true, '处理中…')
      await api('POST', '/spas/intervene/from-source', {
        sourceType: 'checkout_item',
        sourceId: itemId
      })
      toast('已转干预', 'ok')
      await refreshSupervise()
    } catch (e) {
      toast(e.message || '转干预失败', 'err')
    } finally {
      setLoading(false)
    }
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
    const st = m.finishStatus
    const ack = m.memberAck
    let label = '未登记'
    let chipCls = 'miss'
    if (ack === '2') { label = '有异议'; chipCls = 'miss' }
    else if (ack === '3') { label = '超时未确认'; chipCls = 'warn' }
    else if (ack === '0' && st && st !== '0' && st !== 'L' && st !== 'A') { label = '待确认'; chipCls = 'warn' }
    else if (st === '1') { label = ack === '1' ? '已确认' : '已完成'; chipCls = 'ok' }
    else if (st === '2') { label = ack === '1' ? '已确认·部分' : '部分'; chipCls = 'ok' }
    else if (st === '3') { label = ack === '1' ? '已确认·困难' : '有困难'; chipCls = 'miss' }
    else if (st === '0') { label = '未做'; chipCls = 'miss' }
    else if (st === 'L') { label = '请假'; chipCls = 'warn' }
    else if (st === 'A') { label = '未到'; chipCls = 'miss' }
    else if (m.submitted) { label = '已登记'; chipCls = 'ok' }
    return '<span class="chip ' + chipCls + '">' +
      escapeHtml(m.studentName) + (m.roleInGroup === '1' || m.roleInGroup === 1 ? '·组长' : '') +
      ' · ' + label + '</span>'
  }

  function renderAsideTips(logs, pendingAck, confirmable, qn, groupMiss, progress, hasAssign) {
    const box = $('asideTips')
    if (!box) return
    const tips = []
    const acc = state.points && state.points.account
    if (pendingAck) tips.push(['out', '有 ' + pendingAck + ' 条检查结果待确认，确认后可获积分。'])
    else if (!logs.length && !hasAssign) tips.push(['out', '今日还没加练，可用「加练」入口登记。'])
    else if (!logs.length && hasAssign) tips.push(['in', '今日已布置，等待组长座位检查后登记。'])
    else tips.push(['in', '今日已交 ' + logs.length + ' 条，保持节奏不错。'])
    if (acc) {
      const todayPts = acc.todayPoints || 0
      const streak = acc.dayStreak || 0
      tips.push(['in', '今日积分 +' + todayPts + (streak >= 2 ? ('，连打 ' + streak + ' 天') : '')])
      if (state.points.weekRank) tips.push(['out', '本周班榜第 ' + state.points.weekRank + ' 名，加油！'])
    }
    if (confirmable) tips.push(['out', '有 ' + confirmable + ' 条历史代提待确认（旧流程）。'])
    if (qn) tips.push(['in', '离线待传 ' + qn + ' 条，联网后会自动同步。'])
    if (progress.length && groupMiss > 0) tips.push(['in', '本组还有 ' + groupMiss + ' 人未登记检查，可提醒一下。'])
    if (state.weak && state.weak.length) tips.push(['out', '建议优先练：' + (state.weak[0].knowledgeName || '薄弱主题')])
    if (!tips.length) tips.push(['in', '检查在座位完成，一体机只登记结果。'])
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
          ? ('本组已登记 · ' + formatAssign(asg) + ' · 可改正后重提')
          : ('帮本组登记：' + formatAssign(asg) + ' · 先座位查本，再上机点选')
      } else if (co.leader && !asg) {
        $('homeStatus').textContent = '今日教师尚未布置，暂不能帮组员登记（可先加练）'
      } else if (myItem) {
        const ack = myItem.memberAck
        $('homeStatus').textContent = ack === '1'
          ? ('今日检查已确认属实 · ' + formatAssign(asg))
          : (ack === '2'
            ? '已提出异议，等待老师抽检'
            : (ack === '3' ? '昨日未确认已超时，等待老师抽检' : '组长已在座位检查，请确认'))
      } else if (asg) {
        $('homeStatus').textContent = '今日已布置：' + formatAssign(asg) + ' · 等待组长座位检查'
      } else {
        $('homeStatus').textContent = done
          ? ('今日已交 ' + logs.length + ' 条加练')
          : '今日教师尚未布置'
      }
    }
    if ($('btnGoPractice')) {
      if (pendingAck.length) $('btnGoPractice').textContent = '确认今日结果'
      else if (co.leader && asg) $('btnGoPractice').textContent = co.checkout ? '改正本组登记' : '帮本组登记检查'
      else if (asg) $('btnGoPractice').textContent = '查看今日进度'
      else $('btnGoPractice').textContent = '今日练习（加练）'
      $('btnGoPractice').disabled = false
    }
    if ($('btnGoExtra')) $('btnGoExtra').hidden = false
    const wq = co.weekQualify
    const isLeader = !!((state.today && state.today.leader) || co.leader)
    if ($('weekPill')) {
      $('weekPill').textContent = wq
        ? (wq.qualified
          ? ('本周组达标 · ' + (wq.submittedCount || 0) + '/' + (wq.dueCount || 0) + ' 次')
          : ('本周未达标 · ' + (wq.reason || ((wq.submittedCount || 0) + '/' + (wq.dueCount || 0) + ' 次'))))
        : (logs.length + ' 条今日')
    }
    // 组长入口：仅当日本日有布置时显示（走检查单，非旧代填）
    const showLeaderEntry = isLeader && !!asg && !isStaffMode()
    ;['navCheckout', 'btnGoCheckout', 'btnGoCheckout2', 'btnHomeCheckout'].forEach((id) => {
      if (!$(id)) return
      $(id).hidden = !showLeaderEntry
      $(id).style.display = showLeaderEntry ? '' : 'none'
    })
    if ($('btnGoCheckout')) {
      $('btnGoCheckout').textContent = co.checkout ? '改正本组登记' : '帮本组登记'
    }
    if ($('btnHomeCheckout')) {
      $('btnHomeCheckout').textContent = co.checkout ? '改正本组登记' : '帮本组登记检查'
    }
    if ($('weekTip')) {
      $('weekTip').textContent = wq
        ? (wq.qualified
          ? '本周组达标已点亮'
          : (wq.reason || ('本周检查 ' + (wq.submittedCount || 0) + '/' + (wq.dueCount || 0) + ' 次，须抽检且无偏松才达标')))
        : (done ? '今日已有加练记录' : '今日待检查或加练')
    }
    const grid = $('actionGrid')
    if (grid) grid.classList.toggle('single', !isLeader)
    const progress = state.today.groupProgress || []
    const coMembers = (co.members && co.members.length) ? co.members : null
    const groupMiss = coMembers
      ? coMembers.filter((m) => !m.finishStatus).length
      : progress.filter((m) => !m.submitted).length
    if ($('statDone')) $('statDone').textContent = String(logs.length)
    if ($('statDoneDash')) $('statDoneDash').textContent = String(logs.length)
    if ($('statGroupMiss')) $('statGroupMiss').textContent = (coMembers || progress).length ? String(groupMiss) : '-'
    const confirmStat = pendingAck.length + confirmable
    if ($('statConfirm')) $('statConfirm').textContent = String(confirmStat)
    // statConfirmDash 为历史副指标，与待确认同源，已取消展示
    if ($('statConfirmTodo')) $('statConfirmTodo').textContent = String(confirmStat)
    if ($('statQueue')) $('statQueue').textContent = String(qn)
    if ($('asideRole')) $('asideRole').textContent = isLeader ? '组长' : '学生'
    if ($('groupCard')) $('groupCard').hidden = !(coMembers || progress).length
    if ($('tabGroupBtn')) $('tabGroupBtn').hidden = !(coMembers || progress).length
    const chipSrc = coMembers || progress
    const chips = chipSrc.map(memberChipHtml).join('')
    if ($('groupProgress')) $('groupProgress').innerHTML = chips
    if ($('centerGroupProgress')) {
      $('centerGroupProgress').innerHTML = chips || emptyHtml('暂无分组信息')
    }
    if ($('todayList')) {
      $('todayList').innerHTML = logs.length
        ? logs.map(taskCardHtml).join('')
        : emptyHtml('今天还没有练习记录', { action: 'practice', label: '今日练习' })
    }
    renderHomeTodayPreview(logs)
    renderHomeGroup(progress, isLeader, state.today.group)
    renderPendingConfirm(pending)
    loadTemplate()
    updateReuseButtons()
    if ($('quickHero')) $('quickHero').classList.toggle('is-done', done)
    if ($('homeBoardMod')) $('homeBoardMod').hidden = false
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
      state.weakSubjectId = sid || null
      const weakRes = await api('GET', '/spas/practice/suggest/weak?limit=8' + (sid ? ('&subjectId=' + sid) : ''))
      state.weak = weakRes.data || []
      renderHomeWeak(state.weak)
      if ($('weakList')) {
        $('weakList').innerHTML = state.weak.length
          ? state.weak.map((k) =>
            '<button type="button" class="chip weak tap" data-kid="' + k.knowledgeId + '">' +
            escapeHtml(k.knowledgeName || '') + '</button>'
          ).join('')
          : emptyHtml('暂无薄弱建议，可自行选择知识点', { action: 'extra', label: '去加练' })
      }
    } catch (e) {
      renderHomeWeak([])
      if ($('weakList')) $('weakList').innerHTML = emptyHtml('薄弱建议暂不可用', { action: 'extra', label: '去加练' })
    }
    renderHomeAlerts({
      pendingAck: pendingAck.length,
      confirmable, qn, groupMiss, isLeader, done,
      hasAssign: !!asg,
      tpl: state.lastTemplate || loadTemplate()
    })
    updateQueueBadge()
    await loadPointsHome()
    renderAsideTips(logs, pendingAck.length, confirmable, qn, groupMiss, progress, !!asg)
    if (pendingAck.length) {
      /* primary path: checkout ack — CTA already points to openAckView */
    } else if (confirmable && $('homeConfirmMod')) {
      $('homeConfirmMod').scrollIntoView({ behavior: 'smooth', block: 'nearest' })
    }
  }

  async function loadPointsHome(opts) {
    opts = opts || {}
    const prevLevel = state.prevLevelNo
    try {
      const mineRes = await api('GET', '/spas/practice/points/mine')
      state.points = mineRes.data || {}
      applyFarmThresholds(state.points.farmThresholds)
      const lv = (state.points.account && state.points.account.levelNo) || 1
      if (prevLevel != null && lv > prevLevel) {
        state.leveledUpTo = lv
      }
      state.prevLevelNo = lv
      const totalPts = (state.points.account && state.points.account.totalPoints) || 0
      const farmSt = resolveFarmStage(state.points.account, totalPts)
      const prevFarm = state.prevFarmStage
      if (prevFarm != null && farmStageRank(farmSt) > farmStageRank(prevFarm)) {
        state.farmStageUpTo = farmSt
      }
      state.prevFarmStage = farmSt
      renderLevelBar(state.points)
      renderAsidePoints(state.points)
      renderFarm(state.points)
    } catch (e) {
      state.points = { _loadError: true, account: {} }
      renderLevelBar(state.points)
      renderAsidePoints(null)
      renderFarm(state.points)
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
    const acc = data && data.account
    const p = levelProgress(acc)
    const stage = resolveFarmStage(acc, p.total)
    const bounds = farmStageBounds(stage)
    const toNextFarm = acc && acc.pointsToNextFarmStage != null
      ? Number(acc.pointsToNextFarmStage)
      : Math.max(0, bounds[1] - p.total)
    if ($('asideLv')) $('asideLv').textContent = 'Lv.' + p.level
    if ($('asideTotalPts')) $('asideTotalPts').textContent = String(p.total)
    if ($('asidePtsSub')) {
      $('asidePtsSub').textContent = '今日 +' + p.today + ' · 连打 ' + p.streak + ' 天'
    }
    if ($('asideFarmSub')) {
      if (stage === 'tree') {
        $('asideFarmSub').textContent = '植物 · ' + farmStageLabel(stage)
      } else {
        $('asideFarmSub').textContent =
          '植物 · ' + farmStageLabel(stage) + ' · 距下阶段 ' + toNextFarm
      }
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

  function applyFarmThresholds(th) {
    if (!th || typeof th !== 'object') return
    const s = Number(th.seedling)
    const a = Number(th.sapling)
    const t = Number(th.tree)
    if (s > 0) FARM_STAGE.seedling = s
    if (a > s && a > 0) FARM_STAGE.sapling = a
    if (t > a && t > 0) FARM_STAGE.tree = t
    updateFarmMilestoneHints()
  }

  function updateFarmMilestoneHints() {
    const map = {
      seed: '萌芽 · 0+',
      seedling: '浮叶 · ' + FARM_STAGE.seedling + '+',
      sapling: '花蕾 · ' + FARM_STAGE.sapling + '+',
      tree: '盛放 · ' + FARM_STAGE.tree + '+'
    }
    const box = $('farmMilestones')
    if (box) {
      box.querySelectorAll('[data-ms]').forEach((el) => {
        const tip = map[el.dataset.ms]
        if (tip) el.title = tip
      })
    }
    const legend = document.querySelector('.class-farm-legend')
    if (legend) {
      legend.querySelectorAll('[data-stage]').forEach((el) => {
        const tip = map[el.dataset.stage]
        if (tip) el.title = tip
      })
    }
    if ($('farmStageHint')) {
      $('farmStageHint').textContent =
        '植物阶段按累计积分 ' + FARM_STAGE.seedling + ' / ' + FARM_STAGE.sapling +
        ' / ' + FARM_STAGE.tree + '；顶部 Lv 为另一套等级'
    }
    if ($('pointsRuleFarm')) {
      $('pointsRuleFarm').innerHTML =
        '顶部 <b>Lv</b> 按累计积分升级；右侧植物阶段按 <b>' +
        FARM_STAGE.seedling + ' / ' + FARM_STAGE.sapling + ' / ' + FARM_STAGE.tree +
        '</b>（与 Lv 独立）'
    }
  }

  /** 积分阶段：萌芽 → 浮叶 → 花蕾 → 盛放（果树成长；与 Lv 独立） */
  function farmStageOf(totalPoints) {
    const p = Math.max(0, Number(totalPoints) || 0)
    if (p >= FARM_STAGE.tree) return 'tree'
    if (p >= FARM_STAGE.sapling) return 'sapling'
    if (p >= FARM_STAGE.seedling) return 'seedling'
    return 'seed'
  }

  function farmStageLabel(stage) {
    return FARM_STAGE.labels[stage] || FARM_STAGE.labels.seed
  }

  function farmNextHint(total, stage) {
    const bounds = farmStageBounds(stage)
    if (stage === 'tree') return '果树已盛放，继续练习保持生机'
    const left = Math.max(0, bounds[1] - total)
    const next = stage === 'seed' ? '浮叶' : (stage === 'seedling' ? '花蕾' : '盛放')
    return '再攒 ' + left + ' 分长成' + next
  }

  /** 名牌短文案，少挡田心 */
  function farmNextHintShort(total, stage) {
    const bounds = farmStageBounds(stage)
    if (stage === 'tree') return '已盛放'
    const left = Math.max(0, bounds[1] - total)
    const next = stage === 'seed' ? '浮叶' : (stage === 'seedling' ? '花蕾' : '盛放')
    return '差' + left + '→' + next
  }

  /** 当前阶段内进度（驱动植物形态 --farm-p） */
  function farmStageProgress(total, stage) {
    const p = Math.max(0, Number(total) || 0)
    const bounds = farmStageBounds(stage)
    if (stage === 'tree') return 100
    const span = Math.max(1, bounds[1] - bounds[0])
    return Math.min(100, Math.round(((p - bounds[0]) / span) * 100))
  }

  function farmStageBounds(stage) {
    return ({
      seed: [0, FARM_STAGE.seedling],
      seedling: [FARM_STAGE.seedling, FARM_STAGE.sapling],
      sapling: [FARM_STAGE.sapling, FARM_STAGE.tree],
      tree: [FARM_STAGE.tree, FARM_STAGE.tree]
    })[stage] || [0, FARM_STAGE.seedling]
  }

  function farmStageRank(stage) {
    return ({ seed: 0, seedling: 1, sapling: 2, tree: 3 })[stage] || 0
  }

  function resolveFarmStage(acc, total) {
    if (acc && acc.farmStage && FARM_STAGE.labels[acc.farmStage]) return acc.farmStage
    return farmStageOf(total)
  }

  function updateFarmMilestones(stage) {
    const box = $('farmMilestones')
    if (!box) return
    const rank = farmStageRank(stage)
    box.querySelectorAll('[data-ms]').forEach((el) => {
      const r = farmStageRank(el.dataset.ms)
      el.classList.toggle('on', r === rank)
      el.classList.toggle('done', r < rank)
    })
  }

  function farmStorageKey() {
    const id = state.profile && (state.profile.studentId || state.profile.studentNo)
    return FARM_PTS_PREFIX + (id || 'anon')
  }

  function readFarmSnapshot() {
    try { return JSON.parse(localStorage.getItem(farmStorageKey()) || 'null') } catch (e) { return null }
  }

  function writeFarmSnapshot(total, peak, withered) {
    localStorage.setItem(farmStorageKey(), JSON.stringify({
      lastTotal: total,
      peakTotal: peak,
      withered: !!withered,
      at: Date.now()
    }))
  }

  function farmPulseClass(el, cls, ms) {
    if (!el) return
    el.classList.remove(cls)
    void el.offsetWidth
    el.classList.add(cls)
    clearTimeout(el._farmPulseT)
    el._farmPulseT = setTimeout(() => { el.classList.remove(cls) }, ms)
  }

  /** 农场飞行物：蝴蝶曲线漫游 + 蜜蜂游荡 */
  const farmFly = {
    raf: 0,
    last: 0,
    bfly: {
      x: 148, y: 76, vx: 0, vy: 0,
      tx: 160, ty: 50, rot: 0, face: 1,
      pauseUntil: 0, bob: 0
    },
    bee: {
      x: 64, y: 88, vx: 0, vy: 0,
      tx: 90, ty: 70, rot: 0
    },
    bflyOn: false,
    beeOn: false
  }

  function farmRand(min, max) {
    return min + Math.random() * (max - min)
  }

  function farmPickPoint(wide) {
    const zones = wide
      ? [
        { x: [22, 100], y: [26, 100] },
        { x: [120, 200], y: [24, 95] },
        { x: [35, 185], y: [28, 68] },
        { x: [30, 100], y: [70, 122] },
        { x: [120, 195], y: [70, 120] },
        { x: [70, 150], y: [35, 110] }
      ]
      : [
        { x: [40, 110], y: [55, 115] },
        { x: [100, 175], y: [50, 110] },
        { x: [55, 160], y: [40, 90] }
      ]
    const z = zones[Math.floor(Math.random() * zones.length)]
    return { x: farmRand(z.x[0], z.x[1]), y: farmRand(z.y[0], z.y[1]) }
  }

  function resolveFarmFxMode() {
    const cfg = String((state.config && state.config.farmFxMode) || 'auto')
    if (cfg === 'full' || cfg === 'lite' || cfg === 'off') return cfg
    try {
      if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return 'lite'
    } catch (e) { /* ignore */ }
    const cores = Number(navigator.hardwareConcurrency) || 8
    const mem = Number(navigator.deviceMemory) || 8
    if (cores <= 4 || mem <= 4) return 'lite'
    return 'full'
  }

  function farmFxAllowsCreatures() {
    return state.farmFxResolved === 'full'
  }

  function farmFxAllowsParticles() {
    return state.farmFxResolved === 'full' || state.farmFxResolved === 'lite'
  }

  function applyFarmFxMode() {
    const mode = resolveFarmFxMode()
    state.farmFxResolved = mode
    try { document.documentElement.setAttribute('data-farm-fx', mode) } catch (e) { /* ignore */ }
    if (mode !== 'full') stopFarmCreatures()
    if (mode === 'off' && typeof farmFx !== 'undefined' && farmFx.stop) {
      try { farmFx.stop() } catch (e) { /* ignore */ }
    } else if (mode !== 'off' && $('viewFarm') && !$('viewFarm').hidden && typeof farmFx !== 'undefined') {
      try { farmFx.init() } catch (e) { /* ignore */ }
    }
    if ($('homeFarm') && !$('homeFarm').hidden && state.points) {
      try { renderFarm(state.points) } catch (e) { /* ignore */ }
    }
  }

  function stopFarmCreatures() {
    farmFly.bflyOn = false
    farmFly.beeOn = false
    if (farmFly.raf) {
      cancelAnimationFrame(farmFly.raf)
      farmFly.raf = 0
    }
    farmFly.last = 0
  }

  function steerToward(agent, tx, ty, maxSpeed, steer, dt) {
    const dx = tx - agent.x
    const dy = ty - agent.y
    const dist = Math.hypot(dx, dy) || 1
    const desiredX = (dx / dist) * maxSpeed
    const desiredY = (dy / dist) * maxSpeed
    agent.vx += (desiredX - agent.vx) * steer * dt
    agent.vy += (desiredY - agent.vy) * steer * dt
    // 阻尼，避免螺旋
    agent.vx *= 1 - Math.min(0.35, 0.12 * dt)
    agent.vy *= 1 - Math.min(0.35, 0.12 * dt)
    agent.x += agent.vx * dt * 60
    agent.y += agent.vy * dt * 60
    return dist
  }

  function tickFarmCreatures(now) {
    if (!farmFly.bflyOn && !farmFly.beeOn) {
      farmFly.raf = 0
      return
    }
    const last = farmFly.last || now
    let dt = (now - last) / 1000
    farmFly.last = now
    if (dt > 0.05) dt = 0.05
    if (dt <= 0) dt = 0.016

    if (farmFly.bflyOn) {
      const b = farmFly.bfly
      const el = $('farmButterfly')
      if (el) {
        if (b.pauseUntil && now < b.pauseUntil) {
          b.vx *= 0.9
          b.vy *= 0.9
          b.bob += dt * 5
          b.x += Math.sin(b.bob) * 0.15
          b.y += Math.cos(b.bob * 1.3) * 0.2
        } else {
          b.pauseUntil = 0
          let dist = steerToward(b, b.tx, b.ty, farmRand(1.1, 1.9), 2.4, dt)
          // 正弦起伏，更像扑翅轨迹
          b.bob += dt * (3.2 + Math.abs(b.vx))
          b.y += Math.sin(b.bob) * 0.55
          if (dist < 8) {
            const p = farmPickPoint(true)
            b.tx = p.x
            b.ty = p.y
            if (Math.random() < 0.22) b.pauseUntil = now + farmRand(500, 1400)
          }
          // 偶尔中途改道，轨迹更随机
          if (Math.random() < 0.008) {
            const p = farmPickPoint(true)
            b.tx = p.x
            b.ty = p.y
          }
        }
        if (Math.abs(b.vx) > 0.08) b.face = b.vx < 0 ? -1 : 1
        b.rot += ((b.vx * 10) - b.rot) * Math.min(1, 6 * dt)
        const flap = Math.min(0.22, 0.28 - Math.min(0.12, Math.hypot(b.vx, b.vy) * 0.04))
        el.style.setProperty('--bfly-flap', flap.toFixed(2) + 's')
        el.setAttribute('transform',
          'translate(' + b.x.toFixed(2) + ' ' + b.y.toFixed(2) +
          ') rotate(' + b.rot.toFixed(2) + ') scale(' + b.face + ' 1)')
      }
    }

    if (farmFly.beeOn) {
      const bee = farmFly.bee
      const el = $('farmBee')
      if (el) {
        let dist = steerToward(bee, bee.tx, bee.ty, farmRand(0.9, 1.5), 2.0, dt)
        bee.y += Math.sin(now * 0.008) * 0.25
        if (dist < 7) {
          const p = farmPickPoint(false)
          bee.tx = p.x
          bee.ty = p.y
        }
        if (Math.random() < 0.01) {
          const p = farmPickPoint(false)
          bee.tx = p.x
          bee.ty = p.y
        }
        bee.rot += ((bee.vx * 8) - bee.rot) * Math.min(1, 5 * dt)
        el.setAttribute('transform',
          'translate(' + bee.x.toFixed(2) + ' ' + bee.y.toFixed(2) +
          ') rotate(' + bee.rot.toFixed(2) + ')')
      }
    }

    farmFly.raf = requestAnimationFrame(tickFarmCreatures)
  }

  function ensureFarmLoop() {
    if (farmFly.raf) return
    if (!farmFly.bflyOn && !farmFly.beeOn) return
    if (!farmFxAllowsCreatures()) return
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
    farmFly.last = 0
    farmFly.raf = requestAnimationFrame(tickFarmCreatures)
  }

  function syncButterflyFlight(visible) {
    visible = !!visible && farmFxAllowsCreatures()
    farmFly.bflyOn = !!visible
    if (visible) {
      const b = farmFly.bfly
      if (!b._inited) {
        const p = farmPickPoint(true)
        b.x = p.x
        b.y = p.y
        const t = farmPickPoint(true)
        b.tx = t.x
        b.ty = t.y
        b._inited = true
      }
      ensureFarmLoop()
    } else if (!farmFly.beeOn) {
      stopFarmCreatures()
    }
  }

  function syncBeeFlight(visible) {
    visible = !!visible && farmFxAllowsCreatures()
    farmFly.beeOn = !!visible
    if (visible) {
      const bee = farmFly.bee
      if (!bee._inited) {
        const p = farmPickPoint(false)
        bee.x = p.x
        bee.y = p.y
        const t = farmPickPoint(false)
        bee.tx = t.x
        bee.ty = t.y
        bee._inited = true
      }
      ensureFarmLoop()
    } else if (!farmFly.bflyOn) {
      stopFarmCreatures()
    }
  }

  function stopButterflyFlight() {
    stopFarmCreatures()
  }

  function renderFarm(data) {
    const panel = $('homeFarm')
    const scene = $('farmScene')
    if (!panel || !scene) return
    if (isStaffMode()) {
      panel.hidden = true
      return
    }
    panel.hidden = false
    const acc = data && data.account
    const total = (acc && acc.totalPoints) || 0
    const stage = resolveFarmStage(acc, total)
    const snapRaw = readFarmSnapshot()
    const hasSnap = !!snapRaw
    const snap = snapRaw || { lastTotal: total, peakTotal: total, withered: false }
    // 兼容旧快照缺 peakTotal：用 lastTotal 兜底
    const priorPeak = Math.max(
      0,
      Number(snap.peakTotal) || 0,
      Number(snap.lastTotal) || 0
    )
    const peak = Math.max(priorPeak, total)
    const wasWithered = !!snap.withered
    // 相对上次掉分 → 枯萎；攒回历史峰值（含持平）即复绿。萌芽仅隐藏枯萎 UI，不改写逻辑态
    let withered = wasWithered
    if (hasSnap && snap.lastTotal != null && total < Number(snap.lastTotal)) withered = true
    if (priorPeak > 0 && total >= priorPeak) withered = false
    const showWither = withered && stage !== 'seed'

    const prevStage = scene.dataset.stage || ''
    const stageChanged = !!prevStage && prevStage !== stage
    const witherJustOn = withered && !wasWithered
    const recoverJustOn = !withered && wasWithered
    const gained = hasSnap && snap.lastTotal != null && total > Number(snap.lastTotal)
    const stagePct = farmStageProgress(total, stage)
    const needToPeak = Math.max(0, peak - total)

    scene.dataset.stage = stage
    scene.classList.toggle('is-bloom', stage === 'sapling' && stagePct >= 55)
    scene.style.setProperty('--farm-p', String((stage === 'tree' ? 100 : stagePct) / 100))
    panel.classList.toggle('is-wither', showWither)
    // 浮叶+/花蕾+：蝴蝶与蜜蜂（仅完整特效档）
    const allowCritters = farmFxAllowsCreatures()
    syncButterflyFlight(allowCritters && !showWither && stage !== 'seed')
    syncBeeFlight(allowCritters && !showWither && (stage === 'sapling' || stage === 'tree'))

    const stageText = showWither ? (farmStageLabel(stage) + ' · 枯萎') : farmStageLabel(stage)
    let caption = ''
    if (data && data._loadError) caption = '积分加载失败，刷新后重试'
    else if (showWither && gained) {
      caption = '叶子还在枯着；再攒 ' + needToPeak + ' 分回到最高分就会复绿'
    } else if (showWither) {
      caption = '积分减少，叶子枯萎了；攒回最高分（' + peak + '）就会重新变绿'
    } else if (withered && stage === 'seed') {
      caption = '积分偏低；攒回最高分（' + peak + '）后叶子才会再绿'
    } else if (recoverJustOn) caption = '叶子重新变绿了！继续加油'
    else if (gained && !stageChanged) {
      caption = '积分增加，' + farmStageLabel(stage) + '又茁壮了一点'
    } else caption = farmNextHint(total, stage)

    if ($('farmStageLabel')) {
      const label = $('farmStageLabel')
      if (label.textContent !== stageText) {
        label.textContent = stageText
        if (stageChanged || (witherJustOn && showWither) || recoverJustOn) {
          farmPulseClass(label, 'is-pop', 560)
        }
      }
    }
    if ($('farmCaption')) {
      const cap = $('farmCaption')
      if (cap.textContent !== caption) {
        cap.textContent = caption
        farmPulseClass(cap, 'is-swap', 480)
      }
    }
    if ($('farmPtsChip')) {
      const chip = $('farmPtsChip')
      const nextTxt = total + ' 分'
      if (chip.textContent !== nextTxt) {
        chip.textContent = nextTxt
        if (gained) farmPulseClass(chip, 'is-bump', 480)
      }
    }
    // 进度条与「当前/下一阶段门槛」一致（阶段内进度；跨阶段重置是预期）
    const fillPct = stage === 'tree' ? 100 : (total > 0 ? Math.max(4, stagePct) : 0)
    if ($('farmProgressFill')) {
      $('farmProgressFill').style.width = fillPct + '%'
    }
    const bounds = farmStageBounds(stage)
    const toNext = acc && acc.pointsToNextFarmStage != null
      ? Number(acc.pointsToNextFarmStage)
      : Math.max(0, bounds[1] - total)
    if ($('farmProgressLabel')) {
      $('farmProgressLabel').textContent = stage === 'tree'
        ? (showWither ? '保持生机' : '已盛放')
        : ('距' + (stage === 'seed' ? '浮叶' : (stage === 'seedling' ? '花蕾' : '盛放')) +
          (toNext > 0 ? ' · 差 ' + toNext : ''))
    }
    if ($('farmProgressNums')) {
      $('farmProgressNums').textContent = stage === 'tree'
        ? (total + ' 分')
        : (total + ' / ' + bounds[1])
    }
    updateFarmMilestones(stage)
    updateFarmMilestoneHints()

    // 升级生长：弹跳 + 光点
    if (stageChanged && !showWither) {
      farmPulseClass(scene, 'is-grow', 950)
    } else if (gained && !showWither) {
      farmPulseClass(panel, 'is-gain', 850)
      farmPulseClass(scene, 'is-grow', 700)
    }
    if (witherJustOn && showWither) {
      farmPulseClass(panel, 'is-wither-enter', 700)
    }
    if (recoverJustOn) {
      farmPulseClass(panel, 'is-recover', 1100)
      farmPulseClass(scene, 'is-grow', 900)
    }

    writeFarmSnapshot(total, peak, withered)
  }

  function cheerFarm() {
    if (isStaffMode()) return
    const panel = $('homeFarm')
    const scene = $('farmScene')
    if (!panel || panel.hidden || !scene) return
    farmPulseClass(panel, 'is-cheer', 560)
    if (!panel.classList.contains('is-wither')) farmPulseClass(scene, 'is-grow', 750)
    const cap = $('farmCaption')
    if (cap && !panel.classList.contains('is-wither')) {
      const tips = ['阳光正好，继续练习吧', '植物在点头鼓励你', '再练一练，长得更快', '农场等你回来浇水（用练习）']
      cap.textContent = tips[Math.floor(Math.random() * tips.length)]
      farmPulseClass(cap, 'is-swap', 480)
    }
  }

  /**
   * 标准等距菱形（平行四边形）。勿再对单侧加 shear，否则农田会「变形」。
   * W:H ≈ 2.7:1：再压纵深，北尖下移，贴近农舍平视而非俯视尖顶。
   */
  const ISO_TILE_W = 98
  const ISO_TILE_H = 36
  const ISO_PLOT_RX = 26
  const ISO_PLOT_RY = 12

  function isoTileXY(col, r) {
    const halfW = ISO_TILE_W / 2
    const halfH = ISO_TILE_H / 2
    const c = Number(col) || 0
    const row = Number(r) || 0
    return {
      x: (c - row) * halfW,
      y: (c + row) * halfH
    }
  }

  function classFarmCols(n) {
    if (n <= 1) return 1
    if (n <= 12) return 4
    if (n <= 20) return 5
    if (n <= 30) return 6
    if (n <= 42) return 7
    if (n <= 56) return 7
    return 8
  }

  /** 轻量合成音效（无需音频文件） */
  const farmAudio = {
    ctx: null,
    ensure() {
      if (isAudioMuted()) return null
      const AC = window.AudioContext || window.webkitAudioContext
      if (!AC) return null
      if (!this.ctx) this.ctx = new AC()
      if (this.ctx.state === 'suspended') this.ctx.resume()
      return this.ctx
    },
    beep(freq, dur, type, vol) {
      try {
        const ctx = this.ensure()
        if (!ctx) return
        const t0 = ctx.currentTime
        const o = ctx.createOscillator()
        const g = ctx.createGain()
        o.type = type || 'sine'
        o.frequency.setValueAtTime(freq, t0)
        g.gain.setValueAtTime(0.0001, t0)
        g.gain.exponentialRampToValueAtTime(vol || 0.06, t0 + 0.012)
        g.gain.exponentialRampToValueAtTime(0.0001, t0 + dur)
        o.connect(g)
        g.connect(ctx.destination)
        o.start(t0)
        o.stop(t0 + dur + 0.02)
      } catch (_) {}
    },
    tap() {
      this.beep(920, 0.09, 'triangle', 0.05)
      setTimeout(() => this.beep(620, 0.07, 'sine', 0.035), 40)
    },
    water() {
      this.beep(520, 0.05, 'sine', 0.03)
      setTimeout(() => this.beep(780, 0.08, 'triangle', 0.04), 30)
      setTimeout(() => this.beep(420, 0.1, 'sine', 0.025), 70)
    },
    refresh() {
      this.beep(660, 0.08, 'triangle', 0.04)
      setTimeout(() => this.beep(880, 0.1, 'sine', 0.045), 60)
      setTimeout(() => this.beep(1100, 0.12, 'triangle', 0.035), 120)
    }
  }

  /** 农场粒子 / 飞分 / 浇水（Canvas，叠在视口上） */
  const farmFx = {
    canvas: null,
    ctx: null,
    parts: [],
    floats: [],
    raf: 0,
    last: 0,
    reduced: false,
    ambientTimer: 0,
    init() {
      const vp = $('classFarmViewport')
      this.canvas = $('classFarmFx')
      this.dom = $('classFarmFxDom')
      if (!vp) return
      // 确保特效层在 world 之后，避免被草地盖住
      if (this.canvas && this.canvas.parentNode !== vp) vp.appendChild(this.canvas)
      else if (this.canvas) vp.appendChild(this.canvas)
      if (this.dom && this.dom.parentNode !== vp) vp.appendChild(this.dom)
      else if (this.dom) vp.appendChild(this.dom)
      if (!this.canvas) return
      this.ctx = this.canvas.getContext('2d')
      this.reduced = state.farmFxResolved === 'off'
      this.resize()
      if (farmFxAllowsCreatures()) this.startAmbient()
      else this.stopAmbient()
    },
    resize() {
      const vp = $('classFarmViewport')
      if (!this.canvas || !vp) return
      const dpr = Math.min(window.devicePixelRatio || 1, 2)
      const w = Math.max(1, vp.clientWidth || 800)
      const h = Math.max(1, vp.clientHeight || 500)
      this.canvas.width = Math.round(w * dpr)
      this.canvas.height = Math.round(h * dpr)
      this.canvas.style.width = w + 'px'
      this.canvas.style.height = h + 'px'
      this.canvas.style.zIndex = '80'
      if (this.ctx) this.ctx.setTransform(dpr, 0, 0, dpr, 0, 0)
    },
    /** DOM 保底特效：不依赖 Canvas 层级也能看见 */
    domBurst(x, y, label) {
      const layer = this.dom || $('classFarmFxDom')
      if (!layer) return
      const ring = document.createElement('i')
      ring.className = 'fx-ring'
      ring.style.left = x + 'px'
      ring.style.top = y + 'px'
      layer.appendChild(ring)
      for (let i = 0; i < 10; i++) {
        const d = document.createElement('i')
        d.className = 'fx-dot'
        const ang = (Math.PI * 2 * i) / 10
        d.style.left = x + 'px'
        d.style.top = y + 'px'
        d.style.background = (i % 2) ? '#38bdf8' : '#fde047'
        d.style.setProperty('--dx', Math.round(Math.cos(ang) * 28) + 'px')
        d.style.setProperty('--dy', Math.round(Math.sin(ang) * 22 - 16) + 'px')
        layer.appendChild(d)
      }
      if (label) {
        const t = document.createElement('b')
        t.className = 'fx-float'
        t.textContent = label
        t.style.left = x + 'px'
        t.style.top = (y - 10) + 'px'
        layer.appendChild(t)
      }
      window.setTimeout(() => {
        try { while (layer.childNodes.length > 40) layer.removeChild(layer.firstChild) } catch (_) {}
      }, 900)
      window.setTimeout(() => {
        ;[ring].forEach((n) => { try { n.remove() } catch (_) {} })
      }, 800)
    },
    vpPointFromEl(el) {
      const vp = $('classFarmViewport')
      if (!vp || !el) return null
      const vr = vp.getBoundingClientRect()
      const er = el.getBoundingClientRect()
      return {
        x: er.left + er.width / 2 - vr.left,
        y: er.top + er.height * 0.35 - vr.top
      }
    },
    pushPart(p) {
      this.parts.push(p)
      if (this.parts.length > 180) this.parts.splice(0, this.parts.length - 180)
    },
    burst(x, y, opt) {
      if (!farmFxAllowsParticles()) return
      if (this.reduced || !this.ctx) return
      const base = (opt && opt.count) || 18
      const n = Math.min(48, state.farmFxResolved === 'lite' ? Math.ceil(base * 0.45) : base)
      const colors = (opt && opt.colors) || ['#fde047', '#86efac', '#f9a8d4', '#fdba74', '#fff']
      const soft = !!(opt && opt.soft)
      for (let i = 0; i < n; i++) {
        const a = Math.random() * Math.PI * 2
        const sp = (soft ? 18 : 40) + Math.random() * (soft ? 36 : 90)
        this.pushPart({
          kind: soft ? 'soft' : 'spark',
          x, y,
          vx: Math.cos(a) * sp,
          vy: Math.sin(a) * sp - (soft ? 12 : 30),
          g: (soft ? 40 : 120) + Math.random() * 50,
          life: (soft ? 0.7 : 0.45) + Math.random() * 0.45,
          age: 0,
          r: (soft ? 1.2 : 1.6) + Math.random() * 2.2,
          color: colors[i % colors.length]
        })
      }
      this.start()
    },
    /** 浇水：上方落滴 + 着地水花 */
    waterAt(el) {
      if (this.reduced || !this.ctx) return
      const p = this.vpPointFromEl(el)
      if (!p) return
      for (let i = 0; i < 16; i++) {
        this.pushPart({
          kind: 'water',
          x: p.x + (Math.random() - 0.5) * 18,
          y: p.y - 34 - Math.random() * 22,
          vx: (Math.random() - 0.5) * 22,
          vy: 50 + Math.random() * 55,
          g: 200,
          life: 0.42 + Math.random() * 0.28,
          age: 0,
          r: 1.6 + Math.random() * 1.8,
          color: Math.random() > 0.45 ? '#38bdf8' : '#7dd3fc'
        })
      }
      for (let i = 0; i < 12; i++) {
        const a = (Math.PI * 1.15) + Math.random() * Math.PI * 0.7
        const sp = 35 + Math.random() * 55
        this.pushPart({
          kind: 'splash',
          x: p.x, y: p.y + 6,
          vx: Math.cos(a) * sp,
          vy: Math.sin(a) * sp * 0.55 - 20,
          g: 160,
          life: 0.35 + Math.random() * 0.25,
          age: 0,
          r: 1.4 + Math.random() * 1.6,
          color: '#bae6fd'
        })
      }
      this.start()
    },
    floatText(x, y, text, color) {
      if (this.reduced || !this.ctx) return
      this.floats.push({
        x, y, text: String(text || ''),
        color: color || '#854d0e',
        age: 0, life: 1.15
      })
      if (this.floats.length > 24) this.floats.shift()
      this.start()
    },
    sparkAt(el, label) {
      const p = this.vpPointFromEl(el)
      if (!p) return
      this.burst(p.x, p.y, { count: 20 })
      if (label) this.floatText(p.x, p.y - 8, label, '#ca8a04')
    },
    /** 点选反馈：轻弹跳 + 短飞字（不是浇水涨分） */
    selectAt(el, label) {
      if (!el) return
      el.classList.remove('is-pop')
      el.classList.remove('is-spark')
      void el.offsetWidth
      el.classList.add('is-pop')
      el.classList.add('is-spark')
      window.setTimeout(() => {
        try { el.classList.remove('is-spark') } catch (_) {}
      }, 520)
      if (!farmFxAllowsParticles()) return
      const p = this.vpPointFromEl(el)
      if (!p) return
      if (!this.canvas || !this.ctx) this.init()
      else this.resize()
      this.burst(p.x, p.y - 6, {
        count: 8,
        soft: true,
        colors: ['#fde047', '#86efac', '#fff']
      })
      if (label) this.floatText(p.x, p.y - 14, label, '#0f766e')
    },
    /** 浇水完整反馈（双击 / 鼓励专用） */
    interactAt(el, label) {
      if (!el) return
      const p = this.vpPointFromEl(el) || { x: 120, y: 120 }
      el.classList.remove('is-water')
      el.classList.remove('is-spark')
      void el.offsetWidth
      el.classList.add('is-water')
      el.classList.add('is-spark')
      window.setTimeout(() => {
        try {
          el.classList.remove('is-water')
          el.classList.remove('is-spark')
        } catch (_) {}
      }, 750)
      if (!farmFxAllowsParticles()) return
      if (!this.canvas || !this.ctx) this.init()
      else this.resize()
      this.domBurst(p.x, p.y, label || '浇水')
      if (state.farmFxResolved === 'full') {
        this.waterAt(el)
        this.sparkAt(el, label || '浇水')
      }
    },
    startAmbient() {
      this.stopAmbient()
      if (this.reduced) return
      if (!farmFxAllowsCreatures()) return
      this.ambientTimer = window.setInterval(() => {
        const farmView = $('viewFarm')
        if (!farmView || farmView.hidden) return
        const grid = $('classFarmGrid')
        if (!grid) return
        const plots = grid.querySelectorAll('.iso-plot:not(.is-ghost)')
        if (!plots.length) return
        const me = grid.querySelector('.iso-plot.me')
        const el = (Math.random() < 0.6 && me) ? me : plots[(Math.random() * plots.length) | 0]
        const p = this.vpPointFromEl(el)
        if (!p) return
        this.burst(p.x, p.y - 8, {
          count: 5 + ((Math.random() * 4) | 0),
          soft: true,
          colors: ['#bbf7d0', '#fef08a', '#fda4af', '#fff']
        })
      }, 2600)
    },
    stopAmbient() {
      if (this.ambientTimer) {
        clearInterval(this.ambientTimer)
        this.ambientTimer = 0
      }
    },
    start() {
      if (this.raf || this.reduced) return
      this.last = performance.now()
      const loop = (t) => {
        this.raf = requestAnimationFrame(loop)
        const dt = Math.min(0.033, (t - this.last) / 1000)
        this.last = t
        this.tick(dt)
      }
      this.raf = requestAnimationFrame(loop)
    },
    stop() {
      this.stopAmbient()
      if (this.raf) cancelAnimationFrame(this.raf)
      this.raf = 0
      this.parts.length = 0
      this.floats.length = 0
      if (this.ctx && this.canvas) {
        this.ctx.clearRect(0, 0, this.canvas.clientWidth || 0, this.canvas.clientHeight || 0)
      }
    },
    tick(dt) {
      if (!this.ctx || !this.canvas) return
      const w = this.canvas.clientWidth
      const h = this.canvas.clientHeight
      this.ctx.clearRect(0, 0, w, h)
      for (let i = this.parts.length - 1; i >= 0; i--) {
        const p = this.parts[i]
        p.age += dt
        if (p.age >= p.life) { this.parts.splice(i, 1); continue }
        p.vy += p.g * dt
        p.x += p.vx * dt
        p.y += p.vy * dt
        p.vx *= p.kind === 'water' ? 0.995 : 0.98
        const k = 1 - p.age / p.life
        this.ctx.globalAlpha = Math.max(0, k)
        this.ctx.fillStyle = p.color
        if (p.kind === 'water') {
          this.ctx.beginPath()
          this.ctx.ellipse(p.x, p.y, p.r * 0.55, p.r * (0.9 + k * 0.4), 0, 0, Math.PI * 2)
          this.ctx.fill()
        } else if (p.kind === 'spark') {
          const rr = p.r * (0.5 + k * 0.6)
          this.ctx.beginPath()
          this.ctx.moveTo(p.x, p.y - rr)
          this.ctx.lineTo(p.x + rr * 0.45, p.y)
          this.ctx.lineTo(p.x, p.y + rr)
          this.ctx.lineTo(p.x - rr * 0.45, p.y)
          this.ctx.closePath()
          this.ctx.fill()
        } else {
          this.ctx.beginPath()
          this.ctx.arc(p.x, p.y, p.r * (0.55 + k * 0.5), 0, Math.PI * 2)
          this.ctx.fill()
        }
      }
      this.ctx.globalAlpha = 1
      this.ctx.font = '800 13px system-ui,sans-serif'
      this.ctx.textAlign = 'center'
      for (let i = this.floats.length - 1; i >= 0; i--) {
        const f = this.floats[i]
        f.age += dt
        if (f.age >= f.life) { this.floats.splice(i, 1); continue }
        const k = 1 - f.age / f.life
        const yy = f.y - f.age * 40
        this.ctx.globalAlpha = k
        this.ctx.lineWidth = 3
        this.ctx.strokeStyle = 'rgba(255,255,255,.88)'
        this.ctx.strokeText(f.text, f.x, yy)
        this.ctx.fillStyle = f.color
        this.ctx.fillText(f.text, f.x, yy)
      }
      this.ctx.globalAlpha = 1
      if (!this.parts.length && !this.floats.length) {
        cancelAnimationFrame(this.raf)
        this.raf = 0
      }
    }
  }

  /**
   * 班级田作物：四阶段轮廓拉开（半埋豆芽 / 横展浮叶 / 细茎花蕾 / 圆冠盛放）。
   */
  function classFarmCropHtml(stage, idx, mine, totalPoints) {
    const s = stage || 'seed'
    const i = idx || 0
    const delay = (i % 14) / 10
    const frameDur = (0.72 + (i % 5) * 0.09).toFixed(2)
    const prog = farmStageProgress(totalPoints || 0, s) / 100
    const jitter = 0.94 + (i % 5) * 0.03
    const tilt = ((i % 7) - 3) * 1.2
    let boost = (0.92 + prog * 0.2) * jitter * (mine ? 1.1 : 1)
    if (s === 'seed') boost *= 1.05
    if (s === 'seedling') boost *= 1.12
    if (s === 'sapling') boost *= 1.14
    if (s === 'tree') boost *= 1.3
    boost = Math.round(boost * 100) / 100
    const style = ' style="--sway-delay:' + delay + 's;--crop-boost:' + boost +
      ';--frame-dur:' + frameDur + 's;--crop-tilt:' + tilt + 'deg"'
    const bug = s === 'tree' && (mine || i % 9 === 2)
      ? '<span class="crop-bug" aria-hidden="true"></span>'
      : ''
    const live = mine ? ' is-live-me' : ' is-live'
    const uid = String(i)

    // 萌芽：豆粒坐在坑心，芽尖刚露出；不自带土丘以免掉到坑沿外
    if (s === 'seed') {
      return '<div class="iso-crop is-pulse' + live + '" data-stage="seed"' + style + '>' +
        '<svg class="crop-svg" viewBox="0 0 24 18" focusable="false">' +
          '<defs>' +
            '<radialGradient id="seedG' + uid + '" cx="36%" cy="32%" r="68%">' +
              '<stop offset="0%" stop-color="#ffe8a3"/><stop offset="55%" stop-color="#d97706"/>' +
              '<stop offset="100%" stop-color="#78350f"/></radialGradient>' +
          '</defs>' +
          '<ellipse cx="12" cy="15.2" rx="5.2" ry="1.35" fill="#1c0f08" opacity=".28"/>' +
          '<g class="seed-core" transform="translate(12 12.2)">' +
            '<ellipse cx="0" cy="0" rx="4.4" ry="3.1" fill="url(#seedG' + uid + ')"/>' +
            '<path d="M-4.2 0.15c1.35 1.5 3.2 2.2 4.2 2.2s2.85-.7 4.2-2.2" fill="#451a03" opacity=".28"/>' +
            '<ellipse cx="-1.2" cy="-0.95" rx="1.45" ry=".75" fill="#fff7d6" opacity=".78"/>' +
            '<path d="M0-2.7c.15.9.2 1.8.08 2.6" fill="none" stroke="#92400e" stroke-width=".65" opacity=".45"/>' +
          '</g>' +
          '<g class="sprout-tip">' +
            '<path d="M12 9.4v-3.1" fill="none" stroke="#65a30d" stroke-width="1.15" stroke-linecap="round"/>' +
            '<path d="M12 7.3c-1.55-.12-2.4-1.05-2.15-1.9.75.08 1.55.48 2.15 1.05z" fill="#84cc16"/>' +
            '<path d="M12 7.15c1.5-.1 2.35-1 2.1-1.85-.75.08-1.5.48-2.1 1.05z" fill="#4d7c0f"/>' +
          '</g>' +
        '</svg></div>'
    }

    // 浮叶：细茎 + 两片横向大叶（读成「叶子」而非小树）
    if (s === 'seedling') {
      return '<div class="iso-crop is-sway' + live + '" data-stage="seedling"' + style + '>' +
        '<svg class="crop-svg" viewBox="0 0 42 30" focusable="false">' +
          '<defs>' +
            '<linearGradient id="leafLG' + uid + '" x1="0" y1=".5" x2="1" y2=".5">' +
              '<stop offset="0%" stop-color="#bbf7d0"/><stop offset="100%" stop-color="#16a34a"/></linearGradient>' +
            '<linearGradient id="leafRG' + uid + '" x1="1" y1=".5" x2="0" y2=".5">' +
              '<stop offset="0%" stop-color="#86efac"/><stop offset="100%" stop-color="#15803d"/></linearGradient>' +
          '</defs>' +
          '<ellipse cx="21" cy="27.8" rx="6.5" ry="1.8" fill="#451a03" opacity=".28"/>' +
          '<path class="stem" d="M20.4 26.8c.1-5.5.2-11 .35-15.2h1.1c.15 4.2.3 9.7.45 15.2z" fill="#166534"/>' +
          '<g class="leaf-pair">' +
            '<ellipse class="leaf leaf-l" cx="11.5" cy="12.2" rx="10.2" ry="4.6" transform="rotate(-18 11.5 12.2)" fill="url(#leafLG' + uid + ')"/>' +
            '<ellipse class="leaf leaf-r" cx="30.5" cy="12.6" rx="10" ry="4.4" transform="rotate(16 30.5 12.6)" fill="url(#leafRG' + uid + ')"/>' +
            '<path d="M12 12.2c3 0 6.2 1.2 9 3.4" fill="none" stroke="#ecfdf5" stroke-width=".9" opacity=".5"/>' +
            '<path d="M30 12.6c-3 0-6.2 1.1-8.8 3.2" fill="none" stroke="#ecfdf5" stroke-width=".85" opacity=".4"/>' +
            '<ellipse cx="8.8" cy="10.6" rx="1.6" ry=".7" fill="#fff" opacity=".35"/>' +
            '<circle cx="21" cy="11.5" r="1.6" fill="#86efac"/>' +
          '</g>' +
        '</svg></div>'
    }

    // 花蕾：细木茎 + 少量小叶 + 大号闭合粉蕾为主角（绝不能再像绿树）
    if (s === 'sapling') {
      return '<div class="iso-crop is-sway' + live + '" data-stage="sapling"' + style + '>' +
        '<svg class="crop-svg" viewBox="0 0 36 40" focusable="false">' +
          '<defs>' +
            '<radialGradient id="budG' + uid + '" cx="40%" cy="30%" r="70%">' +
              '<stop offset="0%" stop-color="#fce7f3"/><stop offset="40%" stop-color="#f472b6"/>' +
              '<stop offset="100%" stop-color="#9d174d"/></radialGradient>' +
            '<radialGradient id="budG2' + uid + '" cx="40%" cy="30%" r="70%">' +
              '<stop offset="0%" stop-color="#fae8ff"/><stop offset="50%" stop-color="#e879f9"/>' +
              '<stop offset="100%" stop-color="#a21caf"/></radialGradient>' +
          '</defs>' +
          '<ellipse cx="18" cy="37.6" rx="6.8" ry="1.9" fill="#451a03" opacity=".3"/>' +
          '<path class="stem" d="M16.9 36.2c.2-9 .4-17.5.6-23.2h1.35c.2 5.7.4 14.2.6 23.2z" fill="#92400e"/>' +
          '<path d="M18.4 36.2c.15-9 .3-17.5.45-23.2h1.2c.25 5.7.5 14.2.75 23.2z" fill="#a16207"/>' +
          '<g class="leaf-pair">' +
            '<path class="leaf leaf-l" d="M17.5 22c-5.5.2-8.5-3.2-7.8-6.8 2.6.6 5 2.4 7.8 6.8z" fill="#4ade80"/>' +
            '<path class="leaf leaf-r" d="M19 21.5c5.2.2 8-3 7.4-6.5-2.5.6-4.8 2.2-7.4 6.5z" fill="#166534"/>' +
          '</g>' +
          '<g class="bud-cluster">' +
            '<ellipse class="bud" cx="18.2" cy="12.2" rx="4.4" ry="6.2" fill="url(#budG' + uid + ')"/>' +
            '<ellipse cx="18.2" cy="9.8" rx="1.8" ry="2.2" fill="#fdf2f8" opacity=".8"/>' +
            '<path d="M18.2 6.2v-2.8" fill="none" stroke="#9d174d" stroke-width=".85" stroke-linecap="round" opacity=".55"/>' +
            '<ellipse class="bud" cx="11.2" cy="14.8" rx="2.8" ry="3.8" fill="url(#budG2' + uid + ')"/>' +
            '<ellipse class="bud" cx="25.2" cy="15.4" rx="2.5" ry="3.4" fill="#fb7185"/>' +
            '<ellipse cx="25.2" cy="14" rx=".9" ry="1.1" fill="#ffe4e6" opacity=".7"/>' +
          '</g>' +
        '</svg></div>'
    }

    // 盛放：树干相对稳，树冠整体摇；果实挂在树冠组内一起动
    const fruitShift = (i % 3) - 1
    const fx = (x) => (x + fruitShift)
    return '<div class="iso-crop is-sway' + live + '" data-stage="tree"' + style + '>' + bug +
      '<svg class="crop-svg" viewBox="0 0 48 44" focusable="false">' +
        '<defs>' +
          '<radialGradient id="treeG' + uid + '" cx="38%" cy="28%" r="72%">' +
            '<stop offset="0%" stop-color="#bbf7d0"/><stop offset="42%" stop-color="#22c55e"/>' +
            '<stop offset="100%" stop-color="#14532d"/></radialGradient>' +
          '<radialGradient id="frRed' + uid + '" cx="35%" cy="30%" r="70%">' +
            '<stop offset="0%" stop-color="#fecaca"/><stop offset="55%" stop-color="#ef4444"/>' +
            '<stop offset="100%" stop-color="#991b1b"/></radialGradient>' +
          '<radialGradient id="frOrg' + uid + '" cx="35%" cy="30%" r="70%">' +
            '<stop offset="0%" stop-color="#ffedd5"/><stop offset="55%" stop-color="#f97316"/>' +
            '<stop offset="100%" stop-color="#c2410c"/></radialGradient>' +
          '<radialGradient id="frYel' + uid + '" cx="35%" cy="30%" r="70%">' +
            '<stop offset="0%" stop-color="#fef9c3"/><stop offset="55%" stop-color="#eab308"/>' +
            '<stop offset="100%" stop-color="#a16207"/></radialGradient>' +
        '</defs>' +
        '<ellipse cx="24" cy="41" rx="10.5" ry="2.6" fill="#451a03" opacity=".34"/>' +
        '<g class="trunk">' +
          '<path class="stem" d="M21.2 39c.45-8.5.9-16.5 1.3-22.5h2.1c.25 6 .55 14 .9 22.5z" fill="#78350f"/>' +
          '<path d="M24.2 39c.4-8.5.8-16.5 1.15-22.5h2c.45 6 .85 14 1.25 22.5z" fill="#a16207"/>' +
        '</g>' +
        '<g class="canopy">' +
          '<ellipse class="leaf leaf-l" cx="14" cy="18" rx="11.5" ry="8.2" fill="#4ade80"/>' +
          '<ellipse class="leaf leaf-r" cx="34" cy="18.8" rx="11" ry="7.8" fill="#166534"/>' +
          '<ellipse class="leaf leaf-top" cx="24" cy="9.5" rx="12.5" ry="9" fill="url(#treeG' + uid + ')"/>' +
          '<ellipse cx="18.5" cy="6.8" rx="4" ry="2.2" fill="#fff" opacity=".22"/>' +
          '<g class="fruit-cluster">' +
            '<line class="fruit-stem" x1="' + fx(16) + '" y1="18.2" x2="' + fx(16) + '" y2="19.4" stroke="#166534" stroke-width=".55" opacity=".55"/>' +
            '<circle class="fruit f1" cx="' + fx(16) + '" cy="21" r="2.35" fill="url(#frRed' + uid + ')"/>' +
            '<line class="fruit-stem" x1="' + fx(32) + '" y1="16.6" x2="' + fx(32) + '" y2="17.7" stroke="#166534" stroke-width=".5" opacity=".5"/>' +
            '<circle class="fruit f2" cx="' + fx(32) + '" cy="19.2" r="2.15" fill="url(#frOrg' + uid + ')"/>' +
            '<line class="fruit-stem" x1="24" y1="10.6" x2="24" y2="11.7" stroke="#166534" stroke-width=".5" opacity=".5"/>' +
            '<circle class="fruit f3" cx="24" cy="13.2" r="2.05" fill="url(#frYel' + uid + ')"/>' +
            '<circle class="fruit f4" cx="20" cy="17.5" r="1.7" fill="url(#frRed' + uid + ')"/>' +
            '<circle class="fruit f5" cx="28.5" cy="16.8" r="1.65" fill="url(#frOrg' + uid + ')"/>' +
            '<circle class="fruit f6" cx="13.5" cy="15.5" r="1.4" fill="#dc2626"/>' +
            '<ellipse class="fruit-shine" cx="' + (fx(16) - 0.7) + '" cy="20.1" rx=".7" ry=".45" fill="#fff" opacity=".55"/>' +
            '<ellipse class="fruit-shine" cx="23.3" cy="12.4" rx=".55" ry=".35" fill="#fff" opacity=".5"/>' +
            '<ellipse class="fruit-shine" cx="' + (fx(32) - 0.55) + '" cy="18.4" rx=".55" ry=".35" fill="#fff" opacity=".45"/>' +
          '</g>' +
          '<g class="bloom" opacity=".9">' +
            '<circle cx="18" cy="10.2" r="1.1" fill="#fda4af"/>' +
            '<circle cx="17" cy="9.4" r=".85" fill="#f472b6"/>' +
            '<circle cx="19" cy="9.3" r=".8" fill="#fb7185"/>' +
            '<circle cx="18" cy="9.6" r=".45" fill="#fff"/>' +
          '</g>' +
          '<circle cx="29.2" cy="11.2" r=".7" fill="#fda4af" opacity=".75"/>' +
          '<circle cx="24.6" cy="12.4" r=".55" fill="#fffbeb" opacity=".85"/>' +
        '</g>' +
      '</svg></div>'
  }

  function classFarmPlotHtml(row, myId, col, r, idx, opts) {
    const total = row.totalPoints || 0
    const stage = resolveFarmStage(row, total)
    const mine = myId && Number(row.studentId) === Number(myId)
    const rawName = row.studentName || row.studentNo || '同学'
    const name = escapeHtml(rawName)
    // 微抖动 + 近大远小（纵深）
    const jx = ((idx * 17) % 7) - 3
    const jy = ((idx * 11) % 5) - 2
    const tile = isoTileXY(col, r)
    const x = tile.x + jx
    const y = tile.y + jy
    const z = col + r
    const delay = Math.min(1.1, (col + r) * 0.035)
    const rows = Math.max(1, (opts && opts.rows) || 1)
    const depthT = rows <= 1 ? 0.55 : (r / Math.max(1, rows - 1))
    const rowScale = (0.78 + depthT * 0.32 + ((idx % 5) * 0.012) + (mine ? 0.06 : 0)).toFixed(3)
    const near = (opts && opts.near) ? ' is-near' : ''
    const sid = escapeHtml(String(row.studentId || ''))
    const stageLab = farmStageLabel(stage)
    const lv = row.levelNo != null ? ('Lv.' + row.levelNo) : ''
    const prog = farmStageProgress(total, stage)
    const nextHint = farmNextHint(total, stage)
    const tipExtra = [stageLab, lv, total + ' 分', '本阶段 ' + prog + '%', nextHint].filter(Boolean).join(' · ')
    return '<article class="iso-plot' + (mine ? ' me' : '') + near + '" role="listitem" tabindex="0"' +
      ' data-student-id="' + sid + '"' +
      ' data-stage="' + stage + '"' +
      ' data-total="' + total + '"' +
      ' data-name="' + name + '"' +
      ' title="点击查看：' + name + ' · ' + tipExtra + '"' +
      ' style="--iso-x:' + x + 'px;--iso-y:' + y + 'px;--iso-z:' + z +
      ';--plot-scale:' + rowScale + ';--enter-delay:' + delay + 's;' +
      (mine ? '--me:1;' : '') + '">' +
      '<div class="iso-soil">' +
        '<i class="soil-shadow"></i>' +
        '<i class="soil-side soil-side-se"></i><i class="soil-side soil-side-sw"></i>' +
        '<i class="soil-face"></i><i class="soil-rim"></i>' +
        '<i class="soil-ring" aria-hidden="true"></i>' +
        classFarmCropHtml(stage, idx, mine, total) +
      '</div>' +
      '<div class="iso-name-tag' + (mine ? ' me' : '') + '" aria-hidden="true">' +
        '<b>' + name + '</b><span>' + total + '分</span>' +
      '</div>' +
      (mine ? '<span class="iso-tip me" aria-hidden="true">我的田</span>' : '') +
      '</article>'
  }

  /** 名牌层：本人常显短文案，锚在田脚上方少挡垄心 */
  function classFarmNameHtml(row, myId, col, r, idx) {
    const total = row.totalPoints || 0
    const stage = resolveFarmStage(row, total)
    const mine = myId && Number(row.studentId) === Number(myId)
    const rawName = row.studentName || row.studentNo || '同学'
    const name = escapeHtml(rawName)
    const stageLab = farmStageLabel(stage)
    const lv = row.levelNo != null ? ('Lv.' + row.levelNo) : ''
    const nextHint = farmNextHint(total, stage)
    const tipExtra = [stageLab, lv, total + ' 分', nextHint].filter(Boolean).join(' · ')
    const plateSub = mine
      ? escapeHtml(farmNextHintShort(total, stage))
      : (lv ? (stageLab + ' · ' + lv) : (stageLab + ' · ' + total + '分'))
    const i = idx == null ? (col + r * 8) : idx
    const jx = ((i * 17) % 7) - 3
    const jy = ((i * 11) % 5) - 2
    const tile = isoTileXY(col, r)
    const x = tile.x + jx
    const y = tile.y + jy
    return '<button type="button" class="iso-nameplate' + (mine ? ' me on' : '') + '"' +
      ' data-student-id="' + escapeHtml(String(row.studentId || '')) + '"' +
      ' data-stage="' + stage + '"' +
      ' data-name="' + name + '"' +
      ' style="--iso-x:' + x + 'px;--iso-y:' + y + 'px"' +
      ' title="' + name + ' · ' + tipExtra + '">' +
      '<b>' + (mine ? '我' : name) + '</b>' +
      '<span>' + plateSub + '</span>' +
      '<i class="np-arrow" aria-hidden="true"></i>' +
      '</button>'
  }

  /** 点选地块后的顶栏提示（短句，细节在名牌上） */
  function classFarmFocusHint(plot, plate) {
    if (!plot) return defaultClassFarmHint()
    const total = Number(plot.getAttribute('data-total') || 0)
    const stage = plot.getAttribute('data-stage') || ''
    const stageLab = farmStageLabel(stage)
    const rawName = (plate && plate.getAttribute('data-name')) ||
      plot.getAttribute('data-name') || '同学'
    const nm = plot.classList.contains('me') ? ('我 · ' + rawName) : rawName
    return nm + ' · ' + stageLab + ' · ' + total + '分 · ' + farmNextHintShort(total, stage)
  }

  /** 同步名牌副文案为当前进度（点选后） */
  function syncFarmNameplate(plate, plot) {
    if (!plate || !plot) return
    const total = Number(plot.getAttribute('data-total') || 0)
    const stage = plot.getAttribute('data-stage') || ''
    const span = plate.querySelector('span')
    if (span) span.textContent = farmNextHintShort(total, stage)
  }

  /** 沿菱形边生成木篱；edgeFilter 可选只画远沿或近沿 */
  function buildClassFarmFenceSvg(N, E, S, W, edgeFilter) {
    const pad = 44
    const minX = Math.min(N.x, E.x, S.x, W.x) - pad
    const minY = Math.min(N.y, E.y, S.y, W.y) - pad
    const maxX = Math.max(N.x, E.x, S.x, W.x) + pad
    const maxY = Math.max(N.y, E.y, S.y, W.y) + pad
    const w = Math.max(120, Math.ceil(maxX - minX))
    const h = Math.max(120, Math.ceil(maxY - minY))
    const to = (p) => ({ x: p.x - minX, y: p.y - minY })
    const n = to(N)
    const e = to(E)
    const s = to(S)
    const wPt = to(W)
    // 0 NE远 1 SE近 2 SW近(含门) 3 NW远
    const edges = [[n, e], [e, s], [s, wPt], [wPt, n]]
    const postH = 38
    let layerShadow = ''
    let layerRail = ''
    let layerPost = ''
    let layerDecor = ''
    const allow = (idx) => !edgeFilter || edgeFilter(idx)
    const f = (n) => n.toFixed(1)

    /** 立体木柱：柱身双面 + 尖帽 + 脚影 */
    const drawPost = (x, y, kind) => {
      const tall = kind === 'corner' || kind === 'gate'
      const ph = tall ? postH + 6 : postH
      const bw = tall ? 6.2 : 5
      const topY = y - ph
      const lean = 2
      // 阳光右上 → 影偏左下
      layerShadow += '<ellipse cx="' + f(x - 5) + '" cy="' + f(y + 5.5) +
        '" rx="' + (tall ? 10 : 7.5) + '" ry="3" fill="rgba(12,40,22,.4)"/>'
      // 暗面 / 亮面 / 顶面厚度
      layerPost += '<path d="M' + f(x - bw * 0.6) + ' ' + f(topY + 6) +
        ' L' + f(x - bw * 0.4) + ' ' + f(y) +
        ' L' + f(x + bw * 0.1) + ' ' + f(y) +
        ' L' + f(x - lean) + ' ' + f(topY + 6) + 'Z" fill="#5c3a1e"/>'
      layerPost += '<path d="M' + f(x - lean) + ' ' + f(topY + 6) +
        ' L' + f(x + bw * 0.1) + ' ' + f(y) +
        ' L' + f(x + bw * 0.75) + ' ' + f(y - 0.6) +
        ' L' + f(x + bw * 0.4 - lean) + ' ' + f(topY + 5.2) + 'Z" fill="#b45309"/>'
      layerPost += '<path d="M' + f(x - bw * 0.55) + ' ' + f(topY + 6) +
        ' L' + f(x + bw * 0.35 - lean) + ' ' + f(topY + 5) +
        ' L' + f(x + bw * 0.15) + ' ' + f(topY + 3.2) +
        ' L' + f(x - bw * 0.35) + ' ' + f(topY + 4) + 'Z" fill="#d97706" opacity=".55"/>'
      layerPost += '<line x1="' + f(x + 0.4) + '" y1="' + f(topY + 9) +
        '" x2="' + f(x + 1.8) + '" y2="' + f(y - 4) +
        '" stroke="#fbbf24" stroke-width="1" opacity=".4" stroke-linecap="round"/>'
      // 尖顶帽双面
      layerPost += '<path d="M' + f(x - bw * 0.75) + ' ' + f(topY + 7) +
        ' L' + f(x) + ' ' + f(topY - 2) +
        ' L' + f(x + bw * 0.55) + ' ' + f(topY + 6.2) +
        ' Z" fill="#78350f"/>'
      layerPost += '<path d="M' + f(x) + ' ' + f(topY - 2) +
        ' L' + f(x + bw * 0.55) + ' ' + f(topY + 6.2) +
        ' L' + f(x + 0.5) + ' ' + f(topY + 7) +
        ' Z" fill="#d97706"/>'
      if (kind === 'gate') {
        layerPost += '<rect x="' + f(x - 3.6) + '" y="' + f(topY + 12) +
          '" width="7.2" height="2.4" rx="0.6" fill="#5c3a1e"/>'
        layerDecor += '<circle cx="' + f(x + 0.2) + '" cy="' + f(topY + 2) +
          '" r="1.8" fill="#22c55e"/>'
      } else if (kind === 'flower') {
        layerDecor += '<circle cx="' + f(x + 2.8) + '" cy="' + f(topY + 14) +
          '" r="1.8" fill="#f472b6"/>'
        layerDecor += '<circle cx="' + f(x - 2.2) + '" cy="' + f(topY + 18) +
          '" r="1.5" fill="#4ade80"/>'
      }
    }

    /** 厚木横杆：底暗面 + 中板 + 顶高光，做出截面厚度 */
    const drawRailSeg = (p0, p1, ratio) => {
      const y0 = p0.y - postH * ratio
      const y1 = p1.y - postH * ratio
      const x0 = p0.x
      const x1 = p1.x
      layerRail += '<line x1="' + f(x0 - 2) + '" y1="' + f(y0 + 3.2) +
        '" x2="' + f(x1 - 2) + '" y2="' + f(y1 + 3.2) +
        '" stroke="rgba(12,40,22,.22)" stroke-width="5.5" stroke-linecap="round"/>'
      layerRail += '<line x1="' + f(x0) + '" y1="' + f(y0 + 1.8) +
        '" x2="' + f(x1) + '" y2="' + f(y1 + 1.8) +
        '" stroke="#5c3a1e" stroke-width="4.8" stroke-linecap="round"/>'
      layerRail += '<line x1="' + f(x0) + '" y1="' + f(y0) +
        '" x2="' + f(x1) + '" y2="' + f(y1) +
        '" stroke="#a16207" stroke-width="3.8" stroke-linecap="round"/>'
      layerRail += '<line x1="' + f(x0) + '" y1="' + f(y0 - 1.4) +
        '" x2="' + f(x1) + '" y2="' + f(y1 - 1.4) +
        '" stroke="#fbbf24" stroke-width="1.5" stroke-linecap="round" opacity=".6"/>'
    }

    edges.forEach(([a, b], edgeIdx) => {
      if (!allow(edgeIdx)) return
      const len = Math.hypot(b.x - a.x, b.y - a.y) || 1
      const steps = Math.max(3, Math.round(len / 30))
      const gate = edgeIdx === 2
      const pts = []
      for (let i = 0; i <= steps; i++) {
        const t = i / steps
        pts.push({
          t,
          x: a.x + (b.x - a.x) * t,
          y: a.y + (b.y - a.y) * t,
          skip: gate && t > 0.36 && t < 0.64 && i !== 0 && i !== steps
        })
      }
      // 横杆分段（门口断开）
      let segStart = null
      const flushRail = (from, to) => {
        if (!from || !to) return
        drawRailSeg(from, to, 0.68)
        drawRailSeg(from, to, 0.32)
      }
      pts.forEach((p, i) => {
        if (p.skip) {
          if (segStart != null) {
            flushRail(pts[segStart], pts[i - 1])
            segStart = null
          }
          return
        }
        if (segStart == null) segStart = i
        // 四角与门柱另画，这里只画中间柱
        if (i === 0 || i === steps) return
        drawPost(p.x, p.y, (i % 4 === 2) ? 'flower' : 'normal')
      })
      if (segStart != null) flushRail(pts[segStart], pts[pts.length - 1])
      if (gate) {
        const leftJamb = pts.filter((p) => !p.skip && p.t <= 0.37).pop()
        const rightJamb = pts.find((p) => !p.skip && p.t >= 0.63)
        if (leftJamb) drawPost(leftJamb.x, leftJamb.y, 'gate')
        if (rightJamb) drawPost(rightJamb.x, rightJamb.y, 'gate')
      }
    })

    // 四角粗柱（所属边被画时才加）
    const corners = [
      { p: n, edges: [0, 3] },
      { p: e, edges: [0, 1] },
      { p: s, edges: [1, 2] },
      { p: wPt, edges: [2, 3] }
    ]
    corners.forEach((c) => {
      if (!c.edges.some(allow)) return
      drawPost(c.p.x, c.p.y, 'corner')
    })

    const svg =
      '<svg viewBox="0 0 ' + w + ' ' + h + '" width="' + w + '" height="' + h + '" focusable="false">' +
      '<g>' + layerShadow + layerRail + layerPost + layerDecor + '</g></svg>'
    return { svg, left: minX, top: minY, w, h }
  }

  function applyFenceEl(el, built) {
    if (!el || !built) return
    el.style.display = ''
    el.style.left = Math.round(built.left) + 'px'
    el.style.top = Math.round(built.top) + 'px'
    el.style.width = built.w + 'px'
    el.style.height = built.h + 'px'
    el.innerHTML = built.svg
  }

  /** 装饰锚点：房屋分两侧；田床东尖加厚；篱笆围田一周 */
  function placeClassFarmDecor(layout) {
    const {
      fieldW, fieldH, originX, originY, padN, padS, padW, padE,
      cols, rows, lockRows, bedExtendS
    } = layout
    const fx = padW
    const fy = padN
    const halfW = ISO_TILE_W / 2
    const halfH = ISO_TILE_H / 2
    const totalRows = rows + (lockRows || 0)
    const extS = bedExtendS || 0
    // 田床四尖：标准等距平行四边形（与 isoTileXY 一致）
    const north = { x: fx + originX, y: fy + originY }
    const east = {
      x: fx + originX + (cols - 1) * halfW,
      y: fy + originY + (cols - 1) * halfH
    }
    const south = {
      x: fx + originX + (cols - 1 - (totalRows - 1)) * halfW,
      y: fy + originY + (cols - 1 + totalRows - 1) * halfH + extS * 0.55
    }
    const west = {
      x: fx + originX - (totalRows - 1) * halfW,
      y: fy + originY + (totalRows - 1) * halfH
    }
    const bed = $('classFarmBed')
    const bedCliff = $('classFarmBedCliff')
    // 北尖几乎不外扩，并略下沉，与农舍地平面对齐
    const inflateN = 2
    const inflateE = 24
    const inflateS = 22
    const inflateW = 24
    const nx = originX
    const ny = Math.max(0, originY - inflateN + 6)
    const ex = originX + (cols - 1) * halfW + inflateE
    const ey = originY + (cols - 1) * halfH + Math.round(inflateE * 0.38) + 4
    const sx = originX + (cols - 1 - (totalRows - 1)) * halfW
    const sy = Math.min(fieldH, originY + (cols - 1 + totalRows - 1) * halfH + inflateS + extS)
    const wx = originX - (totalRows - 1) * halfW - inflateW
    const wy = originY + (totalRows - 1) * halfH + Math.round(inflateW * 0.1) + 4
    if (bed) {
      bed.style.width = fieldW + 'px'
      bed.style.height = fieldH + 'px'
      bed.style.left = fx + 'px'
      bed.style.top = fy + 'px'
      const pct = (x, y) => (Math.max(0, Math.min(fieldW, x)) / fieldW * 100).toFixed(2) + '% ' +
        (Math.max(0, Math.min(fieldH, y)) / fieldH * 100).toFixed(2) + '%'
      const polyOuter = 'polygon(' + pct(nx, ny) + ', ' + pct(ex, ey) + ', ' + pct(sx, sy) + ', ' + pct(wx, wy) + ')'
      // 北缘土面几乎贴绿檐，去掉「绿三角空尖」
      const polySoil = 'polygon(' +
        pct(nx, ny + 4) + ', ' +
        pct(ex - 10, ey + 2) + ', ' +
        pct(sx, sy - 12) + ', ' +
        pct(wx + 10, wy + 2) + ')'
      const rim = bed.querySelector('.bed-rim')
      const soil = bed.querySelector('.bed-soil')
      const gloss = bed.querySelector('.bed-gloss')
      const shadow = bed.querySelector('.bed-shadow')
      if (rim) rim.style.clipPath = polyOuter
      if (shadow) shadow.style.clipPath = polyOuter
      if (soil) soil.style.clipPath = polySoil
      if (gloss) gloss.style.clipPath = polySoil
    }
    // 近侧台地立面已按产品要求移除：田面贴草地，与农舍同地平面
    if (bedCliff) {
      bedCliff.style.display = 'none'
      bedCliff.innerHTML = ''
    }

    const cx = (north.x + south.x) / 2
    const cy = (north.y + south.y) / 2
    const outPush = (p, d) => {
      const dx = p.x - cx
      const dy = p.y - cy
      const L = Math.hypot(dx, dy) || 1
      return { x: p.x + (dx / L) * d, y: p.y + (dy / L) * d }
    }
    // 田床外沿（与绿檐/台地 clip 对齐），篱笆略外扩一圈
    const bedN = { x: fx + nx, y: fy + ny }
    const bedE = { x: fx + ex, y: fy + ey }
    const bedS = { x: fx + sx, y: fy + sy }
    const bedW = { x: fx + wx, y: fy + wy }
    // 外推量：东/南/西明显外移；北沿外移略少并微沉，避免翘进农舍
    const rimOut = 28
    const fN = (() => {
      const p = outPush(bedN, rimOut - 6)
      return { x: p.x, y: p.y + 4 }
    })()
    const fE = outPush(bedE, rimOut)
    const fS = (() => {
      const p = outPush(bedS, rimOut)
      return { x: p.x, y: p.y + 4 }
    })()
    const fW = outPush(bedW, rimOut)
    // 装饰贴篱：落在西/东尖外侧草地
    const dN = outPush(bedN, 28)
    const dE = outPush(bedE, 30)
    const dS = outPush(bedS, 28)
    const dW = outPush(bedW, 30)

    // 农舍：必须完全落在西篱外（勿与田床/垄位相交；垄 z 高于屋会「切」进房子）
    const house = $('classFarmHouse')
    if (house) {
      const nw = outPush({
        x: fW.x * 0.48 + fN.x * 0.52,
        y: fW.y * 0.48 + fN.y * 0.52
      }, 96)
      // 台阶锚点对准草地；整屋偏左上，右缘离开西尖 ≥ 一座身宽余量
      house.style.left = Math.round(nw.x - 208) + 'px'
      house.style.top = Math.round(nw.y - 186) + 'px'
      house.classList.remove('is-flip')
    }

    const path = $('classFarmPath')
    if (path) path.style.display = 'none'

    // 稻草人：站在东篱外草地（相对篱笆外推，勿落进田内）
    const scare = $('classFarmScarecrow')
    if (scare) {
      const ne = outPush({
        x: fE.x * 0.82 + fN.x * 0.18,
        y: fE.y * 0.82 + fN.y * 0.18
      }, 42)
      scare.style.left = Math.round(ne.x - 22) + 'px'
      scare.style.top = Math.round(ne.y - 68) + 'px'
    }

    // 池塘：农舍南侧草地，勿叠进田床西尖
    const pond = $('classFarmPond')
    if (pond) {
      const pw = outPush({
        x: fW.x * 0.62 + fS.x * 0.38,
        y: fW.y * 0.62 + fS.y * 0.38
      }, 88)
      pond.style.left = Math.round(pw.x - 118) + 'px'
      pond.style.top = Math.round(pw.y - 20) + 'px'
    }

    // 劳动光荣：篱角外前景草
    const sign = $('classFarmSign')
    if (sign) {
      const swMid = {
        x: dW.x * 0.4 + dS.x * 0.6,
        y: dW.y * 0.4 + dS.y * 0.6
      }
      const swOut = outPush(swMid, 40)
      sign.style.display = ''
      sign.style.left = Math.round(swOut.x - 36) + 'px'
      sign.style.top = Math.round(swOut.y) + 'px'
    }

    // 扩建牌：南门外侧
    const expand = $('classFarmExpand')
    if (expand) {
      expand.style.left = Math.round(fS.x - 26) + 'px'
      expand.style.top = Math.round(fS.y + 8) + 'px'
    }

    // 远沿篱在田后，近沿篱盖住前景作物脚
    applyFenceEl($('classFarmFenceBack'), buildClassFarmFenceSvg(fN, fE, fS, fW, (i) => i === 0 || i === 3))
    applyFenceEl($('classFarmFence'), buildClassFarmFenceSvg(fN, fE, fS, fW, (i) => i === 1 || i === 2))
  }

  function classFarmLockHtml(col, r) {
    const tile = isoTileXY(col, r)
    return '<div class="iso-lock-plot" style="left:calc(var(--iso-ox) + ' + tile.x +
      'px);top:calc(var(--iso-oy) + ' + tile.y + 'px)">' +
      '<i class="lock-edge"></i><i class="lock-face"></i></div>'
  }

  /** 末行空垄：同色浅土，补齐田沿，不抢戏 */
  function classFarmGhostPlotHtml(col, r) {
    const tile = isoTileXY(col, r)
    const z = col + r
    return '<article class="iso-plot is-ghost" aria-hidden="true" tabindex="-1"' +
      ' style="--iso-x:' + tile.x + 'px;--iso-y:' + tile.y + 'px;--iso-z:' + z + '">' +
      '<div class="iso-soil">' +
        '<i class="soil-shadow"></i>' +
        '<i class="soil-side soil-side-se"></i><i class="soil-side soil-side-sw"></i>' +
        '<i class="soil-face"></i>' +
      '</div></article>'
  }

  function updateFarmZoomLabel() {
    const el = $('farmZoomLabel')
    if (!el) return
    const pct = Math.round((Number(state.farmZoom) || 1) * 100)
    el.textContent = pct + '%'
  }

  function setFarmZoom(next, opts) {
    const z = Math.max(0.75, Math.min(1.6, Math.round((Number(next) || 1) * 100) / 100))
    state.farmZoom = z
    updateFarmZoomLabel()
    if ($('viewFarm') && !$('viewFarm').hidden && state.farmCache) {
      fitClassFarmScene({ scrollToMe: !!(opts && opts.scrollToMe) })
    }
  }

  function bumpFarmZoom(delta) {
    setFarmZoom((Number(state.farmZoom) || 1) + delta)
  }

  function defaultClassFarmHint() {
    const n = state.farmCache && state.farmCache.list && state.farmCache.list.length
    return n
      ? ('共 ' + n + ' 块田 · 点选查看 · 拖动画布 · 滚轮缩放 · 双击浇水')
      : '点地块查看进度'
  }

  /**
   * 以田面为取景中心：菱形田床必须完整入画；农舍所在 pad 可裁左侧。
   * （勿按整块 yard 居中——大 padW 会把东尖推出右缘）
   */
  function fitClassFarmScene(opts) {
    const scrollToMe = !!(opts && opts.scrollToMe)
    const grid = $('classFarmGrid')
    const names = $('classFarmNames')
    const yard = $('classFarmYard')
    const world = $('classFarmWorld')
    const vp = $('classFarmViewport')
    const layout = state.farmCache && state.farmCache.layout
    if (!grid || !world || !vp || !yard || !layout) return

    const { fieldW, fieldH, originX, originY, padN, padS, padW, padE } = layout
    const vpW = Math.max(320, vp.clientWidth || 0)
    const vpH = Math.max(280, vp.clientHeight || 0)
    world.style.width = vpW + 'px'
    world.style.height = vpH + 'px'
    if (!farmFx.canvas) farmFx.init()
    else farmFx.resize()
    const locks = $('classFarmLocks')

    ;[grid, names, locks].forEach((el) => {
      if (!el) return
      el.style.width = fieldW + 'px'
      el.style.height = fieldH + 'px'
      el.style.setProperty('--iso-ox', originX + 'px')
      el.style.setProperty('--iso-oy', originY + 'px')
      el.style.left = padW + 'px'
      el.style.top = padN + 'px'
    })

    placeClassFarmDecor(layout)

    const yardW = fieldW + padW + padE
    const yardH = fieldH + padN + padS
    yard.style.width = yardW + 'px'
    yard.style.height = yardH + 'px'

    // 田面 + 篱笆外扩余量必须完整入画（篱笆 rimOut≈28，再留柱高余量）
    const fenceMargin = 64
    const fitW = fieldW + fenceMargin * 2
    const fitH = fieldH + fenceMargin * 2 + 28
    let scale = Math.min(
      (vpW * 0.96) / Math.max(fitW, 1),
      (vpH * 0.9) / Math.max(fitH, 1),
      4.0
    )
    const zoom = Math.max(0.75, Math.min(1.6, Number(state.farmZoom) || 1))
    state.farmZoom = zoom
    scale = scale * zoom
    yard.style.setProperty('--yard-scale', String(scale))
    updateFarmZoomLabel()

    // 田心对准视口中心略偏下；勿用 yard 几何中心（padW 很大时会右偏裁东尖）
    const fieldCx = padW + fieldW / 2
    const fieldCy = padN + fieldH * 0.52
    let left = Math.round(vpW / 2 - fieldCx * scale)
    let top = Math.round(vpH * 0.56 - fieldCy * scale)

    const clampFieldInView = () => {
      // 含篱笆/台地外扩，避免东尖被 iso-world overflow:hidden 裁掉
      const fieldLeft = left + (padW - fenceMargin) * scale
      const fieldRight = left + (padW + fieldW + fenceMargin) * scale
      const fieldTop = top + (padN - fenceMargin) * scale
      const fieldBottom = top + (padN + fieldH + fenceMargin) * scale
      const m = 8
      if (fieldLeft < m) left += Math.round(m - fieldLeft)
      if (fieldRight > vpW - m) left -= Math.round(fieldRight - (vpW - m))
      if (fieldTop < m) top += Math.round(m - fieldTop)
      if (fieldBottom > vpH - m) top -= Math.round(fieldBottom - (vpH - m))
      yard.style.left = left + 'px'
      yard.style.top = top + 'px'
    }
    clampFieldInView()

    requestAnimationFrame(() => {
      vp.scrollLeft = 0
      vp.scrollTop = 0
      if (scrollToMe) {
        const me = grid.querySelector('.iso-plot.me')
        if (me) {
          const mr = me.getBoundingClientRect()
          const vr = vp.getBoundingClientRect()
          const dx = mr.left + mr.width / 2 - (vr.left + vr.width / 2)
          const dy = mr.top + mr.height / 2 - (vr.top + vr.height * 0.58)
          if (Math.abs(dx) > 24 || Math.abs(dy) > 24) {
            left = Math.round(left - dx * 0.28)
            top = Math.round(top - dy * 0.22)
            clampFieldInView()
          }
        }
      }
    })
  }

  /** 本人田挪到田心偏南，避开北尖农舍，名牌也好挂 */
  function arrangeFarmList(list, myId, cols) {
    const arr = (list || []).slice()
    if (!myId || arr.length < 3) return arr
    const idx = arr.findIndex((r) => Number(r.studentId) === Number(myId))
    if (idx < 0) return arr
    const [me] = arr.splice(idx, 1)
    const n = arr.length + 1
    const rows = Math.ceil(n / cols) || 1
    // 倒数第二行中部：视野中心、不被屋压
    let seat = Math.max(cols, (Math.max(1, rows - 2)) * cols + Math.floor((cols - 1) / 2))
    if (seat > arr.length) seat = Math.min(arr.length, Math.floor(arr.length * 0.55))
    arr.splice(seat, 0, me)
    return arr
  }

  function layoutClassFarm(list, myId) {
    const grid = $('classFarmGrid')
    const names = $('classFarmNames')
    const locks = $('classFarmLocks')
    if (!grid) return
    const n0 = list.length
    // 参考图约 4 列；人少时固定 4 列更像整片田
    const cols = n0 <= 16 ? 4 : classFarmCols(n0)
    const ordered = arrangeFarmList(list, myId, cols)
    const n = ordered.length
    const rows = Math.ceil(n / cols) || 1
    // 南侧 1 行浅垄即可铺满南沿，过多会拉高院落反把田压小
    const lockRows = 1
    let plotHtml = ''
    let nameHtml = ''
    for (let i = 0; i < n; i++) {
      const col = i % cols
      const r = Math.floor(i / cols)
      plotHtml += classFarmPlotHtml(ordered[i], myId, col, r, i, { near: r >= rows - 2, rows })
      nameHtml += classFarmNameHtml(ordered[i], myId, col, r, i)
    }
    const filled = rows * cols
    for (let i = n; i < filled; i++) {
      plotHtml += classFarmGhostPlotHtml(i % cols, Math.floor(i / cols))
    }
    // 待开垦行：空凹坑，落在扩大耕地内
    for (let r = rows; r < rows + lockRows; r++) {
      for (let col = 0; col < cols; col++) {
        plotHtml += classFarmGhostPlotHtml(col, r)
      }
    }
    grid.innerHTML = plotHtml
    if (names) names.innerHTML = nameHtml
    if (locks) locks.innerHTML = ''

    const halfW = ISO_TILE_W / 2
    const halfH = ISO_TILE_H / 2
    const totalRows = rows + lockRows
    const spanX = (cols + totalRows - 2) * halfW
    const spanY = (cols + totalRows - 2) * halfH
    const marginX = ISO_PLOT_RX + 16
    const marginY = ISO_PLOT_RY + 14
    // 南尖土色外扩（不靠多行空垄撑面积）
    const bedExtendS = Math.round(halfH * 2.4)
    const fieldW = spanX + marginX * 2
    const fieldH = spanY + marginY * 2 + bedExtendS
    // 含待开垦行后，西尖更靠左，原点按总行数算
    const originX = (totalRows - 1) * halfW + marginX
    const originY = marginY
    // 西/北留足农舍；东侧略增，保证东尖+稻草人不贴边
    const padN = 180
    const padS = 80
    const padW = 240
    const padE = 140
    state.farmCache = {
      list,
      myId,
      layout: {
        cols, rows, lockRows, fieldW, fieldH, originX, originY,
        padN, padS, padW, padE, bedExtendS
      }
    }
    requestAnimationFrame(() => {
      requestAnimationFrame(() => fitClassFarmScene({ scrollToMe: true }))
    })
  }

  async function openClassFarm(opts) {
    opts = opts || {}
    const staff = isStaffMode()
    state.farmReadOnly = !!(opts.readOnly || staff)
    applyModeChrome()
    let deptId = opts.deptId
    if (staff && deptId == null) {
      deptId = state.supervise && state.supervise.deptId
    }
    if (staff && !deptId) {
      toast('请先在督察页选择班级', 'warn')
      return
    }
    show('viewFarm')
    await loadClassFarm(deptId)
    maybeShowFarmTour()
  }

  function renderFarmWeekStrip(list) {
    const strip = $('farmWeekStrip')
    if (!strip) return
    const rows = list || []
    if (!rows.length) {
      strip.hidden = true
      strip.innerHTML = ''
      return
    }
    const counts = { seed: 0, seedling: 0, sapling: 0, tree: 0 }
    let sum = 0
    rows.forEach((r) => {
      const total = Number(r.totalPoints) || 0
      sum += total
      const st = resolveFarmStage(r, total)
      counts[st] = (counts[st] || 0) + 1
    })
    const top = rows.slice().sort((a, b) => (Number(b.totalPoints) || 0) - (Number(a.totalPoints) || 0)).slice(0, 3)
    const avg = Math.round(sum / rows.length)
    const bloom = counts.tree || 0
    const topTxt = top.map((r, i) =>
      (i + 1) + '.' + escapeHtml(r.studentName || r.studentNo || '同学') +
      '<small>' + (Number(r.totalPoints) || 0) + '</small>'
    ).join(' ')
    strip.hidden = false
    strip.innerHTML =
      '<div class="farm-week-kpis">' +
        '<span><b>' + rows.length + '</b>人田</span>' +
        '<span><b>' + avg + '</b>人均分</span>' +
        '<span><b>' + bloom + '</b>盛放</span>' +
        '<span>萌芽' + counts.seed + ' · 浮叶' + counts.seedling +
          ' · 花蕾' + counts.sapling + '</span>' +
      '</div>' +
      '<div class="farm-week-top">班级领先 ' + topTxt + '</div>'
  }

  function applyFarmStageFilter(filter) {
    state.farmStageFilter = filter || 'all'
    document.querySelectorAll('#classFarmLegend [data-stage-filter]').forEach((btn) => {
      btn.classList.toggle('on', btn.dataset.stageFilter === state.farmStageFilter)
    })
    const f = state.farmStageFilter
    document.querySelectorAll('#classFarmGrid .iso-plot').forEach((plot) => {
      if (plot.classList.contains('is-ghost')) return
      const st = plot.getAttribute('data-stage') || 'seed'
      const hide = f !== 'all' && st !== f
      plot.classList.toggle('is-stage-dim', hide)
      plot.classList.toggle('is-stage-hide', hide)
    })
    document.querySelectorAll('#classFarmNames .iso-nameplate').forEach((plate) => {
      const st = plate.getAttribute('data-stage') || 'seed'
      const hide = f !== 'all' && st !== f
      plate.classList.toggle('is-stage-dim', hide)
    })
    if ($('classFarmHint') && f !== 'all') {
      const n = document.querySelectorAll('#classFarmGrid .iso-plot:not(.is-ghost):not(.is-stage-hide)').length
      $('classFarmHint').textContent = farmStageLabel(f) + ' · ' + n + ' 块田（点「全部」取消筛选）'
    } else if ($('classFarmHint') && f === 'all') {
      $('classFarmHint').textContent = defaultClassFarmHint()
    }
  }

  function maybeShowFarmTour() {
    const tour = $('farmTour')
    if (!tour) return
    try {
      if (localStorage.getItem(FARM_TOUR_KEY) === '1') {
        tour.hidden = true
        tour.setAttribute('hidden', '')
        tour.style.display = 'none'
        return
      }
    } catch (e) { /* ignore */ }
    tour.hidden = false
    tour.removeAttribute('hidden')
    tour.style.display = ''
  }

  function dismissFarmTour() {
    const tour = $('farmTour')
    if (tour) {
      tour.hidden = true
      tour.setAttribute('hidden', '')
      tour.style.display = 'none'
    }
    try { localStorage.setItem(FARM_TOUR_KEY, '1') } catch (e) { /* ignore */ }
  }

  async function loadClassFarm(deptId) {
    const grid = $('classFarmGrid')
    const names = $('classFarmNames')
    if (!grid) return
    grid.innerHTML = '<div class="iso-loading">正在开垦田地…</div>'
    if (names) names.innerHTML = ''
    if ($('farmWeekStrip')) { $('farmWeekStrip').hidden = true; $('farmWeekStrip').innerHTML = '' }
    try {
      const q = deptId != null ? ('?deptId=' + encodeURIComponent(deptId)) : ''
      const res = await api('GET', '/spas/practice/points/farm' + q)
      const data = res.data || {}
      applyFarmThresholds(data.farmThresholds)
      const list = data.list || []
      const myId = state.farmReadOnly
        ? null
        : (data.myStudentId || (state.profile && state.profile.studentId))
      const deptName = data.deptName || (state.profile && state.profile.deptName) || ''
      if ($('classFarmTitle')) {
        const base = deptName ? (deptName + ' · 成长农场') : '班级成长农场'
        $('classFarmTitle').textContent = state.farmReadOnly ? (base + ' · 巡班只读') : base
      }
      if ($('classFarmHint')) {
        $('classFarmHint').textContent = list.length
          ? (state.farmReadOnly
            ? ('共 ' + list.length + ' 块田 · 巡班只读 · 点选查看 · 拖动画布 · 滚轮缩放')
            : defaultClassFarmHint())
          : '本班暂无学生档案'
      }
      if (!list.length) {
        state.farmCache = null
        grid.innerHTML = '<div class="iso-empty">' + emptyHtml('本班暂无学生，或积分服务暂不可用') + '</div>'
        if (names) names.innerHTML = ''
        return
      }
      layoutClassFarm(list, myId)
      renderFarmWeekStrip(list)
      applyFarmStageFilter(state.farmStageFilter || 'all')
      farmFx.init()
      // 进场：聚焦本人田 + 轻点选反馈（不再伪造成长/浇水）
      requestAnimationFrame(() => {
        const me = grid.querySelector('.iso-plot.me') || grid.querySelector('.iso-plot:not(.is-ghost)')
        if (me) {
          me.classList.add('is-focus')
          const plate = names && me.getAttribute('data-student-id')
            ? names.querySelector('.iso-nameplate[data-student-id="' +
              String(me.getAttribute('data-student-id')).replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"]')
            : null
          if (plate) {
            plate.classList.add('on')
            syncFarmNameplate(plate, me)
          }
          if ($('classFarmHint')) $('classFarmHint').textContent = classFarmFocusHint(me, plate)
          farmFx.selectAt(me, farmStageLabel(me.getAttribute('data-stage') || 'seed'))
          farmAudio.tap()
        }
        document.body.classList.add('farm-fx-on')
      })
    } catch (e) {
      state.farmCache = null
      farmFx.stop()
      grid.innerHTML = '<div class="iso-empty">' + emptyHtml(e.message || '农场加载失败，请稍后重试') + '</div>'
      if (names) names.innerHTML = ''
      toast(e.message || '农场加载失败', 'err')
    }
  }

  function onFarmViewportResize() {
    const farmView = $('viewFarm')
    if (!farmView || farmView.hidden || !state.farmCache) return
    fitClassFarmScene({ scrollToMe: false })
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
    if ($('btnAsideBoardWeek')) $('btnAsideBoardWeek').classList.toggle('active', state.boardRange === 'week')
    if ($('btnAsideBoardAll')) $('btnAsideBoardAll').classList.toggle('active', state.boardRange === 'all')
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
      const rankText = data.myRank ? ('我的名次：第 ' + data.myRank + ' 名') : '我的名次：暂未上榜'
      if ($('boardMyRank')) $('boardMyRank').textContent = rankText
      if ($('asideBoardMyRank')) $('asideBoardMyRank').textContent = rankText
      if (state.points) {
        if (state.boardRange === 'week') state.points.weekRank = data.myRank
        else state.points.allRank = data.myRank
        renderAsidePoints(state.points)
      }
    } catch (e) {
      const err = '<li class="empty-row">积分榜暂不可用</li>'
      if ($('homeBoardList')) $('homeBoardList').innerHTML = err
      if ($('asideBoardList')) $('asideBoardList').innerHTML = err
      if ($('asideBoardMyRank')) $('asideBoardMyRank').textContent = '我的名次：-'
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
        const pts = Number(row.points || 0)
        const ptsText = (pts > 0 ? '+' : '') + pts
        const ptsClass = pts < 0 ? ' pts-neg' : (pts > 0 ? ' pts-pos' : '')
        return '<li><div><b class="' + ptsClass.trim() + '">' + ptsText + '</b> ' + escapeHtml(label) +
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
        : emptyHtml('近 7 日暂无练习记录', { action: 'practice', label: '今日练习' })
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
      '<br/><span class="muted">历史代提 · ' + escapeHtml(l.submitByName || '') + '</span></div>' +
      (ok
        ? '<div class="feed-actions">' +
          '<button type="button" class="btn mini ok" data-confirm="' + l.logId + '">确认</button>' +
          '<button type="button" class="btn mini danger" data-reject="' + l.logId + '">驳回</button></div>'
        : '<span class="chip">旧流程·次日可确认</span>') +
      '</li>'
  }

  function renderPendingConfirm(list) {
    const card = $('confirmCard')
    const ul = $('confirmList')
    const center = $('centerConfirmCard')
    const centerUl = $('centerConfirmList')
    const homeMod = $('homeConfirmMod')
    const homeUl = $('homeConfirmList')
    const today = todayStr()
    // 旧代提：仅展示已到确认日的条目，避免与当日检查确认抢视线
    const ready = (list || []).filter((l) => practiceDateStr(l.practiceDate) < today)
    if (!ready.length) {
      if (card) card.hidden = true
      if (ul) ul.innerHTML = ''
      if (center) center.hidden = true
      if (centerUl) centerUl.innerHTML = ''
      if (homeMod) homeMod.hidden = true
      if (homeUl) homeUl.innerHTML = ''
      return
    }
    const hint = '（历史代提 ' + ready.length + ' 条可确认）'
    const html = ready.map((l) => confirmItemHtml(l, today)).join('')
    if (card) card.hidden = false
    if ($('confirmHint')) $('confirmHint').textContent = hint
    if (ul) ul.innerHTML = html
    if (center) center.hidden = false
    if ($('centerConfirmHint')) $('centerConfirmHint').textContent = hint
    if (centerUl) centerUl.innerHTML = html
    if (homeMod) homeMod.hidden = false
    if ($('homeConfirmTitle')) $('homeConfirmTitle').textContent = ready.length + ' 条历史代提可确认'
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
      else toast(accept ? '已确认' : '已驳回并作废', accept ? 'ok' : 'warn')
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
    // 日常代提已停用，组长统一走今日通路（结账/确认）
    if (proxy) {
      openTodayFlow({ leaderOnly: true })
      return
    }
    state.proxyStudentId = null
    state.preselectKnowledgeIds = (opts.knowledgeIds || []).map(Number).filter(Boolean)
    state.draftReuse = opts.reuse ? (state.lastTemplate || loadTemplate()) : null
    if (state.draftReuse && state.draftReuse.knowledgeIds && state.draftReuse.knowledgeIds.length) {
      state.preselectKnowledgeIds = state.draftReuse.knowledgeIds.map(Number)
    }
    $('practiceTitle').textContent = '加练登记'
    if ($('proxyHint')) {
      $('proxyHint').hidden = true
      $('proxyHint').textContent = ''
    }
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
    // 日常代提已停用：加练只走本人提交；离线队列若仍有历史 /proxy 项由 flushQueue 兼容
    state.proxyStudentId = null
    state.pendingPayload = { payload, proxy: false, path: '/spas/practice' }
    doSubmitConfirmed()
  }

  function clearSuccessTimer() {
    if (state.successTimer) {
      clearInterval(state.successTimer)
      state.successTimer = null
    }
  }

  function renderSuccessBoost(acc, farmSt, stageUp) {
    const boost = $('successBoost')
    if (!boost) return
    const streak = (acc && acc.dayStreak) || 0
    const total = (acc && acc.totalPoints) || 0
    const show = !!(farmSt || streak >= 2)
    boost.hidden = !show
    if (!show) return
    if ($('successFarmMini')) {
      $('successFarmMini').dataset.stage = farmSt || 'seed'
      $('successFarmMini').classList.toggle('is-up', !!stageUp)
    }
    if ($('successFarmHint')) {
      $('successFarmHint').textContent = stageUp
        ? ('植物长成「' + farmStageLabel(farmSt) + '」！继续攒分冲下一阶段')
        : ('植物 · ' + farmStageLabel(farmSt) + ' · 累计 ' + total + ' 分')
    }
    if ($('successStreak')) {
      if (streak >= 2) {
        $('successStreak').hidden = false
        $('successStreak').textContent = '连打 ' + streak + ' 天 · 保持节奏！'
      } else {
        $('successStreak').hidden = true
      }
    }
  }

  async function showSuccess(payload, proxy, offline, awardedPoints) {
    const text = offline
      ? '已暂存本地，联网后自动同步，可放心离开'
      : ('已登记：' + (payload.bookName || '') + ' · 题号 ' + (payload.questionText || ''))
    if ($('successText')) $('successText').textContent = text
    const pts = Number(awardedPoints) || 0
    if ($('successPoints')) {
      if (!offline && pts > 0) {
        $('successPoints').hidden = false
        $('successPoints').textContent = '积分 +' + pts
      } else {
        $('successPoints').hidden = true
      }
    }
    if ($('successLevelUp')) $('successLevelUp').hidden = true
    if ($('successBoost')) $('successBoost').hidden = true
    if (!offline && pts > 0) {
      try {
        const before = state.prevLevelNo
        const beforeFarm = state.prevFarmStage
        const mineRes = await api('GET', '/spas/practice/points/mine')
        state.points = mineRes.data || {}
        applyFarmThresholds(state.points.farmThresholds)
        const lv = (state.points.account && state.points.account.levelNo) || 1
        const totalPts = (state.points.account && state.points.account.totalPoints) || 0
        const farmSt = resolveFarmStage(state.points.account, totalPts)
        const bits = []
        let stageUp = false
        if (before != null && lv > before) {
          state.leveledUpTo = lv
          bits.push('升级到 Lv.' + lv)
        }
        if (beforeFarm != null && farmStageRank(farmSt) > farmStageRank(beforeFarm)) {
          state.farmStageUpTo = farmSt
          stageUp = true
          bits.push('长成' + farmStageLabel(farmSt))
        }
        if (bits.length && $('successLevelUp')) {
          $('successLevelUp').hidden = false
          $('successLevelUp').textContent = bits.join(' · ') + '！'
        }
        state.prevLevelNo = lv
        state.prevFarmStage = farmSt
        renderSuccessBoost(state.points.account, farmSt, stageUp)
        renderLevelBar(state.points)
        renderAsidePoints(state.points)
        renderFarm(state.points)
        if (!isAudioMuted()) farmAudio.refresh()
      } catch (e) { /* ignore */ }
    } else if (!offline && state.points && state.points.account) {
      const farmSt = resolveFarmStage(state.points.account, state.points.account.totalPoints || 0)
      renderSuccessBoost(state.points.account, farmSt, false)
    }
    let left = SUCCESS_EXIT_SEC
    if ($('successCountdown')) $('successCountdown').textContent = String(left)
    show('viewSuccess')
    clearSuccessTimer()
    if (proxy) {
      // 兼容离线队列中的历史代提项：不自动退出
      if ($('successCountdown') && $('successCountdown').parentElement) {
        $('successCountdown').parentElement.hidden = true
      }
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

  function isProxyQueuePath(path) {
    const p = String(path || '')
    return PROXY_PATHS.indexOf(p) >= 0
  }

  function isCheckoutQueueItem(item) {
    if (!item) return false
    if (item.kind === 'checkout') return true
    return String(item.path || '') === '/spas/practice/checkout'
  }

  function enqueue(item) {
    if (isProxyQueuePath(item && item.path)) {
      logClient('queue reject legacy proxy path')
      toast('旧代提离线项已忽略，请改用检查单', 'warn')
      return
    }
    const q = loadQueue()
    // Checkout: one pending sheet per assignment (replace older)
    if (isCheckoutQueueItem(item) && item.assignmentId != null) {
      const aid = Number(item.assignmentId)
      const kept = q.filter((x) => !(isCheckoutQueueItem(x) && Number(x.assignmentId) === aid))
      kept.push(Object.assign({
        id: 'co_' + aid + '_' + Date.now(),
        ts: Date.now(),
        retries: 0,
        kind: 'checkout',
        path: '/spas/practice/checkout'
      }, item))
      saveQueue(kept)
      logClient('queue enqueue checkout assignmentId=' + aid + ' size=' + kept.length)
      return
    }
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
    // Drop legacy proxy leftovers once
    const cleaned = q.filter((item) => !isProxyQueuePath(item.path))
    if (cleaned.length !== q.length) {
      logClient('queue drop legacy proxy count=' + (q.length - cleaned.length))
      q = cleaned
      saveQueue(q)
    }
    if (!q.length) {
      updateQueueBadge()
      return
    }
    const remain = []
    let ok = 0
    let awardedSum = 0
    let checkoutOk = 0
    const meId = state.profile && state.profile.studentId != null
      ? Number(state.profile.studentId)
      : null
    for (const item of q) {
      if (isProxyQueuePath(item.path)) continue
      if (isCheckoutQueueItem(item) && item.studentId != null && meId != null
        && Number(item.studentId) !== meId) {
        // Wait until the same leader logs in
        remain.push(item)
        continue
      }
      try {
        const body = Object.assign({}, item.payload || {})
        if (item.clientRequestId && !body.clientRequestId) {
          body.clientRequestId = item.clientRequestId
        }
        const res = await api('POST', item.path || '/spas/practice', body)
        ok++
        if (isCheckoutQueueItem(item)) {
          checkoutOk++
          clearCheckoutDraftFromDisk(item.assignmentId)
        }
        if (res && res.awardedPoints) awardedSum += Number(res.awardedPoints) || 0
      } catch (e) {
        const msg = e && e.message ? String(e.message) : ''
        // Business reject (locked rows etc.): do not infinite-retry
        const fatal = /已确认|已抽检|只能提交当日|仅组长|禁止自检|请为全员|有困难必须|布置不存在|登录已失效/.test(msg)
        item.retries = (item.retries || 0) + 1
        if (!fatal && item.retries < 8) remain.push(item)
        else {
          logClient('queue drop id=' + item.id + ' fatal=' + fatal + ' msg=' + msg)
          if (isCheckoutQueueItem(item)) {
            toast('检查单离线项无法同步：' + (msg || '已丢弃'), 'err')
          }
        }
      }
    }
    saveQueue(remain)
    updateQueueBadge()
    if (ok) {
      const ptsTip = awardedSum > 0 ? ('，积分 +' + awardedSum) : ''
      const coTip = checkoutOk > 0 ? ('（含检查单 ' + checkoutOk + '）') : ''
      toast('已同步离线记录 ' + ok + ' 条' + coTip + ptsTip, 'ok')
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
        else if ($('viewCheckout') && !$('viewCheckout').hidden) await loadHome()
        else await loadPointsHome()
      } catch (e) { /* ignore */ }
    }
  }

  function checkoutDiskMeta() {
    const co = state.checkout || {}
    const asg = co.assignment || {}
    const g = co.group || {}
    const day = asg.assignDate
      ? String(asg.assignDate).substring(0, 10)
      : (co.practiceDate ? String(co.practiceDate).substring(0, 10) : '')
    return {
      assignmentId: asg.assignmentId != null ? Number(asg.assignmentId) : null,
      groupId: (g.groupId != null ? Number(g.groupId) : (co.groupId != null ? Number(co.groupId) : null)),
      practiceDate: day,
      studentId: checkoutMeId() ? Number(checkoutMeId()) : null
    }
  }

  function saveCheckoutDraftToDisk() {
    const meta = checkoutDiskMeta()
    if (!meta.assignmentId) return
    const draft = {}
    Object.keys(state.checkoutDraft || {}).forEach((k) => {
      const d = state.checkoutDraft[k] || {}
      draft[k] = {
        finishStatus: d.finishStatus || '',
        difficultyNote: d.difficultyNote || '',
        knowledgeIds: Array.isArray(d.knowledgeIds) ? d.knowledgeIds.map(Number).filter(Boolean) : []
      }
    })
    try {
      localStorage.setItem(CHECKOUT_DRAFT_LS_KEY, JSON.stringify({
        ...meta,
        ts: Date.now(),
        draft
      }))
    } catch (e) { /* ignore quota */ }
  }

  function loadCheckoutDraftFromDisk() {
    try {
      return JSON.parse(localStorage.getItem(CHECKOUT_DRAFT_LS_KEY) || 'null')
    } catch (e) {
      return null
    }
  }

  function clearCheckoutDraftFromDisk(assignmentId) {
    const cur = loadCheckoutDraftFromDisk()
    if (!cur) return
    if (assignmentId == null || Number(cur.assignmentId) === Number(assignmentId)) {
      localStorage.removeItem(CHECKOUT_DRAFT_LS_KEY)
    }
  }

  function touchCheckoutDraft() {
    saveCheckoutDraftToDisk()
  }

  function applyPersistedCheckoutDraft(persisted) {
    if (!persisted || !persisted.draft) return false
    const members = (state.checkout && state.checkout.members) || []
    let applied = 0
    members.forEach((m) => {
      const k = checkoutDraftKey(m.studentId)
      const src = persisted.draft[k]
      if (!src) return
      if (isCheckoutRowLocked(m)) return
      const d = getCheckoutDraft(m.studentId)
      let st = src.finishStatus || ''
      if ((st === '1' || st === '2') && isCheckoutSelfRow(m)) st = ''
      d.finishStatus = st
      d.difficultyNote = src.difficultyNote || ''
      d.knowledgeIds = Array.isArray(src.knowledgeIds) ? src.knowledgeIds.map(Number).filter(Boolean) : []
      applied++
    })
    return applied > 0
  }

  function openCheckoutFlow() {
    openTodayFlow()
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
      $('ackAssign').textContent = formatAssign(asg, { withSubject: true, empty: '今日布置' })
    }
    if ($('ackFinish')) $('ackFinish').textContent = finishLabel(item.finishStatus)
    if ($('ackKnow')) {
      const names = item.knowledgeNames || []
      $('ackKnow').textContent = names.length ? ('知识主题：' + names.join('、')) : '知识主题：未标注'
    }
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

  function checkoutDraftKey(studentId) {
    return String(studentId == null ? '' : studentId)
  }

  function checkoutMeId() {
    const co = state.checkout || {}
    const p = state.profile || {}
    return String(co.studentId || p.studentId || '')
  }

  function isCheckoutSelfRow(m) {
    if (!m) return false
    const me = checkoutMeId()
    if (me) return checkoutDraftKey(m.studentId) === me
    return m.roleInGroup === '1' || m.roleInGroup === 1
  }

  function getCheckoutDraft(studentId) {
    const k = checkoutDraftKey(studentId)
    if (!state.checkoutDraft[k]) {
      state.checkoutDraft[k] = { finishStatus: '', difficultyNote: '', knowledgeIds: [], knowMore: false }
    }
    if (!Array.isArray(state.checkoutDraft[k].knowledgeIds)) state.checkoutDraft[k].knowledgeIds = []
    return state.checkoutDraft[k]
  }

  function checkoutSelfDoneBlocked() {
    const members = (state.checkout && state.checkout.members) || []
    for (let i = 0; i < members.length; i++) {
      const m = members[i]
      if (!isCheckoutSelfRow(m)) continue
      const d = getCheckoutDraft(m.studentId)
      // 组长禁止自评已完成/部分
      if (d.finishStatus === '1' || d.finishStatus === '2') return m
    }
    return null
  }

  function memberNeedsKnowledge(d) {
    const st = (d && d.finishStatus) || ''
    return st === '1' || st === '2' || st === '3'
  }

  function ensureCheckoutDefaultKnow(d) {
    if (!d || !memberNeedsKnowledge(d)) return
    if ((d.knowledgeIds || []).length) return
    const defs = state.checkoutDefaultKnow || []
    if (defs.length) d.knowledgeIds = defs.slice()
  }

  function isCheckoutDraftReady(m) {
    if (!m) return false
    if (isCheckoutRowLocked(m)) return true
    const d = getCheckoutDraft(m.studentId)
    if (!d.finishStatus) return false
    if (isCheckoutSelfRow(m) && d.finishStatus === '1') return false
    if (memberNeedsKnowledge(d) && !(d.knowledgeIds || []).length) return false
    if (d.finishStatus === '3' && !(d.difficultyNote || '').trim()) return false
    return true
  }

  function focusCheckoutIssue(studentId, kind) {
    const sid = checkoutDraftKey(studentId)
    const row = document.querySelector('.checkout-row[data-row="' + sid + '"]')
    if (row && row.scrollIntoView) {
      row.scrollIntoView({ behavior: 'smooth', block: 'center' })
      row.classList.add('flash-issue')
      setTimeout(() => row.classList.remove('flash-issue'), 1200)
    }
    if (kind === 'note') {
      const inp = row && row.querySelector('[data-note]')
      if (inp) setTimeout(() => { try { inp.focus() } catch (e) { /* ignore */ } }, 220)
    }
  }

  function checkoutMissingKnowledge() {
    const members = (state.checkout && state.checkout.members) || []
    for (let i = 0; i < members.length; i++) {
      const m = members[i]
      if (isCheckoutRowLocked(m)) continue
      const d = getCheckoutDraft(m.studentId)
      if (memberNeedsKnowledge(d) && !(d.knowledgeIds || []).length) return m
    }
    return null
  }

  function toggleMemberKnowledge(studentId, kid) {
    const id = Number(kid)
    if (!id) return
    const d = getCheckoutDraft(studentId)
    const cur = (d.knowledgeIds || []).map(Number)
    const i = cur.indexOf(id)
    if (i >= 0) cur.splice(i, 1)
    else cur.push(id)
    d.knowledgeIds = cur
    renderCheckoutMembers()
    touchCheckoutDraft()
  }

  function copyFirstKnowledgeToOthers() {
    const members = (state.checkout && state.checkout.members) || []
    let src = null
    for (let i = 0; i < members.length; i++) {
      const d = getCheckoutDraft(members[i].studentId)
      if (memberNeedsKnowledge(d) && (d.knowledgeIds || []).length) {
        src = (d.knowledgeIds || []).map(Number)
        break
      }
    }
    if (!src || !src.length) {
      toast('请先为至少一人选好主题', 'warn')
      return
    }
    members.forEach((m) => {
      const d = getCheckoutDraft(m.studentId)
      if (memberNeedsKnowledge(d) && !(d.knowledgeIds || []).length) {
        d.knowledgeIds = src.slice()
      }
    })
    if ($('checkoutErr')) $('checkoutErr').textContent = '已将主题套用到尚未选题的组员'
    renderCheckoutMembers()
    touchCheckoutDraft()
  }

  function knowOptionsForRow() {
    const weak = state.checkoutWeak || []
    const all = state.checkoutKnowAll || []
    const seen = {}
    const out = []
    weak.concat(all).forEach((k) => {
      const id = Number(k.knowledgeId)
      if (!id || seen[id]) return
      seen[id] = true
      out.push({ knowledgeId: id, knowledgeName: k.knowledgeName, weak: !!k.weak })
    })
    return out
  }

  async function loadCheckoutKnowledgeOptions() {
    const co = state.checkout || {}
    const asg = co.assignment || {}
    const sid = asg.subjectId
    state.checkoutWeak = (co.weakKnowledge || []).map((k) => ({
      knowledgeId: k.knowledgeId,
      knowledgeName: k.knowledgeName,
      weak: true
    }))
    state.checkoutKnowAll = []
    if (!sid) {
      renderCheckoutMembers()
      return
    }
    try {
      const [weakRes, treeRes] = await Promise.all([
        api('GET', '/spas/practice/suggest/weak?limit=10&subjectId=' + sid).catch(() => ({ data: [] })),
        api('GET', '/spas/knowledge/tree/' + sid).catch(() => ({ data: [] }))
      ])
      const weak = (weakRes.data || []).map((k) => ({
        knowledgeId: k.knowledgeId,
        knowledgeName: k.knowledgeName,
        weak: true
      }))
      if (weak.length) state.checkoutWeak = weak
      const flat = []
      flattenTree(treeRes.data || [], flat)
      state.checkoutKnowAll = flat.filter((k) => k.knowledgeId).slice(0, 80)
    } catch (e) { /* keep bundle weak */ }
    renderCheckoutMembers()
  }

  function updateCheckoutProgress() {
    const members = (state.checkout && state.checkout.members) || []
    const total = members.length
    let statusFilled = 0
    let readyCount = 0
    let hardMissing = 0
    members.forEach((m) => {
      const d = getCheckoutDraft(m.studentId)
      if (d.finishStatus || isCheckoutRowLocked(m)) statusFilled += 1
      if (isCheckoutDraftReady(m)) readyCount += 1
      if (!isCheckoutRowLocked(m) && d.finishStatus === '3' && !(d.difficultyNote || '').trim()) hardMissing += 1
    })
    const selfBlocked = checkoutSelfDoneBlocked()
    const missKnow = checkoutMissingKnowledge()
    const pct = total > 0 ? Math.round((readyCount / total) * 100) : 0
    if ($('checkoutProgressFill')) $('checkoutProgressFill').style.width = pct + '%'
    if ($('checkoutProgress')) {
      let text = '可提交 ' + readyCount + ' / ' + total
      if (selfBlocked) text += ' · 组长勿自评已完成/部分'
      else if (missKnow) text += ' · ' + (missKnow.studentName || '') + '待选主题'
      else if (hardMissing) text += ' · ' + hardMissing + ' 人待填卡点'
      else if (statusFilled < total) text += ' · 还需点选 ' + (total - statusFilled) + ' 人'
      $('checkoutProgress').textContent = text
    }
    const btn = $('btnCheckoutSubmit')
    if (btn) {
      const ready = total > 0 && readyCount === total && !selfBlocked
      btn.disabled = !ready
      if (selfBlocked) btn.textContent = '请先改掉组长的完成类自评'
      else if (missKnow) btn.textContent = '请为「' + (missKnow.studentName || '组员') + '」选主题'
      else if (ready) btn.textContent = (state.checkout && state.checkout.checkout) ? '改正并重新提交' : '提交本组检查单'
      else if (statusFilled < total) btn.textContent = '还需点选 ' + (total - statusFilled) + ' 人'
      else if (hardMissing) btn.textContent = '请填写卡点说明'
      else btn.textContent = '请为全员点选状态'
    }
    if (selfBlocked && $('checkoutErr')) {
      $('checkoutErr').textContent = '禁止自检自评为已完成/部分：请给「' +
        (selfBlocked.studentName || '组长') + '」改选「有困难 / 未做 / 请假 / 未到」'
    }
  }

  function isCheckoutRowLocked(m) {
    if (!m) return false
    if (m.voided === '1' || (m.spotResult && String(m.spotResult))) return true
    const ack = m.memberAck == null ? '0' : String(m.memberAck)
    if (ack === '2' || ack === '3') return true
    // 属实过的完成类结果锁定；请假/未到/未做的自动确认仍可改正
    if (ack === '1' && m.finishStatus && ['1', '2', '3'].indexOf(m.finishStatus) >= 0) return true
    return false
  }

  function applyCheckoutBatch(mode) {
    const members = (state.checkout && state.checkout.members) || []
    members.forEach((m) => {
      if (isCheckoutRowLocked(m)) return
      const d = getCheckoutDraft(m.studentId)
      if (mode === 'clear') {
        d.finishStatus = ''
        d.difficultyNote = ''
        d.knowledgeIds = []
        return
      }
      if (String(mode) === '1' && isCheckoutSelfRow(m)) {
        // 组长不预填完成类状态，须自行点选困难/未做/请假/未到
        d.finishStatus = ''
        d.difficultyNote = ''
        d.knowledgeIds = []
        return
      }
      d.finishStatus = String(mode)
      if (String(mode) !== '3') d.difficultyNote = ''
      if (!memberNeedsKnowledge(d)) d.knowledgeIds = []
      else ensureCheckoutDefaultKnow(d)
    })
    if ($('checkoutErr')) {
      $('checkoutErr').textContent = (String(mode) === '1')
        ? '组员已标「已完成」并预填默认主题；请组长为自己点选有困难/未做/请假/未到。已确认/已抽检行不会被改。'
        : ''
    }
    renderCheckoutMembers()
    touchCheckoutDraft()
    const leaderRow = document.querySelector('.checkout-row.is-leader')
    if (leaderRow && typeof leaderRow.scrollIntoView === 'function') {
      leaderRow.scrollIntoView({ block: 'nearest', behavior: 'smooth' })
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
    const fromBundle = (co.knowledgeIds || []).map(Number).filter(Boolean)
    const fromAsgList = (asg.knowledgeIdList || []).map(Number).filter(Boolean)
    const defaultKnow = fromBundle.length
      ? fromBundle
      : (fromAsgList.length ? fromAsgList : (asg.knowledgeId ? [Number(asg.knowledgeId)] : []))
    state.checkoutDefaultKnow = defaultKnow.slice()
    ;(co.members || []).forEach((m) => {
      const d = getCheckoutDraft(m.studentId)
      const st = m.finishStatus || ''
      d.finishStatus = ((st === '1' || st === '2') && isCheckoutSelfRow(m)) ? '' : st
      d.difficultyNote = m.difficultyNote || ''
      const fromItem = (m.knowledgeIds || []).map(Number).filter(Boolean)
      d.knowledgeIds = fromItem.length ? fromItem : (memberNeedsKnowledge(d) ? defaultKnow.slice() : [])
      d.knowMore = false
    })
    // Restore local draft (offline / interrupted) for same assignment + day + leader
    const persisted = loadCheckoutDraftFromDisk()
    const meta = checkoutDiskMeta()
    const day = meta.practiceDate || ''
    let restored = false
    if (persisted && Number(persisted.assignmentId) === Number(asg.assignmentId)
      && (!day || !persisted.practiceDate || String(persisted.practiceDate) === String(day))
      && (!meta.studentId || !persisted.studentId || Number(persisted.studentId) === Number(meta.studentId))) {
      restored = applyPersistedCheckoutDraft(persisted)
    }
    const pagePart = asg.pageFrom
      ? ('p.' + asg.pageFrom + (asg.pageTo && asg.pageTo !== asg.pageFrom ? ('-' + asg.pageTo) : ''))
      : ''
    if ($('checkoutAssign')) {
      $('checkoutAssign').textContent = [
        asg.subjectName || '',
        asg.bookName || '',
        pagePart,
        asg.questionText ? ('题 ' + asg.questionText) : '',
        defaultKnow.length ? ('默认主题 ' + defaultKnow.length + ' 个') : ''
      ].filter(Boolean).join(' · ') || '今日已布置'
    }
    if ($('checkoutDef')) {
      const def = asg.completeDefinition || '指定题有书写且能口述关键步骤'
      $('checkoutDef').textContent = '已完成定义：' + def +
        (defaultKnow.length
          ? ' · 已预填默认主题，可按人改；组长不可自评已完成/部分'
          : ' · 请假/未到可不选题；组长不可自评已完成/部分') +
        ' · 填写过程自动本地保存，断网可稍后同步'
    }
    if ($('checkoutErr')) {
      $('checkoutErr').textContent = restored ? '已恢复本机未提交草稿，请核对后提交' : ''
    }
    if (restored) toast('已恢复未提交的检查单草稿', 'ok')
    renderCheckoutMembers()
    touchCheckoutDraft()
    loadCheckoutKnowledgeOptions()
    show('viewCheckout')
  }

  function renderCheckoutMembers() {
    const box = $('checkoutMembers')
    if (!box) return
    const members = (state.checkout && state.checkout.members) || []
    if (!members.length) {
      box.innerHTML = '<div class="check-empty">暂无组员，请先在 Web 端维护学习小组</div>'
      updateCheckoutProgress()
      return
    }
    const opts = knowOptionsForRow()
    const weakOpts = opts.filter((k) => k.weak).slice(0, 8)
    const moreOpts = opts.slice(0, 40)
    box.innerHTML = members.map((m) => {
      const sid = checkoutDraftKey(m.studentId)
      const d = getCheckoutDraft(m.studentId)
      const locked = isCheckoutRowLocked(m)
      if (!locked && (d.finishStatus === '1' || d.finishStatus === '2') && isCheckoutSelfRow(m)) d.finishStatus = ''
      const self = isCheckoutSelfRow(m)
      const statuses = self
        ? [['3', '有困难'], ['0', '未做'], ['L', '请假'], ['A', '未到/没带本']]
        : [['1', '已完成'], ['2', '部分'], ['0', '未做'], ['3', '有困难'], ['L', '请假'], ['A', '未到/没带本']]
      const set = !!d.finishStatus
      const needKnow = !locked && memberNeedsKnowledge(d)
      const selected = (d.knowledgeIds || []).map(Number)
      const picks = statuses.map((s) =>
        '<button type="button" data-stu="' + sid + '" data-st="' + s[0] + '"' +
        (locked ? ' disabled' : '') + ' class="' +
        (d.finishStatus === s[0] ? 'on' : '') + '">' + s[1] + '</button>'
      ).join('')
      const note = (!locked && d.finishStatus === '3')
        ? ('<input class="input lg checkout-note" data-note="' + sid +
          '" placeholder="卡点说明必填：哪一题卡住了？" value="' + escapeHtml(d.difficultyNote || '') + '" />')
        : (locked && d.difficultyNote
          ? ('<div class="muted">卡点：' + escapeHtml(d.difficultyNote) + '</div>')
          : '')
      let knowHtml = ''
      if (needKnow) {
        const chips = (weakOpts.length ? weakOpts : moreOpts.slice(0, 8)).map((k) =>
          '<button type="button" class="chip tap' + (selected.indexOf(Number(k.knowledgeId)) >= 0 ? ' on' : '') +
          '" data-stu="' + sid + '" data-ckid="' + k.knowledgeId + '">' +
          escapeHtml(k.knowledgeName || '') + (k.weak ? '·薄' : '') + '</button>'
        ).join('')
        const more = d.knowMore
          ? ('<div class="row-know-more">' + moreOpts.map((k) =>
            '<button type="button" class="chip tap' + (selected.indexOf(Number(k.knowledgeId)) >= 0 ? ' on' : '') +
            '" data-stu="' + sid + '" data-ckid="' + k.knowledgeId + '">' +
            escapeHtml(k.knowledgeName || '') + '</button>'
          ).join('') + '</div>')
          : ''
        knowHtml = '<div class="row-know' + (selected.length ? '' : ' need') + '">' +
          '<div class="row-know-label">知识主题' + (selected.length ? '' : '（必选）') + '</div>' +
          '<div class="row-know-picks">' + (chips || '<span class="muted">加载主题中…</span>') +
          '<button type="button" class="chip tap" data-stu="' + sid + '" data-know-more="1">' +
          (d.knowMore ? '收起' : '更多') + '</button></div>' + more + '</div>'
      } else if (locked && selected.length) {
        knowHtml = '<div class="muted">主题已锁定</div>'
      }
      let tag
      if (locked) {
        const ack = String(m.memberAck || '0')
        tag = ack === '2' ? '<span class="tag warn">有异议 · 已锁定</span>'
          : (ack === '3' ? '<span class="tag warn">超时 · 已锁定</span>'
            : (m.spotResult ? '<span class="tag warn">已抽检 · 锁定</span>'
              : '<span class="tag warn">已确认 · 锁定</span>'))
      } else if (self) {
        tag = set
          ? '<span class="tag warn">组长 · 已点选（不可自评完成/部分）</span>'
          : '<span class="tag warn">组长 · 请点选（无已完成/部分）</span>'
      } else {
        tag = set ? '<span class="tag">已点选</span>' : '<span class="tag">待点选</span>'
      }
      return '<div class="checkout-row' + (set ? ' is-set' : '') + (self ? ' is-leader' : '') +
        (locked ? ' is-locked' : '') +
        (!set && self && !locked ? ' need-pick' : '') + (needKnow && !selected.length ? ' need-know' : '') +
        '" data-row="' + sid + '">' +
        '<div class="name-row"><div class="name">' + escapeHtml(m.studentName || '') + '</div>' + tag + '</div>' +
        '<div class="st-picks">' + picks + '</div>' + knowHtml + note + '</div>'
    }).join('')
    updateCheckoutProgress()
  }

  async function submitCheckoutSheet() {
    const co = state.checkout || {}
    if (!co.assignment) return
    const amending = !!co.checkout
    const blocked = checkoutSelfDoneBlocked()
    if (blocked) {
      const msg = '禁止自检自评为已完成：请改选「' + (blocked.studentName || '组长') + '」的状态'
      if ($('checkoutErr')) $('checkoutErr').textContent = msg
      toast(msg, 'warn')
      renderCheckoutMembers()
      focusCheckoutIssue(blocked.studentId)
      updateCheckoutProgress()
      return
    }
    const missKnow = checkoutMissingKnowledge()
    if (missKnow) {
      const msg = '请为「' + (missKnow.studentName || '组员') + '」选择知识主题'
      if ($('checkoutErr')) $('checkoutErr').textContent = msg
      toast(msg, 'warn')
      renderCheckoutMembers()
      focusCheckoutIssue(missKnow.studentId)
      updateCheckoutProgress()
      return
    }
    if (amending) {
      const ok = await promptConfirm('改正检查单？', '未锁定行会更新；已确认/异议/超时/已抽检行保持不变。')
      if (!ok) return
    }
    const members = co.members || []
    const items = []
    for (let i = 0; i < members.length; i++) {
      const m = members[i]
      if (isCheckoutRowLocked(m)) {
        // 原样回传，避免被当成「改正」
        items.push({
          studentId: m.studentId,
          finishStatus: m.finishStatus,
          difficultyNote: m.difficultyNote || '',
          knowledgeIdList: (m.knowledgeIds || []).map(Number).filter(Boolean)
        })
        continue
      }
      const d = getCheckoutDraft(m.studentId)
      if (!d.finishStatus) {
        if ($('checkoutErr')) $('checkoutErr').textContent = '请为全员选择状态：' + (m.studentName || '')
        toast('请为「' + (m.studentName || '组员') + '」点选状态', 'warn')
        focusCheckoutIssue(m.studentId)
        return
      }
      if (d.finishStatus === '3' && !(d.difficultyNote || '').trim()) {
        if ($('checkoutErr')) $('checkoutErr').textContent = '有困难必须填卡点：' + (m.studentName || '')
        toast('请填写「' + (m.studentName || '组员') + '」的卡点说明', 'warn')
        focusCheckoutIssue(m.studentId, 'note')
        return
      }
      items.push({
        studentId: m.studentId,
        finishStatus: d.finishStatus,
        difficultyNote: d.difficultyNote || '',
        knowledgeIdList: memberNeedsKnowledge(d) ? (d.knowledgeIds || []).map(Number).filter(Boolean) : []
      })
    }
    const clientRequestId = 'co_' + co.assignment.assignmentId + '_' +
      ((state.config && state.config.deviceCode) || 'dev') + '_' + Date.now()
    const payload = {
      assignmentId: co.assignment.assignmentId,
      deviceCode: (state.config && state.config.deviceCode) || '',
      clientRequestId: clientRequestId,
      items: items
    }
    const queueMeta = {
      kind: 'checkout',
      path: '/spas/practice/checkout',
      assignmentId: co.assignment.assignmentId,
      studentId: (state.profile && state.profile.studentId) || null,
      clientRequestId: clientRequestId,
      payload: payload
    }

    const enqueueAndLeave = async (reasonTip) => {
      touchCheckoutDraft()
      enqueue(queueMeta)
      updateQueueBadge()
      toast(reasonTip || '检查单已暂存，联网后自动同步', 'ok')
      if ($('checkoutErr')) $('checkoutErr').textContent = '已暂存本机离线队列，恢复网络后点「同步离线」或自动上传'
      try { await loadHome() } catch (e) { /* ignore */ }
      show('viewHome')
    }

    if (!state.online || !navigator.onLine) {
      await enqueueAndLeave('当前离线：检查单已暂存，联网后自动同步')
      return
    }

    setLoading(true, amending ? '改正检查单…' : '提交检查单…')
    try {
      const res = await api('POST', '/spas/practice/checkout', payload)
      const pts = Number(res.awardedPoints) || 0
      clearCheckoutDraftFromDisk(co.assignment.assignmentId)
      // Drop any pending offline copy for this assignment
      saveQueue(loadQueue().filter((x) => !(isCheckoutQueueItem(x)
        && Number(x.assignmentId) === Number(co.assignment.assignmentId))))
      updateQueueBadge()
      toast((amending
        ? '已更新未锁定行，组员请当日确认'
        : '检查单已提交，请组员当日确认') + (pts > 0 ? (' · 积分 +' + pts) : ''), 'ok')
      await loadHome()
      show('viewHome')
    } catch (e) {
      const msg = e.message || '提交失败'
      if (!navigator.onLine || /Failed to fetch|NetworkError|network|超时/i.test(msg)) {
        await enqueueAndLeave('网络异常：检查单已暂存，联网后自动同步')
        return
      }
      if ($('checkoutErr')) $('checkoutErr').textContent = msg
      toast(msg, 'err')
      touchCheckoutDraft()
    } finally {
      setLoading(false)
    }
  }


  function logout(silent) {
    stopButterflyFlight()
    state.token = ''
    state.mode = 'student'
    state.roles = []
    state.permissions = []
    state.user = null
    state.profile = null
    state.dashOpen = false
    state.lastTemplate = null
    state.points = null
    state.ledger = []
    state.prevLevelNo = null
    state.prevFarmStage = null
    state.leveledUpTo = null
    state.farmStageUpTo = null
    state.lastAwardedPoints = 0
    state.boardRange = 'week'
    state.today = null
    state.weak = []
    state.weakSubjectId = null
    state.recentLogs = []
    state.proxyStudentId = null
    state.proxyStudentName = ''
    state.pendingPayload = null
    state.rejectLogId = null
    state.dlgResolve = null
    state.farmReadOnly = false
    state.supervise = {
      depts: [], deptId: null, subjectId: null, practiceDate: '',
      tab: 'spot', alerts: {}, spotQueue: [], assignment: null
    }
    applyModeChrome()
    clearSuccessTimer()
    localStorage.removeItem('spas_desktop_token')
    clearTimeout(state.idleTimer)
    clearTimeout(state.idleWarnTimer)
    $('idleBanner').hidden = true
    $('loginPwd').value = ''
    if ($('loginCode')) $('loginCode').value = ''
    if ($('successPoints')) $('successPoints').hidden = true
    if ($('successLevelUp')) $('successLevelUp').hidden = true
    if ($('successBoost')) $('successBoost').hidden = true
    closeQueueDlg()
    show('viewLogin')
    renderRecentUsers()
    updateQueueBadge()
    prepareLoginView()
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
        ? '可以提交了'
        : ('还差：' + r.miss.join('、'))
    }
    document.querySelectorAll('#readyDots i').forEach((dot) => {
      const map = { theme: r.hasTheme, book: r.hasBook, q: r.hasQ, finish: r.hasFinish }
      dot.classList.toggle('on', !!map[dot.dataset.k])
    })
    if (btn && !state.busy) {
      btn.disabled = !r.ready
      btn.textContent = r.ready ? '提交加练' : '请先补全必填项'
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
    if (isStaffMode()) {
      enterStaffMode().catch((e) => toast(e.message || '加载失败', 'err'))
      return
    }
    loadHome().then(() => show('viewHome')).catch(() => show('viewHome'))
  }

  function openSettings() {
    openSetup(state.token ? (isStaffMode() ? 'viewSupervise' : 'viewHome') : 'viewLogin')
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
    if (btn.dataset.emptyCta === 'practice') openTodayFlow()
    else if (btn.dataset.emptyCta === 'extra') openPracticeSmart(false)
  }

  function syncTitlebarChrome() {
    const kiosk = !!(state.config && state.config.kiosk)
    document.body.classList.toggle('kiosk-chrome', kiosk)
    if ($('titlebarTitle')) {
      $('titlebarTitle').textContent = (state.config && state.config.title) || '知脉 · 每日自主练'
    }
    syncMaximizeBtn()
  }

  async function syncMaximizeBtn() {
    const btn = $('btnWinMax')
    if (!btn || !window.spasDesktop || !window.spasDesktop.windowIsMaximized) return
    try {
      const max = await window.spasDesktop.windowIsMaximized()
      document.body.classList.toggle('is-maximized', !!max)
      btn.title = max ? '还原' : '最大化'
      btn.setAttribute('aria-label', btn.title)
      btn.textContent = max ? '❐' : '▢'
    } catch (e) { /* ignore */ }
  }

  function bindTitlebar() {
    if ($('btnWinMin')) {
      $('btnWinMin').onclick = () => {
        if (window.spasDesktop && window.spasDesktop.windowMinimize) window.spasDesktop.windowMinimize()
      }
    }
    if ($('btnWinMax')) {
      $('btnWinMax').onclick = async () => {
        if (window.spasDesktop && window.spasDesktop.windowMaximizeToggle) {
          await window.spasDesktop.windowMaximizeToggle()
          syncMaximizeBtn()
        }
      }
    }
    if ($('btnWinClose')) {
      $('btnWinClose').onclick = () => {
        if (window.spasDesktop && window.spasDesktop.windowClose) window.spasDesktop.windowClose()
      }
    }
    window.addEventListener('resize', () => {
      clearTimeout(syncMaximizeBtn._t)
      syncMaximizeBtn._t = setTimeout(() => {
        syncMaximizeBtn()
        onFarmViewportResize()
      }, 120)
    })
  }

  /** 农场视口：拖拽平移 + 滚轮缩放（与点选互不抢） */
  function bindFarmGestures(clearFarmFocus) {
    const vp = $('classFarmViewport')
    if (!vp || vp.dataset.farmGesturesBound === '1') return
    vp.dataset.farmGesturesBound = '1'
    let pan = null

    vp.addEventListener('pointerdown', (e) => {
      if (e.button !== 0) return
      if (e.target.closest('button, a, input, .farm-zoom-actions')) return
      const yard = $('classFarmYard')
      if (!yard) return
      pan = {
        id: e.pointerId,
        x: e.clientX,
        y: e.clientY,
        left: parseFloat(yard.style.left) || 0,
        top: parseFloat(yard.style.top) || 0,
        moved: false
      }
      state.farmPanMoved = false
      try { vp.setPointerCapture(e.pointerId) } catch (_) {}
    })

    vp.addEventListener('pointermove', (e) => {
      if (!pan || e.pointerId !== pan.id) return
      const dx = e.clientX - pan.x
      const dy = e.clientY - pan.y
      if (!pan.moved && Math.hypot(dx, dy) < 10) return
      pan.moved = true
      state.farmPanMoved = true
      const yard = $('classFarmYard')
      if (!yard) return
      yard.style.left = Math.round(pan.left + dx) + 'px'
      yard.style.top = Math.round(pan.top + dy) + 'px'
      vp.classList.add('is-panning')
    })

    const endPan = (e) => {
      if (!pan || (e && e.pointerId !== pan.id)) return
      const moved = pan.moved
      pan = null
      vp.classList.remove('is-panning')
      if (moved) {
        // 让紧随其后的 click 被忽略，再清掉标记
        setTimeout(() => { state.farmPanMoved = false }, 40)
      } else {
        state.farmPanMoved = false
      }
    }
    vp.addEventListener('pointerup', endPan)
    vp.addEventListener('pointercancel', endPan)

    vp.addEventListener('wheel', (e) => {
      if ($('viewFarm') && $('viewFarm').hidden) return
      e.preventDefault()
      bumpFarmZoom(e.deltaY > 0 ? -0.08 : 0.08)
    }, { passive: false })

    // 空白处单击已在 bind() 里 clear；此处仅占位避免未使用告警
    void clearFarmFocus
  }

  function bind() {
    bindTitlebar()
    $('btnLogin').onclick = login
    $('captchaImg').onclick = refreshCaptcha
    if ($('navLogout')) $('navLogout').onclick = () => logout(false)
    if ($('navHome')) $('navHome').onclick = goHome
    if ($('navPractice')) $('navPractice').onclick = () => { if (!isStaffMode()) openTodayFlow() }
    if ($('navQuickAdd')) $('navQuickAdd').onclick = () => { if (!isStaffMode()) openPracticeSmart(false) }
    if ($('btnAsidePractice')) $('btnAsidePractice').onclick = () => { if (!isStaffMode()) openTodayFlow() }
    if ($('navHistory')) $('navHistory').onclick = () => { if (!isStaffMode()) loadHistory() }
    if ($('navFarm')) {
      $('navFarm').onclick = () => {
        if (isStaffMode()) openClassFarm({ readOnly: true })
        else openClassFarm()
      }
    }
    if ($('navCheckout')) $('navCheckout').onclick = () => { if (!isStaffMode()) openTodayFlow({ leaderOnly: true }) }
    if ($('navSettings')) $('navSettings').onclick = openSettings
    if ($('btnHeadSettings')) $('btnHeadSettings').onclick = openSettings
    if ($('btnHistoryHome')) $('btnHistoryHome').onclick = goHome
    if ($('btnFarmHome')) {
      $('btnFarmHome').onclick = () => {
        if (isStaffMode()) show('viewSupervise')
        else goHome()
      }
    }
    if ($('btnFarmZoomOut')) $('btnFarmZoomOut').onclick = () => bumpFarmZoom(-0.1)
    if ($('btnFarmZoomIn')) $('btnFarmZoomIn').onclick = () => bumpFarmZoom(0.1)
    if ($('btnFarmZoomReset')) $('btnFarmZoomReset').onclick = () => setFarmZoom(1, { scrollToMe: true })
    if ($('btnFarmMute')) $('btnFarmMute').onclick = () => setAudioMute(!isAudioMuted())
    if ($('btnFarmFxToggle')) $('btnFarmFxToggle').onclick = () => cycleFarmFxMode()
    if ($('btnFarmFxCycle')) $('btnFarmFxCycle').onclick = () => cycleFarmFxMode()
    if ($('btnQuickMute')) $('btnQuickMute').onclick = () => setAudioMute(!isAudioMuted())
    if ($('btnQuickFx')) $('btnQuickFx').onclick = () => cycleFarmFxMode()
    if ($('btnFarmTourOk')) {
      $('btnFarmTourOk').onclick = (e) => {
        e.preventDefault()
        e.stopPropagation()
        dismissFarmTour()
      }
    }
    if ($('farmTour')) {
      $('farmTour').onclick = (e) => {
        // 点遮罩空白处也可关闭；点卡片本体不关
        if (e.target === $('farmTour')) dismissFarmTour()
      }
    }
    if ($('classFarmLegend')) {
      $('classFarmLegend').onclick = (e) => {
        const btn = e.target.closest('[data-stage-filter]')
        if (!btn) return
        applyFarmStageFilter(btn.dataset.stageFilter)
      }
    }
    if ($('btnFarmRefresh')) {
      $('btnFarmRefresh').onclick = async () => {
        setLoading(true, '刷新农场…')
        try {
          const deptId = state.farmReadOnly && state.supervise ? state.supervise.deptId : null
          await loadClassFarm(deptId)
          const vp = $('classFarmViewport')
          if (vp) {
            farmFx.burst(vp.clientWidth * 0.5, vp.clientHeight * 0.42, {
              count: 36,
              colors: ['#86efac', '#fde047', '#f9a8d4', '#fdba74']
            })
          }
          farmAudio.refresh()
          toast('已刷新', 'ok')
        } catch (e) { toast(e.message || '刷新失败', 'err') }
        finally { setLoading(false) }
      }
    }
    if ($('btnOpenClassFarm')) $('btnOpenClassFarm').onclick = (e) => { e.stopPropagation(); openClassFarm() }
    if ($('btnSuperviseFarm')) {
      $('btnSuperviseFarm').onclick = () => openClassFarm({ readOnly: true })
    }
    const keepMyNameplateOn = () => {
      document.querySelectorAll('.iso-nameplate.me').forEach((n) => n.classList.add('on'))
    }
    const clearFarmFocus = () => {
      document.querySelectorAll('.iso-nameplate.on').forEach((n) => {
        if (!n.classList.contains('me')) n.classList.remove('on')
      })
      document.querySelectorAll('.iso-plot.is-focus').forEach((n) => n.classList.remove('is-focus'))
      keepMyNameplateOn()
      if ($('classFarmHint')) $('classFarmHint').textContent = defaultClassFarmHint()
    }
    const farmClick = (el, evt) => {
      if (!el) return
      if (state.farmPanMoved) return
      // 双击的第二次 click 交给 farmWater，避免先收起再浇水
      if (evt && evt.detail > 1) return
      if (evt) {
        evt.preventDefault()
        evt.stopPropagation()
      }
      const sid = el.getAttribute('data-student-id')
      const sidSel = String(sid || '').replace(/\\/g, '\\\\').replace(/"/g, '\\"')
      const plot = sid && $('classFarmGrid')
        ? $('classFarmGrid').querySelector('.iso-plot[data-student-id="' + sidSel + '"]')
        : (el.classList && el.classList.contains('iso-plot') ? el : null)
      const plate = sid && $('classFarmNames')
        ? $('classFarmNames').querySelector('.iso-nameplate[data-student-id="' + sidSel + '"]')
        : null
      const wasOn = !!(plot && plot.classList.contains('is-focus'))
      clearFarmFocus()
      if (wasOn) return
      if (plot) {
        plot.classList.add('is-focus')
        const stage = plot.getAttribute('data-stage') || 'seed'
        farmFx.selectAt(plot, farmStageLabel(stage))
        farmAudio.tap()
        if ($('classFarmHint')) $('classFarmHint').textContent = classFarmFocusHint(plot, plate)
      }
      if (plate) {
        plate.classList.add('on')
        syncFarmNameplate(plate, plot)
      }
    }
    const farmWater = (el, evt) => {
      if (!el || state.farmPanMoved) return
      if (state.farmReadOnly) {
        toast('巡班只读：可点选查看，不可浇水', 'info')
        return
      }
      if (evt) {
        evt.preventDefault()
        evt.stopPropagation()
      }
      const sid = el.getAttribute('data-student-id')
      const sidSel = String(sid || '').replace(/\\/g, '\\\\').replace(/"/g, '\\"')
      const plot = sid && $('classFarmGrid')
        ? $('classFarmGrid').querySelector('.iso-plot[data-student-id="' + sidSel + '"]')
        : (el.classList && el.classList.contains('iso-plot') ? el : null)
      if (!plot) return
      if (!plot.classList.contains('is-focus')) farmClick(plot, null)
      farmFx.interactAt(plot, '浇水')
      farmAudio.water()
    }
    if ($('classFarmGrid')) {
      $('classFarmGrid').onclick = (e) => {
        const plot = e.target.closest('.iso-plot')
        if (plot) farmClick(plot, e)
      }
      $('classFarmGrid').ondblclick = (e) => {
        const plot = e.target.closest('.iso-plot')
        if (plot) farmWater(plot, e)
      }
      $('classFarmGrid').onkeydown = (e) => {
        if (e.key !== 'Enter' && e.key !== ' ') return
        const plot = e.target.closest('.iso-plot')
        if (plot) farmClick(plot, e)
      }
    }
    if ($('classFarmNames')) {
      $('classFarmNames').onclick = (e) => {
        const plate = e.target.closest('.iso-nameplate')
        if (plate) farmClick(plate, e)
      }
    }
    bindFarmGestures(clearFarmFocus)
    if ($('classFarmViewport')) {
      $('classFarmViewport').onclick = (e) => {
        if (state.farmPanMoved) return
        if (e.target.closest('.iso-plot, .iso-nameplate, .iso-name-tag')) return
        clearFarmFocus()
      }
    }
    if ($('btnSetupBack')) {
      $('btnSetupBack').onclick = () => show(state.setupReturn || (state.token ? (isStaffMode() ? 'viewSupervise' : 'viewHome') : 'viewLogin'))
    }
    if ($('btnSuperviseRefresh')) {
      $('btnSuperviseRefresh').onclick = async () => {
        setLoading(true, '刷新中…')
        try { await refreshSupervise(); toast('已刷新', 'ok') }
        catch (e) { toast(e.message || '刷新失败', 'err') }
        finally { setLoading(false) }
      }
    }
    if ($('superviseDeptChips')) {
      $('superviseDeptChips').onclick = (e) => {
        const chip = e.target.closest('[data-dept-id]')
        if (!chip) return
        state.supervise.deptId = Number(chip.dataset.deptId)
        renderSuperviseDeptChips()
        refreshSupervise()
      }
    }
    if ($('superviseDate')) {
      $('superviseDate').onchange = () => {
        state.supervise.practiceDate = $('superviseDate').value || todayStr()
        refreshSupervise()
      }
    }
    if ($('superviseSubject')) {
      $('superviseSubject').onchange = () => {
        const v = $('superviseSubject').value
        state.supervise.subjectId = v ? Number(v) : null
        refreshSupervise()
      }
    }
    if ($('superviseTabs')) {
      $('superviseTabs').onclick = (e) => {
        const tab = e.target.closest('[data-sup-tab]')
        if (!tab) return
        setSuperviseTab(tab.dataset.supTab)
      }
    }
    if ($('superviseKpi')) {
      $('superviseKpi').onclick = (e) => {
        const kpi = e.target.closest('[data-sup-tab]')
        if (!kpi) return
        setSuperviseTab(kpi.dataset.supTab)
      }
    }
    const superviseClick = (e) => {
      const row = e.target.closest('[data-item-id]')
      if (!row) return
      const itemId = Number(row.dataset.itemId)
      const resolveBtn = e.target.closest('[data-resolve]')
      if (resolveBtn) { staffResolveItem(itemId, resolveBtn.dataset.resolve); return }
      const spotBtn = e.target.closest('[data-spot]')
      if (spotBtn) { staffSpotItem(itemId, spotBtn.dataset.spot); return }
      if (e.target.closest('[data-follow]')) { staffFollowItem(itemId); return }
      if (e.target.closest('[data-intervene]')) { staffInterveneItem(itemId); return }
    }
    ;['supDisputeList', 'supTimeoutList', 'supSpotList', 'supHardList'].forEach((id) => {
      if ($(id)) $(id).onclick = superviseClick
    })
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
    if ($('featureCard')) $('featureCard').onclick = () => openTodayFlow()
    if ($('btnRefreshHome')) {
      $('btnRefreshHome').onclick = async () => {
        setLoading(true, '刷新中…')
        try { await loadHome(); toast('已刷新', 'ok') }
        catch (e) { toast(e.message || '刷新失败', 'err') }
        finally { setLoading(false) }
      }
    }
    if ($('homeFarm')) {
      $('homeFarm').onclick = (e) => {
        // 避免点进度条/里程碑也抢事件时重复；整块可点鼓励
        if (e.target.closest('button, a, input, select')) return
        cheerFarm()
      }
    }
    if ($('btnHomeHistory')) $('btnHomeHistory').onclick = () => loadHistory()
    if ($('btnTodayExpand')) {
      $('btnTodayExpand').onclick = () => { setDashOpen(true); switchHomeTab('done') }
    }
    if ($('btnWeakPractice')) {
      $('btnWeakPractice').onclick = () => openWeakPractice(3)
    }
    if ($('btnHomeCheckout')) $('btnHomeCheckout').onclick = () => openTodayFlow({ leaderOnly: true })
    if ($('homeAlerts')) {
      $('homeAlerts').onclick = async (e) => {
        const btn = e.target.closest('[data-home-alert]')
        if (!btn) return
        const act = btn.dataset.homeAlert
        if (act === 'practice') openTodayFlow()
        else if (act === 'checkout' || act === 'proxy') openTodayFlow({ leaderOnly: true })
        else if (act === 'ack') openAckView()
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
        const chip = e.target.closest('[data-check-hub], [data-proxy-id]')
        if (!chip || chip.disabled) return
        openTodayFlow({ leaderOnly: true })
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
    if ($('queueBadge')) $('queueBadge').onclick = () => openQueueDlg()
    if ($('btnQueueDlgClose')) $('btnQueueDlgClose').onclick = () => closeQueueDlg()
    if ($('btnQueueDlgFlush')) {
      $('btnQueueDlgFlush').onclick = async () => {
        setLoading(true, '同步中…')
        try {
          await flushQueue()
          if (state.token && !isStaffMode()) await loadHome()
          renderQueueDlg()
          if (!loadQueue().length) closeQueueDlg()
        } finally {
          setLoading(false)
        }
      }
    }
    if ($('queueDlgList')) {
      $('queueDlgList').onclick = async (e) => {
        const row = e.target.closest('.queue-item')
        if (!row) return
        const act = e.target.closest('[data-q-act]')
        if (!act) return
        const id = row.dataset.qid
        if (act.dataset.qAct === 'drop') dropQueueItem(id)
        else if (act.dataset.qAct === 'retry') await retryQueueItem(id)
      }
    }
    $('btnFlushQueue').onclick = async () => {
      openQueueDlg()
      setLoading(true, '同步中…')
      try {
        await flushQueue()
        if (state.token && !isStaffMode()) await loadHome()
        renderQueueDlg()
        if (!loadQueue().length) closeQueueDlg()
      } finally {
        setLoading(false)
      }
    }
    $('btnGoPractice').onclick = () => openTodayFlow()
    if ($('btnGoPractice2')) $('btnGoPractice2').onclick = () => openTodayFlow()
    if ($('btnGoExtra')) $('btnGoExtra').onclick = () => openPracticeSmart(false)
    if ($('btnCheckoutHome')) $('btnCheckoutHome').onclick = () => show('viewHome')
    if ($('btnCheckoutCancel')) $('btnCheckoutCancel').onclick = () => show('viewHome')
    if ($('btnCheckoutSubmit')) $('btnCheckoutSubmit').onclick = submitCheckoutSheet
    if ($('btnCheckoutAllDone')) $('btnCheckoutAllDone').onclick = () => applyCheckoutBatch('1')
    if ($('btnCheckoutClear')) $('btnCheckoutClear').onclick = () => applyCheckoutBatch('clear')
    if ($('btnCheckoutCopyKnow')) $('btnCheckoutCopyKnow').onclick = copyFirstKnowledgeToOthers
    if ($('btnAckHome')) $('btnAckHome').onclick = () => show('viewHome')
    if ($('btnAckYes')) $('btnAckYes').onclick = () => submitAck(true)
    if ($('btnAckNo')) $('btnAckNo').onclick = () => submitAck(false)
    if ($('checkoutMembers')) {
      $('checkoutMembers').onclick = (e) => {
        const knowMore = e.target.closest('[data-know-more]')
        if (knowMore) {
          const d = getCheckoutDraft(knowMore.dataset.stu)
          d.knowMore = !d.knowMore
          renderCheckoutMembers()
          return
        }
        const knowBtn = e.target.closest('[data-ckid]')
        if (knowBtn) {
          toggleMemberKnowledge(knowBtn.dataset.stu, knowBtn.dataset.ckid)
          return
        }
        const btn = e.target.closest('[data-st]')
        if (!btn) return
        const sid = checkoutDraftKey(btn.dataset.stu)
        const st = btn.dataset.st
        const members = (state.checkout && state.checkout.members) || []
        const row = members.find((m) => checkoutDraftKey(m.studentId) === sid)
        if ((st === '1' || st === '2') && row && isCheckoutSelfRow(row)) {
          if ($('checkoutErr')) $('checkoutErr').textContent = '禁止自检自评为已完成/部分，请选有困难/未做/请假/未到'
          toast('组长本人不能点「已完成/部分」', 'warn')
          return
        }
        const d = getCheckoutDraft(sid)
        d.finishStatus = st
        if (st !== '3') d.difficultyNote = ''
        if (!memberNeedsKnowledge(d)) d.knowledgeIds = []
        else ensureCheckoutDefaultKnow(d)
        if ($('checkoutErr')) $('checkoutErr').textContent = ''
        renderCheckoutMembers()
        touchCheckoutDraft()
      }
      $('checkoutMembers').addEventListener('input', (e) => {
        const inp = e.target.closest('[data-note]')
        if (!inp) return
        const d = getCheckoutDraft(inp.dataset.note)
        d.difficultyNote = inp.value
        updateCheckoutProgress()
        touchCheckoutDraft()
      })
    }
    if ($('btnGoCheckout')) $('btnGoCheckout').onclick = () => openTodayFlow({ leaderOnly: true })
    if ($('btnGoCheckout2')) $('btnGoCheckout2').onclick = () => openTodayFlow({ leaderOnly: true })
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
        const co = state.checkout || {}
        if (co.leader && co.assignment) openTodayFlow({ leaderOnly: true })
        else openPracticeSmart(false)
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
        try { $('loginPwd').focus() } catch (err) { /* ignore */ }
      }
    }
    $('btnBackHome').onclick = goHome
    $('btnSettingsLogin').onclick = () => openSetup('viewLogin')
    $('btnSaveSetup').onclick = saveSetup
    $('btnTestApi').onclick = testApi
    $('btnOpenLog').onclick = () => {
      if (state.config.logDir && window.spasDesktop) window.spasDesktop.openPath(state.config.logDir)
    }
    $('btnIdleKeep').onclick = () => touchIdle()
    $('btnSubmit').onclick = askSubmitConfirm
    $('btnConfirmCancel').onclick = () => {
      if (state.dlgResolve) closeConfirmDlg(false)
      else { $('confirmDlg').hidden = true; state.pendingPayload = null }
    }
    $('btnConfirmOk').onclick = () => {
      if (state.dlgResolve) closeConfirmDlg(true)
      else doSubmitConfirmed()
    }
    $('confirmDlg').addEventListener('click', (e) => {
      if (e.target === $('confirmDlg')) {
        if (state.dlgResolve) closeConfirmDlg(false)
        else {
          $('confirmDlg').hidden = true
          state.pendingPayload = null
        }
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
          openTodayFlow({ leaderOnly: true })
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
      if ($('queueDlg') && !$('queueDlg').hidden) closeQueueDlg()
      if ($('farmTour') && !$('farmTour').hidden) dismissFarmTour()
    })
    $('subjectId').onchange = () => onSubjectChange(false)
    ;['loginUser', 'loginPwd', 'loginCode'].forEach((id) => {
      const el = $(id)
      if (!el) return
      el.addEventListener('keydown', (e) => {
        if (e.key !== 'Enter') return
        e.preventDefault()
        if (id === 'loginUser') {
          try { $('loginPwd').focus() } catch (err) { /* ignore */ }
          return
        }
        if (id === 'loginPwd') {
          try { $('loginCode').focus() } catch (err) { /* ignore */ }
          return
        }
        login()
      })
    })
    ;['pageFrom', 'pageTo'].forEach((id) => {
      if ($(id)) $(id).addEventListener('input', updatePracticeSteps)
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
    if ($('confirmList')) $('confirmList').onclick = onConfirmClick
    if ($('centerConfirmList')) $('centerConfirmList').onclick = onConfirmClick
    if ($('homeConfirmList')) $('homeConfirmList').onclick = onConfirmClick
    if ($('btnBoardWeek')) $('btnBoardWeek').onclick = () => loadLeaderboard('week')
    if ($('btnBoardAll')) $('btnBoardAll').onclick = () => loadLeaderboard('all')
    if ($('btnAsideBoardWeek')) $('btnAsideBoardWeek').onclick = () => loadLeaderboard('week')
    if ($('btnAsideBoardAll')) $('btnAsideBoardAll').onclick = () => loadLeaderboard('all')
    if ($('levelBar')) {
      $('levelBar').onclick = () => {
        const board = $('asideBoardBlock') || $('homeBoardMod')
        if (board) board.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
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
          const board = $('asideBoardBlock') || $('homeBoardMod')
          if (board) board.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
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
    else if (w >= 1200) layout = 'md'
    else layout = 'sm'
    document.documentElement.dataset.layout = layout
    document.documentElement.style.setProperty('--app-w', w + 'px')
    document.documentElement.style.setProperty('--app-h', h + 'px')
  }

  async function boot() {
    bind()
    updateFarmMilestoneHints()
    applyLayoutScale()
    window.addEventListener('resize', () => {
      clearTimeout(applyLayoutScale._t)
      applyLayoutScale._t = setTimeout(() => {
        applyLayoutScale()
        onFarmViewportResize()
      }, 120)
    })
    renderWeekBars([])
    tickClock()
    setInterval(tickClock, 30000)
    if (window.spasDesktop && window.spasDesktop.getConfig) {
      state.config = Object.assign(state.config, await window.spasDesktop.getConfig())
    }
    try {
      if (state.config.audioMute == null) {
        state.config.audioMute = localStorage.getItem(AUDIO_MUTE_KEY) === '1'
      }
    } catch (e) { /* ignore */ }
    applyFarmFxMode()
    syncAudioMuteUi()
    syncFarmFxUi()
    updateFarmZoomLabel()
    document.title = state.config.title || document.title
    syncTitlebarChrome()
    updateDeviceMeta()
    setOnline(navigator.onLine)
    updateQueueBadge()
    prepareLoginView()

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
    prepareLoginView()
  }

  boot()
})()
