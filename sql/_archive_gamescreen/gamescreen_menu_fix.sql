-- 活动大屏菜单 ID 冲突修复（与学情中心等占用 2000+ 的库并存）
-- 将 gs 菜单迁移到 3000+，并清理误挂在 2000 段的条目

-- 清理旧 role_menu（2004-2040 段 gs 菜单 + 角色3）
delete from sys_role_menu where role_id = 3;
delete from sys_role_menu where menu_id between 2004 and 2040;

-- 清理误插入的 gs 菜单（保留学情中心 2000-2003）
delete from sys_menu where menu_id between 2004 and 2040;

-- 活动大屏目录与子菜单 3000+
insert into sys_menu values('3000', '活动大屏', '0', '6', 'gamescreen', null, '', '', 1, 0, 'M', '0', '0', '', 'guide', 'admin', now(), '', null, '活动大屏目录')
on conflict (menu_id) do update set menu_name=excluded.menu_name, parent_id=excluded.parent_id, order_num=excluded.order_num, path=excluded.path, icon=excluded.icon, remark=excluded.remark;

insert into sys_menu values('3001', '活动配置', '3000', '1', 'activity', 'gamescreen/activity/index', '', '', 1, 0, 'C', '0', '0', 'gs:activity:list', 'edit', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3002', '功能开关', '3000', '2', 'plug', 'gamescreen/plug/index', '', '', 1, 0, 'C', '0', '0', 'gs:plug:list', 'switch', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3003', '签到用户', '3000', '3', 'attendee', 'gamescreen/attendee/index', '', '', 1, 0, 'C', '0', '0', 'gs:attendee:list', 'peoples', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3004', '上墙审核', '3000', '4', 'wall', 'gamescreen/wall/index', '', '', 1, 0, 'C', '0', '0', 'gs:wall:list', 'message', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3005', '投票管理', '3000', '5', 'vote', 'gamescreen/vote/index', '', '', 1, 0, 'C', '0', '0', 'gs:vote:list', 'list', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3006', '奖品中台', '3000', '6', 'prize', 'gamescreen/prize/index', '', '', 1, 0, 'C', '0', '0', 'gs:prize:list', 'star', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3007', '抽奖玩法', '3000', '7', 'lottery', 'gamescreen/lottery/index', '', '', 1, 0, 'C', '0', '0', 'gs:lottery:list', 'guide', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3008', '竞速游戏', '3000', '8', 'game', 'gamescreen/game/index', '', '', 1, 0, 'C', '0', '0', 'gs:game:list', 'example', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3009', '红包雨', '3000', '9', 'redpacket', 'gamescreen/redpacket/index', '', '', 1, 0, 'C', '0', '0', 'gs:redpacket:list', 'money', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3010', '展示内容', '3000', '10', 'content', 'gamescreen/content/index', '', '', 1, 0, 'C', '0', '0', 'gs:content:list', 'documentation', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3011', '运营工具', '3000', '11', 'ops', 'gamescreen/ops/index', '', '', 1, 0, 'C', '0', '0', 'gs:ops:list', 'tool', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3012', '3D签到配置', '3000', '12', 'threed', 'gamescreen/threed/index', '', '', 1, 0, 'C', '0', '0', 'gs:threed:list', 'example', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;
insert into sys_menu values('3013', '幸运记录', '3000', '13', 'lucky', 'gamescreen/lucky/index', '', '', 1, 0, 'C', '0', '0', 'gs:lucky:list', 'skill', 'admin', now(), '', null, '')
on conflict (menu_id) do update set parent_id='3000', component=excluded.component, perms=excluded.perms;

-- 按钮权限
insert into sys_menu values('3021', '活动查询', '3001', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:activity:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3001', perms=excluded.perms;
insert into sys_menu values('3022', '活动修改', '3001', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:activity:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3001', perms=excluded.perms;
insert into sys_menu values('3023', '活动创建', '3001', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:activity:create', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3001', perms=excluded.perms;
insert into sys_menu values('3024', '插件修改', '3002', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:plug:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3002', perms=excluded.perms;
insert into sys_menu values('3025', '插件查询', '3002', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:plug:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3002', perms=excluded.perms;
insert into sys_menu values('3026', '用户修改', '3003', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:attendee:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3003', perms=excluded.perms;
insert into sys_menu values('3027', '观众查询', '3003', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:attendee:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3003', perms=excluded.perms;
insert into sys_menu values('3028', '上墙审核按钮', '3004', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:wall:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3004', perms=excluded.perms;
insert into sys_menu values('3029', '上墙查询', '3004', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:wall:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3004', perms=excluded.perms;
insert into sys_menu values('3030', '投票修改', '3005', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:vote:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3005', perms=excluded.perms;
insert into sys_menu values('3031', '投票查询', '3005', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:vote:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3005', perms=excluded.perms;
insert into sys_menu values('3032', '奖品修改', '3006', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:prize:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3006', perms=excluded.perms;
insert into sys_menu values('3033', '奖品查询', '3006', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:prize:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3006', perms=excluded.perms;
insert into sys_menu values('3034', '抽奖执行', '3007', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:lottery:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3007', perms=excluded.perms;
insert into sys_menu values('3035', '抽奖查询', '3007', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:lottery:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3007', perms=excluded.perms;
insert into sys_menu values('3036', '游戏控制', '3008', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:game:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3008', perms=excluded.perms;
insert into sys_menu values('3037', '游戏查询', '3008', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:game:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3008', perms=excluded.perms;
insert into sys_menu values('3038', '红包控制', '3009', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:redpacket:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3009', perms=excluded.perms;
insert into sys_menu values('3039', '红包查询', '3009', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:redpacket:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3009', perms=excluded.perms;
insert into sys_menu values('3040', '内容修改', '3010', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:content:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3010', perms=excluded.perms;
insert into sys_menu values('3041', '内容查询', '3010', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:content:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3010', perms=excluded.perms;
insert into sys_menu values('3042', '运营修改', '3011', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:ops:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3011', perms=excluded.perms;
insert into sys_menu values('3043', '运营查询', '3011', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:ops:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3011', perms=excluded.perms;
insert into sys_menu values('3044', '对对碰执行', '3011', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:ops:pair', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3011', perms=excluded.perms;
insert into sys_menu values('3045', '3D签到修改', '3012', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:threed:edit', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3012', perms=excluded.perms;
insert into sys_menu values('3046', '3D查询', '3012', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:threed:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3012', perms=excluded.perms;
insert into sys_menu values('3047', '幸运查询', '3013', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'gs:lucky:query', '#', 'admin', now(), '', null, '') on conflict (menu_id) do update set parent_id='3013', perms=excluded.perms;

-- 活动运营角色
insert into sys_role values('3', '活动运营', 'gamescreen', 3, 1, 1, 1, '0', '0', 'admin', now(), '', null, '活动大屏运营人员')
on conflict (role_id) do nothing;

insert into sys_role_menu (role_id, menu_id)
select '3', m::bigint from unnest(array[
  '3000','3001','3002','3003','3004','3005','3006','3007','3008','3009','3010','3011','3012','3013',
  '3021','3022','3023','3024','3025','3026','3027','3028','3029','3030','3031','3032','3033','3034','3035',
  '3036','3037','3038','3039','3040','3041','3042','3043','3044','3045','3046','3047'
]) as m
on conflict do nothing;

select setval(pg_get_serial_sequence('sys_menu', 'menu_id'), (select coalesce(max(menu_id), 1) from sys_menu));
