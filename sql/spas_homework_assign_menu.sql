-- Homework assignment menu (simplified class+subject+date)
-- Route: /spas/biz/hw-task  → component spas/homework/task

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2425, E'\u4f5c\u4e1a\u5e03\u7f6e', 2002, 19, 'hw-task', 'spas/homework/task', '', 'HwTask', 1, 0, 'C', '0', '0', 'spas:practice:edit', 'date', 'admin', now(), 'daily homework assign (class+subject+date)'
where not exists (select 1 from sys_menu where menu_id=2425);

insert into sys_role_menu(role_id, menu_id)
select 1, 2425
where not exists (select 1 from sys_role_menu where role_id=1 and menu_id=2425);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, 2425
from sys_role r
where r.role_key in ('spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader')
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=2425);
