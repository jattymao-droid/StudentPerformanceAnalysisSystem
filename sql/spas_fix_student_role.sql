-- Repair: ensure every spas_student profile user has spas_student role + portal menus
insert into sys_user_role(user_id, role_id)
select distinct s.user_id, r.role_id
from spas_student s
cross join sys_role r
where s.del_flag = '0'
  and s.user_id is not null
  and r.role_key = 'spas_student'
  and r.del_flag = '0'
  and not exists (
    select 1 from sys_user_role ur
    where ur.user_id = s.user_id and ur.role_id = r.role_id
  );

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_student'
  and m.menu_id in (2200, 2210)
  and not exists (
    select 1 from sys_role_menu rm
    where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );

-- demo accounts by username (in case profile missing)
insert into sys_user_role(user_id, role_id)
select u.user_id, r.role_id
from sys_user u
cross join sys_role r
where u.user_name in ('demo001', 'demo002', 'demo003')
  and r.role_key = 'spas_student'
  and not exists (
    select 1 from sys_user_role ur
    where ur.user_id = u.user_id and ur.role_id = r.role_id
  );

-- restore soft-deleted demo student profiles
update spas_student
set del_flag = '0', status = '0'
where student_no in ('demo001', 'demo002', 'demo003')
  and del_flag <> '0';
