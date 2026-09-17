<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="学科编码" prop="subjectCode">
        <el-input
          v-model="queryParams.subjectCode"
          placeholder="请输入学科编码"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="学科名称" prop="subjectName">
        <el-input
          v-model="queryParams.subjectName"
          placeholder="请输入学科名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="学科状态" clearable>
          <el-option
            v-for="dict in dict.type.sys_normal_disable"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['spas:subject:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['spas:subject:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['spas:subject:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['spas:subject:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="subjectList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="学科编号" align="center" prop="subjectId" width="90" />
      <el-table-column label="学科编码" align="center" prop="subjectCode" />
      <el-table-column label="学科名称" align="center" prop="subjectName" />
      <el-table-column label="排序" align="center" prop="sort" width="80" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="220">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['spas:subject:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-s-grid"
            @click="openQuestionType(scope.row)"
            v-hasPermi="['spas:subject:edit']"
          >题型</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['spas:subject:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="学科名称" prop="subjectName">
          <el-input v-model="form.subjectName" placeholder="请输入学科名称" maxlength="64" />
        </el-form-item>
        <el-form-item label="学科编码" prop="subjectCode">
          <el-input v-model="form.subjectCode" placeholder="请输入学科编码" maxlength="32" />
        </el-form-item>
        <el-form-item label="显示排序" prop="sort">
          <el-input-number v-model="form.sort" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in dict.type.sys_normal_disable"
              :key="dict.value"
              :label="dict.value"
            >{{ dict.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="questionTypeTitle" :visible.sync="questionTypeOpen" width="720px" append-to-body>
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAddQuestionType" v-hasPermi="['spas:subject:edit']">新增题型</el-button>
        </el-col>
      </el-row>
      <el-table v-loading="questionTypeLoading" :data="questionTypeList" size="mini" max-height="360">
        <el-table-column label="编码" prop="typeCode" width="120" />
        <el-table-column label="名称" prop="typeName" min-width="140" />
        <el-table-column label="排序" prop="sort" width="80" align="center" />
        <el-table-column label="状态" prop="status" width="90" align="center">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="140" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="mini" @click="handleEditQuestionType(scope.row)" v-hasPermi="['spas:subject:edit']">修改</el-button>
            <el-button type="text" size="mini" @click="handleDeleteQuestionType(scope.row)" v-hasPermi="['spas:subject:edit']">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div slot="footer" class="dialog-footer">
        <el-button @click="questionTypeOpen = false">关 闭</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="questionTypeFormTitle" :visible.sync="questionTypeFormOpen" width="480px" append-to-body>
      <el-form ref="questionTypeForm" :model="questionTypeForm" :rules="questionTypeRules" label-width="90px">
        <el-form-item label="题型编码" prop="typeCode">
          <el-input v-model="questionTypeForm.typeCode" placeholder="single" maxlength="32" :disabled="!!questionTypeForm.typeId" />
        </el-form-item>
        <el-form-item label="题型名称" prop="typeName">
          <el-input v-model="questionTypeForm.typeName" maxlength="64" />
        </el-form-item>
        <el-form-item label="显示排序" prop="sort">
          <el-input-number v-model="questionTypeForm.sort" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="questionTypeForm.status">
            <el-radio
              v-for="dict in dict.type.sys_normal_disable"
              :key="dict.value"
              :label="dict.value"
            >{{ dict.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="questionTypeForm.remark" type="textarea" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitQuestionType">确 定</el-button>
        <el-button @click="questionTypeFormOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSubject, getSubject, addSubject, updateSubject, delSubject } from '@/api/spas/subject'
import { listQuestionType, addQuestionType, updateQuestionType, delQuestionType } from '@/api/spas/questionType'

export default {
  name: 'SpasSubject',
  dicts: ['sys_normal_disable'],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      subjectList: [],
      title: '',
      open: false,
      questionTypeOpen: false,
      questionTypeLoading: false,
      questionTypeList: [],
      questionTypeSubject: null,
      questionTypeTitle: '',
      questionTypeFormOpen: false,
      questionTypeFormTitle: '',
      questionTypeForm: {},
      questionTypeRules: {
        typeCode: [{ required: true, message: '题型编码不能为空', trigger: 'blur' }],
        typeName: [{ required: true, message: '题型名称不能为空', trigger: 'blur' }],
        sort: [{ required: true, message: '显示排序不能为空', trigger: 'blur' }]
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        subjectCode: undefined,
        subjectName: undefined,
        status: undefined
      },
      form: {},
      rules: {
        subjectName: [
          { required: true, message: '学科名称不能为空', trigger: 'blur' }
        ],
        subjectCode: [
          { required: true, message: '学科编码不能为空', trigger: 'blur' }
        ],
        sort: [
          { required: true, message: '显示排序不能为空', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listSubject(this.queryParams).then(response => {
        this.subjectList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        subjectId: undefined,
        subjectCode: undefined,
        subjectName: undefined,
        sort: 0,
        status: '0',
        remark: undefined
      }
      this.resetForm('form')
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    handleExport() {
      this.download('spas/subject/export', { ...this.queryParams }, `subject_${new Date().getTime()}.xlsx`)
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.subjectId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '添加学科'
    },
    handleUpdate(row) {
      this.reset()
      const subjectId = row.subjectId || this.ids
      getSubject(subjectId).then(response => {
        this.form = response.data
        this.open = true
        this.title = '修改学科'
      })
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          if (this.form.subjectId != undefined) {
            updateSubject(this.form).then(() => {
              this.$modal.msgSuccess('修改成功')
              this.open = false
              this.getList()
            })
          } else {
            addSubject(this.form).then(() => {
              this.$modal.msgSuccess('新增成功')
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    openQuestionType(row) {
      this.questionTypeSubject = row
      this.questionTypeTitle = '题型管理 - ' + (row.subjectName || '')
      this.questionTypeOpen = true
      this.loadQuestionTypeList()
    },
    loadQuestionTypeList() {
      if (!this.questionTypeSubject || !this.questionTypeSubject.subjectId) {
        this.questionTypeList = []
        return
      }
      this.questionTypeLoading = true
      listQuestionType({ subjectId: this.questionTypeSubject.subjectId, pageNum: 1, pageSize: 100 }).then(res => {
        this.questionTypeList = res.rows || []
        this.questionTypeLoading = false
      }).catch(() => { this.questionTypeLoading = false })
    },
    resetQuestionTypeForm() {
      this.questionTypeForm = {
        typeId: undefined,
        subjectId: this.questionTypeSubject && this.questionTypeSubject.subjectId,
        typeCode: undefined,
        typeName: undefined,
        sort: 0,
        status: '0',
        remark: undefined
      }
      this.resetForm('questionTypeForm')
    },
    handleAddQuestionType() {
      this.resetQuestionTypeForm()
      this.questionTypeFormOpen = true
      this.questionTypeFormTitle = '新增题型'
    },
    handleEditQuestionType(row) {
      this.resetQuestionTypeForm()
      this.questionTypeForm = Object.assign({}, row)
      this.questionTypeFormOpen = true
      this.questionTypeFormTitle = '修改题型'
    },
    submitQuestionType() {
      this.$refs['questionTypeForm'].validate(valid => {
        if (!valid) return
        const req = this.questionTypeForm.typeId != undefined
          ? updateQuestionType(this.questionTypeForm)
          : addQuestionType(this.questionTypeForm)
        req.then(() => {
          this.$modal.msgSuccess(this.questionTypeForm.typeId != undefined ? '修改成功' : '新增成功')
          this.questionTypeFormOpen = false
          this.loadQuestionTypeList()
        })
      })
    },
    handleDeleteQuestionType(row) {
      this.$modal.confirm('是否确认删除题型"' + row.typeName + '"？').then(function() {
        return delQuestionType(row.typeId)
      }).then(() => {
        this.loadQuestionTypeList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    handleDelete(row) {
      const subjectIds = row.subjectId || this.ids
      this.$modal.confirm('是否确认删除学科编号为"' + subjectIds + '"的数据项？').then(function() {
        return delSubject(subjectIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    }
  }
}
</script>
