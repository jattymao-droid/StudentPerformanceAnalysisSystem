const STORAGE_KEY = 'spas-qb-basket'

function loadState() {
  try {
    const raw = sessionStorage.getItem(STORAGE_KEY)
    if (!raw) return { items: [], subjectId: null }
    const parsed = JSON.parse(raw)
    return {
      items: Array.isArray(parsed.items) ? parsed.items : [],
      subjectId: parsed.subjectId || null
    }
  } catch (e) {
    return { items: [], subjectId: null }
  }
}

function persist(state) {
  try {
    sessionStorage.setItem(STORAGE_KEY, JSON.stringify({
      items: state.items,
      subjectId: state.subjectId
    }))
  } catch (e) { /* ignore */ }
}

/** Strip HTML / formula markup for basket list preview */
function plainPreview(content) {
  let s = String(content || '')
  s = s.replace(/<[^>]+>/g, ' ')
  s = s.replace(/\$\$[\s\S]*?\$\$/g, '[formula]')
  s = s.replace(/\$[^$]+\$/g, '[formula]')
  s = s.replace(/\\\[[\s\S]*?\\\]/g, '[formula]')
  s = s.replace(/\\\([\s\S]*?\\\)/g, '[formula]')
  s = s.replace(/\s+/g, ' ').trim()
  return s.slice(0, 80)
}

const state = loadState()

const mutations = {
  SET_SUBJECT(state, subjectId) {
    state.subjectId = subjectId || null
    persist(state)
  },
  ADD_ITEM(state, question) {
    if (!question || !question.questionId) return
    if (state.items.some(i => String(i.questionId) === String(question.questionId))) return
    const content = question.content || ''
    state.items.push({
      questionId: question.questionId,
      content: content,
      contentPreview: plainPreview(content),
      questionType: question.questionType,
      difficulty: question.difficulty,
      knowledgeCount: question.knowledgeCount || 0,
      sourceYear: question.sourceYear,
      sourceRegion: question.sourceRegion,
      sourceExam: question.sourceExam,
      stemImage: question.stemImage,
      scoreValue: question.scoreValue != null ? Number(question.scoreValue) : 5,
      subjectId: question.subjectId
    })
    if (question.subjectId) state.subjectId = question.subjectId
    persist(state)
  },
  REMOVE_ITEM(state, questionId) {
    state.items = state.items.filter(i => String(i.questionId) !== String(questionId))
    persist(state)
  },
  UPDATE_SCORE(state, { questionId, scoreValue }) {
    const row = state.items.find(i => String(i.questionId) === String(questionId))
    if (row) row.scoreValue = Number(scoreValue) || 0
    persist(state)
  },
  CLEAR(state) {
    state.items = []
    persist(state)
  },
  SET_ITEMS(state, items) {
    state.items = Array.isArray(items) ? items : []
    persist(state)
  }
}

const actions = {
  setSubject({ commit }, subjectId) { commit('SET_SUBJECT', subjectId) },
  add({ commit }, question) { commit('ADD_ITEM', question) },
  remove({ commit }, questionId) { commit('REMOVE_ITEM', questionId) },
  updateScore({ commit }, payload) { commit('UPDATE_SCORE', payload) },
  clear({ commit }) { commit('CLEAR') },
  setItems({ commit }, items) { commit('SET_ITEMS', items) }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
