const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('spasDesktop', {
  getConfig: () => ipcRenderer.invoke('get-config'),
  saveConfig: (partial) => ipcRenderer.invoke('save-config', partial),
  openPath: (target) => ipcRenderer.invoke('open-path', target),
  setFullscreen: (on) => ipcRenderer.invoke('set-fullscreen', on),
  writeLog: (message) => ipcRenderer.invoke('write-log', message),
  windowMinimize: () => ipcRenderer.invoke('window-minimize'),
  windowMaximizeToggle: () => ipcRenderer.invoke('window-maximize-toggle'),
  windowClose: () => ipcRenderer.invoke('window-close'),
  windowIsMaximized: () => ipcRenderer.invoke('window-is-maximized')
})
