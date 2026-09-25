-- Optional warning rules for imported school ranks. No new tables.
-- RANK_DROP: last 3 total ranks strictly worse, drop more than 10 places.
-- SUBJECT_IMBALANCE: one subject rank worse than total by more than 20 places.

insert into spas_warning_rule(rule_name, rule_code, scope_type, scope_id, metric, operator, threshold, window_days, level, enabled, notify_channels, create_by, create_time, remark)
select '总分校次连续下滑', 'RANK_DROP_DEFAULT', '1', null, 'RANK_DROP', '>', 10, 3, '2', '1', 'system', 'admin', now(),
       '最近3场总分校次逐场变差且退步超过10名'
where not exists (select 1 from spas_warning_rule where rule_code = 'RANK_DROP_DEFAULT');

insert into spas_warning_rule(rule_name, rule_code, scope_type, scope_id, metric, operator, threshold, window_days, level, enabled, notify_channels, create_by, create_time, remark)
select '单科落后总分', 'SUBJECT_IMBALANCE_DEFAULT', '1', null, 'SUBJECT_IMBALANCE', '>', 20, 1, '2', '1', 'system', 'admin', now(),
       '最近一场至少一科校次比总分落后超过20名'
where not exists (select 1 from spas_warning_rule where rule_code = 'SUBJECT_IMBALANCE_DEFAULT');
