-- 小题得分明细：手工录入 / 修改 / 删除 按钮权限
-- 注意：2054 已被 spas:teacher:resetPwd 占用
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2056, '成绩修改', 2050, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:score:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where perms = 'spas:score:edit');

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2055, '成绩删除', 2050, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:score:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where perms = 'spas:score:remove');

insert into sys_role_menu(role_id, menu_id)
select 1, m.menu_id from sys_menu m
where m.perms in ('spas:score:edit', 'spas:score:remove')
  and not exists (select 1 from sys_role_menu rm where rm.role_id = 1 and rm.menu_id = m.menu_id);
