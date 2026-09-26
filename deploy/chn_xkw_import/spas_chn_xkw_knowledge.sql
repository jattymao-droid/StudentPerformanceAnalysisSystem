-- 高中语文知识点树（来源：组卷网 lk_10.json / gzyw）
-- 幂等：按 knowledge_code=XKW-CHN-{xkwId} 去重
-- 导入：bash scripts/import_chn_xkw_knowledge.sh

INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
SELECT 'CHN', '语文', 1, '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'CHN');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT s.subject_id, 0, '0', '高中语文综合库', 'XKW-CHN-23177', '0', 1, '2', '0', 'admin', now(), 'xkw:23177'
FROM spas_subject s
WHERE s.subject_code = 'CHN'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23177');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言文字应用', 'XKW-CHN-23178', '1', 1, '2', '0', 'admin', now(), 'xkw:23178'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23178');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '阅读与鉴赏', 'XKW-CHN-23181', '1', 2, '2', '0', 'admin', now(), 'xkw:23181'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23181');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名篇名句默写', 'XKW-CHN-27854', '2', 3, '2', '0', 'admin', now(), 'xkw:27854'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27854');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '写作', 'XKW-CHN-23182', '1', 4, '2', '0', 'admin', now(), 'xkw:23182'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23182');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '作文主题', 'XKW-CHN-181847', '1', 5, '2', '0', 'admin', now(), 'xkw:181847'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181847');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '作家作品', 'XKW-CHN-208', '1', 6, '2', '0', 'admin', now(), 'xkw:208'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-208');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '字音', 'XKW-CHN-23186', '2', 1, '2', '0', 'admin', now(), 'xkw:23186'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23186');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '字形', 'XKW-CHN-23187', '2', 2, '2', '0', 'admin', now(), 'xkw:23187'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23187');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词汇', 'XKW-CHN-23183', '1', 3, '2', '0', 'admin', now(), 'xkw:23183'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23183');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '短语', 'XKW-CHN-184938', '2', 4, '2', '0', 'admin', now(), 'xkw:184938'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184938');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '句子', 'XKW-CHN-23184', '1', 5, '2', '0', 'admin', now(), 'xkw:23184'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23184');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语段', 'XKW-CHN-23185', '1', 6, '2', '0', 'admin', now(), 'xkw:23185'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23185');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语文综合实践', 'XKW-CHN-182518', '2', 7, '2', '0', 'admin', now(), 'xkw:182518'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182518');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '朗读和停顿', 'XKW-CHN-184608', '2', 8, '2', '0', 'admin', now(), 'xkw:184608'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184608');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文学常识综合', 'XKW-CHN-26218', '2', 1, '2', '0', 'admin', now(), 'xkw:26218'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26218');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文学类文本', 'XKW-CHN-27870', '1', 2, '2', '0', 'admin', now(), 'xkw:27870'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27870');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实用类文本', 'XKW-CHN-27871', '1', 3, '2', '0', 'admin', now(), 'xkw:27871'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27871');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '论述类文本', 'XKW-CHN-27869', '1', 4, '2', '0', 'admin', now(), 'xkw:27869'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27869');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '信息类文本', 'XKW-CHN-157938', '1', 5, '2', '0', 'admin', now(), 'xkw:157938'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157938');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '整本书阅读', 'XKW-CHN-27855', '1', 6, '2', '0', 'admin', now(), 'xkw:27855'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27855');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文言文阅读', 'XKW-CHN-27850', '1', 7, '2', '0', 'admin', now(), 'xkw:27850'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27850');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古代诗歌阅读', 'XKW-CHN-27851', '1', 8, '2', '0', 'admin', now(), 'xkw:27851'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27851');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '课文分析理解', 'XKW-CHN-194472', '2', 9, '2', '0', 'admin', now(), 'xkw:194472'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194472');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微写作', 'XKW-CHN-149801', '1', 1, '2', '0', 'admin', now(), 'xkw:149801'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-149801');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全命题作文', 'XKW-CHN-157952', '2', 2, '2', '0', 'admin', now(), 'xkw:157952'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157952');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '半命题作文', 'XKW-CHN-157953', '2', 3, '2', '0', 'admin', now(), 'xkw:157953'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157953');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '话题作文', 'XKW-CHN-157954', '2', 4, '2', '0', 'admin', now(), 'xkw:157954'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157954');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '材料作文', 'XKW-CHN-157955', '1', 5, '2', '0', 'admin', now(), 'xkw:157955'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157955');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '任务驱动型作文', 'XKW-CHN-157959', '2', 6, '2', '0', 'admin', now(), 'xkw:157959'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157959');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '青年成长', 'XKW-CHN-27890', '1', 1, '2', '0', 'admin', now(), 'xkw:27890'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27890');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人与自然', 'XKW-CHN-27892', '1', 2, '2', '0', 'admin', now(), 'xkw:27892'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27892');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人文科技', 'XKW-CHN-27893', '1', 3, '2', '0', 'admin', now(), 'xkw:27893'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27893');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '普世价值', 'XKW-CHN-182248', '1', 4, '2', '0', 'admin', now(), 'xkw:182248'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182248');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '法治意识', 'XKW-CHN-192932', '1', 5, '2', '0', 'admin', now(), 'xkw:192932'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192932');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化·交流', 'XKW-CHN-182256', '1', 6, '2', '0', 'admin', now(), 'xkw:182256'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182256');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '哲理·思辨', 'XKW-CHN-182266', '1', 7, '2', '0', 'admin', now(), 'xkw:182266'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182266');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '品德修养', 'XKW-CHN-182275', '1', 8, '2', '0', 'admin', now(), 'xkw:182275'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182275');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '读书·学习', 'XKW-CHN-182284', '1', 9, '2', '0', 'admin', now(), 'xkw:182284'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182284');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生命关怀', 'XKW-CHN-182290', '1', 10, '2', '0', 'admin', now(), 'xkw:182290'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182290');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家国情怀', 'XKW-CHN-182294', '1', 11, '2', '0', 'admin', now(), 'xkw:182294'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182294');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '放眼世界', 'XKW-CHN-182301', '1', 12, '2', '0', 'admin', now(), 'xkw:182301'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182301');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情感世界', 'XKW-CHN-182305', '1', 13, '2', '0', 'admin', now(), 'xkw:182305'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182305');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '社会热点', 'XKW-CHN-182310', '1', 14, '2', '0', 'admin', now(), 'xkw:182310'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182310');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国精神', 'XKW-CHN-192942', '1', 15, '2', '0', 'admin', now(), 'xkw:192942'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192942');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '教育理念', 'XKW-CHN-192956', '1', 16, '2', '0', 'admin', now(), 'xkw:192956'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-181847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192956');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国古代文学', 'XKW-CHN-7898', '1', 1, '2', '0', 'admin', now(), 'xkw:7898'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7898');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国现当代文学', 'XKW-CHN-8252', '1', 2, '2', '0', 'admin', now(), 'xkw:8252'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8252');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '外国文学', 'XKW-CHN-8505', '1', 3, '2', '0', 'admin', now(), 'xkw:8505'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8505');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词性', 'XKW-CHN-184937', '2', 1, '2', '0', 'admin', now(), 'xkw:184937'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184937');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词语的色彩', 'XKW-CHN-195246', '2', 2, '2', '0', 'admin', now(), 'xkw:195246'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195246');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词义', 'XKW-CHN-185171', '2', 3, '2', '0', 'admin', now(), 'xkw:185171'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185171');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般词语', 'XKW-CHN-23188', '2', 4, '2', '0', 'admin', now(), 'xkw:23188'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23188');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关联词语', 'XKW-CHN-23191', '2', 5, '2', '0', 'admin', now(), 'xkw:23191'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-23191');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '熟语（含成语）', 'XKW-CHN-182894', '2', 6, '2', '0', 'admin', now(), 'xkw:182894'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182894');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词的语境义', 'XKW-CHN-194351', '2', 7, '2', '0', 'admin', now(), 'xkw:194351'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194351');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '句式的运用和分析', 'XKW-CHN-195247', '1', 1, '2', '0', 'admin', now(), 'xkw:195247'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195247');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单句复句', 'XKW-CHN-26117', '2', 2, '2', '0', 'admin', now(), 'xkw:26117'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26117');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '辨析并修改病句', 'XKW-CHN-26125', '1', 3, '2', '0', 'admin', now(), 'xkw:26125'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26125');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '修辞手法', 'XKW-CHN-26120', '2', 1, '2', '0', 'admin', now(), 'xkw:26120'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26120');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '准确、鲜明、生动', 'XKW-CHN-26184', '1', 2, '2', '0', 'admin', now(), 'xkw:26184'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26184');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '简明、连贯', 'XKW-CHN-26183', '1', 3, '2', '0', 'admin', now(), 'xkw:26183'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26183');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '得体', 'XKW-CHN-157831', '1', 4, '2', '0', 'admin', now(), 'xkw:157831'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157831');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '压缩语段', 'XKW-CHN-26214', '1', 5, '2', '0', 'admin', now(), 'xkw:26214'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26214');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '扩展语句', 'XKW-CHN-26213', '1', 6, '2', '0', 'admin', now(), 'xkw:26213'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26213');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '图文转换', 'XKW-CHN-26177', '1', 7, '2', '0', 'admin', now(), 'xkw:26177'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26177');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言应用场景', 'XKW-CHN-26178', '1', 8, '2', '0', 'admin', now(), 'xkw:26178'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26178');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '标点符号', 'XKW-CHN-26126', '2', 9, '2', '0', 'admin', now(), 'xkw:26126'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26126');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语句（语段）表达效果', 'XKW-CHN-181506', '2', 10, '2', '0', 'admin', now(), 'xkw:181506'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-23185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181506');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体裁', 'XKW-CHN-157917', '1', 1, '2', '0', 'admin', now(), 'xkw:157917'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27870'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157917');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '小说 散文', 'XKW-CHN-157924', '1', 2, '2', '0', 'admin', now(), 'xkw:157924'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27870'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157924');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现代诗歌', 'XKW-CHN-27853', '1', 3, '2', '0', 'admin', now(), 'xkw:27853'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27870'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27853');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '戏剧', 'XKW-CHN-195832', '1', 4, '2', '0', 'admin', now(), 'xkw:195832'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27870'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195832');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实用类文本常见类型', 'XKW-CHN-157937', '1', 1, '2', '0', 'admin', now(), 'xkw:157937'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27871'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157937');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实用类文本常设考点', 'XKW-CHN-157939', '1', 2, '2', '0', 'admin', now(), 'xkw:157939'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27871'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157939');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '论述类文本常见类型', 'XKW-CHN-157908', '1', 1, '2', '0', 'admin', now(), 'xkw:157908'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27869'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157908');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '论述类文本常设考点', 'XKW-CHN-157909', '1', 2, '2', '0', 'admin', now(), 'xkw:157909'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27869'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157909');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要词语', 'XKW-CHN-180643', '2', 1, '2', '0', 'admin', now(), 'xkw:180643'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180643');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要概念', 'XKW-CHN-180642', '2', 2, '2', '0', 'admin', now(), 'xkw:180642'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180642');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要句子', 'XKW-CHN-180644', '2', 3, '2', '0', 'admin', now(), 'xkw:180644'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180644');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '筛选整合信息，归纳概括要点', 'XKW-CHN-180645', '2', 4, '2', '0', 'admin', now(), 'xkw:180645'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180645');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '根据材料进行判断、推理', 'XKW-CHN-193058', '2', 5, '2', '0', 'admin', now(), 'xkw:193058'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-193058');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析、运用文中信息', 'XKW-CHN-180647', '2', 6, '2', '0', 'admin', now(), 'xkw:180647'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180647');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析文章结构和思路', 'XKW-CHN-180651', '2', 7, '2', '0', 'admin', now(), 'xkw:180651'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180651');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析论点、论据、论证方法', 'XKW-CHN-180649', '2', 8, '2', '0', 'admin', now(), 'xkw:180649'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180649');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析语言特色', 'XKW-CHN-180652', '2', 9, '2', '0', 'admin', now(), 'xkw:180652'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180652');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '概括分析、比较材料', 'XKW-CHN-180646', '2', 10, '2', '0', 'admin', now(), 'xkw:180646'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180646');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析概括作者的观点态度', 'XKW-CHN-180650', '2', 11, '2', '0', 'admin', now(), 'xkw:180650'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180650');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价主要观点和基本倾向', 'XKW-CHN-180654', '2', 12, '2', '0', 'admin', now(), 'xkw:180654'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180654');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价社会价值和影响', 'XKW-CHN-180655', '2', 13, '2', '0', 'admin', now(), 'xkw:180655'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180655');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析文本特色', 'XKW-CHN-180656', '2', 14, '2', '0', 'admin', now(), 'xkw:180656'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180656');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发掘人文价值和时代精神', 'XKW-CHN-180657', '2', 15, '2', '0', 'admin', now(), 'xkw:180657'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180657');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究问题，提出见解', 'XKW-CHN-180659', '2', 16, '2', '0', 'admin', now(), 'xkw:180659'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180659');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解并分析图表', 'XKW-CHN-182525', '2', 17, '2', '0', 'admin', now(), 'xkw:182525'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182525');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《红楼梦》', 'XKW-CHN-194431', '1', 1, '2', '0', 'admin', now(), 'xkw:194431'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27855'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194431');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《乡土中国》', 'XKW-CHN-194453', '1', 2, '2', '0', 'admin', now(), 'xkw:194453'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27855'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194453');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体裁', 'XKW-CHN-157848', '1', 1, '2', '0', 'admin', now(), 'xkw:157848'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27850'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157848');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古代文化常识', 'XKW-CHN-27510', '1', 2, '2', '0', 'admin', now(), 'xkw:27510'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27850'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27510');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文言基础知识', 'XKW-CHN-27511', '1', 3, '2', '0', 'admin', now(), 'xkw:27511'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27850'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27511');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '常见考点', 'XKW-CHN-157849', '1', 4, '2', '0', 'admin', now(), 'xkw:157849'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27850'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157849');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体裁', 'XKW-CHN-157854', '1', 1, '2', '0', 'admin', now(), 'xkw:157854'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27851'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157854');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诗词曲常见题材', 'XKW-CHN-157857', '1', 2, '2', '0', 'admin', now(), 'xkw:157857'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27851'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157857');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诗词曲常见考点', 'XKW-CHN-157865', '1', 3, '2', '0', 'admin', now(), 'xkw:157865'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27851'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157865');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '说明类', 'XKW-CHN-185245', '1', 1, '2', '0', 'admin', now(), 'xkw:185245'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-149801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185245');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '议论类', 'XKW-CHN-185247', '1', 2, '2', '0', 'admin', now(), 'xkw:185247'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-149801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185247');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '描写类', 'XKW-CHN-185248', '1', 3, '2', '0', 'admin', now(), 'xkw:185248'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-149801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185248');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '记叙类', 'XKW-CHN-185249', '2', 4, '2', '0', 'admin', now(), 'xkw:185249'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-149801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185249');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抒情类', 'XKW-CHN-185250', '1', 5, '2', '0', 'admin', now(), 'xkw:185250'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-149801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185250');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实用类', 'XKW-CHN-185251', '1', 6, '2', '0', 'admin', now(), 'xkw:185251'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-149801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185251');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '图画式材料', 'XKW-CHN-157956', '2', 1, '2', '0', 'admin', now(), 'xkw:157956'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157956');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '引语式材料', 'XKW-CHN-157957', '2', 2, '2', '0', 'admin', now(), 'xkw:157957'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157957');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '记叙性材料', 'XKW-CHN-157958', '2', 3, '2', '0', 'admin', now(), 'xkw:157958'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157958');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '青春 使命', 'XKW-CHN-27896', '2', 1, '2', '0', 'admin', now(), 'xkw:27896'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27896');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '责任 担当', 'XKW-CHN-27897', '2', 2, '2', '0', 'admin', now(), 'xkw:27897'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27897');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '奋斗 励志', 'XKW-CHN-27898', '2', 3, '2', '0', 'admin', now(), 'xkw:27898'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27898');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探索 创造', 'XKW-CHN-182236', '2', 4, '2', '0', 'admin', now(), 'xkw:182236'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182236');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '梦想 追求', 'XKW-CHN-182237', '2', 5, '2', '0', 'admin', now(), 'xkw:182237'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182237');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '职业规划', 'XKW-CHN-182238', '2', 6, '2', '0', 'admin', now(), 'xkw:182238'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182238');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '逆境 自我', 'XKW-CHN-182239', '2', 7, '2', '0', 'admin', now(), 'xkw:182239'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182239');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '审美情趣', 'XKW-CHN-182240', '2', 8, '2', '0', 'admin', now(), 'xkw:182240'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182240');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理性追星', 'XKW-CHN-182241', '2', 9, '2', '0', 'admin', now(), 'xkw:182241'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182241');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自我定位', 'XKW-CHN-182242', '2', 10, '2', '0', 'admin', now(), 'xkw:182242'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182242');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '媒介素养', 'XKW-CHN-182243', '2', 11, '2', '0', 'admin', now(), 'xkw:182243'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182243');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '为人处世', 'XKW-CHN-27904', '2', 12, '2', '0', 'admin', now(), 'xkw:27904'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27904');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人 他人', 'XKW-CHN-182278', '2', 13, '2', '0', 'admin', now(), 'xkw:182278'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182278');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '环境保护', 'XKW-CHN-27906', '2', 1, '2', '0', 'admin', now(), 'xkw:27906'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27906');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '师法自然', 'XKW-CHN-27907', '2', 2, '2', '0', 'admin', now(), 'xkw:27907'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27907');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '敬畏自然', 'XKW-CHN-27908', '2', 3, '2', '0', 'admin', now(), 'xkw:27908'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27908');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '绿色科技', 'XKW-CHN-27909', '2', 4, '2', '0', 'admin', now(), 'xkw:27909'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27909');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天人合一', 'XKW-CHN-27910', '2', 5, '2', '0', 'admin', now(), 'xkw:27910'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27910');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人与动物', 'XKW-CHN-182244', '2', 6, '2', '0', 'admin', now(), 'xkw:182244'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182244');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '创新 发展', 'XKW-CHN-27912', '2', 1, '2', '0', 'admin', now(), 'xkw:27912'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27912');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同生共荣', 'XKW-CHN-27913', '2', 2, '2', '0', 'admin', now(), 'xkw:27913'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27913');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人工智能', 'XKW-CHN-182245', '2', 3, '2', '0', 'admin', now(), 'xkw:182245'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182245');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '竞争 合作', 'XKW-CHN-182249', '2', 1, '2', '0', 'admin', now(), 'xkw:182249'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182248'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182249');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平等 互利', 'XKW-CHN-182251', '2', 2, '2', '0', 'admin', now(), 'xkw:182251'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182248'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182251');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自利 利他', 'XKW-CHN-182253', '2', 3, '2', '0', 'admin', now(), 'xkw:182253'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182248'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182253');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '和平 发展', 'XKW-CHN-182255', '2', 4, '2', '0', 'admin', now(), 'xkw:182255'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182248'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182255');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '公平 正义', 'XKW-CHN-182250', '2', 1, '2', '0', 'admin', now(), 'xkw:182250'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192932'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182250');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '权利 义务', 'XKW-CHN-182252', '2', 2, '2', '0', 'admin', now(), 'xkw:182252'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192932'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182252');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '法律 人情', 'XKW-CHN-27903', '2', 3, '2', '0', 'admin', now(), 'xkw:27903'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192932'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27903');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '规则 秩序', 'XKW-CHN-182254', '2', 4, '2', '0', 'admin', now(), 'xkw:182254'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192932'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182254');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传统美德', 'XKW-CHN-27902', '2', 1, '2', '0', 'admin', now(), 'xkw:27902'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27902');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化传承', 'XKW-CHN-182257', '2', 2, '2', '0', 'admin', now(), 'xkw:182257'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182257');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化自信', 'XKW-CHN-182258', '2', 3, '2', '0', 'admin', now(), 'xkw:182258'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182258');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化坚守', 'XKW-CHN-182259', '2', 4, '2', '0', 'admin', now(), 'xkw:182259'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182259');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '开放与包容', 'XKW-CHN-182260', '2', 5, '2', '0', 'admin', now(), 'xkw:182260'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182260');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中华礼仪', 'XKW-CHN-182261', '2', 6, '2', '0', 'admin', now(), 'xkw:182261'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182261');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传统节日', 'XKW-CHN-182262', '2', 7, '2', '0', 'admin', now(), 'xkw:182262'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182262');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诗歌素养', 'XKW-CHN-182263', '2', 8, '2', '0', 'admin', now(), 'xkw:182263'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182263');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家风家书', 'XKW-CHN-182264', '2', 9, '2', '0', 'admin', now(), 'xkw:182264'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182264');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '致敬先贤', 'XKW-CHN-182265', '2', 10, '2', '0', 'admin', now(), 'xkw:182265'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182265');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化积淀', 'XKW-CHN-27917', '2', 11, '2', '0', 'admin', now(), 'xkw:27917'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27917');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化创新', 'XKW-CHN-27918', '2', 12, '2', '0', 'admin', now(), 'xkw:27918'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27918');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化传播', 'XKW-CHN-182910', '2', 13, '2', '0', 'admin', now(), 'xkw:182910'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182910');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传承与创新', 'XKW-CHN-27894', '2', 1, '2', '0', 'admin', now(), 'xkw:27894'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27894');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生活体验', 'XKW-CHN-27920', '2', 2, '2', '0', 'admin', now(), 'xkw:27920'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27920');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人生感悟', 'XKW-CHN-27921', '2', 3, '2', '0', 'admin', now(), 'xkw:27921'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27921');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '价值理念', 'XKW-CHN-27922', '2', 4, '2', '0', 'admin', now(), 'xkw:27922'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27922');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '道德境界', 'XKW-CHN-27923', '2', 5, '2', '0', 'admin', now(), 'xkw:27923'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27923');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理性思辨', 'XKW-CHN-182267', '2', 6, '2', '0', 'admin', now(), 'xkw:182267'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182267');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '批判精神', 'XKW-CHN-182268', '2', 7, '2', '0', 'admin', now(), 'xkw:182268'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182268');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '成功面面观', 'XKW-CHN-182269', '2', 8, '2', '0', 'admin', now(), 'xkw:182269'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182269');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科技伦理', 'XKW-CHN-182270', '2', 9, '2', '0', 'admin', now(), 'xkw:182270'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182270');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '反思 反省', 'XKW-CHN-182271', '2', 10, '2', '0', 'admin', now(), 'xkw:182271'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182271');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人才评价', 'XKW-CHN-182272', '2', 11, '2', '0', 'admin', now(), 'xkw:182272'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182272');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '网络利弊', 'XKW-CHN-182273', '2', 12, '2', '0', 'admin', now(), 'xkw:182273'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182273');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '德·才·学·识·名', 'XKW-CHN-182274', '2', 13, '2', '0', 'admin', now(), 'xkw:182274'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182266'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182274');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '社会公德', 'XKW-CHN-192933', '2', 1, '2', '0', 'admin', now(), 'xkw:192933'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192933');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '职业道德', 'XKW-CHN-192934', '2', 2, '2', '0', 'admin', now(), 'xkw:192934'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192934');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家庭美德', 'XKW-CHN-192935', '2', 3, '2', '0', 'admin', now(), 'xkw:192935'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192935');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人品德', 'XKW-CHN-192936', '1', 4, '2', '0', 'admin', now(), 'xkw:192936'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192936');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '终身学习', 'XKW-CHN-182285', '2', 1, '2', '0', 'admin', now(), 'xkw:182285'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182284'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182285');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '乐学 善学', 'XKW-CHN-182286', '2', 2, '2', '0', 'admin', now(), 'xkw:182286'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182284'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182286');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '知识·命运', 'XKW-CHN-182287', '2', 3, '2', '0', 'admin', now(), 'xkw:182287'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182284'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182287');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '志向 信念', 'XKW-CHN-182288', '2', 4, '2', '0', 'admin', now(), 'xkw:182288'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182284'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182288');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '知与行', 'XKW-CHN-182289', '2', 5, '2', '0', 'admin', now(), 'xkw:182289'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182284'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182289');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生命礼赞', 'XKW-CHN-182291', '2', 1, '2', '0', 'admin', now(), 'xkw:182291'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182290'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182291');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '价值意义', 'XKW-CHN-182292', '2', 2, '2', '0', 'admin', now(), 'xkw:182292'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182290'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182292');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '强身健体', 'XKW-CHN-182293', '2', 3, '2', '0', 'admin', now(), 'xkw:182293'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182290'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182293');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '民族复兴', 'XKW-CHN-192940', '2', 1, '2', '0', 'admin', now(), 'xkw:192940'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192940');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '国家情愫', 'XKW-CHN-182295', '2', 2, '2', '0', 'admin', now(), 'xkw:182295'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182295');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时代榜样', 'XKW-CHN-182299', '2', 3, '2', '0', 'admin', now(), 'xkw:182299'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182299');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时代发展', 'XKW-CHN-192941', '2', 4, '2', '0', 'admin', now(), 'xkw:192941'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192941');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家乡风物', 'XKW-CHN-182296', '2', 5, '2', '0', 'admin', now(), 'xkw:182296'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182296');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '乡村建设', 'XKW-CHN-182297', '2', 6, '2', '0', 'admin', now(), 'xkw:182297'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182297');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '乡言俚语', 'XKW-CHN-182298', '2', 7, '2', '0', 'admin', now(), 'xkw:182298'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182298');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '铭记历史', 'XKW-CHN-182300', '2', 8, '2', '0', 'admin', now(), 'xkw:182300'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182300');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '外交风云', 'XKW-CHN-182302', '2', 1, '2', '0', 'admin', now(), 'xkw:182302'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182301'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182302');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '融合·碰撞', 'XKW-CHN-182303', '2', 2, '2', '0', 'admin', now(), 'xkw:182303'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182301'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182303');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国·世界', 'XKW-CHN-182304', '2', 3, '2', '0', 'admin', now(), 'xkw:182304'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182301'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182304');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '亲情', 'XKW-CHN-182306', '2', 1, '2', '0', 'admin', now(), 'xkw:182306'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182305'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182306');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '友情', 'XKW-CHN-182307', '2', 2, '2', '0', 'admin', now(), 'xkw:182307'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182305'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182307');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '大爱', 'XKW-CHN-182308', '2', 3, '2', '0', 'admin', now(), 'xkw:182308'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182305'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182308');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '感恩', 'XKW-CHN-182309', '2', 4, '2', '0', 'admin', now(), 'xkw:182309'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182305'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182309');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '新冠疫情', 'XKW-CHN-182311', '2', 1, '2', '0', 'admin', now(), 'xkw:182311'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182311');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冬奥话题', 'XKW-CHN-182312', '2', 2, '2', '0', 'admin', now(), 'xkw:182312'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182312');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自媒体', 'XKW-CHN-182313', '2', 3, '2', '0', 'admin', now(), 'xkw:182313'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182313');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '正能量', 'XKW-CHN-182314', '2', 4, '2', '0', 'admin', now(), 'xkw:182314'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182314');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '数字化', 'XKW-CHN-182315', '2', 5, '2', '0', 'admin', now(), 'xkw:182315'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182315');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '小议舒适区', 'XKW-CHN-182317', '2', 6, '2', '0', 'admin', now(), 'xkw:182317'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182317');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '躺平·内卷', 'XKW-CHN-182318', '2', 7, '2', '0', 'admin', now(), 'xkw:182318'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182318');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '小康·扶贫', 'XKW-CHN-182319', '2', 8, '2', '0', 'admin', now(), 'xkw:182319'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182319');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '学历·成才', 'XKW-CHN-182320', '2', 9, '2', '0', 'admin', now(), 'xkw:182320'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182320');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '凡人微光', 'XKW-CHN-182321', '2', 10, '2', '0', 'admin', now(), 'xkw:182321'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182321');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '网红·直播', 'XKW-CHN-182322', '2', 11, '2', '0', 'admin', now(), 'xkw:182322'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182322');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '饭圈乱象', 'XKW-CHN-185348', '2', 12, '2', '0', 'admin', now(), 'xkw:185348'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185348');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“双减”话题', 'XKW-CHN-185469', '2', 13, '2', '0', 'admin', now(), 'xkw:185469'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-182310'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185469');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科学精神', 'XKW-CHN-182246', '2', 1, '2', '0', 'admin', now(), 'xkw:182246'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182246');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '长征精神', 'XKW-CHN-192943', '2', 2, '2', '0', 'admin', now(), 'xkw:192943'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192943');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '五四精神', 'XKW-CHN-192944', '2', 3, '2', '0', 'admin', now(), 'xkw:192944'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192944');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抗战精神', 'XKW-CHN-192945', '2', 4, '2', '0', 'admin', now(), 'xkw:192945'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192945');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抗美援朝精神', 'XKW-CHN-192946', '2', 5, '2', '0', 'admin', now(), 'xkw:192946'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192946');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '脱贫攻坚精神', 'XKW-CHN-192947', '2', 6, '2', '0', 'admin', now(), 'xkw:192947'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192947');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抗震救灾精神', 'XKW-CHN-192948', '2', 7, '2', '0', 'admin', now(), 'xkw:192948'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192948');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抗疫精神', 'XKW-CHN-192949', '2', 8, '2', '0', 'admin', now(), 'xkw:192949'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192949');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '奥运精神', 'XKW-CHN-192950', '2', 9, '2', '0', 'admin', now(), 'xkw:192950'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192950');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '航天精神', 'XKW-CHN-192951', '2', 10, '2', '0', 'admin', now(), 'xkw:192951'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192951');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '工匠精神', 'XKW-CHN-192952', '2', 11, '2', '0', 'admin', now(), 'xkw:192952'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192952');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“三牛”精神', 'XKW-CHN-192953', '2', 12, '2', '0', 'admin', now(), 'xkw:192953'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192953');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '丝路精神', 'XKW-CHN-192954', '2', 13, '2', '0', 'admin', now(), 'xkw:192954'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192954');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '爱国精神', 'XKW-CHN-192955', '2', 14, '2', '0', 'admin', now(), 'xkw:192955'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192955');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '因材施教', 'XKW-CHN-27914', '2', 1, '2', '0', 'admin', now(), 'xkw:27914'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192956'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27914');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '春秋', 'XKW-CHN-7899', '1', 1, '2', '0', 'admin', now(), 'xkw:7899'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7899');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '战国', 'XKW-CHN-7915', '1', 2, '2', '0', 'admin', now(), 'xkw:7915'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7915');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '秦朝', 'XKW-CHN-7932', '1', 3, '2', '0', 'admin', now(), 'xkw:7932'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7932');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '西汉', 'XKW-CHN-7934', '1', 4, '2', '0', 'admin', now(), 'xkw:7934'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7934');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '东汉', 'XKW-CHN-7943', '1', 5, '2', '0', 'admin', now(), 'xkw:7943'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7943');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '三国', 'XKW-CHN-7947', '1', 6, '2', '0', 'admin', now(), 'xkw:7947'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7947');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '西晋', 'XKW-CHN-7959', '1', 7, '2', '0', 'admin', now(), 'xkw:7959'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7959');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '东晋', 'XKW-CHN-7966', '1', 8, '2', '0', 'admin', now(), 'xkw:7966'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7966');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '南北朝', 'XKW-CHN-7979', '1', 9, '2', '0', 'admin', now(), 'xkw:7979'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7979');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '隋唐', 'XKW-CHN-7997', '1', 10, '2', '0', 'admin', now(), 'xkw:7997'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7997');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '五代十国', 'XKW-CHN-8077', '1', 11, '2', '0', 'admin', now(), 'xkw:8077'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8077');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '北宋', 'XKW-CHN-8092', '1', 12, '2', '0', 'admin', now(), 'xkw:8092'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8092');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '南宋', 'XKW-CHN-8140', '1', 13, '2', '0', 'admin', now(), 'xkw:8140'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8140');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '元', 'XKW-CHN-8162', '1', 14, '2', '0', 'admin', now(), 'xkw:8162'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8162');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '明', 'XKW-CHN-8181', '1', 15, '2', '0', 'admin', now(), 'xkw:8181'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8181');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他明代作家', 'XKW-CHN-8207', '2', 16, '2', '0', 'admin', now(), 'xkw:8207'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8207');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '清', 'XKW-CHN-8208', '1', 17, '2', '0', 'admin', now(), 'xkw:8208'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8208');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他古代作家', 'XKW-CHN-8242', '2', 18, '2', '0', 'admin', now(), 'xkw:8242'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8242');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '近代', 'XKW-CHN-8243', '1', 19, '2', '0', 'admin', now(), 'xkw:8243'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8243');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现代', 'XKW-CHN-8253', '1', 1, '2', '0', 'admin', now(), 'xkw:8253'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8252'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8253');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '当代', 'XKW-CHN-8408', '1', 2, '2', '0', 'admin', now(), 'xkw:8408'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8252'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8408');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他中国现当代作家', 'XKW-CHN-8504', '2', 3, '2', '0', 'admin', now(), 'xkw:8504'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8252'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8504');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '爱尔兰', 'XKW-CHN-8506', '1', 1, '2', '0', 'admin', now(), 'xkw:8506'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8506');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '奥地利', 'XKW-CHN-8508', '1', 2, '2', '0', 'admin', now(), 'xkw:8508'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8508');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '澳大利亚', 'XKW-CHN-8513', '1', 3, '2', '0', 'admin', now(), 'xkw:8513'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8513');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波兰', 'XKW-CHN-8515', '1', 4, '2', '0', 'admin', now(), 'xkw:8515'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8515');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '丹麦', 'XKW-CHN-8517', '1', 5, '2', '0', 'admin', now(), 'xkw:8517'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8517');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '德国', 'XKW-CHN-8519', '1', 6, '2', '0', 'admin', now(), 'xkw:8519'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8519');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '俄罗斯', 'XKW-CHN-8525', '1', 7, '2', '0', 'admin', now(), 'xkw:8525'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8525');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '法国', 'XKW-CHN-8537', '1', 8, '2', '0', 'admin', now(), 'xkw:8537'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8537');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '哥伦比亚', 'XKW-CHN-8559', '1', 9, '2', '0', 'admin', now(), 'xkw:8559'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8559');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古希腊', 'XKW-CHN-8562', '1', 10, '2', '0', 'admin', now(), 'xkw:8562'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8562');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '加拿大', 'XKW-CHN-8569', '2', 11, '2', '0', 'admin', now(), 'xkw:8569'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8569');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '捷克', 'XKW-CHN-8570', '1', 12, '2', '0', 'admin', now(), 'xkw:8570'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8570');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '美国', 'XKW-CHN-8572', '1', 13, '2', '0', 'admin', now(), 'xkw:8572'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8572');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '挪威', 'XKW-CHN-8597', '1', 14, '2', '0', 'admin', now(), 'xkw:8597'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8597');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '日本', 'XKW-CHN-8600', '1', 15, '2', '0', 'admin', now(), 'xkw:8600'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8600');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '苏格兰', 'XKW-CHN-8606', '1', 16, '2', '0', 'admin', now(), 'xkw:8606'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8606');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '苏联', 'XKW-CHN-8609', '1', 17, '2', '0', 'admin', now(), 'xkw:8609'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8609');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '西班牙', 'XKW-CHN-8616', '1', 18, '2', '0', 'admin', now(), 'xkw:8616'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8616');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匈牙利', 'XKW-CHN-8619', '1', 19, '2', '0', 'admin', now(), 'xkw:8619'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8619');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '意大利', 'XKW-CHN-8621', '1', 20, '2', '0', 'admin', now(), 'xkw:8621'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8621');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '印度', 'XKW-CHN-8625', '1', 21, '2', '0', 'admin', now(), 'xkw:8625'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8625');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '英国', 'XKW-CHN-8629', '1', 22, '2', '0', 'admin', now(), 'xkw:8629'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8629');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '墨西哥', 'XKW-CHN-8654', '1', 23, '2', '0', 'admin', now(), 'xkw:8654'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8654');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '黎巴嫩', 'XKW-CHN-8656', '1', 24, '2', '0', 'admin', now(), 'xkw:8656'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8656');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '巴西', 'XKW-CHN-8658', '2', 25, '2', '0', 'admin', now(), 'xkw:8658'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8658');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '瑞典', 'XKW-CHN-8659', '1', 26, '2', '0', 'admin', now(), 'xkw:8659'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8659');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '阿根廷', 'XKW-CHN-8661', '1', 27, '2', '0', 'admin', now(), 'xkw:8661'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8661');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '智利', 'XKW-CHN-8663', '1', 28, '2', '0', 'admin', now(), 'xkw:8663'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8663');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他外国作家', 'XKW-CHN-8665', '2', 29, '2', '0', 'admin', now(), 'xkw:8665'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8505'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8665');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变换句式', 'XKW-CHN-26122', '2', 1, '2', '0', 'admin', now(), 'xkw:26122'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26122');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '句式仿写', 'XKW-CHN-26123', '2', 2, '2', '0', 'admin', now(), 'xkw:26123'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26123');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '句式表达效果', 'XKW-CHN-195248', '2', 3, '2', '0', 'admin', now(), 'xkw:195248'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195248');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '句式运用', 'XKW-CHN-195249', '2', 4, '2', '0', 'admin', now(), 'xkw:195249'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195249');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '选用句式', 'XKW-CHN-26121', '2', 5, '2', '0', 'admin', now(), 'xkw:26121'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26121');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语序不当', 'XKW-CHN-26157', '2', 1, '2', '0', 'admin', now(), 'xkw:26157'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26125'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26157');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '搭配不当', 'XKW-CHN-26158', '2', 2, '2', '0', 'admin', now(), 'xkw:26158'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26125'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26158');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '成分残缺或赘余', 'XKW-CHN-26160', '2', 3, '2', '0', 'admin', now(), 'xkw:26160'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26125'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26160');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表意不明', 'XKW-CHN-26161', '2', 4, '2', '0', 'admin', now(), 'xkw:26161'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26125'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26161');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不合逻辑', 'XKW-CHN-26162', '2', 5, '2', '0', 'admin', now(), 'xkw:26162'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26125'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26162');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '结构混乱', 'XKW-CHN-181977', '2', 6, '2', '0', 'admin', now(), 'xkw:181977'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26125'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181977');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '描绘场景', 'XKW-CHN-180578', '2', 1, '2', '0', 'admin', now(), 'xkw:180578'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180578');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '逻辑问题', 'XKW-CHN-100543', '2', 2, '2', '0', 'admin', now(), 'xkw:100543'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-100543');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表达准确', 'XKW-CHN-181584', '2', 3, '2', '0', 'admin', now(), 'xkw:181584'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181584');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探讨问题，分析原因', 'XKW-CHN-181687', '2', 4, '2', '0', 'admin', now(), 'xkw:181687'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181687');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '谈观点，写评论', 'XKW-CHN-180579', '2', 5, '2', '0', 'admin', now(), 'xkw:180579'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180579');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人评价', 'XKW-CHN-184885', '2', 6, '2', '0', 'admin', now(), 'xkw:184885'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184885');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '补充论据', 'XKW-CHN-185810', '2', 7, '2', '0', 'admin', now(), 'xkw:185810'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185810');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '简明', 'XKW-CHN-157826', '2', 1, '2', '0', 'admin', now(), 'xkw:157826'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157826');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '连贯', 'XKW-CHN-157827', '2', 2, '2', '0', 'admin', now(), 'xkw:157827'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157827');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情境补写', 'XKW-CHN-26180', '2', 3, '2', '0', 'admin', now(), 'xkw:26180'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26180');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语句复位', 'XKW-CHN-157829', '2', 4, '2', '0', 'admin', now(), 'xkw:157829'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157829');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '衔接与排序', 'XKW-CHN-157828', '2', 5, '2', '0', 'admin', now(), 'xkw:157828'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157828');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '谦敬误用', 'XKW-CHN-157832', '2', 1, '2', '0', 'admin', now(), 'xkw:157832'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157831'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157832');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '特定场合用语', 'XKW-CHN-157833', '2', 2, '2', '0', 'admin', now(), 'xkw:157833'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157831'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157833');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '书面语和口头语', 'XKW-CHN-157834', '2', 3, '2', '0', 'admin', now(), 'xkw:157834'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157831'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157834');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '日常交际用语', 'XKW-CHN-180580', '2', 4, '2', '0', 'admin', now(), 'xkw:180580'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157831'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180580');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '下定义', 'XKW-CHN-157838', '2', 1, '2', '0', 'admin', now(), 'xkw:157838'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157838');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '提取关键词', 'XKW-CHN-157839', '2', 2, '2', '0', 'admin', now(), 'xkw:157839'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157839');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '概括要点', 'XKW-CHN-157840', '2', 3, '2', '0', 'admin', now(), 'xkw:157840'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157840');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '拟写新闻标题、一句话新闻', 'XKW-CHN-157841', '2', 4, '2', '0', 'admin', now(), 'xkw:157841'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157841');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '拟写新闻导语', 'XKW-CHN-181585', '2', 5, '2', '0', 'admin', now(), 'xkw:181585'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181585');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '句子扩展', 'XKW-CHN-157835', '2', 1, '2', '0', 'admin', now(), 'xkw:157835'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157835');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情景扩展', 'XKW-CHN-157836', '2', 2, '2', '0', 'admin', now(), 'xkw:157836'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157836');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '话题扩展', 'XKW-CHN-157837', '2', 3, '2', '0', 'admin', now(), 'xkw:157837'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157837');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '漫画/照片', 'XKW-CHN-26185', '2', 1, '2', '0', 'admin', now(), 'xkw:26185'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26185');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '徽标', 'XKW-CHN-26186', '2', 2, '2', '0', 'admin', now(), 'xkw:26186'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26186');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表格/图表', 'XKW-CHN-26187', '2', 3, '2', '0', 'admin', now(), 'xkw:26187'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26187');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '思维导图', 'XKW-CHN-26188', '2', 4, '2', '0', 'admin', now(), 'xkw:26188'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26188');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '流程图/结构图', 'XKW-CHN-26189', '2', 5, '2', '0', 'admin', now(), 'xkw:26189'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26189');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '地理方位图', 'XKW-CHN-184873', '2', 6, '2', '0', 'admin', now(), 'xkw:184873'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184873');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '应用句段', 'XKW-CHN-26190', '1', 1, '2', '0', 'admin', now(), 'xkw:26190'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26190');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '应用文章', 'XKW-CHN-26192', '1', 2, '2', '0', 'admin', now(), 'xkw:26192'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26192');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '记叙性散文', 'XKW-CHN-158888', '2', 1, '2', '0', 'admin', now(), 'xkw:158888'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-158888');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '议论性散文', 'XKW-CHN-158890', '2', 2, '2', '0', 'admin', now(), 'xkw:158890'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-158890');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抒情性散文', 'XKW-CHN-158889', '2', 3, '2', '0', 'admin', now(), 'xkw:158889'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-158889');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他散文', 'XKW-CHN-27878', '2', 4, '2', '0', 'admin', now(), 'xkw:27878'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27878');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古代白话小说', 'XKW-CHN-158635', '2', 5, '2', '0', 'admin', now(), 'xkw:158635'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-158635');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国现当代小说', 'XKW-CHN-158636', '2', 6, '2', '0', 'admin', now(), 'xkw:158636'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-158636');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '外国小说', 'XKW-CHN-158637', '2', 7, '2', '0', 'admin', now(), 'xkw:158637'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-158637');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他小说', 'XKW-CHN-27877', '2', 8, '2', '0', 'admin', now(), 'xkw:27877'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27877');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现代诗歌', 'XKW-CHN-216731', '2', 9, '2', '0', 'admin', now(), 'xkw:216731'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-216731');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '戏剧', 'XKW-CHN-27879', '2', 10, '2', '0', 'admin', now(), 'xkw:27879'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157917'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27879');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要词语', 'XKW-CHN-157925', '2', 1, '2', '0', 'admin', now(), 'xkw:157925'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157925');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要句子', 'XKW-CHN-157926', '2', 2, '2', '0', 'admin', now(), 'xkw:157926'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157926');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析、理解文章内容', 'XKW-CHN-181769', '2', 3, '2', '0', 'admin', now(), 'xkw:181769'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181769');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文章的叙述视角', 'XKW-CHN-182907', '2', 4, '2', '0', 'admin', now(), 'xkw:182907'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182907');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文章的叙述人称', 'XKW-CHN-182908', '2', 5, '2', '0', 'admin', now(), 'xkw:182908'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182908');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文章的表达方式', 'XKW-CHN-188529', '2', 6, '2', '0', 'admin', now(), 'xkw:188529'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-188529');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析结构，概括主题', 'XKW-CHN-157927', '2', 7, '2', '0', 'admin', now(), 'xkw:157927'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157927');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析标题的含义和作用', 'XKW-CHN-157928', '2', 8, '2', '0', 'admin', now(), 'xkw:157928'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157928');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析情节、语段的作用', 'XKW-CHN-157929', '2', 9, '2', '0', 'admin', now(), 'xkw:157929'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157929');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情节概括', 'XKW-CHN-184887', '2', 10, '2', '0', 'admin', now(), 'xkw:184887'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184887');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鉴赏作品中的艺术形象', 'XKW-CHN-157931', '2', 11, '2', '0', 'admin', now(), 'xkw:157931'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157931');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鉴赏人物描写手法', 'XKW-CHN-180641', '2', 12, '2', '0', 'admin', now(), 'xkw:180641'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180641');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析环境描写的作用', 'XKW-CHN-180640', '2', 13, '2', '0', 'admin', now(), 'xkw:180640'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180640');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '品味语言艺术', 'XKW-CHN-157932', '2', 14, '2', '0', 'admin', now(), 'xkw:157932'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157932');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析体裁特征和表现手法', 'XKW-CHN-157933', '2', 15, '2', '0', 'admin', now(), 'xkw:157933'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157933');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探讨创作背景和意图', 'XKW-CHN-157934', '2', 16, '2', '0', 'admin', now(), 'xkw:157934'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157934');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个性化阅读和有创意的解读', 'XKW-CHN-157935', '2', 17, '2', '0', 'admin', now(), 'xkw:157935'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157935');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价作品价值判断和审美取向', 'XKW-CHN-157930', '2', 18, '2', '0', 'admin', now(), 'xkw:157930'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157930');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多角度探究作品意蕴', 'XKW-CHN-157936', '2', 19, '2', '0', 'admin', now(), 'xkw:157936'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157936');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析、探究文本情感', 'XKW-CHN-182909', '2', 20, '2', '0', 'admin', now(), 'xkw:182909'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182909');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析、理解内容', 'XKW-CHN-182519', '2', 1, '2', '0', 'admin', now(), 'xkw:182519'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182519');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '创作意图和背景', 'XKW-CHN-182523', '2', 2, '2', '0', 'admin', now(), 'xkw:182523'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182523');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '把握意象', 'XKW-CHN-157920', '2', 3, '2', '0', 'admin', now(), 'xkw:157920'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157920');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '领会意境', 'XKW-CHN-182522', '2', 4, '2', '0', 'admin', now(), 'xkw:182522'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182522');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析技巧', 'XKW-CHN-157923', '2', 5, '2', '0', 'admin', now(), 'xkw:157923'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157923');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析人物形象', 'XKW-CHN-272854', '2', 6, '2', '0', 'admin', now(), 'xkw:272854'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-272854');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究作品意蕴', 'XKW-CHN-182521', '2', 7, '2', '0', 'admin', now(), 'xkw:182521'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182521');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '领悟主旨', 'XKW-CHN-182520', '2', 8, '2', '0', 'admin', now(), 'xkw:182520'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182520');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '品味语言', 'XKW-CHN-157922', '2', 9, '2', '0', 'admin', now(), 'xkw:157922'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157922');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体会情感', 'XKW-CHN-157921', '2', 10, '2', '0', 'admin', now(), 'xkw:157921'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157921');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '创意解读', 'XKW-CHN-182524', '2', 11, '2', '0', 'admin', now(), 'xkw:182524'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27853'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182524');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要句子', 'XKW-CHN-195833', '2', 1, '2', '0', 'admin', now(), 'xkw:195833'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195833');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解文本内容', 'XKW-CHN-195834', '2', 2, '2', '0', 'admin', now(), 'xkw:195834'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195834');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '背景和创作意图', 'XKW-CHN-195835', '2', 3, '2', '0', 'admin', now(), 'xkw:195835'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195835');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '标题含义', 'XKW-CHN-195836', '2', 4, '2', '0', 'admin', now(), 'xkw:195836'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195836');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '舞台说明', 'XKW-CHN-195837', '2', 5, '2', '0', 'admin', now(), 'xkw:195837'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195837');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情节概括', 'XKW-CHN-195838', '2', 6, '2', '0', 'admin', now(), 'xkw:195838'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195838');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '戏剧语言', 'XKW-CHN-195839', '2', 7, '2', '0', 'admin', now(), 'xkw:195839'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195839');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艺术特色', 'XKW-CHN-195840', '2', 8, '2', '0', 'admin', now(), 'xkw:195840'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195840');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人物形象', 'XKW-CHN-195841', '2', 9, '2', '0', 'admin', now(), 'xkw:195841'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195841');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '戏剧冲突', 'XKW-CHN-194347', '2', 10, '2', '0', 'admin', now(), 'xkw:194347'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194347');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主旨情感', 'XKW-CHN-195842', '2', 11, '2', '0', 'admin', now(), 'xkw:195842'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195842');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究评价', 'XKW-CHN-195843', '2', 12, '2', '0', 'admin', now(), 'xkw:195843'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-195832'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-195843');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '新闻（消息、通讯、报告文学、特写）', 'XKW-CHN-27881', '2', 1, '2', '0', 'admin', now(), 'xkw:27881'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157937'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27881');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传记', 'XKW-CHN-27882', '2', 2, '2', '0', 'admin', now(), 'xkw:27882'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157937'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27882');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '报告', 'XKW-CHN-27883', '2', 3, '2', '0', 'admin', now(), 'xkw:27883'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157937'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27883');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科普-社会科学类', 'XKW-CHN-27887', '2', 4, '2', '0', 'admin', now(), 'xkw:27887'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157937'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27887');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科普-自然科学类', 'XKW-CHN-27886', '2', 5, '2', '0', 'admin', now(), 'xkw:27886'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157937'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27886');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要词语', 'XKW-CHN-180660', '2', 1, '2', '0', 'admin', now(), 'xkw:180660'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180660');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要概念', 'XKW-CHN-157940', '2', 2, '2', '0', 'admin', now(), 'xkw:157940'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157940');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要句子', 'XKW-CHN-157941', '2', 3, '2', '0', 'admin', now(), 'xkw:157941'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157941');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '筛选并整合文中信息', 'XKW-CHN-157942', '2', 4, '2', '0', 'admin', now(), 'xkw:157942'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157942');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析语句的作用', 'XKW-CHN-182527', '2', 5, '2', '0', 'admin', now(), 'xkw:182527'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182527');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析段落作用', 'XKW-CHN-180661', '2', 6, '2', '0', 'admin', now(), 'xkw:180661'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180661');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析、理解文章内容', 'XKW-CHN-182225', '2', 7, '2', '0', 'admin', now(), 'xkw:182225'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182225');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '标题含义及作用', 'XKW-CHN-208011', '2', 8, '2', '0', 'admin', now(), 'xkw:208011'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-208011');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解常见说明方法及作用', 'XKW-CHN-180662', '2', 9, '2', '0', 'admin', now(), 'xkw:180662'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180662');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '说明顺序', 'XKW-CHN-184614', '2', 10, '2', '0', 'admin', now(), 'xkw:184614'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184614');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析语言特色', 'XKW-CHN-180663', '2', 11, '2', '0', 'admin', now(), 'xkw:180663'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180663');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析文体特征和表现手法', 'XKW-CHN-157944', '2', 12, '2', '0', 'admin', now(), 'xkw:157944'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157944');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价主要观点和基本倾向', 'XKW-CHN-157945', '2', 13, '2', '0', 'admin', now(), 'xkw:157945'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157945');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价社会价值和影响', 'XKW-CHN-157946', '2', 14, '2', '0', 'admin', now(), 'xkw:157946'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157946');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '深度思考和判断文本特色', 'XKW-CHN-157947', '2', 15, '2', '0', 'admin', now(), 'xkw:157947'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157947');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多角度发掘人文价值和时代精神', 'XKW-CHN-157948', '2', 16, '2', '0', 'admin', now(), 'xkw:157948'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157948');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探讨写作背景和意图', 'XKW-CHN-157949', '2', 17, '2', '0', 'admin', now(), 'xkw:157949'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157949');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究内容，提出见解', 'XKW-CHN-157950', '2', 18, '2', '0', 'admin', now(), 'xkw:157950'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157950');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析传主形象', 'XKW-CHN-181770', '2', 19, '2', '0', 'admin', now(), 'xkw:181770'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181770');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '归纳分析访谈内容', 'XKW-CHN-182528', '2', 20, '2', '0', 'admin', now(), 'xkw:182528'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182528');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '赏析访谈技巧', 'XKW-CHN-182529', '2', 21, '2', '0', 'admin', now(), 'xkw:182529'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182529');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '概括文章大意', 'XKW-CHN-184616', '2', 22, '2', '0', 'admin', now(), 'xkw:184616'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184616');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '要点梳理', 'XKW-CHN-184617', '2', 23, '2', '0', 'admin', now(), 'xkw:184617'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184617');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '政论文', 'XKW-CHN-27872', '2', 1, '2', '0', 'admin', now(), 'xkw:27872'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27872');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '学术论文', 'XKW-CHN-27873', '2', 2, '2', '0', 'admin', now(), 'xkw:27873'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27873');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时评', 'XKW-CHN-27874', '2', 3, '2', '0', 'admin', now(), 'xkw:27874'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27874');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '书评', 'XKW-CHN-27875', '2', 4, '2', '0', 'admin', now(), 'xkw:27875'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27875');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要词语', 'XKW-CHN-180637', '2', 1, '2', '0', 'admin', now(), 'xkw:180637'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180637');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要概念', 'XKW-CHN-157913', '2', 2, '2', '0', 'admin', now(), 'xkw:157913'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157913');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要句、段的含义和作用', 'XKW-CHN-157914', '2', 3, '2', '0', 'admin', now(), 'xkw:157914'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157914');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解标题含义及作用', 'XKW-CHN-208010', '2', 4, '2', '0', 'admin', now(), 'xkw:208010'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-208010');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '筛选并整合文中信息', 'XKW-CHN-157910', '2', 5, '2', '0', 'admin', now(), 'xkw:157910'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157910');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析文章结构和思路', 'XKW-CHN-157916', '2', 6, '2', '0', 'admin', now(), 'xkw:157916'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157916');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '归纳要点，概括中心', 'XKW-CHN-157915', '2', 7, '2', '0', 'admin', now(), 'xkw:157915'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157915');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析论点、论据、论证方法', 'XKW-CHN-157911', '2', 8, '2', '0', 'admin', now(), 'xkw:157911'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157911');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析概括作者的观点态度', 'XKW-CHN-157912', '2', 9, '2', '0', 'admin', now(), 'xkw:157912'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157912');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '根据文本内容进行判断、推理', 'XKW-CHN-181209', '2', 10, '2', '0', 'admin', now(), 'xkw:181209'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181209');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '识记常识', 'XKW-CHN-194432', '2', 1, '2', '0', 'admin', now(), 'xkw:194432'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194432');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要词语', 'XKW-CHN-194433', '2', 2, '2', '0', 'admin', now(), 'xkw:194433'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194433');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要句子', 'XKW-CHN-194434', '2', 3, '2', '0', 'admin', now(), 'xkw:194434'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194434');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '整体把握内容、主旨或观点', 'XKW-CHN-194435', '2', 4, '2', '0', 'admin', now(), 'xkw:194435'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194435');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '把握相关情节、内容', 'XKW-CHN-194438', '2', 5, '2', '0', 'admin', now(), 'xkw:194438'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194438');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析情节、语段的作用', 'XKW-CHN-194437', '2', 6, '2', '0', 'admin', now(), 'xkw:194437'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194437');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鉴赏艺术特色、表现手法', 'XKW-CHN-194436', '2', 7, '2', '0', 'admin', now(), 'xkw:194436'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194436');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文章的叙述视角', 'XKW-CHN-194439', '2', 8, '2', '0', 'admin', now(), 'xkw:194439'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194439');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析人物形象', 'XKW-CHN-194440', '2', 9, '2', '0', 'admin', now(), 'xkw:194440'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194440');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鉴赏人物描写手法', 'XKW-CHN-194441', '2', 10, '2', '0', 'admin', now(), 'xkw:194441'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194441');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析环境描写的作用', 'XKW-CHN-194442', '2', 11, '2', '0', 'admin', now(), 'xkw:194442'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194442');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '品味语言艺术', 'XKW-CHN-194443', '2', 12, '2', '0', 'admin', now(), 'xkw:194443'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194443');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析文章结构和思路', 'XKW-CHN-194444', '2', 13, '2', '0', 'admin', now(), 'xkw:194444'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194444');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析标题的含义和作用', 'XKW-CHN-194445', '2', 14, '2', '0', 'admin', now(), 'xkw:194445'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194445');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探讨创作背景和意图', 'XKW-CHN-194446', '2', 15, '2', '0', 'admin', now(), 'xkw:194446'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194446');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析、探究文本情感', 'XKW-CHN-194447', '2', 16, '2', '0', 'admin', now(), 'xkw:194447'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194447');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究、评价主旨或观点', 'XKW-CHN-194448', '2', 17, '2', '0', 'admin', now(), 'xkw:194448'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194448');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价、感悟作品人文价值、时代意义', 'XKW-CHN-194449', '2', 18, '2', '0', 'admin', now(), 'xkw:194449'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194449');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价作品价值判断和审美取向', 'XKW-CHN-194450', '2', 19, '2', '0', 'admin', now(), 'xkw:194450'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194450');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究问题，提出见解', 'XKW-CHN-194451', '2', 20, '2', '0', 'admin', now(), 'xkw:194451'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194451');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析、运用文中信息', 'XKW-CHN-194452', '2', 21, '2', '0', 'admin', now(), 'xkw:194452'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194452');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '识记常识', 'XKW-CHN-194454', '2', 1, '2', '0', 'admin', now(), 'xkw:194454'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194454');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '整体把握内容、观点', 'XKW-CHN-194455', '2', 2, '2', '0', 'admin', now(), 'xkw:194455'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194455');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解重要概念', 'XKW-CHN-194456', '2', 3, '2', '0', 'admin', now(), 'xkw:194456'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194456');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析思想内涵', 'XKW-CHN-194457', '2', 4, '2', '0', 'admin', now(), 'xkw:194457'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194457');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价、感悟作品人文价值、时代意义', 'XKW-CHN-194458', '2', 5, '2', '0', 'admin', now(), 'xkw:194458'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194458');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鉴赏文本特色', 'XKW-CHN-194459', '2', 6, '2', '0', 'admin', now(), 'xkw:194459'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194459');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '筛选整合信息，归纳概括要点', 'XKW-CHN-194460', '2', 7, '2', '0', 'admin', now(), 'xkw:194460'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194460');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析概括作者的观点、态度', 'XKW-CHN-194461', '2', 8, '2', '0', 'admin', now(), 'xkw:194461'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194461');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析文章结构和思路', 'XKW-CHN-194462', '2', 9, '2', '0', 'admin', now(), 'xkw:194462'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194462');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究、评价、运用概念或观点', 'XKW-CHN-194463', '2', 10, '2', '0', 'admin', now(), 'xkw:194463'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194463');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析、阐释论述要素', 'XKW-CHN-194464', '2', 11, '2', '0', 'admin', now(), 'xkw:194464'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194464');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析材料，合理推断', 'XKW-CHN-194465', '2', 12, '2', '0', 'admin', now(), 'xkw:194465'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194465');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究问题，提出见解', 'XKW-CHN-194466', '2', 13, '2', '0', 'admin', now(), 'xkw:194466'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-194453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-194466');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '史传文', 'XKW-CHN-192921', '2', 1, '2', '0', 'admin', now(), 'xkw:192921'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157848'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192921');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '论说文', 'XKW-CHN-192922', '1', 2, '2', '0', 'admin', now(), 'xkw:192922'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157848'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192922');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杂记文', 'XKW-CHN-192925', '1', 3, '2', '0', 'admin', now(), 'xkw:192925'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157848'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192925');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '应用类', 'XKW-CHN-27862', '2', 4, '2', '0', 'admin', now(), 'xkw:27862'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157848'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27862');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他', 'XKW-CHN-27864', '2', 5, '2', '0', 'admin', now(), 'xkw:27864'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157848'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27864');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '姓名称谓', 'XKW-CHN-27512', '2', 1, '2', '0', 'admin', now(), 'xkw:27512'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27512');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古代官职 典章制度', 'XKW-CHN-27513', '2', 2, '2', '0', 'admin', now(), 'xkw:27513'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27513');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天文历法', 'XKW-CHN-27514', '2', 3, '2', '0', 'admin', now(), 'xkw:27514'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27514');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古代地理', 'XKW-CHN-27515', '2', 4, '2', '0', 'admin', now(), 'xkw:27515'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27515');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '教育科举', 'XKW-CHN-27516', '2', 5, '2', '0', 'admin', now(), 'xkw:27516'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27516');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '风俗礼仪', 'XKW-CHN-27517', '2', 6, '2', '0', 'admin', now(), 'xkw:27517'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27517');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '衣食住行 度量衡', 'XKW-CHN-27518', '2', 7, '2', '0', 'admin', now(), 'xkw:27518'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27518');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '音乐文娱', 'XKW-CHN-27519', '2', 8, '2', '0', 'admin', now(), 'xkw:27519'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27519');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文史典籍', 'XKW-CHN-27520', '2', 9, '2', '0', 'admin', now(), 'xkw:27520'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27520');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '目录辞书', 'XKW-CHN-27521', '2', 10, '2', '0', 'admin', now(), 'xkw:27521'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27521');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古代刑罚 军政事务', 'XKW-CHN-180748', '2', 11, '2', '0', 'admin', now(), 'xkw:180748'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27510'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180748');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般文言实词', 'XKW-CHN-182903', '2', 1, '2', '0', 'admin', now(), 'xkw:182903'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182903');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般文言虚词', 'XKW-CHN-182906', '2', 2, '2', '0', 'admin', now(), 'xkw:182906'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182906');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '通假字', 'XKW-CHN-182901', '2', 3, '2', '0', 'admin', now(), 'xkw:182901'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182901');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一词多义', 'XKW-CHN-188528', '2', 4, '2', '0', 'admin', now(), 'xkw:188528'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-188528');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古今异义', 'XKW-CHN-182904', '2', 5, '2', '0', 'admin', now(), 'xkw:182904'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182904');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词类活用', 'XKW-CHN-182902', '2', 6, '2', '0', 'admin', now(), 'xkw:182902'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182902');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '偏义复词', 'XKW-CHN-182905', '2', 7, '2', '0', 'admin', now(), 'xkw:182905'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182905');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断句', 'XKW-CHN-27845', '2', 8, '2', '0', 'admin', now(), 'xkw:27845'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27845');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '被动句', 'XKW-CHN-27846', '2', 9, '2', '0', 'admin', now(), 'xkw:27846'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27846');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '倒装句', 'XKW-CHN-27847', '2', 10, '2', '0', 'admin', now(), 'xkw:27847'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27847');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '省略句', 'XKW-CHN-27848', '2', 11, '2', '0', 'admin', now(), 'xkw:27848'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27848');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '固定句式', 'XKW-CHN-157847', '2', 12, '2', '0', 'admin', now(), 'xkw:157847'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157847');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文言文断句', 'XKW-CHN-27525', '2', 13, '2', '0', 'admin', now(), 'xkw:27525'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27525');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文言文翻译', 'XKW-CHN-27526', '2', 14, '2', '0', 'admin', now(), 'xkw:27526'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27511'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27526');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析信息，归纳要点', 'XKW-CHN-157850', '2', 1, '2', '0', 'admin', now(), 'xkw:157850'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157850');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '概括中心意思', 'XKW-CHN-157851', '2', 2, '2', '0', 'admin', now(), 'xkw:157851'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157851');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '把握文章的结构和思路', 'XKW-CHN-157852', '2', 3, '2', '0', 'admin', now(), 'xkw:157852'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157852');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '概括、分析人物形象', 'XKW-CHN-157853', '2', 4, '2', '0', 'admin', now(), 'xkw:157853'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157853');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析理解文章内容', 'XKW-CHN-180625', '2', 5, '2', '0', 'admin', now(), 'xkw:180625'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180625');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鉴赏艺术手法', 'XKW-CHN-180626', '2', 6, '2', '0', 'admin', now(), 'xkw:180626'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180626');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价探究文中思想观点', 'XKW-CHN-180627', '2', 7, '2', '0', 'admin', now(), 'xkw:180627'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180627');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解句段含义及作用', 'XKW-CHN-184886', '2', 8, '2', '0', 'admin', now(), 'xkw:184886'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184886');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诗', 'XKW-CHN-27865', '1', 1, '2', '0', 'admin', now(), 'xkw:27865'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157854'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27865');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词', 'XKW-CHN-27866', '1', 2, '2', '0', 'admin', now(), 'xkw:27866'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157854'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27866');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曲', 'XKW-CHN-27867', '1', 3, '2', '0', 'admin', now(), 'xkw:27867'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157854'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27867');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '咏史怀古', 'XKW-CHN-157858', '2', 1, '2', '0', 'admin', now(), 'xkw:157858'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157858');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '赠友送别', 'XKW-CHN-157859', '2', 2, '2', '0', 'admin', now(), 'xkw:157859'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157859');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '羁旅思乡', 'XKW-CHN-157860', '2', 3, '2', '0', 'admin', now(), 'xkw:157860'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157860');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '咏物言志', 'XKW-CHN-157861', '2', 4, '2', '0', 'admin', now(), 'xkw:157861'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157861');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '边塞 征戍', 'XKW-CHN-157862', '2', 5, '2', '0', 'admin', now(), 'xkw:157862'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157862');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '山水田园', 'XKW-CHN-157863', '2', 6, '2', '0', 'admin', now(), 'xkw:157863'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157863');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '思妇闺情', 'XKW-CHN-157864', '2', 7, '2', '0', 'admin', now(), 'xkw:157864'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157864');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '即事感怀', 'XKW-CHN-180628', '2', 8, '2', '0', 'admin', now(), 'xkw:180628'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180628');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '写景抒情', 'XKW-CHN-181221', '2', 9, '2', '0', 'admin', now(), 'xkw:181221'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-181221');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酬和类', 'XKW-CHN-180629', '2', 10, '2', '0', 'admin', now(), 'xkw:180629'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180629');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '讽喻类', 'XKW-CHN-180630', '2', 11, '2', '0', 'admin', now(), 'xkw:180630'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180630');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '哲理类', 'XKW-CHN-180631', '2', 12, '2', '0', 'admin', now(), 'xkw:180631'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180631');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宫苑类', 'XKW-CHN-180632', '2', 13, '2', '0', 'admin', now(), 'xkw:180632'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180632');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '题画类', 'XKW-CHN-180633', '2', 14, '2', '0', 'admin', now(), 'xkw:180633'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180633');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '叙事类', 'XKW-CHN-180634', '2', 15, '2', '0', 'admin', now(), 'xkw:180634'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180634');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无题类', 'XKW-CHN-180635', '2', 16, '2', '0', 'admin', now(), 'xkw:180635'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180635');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '悼亡类', 'XKW-CHN-180636', '2', 17, '2', '0', 'admin', now(), 'xkw:180636'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157857'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180636');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析、理解古诗内容', 'XKW-CHN-157866', '2', 1, '2', '0', 'admin', now(), 'xkw:157866'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157865'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157866');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鉴赏诗词语言', 'XKW-CHN-157871', '1', 2, '2', '0', 'admin', now(), 'xkw:157871'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157865'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157871');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鉴赏诗词形象', 'XKW-CHN-157867', '1', 3, '2', '0', 'admin', now(), 'xkw:157867'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157865'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157867');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鉴赏古诗的表达技巧', 'XKW-CHN-192930', '1', 4, '2', '0', 'admin', now(), 'xkw:192930'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157865'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192930');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '评价思想内容', 'XKW-CHN-157904', '2', 5, '2', '0', 'admin', now(), 'xkw:157904'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157865'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157904');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '漫画说明', 'XKW-CHN-185246', '2', 1, '2', '0', 'admin', now(), 'xkw:185246'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185245'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-185246');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '谈观点', 'XKW-CHN-182227', '2', 1, '2', '0', 'admin', now(), 'xkw:182227'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182227');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人物点评', 'XKW-CHN-182230', '2', 2, '2', '0', 'admin', now(), 'xkw:182230'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182230');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '写辩论词', 'XKW-CHN-182231', '2', 3, '2', '0', 'admin', now(), 'xkw:182231'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182231');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微感悟', 'XKW-CHN-182234', '2', 4, '2', '0', 'admin', now(), 'xkw:182234'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182234');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微评论', 'XKW-CHN-182235', '2', 5, '2', '0', 'admin', now(), 'xkw:182235'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182235');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人物片段', 'XKW-CHN-184894', '2', 1, '2', '0', 'admin', now(), 'xkw:184894'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185248'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184894');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '描绘场景', 'XKW-CHN-182228', '2', 2, '2', '0', 'admin', now(), 'xkw:182228'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185248'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182228');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '写现代小诗', 'XKW-CHN-182233', '2', 1, '2', '0', 'admin', now(), 'xkw:182233'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185250'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182233');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '倡议书', 'XKW-CHN-182226', '2', 1, '2', '0', 'admin', now(), 'xkw:182226'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185251'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182226');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '推荐语', 'XKW-CHN-182232', '2', 2, '2', '0', 'admin', now(), 'xkw:182232'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185251'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182232');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '劝说词', 'XKW-CHN-182229', '2', 3, '2', '0', 'admin', now(), 'xkw:182229'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-185251'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182229');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '勤俭节约', 'XKW-CHN-182279', '2', 1, '2', '0', 'admin', now(), 'xkw:182279'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182279');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '劳动 勤勉', 'XKW-CHN-182277', '2', 2, '2', '0', 'admin', now(), 'xkw:182277'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182277');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自信 谦虚', 'XKW-CHN-182280', '2', 3, '2', '0', 'admin', now(), 'xkw:182280'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182280');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诚实守信', 'XKW-CHN-182281', '2', 4, '2', '0', 'admin', now(), 'xkw:182281'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182281');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解 宽容 ', 'XKW-CHN-182282', '2', 5, '2', '0', 'admin', now(), 'xkw:182282'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182282');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '信任 沟通', 'XKW-CHN-182283', '2', 6, '2', '0', 'admin', now(), 'xkw:182283'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-182283');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自强自律', 'XKW-CHN-192937', '2', 7, '2', '0', 'admin', now(), 'xkw:192937'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192937');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '正直善良', 'XKW-CHN-192938', '2', 8, '2', '0', 'admin', now(), 'xkw:192938'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192938');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '见义勇为', 'XKW-CHN-192939', '2', 9, '2', '0', 'admin', now(), 'xkw:192939'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192939');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诗经', 'XKW-CHN-7900', '2', 1, '2', '0', 'admin', now(), 'xkw:7900'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7900');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孔子(前551-前479)', 'XKW-CHN-7901', '1', 2, '2', '0', 'admin', now(), 'xkw:7901'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7901');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '左丘明(前556-前451)', 'XKW-CHN-7903', '1', 3, '2', '0', 'admin', now(), 'xkw:7903'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7903');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '墨子(约前468-前376)', 'XKW-CHN-7906', '1', 4, '2', '0', 'admin', now(), 'xkw:7906'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7906');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '老子(约前570-500)', 'XKW-CHN-7908', '1', 5, '2', '0', 'admin', now(), 'xkw:7908'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7908');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孙子(约前551-前479)', 'XKW-CHN-7910', '1', 6, '2', '0', 'admin', now(), 'xkw:7910'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7910');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孔伋(前483-前402)', 'XKW-CHN-7912', '1', 7, '2', '0', 'admin', now(), 'xkw:7912'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7912');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他春秋作家', 'XKW-CHN-7914', '2', 8, '2', '0', 'admin', now(), 'xkw:7914'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7914');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孟子(前372-前289)', 'XKW-CHN-7916', '1', 1, '2', '0', 'admin', now(), 'xkw:7916'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7915'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7916');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '庄子(约前369-前286)', 'XKW-CHN-7918', '1', 2, '2', '0', 'admin', now(), 'xkw:7918'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7915'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7918');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '荀子(前313-前238)', 'XKW-CHN-7920', '1', 3, '2', '0', 'admin', now(), 'xkw:7920'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7915'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7920');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '韩非子(前280-前233)', 'XKW-CHN-7922', '1', 4, '2', '0', 'admin', now(), 'xkw:7922'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7915'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7922');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '吕不韦(前292-前235)', 'XKW-CHN-7924', '1', 5, '2', '0', 'admin', now(), 'xkw:7924'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7915'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7924');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '列子(约前649-前606)', 'XKW-CHN-7926', '1', 6, '2', '0', 'admin', now(), 'xkw:7926'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7915'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7926');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '屈原(约前340-约前278)', 'XKW-CHN-7928', '1', 7, '2', '0', 'admin', now(), 'xkw:7928'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7915'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7928');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宋玉(约前298-222)', 'XKW-CHN-7930', '2', 8, '2', '0', 'admin', now(), 'xkw:7930'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7915'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7930');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他战国作家', 'XKW-CHN-7931', '2', 9, '2', '0', 'admin', now(), 'xkw:7931'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7915'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7931');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李斯', 'XKW-CHN-7933', '2', 1, '2', '0', 'admin', now(), 'xkw:7933'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7932'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7933');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '贾谊(前200-前168)', 'XKW-CHN-7935', '1', 1, '2', '0', 'admin', now(), 'xkw:7935'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7935');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '司马迁(前145-前90)', 'XKW-CHN-7937', '1', 2, '2', '0', 'admin', now(), 'xkw:7937'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7937');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘向(约前77-前6)', 'XKW-CHN-7939', '1', 3, '2', '0', 'admin', now(), 'xkw:7939'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7939');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他西汉作家', 'XKW-CHN-7942', '2', 4, '2', '0', 'admin', now(), 'xkw:7942'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7942');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '班固(32-92)', 'XKW-CHN-7944', '1', 1, '2', '0', 'admin', now(), 'xkw:7944'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7943'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7944');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他东汉作家', 'XKW-CHN-7946', '2', 2, '2', '0', 'admin', now(), 'xkw:7946'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7943'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7946');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曹操(155-220)', 'XKW-CHN-7948', '1', 1, '2', '0', 'admin', now(), 'xkw:7948'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7948');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诸葛亮(181-234)', 'XKW-CHN-7951', '1', 2, '2', '0', 'admin', now(), 'xkw:7951'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7951');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曹丕(155-220)', 'XKW-CHN-7953', '1', 3, '2', '0', 'admin', now(), 'xkw:7953'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7953');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曹植(192-232)', 'XKW-CHN-7955', '2', 4, '2', '0', 'admin', now(), 'xkw:7955'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7955');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '阮籍(210-263)', 'XKW-CHN-7956', '1', 5, '2', '0', 'admin', now(), 'xkw:7956'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7956');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他三国作家', 'XKW-CHN-7958', '2', 6, '2', '0', 'admin', now(), 'xkw:7958'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7958');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李密(233-297)', 'XKW-CHN-7960', '1', 1, '2', '0', 'admin', now(), 'xkw:7960'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7959'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7960');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陈寿(233-297)', 'XKW-CHN-7962', '1', 2, '2', '0', 'admin', now(), 'xkw:7962'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7959'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7962');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陆机(261-303)', 'XKW-CHN-7964', '2', 3, '2', '0', 'admin', now(), 'xkw:7964'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7959'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7964');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他西晋作家', 'XKW-CHN-7965', '2', 4, '2', '0', 'admin', now(), 'xkw:7965'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7959'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7965');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陶渊明(365-427)', 'XKW-CHN-7967', '1', 1, '2', '0', 'admin', now(), 'xkw:7967'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7966'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7967');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '干宝(283-351)', 'XKW-CHN-7973', '1', 2, '2', '0', 'admin', now(), 'xkw:7973'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7966'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7973');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '谢灵运(385-433)', 'XKW-CHN-7975', '2', 3, '2', '0', 'admin', now(), 'xkw:7975'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7966'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7975');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王羲之(303-361)', 'XKW-CHN-7976', '1', 4, '2', '0', 'admin', now(), 'xkw:7976'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7966'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7976');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他东晋作家', 'XKW-CHN-7978', '2', 5, '2', '0', 'admin', now(), 'xkw:7978'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7966'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7978');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '范晔(398-445)', 'XKW-CHN-7980', '1', 1, '2', '0', 'admin', now(), 'xkw:7980'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7980');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘义庆(403-444)', 'XKW-CHN-7982', '1', 2, '2', '0', 'admin', now(), 'xkw:7982'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7982');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鲍照(约414-466)', 'XKW-CHN-7984', '1', 3, '2', '0', 'admin', now(), 'xkw:7984'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7984');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '谢朓(464-499)', 'XKW-CHN-7986', '2', 4, '2', '0', 'admin', now(), 'xkw:7986'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7986');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '丘迟(464-508)', 'XKW-CHN-7987', '1', 5, '2', '0', 'admin', now(), 'xkw:7987'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7987');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘勰(465-520)', 'XKW-CHN-7989', '1', 6, '2', '0', 'admin', now(), 'xkw:7989'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7989');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '钟嵘(约468-518)', 'XKW-CHN-7991', '2', 7, '2', '0', 'admin', now(), 'xkw:7991'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7991');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '郦道元(470-527)', 'XKW-CHN-7992', '1', 8, '2', '0', 'admin', now(), 'xkw:7992'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7992');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '萧统', 'XKW-CHN-7994', '1', 9, '2', '0', 'admin', now(), 'xkw:7994'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7994');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他南北朝作家', 'XKW-CHN-7996', '2', 10, '2', '0', 'admin', now(), 'xkw:7996'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7996');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王勃(650-675)', 'XKW-CHN-7998', '1', 1, '2', '0', 'admin', now(), 'xkw:7998'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7998');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张若虚(约660-约720)', 'XKW-CHN-8000', '1', 2, '2', '0', 'admin', now(), 'xkw:8000'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8000');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张九龄(678-740)', 'XKW-CHN-8002', '1', 3, '2', '0', 'admin', now(), 'xkw:8002'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8002');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杨炯(650-692)', 'XKW-CHN-8005', '1', 4, '2', '0', 'admin', now(), 'xkw:8005'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8005');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卢照邻(约635-约689)', 'XKW-CHN-8007', '2', 5, '2', '0', 'admin', now(), 'xkw:8007'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8007');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '骆宾王(约640-687)', 'XKW-CHN-8008', '1', 6, '2', '0', 'admin', now(), 'xkw:8008'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8008');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '贺知章(659-744)', 'XKW-CHN-8010', '1', 7, '2', '0', 'admin', now(), 'xkw:8010'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8010');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王之涣(688-742)', 'XKW-CHN-8012', '2', 8, '2', '0', 'admin', now(), 'xkw:8012'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8012');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孟浩然(689-740)', 'XKW-CHN-8013', '2', 9, '2', '0', 'admin', now(), 'xkw:8013'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8013');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王昌龄(690-756)', 'XKW-CHN-8014', '1', 10, '2', '0', 'admin', now(), 'xkw:8014'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8014');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王维(701-761)', 'XKW-CHN-8017', '2', 11, '2', '0', 'admin', now(), 'xkw:8017'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8017');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李白(701-762)', 'XKW-CHN-8018', '1', 12, '2', '0', 'admin', now(), 'xkw:8018'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8018');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '高适(700-765)', 'XKW-CHN-8021', '1', 13, '2', '0', 'admin', now(), 'xkw:8021'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8021');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '崔颢(704-754)', 'XKW-CHN-8024', '1', 14, '2', '0', 'admin', now(), 'xkw:8024'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8024');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杜甫(712-770)', 'XKW-CHN-8026', '1', 15, '2', '0', 'admin', now(), 'xkw:8026'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8026');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '岑参(715-770)', 'XKW-CHN-8028', '1', 16, '2', '0', 'admin', now(), 'xkw:8028'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8028');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张志和(730-810)', 'XKW-CHN-8030', '2', 17, '2', '0', 'admin', now(), 'xkw:8030'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8030');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '韦应物(约737-791)', 'XKW-CHN-8031', '1', 18, '2', '0', 'admin', now(), 'xkw:8031'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8031');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孟郊(751-814)', 'XKW-CHN-8034', '2', 19, '2', '0', 'admin', now(), 'xkw:8034'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8034');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '韩愈(768-824)', 'XKW-CHN-8035', '1', 20, '2', '0', 'admin', now(), 'xkw:8035'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8035');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘禹锡(772-842)', 'XKW-CHN-8037', '1', 21, '2', '0', 'admin', now(), 'xkw:8037'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8037');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '白居易(772-846)', 'XKW-CHN-8039', '1', 22, '2', '0', 'admin', now(), 'xkw:8039'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8039');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '柳宗元(773-819)', 'XKW-CHN-8044', '1', 23, '2', '0', 'admin', now(), 'xkw:8044'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8044');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '元稹(779-831)', 'XKW-CHN-8047', '2', 24, '2', '0', 'admin', now(), 'xkw:8047'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8047');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '贾岛(779-843)', 'XKW-CHN-8048', '1', 25, '2', '0', 'admin', now(), 'xkw:8048'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8048');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李贺(790-816)', 'XKW-CHN-8050', '1', 26, '2', '0', 'admin', now(), 'xkw:8050'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8050');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杜牧(803-853)', 'XKW-CHN-8052', '1', 27, '2', '0', 'admin', now(), 'xkw:8052'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8052');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '温庭筠(约812-866)', 'XKW-CHN-8055', '2', 28, '2', '0', 'admin', now(), 'xkw:8055'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8055');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李商隐(813-858)', 'XKW-CHN-8056', '1', 29, '2', '0', 'admin', now(), 'xkw:8056'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8056');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '罗隐(833-909)', 'XKW-CHN-8059', '1', 30, '2', '0', 'admin', now(), 'xkw:8059'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8059');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '房玄龄等', 'XKW-CHN-8061', '1', 31, '2', '0', 'admin', now(), 'xkw:8061'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8061');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '姚思廉', 'XKW-CHN-8063', '1', 32, '2', '0', 'admin', now(), 'xkw:8063'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8063');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李百药', 'XKW-CHN-8066', '1', 33, '2', '0', 'admin', now(), 'xkw:8066'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8066');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '令狐德棻等', 'XKW-CHN-8068', '1', 34, '2', '0', 'admin', now(), 'xkw:8068'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8068');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '魏征等', 'XKW-CHN-8070', '1', 35, '2', '0', 'admin', now(), 'xkw:8070'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8070');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘长卿', 'XKW-CHN-8072', '2', 36, '2', '0', 'admin', now(), 'xkw:8072'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8072');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杜荀鹤', 'XKW-CHN-8073', '2', 37, '2', '0', 'admin', now(), 'xkw:8073'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8073');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘知几', 'XKW-CHN-8074', '1', 38, '2', '0', 'admin', now(), 'xkw:8074'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8074');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他隋唐作者', 'XKW-CHN-8076', '2', 39, '2', '0', 'admin', now(), 'xkw:8076'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7997'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8076');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '韦庄(约836-910)', 'XKW-CHN-8078', '2', 1, '2', '0', 'admin', now(), 'xkw:8078'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8078');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冯延巳(903-960)', 'XKW-CHN-8079', '2', 2, '2', '0', 'admin', now(), 'xkw:8079'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8079');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李煜(937-978)', 'XKW-CHN-8080', '1', 3, '2', '0', 'admin', now(), 'xkw:8080'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8080');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '沈约', 'XKW-CHN-8083', '1', 4, '2', '0', 'admin', now(), 'xkw:8083'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8083');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '萧子显', 'XKW-CHN-8085', '1', 5, '2', '0', 'admin', now(), 'xkw:8085'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8085');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '魏收', 'XKW-CHN-8087', '1', 6, '2', '0', 'admin', now(), 'xkw:8087'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8087');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘昫等', 'XKW-CHN-8089', '1', 7, '2', '0', 'admin', now(), 'xkw:8089'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8089');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他五代十国作者', 'XKW-CHN-8091', '2', 8, '2', '0', 'admin', now(), 'xkw:8091'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8091');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '柳永(约971-1053)', 'XKW-CHN-8093', '1', 1, '2', '0', 'admin', now(), 'xkw:8093'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8093');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '范仲淹(989-1052)', 'XKW-CHN-8097', '1', 2, '2', '0', 'admin', now(), 'xkw:8097'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8097');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张先(990-1078)', 'XKW-CHN-8099', '2', 3, '2', '0', 'admin', now(), 'xkw:8099'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8099');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '晏殊(991-1055)', 'XKW-CHN-8100', '1', 4, '2', '0', 'admin', now(), 'xkw:8100'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8100');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宋祁(998-1061)', 'XKW-CHN-8102', '1', 5, '2', '0', 'admin', now(), 'xkw:8102'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8102');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '欧阳修(1007-1072)', 'XKW-CHN-8104', '1', 6, '2', '0', 'admin', now(), 'xkw:8104'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8104');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '苏洵(1009-1066)', 'XKW-CHN-8107', '1', 7, '2', '0', 'admin', now(), 'xkw:8107'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8107');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '周敦颐(1017-1073)', 'XKW-CHN-8109', '1', 8, '2', '0', 'admin', now(), 'xkw:8109'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8109');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '司马光(1019-1086)', 'XKW-CHN-8111', '1', 9, '2', '0', 'admin', now(), 'xkw:8111'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8111');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王安石(1021-1086)', 'XKW-CHN-8113', '1', 10, '2', '0', 'admin', now(), 'xkw:8113'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8113');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '沈括(1031-1095)', 'XKW-CHN-8116', '1', 11, '2', '0', 'admin', now(), 'xkw:8116'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8116');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '苏轼(1037-1101)', 'XKW-CHN-8118', '1', 12, '2', '0', 'admin', now(), 'xkw:8118'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8118');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '苏辙(1039-1112)', 'XKW-CHN-8122', '1', 13, '2', '0', 'admin', now(), 'xkw:8122'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8122');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '晏几道(约1040-约1112)', 'XKW-CHN-8125', '2', 14, '2', '0', 'admin', now(), 'xkw:8125'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8125');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '黄庭坚(1045-1105)', 'XKW-CHN-8126', '2', 15, '2', '0', 'admin', now(), 'xkw:8126'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8126');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '秦观(1049-1100)', 'XKW-CHN-8127', '1', 16, '2', '0', 'admin', now(), 'xkw:8127'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8127');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '贺铸(1052-1125)', 'XKW-CHN-8129', '1', 17, '2', '0', 'admin', now(), 'xkw:8129'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8129');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '周邦彦(1056-1121)', 'XKW-CHN-8131', '2', 18, '2', '0', 'admin', now(), 'xkw:8131'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8131');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李清照(1084-1155)', 'XKW-CHN-8132', '1', 19, '2', '0', 'admin', now(), 'xkw:8132'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8132');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '薛居正', 'XKW-CHN-8135', '1', 20, '2', '0', 'admin', now(), 'xkw:8135'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8135');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曾巩', 'XKW-CHN-8137', '2', 21, '2', '0', 'admin', now(), 'xkw:8137'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8137');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '郭茂倩', 'XKW-CHN-8138', '2', 22, '2', '0', 'admin', now(), 'xkw:8138'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8138');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他北宋作家', 'XKW-CHN-8139', '2', 23, '2', '0', 'admin', now(), 'xkw:8139'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8092'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8139');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '岳飞(1103-1142)', 'XKW-CHN-8141', '1', 1, '2', '0', 'admin', now(), 'xkw:8141'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8141');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陆游(1125-1207)', 'XKW-CHN-8143', '1', 2, '2', '0', 'admin', now(), 'xkw:8143'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8143');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杨万里(1127-1206)', 'XKW-CHN-8147', '1', 3, '2', '0', 'admin', now(), 'xkw:8147'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8147');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '朱熹(1130-1200)', 'XKW-CHN-8149', '1', 4, '2', '0', 'admin', now(), 'xkw:8149'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8149');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张孝祥(1132-1169)', 'XKW-CHN-8152', '1', 5, '2', '0', 'admin', now(), 'xkw:8152'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8152');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '辛弃疾(1140-1207)', 'XKW-CHN-8154', '1', 6, '2', '0', 'admin', now(), 'xkw:8154'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8154');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '姜夔(1155-1221)', 'XKW-CHN-8157', '1', 7, '2', '0', 'admin', now(), 'xkw:8157'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8157');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文天祥(1236-1283)', 'XKW-CHN-8159', '2', 8, '2', '0', 'admin', now(), 'xkw:8159'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8159');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '邓剡', 'XKW-CHN-8160', '2', 9, '2', '0', 'admin', now(), 'xkw:8160'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8160');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他南宋作家', 'XKW-CHN-8161', '2', 10, '2', '0', 'admin', now(), 'xkw:8161'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8161');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关汉卿(1220-1300)', 'XKW-CHN-8163', '1', 1, '2', '0', 'admin', now(), 'xkw:8163'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8163');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王实甫(不详)', 'XKW-CHN-8165', '1', 2, '2', '0', 'admin', now(), 'xkw:8165'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8165');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '马致远(约1251-1321)', 'XKW-CHN-8167', '1', 3, '2', '0', 'admin', now(), 'xkw:8167'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8167');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张养浩(1270-1329)', 'XKW-CHN-8170', '2', 4, '2', '0', 'admin', now(), 'xkw:8170'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8170');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '郑光祖(不详)', 'XKW-CHN-8171', '2', 5, '2', '0', 'admin', now(), 'xkw:8171'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8171');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张可久(约1270-1348)', 'XKW-CHN-8172', '2', 6, '2', '0', 'admin', now(), 'xkw:8172'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8172');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '乔吉(不详)', 'XKW-CHN-8173', '2', 7, '2', '0', 'admin', now(), 'xkw:8173'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8173');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '施耐庵(不详)', 'XKW-CHN-8174', '1', 8, '2', '0', 'admin', now(), 'xkw:8174'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8174');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '脱脱等', 'XKW-CHN-8176', '1', 9, '2', '0', 'admin', now(), 'xkw:8176'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8176');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他元代作家', 'XKW-CHN-8180', '2', 10, '2', '0', 'admin', now(), 'xkw:8180'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8162'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8180');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宋濂(1310-1381)', 'XKW-CHN-8182', '1', 1, '2', '0', 'admin', now(), 'xkw:8182'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8182');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘基(1311-1375)', 'XKW-CHN-8184', '1', 2, '2', '0', 'admin', now(), 'xkw:8184'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8184');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '罗贯中(不详)', 'XKW-CHN-8186', '1', 3, '2', '0', 'admin', now(), 'xkw:8186'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8186');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '于谦(1398-1457)', 'XKW-CHN-8188', '2', 4, '2', '0', 'admin', now(), 'xkw:8188'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8188');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '吴承恩(1507-1582)', 'XKW-CHN-8189', '1', 5, '2', '0', 'admin', now(), 'xkw:8189'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8189');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '归有光(1506-1571)', 'XKW-CHN-8191', '1', 6, '2', '0', 'admin', now(), 'xkw:8191'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8191');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '汤显祖(1550-1616)', 'XKW-CHN-8193', '1', 7, '2', '0', 'admin', now(), 'xkw:8193'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8193');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '袁宏道(1568-1610)', 'XKW-CHN-8195', '1', 8, '2', '0', 'admin', now(), 'xkw:8195'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8195');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冯梦龙(1574-1646)', 'XKW-CHN-8197', '1', 9, '2', '0', 'admin', now(), 'xkw:8197'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8197');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '徐弘祖(1586-1641)', 'XKW-CHN-8199', '1', 10, '2', '0', 'admin', now(), 'xkw:8199'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8199');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '魏学洢(约1596-约1625)', 'XKW-CHN-8201', '1', 11, '2', '0', 'admin', now(), 'xkw:8201'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8201');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张溥(1602-1641)', 'XKW-CHN-8203', '1', 12, '2', '0', 'admin', now(), 'xkw:8203'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8203');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陈继儒', 'XKW-CHN-8205', '2', 13, '2', '0', 'admin', now(), 'xkw:8205'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8205');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李贽', 'XKW-CHN-8206', '2', 14, '2', '0', 'admin', now(), 'xkw:8206'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8206');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张岱(1597-1679)', 'XKW-CHN-8209', '1', 1, '2', '0', 'admin', now(), 'xkw:8209'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8209');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李渔(1610-1680)', 'XKW-CHN-8211', '1', 2, '2', '0', 'admin', now(), 'xkw:8211'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8211');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '顾炎武(1613-1682)', 'XKW-CHN-8213', '1', 3, '2', '0', 'admin', now(), 'xkw:8213'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8213');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '魏禧(1624-1681)', 'XKW-CHN-8215', '2', 4, '2', '0', 'admin', now(), 'xkw:8215'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8215');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蒲松龄(1640-1715)', 'XKW-CHN-8216', '1', 5, '2', '0', 'admin', now(), 'xkw:8216'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8216');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '洪昇(1645-1704)', 'XKW-CHN-8218', '2', 6, '2', '0', 'admin', now(), 'xkw:8218'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8218');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孔尚任(1648-1718)', 'XKW-CHN-8219', '1', 7, '2', '0', 'admin', now(), 'xkw:8219'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8219');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '查慎行(1650-1727)', 'XKW-CHN-8221', '2', 8, '2', '0', 'admin', now(), 'xkw:8221'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8221');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '纳兰性德(1655-1685)', 'XKW-CHN-8222', '1', 9, '2', '0', 'admin', now(), 'xkw:8222'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8222');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '方苞(1668-1749)', 'XKW-CHN-8224', '1', 10, '2', '0', 'admin', now(), 'xkw:8224'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8224');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '吴敬梓(1701-1754)', 'XKW-CHN-8226', '1', 11, '2', '0', 'admin', now(), 'xkw:8226'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8226');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全祖望(1705-1755)', 'XKW-CHN-8228', '1', 12, '2', '0', 'admin', now(), 'xkw:8228'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8228');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曹雪芹(1715-1764)', 'XKW-CHN-8230', '1', 13, '2', '0', 'admin', now(), 'xkw:8230'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8230');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '袁枚(1716-1798)', 'XKW-CHN-8232', '1', 14, '2', '0', 'admin', now(), 'xkw:8232'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8232');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '姚鼐(1732-1815)', 'XKW-CHN-8234', '1', 15, '2', '0', 'admin', now(), 'xkw:8234'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8234');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '龚自珍(1792-1841)', 'XKW-CHN-8236', '1', 16, '2', '0', 'admin', now(), 'xkw:8236'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8236');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张廷玉', 'XKW-CHN-8238', '1', 17, '2', '0', 'admin', now(), 'xkw:8238'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8238');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '魏禧', 'XKW-CHN-8240', '2', 18, '2', '0', 'admin', now(), 'xkw:8240'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8240');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他清代作家', 'XKW-CHN-8241', '2', 19, '2', '0', 'admin', now(), 'xkw:8241'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8208'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8241');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孙文(1866-1925)', 'XKW-CHN-8244', '2', 1, '2', '0', 'admin', now(), 'xkw:8244'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8243'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8244');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘鹗(1857-1909)', 'XKW-CHN-8245', '1', 2, '2', '0', 'admin', now(), 'xkw:8245'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8243'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8245');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '康有为(1858-1927)', 'XKW-CHN-8247', '2', 3, '2', '0', 'admin', now(), 'xkw:8247'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8243'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8247');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '梁启超(1873-1929)', 'XKW-CHN-8248', '2', 4, '2', '0', 'admin', now(), 'xkw:8248'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8243'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8248');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王国维(1877-1927)', 'XKW-CHN-8249', '1', 5, '2', '0', 'admin', now(), 'xkw:8249'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8243'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8249');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他近代作家', 'XKW-CHN-8251', '2', 6, '2', '0', 'admin', now(), 'xkw:8251'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8243'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8251');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鲁迅(1881-1936)', 'XKW-CHN-8254', '1', 1, '2', '0', 'admin', now(), 'xkw:8254'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8254');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '周作人(1884-1967)', 'XKW-CHN-8259', '2', 2, '2', '0', 'admin', now(), 'xkw:8259'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8259');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胡适(1887-1962)', 'XKW-CHN-8260', '2', 3, '2', '0', 'admin', now(), 'xkw:8260'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8260');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘半农(1891-1934)', 'XKW-CHN-8261', '2', 4, '2', '0', 'admin', now(), 'xkw:8261'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8261');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '郭沫若(1892-1978)', 'XKW-CHN-8262', '1', 5, '2', '0', 'admin', now(), 'xkw:8262'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8262');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '毛泽东(1893-1976)', 'XKW-CHN-8265', '1', 6, '2', '0', 'admin', now(), 'xkw:8265'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8265');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '许地山(1893-1941)', 'XKW-CHN-8268', '2', 7, '2', '0', 'admin', now(), 'xkw:8268'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8268');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '丁西林(1893-1974)', 'XKW-CHN-8269', '2', 8, '2', '0', 'admin', now(), 'xkw:8269'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8269');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '叶圣陶(1894-1988)', 'XKW-CHN-8270', '1', 9, '2', '0', 'admin', now(), 'xkw:8270'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8270');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '邹韬奋(1895-1944)', 'XKW-CHN-8272', '2', 10, '2', '0', 'admin', now(), 'xkw:8272'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8272');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冯友兰(1895-1990)', 'XKW-CHN-8273', '1', 11, '2', '0', 'admin', now(), 'xkw:8273'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8273');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '林语堂(1895-1976)', 'XKW-CHN-8275', '1', 12, '2', '0', 'admin', now(), 'xkw:8275'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8275');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '茅盾(1896-1981)', 'XKW-CHN-8277', '1', 13, '2', '0', 'admin', now(), 'xkw:8277'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8277');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '郁达夫(1896-1945)', 'XKW-CHN-8280', '1', 14, '2', '0', 'admin', now(), 'xkw:8280'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8280');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '徐志摩(1896-1945)', 'XKW-CHN-8283', '1', 15, '2', '0', 'admin', now(), 'xkw:8283'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8283');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '朱光潜(1897-1986)', 'XKW-CHN-8286', '1', 16, '2', '0', 'admin', now(), 'xkw:8286'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8286');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '田汉(1898-1968)', 'XKW-CHN-8289', '2', 17, '2', '0', 'admin', now(), 'xkw:8289'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8289');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '朱自清(1898-1948)', 'XKW-CHN-8290', '1', 18, '2', '0', 'admin', now(), 'xkw:8290'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8290');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '郑振铎(1898-1948)', 'XKW-CHN-8292', '2', 19, '2', '0', 'admin', now(), 'xkw:8292'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8292');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '翦伯赞(1898-1968)', 'XKW-CHN-8293', '2', 20, '2', '0', 'admin', now(), 'xkw:8293'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8293');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '瞿秋白(1899-1935)', 'XKW-CHN-8294', '2', 21, '2', '0', 'admin', now(), 'xkw:8294'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8294');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '闻一多(1899-1946)', 'XKW-CHN-8295', '1', 22, '2', '0', 'admin', now(), 'xkw:8295'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8295');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '老舍(1899-1966)', 'XKW-CHN-8298', '1', 23, '2', '0', 'admin', now(), 'xkw:8298'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8298');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冰心(1900-1999)', 'XKW-CHN-8302', '2', 24, '2', '0', 'admin', now(), 'xkw:8302'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8302');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '夏衍(1900-1995)', 'XKW-CHN-8303', '1', 25, '2', '0', 'admin', now(), 'xkw:8303'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8303');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王力(1900-1986)', 'XKW-CHN-8305', '2', 26, '2', '0', 'admin', now(), 'xkw:8305'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8305');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '鲁彦(1901-1944)', 'XKW-CHN-8306', '2', 27, '2', '0', 'admin', now(), 'xkw:8306'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8306');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '梁思成(1901-1972)', 'XKW-CHN-8307', '2', 28, '2', '0', 'admin', now(), 'xkw:8307'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8307');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '柔石(1902-1931)', 'XKW-CHN-8308', '1', 29, '2', '0', 'admin', now(), 'xkw:8308'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8308');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '沈从文(1902-1988)', 'XKW-CHN-8311', '1', 30, '2', '0', 'admin', now(), 'xkw:8311'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8311');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冯雪峰(1903-1976)', 'XKW-CHN-8315', '2', 31, '2', '0', 'admin', now(), 'xkw:8315'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8315');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胡也频(1903-1931)', 'XKW-CHN-8316', '2', 32, '2', '0', 'admin', now(), 'xkw:8316'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8316');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '梁实秋（1903-1987）', 'XKW-CHN-8317', '1', 33, '2', '0', 'admin', now(), 'xkw:8317'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8317');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '巴金(1904-2005)', 'XKW-CHN-8319', '1', 34, '2', '0', 'admin', now(), 'xkw:8319'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8319');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艾芜(1904-1992)', 'XKW-CHN-8323', '2', 35, '2', '0', 'admin', now(), 'xkw:8323'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8323');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '丁玲(1904-1986)', 'XKW-CHN-8324', '1', 36, '2', '0', 'admin', now(), 'xkw:8324'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8324');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '臧克家(1905-2004)', 'XKW-CHN-8326', '2', 37, '2', '0', 'admin', now(), 'xkw:8326'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8326');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李广田(1906-1968)', 'XKW-CHN-8327', '2', 38, '2', '0', 'admin', now(), 'xkw:8327'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8327');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '吴伯箫(1906-1982)', 'XKW-CHN-8328', '2', 39, '2', '0', 'admin', now(), 'xkw:8328'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8328');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '赵树理(1906-1970)', 'XKW-CHN-8329', '1', 40, '2', '0', 'admin', now(), 'xkw:8329'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8329');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张天翼(1906-1985)', 'XKW-CHN-8332', '1', 41, '2', '0', 'admin', now(), 'xkw:8332'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8332');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李健吾(1906-1982)', 'XKW-CHN-8334', '2', 42, '2', '0', 'admin', now(), 'xkw:8334'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8334');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '萧军(1907-1988)', 'XKW-CHN-8335', '1', 43, '2', '0', 'admin', now(), 'xkw:8335'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8335');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '周立波(1908-1979)', 'XKW-CHN-8337', '1', 44, '2', '0', 'admin', now(), 'xkw:8337'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8337');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '吴组缃(1908-1994)', 'XKW-CHN-8340', '2', 45, '2', '0', 'admin', now(), 'xkw:8340'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8340');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '吴晗(1909-1969)', 'XKW-CHN-8341', '2', 46, '2', '0', 'admin', now(), 'xkw:8341'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8341');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '姚雪垠(1910-1999)', 'XKW-CHN-8342', '2', 47, '2', '0', 'admin', now(), 'xkw:8342'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8342');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曹禺(1910-1996)', 'XKW-CHN-8343', '1', 48, '2', '0', 'admin', now(), 'xkw:8343'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8343');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艾青(1910-1996)', 'XKW-CHN-8347', '1', 49, '2', '0', 'admin', now(), 'xkw:8347'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8347');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '钱锺书(1910-1998)', 'XKW-CHN-8351', '1', 50, '2', '0', 'admin', now(), 'xkw:8351'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8351');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '萧乾(1910-1999)', 'XKW-CHN-8354', '2', 51, '2', '0', 'admin', now(), 'xkw:8354'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8354');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '吴强(1910-1990)', 'XKW-CHN-8355', '1', 52, '2', '0', 'admin', now(), 'xkw:8355'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8355');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '萧红(1911-1942)', 'XKW-CHN-8357', '1', 53, '2', '0', 'admin', now(), 'xkw:8357'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8357');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孙犁(1913-2002)', 'XKW-CHN-8361', '1', 54, '2', '0', 'admin', now(), 'xkw:8361'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8361');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杨朔(1913-1968)', 'XKW-CHN-8364', '2', 55, '2', '0', 'admin', now(), 'xkw:8364'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8364');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '唐弢(1913-1992)', 'XKW-CHN-8365', '2', 56, '2', '0', 'admin', now(), 'xkw:8365'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8365');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杨沫(1914-1995)', 'XKW-CHN-8366', '1', 57, '2', '0', 'admin', now(), 'xkw:8366'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8366');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '柳青(1916-1978)', 'XKW-CHN-8368', '1', 58, '2', '0', 'admin', now(), 'xkw:8368'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8368');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘白羽(1916-2005)', 'XKW-CHN-8370', '1', 59, '2', '0', 'admin', now(), 'xkw:8370'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8370');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '袁珂(1916-2001)', 'XKW-CHN-8372', '2', 60, '2', '0', 'admin', now(), 'xkw:8372'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8372');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '田间(1916-1985)', 'XKW-CHN-8373', '2', 61, '2', '0', 'admin', now(), 'xkw:8373'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8373');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '秦牧(1919-1992)', 'XKW-CHN-8374', '2', 62, '2', '0', 'admin', now(), 'xkw:8374'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8374');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '魏巍(1920-2008)', 'XKW-CHN-8375', '2', 63, '2', '0', 'admin', now(), 'xkw:8375'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8375');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '汪曾祺(1920-1997)', 'XKW-CHN-8376', '1', 64, '2', '0', 'admin', now(), 'xkw:8376'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8376');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杜鹏程(1921-1991)', 'XKW-CHN-8379', '1', 65, '2', '0', 'admin', now(), 'xkw:8379'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8379');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '峻青(1922-2019)', 'XKW-CHN-8381', '1', 66, '2', '0', 'admin', now(), 'xkw:8381'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8381');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曲波(1923-2002)', 'XKW-CHN-8383', '1', 67, '2', '0', 'admin', now(), 'xkw:8383'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8383');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '贺敬之(1924-)', 'XKW-CHN-8385', '2', 68, '2', '0', 'admin', now(), 'xkw:8385'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8385');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张爱玲(1920-1995)', 'XKW-CHN-8386', '2', 69, '2', '0', 'admin', now(), 'xkw:8386'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8386');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '戴望舒', 'XKW-CHN-8387', '1', 70, '2', '0', 'admin', now(), 'xkw:8387'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8387');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陆蠡', 'XKW-CHN-8389', '1', 71, '2', '0', 'admin', now(), 'xkw:8389'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8389');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蔡元培', 'XKW-CHN-8391', '2', 72, '2', '0', 'admin', now(), 'xkw:8391'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8391');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '梁斌', 'XKW-CHN-8392', '1', 73, '2', '0', 'admin', now(), 'xkw:8392'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8392');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冯至', 'XKW-CHN-8394', '2', 74, '2', '0', 'admin', now(), 'xkw:8394'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8394');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '穆旦（查良铮，1918-1977)', 'XKW-CHN-8395', '2', 75, '2', '0', 'admin', now(), 'xkw:8395'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8395');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '何其芳', 'XKW-CHN-8396', '2', 76, '2', '0', 'admin', now(), 'xkw:8396'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8396');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卞之琳', 'XKW-CHN-8397', '1', 77, '2', '0', 'admin', now(), 'xkw:8397'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8397');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛汉', 'XKW-CHN-8399', '2', 78, '2', '0', 'admin', now(), 'xkw:8399'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8399');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '洛夫', 'XKW-CHN-8400', '2', 79, '2', '0', 'admin', now(), 'xkw:8400'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8400');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陶行知', 'XKW-CHN-8401', '2', 80, '2', '0', 'admin', now(), 'xkw:8401'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8401');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杨绛', 'XKW-CHN-8402', '2', 81, '2', '0', 'admin', now(), 'xkw:8402'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8402');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '费孝通', 'XKW-CHN-8403', '1', 82, '2', '0', 'admin', now(), 'xkw:8403'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8403');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '丰子恺', 'XKW-CHN-8405', '1', 83, '2', '0', 'admin', now(), 'xkw:8405'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8405');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他现代作家', 'XKW-CHN-8407', '2', 84, '2', '0', 'admin', now(), 'xkw:8407'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8407');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '金庸(1924-2018)', 'XKW-CHN-8409', '1', 1, '2', '0', 'admin', now(), 'xkw:8409'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8409');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '茹志鹃(1925-1998)', 'XKW-CHN-8412', '1', 2, '2', '0', 'admin', now(), 'xkw:8412'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8412');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陆文夫(1928-2005)', 'XKW-CHN-8415', '1', 3, '2', '0', 'admin', now(), 'xkw:8415'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8415');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '高晓声(1928-1999)', 'XKW-CHN-8417', '1', 4, '2', '0', 'admin', now(), 'xkw:8417'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8417');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宗璞(1928-)', 'XKW-CHN-8419', '1', 5, '2', '0', 'admin', now(), 'xkw:8419'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8419');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李准(1928-)', 'XKW-CHN-8421', '1', 6, '2', '0', 'admin', now(), 'xkw:8421'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8421');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '余光中（1928-2017）', 'XKW-CHN-8423', '1', 7, '2', '0', 'admin', now(), 'xkw:8423'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8423');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王愿坚(1929-1991)', 'XKW-CHN-8425', '1', 8, '2', '0', 'admin', now(), 'xkw:8425'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8425');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '邓友梅(1931-)', 'XKW-CHN-8427', '2', 9, '2', '0', 'admin', now(), 'xkw:8427'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8427');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '邵燕祥(1933-)', 'XKW-CHN-8428', '2', 10, '2', '0', 'admin', now(), 'xkw:8428'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8428');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王蒙(1934-)', 'XKW-CHN-8429', '1', 11, '2', '0', 'admin', now(), 'xkw:8429'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8429');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘绍棠(1936-1997)', 'XKW-CHN-8431', '1', 12, '2', '0', 'admin', now(), 'xkw:8431'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8431');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张贤亮(1936-)', 'XKW-CHN-8433', '2', 13, '2', '0', 'admin', now(), 'xkw:8433'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8433');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张洁(1937-)', 'XKW-CHN-8434', '1', 14, '2', '0', 'admin', now(), 'xkw:8434'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8434');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蒋子龙(1941-)', 'XKW-CHN-8436', '1', 15, '2', '0', 'admin', now(), 'xkw:8436'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8436');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘心武(1942-)', 'XKW-CHN-8438', '2', 16, '2', '0', 'admin', now(), 'xkw:8438'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8438');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冯骥才(1942-)', 'XKW-CHN-8439', '2', 17, '2', '0', 'admin', now(), 'xkw:8439'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8439');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陈忠实(1942-2016）', 'XKW-CHN-8440', '1', 18, '2', '0', 'admin', now(), 'xkw:8440'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8440');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '席慕容(1943-)', 'XKW-CHN-8442', '2', 19, '2', '0', 'admin', now(), 'xkw:8442'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8442');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '三毛(1943-1991)', 'XKW-CHN-8443', '2', 20, '2', '0', 'admin', now(), 'xkw:8443'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8443');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '路遥(1949-1992)', 'XKW-CHN-8444', '1', 21, '2', '0', 'admin', now(), 'xkw:8444'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8444');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '梁晓声(1949-)', 'XKW-CHN-8447', '2', 22, '2', '0', 'admin', now(), 'xkw:8447'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8447');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '贾平凹(1952-)', 'XKW-CHN-8448', '1', 23, '2', '0', 'admin', now(), 'xkw:8448'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8448');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '莫言(1955-)', 'XKW-CHN-8450', '1', 24, '2', '0', 'admin', now(), 'xkw:8450'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8450');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '余华(1960-）', 'XKW-CHN-8454', '1', 25, '2', '0', 'admin', now(), 'xkw:8454'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8454');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '木心', 'XKW-CHN-8457', '2', 26, '2', '0', 'admin', now(), 'xkw:8457'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8457');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '季羡林（1911－2009）', 'XKW-CHN-8458', '2', 27, '2', '0', 'admin', now(), 'xkw:8458'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8458');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '史铁生（1950-2010）', 'XKW-CHN-8459', '1', 28, '2', '0', 'admin', now(), 'xkw:8459'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8459');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '林清玄（1953-2019）', 'XKW-CHN-8462', '2', 29, '2', '0', 'admin', now(), 'xkw:8462'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8462');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '阿城', 'XKW-CHN-8463', '1', 30, '2', '0', 'admin', now(), 'xkw:8463'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8463');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '吴念真', 'XKW-CHN-8465', '2', 31, '2', '0', 'admin', now(), 'xkw:8465'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8465');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曹文轩', 'XKW-CHN-8466', '2', 32, '2', '0', 'admin', now(), 'xkw:8466'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8466');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '阿来', 'XKW-CHN-8467', '2', 33, '2', '0', 'admin', now(), 'xkw:8467'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8467');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王安忆', 'XKW-CHN-8468', '2', 34, '2', '0', 'admin', now(), 'xkw:8468'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8468');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '梁小斌', 'XKW-CHN-8469', '2', 35, '2', '0', 'admin', now(), 'xkw:8469'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8469');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '食指', 'XKW-CHN-8470', '1', 36, '2', '0', 'admin', now(), 'xkw:8470'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8470');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张承志', 'XKW-CHN-8472', '1', 37, '2', '0', 'admin', now(), 'xkw:8472'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8472');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '余秋雨', 'XKW-CHN-8475', '1', 38, '2', '0', 'admin', now(), 'xkw:8475'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8475');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张抗抗', 'XKW-CHN-8477', '2', 39, '2', '0', 'admin', now(), 'xkw:8477'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8477');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '袁行霈', 'XKW-CHN-8478', '2', 40, '2', '0', 'admin', now(), 'xkw:8478'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8478');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '琦君', 'XKW-CHN-8479', '2', 41, '2', '0', 'admin', now(), 'xkw:8479'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8479');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '舒婷', 'XKW-CHN-8480', '1', 42, '2', '0', 'admin', now(), 'xkw:8480'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8480');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '海子', 'XKW-CHN-8482', '2', 43, '2', '0', 'admin', now(), 'xkw:8482'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8482');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '郑愁予', 'XKW-CHN-8483', '1', 44, '2', '0', 'admin', now(), 'xkw:8483'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8483');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '韩少功', 'XKW-CHN-8485', '2', 45, '2', '0', 'admin', now(), 'xkw:8485'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8485');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刘亮程', 'XKW-CHN-8486', '1', 46, '2', '0', 'admin', now(), 'xkw:8486'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8486');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '肖复兴', 'XKW-CHN-8488', '2', 47, '2', '0', 'admin', now(), 'xkw:8488'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8488');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '毕淑敏', 'XKW-CHN-8489', '2', 48, '2', '0', 'admin', now(), 'xkw:8489'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8489');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '北岛', 'XKW-CHN-8490', '2', 49, '2', '0', 'admin', now(), 'xkw:8490'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8490');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '顾城', 'XKW-CHN-8491', '2', 50, '2', '0', 'admin', now(), 'xkw:8491'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8491');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '周国平', 'XKW-CHN-8492', '2', 51, '2', '0', 'admin', now(), 'xkw:8492'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8492');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '张晓风', 'XKW-CHN-8493', '2', 52, '2', '0', 'admin', now(), 'xkw:8493'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8493');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王朔', 'XKW-CHN-8494', '2', 53, '2', '0', 'admin', now(), 'xkw:8494'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8494');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '苏童', 'XKW-CHN-8495', '2', 54, '2', '0', 'admin', now(), 'xkw:8495'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8495');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '王小波', 'XKW-CHN-8496', '2', 55, '2', '0', 'admin', now(), 'xkw:8496'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8496');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '方方', 'XKW-CHN-8497', '2', 56, '2', '0', 'admin', now(), 'xkw:8497'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8497');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '铁凝', 'XKW-CHN-8498', '1', 57, '2', '0', 'admin', now(), 'xkw:8498'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8498');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '迟子建', 'XKW-CHN-8500', '2', 58, '2', '0', 'admin', now(), 'xkw:8500'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8500');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李娟', 'XKW-CHN-8501', '2', 59, '2', '0', 'admin', now(), 'xkw:8501'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8501');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '李汉荣', 'XKW-CHN-8502', '2', 60, '2', '0', 'admin', now(), 'xkw:8502'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8502');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他当代作家', 'XKW-CHN-8503', '2', 61, '2', '0', 'admin', now(), 'xkw:8503'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8408'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8503');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '乔伊斯', 'XKW-CHN-8507', '2', 1, '2', '0', 'admin', now(), 'xkw:8507'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8506'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8507');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卡夫卡', 'XKW-CHN-8509', '1', 1, '2', '0', 'admin', now(), 'xkw:8509'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8508'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8509');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '斯蒂芬', 'XKW-CHN-8511', '2', 2, '2', '0', 'admin', now(), 'xkw:8511'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8508'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8511');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '里尔克', 'XKW-CHN-8512', '2', 3, '2', '0', 'admin', now(), 'xkw:8512'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8508'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8512');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '考琳·麦卡洛', 'XKW-CHN-8514', '2', 1, '2', '0', 'admin', now(), 'xkw:8514'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8513'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8514');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '显克微支', 'XKW-CHN-8516', '2', 1, '2', '0', 'admin', now(), 'xkw:8516'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8515'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8516');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '安徒生', 'XKW-CHN-8518', '2', 1, '2', '0', 'admin', now(), 'xkw:8518'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8517'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8518');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '歌德', 'XKW-CHN-8520', '2', 1, '2', '0', 'admin', now(), 'xkw:8520'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8519'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8520');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '海涅', 'XKW-CHN-8521', '2', 2, '2', '0', 'admin', now(), 'xkw:8521'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8519'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8521');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '赫尔曼·黑塞', 'XKW-CHN-8522', '2', 3, '2', '0', 'admin', now(), 'xkw:8522'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8519'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8522');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '托马斯·曼', 'XKW-CHN-8523', '2', 4, '2', '0', 'admin', now(), 'xkw:8523'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8519'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8523');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '海因里希·伯尔', 'XKW-CHN-8524', '2', 5, '2', '0', 'admin', now(), 'xkw:8524'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8519'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8524');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '普希金', 'XKW-CHN-8526', '2', 1, '2', '0', 'admin', now(), 'xkw:8526'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8525'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8526');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '果戈理', 'XKW-CHN-8527', '2', 2, '2', '0', 'admin', now(), 'xkw:8527'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8525'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8527');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '屠格涅夫', 'XKW-CHN-8528', '2', 3, '2', '0', 'admin', now(), 'xkw:8528'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8525'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8528');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陀思妥耶夫斯基', 'XKW-CHN-8529', '2', 4, '2', '0', 'admin', now(), 'xkw:8529'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8525'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8529');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '莱蒙托夫', 'XKW-CHN-8530', '2', 5, '2', '0', 'admin', now(), 'xkw:8530'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8525'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8530');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '列夫·托尔斯泰', 'XKW-CHN-8531', '1', 6, '2', '0', 'admin', now(), 'xkw:8531'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8525'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8531');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '契诃夫', 'XKW-CHN-8533', '1', 7, '2', '0', 'admin', now(), 'xkw:8533'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8525'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8533');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '帕乌斯托夫斯基', 'XKW-CHN-8535', '2', 8, '2', '0', 'admin', now(), 'xkw:8535'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8525'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8535');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '叶赛宁', 'XKW-CHN-8536', '2', 9, '2', '0', 'admin', now(), 'xkw:8536'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8525'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8536');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '莫里哀', 'XKW-CHN-8538', '1', 1, '2', '0', 'admin', now(), 'xkw:8538'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8538');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卢梭', 'XKW-CHN-8540', '2', 2, '2', '0', 'admin', now(), 'xkw:8540'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8540');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '雨果', 'XKW-CHN-8541', '1', 3, '2', '0', 'admin', now(), 'xkw:8541'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8541');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '大仲马', 'XKW-CHN-8544', '1', 4, '2', '0', 'admin', now(), 'xkw:8544'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8544');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '司汤达', 'XKW-CHN-8546', '1', 5, '2', '0', 'admin', now(), 'xkw:8546'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8546');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波德莱尔', 'XKW-CHN-8548', '2', 6, '2', '0', 'admin', now(), 'xkw:8548'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8548');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '巴尔扎克', 'XKW-CHN-8549', '1', 7, '2', '0', 'admin', now(), 'xkw:8549'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8549');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '梅里美', 'XKW-CHN-8551', '2', 8, '2', '0', 'admin', now(), 'xkw:8551'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8551');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '左拉', 'XKW-CHN-8552', '2', 9, '2', '0', 'admin', now(), 'xkw:8552'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8552');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '莫泊桑', 'XKW-CHN-8553', '1', 10, '2', '0', 'admin', now(), 'xkw:8553'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8553');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '都德', 'XKW-CHN-8556', '1', 11, '2', '0', 'admin', now(), 'xkw:8556'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8556');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '罗曼·罗兰', 'XKW-CHN-8558', '2', 12, '2', '0', 'admin', now(), 'xkw:8558'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8537'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8558');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '马尔克斯', 'XKW-CHN-8560', '1', 1, '2', '0', 'admin', now(), 'xkw:8560'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8559'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8560');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '柏拉图', 'XKW-CHN-8563', '2', 1, '2', '0', 'admin', now(), 'xkw:8563'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8562'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8563');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '亚里士多德', 'XKW-CHN-8564', '2', 2, '2', '0', 'admin', now(), 'xkw:8564'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8562'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8564');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '荷马', 'XKW-CHN-8565', '1', 3, '2', '0', 'admin', now(), 'xkw:8565'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8562'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8565');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '索福克勒斯', 'XKW-CHN-8567', '1', 4, '2', '0', 'admin', now(), 'xkw:8567'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8562'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8567');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '米兰·昆德拉', 'XKW-CHN-8571', '2', 1, '2', '0', 'admin', now(), 'xkw:8571'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8570'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8571');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '华盛顿·欧文', 'XKW-CHN-8573', '2', 1, '2', '0', 'admin', now(), 'xkw:8573'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8573');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '玛格丽特·米切尔', 'XKW-CHN-8574', '1', 2, '2', '0', 'admin', now(), 'xkw:8574'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8574');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '惠特曼', 'XKW-CHN-8576', '2', 3, '2', '0', 'admin', now(), 'xkw:8576'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8576');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '马克·吐温', 'XKW-CHN-8577', '2', 4, '2', '0', 'admin', now(), 'xkw:8577'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8577');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '欧·亨利', 'XKW-CHN-8578', '1', 5, '2', '0', 'admin', now(), 'xkw:8578'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8578');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杰克·伦敦', 'XKW-CHN-8580', '1', 6, '2', '0', 'admin', now(), 'xkw:8580'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8580');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '霍桑', 'XKW-CHN-8582', '2', 7, '2', '0', 'admin', now(), 'xkw:8582'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8582');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '福克纳', 'XKW-CHN-8583', '2', 8, '2', '0', 'admin', now(), 'xkw:8583'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8583');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '海明威', 'XKW-CHN-8584', '1', 9, '2', '0', 'admin', now(), 'xkw:8584'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8584');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杜鲁门', 'XKW-CHN-8586', '2', 10, '2', '0', 'admin', now(), 'xkw:8586'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8586');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '雷蒙德卡佛', 'XKW-CHN-8587', '2', 11, '2', '0', 'admin', now(), 'xkw:8587'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8587');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '亨利·大卫·梭罗', 'XKW-CHN-8588', '1', 12, '2', '0', 'admin', now(), 'xkw:8588'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8588');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '赫尔曼·梅尔维尔', 'XKW-CHN-8590', '1', 13, '2', '0', 'admin', now(), 'xkw:8590'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8590');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '罗伯特·弗罗斯特', 'XKW-CHN-8592', '2', 14, '2', '0', 'admin', now(), 'xkw:8592'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8592');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艾米莉·狄金森', 'XKW-CHN-8593', '2', 15, '2', '0', 'admin', now(), 'xkw:8593'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8593');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '爱默生', 'XKW-CHN-8594', '2', 16, '2', '0', 'admin', now(), 'xkw:8594'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8594');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艾萨克·辛格', 'XKW-CHN-8595', '2', 17, '2', '0', 'admin', now(), 'xkw:8595'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8595');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '埃德加·斯诺', 'XKW-CHN-8596', '2', 18, '2', '0', 'admin', now(), 'xkw:8596'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8572'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8596');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '易卜生', 'XKW-CHN-8598', '1', 1, '2', '0', 'admin', now(), 'xkw:8598'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8597'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8598');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '川端康成', 'XKW-CHN-8601', '2', 1, '2', '0', 'admin', now(), 'xkw:8601'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8601');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '村上春树', 'XKW-CHN-8602', '2', 2, '2', '0', 'admin', now(), 'xkw:8602'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8602');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '夏目漱石', 'XKW-CHN-8603', '2', 3, '2', '0', 'admin', now(), 'xkw:8603'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8603');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '渡边淳一', 'XKW-CHN-8604', '2', 4, '2', '0', 'admin', now(), 'xkw:8604'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8604');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '志贺直哉', 'XKW-CHN-8605', '2', 5, '2', '0', 'admin', now(), 'xkw:8605'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8605');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '伏尼契', 'XKW-CHN-8607', '1', 1, '2', '0', 'admin', now(), 'xkw:8607'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8606'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8607');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '高尔基', 'XKW-CHN-8610', '2', 1, '2', '0', 'admin', now(), 'xkw:8610'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8609'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8610');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '奥斯特洛夫斯基', 'XKW-CHN-8611', '1', 2, '2', '0', 'admin', now(), 'xkw:8611'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8609'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8611');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '肖洛霍夫', 'XKW-CHN-8613', '2', 3, '2', '0', 'admin', now(), 'xkw:8613'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8609'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8613');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '帕斯捷尔纳克', 'XKW-CHN-8614', '2', 4, '2', '0', 'admin', now(), 'xkw:8614'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8609'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8614');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '巴乌斯托夫斯基', 'XKW-CHN-8615', '2', 5, '2', '0', 'admin', now(), 'xkw:8615'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8609'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8615');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '塞万提斯', 'XKW-CHN-8617', '1', 1, '2', '0', 'admin', now(), 'xkw:8617'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8616'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8617');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '裴多菲', 'XKW-CHN-8620', '2', 1, '2', '0', 'admin', now(), 'xkw:8620'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8620');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '亚米契斯', 'XKW-CHN-8622', '2', 1, '2', '0', 'admin', now(), 'xkw:8622'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8621'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8622');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卡尔维诺', 'XKW-CHN-8623', '1', 2, '2', '0', 'admin', now(), 'xkw:8623'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8621'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8623');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '泰戈尔', 'XKW-CHN-8626', '1', 1, '2', '0', 'admin', now(), 'xkw:8626'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8625'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8626');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '莎士比亚', 'XKW-CHN-8630', '1', 1, '2', '0', 'admin', now(), 'xkw:8630'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8630');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '斯威夫特', 'XKW-CHN-8632', '1', 2, '2', '0', 'admin', now(), 'xkw:8632'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8632');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '奥斯汀', 'XKW-CHN-8634', '1', 3, '2', '0', 'admin', now(), 'xkw:8634'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8634');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '拜伦', 'XKW-CHN-8636', '2', 4, '2', '0', 'admin', now(), 'xkw:8636'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8636');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '雪莱', 'XKW-CHN-8637', '1', 5, '2', '0', 'admin', now(), 'xkw:8637'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8637');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '狄更斯', 'XKW-CHN-8640', '1', 6, '2', '0', 'admin', now(), 'xkw:8640'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8640');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '夏洛蒂·勃朗特', 'XKW-CHN-8642', '1', 7, '2', '0', 'admin', now(), 'xkw:8642'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8642');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '哈代', 'XKW-CHN-8644', '2', 8, '2', '0', 'admin', now(), 'xkw:8644'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8644');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '劳伦斯', 'XKW-CHN-8645', '2', 9, '2', '0', 'admin', now(), 'xkw:8645'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8645');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '培根', 'XKW-CHN-8646', '2', 10, '2', '0', 'admin', now(), 'xkw:8646'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8646');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '毛姆', 'XKW-CHN-8647', '1', 11, '2', '0', 'admin', now(), 'xkw:8647'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8647');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '奥斯卡·王尔德', 'XKW-CHN-8649', '2', 12, '2', '0', 'admin', now(), 'xkw:8649'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8649');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '彼得·梅尔', 'XKW-CHN-8650', '2', 13, '2', '0', 'admin', now(), 'xkw:8650'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8650');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'J·K·罗琳', 'XKW-CHN-8651', '2', 14, '2', '0', 'admin', now(), 'xkw:8651'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8651');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弗吉尼亚·伍尔夫', 'XKW-CHN-8652', '2', 15, '2', '0', 'admin', now(), 'xkw:8652'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8652');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '威廉·布莱克', 'XKW-CHN-8653', '2', 16, '2', '0', 'admin', now(), 'xkw:8653'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8629'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8653');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '帕斯', 'XKW-CHN-8655', '2', 1, '2', '0', 'admin', now(), 'xkw:8655'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8654'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8655');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卡里·纪伯伦', 'XKW-CHN-8657', '2', 1, '2', '0', 'admin', now(), 'xkw:8657'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8656'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8657');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '斯特林保', 'XKW-CHN-8660', '2', 1, '2', '0', 'admin', now(), 'xkw:8660'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8659'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8660');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '博尔赫斯', 'XKW-CHN-8662', '2', 1, '2', '0', 'admin', now(), 'xkw:8662'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8661'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8662');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '聂鲁达', 'XKW-CHN-8664', '2', 1, '2', '0', 'admin', now(), 'xkw:8664'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8663'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8664');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '对联', 'XKW-CHN-26193', '2', 1, '2', '0', 'admin', now(), 'xkw:26193'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26193');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '广告语', 'XKW-CHN-26195', '2', 2, '2', '0', 'admin', now(), 'xkw:26195'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26195');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宣传语', 'XKW-CHN-26194', '2', 3, '2', '0', 'admin', now(), 'xkw:26194'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26194');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '赠言', 'XKW-CHN-180581', '2', 4, '2', '0', 'admin', now(), 'xkw:180581'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180581');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '墓志铭', 'XKW-CHN-180582', '2', 5, '2', '0', 'admin', now(), 'xkw:180582'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180582');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '短信、微信', 'XKW-CHN-26197', '2', 6, '2', '0', 'admin', now(), 'xkw:26197'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26197');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '串联词', 'XKW-CHN-26198', '2', 7, '2', '0', 'admin', now(), 'xkw:26198'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26198');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '劝说词', 'XKW-CHN-26201', '2', 8, '2', '0', 'admin', now(), 'xkw:26201'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26201');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '请假条', 'XKW-CHN-180584', '2', 9, '2', '0', 'admin', now(), 'xkw:180584'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180584');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '祝寿词', 'XKW-CHN-180585', '2', 10, '2', '0', 'admin', now(), 'xkw:180585'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180585');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '答谢词', 'XKW-CHN-180586', '2', 11, '2', '0', 'admin', now(), 'xkw:180586'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180586');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宣传海报', 'XKW-CHN-180587', '2', 12, '2', '0', 'admin', now(), 'xkw:180587'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180587');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '借条、欠条、收条', 'XKW-CHN-180588', '2', 13, '2', '0', 'admin', now(), 'xkw:180588'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180588');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '推荐语', 'XKW-CHN-180589', '2', 14, '2', '0', 'admin', now(), 'xkw:180589'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180589');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '辩论词', 'XKW-CHN-180590', '2', 15, '2', '0', 'admin', now(), 'xkw:180590'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180590');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '忠告', 'XKW-CHN-180591', '2', 16, '2', '0', 'admin', now(), 'xkw:180591'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180591');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '潜台词', 'XKW-CHN-184060', '2', 17, '2', '0', 'admin', now(), 'xkw:184060'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26190'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-184060');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '道歉信', 'XKW-CHN-180597', '2', 1, '2', '0', 'admin', now(), 'xkw:180597'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180597');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '推荐信', 'XKW-CHN-180596', '2', 2, '2', '0', 'admin', now(), 'xkw:180596'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180596');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '介绍信', 'XKW-CHN-180595', '2', 3, '2', '0', 'admin', now(), 'xkw:180595'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180595');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '求职信', 'XKW-CHN-180594', '2', 4, '2', '0', 'admin', now(), 'xkw:180594'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180594');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自荐信', 'XKW-CHN-180592', '2', 5, '2', '0', 'admin', now(), 'xkw:180592'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180592');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '感谢信', 'XKW-CHN-180593', '2', 6, '2', '0', 'admin', now(), 'xkw:180593'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180593');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自我介绍', 'XKW-CHN-180583', '2', 7, '2', '0', 'admin', now(), 'xkw:180583'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180583');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '演讲辞、演讲稿', 'XKW-CHN-26206', '2', 8, '2', '0', 'admin', now(), 'xkw:26206'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26206');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '申请书', 'XKW-CHN-26207', '2', 9, '2', '0', 'admin', now(), 'xkw:26207'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26207');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '活动总结', 'XKW-CHN-26209', '2', 10, '2', '0', 'admin', now(), 'xkw:26209'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26209');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '新闻稿', 'XKW-CHN-26210', '2', 11, '2', '0', 'admin', now(), 'xkw:26210'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26210');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '调查报告', 'XKW-CHN-26211', '2', 12, '2', '0', 'admin', now(), 'xkw:26211'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26211');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发言稿', 'XKW-CHN-180598', '2', 13, '2', '0', 'admin', now(), 'xkw:180598'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180598');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '通知', 'XKW-CHN-26202', '2', 14, '2', '0', 'admin', now(), 'xkw:26202'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26202');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '启事', 'XKW-CHN-26203', '2', 15, '2', '0', 'admin', now(), 'xkw:26203'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26203');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '留言条', 'XKW-CHN-180599', '2', 16, '2', '0', 'admin', now(), 'xkw:180599'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180599');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '建议书', 'XKW-CHN-180600', '2', 17, '2', '0', 'admin', now(), 'xkw:180600'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180600');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '说明书', 'XKW-CHN-180601', '2', 18, '2', '0', 'admin', now(), 'xkw:180601'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180601');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '倡议书', 'XKW-CHN-180602', '2', 19, '2', '0', 'admin', now(), 'xkw:180602'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180602');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '通告、公告', 'XKW-CHN-180603', '2', 20, '2', '0', 'admin', now(), 'xkw:180603'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180603');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '邀请函', 'XKW-CHN-180604', '2', 21, '2', '0', 'admin', now(), 'xkw:180604'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180604');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文学短评', 'XKW-CHN-180605', '2', 22, '2', '0', 'admin', now(), 'xkw:180605'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180605');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '新闻短评', 'XKW-CHN-180606', '2', 23, '2', '0', 'admin', now(), 'xkw:180606'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180606');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '论文提纲', 'XKW-CHN-180607', '2', 24, '2', '0', 'admin', now(), 'xkw:180607'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180607');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卷首语', 'XKW-CHN-180608', '2', 25, '2', '0', 'admin', now(), 'xkw:180608'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180608');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计划书/活动方案', 'XKW-CHN-180609', '2', 26, '2', '0', 'admin', now(), 'xkw:180609'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180609');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '请柬', 'XKW-CHN-180611', '2', 27, '2', '0', 'admin', now(), 'xkw:180611'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180611');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '解说词', 'XKW-CHN-180612', '2', 28, '2', '0', 'admin', now(), 'xkw:180612'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180612');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '广播稿', 'XKW-CHN-180613', '2', 29, '2', '0', 'admin', now(), 'xkw:180613'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180613');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '颁奖词', 'XKW-CHN-26200', '2', 30, '2', '0', 'admin', now(), 'xkw:26200'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26200');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '悼词', 'XKW-CHN-180615', '2', 31, '2', '0', 'admin', now(), 'xkw:180615'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180615');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宣誓词', 'XKW-CHN-180616', '2', 32, '2', '0', 'admin', now(), 'xkw:180616'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-180616');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '开场白', 'XKW-CHN-26199', '2', 33, '2', '0', 'admin', now(), 'xkw:26199'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-26192'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-26199');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诸子散文', 'XKW-CHN-192923', '2', 1, '2', '0', 'admin', now(), 'xkw:192923'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192922'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192923');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单篇论文', 'XKW-CHN-192924', '2', 2, '2', '0', 'admin', now(), 'xkw:192924'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192922'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192924');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '笔记', 'XKW-CHN-192926', '2', 1, '2', '0', 'admin', now(), 'xkw:192926'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192925'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192926');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杂记（山川、景物、人事记）', 'XKW-CHN-27861', '2', 2, '2', '0', 'admin', now(), 'xkw:27861'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192925'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-27861');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古体诗', 'XKW-CHN-157855', '2', 1, '2', '0', 'admin', now(), 'xkw:157855'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27865'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157855');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '近体诗（律诗和绝句）', 'XKW-CHN-157856', '2', 2, '2', '0', 'admin', now(), 'xkw:157856'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27865'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157856');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '豪放词', 'XKW-CHN-158631', '2', 1, '2', '0', 'admin', now(), 'xkw:158631'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27866'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-158631');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '婉约词', 'XKW-CHN-158632', '2', 2, '2', '0', 'admin', now(), 'xkw:158632'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27866'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-158632');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '元曲', 'XKW-CHN-158633', '2', 1, '2', '0', 'admin', now(), 'xkw:158633'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-27867'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-158633');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '炼字、诗眼', 'XKW-CHN-157872', '2', 1, '2', '0', 'admin', now(), 'xkw:157872'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157871'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157872');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '炼句', 'XKW-CHN-157873', '2', 2, '2', '0', 'admin', now(), 'xkw:157873'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157871'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157873');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言风格', 'XKW-CHN-157874', '2', 3, '2', '0', 'admin', now(), 'xkw:157874'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157871'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157874');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古诗中的人物形象', 'XKW-CHN-157868', '2', 1, '2', '0', 'admin', now(), 'xkw:157868'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157867'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157868');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古诗中的景物形象', 'XKW-CHN-157869', '2', 2, '2', '0', 'admin', now(), 'xkw:157869'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157867'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157869');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古诗中的事物形象', 'XKW-CHN-157870', '2', 3, '2', '0', 'admin', now(), 'xkw:157870'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-157867'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157870');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '修辞手法', 'XKW-CHN-157896', '2', 1, '2', '0', 'admin', now(), 'xkw:157896'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192930'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157896');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表达方式', 'XKW-CHN-192931', '2', 2, '2', '0', 'admin', now(), 'xkw:192931'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192930'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-192931');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表现手法', 'XKW-CHN-157889', '2', 3, '2', '0', 'admin', now(), 'xkw:157889'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192930'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157889');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '结构技巧', 'XKW-CHN-157897', '2', 4, '2', '0', 'admin', now(), 'xkw:157897'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-192930'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-157897');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《论语》', 'XKW-CHN-7902', '2', 1, '2', '0', 'admin', now(), 'xkw:7902'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7901'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7902');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《左传》', 'XKW-CHN-7904', '2', 1, '2', '0', 'admin', now(), 'xkw:7904'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7903'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7904');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《国语》', 'XKW-CHN-7905', '2', 2, '2', '0', 'admin', now(), 'xkw:7905'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7903'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7905');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《墨子》', 'XKW-CHN-7907', '2', 1, '2', '0', 'admin', now(), 'xkw:7907'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7906'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7907');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《老子》', 'XKW-CHN-7909', '2', 1, '2', '0', 'admin', now(), 'xkw:7909'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7909');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《孙子兵法》', 'XKW-CHN-7911', '2', 1, '2', '0', 'admin', now(), 'xkw:7911'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7910'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7911');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《中庸》', 'XKW-CHN-7913', '2', 1, '2', '0', 'admin', now(), 'xkw:7913'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7912'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7913');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《孟子》', 'XKW-CHN-7917', '2', 1, '2', '0', 'admin', now(), 'xkw:7917'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7916'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7917');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《庄子》', 'XKW-CHN-7919', '2', 1, '2', '0', 'admin', now(), 'xkw:7919'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7918'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7919');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《荀子》', 'XKW-CHN-7921', '2', 1, '2', '0', 'admin', now(), 'xkw:7921'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7920'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7921');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《韩非子》', 'XKW-CHN-7923', '2', 1, '2', '0', 'admin', now(), 'xkw:7923'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7922'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7923');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《吕氏春秋》', 'XKW-CHN-7925', '2', 1, '2', '0', 'admin', now(), 'xkw:7925'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7924'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7925');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《列子》', 'XKW-CHN-7927', '2', 1, '2', '0', 'admin', now(), 'xkw:7927'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7926'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7927');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《离骚》', 'XKW-CHN-7929', '2', 1, '2', '0', 'admin', now(), 'xkw:7929'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7929');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《过秦论》', 'XKW-CHN-7936', '2', 1, '2', '0', 'admin', now(), 'xkw:7936'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7936');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《史记》', 'XKW-CHN-7938', '2', 1, '2', '0', 'admin', now(), 'xkw:7938'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7937'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7938');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《说苑》', 'XKW-CHN-7940', '2', 1, '2', '0', 'admin', now(), 'xkw:7940'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7940');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《新序》（《战国策》整理）', 'XKW-CHN-7941', '2', 2, '2', '0', 'admin', now(), 'xkw:7941'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7941');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《汉书》', 'XKW-CHN-7945', '2', 1, '2', '0', 'admin', now(), 'xkw:7945'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7944'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7945');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《观沧海》', 'XKW-CHN-7949', '2', 1, '2', '0', 'admin', now(), 'xkw:7949'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7948'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7949');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《蒿里行》', 'XKW-CHN-7950', '2', 2, '2', '0', 'admin', now(), 'xkw:7950'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7948'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7950');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《出师表》', 'XKW-CHN-7952', '2', 1, '2', '0', 'admin', now(), 'xkw:7952'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7951'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7952');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《典论》', 'XKW-CHN-7954', '2', 1, '2', '0', 'admin', now(), 'xkw:7954'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7953'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7954');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《咏怀》', 'XKW-CHN-7957', '2', 1, '2', '0', 'admin', now(), 'xkw:7957'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7956'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7957');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《陈情表》', 'XKW-CHN-7961', '2', 1, '2', '0', 'admin', now(), 'xkw:7961'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7960'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7961');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《三国志》', 'XKW-CHN-7963', '2', 1, '2', '0', 'admin', now(), 'xkw:7963'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7962'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7963');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《桃花源记》', 'XKW-CHN-7968', '2', 1, '2', '0', 'admin', now(), 'xkw:7968'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7967'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7968');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《五柳先生传》', 'XKW-CHN-7969', '2', 2, '2', '0', 'admin', now(), 'xkw:7969'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7967'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7969');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《归园田居》', 'XKW-CHN-7970', '2', 3, '2', '0', 'admin', now(), 'xkw:7970'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7967'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7970');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《饮酒》', 'XKW-CHN-7971', '2', 4, '2', '0', 'admin', now(), 'xkw:7971'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7967'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7971');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《归去来兮辞》', 'XKW-CHN-7972', '2', 5, '2', '0', 'admin', now(), 'xkw:7972'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7967'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7972');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《搜神记》', 'XKW-CHN-7974', '2', 1, '2', '0', 'admin', now(), 'xkw:7974'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7973'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7974');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《兰亭集序》', 'XKW-CHN-7977', '2', 1, '2', '0', 'admin', now(), 'xkw:7977'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7976'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7977');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《后汉书》编撰', 'XKW-CHN-7981', '2', 1, '2', '0', 'admin', now(), 'xkw:7981'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7981');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《世说新语》', 'XKW-CHN-7983', '2', 1, '2', '0', 'admin', now(), 'xkw:7983'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7982'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7983');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《拟行路难》', 'XKW-CHN-7985', '2', 1, '2', '0', 'admin', now(), 'xkw:7985'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7984'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7985');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《与陈伯之书》', 'XKW-CHN-7988', '2', 1, '2', '0', 'admin', now(), 'xkw:7988'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7987'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7988');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《文心雕龙》', 'XKW-CHN-7990', '2', 1, '2', '0', 'admin', now(), 'xkw:7990'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7990');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《水经注》', 'XKW-CHN-7993', '2', 1, '2', '0', 'admin', now(), 'xkw:7993'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7992'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7993');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《文选》', 'XKW-CHN-7995', '2', 1, '2', '0', 'admin', now(), 'xkw:7995'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7994'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7995');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《滕王阁序》', 'XKW-CHN-7999', '2', 1, '2', '0', 'admin', now(), 'xkw:7999'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-7998'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-7999');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《春江花月夜》', 'XKW-CHN-8001', '2', 1, '2', '0', 'admin', now(), 'xkw:8001'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8001');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《感遇》', 'XKW-CHN-8003', '2', 1, '2', '0', 'admin', now(), 'xkw:8003'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8002'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8003');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《望月怀远》', 'XKW-CHN-8004', '2', 2, '2', '0', 'admin', now(), 'xkw:8004'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8002'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8004');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《从军行》', 'XKW-CHN-8006', '2', 1, '2', '0', 'admin', now(), 'xkw:8006'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8005'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8006');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《在狱咏蝉》', 'XKW-CHN-8009', '2', 1, '2', '0', 'admin', now(), 'xkw:8009'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8008'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8009');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《回乡偶书》', 'XKW-CHN-8011', '2', 1, '2', '0', 'admin', now(), 'xkw:8011'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8011');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《从军行》', 'XKW-CHN-8015', '2', 1, '2', '0', 'admin', now(), 'xkw:8015'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8015');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《芙蓉楼送辛渐》', 'XKW-CHN-8016', '2', 2, '2', '0', 'admin', now(), 'xkw:8016'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8016');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《梦游天姥吟留别》', 'XKW-CHN-8019', '2', 1, '2', '0', 'admin', now(), 'xkw:8019'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8018'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8019');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《行路难》', 'XKW-CHN-8020', '2', 2, '2', '0', 'admin', now(), 'xkw:8020'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8018'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8020');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《燕歌行》', 'XKW-CHN-8022', '2', 1, '2', '0', 'admin', now(), 'xkw:8022'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8021'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8022');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《别董大》', 'XKW-CHN-8023', '2', 2, '2', '0', 'admin', now(), 'xkw:8023'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8021'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8023');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《黄鹤楼》', 'XKW-CHN-8025', '2', 1, '2', '0', 'admin', now(), 'xkw:8025'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8024'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8025');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《潼关吏》', 'XKW-CHN-8027', '2', 1, '2', '0', 'admin', now(), 'xkw:8027'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8027');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《白雪歌送武判官归京》', 'XKW-CHN-8029', '2', 1, '2', '0', 'admin', now(), 'xkw:8029'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8028'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8029');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《观田家》', 'XKW-CHN-8032', '2', 1, '2', '0', 'admin', now(), 'xkw:8032'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8031'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8032');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《滁州西涧》', 'XKW-CHN-8033', '2', 2, '2', '0', 'admin', now(), 'xkw:8033'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8031'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8033');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《昌黎先生集》', 'XKW-CHN-8036', '2', 1, '2', '0', 'admin', now(), 'xkw:8036'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8035'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8036');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《陋室铭》', 'XKW-CHN-8038', '2', 1, '2', '0', 'admin', now(), 'xkw:8038'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8037'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8038');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《秦中吟》', 'XKW-CHN-8040', '2', 1, '2', '0', 'admin', now(), 'xkw:8040'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8039'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8040');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《长恨歌》', 'XKW-CHN-8041', '2', 2, '2', '0', 'admin', now(), 'xkw:8041'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8039'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8041');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《琵琶行》（并序）', 'XKW-CHN-8042', '2', 3, '2', '0', 'admin', now(), 'xkw:8042'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8039'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8042');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《钱塘湖春行》', 'XKW-CHN-8043', '2', 4, '2', '0', 'admin', now(), 'xkw:8043'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8039'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8043');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《捕蛇者说》', 'XKW-CHN-8045', '2', 1, '2', '0', 'admin', now(), 'xkw:8045'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8044'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8045');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《永州八记》', 'XKW-CHN-8046', '2', 2, '2', '0', 'admin', now(), 'xkw:8046'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8044'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8046');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《题李凝幽居》', 'XKW-CHN-8049', '2', 1, '2', '0', 'admin', now(), 'xkw:8049'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8048'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8049');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《雁门太守行》', 'XKW-CHN-8051', '2', 1, '2', '0', 'admin', now(), 'xkw:8051'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8050'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8051');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《赤壁》', 'XKW-CHN-8053', '2', 1, '2', '0', 'admin', now(), 'xkw:8053'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8052'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8053');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《过华清宫绝句》', 'XKW-CHN-8054', '2', 2, '2', '0', 'admin', now(), 'xkw:8054'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8052'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8054');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《无题》', 'XKW-CHN-8057', '2', 1, '2', '0', 'admin', now(), 'xkw:8057'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8057');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《夜雨寄北》', 'XKW-CHN-8058', '2', 2, '2', '0', 'admin', now(), 'xkw:8058'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8058');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《蜂》', 'XKW-CHN-8060', '2', 1, '2', '0', 'admin', now(), 'xkw:8060'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8059'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8060');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《晋书》', 'XKW-CHN-8062', '2', 1, '2', '0', 'admin', now(), 'xkw:8062'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8061'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8062');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《梁书》', 'XKW-CHN-8064', '2', 1, '2', '0', 'admin', now(), 'xkw:8064'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8063'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8064');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《陈书》', 'XKW-CHN-8065', '2', 2, '2', '0', 'admin', now(), 'xkw:8065'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8063'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8065');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《北齐书》', 'XKW-CHN-8067', '2', 1, '2', '0', 'admin', now(), 'xkw:8067'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8066'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8067');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《周书》', 'XKW-CHN-8069', '2', 1, '2', '0', 'admin', now(), 'xkw:8069'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8068'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8069');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《隋书》', 'XKW-CHN-8071', '2', 1, '2', '0', 'admin', now(), 'xkw:8071'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8070'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8071');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《史通》', 'XKW-CHN-8075', '2', 1, '2', '0', 'admin', now(), 'xkw:8075'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8074'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8075');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《虞美人》', 'XKW-CHN-8081', '2', 1, '2', '0', 'admin', now(), 'xkw:8081'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8080'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8081');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《浪淘沙》', 'XKW-CHN-8082', '2', 2, '2', '0', 'admin', now(), 'xkw:8082'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8080'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8082');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《宋书》', 'XKW-CHN-8084', '2', 1, '2', '0', 'admin', now(), 'xkw:8084'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8083'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8084');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《南齐书》', 'XKW-CHN-8086', '2', 1, '2', '0', 'admin', now(), 'xkw:8086'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8085'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8086');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《魏书》', 'XKW-CHN-8088', '2', 1, '2', '0', 'admin', now(), 'xkw:8088'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8087'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8088');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《旧唐书》', 'XKW-CHN-8090', '2', 1, '2', '0', 'admin', now(), 'xkw:8090'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8089'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8090');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《雨霖铃》', 'XKW-CHN-8094', '2', 1, '2', '0', 'admin', now(), 'xkw:8094'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8093'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8094');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《少年游》', 'XKW-CHN-8095', '2', 2, '2', '0', 'admin', now(), 'xkw:8095'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8093'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8095');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《望海潮》', 'XKW-CHN-8096', '2', 3, '2', '0', 'admin', now(), 'xkw:8096'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8093'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8096');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《岳阳楼记》', 'XKW-CHN-8098', '2', 1, '2', '0', 'admin', now(), 'xkw:8098'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8097'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8098');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《踏莎行》', 'XKW-CHN-8101', '2', 1, '2', '0', 'admin', now(), 'xkw:8101'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8100'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8101');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《玉楼春》', 'XKW-CHN-8103', '2', 1, '2', '0', 'admin', now(), 'xkw:8103'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8102'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8103');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《新唐书》', 'XKW-CHN-8105', '2', 1, '2', '0', 'admin', now(), 'xkw:8105'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8105');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《新五代史》', 'XKW-CHN-8106', '2', 2, '2', '0', 'admin', now(), 'xkw:8106'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8106');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《六国论》', 'XKW-CHN-8108', '2', 1, '2', '0', 'admin', now(), 'xkw:8108'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8108');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《爱莲说》', 'XKW-CHN-8110', '2', 1, '2', '0', 'admin', now(), 'xkw:8110'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8110');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《资治通鉴》', 'XKW-CHN-8112', '2', 1, '2', '0', 'admin', now(), 'xkw:8112'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8111'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8112');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《桂枝香》', 'XKW-CHN-8114', '2', 1, '2', '0', 'admin', now(), 'xkw:8114'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8113'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8114');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《泊船瓜洲》', 'XKW-CHN-8115', '2', 2, '2', '0', 'admin', now(), 'xkw:8115'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8113'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8115');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《梦溪笔谈》', 'XKW-CHN-8117', '2', 1, '2', '0', 'admin', now(), 'xkw:8117'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8116'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8117');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《水调歌头》', 'XKW-CHN-8119', '2', 1, '2', '0', 'admin', now(), 'xkw:8119'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8119');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《念奴娇》', 'XKW-CHN-8120', '2', 2, '2', '0', 'admin', now(), 'xkw:8120'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8120');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《赤壁赋》', 'XKW-CHN-8121', '2', 3, '2', '0', 'admin', now(), 'xkw:8121'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8121');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《上枢密韩太尉书》', 'XKW-CHN-8123', '2', 1, '2', '0', 'admin', now(), 'xkw:8123'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8122'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8123');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《黄州快哉亭记》', 'XKW-CHN-8124', '2', 2, '2', '0', 'admin', now(), 'xkw:8124'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8122'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8124');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《鹊桥仙》', 'XKW-CHN-8128', '2', 1, '2', '0', 'admin', now(), 'xkw:8128'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8127'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8128');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《青玉案》', 'XKW-CHN-8130', '2', 1, '2', '0', 'admin', now(), 'xkw:8130'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8130');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《声声慢》', 'XKW-CHN-8133', '2', 1, '2', '0', 'admin', now(), 'xkw:8133'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8132'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8133');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《一剪梅》', 'XKW-CHN-8134', '2', 2, '2', '0', 'admin', now(), 'xkw:8134'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8132'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8134');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《旧五代史》', 'XKW-CHN-8136', '2', 1, '2', '0', 'admin', now(), 'xkw:8136'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8135'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8136');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《满江红》', 'XKW-CHN-8142', '2', 1, '2', '0', 'admin', now(), 'xkw:8142'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8141'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8142');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《关山月》', 'XKW-CHN-8144', '2', 1, '2', '0', 'admin', now(), 'xkw:8144'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8143'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8144');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《书愤》', 'XKW-CHN-8145', '2', 2, '2', '0', 'admin', now(), 'xkw:8145'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8143'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8145');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《诉衷情》', 'XKW-CHN-8146', '2', 3, '2', '0', 'admin', now(), 'xkw:8146'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8143'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8146');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《诚斋集》', 'XKW-CHN-8148', '2', 1, '2', '0', 'admin', now(), 'xkw:8148'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8147'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8148');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《四书章句集注》', 'XKW-CHN-8150', '2', 1, '2', '0', 'admin', now(), 'xkw:8150'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8149'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8150');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《楚辞集注》', 'XKW-CHN-8151', '2', 2, '2', '0', 'admin', now(), 'xkw:8151'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8149'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8151');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《于湖居士文集》', 'XKW-CHN-8153', '2', 1, '2', '0', 'admin', now(), 'xkw:8153'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8152'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8153');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《青玉案》', 'XKW-CHN-8155', '2', 1, '2', '0', 'admin', now(), 'xkw:8155'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8154'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8155');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《菩萨蛮》', 'XKW-CHN-8156', '2', 2, '2', '0', 'admin', now(), 'xkw:8156'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8154'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8156');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《扬州慢》', 'XKW-CHN-8158', '2', 1, '2', '0', 'admin', now(), 'xkw:8158'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8157'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8158');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《窦娥冤》', 'XKW-CHN-8164', '2', 1, '2', '0', 'admin', now(), 'xkw:8164'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8163'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8164');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《西厢记》', 'XKW-CHN-8166', '2', 1, '2', '0', 'admin', now(), 'xkw:8166'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8165'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8166');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《汉宫秋》', 'XKW-CHN-8168', '2', 1, '2', '0', 'admin', now(), 'xkw:8168'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8167'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8168');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《天净沙》', 'XKW-CHN-8169', '2', 2, '2', '0', 'admin', now(), 'xkw:8169'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8167'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8169');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《水浒传》', 'XKW-CHN-8175', '2', 1, '2', '0', 'admin', now(), 'xkw:8175'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8174'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8175');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《宋史》', 'XKW-CHN-8177', '2', 1, '2', '0', 'admin', now(), 'xkw:8177'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8176'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8177');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《辽史》', 'XKW-CHN-8178', '2', 2, '2', '0', 'admin', now(), 'xkw:8178'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8176'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8178');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《金史》', 'XKW-CHN-8179', '2', 3, '2', '0', 'admin', now(), 'xkw:8179'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8176'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8179');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《元史》', 'XKW-CHN-8183', '2', 1, '2', '0', 'admin', now(), 'xkw:8183'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8183');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《卖柑者言》', 'XKW-CHN-8185', '2', 1, '2', '0', 'admin', now(), 'xkw:8185'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8184'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8185');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《三国演义》', 'XKW-CHN-8187', '2', 1, '2', '0', 'admin', now(), 'xkw:8187'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8186'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8187');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《西游记》', 'XKW-CHN-8190', '2', 1, '2', '0', 'admin', now(), 'xkw:8190'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8189'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8190');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《项脊轩志》', 'XKW-CHN-8192', '2', 1, '2', '0', 'admin', now(), 'xkw:8192'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8191'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8192');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《牡丹亭》', 'XKW-CHN-8194', '2', 1, '2', '0', 'admin', now(), 'xkw:8194'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8193'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8194');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《袁中郎全集》', 'XKW-CHN-8196', '2', 1, '2', '0', 'admin', now(), 'xkw:8196'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8195'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8196');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《警世通言》', 'XKW-CHN-8198', '2', 1, '2', '0', 'admin', now(), 'xkw:8198'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8197'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8198');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《徐霞客游记》', 'XKW-CHN-8200', '2', 1, '2', '0', 'admin', now(), 'xkw:8200'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8199'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8200');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《核舟记》', 'XKW-CHN-8202', '2', 1, '2', '0', 'admin', now(), 'xkw:8202'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8201'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8202');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《五人墓碑记》', 'XKW-CHN-8204', '2', 1, '2', '0', 'admin', now(), 'xkw:8204'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8204');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《陶庵梦忆》', 'XKW-CHN-8210', '2', 1, '2', '0', 'admin', now(), 'xkw:8210'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8209'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8210');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《闲情偶寄》', 'XKW-CHN-8212', '2', 1, '2', '0', 'admin', now(), 'xkw:8212'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8211'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8212');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《复庵记》', 'XKW-CHN-8214', '2', 1, '2', '0', 'admin', now(), 'xkw:8214'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8214');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《聊斋志异》', 'XKW-CHN-8217', '2', 1, '2', '0', 'admin', now(), 'xkw:8217'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8216'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8217');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《桃花扇》', 'XKW-CHN-8220', '2', 1, '2', '0', 'admin', now(), 'xkw:8220'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8219'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8220');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《饮水集》', 'XKW-CHN-8223', '2', 1, '2', '0', 'admin', now(), 'xkw:8223'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8222'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8223');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《狱中杂记》', 'XKW-CHN-8225', '2', 1, '2', '0', 'admin', now(), 'xkw:8225'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8224'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8225');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《儒林外史》', 'XKW-CHN-8227', '2', 1, '2', '0', 'admin', now(), 'xkw:8227'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8226'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8227');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《鲒埼亭集》', 'XKW-CHN-8229', '2', 1, '2', '0', 'admin', now(), 'xkw:8229'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8228'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8229');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《红楼梦》', 'XKW-CHN-8231', '2', 1, '2', '0', 'admin', now(), 'xkw:8231'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8230'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8231');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《随园诗话》', 'XKW-CHN-8233', '2', 1, '2', '0', 'admin', now(), 'xkw:8233'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8232'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8233');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《登泰山记》', 'XKW-CHN-8235', '2', 1, '2', '0', 'admin', now(), 'xkw:8235'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8234'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8235');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《己亥杂诗》', 'XKW-CHN-8237', '2', 1, '2', '0', 'admin', now(), 'xkw:8237'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8236'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8237');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《明史》', 'XKW-CHN-8239', '2', 1, '2', '0', 'admin', now(), 'xkw:8239'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8238'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8239');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《老残游记》', 'XKW-CHN-8246', '2', 1, '2', '0', 'admin', now(), 'xkw:8246'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8245'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8246');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《人间词话》', 'XKW-CHN-8250', '2', 1, '2', '0', 'admin', now(), 'xkw:8250'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8250');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《阿Q正传》', 'XKW-CHN-8255', '2', 1, '2', '0', 'admin', now(), 'xkw:8255'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8254'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8255');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《孔乙己》', 'XKW-CHN-8256', '2', 2, '2', '0', 'admin', now(), 'xkw:8256'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8254'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8256');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《拿来主义》', 'XKW-CHN-8257', '2', 3, '2', '0', 'admin', now(), 'xkw:8257'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8254'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8257');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《记念刘和珍君》', 'XKW-CHN-8258', '2', 4, '2', '0', 'admin', now(), 'xkw:8258'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8254'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8258');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《女神》', 'XKW-CHN-8263', '2', 1, '2', '0', 'admin', now(), 'xkw:8263'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8263');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《屈原》', 'XKW-CHN-8264', '2', 2, '2', '0', 'admin', now(), 'xkw:8264'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8264');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《沁园春 雪》', 'XKW-CHN-8266', '2', 1, '2', '0', 'admin', now(), 'xkw:8266'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8265'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8266');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《沁园春 长沙》', 'XKW-CHN-8267', '2', 2, '2', '0', 'admin', now(), 'xkw:8267'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8265'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8267');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《夜》', 'XKW-CHN-8271', '2', 1, '2', '0', 'admin', now(), 'xkw:8271'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8270'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8271');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《中国哲学简史》', 'XKW-CHN-8274', '2', 1, '2', '0', 'admin', now(), 'xkw:8274'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8274');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《京华烟云》', 'XKW-CHN-8276', '2', 1, '2', '0', 'admin', now(), 'xkw:8276'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8276');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《子夜》', 'XKW-CHN-8278', '2', 1, '2', '0', 'admin', now(), 'xkw:8278'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8278');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《林家铺子》', 'XKW-CHN-8279', '2', 2, '2', '0', 'admin', now(), 'xkw:8279'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8279');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《春风沉醉的晚上》', 'XKW-CHN-8281', '2', 1, '2', '0', 'admin', now(), 'xkw:8281'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8280'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8281');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《故都的秋》', 'XKW-CHN-8282', '2', 2, '2', '0', 'admin', now(), 'xkw:8282'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8280'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8282');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《志摩的诗》', 'XKW-CHN-8284', '2', 1, '2', '0', 'admin', now(), 'xkw:8284'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8283'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8284');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《翡冷翠的一夜》', 'XKW-CHN-8285', '2', 2, '2', '0', 'admin', now(), 'xkw:8285'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8283'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8285');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《悲剧心理学》', 'XKW-CHN-8287', '2', 1, '2', '0', 'admin', now(), 'xkw:8287'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8286'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8287');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《咬文嚼字》', 'XKW-CHN-8288', '2', 2, '2', '0', 'admin', now(), 'xkw:8288'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8286'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8288');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《荷塘月色》', 'XKW-CHN-8291', '2', 1, '2', '0', 'admin', now(), 'xkw:8291'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8290'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8291');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《红烛》', 'XKW-CHN-8296', '2', 1, '2', '0', 'admin', now(), 'xkw:8296'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8295'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8296');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《死水》', 'XKW-CHN-8297', '2', 2, '2', '0', 'admin', now(), 'xkw:8297'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8295'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8297');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《骆驼祥子》', 'XKW-CHN-8299', '2', 1, '2', '0', 'admin', now(), 'xkw:8299'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8298'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8299');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《龙须沟》', 'XKW-CHN-8300', '2', 2, '2', '0', 'admin', now(), 'xkw:8300'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8298'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8300');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《茶馆》', 'XKW-CHN-8301', '2', 3, '2', '0', 'admin', now(), 'xkw:8301'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8298'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8301');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《包身工》', 'XKW-CHN-8304', '2', 1, '2', '0', 'admin', now(), 'xkw:8304'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8303'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8304');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《二月》', 'XKW-CHN-8309', '2', 1, '2', '0', 'admin', now(), 'xkw:8309'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8308'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8309');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《为奴隶的母亲》', 'XKW-CHN-8310', '2', 2, '2', '0', 'admin', now(), 'xkw:8310'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8308'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8310');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《边城》', 'XKW-CHN-8312', '2', 1, '2', '0', 'admin', now(), 'xkw:8312'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8311'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8312');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《长河》', 'XKW-CHN-8313', '2', 2, '2', '0', 'admin', now(), 'xkw:8313'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8311'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8313');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《湘行散记》', 'XKW-CHN-8314', '2', 3, '2', '0', 'admin', now(), 'xkw:8314'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8311'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8314');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《雅舍小品》', 'XKW-CHN-8318', '2', 1, '2', '0', 'admin', now(), 'xkw:8318'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8317'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8318');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《雾》', 'XKW-CHN-8320', '2', 1, '2', '0', 'admin', now(), 'xkw:8320'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8319'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8320');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《家》', 'XKW-CHN-8321', '2', 2, '2', '0', 'admin', now(), 'xkw:8321'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8319'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8321');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《春》', 'XKW-CHN-8322', '2', 3, '2', '0', 'admin', now(), 'xkw:8322'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8319'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8322');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《太阳照在桑干河上》', 'XKW-CHN-8325', '2', 1, '2', '0', 'admin', now(), 'xkw:8325'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8324'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8325');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《小二黑结婚》', 'XKW-CHN-8330', '2', 1, '2', '0', 'admin', now(), 'xkw:8330'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8329'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8330');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《李有才板话》', 'XKW-CHN-8331', '2', 2, '2', '0', 'admin', now(), 'xkw:8331'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8329'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8331');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《华威先生》', 'XKW-CHN-8333', '2', 1, '2', '0', 'admin', now(), 'xkw:8333'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8332'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8333');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《八月的乡村》', 'XKW-CHN-8336', '2', 1, '2', '0', 'admin', now(), 'xkw:8336'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8335'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8336');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《暴风骤雨》', 'XKW-CHN-8338', '2', 1, '2', '0', 'admin', now(), 'xkw:8338'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8337'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8338');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《山乡巨变》', 'XKW-CHN-8339', '2', 2, '2', '0', 'admin', now(), 'xkw:8339'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8337'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8339');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《雷雨》', 'XKW-CHN-8344', '2', 1, '2', '0', 'admin', now(), 'xkw:8344'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8344');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《日出》', 'XKW-CHN-8345', '2', 2, '2', '0', 'admin', now(), 'xkw:8345'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8345');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《原野》', 'XKW-CHN-8346', '2', 3, '2', '0', 'admin', now(), 'xkw:8346'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8346');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《我爱这土地》', 'XKW-CHN-8348', '2', 1, '2', '0', 'admin', now(), 'xkw:8348'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8347'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8348');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《大堰河-我的保姆》', 'XKW-CHN-8349', '2', 2, '2', '0', 'admin', now(), 'xkw:8349'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8347'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8349');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《给乌兰诺娃》', 'XKW-CHN-8350', '2', 3, '2', '0', 'admin', now(), 'xkw:8350'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8347'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8350');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《写在人生边上》', 'XKW-CHN-8352', '2', 1, '2', '0', 'admin', now(), 'xkw:8352'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8351'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8352');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《围城》', 'XKW-CHN-8353', '2', 2, '2', '0', 'admin', now(), 'xkw:8353'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8351'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8353');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《红日》', 'XKW-CHN-8356', '2', 1, '2', '0', 'admin', now(), 'xkw:8356'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8355'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8356');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《生死场》', 'XKW-CHN-8358', '2', 1, '2', '0', 'admin', now(), 'xkw:8358'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8357'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8358');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《小城三月》', 'XKW-CHN-8359', '2', 2, '2', '0', 'admin', now(), 'xkw:8359'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8357'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8359');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《呼兰河传》', 'XKW-CHN-8360', '2', 3, '2', '0', 'admin', now(), 'xkw:8360'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8357'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8360');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《荷花淀》', 'XKW-CHN-8362', '2', 1, '2', '0', 'admin', now(), 'xkw:8362'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8361'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8362');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《芦花荡》', 'XKW-CHN-8363', '2', 2, '2', '0', 'admin', now(), 'xkw:8363'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8361'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8363');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《青春之歌》', 'XKW-CHN-8367', '2', 1, '2', '0', 'admin', now(), 'xkw:8367'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8366'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8367');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《创业史》', 'XKW-CHN-8369', '2', 1, '2', '0', 'admin', now(), 'xkw:8369'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8368'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8369');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《长江三峡》', 'XKW-CHN-8371', '2', 1, '2', '0', 'admin', now(), 'xkw:8371'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8370'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8371');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《大淖记事》', 'XKW-CHN-8377', '2', 1, '2', '0', 'admin', now(), 'xkw:8377'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8376'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8377');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《受戒》', 'XKW-CHN-8378', '2', 2, '2', '0', 'admin', now(), 'xkw:8378'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8376'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8378');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《保卫延安》', 'XKW-CHN-8380', '2', 1, '2', '0', 'admin', now(), 'xkw:8380'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8380');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《海啸》', 'XKW-CHN-8382', '2', 1, '2', '0', 'admin', now(), 'xkw:8382'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8381'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8382');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《林海雪原》', 'XKW-CHN-8384', '2', 1, '2', '0', 'admin', now(), 'xkw:8384'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8383'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8384');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《雨巷》《我的记忆》', 'XKW-CHN-8388', '2', 1, '2', '0', 'admin', now(), 'xkw:8388'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8387'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8388');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《囚绿记》《海星》', 'XKW-CHN-8390', '2', 1, '2', '0', 'admin', now(), 'xkw:8390'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8389'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8390');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《红旗谱》', 'XKW-CHN-8393', '2', 1, '2', '0', 'admin', now(), 'xkw:8393'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8392'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8393');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《断章》', 'XKW-CHN-8398', '2', 1, '2', '0', 'admin', now(), 'xkw:8398'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8397'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8398');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《乡土中国》', 'XKW-CHN-8404', '2', 1, '2', '0', 'admin', now(), 'xkw:8404'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8403'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8404');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《缘缘堂随笔》', 'XKW-CHN-8406', '2', 1, '2', '0', 'admin', now(), 'xkw:8406'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8405'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8406');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《笑傲江湖》', 'XKW-CHN-8410', '2', 1, '2', '0', 'admin', now(), 'xkw:8410'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8409'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8410');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《射雕英雄传》', 'XKW-CHN-8411', '2', 2, '2', '0', 'admin', now(), 'xkw:8411'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8409'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8411');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《静静的产院》', 'XKW-CHN-8413', '2', 1, '2', '0', 'admin', now(), 'xkw:8413'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8412'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8413');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《百合花》', 'XKW-CHN-8414', '2', 2, '2', '0', 'admin', now(), 'xkw:8414'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8412'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8414');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《围墙》', 'XKW-CHN-8416', '2', 1, '2', '0', 'admin', now(), 'xkw:8416'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8415'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8416');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《陈奂生上城》', 'XKW-CHN-8418', '2', 1, '2', '0', 'admin', now(), 'xkw:8418'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8418');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《红豆》', 'XKW-CHN-8420', '2', 1, '2', '0', 'admin', now(), 'xkw:8420'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8419'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8420');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《高山下的花环》', 'XKW-CHN-8422', '2', 1, '2', '0', 'admin', now(), 'xkw:8422'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8421'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8422');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《乡愁》', 'XKW-CHN-8424', '2', 1, '2', '0', 'admin', now(), 'xkw:8424'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8423'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8424');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《普通劳动者》', 'XKW-CHN-8426', '2', 1, '2', '0', 'admin', now(), 'xkw:8426'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8425'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8426');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《青春万岁》', 'XKW-CHN-8430', '2', 1, '2', '0', 'admin', now(), 'xkw:8430'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8429'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8430');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《蒲柳人家》', 'XKW-CHN-8432', '2', 1, '2', '0', 'admin', now(), 'xkw:8432'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8432');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《从森林里来的孩子》', 'XKW-CHN-8435', '2', 1, '2', '0', 'admin', now(), 'xkw:8435'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8434'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8435');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《乔厂长上任记》', 'XKW-CHN-8437', '2', 1, '2', '0', 'admin', now(), 'xkw:8437'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8437');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《白鹿原》', 'XKW-CHN-8441', '2', 1, '2', '0', 'admin', now(), 'xkw:8441'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8440'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8441');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《平凡的世界》', 'XKW-CHN-8445', '2', 1, '2', '0', 'admin', now(), 'xkw:8445'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8444'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8445');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《人生》', 'XKW-CHN-8446', '2', 2, '2', '0', 'admin', now(), 'xkw:8446'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8444'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8446');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《秦腔》', 'XKW-CHN-8449', '2', 1, '2', '0', 'admin', now(), 'xkw:8449'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8448'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8449');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《生死疲劳》', 'XKW-CHN-8451', '2', 1, '2', '0', 'admin', now(), 'xkw:8451'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8451');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《蛙》', 'XKW-CHN-8452', '2', 2, '2', '0', 'admin', now(), 'xkw:8452'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8452');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《红高粱》', 'XKW-CHN-8453', '2', 3, '2', '0', 'admin', now(), 'xkw:8453'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8453');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《活着》', 'XKW-CHN-8455', '2', 1, '2', '0', 'admin', now(), 'xkw:8455'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8454'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8455');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《许三观卖血记》', 'XKW-CHN-8456', '2', 2, '2', '0', 'admin', now(), 'xkw:8456'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8454'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8456');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《我与地坛》《务虚笔记》', 'XKW-CHN-8460', '2', 1, '2', '0', 'admin', now(), 'xkw:8460'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8459'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8460');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《我的遥远的清平湾》', 'XKW-CHN-8461', '2', 2, '2', '0', 'admin', now(), 'xkw:8461'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8459'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8461');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《棋王》', 'XKW-CHN-8464', '2', 1, '2', '0', 'admin', now(), 'xkw:8464'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8463'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8464');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《相信未来》', 'XKW-CHN-8471', '2', 1, '2', '0', 'admin', now(), 'xkw:8471'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8470'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8471');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《北方的河》', 'XKW-CHN-8473', '2', 1, '2', '0', 'admin', now(), 'xkw:8473'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8472'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8473');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《黑骏马》', 'XKW-CHN-8474', '2', 2, '2', '0', 'admin', now(), 'xkw:8474'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8472'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8474');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《文化苦旅》', 'XKW-CHN-8476', '2', 1, '2', '0', 'admin', now(), 'xkw:8476'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8475'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8476');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《致橡树》', 'XKW-CHN-8481', '2', 1, '2', '0', 'admin', now(), 'xkw:8481'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8480'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8481');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《错误》', 'XKW-CHN-8484', '2', 1, '2', '0', 'admin', now(), 'xkw:8484'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8483'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8484');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《一个人的村庄》', 'XKW-CHN-8487', '2', 1, '2', '0', 'admin', now(), 'xkw:8487'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8486'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8487');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《哦，香雪》', 'XKW-CHN-8499', '2', 1, '2', '0', 'admin', now(), 'xkw:8499'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8498'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8499');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《变形记》', 'XKW-CHN-8510', '2', 1, '2', '0', 'admin', now(), 'xkw:8510'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8509'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8510');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《安娜·卡列尼娜》', 'XKW-CHN-8532', '2', 1, '2', '0', 'admin', now(), 'xkw:8532'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8531'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8532');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《变色龙》', 'XKW-CHN-8534', '2', 1, '2', '0', 'admin', now(), 'xkw:8534'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8533'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8534');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《伪君子》', 'XKW-CHN-8539', '2', 1, '2', '0', 'admin', now(), 'xkw:8539'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8538'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8539');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《巴黎圣母院》', 'XKW-CHN-8542', '2', 1, '2', '0', 'admin', now(), 'xkw:8542'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8541'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8542');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《悲惨世界》', 'XKW-CHN-8543', '2', 2, '2', '0', 'admin', now(), 'xkw:8543'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8541'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8543');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《基督山伯爵》', 'XKW-CHN-8545', '2', 1, '2', '0', 'admin', now(), 'xkw:8545'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8544'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8545');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《红与黑》', 'XKW-CHN-8547', '2', 1, '2', '0', 'admin', now(), 'xkw:8547'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8546'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8547');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《人间喜剧》', 'XKW-CHN-8550', '2', 1, '2', '0', 'admin', now(), 'xkw:8550'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8549'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8550');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《羊脂球》', 'XKW-CHN-8554', '2', 1, '2', '0', 'admin', now(), 'xkw:8554'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8553'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8554');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《项链》', 'XKW-CHN-8555', '2', 2, '2', '0', 'admin', now(), 'xkw:8555'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8553'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8555');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《最后一课》', 'XKW-CHN-8557', '2', 1, '2', '0', 'admin', now(), 'xkw:8557'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8556'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8557');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《百年孤独》', 'XKW-CHN-8561', '2', 1, '2', '0', 'admin', now(), 'xkw:8561'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8561');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《荷马史诗》', 'XKW-CHN-8566', '2', 1, '2', '0', 'admin', now(), 'xkw:8566'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8565'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8566');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《俄狄浦斯王》', 'XKW-CHN-8568', '2', 1, '2', '0', 'admin', now(), 'xkw:8568'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8567'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8568');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《飘》', 'XKW-CHN-8575', '2', 1, '2', '0', 'admin', now(), 'xkw:8575'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8574'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8575');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《麦琪的礼物》', 'XKW-CHN-8579', '2', 1, '2', '0', 'admin', now(), 'xkw:8579'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8578'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8579');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《热爱生命》', 'XKW-CHN-8581', '2', 1, '2', '0', 'admin', now(), 'xkw:8581'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8580'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8581');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《老人与海》', 'XKW-CHN-8585', '2', 1, '2', '0', 'admin', now(), 'xkw:8585'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8584'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8585');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《瓦尔登湖》', 'XKW-CHN-8589', '2', 1, '2', '0', 'admin', now(), 'xkw:8589'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8588'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8589');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《白鲸记》', 'XKW-CHN-8591', '2', 1, '2', '0', 'admin', now(), 'xkw:8591'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8590'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8591');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《玩偶之家》', 'XKW-CHN-8599', '2', 1, '2', '0', 'admin', now(), 'xkw:8599'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8598'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8599');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《牛虻》', 'XKW-CHN-8608', '2', 1, '2', '0', 'admin', now(), 'xkw:8608'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8607'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8608');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《钢铁是怎样炼成的》', 'XKW-CHN-8612', '2', 1, '2', '0', 'admin', now(), 'xkw:8612'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8611'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8612');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《堂吉诃德》', 'XKW-CHN-8618', '2', 1, '2', '0', 'admin', now(), 'xkw:8618'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8618');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《树上的男爵》', 'XKW-CHN-8624', '2', 1, '2', '0', 'admin', now(), 'xkw:8624'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8623'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8624');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《吉檀迦利》', 'XKW-CHN-8627', '2', 1, '2', '0', 'admin', now(), 'xkw:8627'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8626'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8627');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《飞鸟集》', 'XKW-CHN-8628', '2', 2, '2', '0', 'admin', now(), 'xkw:8628'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8626'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8628');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《哈姆雷特》', 'XKW-CHN-8631', '2', 1, '2', '0', 'admin', now(), 'xkw:8631'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8630'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8631');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《格列佛游记》', 'XKW-CHN-8633', '2', 1, '2', '0', 'admin', now(), 'xkw:8633'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8632'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8633');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《傲慢与偏见》', 'XKW-CHN-8635', '2', 1, '2', '0', 'admin', now(), 'xkw:8635'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8634'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8635');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《西风颂》', 'XKW-CHN-8638', '2', 1, '2', '0', 'admin', now(), 'xkw:8638'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8637'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8638');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《致云雀》', 'XKW-CHN-8639', '2', 2, '2', '0', 'admin', now(), 'xkw:8639'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8637'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8639');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《雾都孤儿》', 'XKW-CHN-8641', '2', 1, '2', '0', 'admin', now(), 'xkw:8641'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8640'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8641');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《简爱》', 'XKW-CHN-8643', '2', 1, '2', '0', 'admin', now(), 'xkw:8643'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8642'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8643');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '《月亮和六便士》', 'XKW-CHN-8648', '2', 1, '2', '0', 'admin', now(), 'xkw:8648'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-CHN-8647'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-CHN-8648');
