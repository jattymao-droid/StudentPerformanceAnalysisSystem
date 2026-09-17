-- Knowledge node type: 0 version, 1 chapter, 2 knowledge point
ALTER TABLE spas_knowledge ADD COLUMN IF NOT EXISTS node_type char(1) DEFAULT '2';
COMMENT ON COLUMN spas_knowledge.node_type IS '0 version 1 chapter 2 knowledge';

UPDATE spas_knowledge SET node_type = '2' WHERE node_type IS NULL OR node_type = '';

INSERT INTO sys_dict_type(dict_name, dict_type, status, create_by, create_time, remark)
SELECT U&'\77e5\8bc6\70b9\8282\70b9\7c7b\578b', 'spas_knowledge_node_type', '0', 'admin', now(), U&'\7248\672c/\7ae0\8282/\77e5\8bc6\70b9'
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'spas_knowledge_node_type');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
SELECT 0, U&'\7248\672c', '0', 'spas_knowledge_node_type', '', 'info', 'N', '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'spas_knowledge_node_type' AND dict_value = '0');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
SELECT 1, U&'\7ae0\8282', '1', 'spas_knowledge_node_type', '', 'primary', 'N', '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'spas_knowledge_node_type' AND dict_value = '1');

INSERT INTO sys_dict_data(dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time)
SELECT 2, U&'\77e5\8bc6\70b9', '2', 'spas_knowledge_node_type', '', 'success', 'Y', '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'spas_knowledge_node_type' AND dict_value = '2');
