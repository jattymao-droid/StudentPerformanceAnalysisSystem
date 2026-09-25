-- D2: error cause taxonomy v2 + migrate legacy codes (idempotent)
INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT U&'\9519\56e0\5927\7c7b', 'spas_error_category', '0', 'admin', now(), 'D2 error category'
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type='spas_error_category');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
SELECT * FROM (VALUES
 (1, U&'\77e5\8bc6\6027\9519\8bef', 'knowledge', 'spas_error_category', '', 'primary', 'N', '0', 'admin', now()),
 (2, U&'\6280\80fd\6027\9519\8bef', 'skill', 'spas_error_category', '', 'warning', 'N', '0', 'admin', now()),
 (3, U&'\7b56\7565\6027\9519\8bef', 'strategy', 'spas_error_category', '', 'danger', 'N', '0', 'admin', now()),
 (4, U&'\5fc3\7406\6027\56e0\7d20', 'psychology', 'spas_error_category', '', 'info', 'N', '0', 'admin', now()),
 (5, U&'\672a\505a', 'skip', 'spas_error_category', '', 'info', 'N', '0', 'admin', now())
) AS v(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data d WHERE d.dict_type=v.dict_type AND d.dict_value=v.dict_value);

-- replace spas_error_cause children
DELETE FROM sys_dict_data WHERE dict_type='spas_error_cause';
INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
VALUES
 (1, U&'\6982\5ff5\4e0d\6e05', 'concept_unclear', 'spas_error_cause', '', 'primary', 'N', '0', 'admin', now(), 'knowledge'),
 (2, U&'\516c\5f0f\8bb0\9519', 'formula_wrong', 'spas_error_cause', '', 'primary', 'N', '0', 'admin', now(), 'knowledge'),
 (3, U&'\8ba1\7b97\5931\8bef', 'calc_slip', 'spas_error_cause', '', 'warning', 'N', '0', 'admin', now(), 'skill'),
 (4, U&'\5ba1\9898\9057\6f0f', 'reading_miss', 'spas_error_cause', '', 'warning', 'N', '0', 'admin', now(), 'skill'),
 (5, U&'\5355\4f4d\6362\7b97', 'unit_convert', 'spas_error_cause', '', 'warning', 'N', '0', 'admin', now(), 'skill'),
 (6, U&'\65f6\95f4\5206\914d', 'time_alloc', 'spas_error_cause', '', 'danger', 'N', '0', 'admin', now(), 'strategy'),
 (7, U&'\96be\9898\8017\65f6\8fc7\591a', 'hard_first', 'spas_error_cause', '', 'danger', 'N', '0', 'admin', now(), 'strategy'),
 (8, U&'\8003\8bd5\7126\8651', 'anxiety', 'spas_error_cause', '', 'info', 'N', '0', 'admin', now(), 'psychology'),
 (9, U&'\7c97\5fc3', 'careless', 'spas_error_cause', '', 'info', 'N', '0', 'admin', now(), 'psychology'),
 (10, U&'\672a\505a', 'skip', 'spas_error_cause', '', 'info', 'N', '0', 'admin', now(), 'skip');

UPDATE sys_dict_type SET remark='D2 subcodes; remark on data = category' WHERE dict_type='spas_error_cause';

-- migrate legacy tags
UPDATE spas_error_tag SET error_code='concept_unclear', update_time=now() WHERE error_code='concept';
UPDATE spas_error_tag SET error_code='calc_slip', update_time=now() WHERE error_code='calc';
UPDATE spas_error_tag SET error_code='reading_miss', update_time=now() WHERE error_code='reading';
-- skip stays

COMMENT ON COLUMN spas_error_tag.error_code IS 'v2 subcode: concept_unclear|formula_wrong|calc_slip|...';
