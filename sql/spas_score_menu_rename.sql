-- Rename score import menu to reduce confusion with examScore (school rank)
-- 2050: item-level scores for knowledge analysis
-- U& escapes: xiao-ti-cheng-ji / xiao-ti-dao-ru

update sys_menu
   set menu_name = U&'\5c0f\9898\6210\7ee9',
       remark = 'item scores for analysis paper; not school rank'
 where menu_id = 2050
   and menu_name <> U&'\5c0f\9898\6210\7ee9';

update sys_menu
   set menu_name = U&'\5c0f\9898\5bfc\5165'
 where menu_id = 2052
   and menu_name <> U&'\5c0f\9898\5bfc\5165';