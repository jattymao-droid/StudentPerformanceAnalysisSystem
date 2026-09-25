<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="78px">
      <el-form-item label="学科" prop="subjectId">
        <el-select v-model="queryParams.subjectId" placeholder="学科" clearable filterable @change="handleQuery">
          <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
        </el-select>
      </el-form-item>
      <el-form-item label="题干" prop="content">
        <el-input v-model="queryParams.content" placeholder="题干关键词" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="题型" prop="questionType">
        <el-select v-model="queryParams.questionType" clearable filterable placeholder="题型">
          <el-option v-for="t in typeOptions" :key="t.typeCode" :label="t.typeName" :value="t.typeCode" />
        </el-select>
      </el-form-item>
      <el-form-item label="知识点">
        <el-checkbox v-model="queryParams.unboundOnly" @change="handleQuery">仅未绑定</el-checkbox>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-dropdown split-button type="primary" size="mini" @click="handleAdd" v-hasPermi="['spas:qb:question:add']" @command="onAddCommand">
          添加题目
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="single" icon="el-icon-plus">单题新增</el-dropdown-item>
            <el-dropdown-item command="import" icon="el-icon-upload2">上传试卷解析</el-dropdown-item>
            <el-dropdown-item command="annotate" icon="el-icon-crop">可视标注</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-upload2" size="mini" @click="openImport" v-hasPermi="['spas:qb:question:add']">上传试卷</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-crop" size="mini" @click="openAnnotate" v-hasPermi="['spas:qb:question:add']">可视标注</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['spas:qb:question:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-search" size="mini" @click="goSelectCenter" v-hasPermi="['spas:qb:question:list']">选题中心</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="questionList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" prop="questionId" width="70" align="center" />
      <el-table-column label="学科" prop="subjectName" width="90" />
      <el-table-column label="题干" min-width="220">
        <template slot-scope="scope">
          <div class="qb-list-stem qb-list-stem--click" title="点击查看完整题目" @click.stop="openView(scope.row)">
            <qb-rich-content compact :content="scope.row.content" />
            <span class="qb-list-stem-more">查看全文</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="题型" width="90" align="center">
        <template slot-scope="scope">{{ viewTypeLabel(scope.row.questionType) }}</template>
      </el-table-column>
      <el-table-column label="难度" prop="difficulty" width="70" align="center">
        <template slot-scope="scope">
          <span>{{ { '1': '易', '2': '中', '3': '难' }[scope.row.difficulty] || scope.row.difficulty }}</span>
        </template>
      </el-table-column>
      <el-table-column label="知识点" width="90" align="center">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.knowledgeCount > 0" size="mini" type="success">{{ scope.row.knowledgeCount }}</el-tag>
          <el-tag v-else size="mini" type="info">未绑</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="300" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="openView(scope.row)">查看</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['spas:qb:question:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-magic-stick" @click="handleAi(scope.row)" v-hasPermi="['spas:qb:question:edit']">AI</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['spas:qb:question:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="880px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="学科" prop="subjectId">
          <el-select v-model="form.subjectId" placeholder="请选择学科" filterable style="width:100%" @change="onFormSubjectChange">
            <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
          </el-select>
        </el-form-item>
        <el-form-item label="题干" prop="content">
          <qb-field-editor
            ref="contentEditor"
            v-model="form.content"
            :rows="6"
            live-preview
            paste-as-ocr
            @ocr-image="ocrFromBlob"
            placeholder="工具栏快捷公式一点即插；「插入公式」可自定义；Ctrl+/ 打开"
            @blur="onContentBlur"
            @image-inserted="onStemInlineImage"
          />
          <div style="margin-top:6px">
            <el-button size="mini" plain icon="el-icon-magic-stick" @click="cleanStemDup">清理题干重复</el-button>
            <el-button size="mini" type="primary" plain icon="el-icon-edit-outline" :loading="formFormulaPolishing" @click="polishFormFormula">整理公式</el-button>
            <span style="margin-left:8px;font-size:12px;color:#909399">快捷芯片一键插入；双击公式可再编辑</span>
          </div>
          <div v-if="dupHint" style="color:#F56C6C;font-size:12px;margin-top:4px">{{ dupHint }}</div>
        </el-form-item>
        <el-form-item label="题干配图">
          <image-upload v-model="form.stemImage" :limit="1" :file-size="5" />
          <div style="margin-top:6px;display:flex;gap:8px;align-items:center;flex-wrap:wrap">
            <el-button size="mini" type="success" plain icon="el-icon-view" :loading="formOcring" @click="ocrStemImage">OCR 识别配图</el-button>
            <el-button size="mini" plain icon="el-icon-picture-outline" @click="$refs.formOcrFile && $refs.formOcrFile.click()">选择图片 OCR</el-button>
            <input ref="formOcrFile" type="file" accept="image/*" style="display:none" @change="onFormOcrFile" />
            <span style="font-size:12px;color:#909399">也可在题干框 Ctrl+V 粘贴截图识别</span>
          </div>
          <div style="font-size:12px;color:#909399;margin-top:4px">配图为题干整图；也可用上方 OCR 或粘贴截图填入文字</div>
        </el-form-item>
        <el-row>
          <el-col :span="8">
            <el-form-item label="题型" prop="questionType">
              <el-select v-model="form.questionType" filterable clearable style="width:100%" placeholder="学科题型">
                <el-option v-for="t in formTypeOptions" :key="t.typeCode" :label="t.typeName" :value="t.typeCode" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="难度" prop="difficulty">
              <el-select v-model="form.difficulty" style="width:100%">
                <el-option label="易" value="1" /><el-option label="中" value="2" /><el-option label="难" value="3" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="题目编码" prop="questionCode">
              <el-input v-model="form.questionCode" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item v-if="showOptionsField" label="选项" prop="options">
          <qb-field-editor
            v-model="form.options"
            :rows="3"
            live-preview
            placeholder="选择题选项，如 A. ... B. ...；可插入公式"
          />
        </el-form-item>
        <el-form-item v-if="showOptionsField" label="选项配图">
          <image-upload v-model="form.optionsImage" :limit="1" :file-size="5" />
        </el-form-item>
        <el-form-item label="答案" prop="correctAnswer">
          <qb-field-editor
            v-model="form.correctAnswer"
            :rows="2"
            live-preview
            placeholder="正确答案；填空/计算可写公式，多选可用 A,B"
          />
        </el-form-item>
        <el-form-item label="解析" prop="analysis">
          <qb-field-editor
            v-model="form.analysis"
            :rows="4"
            live-preview
            placeholder="解题要点／步骤；工具栏可插入公式与图片"
          />
        </el-form-item>
        <el-form-item label="解析配图">
          <image-upload v-model="form.analysisImage" :limit="1" :file-size="5" />
        </el-form-item>
        <el-form-item label="知识点权重">
          <div class="weight-sum" :class="weightSumOk ? 'ok' : 'bad'">权重和 {{ weightSum.toFixed(2) }} {{ weightSumOk ? '合格' : '（需≈1）' }}</div>
          
          <el-table :data="form.knowledgeList" size="mini" style="margin-top:6px" empty-text="请先树选知识点，或 AI 建议">
            <el-table-column label="主" width="50" align="center">
              <template slot-scope="scope">
                <el-radio v-model="primaryKnowledgeId" :label="scope.row.knowledgeId">&nbsp;</el-radio>
              </template>
            </el-table-column>
            <el-table-column label="知识点" prop="knowledgeName" min-width="160" />
            <el-table-column label="权重" width="120">
              <template slot-scope="scope">
                <el-input-number v-model="scope.row.weight" :min="0" :max="1" :step="0.05" :precision="2" size="mini" controls-position="right" style="width:100%" />
              </template>
            </el-table-column>
          </el-table>
          <div style="margin-top:8px">
            <el-button size="mini" type="primary" plain icon="el-icon-share" @click="openKnowledgeDialog" :disabled="!form.subjectId">树选知识点</el-button>
            <el-button size="mini" type="warning" plain icon="el-icon-magic-stick" @click="runAiInForm" :disabled="!(form.content || '').trim()" :loading="formAiLoading">AI 建议</el-button>
            <span v-if="!form.questionId" style="margin-left:8px;color:#909399;font-size:12px">未保存也可识别：先填题干后点 AI 建议</span>
          </div>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" :disabled="!!dupHint" @click="submitForm">确定</el-button>
        <el-button @click="open=false">取消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="选择知识点" :visible.sync="knowledgeOpen" width="720px" append-to-body>
      <el-input v-model="knowledgeFilterText" size="small" placeholder="搜索知识点" clearable style="margin-bottom:8px" @input="filterKnowledgeTree" />
      <el-tabs v-model="activeVersionId" type="card" @tab-click="handleVersionTabClick">
        <el-tab-pane v-for="tab in knowledgeVersionTabs" :key="tab.id" :label="tab.label" :name="String(tab.id)" />
      </el-tabs>
      <el-tree
        ref="knowledgeTree"
        :key="'kp-tree-' + activeVersionId"
        :data="knowledgeTree"
        show-checkbox
        node-key="knowledgeId"
        :props="{ label: 'knowledgeName', children: 'children', disabled: 'disabled' }"
        :filter-node-method="filterKnowledgeNode"
        default-expand-all
      />
      <div slot="footer">
        <el-button type="primary" @click="confirmKnowledge">确定</el-button>
        <el-button @click="knowledgeOpen=false">取消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="导入试卷（解析拆题）" :visible.sync="importOpen" width="92%" top="3vh" append-to-body :close-on-click-modal="false" custom-class="qb-import-dialog" @closed="onImportClosed">
      <el-alert type="info" :closable="false" show-icon style="margin-bottom:10px"
        title="支持 .docx / .pdf。扫描件 PDF 可点「OCR 识别」提取文字后拆题；docx 可在左侧 Word 预览框选补题。知识点需校对后再入库（不会直接写入掌握度）。" />
      <el-form :inline="true" size="small" label-width="56px" class="qb-import-toolbar">
        <el-form-item label="学科" required>
          <el-select v-model="importForm.subjectId" filterable placeholder="请选择学科" style="width:180px" @change="onImportSubjectChange">
            <el-option v-for="s in subjectOptions" :key="s.subjectId" :label="s.subjectName" :value="s.subjectId" />
          </el-select>
        </el-form-item>
        <el-form-item label="文件">
          <input ref="importFile" type="file" accept=".docx,.pdf,application/pdf,application/vnd.openxmlformats-officedocument.wordprocessingml.document" @change="onImportFileChange" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="importParsing" :disabled="!importForm.subjectId || !importFile" @click="doParsePaper">解析拆题</el-button>
        </el-form-item>
        <el-form-item v-if="importOcrNeeded || (importOcrPages && importOcrPages.length)">
          <el-button type="success" icon="el-icon-view" :loading="importOcring" :disabled="!importOcrPages.length" @click="runImportOcr">OCR 识别</el-button>
          <span v-if="importOcrProgress" style="margin-left:8px;color:#909399;font-size:12px">{{ importOcrProgress }}</span>
        </el-form-item>
        <el-form-item>
          <el-checkbox v-model="importForm.skipDuplicate">跳过内容重复题</el-checkbox>
        </el-form-item>
        <el-form-item v-if="importIsPdf">
          <el-button type="text" icon="el-icon-picture-outline" @click="openAnnotateFromImport">改用可视标注</el-button>
        </el-form-item>
      </el-form>
      <el-alert v-if="importWarn" type="warning" :closable="false" :title="importWarn" style="margin-bottom:8px" />

      <div class="qb-import-split">
        <div class="qb-import-left">
          <qb-word-preview
            v-if="importIsDocx && importPreviewFile"
            ref="wordPreview"
            :source="importPreviewFile"
            :file-name="importFileName"
            title="Word 预览"
            :select-mode.sync="importSelectMode"
            @rendered="onWordPreviewRendered"
            @region-select="onWordRegionSelect"
            @region-empty="onWordRegionEmpty"
          />
          <div v-else-if="importIsPdf && importPdfUrl" class="qb-pdf-wrap">
            <div class="qb-pdf-toolbar">
              <span class="qb-pdf-title">{{ importFileName }}</span>
              <span class="qb-pdf-tip">PDF 预览（A4）</span>
            </div>
            <iframe class="qb-pdf-frame" :src="importPdfUrl" title="pdf-preview" />
          </div>
          <div v-else class="qb-word-empty">
            <i class="el-icon-document" />
            <p>请上传 .docx 或 .pdf 试卷</p>
            <p class="sub">docx 支持 Word 预览框选区域补题；扫描 PDF 请用 OCR</p>
          </div>
        </div>
        <div class="qb-import-right">
          <div class="qb-import-right-hd">
            <span>题目校对</span>
            <template v-if="importItems.length">
              <el-button size="mini" @click="selectAllImport(true)">全选</el-button>
              <el-button size="mini" @click="selectAllImport(false)">全不选</el-button>
              <el-button size="mini" @click="selectNonDup">仅选非重复</el-button>
              <el-button size="mini" type="success" plain icon="el-icon-magic-stick" :loading="importSmarting" @click="doSmartAnnotate">智能识别</el-button>
              <el-button size="mini" type="primary" plain icon="el-icon-edit-outline" :loading="importFormulaPolishing" @click="polishImportFormulas">整理公式</el-button>
              <el-button size="mini" type="warning" plain icon="el-icon-price-tag" @click="openImportKpBatch">批量标注</el-button>
              <span class="qb-import-count">已解析 {{ importItems.length }} 题，已勾选 {{ importSelectedCount }} 题</span>
            </template>
          </div>
          <el-table v-if="importItems.length" ref="importTable" :data="importItems" size="mini" height="calc(78vh - 220px)" border highlight-current-row class="import-q-table" @row-click="onImportRowClick" @current-change="onImportCurrentChange">
            <el-table-column label="入库" width="54" align="center">
              <template slot-scope="scope"><el-checkbox v-model="scope.row.selected" /></template>
            </el-table-column>
            <el-table-column label="题号" width="64" align="center">
              <template slot-scope="scope"><el-input v-model="scope.row.questionNo" size="mini" /></template>
            </el-table-column>
            <el-table-column label="题干" min-width="200">
              <template slot-scope="scope">
                <el-input type="textarea" :rows="2" v-model="scope.row.content" size="mini" />
                <div v-if="scope.row.content" class="import-formula" v-html="importFormulaHtml(scope.row.content)" />
              </template>
            </el-table-column>
            <el-table-column label="图" width="96" align="center">
              <template slot-scope="scope">
                <div v-if="scope.row.stemImage || (scope.row.imageUrls && scope.row.imageUrls.length)" class="import-imgs">
                  <el-image
                    v-for="(u, ui) in (scope.row.imageUrls && scope.row.imageUrls.length ? scope.row.imageUrls : [scope.row.stemImage])"
                    :key="ui"
                    :src="mediaUrl(u)"
                    :preview-src-list="(scope.row.imageUrls && scope.row.imageUrls.length ? scope.row.imageUrls : [scope.row.stemImage]).map(mediaUrl)"
                    fit="contain"
                    class="import-thumb"
                  />
                </div>
                <span v-else style="color:#c0c4cc">-</span>
              </template>
            </el-table-column>
            <el-table-column label="题型" width="100">
              <template slot-scope="scope">
                <el-select v-model="scope.row.questionType" size="mini" filterable clearable style="width:100%">
                  <el-option v-for="t in importTypeOptions" :key="t.typeCode" :label="t.typeName" :value="t.typeCode" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column label="难度" width="78">
              <template slot-scope="scope">
                <el-select v-model="scope.row.difficulty" size="mini" style="width:100%">
                  <el-option label="易" value="1" /><el-option label="中" value="2" /><el-option label="难" value="3" />
                </el-select>
              </template>
            </el-table-column>
                        <el-table-column label="章节" width="110" show-overflow-tooltip>
              <template slot-scope="scope">{{ scope.row.chapterName || '-' }}</template>
            </el-table-column>
            <el-table-column label="知识点" min-width="140">
              <template slot-scope="scope">
                <div class="import-kp-cell">
                  <span v-if="scope.row.knowledgeList && scope.row.knowledgeList.length" class="import-kp-text">
                    {{ (scope.row.knowledgeList || []).map(k => k.knowledgeName).filter(Boolean).join('、') }}
                  </span>
                  <span v-else style="color:#c0c4cc">未标注</span>
                  <el-button type="text" size="mini" @click.stop="openImportKp(scope.row, scope.$index)">编辑</el-button>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="标注" width="92" align="center">
              <template slot-scope="scope">
                <el-tag v-if="scope.row.annotateMode === 'remote'" type="success" size="mini">远程</el-tag>
                <el-tag v-else-if="scope.row.annotateMode === 'heuristic'" type="info" size="mini">启发</el-tag>
                <el-tag v-else-if="scope.row.annotateMode && String(scope.row.annotateMode).indexOf('remote-fail') === 0" type="warning" size="mini">回退</el-tag>
                <span v-else style="color:#c0c4cc">-</span>
              </template>
            </el-table-column>
<el-table-column label="重复" width="80" align="center">
              <template slot-scope="scope">
                <el-tag v-if="scope.row.duplicate" type="danger" size="mini">ID {{ scope.row.duplicateId }}</el-tag>
                <span v-else>-</span>
              </template>
            </el-table-column>
          </el-table>
          <div v-else class="qb-import-right-empty">
            <p>解析后题目将显示在此处</p>
            <p class="sub">可核对题干、题型、难度与知识点后入库</p>
            <el-collapse v-if="importRawPreview" style="margin-top:12px;text-align:left">
              <el-collapse-item title="原始文本预览" name="raw">
                <pre class="qb-raw-pre">{{ importRawPreview }}</pre>
              </el-collapse-item>
            </el-collapse>
          </div>
        </div>
      </div>
      <div slot="footer">
        <el-button type="primary" :loading="importSaving" :disabled="!importSelectedCount" @click="doBatchInsert">确认入库</el-button>
        <el-button @click="importOpen=false">关闭</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="importKpBatchMode ? '批量标注知识点' : '标注知识点'" :visible.sync="importKpOpen" width="560px" append-to-body :close-on-click-modal="false">
      <el-alert type="info" :closable="false" show-icon style="margin-bottom:10px"
        :title="importKpBatchMode ? '将应用到所有已勾选题目' : '仅应用到当前编辑的该题'" />
      <el-form size="small" label-width="72px">
        <el-form-item label="章节">
          <el-select v-model="importKpForm.chapterId" filterable clearable placeholder="可选" style="width:100%" @change="onImportChapterChange">
            <el-option v-for="c in importChapterOptions" :key="c.knowledgeId" :label="c.knowledgeName" :value="c.knowledgeId" />
          </el-select>
        </el-form-item>
        <el-form-item label="知识点">
          <el-input v-model="importKpFilter" size="mini" clearable placeholder="搜索" style="margin-bottom:6px" @input="filterImportKpTree" />
          <el-tree
            ref="importKpTree"
            :data="importKpTreeData"
            show-checkbox
            node-key="knowledgeId"
            :props="{ label: 'knowledgeName', children: 'children', disabled: 'disabled' }"
            :filter-node-method="filterImportKpNode"
            default-expand-all
            style="max-height:320px;overflow:auto;border:1px solid #ebeef5;padding:6px;border-radius:4px"
          />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button type="primary" @click="confirmImportKp">确定</el-button>
        <el-button @click="clearImportKp">清空</el-button>
        <el-button @click="importKpOpen=false">取消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="题目详情" :visible.sync="viewOpen" width="820px" append-to-body top="6vh" custom-class="qb-view-dialog">
      <div v-loading="viewLoading" class="qb-view">
        <template v-if="viewDetail">
          <div class="qb-view-meta">
            <el-tag size="mini" type="info">ID {{ viewDetail.questionId }}</el-tag>
            <el-tag size="mini">{{ viewDetail.subjectName || ('学科#' + viewDetail.subjectId) }}</el-tag>
            <el-tag size="mini">{{ viewTypeLabel(viewDetail.questionType) }}</el-tag>
            <el-tag size="mini" type="warning">{{ viewDiffLabel(viewDetail.difficulty) }}</el-tag>
            <el-tag v-if="viewDetail.questionCode" size="mini" type="success">{{ viewDetail.questionCode }}</el-tag>
          </div>
          <div class="qb-view-section">
            <div class="qb-view-label">题干</div>
            <div class="qb-view-body"><qb-rich-content :content="viewDetail.content" /></div>
            <div v-if="viewDetail.stemImage" class="qb-view-img">
              <el-image :src="mediaUrl(viewDetail.stemImage)" :preview-src-list="[mediaUrl(viewDetail.stemImage)]" fit="contain" />
            </div>
          </div>
          <div v-if="viewDetail.options" class="qb-view-section">
            <div class="qb-view-label">选项</div>
            <div class="qb-view-body"><qb-rich-content :content="viewDetail.options" /></div>
            <div v-if="viewDetail.optionsImage" class="qb-view-img">
              <el-image :src="mediaUrl(viewDetail.optionsImage)" :preview-src-list="[mediaUrl(viewDetail.optionsImage)]" fit="contain" />
            </div>
          </div>
          <div v-if="viewDetail.correctAnswer" class="qb-view-section">
            <div class="qb-view-label">答案</div>
            <div class="qb-view-body"><qb-rich-content :content="viewDetail.correctAnswer" /></div>
          </div>
          <div v-if="viewDetail.analysis" class="qb-view-section">
            <div class="qb-view-label">解析</div>
            <div class="qb-view-body"><qb-rich-content :content="viewDetail.analysis" /></div>
            <div v-if="viewDetail.analysisImage" class="qb-view-img">
              <el-image :src="mediaUrl(viewDetail.analysisImage)" :preview-src-list="[mediaUrl(viewDetail.analysisImage)]" fit="contain" />
            </div>
          </div>
          <div class="qb-view-section">
            <div class="qb-view-label">知识点</div>
            <div v-if="viewDetail.knowledgeList && viewDetail.knowledgeList.length" class="qb-view-kp">
              <el-tag
                v-for="(k, ki) in viewDetail.knowledgeList"
                :key="k.knowledgeId + '-' + ki"
                size="mini"
                :type="k.isPrimary === '1' ? 'danger' : ''"
                style="margin:0 6px 6px 0"
              >{{ k.knowledgeName || ('#' + k.knowledgeId) }}{{ k.weight != null ? (' · ' + k.weight) : '' }}</el-tag>
            </div>
            <div v-else class="qb-view-empty">未绑定知识点</div>
          </div>
        </template>
      </div>
      <div slot="footer">
        <el-button type="primary" size="mini" icon="el-icon-edit" @click="viewThenEdit" v-hasPermi="['spas:qb:question:edit']">去修改</el-button>
        <el-button size="mini" @click="viewOpen=false">关闭</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="aiDialogTitle" :visible.sync="aiOpen" width="640px" append-to-body>
      <el-alert type="info" :closable="false" show-icon title="建议不会进入掌握度；采纳后写入题库已审知识点。" style="margin-bottom:10px" />
      <div v-if="aiMode" style="margin-bottom:8px">
        <el-tag size="mini" :type="aiModeTagType">{{ aiModeLabel }}</el-tag>
        <span v-if="aiModeDetail" style="margin-left:8px;color:#909399;font-size:12px">{{ aiModeDetail }}</span>
      </div>
      <el-table :data="aiItems" @selection-change="onAiSelect">
        <el-table-column type="selection" width="45" />
        <el-table-column label="知识点" prop="knowledgeName" />
        <el-table-column label="权重" prop="weight" width="80" />
        <el-table-column label="理由" prop="reason" :show-overflow-tooltip="true" />
      </el-table>
      <div slot="footer">
        <el-button type="primary" :disabled="!aiSelected.length" @click="adoptAi">采纳建议</el-button>
        <el-button @click="aiOpen=false">取消</el-button>
      </div>
    </el-dialog>

    <spas-qb-annotate :visible.sync="annotateOpen" @done="getList" />
  </div>
</template>

<script>
import { listQbQuestion, getQbQuestion, addQbQuestion, updateQbQuestion, delQbQuestion, checkQbDup, saveQbKnowledge, aiSuggestQbKnowledge, parseQbPaper, parseQbOcrText, smartAnnotateQb, batchAddQbQuestion, polishQbFormula, polishQbFormulaBatch, cleanupQbOcrSession } from '@/api/spas/qb/question'
import { optionselectSubject } from '@/api/spas/subject'
import { optionselectQuestionType } from '@/api/spas/questionType'
import { treeKnowledge } from '@/api/spas/knowledge'
import SpasQbAnnotate from './annotate.vue'
import QbRichContent from '@/components/spas/QbRichContent'
import QbFieldEditor from '@/components/spas/QbFieldEditor'
import QbWordPreview from '@/components/spas/QbWordPreview'
import { renderFormulaHtml, dedupeStemContent, cleanupOcrText, recognizeImage, terminateOcrWorker } from '@/utils/qbFormula'
import { qbTypeLabel } from '@/utils/qbTypeLabel'

export default {
  name: 'SpasQbQuestion',
  components: { SpasQbAnnotate, QbRichContent, QbWordPreview, QbFieldEditor },
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      questionList: [],
      subjectOptions: [],
      typeOptions: [],
      formTypeOptions: [],
      ids: [],
      multiple: true,
      open: false,
      title: '',
      viewOpen: false,
      viewLoading: false,
      viewDetail: null,
      dupHint: '',
      aiOpen: false,
      aiItems: [],
      aiSelected: [],
      aiQuestionId: null,
      aiMode: '',
      importOpen: false,
      annotateOpen: false,
      importParsing: false,
      importSmarting: false,
      importOcring: false,
      formOcring: false,
      formAiLoading: false,
      formFormulaPolishing: false,
      importFormulaPolishing: false,
      importOcrNeeded: false,
      importOcrSessionId: '',
      importOcrPages: [],
      importOcrProgress: '',
      importSaving: false,
      importFile: null,
      importPreviewFile: null,
      importPdfUrl: '',
      importFileName: '',
      importIsDocx: false,
      importIsPdf: false,
      importWarn: '',
      importRawPreview: '',
      importItems: [],
      importSelectMode: false,
      importActiveRowIndex: -1,
      importTypeOptions: [],
      importForm: { subjectId: undefined, skipDuplicate: true },
      importKpOpen: false,
      importKpBatchMode: false,
      importKpRowIndex: -1,
      importKpFilter: '',
      importKpForm: { chapterId: undefined, chapterName: '' },
      importKnowledgeFullTree: [],
      importChapterOptions: [],
      importKpTreeData: [],
      knowledgeOpen: false,
      knowledgeFullTree: [],
      knowledgeVersionTabs: [],
      knowledgeTree: [],
      activeVersionId: '',
      knowledgeFilterText: '',
      primaryKnowledgeId: undefined,
      queryParams: { pageNum: 1, pageSize: 10, subjectId: undefined, content: undefined, questionType: undefined, unboundOnly: false },
      form: {},
      rules: {
        subjectId: [{ required: true, message: '请选择学科', trigger: 'change' }],
        content: [{ required: true, message: '请填写题干', trigger: 'blur' }]
      }
    }
  },
  computed: {
    weightSum() {
      return (this.form.knowledgeList || []).reduce((s, k) => s + Number(k.weight || 0), 0)
    },
    weightSumOk() {
      return Math.abs(this.weightSum - 1) < 0.02 || !(this.form.knowledgeList || []).length
    },
    showOptionsField() {
      const t = String((this.form && this.form.questionType) || '')
      return !t || t === 'choice' || t === 'single' || t === 'multi' || t === 'judge' || t.indexOf('choice') >= 0
    },

    importSelectedCount() {
      return (this.importItems || []).filter(i => i.selected).length
    },
    aiDialogTitle() {
      return this.aiModeLabel ? ('AI 知识点建议 \u00b7 ' + this.aiModeLabel) : 'AI 知识点建议'
    },
    aiModeLabel() {
      const m = String(this.aiMode || '')
      if (m === 'remote') return '远程'
      if (m === 'heuristic') return '启发式'
      if (m.indexOf('heuristic-fallback') === 0) return '启发式(回退)'
      return m || ''
    },
    aiModeTagType() {
      const m = String(this.aiMode || '')
      if (m === 'remote') return 'success'
      if (m.indexOf('heuristic-fallback') === 0) return 'warning'
      return 'info'
    },
    aiModeDetail() {
      const m = String(this.aiMode || '')
      if (m.indexOf('heuristic-fallback:') === 0) {
        return m.slice('heuristic-fallback:'.length)
      }
      return ''
    }
  },
  created() {
    optionselectSubject().then(res => { this.subjectOptions = res.data || [] })
    this.getList()
  },
  methods: {
    importFormulaHtml(text) {
      return renderFormulaHtml(text)
    },
    loadTypes(subjectId, target) {
      if (!subjectId) {
        if (target === 'form') this.formTypeOptions = []
        else if (target === 'import') this.importTypeOptions = []
        else this.typeOptions = []
        return
      }
      optionselectQuestionType(subjectId).then(res => {
        const list = res.data || []
        if (target === 'form') this.formTypeOptions = list
        else if (target === 'import') this.importTypeOptions = list
        else this.typeOptions = list
      })
    },
    getList() {
      this.loading = true
      const q = Object.assign({}, this.queryParams)
      if (!q.unboundOnly) delete q.unboundOnly
      listQbQuestion(q).then(res => {
        this.questionList = res.rows || []
        this.total = res.total || 0
        this.loading = false
      }).catch(() => { this.loading = false })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      if (this.queryParams.subjectId) this.loadTypes(this.queryParams.subjectId, 'query')
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.queryParams.unboundOnly = false
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(i => i.questionId)
      this.multiple = !selection.length
    },
    reset() {
      this.form = { questionId: undefined, subjectId: undefined, content: '', options: '', correctAnswer: '', questionType: undefined, difficulty: '2', questionCode: '', analysis: '', stemImage: '', optionsImage: '', analysisImage: '', knowledgeList: [] }
      this.dupHint = ''
      this.primaryKnowledgeId = undefined
      this.formTypeOptions = []
      this.resetForm('form')
    },

    onAddCommand(cmd) {
      if (cmd === 'import') this.openImport()
      else if (cmd === 'annotate') this.openAnnotate()
      else this.handleAdd()
    },
    mediaUrl(url) {
      if (!url) return ''
      if (url.indexOf('http') === 0) return url
      return process.env.VUE_APP_BASE_API + url
    },
    openAnnotate() {
      this.annotateOpen = true
    },
    openImport() {
      this.revokeImportPdfUrl()
      this.importKpOpen = false
      this.importOpen = true
      this.importWarn = ''
      this.importRawPreview = ''
      this.importItems = []
      this.importSelectMode = false
      this.importActiveRowIndex = -1
      this.importFile = null
      this.importPreviewFile = null
      this.importFileName = ''
      this.importIsDocx = false
      this.importIsPdf = false
      this.importForm.skipDuplicate = true
      if (!this.importForm.subjectId && this.queryParams.subjectId) {
        this.importForm.subjectId = this.queryParams.subjectId
        this.onImportSubjectChange(this.importForm.subjectId)
      } else if (this.importForm.subjectId) {
        this.loadImportKnowledgeTree(this.importForm.subjectId)
      }
      this.$nextTick(() => {
        if (this.$refs.importFile) this.$refs.importFile.value = ''
      })
    },
    onImportClosed() {
      const sid = this.importOcrSessionId
      this.importOcrNeeded = false
      this.importOcrSessionId = ''
      this.importOcrPages = []
      this.importOcrProgress = ''
      this.revokeImportPdfUrl()
      this.importPreviewFile = null
      this.importSelectMode = false
      this.importActiveRowIndex = -1
      if (sid) {
        cleanupQbOcrSession(sid).catch(() => {})
      }
    },
    revokeImportPdfUrl() {
      if (this.importPdfUrl) {
        try { URL.revokeObjectURL(this.importPdfUrl) } catch (e) { /* ignore */ }
        this.importPdfUrl = ''
      }
    },
    openAnnotateFromImport() {
      this.importOpen = false
      this.openAnnotate()
    },
    onImportSubjectChange(v) {
      this.loadTypes(v, 'import')
      this.loadImportKnowledgeTree(v)
    },
    onImportFileChange(e) {
      const files = e.target.files
      const f = files && files.length ? files[0] : null
      this.revokeImportPdfUrl()
      this.importFile = f
      this.importPreviewFile = null
      this.importFileName = f ? (f.name || '') : ''
      const name = (this.importFileName || '').toLowerCase()
      this.importIsDocx = !!(f && name.endsWith('.docx'))
      this.importIsPdf = !!(f && name.endsWith('.pdf'))
      if (this.importIsDocx) {
        this.importPreviewFile = f
      } else if (this.importIsPdf) {
        this.importPdfUrl = URL.createObjectURL(f)
      }
    },
    doParsePaper() {
      if (!this.importForm.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      if (!this.importFile) {
        this.$modal.msgWarning('请上传 docx 或 pdf 文件')
        return
      }
      const fd = new FormData()
      fd.append('file', this.importFile)
      fd.append('subjectId', this.importForm.subjectId)
      this.importParsing = true
      parseQbPaper(fd).then(res => {
        const d = res.data || {}
        this.importWarn = d.warn || ''
        this.importRawPreview = d.rawPreview || ''
        this.importItems = (d.items || []).map(it => Object.assign({
          selected: it.selected !== false,
          difficulty: it.difficulty || '2',
          questionType: it.questionType || 'short',
          chapterId: it.chapterId || undefined,
          chapterName: it.chapterName || '',
          knowledgeList: it.knowledgeList || []
        }, it))
        if (this.importForm.subjectId) this.loadImportKnowledgeTree(this.importForm.subjectId)
        this.importOcrNeeded = !!d.ocrNeeded
        this.importOcrSessionId = d.ocrSessionId || ''
        this.importOcrPages = d.pageImageUrls || []
        this.importOcrProgress = ''
        if (this.importOcrNeeded && this.importOcrPages.length) {
          this.$modal.confirm('检测到扫描件（' + this.importOcrPages.length + ' 页图）。请保证扫描清晰、正向；浏览器本地 OCR（chi_sim+eng），页数受服务端预算限制。是否立即识别？', 'OCR', {
            confirmButtonText: '开始识别',
            cancelButtonText: '稍后',
            type: 'info'
          }).then(() => this.runImportOcr()).catch(() => {})
        }
        if (!this.importItems.length) {
          this.$modal.msgWarning('未解析出题目；若为扫描件请使用 OCR 识别')
        } else {
          const kpN = this.importItems.filter(i => i.knowledgeList && i.knowledgeList.length).length
          this.$modal.msgSuccess('已解析 ' + this.importItems.length + ' 题' + (kpN ? '，智能标注 ' + kpN + ' 题' : '') + '，请校对后入库')
          this.polishImportFormulas({ silent: true }).catch(() => {})
        }
      }).finally(() => { this.importParsing = false })
    },
    onWordPreviewRendered() {
      this._wordPreviewReady = true
    },
    onImportCurrentChange(row) {
      if (!row) {
        this.importActiveRowIndex = -1
        return
      }
      this.importActiveRowIndex = this.importItems.indexOf(row)
    },
    onImportRowClick(row, column, event) {
      if (!row) return
      const idx = this.importItems.indexOf(row)
      if (idx >= 0) this.importActiveRowIndex = idx
      if (this.$refs.importTable) this.$refs.importTable.setCurrentRow(row)
      const t = event && event.target
      if (t && t.closest && t.closest('.el-checkbox,.el-select,.el-input,.el-textarea,.el-button,.el-image,.el-radio')) {
        return
      }
      if (this.importSelectMode) return
      // PDF: row click only highlights; Word locate needs preview
      if (!this.importIsDocx) return
      if (!this._wordPreviewReady) {
        this.$modal.msgWarning('请先等待 Word 预览加载完成')
        return
      }
      const preview = this.$refs.wordPreview
      if (!preview || typeof preview.locateQuestion !== 'function') {
        this.$modal.msgWarning('请先在预览中框选区域')
        return
      }
      const ok = preview.locateQuestion(row)
      if (!ok) {
        this.$modal.msgWarning('框选区域未识别到有效文字')
      }
    },
    onWordRegionEmpty() {
      this.$modal.msgWarning('请先解析或框选补题后再操作')
    },
    onWordRegionSelect(payload) {
      if (!payload) return
      let idx = this.importActiveRowIndex
      if (idx < 0 || !this.importItems[idx]) {
        if (!this.importItems.length) {
          const row = {
            selected: true,
            questionNo: '1',
            content: '',
            questionType: (this.importTypeOptions[0] && this.importTypeOptions[0].typeCode) || 'choice',
            difficulty: '2',
            imageUrls: [],
            stemImage: '',
            duplicate: false,
            knowledgeList: []
          }
          this.importItems.push(row)
          idx = 0
          this.importActiveRowIndex = 0
          this.$nextTick(() => {
            if (this.$refs.importTable) this.$refs.importTable.setCurrentRow(row)
          })
        } else {
          this.$modal.msgWarning('请先在右侧选中一道题')
          return
        }
      }
      const row = this.importItems[idx]
      const imgs = (payload.imageUrls || []).filter(Boolean)
      let text = (payload.text || '').trim()
      if (imgs.length) {
        const md = imgs.map(u => '![](' + u + ')').join('\n')
        if (text) {
          const missing = imgs.filter(u => text.indexOf(u) < 0)
          if (missing.length) text = text + '\n' + missing.map(u => '![](' + u + ')').join('\n')
        } else {
          text = md
        }
      }
      if (text) this.$set(row, 'content', cleanupOcrText(text) || text)
      if (imgs.length) {
        this.$set(row, 'imageUrls', imgs.slice())
        this.$set(row, 'stemImage', imgs[0])
      }
      this.$set(row, 'selected', true)
      this.$modal.msgSuccess('已填入第 ' + (idx + 1) + ' 题' + (imgs.length ? ' (含 ' + imgs.length + ' 图)' : ''))
    },
    async runImportOcr() {
      if (!this.importForm.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      const pages = this.importOcrPages || []
      if (!pages.length) {
        this.$modal.msgWarning('没有可 OCR 的页图')
        return
      }
      this.importOcring = true
      this.importOcrProgress = ''
      try {
        const parts = []
        for (let i = 0; i < pages.length; i++) {
          this.importOcrProgress = 'OCR ' + (i + 1) + '/' + pages.length
          const url = this.mediaUrl(pages[i])
          const text = await recognizeImage(url)
          if (text) parts.push(text)
        }
        const joined = parts.join('\n\n')
        if (!joined || joined.replace(/\s+/g, '').length < 10) {
          this.$modal.msgError('OCR 未识别到有效文字，请检查图片清晰度或改用可视标注')
          return
        }
        this.importOcrProgress = '正在拆题...'
        const res = await parseQbOcrText({
          subjectId: this.importForm.subjectId,
          text: joined,
          fileName: (this.importFileName || 'scan.pdf') + '.ocr'
        })
        const d = res.data || {}
        this.importWarn = d.warn || ''
        this.importRawPreview = d.rawPreview || joined.slice(0, 2000)
        this.importOcrNeeded = false
        this.importItems = (d.items || []).map(it => Object.assign({
          selected: it.selected !== false,
          questionType: it.questionType,
          difficulty: it.difficulty || '2',
          knowledgeList: it.knowledgeList || [],
          annotateMode: it.annotateMode || '',
          chapterId: it.chapterId,
          chapterName: it.chapterName || ''
        }, it))
        const kpN = this.importItems.filter(i => i.knowledgeList && i.knowledgeList.length).length
        let tip = 'OCR 完成，解析 ' + this.importItems.length + ' 题'
        if (kpN) tip += '，智能标注 ' + kpN + ' 题'
        this.$modal.msgSuccess(tip)
        if (this.importItems.length) {
          this.importOcrProgress = '正在整理公式...'
          try { await this.polishImportFormulas({ silent: true }) } catch (e4) { /* keep raw */ }
        }
        if (this.importItems.length && !kpN) {
          this.importOcrProgress = '正在智能标注...'
          try {
            await this.doSmartAnnotateAsync()
          } catch (e3) {
            this.$modal.msgWarning('智能标注未成功，可手动点「智能识别」')
          }
        }
      } catch (e) {
        this.$modal.msgError((e && e.message) || 'OCR 失败')
      } finally {
        this.importOcring = false
        this.importOcrProgress = ''
        try { await terminateOcrWorker() } catch (e2) { /* ignore */ }
      }
    },

    doSmartAnnotate() {
      this.doSmartAnnotateAsync().catch(e => {
        this.$modal.msgError((e && e.message) || '智能识别失败')
      })
    },
    async doSmartAnnotateAsync() {
      if (!this.importForm.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return null
      }
      if (!this.importItems.length) {
        this.$modal.msgWarning('请先解析拆题')
        return null
      }
      const targets = []
      this.importItems.forEach((row, idx) => {
        if (row.selected === false || !(row.content || '').trim()) return
        targets.push({
          rowIndex: idx,
          questionNo: row.questionNo,
          content: row.content,
          questionType: row.questionType,
          difficulty: row.difficulty
        })
      })
      if (!targets.length) {
        this.$modal.msgWarning('请至少勾选一道题')
        return null
      }
      this.importSmarting = true
      try {
        const res = await smartAnnotateQb({ subjectId: this.importForm.subjectId, items: targets })
        const payload = res.data
        const annotated = Array.isArray(payload) ? payload : ((payload && payload.items) || [])
        const stats = (!Array.isArray(payload) && payload && payload.stats) ? payload.stats : null
        annotated.forEach(a => {
          if (!a) return
          let row = null
          if (a.rowIndex != null && this.importItems[a.rowIndex]) {
            row = this.importItems[a.rowIndex]
          } else if (a.questionNo) {
            row = this.importItems.find(r => r.questionNo === a.questionNo)
          }
          if (!row) return
          if (a.questionType) this.$set(row, 'questionType', a.questionType)
          if (a.difficulty) this.$set(row, 'difficulty', a.difficulty)
          if (a.chapterId) {
            this.$set(row, 'chapterId', a.chapterId)
            this.$set(row, 'chapterName', a.chapterName || '')
          }
          if (a.knowledgeList && a.knowledgeList.length) {
            this.$set(row, 'knowledgeList', a.knowledgeList)
            this.$set(row, 'knowledgeConfirmed', false)
          }
          if (a.annotateMode) this.$set(row, 'annotateMode', a.annotateMode)
        })
        const kpN = stats ? stats.withKp : annotated.filter(a => a && a.knowledgeList && a.knowledgeList.length).length
        let msg = '智能识别完成：命中 ' + kpN + ' 题'
        if (stats) {
          msg += '(启发 ' + (stats.heuristic || 0) + ' / 远程 ' + (stats.remote || 0)
          if (stats.remoteFail) msg += ' / 失败 ' + stats.remoteFail
          msg += ')'
        }
        this.$modal.msgSuccess(msg)
        return { kpN, stats }
      } finally {
        this.importSmarting = false
      }
    },

    selectAllImport(flag) {
      (this.importItems || []).forEach(i => { i.selected = !!flag })
    },
    selectNonDup() {
      (this.importItems || []).forEach(i => { i.selected = !i.duplicate })
    },
    doBatchInsert() {
      const items = (this.importItems || []).filter(i => i.selected && (i.content || '').trim())
      if (!items.length) {
        this.$modal.msgWarning('请至少勾选一道题')
        return
      }
      const kpItems = items.filter(i => i.knowledgeList && i.knowledgeList.length)
      const run = (acceptAiKnowledge) => {
        this.importSaving = true
        const payloadItems = items.map(i => {
          const row = Object.assign({}, i)
          if (acceptAiKnowledge && row.knowledgeList && row.knowledgeList.length) {
            row.knowledgeConfirmed = true
          } else if (!acceptAiKnowledge) {
            row.knowledgeList = []
            row.knowledgeConfirmed = false
          }
          return row
        })
        batchAddQbQuestion({
          subjectId: this.importForm.subjectId,
          skipDuplicate: this.importForm.skipDuplicate,
          acceptAiKnowledge: !!acceptAiKnowledge,
          items: payloadItems
        }).then(res => {
          const d = res.data || {}
          const sid = this.importForm.subjectId
          this.$modal.msgSuccess('入库 ' + (d.inserted || 0) + ' / 跳过 ' + (d.skipped || 0) + ' / 失败 ' + (d.failed || 0))
          this.importOpen = false
          this.getList()
          if ((d.inserted || 0) > 0) {
            this.$confirm('是否前往选题中心组卷？', '入库成功', {
              confirmButtonText: '前往选题中心',
              cancelButtonText: '留在本页',
              type: 'success'
            }).then(() => {
              this.$router.push({ path: '/spas/qb/select', query: { subjectId: sid } }).catch(() => {})
            }).catch(() => {})
          }
        }).finally(() => { this.importSaving = false })
      }
      if (kpItems.length) {
        this.$confirm(
          '所选题中有 ' + kpItems.length + ' 道含智能标注知识点。确认已人工校对后才会写入知识点；也可选择「不带知识点入库」。',
          '确认审阅',
          {
            type: 'warning',
            distinguishCancelAndClose: true,
            confirmButtonText: '已校对，带知识点入库',
            cancelButtonText: '不带知识点入库'
          }
        ).then(() => run(true)).catch(action => {
          if (action === 'cancel') run(false)
        })
      } else {
        run(false)
      }
    },

    openView(row) {
      if (!row || !row.questionId) return
      this.viewOpen = true
      this.viewLoading = true
      this.viewDetail = Object.assign({}, row)
      getQbQuestion(row.questionId).then(res => {
        this.viewDetail = res.data || row
      }).finally(() => { this.viewLoading = false })
    },
    viewThenEdit() {
      const row = this.viewDetail
      this.viewOpen = false
      if (row) this.handleUpdate(row)
    },
    viewDiffLabel(d) {
      return ({ '1': '易', '2': '中', '3': '难' })[d] || d || '-'
    },
    viewTypeLabel(code) {
      const hit = (this.typeOptions || []).find(t => t.typeCode === code)
      return (hit && hit.typeName) || qbTypeLabel(code)
    },
    goSelectCenter() {
      const sid = this.queryParams.subjectId
      this.$router.push({
        path: '/spas/qb/select',
        query: sid ? { subjectId: sid } : {}
      }).catch(() => {})
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '单题新增'
    },
    handleUpdate(row) {
      this.reset()
      getQbQuestion(row.questionId).then(res => {
        this.form = Object.assign({ knowledgeList: [] }, res.data || {})
        if (!this.form.knowledgeList) this.form.knowledgeList = []
        if (this.form.content) {
          const cleaned = dedupeStemContent(this.form.content)
          if (cleaned && cleaned !== this.form.content) this.form.content = cleaned
        }
        const primary = this.form.knowledgeList.find(k => k.isPrimary === '1')
        this.primaryKnowledgeId = primary ? primary.knowledgeId : (this.form.knowledgeList[0] && this.form.knowledgeList[0].knowledgeId)
        this.loadTypes(this.form.subjectId, 'form')
        this.open = true
        this.title = '修改题目'
      })
    },
    onFormSubjectChange(v) {
      this.loadTypes(v, 'form')
      this.form.questionType = undefined
      this.form.knowledgeList = []
    },
    onStemInlineImage(url) {
      if (!this.form.stemImage && url) this.$set(this.form, 'stemImage', url)
    },
    async ocrStemImage() {
      const url = this.form.stemImage
      if (!url) { this.$modal.msgWarning('请先上传题干配图'); return }
      this.formOcring = true
      try {
        const text = await recognizeImage(this.mediaUrl(url))
        this.applyOcrTextToStem(text)
      } catch (e) { this.$modal.msgError((e && e.message) || 'OCR 失败') }
      finally { this.formOcring = false; try { await terminateOcrWorker() } catch (e2) {} }
    },
    onFormOcrFile(e) {
      const f = e.target.files && e.target.files[0]
      if (this.$refs.formOcrFile) this.$refs.formOcrFile.value = ''
      if (f) this.ocrFromBlob(f)
    },
    async ocrFromBlob(file) {
      this.formOcring = true
      try {
        const text = await recognizeImage(file)
        this.applyOcrTextToStem(text)
      } catch (e) { this.$modal.msgError((e && e.message) || 'OCR 失败') }
      finally { this.formOcring = false; try { await terminateOcrWorker() } catch (e2) {} }
    },
    applyOcrTextToStem(text) {
      const cleaned = cleanupOcrText(text || '')
      if (!cleaned || cleaned.replace(/\s+/g, '').length < 2) {
        this.$modal.msgWarning('未识别到有效文字'); return
      }
      const cur = (this.form.content || '').trim()
      this.form.content = cur ? (cur + '\n' + cleaned) : cleaned
      if (this.onContentBlur) this.onContentBlur()
      this.$modal.msgSuccess('OCR 已填入题干，请校对')
      polishQbFormula({ content: this.form.content }).then(res => {
        const d = res.data || {}
        if (d.content) this.form.content = d.content
      }).catch(() => {})
    },
    polishFormFormula() {
      if (!(this.form.content || '').trim()) {
        this.$modal.msgWarning('请先填写题干'); return
      }
      this.formFormulaPolishing = true
      polishQbFormula({ content: this.form.content }).then(res => {
        const d = res.data || {}
        if (d.content) this.form.content = d.content
        const mode = d.mode === 'remote' ? ' (远程 AI)' : ' (本地)'
        this.$modal.msgSuccess((d.changed ? '公式已整理' : '无需修改') + mode)
        if (this.onContentBlur) this.onContentBlur()
      }).catch(e => {
        this.$modal.msgError((e && (e.message || e.msg)) || '整理失败')
      }).finally(() => { this.formFormulaPolishing = false })
    },
    async polishImportFormulas(opts) {
      const silent = !!(opts && opts.silent)
      const rows = (this.importItems || []).filter(i => i.selected !== false && (i.content || '').trim())
      if (!rows.length) {
        if (!silent) this.$modal.msgWarning('请至少勾选一道题')
        return 0
      }
      this.importFormulaPolishing = true
      let n = 0
      try {
        const res = await polishQbFormulaBatch({ contents: rows.map(r => r.content) })
        const items = ((res.data || {}).items) || []
        rows.forEach((row, i) => {
          const d = items[i] || {}
          if (d.content) {
            if (d.content !== row.content) n++
            this.$set(row, 'content', d.content)
          }
        })
        if (!silent) this.$modal.msgSuccess('已整理 ' + n + ' / ' + rows.length + ' 题')
        return n
      } catch (e) {
        if (!silent) this.$modal.msgError((e && (e.message || e.msg)) || '整理失败')
        throw e
      } finally { this.importFormulaPolishing = false }
    },
    cleanStemDup() {
      const before = this.form.content || ''
      const after = dedupeStemContent(before)
      if (!after || after === before) {
        this.$modal.msgSuccess('未检测到重复片段')
        return
      }
      this.form.content = after
      this.$modal.msgSuccess('已清理题干重复内容')
      this.onContentBlur()
    },
    onContentBlur() {
      if (!this.form.subjectId || !this.form.content) { this.dupHint = ''; return }
      checkQbDup({ subjectId: this.form.subjectId, content: this.form.content }).then(res => {
        const d = res.data || {}
        if (d.duplicate && d.question && d.question.questionId !== this.form.questionId) {
          this.dupHint = '题干与已有题目重复（ID=' + (d.questionId || (d.question && d.question.questionId) || '') + '），请复用，禁止重复入库'
        } else {
          this.dupHint = ''
        }
      })
    },

    loadImportKnowledgeTree(subjectId) {
      if (!subjectId) {
        this.importKnowledgeFullTree = []
        this.importChapterOptions = []
        this.importKpTreeData = []
        return
      }
      treeKnowledge(subjectId).then(res => {
        const tree = res.data || []
        this.importKnowledgeFullTree = tree
        this.importChapterOptions = this.collectChapters(tree)
      }).catch(() => {
        this.importKnowledgeFullTree = []
        this.importChapterOptions = []
      })
    },
    collectChapters(nodes, out) {
      out = out || []
      ;(nodes || []).forEach(n => {
        const type = String(n.nodeType || '')
        if (type === '1') out.push({ knowledgeId: n.knowledgeId, knowledgeName: n.knowledgeName, children: n.children || [] })
        if (n.children && n.children.length) this.collectChapters(n.children, out)
      })
      return out
    },
    findChapterNode(chapterId) {
      return (this.importChapterOptions || []).find(c => String(c.knowledgeId) === String(chapterId))
    },
    buildImportKpTree(chapterId) {
      const ch = this.findChapterNode(chapterId)
      const src = ch ? (ch.children || []) : []
      return this.markChapterDisabled(JSON.parse(JSON.stringify(src)))
    },
    openImportKp(row, index) {
      if (!this.importForm.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      const ensure = this.importKnowledgeFullTree.length
        ? Promise.resolve()
        : treeKnowledge(this.importForm.subjectId).then(res => {
          this.importKnowledgeFullTree = res.data || []
          this.importChapterOptions = this.collectChapters(this.importKnowledgeFullTree)
        })
      ensure.then(() => {
        this.importKpBatchMode = false
        this.importKpRowIndex = index
        this.importKpFilter = ''
        this.importKpForm = {
          chapterId: row.chapterId || undefined,
          chapterName: row.chapterName || ''
        }
        this.importKpTreeData = this.buildImportKpTree(this.importKpForm.chapterId)
        this.importKpOpen = true
        this.$nextTick(() => {
          const keys = (row.knowledgeList || []).map(k => k.knowledgeId)
          this.$refs.importKpTree && this.$refs.importKpTree.setCheckedKeys(keys)
          this.filterImportKpTree()
        })
      })
    },
    openImportKpBatch() {
      if (!this.importForm.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      const selected = (this.importItems || []).filter(i => i.selected)
      if (!selected.length) {
        this.$modal.msgWarning('知识点权重之和需约等于 1')
        return
      }
      const ensure = this.importKnowledgeFullTree.length
        ? Promise.resolve()
        : treeKnowledge(this.importForm.subjectId).then(res => {
          this.importKnowledgeFullTree = res.data || []
          this.importChapterOptions = this.collectChapters(this.importKnowledgeFullTree)
        })
      ensure.then(() => {
        this.importKpBatchMode = true
        this.importKpRowIndex = -1
        this.importKpFilter = ''
        this.importKpForm = { chapterId: undefined, chapterName: '' }
        this.importKpTreeData = []
        this.importKpOpen = true
        this.$nextTick(() => {
          this.$refs.importKpTree && this.$refs.importKpTree.setCheckedKeys([])
        })
      })
    },
    onImportChapterChange(v) {
      const ch = this.findChapterNode(v)
      this.importKpForm.chapterName = ch ? ch.knowledgeName : ''
      this.importKpTreeData = this.buildImportKpTree(v)
      this.$nextTick(() => {
        this.$refs.importKpTree && this.$refs.importKpTree.setCheckedKeys([])
        this.filterImportKpTree()
      })
    },
    filterImportKpNode(value, data) {
      if (!value) return true
      return (data.knowledgeName || '').indexOf(value) !== -1
    },
    filterImportKpTree() {
      this.$refs.importKpTree && this.$refs.importKpTree.filter(this.importKpFilter)
    },
    buildImportKnowledgeListFromTree() {
      const checked = (this.$refs.importKpTree && this.$refs.importKpTree.getCheckedKeys(true)) || []
      const nameMap = {}
      this.collectLeafMap(this.importKpTreeData, nameMap)
      const n = checked.length || 1
      return checked.map((id, idx) => ({
        knowledgeId: id,
        knowledgeName: nameMap[id] || String(id),
        weight: Number((1 / n).toFixed(2)),
        isPrimary: idx === 0 ? '1' : '0'
      }))
    },
    confirmImportKp() {
      const list = this.buildImportKnowledgeListFromTree()
      const chapterId = this.importKpForm.chapterId
      const chapterName = this.importKpForm.chapterName || ''
      if (!chapterId && !list.length) {
        this.$modal.msgWarning('请先在预览中框选区域')
        return
      }
      if (this.importKpBatchMode) {
        ;(this.importItems || []).forEach(row => {
          if (!row.selected) return
          this.$set(row, 'chapterId', chapterId)
          this.$set(row, 'chapterName', chapterName)
          this.$set(row, 'knowledgeList', list.map(k => Object.assign({}, k)))
        })
        this.$modal.msgSuccess('已批量更新知识点')
      } else {
        const row = this.importItems[this.importKpRowIndex]
        if (row) {
          this.$set(row, 'chapterId', chapterId)
          this.$set(row, 'chapterName', chapterName)
          this.$set(row, 'knowledgeList', list)
        }
      }
      this.importKpOpen = false
    },
    clearImportKp() {
      if (this.importKpBatchMode) {
        ;(this.importItems || []).forEach(row => {
          if (!row.selected) return
          this.$set(row, 'chapterId', undefined)
          this.$set(row, 'chapterName', '')
          this.$set(row, 'knowledgeList', [])
        })
      } else {
        const row = this.importItems[this.importKpRowIndex]
        if (row) {
          this.$set(row, 'chapterId', undefined)
          this.$set(row, 'chapterName', '')
          this.$set(row, 'knowledgeList', [])
        }
      }
      this.importKpForm = { chapterId: undefined, chapterName: '' }
      this.importKpTreeData = []
      this.$nextTick(() => {
        this.$refs.importKpTree && this.$refs.importKpTree.setCheckedKeys([])
      })
    },

    openKnowledgeDialog() {
      if (!this.form.subjectId) {
        this.$modal.msgWarning('请先选择学科')
        return
      }
      this.knowledgeFilterText = ''
      this.knowledgeOpen = true
      treeKnowledge(this.form.subjectId).then(response => {
        this.knowledgeFullTree = this.markChapterDisabled(response.data || [])
        this.knowledgeVersionTabs = this.splitKnowledgeVersions(this.knowledgeFullTree)
        this.activeVersionId = this.knowledgeVersionTabs.length ? String(this.knowledgeVersionTabs[0].id) : ''
        this.applyActiveVersionTree()
        this.$nextTick(() => {
          const keys = (this.form.knowledgeList || []).map(k => k.knowledgeId)
          this.$refs.knowledgeTree && this.$refs.knowledgeTree.setCheckedKeys(keys)
        })
      })
    },
    splitKnowledgeVersions(nodes) {
      const list = nodes || []
      const versions = list.filter(n => String(n.nodeType || '') === '0')
      const others = list.filter(n => String(n.nodeType || '') !== '0')
      const tabs = versions.map(v => ({ id: v.knowledgeId, label: v.knowledgeName, children: v.children || [] }))
      if (others.length) tabs.unshift({ id: 'all', label: '全部', children: others })
      if (!tabs.length) tabs.push({ id: 'all', label: '全部', children: list })
      return tabs
    },
    applyActiveVersionTree() {
      const tab = (this.knowledgeVersionTabs || []).find(t => String(t.id) === String(this.activeVersionId))
      this.knowledgeTree = tab ? (tab.children || []) : []
      this.$nextTick(() => {
        if (this.$refs.knowledgeTree) {
          this.$refs.knowledgeTree.setCheckedKeys((this.form.knowledgeList || []).map(k => k.knowledgeId))
          this.filterKnowledgeTree()
        }
      })
    },
    handleVersionTabClick(tab) {
      // el-tabs updates v-model before @tab-click; never skip by comparing to old id
      const nextId = tab && tab.name != null ? String(tab.name) : String(this.activeVersionId || '')
      if (!nextId) return
      this.activeVersionId = nextId
      this.applyActiveVersionTree()
    },
    filterKnowledgeNode(value, data) {
      if (!value) return true
      return (data.knowledgeName || '').indexOf(value) !== -1
    },
    filterKnowledgeTree() {
      this.$refs.knowledgeTree && this.$refs.knowledgeTree.filter(this.knowledgeFilterText)
    },
    markChapterDisabled(nodes) {
      return (nodes || []).map(n => {
        const item = Object.assign({}, n)
        const type = String(n.nodeType || '')
        item.disabled = type === '1' || type === '0'
        if (n.children && n.children.length) item.children = this.markChapterDisabled(n.children)
        return item
      })
    },
    collectLeafMap(nodes, map) {
      ;(nodes || []).forEach(n => {
        const type = String(n.nodeType || '')
        if (type === '2' || (!n.children || !n.children.length)) map[n.knowledgeId] = n.knowledgeName
        if (n.children && n.children.length) this.collectLeafMap(n.children, map)
      })
    },
    confirmKnowledge() {
      const checked = (this.$refs.knowledgeTree && this.$refs.knowledgeTree.getCheckedKeys(true)) || []
      const nameMap = {}
      this.collectLeafMap(this.knowledgeFullTree, nameMap)
      const oldMap = {}
      ;(this.form.knowledgeList || []).forEach(k => { oldMap[k.knowledgeId] = k })
      const n = checked.length || 1
      const list = checked.map((id, idx) => {
        const prev = oldMap[id]
        return {
          knowledgeId: id,
          knowledgeName: nameMap[id] || (prev && prev.knowledgeName) || String(id),
          weight: prev && prev.weight != null ? prev.weight : Number((1 / n).toFixed(2)),
          isPrimary: '0'
        }
      })
      this.form.knowledgeList = list
      this.primaryKnowledgeId = list[0] && list[0].knowledgeId
      this.knowledgeOpen = false
    },
    submitForm() {
      if (this.dupHint) {
        this.$modal.msgError(this.dupHint)
        return
      }
      this.$refs.form.validate(valid => {
        if (!valid) return
        if ((this.form.knowledgeList || []).length && !this.weightSumOk) {
          this.$modal.msgWarning('知识点权重之和需约等于 1')
          return
        }
        ;(this.form.knowledgeList || []).forEach(k => {
          k.isPrimary = (k.knowledgeId === this.primaryKnowledgeId) ? '1' : '0'
        })
        if ((this.form.knowledgeList || []).length && !this.primaryKnowledgeId) {
          this.form.knowledgeList[0].isPrimary = '1'
        }
        const req = this.form.questionId ? updateQbQuestion(this.form) : addQbQuestion(this.form)
        req.then(() => {
          this.$modal.msgSuccess(this.form.questionId ? '修改成功' : '新增成功')
          this.open = false
          this.getList()
        })
      })
    },
    handleDelete(row) {
      const ids = row.questionId || this.ids
      this.$modal.confirm('是否确认删除选中的题目？').then(() => delQbQuestion(ids)).then(() => {
        this.$modal.msgSuccess('删除成功')
        this.getList()
      }).catch(() => {})
    },
    handleAi(row) {
      this.aiQuestionId = row.questionId
      this.aiMode = ''
      aiSuggestQbKnowledge(row.questionId).then(res => {
        const data = res.data
        if (Array.isArray(data)) {
          this.aiItems = data
          this.aiMode = 'heuristic'
        } else if (data && typeof data === 'object') {
          this.aiItems = data.suggestions || []
          this.aiMode = data.mode || ''
        } else {
          this.aiItems = []
          this.aiMode = ''
        }
        this.aiSelected = []
        this.aiOpen = true
      })
    },
    runAiInForm() {
      if (!(this.form.content || '').trim()) { this.$modal.msgWarning('请先填写题干'); return }
      if (!this.form.subjectId) { this.$modal.msgWarning('请选择学科'); return }
      if (this.form.questionId) { this.handleAi(this.form); return }
      this.formAiLoading = true
      smartAnnotateQb({
        subjectId: this.form.subjectId,
        items: [{ rowIndex: 0, content: this.form.content, questionType: this.form.questionType, difficulty: this.form.difficulty }]
      }).then(res => {
        const payload = res.data
        const items = Array.isArray(payload) ? payload : ((payload && payload.items) || [])
        const a = items[0]
        const list = (a && a.knowledgeList) || []
        if (!list.length) { this.$modal.msgWarning('未识别到知识点'); return }
        this.aiQuestionId = null
        this.aiMode = (a && a.annotateMode) || 'heuristic'
        this.aiItems = list.map(k => ({ knowledgeId: k.knowledgeId, knowledgeName: k.knowledgeName, weight: k.weight, reason: a.annotateMode === 'remote' ? '远程模型' : '启发式' }))
        this.aiSelected = []
        this.aiOpen = true
        if (a.questionType) this.$set(this.form, 'questionType', a.questionType)
        if (a.difficulty) this.$set(this.form, 'difficulty', a.difficulty)
      }).catch(e => {
        this.$modal.msgError((e && (e.message || e.msg)) || '智能标注失败')
      }).finally(() => { this.formAiLoading = false })
    },
    onAiSelect(rows) { this.aiSelected = rows },
    adoptAi() {
      const list = this.aiSelected.map((i, idx) => ({ knowledgeId: i.knowledgeId, knowledgeName: i.knowledgeName, weight: i.weight || Number((1 / this.aiSelected.length).toFixed(2)), isPrimary: idx === 0 ? '1' : '0' }))
      if (!list.length) return
      if (!this.aiQuestionId) {
        this.form.knowledgeList = list
        this.primaryKnowledgeId = list[0].knowledgeId
        this.aiOpen = false
        this.$modal.msgSuccess('已填入知识点，保存题目后生效')
        return
      }
      saveQbKnowledge(this.aiQuestionId, list).then(() => {
        this.$modal.msgSuccess('知识点已保存')
        this.aiOpen = false
        if (this.open && this.form.questionId === this.aiQuestionId) {
          this.form.knowledgeList = list
          this.primaryKnowledgeId = list[0] && list[0].knowledgeId
        }
        this.getList()
      })
    }
  }
}
</script>

<style scoped>
.weight-sum { font-size: 13px; margin-bottom: 4px; }
.weight-sum.ok { color: #67c23a; }
.weight-sum.bad { color: #f56c6c; }
.mb8 { margin-bottom: 8px; }
.qb-form-preview-title { font-size: 12px; color: #909399; margin-bottom: 4px; }
.qb-import-toolbar { margin-bottom: 4px; }
.qb-import-split {
  display: flex;
  gap: 12px;
  height: calc(78vh - 160px);
  min-height: 460px;
}
.qb-import-left {
  flex: 1 1 52%;
  min-width: 0;
  height: 100%;
}
.qb-import-right {
  flex: 1 1 48%;
  min-width: 360px;
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.qb-import-right-hd {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 8px;
  font-weight: 600;
  color: #303133;
}
.qb-import-count { margin-left: 4px; color: #909399; font-size: 12px; font-weight: 400; }
.qb-import-right-empty {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #909399;
  background: #fafafa;
  border: 1px dashed #dcdfe6;
  border-radius: 4px;
  padding: 24px;
}
.qb-import-right-empty .sub { font-size: 12px; margin-top: 4px; }
.qb-word-empty {
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #c7c7c7;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  color: #606266;
}
.qb-word-empty i { font-size: 42px; color: #909399; margin-bottom: 8px; }
.qb-word-empty .sub { font-size: 12px; color: #909399; }
.qb-pdf-wrap {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #c7c7c7;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  overflow: hidden;
}
.qb-pdf-toolbar {
  flex: 0 0 auto;
  display: flex;
  justify-content: space-between;
  padding: 6px 12px;
  background: #f3f3f3;
  border-bottom: 1px solid #d0d0d0;
  font-size: 12px;
  color: #606266;
}
.qb-pdf-title { font-weight: 600; color: #303133; max-width: 70%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.qb-pdf-tip { color: #909399; }
.qb-pdf-frame {
  flex: 1;
  width: 100%;
  border: 0;
  background: #525659;
}
.qb-raw-pre { white-space: pre-wrap; max-height: 200px; overflow: auto; font-size: 12px; margin: 0; }
.import-formula { margin-top: 4px; font-size: 12px; line-height: 1.5; color: #303133; }
.import-imgs { display: flex; flex-wrap: wrap; gap: 4px; justify-content: center; }
.import-thumb { width: 72px; height: 54px; border: 1px solid #ebeef5; border-radius: 2px; }
.qb-list-stem { max-height: 88px; overflow: hidden; font-size: 13px; line-height: 1.5; }
.qb-list-stem .katex { font-size: 1em; }
.qb-list-stem >>> .qb-rich.is-compact .qb-rich-text { max-height: 4.8em; }

.qb-list-stem--click { cursor: pointer; position: relative; padding-right: 52px; }
.qb-list-stem--click:hover { color: #409EFF; }
.qb-list-stem-more {
  position: absolute; right: 0; bottom: 0;
  font-size: 12px; color: #409EFF; background: linear-gradient(90deg, rgba(255,255,255,0), #fff 28%);
  padding-left: 12px;
}
.qb-view { min-height: 120px; max-height: 70vh; overflow: auto; padding-right: 4px; }
.qb-view-meta { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 12px; }
.qb-view-section { margin-bottom: 14px; }
.qb-view-label { font-size: 12px; color: #909399; margin-bottom: 4px; font-weight: 600; }
.qb-view-body { font-size: 14px; line-height: 1.7; color: #303133; word-break: break-word; }
.qb-view-img { margin-top: 8px; }
.qb-view-img >>> .el-image { max-width: 100%; max-height: 320px; }
.qb-view-img >>> img { max-width: 100%; max-height: 320px; object-fit: contain; }
.qb-view-empty { color: #c0c4cc; font-size: 13px; }
.qb-view-kp { line-height: 1.6; }
.import-kp-cell { font-size: 12px; line-height: 1.4; }
.import-kp-chapter { color: #606266; margin-bottom: 2px; font-weight: 600; }
.import-kp-tags { margin-bottom: 2px; }
.import-kp-empty { color: #c0c4cc; margin-right: 4px; }
.import-q-table .el-table__body tr { cursor: pointer; }
.import-q-table .el-table__body tr.current-row > td { background: #ecf5ff !important; }

</style>

<style>
.qb-import-dialog .el-dialog__body {
  padding-top: 10px;
  padding-bottom: 8px;
}
</style>



