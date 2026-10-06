-- SPAS: 教师布置 + 组长检查单 + 抽检（M1/M2）
-- PostgreSQL · idempotent
-- Doc: docs/spas-leader-check-spot-supervision.md

create table if not exists spas_practice_assignment (
  assignment_id      bigserial primary key,
  dept_id            int8 not null,
  subject_id         int8 not null,
  assign_date        date not null,
  knowledge_id       int8,
  book_name          varchar(200) not null,
  page_from          int4,
  page_to            int4,
  question_text      varchar(500) not null,
  complete_definition varchar(500),
  due_count_week     int2 default 3,
  status             char(1) default '0',
  create_by          varchar(64),
  create_time        timestamp,
  update_by          varchar(64),
  update_time        timestamp,
  remark             varchar(500),
  constraint uk_spas_assignment_day unique (dept_id, subject_id, assign_date)
);
create index if not exists idx_spas_assignment_dept on spas_practice_assignment(dept_id, assign_date);

create table if not exists spas_practice_checkout (
  checkout_id          bigserial primary key,
  assignment_id        int8 not null,
  group_id             int8 not null,
  practice_date        date not null,
  leader_student_id    int8 not null,
  checker_student_id   int8 not null,
  submit_time          timestamp,
  device_code          varchar(64),
  status               char(1) default '0',
  create_time          timestamp,
  update_time          timestamp,
  constraint uk_spas_checkout_group_day unique (group_id, practice_date, assignment_id)
);
create index if not exists idx_spas_checkout_assign on spas_practice_checkout(assignment_id, practice_date);

create table if not exists spas_practice_checkout_item (
  item_id           bigserial primary key,
  checkout_id       int8 not null,
  student_id        int8 not null,
  finish_status     varchar(2) not null,
  difficulty_note   varchar(500),
  member_ack        char(1) default '0',
  ack_time          timestamp,
  voided            char(1) default '0',
  follow_status     char(1) default '0',
  spot_result       char(1),
  constraint uk_spas_checkout_item unique (checkout_id, student_id)
);
create index if not exists idx_spas_checkout_item_stu on spas_practice_checkout_item(student_id, checkout_id);

create table if not exists spas_practice_spot (
  spot_id              bigserial primary key,
  item_id              int8 not null,
  student_id           int8 not null,
  group_id             int8 not null,
  checker_student_id   int8,
  spot_result          char(1) not null,
  spot_by              varchar(64),
  spot_time            timestamp,
  spot_remark          varchar(500)
);
create index if not exists idx_spas_spot_item on spas_practice_spot(item_id);
create index if not exists idx_spas_spot_group on spas_practice_spot(group_id, spot_time);

comment on table spas_practice_assignment is '自主练教师布置（班+学科+日）';
comment on table spas_practice_checkout is '学习小组检查结账单';
comment on table spas_practice_checkout_item is '检查单明细（人×状态×确认）';
comment on table spas_practice_spot is '教师抽检（一致/偏松/偏严）';
comment on column spas_practice_checkout_item.finish_status is '1完成 2部分 0未做 3困难 L请假 A未到/没带本';
comment on column spas_practice_checkout_item.member_ack is '0待确认 1属实 2异议 3超时';
comment on column spas_practice_spot.spot_result is '1一致 2偏松 3偏严';
