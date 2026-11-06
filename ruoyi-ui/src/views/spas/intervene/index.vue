<template>
  <div class="app-container spas-intervene">
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
          <span class="filter-tag-label">状态:</span>
          <div class="filter-tag-list">
            <button
              type="button"
              class="filter-chip"
              :class="{ active: queryParams.status === '' || queryParams.status == null }"
              @click="selectStatusTag('')"
            >全部</button>
            <button
              v-for="dict in dict.type.spas_intervene_status"
              :key="'st-' + dict.value"
              type="button"
              class="filter-chip"
              :class="{ active: String(queryParams.status) === String(dict.value) }"
              @click="selectStatusTag(dict.value)"
            >{{ dict.label }}</button>
          </div>
        </div>

        <div class="filter-tag-row">
          <span class="filter-tag-label">来源:</span>
          <div class="filter-tag-list">
            <button
              type="button"
              class="filter-chip"
              :class="{ active: !queryParams.sourceType }"
              @click="selectSourceTag(undefined)"
            >全部</button>
            <button
              v-for="dict in dict.type.spas_intervene_source"
              :key="'src-' + dict.value"
              type="button"
              class="filter-chip"
              :class="{ active: String(queryParams.sourceType) === String(dict.value) }"
              @click="selectSourceTag(dict.value)"
            >{{ dict.label }}</button>
          </div>
        </div>

        <div class="filter-tag-row">
          <span class="filter-tag-label">负责:</span>
          <div class="filter-tag-list">
            <button
              type="button"
              class="filter-chip"
              :class="{ active: !ownerMineOnly }"
              @click="selectOwnerMine(false)"
            >全部</button>
            <button
              type="button"
              class="filter-chip"
              :class="{ active: ownerMineOnly }"
              @click="selectOwnerMine(true)"
            >我负责的</button>
          </div>
        </div>
      </div>

      <div v-if="queryParams.deptId && todoSummary" class="todo-kpi-row">
        <button type="button" class="todo-kpi" @click="selectStatusTag('0')">
          <span class="todo-n">{{ todoSummary.openCount || 0 }}</span>
          <span class="todo-l">进行中</span>
        </button>
        <button type="button" class="todo-kpi warn" @click="filterDueToday">
          <span class="todo-n">{{ todoSummary.dueTodayCount || 0 }}</span>
          <span class="todo-l">今日到期</span>
        </button>
        <button type="button" class="todo-kpi danger" @click="filterPastDue">
          <span class="todo-n">{{ (todoSummary.overdueCount || 0) + (todoSummary.pastDueOpenCount || 0) }}</span>
          <span class="todo-l">逾期/过期</span>
        </button>
        <button type="button" class="todo-kpi" @click="selectOwnerMine(true)">
          <span class="todo-n">{{ todoSummary.myOpenCount || 0 }}</span>
          <span class="todo-l">我负责</span>
        </button>
        <button type="button" class="todo-kpi warn" @click="filterNoCoach">
          <span class="todo-n">{{ todoSummary.noCoachCount || 0 }}</span>
          <span class="todo-l">无辅导</span>
        </button>
        <button type="button" class="todo-kpi danger" @click="filterNoAction">
          <span class="todo-n">{{ todoSummary.noActionCount || 0 }}</span>
          <span class="todo-l">无动作挂单</span>
        </button>
        <div class="todo-kpi muted" title="达标数 / (进行中+达标+逾期)">
          <span class="todo-n">{{ formatPct(todoSummary.passRate) }}</span>
          <span class="todo-l">达标率</span>
        </div>
        <div class="todo-kpi muted" title="无动作挂单 / 进行中">
          <span class="todo-n">{{ formatPct(todoSummary.actionHangRate) }}</span>
          <span class="todo-l">挂单率</span>
        </div>
      </div>

      <div class="filter-actions">
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">查询</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        <el-button
          v-if="queryParams.studentId"
          type="text"
          size="mini"
          icon="el-icon-back"
          @click="backToStudentList"
        >返回学生名单</el-button>
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['spas:intervene:add']">新增干预</el-button>
        <el-button size="mini" plain icon="el-icon-bell" @click="$router.push('/spas/warning/record')" v-hasPermi="['spas:warning:record']">从预警发起</el-button>
      </div>
    </div>

    <el-alert
      type="info"
      :closable="false"
      show-icon
      class="mb8"
      title="创建干预须挂知识点并选择动作包（布置练习/选题补弱/辅导计划）；过程有辅导或新练习后可关闭，否则须填写关闭原因。导入成绩后可自动评估 Δrate。"
    />

    <el-empty v-if="!queryParams.deptId" description="请选择班级后查看学生名单">
      <div class="empty-actions">
        <el-button type="primary" size="mini" v-if="myDepts.length" @click="selectClassTag(preferredDeptId)">选择我的班级</el-button>
        <el-button size="mini" v-if="!boundClassMode" @click="$router.push('/system/dept')">去部门管理</el-button>
      </div>
    </el-empty>

    <div
      v-else-if="!queryParams.studentId"
      class="student-roster-panel"
      v-loading="rosterLoading"
    >
      <div class="roster-header">
        <div class="roster-header-main">
          <div class="roster-title">{{ currentDeptName || '班级' }} · 需干预学生</div>
          <div class="roster-sub">仅显示当前筛选条件下有干预任务的学生；点击查看任务明细</div>
        </div>
        <div class="roster-meta">
          <span class="roster-count">{{ filteredStudentOptions.length }}</span>
          <span class="roster-count-label">人{{ studentNameKeyword ? '（已筛选）' : '' }}</span>
        </div>
      </div>

      <el-empty
        v-if="!filteredStudentOptions.length"
        :description="studentNameKeyword ? '未找到匹配的需干预学生' : '当前筛选下暂无需干预学生'"
        :image-size="72"
      >
        <div class="empty-actions">
          <el-button type="primary" size="mini" icon="el-icon-plus" @click="handleAdd" v-hasPermi="['spas:intervene:add']">新增干预</el-button>
          <el-button size="mini" icon="el-icon-bell" @click="$router.push('/spas/warning/record')" v-hasPermi="['spas:warning:record']">从预警发起</el-button>
        </div>
      </el-empty>

      <div v-else class="roster-grid">
        <button
          v-for="s in filteredStudentOptions"
          :key="s.studentId"
          type="button"
          class="roster-tile"
          @click="enterStudentIntervene(s)"
        >
          <span class="roster-avatar" :class="'tone-' + studentAvatarTone(s)">{{ studentAvatarText(s) }}</span>
          <span class="roster-body">
            <span class="roster-name-row">
              <span class="roster-name">{{ s.studentName || '-' }}</span>
              <el-tag v-if="s.taskCount" size="mini" type="warning" effect="plain">{{ s.taskCount }} 项</el-tag>
            </span>
            <span class="roster-no">学号 {{ s.studentNo || '-' }}</span>
          </span>
          <span class="roster-action">
            干预<i class="el-icon-arrow-right" />
          </span>
        </button>
      </div>
    </div>

    <div v-else class="intervene-list-panel">
      <div class="roster-header">
        <div class="roster-header-main">
          <div class="roster-title">{{ currentStudentLabel }} · 干预任务</div>
          <div class="roster-sub">可按状态/来源筛选；支持评估、关闭与跳转学情分析</div>
        </div>
        <div class="roster-meta">
          <span class="roster-count">{{ total }}</span>
          <span class="roster-count-label">条</span>
        </div>
      </div>

      <el-empty
        v-if="!loading && (!taskList || !taskList.length)"
        :image-size="72"
        description="该生暂无干预任务"
      >
        <div class="empty-actions">
          <el-button type="primary" size="mini" icon="el-icon-plus" @click="handleAdd" v-hasPermi="['spas:intervene:add']">新增干预</el-button>
          <el-button size="mini" icon="el-icon-back" @click="backToStudentList">返回名单</el-button>
        </div>
      </el-empty>

      <el-table v-loading="loading" :data="taskList" v-show="loading || (taskList && taskList.length)">
        <el-table-column label="ID" prop="interveneId" width="70" align="center" />
        <el-table-column label="标题" prop="title" min-width="140" :show-overflow-tooltip="true" />
        <el-table-column label="来源" prop="sourceType" width="80" align="center">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.spas_intervene_source" :value="scope.row.sourceType" />
          </template>
        </el-table-column>
        <el-table-column label="基线" width="90" align="center">
          <template slot-scope="scope">{{ formatRate(scope.row.baselineRate) }}</template>
        </el-table-column>
        <el-table-column label="目标" width="90" align="center">
          <template slot-scope="scope">{{ formatRate(scope.row.targetRate) }}</template>
        </el-table-column>
        <el-table-column label="当前" width="90" align="center">
          <template slot-scope="scope">{{ formatRate(scope.row.effectRate) }}</template>
        </el-table-column>
        <el-table-column label="增益" width="90" align="center">
          <template slot-scope="scope">
            <span :style="{ color: deltaColor(scope.row.effectDelta) }">{{ formatGap(scope.row.effectDelta) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" prop="status" width="90" align="center">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.spas_intervene_status" :value="scope.row.status" />
          </template>
        </el-table-column>
        <el-table-column label="过程" min-width="110" align="center">
          <template slot-scope="scope">
            <el-tag size="mini" :type="processTagType(scope.row)" effect="plain">{{ scope.row.processLabel || '—' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="负责人" prop="ownerBy" width="90" align="center" />
        <el-table-column label="截止" width="110" align="center">
          <template slot-scope="scope">{{ scope.row.dueDate || '—' }}</template>
        </el-table-column>
        <el-table-column label="创建时间" width="160" align="center">
          <template slot-scope="scope">{{ parseTime(scope.row.createTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="260" align="center" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">详情</el-button>
            <el-button size="mini" type="text" icon="el-icon-refresh" @click="handleEvaluate(scope.row)" v-hasPermi="['spas:intervene:handle']">评估</el-button>
            <el-button v-if="scope.row.status === '0' || scope.row.status === '1' || scope.row.status === '3'" size="mini" type="text" icon="el-icon-check" @click="handleClose(scope.row)" v-hasPermi="['spas:intervene:edit']">关闭</el-button>
            <el-button size="mini" type="text" icon="el-icon-data-analysis" @click="goAnalysis(scope.row)" v-hasPermi="['spas:analysis:student']">分析</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    </div>

    <el-dialog :title="title" :visible.sync="open" width="620px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="学生" prop="studentId">
          <el-select
            v-model="form.studentId"
            placeholder="输入学号/姓名搜索"
            filterable
            remote
            clearable
            :remote-method="remoteStudent"
            :loading="studentLoading"
            style="width: 100%"
            :disabled="!!form.interveneId"
          >
            <el-option
              v-for="item in studentOptions"
              :key="item.studentId"
              :label="formatStudentLabel(item)"
              :value="item.studentId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="学科" prop="subjectId">
          <el-select
            v-model="form.subjectId"
            placeholder="请选择学科"
            filterable
            clearable
            style="width: 100%"
            @change="handleFormSubjectChange"
          >
            <el-option
              v-for="item in subjectOptions"
              :key="item.subjectId"
              :label="item.subjectName"
              :value="item.subjectId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" maxlength="128" placeholder="干预任务标题" />
        </el-form-item>
        <el-form-item label="知识点" prop="knowledgeIdList">
          <el-select
            v-model="form.knowledgeIdList"
            multiple
            filterable
            clearable
            collapse-tags
            placeholder="必选：至少挂接一个知识点"
            style="width: 100%"
            :disabled="!form.subjectId"
          >
            <el-option
              v-for="item in knowledgeOptions"
              :key="item.knowledgeId"
              :label="item.knowledgeName"
              :value="item.knowledgeId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="目标得分率" prop="targetRate">
          <el-input-number v-model="form.targetRate" :min="0" :max="1" :step="0.05" :precision="2" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item label="计划完成日" prop="dueDate">
          <el-date-picker v-model="form.dueDate" type="date" value-format="yyyy-MM-dd" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="动作包" prop="actionTypes">
          <el-checkbox-group v-model="form.actionTypes">
            <el-checkbox label="practice">布置练习</el-checkbox>
            <el-checkbox label="select">选题补弱</el-checkbox>
            <el-checkbox label="coach">辅导计划</el-checkbox>
          </el-checkbox-group>
          <div class="form-tip">至少选一项；创建后可跳转执行</div>
        </el-form-item>
        <el-form-item v-if="(form.actionTypes || []).indexOf('coach') >= 0" label="辅导计划" prop="coachPlan">
          <el-input v-model="form.coachPlan" type="textarea" :rows="2" placeholder="下一步计划，例如：本周面谈 + 完成相关练习" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="open = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="关闭干预" :visible.sync="closeOpen" width="480px" append-to-body>
      <el-alert
        v-if="closeNeedReason"
        type="warning"
        :closable="false"
        show-icon
        class="mb8"
        title="当前无辅导/新练习/达标证据，关闭须填写原因。"
      />
      <el-form label-width="90px">
        <el-form-item label="关闭原因" :required="closeNeedReason">
          <el-input v-model="closeReason" type="textarea" :rows="3" placeholder="例如：已转线下跟进 / 学生休学 / 误建任务" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitClose">确认关闭</el-button>
        <el-button @click="closeOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog
      title="干预详情"
      :visible.sync="viewOpen"
      width="820px"
      custom-class="intervene-detail-dialog"
      append-to-body
      @closed="viewTab = 'actions'"
    >
      <div v-if="current" class="detail-summary">
        <el-descriptions :column="2" border size="small">
          <el-descriptions-item label="学生">{{ current.studentNo }} · {{ current.studentName }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <dict-tag :options="dict.type.spas_intervene_status" :value="current.status" />
            <el-tag v-if="current.processLabel" size="mini" style="margin-left:6px" :type="processTagType(current)" effect="plain">{{ current.processLabel }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="标题" :span="2">{{ current.title }}</el-descriptions-item>
          <el-descriptions-item label="基线">{{ formatRate(current.baselineRate) }}</el-descriptions-item>
          <el-descriptions-item label="目标">{{ formatRate(current.targetRate) }}</el-descriptions-item>
          <el-descriptions-item label="当前">{{ formatRate(current.effectRate) }}</el-descriptions-item>
          <el-descriptions-item label="增益">
            <span :style="{ color: deltaColor(current.effectDelta) }">{{ formatGap(current.effectDelta) }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="负责人">{{ current.ownerBy || '-' }}</el-descriptions-item>
          <el-descriptions-item label="截止日">{{ current.dueDate || '-' }}{{ progress.daysLeft != null ? ('（剩 ' + progress.daysLeft + ' 天）') : '' }}</el-descriptions-item>
          <el-descriptions-item label="备注" :span="2">{{ current.remark || '-' }}</el-descriptions-item>
        </el-descriptions>
      </div>

      <el-tabs v-model="viewTab" class="detail-tabs">
        <el-tab-pane :label="'行动看板 (' + (progress.doneActionCount || 0) + '/' + (progress.actionCount || 0) + ')'" name="actions">
          <div class="board-kpis" v-if="progress">
            <div class="board-kpi"><span class="kpi-n">{{ progress.actionCount || 0 }}</span><span class="kpi-l">动作</span></div>
            <div class="board-kpi"><span class="kpi-n">{{ progress.doneActionCount || 0 }}</span><span class="kpi-l">已完成</span></div>
            <div class="board-kpi"><span class="kpi-n">{{ progress.coachCount || 0 }}</span><span class="kpi-l">辅导</span></div>
            <div class="board-kpi"><span class="kpi-n">{{ progress.hasPostCreateSample ? '有' : '无' }}</span><span class="kpi-l">创建后新样本</span></div>
            <div class="board-kpi"><span class="kpi-n" :class="progress.processOk ? 'ok' : 'warn'">{{ progress.processOk ? '可关' : '缺过程' }}</span><span class="kpi-l">关闭门槛</span></div>
          </div>
          <el-table :data="(current && current.actions) || []" size="mini" empty-text="暂无动作" max-height="280">
            <el-table-column label="类型" width="100" align="center">
              <template slot-scope="scope">{{ actionTypeLabel(scope.row.actionType) }}</template>
            </el-table-column>
            <el-table-column label="标题" prop="title" min-width="140" />
            <el-table-column label="状态" width="90" align="center">
              <template slot-scope="scope">
                <el-tag size="mini" :type="scope.row.status === '1' ? 'success' : (scope.row.status === '2' ? 'info' : 'warning')">
                  {{ scope.row.status === '1' ? '已完成' : (scope.row.status === '2' ? '已跳过' : '待执行') }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="200" align="center">
              <template slot-scope="scope">
                <el-button v-if="scope.row.status === '0' && scope.row.actionType === 'practice'" type="text" size="mini" @click="goActionPractice(current)">去布置</el-button>
                <el-button v-if="scope.row.status === '0' && scope.row.actionType === 'select'" type="text" size="mini" @click="goActionSelect(current)">去选题</el-button>
                <el-button v-if="scope.row.status === '0'" type="text" size="mini" @click="markActionDone(scope.row)">标完成</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane :label="'基线明细 (' + baselineRows.length + ')'" name="baseline">
          <el-table :data="baselineRows" size="mini" empty-text="无基线明细" max-height="320">
            <el-table-column label="知识点" prop="knowledgeName" min-width="140" />
            <el-table-column label="得分率" width="100" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.weightedRate) }}</template>
            </el-table-column>
            <el-table-column label="练习" prop="attemptCount" width="70" align="center" />
            <el-table-column label="等级" prop="weakLevel" width="70" align="center" />
          </el-table>
        </el-tab-pane>

        <el-tab-pane :label="'复测明细 (' + effectRows.length + ')'" name="effect">
          <el-alert
            v-if="effectMeta && effectMeta.windowDesc"
            class="mb8"
            type="info"
            :closable="false"
            show-icon
            :title="effectExplainTitle"
          />
          <el-table :data="effectRows" size="mini" empty-text="尚未评估" max-height="300">
            <el-table-column label="知识点" prop="knowledgeName" min-width="140" />
            <el-table-column label="基线" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.baselineRate) }}</template>
            </el-table-column>
            <el-table-column label="复测" width="90" align="center">
              <template slot-scope="scope">{{ formatRate(scope.row.effectRate) }}</template>
            </el-table-column>
            <el-table-column label="Δrate" width="100" align="center">
              <template slot-scope="scope">
                <span :style="{ color: deltaColor(scope.row.delta) }">{{ formatGap(scope.row.delta) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="练习" prop="attemptCount" width="70" align="center" />
          </el-table>
        </el-tab-pane>

        <el-tab-pane :label="'辅导记录 (' + ((current && current.coachLogs) || []).length + ')'" name="coach">
          <el-table :data="(current && current.coachLogs) || []" size="mini" empty-text="暂无辅导" max-height="320">
            <el-table-column label="时间" width="160">
              <template slot-scope="scope">{{ parseTime(scope.row.createTime) }}</template>
            </el-table-column>
            <el-table-column label="教师" prop="createBy" width="90" />
            <el-table-column label="内容" prop="content" min-width="180" :show-overflow-tooltip="true" />
            <el-table-column label="下一步" prop="nextPlan" min-width="120" :show-overflow-tooltip="true" />
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="基本信息" name="info">
          <el-descriptions v-if="current" :column="1" border size="small">
            <el-descriptions-item label="知识点">{{ current.knowledgeIds || '-' }}</el-descriptions-item>
            <el-descriptions-item label="来源">
              <dict-tag :options="dict.type.spas_intervene_source" :value="current.sourceType" />
              <span v-if="current.sourceId" style="margin-left:6px;color:#667085">#{{ current.sourceId }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="创建时间">{{ parseTime(current.createTime) }}</el-descriptions-item>
            <el-descriptions-item label="关闭原因">{{ current.closeReason || '-' }}</el-descriptions-item>
          </el-descriptions>
        </el-tab-pane>
      </el-tabs>

      <div slot="footer" class="dialog-footer">
        <el-button type="primary" plain @click="openCoach" v-hasPermi="['spas:portfolio:coach', 'spas:portfolio:list']">写辅导</el-button>
        <el-button plain @click="goActionPractice(current)">布置练习</el-button>
        <el-button plain @click="goActionSelect(current)">选题补弱</el-button>
        <el-button plain @click="openTransfer" v-hasPermi="['spas:intervene:edit']">转交</el-button>
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>

    <el-dialog title="转交负责人" :visible.sync="transferOpen" width="420px" append-to-body>
      <el-form label-width="90px">
        <el-form-item label="当前">
          <span>{{ (current && current.ownerBy) || '-' }}</span>
        </el-form-item>
        <el-form-item label="新负责人">
          <el-input v-model="transferOwner" placeholder="输入系统用户名（如 teacher01）" maxlength="64" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitTransfer">确认转交</el-button>
        <el-button @click="transferOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="新增辅导记录" :visible.sync="coachOpen" width="520px" append-to-body>
      <el-form ref="coachForm" :model="coachForm" :rules="coachRules" label-width="90px">
        <el-form-item label="辅导内容" prop="content">
          <el-input v-model="coachForm.content" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="下一步" prop="nextPlan">
          <el-input v-model="coachForm.nextPlan" type="textarea" :rows="2" />
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
import { listIntervene, getIntervene, addIntervene, updateIntervene, evaluateIntervene, interveneProgress, updateInterveneAction, classInterveneSummary } from '@/api/spas/intervene'
import { mapGetters } from 'vuex'
import { addCoachLog } from '@/api/spas/portfolio'
import { listStudent } from '@/api/spas/student'
import { optionselectSubject } from '@/api/spas/subject'
import { listKnowledge } from '@/api/spas/knowledge'
import { listMyTeachingDepts } from '@/api/spas/teacher'
import { deptTreeSelect } from '@/api/system/user'
import { applyTeachingDeptContext, canLoadSystemDeptTree, isLikelyClassDeptName } from '@/utils/spasDeptTree'
import { boundClassRoleFromDepts } from '@/utils/spasTeacherRole'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  name: 'SpasIntervene',
  components: { Treeselect },
  dicts: ['spas_intervene_status', 'spas_intervene_source'],
  data() {
    return {
      loading: false,
      rosterLoading: false,
      pendingKnowledgeId: null,
      pendingKnowledgeName: '',
      pendingSubjectId: null,
      total: 0,
      taskList: [],
      title: '',
      open: false,
      viewOpen: false,
      viewTab: 'actions',
      coachOpen: false,
      closeOpen: false,
      closeRow: null,
      closeReason: '',
      closeNeedReason: false,
      transferOpen: false,
      transferOwner: '',
      ownerMineOnly: false,
      todoSummary: null,
      current: {},
      progress: {},
      baselineRows: [],
      effectRows: [],
      effectMeta: null,
      studentOptions: [],
      rosterStudents: [],
      subjectOptions: [],
      knowledgeOptions: [],
      studentLoading: false,
      studentNameKeyword: '',
      gradeFilter: '',
      classTagsExpanded: false,
      deptOptions: [],
      myDepts: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deptId: undefined,
        studentId: undefined,
        studentNo: undefined,
        studentName: undefined,
        status: '0',
        sourceType: undefined,
        ownerBy: undefined
      },
      form: {},
      rules: {
        studentId: [{ required: true, message: '请选择学生', trigger: 'change' }],
        subjectId: [{ required: true, message: '请选择学科', trigger: 'change' }],
        title: [{ required: true, message: '标题不能为空', trigger: 'blur' }],
        knowledgeIdList: [{ type: 'array', required: true, min: 1, message: '请至少挂接一个知识点', trigger: 'change' }],
        dueDate: [{ required: true, message: '请选择计划完成日', trigger: 'change' }],
        actionTypes: [{ type: 'array', required: true, min: 1, message: '请至少选择一种动作', trigger: 'change' }]
      },
      coachForm: {},
      coachRules: {
        content: [{ required: true, message: '辅导内容不能为空', trigger: 'blur' }]
      }
    }
  },
  computed: {
    ...mapGetters(['name']),
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
      return ''
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
      let list = (this.rosterStudents || []).slice()
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
    currentStudentLabel() {
      const sid = this.queryParams.studentId
      if (!sid) return '学生'
      const hit = (this.rosterStudents || []).find(s => Number(s.studentId) === Number(sid))
      if (hit) {
        return (hit.studentName || '-') + (hit.studentNo ? (' · ' + hit.studentNo) : '')
      }
      return '学生'
    },
    effectExplainTitle() {
      const m = this.effectMeta || {}
      const parts = []
      if (m.windowDesc) parts.push('对照口径：' + m.windowDesc)
      if (m.windowFrom) parts.push('起算 ' + this.parseTime(m.windowFrom))
      if (m.formula) parts.push(m.formula)
      if (m.mode === 'after_create') parts.push('优先用干预后作答')
      else if (m.mode === 'snapshot') parts.push('回退全量快照')
      return parts.join(' · ') || '效果说明'
    }
  },
  created() {
    const q = this.$route.query || {}
    if (q.deptId) {
      this.queryParams.deptId = isNaN(Number(q.deptId)) ? q.deptId : Number(q.deptId)
    }
    if (q.studentId) {
      this.queryParams.studentId = Number(q.studentId) || q.studentId
    }
    if (q.status !== undefined) {
      this.queryParams.status = q.status
    }
    if (q.knowledgeId) {
      this.pendingKnowledgeId = Number(q.knowledgeId) || q.knowledgeId
      this.pendingKnowledgeName = q.knowledgeName || ''
    }
    if (q.subjectId) {
      this.pendingSubjectId = Number(q.subjectId) || q.subjectId
    }
    this.loadSubjects()
    this.loadDepts().then(() => {
      if (this.queryParams.deptId) {
        return this.loadRosterStudents()
      }
      return null
    }).then(() => {
      if (this.queryParams.studentId) {
        this.getList()
      }
    }).catch(() => {})
    if (q.warningId) {
      this.$nextTick(() => this.promptFromWarning(q.warningId))
    } else if (q.openAdd === '1' || q.openAdd === 1) {
      this.$nextTick(() => this.handleAdd())
    }
  },
  methods: {
    loadDepts() {
      return applyTeachingDeptContext(this, listMyTeachingDepts, deptTreeSelect).catch(() => {
        if (!canLoadSystemDeptTree()) {
          this.deptOptions = []
          return Promise.resolve()
        }
        return deptTreeSelect().then(res => {
          this.deptOptions = res.data || []
        }).catch(() => { this.deptOptions = [] })
      })
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
    syncInterveneRoute() {
      const q = {}
      if (this.queryParams.deptId) q.deptId = this.queryParams.deptId
      if (this.queryParams.studentId) q.studentId = this.queryParams.studentId
      if (this.queryParams.status !== undefined && this.queryParams.status !== null && this.queryParams.status !== '') {
        q.status = this.queryParams.status
      }
      if (this.queryParams.sourceType) q.sourceType = this.queryParams.sourceType
      this.$router.replace({ path: this.$route.path, query: q }).catch(() => {})
    },
    clearTaskView() {
      this.queryParams.studentId = undefined
      this.queryParams.studentNo = undefined
      this.queryParams.studentName = undefined
      this.taskList = []
      this.total = 0
    },
    clearClassFilter() {
      this.queryParams.deptId = undefined
      this.rosterStudents = []
      this.studentNameKeyword = ''
      this.todoSummary = null
      this.clearTaskView()
      this.syncInterveneRoute()
    },
    selectClassTag(deptId) {
      this.selectMyDept(deptId)
    },
    selectMyDept(deptId) {
      this.queryParams.deptId = deptId
      this.clearTaskView()
      this.studentNameKeyword = ''
      this.syncInterveneRoute()
      this.loadTodoSummary()
      this.loadRosterStudents()
    },
    handleDeptChange() {
      this.selectMyDept(this.queryParams.deptId)
    },
    loadTodoSummary() {
      if (!this.queryParams.deptId) {
        this.todoSummary = null
        return
      }
      classInterveneSummary(this.queryParams.deptId, {}).then(res => {
        this.todoSummary = res.data || {}
      }).catch(() => { this.todoSummary = null })
    },
    clearExtraParams() {
      if (!this.queryParams.params) this.$set(this.queryParams, 'params', {})
      this.$delete(this.queryParams.params, 'dueToday')
      this.$delete(this.queryParams.params, 'pastDueOpen')
      this.$delete(this.queryParams.params, 'noCoach')
      this.$delete(this.queryParams.params, 'noAction')
    },
    refreshAfterFilter() {
      this.queryParams.pageNum = 1
      this.syncInterveneRoute()
      if (this.queryParams.studentId) {
        this.getList()
      } else if (this.queryParams.deptId) {
        this.loadRosterStudents((this.studentNameKeyword || '').trim() || undefined)
      }
    },
    selectStatusTag(status) {
      this.clearExtraParams()
      this.queryParams.status = status
      this.refreshAfterFilter()
    },
    selectSourceTag(sourceType) {
      this.queryParams.sourceType = sourceType
      this.refreshAfterFilter()
    },
    selectOwnerMine(mine) {
      this.ownerMineOnly = !!mine
      this.queryParams.ownerBy = mine ? (this.name || undefined) : undefined
      this.refreshAfterFilter()
    },
    filterDueToday() {
      this.clearExtraParams()
      this.queryParams.status = '0'
      this.$set(this.queryParams.params, 'dueToday', '1')
      this.refreshAfterFilter()
    },
    filterPastDue() {
      this.clearExtraParams()
      this.queryParams.status = ''
      this.$set(this.queryParams.params, 'pastDueOpen', '1')
      this.refreshAfterFilter()
    },
    filterNoCoach() {
      this.clearExtraParams()
      this.queryParams.status = ''
      this.$set(this.queryParams.params, 'noCoach', '1')
      this.refreshAfterFilter()
    },
    filterNoAction() {
      this.clearExtraParams()
      this.queryParams.status = '0'
      this.$set(this.queryParams.params, 'noAction', '1')
      this.refreshAfterFilter()
    },
    openTransfer() {
      if (!this.current || !this.current.interveneId) return
      this.transferOwner = ''
      this.transferOpen = true
    },
    submitTransfer() {
      const owner = (this.transferOwner || '').trim()
      if (!owner) {
        this.$modal.msgWarning('请输入新负责人用户名')
        return
      }
      updateIntervene({
        interveneId: this.current.interveneId,
        ownerBy: owner
      }).then(() => {
        this.$modal.msgSuccess('已转交')
        this.transferOpen = false
        this.handleView(this.current)
        this.getList()
        this.loadTodoSummary()
      })
    },
    enterStudentIntervene(row) {
      const studentId = row && (row.studentId || row.id)
      if (!studentId) {
        this.$modal.msgWarning('无法定位学生')
        return
      }
      this.queryParams.studentId = studentId
      this.queryParams.studentNo = undefined
      this.queryParams.studentName = undefined
      this.queryParams.pageNum = 1
      this.syncInterveneRoute()
      this.getList()
    },
    backToStudentList() {
      this.clearTaskView()
      this.syncInterveneRoute()
      if (this.queryParams.deptId) {
        this.loadRosterStudents((this.studentNameKeyword || '').trim() || undefined)
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
      this.loadRosterStudents(kw || undefined)
    },
    loadRosterStudents(keyword) {
      if (!this.queryParams.deptId) {
        this.rosterStudents = []
        return Promise.resolve()
      }
      // Aggregate students who have intervene tasks under current class/status/source filters
      const params = {
        pageNum: 1,
        pageSize: 2000,
        deptId: this.queryParams.deptId
      }
      if (this.queryParams.status !== undefined && this.queryParams.status !== null && this.queryParams.status !== '') {
        params.status = this.queryParams.status
      }
      if (this.queryParams.sourceType) {
        params.sourceType = this.queryParams.sourceType
      }
      if (this.queryParams.ownerBy) {
        params.ownerBy = this.queryParams.ownerBy
      }
      if (this.queryParams.params) {
        params.params = this.queryParams.params
      }
      if (keyword) {
        if (/^\d/.test(String(keyword))) {
          params.studentNo = keyword
        } else {
          params.studentName = keyword
        }
      }
      this.rosterLoading = true
      return listIntervene(params).then(response => {
        const rows = response.rows || []
        const map = {}
        const order = []
        rows.forEach(t => {
          const sid = t.studentId
          if (sid == null) return
          const key = String(sid)
          if (!map[key]) {
            map[key] = {
              studentId: sid,
              studentNo: t.studentNo,
              studentName: t.studentName,
              taskCount: 0
            }
            order.push(key)
          }
          map[key].taskCount += 1
          if (!map[key].studentNo && t.studentNo) map[key].studentNo = t.studentNo
          if (!map[key].studentName && t.studentName) map[key].studentName = t.studentName
        })
        this.rosterStudents = order.map(k => map[k])
        if (response.total > params.pageSize) {
          this.$modal.msgWarning('干预任务超过 ' + params.pageSize + ' 条，名单可能不完整，请缩小状态/来源筛选')
        }
      }).catch(() => {
        this.rosterStudents = []
      }).finally(() => {
        this.rosterLoading = false
      })
    },
    formatRate(rate) {
      if (rate == null || rate === '') return '-'
      const n = Number(rate)
      if (isNaN(n)) return rate
      const p = n <= 1 ? n * 100 : n
      return p.toFixed(2) + '%'
    },
    formatGap(gap) {
      if (gap == null || gap === '') return '-'
      const n = Number(gap)
      if (isNaN(n)) return gap
      const pct = (n <= 1 && n >= -1 ? n * 100 : n)
      return (pct > 0 ? '+' : '') + pct.toFixed(2) + '%'
    },
    deltaColor(gap) {
      const n = Number(gap)
      if (isNaN(n)) return undefined
      if (n > 0.01) return '#10B981'
      if (n < -0.01) return '#FF5A5F'
      return '#64748B'
    },
    formatStudentLabel(item) {
      const no = item.studentNo || ''
      const name = item.studentName || ''
      return no ? (no + ' · ' + name) : name
    },
    loadSubjects() {
      return optionselectSubject().then(response => {
        this.subjectOptions = response.data || []
      })
    },
    loadKnowledge() {
      if (!this.form.subjectId) {
        this.knowledgeOptions = []
        return Promise.resolve()
      }
      return listKnowledge({
        subjectId: this.form.subjectId,
        nodeType: '2',
        status: '0',
        pageNum: 1,
        pageSize: 500
      }).then(response => {
        this.knowledgeOptions = response.rows || response.data || []
      }).catch(() => {
        this.knowledgeOptions = []
      })
    },
    handleFormSubjectChange() {
      this.form.knowledgeIdList = []
      this.loadKnowledge()
    },
    loadStudents(keyword) {
      const params = {
        pageNum: 1,
        pageSize: 50,
        status: '0'
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
      }).catch(() => {
        this.studentOptions = []
      }).finally(() => {
        this.studentLoading = false
      })
    },
    remoteStudent(query) {
      if (!query) {
        this.studentOptions = []
        return
      }
      this.loadStudents(query)
    },
    getList() {
      if (!this.queryParams.studentId) {
        this.taskList = []
        this.total = 0
        return
      }
      this.loading = true
      const params = Object.assign({}, this.queryParams)
      // Prefer studentId filter; avoid conflicting name/no when browsing by card
      delete params.studentNo
      delete params.studentName
      listIntervene(params).then(res => {
        this.taskList = res.rows || []
        this.total = res.total || 0
      }).finally(() => {
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      if (this.queryParams.studentId) {
        this.getList()
        return
      }
      if (!this.queryParams.deptId) {
        this.$modal.msgWarning('请先选择班级')
        return
      }
      this.loadRosterStudents((this.studentNameKeyword || '').trim() || undefined)
    },
    resetQuery() {
      this.gradeFilter = ''
      this.classTagsExpanded = false
      this.studentNameKeyword = ''
      this.ownerMineOnly = false
      this.queryParams.status = '0'
      this.queryParams.sourceType = undefined
      this.queryParams.ownerBy = undefined
      this.clearExtraParams()
      this.clearClassFilter()
    },
    reset() {
      const due = new Date()
      due.setDate(due.getDate() + 14)
      const dueStr = due.getFullYear() + '-' + String(due.getMonth() + 1).padStart(2, '0') + '-' + String(due.getDate()).padStart(2, '0')
      this.form = {
        interveneId: undefined,
        studentId: undefined,
        subjectId: undefined,
        title: undefined,
        knowledgeIdList: [],
        knowledgeIds: undefined,
        targetRate: 0.6,
        dueDate: dueStr,
        actionTypes: ['coach'],
        coachPlan: '安排一对一辅导，并督促完成相关练习',
        coachContent: undefined,
        remark: undefined,
        sourceType: '3'
      }
      this.knowledgeOptions = []
      this.studentOptions = []
      this.resetForm('form')
    },
    processTagType(row) {
      if (row && String(row.effectPassed) === '2') return 'warning'
      const label = (row && row.processLabel) || ''
      if (label.indexOf('达标') >= 0) return 'success'
      if (label.indexOf('观察') >= 0) return 'warning'
      if (label.indexOf('逾期') >= 0 || label.indexOf('无动作') >= 0) return 'danger'
      if (label.indexOf('关闭') >= 0) return 'info'
      if (label.indexOf('待执行') >= 0) return 'warning'
      return 'primary'
    },
    formatPct(rate) {
      if (rate == null || rate === '') return '—'
      const n = Number(rate)
      if (isNaN(n)) return '—'
      const pct = (n <= 1 && n >= 0 ? n * 100 : n)
      return pct.toFixed(0) + '%'
    },
    actionTypeLabel(type) {
      return ({ practice: '布置练习', select: '选题补弱', coach: '辅导计划', custom: '其它' })[type] || type || '-'
    },
    defaultDueDateStr() {
      const due = new Date()
      due.setDate(due.getDate() + 14)
      return due.getFullYear() + '-' + String(due.getMonth() + 1).padStart(2, '0') + '-' + String(due.getDate()).padStart(2, '0')
    },
    handleAdd() {
      this.reset()
      if (this.queryParams.studentId) {
        this.form.studentId = this.queryParams.studentId
        const hit = (this.rosterStudents || []).find(s => Number(s.studentId) === Number(this.queryParams.studentId))
        if (hit) {
          this.studentOptions = [hit]
        }
      }
      this.open = true
      this.title = '新增干预任务'
      if (!this.pendingKnowledgeId) return
      const applyKp = () => {
        this.form.knowledgeIdList = [this.pendingKnowledgeId]
        if (this.pendingKnowledgeName) {
          this.$modal.msgSuccess('已预填知识点：' + this.pendingKnowledgeName)
        }
      }
      if (this.pendingSubjectId) {
        this.form.subjectId = this.pendingSubjectId
        this.loadKnowledge().then(applyKp)
      } else {
        applyKp()
      }
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (!valid) return
        const payload = Object.assign({}, this.form)
        const list = payload.knowledgeIdList
        if (!list || !list.length) {
          this.$modal.msgWarning('请至少挂接一个知识点')
          return
        }
        if (!payload.actionTypes || !payload.actionTypes.length) {
          this.$modal.msgWarning('请至少选择一种动作')
          return
        }
        payload.knowledgeIds = list.join(',')
        delete payload.knowledgeIdList
        const types = (payload.actionTypes || []).slice()
        addIntervene(payload).then(res => {
          const created = (res && res.data) || {}
          this.$modal.msgSuccess('新增成功：已拍摄基线并生成动作包')
          this.open = false
          if (this.queryParams.studentId) {
            this.getList()
          } else if (this.queryParams.deptId) {
            this.loadRosterStudents((this.studentNameKeyword || '').trim() || undefined)
          }
          this.afterCreateNavigate(created, types)
        })
      })
    },
    afterCreateNavigate(created, types) {
      if (!created || !created.interveneId) return
      if (types.indexOf('practice') >= 0) {
        this.$modal.confirm('已创建干预，是否立即去布置练习？').then(() => {
          this.goActionPractice(created)
        }).catch(() => {})
        return
      }
      if (types.indexOf('select') >= 0) {
        this.$modal.confirm('已创建干预，是否立即去选题补弱？').then(() => {
          this.goActionSelect(created)
        }).catch(() => {})
      }
    },
    goActionPractice(row) {
      if (!row) return
      const q = {
        interveneId: row.interveneId,
        subjectId: row.subjectId,
        knowledgeIds: row.knowledgeIds
      }
      if (row.deptId) q.deptId = row.deptId
      else if (this.queryParams.deptId) q.deptId = this.queryParams.deptId
      this.$router.push({ path: '/spas/biz/hw-task', query: q }).catch(() => {
        this.$router.push({ path: '/spas/homework/task', query: q }).catch(() => {
          this.$modal.msgWarning('未找到作业布置页')
        })
      })
    },
    goActionSelect(row) {
      if (!row) return
      const q = {
        interveneId: row.interveneId,
        subjectId: row.subjectId,
        knowledgeIds: row.knowledgeIds
      }
      this.$router.push({ path: '/spas/qb/select', query: q }).catch(() => {
        this.$modal.msgWarning('未找到选题中心')
      })
    },
    markActionDone(action) {
      if (!action || !this.current) return
      updateInterveneAction({
        actionId: action.actionId,
        interveneId: this.current.interveneId,
        status: '1'
      }).then(() => {
        this.$modal.msgSuccess('已标记完成')
        this.handleView(this.current)
      })
    },
    handleView(row) {
      const id = row && row.interveneId
      if (!id) return
      Promise.all([getIntervene(id), interveneProgress(id).catch(() => ({ data: {} }))]).then(([res, progRes]) => {
        const data = res.data || {}
        if (!Array.isArray(data.coachLogs)) {
          data.coachLogs = []
        }
        if (!Array.isArray(data.actions)) {
          data.actions = []
        }
        this.current = data
        this.progress = (progRes && progRes.data) || {}
        if (this.progress.processLabel) {
          this.current.processLabel = this.progress.processLabel
          this.current.processOk = this.progress.processOk
        }
        try {
          this.baselineRows = data.baselineJson ? JSON.parse(data.baselineJson) : []
        } catch (e) {
          this.baselineRows = []
        }
        try {
          const raw = data.effectJson ? JSON.parse(data.effectJson) : null
          if (Array.isArray(raw)) {
            this.effectRows = raw
            this.effectMeta = null
          } else if (raw && typeof raw === 'object') {
            this.effectMeta = raw
            this.effectRows = Array.isArray(raw.knowledges) ? raw.knowledges : []
          } else {
            this.effectRows = []
            this.effectMeta = null
          }
        } catch (e) {
          this.effectRows = []
          this.effectMeta = null
        }
        this.viewTab = 'actions'
        this.viewOpen = true
      })
    },
    handleEvaluate(row) {
      this.$modal.confirm('将按「干预后作答优先，否则全量快照」重新评估各知识点 Δ？').then(() => {
        return evaluateIntervene(row.interveneId)
      }).then(res => {
        const d = res.data || {}
        this.$modal.msgSuccess('评估完成：当前 ' + this.formatRate(d.effectRate) + '，增益 ' + this.formatGap(d.effectDelta))
        this.getList()
        if (this.viewOpen && this.current && this.current.interveneId === row.interveneId) {
          this.handleView(row)
        }
      }).catch(() => {})
    },
    handleClose(row) {
      this.closeRow = row
      this.closeReason = ''
      const need = !(row && (row.processOk || row.effectPassed === '1' || Number(row.coachCount) > 0))
      this.closeNeedReason = need
      // refresh processOk from progress when possible
      interveneProgress(row.interveneId).then(res => {
        const p = res.data || {}
        this.closeNeedReason = !p.processOk
        this.closeOpen = true
      }).catch(() => {
        this.closeOpen = true
      })
    },
    submitClose() {
      if (!this.closeRow) return
      if (this.closeNeedReason && !(this.closeReason || '').trim()) {
        this.$modal.msgWarning('请填写关闭原因')
        return
      }
      updateIntervene({
        interveneId: this.closeRow.interveneId,
        status: '2',
        closeReason: (this.closeReason || '').trim() || undefined
      }).then(() => {
        this.$modal.msgSuccess('已关闭')
        this.closeOpen = false
        this.getList()
        if (this.viewOpen) this.viewOpen = false
      }).catch(() => {})
    },
    goAnalysis(row) {
      this.$router.push({
        path: '/spas/analysis/student',
        query: { studentId: row.studentId, subjectId: row.subjectId }
      })
    },
    openCoach() {
      if (!this.current) return
      this.coachForm = {
        studentId: this.current.studentId,
        interveneId: this.current.interveneId,
        content: undefined,
        nextPlan: undefined
      }
      this.coachOpen = true
    },
    submitCoach() {
      this.$refs['coachForm'].validate(valid => {
        if (!valid) return
        addCoachLog(this.coachForm).then(() => {
          this.$modal.msgSuccess('辅导已保存')
          this.coachOpen = false
          this.handleView(this.current)
        })
      })
    },
    promptFromWarning(warningId) {
      this.$modal.msgSuccess('可在预警详情中一键创建干预；warningId=' + warningId)
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
.filter-select { width: 148px; }
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
.filter-more:hover { color: #0F766E; }
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
.student-roster-panel,
.intervene-list-panel {
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
.roster-tile.is-inactive { opacity: 0.72; }
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
.todo-kpi-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin: 4px 0 10px;
}
.todo-kpi {
  border: 1px solid #E8EDF5;
  background: #F8FAFC;
  border-radius: 8px;
  padding: 8px 12px;
  min-width: 76px;
  cursor: pointer;
  text-align: center;
}
.todo-kpi:hover { border-color: #94A3B8; }
.todo-kpi.warn { background: #FFF7ED; border-color: #FED7AA; }
.todo-kpi.danger { background: #FEF2F2; border-color: #FECACA; }
.todo-kpi.muted {
  cursor: default;
  background: #F1F5F9;
  border-color: #E2E8F0;
}
.todo-kpi.muted:hover { border-color: #E2E8F0; }
.todo-kpi .todo-n {
  display: block;
  font-size: 18px;
  font-weight: 650;
  color: #1F2A44;
  line-height: 1.2;
}
.todo-kpi .todo-l {
  display: block;
  margin-top: 2px;
  font-size: 12px;
  color: #667085;
}
.empty-actions {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 8px;
}
.form-tip {
  margin-top: 4px;
  font-size: 12px;
  color: #909399;
  line-height: 1.4;
}
.board-title {
  margin-top: 16px;
  font-weight: 600;
}
.board-kpis {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 8px;
}
.board-kpi {
  min-width: 72px;
  padding: 8px 10px;
  border: 1px solid #E8EDF5;
  border-radius: 8px;
  background: #F8FAFC;
  text-align: center;
}
.board-kpi .kpi-n {
  display: block;
  font-size: 16px;
  font-weight: 600;
  color: #1F2A44;
}
.board-kpi .kpi-n.ok { color: #067647; }
.board-kpi .kpi-n.warn { color: #B54708; }
.board-kpi .kpi-l {
  display: block;
  margin-top: 2px;
  font-size: 12px;
  color: #667085;
}
.mb8 { margin-bottom: 12px; }
.detail-summary {
  margin-bottom: 8px;
}
.detail-tabs {
  margin-top: 4px;
}
.detail-tabs >>> .el-tabs__header {
  margin-bottom: 10px;
}
.detail-tabs >>> .el-tabs__content {
  min-height: 180px;
  max-height: 380px;
  overflow-y: auto;
}
.detail-tabs .board-kpis {
  margin-top: 0;
  margin-bottom: 10px;
}
</style>

<style>
.intervene-detail-dialog {
  margin-top: 8vh !important;
}
.intervene-detail-dialog .el-dialog__body {
  padding-top: 10px;
  padding-bottom: 8px;
}
</style>
