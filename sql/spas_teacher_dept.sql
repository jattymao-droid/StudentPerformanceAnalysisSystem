-- Multi-class assignments for subject teachers (PostgreSQL, idempotent)

create table if not exists spas_teacher_dept (
  teacher_id int8 not null,
  dept_id int8 not null,
  primary key (teacher_id, dept_id)
);
create index if not exists idx_spas_teacher_dept_dept on spas_teacher_dept(dept_id);

-- Ensure spas_jw has score page menus (not only export button 2053)
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_jw'
  and m.menu_id in (2050, 2051, 2052)
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );
