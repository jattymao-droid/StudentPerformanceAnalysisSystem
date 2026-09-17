-- F3 quality board menus
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2134, '质量看板', 2000, 9, 'quality', 'spas/quality/index', '', '', 1, 0, 'C', '0', '0', 'spas:quality:list', 'example', 'admin', now(), 'data quality board'
where not exists (select 1 from sys_menu where menu_id=2134);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2135, '质量查询', 2134, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:quality:list', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2135);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join (values (2134),(2135)) as m(menu_id)
where r.role_key in ('admin', 'spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader', 'spas_school_leader')
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );
