-- Fix duplicate vue-router names (Student/Knowledge clash with base menus)
update sys_menu set route_name = 'AnalysisStudent' where menu_id = 2070;
update sys_menu set route_name = 'AnalysisKnowledge' where menu_id = 2080;
