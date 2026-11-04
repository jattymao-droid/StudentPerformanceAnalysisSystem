-- SPAS: dedupe practice menus
-- Keep 2170/2220 from spas_group_practice.sql; hide duplicate 2410-2422 from spas_practice_menu_fix.sql
-- visible: '0'=show, '1'=hide

update sys_menu
   set visible = '1',
       remark = coalesce(remark, '') || ' [dedupe: hidden, use 2170/2220]'
 where menu_id between 2410 and 2422
   and visible = '0';

-- Hide student proxy button (daily path retired)
update sys_menu
   set visible = '1',
       remark = coalesce(nullif(trim(remark), ''), '') || ' [proxy legacy; hidden]'
 where menu_id = 2222
   and visible = '0';

-- Keep teacher proxy button visible for admin makeup; annotate only
update sys_menu
   set remark = coalesce(nullif(trim(remark), ''), 'proxy legacy; admin makeup only')
 where menu_id = 2175
   and (remark is null or remark not like '%proxy legacy%');
