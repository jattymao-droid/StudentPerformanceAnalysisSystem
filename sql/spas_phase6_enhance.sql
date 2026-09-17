-- Phase 6: menu permissions and open admin (PostgreSQL UTF-8, idempotent)

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2036, U&'\5b66\751f\5bfc\5165', 2030, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:student:import', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2036);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2037, U&'\5b66\751f\5bfc\51fa', 2030, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:student:export', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2037);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2053, U&'\6210\7ee9\5bfc\51fa', 2050, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:score:export', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2053);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2120, U&'\5f00\653e\63a5\53e3', 2000, 6, 'open', 'spas/open/index', '', '', 1, 0, 'C', '0', '0', 'spas:open:client:list', 'link', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2120);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2121, U&'\5ba2\6237\7aef\67e5\8be2', 2120, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:open:client:query', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2121);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2122, U&'\5ba2\6237\7aef\65b0\589e', 2120, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:open:client:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2122);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2123, U&'\5ba2\6237\7aef\4fee\6539', 2120, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:open:client:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2123);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2124, U&'\5ba2\6237\7aef\5220\9664', 2120, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:open:client:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2124);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2125, U&'\5bb6\957f\67e5\8be2', 2120, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:open:parent:list', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2125);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2126, U&'\5bb6\957f\65b0\589e', 2120, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:open:parent:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2126);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2127, U&'\5bb6\957f\4fee\6539', 2120, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:open:parent:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2127);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2128, U&'\5bb6\957f\5220\9664', 2120, 8, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:open:parent:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2128);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key in ('admin', 'spas_admin')
  and m.menu_id in (2036, 2037)
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key in ('admin', 'spas_admin', 'spas_teacher', 'spas_jw')
  and m.menu_id = 2053
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key in ('admin', 'spas_admin')
  and m.menu_id between 2120 and 2128
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);
