const fs = require('fs')
const path = require('path')

const glyphs = [
  '😊', '😍', '😵', '😅', '😓', '😲', '😔', '🤔', '🤓', '😢',
  '😷', '👋', '🥶', '😏', '😴', '🤕', '🤩', '😭', '😑', '🤢',
  '🥰', '😁', '😆', '🤤', '😤', '😠', '🤨', '🤐', '🙄', '😒',
  '😏', '😑', '🙄', '🍋', '😘', '😱', '👎', '👍', '🤫', '😣',
  '🥺', '🥹', '😎', '🤪', '🖤'
]
const cell = 64
const w = glyphs.length * cell
const texts = glyphs.map((g, i) =>
  `<text x="${i * cell + 32}" y="42" font-size="36" text-anchor="middle" dominant-baseline="middle">${g}</text>`
).join('')
const svg = `<?xml version="1.0" encoding="UTF-8"?>\n<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${cell}" viewBox="0 0 ${w} ${cell}">${texts}</svg>`

const targets = [
  'gamescreen-wall/public/themes/meepo/assets/images/screen_wallface.svg',
  'gamescreen-h5/public/themes/meepo/assets/images/screen_wallface.svg'
]
for (const rel of targets) {
  const p = path.join(__dirname, '..', rel)
  fs.mkdirSync(path.dirname(p), { recursive: true })
  fs.writeFileSync(p, svg)
  console.log('wrote', p)
}
