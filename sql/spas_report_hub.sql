-- Make report hub visible with component page (idempotent)
update sys_menu
set menu_type = 'C',
    visible = '0',
    component = 'spas/report/index',
    path = 'report',
    perms = 'spas:report:export',
    icon = 'download',
    menu_name = '报告导出'
where menu_id = 2130;

insert into sys_role_menu(role_id, menu_id)
select r.role_id, 2130
from sys_role r
where r.role_key in ('admin', 'spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader', 'spas_school_leader')
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = 2130
  );
