-- F2 report export menus (IDs 2130+)
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2130, '报告导出', 2000, 8, 'report', null, '', '', 1, 0, 'M', '1', '0', '', 'download', 'admin', now(), 'report export'
where not exists (select 1 from sys_menu where menu_id=2130);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2131, '导出报告', 2130, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:report:export', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2131);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2132, '导出报告', 2060, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:report:export', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2132);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2133, '导出报告', 2070, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:report:export', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2133);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join (values (2130),(2131),(2132),(2133)) as m(menu_id)
where r.role_key in ('admin', 'spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader', 'spas_school_leader')
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );
