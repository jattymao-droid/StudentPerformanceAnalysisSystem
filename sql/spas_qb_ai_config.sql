-- SPAS QB AI / LLM settings in sys_config + System Management menu
-- PostgreSQL, idempotent

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '题库AI-启用', 'spas.qb.ai.enabled', 'false', 'N', 'admin', current_timestamp,
       'true=远程大模型；false=本地启发式'
where not exists (select 1 from sys_config where config_key = 'spas.qb.ai.enabled');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '题库AI-接口地址', 'spas.qb.ai.endpoint', 'https://api.deepseek.com/v1/chat/completions', 'N', 'admin', current_timestamp,
       'OpenAI-compatible chat/completions URL'
where not exists (select 1 from sys_config where config_key = 'spas.qb.ai.endpoint');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '题库AI-API密钥', 'spas.qb.ai.api-key', '', 'N', 'admin', current_timestamp,
       'DeepSeek Bearer Token'
where not exists (select 1 from sys_config where config_key = 'spas.qb.ai.api-key');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '题库AI-模型名', 'spas.qb.ai.model', 'deepseek-chat', 'N', 'admin', current_timestamp,
       'e.g. deepseek-chat'
where not exists (select 1 from sys_config where config_key = 'spas.qb.ai.model');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '题库AI-超时毫秒', 'spas.qb.ai.timeout-ms', '30000', 'N', 'admin', current_timestamp,
       'HTTP connect/read timeout'
where not exists (select 1 from sys_config where config_key = 'spas.qb.ai.timeout-ms');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '题库AI-建议条数', 'spas.qb.ai.top-k', '5', 'N', 'admin', current_timestamp,
       'Max knowledge suggestions per call'
where not exists (select 1 from sys_config where config_key = 'spas.qb.ai.top-k');

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 118, '大模型配置', 1, 10, 'llm', 'system/llm/index', '', '', 1, 0, 'C', '0', '0',
       'system:llm:query', 'guide', 'admin', current_timestamp, 'QB AI LLM settings'
where not exists (select 1 from sys_menu where menu_id = 118);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 1181, '大模型查询', 118, 1, '#', '', '', '', 1, 0, 'F', '0', '0',
       'system:llm:query', '#', 'admin', current_timestamp, ''
where not exists (select 1 from sys_menu where menu_id = 1181);

insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 1182, '大模型修改', 118, 2, '#', '', '', '', 1, 0, 'F', '0', '0',
       'system:llm:edit', '#', 'admin', current_timestamp, ''
where not exists (select 1 from sys_menu where menu_id = 1182);

insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key in ('admin')
  and m.menu_id in (118, 1181, 1182)
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );
