-- Align spas_bzr / spas_teacher menus for class-scoped teaching pages (idempotent)

-- spas_bzr: exam score (school rank) same as subject teacher
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_bzr'
  and m.menu_id between 2150 and 2154
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );

-- spas_bzr: keep student import (already in roles sql); ensure intervene parent 2085 tree if missing
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_bzr'
  and m.menu_id in (2085, 2086, 2087, 2088, 2089, 2131, 2132, 2133, 2134, 2135, 2136, 2137, 2138, 2139, 2081)
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );

-- spas_teacher: ensure portfolio coach + report + quality parity
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_teacher'
  and m.menu_id in (2110, 2111, 2131, 2132, 2133, 2081, 2036)
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );

-- Do NOT grant system:user:list to teachers; frontend uses /spas/teacher/my-depts instead.
