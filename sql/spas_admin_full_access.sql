-- Ensure admin / spas_admin have all menus and all-data scope (idempotent)

update sys_role set data_scope = '1' where role_key in ('admin', 'spas_admin');

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key in ('admin', 'spas_admin')
  and not exists (
    select 1 from sys_role_menu rm
    where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );
