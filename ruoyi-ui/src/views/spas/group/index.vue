<template>
  <div class="app-container spas-group">
    <el-form :model="queryParams" size="small" :inline="true" label-width="68px" class="filter-form">
      <el-form-item label="班级">
        <el-button-group v-if="myDepts.length">
          <el-button
            v-for="d in myDepts"
            :key="d.deptId"
            size="mini"
            :type="queryParams.deptId === d.deptId ? 'primary' : 'default'"
            @click="selectDept(d.deptId)"
          >{{ d.deptName }}</el-button>
        </el-button-group>
        <treeselect
          v-else
          v-model="queryParams.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="选择班级"
          style="width: 240px"
          @input="onDeptChange"
        />
      </el-form-item>
      <el-form-item label="学科">
        <el-select v-model="queryParams.subjectId" clearable placeholder="不限/通用组" style="width: 160px" @change="refreshAll">
          <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="queryParams.status" style="width: 110px" @change="getList">
          <el-option label="启用中" value="0" />
          <el-option label="已解散" value="1" />
          <el-option label="全部" value="" />
        </el-select>
      </el-form-item>
      <el-form-item label="成绩场次">
        <el-select v-model="queryParams.examId" clearable filterable placeholder="默认最近考试" style="width: 200px" @change="getList">
          <el-option
            v-for="e in examOptions"
            :key="e.examId"
            :label="(e.examName || ('考试#' + e.examId)) + (e.examDate ? (' · ' + parseTime(e.examDate, '{y}-{m}-{d}')) : '')"
            :value="e.examId"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="refreshAll">搜索</el-button>
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['spas:group:add']">新建组</el-button>
        <el-button type="success" plain icon="el-icon-magic-stick" size="mini" @click="openSmart" v-hasPermi="['spas:group:add']">智能分组</el-button>
        <el-dropdown
          size="mini"
          split-button
          type="warning"
          plain
          :disabled="!queryParams.deptId || !groupList.length"
          @click="exportDeptWeak('xlsx')"
          @command="exportDeptWeak"
          style="margin-left: 8px"
        >
          导出各组薄弱
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="xlsx">导出 Excel</el-dropdown-item>
            <el-dropdown-item command="pdf">导出 PDF</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </el-form-item>
    </el-form>

    <div v-if="queryParams.deptId" class="list-summary">
      <span>共 <b>{{ groupList.length }}</b> 组</span>
      <span class="dot">·</span>
      <span>在册 <b>{{ totalMemberCount }}</b> 人</span>
      <span class="dot">·</span>
      <span>未入组 <b :class="{ warn: unassignedCount > 0 }">{{ unassignedCount }}</b> 人</span>
      <span v-if="statsExamLabel" class="dot">·</span>
      <span v-if="statsExamLabel">成绩：{{ statsExamLabel }}</span>
      <span class="hint">同班同科每人仅一组 · 建议 4～6 人</span>
    </div>

    <div class="group-grid">
      <div
        v-for="g in groupList"
        :key="g.groupId"
        class="group-card"
        :class="{ disabled: g.status !== '0', 'size-warn': isSizeWarn(g) }"
        @click="previewMembers(g)"
      >
        <div class="card-top">
          <div class="title-row">
            <span class="group-name">{{ g.groupName }}</span>
            <span v-if="g.status !== '0'" class="status-pill muted">已解散</span>
            <span v-else-if="!queryParams.subjectId" class="status-pill">{{ g.subjectName || '通用' }}</span>
          </div>
          <span
            class="count-badge"
            :class="{ warn: isSizeWarn(g) }"
            :title="isSizeWarn(g) ? '建议每组 4～6 人' : ''"
          >{{ g.memberCount || 0 }}人</span>
        </div>
        <div class="leader-row">
          <i class="el-icon-user-solid" />
          <span>{{ g.leaderStudentName || '未指定组长' }}</span>
        </div>
        <div class="stats-row">
          <span v-if="g.avgScore != null" class="stat"><em>均分</em>{{ formatStat(g.avgScore) }}</span>
          <span v-if="g.avgRank != null" class="stat"><em>均次</em>{{ formatStat(g.avgRank) }}</span>
          <span class="stat"><em>男女</em>{{ (g.maleCount || 0) }}/{{ (g.femaleCount || 0) }}</span>
          <span v-if="g.avgScore == null && g.avgRank == null" class="stat muted">暂无成绩</span>
        </div>
        <div class="members-line" :title="memberNamesText(g)">
          <template v-if="memberPreview[g.groupId]">
            {{ memberNamesText(g) || '暂无成员' }}
          </template>
          <template v-else-if="(g.memberCount || 0) > 0">加载中…</template>
          <template v-else>暂无成员</template>
        </div>
        <div class="card-actions" @click.stop>
          <el-button type="text" size="mini" @click="previewMembers(g)">成绩</el-button>
          <template v-if="g.status === '0'">
            <el-button type="text" size="mini" @click="handleUpdate(g)" v-hasPermi="['spas:group:edit']">编辑</el-button>
            <el-button type="text" size="mini" class="danger-text" @click="handleDelete(g)" v-hasPermi="['spas:group:remove']">解散</el-button>
          </template>
        </div>
      </div>
    </div>
    <el-empty v-if="!groupList.length" :description="queryParams.deptId ? '暂无小组，可新建或智能分组' : '请先选择班级'" />

    <!-- 新建/编辑 -->
    <el-dialog :title="title" :visible.sync="open" width="720px" append-to-body @closed="resetForm">
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="组名" prop="groupName">
          <el-input v-model="form.groupName" maxlength="64" placeholder="如：一组 / 物理1组" />
        </el-form-item>
        <el-form-item label="学科">
          <el-select v-model="form.subjectId" clearable placeholder="空=不分科通用组" style="width: 100%" @change="onFormSubjectChange">
            <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
          </el-select>
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sortOrder" :min="0" :max="999" controls-position="right" />
        </el-form-item>
        <el-form-item label="成员" prop="studentIds">
          <el-transfer
            v-model="form.studentIds"
            :data="transferData"
            :titles="['可选学生', '组内']"
            :props="{ key: 'key', label: 'label' }"
            filterable
            :filter-method="filterTransfer"
          />
          <div class="form-tip">左侧仅显示未入组学生，以及本组成员；已在其他组的学生不会出现。</div>
        </el-form-item>
        <el-form-item label="组长" prop="leaderStudentId">
          <el-select v-model="form.leaderStudentId" clearable placeholder="从组内指定组长" style="width: 100%">
            <el-option
              v-for="s in selectedStudents"
              :key="s.studentId"
              :label="(s.studentNo || '') + ' ' + s.studentName"
              :value="s.studentId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="2" maxlength="200" show-word-limit />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" :loading="saving" @click="submitForm">保 存</el-button>
        <el-button @click="open = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 智能分组 -->
    <el-dialog title="智能分组" :visible.sync="smartOpen" width="520px" append-to-body>
      <el-form label-width="100px" size="small">
        <el-form-item label="班级">
          <span>{{ currentDeptName || ('ID ' + queryParams.deptId) }}</span>
        </el-form-item>
        <el-form-item label="学科范围">
          <el-select v-model="smartForm.subjectId" clearable placeholder="空=通用组（成绩按总分）" style="width: 100%">
            <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
          </el-select>
        </el-form-item>
        <el-form-item label="参考考试">
          <el-select v-model="smartForm.examId" clearable filterable placeholder="默认最近一场已导入考试" style="width: 100%">
            <el-option
              v-for="e in examOptions"
              :key="e.examId"
              :label="(e.examName || ('考试#' + e.examId)) + (e.examDate ? (' · ' + parseTime(e.examDate, '{y}-{m}-{d}')) : '')"
              :value="e.examId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="每组人数">
          <el-input-number v-model="smartForm.groupSize" :min="3" :max="8" />
          <span class="form-tip inline">建议 4～6</span>
        </el-form-item>
        <el-form-item label="模式">
          <el-radio-group v-model="smartForm.mode">
            <el-radio label="unassigned">仅未入组学生</el-radio>
            <el-radio label="rebuild">重新分组（解散本范围旧组）</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-alert
          v-if="smartForm.mode === 'rebuild'"
          type="warning"
          :closable="false"
          show-icon
          title="将解散当前班级+学科下所有启用中的小组，再按全班学生重新编组。"
        />
        <el-alert
          type="info"
          :closable="false"
          show-icon
          class="mt8"
          :title="smartHint"
        />
      </el-form>
      <div slot="footer">
        <el-button type="primary" :loading="smartSaving" @click="submitSmart">开始分组</el-button>
        <el-button @click="smartOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 小组详情：成员成绩 + 趋势 -->
    <el-dialog
      :title="previewDialogTitle"
      :visible.sync="previewOpen"
      width="920px"
      append-to-body
      custom-class="group-perf-dialog"
      @closed="onPreviewClosed"
      @opened="onPreviewOpened"
    >
      <div v-loading="previewLoading" class="perf-body">
        <div class="perf-summary">
          <div class="perf-summary-left">
            <el-select
              v-model="previewExamId"
              size="small"
              filterable
              placeholder="选择考试"
              class="perf-exam-select"
              @change="reloadPreviewPerformance"
            >
              <el-option
                v-for="e in previewExamOptions"
                :key="e.examId"
                :label="(e.examName || ('考试#' + e.examId)) + (e.examDate ? (' · ' + parseTime(e.examDate, '{y}-{m}-{d}')) : '')"
                :value="e.examId"
              />
            </el-select>
            <span class="perf-metric">{{ previewMetricLabel }}</span>
          </div>
          <div class="perf-kpis">
            <div class="kpi-box">
              <span class="kpi-label">均分</span>
              <span class="kpi-value">{{ formatStat(previewPerf.avgScore) }}</span>
            </div>
            <div class="kpi-box">
              <span class="kpi-label">均次</span>
              <span class="kpi-value">{{ formatStat(previewPerf.avgRank) }}</span>
            </div>
            <div class="kpi-box">
              <span class="kpi-label">有成绩</span>
              <span class="kpi-value">{{ previewPerf.scoredCount || 0 }}/{{ previewPerf.memberCount || 0 }}</span>
            </div>
          </div>
        </div>

        <el-tabs v-model="previewTab" class="perf-tabs" @tab-click="onPreviewTabClick">
          <el-tab-pane label="成员成绩" name="scores">
            <el-table :data="previewMembersList" size="mini" empty-text="暂无成员" max-height="420" class="perf-table">
              <el-table-column label="学号" prop="studentNo" width="110" />
              <el-table-column label="姓名" prop="studentName" min-width="90" />
              <el-table-column label="角色" width="72" align="center">
                <template slot-scope="scope">
                  <el-tag size="mini" :type="scope.row.roleInGroup === '1' ? 'warning' : 'info'">
                    {{ scope.row.roleInGroup === '1' ? '组长' : '组员' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="成绩" prop="score" width="80" align="right">
                <template slot-scope="scope">{{ formatStat(scope.row.score) }}</template>
              </el-table-column>
              <el-table-column label="校次" prop="schoolRank" width="72" align="right">
                <template slot-scope="scope">{{ scope.row.schoolRank != null ? scope.row.schoolRank : '-' }}</template>
              </el-table-column>
              <el-table-column label="较上场" width="100" align="center">
                <template slot-scope="scope">
                  <span v-if="scope.row.scoreDelta != null" :class="deltaClass(scope.row.scoreDelta, false)">
                    {{ formatDelta(scope.row.scoreDelta) }}
                  </span>
                  <span v-else class="muted">-</span>
                </template>
              </el-table-column>
              <el-table-column label="名次变化" width="100" align="center">
                <template slot-scope="scope">
                  <span v-if="scope.row.rankDelta != null" :class="deltaClass(scope.row.rankDelta, true)">
                    {{ formatRankDelta(scope.row.rankDelta) }}
                  </span>
                  <span v-else class="muted">-</span>
                </template>
              </el-table-column>
            </el-table>
            <p v-if="previewPerf.prevExamName" class="perf-tip">较上场对比：{{ previewPerf.prevExamName }}</p>
            <p v-else class="perf-tip">当前仅有一场考试数据时，较上场对比暂不可用。</p>
          </el-tab-pane>
          <el-tab-pane label="成绩趋势" name="trend" lazy>
            <!-- 仅在可见时挂载，避免隐藏 Tab 内 ECharts 宽度塌缩 -->
            <div v-if="previewTab === 'trend'" class="trend-panel">
              <spas-chart
                ref="previewTrendChart"
                :option="previewTrendOption"
                width="100%"
                height="380px"
              />
              <p class="perf-tip">折线为小组成员均分；虚线为同场同科班级均分；校次越低越好（右轴倒置）。</p>
            </div>
          </el-tab-pane>
          <el-tab-pane label="薄弱知识点" name="weak" lazy>
            <div class="weak-panel">
              <div v-if="previewWeakList.length" class="weak-chart-wrap">
                <spas-chart
                  v-if="previewTab === 'weak'"
                  ref="previewWeakChart"
                  :option="previewWeakOption"
                  width="100%"
                  height="260px"
                />
              </div>
              <el-table :data="previewWeakList" size="mini" empty-text="暂无薄弱知识点" max-height="320" class="perf-table">
                <el-table-column label="知识点" min-width="140" show-overflow-tooltip>
                  <template slot-scope="scope">{{ scope.row.knowledgeName || scope.row.name || '-' }}</template>
                </el-table-column>
                <el-table-column label="组均得分率" width="100" align="right">
                  <template slot-scope="scope">{{ formatRatePct(scope.row.rate) }}</template>
                </el-table-column>
                <el-table-column label="班均" width="80" align="right">
                  <template slot-scope="scope">{{ formatRatePct(scope.row.classAvgRate) }}</template>
                </el-table-column>
                <el-table-column label="薄弱人数" width="88" align="center">
                  <template slot-scope="scope">
                    <span :class="{ 'delta-down': (scope.row.weakStudentCount || 0) > 0 }">
                      {{ scope.row.weakStudentCount || 0 }}/{{ scope.row.studentCount || 0 }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column label="薄弱成员" min-width="140" show-overflow-tooltip>
                  <template slot-scope="scope">{{ (scope.row.weakStudentNames || []).join('、') || '-' }}</template>
                </el-table-column>
                <el-table-column label="判定" width="96" align="center">
                  <template slot-scope="scope">
                    <el-tag v-if="scope.row.formalWeak" size="mini" type="danger">正式薄弱</el-tag>
                    <el-tag v-else-if="(scope.row.weakStudentCount || 0) > 0 && scope.row.evidenceOk === false" size="mini" type="info">样本不足</el-tag>
                    <el-tag v-else-if="(scope.row.weakStudentCount || 0) > 0" size="mini" type="warning">偏低</el-tag>
                    <el-tag v-else size="mini" type="info">正常</el-tag>
                  </template>
                </el-table-column>
              </el-table>
              <div class="weak-export-row">
                <el-button
                  type="warning"
                  plain
                  size="mini"
                  icon="el-icon-document"
                  :loading="weakExportLoading === 'xlsx'"
                  :disabled="!previewWeakList.length"
                  @click="exportPreviewWeak('xlsx')"
                >导出 Excel</el-button>
                <el-button
                  type="primary"
                  plain
                  size="mini"
                  icon="el-icon-download"
                  :loading="weakExportLoading === 'pdf'"
                  :disabled="!previewWeakList.length"
                  @click="exportPreviewWeak('pdf')"
                >导出 PDF</el-button>
              </div>
              <p class="perf-tip">按本学期作答聚合（与上方考试场次无关）；薄弱人数=组内得分率低于薄弱线的成员数；正式薄弱另需作答次数达标。</p>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
      <div slot="footer">
        <el-button type="primary" plain size="mini" @click="handleUpdate(previewGroup)" v-if="previewGroup && previewGroup.status === '0'" v-hasPermi="['spas:group:edit']">去编辑</el-button>
        <el-button @click="previewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listStudyGroup, getStudyGroup, addStudyGroup, updateStudyGroup, delStudyGroup, listUnassignedStudents, smartAssignGroups, getGroupPerformance } from '@/api/spas/group'
import { listStudent } from '@/api/spas/student'
import { optionselectSubject } from '@/api/spas/subject'
import { listExamScore } from '@/api/spas/examScore'
import { deptTreeSelect } from '@/api/system/user'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { applyTeachingDeptContext } from '@/utils/spasDeptTree'
import SpasChart from '@/components/spas/charts/SpasChart'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  name: 'StudyGroup',
  components: { Treeselect, SpasChart },
  data() {
    return {
      myDepts: [],
      deptOptions: [],
      subjectOptions: [],
      groupList: [],
      classStudents: [],
      unassignedStudents: [],
      memberPreview: {},
      open: false,
      saving: false,
      title: '',
      smartOpen: false,
      smartSaving: false,
      examOptions: [],
      smartForm: { subjectId: undefined, examId: undefined, groupSize: 5, mode: 'unassigned' },
      previewOpen: false,
      previewLoading: false,
      previewGroup: null,
      previewMembersList: [],
      previewTab: 'scores',
      previewExamId: undefined,
      previewExamOptions: [],
      previewPerf: {},
      previewTrendOption: {},
      previewWeakList: [],
      previewWeakOption: {},
      weakExportLoading: '',
      queryParams: { deptId: undefined, subjectId: undefined, status: '0', examId: undefined, pageNum: 1, pageSize: 100 },
      form: {},
      rules: {
        groupName: [{ required: true, message: '请填写组名', trigger: 'blur' }]
      }
    }
  },
  computed: {
    unassignedCount() {
      return (this.unassignedStudents || []).length
    },
    totalMemberCount() {
      return (this.groupList || []).reduce((sum, g) => sum + (g.memberCount || 0), 0)
    },
    smartHint() {
      const who = this.smartForm.mode === 'rebuild' ? '全班学生' : ('约 ' + this.unassignedCount + ' 名未入组学生')
      const exam = this.examOptions.find(e => e.examId === this.smartForm.examId)
      const examTip = exam
        ? ('参考「' + (exam.examName || '') + '」')
        : (this.examOptions.length ? '参考最近一场考试' : '本班暂无考试成绩，将仅按性别均衡')
      const scoreTip = this.smartForm.subjectId
        ? '按该学科分数蛇形均分，再交换压低组间均分差，兼顾男女比'
        : '按总分分数蛇形均分，再交换压低组间均分差，兼顾男女比'
      return '将把' + who + '编组：' + examTip + '；' + scoreTip + '；每组成绩最强者为组长。'
    },
    currentDeptName() {
      const hit = (this.myDepts || []).find(d => Number(d.deptId) === Number(this.queryParams.deptId))
      return hit ? hit.deptName : ''
    },
    statsExamLabel() {
      const hit = (this.groupList || []).find(g => g.statsExamName)
      if (hit) return hit.statsExamName
      const selected = (this.examOptions || []).find(e => e.examId === this.queryParams.examId)
      return selected ? selected.examName : ''
    },
    transferData() {
      const currentIds = this.form.studentIds || []
      const allow = {}
      ;(this.unassignedStudents || []).forEach(s => { allow[s.studentId] = true })
      currentIds.forEach(id => { allow[id] = true })
      return (this.classStudents || [])
        .filter(s => allow[s.studentId])
        .map(s => ({
          key: s.studentId,
          label: (s.studentNo || '') + ' ' + s.studentName
        }))
    },
    selectedStudents() {
      const ids = this.form.studentIds || []
      return (this.classStudents || []).filter(s => ids.indexOf(s.studentId) !== -1)
    },
    previewDialogTitle() {
      const name = (this.previewGroup && this.previewGroup.groupName) || '小组'
      const sub = this.previewPerf.subjectName || (this.previewGroup && this.previewGroup.subjectName) || ''
      return sub ? (name + ' · ' + sub) : (name + ' · 成绩')
    },
    previewMetricLabel() {
      if (this.previewPerf.metric === 'subject' && this.previewPerf.subjectName) {
        return '指标：' + this.previewPerf.subjectName
      }
      if (this.previewPerf.subjectName) {
        return '指标：总分（本场无「' + this.previewPerf.subjectName + '」科分）'
      }
      return '指标：总分'
    }
  },
  created() {
    optionselectSubject().then(r => { this.subjectOptions = r.data || [] })
    applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).then(() => {
      if (this.queryParams.deptId) this.refreshAll()
    })
  },
  methods: {
    selectDept(deptId) {
      this.queryParams.deptId = deptId
      this.queryParams.examId = undefined
      this.refreshAll()
    },
    onDeptChange() {
      this.queryParams.examId = undefined
      this.refreshAll()
    },
    refreshAll() {
      this.loadExamOptions().then(() => {
        this.getList()
        this.loadUnassigned()
      })
    },
    getList() {
      if (!this.queryParams.deptId) {
        this.groupList = []
        this.memberPreview = {}
        return
      }
      const params = Object.assign({}, this.queryParams)
      if (params.status === '') delete params.status
      if (params.examId) {
        params['params[examId]'] = params.examId
      }
      delete params.examId
      listStudyGroup(params).then(res => {
        this.groupList = res.rows || []
        this.memberPreview = {}
        ;(this.groupList || []).forEach(g => {
          if ((g.memberCount || 0) > 0) this.loadMemberPreview(g.groupId)
        })
      })
    },
    formatStat(v) {
      if (v == null || v === '') return '-'
      const n = Number(v)
      if (isNaN(n)) return v
      return Number.isInteger(n) ? String(n) : n.toFixed(1)
    },
    isSizeWarn(g) {
      if (!g || g.status !== '0') return false
      const n = g.memberCount || 0
      return n > 0 && (n < 4 || n > 6)
    },
    memberNamesText(g) {
      const list = this.memberPreview[g.groupId] || []
      if (!list.length) return ''
      const names = list.map(m => m.studentName)
      const shown = names.slice(0, 6).join('、')
      const more = (g.memberCount || names.length) - Math.min(6, names.length)
      return more > 0 ? shown + ' 等' + (g.memberCount || names.length) + '人' : shown
    },
    loadUnassigned() {
      if (!this.queryParams.deptId) {
        this.unassignedStudents = []
        return
      }
      listUnassignedStudents({
        deptId: this.queryParams.deptId,
        subjectId: this.queryParams.subjectId || undefined
      }).then(res => {
        this.unassignedStudents = res.data || []
      }).catch(() => { this.unassignedStudents = [] })
    },
    loadClassStudents() {
      if (!this.queryParams.deptId) return Promise.resolve()
      return listStudent({ deptId: this.queryParams.deptId, pageNum: 1, pageSize: 500, status: '0' }).then(res => {
        this.classStudents = res.rows || []
      })
    },
    loadMemberPreview(groupId) {
      getStudyGroup(groupId).then(res => {
        const members = (res.data || {}).members || []
        this.$set(this.memberPreview, groupId, members)
      }).catch(() => {})
    },
    filterTransfer(query, item) {
      return String(item.label || '').toLowerCase().indexOf(String(query || '').toLowerCase()) >= 0
    },
    resetForm() {
      this.form = {}
      this.saving = false
    },
    handleAdd() {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      this.form = {
        deptId: this.queryParams.deptId,
        subjectId: this.queryParams.subjectId,
        groupName: undefined,
        studentIds: [],
        leaderStudentId: undefined,
        sortOrder: undefined,
        remark: undefined
      }
      this.title = '新建小组'
      Promise.all([this.loadClassStudents(), this.loadUnassignedForForm(this.form.subjectId)]).then(() => {
        this.open = true
      })
    },
    handleUpdate(row) {
      if (!row || !row.groupId) return
      this.previewOpen = false
      getStudyGroup(row.groupId).then(res => {
        const data = res.data || {}
        this.form = {
          groupId: data.groupId,
          deptId: data.deptId,
          subjectId: data.subjectId,
          groupName: data.groupName,
          leaderStudentId: data.leaderStudentId,
          studentIds: (data.members || []).map(m => m.studentId),
          sortOrder: data.sortOrder,
          remark: data.remark,
          _origSubjectId: data.subjectId
        }
        this.queryParams.deptId = data.deptId
        this.title = '编辑小组'
        Promise.all([this.loadClassStudents(), this.loadUnassignedForForm(data.subjectId)]).then(() => {
          // ensure current members appear in classStudents / transfer
          const known = {}
          ;(this.classStudents || []).forEach(s => { known[s.studentId] = true })
          ;(data.members || []).forEach(m => {
            if (!known[m.studentId]) {
              this.classStudents.push({
                studentId: m.studentId,
                studentNo: m.studentNo,
                studentName: m.studentName
              })
            }
          })
          this.open = true
        })
      })
    },
    loadUnassignedForForm(subjectId) {
      if (!this.queryParams.deptId && !this.form.deptId) return Promise.resolve()
      const deptId = this.form.deptId || this.queryParams.deptId
      return listUnassignedStudents({ deptId, subjectId: subjectId || undefined }).then(res => {
        this.unassignedStudents = res.data || []
      }).catch(() => { this.unassignedStudents = [] })
    },
    onFormSubjectChange() {
      this.loadUnassignedForForm(this.form.subjectId)
    },
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        const payload = { ...this.form }
        if (payload.leaderStudentId && (payload.studentIds || []).indexOf(payload.leaderStudentId) < 0) {
          this.$modal.msgWarning('组长必须在组内成员中')
          return
        }
        // clear subject when emptied on edit
        if (payload.groupId && payload.subjectId == null && payload._origSubjectId != null) {
          if (!payload.params) payload.params = {}
          payload.params.clearSubject = true
        }
        delete payload._origSubjectId
        const n = (payload.studentIds || []).length
        const save = () => {
          this.saving = true
          const req = payload.groupId ? updateStudyGroup(payload) : addStudyGroup(payload)
          return req.then(() => {
            this.$modal.msgSuccess('保存成功')
            this.open = false
            this.refreshAll()
          }).finally(() => { this.saving = false })
        }
        if (n === 0) {
          this.$modal.confirm('当前未选择成员，组内将无人，仍要保存？').then(save).catch(() => {})
        } else if (n < 4 || n > 6) {
          this.$modal.confirm('建议每组 4～6 人，当前 ' + n + ' 人，仍要保存？').then(save).catch(() => {})
        } else {
          save()
        }
      })
    },
    handleDelete(row) {
      this.$modal.confirm('确认解散小组「' + row.groupName + '」？历史打卡将保留。').then(() => {
        return delStudyGroup(row.groupId)
      }).then(() => {
        this.$modal.msgSuccess('已解散')
        this.refreshAll()
      }).catch(() => {})
    },
    openSmart() {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      this.smartForm = {
        subjectId: this.queryParams.subjectId,
        examId: undefined,
        groupSize: 5,
        mode: 'unassigned'
      }
      this.loadUnassigned()
      this.loadExamOptions().then(() => {
        if (!this.smartForm.examId && this.examOptions.length) {
          this.smartForm.examId = this.examOptions[0].examId
        }
        this.smartOpen = true
      })
    },
    loadExamOptions() {
      if (!this.queryParams.deptId) {
        this.examOptions = []
        return Promise.resolve()
      }
      return listExamScore({
        deptId: this.queryParams.deptId,
        status: '1',
        pageNum: 1,
        pageSize: 50
      }).then(res => {
        this.examOptions = res.rows || []
      }).catch(() => { this.examOptions = [] })
    },
    submitSmart() {
      const run = () => {
        this.smartSaving = true
        smartAssignGroups({
          deptId: this.queryParams.deptId,
          subjectId: this.smartForm.subjectId || undefined,
          examId: this.smartForm.examId || undefined,
          groupSize: this.smartForm.groupSize,
          mode: this.smartForm.mode
        }).then(res => {
          const d = res.data || {}
          const scoreTip = d.scoreBalanced
            ? ('，已按成绩均衡' + (d.examName ? ('（' + d.examName + '）') : '') + '，覆盖成绩 ' + (d.scoredStudentCount || 0) + ' 人')
            : '，无可用成绩仅性别均衡'
          this.$modal.msgSuccess('已创建 ' + (d.createdCount || 0) + ' 个组，覆盖 ' + (d.studentCount || 0) + ' 名学生' + scoreTip)
          this.smartOpen = false
          if (this.smartForm.subjectId !== this.queryParams.subjectId) {
            this.queryParams.subjectId = this.smartForm.subjectId
          }
          this.queryParams.status = '0'
          this.refreshAll()
        }).finally(() => { this.smartSaving = false })
      }
      if (this.smartForm.mode === 'rebuild') {
        this.$modal.confirm('将解散本班级该学科范围下所有启用小组并重新编组，确认继续？').then(run).catch(() => {})
      } else {
        run()
      }
    },
    previewMembers(row) {
      if (!row || !row.groupId) return
      this.previewGroup = row
      this.previewMembersList = []
      this.previewPerf = {}
      this.previewTrendOption = {}
      this.previewWeakList = []
      this.previewWeakOption = {}
      this.previewTab = 'scores'
      this.previewExamId = this.queryParams.examId || row.statsExamId || undefined
      this.previewExamOptions = (this.examOptions || []).slice()
      this.previewOpen = true
      this.loadPreviewPerformance()
    },
    onPreviewClosed() {
      this.previewLoading = false
      this.previewGroup = null
      this.previewMembersList = []
      this.previewPerf = {}
      this.previewTrendOption = {}
      this.previewWeakList = []
      this.previewWeakOption = {}
      this.previewExamId = undefined
      this.previewTab = 'scores'
    },
    onPreviewOpened() {
      this.$nextTick(() => this.resizePreviewTrend())
    },
    onPreviewTabClick(tab) {
      const name = (tab && (tab.name || tab.paneName)) || this.previewTab
      if (name === 'trend' || name === 'weak') {
        this.$nextTick(() => {
          this.$nextTick(() => {
            if (name === 'trend') this.resizePreviewTrend()
            if (name === 'weak') this.resizePreviewWeak()
          })
        })
      }
    },
    resizePreviewTrend() {
      const chart = this.$refs.previewTrendChart
      if (chart && typeof chart.resize === 'function') {
        chart.resize()
      }
    },
    resizePreviewWeak() {
      const chart = this.$refs.previewWeakChart
      if (chart && typeof chart.resize === 'function') {
        chart.resize()
      }
    },
    reloadPreviewPerformance() {
      this.loadPreviewPerformance()
    },
    loadPreviewPerformance() {
      if (!this.previewGroup || !this.previewGroup.groupId) return
      this.previewLoading = true
      const subjectId = this.previewGroup.subjectId || this.queryParams.subjectId || undefined
      getGroupPerformance(this.previewGroup.groupId, {
        subjectId,
        examId: this.previewExamId || undefined
      }).then(res => {
        const data = res.data || {}
        this.previewPerf = data
        this.previewMembersList = data.members || []
        this.previewWeakList = data.weakTop || []
        this.previewExamOptions = (data.exams && data.exams.length) ? data.exams.slice().reverse() : (this.examOptions || []).slice()
        if (data.examId) this.previewExamId = data.examId
        this.$set(this.memberPreview, this.previewGroup.groupId, (data.members || []).slice(0, 8))
        this.buildPreviewTrend(data.trend || [])
        this.buildPreviewWeak(this.previewWeakList)
      }).catch(() => {
        this.previewPerf = {}
        this.previewMembersList = []
        this.previewWeakList = []
        this.previewTrendOption = {
          title: { text: '加载失败', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } }
        }
        this.previewWeakOption = {}
      }).finally(() => { this.previewLoading = false })
    },
    buildPreviewTrend(list) {
      if (!list || !list.length) {
        this.previewTrendOption = {
          title: { text: '暂无考试成绩', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } }
        }
        return
      }
      const xData = list.map(p => p.examName || ('考试#' + p.examId))
      const scoreData = list.map(p => p.avgScore == null ? null : Number(p.avgScore))
      const classData = list.map(p => p.classAvgScore == null ? null : Number(p.classAvgScore))
      const rankData = list.map(p => p.avgRank == null ? null : Number(p.avgRank))
      const hasClass = classData.some(v => v != null)
      const hasRank = rankData.some(v => v != null)
      const singlePoint = xData.length === 1
      const legend = ['小组均分']
      if (hasClass) legend.push('班级均分')
      if (hasRank) legend.push('小组均次')
      const scoreAxis = this.calcAxisPad(scoreData.concat(hasClass ? classData : []))
      const rankAxis = this.calcAxisPad(rankData)
      const series = [{
        name: '小组均分',
        type: 'line',
        smooth: !singlePoint,
        showSymbol: true,
        symbolSize: singlePoint ? 10 : 6,
        yAxisIndex: 0,
        data: scoreData,
        itemStyle: { color: '#2442ED' },
        lineStyle: { color: '#2442ED', width: 2 },
        areaStyle: singlePoint ? undefined : { opacity: 0.1, color: 'rgba(36, 66, 237, 0.16)' }
      }]
      if (hasClass) {
        series.push({
          name: '班级均分',
          type: 'line',
          smooth: !singlePoint,
          showSymbol: true,
          symbolSize: singlePoint ? 10 : 6,
          yAxisIndex: 0,
          data: classData,
          itemStyle: { color: '#94A3B8' },
          lineStyle: { color: '#94A3B8', type: 'dashed', width: 2 }
        })
      }
      if (hasRank) {
        series.push({
          name: '小组均次',
          type: 'line',
          smooth: !singlePoint,
          showSymbol: true,
          symbolSize: singlePoint ? 10 : 6,
          yAxisIndex: 1,
          data: rankData,
          itemStyle: { color: '#F79009' },
          lineStyle: { color: '#F79009', width: 2 }
        })
      }
      this.previewTrendOption = {
        tooltip: { trigger: 'axis' },
        legend: {
          data: legend,
          bottom: 4,
          left: 'center',
          itemGap: 20,
          textStyle: { color: '#475467', fontSize: 12 }
        },
        grid: {
          left: 16,
          right: hasRank ? 28 : 16,
          bottom: 48,
          top: 36,
          containLabel: true
        },
        xAxis: {
          type: 'category',
          boundaryGap: true,
          data: xData,
          axisLabel: {
            color: '#667085',
            hideOverlap: true,
            rotate: xData.length > 5 ? 28 : 0,
            interval: 0,
            formatter: (val) => {
              const s = String(val || '')
              return s.length > 12 ? (s.slice(0, 12) + '…') : s
            }
          }
        },
        yAxis: [
          {
            type: 'value',
            name: '均分',
            nameTextStyle: { color: '#98A2B3', padding: [0, 0, 0, 8] },
            min: scoreAxis.min,
            max: scoreAxis.max,
            scale: false,
            axisLabel: { color: '#667085' },
            splitLine: { lineStyle: { color: '#F2F4F7' } }
          },
          {
            type: 'value',
            name: '均次',
            nameTextStyle: { color: '#98A2B3' },
            inverse: true,
            min: rankAxis.min,
            max: rankAxis.max,
            scale: false,
            splitLine: { show: false },
            axisLabel: { color: '#667085' },
            show: hasRank
          }
        ],
        series
      }
      this.$nextTick(() => this.resizePreviewTrend())
    },
    buildPreviewWeak(list) {
      const rows = (list || []).slice(0, 8)
      if (!rows.length) {
        this.previewWeakOption = {
          title: { text: '暂无薄弱知识点', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } }
        }
        return
      }
      const names = rows.map(r => r.knowledgeName || r.name || '-').reverse()
      const rates = rows.map(r => this.toPercent(r.rate)).reverse()
      this.previewWeakOption = {
        tooltip: {
          trigger: 'axis',
          axisPointer: { type: 'shadow' },
          formatter: (params) => {
            const p = (params && params[0]) || {}
            return (p.name || '') + '<br/>组均得分率：' + (p.value != null ? p.value + '%' : '-')
          }
        },
        grid: { left: 8, right: 24, top: 12, bottom: 8, containLabel: true },
        xAxis: { type: 'value', name: '%', min: 0, max: 100, axisLabel: { color: '#667085' }, splitLine: { lineStyle: { color: '#F2F4F7' } } },
        yAxis: {
          type: 'category',
          data: names,
          axisLabel: {
            color: '#344054',
            width: 110,
            overflow: 'truncate'
          }
        },
        series: [{
          name: '组均得分率',
          type: 'bar',
          data: rates,
          barMaxWidth: 18,
          itemStyle: {
            color: (p) => {
              const v = Number(p.value)
              if (isNaN(v)) return '#94A3B8'
              if (v < 45) return '#D92D20'
              if (v < 60) return '#F79009'
              return '#2442ED'
            }
          },
          label: { show: true, position: 'right', formatter: '{c}%', color: '#667085', fontSize: 11 }
        }]
      }
      this.$nextTick(() => this.resizePreviewWeak())
    },
    toPercent(v) {
      if (v == null || v === '') return null
      const n = Number(v)
      if (isNaN(n)) return null
      return +(n <= 1 ? n * 100 : n).toFixed(1)
    },
    formatRatePct(v) {
      const p = this.toPercent(v)
      return p == null ? '-' : (p + '%')
    },
    exportDeptWeak(format) {
      const fmt = format === 'pdf' ? 'pdf' : 'xlsx'
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      if (!(this.groupList || []).length) {
        this.$modal.msgWarning('当前没有可导出的小组')
        return
      }
      const params = {
        deptId: this.queryParams.deptId,
        format: fmt
      }
      if (this.queryParams.subjectId) params.subjectId = this.queryParams.subjectId
      const name = `class_groups_weak_${this.queryParams.deptId}_${Date.now()}.${fmt}`
      this.download('spas/group/weak/export', params, name)
    },
    exportPreviewWeak(format) {
      const fmt = format === 'pdf' ? 'pdf' : 'xlsx'
      if (!this.previewGroup || !this.previewGroup.groupId) return
      if (!(this.previewWeakList || []).length) {
        this.$modal.msgWarning('暂无薄弱知识点可导出')
        return
      }
      this.weakExportLoading = fmt
      const subjectId = this.previewPerf.subjectId || this.previewGroup.subjectId || this.queryParams.subjectId
      const params = { format: fmt }
      if (subjectId) params.subjectId = subjectId
      const gname = (this.previewGroup.groupName || 'group').replace(/[\\/:*?"<>|\s]+/g, '_')
      const name = `group_weak_${gname}_${Date.now()}.${fmt}`
      this.download('spas/group/' + this.previewGroup.groupId + '/weak/export', params, name)
        .finally(() => { this.weakExportLoading = '' })
    },
    /** Pad axis range so single/close points don't collapse into a hairline. */
    calcAxisPad(values) {
      const nums = (values || []).map(v => Number(v)).filter(v => !isNaN(v))
      if (!nums.length) return { min: null, max: null }
      let min = Math.min.apply(null, nums)
      let max = Math.max.apply(null, nums)
      if (min === max) {
        const pad = Math.max(Math.abs(min) * 0.08, 5)
        return { min: Math.max(0, +(min - pad).toFixed(1)), max: +(max + pad).toFixed(1) }
      }
      const span = max - min
      const pad = Math.max(span * 0.15, 2)
      return {
        min: Math.max(0, +(min - pad).toFixed(1)),
        max: +(max + pad).toFixed(1)
      }
    },
    formatDelta(v) {
      const n = Number(v)
      if (isNaN(n)) return '-'
      const s = n > 0 ? '+' : ''
      return s + (Number.isInteger(n) ? String(n) : n.toFixed(1))
    },
    formatRankDelta(v) {
      const n = Number(v)
      if (isNaN(n) || n === 0) return '持平'
      return n > 0 ? ('升 ' + n) : ('降 ' + Math.abs(n))
    },
    deltaClass(v, rankImprovePositive) {
      const n = Number(v)
      if (isNaN(n) || n === 0) return 'delta-flat'
      const good = rankImprovePositive ? n > 0 : n > 0
      return good ? 'delta-up' : 'delta-down'
    }
  }
}
</script>

<style scoped>
.filter-form { margin-bottom: 4px; }
.mb8 { margin-bottom: 12px; }
.mt8 { margin-top: 8px; }
.list-summary {
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  gap: 4px 0;
  margin: 4px 0 14px;
  padding: 8px 12px;
  background: #F8FAFC;
  border: 1px solid #EEF2F6;
  border-radius: 6px;
  color: #475467;
  font-size: 13px;
}
.list-summary .dot { margin: 0 8px; color: #D0D5DD; }
.list-summary b { color: #101828; font-weight: 600; }
.list-summary b.warn { color: #B54708; }
.list-summary .hint {
  margin-left: auto;
  color: #98A2B3;
  font-size: 12px;
}
.group-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 12px;
}
.group-card {
  display: flex;
  flex-direction: column;
  min-height: 148px;
  padding: 14px 14px 8px;
  background: #fff;
  border: 1px solid #EAECF0;
  border-radius: 8px;
  cursor: pointer;
  transition: border-color .15s, box-shadow .15s;
}
.group-card:hover {
  border-color: #B2DDFF;
  box-shadow: 0 4px 12px rgba(16, 24, 40, 0.06);
}
.group-card.disabled { opacity: 0.65; background: #F9FAFB; }
.group-card.size-warn { border-left: 3px solid #F79009; }
.card-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 8px;
}
.title-row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 6px;
  min-width: 0;
}
.group-name {
  font-size: 15px;
  font-weight: 600;
  color: #101828;
  line-height: 1.3;
}
.status-pill {
  font-size: 11px;
  line-height: 1;
  padding: 3px 6px;
  border-radius: 4px;
  background: #F2F4F7;
  color: #667085;
}
.status-pill.muted { background: #F2F4F7; color: #98A2B3; }
.count-badge {
  flex-shrink: 0;
  font-size: 12px;
  font-weight: 600;
  color: #344054;
  background: #F2F4F7;
  padding: 3px 8px;
  border-radius: 999px;
}
.count-badge.warn {
  color: #B54708;
  background: #FFFAEB;
}
.leader-row {
  margin-top: 10px;
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 13px;
  color: #344054;
}
.leader-row i { color: #F79009; font-size: 13px; }
.stats-row {
  margin-top: 8px;
  display: flex;
  flex-wrap: wrap;
  gap: 6px 10px;
  font-size: 12px;
  color: #344054;
}
.stats-row .stat em {
  font-style: normal;
  color: #98A2B3;
  margin-right: 2px;
}
.stats-row .stat.muted { color: #98A2B3; }
.members-line {
  margin-top: 8px;
  flex: 1;
  font-size: 12px;
  line-height: 1.5;
  color: #667085;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  word-break: break-all;
}
.card-actions {
  margin-top: 8px;
  padding-top: 4px;
  border-top: 1px solid #F2F4F7;
  display: flex;
  gap: 2px;
}
.card-actions .el-button { padding: 4px 6px; }
.danger-text { color: #F04438 !important; }
.form-tip { margin-top: 6px; font-size: 12px; color: #909399; line-height: 1.4; }
.form-tip.inline { margin-left: 8px; }
.perf-body { min-height: 320px; }
.perf-summary {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
  padding: 10px 12px;
  background: #F8FAFC;
  border: 1px solid #EEF2F6;
  border-radius: 8px;
}
.perf-summary-left {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
  min-width: 0;
}
.perf-exam-select { width: 260px; }
.perf-metric {
  font-size: 12px;
  color: #667085;
  line-height: 1.4;
}
.perf-kpis {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.kpi-box {
  min-width: 72px;
  padding: 6px 10px;
  background: #fff;
  border: 1px solid #EAECF0;
  border-radius: 6px;
  text-align: center;
}
.kpi-label {
  display: block;
  font-size: 11px;
  color: #98A2B3;
  line-height: 1.2;
}
.kpi-value {
  display: block;
  margin-top: 2px;
  font-size: 15px;
  font-weight: 600;
  color: #101828;
  line-height: 1.2;
}
.perf-tabs { margin-top: 2px; }
.perf-table { width: 100%; }
.trend-panel {
  width: 100%;
  min-height: 420px;
  overflow: hidden;
}
.trend-panel >>> .spas-chart,
.weak-chart-wrap >>> .spas-chart {
  width: 100% !important;
  min-width: 100%;
}
.weak-panel { width: 100%; }
.weak-chart-wrap {
  width: 100%;
  margin-bottom: 8px;
  overflow: hidden;
}
.weak-export-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin: 10px 0 4px;
}
.perf-tip {
  margin: 8px 0 0;
  font-size: 12px;
  color: #98A2B3;
  line-height: 1.5;
}
.muted { color: #98A2B3; }
.delta-up { color: #039855; font-weight: 600; }
.delta-down { color: #D92D20; font-weight: 600; }
.delta-flat { color: #98A2B3; }
</style>

<style>
.group-perf-dialog .el-dialog__body {
  padding: 12px 20px 6px;
}
.group-perf-dialog .el-tabs__header {
  margin-bottom: 12px;
}
.group-perf-dialog .el-tabs__content {
  overflow: visible;
}
</style>
