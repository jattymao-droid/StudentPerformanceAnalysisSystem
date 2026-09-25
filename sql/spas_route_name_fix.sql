-- Fix duplicate vue-router names when multiple menus share the same path segment
-- (RuoYi capitalizes path as route name when route_name is empty)

update sys_menu set route_name = 'KnowledgeTree' where menu_id = 2020;
update sys_menu set route_name = 'StudentProfile' where menu_id = 2030;
update sys_menu set route_name = 'BizPaper' where menu_id = 2040;
update sys_menu set route_name = 'AnalysisStudent' where menu_id = 2070;
update sys_menu set route_name = 'AnalysisKnowledge' where menu_id = 2080;
update sys_menu set route_name = 'QbPaper' where menu_id = 2310;
