const { app, BrowserWindow, ipcMain, session, shell, dialog, screen } = require('electron')
const path = require('path')
const fs = require('fs')

const DEFAULT_CONFIG = {
  apiBase: 'http://127.0.0.1:8080',
  deviceCode: 'DEV-LOCAL',
  kiosk: false,
  autoLaunch: false,
  idleMinutes: 8,
  title: '知脉 · 每日自主练',
  appVersion: '1.5.9',
  /** 可选：固定宽高；不填则按屏幕工作区自适应 */
  windowWidth: 0,
  windowHeight: 0,
  /** 大屏默认最大化；也可配置强制 true/false */
  maximize: null
}

let mainWindow = null
let appConfig = Object.assign({}, DEFAULT_CONFIG)
let allowQuit = false

function userConfigPath() {
  return path.join(app.getPath('userData'), 'config.json')
}

function logDir() {
  return path.join(app.getPath('userData'), 'logs')
}

function appendLog(line) {
  try {
    if (!fs.existsSync(logDir())) fs.mkdirSync(logDir(), { recursive: true })
    const day = new Date().toISOString().slice(0, 10)
    const file = path.join(logDir(), 'desktop-' + day + '.log')
    fs.appendFileSync(file, '[' + new Date().toISOString() + '] ' + line + '\n', 'utf8')
  } catch (e) { /* ignore */ }
}

function bundledConfigCandidates() {
  return [
    path.join(process.resourcesPath || '', 'config.json'),
    path.join(path.dirname(process.execPath), 'config.json'),
    path.join(__dirname, 'config.json'),
    path.join(__dirname, 'config.example.json')
  ]
}

function readJson(file) {
  try {
    if (file && fs.existsSync(file)) {
      return JSON.parse(fs.readFileSync(file, 'utf8'))
    }
  } catch (e) {
    appendLog('config read failed ' + file + ' ' + e.message)
  }
  return null
}

function loadConfig() {
  const fromUser = readJson(userConfigPath())
  if (fromUser) return Object.assign({}, DEFAULT_CONFIG, fromUser)
  for (const p of bundledConfigCandidates()) {
    const cfg = readJson(p)
    if (cfg) return Object.assign({}, DEFAULT_CONFIG, cfg)
  }
  return Object.assign({}, DEFAULT_CONFIG)
}

function saveConfig(partial) {
  const next = Object.assign({}, loadConfig(), partial || {})
  delete next.appVersion
  const dir = path.dirname(userConfigPath())
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true })
  fs.writeFileSync(userConfigPath(), JSON.stringify(next, null, 2), 'utf8')
  appConfig = Object.assign({}, DEFAULT_CONFIG, next, { appVersion: DEFAULT_CONFIG.appVersion })
  applyAutoLaunch(!!appConfig.autoLaunch)
  appendLog('config saved device=' + appConfig.deviceCode)
  return appConfig
}

function applyAutoLaunch(enabled) {
  try {
    app.setLoginItemSettings({
      openAtLogin: !!enabled,
      path: process.execPath,
      args: []
    })
  } catch (e) {
    appendLog('setLoginItemSettings failed ' + e.message)
  }
}

function resolveWindowBounds() {
  const display = screen.getPrimaryDisplay()
  const wa = display.workAreaSize
  const cfgW = Number(appConfig.windowWidth) || 0
  const cfgH = Number(appConfig.windowHeight) || 0
  const minW = 1100
  const minH = 720
  // 默认约占工作区 92%/90%，贴近一体机全屏观感，又留一点边
  let width = cfgW > 0 ? cfgW : Math.round(wa.width * 0.92)
  let height = cfgH > 0 ? cfgH : Math.round(wa.height * 0.9)
  width = Math.min(Math.max(width, minW), wa.width)
  height = Math.min(Math.max(height, minH), wa.height)
  let maximize = appConfig.maximize
  if (maximize == null) {
    // ≥1600 宽或接近全高时默认最大化，教室大屏更合适
    maximize = !cfgW && !cfgH && (wa.width >= 1600 || wa.height >= 960)
  }
  return { width, height, minWidth: Math.min(minW, wa.width), minHeight: Math.min(minH, wa.height), maximize: !!maximize }
}

function createWindow() {
  const bounds = resolveWindowBounds()
  mainWindow = new BrowserWindow({
    width: bounds.width,
    height: bounds.height,
    minWidth: bounds.minWidth,
    minHeight: bounds.minHeight,
    center: true,
    fullscreen: !!appConfig.kiosk,
    autoHideMenuBar: true,
    show: false,
    backgroundColor: '#d9dce8',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false,
      webSecurity: false,
      spellcheck: false
    },
    title: appConfig.title || DEFAULT_CONFIG.title
  })

  mainWindow.webContents.setZoomFactor(1)
  mainWindow.webContents.setVisualZoomLevelLimits(1, 1)
  mainWindow.webContents.on('before-input-event', (event, input) => {
    if ((input.control || input.meta) && ['+', '-', '=', '0'].includes(input.key)) {
      event.preventDefault()
    }
  })
  mainWindow.webContents.setWindowOpenHandler(() => ({ action: 'deny' }))
  mainWindow.webContents.on('will-navigate', (e, url) => {
    if (!url.startsWith('file://')) e.preventDefault()
  })

  mainWindow.loadFile(path.join(__dirname, 'renderer', 'index.html'))
  mainWindow.once('ready-to-show', () => {
    if (!appConfig.kiosk && bounds.maximize) {
      try { mainWindow.maximize() } catch (e) { /* ignore */ }
    }
    mainWindow.show()
    if (appConfig.kiosk) mainWindow.setFullScreen(true)
    appendLog('window ' + bounds.width + 'x' + bounds.height +
      ' maximize=' + !!bounds.maximize + ' kiosk=' + !!appConfig.kiosk)
  })

  mainWindow.on('close', (e) => {
    if (allowQuit || !appConfig.kiosk) return
    e.preventDefault()
    dialog.showMessageBox(mainWindow, {
      type: 'question',
      buttons: ['取消', '退出程序'],
      defaultId: 0,
      cancelId: 0,
      title: '退出一体机客户端',
      message: '当前为 Kiosk 模式，确定退出？'
    }).then((r) => {
      if (r.response === 1) {
        allowQuit = true
        app.quit()
      }
    })
  })

  mainWindow.on('closed', () => { mainWindow = null })
}

const gotLock = app.requestSingleInstanceLock()
if (!gotLock) {
  app.quit()
} else {
  app.on('second-instance', () => {
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore()
      mainWindow.focus()
    }
  })

  ipcMain.handle('get-config', () => {
    const login = app.getLoginItemSettings()
    return Object.assign({}, appConfig, {
      autoLaunch: !!login.openAtLogin || !!appConfig.autoLaunch,
      configPath: userConfigPath(),
      logDir: logDir(),
      isPackaged: app.isPackaged,
      platform: process.platform
    })
  })

  ipcMain.handle('save-config', (_e, partial) => {
    const cfg = saveConfig(partial)
    if (mainWindow && !mainWindow.isDestroyed()) {
      mainWindow.setTitle(cfg.title || DEFAULT_CONFIG.title)
      if (partial && typeof partial.kiosk === 'boolean') {
        mainWindow.setFullScreen(!!partial.kiosk)
      }
    }
    return cfg
  })

  ipcMain.handle('open-path', (_e, target) => {
    if (!target) return false
    shell.showItemInFolder(target)
    return true
  })

  ipcMain.handle('set-fullscreen', (_e, on) => {
    if (mainWindow && !mainWindow.isDestroyed()) mainWindow.setFullScreen(!!on)
    return true
  })

  ipcMain.handle('write-log', (_e, message) => {
    appendLog(String(message || ''))
    return true
  })

  app.whenReady().then(() => {
    appConfig = loadConfig()
    applyAutoLaunch(!!appConfig.autoLaunch)
    appendLog('app start v' + appConfig.appVersion + ' device=' + appConfig.deviceCode)
    session.defaultSession.webRequest.onBeforeSendHeaders((details, callback) => {
      callback({ requestHeaders: details.requestHeaders })
    })
    createWindow()
    app.on('activate', () => {
      if (BrowserWindow.getAllWindows().length === 0) createWindow()
    })
  })

  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit()
  })

  process.on('uncaughtException', (err) => {
    appendLog('uncaughtException ' + (err && err.stack ? err.stack : err))
  })
}
