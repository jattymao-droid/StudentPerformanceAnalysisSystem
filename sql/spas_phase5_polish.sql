-- Phase 5 polish: warning buttons + teacher/jw role menus (idempotent)

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2091, 'Rule Query', 2090, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:warning:rule', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2091);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2092, 'Rule Add', 2090, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:warning:rule:add', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2092);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2093, 'Rule Edit', 2090, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:warning:rule:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2093);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2094, 'Rule Remove', 2090, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:warning:rule:remove', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2094);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2095, 'Rule Run', 2090, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:warning:rule:run', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2095);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2101, 'Record Query', 2100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:warning:record', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2101);
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2102, 'Record Handle', 2100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:warning:record:handle', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2102);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 2111, 'Coach Log', 2110, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'spas:portfolio:coach', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id=2111);

insert into sys_role_menu(role_id, menu_id)
select 1, m.menu_id from sys_menu m
where m.menu_id in (2091,2092,2093,2094,2095,2101,2102,2111)
  and not exists (select 1 from sys_role_menu rm where rm.role_id=1 and rm.menu_id=m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key='spas_admin' and m.menu_id in (2091,2092,2093,2094,2095,2101,2102,2111)
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);

delete from sys_role_menu rm
using sys_role r
where rm.role_id = r.role_id
  and r.role_key = 'spas_admin'
  and rm.menu_id in (2200, 2210);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_teacher'
  and m.menu_id in (
    2000, 2001, 2030, 2031, 2032, 2033, 2034, 2035,
    2002, 2040, 2041, 2042, 2043, 2044,
    2050, 2051, 2052,
    2003, 2060, 2070, 2080,
    2004, 2100, 2101, 2102,
    2110, 2111
  )
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key = 'spas_jw'
  and m.menu_id in (
    2000, 2001, 2010, 2011, 2012, 2013, 2014,
    2020, 2021, 2022, 2023, 2024,
    2030, 2031, 2032, 2033, 2034, 2035,
    2003, 2060, 2070, 2080,
    2004, 2090, 2091, 2092, 2093, 2094, 2095, 2100, 2101, 2102,
    2110, 2111
  )
  and not exists (select 1 from sys_role_menu rm where rm.role_id=r.role_id and rm.menu_id=m.menu_id);

update sys_menu set menu_name = '规则查询' where menu_id=2091;
update sys_menu set menu_name = '规则新增' where menu_id=2092;
update sys_menu set menu_name = '规则修改' where menu_id=2093;
update sys_menu set menu_name = '规则删除' where menu_id=2094;
update sys_menu set menu_name = '立即执行' where menu_id=2095;
update sys_menu set menu_name = '记录查询' where menu_id=2101;
update sys_menu set menu_name = '记录处理' where menu_id=2102;
update sys_menu set menu_name = '辅导记录' where menu_id=2111;
