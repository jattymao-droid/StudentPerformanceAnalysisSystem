-- Rename analysis paper menu (2040) to distinguish from QB compose (2310)
-- U&: fen-xi-shi-juan / fen-xi-juan-*

update sys_menu
   set menu_name = U&'\5206\6790\8bd5\5377',
       remark = 'analysis paper for item scores; compose via QB then publish'
 where menu_id = 2040
   and menu_name <> U&'\5206\6790\8bd5\5377';

update sys_menu set menu_name = U&'\5206\6790\5377\67e5\8be2' where menu_id = 2041 and menu_name <> U&'\5206\6790\5377\67e5\8be2';
update sys_menu set menu_name = U&'\5206\6790\5377\65b0\589e' where menu_id = 2042 and menu_name <> U&'\5206\6790\5377\65b0\589e';
update sys_menu set menu_name = U&'\5206\6790\5377\4fee\6539' where menu_id = 2043 and menu_name <> U&'\5206\6790\5377\4fee\6539';
update sys_menu set menu_name = U&'\5206\6790\5377\5220\9664' where menu_id = 2044 and menu_name <> U&'\5206\6790\5377\5220\9664';