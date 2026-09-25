-- Allow the same teacher to be both subject teacher and homeroom (PostgreSQL, idempotent)

alter table spas_teacher add column if not exists homeroom_dept_id int8;

-- Backfill: pure/legacy homeroom teachers
update spas_teacher
set homeroom_dept_id = dept_id
where teacher_type = '2'
  and del_flag = '0'
  and homeroom_dept_id is null;

create unique index if not exists uk_spas_teacher_homeroom_dept
  on spas_teacher(homeroom_dept_id)
  where homeroom_dept_id is not null and del_flag = '0';

create index if not exists idx_spas_teacher_homeroom_dept on spas_teacher(homeroom_dept_id);
