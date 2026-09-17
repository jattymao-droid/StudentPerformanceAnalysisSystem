-- extra button permissions for phase 1
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2031, '学生查询', 2030, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:student:query', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2031);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2032, '学生新增', 2030, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:student:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2032);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2033, '学生修改', 2030, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:student:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2033);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2034, '学生删除', 2030, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:student:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2034);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2035, '重置密码', 2030, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:student:resetPwd', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2035);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2021, '知识点查询', 2020, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:knowledge:query', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2021);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2022, '知识点新增', 2020, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:knowledge:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2022);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2023, '知识点修改', 2020, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:knowledge:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2023);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2024, '知识点删除', 2020, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:knowledge:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2024);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2041, '试卷查询', 2040, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:paper:query', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2041);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2042, '试卷新增', 2040, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:paper:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2042);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2043, '试卷修改', 2040, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:paper:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2043);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2044, '试卷删除', 2040, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:paper:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2044);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2051, '成绩查询', 2050, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:score:list', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2051);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2052, '成绩导入', 2050, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:score:import', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2052);

insert into sys_role_menu(role_id, menu_id)
select 1, m.menu_id from sys_menu m
where m.menu_id between 2000 and 2299
  and not exists (select 1 from sys_role_menu rm where rm.role_id=1 and rm.menu_id=m.menu_id);
