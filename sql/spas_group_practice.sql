-- SPAS: 班级分组 + 每日自主练打卡（P0）
-- PostgreSQL · idempotent
-- Doc: docs/spas-group-daily-practice-desktop.md

-- ========== tables ==========
create table if not exists spas_study_group (
  group_id            bigserial primary key,
  dept_id             int8 not null,
  subject_id          int8,
  group_name          varchar(64) not null,
  leader_student_id   int8,
  status              char(1) default '0',
  sort_order          int4 default 0,
  create_by           varchar(64),
  create_time         timestamp,
  update_by           varchar(64),
  update_time         timestamp,
  remark              varchar(500)
);
create index if not exists idx_spas_study_group_dept on spas_study_group(dept_id, subject_id);

create table if not exists spas_study_group_member (
  id              bigserial primary key,
  group_id        int8 not null,
  student_id      int8 not null,
  role_in_group   char(1) default '0',
  join_time       timestamp default now(),
  leave_time      timestamp,
  constraint uk_spas_sgm_group_student unique (group_id, student_id)
);
create index if not exists idx_spas_sgm_student on spas_study_group_member(student_id);

create table if not exists spas_practice_log (
  log_id                  bigserial primary key,
  practice_date           date not null,
  dept_id                 int8 not null,
  group_id                int8,
  student_id              int8 not null,
  subject_id              int8 not null,
  book_name               varchar(200) not null,
  page_from               int4,
  page_to                 int4,
  question_text           varchar(500) not null,
  finish_status           char(1) not null,
  difficulty_note         varchar(500),
  self_correct_rate       numeric(5,2),
  hardest_question        varchar(200),
  duration_min            int4,
  submit_slot             char(1) default '0',
  submit_by_student_id    int8 not null,
  proxy_flag              char(1) default '0',
  client_type             varchar(20),
  device_code             varchar(64),
  spot_status             char(1) default '0',
  spot_by                 varchar(64),
  spot_time               timestamp,
  spot_remark             varchar(500),
  status                  char(1) default '0',
  create_time             timestamp,
  update_time             timestamp,
  remark                  varchar(500)
);
create index if not exists idx_spas_plog_day_dept on spas_practice_log(practice_date, dept_id);
create index if not exists idx_spas_plog_student on spas_practice_log(student_id, practice_date);

create table if not exists spas_practice_log_knowledge (
  id              bigserial primary key,
  log_id          int8 not null,
  knowledge_id    int8 not null,
  is_primary      char(1) default '0',
  constraint uk_spas_plk unique (log_id, knowledge_id)
);
create index if not exists idx_spas_plk_log on spas_practice_log_knowledge(log_id);

create table if not exists spas_practice_book_stat (
  id              bigserial primary key,
  dept_id         int8 not null,
  subject_id      int8 not null,
  book_name       varchar(200) not null,
  use_count       int4 default 1,
  last_used       timestamp,
  constraint uk_spas_pbook unique (dept_id, subject_id, book_name)
);

create table if not exists spas_kiosk_device (
  device_id     bigserial primary key,
  device_code   varchar(64) unique not null,
  device_name   varchar(100),
  dept_id       int8,
  status        char(1) default '0',
  last_seen     timestamp,
  last_student_id int8,
  app_version   varchar(32),
  remark        varchar(500),
  create_time   timestamp default now(),
  update_time   timestamp
);
comment on table spas_kiosk_device is '一体机设备登记';

-- student PIN for kiosk quick login (BCrypt hash; rate-limit in app)
create table if not exists spas_student_pin (
  student_id    int8 primary key,
  pin_hash      varchar(100) not null,
  status        char(1) default '0',
  fail_count    int4 default 0,
  lock_until    timestamp,
  create_time   timestamp default now(),
  update_time   timestamp
);
comment on table spas_student_pin is '学生一体机 PIN 哈希（4~6 位数字）';

-- proxy confirm: 0 N/A(self) 1 pending 2 confirmed 3 rejected
alter table spas_practice_log add column if not exists confirm_status char(1) default '0';
alter table spas_practice_log add column if not exists confirm_time timestamp;
comment on column spas_practice_log.confirm_status is '0本人无需确认 1待组员确认 2已确认 3已驳回';

comment on table spas_study_group is '班级学习小组';
comment on table spas_study_group_member is '学习小组成员';
comment on table spas_practice_log is '每日自主练打卡（不进掌握度）';
comment on table spas_practice_log_knowledge is '打卡关联知识主题';
comment on table spas_practice_book_stat is '班级常用书名统计';

-- ========== menus (2160 group / 2170 practice / 2220 student mine) ==========
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2160, '班级分组', 2002, 3, 'group', 'spas/group/index', '', 'StudyGroup', 1, 0, 'C', '0', '0', 'spas:group:list', 'peoples', 'admin', now(), 'class study groups'
where not exists (select 1 from sys_menu where menu_id=2160);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2161, '分组查询', 2160, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:group:query', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2161);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2162, '分组新增', 2160, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:group:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2162);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2163, '分组修改', 2160, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:group:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2163);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2164, '分组删除', 2160, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:group:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2164);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2170, '自主练打卡', 2002, 4, 'practice', 'spas/practice/index', '', 'PracticeBoard', 1, 0, 'C', '0', '0', 'spas:practice:list', 'edit', 'admin', now(), 'daily self-practice supervision'
where not exists (select 1 from sys_menu where menu_id=2170);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2171, '打卡查询', 2170, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:query', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2171);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2172, '打卡新增', 2170, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2172);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2173, '打卡修改', 2170, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2173);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2174, '打卡作废', 2170, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2174);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2175, '代提打卡', 2170, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:proxy', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2175);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2176, '抽查录入', 2170, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:spot', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2176);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2177, '打卡统计', 2170, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:stat', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2177);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2178, '设备登记', 2170, 8, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:device', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2178);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2220, '每日自主练', 2200, 2, 'practice', 'spas/practice/mine', '', 'MyPractice', 1, 0, 'C', '0', '0', 'spas:practice:mine', 'edit', 'admin', now(), 'student self practice'
where not exists (select 1 from sys_menu where menu_id=2220);

-- grant menus
insert into sys_role_menu(role_id, menu_id)
select 1, m.menu_id from sys_menu m
where m.menu_id between 2160 and 2178
  and not exists (select 1 from sys_role_menu rm where rm.role_id=1 and rm.menu_id=m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key in ('spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader')
  and m.menu_id between 2160 and 2178
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_school_leader'
  and m.menu_id in (2160, 2161, 2170, 2171, 2177)
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_student'
  and m.menu_id in (2220, 2172, 2175)
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);

-- ensure student also gets practice:mine button semantics if menu already exists
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2221, '自主练提交', 2220, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2221);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2222, '自主练代提', 2220, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:proxy', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2222);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_student'
  and m.menu_id in (2221, 2222)
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);
