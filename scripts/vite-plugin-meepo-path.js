import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const PREFIX = '/wall/themes/meepo/'
const REPLACEMENT = '/themes/meepo/'

const MIME = {
  '.css': 'text/css',
  '.js': 'application/javascript',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.mp3': 'audio/mpeg',
  '.mp4': 'video/mp4',
  '.html': 'text/html'
}

function serveFile(res, filePath) {
  const ext = path.extname(filePath).toLowerCase()
  res.statusCode = 200
  res.setHeader('Content-Type', MIME[ext] || 'application/octet-stream')
  fs.createReadStream(filePath).pipe(res)
}

/**
 * @param {{ meepoSource?: string }} [opts]
 * - meepoSource: ���� meepo ��ԴĿ¼��H5 �� gamescreen-wall ���ã�
 */
export function meepoPathPlugin(opts = {}) {
  const meepoSource = opts.meepoSource
    ? path.resolve(opts.meepoSource)
    : path.resolve(process.cwd(), 'public/themes/meepo')

  const rewrite = (req, res, next) => {
    const url = req.url || ''
    if (!url.startsWith(PREFIX)) return next()

    const rel = decodeURIComponent(url.slice(PREFIX.length).split('?')[0])
    const filePath = path.join(meepoSource, rel)
    if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
      serveFile(res, filePath)
      return
    }

    req.url = url.replace(PREFIX, REPLACEMENT)
    next()
  }

  return {
    name: 'meepo-path-rewrite',
    configureServer(server) {
      server.middlewares.use(rewrite)
    },
    configurePreviewServer(server) {
      server.middlewares.use(rewrite)
    },
    closeBundle() {
      const distDest = path.resolve(process.cwd(), 'dist/wall/themes/meepo')
      if (!fs.existsSync(meepoSource)) return
      fs.mkdirSync(path.dirname(distDest), { recursive: true })
      fs.cpSync(meepoSource, distDest, { recursive: true, force: true })
    }
  }
}

/** ��ȡ localStorage ƫ�ã�δ����ʱĬ�Ͽ���ԭƤ�� */
export function legacyPref(key, defaultOn = true) {
  if (typeof localStorage === 'undefined') return defaultOn
  const v = localStorage.getItem(key)
  if (v === null) return defaultOn
  return v === '1'
}
