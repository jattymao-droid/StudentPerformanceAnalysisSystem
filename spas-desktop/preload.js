const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('spasDesktop', {
  getConfig: () => ipcRenderer.invoke('get-config'),
  saveConfig: (partial) => ipcRenderer.invoke('save-config', partial),
  openPath: (target) => ipcRenderer.invoke('open-path', target),
  setFullscreen: (on) => ipcRenderer.invoke('set-fullscreen', on),
  writeLog: (message) => ipcRenderer.invoke('write-log', message)
})
