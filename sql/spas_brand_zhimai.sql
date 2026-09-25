-- 知脉品牌显示名（已有库增量；技术路径 /spas、表前缀 spas_ 不变）
-- 用法: psql -U postgres -d spas-sql -f sql/spas_brand_zhimai.sql

update sys_menu
   set menu_name = '知脉',
       remark = '知脉 root',
       update_by = 'admin',
       update_time = now()
 where menu_id = 2000
   and menu_name <> '知脉';

update sys_role
   set remark = replace(coalesce(remark, ''), 'SPAS', '知脉')
 where role_key like 'spas_%'
   and remark like '%SPAS%';
