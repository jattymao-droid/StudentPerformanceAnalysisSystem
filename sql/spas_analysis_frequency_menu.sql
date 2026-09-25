-- Knowledge examination frequency menu under analysis (menu_id 2081)
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2081,
       U&'\8003\67E5\9891\6B21',
       2003, 4, 'frequency', 'spas/analysis/frequency', '', 'AnalysisFrequency',
       1, 0, 'C', '0', '0', 'spas:analysis:frequency', 'chart', 'admin', now(),
       U&'\77E5\8BC6\70B9\8003\67E5\9891\6B21\FF1A\5355\6B21/\591A\6B21\8003\8BD5'
where not exists (select 1 from sys_menu where menu_id=2081);

insert into sys_role_menu(role_id, menu_id)
select 1, 2081
where not exists (select 1 from sys_role_menu where role_id=1 and menu_id=2081);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, 2081
from sys_role r
where exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = 2080)
  and not exists (select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = 2081);
