-- SPAS: ѧ�����ֲ˵� + ��ʦһ�����ְ�ť��idempotent��
-- Doc: docs/spas-group-daily-practice-desktop.md ��8B
-- Depends: spas_student_points.sql (��), spas_group_practice.sql (2170 ������)

-- Ŀ¼����ѧҵ���¡�ѧ�����֡�
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2430, 'ѧ������', 2002, 21, 'points', null, '', '', 1, 0, 'M', '0', '0', '', 'star', 'admin', now(), 'student points hub'
where not exists (select 1 from sys_menu where menu_id = 2430);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2431, '�����˻�', 2430, 1, 'account', 'spas/points/account', '', 'SpasPointAccount', 1, 0, 'C', '0', '0', 'spas:point:account:list', 'peoples', 'admin', now(), 'class point accounts + batch award'
where not exists (select 1 from sys_menu where menu_id = 2431);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2432, '���ֹ���', 2430, 2, 'rule', 'spas/points/rule', '', 'SpasPointRule', 1, 0, 'C', '0', '0', 'spas:point:rule:list', 'documentation', 'admin', now(), 'built-in point rules (read-only)'
where not exists (select 1 from sys_menu where menu_id = 2432);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2433, '�ҵĻ���', 2200, 6, 'points', 'spas/points/mine', '', 'SpasPointMine', 1, 0, 'C', '0', '0', 'spas:point:mine', 'star', 'admin', now(), 'student self points'
where not exists (select 1 from sys_menu where menu_id = 2433);

-- ��ť��һ�����֣����ڻ����˻��£�Ҳ�ɽ��� practice:edit/list ʹ�ã�
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2434, 'һ������', 2431, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:point:award', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2434);

-- ���������ҳͬ����һ�����ְ�ťȨ�ޣ���ѡ��
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2179, '���ַ���', 2170, 9, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:point:award', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 2179);

-- ��ʦ / ������ / �꼶 / ���� / ����Ա
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key in ('admin', 'spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader')
  and m.menu_id in (2430, 2431, 2432, 2434, 2179)
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_school_leader'
  and m.menu_id in (2430, 2431, 2432)
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_student'
  and m.menu_id in (2433)
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id);
