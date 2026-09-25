<template>
  <div class="app-container spas-analysis">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
      <el-form-item label="班级" prop="deptId" class="class-row">
        <template v-if="boundClassMode">
          <div class="bound-class-wrap">
            <span class="bound-class-name">{{ currentDeptName || '未绑定班级' }}</span>
            <el-tag v-if="boundClassRoleLabel" size="mini" type="info" class="bound-class-role">{{ boundClassRoleLabel }}</el-tag>
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
          placeholder="请选择班级/部门"
          style="width: 240px"
        />
      </el-form-item>
      <el-form-item label="学科" prop="subjectId">
        <el-select
          v-model="queryParams.subjectId"
          placeholder="请选择学科"
          clearable
          filterable
          style="width: 180px"
          @change="onSubjectChange"
        >
          <el-option
            v-for="item in subjectOptions"
            :key="item.subjectId"
            :label="item.subjectName"
            :value="item.subjectId"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" v-hasPermi="['spas:analysis:class']">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        <el-button type="text" size="mini" icon="el-icon-setting" @click="showAdvancedScope = !showAdvancedScope">
          {{ showAdvancedScope ? '收起口径' : '高级口径' }}
        </el-button>
      </el-form-item>
      <template v-if="showAdvancedScope">
            <el-form-item label="模式" prop="analysisMode">
        <el-radio-group v-model="analysisMode" size="mini" @change="onModeChange">
          <el-radio-button label="window">时间窗</el-radio-button>
          <el-radio-button label="papers">选卷诊断</el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item v-if="analysisMode === 'window'" label="时间窗" prop="window">
        <el-select v-model="queryParams.window" style="width: 140px">
          <el-option label="本学期(默认)" value="semester" />
          <el-option label="上学期" value="prev_semester" />
          <el-option label="近30天" value="last30d" />
          <el-option label="近90天" value="last90d" />
          <el-option label="全部(快照)" value="all" />
        </el-select>
        <div v-if="prevSemesterLabel" class="stat-hint" style="margin-top:4px;line-height:1.3">上学期窗：{{ prevSemesterLabel }}</div>
      </el-form-item>
      <el-form-item v-else label="考试集合" prop="paperIds">
        <el-select
          v-model="queryParams.paperIds"
          multiple
          filterable
          collapse-tags
          clearable
          placeholder="勾选多场已发布试卷"
          style="width: 320px"
          :disabled="!queryParams.subjectId"
        >
          <el-option
            v-for="item in paperOptions"
            :key="item.paperId"
            :label="paperLabel(item)"
            :value="item.paperId"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="近因">
        <el-switch v-model="useRecency" active-text="衰减" inactive-text="关闭" />
      </el-form-item>
      </template>
      <el-form-item>
        <el-button
          type="warning"
          plain
          icon="el-icon-refresh-right"
          size="mini"
          :loading="recalcLoading"
          :disabled="!queryParams.deptId"
          @click="handleRecalcDept"
          v-hasPermi="['spas:analysis:class']"
        >按新算法重算</el-button>
        <el-button
          type="success"
          plain
          icon="el-icon-download"
          size="mini"
          :disabled="!queryParams.deptId"
          :loading="exportLoading"
          @click="handleExportReport('pdf')"
          v-hasPermi="['spas:report:export']"
        >导出报告</el-button>
        <el-button
          type="primary"
          plain
          icon="el-icon-view"
          size="mini"
          :disabled="!queryParams.deptId"
          :loading="previewLoading"
          @click="openReportPreview"
          v-hasPermi="['spas:report:export']"
        >预览报告</el-button>
        <el-button
          type="info"
          plain
          icon="el-icon-document"
          size="mini"
          :disabled="!queryParams.deptId"
          :loading="exportLoading"
          @click="handleExportReport('xlsx')"
          v-hasPermi="['spas:report:export']"
        >导出明细</el-button>
      </el-form-item>
    </el-form>

    <el-empty v-if="!queryParams.deptId" description="请选择班级后查看班级学情">
      <div class="empty-actions">
        <el-button type="primary" size="mini" v-if="myDepts.length" @click="selectMyDept(preferredDeptId)">选择我的班级</el-button>
        <el-button size="mini" v-if="!boundClassMode" @click="$router.push('/system/dept')">去部门管理</el-button>
      </div>
    </el-empty>

    <template v-else>
      <el-alert
        :title="scopeBanner || analysisHint"
        type="success"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-alert
        v-if="interveneHint"
        :title="interveneHint"
        type="success"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-alert
        v-if="scopeHint"
        :title="scopeHint"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
      />
      <el-alert
        v-if="overview.headline"
        :title="overview.headline"
        :type="overview.emptyKnowledge ? 'warning' : 'info'"
        :closable="false"
        show-icon
        class="mb8"
      >
        <template v-if="overview.emptyKnowledge && suggestedSubjects.length" slot="default">
          <span>可切换到：</span>
          <el-button
            v-for="s in suggestedSubjects"
            :key="'sug-' + s.subjectId"
            type="text"
            size="mini"
            @click="switchToSubject(s.subjectId)"
          >{{ s.subjectName }}</el-button>
        </template>
      </el-alert>
      <el-alert
        v-if="thinSampleHint"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
        :title="thinSampleHint"
      />
      <el-alert
        v-if="analysisMode === 'papers'"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
        :title="'当前为选卷诊断 · ' + (queryParams.paperIds || []).length + ' 场考试；概览/薄弱榜/热力/章节均基于所选试卷集合'"
      />
      <el-alert
        v-if="annotationBlocked || (overview && overview.formalWeakBlocked)"
        type="error"
        :closable="false"
        show-icon
        class="mb8"
        :title="(overview && overview.formalWeakBlockReason) || annotationHint || '选卷标注不足，薄弱结论仅供参考，不得作为正式定级'"
      />
      <el-alert
        v-else-if="annotationHint"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
        :title="annotationHint"
      />
      <el-alert
        type="info"
        :closable="false"
        show-icon
        class="mb8"
        :title="analysisHint"
      />
      <el-row :gutter="16" class="overview-row" v-loading="loading">
        <el-col :xs="12" :sm="8" :md="4" v-for="card in overviewCards" :key="card.key">
          <div class="stat-card" :class="'tone-' + card.tone">
            <div class="stat-label">{{ card.label }}</div>
            <div class="stat-value">{{ card.value }}</div>
            <div class="stat-hint" v-if="card.hint">{{ card.hint }}</div>
          </div>
        </el-col>
      </el-row>

            <el-row :gutter="16" style="margin-top: 8px" v-loading="loading">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card class-trend-card">
            <div slot="header" class="card-header">班级趋势</div>
            <spas-chart :option="classTrendOption" height="360px" />
          </el-card>
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">章节汇总</div>
            <el-alert class="mb8 chapter-formula-tip" type="info" :closable="false" show-icon
              title="章节得分率 = 学生章节率的班均；学生章节率 = attempt-weighted avg(叶子加权率)。覆盖学生=该章有数据的人数；薄弱人数=章节率低于薄弱线（默认60%）的人数（不看出答次数）。" />
            <spas-chart :option="chapterBarOption" height="320px" />
            <el-table :data="chapterRows" empty-text="暂无章节数据" size="mini" max-height="220" style="margin-top: 8px">
              <el-table-column label="章节" min-width="140" :show-overflow-tooltip="true">
                <template slot-scope="scope">{{ scope.row.name || '-' }}</template>
              </el-table-column>
              <el-table-column label="班均得分率" width="110" align="center">
                <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
              </el-table-column>
              <el-table-column label="覆盖学生" prop="studentCount" width="90" align="center" />
              <el-table-column label="薄弱人数" prop="weakCount" width="90" align="center" />
            </el-table>
          </el-card>
        </el-col>
      </el-row>

      <el-row :gutter="16" style="margin-top: 8px" v-loading="loading">
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">
              题型表现
              <span v-if="questionTypeSummary.coverageRate != null" class="card-sub">覆盖率 {{ formatPct(questionTypeSummary.coverageRate) }} · 未标注 {{ questionTypeSummary.unlabeledCount != null ? questionTypeSummary.unlabeledCount : 0 }}</span>
            </div>
            <el-alert
              class="mb8"
              type="info"
              :closable="false"
              show-icon
              title="题型得分率 = 该题型下 sum(得分)/sum(满分)（卷面得分池），与知识点加权掌握度不同口径"
            />
            <el-alert
              v-if="questionTypeSummary.coverageRate != null && Number(questionTypeSummary.coverageRate) < 0.6"
              class="mb8"
              type="warning"
              :closable="false"
              show-icon
              title="题型标注覆盖率偏低，结论仅供参考"
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
        </el-col>
        <el-col :xs="24" :lg="12">
          <el-card shadow="never" class="chart-card">
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
              title="认知层级标注覆盖率偏低，请补全卷面 Bloom 标注"
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
        </el-col>
      </el-row>

      <el-card shadow="never" style="margin-top: 16px" class="chart-card" v-loading="loading">
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

<el-row :gutter="16" style="margin-top: 8px" v-loading="loading">
        <el-col :span="24">
          <el-card shadow="never" class="chart-card">
            <div slot="header" class="card-header">班级薄弱知识点 Top</div>
            <spas-chart :option="weakBarOption" height="360px" @chart-click="onWeakBarClick" />
            <el-table :data="weakTopRows" size="mini" empty-text="暂无薄弱知识点" max-height="280" style="margin-top: 12px">
              <el-table-column label="知识点" min-width="140" :show-overflow-tooltip="true">
                <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName || '-' }}</template>
              </el-table-column>
              <el-table-column label="班均" width="90" align="center">
                <template slot-scope="scope">{{ formatRate(scope.row.avgRate != null ? scope.row.avgRate : scope.row.rate) }}</template>
              </el-table-column>
              <el-table-column label="薄弱人数" width="90" align="center">
                <template slot-scope="scope">{{ scope.row.weakStudentCount != null ? scope.row.weakStudentCount : (scope.row.studentCount || '-') }}</template>
              </el-table-column>
              <el-table-column label="根因提示" min-width="160" :show-overflow-tooltip="true">
                <template slot-scope="scope">
                  <span v-if="scope.row.rootHint">{{ scope.row.rootHint }}</span>
                  <span v-else-if="scope.row.dependencyHints && scope.row.dependencyHints.length">{{ formatDependencyHints(scope.row.dependencyHints) }}</span>
                  <span v-else>-</span>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>
      </el-row>

      <el-row :gutter="16" style="margin-top: 8px" v-loading="loading">
        <el-col :span="24">
          <el-card shadow="never" class="chart-card heatmap-card">
            <div slot="header" class="card-header">学生 × 知识点热力图（点击可下钻）</div>
            <spas-chart :option="heatmapOption" :height="heatmapHeight" @chart-click="onHeatmapClick" />
            <div v-if="heatmapLimitHint" class="rank-note heatmap-hint">{{ heatmapLimitHint }}</div>
          </el-card>
        </el-col>
      </el-row>

      <el-card shadow="never" style="margin-top: 16px" v-loading="loading" class="ranking-card">
        <div slot="header" class="card-header">学生综合排名（弱→强，点击可查看学情）</div>
        <div class="rank-note">低分点数按得分率统计（低于60% / 低于45%）。正式薄弱还要求该知识点至少作答 3 题；样本不够时不记入正式薄弱，避免把单题偶然低分判成薄弱。作答题数按去重题目计，一题多知识点不重复累计。</div>
        <el-table :data="studentRanking" empty-text="暂无数据" max-height="360" style="width: 100%" @row-click="onRankingClick">
          <el-table-column type="index" label="#" width="55" align="center" />
          <el-table-column label="学号" prop="studentNo" min-width="120" show-overflow-tooltip />
          <el-table-column label="姓名" prop="studentName" min-width="100" show-overflow-tooltip />
          <el-table-column label="综合得分率" min-width="120" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.overallRate) }}</template>
          </el-table-column>
          <el-table-column label="低分点数" min-width="150" align="center">
            <template slot-scope="scope">
              <span :title="'得分率低于60%的知识点数'">{{ num(scope.row.lowRateCount) }}</span>
              <el-tag v-if="showThinSample(scope.row)" size="mini" type="info" style="margin-left: 6px">样本不足</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="低于45%" min-width="100" align="center">
            <template slot-scope="scope">{{ num(scope.row.lowSevereCount) }}</template>
          </el-table-column>
          <el-table-column label="正式薄弱" min-width="100" align="center">
            <template slot-scope="scope">
              <span :title="'低于60%且该知识点作答不少于3题'">{{ num(scope.row.weakKnowledgeCount) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="正式严重" min-width="100" align="center">
            <template slot-scope="scope">
              <span :title="'低于45%且该知识点作答不少于3题'">{{ num(scope.row.severeKnowledgeCount) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="作答题数" min-width="110" align="center">
            <template slot-scope="scope">
              <span :title="'按去重题目计（一题多知识点不重复累计）'">{{ scope.row.totalAttempts != null ? scope.row.totalAttempts : '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="90" align="center" fixed="right">
            <template slot-scope="scope">
              <el-button type="text" size="mini" @click.stop="goStudent(scope.row)" v-hasPermi="['spas:analysis:student']">学情</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-card shadow="never" style="margin-top: 16px" v-loading="loading">
        <div slot="header" class="card-header">知识点掌握明细</div>
        <el-table :data="knowledgeRows" empty-text="暂无数据" max-height="420">
          <el-table-column label="知识点" min-width="160" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName || '-' }}</template>
          </el-table-column>
          <el-table-column label="班均得分率" width="120" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
          </el-table-column>
          <el-table-column label="置信度" width="100" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="confidenceTagType(scope.row)">{{ confidenceText(scope.row) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="参与人数" prop="studentCount" width="100" align="center" />
          <el-table-column label="反复薄弱人数" prop="persistentStudentCount" width="110" align="center" />
          <el-table-column label="关注" prop="watchCount" width="80" align="center" />
          <el-table-column label="薄弱" prop="weakCount" width="80" align="center" />
          <el-table-column label="严重" prop="severeCount" width="80" align="center" />
          <el-table-column label="操作" width="130" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click="goKnowledge(scope.row)">下钻</el-button>
              <el-button size="mini" type="text" @click="openKpTrend(scope.row)">场次</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </template>

    <el-drawer title="班级报告预览" :visible.sync="previewOpen" size="560px" append-to-body>
      <div v-loading="previewLoading" style="padding: 0 16px 16px;">
        <div class="card-header mb8">概览</div>
        <p v-if="previewData.scopeLabel" class="stat-hint">分析口径：{{ previewData.scopeLabel }}</p>
        <p v-if="previewData.headline">{{ previewData.headline }}</p>
        <p v-else class="stat-hint">暂无预览摘要</p>
        <div class="card-header mb8" style="margin-top:12px">薄弱知识点 Top</div>
        <el-table :data="previewWeakTop" size="mini" empty-text="暂无数据" max-height="200">
          <el-table-column label="知识点" min-width="140">
            <template slot-scope="scope">{{ scope.row.name || scope.row.knowledgeName || '-' }}</template>
          </el-table-column>
          <el-table-column label="班均" width="90" align="center">
            <template slot-scope="scope">{{ formatRate(scope.row.avgRate != null ? scope.row.avgRate : scope.row.rate) }}</template>
          </el-table-column>
          <el-table-column label="根因" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">{{ scope.row.rootHint || '-' }}</template>
          </el-table-column>
        </el-table>
        <template v-if="previewQuestionType.length">
          <div class="card-header mb8" style="margin-top:12px">题型表现</div>
          <el-table :data="previewQuestionType" size="mini" empty-text="-" max-height="140">
            <el-table-column label="题型" min-width="100">
              <template slot-scope="scope">{{ scope.row.typeName || scope.row.typeCode || '-' }}</template>
            </el-table-column>
            <el-table-column label="得分率" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
            </el-table-column>
          </el-table>
        </template>
        <template v-if="previewBloom.length">
          <div class="card-header mb8" style="margin-top:12px">能力层级</div>
          <el-alert v-if="previewBloomInsight" class="mb8" type="info" :closable="false" show-icon :title="previewBloomInsight" />
          <el-table :data="previewBloom" size="mini" empty-text="-" max-height="140">
            <el-table-column label="层级" min-width="100">
              <template slot-scope="scope">{{ scope.row.bloomLabel || scope.row.bloomLevel || '-' }}</template>
            </el-table-column>
            <el-table-column label="得分率" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.avgRate) }}</template>
            </el-table-column>
          </el-table>
        </template>
        <template v-if="previewChapterRows.length">
          <div class="card-header mb8" style="margin-top:12px">章节进退</div>
          <el-alert v-if="previewChapterHeadline" class="mb8" type="info" :closable="false" show-icon :title="previewChapterHeadline" />
          <el-table :data="previewChapterRows" size="mini" empty-text="-" max-height="140">
            <el-table-column label="章节" min-width="120" :show-overflow-tooltip="true">
              <template slot-scope="scope">{{ scope.row.chapterName || '-' }}</template>
            </el-table-column>
            <el-table-column label="变化" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.deltaRate) }}</template>
            </el-table-column>
          </el-table>
        </template>
        <div style="margin-top: 16px; text-align: right;">
          <el-button type="primary" size="mini" :loading="exportLoading" @click="handleExportReport('pdf')" v-hasPermi="['spas:report:export']">下载 PDF</el-button>
          <el-button size="mini" :loading="exportLoading" @click="handleExportReport('xlsx')" v-hasPermi="['spas:report:export']">下载 Excel</el-button>
        </div>
      </div>
    </el-drawer>

    <el-drawer :title="kpTrendTitle" :visible.sync="kpTrendOpen" size="520px" append-to-body>
      <div v-loading="kpTrendLoading" style="padding: 0 16px 16px;">
        <el-alert
          v-if="kpTrendLowCount > 0"
          type="warning"
          :closable="false"
          show-icon
          class="mb8"
          :title="'班均&lt;60%的场次：' + kpTrendLowCount + ' 场'"
        />
        <spas-chart :option="kpTrendOption" height="280px" />
        <el-table :data="kpTrendRows" size="mini" max-height="280" style="margin-top: 12px">
          <el-table-column label="试卷" prop="paperName" min-width="140" :show-overflow-tooltip="true" />
          <el-table-column label="日期" width="110" align="center">
            <template slot-scope="scope">{{ scope.row.examDate ? String(scope.row.examDate).substring(0, 10) : '-' }}</template>
          </el-table-column>
          <el-table-column label="班均" width="90" align="center">
            <template slot-scope="scope"><span :style="{ color: Number(scope.row.avgRate) < 0.6 ? '#FF5A5F' : '#10B981', fontWeight: 600 }">{{ formatRate(scope.row.avgRate) }}</span></template>
          </el-table-column>
          <el-table-column label="偏低人数" prop="weakStudentCount" width="90" align="center" />
        </el-table>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import { classInterveneSummary } from '@/api/spas/intervene'
import { weakTopClass, heatmapClass, overviewClass, recalcDept, trendClass, chapterOverviewClass, analysisConfig, paperAnnotationCoverage, classKnowledgeExamTrend, questionTypeClass, bloomClass, chapterDeltaClass } from '@/api/spas/analysis'
import { previewClassReport } from '@/api/spas/report'
import { optionselectSubject } from '@/api/spas/subject'
import { listPaper } from '@/api/spas/paper'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
import { applyTeachingDeptContext, canLoadSystemDeptTree } from '@/utils/spasDeptTree'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import SpasChart from '@/components/spas/charts/SpasChart'
import { buildScopeBanner } from '@/utils/spasAnalysisScope'
import { boundClassRoleFromDepts } from '@/utils/spasTeacherRole'

export default {
  name: 'SpasAnalysisClass',
  components: { Treeselect, SpasChart },
  data() {
    return {
      loading: false,
      recalcLoading: false,
      exportLoading: false,
      previewLoading: false,
      previewOpen: false,
      previewData: {},
      classTrend: [],
      chapterRows: [],
      questionTypeItems: [],
      questionTypeSummary: {},
      bloomItems: [],
      bloomSummary: {},
      bloomInsight: '',
      chapterDelta: { items: [], improved: [], declined: [], headline: '', baselineWindow: '', baselineHint: '', baselineEmpty: false },
      subjectOptions: [],
      deptOptions: [],
      myDepts: [],
      overview: {},
      interveneSummary: null,
      knowledgeRows: [],
      kpTrendOpen: false,
      kpTrendLoading: false,
      kpTrendTitle: '',
      kpTrendRows: [],
      kpTrendOption: {},
      studentRanking: [],
      weakTopRows: [],
      heatStudents: [],
      heatKnowledges: [],
      weakBarOption: {},
      heatmapOption: {},
      useRecency: true,
      showAdvancedScope: false,
      defaultWindow: 'semester',
      analysisMode: 'window',
      paperOptions: [],
      annotationHint: '',
      annotationBlocked: false,
      unboundRatioThreshold: 0.20,
      prevSemesterLabel: '',
      subjectPickedByUser: false,
      autoSwitchingSubject: false,
      heatmapLimitHint: '',
      recencyHalfLifeDays: 60,
      queryParams: {
        window: 'semester',
        deptId: undefined,
        subjectId: undefined,
        paperIds: [],
        limit: 10
      }
    }
  },
  watch: {
    'queryParams.deptId'(val, oldVal) {
      if (val !== oldVal) {
        this.subjectPickedByUser = false
      }
    }
  },
  computed: {
    suggestedSubjects() {
      const list = (this.overview && this.overview.subjectsWithData) || []
      return Array.isArray(list) ? list : []
    },
    thinSampleHint() {
      const o = this.overview || {}
      if (o.emptyKnowledge) return ''
      const thin = Number(o.thinSampleStudentCount || 0)
      const formal = Number(o.weakStudentCount || 0)
      if (thin > 0 && formal <= 0) {
        return '有 ' + thin + ' 名学生存在低分知识点，但作答不足 3 题，未计入正式薄弱；请看「综合低分」与排名表中的低分点数。'
      }
      return ''
    },
    heatmapHeight() {
      const n = (this.heatStudents || []).length
      if (!n) return '320px'
      // Legend on top + rotated x labels + readable row height
      const rowH = n > 40 ? 13 : (n > 24 ? 15 : 17)
      const h = 48 + 64 + n * rowH
      return Math.max(300, Math.min(520, h)) + 'px'
    },
    boundClassMode() {
      // Teachers with assigned classes: show class name, not dept tree.
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
    kpTrendLowCount() {
      return (this.kpTrendRows || []).filter(r => r.low || Number(r.avgRate) < 0.6).length
    },
    scopeHint() {
      const id = this.queryParams.deptId
      if (!id) return ''
      if (this.boundClassMode) {
        return '当前为班级范围（仅本班）'
      }
      const node = this.findDeptNode(this.deptOptions, id)
      if (!node) return ''
      const hasChild = !!(node.children && node.children.length)
      return hasChild
        ? '当前为年级/校级范围，统计含下级班级'
        : '当前为班级范围（仅本班）'
    },
    interveneHint() {
      const s = this.interveneSummary
      if (!s) return ''
      const open = Number(s.openCount || 0)
      const passed = Number(s.passedCount || 0)
      const overdue = Number(s.overdueCount || 0)
      if (!open && !passed && !overdue) return ''
      let delta = ''
      if (s.avgDelta != null && s.avgDelta !== '') {
        const n = Number(s.avgDelta)
        if (!isNaN(n)) {
          const pct = Math.abs(n) <= 1 ? n * 100 : n
          delta = '，平均 Δ ' + (pct >= 0 ? '+' : '') + pct.toFixed(1) + '%'
        }
      }
      return '本班干预：进行中 ' + open + '，已达标 ' + passed + '，逾期 ' + overdue + delta
    },
    analysisHint() {
      return this.scopeBanner
    },
    scopeBanner() {
      return buildScopeBanner({
        analysisMode: this.analysisMode,
        window: this.queryParams.window,
        defaultWindow: this.defaultWindow || 'semester',
        paperIds: this.queryParams.paperIds,
        useRecency: this.useRecency,
        dataMode: this.overview && this.overview.dataMode,
        calcTime: this.overview && (this.overview.lastCalcTime || this.overview.calcTime)
      })
    },
    classTrendOption() {
      const rows = this.classTrend || []
      const dates = rows.map(r => r.examDate || r.paperName || '-')
      const avgs = rows.map(r => {
        const v = Number(r.classAvgRate)
        if (isNaN(v)) return 0
        return v <= 1 ? +(v * 100).toFixed(1) : +v.toFixed(1)
      })
      const weaks = rows.map(r => {
        const v = Number(r.weakStudentRatio)
        if (isNaN(v)) return 0
        return v <= 1 ? +(v * 100).toFixed(1) : +v.toFixed(1)
      })
      return {
        tooltip: { trigger: 'axis' },
        legend: { data: ['班均', '薄弱占比'] },
        grid: { left: 40, right: 40, top: 40, bottom: 40 },
        xAxis: { type: 'category', data: dates, axisLabel: { rotate: 30 } },
        yAxis: [
          { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } },
          { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } }
        ],
        series: [
          { name: '班均', type: 'line', data: avgs },
          { name: '薄弱占比', type: 'line', yAxisIndex: 1, data: weaks }
        ]
      }
    },
    chapterBarOption() {
      const rows = this.chapterRows || []
      const names = rows.map(r => r.name || '-')
      const rates = rows.map(r => {
        const v = Number(r.avgRate)
        if (isNaN(v)) return 0
        return v <= 1 ? +(v * 100).toFixed(1) : +v.toFixed(1)
      })
      const longLabel = names.some(n => String(n).length > 4) || names.length > 4
      return {
        tooltip: { trigger: 'axis' },
        grid: { left: 40, right: 20, top: 30, bottom: longLabel ? 8 : 20, containLabel: true },
        xAxis: {
          type: 'category',
          data: names,
          axisLabel: {
            interval: 0,
            rotate: longLabel ? 36 : 0,
            fontSize: 11,
            hideOverlap: false,
            formatter: v => {
              const s = String(v || '')
              return s.length > 10 ? s.slice(0, 10) + '…' : s
            }
          }
        },
        yAxis: { type: 'value', max: 100, axisLabel: { formatter: '{value}%' } },
        series: [{ type: 'bar', data: rates, name: '章节班均', barMaxWidth: 28, label: { show: names.length <= 12, position: 'top', formatter: '{c}%', fontSize: 10 } }]
      }
    },
    overviewCards() {
      const o = this.overview || {}
      const avg = o.avgRate != null ? o.avgRate : o.averageRate
      const weakStudents = o.weakStudentCount != null ? o.weakStudentCount : o.weakCount
      const lowRateStudents = o.lowRateStudentCount
      const studentCount = o.studentCount != null ? o.studentCount : o.totalStudents
      const knowledgeCount = o.knowledgeCount != null ? o.knowledgeCount : o.weakKnowledgeCount
      const severeStudents = o.severeStudentCount
      const thin = o.thinSampleStudentCount
      let weakHint = '作答≥3 且薄弱/严重'
      if (severeStudents != null && Number(severeStudents) > 0) {
        weakHint = '含严重 ' + severeStudents
      } else if (thin != null && Number(thin) > 0 && Number(weakStudents || 0) <= 0) {
        weakHint = Number(thin) + ' 人样本不足未定级'
      }
      return [
        {
          key: 'avg',
          label: '班均得分率',
          value: avg != null ? this.formatRate(avg) : '-',
          hint: '学生综合率再平均',
          tone: 'blue'
        },
        {
          key: 'weakStu',
          label: '正式薄弱',
          value: weakStudents != null ? weakStudents : '-',
          hint: weakHint,
          tone: 'orange'
        },
        {
          key: 'lowStu',
          label: '综合低分',
          value: lowRateStudents != null ? lowRateStudents : '-',
          hint: '综合得分率低于60%',
          tone: 'red'
        },
        {
          key: 'stu',
          label: '学生人数',
          value: studentCount != null ? studentCount : '-',
          hint: '本班参与统计',
          tone: 'green'
        },
        {
          key: 'know',
          label: '薄弱知识点',
          value: knowledgeCount != null ? knowledgeCount : '-',
          hint: '班均偏低或有薄弱人数',
          tone: 'orange'
        }
      ]
    },
    previewOverview() {
      return (this.previewData && this.previewData.overview) || null
    },
    previewWeakTop() {
      const w = this.previewData && this.previewData.weakTop
      return Array.isArray(w) ? w : []
    },
    previewExamPapers() {
      const w = this.previewData && this.previewData.examPapers
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
    previewChapterRows() {
      const q = this.previewData && this.previewData.chapterDelta
      const improved = (q && q.improved) || []
      const declined = (q && q.declined) || []
      return [].concat(Array.isArray(improved) ? improved : [], Array.isArray(declined) ? declined : [])
    },
    previewChapterHeadline() {
      const q = this.previewData && this.previewData.chapterDelta
      return (q && q.headline) || ''
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.deptId) {
      this.queryParams.deptId = Number(q.deptId) || q.deptId
    }
    if (q.subjectId) {
      this.queryParams.subjectId = Number(q.subjectId) || q.subjectId
    }
    if (q.window) {
      this.queryParams.window = q.window
    }
    this.loadAnalysisConfig()
    Promise.all([this.loadSubjects(), this.loadMyDepts(), this.loadPapers()]).then(() => {
      if (!this.queryParams.deptId && this.preferredDeptId) {
        this.queryParams.deptId = this.preferredDeptId
      }
      if (this.queryParams.deptId) {
        this.loadAnalysis()
      }
    }).catch(() => {})
  },
  methods: {
    onSubjectChange() {
      if (!this.autoSwitchingSubject) {
        this.subjectPickedByUser = true
      }
      this.queryParams.paperIds = []
      this.loadPapers()
      if (this.queryParams.deptId) {
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
      this.queryParams.paperIds = []
      this.loadPapers()
      this.autoSwitchingSubject = false
      this.handleQuery()
    },
    findDeptNode(nodes, id) {
      for (const n of nodes || []) {
        if (n.id === id || n.deptId === id) return n
        const c = this.findDeptNode(n.children, id)
        if (c) return c
      }
      return null
    },
    confidenceText(row) {
      if (row.confidenceLabel) return row.confidenceLabel
      const a = Number(row.attemptCount != null ? row.attemptCount : row.avgAttemptCount)
      if (!a || a < 3) return '样本不足'
      if (a < 6) return '中'
      return '高'
    },
    confidenceTagType(row) {
      const t = this.confidenceText(row)
      if (t === '样本不足') return 'danger'
      if (t === '高') return 'success'
      return 'warning'
    },
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      this.loadAnalysis()
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
    formatRate(rate) {
      if (rate == null || rate === '') {
        return '-'
      }
      return this.toPercent(rate).toFixed(2) + '%'
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
    formatGap(gap) {
      if (gap == null || gap === '') return '-'
      const n = Number(gap)
      if (isNaN(n)) return gap
      const pct = (n <= 1 && n >= -1 ? n * 100 : n)
      const sign = pct > 0 ? '+' : ''
      return sign + pct.toFixed(2) + '%'
    },
    num(v) {
      return v == null || v === '' ? 0 : v
    },
    showThinSample(row) {
      if (!row) return false
      const thin = Number(row.thinSampleCount || 0)
      const formal = Number(row.weakKnowledgeCount || 0)
      return thin > 0 && formal === 0
    },
    rateColor(rate) {
      const p = this.toPercent(rate)
      if (p < 45) return '#F56C6C'
      if (p < 60) return '#E6A23C'
      if (p < 75) return '#F2C94C'
      return '#67C23A'
    },
    goStudent(row) {
      if (!row || !row.studentId) return
      this.$router.push({
        path: '/spas/analysis/student',
        query: {
          studentId: row.studentId,
          deptId: this.queryParams.deptId,
          subjectId: this.queryParams.subjectId
        }
      })
    },
    onRankingClick(row) {
      this.goStudent(row)
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
    unwrapData(res) {
      if (!res) {
        return {}
      }
      return res.data != null ? res.data : res
    },
    loadSubjects() {
      return optionselectSubject().then(response => {
        this.subjectOptions = response.data || []
        if (!this.queryParams.subjectId && this.subjectOptions.length) {
          this.queryParams.subjectId = this.subjectOptions[0].subjectId
        }
      })
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
    openReportPreview() {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      this.previewOpen = true
      this.previewLoading = true
      this.previewData = {}
      previewClassReport(this.queryParams.deptId, this.scopeQuery()).then(res => {
        this.previewData = res.data || {}
      }).catch(() => {
        this.previewData = {}
        this.$modal.msgError('报告预览加载失败')
      }).finally(() => {
        this.previewLoading = false
      })
    },
    handleExportReport(format) {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      const ext = format === 'xlsx' ? 'xlsx' : 'pdf'
      const params = Object.assign({ format: ext }, this.scopeQuery())
      this.exportLoading = true
      this.download(
        'spas/report/class/' + this.queryParams.deptId,
        params,
        `class_report_${this.queryParams.deptId}_${new Date().getTime()}.${ext}`
      ).finally(() => {
        this.exportLoading = false
      })
    },
    handleRecalcDept() {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      const tip = '将按最新算法重算本班（及下级）有成绩学生的知识点快照，并刷新预警。'
        + (this.useRecency ? ('启用近因衰减（半衰期 ' + this.recencyHalfLifeDays + ' 天）。') : '关闭近因衰减。')
        + '确认继续？'
      this.$modal.confirm(tip).then(() => {
        this.recalcLoading = true
        return recalcDept(this.queryParams.deptId, {
          subjectId: this.queryParams.subjectId,
          useRecency: this.useRecency
        })
      }).then(res => {
        const d = (res && res.data) || {}
        this.$modal.msgSuccess('重算完成：学生 ' + (d.studentCount != null ? d.studentCount : 0)
          + ' 人，快照 ' + (d.statRows != null ? d.statRows : 0)
          + ' 条，新增预警 ' + (d.warningCreated != null ? d.warningCreated : 0)
          + (d.interveneAsync ? '（干预评估已异步排队）' : ''))
        this.loadAnalysis()
      }).catch(() => {}).finally(() => {
        this.recalcLoading = false
      })
    },
    loadAnalysisConfig() {
      return analysisConfig().then(res => {
        const cfg = (res && res.data) || {}
        if (cfg.defaultWindow && !this.$route.query.window) {
          this.queryParams.window = cfg.defaultWindow
        }
        if (cfg.recencyHalfLifeDays != null) {
          this.recencyHalfLifeDays = Number(cfg.recencyHalfLifeDays) || 60
          this.useRecency = this.recencyHalfLifeDays > 0
        }
        const annot = cfg.annotationCoverage || {}
        if (annot.unboundRatioThreshold != null) {
          this.unboundRatioThreshold = Number(annot.unboundRatioThreshold) || 0.20
        }
        const prev = cfg.prevSemester || {}
        this.prevSemesterLabel = prev.label || ''
      }).catch(() => {})
    },
    resetQuery() {
      this.queryParams.deptId = undefined
      this.overview = {}
      this.knowledgeRows = []
      this.heatStudents = []
      this.heatKnowledges = []
      this.weakBarOption = {}
      this.heatmapOption = {}
      this.clearAdvancedAnalysis()
      this.loadSubjects()
    },
    clearAdvancedAnalysis() {
      this.questionTypeItems = []
      this.questionTypeSummary = {}
      this.bloomItems = []
      this.bloomSummary = {}
      this.bloomInsight = ''
      this.chapterDelta = { items: [], improved: [], declined: [], headline: '', baselineWindow: '', baselineHint: '', baselineEmpty: false }
      this.chapterRows = []
      this.classTrend = []
    },
    loadClassTrend() {
      return trendClass(this.queryParams.deptId, this.scopeQuery()).then(res => {
        const data = (res && res.data != null) ? res.data : res
        this.classTrend = Array.isArray(data) ? data : []
      }).catch(() => { this.classTrend = [] })
    },
    loadChapterOverview() {
      return chapterOverviewClass(this.queryParams.deptId, this.scopeQuery()).then(res => {
        const data = (res && res.data != null) ? res.data : res
        this.chapterRows = (data && data.chapters) ? data.chapters : []
      }).catch(() => { this.chapterRows = [] })
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
      if (!this.queryParams.deptId) {
        this.questionTypeItems = []
        this.questionTypeSummary = {}
        return Promise.resolve()
      }
      return questionTypeClass(this.queryParams.deptId, this.scopeQuery()).then(res => {
        this.applyDimPayload(res, 'questionTypeItems', 'questionTypeSummary')
      }).catch(() => {
        this.questionTypeItems = []
        this.questionTypeSummary = {}
      })
    },
    loadBloom() {
      if (!this.queryParams.deptId) {
        this.bloomItems = []
        this.bloomSummary = {}
        this.bloomInsight = ''
        return Promise.resolve()
      }
      return bloomClass(this.queryParams.deptId, this.scopeQuery()).then(res => {
        this.applyDimPayload(res, 'bloomItems', 'bloomSummary')
      }).catch(() => {
        this.bloomItems = []
        this.bloomSummary = {}
        this.bloomInsight = ''
      })
    },
    loadChapterDelta() {
      if (!this.queryParams.deptId) {
        this.chapterDelta = { items: [], improved: [], declined: [], headline: '', baselineWindow: '', baselineHint: '', baselineEmpty: false }
        return Promise.resolve()
      }
      return chapterDeltaClass(this.queryParams.deptId, this.scopeQuery({ baselineWindow: 'prev_semester' })).then(res => {
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
    loadAnnotationCoverage() {
      if (this.analysisMode !== 'papers' || !this.queryParams.paperIds || !this.queryParams.paperIds.length) {
        this.annotationHint = ''
        this.annotationBlocked = false
        return Promise.resolve()
      }
      return paperAnnotationCoverage({ paperIds: this.queryParams.paperIds.join(',') }).then(res => {
        const d = (res && res.data) || {}
        const unbound = Number(d.unboundCount || 0)
        const total = Number(d.questionCount || 0)
        const ratio = Number(d.unboundRatio || 0)
        const thr = Number(this.unboundRatioThreshold) || 0.20
        this.annotationBlocked = total > 0 && ratio > thr
        if (this.annotationBlocked) {
          this.annotationHint = '未标注占比 ' + Math.round(ratio * 1000) / 10 + '%（阈值 ' + Math.round(thr * 100) + '%），'
            + unbound + '/' + total + ' 题未标知识点：禁止正式薄弱定级，结论仅供参考。'
        } else if (total > 0 && unbound > 0) {
          this.annotationHint = '所选试卷有 ' + unbound + '/' + total + ' 题未标注知识点（'
            + Math.round(ratio * 1000) / 10 + '%），薄弱结论可能偏差，建议先补齐标注。'
          this.annotationBlocked = false
        } else {
          this.annotationHint = ''
          this.annotationBlocked = false
        }
        const noType = Number(d.noTypeCount || 0)
        const noBloom = Number(d.noBloomCount || 0)
        const metaParts = []
        if (noType > 0) metaParts.push(noType + ' 题缺题型')
        if (noBloom > 0) metaParts.push(noBloom + ' 题缺认知层级')
        if (metaParts.length) {
          this.annotationHint = (this.annotationHint ? this.annotationHint + '；' : '') + metaParts.join('，') + '（题型/能力层分析将记为未标注）'
        }
      }).catch(() => {
        this.annotationHint = ''
        this.annotationBlocked = false
      })
    },
    loadInterveneSummary() {
      if (!this.queryParams.deptId) {
        this.interveneSummary = null
        return
      }
      classInterveneSummary(this.queryParams.deptId, { subjectId: this.queryParams.subjectId }).then(res => {
        this.interveneSummary = (res && res.data) || null
      }).catch(() => { this.interveneSummary = null })
    },
    loadAnalysis() {
      const deptId = this.queryParams.deptId
      if (!deptId) return
      if (this.analysisMode === 'papers' && (!this.queryParams.paperIds || !this.queryParams.paperIds.length)) {
        this.$modal.msgWarning('选卷诊断请至少勾选一份试卷')
        return
      }
      const query = this.scopeQuery({ limit: this.queryParams.limit })
      this.loading = true
      let chainedReload = false
      Promise.all([
        overviewClass(deptId, query),
        weakTopClass(deptId, query),
        heatmapClass(deptId, query)
      ]).then(([overviewRes, weakRes, heatRes]) => {
        const ov = this.unwrapData(overviewRes) || {}
        this.overview = ov
        // Default subject sort may land on 语文 while this class only has 物理小题数据
        if (ov.emptyKnowledge && ov.suggestedSubjectId != null && !this.subjectPickedByUser) {
          const sid = Number(ov.suggestedSubjectId)
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
        this.knowledgeRows = Array.isArray(ov.knowledges) ? ov.knowledges : (Array.isArray(ov) ? ov : [])
        this.studentRanking = Array.isArray(ov.studentRanking) ? ov.studentRanking : []
        this.loadClassTrend()
        this.loadChapterOverview()
        this.loadQuestionType()
        this.loadBloom()
        this.loadChapterDelta()
        this.loadAnnotationCoverage()
        this.loadInterveneSummary()
        this.buildWeakBar(this.unwrapList(weakRes))
        this.buildHeatmap(this.unwrapData(heatRes) || {})
      }).catch(() => {
        this.overview = {}
        this.knowledgeRows = []
        this.studentRanking = []
        this.weakBarOption = {}
        this.heatmapOption = {}
        this.heatmapLimitHint = ''
        this.clearAdvancedAnalysis()
        this.$modal.msgError('加载班级分析失败')
      }).finally(() => {
        if (!chainedReload) {
          this.loading = false
        }
      })
    },
    scopeQuery(extra) {
      const q = Object.assign({
        subjectId: this.queryParams.subjectId,
        useRecency: this.useRecency
      }, extra || {})
      if (this.analysisMode === 'papers') {
        q.paperIds = (this.queryParams.paperIds || []).join(',')
      } else {
        q.window = this.queryParams.window
      }
      return q
    },
    onModeChange() {
      if (this.analysisMode === 'papers') {
        this.loadPapers()
      }
      if (this.queryParams.deptId) {
        this.handleQuery()
      }
    },
    paperLabel(item) {
      const date = item.examDate ? String(item.examDate).substring(0, 10) : ''
      return (item.paperName || ('试卷' + item.paperId)) + (date ? (' · ' + date) : '')
    },
    loadPapers() {
      const query = { pageNum: 1, pageSize: 200, status: '1' }
      if (this.queryParams.subjectId) {
        query.subjectId = this.queryParams.subjectId
      }
      return listPaper(query).then(res => {
        this.paperOptions = res.rows || []
      }).catch(() => {
        this.paperOptions = []
      })
    },
    handleQuery() {
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      if (this.analysisMode === 'papers' && (!this.queryParams.paperIds || !this.queryParams.paperIds.length)) {
        this.$modal.msgWarning('选卷诊断请至少勾选一份试卷')
        return
      }
      this.loadAnalysis()
    },
    buildWeakBar(list) {
      this.weakTopRows = list || []
      if (!list.length) {
        this.weakBarOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } }
        }
        return
      }
      const names = list.map(item => item.name || item.knowledgeName || '-').reverse()
      const rates = list.map(item => this.toPercent(item.rate != null ? item.rate : item.avgRate != null ? item.avgRate : item.weightedRate)).reverse()
      this.weakBarOption = {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '6%', bottom: '3%', top: 20, containLabel: true },
        xAxis: { type: 'value', name: '%', max: 100 },
        yAxis: { type: 'category', data: names },
        series: [{
          name: '班级平均得分率',
          type: 'bar',
          data: rates.map(r => ({
            value: r,
            itemStyle: { color: this.rateColor(r / 100) }
          })),
          barMaxWidth: 28,
          label: { show: true, position: 'right', formatter: '{c}%' }
        }]
      }
    },
    buildHeatmap(payload) {
      let students = payload.students || []
      let knowledges = payload.knowledges || payload.knowledgeList || []
      let matrix = payload.matrix || []
      this.heatmapLimitHint = ''
      const hints = []
      // Prefer weakest knowledges when too many columns for readable heat map
      const maxKp = 16
      if (knowledges.length > maxKp && matrix.length) {
        const scores = knowledges.map((k, xi) => {
          let sum = 0
          let n = 0
          for (let yi = 0; yi < matrix.length; yi++) {
            const raw = (matrix[yi] || [])[xi]
            if (raw == null || raw === '') continue
            const p = this.toPercent(raw)
            sum += p
            n++
          }
          return { xi, avg: n ? sum / n : 101 }
        })
        scores.sort((a, b) => a.avg - b.avg)
        const keep = scores.slice(0, maxKp).map(s => s.xi).sort((a, b) => a - b)
        knowledges = keep.map(i => knowledges[i])
        matrix = matrix.map(row => keep.map(i => (row || [])[i]))
        hints.push('知识点较多，横轴仅展示班均最低的 ' + maxKp + ' 个')
      }
      // Prefer lowest overall-rate students when rows are too dense
      const maxStu = 36
      if (students.length > maxStu && matrix.length) {
        const scores = students.map((s, yi) => {
          const row = matrix[yi] || []
          let sum = 0
          let n = 0
          for (let xi = 0; xi < row.length; xi++) {
            const raw = row[xi]
            if (raw == null || raw === '') continue
            sum += this.toPercent(raw)
            n++
          }
          return { yi, avg: n ? sum / n : 101 }
        })
        scores.sort((a, b) => a.avg - b.avg)
        const keep = scores.slice(0, maxStu).map(s => s.yi).sort((a, b) => a - b)
        students = keep.map(i => students[i])
        matrix = keep.map(i => matrix[i])
        hints.push('学生较多，纵轴仅展示综合得分较低的 ' + maxStu + ' 人')
      }
      if (hints.length) {
        this.heatmapLimitHint = hints.join('；') + '。完整列表见下方「知识点掌握明细」与「学生综合排名」。'
      }
      this.heatStudents = students
      this.heatKnowledges = knowledges
      if (!students.length || !knowledges.length) {
        this.heatmapOption = {
          title: { text: '暂无数据', left: 'center', top: 'center', textStyle: { color: '#909399', fontSize: 14 } }
        }
        return
      }
      const yLabels = students.map(s => {
        const name = s.name || s.studentName || String(s.id || s.studentId)
        return String(name).length > 5 ? String(name).slice(0, 5) + '…' : name
      })
      const xLabels = knowledges.map(k => {
        const name = k.name || k.knowledgeName || String(k.id || k.knowledgeId)
        return String(name).length > 6 ? String(name).slice(0, 6) + '…' : name
      })
      const xFull = knowledges.map(k => k.name || k.knowledgeName || String(k.id || k.knowledgeId))
      const yFull = students.map(s => s.name || s.studentName || String(s.id || s.studentId))
      const data = []
      for (let yi = 0; yi < matrix.length; yi++) {
        const row = matrix[yi] || []
        for (let xi = 0; xi < knowledges.length; xi++) {
          const raw = row[xi]
          if (raw == null || raw === '') {
            data.push({
              value: [xi, yi, -1],
              itemStyle: { color: '#EBEEF5' },
              label: { show: true, formatter: '无', color: '#C0C4CC' }
            })
          } else {
            data.push([xi, yi, this.toPercent(raw)])
          }
        }
      }
      const showCellLabel = students.length * knowledges.length <= 280
      this.heatmapOption = {
        tooltip: {
          position: 'top',
          formatter: params => {
            const x = xFull[params.value[0]] || ''
            const y = yFull[params.value[1]] || ''
            const v = params.value[2]
            if (v == null || v < 0) {
              return y + '<br/>' + x + '：无数据'
            }
            return y + '<br/>' + x + '：' + v + '%'
          }
        },
        grid: {
          left: 8,
          right: 16,
          top: 40,
          bottom: 8,
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: xLabels,
          splitArea: { show: true },
          axisLabel: {
            rotate: 30,
            interval: 0,
            fontSize: 10,
            hideOverlap: true,
            margin: 8
          }
        },
        yAxis: {
          type: 'category',
          data: yLabels,
          splitArea: { show: true },
          axisLabel: { fontSize: 10, interval: 0, margin: 6 }
        },
        visualMap: {
          type: 'piecewise',
          orient: 'horizontal',
          left: 'center',
          top: 4,
          itemWidth: 12,
          itemHeight: 10,
          textStyle: { fontSize: 11 },
          pieces: [
            { value: -1, label: '无数据', color: '#EBEEF5' },
            { gte: 0, lt: 45, label: '<45%', color: '#F56C6C' },
            { gte: 45, lt: 60, label: '45-60%', color: '#E6A23C' },
            { gte: 60, lt: 75, label: '60-75%', color: '#CA8A04' },
            { gte: 75, lte: 100, label: '>=75%', color: '#67C23A' }
          ]
        },
        series: [{
          name: '得分率',
          type: 'heatmap',
          data,
          label: {
            show: showCellLabel,
            fontSize: 9,
            formatter: p => {
              const v = p.value && p.value[2]
              if (v == null || v < 0) return '无'
              return v
            }
          },
          emphasis: { itemStyle: { shadowBlur: 8, shadowColor: 'rgba(0,0,0,0.25)' } }
        }]
      }
    },
    openKpTrend(row) {
      const knowledgeId = row.knowledgeId || row.id
      if (!knowledgeId || !this.queryParams.deptId) return
      const name = row.knowledgeName || row.name || ('#' + knowledgeId)
      this.kpTrendTitle = name + ' · 班级场次趋势'
      this.kpTrendOpen = true
      this.kpTrendLoading = true
      this.kpTrendRows = []
      this.kpTrendOption = {}
      const q = Object.assign({ knowledgeId }, this.scopeQuery())
      classKnowledgeExamTrend(this.queryParams.deptId, q).then(res => {
        const rows = (res && res.data) || []
        this.kpTrendRows = Array.isArray(rows) ? rows : []
        const names = this.kpTrendRows.map(r => (r.examDate ? String(r.examDate).substring(0, 10) : (r.paperName || '-')))
        const rates = this.kpTrendRows.map(r => this.toPercent(r.avgRate))
        this.kpTrendOption = {
          tooltip: { trigger: 'axis' },
          grid: { left: '3%', right: '4%', bottom: '3%', top: 30, containLabel: true },
          xAxis: { type: 'category', data: names, axisLabel: { rotate: names.length > 5 ? 30 : 0 } },
          yAxis: { type: 'value', name: '%', min: 0, max: 100 },
          series: [{ name: '班均得分率', type: 'line', data: rates, smooth: true,
            markLine: { data: [{ yAxis: 60, name: '60%' }], lineStyle: { color: '#D97706' } } }]
        }
      }).catch(() => {
        this.kpTrendRows = []
        this.kpTrendOption = {}
        this.$modal.msgError('加载知识点场次趋势失败')
      }).finally(() => { this.kpTrendLoading = false })
    },
    goKnowledge(row) {
      const knowledgeId = row && (row.knowledgeId || row.id)
      if (!knowledgeId) return
      this.$router.push({
        path: '/spas/analysis/knowledge',
        query: { knowledgeId, deptId: this.queryParams.deptId, subjectId: this.queryParams.subjectId }
      })
    },
    onWeakBarClick(params) {
      if (!params || params.componentType !== 'series') return
      const name = params.name
      const hit = (this.weakTopRows || []).find(k => (k.name || k.knowledgeName) === name)
        || (this.knowledgeRows || []).find(k => (k.name || k.knowledgeName) === name)
      if (hit) this.goKnowledge(hit)
    },
    onHeatmapClick(params) {
      if (!params || !params.value) return
      const xi = params.value[0]
      const yi = params.value[1]
      const cellVal = params.value[2]
      if (cellVal == null || cellVal < 0) {
        this.$modal.msgWarning('该单元格无数据')
        return
      }
      const student = this.heatStudents[yi]
      const knowledge = this.heatKnowledges[xi]
      this.$confirm('选择下钻目标', '热力图下钻', {
        distinguishCancelAndClose: true,
        confirmButtonText: '查看学生',
        cancelButtonText: '查看知识点'
      }).then(() => {
        const studentId = student && (student.id || student.studentId)
        if (!studentId) { this.$modal.msgWarning('无法定位学生'); return }
        this.$router.push({ path: '/spas/analysis/student', query: { studentId, deptId: this.queryParams.deptId, subjectId: this.queryParams.subjectId } })
      }).catch(action => {
        if (action === 'cancel') {
          const knowledgeId = knowledge && (knowledge.id || knowledge.knowledgeId)
          if (!knowledgeId) { this.$modal.msgWarning('无法定位知识点'); return }
          this.$router.push({ path: '/spas/analysis/knowledge', query: { knowledgeId, deptId: this.queryParams.deptId, subjectId: this.queryParams.subjectId } })
        }
      })
    }
  }
}
</script>

<style scoped>
.spas-analysis .card-header {
  font-weight: 600;
  color: #2C2940;
}
.spas-analysis .card-sub {
  margin-left: 10px;
  font-weight: 400;
  font-size: 12px;
  color: #6B6685;
}
.ranking-card >>> .el-table {
  width: 100%;
}
.rank-note {
  margin: 0 0 10px;
  color: #6B6685;
  font-size: 12px;
  line-height: 1.6;
}
.heatmap-card .heatmap-hint {
  margin: 8px 0 0;
}
.heatmap-card >>> .spas-chart {
  max-width: 100%;
}
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
.bound-class-role {
  margin-left: 0;
}
.bound-class-switch {
  margin-left: 4px;
}
.overview-row {
  margin-bottom: 8px;
}
.stat-card {
  background: #fff;
  border: 1px solid #E8E4F5;
  border-radius: 14px;
  padding: 16px 18px;
  margin-bottom: 12px;
  border-left: 3px solid #7B6CF6;
  box-shadow: 0 8px 24px rgba(91, 75, 219, 0.06);
}
.stat-card.tone-blue { border-left-color: #7B6CF6; }
.stat-card.tone-orange { border-left-color: #E6A23C; }
.stat-card.tone-green { border-left-color: #67C23A; }
.stat-card.tone-red { border-left-color: #F56C6C; }
.stat-label {
  color: #6B6685;
  font-size: 13px;
}
.stat-value {
  margin-top: 8px;
  font-size: 26px;
  font-weight: 600;
  color: #2C2940;
  line-height: 1.2;
}
.stat-hint {
  margin-top: 6px;
  font-size: 12px;
  color: #A8A3BD;
}
</style>
