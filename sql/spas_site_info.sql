-- 站点版权 / ICP 备案（登录页与系统管理「站点信息」）
-- 幂等：按 config_key / menu_id 去重

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '站点版权文案', 'sys.site.copyright', '知脉 · 学生学情分析系统', 'Y', 'admin', now(),
       '登录页与页脚版权文字，可含 © 年份'
where not exists (select 1 from sys_config where config_key = 'sys.site.copyright');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'ICP备案号', 'sys.site.icp', '', 'Y', 'admin', now(),
       '如：粤ICP备xxxxxxxx号；空则登录页不显示备案行'
where not exists (select 1 from sys_config where config_key = 'sys.site.icp');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select 'ICP备案链接', 'sys.site.icpUrl', 'https://beian.miit.gov.cn/', 'Y', 'admin', now(),
       '备案号点击跳转地址，默认工信部查询页'
where not exists (select 1 from sys_config where config_key = 'sys.site.icpUrl');

-- 系统管理 → 站点信息（菜单 119，按钮 1191）
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 119, '站点信息', 1, 8, 'site', 'system/site/index', '', 'SysSite', 1, 0, 'C', '0', '0',
       'system:site:list', 'documentation', 'admin', now(), '登录页版权与ICP备案'
where not exists (select 1 from sys_menu where menu_id = 119);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
select 1191, '站点修改', 119, 1, '', '', '', '', 1, 0, 'F', '0', '0',
       'system:site:edit', '#', 'admin', now()
where not exists (select 1 from sys_menu where menu_id = 1191 or perms = 'system:site:edit');

insert into sys_role_menu(role_id, menu_id)
select 1, m.menu_id from sys_menu m
where m.menu_id in (119, 1191)
  and not exists (select 1 from sys_role_menu rm where rm.role_id = 1 and rm.menu_id = m.menu_id);
