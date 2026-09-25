-- Menu + buttons for exam school-rank import
-- Parent: 2002

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2150, U&'\5b9e\8003\6821\6b21', 2002, 3, 'examScore', 'spas/examScore/index', '', '', 1, 0, 'C', '0', '0', 'spas:examScore:list', 'chart', 'admin', now(), 'multi-subject score + school rank'
where not exists (select 1 from sys_menu where menu_id=2150);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2151, U&'\6821\6b21\67e5\8be2', 2150, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:examScore:list', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2151);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2152, U&'\6821\6b21\5bfc\5165', 2150, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:examScore:import', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2152);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2153, U&'\6821\6b21\5bfc\51fa', 2150, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:examScore:export', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2153);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2154, U&'\6821\6b21\5220\9664', 2150, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:examScore:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2154);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join (values (2150),(2151),(2152),(2153),(2154)) as m(menu_id)
where r.role_key in ('admin', 'spas_admin', 'spas_jw', 'spas_teacher')
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );
