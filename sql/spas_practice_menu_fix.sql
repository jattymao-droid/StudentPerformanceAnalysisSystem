-- Fix practice menu permissions (ASCII-safe, idempotent)

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2410, E'\u81ea\u4e3b\u7ec3\u6253\u5361', 2002, 20, 'practice', 'spas/practice/index', '', 'PracticeBoard', 1, 0, 'C', '0', '0', 'spas:practice:list', 'edit', 'admin', now(), 'daily practice supervision'
where not exists (select 1 from sys_menu where menu_id=2410);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2411, E'\u6253\u5361\u67e5\u8be2', 2410, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:query', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2411);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2412, E'\u6253\u5361\u65b0\u589e', 2410, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2412);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2413, E'\u6253\u5361\u4fee\u6539', 2410, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2413);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2414, E'\u6253\u5361\u4f5c\u5e9f', 2410, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2414);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2415, E'\u4ee3\u63d0\u6253\u5361', 2410, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:proxy', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2415);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2416, E'\u62bd\u67e5\u5f55\u5165', 2410, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:spot', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2416);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2417, E'\u6253\u5361\u7edf\u8ba1', 2410, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:stat', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2417);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2418, E'\u8bbe\u5907\u767b\u8bb0', 2410, 8, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:device', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2418);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2420, E'\u6bcf\u65e5\u81ea\u4e3b\u7ec3', 2200, 5, 'practice', 'spas/practice/mine', '', 'MyPractice', 1, 0, 'C', '0', '0', 'spas:practice:mine', 'edit', 'admin', now(), 'student self practice'
where not exists (select 1 from sys_menu where menu_id=2420);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2421, E'\u81ea\u4e3b\u7ec3\u63d0\u4ea4', 2420, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2421);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2422, E'\u81ea\u4e3b\u7ec3\u4ee3\u63d0', 2420, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:practice:proxy', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2422);

insert into sys_role_menu(role_id, menu_id)
select 1, m.menu_id from sys_menu m
where m.menu_id between 2410 and 2422
  and not exists (select 1 from sys_role_menu rm where rm.role_id=1 and rm.menu_id=m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key in ('spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader')
  and m.menu_id between 2410 and 2418
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_school_leader'
  and m.menu_id in (2410, 2411, 2417)
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_student'
  and m.menu_id in (2420, 2421, 2422, 2412, 2415)
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);
