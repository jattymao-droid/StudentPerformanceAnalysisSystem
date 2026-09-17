-- SPAS menus / roles / dict (PostgreSQL)
-- Clean leftover gamescreen menus if any
delete from sys_role_menu where menu_id in (select menu_id from sys_menu where path like 'gamescreen%' or perms like 'gs:%' or component like 'gamescreen%');
delete from sys_menu where path like 'gamescreen%' or perms like 'gs:%' or component like 'gamescreen%';

-- dict types
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '试卷类型', 'spas_paper_type', '0', 'admin', now(), 'exam/homework'
where not exists (select 1 from sys_dict_type where dict_type='spas_paper_type');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '题目难度', 'spas_difficulty', '0', 'admin', now(), null
where not exists (select 1 from sys_dict_type where dict_type='spas_difficulty');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '试卷状态', 'spas_paper_status', '0', 'admin', now(), null
where not exists (select 1 from sys_dict_type where dict_type='spas_paper_status');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '薄弱等级', 'spas_weak_level', '0', 'admin', now(), null
where not exists (select 1 from sys_dict_type where dict_type='spas_weak_level');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '预警级别', 'spas_warning_level', '0', 'admin', now(), null
where not exists (select 1 from sys_dict_type where dict_type='spas_warning_level');
insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '预警状态', 'spas_warning_status', '0', 'admin', now(), null
where not exists (select 1 from sys_dict_type where dict_type='spas_warning_status');

-- dict data
insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select * from (values
 (1, '考试', '1', 'spas_paper_type', '', 'primary', 'Y', '0', 'admin', now()),
 (2, '作业', '2', 'spas_paper_type', '', 'success', 'N', '0', 'admin', now()),
 (1, '易', '1', 'spas_difficulty', '', 'success', 'N', '0', 'admin', now()),
 (2, '中', '2', 'spas_difficulty', '', 'warning', 'Y', '0', 'admin', now()),
 (3, '难', '3', 'spas_difficulty', '', 'danger', 'N', '0', 'admin', now()),
 (1, '草稿', '0', 'spas_paper_status', '', 'info', 'Y', '0', 'admin', now()),
 (2, '已发布', '1', 'spas_paper_status', '', 'primary', 'N', '0', 'admin', now()),
 (3, '已归档', '2', 'spas_paper_status', '', 'success', 'N', '0', 'admin', now()),
 (1, '正常', '0', 'spas_weak_level', '', 'success', 'Y', '0', 'admin', now()),
 (2, '关注', '1', 'spas_weak_level', '', 'warning', 'N', '0', 'admin', now()),
 (3, '薄弱', '2', 'spas_weak_level', '', 'danger', 'N', '0', 'admin', now()),
 (4, '严重', '3', 'spas_weak_level', '', 'danger', 'N', '0', 'admin', now()),
 (1, '提示', '1', 'spas_warning_level', '', 'info', 'Y', '0', 'admin', now()),
 (2, '重要', '2', 'spas_warning_level', '', 'warning', 'N', '0', 'admin', now()),
 (3, '紧急', '3', 'spas_warning_level', '', 'danger', 'N', '0', 'admin', now()),
 (1, '待处理', '0', 'spas_warning_status', '', 'warning', 'Y', '0', 'admin', now()),
 (2, '已处理', '1', 'spas_warning_status', '', 'success', 'N', '0', 'admin', now()),
 (3, '已忽略', '2', 'spas_warning_status', '', 'info', 'N', '0', 'admin', now())
) as v(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
where not exists (
  select 1 from sys_dict_data d where d.dict_type = v.dict_type and d.dict_value = v.dict_value
);

-- roles
insert into sys_role(role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select '学情管理员', 'spas_admin', 10, '1', 1, 1, '0', '0', 'admin', now(), 'SPAS admin'
where not exists (select 1 from sys_role where role_key='spas_admin');
insert into sys_role(role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select '任课教师', 'spas_teacher', 11, '3', 1, 1, '0', '0', 'admin', now(), 'SPAS teacher'
where not exists (select 1 from sys_role where role_key='spas_teacher');
insert into sys_role(role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select '教务', 'spas_jw', 12, '2', 1, 1, '0', '0', 'admin', now(), 'SPAS jiaowu'
where not exists (select 1 from sys_role where role_key='spas_jw');
insert into sys_role(role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select '学生', 'spas_student', 13, '5', 1, 1, '0', '0', 'admin', now(), 'SPAS student self'
where not exists (select 1 from sys_role where role_key='spas_student');

-- menus (2000+)
-- directory: student learning
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2000, '学生学情', 0, 5, 'spas', null, '', '', 1, 0, 'M', '0', '0', '', 'education', 'admin', now(), 'SPAS root'
where not exists (select 1 from sys_menu where menu_id=2000);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2001, '基础数据', 2000, 1, 'base', null, '', '', 1, 0, 'M', '0', '0', '', 'tree-table', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2001);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2010, '学科管理', 2001, 1, 'subject', 'spas/subject/index', '', '', 1, 0, 'C', '0', '0', 'spas:subject:list', 'list', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2010);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2020, '知识点管理', 2001, 2, 'knowledge', 'spas/knowledge/index', '', '', 1, 0, 'C', '0', '0', 'spas:knowledge:list', 'tree', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2020);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2030, '学生档案', 2001, 3, 'student', 'spas/student/index', '', '', 1, 0, 'C', '0', '0', 'spas:student:list', 'peoples', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2030);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2002, '教务业务', 2000, 2, 'biz', null, '', '', 1, 0, 'M', '0', '0', '', 'form', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2002);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2040, '作业考试', 2002, 1, 'paper', 'spas/paper/index', '', '', 1, 0, 'C', '0', '0', 'spas:paper:list', 'documentation', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2040);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2050, '成绩导入', 2002, 2, 'score', 'spas/score/index', '', '', 1, 0, 'C', '0', '0', 'spas:score:list', 'upload', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2050);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2003, '学情分析', 2000, 3, 'analysis', null, '', '', 1, 0, 'M', '0', '0', '', 'chart', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2003);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2060, '班级分析', 2003, 1, 'class', 'spas/analysis/class', '', '', 1, 0, 'C', '0', '0', 'spas:analysis:class', 'peoples', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2060);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2070, '学生分析', 2003, 2, 'student', 'spas/analysis/student', '', '', 1, 0, 'C', '0', '0', 'spas:analysis:student', 'user', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2070);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2080, '知识点分析', 2003, 3, 'knowledge', 'spas/analysis/knowledge', '', '', 1, 0, 'C', '0', '0', 'spas:analysis:knowledge', 'tree', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2080);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2004, '预警中心', 2000, 4, 'warning', null, '', '', 1, 0, 'M', '0', '0', '', 'message', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2004);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2090, '预警规则', 2004, 1, 'rule', 'spas/warning/rule', '', '', 1, 0, 'C', '0', '0', 'spas:warning:rule', 'edit', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2090);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2100, '预警记录', 2004, 2, 'record', 'spas/warning/record', '', '', 1, 0, 'C', '0', '0', 'spas:warning:record', 'log', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2100);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2110, '一生一册', 2000, 5, 'portfolio', 'spas/portfolio/index', '', '', 1, 0, 'C', '0', '0', 'spas:portfolio:list', 'education', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2110);

-- student self menu
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2200, '我的学情', 0, 6, 'myspas', null, '', '', 1, 0, 'M', '0', '0', '', 'user', 'admin', now(), 'student portal'
where not exists (select 1 from sys_menu where menu_id=2200);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2210, '一生一册', 2200, 1, 'mine', 'spas/portfolio/mine', '', '', 1, 0, 'C', '0', '0', 'spas:portfolio:mine', 'form', 'admin', now(), null
where not exists (select 1 from sys_menu where menu_id=2210);

-- button perms (subject sample)
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2011, '学科查询', 2010, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:subject:query', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2011);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2012, '学科新增', 2010, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:subject:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2012);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2013, '学科修改', 2010, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:subject:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2013);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2014, '学科删除', 2010, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:subject:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2014);

-- grant all spas menus to admin role (role_id=1) and spas_admin
insert into sys_role_menu(role_id, menu_id)
select 1, m.menu_id from sys_menu m
where m.menu_id between 2000 and 2299
  and not exists (select 1 from sys_role_menu rm where rm.role_id=1 and rm.menu_id=m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key='spas_admin' and m.menu_id between 2000 and 2210
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);

-- student role only my portfolio
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key='spas_student' and m.menu_id in (2200, 2210)
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);
