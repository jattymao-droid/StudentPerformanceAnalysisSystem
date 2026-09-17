-- SPAS teacher roles, menus, grants (PostgreSQL UTF-8 via U& escapes, idempotent)

-- roles: bzr / grade leader / school leader
insert into sys_role(role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select U&'\73ed\4e3b\4efb', 'spas_bzr', 11, '3', 1, 1, '0', '0', 'admin', now(), 'SPAS homeroom teacher, class scope'
where not exists (select 1 from sys_role where role_key = 'spas_bzr');

insert into sys_role(role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select U&'\5e74\7ea7\8d1f\8d23\4eba', 'spas_grade_leader', 12, '4', 1, 1, '0', '0', 'admin', now(), 'SPAS grade leader, dept and children'
where not exists (select 1 from sys_role where role_key = 'spas_grade_leader');

insert into sys_role(role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, remark)
select U&'\6821\7ea7\9886\5bfc', 'spas_school_leader', 13, '4', 1, 1, '0', '0', 'admin', now(), 'SPAS school leader, school subtree read'
where not exists (select 1 from sys_role where role_key = 'spas_school_leader');

-- update existing role data scopes
update sys_role set data_scope = '3', role_name = U&'\4efb\8bfe\6559\5e08' where role_key = 'spas_teacher';
update sys_role set data_scope = '2', role_name = U&'\6559\52a1' where role_key = 'spas_jw';

-- teacher management menu under base data
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2045, U&'\6559\5e08\7ba1\7406', 2001, 4, 'teacher', 'spas/teacher/index', '', '', 1, 0, 'C', '0', '0', 'spas:teacher:list', 'peoples', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2045);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2046, U&'\6559\5e08\67e5\8be2', 2045, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:teacher:query', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2046);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2047, U&'\6559\5e08\65b0\589e', 2045, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:teacher:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2047);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2048, U&'\6559\5e08\4fee\6539', 2045, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:teacher:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2048);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2049, U&'\6559\5e08\5220\9664', 2045, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:teacher:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2049);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2054, U&'\91cd\7f6e\5bc6\7801', 2045, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:teacher:resetPwd', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2054);

-- admin + spas_admin: teacher mgmt
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id from sys_role r cross join sys_menu m
where r.role_key in ('admin', 'spas_admin') and m.menu_id between 2045 and 2054
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);

-- spas_jw: teacher mgmt + full base (already has subject/student)
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id from sys_role r cross join sys_menu m
where r.role_key = 'spas_jw' and m.menu_id between 2045 and 2054
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);

-- spas_bzr: teacher perms + student import + same biz as teacher
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id from sys_role r cross join sys_menu m
where r.role_key = 'spas_bzr'
  and m.menu_id in (
    2000, 2001, 2030, 2031, 2032, 2033, 2034, 2035, 2036,
    2002, 2040, 2041, 2042, 2043, 2044, 2050, 2051, 2052, 2053,
    2003, 2060, 2070, 2080, 2004, 2100, 2101, 2102, 2110, 2111
  )
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);

-- spas_grade_leader: analysis + warning + student view + portfolio + score view
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id from sys_role r cross join sys_menu m
where r.role_key = 'spas_grade_leader'
  and m.menu_id in (
    2000, 2001, 2030, 2031, 2036, 2037,
    2002, 2050, 2051, 2053,
    2003, 2060, 2070, 2080,
    2004, 2090, 2091, 2095, 2100, 2101, 2102,
    2110, 2111
  )
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);

-- spas_school_leader: read-heavy overview
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id from sys_role r cross join sys_menu m
where r.role_key = 'spas_school_leader'
  and m.menu_id in (
    2000, 2003, 2060, 2070, 2080,
    2004, 2100, 2101,
    2110, 2030, 2031, 2050, 2051, 2053
  )
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);

-- jw custom dept: school subtree for demo
insert into sys_role_dept(role_id, dept_id)
select r.role_id, 9100 from sys_role r
where r.role_key = 'spas_jw'
  and not exists (select 1 from sys_role_dept rd where rd.role_id = r.role_id and rd.dept_id = 9100);
