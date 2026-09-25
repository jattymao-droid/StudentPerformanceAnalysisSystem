-- D4: bloom_level on paper question + dict (idempotent)
ALTER TABLE spas_paper_question ADD COLUMN IF NOT EXISTS bloom_level varchar(32);
COMMENT ON COLUMN spas_paper_question.bloom_level IS 'remember|understand|apply|analyze';

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT '认知层级', 'spas_bloom_level', '0', 'admin', now(), 'D4 Bloom light'
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type='spas_bloom_level');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
SELECT * FROM (VALUES
 (1, '记忆/识记', 'remember', 'spas_bloom_level', '', 'info', 'N', '0', 'admin', now()),
 (2, '理解', 'understand', 'spas_bloom_level', '', 'primary', 'N', '0', 'admin', now()),
 (3, '应用', 'apply', 'spas_bloom_level', '', 'success', 'N', '0', 'admin', now()),
 (4, '分析/综合', 'analyze', 'spas_bloom_level', '', 'warning', 'N', '0', 'admin', now())
) AS v(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data d WHERE d.dict_type=v.dict_type AND d.dict_value=v.dict_value);
