-- SPAS question bank menus (Plan B) — menu_id 2300+ (avoid 2200 我的学情 / 2210 一生一册)

-- Parent: 学情 2000



insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2300, '题库', 2000, 25, 'qb', null, '', '', 1, 0, 'M', '0', '0', '', 'education', 'admin', current_timestamp, 'Question bank directory'

where not exists (select 1 from sys_menu where menu_id=2300);



insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2301, '题目管理', 2300, 1, 'question', 'spas/qb/question/index', '', '', 1, 0, 'C', '0', '0', 'spas:qb:question:list', 'list', 'admin', current_timestamp, 'Bank questions'

where not exists (select 1 from sys_menu where menu_id=2301);



insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2302, '题目查询', 2301, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'spas:qb:question:query', '#', 'admin', current_timestamp, ''

where not exists (select 1 from sys_menu where menu_id=2302);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2303, '题目新增', 2301, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'spas:qb:question:add', '#', 'admin', current_timestamp, ''

where not exists (select 1 from sys_menu where menu_id=2303);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2304, '题目修改', 2301, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'spas:qb:question:edit', '#', 'admin', current_timestamp, ''

where not exists (select 1 from sys_menu where menu_id=2304);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2305, '题目删除', 2301, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'spas:qb:question:remove', '#', 'admin', current_timestamp, ''

where not exists (select 1 from sys_menu where menu_id=2305);



insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2310, '题库组卷', 2300, 2, 'paper', 'spas/qb/paper/index', '', 'QbPaper', 1, 0, 'C', '0', '0', 'spas:qb:paper:list', 'form', 'admin', current_timestamp, 'Bank paper compose'

where not exists (select 1 from sys_menu where menu_id=2310);



insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2311, '组卷查询', 2310, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'spas:qb:paper:query', '#', 'admin', current_timestamp, ''

where not exists (select 1 from sys_menu where menu_id=2311);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2312, '组卷新增', 2310, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'spas:qb:paper:add', '#', 'admin', current_timestamp, ''

where not exists (select 1 from sys_menu where menu_id=2312);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2313, '组卷修改', 2310, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'spas:qb:paper:edit', '#', 'admin', current_timestamp, ''

where not exists (select 1 from sys_menu where menu_id=2313);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2314, '组卷删除', 2310, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'spas:qb:paper:remove', '#', 'admin', current_timestamp, ''

where not exists (select 1 from sys_menu where menu_id=2314);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)

select 2315, '发布分析卷', 2310, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'spas:qb:paper:publish', '#', 'admin', current_timestamp, ''

where not exists (select 1 from sys_menu where menu_id=2315);



-- Grant to admin / spas teaching roles

insert into sys_role_menu(role_id, menu_id)

select r.role_id, m.menu_id

from sys_role r

cross join sys_menu m

where r.role_key in ('admin', 'spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader')

  and m.menu_id between 2300 and 2315

  and not exists (

    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id

  );

