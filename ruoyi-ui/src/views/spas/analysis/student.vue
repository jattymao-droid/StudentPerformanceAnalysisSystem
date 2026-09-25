<template>
  <div class="app-container spas-analysis">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
      <el-form-item label="班级" prop="deptId" class="class-row">
        <template v-if="boundClassMode">
          <div class="bound-class-wrap">
            <span class="bound-class-name">{{ currentDeptName || '未绑定班级' }}</span>
            <el-tag v-if="boundClassRoleLabel" size="mini" type="info">{{ boundClassRoleLabel }}</el-tag>
            <el-button-group v-if="myDepts.length > 1" class="bound-class-switch">
              <el-button
                v-for="d in myDepts"
                :key="d.deptId"
                size="mini"
                :type="queryParams.deptId === d.deptId ? 'primary' : 'default'"
                @click="selectMyDept(d.deptId)"
              >{{ d.deptName }}{{ d.primary ? '·主' : '' }}</el-button>
            </el-button-group>
          </div>
        </template>
        <treeselect
          v-else
          v-model="queryParams.deptId"
          :options="deptOptions"
          :show-count="true"
          placeholder="筛选班级"
          style="width: 220px"
          @input="handleDeptChange"
        />
      </el-form-item>
      <el-form-item label="学科" prop="subjectId">
        <el-select
          v-model="queryParams.subjectId"
          placeholder="请选择学科"
          filterable
          style="width: 180px"
          @change="handleSubjectChange"
        >
          <el-option label="所有科目" :value="0" />
          <el-option
            v-for="item in subjectOptions"
            :key="item.subjectId"
            :label="item.subjectName"
            :value="item.subjectId"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="学生" prop="studentId">
        <el-select
          v-model="queryParams.studentId"
          placeholder="输入学号/姓名搜索"
          filterable
          remote
          clearable
          :remote-method="remoteStudent"
          :loading="studentLoading"
          style="width: 240px"
        >
          <el-option
            v-for="item in studentOptions"
            :key="item.studentId"
            :label="formatStudentLabel(item)"
            :value="item.studentId"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['spas:analysis:student']">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        <el-button type="text" size="mini" icon="el-icon-setting" @click="showAdvancedScope = !showAdvancedScope">
          {{ showAdvancedScope ? '收起口径' : '高级口径' }}
        </el-button>
        <el-button type="warning" plain icon="el-icon-refresh-right" size="mini" :loading="recalcLoading" :disabled="!queryParams.studentId" @click="handleRecalc" v-hasPermi="['spas:analysis:student']">重新计算</el-button>
        <el-button type="success" plain icon="el-icon-notebook-2" size="mini" :disabled="!queryParams.studentId" @click="goPortfolio" v-hasPermi="['spas:portfolio:list']">一生一册</el-button>
        <el-button type="success" plain icon="el-icon-view" size="mini" :disabled="!queryParams.studentId" :loading="previewLoading" @click="openReportPreview" v-hasPermi="['spas:report:export']">预览报告</el-button>
        <el-button type="warning" plain icon="el-icon-download" size="mini" :disabled="!queryParams.studentId" :loading="exportLoading" @click="handleExportReport('pdf')" v-hasPermi="['spas:report:export']">导出报告</el-button>
        <el-button type="info" plain icon="el-icon-document" size="mini" :disabled="!queryParams.studentId" :loading="exportLoading" @click="handleExportReport('xlsx')" v-hasPermi="['spas:report:export']">导出明细</el-button>
      </el-form-item>
      <template v-if="showAdvancedScope">
        <el-form-item label="模式" prop="analysisMode">
          <el-radio-group v-model="analysisMode" size="mini" @change="onModeChange">
            <el-radio-button label="window">时间窗</el-radio-button>
            <el-radio-button label="papers">选卷诊断</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="analysisMode === 'window'" label="时间窗" prop="window">
          <el-select v-model="queryParams.window" style="width: 160px" @change="handleQuery">
            <el-option label="本学期(默认)" value="semester" />
            <el-option label="上学期" value="prev_semester" />
            <el-option label="近30天" value="last30d" />
            <el-option label="近90天" value="last90d" />
            <el-option label="全部(快照)" value="all" />
          </el-select>
          <div v-if="prevSemesterLabel" class="stat-hint" style="margin-top:4px;line-height:1.3">上学期窗：{{ prevSemesterLabel }}</div>
        </el-form-item>
        <el-form-item v-else label="考试集合" prop="paperIds">
          <el-select v-model="queryParams.paperIds" multiple filterable collapse-tags clearable placeholder="勾选多场已发布试卷" style="width: 320px">
            <el-option v-for="item in paperOptions" :key="item.paperId" :label="paperLabel(item)" :value="item.paperId" />
          </el-select>
        </el-form-item>
        <el-form-item label="近因">
          <el-switch v-model="useRecency" active-text="衰减" inactive-text="关闭" />
        </el-form-item>
      </template>
    </el-form>

<el-empty v-if="!queryParams.studentId" description="请选择学生后查看学情分析">
      <div class="empty-actions">
        <el-button size="mini" type="primary" @click="$router.push('/spas/base/student')">去学生档案选人</el-button>
        <el-button size="mini" @click="$router.push('/spas/analysis/class')">从班级分析进入</el-button>
      </div>
    </el-empty>

    <template v-else>
      <el-alert
        :title="scopeBanner"
        type="success"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-alert
        v-if="summary.headline"
        :title="summary.headline"
        :type="summary.emptyKnowledge ? 'warning' : 'info'"
        :closable="false"
        show-icon
        class="mb8"
      >
        <template v-if="summary.emptyKnowledge && suggestedSubjects.length" slot="default">
          <span style="margin-right:6px">可切换到：</span>
          <el-tag
            v-for="s in suggestedSubjects"
            :key="'sug-' + s.subjectId"
            size="small"
            type="warning"
            effect="plain"
            style="margin:2px 4px;cursor:pointer"
            @click="switchToSubject(s.subjectId)"
          >{{ s.subjectName }}</el-tag>
        </template>
      </el-alert>
      <el-alert
        v-if="subjectOverrideTip"
        type="info"
        :closable="false"
        show-icon
        class="mb8"
        :title="subjectOverrideTip"
      />
      <el-alert
        v-if="summary.formalWeakBlocked"
        type="error"
        :closable="false"
        show-icon
        class="mb8"
        :title="summary.formalWeakBlockReason || '当前口径内标注不足，薄弱结论仅供参考，不得作为正式定级'"
      />
      <el-alert
        v-if="analysisMode === 'papers'"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
        :title="'当前为选卷诊断 · ' + (queryParams.paperIds || []).length + ' 场考试；薄弱结论仅基于所选试卷集合（加权引擎即时聚合）'"
      />
      <el-alert
        v-if="analysisMode === 'papers' && scopeCompareTitle"
        type="info"
        :closable="false"
        show-icon
        class="mb8"
        :title="scopeCompareTitle"
      />
      <el-alert
        v-if="annotationHint"
        type="error"
        :closable="false"
        show-icon
        class="mb8"
        :title="annotationHint"
      />
      <el-alert
        v-if="summary && summary.coverageAdjusted"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
        :title="'标注覆盖率偏低（未标注占比 ' + formatPct(summary.unboundRatio) + '），置信度已自动降级'"
      />
      <el-alert
        v-if="lowConfidenceCount > 0"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
        :title="'列表中有 ' + lowConfidenceCount + ' 项为「证据不足」（样本不足），不定正式薄弱；仅 formalWeak 可作定级依据。'"
      />
      <el-row :gutter="12" class="overview-row" v-loading="loading">
        <el-col :xs="12" :sm="8" :md="4" v-for="card in summaryCards" :key="card.key">
          <div class="stat-card" :class="'tone-' + card.tone">
            <div class="stat-label">{{ card.label }}</div>
            <div class="stat-value">{{ card.value }}</div>
            <div class="stat-hint" v-if="card.hint">{{ card.hint }}</div>
          </div>
        </el-col>
      </el-row>

      <el-card v-if="isAllSubjects && subjectBreakdown.length" shadow="never" style="margin-top: 12px" v-loading="loading">
        <div slot="header" class="card-header">分科得分概览（所有科目）</div>
        <el-table :data="subjectBreakdown" size="mini" empty-text="暂无分科数据">
          <el-table-column label="学科" min-width="100" prop="subjectName" :show-overflow-tooltip="true" />
          <el-table-column label="综合得分率" width="110" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.overallRate) }}</template>
          </el-table-column>
          <el-table-column label="班均" width="100" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.classAvgRate) }}</template>
          </el-table-column>
          <el-table-column label="与班差" width="100" align="center">
            <template slot-scope="scope">{{ formatGap(scope.row.gap) }}</template>
          </el-table-column>
          <el-table-column label="正式薄弱" width="90" align="center" prop="weakCount" />
          <el-table-column label="正式严重" width="90" align="center" prop="severeCount" />
          <el-table-column label="作答题数" width="90" align="center" prop="totalAttempts" />
          <el-table-column label="操作" width="90" align="center">
            <template slot-scope="scope">
              <el-button type="text" size="mini" @click="switchToSubject(scope.row.subjectId)">看单科</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never" class="chart-card" style="margin-top: 16px" v-loading="rankLoading">
        <div slot="header" class="card-header" style="display:flex;justify-content:space-between;align-items:center">
          <span>实考校次进退</span>
          <el-button
            type="warning"
            plain
            size="mini"
            icon="el-icon-download"
            :disabled="!queryParams.studentId"
            :loading="rankExporting"
            @click="exportRankTrend"
          >导出 PDF</el-button>
        </div>
        <el-alert
          class="mb8"
          type="info"
          :closable="false"
          show-icon
          :title="'与上方学情同一口径筛选（学科/时间窗或选卷）；校次来自实考导入，掌握度来自小题成绩。'"
        />
        <el-alert
          v-if="rankSummary && rankSummary.headline"
          class="mb8"
          type="info"
          :closable="false"
          show-icon
          :title="rankSummary.headline"
        />
        <el-alert
          v-if="rankSummary && rankSummary.crossHeadline"
          class="mb8"
          type="warning"
          :closable="false"
          show-icon
          :title="'交叉诊断：' + rankSummary.crossHeadline"
        />
        <el-table :data="rankSubjects" size="small" empty-text="暂无实考校次。请先在「实考校次」导入多次成绩。">
          <el-table-column label="科目" prop="subjectName" width="90" fixed />
          <el-table-column label="校次轨迹" prop="track" min-width="180" :show-overflow-tooltip="true" />
          <el-table-column label="最近校次" prop="latestRank" width="90" align="center">
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
          <el-table-column label="较首次" width="100" align="center">
            <template slot-scope="scope">
              <span :style="{ color: rankColor(scope.row.overallDelta > 0 ? 'up' : (scope.row.overallDelta < 0 ? 'down' : 'flat')) }">{{ deltaText(scope.row.overallDelta) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="结论" width="90" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="rankTag(scope.row.trend)">{{ scope.row.trendLabel }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="关联掌握" align="center" width="110">
            <template slot-scope="scope">
              <span v-if="scope.row.boundMasteryRate != null">{{ formatRate(scope.row.boundMasteryRate) }}</span>
              <span v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column label="交叉诊断" width="160" align="center">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.crossLabel && scope.row.crossLabel !== '-'" size="mini" :type="crossTagType(scope.row.crossCode)">{{ scope.row.crossLabel }}</el-tag>
              <span v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column label="薄弱解释" min-width="220" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.explain || '-' }}</template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-row :gutter="16" v-loading="loading" style="margin-top: 8px">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">知识点掌握雷达（本人 vs 班级）</div>
            <spas-chart :option="radarOption" height="360px" />
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">成绩趋势（本人 vs 班级）</div>
            <spas-chart :option="trendOption" height="360px" />
          </el-card>
        </el-col>
      </el-row>

      <el-row :gutter="16" style="margin-top: 16px" v-loading="loading">
        <el-col :span="24">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">薄弱知识点 Top（点击柱图可下钻题目或发起干预）</div>
            <spas-chart :option="weakBarOption" height="320px" @chart-click="onWeakBarClick" />
          </el-card>
      <el-card shadow="never" style="margin-top: 16px" class="chart-card chapter-radar-card">
        <div slot="header" class="card-header">章节汇总</div>

        <el-alert class="mb8 chapter-formula-tip" type="info" :closable="false" show-icon
          title="章节得分率 = attempt-weighted avg(leaf weighted_rate)" />
        <spas-chart :option="chapterRadarOption" height="320px" />
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" class="chart-card">
        <div slot="header" class="card-header">
          题型表现
          <span v-if="questionTypeSummary.coverageRate != null" class="card-sub">覆盖率 {{ formatPct(questionTypeSummary.coverageRate) }} · 未标注 {{ questionTypeSummary.unlabeledCount != null ? questionTypeSummary.unlabeledCount : 0 }}</span>
        </div>
        <el-alert
          class="mb8"
          type="info"
          :closable="false"
          show-icon
          title="题型得分率 = 该题型下 sum(得分)/sum(满分)（卷面得分池），与知识点加权掌握度不同口径，勿直接对比雷达图"
        />
        <el-alert
          v-if="questionTypeSummary.coverageRate != null && Number(questionTypeSummary.coverageRate) < 0.6"
          class="mb8"
          type="warning"
          :closable="false"
          show-icon
          title="题型标注覆盖率偏低，结论仅供参考，请在试卷编辑中补全题型"
        />
        <el-table :data="questionTypeItems" size="mini" empty-text="暂无题型数据">
          <el-table-column label="题型" min-width="120" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.typeName || scope.row.typeCode || '-' }}</template>
          </el-table-column>
          <el-table-column label="题量" prop="questionCount" width="80" align="center" />
          <el-table-column label="作答次数" prop="attemptCount" width="90" align="center" />
          <el-table-column label="得分率" width="100" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
          </el-table-column>
          <el-table-column label="置信度" width="100" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="confidenceTagType(scope.row)">{{ confidenceText(scope.row) }}</el-tag>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" class="chart-card">
        <div slot="header" class="card-header">
          能力层级
          <span v-if="bloomSummary.coverageRate != null" class="card-sub">覆盖率 {{ formatPct(bloomSummary.coverageRate) }} · 未标注 {{ bloomSummary.unlabeledCount != null ? bloomSummary.unlabeledCount : 0 }}</span>
        </div>
        <el-alert
          class="mb8"
          type="info"
          :closable="false"
          show-icon
          title="能力层级得分率 = 该 Bloom 层级下 sum(得分)/sum(满分)（卷面得分池），非知识点加权掌握度"
        />
        <el-alert
          v-if="bloomSummary.coverageRate != null && Number(bloomSummary.coverageRate) < 0.6"
          class="mb8"
          type="warning"
          :closable="false"
          show-icon
          title="认知层级标注覆盖率偏低，请在试卷编辑中为题目选择能力层级"
        />
        <el-alert v-if="bloomInsight" class="mb8" type="info" :closable="false" show-icon :title="bloomInsight" />
        <el-table :data="bloomItems" size="mini" empty-text="暂无能力层级数据">
          <el-table-column label="层级" min-width="120" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.bloomLabel || scope.row.bloomLevel || '-' }}</template>
          </el-table-column>
          <el-table-column label="题量" prop="questionCount" width="80" align="center" />
          <el-table-column label="作答次数" prop="attemptCount" width="90" align="center" />
          <el-table-column label="得分率" width="100" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
          </el-table-column>
          <el-table-column label="置信度" width="100" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="confidenceTagType(scope.row)">{{ confidenceText(scope.row) }}</el-tag>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card ref="chapterDeltaCard" shadow="never" style="margin-top: 16px" class="chart-card" id="spas-chapter-delta">
        <div slot="header" class="card-header">章节进退</div>
        <el-alert v-if="chapterDelta.baselineHint" class="mb8" :type="chapterDelta.baselineEmpty ? 'warning' : 'info'" :closable="false" show-icon :title="chapterDelta.baselineHint" />
        <el-alert v-else-if="chapterDelta.headline" class="mb8" type="info" :closable="false" show-icon :title="chapterDelta.headline" />
        <el-row :gutter="12">
          <el-col :xs="24" :md="12">
            <div class="card-header mb8">进步 Top</div>
            <el-table :data="chapterDelta.improved || []" size="mini" empty-text="暂无进步章节">
              <el-table-column label="章节" min-width="120" :show-overflow-tooltip="true">
                <template slot-scope="scope">{{ scope.row.chapterName || scope.row.name || '-' }}</template>
              </el-table-column>
              <el-table-column label="近窗" width="90" align="center">
                <template slot-scope="scope">{{ formatRate(scope.row.recentRate) }}</template>
              </el-table-column>
              <el-table-column label="基线" width="90" align="center">
                <template slot-scope="scope">{{ formatRate(scope.row.baselineRate) }}</template>
              </el-table-column>
              <el-table-column label="变化" width="90" align="center">
                <template slot-scope="scope">
                  <span style="color:#16a34a">{{ formatGap(scope.row.deltaRate) }}</span>
                </template>
              </el-table-column>
            </el-table>
          </el-col>
          <el-col :xs="24" :md="12">
            <div class="card-header mb8">退步 Top</div>
            <el-table :data="chapterDelta.declined || []" size="mini" empty-text="暂无退步章节">
              <el-table-column label="章节" min-width="120" :show-overflow-tooltip="true">
                <template slot-scope="scope">{{ scope.row.chapterName || scope.row.name || '-' }}</template>
              </el-table-column>
              <el-table-column label="近窗" width="90" align="center">
                <template slot-scope="scope">{{ formatRate(scope.row.recentRate) }}</template>
              </el-table-column>
              <el-table-column label="基线" width="90" align="center">
                <template slot-scope="scope">{{ formatRate(scope.row.baselineRate) }}</template>
              </el-table-column>
              <el-table-column label="变化" width="90" align="center">
                <template slot-scope="scope">
                  <span style="color:#dc2626">{{ formatGap(scope.row.deltaRate) }}</span>
                </template>
              </el-table-column>
            </el-table>
          </el-col>
        </el-row>
      </el-card>

        </el-col>
      </el-row>

      <el-card shadow="never" style="margin-top: 16px">
        <div slot="header" class="card-header">薄弱知识点明细</div>
        <el-table :data="weakList" v-loading="loading" empty-text="暂无薄弱知识点数据">
          <el-table-column label="知识点" align="center" prop="name" min-width="160" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span>{{ scope.row.name || scope.row.knowledgeName }}</span>
            </template>
          </el-table-column>
          <el-table-column label="加权得分率" align="center" min-width="110">
            <template slot-scope="scope">
              <span>{{ formatRate(scope.row.rate != null ? scope.row.rate : scope.row.weightedRate) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="班级均分" align="center" width="100">
            <template slot-scope="scope">{{ formatRate(scope.row.classAvgRate) }}</template>
          </el-table-column>
          <el-table-column label="与班差" align="center" width="100">
            <template slot-scope="scope">
              <span :style="{ color: gapColor(scope.row.gap) }">{{ formatGap(scope.row.gap) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="练习次数" align="center" prop="attemptCount" width="90">
            <template slot-scope="scope">
              <span>{{ scope.row.attemptCount != null ? scope.row.attemptCount : '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="置信度" align="center" width="110">
            <template slot-scope="scope">
              <el-tag size="mini" :type="confidenceTagType(scope.row)">{{ confidenceText(scope.row) }}</el-tag>
              <el-tag v-if="rowFormalWeak(scope.row)" size="mini" type="danger" style="margin-left:4px">正式薄弱</el-tag>
              <el-tag v-else-if="rowLowEvidence(scope.row)" size="mini" type="info" style="margin-left:4px">证据不足</el-tag>
              <el-tag v-if="scope.row.relativeWeak" size="mini" type="warning" style="margin-left:4px">低于班均</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="跨场标签" align="center" width="110">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.persistTag" size="mini" :type="persistTagType(scope.row.persistTag)">{{ scope.row.persistTag }}</el-tag>
              <span v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column label="薄弱等级" align="center" width="110">
            <template slot-scope="scope">
              <dict-tag :options="dict.type.spas_weak_level" :value="scope.row.weakLevel" />
            </template>
          </el-table-column>
          <el-table-column label="干预效果" align="center" width="130">
            <template slot-scope="scope">
              <el-tag v-if="interveneLabel(scope.row)" size="mini" :type="interveneTagType(scope.row)" style="cursor:pointer" @click="goInterveneTask(scope.row)">{{ interveneLabel(scope.row) }}</el-tag>
              <span v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column label="根因提示" align="center" min-width="160" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span v-if="scope.row.rootHint">{{ scope.row.rootHint }}</span>
              <span v-else-if="scope.row.dependencyHints && scope.row.dependencyHints.length">{{ formatDependencyHints(scope.row.dependencyHints) }}</span>
              <span v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="200">
            <template slot-scope="scope">
              <el-button size="mini" type="text" icon="el-icon-data-line" @click="openKnowledgeTrend(scope.row)">趋势</el-button>
              <el-button size="mini" type="text" icon="el-icon-view" @click="openKnowledgeDrill(scope.row)">题目</el-button>
              <el-button
                size="mini"
                type="text"
                icon="el-icon-s-flag"
                @click="startIntervene(scope.row)"
                v-hasPermi="['spas:intervene:add']"
              >干预</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </template>

    <el-drawer :title="drillTitle" :visible.sync="drillOpen" size="720px" append-to-body>
      <div style="padding: 0 16px 16px">
        <div v-if="trendPoints.length" class="card-header mb8">各场考试得分率</div>
        <spas-chart v-if="trendPoints.length" :option="knowledgeTrendOption" height="220px" />
        <div class="card-header mb8" style="margin-top:12px">题目明细</div>
        <el-alert class="mb8" type="info" :closable="false" show-icon
          title="错因打标：仅对得分率显著偏低的题打标；四级分类见字典。未标注不进入一生一册错因汇总（无作答过程数据）。" />
        <el-table v-loading="drillLoading" :data="drillRows" empty-text="暂无题目明细">
          <el-table-column label="试卷" prop="paperName" min-width="110" :show-overflow-tooltip="true" />
          <el-table-column label="题号" prop="questionNo" width="70" align="center" />
          <el-table-column label="本题知识点" min-width="160" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.knowledgeBindings || scope.row.knowledgeName || '-' }}</template>
          </el-table-column>
          <el-table-column label="本点权重" width="80" align="center">
            <template slot-scope="scope">{{ formatWeight(scope.row.weight) }}</template>
          </el-table-column>
          <el-table-column label="分摊得分率" width="100" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.attributedRate) }}</template>
          </el-table-column>
          <el-table-column label="得分" width="70" align="center">
            <template slot-scope="scope">{{ scope.row.score != null ? scope.row.score : '-' }}</template>
          </el-table-column>
          <el-table-column label="得分率" width="80" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.rate) }}</template>
          </el-table-column>
          <el-table-column label="错因" width="200" align="center">
            <template slot-scope="scope">
              <div v-if="isLowRateRow(scope.row)" class="error-quick-tags mb4">
                <el-button
                  v-for="chip in quickErrorChips"
                  :key="chip.code"
                  size="mini"
                  :type="scope.row.errorCode === chip.code ? 'primary' : 'default'"
                  plain
                  :disabled="!checkPermi(['spas:analysis:student'])"
                  @click="quickErrorTag(scope.row, chip.code)"
                >{{ chip.label }}</el-button>
              </div>
              <el-select
                v-model="scope.row.errorCode"
                size="mini"
                clearable
                placeholder="未标注"
                :disabled="!checkPermi(['spas:analysis:student'])"
                @change="onErrorTagChange(scope.row)"
              >
                <template v-if="errorCauseGroups.length">
                  <el-option-group
                    v-for="group in errorCauseGroups"
                    :key="group.value"
                    :label="group.label"
                  >
                    <el-option
                      v-for="dict in group.options"
                      :key="dict.value"
                      :label="dict.label"
                      :value="dict.value"
                    />
                  </el-option-group>
                </template>
                <template v-else>
                  <el-option
                    v-for="dict in dict.type.spas_error_cause"
                    :key="dict.value"
                    :label="dict.label"
                    :value="dict.value"
                  />
                </template>
              </el-select>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-drawer>

    <el-drawer title="学情报告预览" :visible.sync="previewOpen" size="560px" append-to-body>
      <div v-loading="previewLoading" style="padding: 0 16px 16px">
        <p v-if="previewData.generatedAt" style="color:#64748B;margin:0 0 12px">生成时间：{{ previewData.generatedAt }}</p>
        <el-alert
          v-if="previewData.portfolioScopeNote || previewData.dimensionRateNote"
          class="mb8"
          type="info"
          :closable="false"
          show-icon
          :title="[previewData.portfolioScopeNote, previewData.dimensionRateNote].filter(Boolean).join('；')"
        />
        <el-descriptions v-if="previewStudent" :column="1" border size="small" class="mb8">
          <el-descriptions-item label="学生">{{ previewStudent.studentNo }} · {{ previewStudent.studentName }}</el-descriptions-item>
          <el-descriptions-item label="班级">{{ previewStudent.deptName || '-' }}</el-descriptions-item>
        </el-descriptions>
        <el-descriptions v-if="previewSummary" :column="2" border size="small" class="mb8">
          <el-descriptions-item label="分析口径" :span="2">{{ previewData.scopeLabel || subjectScopeLabel }}</el-descriptions-item>
          <el-descriptions-item label="综合得分率">{{ formatRate(previewSummary.overallRate) }}</el-descriptions-item>
          <el-descriptions-item label="班级均分">{{ formatRate(previewSummary.classAvgRate) }}</el-descriptions-item>
          <el-descriptions-item label="名次">{{ formatRank(previewSummary) }}</el-descriptions-item>
          <el-descriptions-item label="百分位">{{ formatPercentile(previewSummary.percentile) }}</el-descriptions-item>
          <el-descriptions-item label="严重/薄弱">{{ previewSummary.severeCount || 0 }} / {{ previewSummary.weakCount || 0 }}</el-descriptions-item>
          <el-descriptions-item label="置信度">{{ previewSummary.confidenceLabel || '-' }}</el-descriptions-item>
        </el-descriptions>
        <template v-if="previewSubjectBreakdown.length">
          <div class="card-header mb8">分科概览</div>
          <el-table :data="previewSubjectBreakdown" size="small" empty-text="-" max-height="200" class="mb8">
            <el-table-column label="学科" min-width="90" prop="subjectName" />
            <el-table-column label="得分率" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.overallRate) }}</template>
            </el-table-column>
            <el-table-column label="薄弱" width="70" align="center" prop="weakCount" />
          </el-table>
        </template>
        <div class="card-header mb8">薄弱 Top</div>
        <el-table :data="previewWeakTop" size="small" empty-text="-" max-height="220">
          <el-table-column label="知识点" min-width="120" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName || '-' }}</template>
          </el-table-column>
          <el-table-column label="得分率" width="90" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.rate != null ? scope.row.rate : scope.row.weightedRate) }}</template>
          </el-table-column>
          <el-table-column label="根因" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.rootHint || '-' }}</template>
          </el-table-column>
        </el-table>
        <template v-if="previewExamPapers.length">
          <div class="card-header mb8" style="margin-top:12px">考试清单（选卷）</div>
          <el-table :data="previewExamPapers" size="small" empty-text="-" max-height="140">
            <el-table-column label="试卷" min-width="140" :show-overflow-tooltip="true">
              <template slot-scope="scope">{{ scope.row.paperName || '-' }}</template>
            </el-table-column>
            <el-table-column label="考试日" width="110" align="center">
              <template slot-scope="scope">{{ scope.row.examDate ? String(scope.row.examDate).substring(0, 10) : '-' }}</template>
            </el-table-column>
          </el-table>
        </template>
        <template v-if="previewPersistentWeak.length">
          <div class="card-header mb8" style="margin-top:12px">反复薄弱</div>
          <el-table :data="previewPersistentWeak" size="small" empty-text="-" max-height="160">
            <el-table-column label="知识点" min-width="120" :show-overflow-tooltip="true">
              <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName || '-' }}</template>
            </el-table-column>
            <el-table-column label="偏低场次" width="90" align="center">
              <template slot-scope="scope">{{ scope.row.lowPapers || 0 }}/{{ scope.row.validPapers || 0 }}</template>
            </el-table-column>
          </el-table>
        </template>
        <template v-if="previewQuestionType.length">
          <div class="card-header mb8" style="margin-top:12px">题型表现</div>
          <el-table :data="previewQuestionType" size="small" empty-text="-" max-height="160">
            <el-table-column label="题型" min-width="100">
              <template slot-scope="scope">{{ scope.row.typeName || scope.row.typeCode || '-' }}</template>
            </el-table-column>
            <el-table-column label="得分率" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
            </el-table-column>
            <el-table-column label="样本" width="70" align="center" prop="attemptCount" />
          </el-table>
        </template>
        <template v-if="previewBloom.length">
          <div class="card-header mb8" style="margin-top:12px">能力层级</div>
          <el-alert v-if="previewBloomInsight" class="mb8" type="info" :closable="false" show-icon :title="previewBloomInsight" />
          <el-table :data="previewBloom" size="small" empty-text="-" max-height="160">
            <el-table-column label="层级" min-width="100">
              <template slot-scope="scope">{{ scope.row.bloomLabel || scope.row.bloomLevel || '-' }}</template>
            </el-table-column>
            <el-table-column label="得分率" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
            </el-table-column>
            <el-table-column label="样本" width="70" align="center" prop="attemptCount" />
          </el-table>
        </template>
        <template v-if="previewChapterImproved.length || previewChapterDeclined.length">
          <div class="card-header mb8" style="margin-top:12px">章节进退</div>
          <el-alert v-if="previewChapterHeadline" class="mb8" type="info" :closable="false" show-icon :title="previewChapterHeadline" />
          <el-table :data="previewChapterImproved.concat(previewChapterDeclined)" size="small" empty-text="-" max-height="160">
            <el-table-column label="类型" width="70" align="center">
              <template slot-scope="scope">
                <el-tag size="mini" :type="(previewChapterImproved.indexOf(scope.row) >= 0) ? 'success' : 'danger'">
                  {{ previewChapterImproved.indexOf(scope.row) >= 0 ? '进步' : '退步' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="章节" min-width="120" :show-overflow-tooltip="true">
              <template slot-scope="scope">{{ scope.row.chapterName || '-' }}</template>
            </el-table-column>
            <el-table-column label="变化" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.deltaRate) }}</template>
            </el-table-column>
          </el-table>
        </template>
        <template v-if="previewErrorCause.length">
          <div class="card-header mb8" style="margin-top:12px">错因汇总</div>
          <el-table :data="previewErrorCause" size="small" empty-text="-" max-height="160">
            <el-table-column label="类别/错因" min-width="120" :show-overflow-tooltip="true">
              <template slot-scope="scope">{{ scope.row.errorLabel || scope.row.errorCategoryLabel || scope.row.errorCode || '-' }}</template>
            </el-table-column>
            <el-table-column label="次数" width="80" align="center" prop="tagCount" />
          </el-table>
        </template>
        <div class="card-header mb8" style="margin-top:12px">开放预警</div>
        <el-table :data="previewWarnings" size="small" empty-text="无" max-height="180">
          <el-table-column label="标题" prop="title" min-width="120" :show-overflow-tooltip="true" />
          <el-table-column label="级别" prop="level" width="70" align="center" />
        </el-table>
        <div style="margin-top:16px;text-align:right">
          <el-button type="primary" size="mini" :loading="exportLoading" @click="handleExportReport('pdf')" v-hasPermi="['spas:report:export']">下载 PDF</el-button>
          <el-button size="mini" :loading="exportLoading" @click="handleExportReport('xlsx')" v-hasPermi="['spas:report:export']">下载 Excel</el-button>
        </div>
      </div>
    </el-drawer>

  </div>
</template>

<script>
import { summaryStudent, radarStudent, trendStudent, weakTopStudent, recalcStudent, studentKnowledgeQuestions, chapterRadarStudent, analysisConfig, knowledgeExamTrend, persistentWeak as fetchPersistentWeak, paperAnnotationCoverage, scopeCompareStudent, questionTypeStudent, bloomStudent, chapterDeltaStudent } from '@/api/spas/analysis'
import { addIntervene, listIntervene } from '@/api/spas/intervene'
import { previewStudentReport } from '@/api/spas/report'
import { getRankTrend } from '@/api/spas/examScore'
import { saveErrorTag } from '@/api/spas/errorTag'
import { optionselectSubject } from '@/api/spas/subject'
import { listStudent } from '@/api/spas/student'
import { listPaper } from '@/api/spas/paper'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
import { applyTeachingDeptContext, canLoadSystemDeptTree } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import SpasChart from '@/components/spas/charts/SpasChart'
import { buildScopeBanner, isFormalWeak, isLowEvidence, isNonDefaultScope } from '@/utils/spasAnalysisScope'
import { boundClassRoleFromDepts } from '@/utils/spasTeacherRole'
import { checkPermi } from '@/utils/permission'

export default {
  name: 'SpasAnalysisStudent',
  dicts: ['spas_weak_level', 'spas_error_cause', 'spas_error_category'],
  components: { Treeselect, SpasChart },
  data() {
    return {
      loading: false,
      recalcLoading: false,
      exportLoading: false,
      previewLoading: false,
      previewOpen: false,
      previewData: {},
      rankLoading: false,
      rankExporting: false,
      rankSubjects: [],
      rankSummary: {},
      chapterRadar: [],
      questionTypeItems: [],
      questionTypeSummary: {},
      bloomItems: [],
      bloomSummary: {},
      bloomInsight: '',
      chapterDelta: { items: [], improved: [], declined: [], headline: '', baselineWindow: '', baselineHint: '', baselineEmpty: false },
      subjectOptions: [],
      deptOptions: [],
      myDepts: [],
      studentOptions: [],
      studentLoading: false,
      paperOptions: [],
      weakList: [],
      interveneByKnowledge: {},
      scopeCompare: null,
      summary: {},
      radarOption: {},
      trendOption: {},
      weakBarOption: {},
      drillOpen: false,
      drillLoading: false,
      drillRows: [],
      drillTitle: '题目明细',
      trendPoints: [],
      analysisMode: 'window',
      useRecency: true,
      showAdvancedScope: false,
      defaultWindow: 'semester',
      minAttempts: 3,
      baseMinAttempts: 3,
      subjectOverrides: {},
      subjectOverrideTip: '',
      recencyHalfLifeDays: 60,
      scopeMaxPapers: 30,
      annotationHint: '',
      unboundRatioThreshold: 0.20,
      prevSemesterLabel: '',
      subjectPickedByUser: false,
      autoSwitchingSubject: false,
      queryParams: {
        window: 'semester',
        subjectId: 0,
        deptId: undefined,
        studentId: undefined,
        paperIds: [],
        limit: 10
      }
    }
  },
  watch: {
    'queryParams.studentId'(val, oldVal) {
      if (val !== oldVal) {
        this.subjectPickedByUser = false
      }
    }
  },
  computed: {
    isAllSubjects() {
      const sid = this.queryParams.subjectId
      return sid === 0 || sid === '0' || sid == null || sid === ''
    },
    subjectScopeLabel() {
      if (this.isAllSubjects) return '所有科目'
      const hit = (this.subjectOptions || []).find(s => Number(s.subjectId) === Number(this.queryParams.subjectId))
      return (hit && hit.subjectName) || '单科'
    },
    subjectBreakdown() {
      const list = (this.summary && this.summary.subjectBreakdown) || []
      return Array.isArray(list) ? list : []
    },
    suggestedSubjects() {
      const list = (this.summary && this.summary.subjectsWithData) || []
      return Array.isArray(list) ? list : []
    },
    errorCauseGroups() {
      const causes = (this.dict && this.dict.type && this.dict.type.spas_error_cause) || []
      const cats = (this.dict && this.dict.type && this.dict.type.spas_error_category) || []
      if (!causes.length || !cats.length) {
        return []
      }
      const used = new Set()
      const groups = cats.map(cat => {
        const options = causes.filter(d => {
          const remark = (d.raw && d.raw.remark) || d.remark || ''
          return remark === cat.value
        })
        options.forEach(o => used.add(o.value))
        return { value: cat.value, label: cat.label, options }
      }).filter(g => g.options.length)
      const orphans = causes.filter(d => !used.has(d.value))
      if (orphans.length) {
        groups.push({ value: '_other', label: '其他', options: orphans })
      }
      return groups
    },
    quickErrorChips() {
      return [
        { code: 'calc_slip', label: '计算' },
        { code: 'reading_miss', label: '审题' },
        { code: 'concept_unclear', label: '概念' },
        { code: 'careless', label: '粗心' }
      ]
    },
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
      if (!id) return ''
      const mine = (this.myDepts || []).find(d => d.deptId === id)
      if (mine && mine.deptName) return mine.deptName
      const node = this.findDeptNode(this.deptOptions, id)
      return node ? (node.label || node.deptName || '') : ''
    },
    boundClassRoleLabel() {
      return boundClassRoleFromDepts(this.myDepts, this.queryParams.deptId)
    },
    knowledgeTrendOption() {
      const rows = this.trendPoints || []
      const names = rows.map(r => r.paperName || r.examDate || '-')
      const rates = rows.map(r => {
        const v = Number(r.rate)
        if (isNaN(v)) return 0
        return v <= 1 ? +(v * 100).toFixed(1) : +v.toFixed(1)
      })
      return {
        tooltip: { trigger: 'axis' },
        grid: { left: 40, right: 20, top: 30, bottom: 40 },
        xAxis: { type: 'category', data: names, axisLabel: { rotate: 20 } },
        yAxis: { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } },
        series: [{ type: 'line', data: rates, name: '得分率', markLine: { data: [{ yAxis: 60, name: '薄弱线' }] } }]
      }
    },
    chapterRadarOption() {
      const rows = this.chapterRadar || []
      const names = rows.map(r => r.name || r.knowledgeName || '-')
      const rates = rows.map(r => {
        const v = Number(r.rate)
        if (isNaN(v)) return 0
        return v <= 1 ? +(v * 100).toFixed(1) : +v.toFixed(1)
      })
      return {
        tooltip: { trigger: 'axis' },
        grid: { left: 40, right: 20, top: 30, bottom: 40 },
        xAxis: { type: 'category', data: names, axisLabel: { rotate: 30 } },
        yAxis: { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } },
        series: [{ type: 'bar', data: rates, name: '章节' }]
      }
    },
    summaryCards() {
      const s = this.summary || {}
      return [
        { key: 'rate', label: '综合得分率', value: this.formatRate(s.overallRate != null ? s.overallRate : s.avgRate), hint: '练习次数加权', tone: 'blue' },
        { key: 'class', label: '班级均分', value: this.formatRate(s.classAvgRate), hint: '同班同学均值', tone: 'green' },
        { key: 'rank', label: '班级名次', value: this.formatRank(s), hint: '得分率从高到低', tone: 'blue' },
        { key: 'pct', label: '百分位', value: this.formatPercentile(s.percentile), hint: '超过X%同班同学', tone: 'green' },
        { key: 'gap', label: '与班差', value: this.formatGap(s.gap), hint: '负值表示偏低', tone: 'orange' },
        { key: 'weak', label: '正式薄弱', value: s.weakCount != null ? s.weakCount : '-', hint: '作答≥3 且低于60%', tone: 'orange' },
        { key: 'severe', label: '正式严重', value: s.severeCount != null ? s.severeCount : '-', hint: '作答≥3 且低于45%', tone: 'red' },
        { key: 'low', label: '综合低分', value: s.lowRateCount != null ? s.lowRateCount : '-', hint: this.lowRateHint(s), tone: 'orange' },
        { key: 'thin', label: '样本不足', value: s.thinSampleCount != null ? s.thinSampleCount : '-', hint: '低分但作答不足，不定级', tone: 'purple' },
        { key: 'conf', label: '置信度', value: this.summaryConfidenceText, hint: this.summaryConfidenceHint, tone: 'purple' }
      ]
    },
    analysisHint() {
      return this.scopeBanner
    },
    scopeBanner() {
      const base = buildScopeBanner({
        analysisMode: this.analysisMode,
        window: this.queryParams.window,
        defaultWindow: this.defaultWindow,
        paperIds: this.queryParams.paperIds,
        useRecency: this.useRecency,
        dataMode: this.summary && this.summary.dataMode,
        calcTime: (this.summary && (this.summary.lastCalcTime || this.summary.calcTime)) || null
      })
      const sub = this.subjectScopeLabel
      return sub ? ('学科：' + sub + ' · ' + base) : base
    },
    scopeCompareTitle() {
      const c = this.scopeCompare
      if (!c || c.deltaOverallRate == null) return ''
      const d = Number(c.deltaOverallRate)
      const pct = (d * 100).toFixed(1)
      const sign = d > 0 ? '+' : ''
      const n = (c.newPersistentCount != null ? c.newPersistentCount : ((c.newPersistentWeaks || []).length))
      let names = ''
      const list = c.newPersistentWeaks || []
      if (list.length) {
        names = '（' + list.slice(0, 3).map(function (x) { return x.knowledgeName || x.name || x.knowledgeId }).join('、') + (list.length > 3 ? '…' : '') + '）'
      }
      return '相对全量口径：综合得分率 Δ ' + sign + pct + '%；新出现反复薄弱 ' + n + ' 个' + names
    },
    lowConfidenceCount() {
      return (this.weakList || []).filter(r => this.rowLowEvidence(r)).length
    },
    summaryConfidenceText() {
      const s = this.summary || {}
      if (s.confidenceLabel) return s.confidenceLabel
      return this.confidenceText({ confidenceLabel: s.confidenceLabel, attemptCount: s.totalAttempts, confidence: s.confidence })
    },
    summaryConfidenceHint() {
      const t = this.summaryConfidenceText
      if (t === '样本不足') return '练习偏少，勿下结论'
      if (t === '高') return '样本较充分'
      return '样本中等'
    },
    previewStudent() {
      return (this.previewData && this.previewData.student) || null
    },
    previewSummary() {
      return (this.previewData && this.previewData.summary) || null
    },
    previewWeakTop() {
      const w = this.previewData && this.previewData.weakTop
      return Array.isArray(w) ? w : []
    },
    previewSubjectBreakdown() {
      const s = this.previewSummary
      const list = (s && s.subjectBreakdown) || (this.previewData && this.previewData.subjectBreakdown) || []
      return Array.isArray(list) ? list : []
    },
    previewExamPapers() {
      const w = this.previewData && this.previewData.examPapers
      return Array.isArray(w) ? w : []
    },
    previewPersistentWeak() {
      const w = this.previewData && this.previewData.persistentWeak
      return Array.isArray(w) ? w : []
    },
    previewWarnings() {
      const w = this.previewData && this.previewData.openWarnings
      return Array.isArray(w) ? w : []
    },
    previewQuestionType() {
      const q = this.previewData && this.previewData.questionType
      const items = q && q.items
      return Array.isArray(items) ? items : []
    },
    previewBloom() {
      const q = this.previewData && this.previewData.bloom
      const items = q && q.items
      return Array.isArray(items) ? items : []
    },
    previewBloomInsight() {
      const q = this.previewData && this.previewData.bloom
      return (q && q.insight) || ''
    },
    previewChapterImproved() {
      const q = this.previewData && this.previewData.chapterDelta
      const items = q && q.improved
      return Array.isArray(items) ? items : []
    },
    previewChapterDeclined() {
      const q = this.previewData && this.previewData.chapterDelta
      const items = q && q.declined
      return Array.isArray(items) ? items : []
    },
    previewChapterHeadline() {
      const q = this.previewData && this.previewData.chapterDelta
      return (q && q.headline) || ''
    },
    previewErrorCause() {
      const c = this.previewData && this.previewData.errorCauseSummary
      return Array.isArray(c) ? c : []
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.studentId) {
      this.queryParams.studentId = Number(q.studentId) || q.studentId
    }
    if (q.subjectId != null && q.subjectId !== '') {
      this.queryParams.subjectId = Number(q.subjectId)
      if (isNaN(this.queryParams.subjectId)) {
        this.queryParams.subjectId = 0
      }
    }
    if (q.deptId) {
      this.queryParams.deptId = Number(q.deptId) || q.deptId
    }
    if (q.window) {
      this.queryParams.window = q.window
    }
    if (q.mode === 'papers') {
      this.analysisMode = 'papers'
      if (q.paperIds) {
        this.queryParams.paperIds = String(q.paperIds).split(',').map(function (s) { return Number(s) }).filter(function (n) { return !isNaN(n) })
      }
    }
    this.loadAnalysisConfig()
    this.loadSubjects()
    this.loadMyDepts().then(() => {
      if (!this.queryParams.deptId && this.preferredDeptId) {
        this.queryParams.deptId = this.preferredDeptId
      }
      this.loadPapers()
      return this.loadStudents()
    }).then(() => {
      if (!this.queryParams.studentId && this.studentOptions.length && !this.$route.query.studentId) {
        this.queryParams.studentId = this.studentOptions[0].studentId
      }
      if (this.queryParams.studentId) {
        return this.loadAnalysis()
      }
    }).catch(() => {})
  },
  methods: {
    lowRateHint(s) {
      const thin = Number(s && s.thinSampleCount)
      const severe = s && s.lowSevereCount
      const parts = ['得分率低于60%的知识点']
      if (!isNaN(thin) && thin > 0) parts.push('含样本不足 ' + thin)
      if (severe != null && severe !== '') parts.push('低于45% ' + severe)
      return parts.join(' · ')
    },
    checkPermi,
    findDeptNode(nodes, id) {
      for (const n of nodes || []) {
        if (n.id === id || n.deptId === id) return n
        const c = this.findDeptNode(n.children, id)
        if (c) return c
      }
      return null
    },
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      this.queryParams.studentId = undefined
      this.loadStudents().then(() => {
        if (this.studentOptions.length) {
          this.queryParams.studentId = this.studentOptions[0].studentId
          this.loadAnalysis()
        } else {
          this.weakList = []
          this.radarOption = {}
          this.trendOption = {}
          this.weakBarOption = {}
          this.clearAdvancedAnalysis()
        }
      })
    },
    toPercent(rate) {
      if (rate == null || rate === '') {
        return 0
      }
      const n = Number(rate)
      if (isNaN(n)) {
        return 0
      }
      return n <= 1 ? Math.round(n * 10000) / 100 : Math.round(n * 100) / 100
    },
    formatPct(v) {
      if (v == null || v === '') return '-'
      const n = Number(v)
      if (isNaN(n)) return '-'
      return (n <= 1 ? n * 100 : n).toFixed(1) + '%'
    },
    formatDependencyHints(hints) {
      if (!Array.isArray(hints) || !hints.length) return '-'
      return hints.map(h => (h && (h.fromKnowledgeName || h.rootHint || h)) || '').filter(Boolean).join('；')
    },
    formatRate(rate) {
      if (rate == null || rate === '') {
        return '-'
      }
      return this.toPercent(rate).toFixed(2) + '%'
    },
    formatRank(s) {
      if (!s || s.rankNo == null || s.rankNo === '') return '-'
      const size = s.classSize != null ? s.classSize : '-'
      return s.rankNo + ' / ' + size
    },
    formatPercentile(p) {
      if (p == null || p === '') return '-'
      const n = Number(p)
      if (isNaN(n)) return p
      return n.toFixed(1) + '%'
    },
    formatGap(gap) {
      if (gap == null || gap === '') return '-'
      const n = Number(gap)
      if (isNaN(n)) return gap
      const pct = (n <= 1 && n >= -1 ? n * 100 : n)
      const sign = pct > 0 ? '+' : ''
      return sign + pct.toFixed(2) + '%'
    },
    formatConfidence(c) {
      if (c == null || c === '') return '-'
      const n = Number(c)
      if (isNaN(n)) return c
      return (n * 100).toFixed(0) + '%'
    },
    confidenceText(row) {
      if (!row) return '-'
      if (row.confidenceLabel) return row.confidenceLabel
      const a = Number(row.attemptCount != null ? row.attemptCount : row.totalAttempts)
      const min = this.minAttempts || 3
      if (!a || a < min) return '样本不足'
      if (a < min * 2) return '中'
      return '高'
    },
    rowFormalWeak(row) {
      return isFormalWeak(row)
    },
    rowLowEvidence(row) {
      return isLowEvidence(row, this.minAttempts)
    },
    confidenceTagType(row) {
      const t = this.confidenceText(row)
      if (t === '样本不足') return 'danger'
      if (t === '高') return 'success'
      return 'warning'
    },
    gapColor(gap) {
      const n = Number(gap)
      if (isNaN(n)) return undefined
      if (n < -0.05) return '#FF5A5F'
      if (n > 0.05) return '#10B981'
      return '#64748B'
    },
    formatWeight(weight) {
      if (weight == null || weight === '') return '-'
      const n = Number(weight)
      if (isNaN(n)) return weight
      return (n * 100).toFixed(0) + '%'
    },
    formatStudentLabel(item) {
      const no = item.studentNo || ''
      const name = item.studentName || ''
      return no ? (no + ' · ' + name) : name
    },
    unwrapList(res) {
      if (!res) {
        return []
      }
      if (Array.isArray(res.data)) {
        return res.data
      }
      if (Array.isArray(res.rows)) {
        return res.rows
      }
      return []
    },
    loadSubjects() {
      return optionselectSubject().then(response => {
        this.subjectOptions = response.data || []
        // Keep route subject; otherwise default to 所有科目 (0)
        if (this.queryParams.subjectId === undefined || this.queryParams.subjectId === null || this.queryParams.subjectId === '') {
          this.queryParams.subjectId = 0
        }
      }).catch(() => {
        this.subjectOptions = []
      })
    },
    resolveSubjectId() {
      if (this.isAllSubjects) return undefined
      return this.queryParams.subjectId
    },
    loadDepts() {
      if (!canLoadSystemDeptTree()) {
        this.deptOptions = []
        return Promise.resolve()
      }
      return deptTreeSelect().then(response => {
        this.deptOptions = response.data || []
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
      if (this.queryParams.deptId) {
        params.deptId = this.queryParams.deptId
      }
      if (keyword) {
        if (/^\d/.test(String(keyword))) {
          params.studentNo = keyword
        } else {
          params.studentName = keyword
        }
      }
      this.studentLoading = true
      return listStudent(params).then(response => {
        this.studentOptions = response.rows || response.data || []
        if (response.total > params.pageSize && !keyword && this.queryParams.deptId) {
          this.$modal.msgWarning('当前班级学生超过 ' + params.pageSize + ' 人，请使用搜索定位')
        }
      }).catch(() => {
        this.studentOptions = []
      }).finally(() => {
        this.studentLoading = false
      })
    },
    remoteStudent(query) {
      if (this.queryParams.deptId && !query) {
        this.loadStudents()
        return
      }
      if (!query && !this.queryParams.deptId) {
        this.studentOptions = []
        return
      }
      this.loadStudents(query)
    },
    handleSubjectChange() {
      if (!this.autoSwitchingSubject) {
        this.subjectPickedByUser = true
      }
      this.applySubjectThresholds()
      this.queryParams.paperIds = []
      this.loadPapers()
      if (this.queryParams.studentId) {
        this.handleQuery()
      }
    },
    switchToSubject(subjectId) {
      if (subjectId == null || Number(subjectId) === Number(this.queryParams.subjectId)) {
        return
      }
      this.subjectPickedByUser = false
      this.autoSwitchingSubject = true
      this.queryParams.subjectId = Number(subjectId) || subjectId
      this.applySubjectThresholds()
      this.queryParams.paperIds = []
      this.loadPapers()
      this.autoSwitchingSubject = false
      this.handleQuery()
    },
    applySubjectThresholds() {
      const base = this.baseMinAttempts || 3
      this.minAttempts = base
      this.subjectOverrideTip = ''
      if (this.isAllSubjects) {
        return
      }
      const hit = (this.subjectOptions || []).find(s => Number(s.subjectId) === Number(this.queryParams.subjectId))
      const code = hit && hit.subjectCode
      if (!code) {
        return
      }
      const overrides = this.subjectOverrides || {}
      let o = overrides[code]
      if (!o) {
        const key = Object.keys(overrides).find(k => k && k.toLowerCase() === String(code).toLowerCase())
        o = key ? overrides[key] : null
      }
      if (!o) {
        return
      }
      if (o.minAttempts != null && Number(o.minAttempts) > 0) {
        this.minAttempts = Number(o.minAttempts)
      }
      const bits = []
      if (o.weak != null) bits.push('薄弱线 ' + Number(o.weak).toFixed(2))
      if (o.minAttempts != null) bits.push('最低练习 ' + o.minAttempts + ' 次')
      if (bits.length) {
        this.subjectOverrideTip = (hit.subjectName || code) + '分科口径：' + bits.join('，')
      }
    },
    handleDeptChange() {
      this.queryParams.studentId = undefined
      this.loadStudents()
    },
    handleQuery() {
      if (!this.queryParams.studentId) {
        this.$modal.msgWarning('请先选择学生')
        return
      }
      if (this.analysisMode === 'papers' && (!this.queryParams.paperIds || !this.queryParams.paperIds.length)) {
        this.$modal.msgWarning('选卷诊断请至少勾选一份试卷')
        return
      }
      this.loadAnalysis()
    },
    resetQuery() {
      this.queryParams.deptId = this.boundClassMode ? this.preferredDeptId : undefined
      this.queryParams.studentId = undefined
      this.queryParams.subjectId = 0
      this.queryParams.paperIds = []
      this.analysisMode = 'window'
      this.subjectPickedByUser = false
      this.weakList = []
      this.radarOption = {}
      this.trendOption = {}
      this.weakBarOption = {}
      this.clearAdvancedAnalysis()
      this.loadSubjects()
      this.loadStudents()
      this.loadPapers()
    },
    handleRecalc() {
      if (!this.queryParams.studentId) {
        return
      }
      const tip = '确认重新计算该学生的知识点统计？'
        + (this.useRecency ? ('（启用近因衰减，半衰期 ' + this.recencyHalfLifeDays + ' 天）') : '（关闭近因衰减）')
      this.$modal.confirm(tip).then(() => {
        this.recalcLoading = true
        return recalcStudent(this.queryParams.studentId, { useRecency: this.useRecency })
      }).then(() => {
        this.$modal.msgSuccess('重算完成')
        this.loadAnalysis()
      }).catch(() => {}).finally(() => {
        this.recalcLoading = false
      })
    },
    loadAnalysisConfig() {
      return analysisConfig().then(res => {
        const cfg = (res && res.data) || {}
        if (cfg.defaultWindow) {
          this.defaultWindow = cfg.defaultWindow
          if (!this.$route.query.window) {
            this.queryParams.window = cfg.defaultWindow
          }
        }
        if (cfg.recencyHalfLifeDays != null) {
          this.recencyHalfLifeDays = Number(cfg.recencyHalfLifeDays) || 60
          this.useRecency = this.recencyHalfLifeDays > 0
        }
        if (cfg.scopeMaxPapers != null) {
          this.scopeMaxPapers = Number(cfg.scopeMaxPapers) || 30
        }
        if (cfg.minAttempts != null) {
          this.baseMinAttempts = Number(cfg.minAttempts) || 3
          this.minAttempts = this.baseMinAttempts
        }
        this.subjectOverrides = cfg.subjectOverrides || {}
        this.applySubjectThresholds()
        const annot = cfg.annotationCoverage || {}
        if (annot.unboundRatioThreshold != null) {
          this.unboundRatioThreshold = Number(annot.unboundRatioThreshold) || 0.20
        }
        const prev = cfg.prevSemester || {}
        this.prevSemesterLabel = prev.label || ''
        this.showAdvancedScope = isNonDefaultScope(
          this.analysisMode,
          this.queryParams.window,
          this.defaultWindow,
          this.queryParams.paperIds,
          this.useRecency
        )
      }).catch(() => {})
    },
    onModeChange() {
      if (this.analysisMode === 'papers') {
        this.loadPapers()
      }
      if (this.queryParams.studentId) {
        this.handleQuery()
      }
    },
    paperLabel(item) {
      const date = item.examDate ? String(item.examDate).substring(0, 10) : ''
      return (item.paperName || ('试卷' + item.paperId)) + (date ? (' · ' + date) : '')
    },
    loadPapers() {
      const query = { pageNum: 1, pageSize: 200, status: '1' }
      const sid = this.resolveSubjectId()
      if (sid) {
        query.subjectId = sid
      }
      return listPaper(query).then(res => {
        this.paperOptions = res.rows || []
      }).catch(() => {
        this.paperOptions = []
      })
    },
    scopeQuery(extra) {
      const q = Object.assign({
        useRecency: this.useRecency,
        limit: this.queryParams.limit || 10
      }, extra || {})
      const sid = this.resolveSubjectId()
      if (sid != null) {
        q.subjectId = sid
      }
      if (this.analysisMode === 'papers') {
        q.paperIds = (this.queryParams.paperIds || []).join(',')
      } else {
        q.window = this.queryParams.window
      }
      return q
    },
    persistTagType(tag) {
      if (tag === '反复薄弱') return 'danger'
      if (tag === '单次探底') return 'warning'
      if (tag === '样本不足') return 'info'
      if (tag === '波动型') return 'warning'
      return 'success'
    },
    mergePersistTags(weakRows, persistRows) {
      const map = {}
      ;(persistRows || []).forEach(r => {
        if (r.knowledgeId != null) map[String(r.knowledgeId)] = r.persistTag
      })
      return (weakRows || []).map(r => {
        const tag = map[String(r.knowledgeId)]
        return tag ? Object.assign({}, r, { persistTag: tag }) : r
      })
    },
    onErrorTagChange(row) {
      if (!row || !row.questionId || !this.queryParams.studentId) return
      const payload = {
        studentId: this.queryParams.studentId,
        paperId: row.paperId,
        questionId: row.questionId,
        errorCode: row.errorCode || ''
      }
      saveErrorTag(payload).then(() => {
        this.$modal.msgSuccess(row.errorCode ? '错因已保存' : '已清除错因')
        const hit = (this.dict.type.spas_error_cause || []).find(d => d.value === row.errorCode)
        this.$set(row, 'errorLabel', hit ? hit.label : null)
      }).catch(() => {
        if (this._drillKnowledgeId) {
          this.openKnowledgeDrill({ knowledgeId: this._drillKnowledgeId })
        }
      })
    },
    isLowRateRow(row) {
      if (!row) return false
      const r = Number(row.rate != null ? row.rate : row.attributedRate)
      if (isNaN(r)) return false
      const pct = r <= 1 ? r : r / 100
      return pct < 0.6
    },
    quickErrorTag(row, code) {
      if (!row || !code) return
      this.$set(row, 'errorCode', row.errorCode === code ? '' : code)
      this.onErrorTagChange(row)
    },
    openKnowledgeTrend(row) {
      this.openKnowledgeDrill(row)
    },
    openKnowledgeDrill(row) {
      const knowledgeId = row.knowledgeId || row.id
      if (!knowledgeId || !this.queryParams.studentId) return
      this._drillKnowledgeId = knowledgeId
      this.drillTitle = (row.name || row.knowledgeName || '知识点') + ' - 趋势与题目'
      this.drillOpen = true
      this.drillLoading = true
      this.trendPoints = []
      const trendQ = this.scopeQuery({ knowledgeId })
      Promise.all([
        knowledgeExamTrend(this.queryParams.studentId, trendQ),
        studentKnowledgeQuestions(this.queryParams.studentId, knowledgeId, this.scopeQuery()),
      ]).then(([trendRes, qRes]) => {
        this.trendPoints = this.unwrapList(trendRes)
        this.drillRows = this.unwrapList(qRes)
      }).catch(() => {
        this.trendPoints = []
        this.drillRows = []
      }).finally(() => {
        this.drillLoading = false
      })
    },
    onWeakBarClick(params) {
      if (!params || params.componentType !== 'series') return
      const name = params.name
      const hit = (this.weakList || []).find(k => (k.name || k.knowledgeName) === name)
      if (!hit) {
        this.$modal.msgWarning('无法定位知识点')
        return
      }
      this.$confirm('选择操作', '薄弱点下钻', {
        distinguishCancelAndClose: true,
        confirmButtonText: '查看趋势/题目',
        cancelButtonText: '发起干预'
      }).then(() => {
        this.openKnowledgeDrill(hit)
      }).catch(action => {
        if (action === 'cancel') {
          this.startIntervene(hit)
        }
      })
    },
    goPortfolio() {
      if (!this.queryParams.studentId) {
        return
      }
      const query = { studentId: this.queryParams.studentId }
      const sid = this.resolveSubjectId()
      if (sid != null) {
        query.subjectId = sid
      }
      this.$router.push({ path: '/spas/portfolio', query })
    },
    openReportPreview() {
      if (!this.queryParams.studentId) {
        this.$modal.msgWarning('请先选择学生')
        return
      }
      this.previewOpen = true
      this.previewLoading = true
      this.previewData = {}
      previewStudentReport(this.queryParams.studentId, this.scopeQuery()).then(res => {
        this.previewData = res.data || {}
      }).catch(() => {
        this.previewData = {}
        this.$modal.msgError('报告预览加载失败')
      }).finally(() => {
        this.previewLoading = false
      })
    },
    handleExportReport(format) {
      if (!this.queryParams.studentId) {
        this.$modal.msgWarning('请先选择学生')
        return
      }
      const ext = format === 'xlsx' ? 'xlsx' : 'pdf'
      const params = Object.assign({ format: ext }, this.scopeQuery())
      this.exportLoading = true
      this.download(
        'spas/report/student/' + this.queryParams.studentId,
        params,
        `student_report_${this.queryParams.studentId}_${new Date().getTime()}.${ext}`
      ).finally(() => {
        this.exportLoading = false
      })
    },
    loadAnnotationCoverage() {
      if (this.analysisMode !== 'papers' || !this.queryParams.paperIds || !this.queryParams.paperIds.length) {
        this.annotationHint = ''
        return Promise.resolve()
      }
      return paperAnnotationCoverage({ paperIds: this.queryParams.paperIds.join(',') }).then(res => {
        const d = (res && res.data) || {}
        const unbound = Number(d.unboundCount || 0)
        const total = Number(d.questionCount || 0)
        const ratio = Number(d.unboundRatio || 0)
        const thr = Number(this.unboundRatioThreshold) || 0.20
        if (total > 0 && ratio > thr) {
          this.annotationHint = '未标注占比 ' + Math.round(ratio * 1000) / 10 + '%（阈值 ' + Math.round(thr * 100) + '%），'
            + unbound + '/' + total + ' 题未标：禁止正式薄弱定级，结论仅供参考。'
        } else if (total > 0 && unbound > 0) {
          this.annotationHint = '所选试卷有 ' + unbound + '/' + total + ' 题未标注知识点（'
            + Math.round(ratio * 1000) / 10 + '%），薄弱结论可能偏差，建议先补齐标注。'
        } else {
          this.annotationHint = ''
        }
        const noType = Number(d.noTypeCount || 0)
        const noBloom = Number(d.noBloomCount || 0)
        const metaParts = []
        if (noType > 0) metaParts.push(noType + ' 题缺题型')
        if (noBloom > 0) metaParts.push(noBloom + ' 题缺认知层级')
        if (metaParts.length) {
          this.annotationHint = (this.annotationHint ? this.annotationHint + '；' : '') + metaParts.join('，') + '（题型/能力层分析将记为未标注）'
        }
      }).catch(() => { this.annotationHint = '' })
    },
    loadInterveneOverlay() {
      const studentId = this.queryParams.studentId
      this.interveneByKnowledge = {}
      if (!studentId) return
      listIntervene({ studentId: studentId, pageNum: 1, pageSize: 200 }).then(res => {
        const map = {}
        ;(res.rows || []).forEach(task => {
          String(task.knowledgeIds || '').split(',').forEach(part => {
            const id = part.trim()
            if (!id) return
            const prev = map[id]
            if (!prev || String(task.status) === '0') map[id] = task
          })
        })
        this.interveneByKnowledge = map
      }).catch(() => { this.interveneByKnowledge = {} })
    },
    interveneOf(row) {
      const id = String((row && (row.knowledgeId || row.id)) || '')
      return this.interveneByKnowledge[id]
    },
    interveneLabel(row) {
      const task = this.interveneOf(row)
      if (!task) return ''
      const status = String(task.status)
      const name = status === '1' ? '已达标' : status === '3' ? '逾期' : status === '2' ? '已关闭' : '干预中'
      if (task.effectDelta == null || task.effectDelta === '') return name
      const n = Number(task.effectDelta)
      if (isNaN(n)) return name
      const pct = Math.abs(n) <= 1 ? n * 100 : n
      return name + ' ' + (pct >= 0 ? '+' : '') + pct.toFixed(1) + '%'
    },
    interveneTagType(row) {
      const task = this.interveneOf(row)
      if (!task) return 'info'
      if (String(task.status) === '1') return 'success'
      if (String(task.status) === '3') return 'danger'
      if (task.effectDelta != null && Number(task.effectDelta) > 0) return 'warning'
      return 'info'
    },
    goInterveneTask() {
      this.$router.push({ path: '/spas/intervene', query: { studentId: this.queryParams.studentId, status: '0' } })
    },
    startIntervene(row) {
      if (!this.queryParams.studentId) return
      if (this.summary && this.summary.formalWeakBlocked) {
        this.$modal.msgWarning('当前选卷标注不足，禁止作为正式薄弱定级后再建干预。请先补齐知识点标注。')
        return
      }
      const knowledgeId = row.knowledgeId || row.id
      const low = this.rowLowEvidence(row)
      const formal = this.rowFormalWeak(row)
      let tip = '为该知识点创建干预任务并冻结基线？'
      if (low && !formal) {
        tip = '该知识点仅为「证据不足」（练习次数 < ' + this.minAttempts + '），不能定正式薄弱。仍要创建干预并冻结基线？'
      } else if (low) {
        tip = '该知识点样本偏少，干预效果可能不稳定。确认仍要创建并冻结基线？'
      }
      this.$modal.confirm(tip).then(() => {
        return addIntervene({
          studentId: this.queryParams.studentId,
          subjectId: this.queryParams.subjectId,
          sourceType: '2',
          sourceId: knowledgeId,
          knowledgeIds: knowledgeId ? String(knowledgeId) : undefined,
          title: '薄弱干预：' + (row.name || row.knowledgeName || knowledgeId),
          targetRate: 0.6
        })
      }).then(res => {
        this.$modal.msgSuccess('干预任务已创建')
        this.$router.push({ path: '/spas/intervene', query: { status: '0' } })
      }).catch(() => {})
    },
    loadChapterRadar() {
      if (!this.queryParams.studentId || this.isAllSubjects) {
        this.chapterRadar = []
        return Promise.resolve()
      }
      return chapterRadarStudent(this.queryParams.studentId, this.scopeQuery()).then(res => {
        const data = (res && res.data != null) ? res.data : res
        this.chapterRadar = Array.isArray(data) ? data : []
      }).catch(() => { this.chapterRadar = [] })
    },
    clearAdvancedAnalysis() {
      this.questionTypeItems = []
      this.questionTypeSummary = {}
      this.bloomItems = []
      this.bloomSummary = {}
      this.bloomInsight = ''
      this.chapterDelta = { items: [], improved: [], declined: [], headline: '', baselineWindow: '' }
      this.chapterRadar = []
    },
    applyDimPayload(res, itemsKey, summaryKey) {
      const data = (res && res.data != null) ? res.data : (res || {})
      this[itemsKey] = Array.isArray(data.items) ? data.items : []
      this[summaryKey] = data.summary || {}
      if (itemsKey === 'bloomItems') {
        this.bloomInsight = data.insight || ''
      }
    },
    loadQuestionType() {
      if (!this.queryParams.studentId) {
        this.questionTypeItems = []
        this.questionTypeSummary = {}
        return Promise.resolve()
      }
      return questionTypeStudent(this.queryParams.studentId, this.scopeQuery()).then(res => {
        this.applyDimPayload(res, 'questionTypeItems', 'questionTypeSummary')
      }).catch(() => {
        this.questionTypeItems = []
        this.questionTypeSummary = {}
      })
    },
    loadBloom() {
      if (!this.queryParams.studentId) {
        this.bloomItems = []
        this.bloomSummary = {}
        this.bloomInsight = ''
        return Promise.resolve()
      }
      return bloomStudent(this.queryParams.studentId, this.scopeQuery()).then(res => {
        this.applyDimPayload(res, 'bloomItems', 'bloomSummary')
      }).catch(() => {
        this.bloomItems = []
        this.bloomSummary = {}
        this.bloomInsight = ''
      })
    },
    focusChapterDeltaIfNeeded() {
      if ((this.$route.query || {}).focus !== 'chapterDelta') {
        return
      }
      const scroll = () => {
        const el = document.getElementById('spas-chapter-delta')
        if (el && typeof el.scrollIntoView === 'function') {
          el.scrollIntoView({ behavior: 'smooth', block: 'start' })
        }
      }
      this.$nextTick(() => {
        scroll()
        setTimeout(scroll, 320)
        setTimeout(scroll, 900)
      })
    },
    loadChapterDelta() {
      if (!this.queryParams.studentId || this.isAllSubjects) {
        this.chapterDelta = {
          items: [], improved: [], declined: [], headline: '', baselineWindow: '',
          baselineHint: this.isAllSubjects ? '章节进退需指定学科，请先选择科目' : '',
          baselineEmpty: !!this.isAllSubjects
        }
        return Promise.resolve()
      }
      return chapterDeltaStudent(this.queryParams.studentId, this.scopeQuery({ baselineWindow: 'prev_semester' })).then(res => {
        const data = (res && res.data != null) ? res.data : (res || {})
        this.chapterDelta = {
          items: Array.isArray(data.items) ? data.items : [],
          improved: Array.isArray(data.improved) ? data.improved : [],
          declined: Array.isArray(data.declined) ? data.declined : [],
          headline: data.headline || '',
          baselineWindow: data.baselineWindow || 'prev_semester',
          baselineHint: data.baselineHint || '',
          baselineEmpty: !!data.baselineEmpty
        }
      }).catch(() => {
        this.chapterDelta = { items: [], improved: [], declined: [], headline: '', baselineWindow: '', baselineHint: '', baselineEmpty: false }
      })
    },

    loadRankTrend() {
      const studentId = this.queryParams.studentId
      if (!studentId) {
        this.rankSubjects = []
        this.rankSummary = {}
        return
      }
      this.rankLoading = true
      getRankTrend(studentId, this.scopeQuery()).then(res => {
        const data = res.data || {}
        this.rankSubjects = data.subjects || []
        this.rankSummary = data.summary || {}
      }).catch(() => {
        this.rankSubjects = []
        this.rankSummary = {}
      }).finally(() => {
        this.rankLoading = false
      })
    },
    exportRankTrend() {
      if (!this.queryParams.studentId) return
      this.rankExporting = true
      this.download('spas/examScore/studentRankTrend/export', Object.assign({ studentId: this.queryParams.studentId }, this.scopeQuery()), 'rank_trend_' + this.queryParams.studentId + '.pdf')
      this.rankExporting = false
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
      if (trend === 'flat') return 'info'
      return 'warning'
    },
    crossTagType(code) {
      if (code === 'dualDown') return 'danger'
      if (code === 'rankUp+weakMastery') return 'warning'
      if (code === 'rankDown+solidMastery') return 'info'
      if (code === 'dualUp') return 'success'
      return ''
    },
    loadAnalysis() {
      const studentId = this.queryParams.studentId
      if (!studentId) {
        return
      }
      if (this.analysisMode === 'papers' && (!this.queryParams.paperIds || !this.queryParams.paperIds.length)) {
        this.$modal.msgWarning('选卷诊断请至少勾选一份试卷')
        return
      }
      const query = this.scopeQuery({ limit: this.queryParams.limit })
      this.loading = true
      let chainedReload = false
      const tasks = [
        summaryStudent(studentId, this.scopeQuery()),
        radarStudent(studentId, query),
        trendStudent(studentId, this.scopeQuery()),
        weakTopStudent(studentId, query),
        fetchPersistentWeak(studentId, this.scopeQuery())
      ]
      if (this.analysisMode === 'papers') {
        tasks.push(scopeCompareStudent(studentId, Object.assign({ baselineWindow: 'all' }, this.scopeQuery())))
      } else {
        this.scopeCompare = null
      }
      Promise.all(tasks).then((results) => {
        const summaryRes = results[0]
        const radarRes = results[1]
        const trendRes = results[2]
        const weakRes = results[3]
        const persistRes = results[4]
        const compareRes = results[5]
        this.summary = (summaryRes && summaryRes.data) ? summaryRes.data : {}
        // Default subject sort may land on 语文 while this student only has 物理小题数据
        // Skip auto-switch when user chose「所有科目」or manually picked a subject
        // Exception: term-compare focus needs a concrete subject for chapterDelta
        const focusDelta = (this.$route.query || {}).focus === 'chapterDelta'
        if ((focusDelta && this.isAllSubjects && this.summary.suggestedSubjectId != null)
          || (!this.isAllSubjects && this.summary.emptyKnowledge && this.summary.suggestedSubjectId != null && !this.subjectPickedByUser)) {
          const sid = Number(this.summary.suggestedSubjectId)
          if (!isNaN(sid) && sid !== Number(this.queryParams.subjectId)) {
            chainedReload = true
            this.autoSwitchingSubject = true
            this.queryParams.subjectId = sid
            this.queryParams.paperIds = []
            this.loadPapers()
            this.autoSwitchingSubject = false
            return this.loadAnalysis()
          }
        }
        this.buildRadar(this.unwrapList(radarRes))
        this.buildTrend(this.unwrapList(trendRes))
        const weak = this.mergePersistTags(this.unwrapList(weakRes), this.unwrapList(persistRes))
        this.weakList = weak
        this.loadInterveneOverlay()
        this.scopeCompare = compareRes && compareRes.data ? compareRes.data : null
        this.loadChapterRadar()
        this.loadQuestionType()
        this.loadBloom()
        this.loadChapterDelta().then(() => this.focusChapterDeltaIfNeeded())
        this.loadAnnotationCoverage()
        this.buildWeakBar(weak)
        this.loadRankTrend()
      }).catch(() => {
        this.summary = {}
        this.radarOption = {}
        this.trendOption = {}
        this.weakBarOption = {}
        this.weakList = []
        this.scopeCompare = null
        this.clearAdvancedAnalysis()
        this.$modal.msgError('加载学生分析失败')
      }).finally(() => {
        if (!chainedReload) {
          this.loading = false
        }
      })
    },
    buildRadar(list) {
      if (!list.length) {
        this.radarOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } }
        }
        return
      }
      const indicator = list.map(item => ({
        name: item.name || item.knowledgeName || '-',
        max: 100
      }))
      const values = list.map(item => this.toPercent(item.rate != null ? item.rate : item.weightedRate))
      const classValues = list.map(item => {
        if (item.classAvgRate == null && item.classRate == null) return null
        return this.toPercent(item.classAvgRate != null ? item.classAvgRate : item.classRate)
      })
      const hasClass = classValues.some(v => v != null)
      const seriesData = [{ value: values, name: '本人' }]
      if (hasClass) {
        seriesData.push({
          value: classValues.map(v => (v == null ? 0 : v)),
          name: '班级均值',
          lineStyle: { type: 'dashed' },
          areaStyle: { opacity: 0.08 }
        })
      }
      this.radarOption = {
        color: ['#2442ED', '#94A3B8'],
        tooltip: {},
        legend: hasClass ? { data: ['本人', '班级均值'], bottom: 0 } : undefined,
        radar: { indicator, radius: '62%', center: ['50%', '48%'] },
        series: [{ type: 'radar', areaStyle: { opacity: 0.25 }, data: seriesData }]
      }
    },
    buildTrend(list) {
      if (!list.length) {
        this.trendOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } }
        }
        return
      }
      const sorted = list.slice().sort((a, b) => {
        const da = a.examDate || a.paperDate || ''
        const db = b.examDate || b.paperDate || ''
        return String(da).localeCompare(String(db))
      })
      const xData = sorted.map(item => item.paperName || item.name || item.examDate || '-')
      const yData = sorted.map(item => this.toPercent(item.totalRate != null ? item.totalRate : item.avgRate != null ? item.avgRate : item.rate))
      const classData = sorted.map(item => item.classAvgRate == null ? null : this.toPercent(item.classAvgRate))
      const hasClass = classData.some(v => v != null)
      const series = [{
        name: '本人',
        type: 'line',
        smooth: true,
        data: yData,
        itemStyle: { color: '#2442ED' },
        lineStyle: { color: '#2442ED' },
        areaStyle: { opacity: 0.12, color: 'rgba(36, 66, 237, 0.18)' },
        markLine: {
          silent: true,
          data: [{ yAxis: 60, name: '参考线60%' }]
        }
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
        grid: { left: '3%', right: '4%', bottom: hasClass ? 36 : 8, top: 40, containLabel: true },
        xAxis: {
          type: 'category',
          data: xData,
          axisLabel: { rotate: xData.length > 6 ? 30 : 0, interval: 0 }
        },
        yAxis: {
          type: 'value',
          name: '整卷得分率(%)',
          min: 0,
          max: 100
        },
        series
      }
    },
    buildWeakBar(list) {
      if (!list.length) {
        this.weakBarOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#64748B', fontSize: 14 } }
        }
        return
      }
      const names = list.map(item => item.name || item.knowledgeName || '-').reverse()
      const rates = list.map(item => this.toPercent(item.rate != null ? item.rate : item.weightedRate)).reverse()
      this.weakBarOption = {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '6%', bottom: '3%', top: 20, containLabel: true },
        xAxis: { type: 'value', name: '%', max: 100 },
        yAxis: { type: 'category', data: names },
        series: [{
          name: '加权得分率',
          type: 'bar',
          data: rates,
          barMaxWidth: 28,
          itemStyle: {
            color: params => {
              const v = params.value
              if (v < 45) return '#FF5A5F'
              if (v < 60) return '#D97706'
              if (v < 75) return '#CA8A04'
              return '#10B981'
            }
          },
          label: { show: true, position: 'right', formatter: '{c}%' }
        }]
      }
    }
  }
}
</script>

<style scoped>
.spas-analysis >>> .el-form--inline .class-row.el-form-item {
  display: flex;
  width: 100%;
  margin-right: 0;
}
.bound-class-wrap {
  display: inline-flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  min-height: 32px;
}
.bound-class-name {
  font-size: 14px;
  font-weight: 600;
  color: #2C2940;
  line-height: 32px;
}
.bound-class-switch {
  margin-left: 4px;
}
.spas-analysis .chart-card {
  margin-bottom: 0;
}
.spas-analysis .card-header {
  font-weight: 600;
  color: #0F172A;
}
.spas-analysis .card-sub {
  margin-left: 10px;
  font-weight: 400;
  font-size: 12px;
  color: #64748B;
}
.spas-analysis .el-card {
  border-radius: 14px;
}
.overview-row {
  margin-bottom: 8px;
}
.stat-card {
  background: #fff;
  border: 1px solid #E2E8F0;
  border-radius: 10px;
  padding: 14px 16px;
  margin-bottom: 12px;
  border-left: 3px solid #2442ED;
  box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04), 0 6px 16px rgba(15, 23, 42, 0.04);
}
.stat-card.tone-blue { border-left-color: #2442ED; }
.stat-card.tone-orange { border-left-color: #D97706; }
.stat-card.tone-green { border-left-color: #10B981; }
.stat-card.tone-red { border-left-color: #FF5A5F; }
.stat-card.tone-purple { border-left-color: #0E7490; }
.stat-label {
  color: #64748B;
  font-size: 12px;
  letter-spacing: 0.03em;
  font-weight: 600;
}
.stat-value {
  margin-top: 8px;
  font-size: 24px;
  font-weight: 700;
  color: #0F172A;
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.02em;
  line-height: 1.15;
}
.stat-hint {
  margin-top: 4px;
  color: #94A3B8;
  font-size: 11px;
}
.mb8 { margin-bottom: 8px; }
.mb4 { margin-bottom: 4px; }
.error-quick-tags .el-button {
  margin: 0 2px 2px 0;
  padding: 4px 6px;
}
</style>
