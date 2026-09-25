-- P1: extend score_source semantics + warning reason_json
-- score_source: 1=manual 2=import 3=blank-as-zero 4=absent 5=not-attempted

ALTER TABLE spas_warning_record ADD COLUMN IF NOT EXISTS reason_json text;
COMMENT ON COLUMN spas_warning_record.reason_json IS 'structured trigger payload JSON';

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
SELECT v.dict_sort, v.dict_label, v.dict_value, 'spas_score_source', '', v.list_class, 'N', '0', 'admin', now()
FROM (VALUES
  (4, U&'\7f3a\8003', '4', 'danger'),
  (5, U&'\672a\505a', '5', 'warning')
) AS v(dict_sort, dict_label, dict_value, list_class)
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data d WHERE d.dict_type='spas_score_source' AND d.dict_value=v.dict_value
);

UPDATE sys_dict_data SET dict_label = U&'\8865\5f55' WHERE dict_type='spas_score_source' AND dict_value='1';
UPDATE sys_dict_data SET dict_label = U&'\5bfc\5165\5b9e\5f97' WHERE dict_type='spas_score_source' AND dict_value='2';
UPDATE sys_dict_data SET dict_label = U&'\7a7a\767d\7f6e\96f6' WHERE dict_type='spas_score_source' AND dict_value='3';
