<template>
  <div class="app-container spas-portfolio">
    <div class="class-filter-panel">
      <div class="filter-toolbar">
        <div class="filter-toolbar-left">
          <el-select v-model="gradeFilter" size="small" class="filter-select" clearable placeholder="全部年级">
            <el-option label="全部年级" value="" />
            <el-option v-for="g in gradeOptions" :key="g" :label="g" :value="g" />
          </el-select>
        </div>
        <div class="exam-search">
          <el-input
            v-model="studentNameKeyword"
            size="small"
            clearable
            placeholder="学号 / 姓名搜索"
            @keyup.enter.native="handleStudentSearch"
          />
          <el-button
            type="primary"
            size="small"
            icon="el-icon-search"
            class="exam-search-btn"
            @click="handleStudentSearch"
            v-hasPermi="['spas:portfolio:list']"
          />
        </div>
      </div>

      <div class="filter-tag-rows">
        <div class="filter-tag-row">
          <span class="filter-tag-label">班级:</span>
          <div class="filter-tag-list">
            <button
              type="button"
              class="filter-chip"
              :class="{ active: !queryParams.deptId }"
              @click="clearClassFilter"
            >全部</button>
            <button
              v-for="d in visibleClassTags"
              :key="d.deptId"
              type="button"
              class="filter-chip"
              :class="{ active: Number(queryParams.deptId) === Number(d.deptId) }"
              @click="selectClassTag(d.deptId)"
            >{{ d.deptName }}{{ d.primary ? '·主' : '' }}</button>
            <button
              v-if="classTagsOverflow"
              type="button"
              class="filter-more"
              @click="classTagsExpanded = !classTagsExpanded"
            >
              {{ classTagsExpanded ? '收起' : '更多' }}
              <i :class="classTagsExpanded ? 'el-icon-arrow-up' : 'el-icon-arrow-down'" />
            </button>
            <treeselect
              v-if="!boundClassMode && !classTagOptions.length"
              v-model="queryParams.deptId"
              :options="deptOptions"
              :show-count="true"
              placeholder="请选择班级/部门"
              class="filter-treeselect"
              @input="handleDeptChange"
            />
            <el-tag v-if="boundClassMode && boundClassRoleLabel" size="mini" type="info">{{ boundClassRoleLabel }}</el-tag>
          </div>
        </div>

        <div class="filter-tag-row">
          <span class="filter-tag-label">学科:</span>
          <div class="filter-tag-list">
            <button
              type="button"
              class="filter-chip"
              :class="{ active: !queryParams.subjectId }"
              @click="selectSubjectTag(undefined)"
            >全部</button>
            <button
              v-for="s in subjectOptions"
              :key="s.subjectId"
              type="button"
              class="filter-chip"
              :class="{ active: Number(queryParams.subjectId) === Number(s.subjectId) }"
              @click="selectSubjectTag(s.subjectId)"
            >{{ s.subjectName }}</button>
          </div>
        </div>
      </div>

      <div class="filter-actions">
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['spas:portfolio:list']">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        <el-button
          v-if="queryParams.studentId"
          type="text"
          size="mini"
          icon="el-icon-back"
          @click="backToStudentList"
        >返回学生名单</el-button>
        <el-button
          type="success"
          plain
          icon="el-icon-data-analysis"
          size="mini"
          :disabled="!queryParams.studentId"
          @click="goAnalysis"
          v-hasPermi="['spas:analysis:student']"
        >学情分析</el-button>
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          :disabled="!queryParams.studentId"
          @click="handleExportReport('pdf')"
          v-hasPermi="['spas:report:export']"
        >导出报告</el-button>
        <el-button
          type="info"
          plain
          icon="el-icon-document"
          size="mini"
          :disabled="!queryParams.studentId"
          @click="handleExportReport('xlsx')"
          v-hasPermi="['spas:report:export']"
        >导出明细</el-button>
      </div>
    </div>

    <el-empty v-if="!queryParams.deptId" description="请选择班级后查看学生名单">
      <div class="empty-actions">
        <el-button type="primary" size="mini" v-if="myDepts.length" @click="selectClassTag(preferredDeptId)">选择我的班级</el-button>
        <el-button size="mini" v-if="!boundClassMode" @click="$router.push('/system/dept')">去部门管理</el-button>
      </div>
    </el-empty>

    <div
      v-else-if="!queryParams.studentId"
      class="student-roster-panel"
      v-loading="studentLoading"
    >
      <div class="roster-header">
        <div class="roster-header-main">
          <div class="roster-title">{{ currentDeptName || '班级' }} · 学生名单</div>
          <div class="roster-sub">点击卡片进入一生一册；可用顶部搜索框按学号/姓名筛选</div>
        </div>
        <div class="roster-meta">
          <span class="roster-count">{{ filteredStudentOptions.length }}</span>
          <span class="roster-count-label">人{{ studentNameKeyword ? '（已筛选）' : '' }}</span>
        </div>
      </div>

      <el-empty
        v-if="!filteredStudentOptions.length"
        :description="studentNameKeyword ? '未找到匹配学生，请调整搜索关键词' : '当前班级暂无学生'"
        :image-size="72"
      >
        <el-button size="mini" @click="$router.push('/spas/student')" v-hasPermi="['spas:student:list']">去学生档案</el-button>
      </el-empty>

      <div v-else class="roster-grid">
        <button
          v-for="s in filteredStudentOptions"
          :key="s.studentId"
          type="button"
          class="roster-tile"
          :class="{ 'is-inactive': s.status !== '0' }"
          @click="enterPortfolio(s)"
        >
          <span class="roster-avatar" :class="'tone-' + studentAvatarTone(s)">{{ studentAvatarText(s) }}</span>
          <span class="roster-body">
            <span class="roster-name-row">
              <span class="roster-name">{{ s.studentName || '-' }}</span>
              <span v-if="studentSexLabel(s)" class="roster-sex">{{ studentSexLabel(s) }}</span>
              <el-tag v-if="s.status !== '0'" size="mini" type="info" effect="plain">停用</el-tag>
            </span>
            <span class="roster-no">学号 {{ s.studentNo || '-' }}</span>
          </span>
          <span class="roster-action">
            一册<i class="el-icon-arrow-right" />
          </span>
        </button>
      </div>
    </div>

    <div v-else v-loading="loading">
      <el-card shadow="never" class="profile-card">
        <div slot="header" class="card-header">学生档案</div>
        <el-descriptions :column="4" border size="small" v-if="portfolio.student">
          <el-descriptions-item label="学号">{{ portfolio.student.studentNo }}</el-descriptions-item>
          <el-descriptions-item label="姓名">{{ portfolio.student.studentName }}</el-descriptions-item>
          <el-descriptions-item label="待处理预警">
            <el-tag type="danger" size="mini">{{ portfolio.openWarningCount || 0 }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="进行中干预">
            <el-tag type="warning" size="mini">{{ portfolio.openInterveneCount || 0 }}</el-tag>
          </el-descriptions-item>
        </el-descriptions>
      </el-card>

      <el-alert
        v-if="summary.headline"
        :title="summary.headline"
        type="info"
        :closable="false"
        show-icon
        style="margin-top: 12px"
      />

      <el-card shadow="never" style="margin-top: 16px">
        <div slot="header" class="card-header card-header-row">
          <span>实考校次进退</span>
          <el-button type="text" size="mini" icon="el-icon-data-analysis" @click="goAnalysis" v-hasPermi="['spas:analysis:student']">查看学情详情</el-button>
        </div>
        <el-alert
          v-if="rankSummary && rankSummary.headline"
          class="mb8"
          type="info"
          :closable="false"
          show-icon
          :title="rankSummary.headline"
        />
        <el-table :data="rankSubjects" size="small" empty-text="暂无实考校次。请先在「实考校次」导入多次成绩。">
          <el-table-column label="科目" prop="subjectName" width="90" />
          <el-table-column label="校次轨迹" prop="track" min-width="160" :show-overflow-tooltip="true" />
          <el-table-column label="最近校次" width="90" align="center">
            <template slot-scope="scope">{{ scope.row.latestRank == null ? '-' : scope.row.latestRank }}</template>
          </el-table-column>
          <el-table-column label="相对总分" width="110" align="center">
            <template slot-scope="scope">
              <span v-if="scope.row.vsTotal == null">-</span>
              <span v-else :style="{ color: scope.row.vsTotal > 0 ? '#F56C6C' : (scope.row.vsTotal < 0 ? '#67C23A' : '#909399') }">
                {{ vsTotalText(scope.row) }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="较上次" width="100" align="center">
            <template slot-scope="scope">
              <span :style="{ color: rankColor(scope.row.trend) }">{{ deltaText(scope.row.stepDelta) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="结论" width="90" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="rankTag(scope.row.trend)">{{ scope.row.trendLabel || '-' }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="薄弱解释" min-width="180" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.explain || '-' }}</template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" v-if="interveneTimeline.length">
        <div slot="header" class="card-header card-header-row">
          <span>干预时间线</span>
          <el-button type="text" size="mini" icon="el-icon-s-flag" @click="goInterveneList" v-hasPermi="['spas:intervene:list']">干预中心</el-button>
        </div>
        <el-timeline>
          <el-timeline-item
            v-for="(item, idx) in interveneTimeline"
            :key="idx"
            :timestamp="parseTime(item.time)"
            :type="timelineType(item)"
            placement="top"
          >
            <p><b>{{ timelineTitle(item) }}</b></p>
            <p v-if="item.type === 'intervene_create'">基线 {{ formatRate(item.baselineRate) }} → 目标 {{ formatRate(item.targetRate) }}</p>
            <p v-if="item.type === 'coach'">{{ item.createBy || '教师' }}：{{ item.content }}</p>
            <p v-if="item.type === 'intervene_effect'">
              当前 {{ formatRate(item.effectRate) }}，增益
              <span :style="{ color: Number(item.effectDelta) > 0 ? '#10B981' : '#FF5A5F' }">{{ formatGap(item.effectDelta) }}</span>
              <el-tag v-if="item.effectPassed === '1'" type="success" size="mini" style="margin-left: 8px">达标</el-tag>
            </p>
          </el-timeline-item>
        </el-timeline>
      </el-card>

      <el-row :gutter="16" style="margin-top: 16px">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never">
            <div slot="header" class="card-header">知识点掌握雷达<span class="card-hint">点击下钻学情</span></div>
            <spas-chart :option="radarOption" height="340px" @chart-click="onRadarClick" />
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never">
            <div slot="header" class="card-header">成绩趋势<span class="card-hint">点击查看学情</span></div>
            <spas-chart :option="trendOption" height="340px" @chart-click="goAnalysis" />
          </el-card>
        </el-col>
      </el-row>

      <el-card shadow="never" style="margin-top: 16px">
        <div slot="header" class="card-header">本学期反复薄弱</div>
        <el-table :data="persistentWeak" empty-text="暂无反复薄弱（本学期）" @row-click="onKnowledgeRow">
          <el-table-column label="知识点" align="center" min-width="160">
            <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName }}</template>
          </el-table-column>
          <el-table-column label="加权得分率" align="center" width="120">
            <template slot-scope="scope">{{ formatRate(scope.row.rate != null ? scope.row.rate : scope.row.weightedRate) }}</template>
          </el-table-column>
          <el-table-column label="偏低场次" align="center" width="110">
            <template slot-scope="scope">{{ scope.row.lowPapers || 0 }}/{{ scope.row.validPapers || 0 }}</template>
          </el-table-column>
          <el-table-column label="标签" align="center" width="110">
            <template slot-scope="scope">
              <el-tag size="mini" type="danger">{{ scope.row.persistTag || '反复薄弱' }}</el-tag>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" v-if="errorCauseSummary.length">
        <div slot="header" class="card-header">错因分布</div>
        <el-table :data="errorCauseSummary" size="small" empty-text="暂无错因标签">
          <el-table-column label="错因大类" min-width="120">
            <template slot-scope="scope">{{ scope.row.errorCategoryLabel || scope.row.errorLabel || '-' }}</template>
          </el-table-column>
          <el-table-column label="题数" prop="tagCount" width="90" align="center" />
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px">
        <div slot="header" class="card-header">薄弱知识点 Top</div>
        <el-table :data="weakList" empty-text="暂无薄弱点" @row-click="onKnowledgeRow">
          <el-table-column label="知识点" align="center" min-width="160">
            <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName }}</template>
          </el-table-column>
          <el-table-column label="加权得分率" align="center" width="120">
            <template slot-scope="scope">{{ formatRate(scope.row.rate != null ? scope.row.rate : scope.row.weightedRate) }}</template>
          </el-table-column>
          <el-table-column label="薄弱等级" align="center" width="120">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_weak_level" :value="scope.row.weakLevel" />
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-row :gutter="16" style="margin-top: 16px">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never">
            <div slot="header" class="card-header">未处理预警</div>
            <el-table :data="openWarnings" empty-text="暂无预警" @row-click="goWarning">
              <el-table-column label="标题" prop="title" min-width="120" :show-overflow-tooltip="true" />
              <el-table-column label="级别" width="90" align="center">
                <template slot-scope="scope">
                  <dict-tag :options="dict.type.spas_warning_level" :value="scope.row.level" />
                </template>
              </el-table-column>
              <el-table-column label="时间" width="160" align="center">
                <template slot-scope="scope">{{ parseTime(scope.row.createTime) }}</template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never">
            <div slot="header" class="card-header card-header-row">
              <span>辅导记录</span>
              <el-button type="text" size="mini" icon="el-icon-plus" @click="openCoach" v-hasPermi="['spas:portfolio:coach', 'spas:portfolio:list']">新增</el-button>
            </div>
            <el-timeline v-if="coachLogs.length">
              <el-timeline-item
                v-for="item in coachLogs"
                :key="item.logId"
                :timestamp="parseTime(item.createTime)"
                placement="top"
              >
                <p><b>{{ item.createBy || '教师' }}</b>：{{ item.content }}</p>
                <p v-if="item.nextPlan" class="next-plan">下一步：{{ item.nextPlan }}</p>
                <p v-if="coachLinkText(item)" class="coach-link">{{ coachLinkText(item) }}</p>
              </el-timeline-item>
            </el-timeline>
            <el-empty v-else description="暂无辅导记录" :image-size="64" />
          </el-card>
        </el-col>
      </el-row>
    </div>

    <el-dialog title="新增辅导记录" :visible.sync="coachOpen" width="560px" append-to-body>
      <el-form ref="coachForm" :model="coachForm" :rules="coachRules" label-width="100px">
        <el-form-item label="关联干预">
          <el-select v-model="coachForm.interveneId" clearable filterable placeholder="可选，关联进行中干预" style="width: 100%">
            <el-option
              v-for="item in interveneOptions"
              :key="item.interveneId"
              :label="item.title || ('干预#' + item.interveneId)"
              :value="item.interveneId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="关联预警">
          <el-select v-model="coachForm.warningId" clearable filterable placeholder="可选，关联未处理预警" style="width: 100%">
            <el-option
              v-for="item in openWarnings"
              :key="item.warningId"
              :label="item.title || ('预警#' + item.warningId)"
              :value="item.warningId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="关联知识点">
          <el-select v-model="coachForm.knowledgeId" clearable filterable placeholder="可选，关联薄弱知识点" style="width: 100%">
            <el-option
              v-for="item in knowledgeOptions"
              :key="item.knowledgeId"
              :label="item.name || item.knowledgeName"
              :value="item.knowledgeId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="辅导内容" prop="content">
          <el-input v-model="coachForm.content" type="textarea" :rows="4" placeholder="请输入辅导内容" />
        </el-form-item>
        <el-form-item label="下一步计划" prop="nextPlan">
          <el-input v-model="coachForm.nextPlan" type="textarea" :rows="2" placeholder="可选" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitCoach">确 定</el-button>
        <el-button @click="coachOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getPortfolio, addCoachLog } from '@/api/spas/portfolio'
import { optionselectSubject } from '@/api/spas/subject'
import { listStudent } from '@/api/spas/student'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { boundClassRoleFromDepts } from '@/utils/spasTeacherRole'
import { applyTeachingDeptContext, canLoadSystemDeptTree, isLikelyClassDeptName } from '@/utils/spasDeptTree'
import { deptTreeSelect } from '@/api/system/user'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import SpasChart from '@/components/spas/charts/SpasChart'

export default {
  name: 'SpasPortfolio',
  dicts: ['spas_weak_level', 'spas_warning_level'],
  components: { Treeselect, SpasChart },
  data() {
    return {
      loading: false,
      subjectOptions: [],
      deptOptions: [],
      myDepts: [],
      studentOptions: [],
      studentLoading: false,
      studentNameKeyword: '',
      gradeFilter: '',
      classTagsExpanded: false,
      portfolio: {},
      summary: {},
      interveneTimeline: [],
      weakList: [],
      persistentWeak: [],
      errorCauseSummary: [],
      openWarnings: [],
      coachLogs: [],
      rankSubjects: [],
      rankSummary: {},
      radarData: [],
      radarOption: {},
      trendOption: {},
      coachOpen: false,
      coachForm: {},
      coachRules: {
        content: [{ required: true, message: '辅导内容不能为空', trigger: 'blur' }]
      },
      queryParams: {
        deptId: undefined,
        studentId: undefined,
        subjectId: undefined
      }
    }
  },
  computed: {
    boundClassMode() {
      return Array.isArray(this.myDepts) && this.myDepts.length > 0
    },
    preferredDeptId() {
      if (!this.myDepts.length) return undefined
      const primary = this.myDepts.find(d => d.primary)
      return (primary || this.myDepts[0]).deptId
    },
    currentDeptName() {
      const id = this.queryParams.deptId
      if (id == null || id === '') return ''
      const mine = (this.myDepts || []).find(d => String(d.deptId) === String(id))
      if (mine && mine.deptName) return mine.deptName
      const hit = (this.classTagOptions || []).find(d => Number(d.deptId) === Number(id))
      if (hit && hit.deptName) return hit.deptName
      const node = this.findDeptNode(this.deptOptions, id)
      return node ? (node.label || node.deptName || '') : ''
    },
    boundClassRoleLabel() {
      return boundClassRoleFromDepts(this.myDepts, this.queryParams.deptId)
    },
    classTagOptions() {
      const keepClass = list => (list || []).filter(d =>
        isLikelyClassDeptName(d.deptName, d.parentLabel)
      )
      if (this.boundClassMode) {
        return keepClass((this.myDepts || []).map(d => ({
          deptId: d.deptId,
          deptName: d.deptName,
          primary: !!d.primary,
          parentLabel: d.parentName || d.parentLabel || ''
        })))
      }
      const leaves = []
      const walk = (nodes, parentLabel) => {
        ;(nodes || []).forEach(n => {
          const id = n.id != null ? n.id : n.deptId
          const name = n.label || n.deptName || ''
          const kids = n.children || []
          if (!kids.length) {
            leaves.push({ deptId: id, deptName: name, parentLabel: parentLabel || '' })
          } else {
            walk(kids, name)
          }
        })
      }
      walk(this.deptOptions, '')
      const classLeaves = keepClass(leaves)
      if (classLeaves.length) return classLeaves
      return keepClass((this.myDepts || []).map(d => ({
        deptId: d.deptId,
        deptName: d.deptName,
        primary: !!d.primary,
        parentLabel: d.parentName || d.parentLabel || ''
      })))
    },
    gradeOptions() {
      const set = {}
      ;(this.classTagOptions || []).forEach(d => {
        const g = this.extractGradeLabel(d.deptName, d.parentLabel)
        if (g) set[g] = true
      })
      return Object.keys(set)
    },
    filteredClassTags() {
      const all = this.classTagOptions || []
      if (!this.gradeFilter) return all
      return all.filter(d => this.extractGradeLabel(d.deptName, d.parentLabel) === this.gradeFilter)
    },
    classTagsOverflow() {
      return this.filteredClassTags.length > 12
    },
    visibleClassTags() {
      const list = this.filteredClassTags
      if (this.classTagsExpanded || list.length <= 12) return list
      return list.slice(0, 12)
    },
    filteredStudentOptions() {
      const kw = (this.studentNameKeyword || '').trim().toLowerCase()
      let list = (this.studentOptions || []).slice()
      if (kw) {
        list = list.filter(s => {
          const no = String(s.studentNo || '').toLowerCase()
          const name = String(s.studentName || '').toLowerCase()
          return no.indexOf(kw) >= 0 || name.indexOf(kw) >= 0
        })
      }
      list.sort((a, b) => String(a.studentNo || '').localeCompare(String(b.studentNo || ''), 'zh-CN', { numeric: true }))
      return list
    },
    interveneOptions() {
      const map = {}
      ;(this.interveneTimeline || []).forEach(item => {
        if (item && item.interveneId != null && !map[item.interveneId]) {
          map[item.interveneId] = {
            interveneId: item.interveneId,
            title: item.title || ('干预#' + item.interveneId)
          }
        }
      })
      return Object.keys(map).map(k => map[k])
    },
    knowledgeOptions() {
      const map = {}
      const push = row => {
        if (!row) return
        const id = row.knowledgeId
        if (id == null || map[id]) return
        map[id] = {
          knowledgeId: id,
          name: row.name || row.knowledgeName || ('知识点#' + id)
        }
      }
      ;(this.weakList || []).forEach(push)
      ;(this.persistentWeak || []).forEach(push)
      return Object.keys(map).map(k => map[k])
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.deptId) {
      this.queryParams.deptId = Number(q.deptId) || q.deptId
    }
    if (q.studentId) {
      this.queryParams.studentId = Number(q.studentId) || q.studentId
    }
    if (q.subjectId) {
      this.queryParams.subjectId = Number(q.subjectId) || q.subjectId
    }
    this.loadSubjects()
    this.loadMyDepts().then(() => {
      // Enter page shows class chips + roster; only open portfolio when URL carries studentId
      if (this.queryParams.deptId) {
        return this.loadStudents()
      }
      return null
    }).then(() => {
      if (this.queryParams.studentId) {
        this.loadPortfolio()
      }
    }).catch(() => {})
  },
  methods: {
    findDeptNode(nodes, id) {
      for (const n of nodes || []) {
        if (n.id === id || n.deptId === id) return n
        const c = this.findDeptNode(n.children, id)
        if (c) return c
      }
      return null
    },
    extractGradeLabel(name, parentLabel) {
      const text = String(name || '') + ' ' + String(parentLabel || '')
      const patterns = ['高三', '高二', '高一', '初三', '初二', '初一', '九年级', '八年级', '七年级', '六年级', '五年级', '四年级', '三年级', '二年级', '一年级']
      for (let i = 0; i < patterns.length; i++) {
        if (text.indexOf(patterns[i]) >= 0) return patterns[i]
      }
      return ''
    },
    studentAvatarText(row) {
      const name = String((row && row.studentName) || '').trim()
      if (name) return name.slice(0, 1)
      const no = String((row && row.studentNo) || '').trim()
      return no ? no.slice(-2) : '?'
    },
    studentAvatarTone(row) {
      const seed = String((row && (row.studentId || row.studentNo || row.studentName)) || '')
      let h = 0
      for (let i = 0; i < seed.length; i++) h = (h + seed.charCodeAt(i) * (i + 1)) % 5
      return ['teal', 'blue', 'amber', 'rose', 'slate'][h]
    },
    studentSexLabel(row) {
      if (!row) return ''
      if (row.sex === '0' || row.sex === 0) return '男'
      if (row.sex === '1' || row.sex === 1) return '女'
      return ''
    },
    clearPortfolioView() {
      this.queryParams.studentId = undefined
      this.portfolio = {}
      this.summary = {}
      this.interveneTimeline = []
      this.weakList = []
      this.persistentWeak = []
      this.errorCauseSummary = []
      this.openWarnings = []
      this.coachLogs = []
      this.rankSubjects = []
      this.rankSummary = {}
      this.radarData = []
      this.radarOption = {}
      this.trendOption = {}
    },
    syncPortfolioRoute() {
      const q = {}
      if (this.queryParams.deptId) q.deptId = this.queryParams.deptId
      if (this.queryParams.studentId) q.studentId = this.queryParams.studentId
      if (this.queryParams.subjectId != null && this.queryParams.subjectId !== '') q.subjectId = this.queryParams.subjectId
      this.$router.replace({ path: this.$route.path, query: q }).catch(() => {})
    },
    clearClassFilter() {
      this.queryParams.deptId = undefined
      this.studentOptions = []
      this.studentNameKeyword = ''
      this.clearPortfolioView()
      this.syncPortfolioRoute()
    },
    selectClassTag(deptId) {
      this.selectMyDept(deptId)
    },
    selectSubjectTag(subjectId) {
      this.queryParams.subjectId = subjectId
      this.syncPortfolioRoute()
      if (this.queryParams.studentId) {
        this.loadPortfolio()
      }
    },
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      this.clearPortfolioView()
      this.studentNameKeyword = ''
      this.syncPortfolioRoute()
      this.loadStudents()
    },
    enterPortfolio(row) {
      const studentId = row && (row.studentId || row.id)
      if (!studentId) {
        this.$modal.msgWarning('无法定位学生')
        return
      }
      this.queryParams.studentId = studentId
      this.syncPortfolioRoute()
      this.loadPortfolio()
    },
    backToStudentList() {
      this.clearPortfolioView()
      this.syncPortfolioRoute()
      if (this.queryParams.deptId) {
        this.loadStudents((this.studentNameKeyword || '').trim() || undefined)
      }
    },
    handleStudentSearch() {
      const kw = (this.studentNameKeyword || '').trim()
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      if (this.queryParams.studentId) {
        this.backToStudentList()
      }
      this.loadStudents(kw || undefined)
    },
    handleQuery() {
      if (this.queryParams.studentId) {
        this.loadPortfolio()
        return
      }
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      this.loadStudents((this.studentNameKeyword || '').trim() || undefined)
    },
    resetQuery() {
      this.gradeFilter = ''
      this.classTagsExpanded = false
      this.studentNameKeyword = ''
      this.queryParams.subjectId = undefined
      this.clearClassFilter()
      this.loadSubjects()
    },
    toPercent(rate) {
      if (rate == null || rate === '') return 0
      const n = Number(rate)
      if (isNaN(n)) return 0
      return n <= 1 ? Math.round(n * 10000) / 100 : Math.round(n * 100) / 100
    },
    formatRate(rate) {
      if (rate == null || rate === '') return '-'
      return this.toPercent(rate).toFixed(1) + '%'
    },
    formatGap(gap) {
      if (gap == null || gap === '') return '-'
      const n = Number(gap)
      if (isNaN(n)) return gap
      const pct = (Math.abs(n) <= 1 ? n * 100 : n)
      return (pct > 0 ? '+' : '') + pct.toFixed(2) + '%'
    },
    timelineType(item) {
      if (item.type === 'intervene_effect') return item.effectPassed === '1' ? 'success' : 'warning'
      if (item.type === 'coach') return 'primary'
      return 'info'
    },
    timelineTitle(item) {
      if (item.type === 'intervene_create') return '创建干预：' + (item.title || '')
      if (item.type === 'coach') return '辅导记录'
      if (item.type === 'intervene_effect') return '效果评估：' + (item.title || '')
      return item.title || item.type
    },
    handleExportReport(format) {
      if (!this.queryParams.studentId) {
        this.$modal.msgWarning('请先选择学生')
        return
      }
      const ext = format === 'xlsx' ? 'xlsx' : 'pdf'
      this.download(
        'spas/report/student/' + this.queryParams.studentId,
        { subjectId: this.queryParams.subjectId, format: ext },
        `student_report_${this.queryParams.studentId}_${new Date().getTime()}.${ext}`
      )
    },
    goInterveneList() {
      this.$router.push({ path: '/spas/intervene', query: { studentId: this.queryParams.studentId, status: '' } })
    },
    goWarning(row) {
      const query = { studentId: this.queryParams.studentId }
      if (row && row.warningId) query.warningId = row.warningId
      this.$router.push({ path: '/spas/warning/record', query })
    },
    onKnowledgeRow(row) {
      this.goAnalysis(row && row.knowledgeId ? { knowledgeId: row.knowledgeId } : null)
    },
    onRadarClick(params) {
      const idx = params && (params.dataIndex != null ? params.dataIndex : params.event && params.event.dataIndex)
      const row = this.radarData[idx]
      if (row && row.knowledgeId) {
        this.goAnalysis({ knowledgeId: row.knowledgeId })
        return
      }
      this.goAnalysis()
    },
    deltaText(v) {
      if (v == null || v === '') return '-'
      const n = Number(v)
      if (Number.isNaN(n)) return '-'
      if (n > 0) return '进步 ' + n
      if (n < 0) return '退步 ' + Math.abs(n)
      return '持平'
    },
    vsTotalText(row) {
      if (!row || row.vsTotal == null || row.vsTotal === '') return '-'
      const n = Number(row.vsTotal)
      if (Number.isNaN(n)) return '-'
      const label = row.biasLabel ? ' ' + row.biasLabel : ''
      if (n > 0) return '落后 ' + n + label
      if (n < 0) return '领先 ' + Math.abs(n) + label
      return '持平'
    },
    rankColor(trend) {
      if (trend === 'up') return '#16a34a'
      if (trend === 'down') return '#dc2626'
      return '#64748b'
    },
    rankTag(trend) {
      if (trend === 'up') return 'success'
      if (trend === 'down') return 'danger'
      return 'info'
    },
    formatStudentLabel(item) {
      const no = item.studentNo || ''
      const name = item.studentName || ''
      return no ? (no + ' · ' + name) : name
    },
    unwrapList(val) {
      if (!val) return []
      if (Array.isArray(val)) return val
      return []
    },
    loadSubjects() {
      return optionselectSubject().then(res => {
        this.subjectOptions = res.data || []
      })
    },
    loadDepts() {
      if (!canLoadSystemDeptTree()) {
        this.deptOptions = []
        return Promise.resolve()
      }
      return deptTreeSelect().then(res => {
        this.deptOptions = res.data || []
      }).catch(() => {
        this.deptOptions = []
      })
    },
    loadMyDepts() {
      return applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).catch(() => {
        this.myDepts = []
      })
    },
    loadStudents(keyword) {
      const params = {
        pageNum: 1,
        pageSize: this.queryParams.deptId ? 200 : 50,
        status: '0'
      }
      if (this.queryParams.deptId) params.deptId = this.queryParams.deptId
      if (keyword) {
        if (/^\d/.test(String(keyword))) {
          params.studentNo = keyword
        } else {
          params.studentName = keyword
        }
      }
      this.studentLoading = true
      return listStudent(params).then(res => {
        this.studentOptions = res.rows || res.data || []
        if (res.total > params.pageSize && !keyword && this.queryParams.deptId) {
          this.$modal.msgWarning('当前班级学生超过 ' + params.pageSize + ' 人，请使用搜索定位')
        }
      }).catch(() => {
        this.studentOptions = []
      }).finally(() => {
        this.studentLoading = false
      })
    },
    handleDeptChange() {
      this.selectMyDept(this.queryParams.deptId)
    },
    goAnalysis(extra) {
      if (!this.queryParams.studentId) {
        return
      }
      const query = { studentId: this.queryParams.studentId }
      if (this.queryParams.subjectId) {
        query.subjectId = this.queryParams.subjectId
      }
      if (this.queryParams.deptId) {
        query.deptId = this.queryParams.deptId
      }
      if (extra && typeof extra === 'object' && extra.knowledgeId) {
        query.knowledgeId = extra.knowledgeId
      }
      this.$router.push({ path: '/spas/analysis/student', query })
    },
    loadPortfolio() {
      if (!this.queryParams.studentId) {
        this.$modal.msgWarning('请先选择学生')
        return
      }
      this.loading = true
      getPortfolio(this.queryParams.studentId, { subjectId: this.queryParams.subjectId }).then(res => {
        const data = res.data || {}
        this.portfolio = data
        this.summary = data.summary || {}
        this.interveneTimeline = this.unwrapList(data.interveneTimeline)
        this.weakList = this.unwrapList(data.weakTop)
        this.persistentWeak = this.unwrapList(data.persistentWeak)
        this.errorCauseSummary = this.unwrapList(data.errorCauseSummary)
        this.openWarnings = this.unwrapList(data.openWarnings)
        this.coachLogs = this.unwrapList(data.coachLogs)
        const examRank = data.examRank || {}
        this.rankSubjects = this.unwrapList(examRank.subjects)
        this.rankSummary = examRank.summary || {}
        this.buildRadar(this.unwrapList(data.radar))
        this.buildTrend(this.unwrapList(data.trend))
      }).catch(() => {
        this.$modal.msgError('加载一生一册失败')
        this.portfolio = {}
        this.summary = {}
        this.interveneTimeline = []
        this.weakList = []
        this.persistentWeak = []
        this.errorCauseSummary = []
        this.openWarnings = []
        this.coachLogs = []
        this.rankSubjects = []
        this.rankSummary = {}
        this.radarData = []
        this.radarOption = {}
        this.trendOption = {}
      }).finally(() => {
        this.loading = false
      })
    },
    buildRadar(list) {
      this.radarData = list || []
      if (!list.length) {
        this.radarOption = { title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } } }
        return
      }
      const values = list.map(i => this.toPercent(i.rate != null ? i.rate : i.weightedRate))
      const classValues = list.map(i => {
        if (i.classAvgRate == null && i.classRate == null) return null
        return this.toPercent(i.classAvgRate != null ? i.classAvgRate : i.classRate)
      })
      const hasClass = classValues.some(v => v != null)
      const seriesData = [{ value: values, name: '本人' }]
      if (hasClass) {
        seriesData.push({ value: classValues.map(v => (v == null ? 0 : v)), name: '班级均值', lineStyle: { type: 'dashed' }, areaStyle: { opacity: 0.08 } })
      }
      this.radarOption = {
        color: ['#2442ED', '#94A3B8'],
        tooltip: {},
        legend: hasClass ? { data: ['本人', '班级均值'], bottom: 0 } : undefined,
        radar: { indicator: list.map(i => ({ name: i.name || i.knowledgeName || '-', max: 100 })), radius: '62%', center: ['50%', '48%'] },
        series: [{ type: 'radar', areaStyle: { opacity: 0.25 }, data: seriesData }]
      }
    },
    buildTrend(list) {
      if (!list.length) {
        this.trendOption = { title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } } }
        return
      }
      const sorted = list.slice().sort((a, b) => String(a.examDate || '').localeCompare(String(b.examDate || '')))
      const classData = sorted.map(i => i.classAvgRate == null ? null : this.toPercent(i.classAvgRate))
      const hasClass = classData.some(v => v != null)
      const series = [{
        name: '本人',
        type: 'line',
        smooth: true,
        data: sorted.map(i => this.toPercent(i.totalRate != null ? i.totalRate : i.avgRate != null ? i.avgRate : i.rate)),
        itemStyle: { color: '#2442ED' },
        lineStyle: { color: '#2442ED' },
        areaStyle: { opacity: 0.12, color: 'rgba(36, 66, 237, 0.18)' },
        markLine: { silent: true, data: [{ yAxis: 60, name: '60%' }] }
      }]
      if (hasClass) {
        series.push({
          name: '班级均分',
          type: 'line',
          smooth: true,
          data: classData,
          itemStyle: { color: '#94A3B8' },
          lineStyle: { color: '#94A3B8', type: 'dashed' }
        })
      }
      this.trendOption = {
        tooltip: { trigger: 'axis' },
        legend: hasClass ? { data: ['本人', '班级均分'], bottom: 0 } : undefined,
        grid: { left: '3%', right: '4%', bottom: hasClass ? 36 : 8, top: 30, containLabel: true },
        xAxis: { type: 'category', data: sorted.map(i => i.paperName || i.name || '-') },
        yAxis: { type: 'value', name: '%', min: 0, max: 100 },
        series
      }
    },
    openCoach() {
      this.coachForm = {
        studentId: this.queryParams.studentId,
        content: undefined,
        nextPlan: undefined,
        interveneId: undefined,
        warningId: undefined,
        knowledgeId: undefined
      }
      this.coachOpen = true
    },
    coachLinkText(item) {
      if (!item) return ''
      const parts = []
      if (item.interveneId) parts.push('干预#' + item.interveneId)
      if (item.warningId) parts.push('预警#' + item.warningId)
      if (item.knowledgeId) {
        const kp = (this.knowledgeOptions || []).find(k => k.knowledgeId === item.knowledgeId)
        parts.push(kp ? ('知识点：' + kp.name) : ('知识点#' + item.knowledgeId))
      }
      return parts.length ? ('关联：' + parts.join(' · ')) : ''
    },
    submitCoach() {
      this.$refs['coachForm'].validate(valid => {
        if (!valid) return
        const payload = Object.assign({}, this.coachForm)
        if (!payload.interveneId) delete payload.interveneId
        if (!payload.warningId) delete payload.warningId
        if (!payload.knowledgeId) delete payload.knowledgeId
        addCoachLog(payload).then(() => {
          this.$modal.msgSuccess('已保存')
          this.coachOpen = false
          this.loadPortfolio()
        })
      })
    }
  }
}
</script>

<style scoped>
.class-filter-panel {
  background: #fff;
  border: 1px solid #E8EDF5;
  border-radius: 12px;
  padding: 14px 16px 12px;
  margin-bottom: 14px;
  box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
}
.filter-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
  margin-bottom: 12px;
}
.filter-toolbar-left {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
}
.filter-select {
  width: 148px;
}
.exam-search {
  display: inline-flex;
  align-items: stretch;
  min-width: 240px;
  max-width: 320px;
  flex: 1;
}
.exam-search >>> .el-input__inner {
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
}
.exam-search-btn {
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
  padding: 0 14px;
  background: #13C2C2;
  border-color: #13C2C2;
}
.exam-search-btn:hover,
.exam-search-btn:focus {
  background: #36CFC9;
  border-color: #36CFC9;
}
.filter-tag-rows {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding-top: 2px;
}
.filter-tag-row {
  display: flex;
  align-items: flex-start;
  gap: 10px;
}
.filter-tag-label {
  flex: 0 0 42px;
  line-height: 28px;
  color: #64748B;
  font-size: 13px;
  text-align: right;
}
.filter-tag-list {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 6px 4px;
  min-width: 0;
  flex: 1;
}
.filter-chip {
  appearance: none;
  border: none;
  background: transparent;
  color: #475569;
  font-size: 13px;
  line-height: 28px;
  padding: 0 12px;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.15s ease, color 0.15s ease;
}
.filter-chip:hover {
  color: #0F766E;
  background: rgba(19, 194, 194, 0.08);
}
.filter-chip.active {
  background: #13C2C2;
  color: #fff;
  font-weight: 500;
}
.filter-more {
  appearance: none;
  border: none;
  background: transparent;
  color: #13C2C2;
  font-size: 13px;
  line-height: 28px;
  padding: 0 8px;
  cursor: pointer;
}
.filter-more:hover {
  color: #0F766E;
}
.filter-treeselect {
  width: 240px;
  margin-left: 4px;
}
.filter-actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  margin-top: 12px;
  padding-top: 10px;
  border-top: 1px dashed #E8EDF5;
}
.student-roster-panel {
  margin-top: 4px;
  background: #fff;
  border: 1px solid #E8EDF5;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
  padding: 16px 16px 18px;
  min-height: 220px;
}
.roster-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 14px;
  padding-bottom: 12px;
  border-bottom: 1px solid #EEF2F7;
}
.roster-title {
  font-size: 16px;
  font-weight: 700;
  color: #0F172A;
  line-height: 1.3;
}
.roster-sub {
  margin-top: 4px;
  font-size: 12px;
  color: #94A3B8;
}
.roster-meta {
  display: flex;
  align-items: baseline;
  gap: 4px;
  flex-shrink: 0;
}
.roster-count {
  font-size: 28px;
  font-weight: 700;
  color: #0F766E;
  font-variant-numeric: tabular-nums;
  line-height: 1;
}
.roster-count-label {
  font-size: 12px;
  color: #64748B;
}
.roster-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 10px;
  max-height: min(62vh, 560px);
  overflow: auto;
  padding-right: 2px;
}
.roster-tile {
  appearance: none;
  width: 100%;
  display: flex;
  align-items: center;
  gap: 12px;
  text-align: left;
  padding: 12px 12px 12px 10px;
  border: 1px solid #E8EDF5;
  border-radius: 10px;
  background: linear-gradient(180deg, #FFFFFF 0%, #F8FAFC 100%);
  cursor: pointer;
  transition: border-color 0.15s ease, box-shadow 0.15s ease, transform 0.15s ease;
}
.roster-tile:hover {
  border-color: #99E6E6;
  box-shadow: 0 6px 16px rgba(15, 23, 42, 0.06);
  transform: translateY(-1px);
}
.roster-tile:hover .roster-action {
  color: #0F766E;
  opacity: 1;
}
.roster-tile.is-inactive {
  opacity: 0.72;
}
.roster-avatar {
  flex: 0 0 40px;
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 15px;
  font-weight: 700;
  color: #fff;
  letter-spacing: 0.02em;
}
.roster-avatar.tone-teal { background: #14B8A6; }
.roster-avatar.tone-blue { background: #3B82F6; }
.roster-avatar.tone-amber { background: #F59E0B; }
.roster-avatar.tone-rose { background: #F43F5E; }
.roster-avatar.tone-slate { background: #64748B; }
.roster-body {
  min-width: 0;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 3px;
}
.roster-name-row {
  display: flex;
  align-items: center;
  gap: 6px;
  min-width: 0;
}
.roster-name {
  font-size: 14px;
  font-weight: 700;
  color: #0F172A;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.roster-sex {
  flex-shrink: 0;
  font-size: 11px;
  color: #64748B;
  background: #F1F5F9;
  border-radius: 999px;
  padding: 0 7px;
  line-height: 18px;
}
.roster-no {
  font-size: 12px;
  color: #94A3B8;
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.roster-action {
  flex-shrink: 0;
  font-size: 12px;
  font-weight: 600;
  color: #94A3B8;
  opacity: 0.85;
  display: inline-flex;
  align-items: center;
  gap: 2px;
}
@media (max-width: 768px) {
  .roster-grid {
    grid-template-columns: 1fr;
    max-height: none;
  }
  .roster-header {
    flex-direction: column;
    align-items: flex-start;
  }
}
.card-header-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
.card-hint {
  margin-left: 8px;
  color: #94a3b8;
  font-size: 12px;
  font-weight: normal;
}
.mb8 {
  margin-bottom: 8px;
}
.spas-portfolio .el-timeline-item__content p {
  margin: 0 0 4px;
  color: #334155;
  line-height: 1.55;
  font-size: 13px;
}
.spas-portfolio .coach-link,
.spas-portfolio .next-plan {
  color: #64748b;
  font-size: 12px;
}
.spas-portfolio .el-table {
  cursor: default;
}
.empty-actions {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 8px;
}
</style>

