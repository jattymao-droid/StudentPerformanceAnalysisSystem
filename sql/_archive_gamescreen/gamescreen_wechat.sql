-- 微信/商户可视化配置菜单（可重复执行）
insert into sys_menu values('3053', '微信配置', '3000', '16', 'wechat', 'gamescreen/wechat/index', '', '', 1, 0, 'C', '0', '0', 'gs:wechat:list', 'wechat', 'admin', now(), '', null, '公众号 OAuth 与商户付款')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3054', '微信配置修改', '3053', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:wechat:edit', '#', 'admin', now(), '', null, '')
on conflict (menu_id) do nothing;
insert into sys_menu values('3055', '微信配置查询', '3053', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:wechat:query', '#', 'admin', now(), '', null, '')
on conflict (menu_id) do nothing;

insert into sys_role_menu (role_id, menu_id) values ('3','3053'),('3','3054'),('3','3055')
on conflict do nothing;

insert into sys_config (config_id, config_name, config_key, config_value, config_type, create_by, create_time, remark)
values (210, 'Mock 微信登录', 'gs.wx.mock', 'true', 'N', 'admin', now(), '活动大屏 H5 模拟登录')
on conflict (config_id) do nothing;

select setval(pg_get_serial_sequence('sys_menu', 'menu_id'), (select coalesce(max(menu_id), 1) from sys_menu));
