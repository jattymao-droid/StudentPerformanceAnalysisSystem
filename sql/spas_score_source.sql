-- score_source: 1=manual 2=import 3=blank-as-zero
alter table spas_score_detail add column if not exists score_source char(1) default '2';
comment on column spas_score_detail.score_source is '1=manual 2=import 3=blank-as-zero';
create index if not exists idx_spas_score_detail_source on spas_score_detail(score_source);

insert into sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
select '成绩来源', 'spas_score_source', '0', 'admin', now(), null
where not exists (select 1 from sys_dict_type where dict_type='spas_score_source');

insert into sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
select * from (values
 (1, '手工', '1', 'spas_score_source', '', 'info', 'N', '0', 'admin', now()),
 (2, '导入', '2', 'spas_score_source', '', 'primary', 'Y', '0', 'admin', now()),
 (3, '空白置零', '3', 'spas_score_source', '', 'warning', 'N', '0', 'admin', now())
) as v(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
where not exists (select 1 from sys_dict_data d where d.dict_type='spas_score_source' and d.dict_value=v.dict_value);
