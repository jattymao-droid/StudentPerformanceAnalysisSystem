-- SPAS: 学生积分与等级（打卡发分 + 掌握度进步发分 + 班内榜）
-- PostgreSQL · idempotent
-- Doc: docs/spas-group-daily-practice-desktop.md

create table if not exists spas_student_point_account (
  student_id          int8 primary key,
  total_points        int4 not null default 0,
  level_no            int4 not null default 1,
  day_streak          int4 not null default 0,
  last_practice_date  date,
  week_points         int4 not null default 0,
  week_start          date,
  update_time         timestamp default now()
);

create table if not exists spas_student_point_ledger (
  ledger_id     bigserial primary key,
  student_id    int8 not null,
  dept_id       int8,
  subject_id    int8,
  points        int4 not null,
  reason_code   varchar(32) not null,
  ref_type      varchar(32),
  ref_id        varchar(64),
  biz_key       varchar(120) not null,
  remark        varchar(200),
  create_time   timestamp default now(),
  constraint uk_spas_point_ledger_biz unique (biz_key)
);
create index if not exists idx_spas_point_ledger_student on spas_student_point_ledger(student_id, create_time desc);
create index if not exists idx_spas_point_ledger_dept on spas_student_point_ledger(dept_id, create_time desc);
create index if not exists idx_spas_point_ledger_day on spas_student_point_ledger(student_id, (create_time::date));
