-- SPAS UI trim: hide unused RuoYi menus (visible=1 means hidden in RuoYi)
-- Keep system core + monitor job (110) for warning schedule

update sys_menu set visible = '1', status = '1' where menu_id = 4;

update sys_menu set visible = '1' where menu_id in (3, 115, 116, 117);
update sys_menu set visible = '1' where parent_id = 3 or parent_id in (115, 116, 117);

update sys_menu set visible = '1' where menu_id in (109, 111, 112, 113, 114);
update sys_menu set menu_name = E'\u8fd0\u7ef4\u4e0e\u4efb\u52a1' where menu_id = 2;
update sys_menu set visible = '0' where menu_id = 110;

update sys_menu set visible = '1' where menu_id = 104;

update sys_dept set dept_name = E'\u793a\u8303\u5b66\u6821' where dept_id = 100 and dept_name like E'%\u82e5\u4f9d%';

update sys_notice set notice_title = E'\u5b66\u60c5\u7cfb\u7edf\u4e0a\u7ebf\u63d0\u793a',
  notice_content = E'\u6b22\u8fce\u4f7f\u7528\u5b66\u751f\u5b66\u60c5\u5206\u6790\u7cfb\u7edf\u3002\u5efa\u8bae\u8def\u5f84\uff1a\u6210\u7ee9\u5bfc\u5165 \u2192 \u5b66\u60c5\u5206\u6790 \u2192 \u9884\u8b66\u6267\u884c \u2192 \u4e00\u751f\u4e00\u518c\u3002',
  status = '0'
where notice_id = 1;
update sys_notice set status = '1' where notice_id in (2, 3);
