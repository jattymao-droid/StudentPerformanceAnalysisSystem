-- 高中英语知识点树（来源：组卷网 lk_12.json / gzyy）
-- 幂等：knowledge_code=XKW-ENG-{xkwId}
-- 导入：bash scripts/import_eng_xkw_knowledge.sh

INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
SELECT 'ENG', '英语', 4, '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'ENG');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT s.subject_id, 0, '0', '高中英语综合库', 'XKW-ENG-29978', '0', 1, '2', '0', 'admin', now(), 'xkw:29978'
FROM spas_subject s
WHERE s.subject_code = 'ENG'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-29978');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词汇', 'XKW-ENG-188736', '1', 1, '2', '0', 'admin', now(), 'xkw:188736'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188736');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语音', 'XKW-ENG-145384', '1', 2, '2', '0', 'admin', now(), 'xkw:145384'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-145384');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语法', 'XKW-ENG-29981', '1', 3, '2', '0', 'admin', now(), 'xkw:29981'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-29981');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主题', 'XKW-ENG-188768', '1', 4, '2', '0', 'admin', now(), 'xkw:188768'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188768');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语篇范围', 'XKW-ENG-148962', '1', 5, '2', '0', 'admin', now(), 'xkw:148962'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148962');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语用', 'XKW-ENG-188834', '1', 6, '2', '0', 'admin', now(), 'xkw:188834'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188834');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他', 'XKW-ENG-29983', '2', 7, '2', '0', 'admin', now(), 'xkw:29983'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-29983');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单词辨析', 'XKW-ENG-188737', '1', 1, '2', '0', 'admin', now(), 'xkw:188737'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188736'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188737');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '短语辨析', 'XKW-ENG-188741', '1', 2, '2', '0', 'admin', now(), 'xkw:188741'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188736'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188741');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语音认知', 'XKW-ENG-188745', '2', 1, '2', '0', 'admin', now(), 'xkw:188745'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-145384'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188745');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基本读音', 'XKW-ENG-188749', '2', 2, '2', '0', 'admin', now(), 'xkw:188749'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-145384'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188749');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重音', 'XKW-ENG-188757', '2', 3, '2', '0', 'admin', now(), 'xkw:188757'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-145384'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188757');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '意群', 'XKW-ENG-188760', '2', 4, '2', '0', 'admin', now(), 'xkw:188760'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-145384'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188760');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语调与节奏', 'XKW-ENG-188763', '2', 5, '2', '0', 'admin', now(), 'xkw:188763'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-145384'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188763');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单词的读音', 'XKW-ENG-188767', '2', 6, '2', '0', 'admin', now(), 'xkw:188767'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-145384'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188767');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时态', 'XKW-ENG-41682', '1', 1, '2', '0', 'admin', now(), 'xkw:41682'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41682');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '被动语态', 'XKW-ENG-41683', '1', 2, '2', '0', 'admin', now(), 'xkw:41683'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41683');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非谓语动词', 'XKW-ENG-41567', '1', 3, '2', '0', 'admin', now(), 'xkw:41567'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41567');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主谓一致', 'XKW-ENG-41714', '1', 4, '2', '0', 'admin', now(), 'xkw:41714'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41714');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词性从句', 'XKW-ENG-41733', '1', 5, '2', '0', 'admin', now(), 'xkw:41733'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41733');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '定语从句', 'XKW-ENG-41734', '1', 6, '2', '0', 'admin', now(), 'xkw:41734'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41734');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '状语从句', 'XKW-ENG-41735', '1', 7, '2', '0', 'admin', now(), 'xkw:41735'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41735');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词', 'XKW-ENG-41562', '1', 8, '2', '0', 'admin', now(), 'xkw:41562'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41562');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动词', 'XKW-ENG-41566', '1', 9, '2', '0', 'admin', now(), 'xkw:41566'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41566');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词', 'XKW-ENG-41638', '1', 10, '2', '0', 'admin', now(), 'xkw:41638'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41638');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词', 'XKW-ENG-41639', '1', 11, '2', '0', 'admin', now(), 'xkw:41639'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41639');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '代词', 'XKW-ENG-41563', '1', 12, '2', '0', 'admin', now(), 'xkw:41563'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41563');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '数词', 'XKW-ENG-41565', '1', 13, '2', '0', 'admin', now(), 'xkw:41565'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41565');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冠词', 'XKW-ENG-41564', '1', 14, '2', '0', 'admin', now(), 'xkw:41564'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41564');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '连词', 'XKW-ENG-41570', '1', 15, '2', '0', 'admin', now(), 'xkw:41570'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41570');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '介词', 'XKW-ENG-41569', '1', 16, '2', '0', 'admin', now(), 'xkw:41569'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41569');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情态动词', 'XKW-ENG-41611', '1', 17, '2', '0', 'admin', now(), 'xkw:41611'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41611');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '构词法', 'XKW-ENG-148965', '1', 18, '2', '0', 'admin', now(), 'xkw:148965'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148965');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气', 'XKW-ENG-41560', '1', 19, '2', '0', 'admin', now(), 'xkw:41560'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41560');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基本句型', 'XKW-ENG-153273', '1', 20, '2', '0', 'admin', now(), 'xkw:153273'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153273');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '句子成分', 'XKW-ENG-153281', '1', 21, '2', '0', 'admin', now(), 'xkw:153281'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153281');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '简单句', 'XKW-ENG-41711', '1', 22, '2', '0', 'admin', now(), 'xkw:41711'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41711');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '特殊句式', 'XKW-ENG-41713', '1', 23, '2', '0', 'admin', now(), 'xkw:41713'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-29981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41713');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人与自我', 'XKW-ENG-181230', '1', 1, '2', '0', 'admin', now(), 'xkw:181230'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188768'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181230');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人与社会', 'XKW-ENG-181244', '1', 2, '2', '0', 'admin', now(), 'xkw:181244'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188768'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181244');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人与自然', 'XKW-ENG-181278', '1', 3, '2', '0', 'admin', now(), 'xkw:181278'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188768'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181278');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体裁分类', 'XKW-ENG-149097', '1', 1, '2', '0', 'admin', now(), 'xkw:149097'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148962'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149097');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '题型分类', 'XKW-ENG-149098', '1', 2, '2', '0', 'admin', now(), 'xkw:149098'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148962'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149098');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '常识', 'XKW-ENG-188835', '2', 1, '2', '0', 'admin', now(), 'xkw:188835'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188834'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188835');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '谚语/习语', 'XKW-ENG-188836', '2', 2, '2', '0', 'admin', now(), 'xkw:188836'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188834'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188836');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情景交际', 'XKW-ENG-29982', '2', 3, '2', '0', 'admin', now(), 'xkw:29982'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188834'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-29982');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词词义辨析', 'XKW-ENG-41574', '2', 1, '2', '0', 'admin', now(), 'xkw:41574'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41574');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动词词义辨析', 'XKW-ENG-41613', '2', 2, '2', '0', 'admin', now(), 'xkw:41613'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41613');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词词义辨析', 'XKW-ENG-41642', '2', 3, '2', '0', 'admin', now(), 'xkw:41642'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41642');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '-ing形容词和-ed形容词辨析', 'XKW-ENG-148986', '2', 4, '2', '0', 'admin', now(), 'xkw:148986'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148986');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词词义辨析', 'XKW-ENG-41657', '2', 5, '2', '0', 'admin', now(), 'xkw:41657'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41657');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '代词辨析', 'XKW-ENG-188738', '2', 6, '2', '0', 'admin', now(), 'xkw:188738'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188738');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '介词辨析', 'XKW-ENG-188739', '2', 7, '2', '0', 'admin', now(), 'xkw:188739'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188739');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '连词辨析', 'XKW-ENG-188740', '2', 8, '2', '0', 'admin', now(), 'xkw:188740'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188740');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动词短语辨析', 'XKW-ENG-188742', '2', 1, '2', '0', 'admin', now(), 'xkw:188742'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188741'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188742');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '介词短语辨析', 'XKW-ENG-188743', '2', 2, '2', '0', 'admin', now(), 'xkw:188743'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188741'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188743');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词短语辨析', 'XKW-ENG-208567', '2', 3, '2', '0', 'admin', now(), 'xkw:208567'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188741'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-208567');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他短语辨析', 'XKW-ENG-188744', '2', 4, '2', '0', 'admin', now(), 'xkw:188744'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188741'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188744');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般现在时', 'XKW-ENG-41684', '1', 1, '2', '0', 'admin', now(), 'xkw:41684'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41684');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在进行时', 'XKW-ENG-41685', '1', 2, '2', '0', 'admin', now(), 'xkw:41685'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41685');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般过去时', 'XKW-ENG-41686', '1', 3, '2', '0', 'admin', now(), 'xkw:41686'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41686');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去进行时', 'XKW-ENG-41687', '1', 4, '2', '0', 'admin', now(), 'xkw:41687'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41687');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般将来时', 'XKW-ENG-41688', '1', 5, '2', '0', 'admin', now(), 'xkw:41688'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41688');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去将来时', 'XKW-ENG-41689', '1', 6, '2', '0', 'admin', now(), 'xkw:41689'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41689');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '将来进行时', 'XKW-ENG-41690', '1', 7, '2', '0', 'admin', now(), 'xkw:41690'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41690');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在完成时', 'XKW-ENG-41691', '1', 8, '2', '0', 'admin', now(), 'xkw:41691'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41691');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去完成时', 'XKW-ENG-41692', '1', 9, '2', '0', 'admin', now(), 'xkw:41692'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41692');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在完成进行时', 'XKW-ENG-41693', '1', 10, '2', '0', 'admin', now(), 'xkw:41693'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41693');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '将来完成时', 'XKW-ENG-41694', '2', 11, '2', '0', 'admin', now(), 'xkw:41694'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41694');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去完成进行时', 'XKW-ENG-41695', '2', 12, '2', '0', 'admin', now(), 'xkw:41695'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41695');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '将来完成进行时', 'XKW-ENG-157964', '2', 13, '2', '0', 'admin', now(), 'xkw:157964'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41682'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-157964');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '被动语态的形式', 'XKW-ENG-148989', '1', 1, '2', '0', 'admin', now(), 'xkw:148989'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41683'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148989');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '被动语态的用法', 'XKW-ENG-148990', '1', 2, '2', '0', 'admin', now(), 'xkw:148990'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41683'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148990');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动词不定式', 'XKW-ENG-41618', '1', 1, '2', '0', 'admin', now(), 'xkw:41618'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41567'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41618');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词', 'XKW-ENG-148976', '1', 2, '2', '0', 'admin', now(), 'xkw:148976'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41567'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148976');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词', 'XKW-ENG-41619', '1', 3, '2', '0', 'admin', now(), 'xkw:41619'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41567'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41619');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去分词', 'XKW-ENG-41620', '1', 4, '2', '0', 'admin', now(), 'xkw:41620'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41567'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41620');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动词的固定结构', 'XKW-ENG-41614', '2', 5, '2', '0', 'admin', now(), 'xkw:41614'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41567'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41614');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '独立主格结构', 'XKW-ENG-127892', '2', 6, '2', '0', 'admin', now(), 'xkw:127892'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41567'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-127892');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'with的复合结构', 'XKW-ENG-185470', '2', 7, '2', '0', 'admin', now(), 'xkw:185470'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41567'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185470');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '就近原则', 'XKW-ENG-41775', '2', 1, '2', '0', 'admin', now(), 'xkw:41775'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41714'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41775');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '意义一致', 'XKW-ENG-41777', '2', 2, '2', '0', 'admin', now(), 'xkw:41777'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41714'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41777');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语法一致', 'XKW-ENG-41778', '2', 3, '2', '0', 'admin', now(), 'xkw:41778'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41714'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41778');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主语从句', 'XKW-ENG-41737', '1', 1, '2', '0', 'admin', now(), 'xkw:41737'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41733'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41737');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同位语从句', 'XKW-ENG-41738', '1', 2, '2', '0', 'admin', now(), 'xkw:41738'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41733'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41738');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表语从句', 'XKW-ENG-41739', '1', 3, '2', '0', 'admin', now(), 'xkw:41739'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41733'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41739');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宾语从句', 'XKW-ENG-41740', '1', 4, '2', '0', 'admin', now(), 'xkw:41740'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41733'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41740');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '限制性定语从句', 'XKW-ENG-41751', '1', 1, '2', '0', 'admin', now(), 'xkw:41751'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41734'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41751');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非限制性定语从句', 'XKW-ENG-41752', '1', 2, '2', '0', 'admin', now(), 'xkw:41752'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41734'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41752');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时间状语从句', 'XKW-ENG-41753', '2', 1, '2', '0', 'admin', now(), 'xkw:41753'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41753');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '地点状语从句', 'XKW-ENG-41754', '2', 2, '2', '0', 'admin', now(), 'xkw:41754'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41754');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '原因状语从句', 'XKW-ENG-41755', '2', 3, '2', '0', 'admin', now(), 'xkw:41755'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41755');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '目的状语从句', 'XKW-ENG-41756', '2', 4, '2', '0', 'admin', now(), 'xkw:41756'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41756');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '结果状语从句', 'XKW-ENG-41757', '2', 5, '2', '0', 'admin', now(), 'xkw:41757'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41757');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '条件状语从句', 'XKW-ENG-41758', '2', 6, '2', '0', 'admin', now(), 'xkw:41758'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41758');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '让步状语从句', 'XKW-ENG-41759', '2', 7, '2', '0', 'admin', now(), 'xkw:41759'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41759');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '方式状语从句', 'XKW-ENG-41760', '2', 8, '2', '0', 'admin', now(), 'xkw:41760'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41760');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '比较状语从句', 'XKW-ENG-41761', '2', 9, '2', '0', 'admin', now(), 'xkw:41761'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41761');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词的数', 'XKW-ENG-41571', '1', 1, '2', '0', 'admin', now(), 'xkw:41571'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41562'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41571');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词所有格', 'XKW-ENG-41572', '2', 2, '2', '0', 'admin', now(), 'xkw:41572'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41562'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41572');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词的功用', 'XKW-ENG-41575', '1', 3, '2', '0', 'admin', now(), 'xkw:41575'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41562'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41575');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实义动词', 'XKW-ENG-148968', '1', 1, '2', '0', 'admin', now(), 'xkw:148968'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41566'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148968');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '系动词', 'XKW-ENG-41610', '1', 2, '2', '0', 'admin', now(), 'xkw:41610'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41566'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41610');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '使役动词', 'XKW-ENG-148969', '1', 3, '2', '0', 'admin', now(), 'xkw:148969'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41566'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148969');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '助动词', 'XKW-ENG-41612', '1', 4, '2', '0', 'admin', now(), 'xkw:41612'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41566'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41612');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词的位置', 'XKW-ENG-41644', '2', 1, '2', '0', 'admin', now(), 'xkw:41644'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41644');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词的功用', 'XKW-ENG-41645', '1', 2, '2', '0', 'admin', now(), 'xkw:41645'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41645');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词的比较等级', 'XKW-ENG-41640', '1', 3, '2', '0', 'admin', now(), 'xkw:41640'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41640');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词的分类', 'XKW-ENG-148984', '1', 1, '2', '0', 'admin', now(), 'xkw:148984'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41639'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148984');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词的位置', 'XKW-ENG-148985', '1', 2, '2', '0', 'admin', now(), 'xkw:148985'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41639'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148985');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词的功用', 'XKW-ENG-41658', '1', 3, '2', '0', 'admin', now(), 'xkw:41658'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41639'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41658');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词的比较等级', 'XKW-ENG-41641', '1', 4, '2', '0', 'admin', now(), 'xkw:41641'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41639'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41641');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人称代词', 'XKW-ENG-41582', '1', 1, '2', '0', 'admin', now(), 'xkw:41582'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41582');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物主代词', 'XKW-ENG-41583', '1', 2, '2', '0', 'admin', now(), 'xkw:41583'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41583');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '反身代词', 'XKW-ENG-41584', '2', 3, '2', '0', 'admin', now(), 'xkw:41584'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41584');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定代词', 'XKW-ENG-41585', '1', 4, '2', '0', 'admin', now(), 'xkw:41585'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41585');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '相互代词', 'XKW-ENG-41586', '2', 5, '2', '0', 'admin', now(), 'xkw:41586'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41586');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '指示代词', 'XKW-ENG-41588', '2', 6, '2', '0', 'admin', now(), 'xkw:41588'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41588');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'it的特殊用法', 'XKW-ENG-41589', '1', 7, '2', '0', 'admin', now(), 'xkw:41589'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41589');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基数词', 'XKW-ENG-41603', '2', 1, '2', '0', 'admin', now(), 'xkw:41603'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41565'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41603');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '序数词', 'XKW-ENG-41604', '2', 2, '2', '0', 'admin', now(), 'xkw:41604'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41565'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41604');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分数、小数和百分数', 'XKW-ENG-41605', '2', 3, '2', '0', 'admin', now(), 'xkw:41605'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41565'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41605');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时间表达法', 'XKW-ENG-41607', '2', 4, '2', '0', 'admin', now(), 'xkw:41607'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41565'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41607');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '倍数表达法', 'XKW-ENG-41608', '2', 5, '2', '0', 'admin', now(), 'xkw:41608'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41565'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41608');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '与数量有关的名词、代词和限定词', 'XKW-ENG-41609', '2', 6, '2', '0', 'admin', now(), 'xkw:41609'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41565'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41609');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定冠词', 'XKW-ENG-41599', '2', 1, '2', '0', 'admin', now(), 'xkw:41599'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41564'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41599');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '定冠词', 'XKW-ENG-41600', '2', 2, '2', '0', 'admin', now(), 'xkw:41600'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41564'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41600');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '零冠词', 'XKW-ENG-41601', '2', 3, '2', '0', 'admin', now(), 'xkw:41601'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41564'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41601');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '短语中有无冠词的意义区分', 'XKW-ENG-41602', '2', 4, '2', '0', 'admin', now(), 'xkw:41602'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41564'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41602');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '并列连词', 'XKW-ENG-41680', '2', 1, '2', '0', 'admin', now(), 'xkw:41680'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41570'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41680');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '从属连词', 'XKW-ENG-41681', '2', 2, '2', '0', 'admin', now(), 'xkw:41681'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41570'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41681');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示时间', 'XKW-ENG-41668', '2', 1, '2', '0', 'admin', now(), 'xkw:41668'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41668');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示地点方位', 'XKW-ENG-41669', '2', 2, '2', '0', 'admin', now(), 'xkw:41669'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41669');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示方式、方法或手段', 'XKW-ENG-41670', '2', 3, '2', '0', 'admin', now(), 'xkw:41670'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41670');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示伴随', 'XKW-ENG-41671', '2', 4, '2', '0', 'admin', now(), 'xkw:41671'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41671');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示“关于”', 'XKW-ENG-148987', '2', 5, '2', '0', 'admin', now(), 'xkw:148987'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148987');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示原因', 'XKW-ENG-41672', '2', 6, '2', '0', 'admin', now(), 'xkw:41672'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41672');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示“除……以外”', 'XKW-ENG-41673', '2', 7, '2', '0', 'admin', now(), 'xkw:41673'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41673');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示目的', 'XKW-ENG-41674', '2', 8, '2', '0', 'admin', now(), 'xkw:41674'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41674');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示比较', 'XKW-ENG-41675', '2', 9, '2', '0', 'admin', now(), 'xkw:41675'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41675');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示所属', 'XKW-ENG-41676', '2', 10, '2', '0', 'admin', now(), 'xkw:41676'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41676');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示条件', 'XKW-ENG-41677', '2', 11, '2', '0', 'admin', now(), 'xkw:41677'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41677');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示让步', 'XKW-ENG-148988', '2', 12, '2', '0', 'admin', now(), 'xkw:148988'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148988');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示其它', 'XKW-ENG-41678', '2', 13, '2', '0', 'admin', now(), 'xkw:41678'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41678');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '介词与其它词类的搭配', 'XKW-ENG-41679', '2', 14, '2', '0', 'admin', now(), 'xkw:41679'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41569'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41679');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情态动词的用法', 'XKW-ENG-41615', '1', 1, '2', '0', 'admin', now(), 'xkw:41615'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41611'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41615');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情态动词+have done', 'XKW-ENG-41617', '1', 2, '2', '0', 'admin', now(), 'xkw:41617'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41611'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41617');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情态动词(not)+动词原形', 'XKW-ENG-149928', '2', 3, '2', '0', 'admin', now(), 'xkw:149928'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41611'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149928');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '派生法', 'XKW-ENG-149053', '2', 1, '2', '0', 'admin', now(), 'xkw:149053'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148965'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149053');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '合成法', 'XKW-ENG-149054', '2', 2, '2', '0', 'admin', now(), 'xkw:149054'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148965'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149054');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '转化法', 'XKW-ENG-149055', '2', 3, '2', '0', 'admin', now(), 'xkw:149055'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148965'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149055');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气在非真实条件句中的运用', 'XKW-ENG-149014', '1', 1, '2', '0', 'admin', now(), 'xkw:149014'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149014');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气在非真实条件句中的特殊句式', 'XKW-ENG-149015', '1', 2, '2', '0', 'admin', now(), 'xkw:149015'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149015');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气在主语从句中的运用', 'XKW-ENG-149016', '1', 3, '2', '0', 'admin', now(), 'xkw:149016'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149016');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气在宾语从句中的运用', 'XKW-ENG-149017', '1', 4, '2', '0', 'admin', now(), 'xkw:149017'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149017');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气在表语从句中的运用', 'XKW-ENG-149018', '1', 5, '2', '0', 'admin', now(), 'xkw:149018'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149018');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气在同位语从句中的运用', 'XKW-ENG-149019', '2', 6, '2', '0', 'admin', now(), 'xkw:149019'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149019');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气在状语从句中的运用', 'XKW-ENG-149020', '1', 7, '2', '0', 'admin', now(), 'xkw:149020'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149020');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气在定语从句中的用法', 'XKW-ENG-149021', '2', 8, '2', '0', 'admin', now(), 'xkw:149021'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149021');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气的其他用法', 'XKW-ENG-149022', '1', 9, '2', '0', 'admin', now(), 'xkw:149022'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41560'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149022');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主谓', 'XKW-ENG-153274', '2', 1, '2', '0', 'admin', now(), 'xkw:153274'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153274');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主系表', 'XKW-ENG-153275', '2', 2, '2', '0', 'admin', now(), 'xkw:153275'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153275');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主谓宾', 'XKW-ENG-153276', '2', 3, '2', '0', 'admin', now(), 'xkw:153276'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153276');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主谓宾宾', 'XKW-ENG-153277', '2', 4, '2', '0', 'admin', now(), 'xkw:153277'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153277');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主谓宾补', 'XKW-ENG-153278', '2', 5, '2', '0', 'admin', now(), 'xkw:153278'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153278');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主谓状', 'XKW-ENG-153279', '2', 6, '2', '0', 'admin', now(), 'xkw:153279'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153279');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主谓宾状', 'XKW-ENG-153280', '2', 7, '2', '0', 'admin', now(), 'xkw:153280'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153280');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主语', 'XKW-ENG-153282', '2', 1, '2', '0', 'admin', now(), 'xkw:153282'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153281'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153282');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '谓语', 'XKW-ENG-153283', '2', 2, '2', '0', 'admin', now(), 'xkw:153283'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153281'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153283');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宾语', 'XKW-ENG-153284', '2', 3, '2', '0', 'admin', now(), 'xkw:153284'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153281'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153284');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '补语', 'XKW-ENG-153285', '2', 4, '2', '0', 'admin', now(), 'xkw:153285'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153281'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153285');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '状语', 'XKW-ENG-153286', '2', 5, '2', '0', 'admin', now(), 'xkw:153286'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153281'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153286');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表语', 'XKW-ENG-153287', '2', 6, '2', '0', 'admin', now(), 'xkw:153287'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153281'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153287');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '定语', 'XKW-ENG-153288', '2', 7, '2', '0', 'admin', now(), 'xkw:153288'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-153281'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-153288');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '疑问句', 'XKW-ENG-41716', '1', 1, '2', '0', 'admin', now(), 'xkw:41716'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41711'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41716');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陈述句', 'XKW-ENG-41717', '1', 2, '2', '0', 'admin', now(), 'xkw:41717'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41711'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41717');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '祈使句', 'XKW-ENG-41718', '1', 3, '2', '0', 'admin', now(), 'xkw:41718'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41711'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41718');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '感叹句', 'XKW-ENG-41719', '1', 4, '2', '0', 'admin', now(), 'xkw:41719'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41711'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41719');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '倒装', 'XKW-ENG-41766', '1', 1, '2', '0', 'admin', now(), 'xkw:41766'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41713'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41766');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '省略', 'XKW-ENG-41767', '1', 2, '2', '0', 'admin', now(), 'xkw:41767'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41713'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41767');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '强调句', 'XKW-ENG-41768', '1', 3, '2', '0', 'admin', now(), 'xkw:41768'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41713'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41768');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '插入语句式', 'XKW-ENG-41770', '2', 4, '2', '0', 'admin', now(), 'xkw:41770'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41713'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41770');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'There be或存在句', 'XKW-ENG-41720', '1', 5, '2', '0', 'admin', now(), 'xkw:41720'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41713'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41720');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生活与学习 ', 'XKW-ENG-197369', '1', 1, '2', '0', 'admin', now(), 'xkw:197369'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181230'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197369');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '做人与做事', 'XKW-ENG-197374', '1', 2, '2', '0', 'admin', now(), 'xkw:197374'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181230'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197374');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '社会服务与人际沟通 ', 'XKW-ENG-197376', '1', 1, '2', '0', 'admin', now(), 'xkw:197376'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181244'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197376');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文学、艺术与体育 ', 'XKW-ENG-197377', '1', 2, '2', '0', 'admin', now(), 'xkw:197377'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181244'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197377');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '历史、社会与文化 ', 'XKW-ENG-197378', '1', 3, '2', '0', 'admin', now(), 'xkw:197378'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181244'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197378');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国文化', 'XKW-ENG-197379', '1', 4, '2', '0', 'admin', now(), 'xkw:197379'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181244'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197379');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科学与技术 ', 'XKW-ENG-197449', '1', 5, '2', '0', 'admin', now(), 'xkw:197449'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181244'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197449');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '环境', 'XKW-ENG-181282', '1', 1, '2', '0', 'admin', now(), 'xkw:181282'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181278'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181282');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自然生态 ', 'XKW-ENG-197452', '1', 2, '2', '0', 'admin', now(), 'xkw:197452'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181278'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197452');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '灾害防范 ', 'XKW-ENG-197453', '1', 3, '2', '0', 'admin', now(), 'xkw:197453'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181278'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197453');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宇宙探索', 'XKW-ENG-197456', '1', 4, '2', '0', 'admin', now(), 'xkw:197456'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181278'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197456');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '记叙文', 'XKW-ENG-149099', '2', 1, '2', '0', 'admin', now(), 'xkw:149099'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149097'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149099');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '说明文', 'XKW-ENG-149100', '2', 2, '2', '0', 'admin', now(), 'xkw:149100'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149097'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149100');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '议论文', 'XKW-ENG-149101', '2', 3, '2', '0', 'admin', now(), 'xkw:149101'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149097'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149101');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '夹叙夹议', 'XKW-ENG-149102', '2', 4, '2', '0', 'admin', now(), 'xkw:149102'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149097'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149102');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '应用文', 'XKW-ENG-149103', '2', 5, '2', '0', 'admin', now(), 'xkw:149103'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149097'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149103');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '新闻报道', 'XKW-ENG-149104', '2', 6, '2', '0', 'admin', now(), 'xkw:149104'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149097'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149104');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他', 'XKW-ENG-149105', '2', 7, '2', '0', 'admin', now(), 'xkw:149105'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149097'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149105');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细节理解', 'XKW-ENG-149106', '1', 1, '2', '0', 'admin', now(), 'xkw:149106'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149098'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149106');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '推理判断', 'XKW-ENG-149107', '1', 2, '2', '0', 'admin', now(), 'xkw:149107'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149098'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149107');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主旨大意', 'XKW-ENG-149108', '1', 3, '2', '0', 'admin', now(), 'xkw:149108'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149098'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149108');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词句猜测', 'XKW-ENG-149109', '1', 4, '2', '0', 'admin', now(), 'xkw:149109'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149098'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149109');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表经常性、习惯性 ', 'XKW-ENG-197033', '2', 1, '2', '0', 'admin', now(), 'xkw:197033'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41684'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197033');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表客观真理、科学事实及自然现象 ', 'XKW-ENG-197034', '2', 2, '2', '0', 'admin', now(), 'xkw:197034'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41684'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197034');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般现在时表将来 ', 'XKW-ENG-197035', '2', 3, '2', '0', 'admin', now(), 'xkw:197035'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41684'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197035');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般现在时态用于具体语境(文学作品) ', 'XKW-ENG-197036', '2', 4, '2', '0', 'admin', now(), 'xkw:197036'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41684'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197036');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在进行时表进行 ', 'XKW-ENG-197037', '2', 1, '2', '0', 'admin', now(), 'xkw:197037'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41685'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197037');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在进行时表将来 ', 'XKW-ENG-197038', '2', 2, '2', '0', 'admin', now(), 'xkw:197038'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41685'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197038');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在进行时表喜恶 ', 'XKW-ENG-197039', '2', 3, '2', '0', 'admin', now(), 'xkw:197039'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41685'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197039');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般过去时表过去的动作和状态 ', 'XKW-ENG-197040', '2', 1, '2', '0', 'admin', now(), 'xkw:197040'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41686'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197040');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'used to do ', 'XKW-ENG-197041', '2', 2, '2', '0', 'admin', now(), 'xkw:197041'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41686'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197041');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去进行时表进行 ', 'XKW-ENG-197042', '2', 1, '2', '0', 'admin', now(), 'xkw:197042'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41687'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197042');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去进行时表过去将来 ', 'XKW-ENG-197043', '2', 2, '2', '0', 'admin', now(), 'xkw:197043'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41687'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197043');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去进行时表过去的喜恶 ', 'XKW-ENG-197044', '2', 3, '2', '0', 'admin', now(), 'xkw:197044'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41687'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197044');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表现在（was/were wandering...） ', 'XKW-ENG-197045', '2', 4, '2', '0', 'admin', now(), 'xkw:197045'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41687'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197045');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'will/shall do ', 'XKW-ENG-197046', '2', 1, '2', '0', 'admin', now(), 'xkw:197046'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41688'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197046');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'be going to ', 'XKW-ENG-197047', '2', 2, '2', '0', 'admin', now(), 'xkw:197047'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41688'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197047');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'be (about) to do表安排计划 ', 'XKW-ENG-197048', '2', 3, '2', '0', 'admin', now(), 'xkw:197048'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41688'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197048');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'would do ', 'XKW-ENG-197049', '2', 1, '2', '0', 'admin', now(), 'xkw:197049'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41689'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197049');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'was/were going to do ', 'XKW-ENG-197050', '2', 2, '2', '0', 'admin', now(), 'xkw:197050'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41689'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197050');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'was/were (about) to do ', 'XKW-ENG-197051', '2', 3, '2', '0', 'admin', now(), 'xkw:197051'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41689'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197051');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'would do表过去习惯性动作 ', 'XKW-ENG-197052', '2', 4, '2', '0', 'admin', now(), 'xkw:197052'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41689'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197052');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表将来某个时间将要进行的事情 ', 'XKW-ENG-197053', '2', 1, '2', '0', 'admin', now(), 'xkw:197053'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41690'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197053');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示对未来的预测 ', 'XKW-ENG-197054', '2', 2, '2', '0', 'admin', now(), 'xkw:197054'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41690'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197054');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '询问未来的计划或打算  ', 'XKW-ENG-197055', '2', 3, '2', '0', 'admin', now(), 'xkw:197055'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41690'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197055');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示影响（动作已完成） ', 'XKW-ENG-197056', '2', 1, '2', '0', 'admin', now(), 'xkw:197056'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41691'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197056');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示持续（动作未完成） ', 'XKW-ENG-197057', '2', 2, '2', '0', 'admin', now(), 'xkw:197057'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41691'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197057');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去完成时表过去的过去 ', 'XKW-ENG-197058', '2', 1, '2', '0', 'admin', now(), 'xkw:197058'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41692'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197058');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'had intended/planned/expceted表“原打算/计划/猜测......” ', 'XKW-ENG-197059', '2', 2, '2', '0', 'admin', now(), 'xkw:197059'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41692'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197059');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表过去开始到现在仍在发生的动作', 'XKW-ENG-197060', '2', 1, '2', '0', 'admin', now(), 'xkw:197060'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41693'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197060');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表过去开始而刚刚结束的动作 ', 'XKW-ENG-197061', '2', 2, '2', '0', 'admin', now(), 'xkw:197061'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41693'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197061');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般现在时的被动语态', 'XKW-ENG-41696', '2', 1, '2', '0', 'admin', now(), 'xkw:41696'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41696');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在进行时的被动语态', 'XKW-ENG-41697', '2', 2, '2', '0', 'admin', now(), 'xkw:41697'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41697');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般过去时的被动语态', 'XKW-ENG-41698', '2', 3, '2', '0', 'admin', now(), 'xkw:41698'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41698');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去进行时的被动语态', 'XKW-ENG-41699', '2', 4, '2', '0', 'admin', now(), 'xkw:41699'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41699');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般将来时的被动语态', 'XKW-ENG-41700', '2', 5, '2', '0', 'admin', now(), 'xkw:41700'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41700');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去将来时的被动语态', 'XKW-ENG-41701', '2', 6, '2', '0', 'admin', now(), 'xkw:41701'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41701');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在完成时的被动语态', 'XKW-ENG-41703', '2', 7, '2', '0', 'admin', now(), 'xkw:41703'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41703');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去完成时的被动语态', 'XKW-ENG-41704', '2', 8, '2', '0', 'admin', now(), 'xkw:41704'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41704');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '将来完成时的被动语态', 'XKW-ENG-41705', '2', 9, '2', '0', 'admin', now(), 'xkw:41705'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41705');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含情态动词的被动语态', 'XKW-ENG-41706', '2', 10, '2', '0', 'admin', now(), 'xkw:41706'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148989'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41706');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '需要使用被动语态的情况', 'XKW-ENG-41707', '2', 1, '2', '0', 'admin', now(), 'xkw:41707'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148990'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41707');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无被动语态的情况', 'XKW-ENG-149056', '2', 2, '2', '0', 'admin', now(), 'xkw:149056'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148990'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149056');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主动表被动', 'XKW-ENG-149057', '2', 3, '2', '0', 'admin', now(), 'xkw:149057'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148990'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149057');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '省略to的不定式的被动语态', 'XKW-ENG-149058', '2', 4, '2', '0', 'admin', now(), 'xkw:149058'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148990'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149058');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式的构成', 'XKW-ENG-148977', '1', 1, '2', '0', 'admin', now(), 'xkw:148977'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41618'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148977');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式的时态和语态', 'XKW-ENG-148978', '1', 2, '2', '0', 'admin', now(), 'xkw:148978'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41618'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148978');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式的用法和意义', 'XKW-ENG-148979', '1', 3, '2', '0', 'admin', now(), 'xkw:148979'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41618'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148979');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词的时态和语态', 'XKW-ENG-149043', '1', 1, '2', '0', 'admin', now(), 'xkw:149043'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148976'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149043');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词的用法', 'XKW-ENG-149044', '1', 2, '2', '0', 'admin', now(), 'xkw:149044'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148976'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149044');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词的复合结构', 'XKW-ENG-149045', '2', 3, '2', '0', 'admin', now(), 'xkw:149045'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148976'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149045');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词的时态和语态', 'XKW-ENG-148980', '1', 1, '2', '0', 'admin', now(), 'xkw:148980'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148980');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词的用法和意义', 'XKW-ENG-148981', '1', 2, '2', '0', 'admin', now(), 'xkw:148981'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148981');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去分词作定语', 'XKW-ENG-41634', '2', 1, '2', '0', 'admin', now(), 'xkw:41634'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41634');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去分词作表语', 'XKW-ENG-41635', '2', 2, '2', '0', 'admin', now(), 'xkw:41635'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41635');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去分词作补足语', 'XKW-ENG-41636', '2', 3, '2', '0', 'admin', now(), 'xkw:41636'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41636');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去分词作状语', 'XKW-ENG-41637', '2', 4, '2', '0', 'admin', now(), 'xkw:41637'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41637');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去分词表示被动意义', 'XKW-ENG-148982', '2', 5, '2', '0', 'admin', now(), 'xkw:148982'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148982');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去分词表示已经完成的动作', 'XKW-ENG-148983', '2', 6, '2', '0', 'admin', now(), 'xkw:148983'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148983');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主语从句的连接词', 'XKW-ENG-41741', '2', 1, '2', '0', 'admin', now(), 'xkw:41741'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41741');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主语从句的语序', 'XKW-ENG-149023', '2', 2, '2', '0', 'admin', now(), 'xkw:149023'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41737'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149023');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同位语从句的连接词', 'XKW-ENG-41743', '2', 1, '2', '0', 'admin', now(), 'xkw:41743'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41738'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41743');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同位语从句与定语从句的区别', 'XKW-ENG-41744', '2', 2, '2', '0', 'admin', now(), 'xkw:41744'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41738'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41744');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表语从句的连接词', 'XKW-ENG-149024', '1', 1, '2', '0', 'admin', now(), 'xkw:149024'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41739'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149024');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表语从句的时态', 'XKW-ENG-149025', '2', 2, '2', '0', 'admin', now(), 'xkw:149025'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41739'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149025');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宾语从句的连接词', 'XKW-ENG-148996', '1', 1, '2', '0', 'admin', now(), 'xkw:148996'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41740'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148996');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宾语从句的语序', 'XKW-ENG-148997', '2', 2, '2', '0', 'admin', now(), 'xkw:148997'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41740'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148997');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宾语从句的时态', 'XKW-ENG-148998', '2', 3, '2', '0', 'admin', now(), 'xkw:148998'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41740'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148998');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宾语从句的否定前移', 'XKW-ENG-148999', '2', 4, '2', '0', 'admin', now(), 'xkw:148999'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41740'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148999');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '直接引语和间接引语', 'XKW-ENG-41736', '1', 5, '2', '0', 'admin', now(), 'xkw:41736'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41740'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41736');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系代词', 'XKW-ENG-149000', '1', 1, '2', '0', 'admin', now(), 'xkw:149000'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41751'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149000');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系副词', 'XKW-ENG-149001', '1', 2, '2', '0', 'admin', now(), 'xkw:149001'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41751'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149001');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“介词+关系代词”引导限制性定语从句', 'XKW-ENG-149002', '2', 3, '2', '0', 'admin', now(), 'xkw:149002'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41751'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149002');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系代词', 'XKW-ENG-149003', '1', 1, '2', '0', 'admin', now(), 'xkw:149003'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41752'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149003');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系副词', 'XKW-ENG-149004', '1', 2, '2', '0', 'admin', now(), 'xkw:149004'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41752'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149004');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非限制性定语从句的注意事项', 'XKW-ENG-149005', '1', 3, '2', '0', 'admin', now(), 'xkw:149005'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41752'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149005');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '可数名词的单复数', 'XKW-ENG-148966', '2', 1, '2', '0', 'admin', now(), 'xkw:148966'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41571'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148966');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不可数名词', 'XKW-ENG-148967', '2', 2, '2', '0', 'admin', now(), 'xkw:148967'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41571'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148967');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词作定语', 'XKW-ENG-41576', '2', 1, '2', '0', 'admin', now(), 'xkw:41576'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41575'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41576');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词作状语', 'XKW-ENG-41577', '2', 2, '2', '0', 'admin', now(), 'xkw:41577'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41575'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41577');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词作主语', 'XKW-ENG-41578', '2', 3, '2', '0', 'admin', now(), 'xkw:41578'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41575'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41578');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词作宾语', 'XKW-ENG-41579', '2', 4, '2', '0', 'admin', now(), 'xkw:41579'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41575'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41579');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词作表语', 'XKW-ENG-41580', '2', 5, '2', '0', 'admin', now(), 'xkw:41580'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41575'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41580');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词作补语', 'XKW-ENG-41581', '2', 6, '2', '0', 'admin', now(), 'xkw:41581'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41575'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41581');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '及物动词', 'XKW-ENG-149026', '2', 1, '2', '0', 'admin', now(), 'xkw:149026'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148968'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149026');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不及物动词', 'XKW-ENG-149027', '2', 2, '2', '0', 'admin', now(), 'xkw:149027'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148968'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149027');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'be动词', 'XKW-ENG-148970', '2', 1, '2', '0', 'admin', now(), 'xkw:148970'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41610'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148970');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '感官动词', 'XKW-ENG-148971', '2', 2, '2', '0', 'admin', now(), 'xkw:148971'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41610'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148971');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他系动词 ', 'XKW-ENG-148972', '2', 3, '2', '0', 'admin', now(), 'xkw:148972'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41610'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148972');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '使役动词let', 'XKW-ENG-157961', '2', 1, '2', '0', 'admin', now(), 'xkw:157961'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148969'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-157961');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '使役动词make', 'XKW-ENG-157962', '2', 2, '2', '0', 'admin', now(), 'xkw:157962'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148969'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-157962');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '使役动词have', 'XKW-ENG-157963', '2', 3, '2', '0', 'admin', now(), 'xkw:157963'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148969'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-157963');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'be作助动词', 'XKW-ENG-148973', '2', 1, '2', '0', 'admin', now(), 'xkw:148973'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41612'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148973');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'do作助动词', 'XKW-ENG-148974', '2', 2, '2', '0', 'admin', now(), 'xkw:148974'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41612'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148974');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'have作助动词', 'XKW-ENG-148975', '2', 3, '2', '0', 'admin', now(), 'xkw:148975'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41612'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148975');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词作定语', 'XKW-ENG-41646', '2', 1, '2', '0', 'admin', now(), 'xkw:41646'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41645'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41646');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词作表语', 'XKW-ENG-41647', '2', 2, '2', '0', 'admin', now(), 'xkw:41647'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41645'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41647');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词作补足语', 'XKW-ENG-41648', '2', 3, '2', '0', 'admin', now(), 'xkw:41648'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41645'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41648');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词作状语', 'XKW-ENG-41649', '2', 4, '2', '0', 'admin', now(), 'xkw:41649'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41645'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41649');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词的原级', 'XKW-ENG-41662', '2', 1, '2', '0', 'admin', now(), 'xkw:41662'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41640'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41662');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词的比较级', 'XKW-ENG-41663', '2', 2, '2', '0', 'admin', now(), 'xkw:41663'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41640'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41663');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词的最高级', 'XKW-ENG-41664', '2', 3, '2', '0', 'admin', now(), 'xkw:41664'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41640'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41664');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时间副词', 'XKW-ENG-41650', '2', 1, '2', '0', 'admin', now(), 'xkw:41650'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148984'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41650');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '地点副词', 'XKW-ENG-41651', '2', 2, '2', '0', 'admin', now(), 'xkw:41651'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148984'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41651');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '方式副词', 'XKW-ENG-41652', '2', 3, '2', '0', 'admin', now(), 'xkw:41652'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148984'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41652');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '程度副词', 'XKW-ENG-41653', '2', 4, '2', '0', 'admin', now(), 'xkw:41653'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148984'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41653');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '频度副词', 'XKW-ENG-41654', '2', 5, '2', '0', 'admin', now(), 'xkw:41654'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148984'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41654');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '连接副词', 'XKW-ENG-41655', '2', 6, '2', '0', 'admin', now(), 'xkw:41655'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148984'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41655');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词enough修饰形容词或副词时后置', 'XKW-ENG-149051', '2', 1, '2', '0', 'admin', now(), 'xkw:149051'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148985'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149051');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人称代词在动副短语中的位置', 'XKW-ENG-149052', '2', 2, '2', '0', 'admin', now(), 'xkw:149052'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148985'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149052');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词作状语', 'XKW-ENG-41659', '2', 1, '2', '0', 'admin', now(), 'xkw:41659'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41658'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41659');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词作定语', 'XKW-ENG-41660', '2', 2, '2', '0', 'admin', now(), 'xkw:41660'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41658'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41660');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词作表语', 'XKW-ENG-41661', '2', 3, '2', '0', 'admin', now(), 'xkw:41661'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41658'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41661');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词作补足语', 'XKW-ENG-136339', '2', 4, '2', '0', 'admin', now(), 'xkw:136339'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41658'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-136339');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词的原级', 'XKW-ENG-41665', '2', 1, '2', '0', 'admin', now(), 'xkw:41665'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41641'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41665');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词的比较级', 'XKW-ENG-41666', '2', 2, '2', '0', 'admin', now(), 'xkw:41666'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41641'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41666');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '副词的最高级', 'XKW-ENG-41667', '2', 3, '2', '0', 'admin', now(), 'xkw:41667'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41641'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41667');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主格', 'XKW-ENG-41590', '2', 1, '2', '0', 'admin', now(), 'xkw:41590'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41582'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41590');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宾格', 'XKW-ENG-41591', '2', 2, '2', '0', 'admin', now(), 'xkw:41591'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41582'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41591');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '形容词性物主代词', 'XKW-ENG-41592', '2', 1, '2', '0', 'admin', now(), 'xkw:41592'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41583'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41592');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '名词性物主代词', 'XKW-ENG-41593', '2', 2, '2', '0', 'admin', now(), 'xkw:41593'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41583'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41593');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '简单不定代词', 'XKW-ENG-41594', '2', 1, '2', '0', 'admin', now(), 'xkw:41594'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41585'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41594');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '复合不定代词', 'XKW-ENG-41595', '2', 2, '2', '0', 'admin', now(), 'xkw:41595'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41585'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41595');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '代词it', 'XKW-ENG-41596', '2', 1, '2', '0', 'admin', now(), 'xkw:41596'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41589'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41596');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'it 作形式主语', 'XKW-ENG-41597', '2', 2, '2', '0', 'admin', now(), 'xkw:41597'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41589'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41597');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'it 作形式宾语', 'XKW-ENG-41598', '2', 3, '2', '0', 'admin', now(), 'xkw:41598'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41589'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41598');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'can/could的用法', 'XKW-ENG-154570', '1', 1, '2', '0', 'admin', now(), 'xkw:154570'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154570');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'may/might的用法', 'XKW-ENG-154574', '1', 2, '2', '0', 'admin', now(), 'xkw:154574'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154574');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'must的用法', 'XKW-ENG-154577', '1', 3, '2', '0', 'admin', now(), 'xkw:154577'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154577');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'should的用法', 'XKW-ENG-154581', '2', 4, '2', '0', 'admin', now(), 'xkw:154581'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154581');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'would的用法', 'XKW-ENG-154582', '2', 5, '2', '0', 'admin', now(), 'xkw:154582'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154582');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'will的用法', 'XKW-ENG-154583', '2', 6, '2', '0', 'admin', now(), 'xkw:154583'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154583');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'ought (not) to的用法', 'XKW-ENG-154584', '2', 7, '2', '0', 'admin', now(), 'xkw:154584'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154584');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'shall的用法', 'XKW-ENG-154585', '2', 8, '2', '0', 'admin', now(), 'xkw:154585'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154585');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'need的用法', 'XKW-ENG-154586', '2', 9, '2', '0', 'admin', now(), 'xkw:154586'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154586');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'have to的用法', 'XKW-ENG-154587', '2', 10, '2', '0', 'admin', now(), 'xkw:154587'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154587');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'dare (not)的用法', 'XKW-ENG-154588', '2', 11, '2', '0', 'admin', now(), 'xkw:154588'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154588');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'had better (not)的用法', 'XKW-ENG-154589', '2', 12, '2', '0', 'admin', now(), 'xkw:154589'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41615'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154589');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'can/could have done的用法', 'XKW-ENG-154590', '2', 1, '2', '0', 'admin', now(), 'xkw:154590'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154590');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'can’t/couldn’t have done的用法', 'XKW-ENG-154591', '2', 2, '2', '0', 'admin', now(), 'xkw:154591'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154591');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'should(ought to) have done的用法', 'XKW-ENG-154592', '2', 3, '2', '0', 'admin', now(), 'xkw:154592'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154592');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'shouldn’t(ought not to) have done的用法', 'XKW-ENG-154593', '2', 4, '2', '0', 'admin', now(), 'xkw:154593'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154593');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'would have done的用法', 'XKW-ENG-154594', '2', 5, '2', '0', 'admin', now(), 'xkw:154594'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154594');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'need have done的用法', 'XKW-ENG-154595', '2', 6, '2', '0', 'admin', now(), 'xkw:154595'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154595');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'must have done的用法', 'XKW-ENG-154596', '2', 7, '2', '0', 'admin', now(), 'xkw:154596'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154596');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'needn’t have done的用法', 'XKW-ENG-154597', '2', 8, '2', '0', 'admin', now(), 'xkw:154597'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154597');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'may/might have done的用法', 'XKW-ENG-154598', '2', 9, '2', '0', 'admin', now(), 'xkw:154598'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154598');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '与现在事实相反的假设', 'XKW-ENG-149059', '2', 1, '2', '0', 'admin', now(), 'xkw:149059'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149059');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '与过去事实相反的假设', 'XKW-ENG-149060', '2', 2, '2', '0', 'admin', now(), 'xkw:149060'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149060');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '与将来事实相反的假设', 'XKW-ENG-149061', '2', 3, '2', '0', 'admin', now(), 'xkw:149061'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149061');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '省略if的条件句', 'XKW-ENG-149062', '2', 1, '2', '0', 'admin', now(), 'xkw:149062'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149015'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149062');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '错综时间条件句', 'XKW-ENG-149063', '2', 2, '2', '0', 'admin', now(), 'xkw:149063'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149015'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149063');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含蓄条件句', 'XKW-ENG-149064', '2', 3, '2', '0', 'admin', now(), 'xkw:149064'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149015'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149064');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'It be important/necessary…that+(should) do', 'XKW-ENG-149065', '2', 1, '2', '0', 'admin', now(), 'xkw:149065'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149065');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'It be a pity/shame…that+(should) do', 'XKW-ENG-149066', '2', 2, '2', '0', 'admin', now(), 'xkw:149066'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149066');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'It be suggested/desired…that+(should) do', 'XKW-ENG-149067', '2', 3, '2', '0', 'admin', now(), 'xkw:149067'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149067');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'wish后的宾语从句中虚拟语气的用法', 'XKW-ENG-149068', '2', 1, '2', '0', 'admin', now(), 'xkw:149068'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149068');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'would rather等短语后的宾语从句', 'XKW-ENG-149069', '2', 2, '2', '0', 'admin', now(), 'xkw:149069'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149069');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示建议、命令等动词后的宾语从句+(should) do', 'XKW-ENG-149070', '2', 3, '2', '0', 'admin', now(), 'xkw:149070'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149070');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '在suggestion/advice等名词后的表语从句+(should) do', 'XKW-ENG-149071', '2', 1, '2', '0', 'admin', now(), 'xkw:149071'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149018'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149071');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气用于as if/though引导的表语从句', 'XKW-ENG-149072', '2', 2, '2', '0', 'admin', now(), 'xkw:149072'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149018'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149072');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气用于as if/though引导的方式状语从句', 'XKW-ENG-149073', '2', 1, '2', '0', 'admin', now(), 'xkw:149073'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149020'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149073');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '虚拟语气用于in case, on condition, for fear that等引导的状语从句', 'XKW-ENG-149074', '2', 2, '2', '0', 'admin', now(), 'xkw:149074'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149020'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149074');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'if only句型', 'XKW-ENG-149075', '2', 1, '2', '0', 'admin', now(), 'xkw:149075'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149022'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149075');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表示祝福', 'XKW-ENG-149076', '2', 2, '2', '0', 'admin', now(), 'xkw:149076'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149022'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149076');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '反意疑问句及其回答', 'XKW-ENG-41722', '2', 1, '2', '0', 'admin', now(), 'xkw:41722'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41716'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41722');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般疑问句及其回答', 'XKW-ENG-41723', '2', 2, '2', '0', 'admin', now(), 'xkw:41723'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41716'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41723');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '特殊疑问句及其回答', 'XKW-ENG-41724', '1', 3, '2', '0', 'admin', now(), 'xkw:41724'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41716'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41724');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '选择疑问句及其回答', 'XKW-ENG-41725', '2', 4, '2', '0', 'admin', now(), 'xkw:41725'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41716'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41725');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陈述句的肯定形式', 'XKW-ENG-148991', '2', 1, '2', '0', 'admin', now(), 'xkw:148991'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41717'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148991');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陈述句的否定形式', 'XKW-ENG-148992', '2', 2, '2', '0', 'admin', now(), 'xkw:148992'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41717'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148992');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陈述句的语序', 'XKW-ENG-148993', '2', 3, '2', '0', 'admin', now(), 'xkw:148993'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41717'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148993');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '祈使句的否定形式', 'XKW-ENG-41726', '2', 1, '2', '0', 'admin', now(), 'xkw:41726'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41718'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41726');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '祈使句的肯定形式', 'XKW-ENG-41727', '2', 2, '2', '0', 'admin', now(), 'xkw:41727'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41718'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41727');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '祈使句+and/or+简单句', 'XKW-ENG-148994', '2', 3, '2', '0', 'admin', now(), 'xkw:148994'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41718'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148994');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'what引导的感叹句', 'XKW-ENG-41728', '2', 1, '2', '0', 'admin', now(), 'xkw:41728'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41719'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41728');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'how引导的感叹句', 'XKW-ENG-41729', '2', 2, '2', '0', 'admin', now(), 'xkw:41729'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41719'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41729');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全部倒装', 'XKW-ENG-41771', '2', 1, '2', '0', 'admin', now(), 'xkw:41771'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41766'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41771');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '部分倒装', 'XKW-ENG-41772', '2', 2, '2', '0', 'admin', now(), 'xkw:41772'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41766'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41772');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '状语从句中的省略', 'XKW-ENG-41773', '2', 1, '2', '0', 'admin', now(), 'xkw:41773'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41767'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41773');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式符号to的省略', 'XKW-ENG-41774', '2', 2, '2', '0', 'admin', now(), 'xkw:41774'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41767'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41774');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '强调谓语（do+动词原形）', 'XKW-ENG-149006', '2', 1, '2', '0', 'admin', now(), 'xkw:149006'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41768'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149006');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'It be…that/who强调句型', 'XKW-ENG-149007', '2', 2, '2', '0', 'admin', now(), 'xkw:149007'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41768'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149007');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'there be句型', 'XKW-ENG-41730', '2', 1, '2', '0', 'admin', now(), 'xkw:41730'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41720'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41730');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '存在句的其他句型', 'XKW-ENG-148995', '2', 2, '2', '0', 'admin', now(), 'xkw:148995'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41720'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-148995');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'there be或存在句的时态', 'XKW-ENG-41731', '2', 3, '2', '0', 'admin', now(), 'xkw:41731'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41720'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41731');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'there be的非谓语形式', 'XKW-ENG-41732', '2', 4, '2', '0', 'admin', now(), 'xkw:41732'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41720'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41732');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人情况', 'XKW-ENG-41779', '1', 1, '2', '0', 'admin', now(), 'xkw:41779'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41779');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '外表与形象', 'XKW-ENG-188769', '1', 2, '2', '0', 'admin', now(), 'xkw:188769'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188769');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '兴趣与爱好', 'XKW-ENG-41784', '1', 3, '2', '0', 'admin', now(), 'xkw:41784'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41784');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家庭、朋友与周围的人', 'XKW-ENG-41780', '1', 4, '2', '0', 'admin', now(), 'xkw:41780'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41780');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '居住环境', 'XKW-ENG-41781', '1', 5, '2', '0', 'admin', now(), 'xkw:41781'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41781');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '日常活动', 'XKW-ENG-41782', '1', 6, '2', '0', 'admin', now(), 'xkw:41782'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41782');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '学校生活', 'XKW-ENG-41783', '1', 7, '2', '0', 'admin', now(), 'xkw:41783'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41783');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '节假日活动', 'XKW-ENG-41788', '1', 8, '2', '0', 'admin', now(), 'xkw:41788'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41788');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生活态度', 'XKW-ENG-185706', '1', 9, '2', '0', 'admin', now(), 'xkw:185706'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185706');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '购物', 'XKW-ENG-41789', '1', 10, '2', '0', 'admin', now(), 'xkw:41789'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41789');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言学习', 'XKW-ENG-41795', '1', 11, '2', '0', 'admin', now(), 'xkw:41795'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41795');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '饮食', 'XKW-ENG-41790', '1', 12, '2', '0', 'admin', now(), 'xkw:41790'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41790');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '健康', 'XKW-ENG-41791', '1', 13, '2', '0', 'admin', now(), 'xkw:41791'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197369'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41791');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '道德与品行', 'XKW-ENG-185709', '2', 1, '2', '0', 'admin', now(), 'xkw:185709'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197374'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185709');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计划与愿望', 'XKW-ENG-41787', '1', 2, '2', '0', 'admin', now(), 'xkw:41787'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197374'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41787');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '工作与职业', 'XKW-ENG-181232', '1', 3, '2', '0', 'admin', now(), 'xkw:181232'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197374'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181232');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '精神与品格', 'XKW-ENG-188780', '1', 4, '2', '0', 'admin', now(), 'xkw:188780'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197374'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188780');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情感与情绪', 'XKW-ENG-41785', '1', 5, '2', '0', 'admin', now(), 'xkw:41785'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197374'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41785');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '方法与哲理 ', 'XKW-ENG-197375', '1', 6, '2', '0', 'admin', now(), 'xkw:197375'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197374'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197375');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人际交往', 'XKW-ENG-41786', '1', 1, '2', '0', 'admin', now(), 'xkw:41786'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197376'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41786');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '公益行为', 'XKW-ENG-181247', '1', 2, '2', '0', 'admin', now(), 'xkw:181247'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197376'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181247');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文学/艺术 ', 'XKW-ENG-41793', '2', 1, '2', '0', 'admin', now(), 'xkw:41793'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197377'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41793');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文学作品', 'XKW-ENG-188807', '1', 2, '2', '0', 'admin', now(), 'xkw:188807'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197377'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188807');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艺术', 'XKW-ENG-188797', '1', 3, '2', '0', 'admin', now(), 'xkw:188797'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197377'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188797');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文学形式', 'XKW-ENG-188800', '1', 4, '2', '0', 'admin', now(), 'xkw:188800'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197377'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188800');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体育', 'XKW-ENG-149010', '1', 5, '2', '0', 'admin', now(), 'xkw:149010'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197377'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149010');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '旅游', 'XKW-ENG-181264', '1', 6, '2', '0', 'admin', now(), 'xkw:181264'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197377'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181264');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交通', 'XKW-ENG-41794', '1', 7, '2', '0', 'admin', now(), 'xkw:41794'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197377'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41794');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '历史', 'XKW-ENG-41800', '1', 1, '2', '0', 'admin', now(), 'xkw:41800'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41800');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '社会', 'XKW-ENG-41801', '1', 2, '2', '0', 'admin', now(), 'xkw:41801'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41801');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化交流 ', 'XKW-ENG-181262', '1', 3, '2', '0', 'admin', now(), 'xkw:181262'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181262');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '通讯与媒体', 'XKW-ENG-181249', '1', 4, '2', '0', 'admin', now(), 'xkw:181249'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181249');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '世界', 'XKW-ENG-41797', '1', 5, '2', '0', 'admin', now(), 'xkw:41797'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41797');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '著名人物', 'XKW-ENG-41904', '1', 6, '2', '0', 'admin', now(), 'xkw:41904'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41904');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '政治与经济', 'XKW-ENG-188817', '1', 7, '2', '0', 'admin', now(), 'xkw:188817'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188817');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '教育', 'XKW-ENG-188818', '1', 8, '2', '0', 'admin', now(), 'xkw:188818'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188818');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时代变迁', 'XKW-ENG-181270', '1', 9, '2', '0', 'admin', now(), 'xkw:181270'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181270');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '故事', 'XKW-ENG-41805', '1', 10, '2', '0', 'admin', now(), 'xkw:41805'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41805');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艺术与手工艺', 'XKW-ENG-197380', '1', 1, '2', '0', 'admin', now(), 'xkw:197380'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197380');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '习俗礼仪', 'XKW-ENG-197392', '1', 2, '2', '0', 'admin', now(), 'xkw:197392'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197392');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传统节日', 'XKW-ENG-197396', '1', 3, '2', '0', 'admin', now(), 'xkw:197396'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197396');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国元素', 'XKW-ENG-197406', '1', 4, '2', '0', 'admin', now(), 'xkw:197406'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197406');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体育与武术', 'XKW-ENG-197417', '1', 5, '2', '0', 'admin', now(), 'xkw:197417'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197417');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言文字', 'XKW-ENG-197422', '1', 6, '2', '0', 'admin', now(), 'xkw:197422'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197422');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '饮食文化', 'XKW-ENG-197427', '1', 7, '2', '0', 'admin', now(), 'xkw:197427'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197427');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '技术与发明', 'XKW-ENG-197433', '1', 8, '2', '0', 'admin', now(), 'xkw:197433'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197433');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人文思想', 'XKW-ENG-197438', '1', 9, '2', '0', 'admin', now(), 'xkw:197438'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197438');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发展历程', 'XKW-ENG-197443', '2', 10, '2', '0', 'admin', now(), 'xkw:197443'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197443');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中式建筑与园林', 'XKW-ENG-197444', '2', 11, '2', '0', 'admin', now(), 'xkw:197444'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197444');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国城市', 'XKW-ENG-197445', '2', 12, '2', '0', 'admin', now(), 'xkw:197445'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197445');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国河流', 'XKW-ENG-197446', '2', 13, '2', '0', 'admin', now(), 'xkw:197446'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197446');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '历史遗迹', 'XKW-ENG-197447', '2', 14, '2', '0', 'admin', now(), 'xkw:197447'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197447');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '风景名胜', 'XKW-ENG-197448', '2', 15, '2', '0', 'admin', now(), 'xkw:197448'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197448');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科学科普 ', 'XKW-ENG-41798', '1', 1, '2', '0', 'admin', now(), 'xkw:41798'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197449'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41798');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现代技术 ', 'XKW-ENG-197450', '1', 2, '2', '0', 'admin', now(), 'xkw:197450'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197449'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197450');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '碳足迹', 'XKW-ENG-188826', '2', 1, '2', '0', 'admin', now(), 'xkw:188826'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181282'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188826');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '环境保护', 'XKW-ENG-41893', '2', 2, '2', '0', 'admin', now(), 'xkw:41893'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181282'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41893');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '环境污染', 'XKW-ENG-41896', '2', 3, '2', '0', 'admin', now(), 'xkw:41896'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181282'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41896');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '空气污染', 'XKW-ENG-188827', '2', 4, '2', '0', 'admin', now(), 'xkw:188827'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181282'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188827');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态旅游', 'XKW-ENG-185716', '2', 5, '2', '0', 'admin', now(), 'xkw:185716'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181282'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185716');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人与环境', 'XKW-ENG-181283', '2', 6, '2', '0', 'admin', now(), 'xkw:181283'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181282'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181283');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '垃圾分类', 'XKW-ENG-181224', '2', 7, '2', '0', 'admin', now(), 'xkw:181224'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181282'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181224');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天气与气候', 'XKW-ENG-41792', '1', 1, '2', '0', 'admin', now(), 'xkw:41792'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197452'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41792');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '地理', 'XKW-ENG-181259', '1', 2, '2', '0', 'admin', now(), 'xkw:181259'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197452'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181259');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自然', 'XKW-ENG-41796', '1', 3, '2', '0', 'admin', now(), 'xkw:41796'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197452'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41796');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '户外探险', 'XKW-ENG-185707', '1', 4, '2', '0', 'admin', now(), 'xkw:185707'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197452'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185707');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自然灾害与防范', 'XKW-ENG-41877', '2', 1, '2', '0', 'admin', now(), 'xkw:41877'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41877');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '安全常识 ', 'XKW-ENG-197454', '2', 2, '2', '0', 'admin', now(), 'xkw:197454'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197454');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自我保护 ', 'XKW-ENG-197455', '2', 3, '2', '0', 'admin', now(), 'xkw:197455'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197453'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197455');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '航空航天', 'XKW-ENG-181227', '2', 1, '2', '0', 'admin', now(), 'xkw:181227'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197456'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181227');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天体和宇宙', 'XKW-ENG-41883', '2', 2, '2', '0', 'admin', now(), 'xkw:41883'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197456'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41883');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宇宙探险', 'XKW-ENG-188830', '2', 3, '2', '0', 'admin', now(), 'xkw:188830'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197456'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188830');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '直接理解', 'XKW-ENG-149111', '2', 1, '2', '0', 'admin', now(), 'xkw:149111'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149111');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语意转化', 'XKW-ENG-149112', '2', 2, '2', '0', 'admin', now(), 'xkw:149112'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149112');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '数字计算', 'XKW-ENG-149113', '2', 3, '2', '0', 'admin', now(), 'xkw:149113'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149113');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '正误判断', 'XKW-ENG-149114', '2', 4, '2', '0', 'admin', now(), 'xkw:149114'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149114');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细节排序', 'XKW-ENG-149115', '2', 5, '2', '0', 'admin', now(), 'xkw:149115'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149115');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '逻辑推理', 'XKW-ENG-149116', '2', 1, '2', '0', 'admin', now(), 'xkw:149116'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149116');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '观点态度', 'XKW-ENG-149117', '2', 2, '2', '0', 'admin', now(), 'xkw:149117'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149117');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '目的意图', 'XKW-ENG-149118', '2', 3, '2', '0', 'admin', now(), 'xkw:149118'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149118');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文章出处', 'XKW-ENG-149119', '2', 4, '2', '0', 'admin', now(), 'xkw:149119'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149119');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '读者对象', 'XKW-ENG-149120', '2', 5, '2', '0', 'admin', now(), 'xkw:149120'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149120');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '论证方式', 'XKW-ENG-149121', '2', 6, '2', '0', 'admin', now(), 'xkw:149121'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149121');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '篇章结构', 'XKW-ENG-149122', '2', 7, '2', '0', 'admin', now(), 'xkw:149122'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149122');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文章大意', 'XKW-ENG-149123', '2', 1, '2', '0', 'admin', now(), 'xkw:149123'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149108'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149123');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '段落大意', 'XKW-ENG-149124', '2', 2, '2', '0', 'admin', now(), 'xkw:149124'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149108'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149124');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '标题判断', 'XKW-ENG-149125', '2', 3, '2', '0', 'admin', now(), 'xkw:149125'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149108'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149125');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '词义猜测', 'XKW-ENG-149126', '2', 1, '2', '0', 'admin', now(), 'xkw:149126'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149126');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '短语猜测', 'XKW-ENG-149127', '2', 2, '2', '0', 'admin', now(), 'xkw:149127'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149127');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '指代猜测', 'XKW-ENG-149128', '2', 3, '2', '0', 'admin', now(), 'xkw:149128'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149128');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '句意猜测', 'XKW-ENG-149129', '2', 4, '2', '0', 'admin', now(), 'xkw:149129'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149129');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '习语猜测', 'XKW-ENG-149130', '2', 5, '2', '0', 'admin', now(), 'xkw:149130'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149130');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动词不定式的肯定结构', 'XKW-ENG-149028', '2', 1, '2', '0', 'admin', now(), 'xkw:149028'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148977'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149028');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动词不定式的否定结构', 'XKW-ENG-149029', '2', 2, '2', '0', 'admin', now(), 'xkw:149029'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148977'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149029');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式的一般式：to+动词原形', 'XKW-ENG-149031', '2', 1, '2', '0', 'admin', now(), 'xkw:149031'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149031');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式的完成式：to have done', 'XKW-ENG-149032', '2', 2, '2', '0', 'admin', now(), 'xkw:149032'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149032');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式的进行式：to be doing', 'XKW-ENG-149033', '2', 3, '2', '0', 'admin', now(), 'xkw:149033'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149033');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式的完成进行式：to have been doing', 'XKW-ENG-149034', '2', 4, '2', '0', 'admin', now(), 'xkw:149034'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149034');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式的被动语态', 'XKW-ENG-149035', '2', 5, '2', '0', 'admin', now(), 'xkw:149035'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148978'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149035');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式作目的状语', 'XKW-ENG-41621', '2', 1, '2', '0', 'admin', now(), 'xkw:41621'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41621');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式作结果状语', 'XKW-ENG-154235', '2', 2, '2', '0', 'admin', now(), 'xkw:154235'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154235');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式作原因状语', 'XKW-ENG-154236', '2', 3, '2', '0', 'admin', now(), 'xkw:154236'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154236');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式作主语', 'XKW-ENG-41622', '2', 4, '2', '0', 'admin', now(), 'xkw:41622'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41622');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式作宾语', 'XKW-ENG-41623', '2', 5, '2', '0', 'admin', now(), 'xkw:41623'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41623');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式作表语', 'XKW-ENG-41624', '2', 6, '2', '0', 'admin', now(), 'xkw:41624'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41624');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式作宾语补足语', 'XKW-ENG-41625', '2', 7, '2', '0', 'admin', now(), 'xkw:41625'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41625');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式作主语补足语', 'XKW-ENG-41626', '2', 8, '2', '0', 'admin', now(), 'xkw:41626'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41626');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式作定语', 'XKW-ENG-41627', '2', 9, '2', '0', 'admin', now(), 'xkw:41627'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41627');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不定式表示将要发生的动作', 'XKW-ENG-149036', '2', 10, '2', '0', 'admin', now(), 'xkw:149036'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149036');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '特殊疑问词加动词不定式的用法', 'XKW-ENG-149037', '2', 11, '2', '0', 'admin', now(), 'xkw:149037'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148979'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149037');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词的一般式：doing', 'XKW-ENG-149046', '2', 1, '2', '0', 'admin', now(), 'xkw:149046'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149043'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149046');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词的完成式：having done', 'XKW-ENG-149047', '2', 2, '2', '0', 'admin', now(), 'xkw:149047'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149043'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149047');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词的被动语态', 'XKW-ENG-149048', '2', 3, '2', '0', 'admin', now(), 'xkw:149048'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149043'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149048');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词作主语', 'XKW-ENG-41628', '2', 1, '2', '0', 'admin', now(), 'xkw:41628'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149044'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41628');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词作宾语', 'XKW-ENG-41629', '2', 2, '2', '0', 'admin', now(), 'xkw:41629'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149044'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41629');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词作定语', 'XKW-ENG-149049', '2', 3, '2', '0', 'admin', now(), 'xkw:149049'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149044'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149049');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动名词作表语', 'XKW-ENG-149050', '2', 4, '2', '0', 'admin', now(), 'xkw:149050'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149044'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149050');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词的一般式：doing', 'XKW-ENG-149038', '2', 1, '2', '0', 'admin', now(), 'xkw:149038'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149038');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词的完成式：having done', 'XKW-ENG-149039', '2', 2, '2', '0', 'admin', now(), 'xkw:149039'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149039');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词的被动语态', 'XKW-ENG-149040', '2', 3, '2', '0', 'admin', now(), 'xkw:149040'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149040');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词作表语', 'XKW-ENG-41630', '2', 1, '2', '0', 'admin', now(), 'xkw:41630'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41630');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词作定语', 'XKW-ENG-41631', '2', 2, '2', '0', 'admin', now(), 'xkw:41631'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41631');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词作补足语', 'XKW-ENG-41632', '2', 3, '2', '0', 'admin', now(), 'xkw:41632'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41632');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词作状语', 'XKW-ENG-41633', '2', 4, '2', '0', 'admin', now(), 'xkw:41633'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41633');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词表示主动意义', 'XKW-ENG-149041', '2', 5, '2', '0', 'admin', now(), 'xkw:149041'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149041');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '现在分词表示正在进行的动作', 'XKW-ENG-149042', '2', 6, '2', '0', 'admin', now(), 'xkw:149042'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149042');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'that, whether, as, as if, as though, because引导的表语从句 ', 'XKW-ENG-41745', '2', 1, '2', '0', 'admin', now(), 'xkw:41745'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149024'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41745');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '连接代词和连接副词引导的表语从句 ', 'XKW-ENG-41746', '2', 2, '2', '0', 'admin', now(), 'xkw:41746'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149024'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41746');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'that,if, whether引导的宾语从句 ', 'XKW-ENG-41747', '2', 1, '2', '0', 'admin', now(), 'xkw:41747'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41747');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '连接代词和连接副词引导的宾语从句 ', 'XKW-ENG-41748', '2', 2, '2', '0', 'admin', now(), 'xkw:41748'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-148996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41748');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '陈述句', 'XKW-ENG-41762', '2', 1, '2', '0', 'admin', now(), 'xkw:41762'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41736'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41762');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般疑问句', 'XKW-ENG-41763', '2', 2, '2', '0', 'admin', now(), 'xkw:41763'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41736'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41763');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '特殊疑问句', 'XKW-ENG-41764', '2', 3, '2', '0', 'admin', now(), 'xkw:41764'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41736'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41764');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '祈使句', 'XKW-ENG-41765', '2', 4, '2', '0', 'admin', now(), 'xkw:41765'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41736'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41765');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系代词that引导限制性定语从句', 'XKW-ENG-149077', '2', 1, '2', '0', 'admin', now(), 'xkw:149077'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149077');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系代词which引导限制性定语从句', 'XKW-ENG-149078', '2', 2, '2', '0', 'admin', now(), 'xkw:149078'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149078');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系代词who引导限制性定语从句', 'XKW-ENG-149079', '2', 3, '2', '0', 'admin', now(), 'xkw:149079'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149079');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系代词whom引导限制性定语从句', 'XKW-ENG-149080', '2', 4, '2', '0', 'admin', now(), 'xkw:149080'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149080');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系代词whose引导限制性定语从句', 'XKW-ENG-149081', '2', 5, '2', '0', 'admin', now(), 'xkw:149081'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149081');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'as引导限制性定语从句', 'XKW-ENG-149082', '2', 6, '2', '0', 'admin', now(), 'xkw:149082'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149082');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系副词when引导限制性定语从句', 'XKW-ENG-149083', '2', 1, '2', '0', 'admin', now(), 'xkw:149083'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149001'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149083');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系副词where引导限制性定语从句', 'XKW-ENG-149084', '2', 2, '2', '0', 'admin', now(), 'xkw:149084'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149001'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149084');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系副词why引导限制性定语从句', 'XKW-ENG-149085', '2', 3, '2', '0', 'admin', now(), 'xkw:149085'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149001'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149085');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关系副词=介词+关系代词', 'XKW-ENG-149086', '2', 4, '2', '0', 'admin', now(), 'xkw:149086'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149001'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149086');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'who引导非限制性定语从句', 'XKW-ENG-149087', '2', 1, '2', '0', 'admin', now(), 'xkw:149087'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149003'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149087');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'whom引导非限制性定语从句', 'XKW-ENG-149088', '2', 2, '2', '0', 'admin', now(), 'xkw:149088'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149003'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149088');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'whose引导非限制性定语从句', 'XKW-ENG-149089', '2', 3, '2', '0', 'admin', now(), 'xkw:149089'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149003'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149089');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'which引导非限制性定语从句', 'XKW-ENG-149090', '2', 4, '2', '0', 'admin', now(), 'xkw:149090'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149003'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149090');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'as引导非限制性定语从句', 'XKW-ENG-149091', '2', 5, '2', '0', 'admin', now(), 'xkw:149091'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149003'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149091');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“介词+关系代词”引导的非限制性定语从句', 'XKW-ENG-149092', '2', 6, '2', '0', 'admin', now(), 'xkw:149092'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149003'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149092');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'when引导的非限制性定语从句', 'XKW-ENG-149093', '2', 1, '2', '0', 'admin', now(), 'xkw:149093'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149004'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149093');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'where引导的非限制性定语从句', 'XKW-ENG-149094', '2', 2, '2', '0', 'admin', now(), 'xkw:149094'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149004'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149094');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非限制性定语从句不可用that', 'XKW-ENG-149095', '2', 1, '2', '0', 'admin', now(), 'xkw:149095'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149005'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149095');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非限制性定语从句不可用why，用for which代替why', 'XKW-ENG-149096', '2', 2, '2', '0', 'admin', now(), 'xkw:149096'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149005'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149096');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'can/could表示能力', 'XKW-ENG-154571', '2', 1, '2', '0', 'admin', now(), 'xkw:154571'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-154570'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154571');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'can/could表示推测', 'XKW-ENG-154572', '2', 2, '2', '0', 'admin', now(), 'xkw:154572'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-154570'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154572');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'can/could表示请求', 'XKW-ENG-154573', '2', 3, '2', '0', 'admin', now(), 'xkw:154573'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-154570'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154573');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'may/might表示“可以”', 'XKW-ENG-154575', '2', 1, '2', '0', 'admin', now(), 'xkw:154575'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-154574'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154575');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'may/might表示推测', 'XKW-ENG-154576', '2', 2, '2', '0', 'admin', now(), 'xkw:154576'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-154574'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154576');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'must表示“必须”“应当”', 'XKW-ENG-154578', '2', 1, '2', '0', 'admin', now(), 'xkw:154578'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-154577'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154578');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'must表示推测', 'XKW-ENG-154579', '2', 2, '2', '0', 'admin', now(), 'xkw:154579'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-154577'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154579');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'mustn''t的用法', 'XKW-ENG-154580', '2', 3, '2', '0', 'admin', now(), 'xkw:154580'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-154577'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-154580');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '疑问代词', 'XKW-ENG-41587', '2', 1, '2', '0', 'admin', now(), 'xkw:41587'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41724'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41587');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '疑问副词', 'XKW-ENG-41656', '2', 2, '2', '0', 'admin', now(), 'xkw:41656'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41724'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41656');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人信息 ', 'XKW-ENG-41807', '2', 1, '2', '0', 'admin', now(), 'xkw:41807'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41779'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41807');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人经历', 'XKW-ENG-181231', '2', 2, '2', '0', 'admin', now(), 'xkw:181231'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41779'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181231');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家庭信息', 'XKW-ENG-41808', '2', 3, '2', '0', 'admin', now(), 'xkw:41808'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41779'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41808');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '学校信息 ', 'XKW-ENG-41809', '2', 4, '2', '0', 'admin', now(), 'xkw:41809'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41779'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41809');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '服饰穿戴', 'XKW-ENG-41906', '2', 1, '2', '0', 'admin', now(), 'xkw:41906'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188769'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41906');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '礼仪修养', 'XKW-ENG-188770', '2', 2, '2', '0', 'admin', now(), 'xkw:188770'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188769'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188770');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '外貌与神态', 'XKW-ENG-188771', '2', 3, '2', '0', 'admin', now(), 'xkw:188771'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188769'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188771');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '言谈举止', 'XKW-ENG-188772', '2', 4, '2', '0', 'admin', now(), 'xkw:188772'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188769'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188772');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '游戏', 'XKW-ENG-41827', '2', 1, '2', '0', 'admin', now(), 'xkw:41827'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41784'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41827');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '爱好', 'XKW-ENG-41828', '2', 2, '2', '0', 'admin', now(), 'xkw:41828'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41784'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41828');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '阅读 ', 'XKW-ENG-41829', '2', 3, '2', '0', 'admin', now(), 'xkw:41829'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41784'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41829');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '娱乐活动 ', 'XKW-ENG-41830', '2', 4, '2', '0', 'admin', now(), 'xkw:41830'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41784'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41830');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '兴趣社交', 'XKW-ENG-41831', '2', 5, '2', '0', 'admin', now(), 'xkw:41831'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41784'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41831');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家人和亲人 ', 'XKW-ENG-41812', '2', 1, '2', '0', 'admin', now(), 'xkw:41812'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41812');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '朋友 ', 'XKW-ENG-41813', '2', 2, '2', '0', 'admin', now(), 'xkw:41813'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41813');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他人物关系', 'XKW-ENG-41814', '2', 3, '2', '0', 'admin', now(), 'xkw:41814'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41814');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '房屋和家居', 'XKW-ENG-41815', '2', 1, '2', '0', 'admin', now(), 'xkw:41815'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41781'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41815');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '周边环境与场所', 'XKW-ENG-41816', '2', 2, '2', '0', 'admin', now(), 'xkw:41816'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41781'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41816');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '公园', 'XKW-ENG-188774', '2', 3, '2', '0', 'admin', now(), 'xkw:188774'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41781'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188774');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '房屋与租赁 ', 'XKW-ENG-197370', '2', 4, '2', '0', 'admin', now(), 'xkw:197370'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41781'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197370');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家庭生活 ', 'XKW-ENG-41817', '2', 1, '2', '0', 'admin', now(), 'xkw:41817'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41782'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41817');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '闲暇活动 ', 'XKW-ENG-41819', '2', 2, '2', '0', 'admin', now(), 'xkw:41819'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41782'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41819');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时间管理', 'XKW-ENG-185708', '2', 3, '2', '0', 'admin', now(), 'xkw:185708'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41782'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185708');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '日常生活 ', 'XKW-ENG-41822', '2', 4, '2', '0', 'admin', now(), 'xkw:41822'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41782'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41822');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家庭问题', 'XKW-ENG-188775', '2', 5, '2', '0', 'admin', now(), 'xkw:188775'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41782'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188775');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '邮局与邮寄 ', 'XKW-ENG-197371', '2', 6, '2', '0', 'admin', now(), 'xkw:197371'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41782'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197371');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '学习', 'XKW-ENG-41823', '2', 1, '2', '0', 'admin', now(), 'xkw:41823'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41823');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '网课', 'XKW-ENG-181236', '2', 2, '2', '0', 'admin', now(), 'xkw:181236'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181236');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '课程', 'XKW-ENG-41826', '2', 3, '2', '0', 'admin', now(), 'xkw:41826'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41826');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '学校人员 ', 'XKW-ENG-41824', '2', 4, '2', '0', 'admin', now(), 'xkw:41824'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41824');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '学校活动', 'XKW-ENG-41825', '2', 5, '2', '0', 'admin', now(), 'xkw:41825'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41825');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '校园安全', 'XKW-ENG-181235', '2', 6, '2', '0', 'admin', now(), 'xkw:181235'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181235');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '大学生活', 'XKW-ENG-188776', '2', 7, '2', '0', 'admin', now(), 'xkw:188776'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188776');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '高中生活', 'XKW-ENG-188777', '2', 8, '2', '0', 'admin', now(), 'xkw:188777'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188777');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '专业选择', 'XKW-ENG-188778', '2', 9, '2', '0', 'admin', now(), 'xkw:188778'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188778');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '校园俱乐部', 'XKW-ENG-188779', '2', 10, '2', '0', 'admin', now(), 'xkw:188779'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188779');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '图书馆与借书 ', 'XKW-ENG-197372', '2', 11, '2', '0', 'admin', now(), 'xkw:197372'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41783'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197372');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '假日活动', 'XKW-ENG-181237', '2', 1, '2', '0', 'admin', now(), 'xkw:181237'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41788'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181237');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '庆祝活动 ', 'XKW-ENG-41820', '2', 2, '2', '0', 'admin', now(), 'xkw:41820'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41788'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41820');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人庆典', 'XKW-ENG-41840', '2', 3, '2', '0', 'admin', now(), 'xkw:41840'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41788'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41840');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '认识压力', 'XKW-ENG-188790', '2', 1, '2', '0', 'admin', now(), 'xkw:188790'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-185706'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188790');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '迎接挑战', 'XKW-ENG-188791', '2', 2, '2', '0', 'admin', now(), 'xkw:188791'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-185706'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188791');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '认识成功', 'XKW-ENG-188792', '2', 3, '2', '0', 'admin', now(), 'xkw:188792'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-185706'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188792');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '商品 ', 'XKW-ENG-41841', '2', 1, '2', '0', 'admin', now(), 'xkw:41841'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41789'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41841');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时尚 ', 'XKW-ENG-41842', '2', 2, '2', '0', 'admin', now(), 'xkw:41842'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41789'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41842');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '网购', 'XKW-ENG-181238', '2', 3, '2', '0', 'admin', now(), 'xkw:181238'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41789'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181238');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '购物选择', 'XKW-ENG-41843', '2', 4, '2', '0', 'admin', now(), 'xkw:41843'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41789'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41843');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '支付方式', 'XKW-ENG-181239', '2', 5, '2', '0', 'admin', now(), 'xkw:181239'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41789'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181239');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人购物喜好', 'XKW-ENG-181240', '2', 6, '2', '0', 'admin', now(), 'xkw:181240'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41789'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181240');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '商品价格 ', 'XKW-ENG-197373', '2', 7, '2', '0', 'admin', now(), 'xkw:197373'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41789'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197373');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体态语', 'XKW-ENG-41876', '2', 1, '2', '0', 'admin', now(), 'xkw:41876'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41795'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41876');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言与文化 ', 'XKW-ENG-41874', '2', 2, '2', '0', 'admin', now(), 'xkw:41874'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41795'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41874');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言学习经历', 'XKW-ENG-41873', '2', 3, '2', '0', 'admin', now(), 'xkw:41873'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41795'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41873');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言学习策略', 'XKW-ENG-41875', '2', 4, '2', '0', 'admin', now(), 'xkw:41875'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41795'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41875');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言变化及发展', 'XKW-ENG-188793', '2', 5, '2', '0', 'admin', now(), 'xkw:188793'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41795'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188793');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '食物与饮料 ', 'XKW-ENG-41844', '2', 1, '2', '0', 'admin', now(), 'xkw:41844'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41790'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41844');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '饮食习俗 ', 'XKW-ENG-41845', '2', 2, '2', '0', 'admin', now(), 'xkw:41845'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41790'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41845');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '点餐 ', 'XKW-ENG-41846', '2', 3, '2', '0', 'admin', now(), 'xkw:41846'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41790'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41846');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '烹饪 ', 'XKW-ENG-41847', '2', 4, '2', '0', 'admin', now(), 'xkw:41847'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41790'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41847');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '对食物的喜恶', 'XKW-ENG-41848', '2', 5, '2', '0', 'admin', now(), 'xkw:41848'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41790'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41848');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '医疗 ', 'XKW-ENG-41849', '2', 1, '2', '0', 'admin', now(), 'xkw:41849'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41849');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '疾病 ', 'XKW-ENG-41850', '2', 2, '2', '0', 'admin', now(), 'xkw:41850'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41850');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '减肥', 'XKW-ENG-181241', '2', 3, '2', '0', 'admin', now(), 'xkw:181241'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181241');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '健康饮食 ', 'XKW-ENG-41851', '2', 4, '2', '0', 'admin', now(), 'xkw:41851'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41851');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '身体部位 ', 'XKW-ENG-41853', '2', 5, '2', '0', 'admin', now(), 'xkw:41853'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41853');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人保健', 'XKW-ENG-41854', '2', 6, '2', '0', 'admin', now(), 'xkw:41854'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41854');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '医护人员', 'XKW-ENG-41856', '2', 7, '2', '0', 'admin', now(), 'xkw:41856'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41856');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '安全与救护', 'XKW-ENG-181242', '2', 8, '2', '0', 'admin', now(), 'xkw:181242'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181242');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '锻炼/健身（个人）', 'XKW-ENG-181243', '2', 9, '2', '0', 'admin', now(), 'xkw:181243'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181243');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '新型冠状病毒', 'XKW-ENG-181222', '2', 10, '2', '0', 'admin', now(), 'xkw:181222'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41791'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181222');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计划', 'XKW-ENG-41837', '2', 1, '2', '0', 'admin', now(), 'xkw:41837'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41787'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41837');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '愿望', 'XKW-ENG-41838', '2', 2, '2', '0', 'admin', now(), 'xkw:41838'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41787'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41838');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '职业规划', 'XKW-ENG-181233', '2', 1, '2', '0', 'admin', now(), 'xkw:181233'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181232'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181233');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '创业意识', 'XKW-ENG-181234', '2', 2, '2', '0', 'admin', now(), 'xkw:181234'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181232'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181234');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '职业内容', 'XKW-ENG-41811', '2', 3, '2', '0', 'admin', now(), 'xkw:41811'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181232'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41811');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '个人简历', 'XKW-ENG-188773', '2', 4, '2', '0', 'admin', now(), 'xkw:188773'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181232'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188773');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '勤劳', 'XKW-ENG-188781', '2', 1, '2', '0', 'admin', now(), 'xkw:188781'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188781');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '勇敢', 'XKW-ENG-188782', '2', 2, '2', '0', 'admin', now(), 'xkw:188782'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188782');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '幽默', 'XKW-ENG-188783', '2', 3, '2', '0', 'admin', now(), 'xkw:188783'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188783');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '坚韧', 'XKW-ENG-188784', '2', 4, '2', '0', 'admin', now(), 'xkw:188784'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188784');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同理心', 'XKW-ENG-188785', '2', 5, '2', '0', 'admin', now(), 'xkw:188785'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188785');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诚实守信', 'XKW-ENG-188786', '2', 6, '2', '0', 'admin', now(), 'xkw:188786'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188786');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宽容大度', 'XKW-ENG-188787', '2', 7, '2', '0', 'admin', now(), 'xkw:188787'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188787');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '乐于助人', 'XKW-ENG-188788', '2', 8, '2', '0', 'admin', now(), 'xkw:188788'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188788');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '工匠精神', 'XKW-ENG-188789', '2', 9, '2', '0', 'admin', now(), 'xkw:188789'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188789');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '节约意识', 'XKW-ENG-181511', '2', 10, '2', '0', 'admin', now(), 'xkw:181511'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188780'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181511');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情绪', 'XKW-ENG-41832', '2', 1, '2', '0', 'admin', now(), 'xkw:41832'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41785'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41832');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '情感', 'XKW-ENG-41833', '2', 2, '2', '0', 'admin', now(), 'xkw:41833'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41785'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41833');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '哲理感悟', 'XKW-ENG-41806', '2', 1, '2', '0', 'admin', now(), 'xkw:41806'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197375'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41806');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '方法/策略', 'XKW-ENG-41803', '2', 2, '2', '0', 'admin', now(), 'xkw:41803'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197375'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41803');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '申请/请求/建议', 'XKW-ENG-149008', '2', 3, '2', '0', 'admin', now(), 'xkw:149008'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197375'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149008');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '邀请', 'XKW-ENG-149009', '2', 4, '2', '0', 'admin', now(), 'xkw:149009'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197375'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149009');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '友谊', 'XKW-ENG-41834', '2', 1, '2', '0', 'admin', now(), 'xkw:41834'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41786'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41834');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '社会关系', 'XKW-ENG-41835', '2', 2, '2', '0', 'admin', now(), 'xkw:41835'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41786'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41835');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家庭关系', 'XKW-ENG-181245', '2', 3, '2', '0', 'admin', now(), 'xkw:181245'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41786'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181245');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '网络社交', 'XKW-ENG-188794', '2', 4, '2', '0', 'admin', now(), 'xkw:188794'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41786'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188794');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '合作与交流', 'XKW-ENG-181246', '2', 5, '2', '0', 'admin', now(), 'xkw:181246'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41786'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181246');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冲突与和解', 'XKW-ENG-188795', '2', 6, '2', '0', 'admin', now(), 'xkw:188795'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41786'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188795');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '社交礼仪及规则', 'XKW-ENG-188796', '2', 7, '2', '0', 'admin', now(), 'xkw:188796'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41786'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188796');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '善行义举（个人）', 'XKW-ENG-181248', '2', 1, '2', '0', 'admin', now(), 'xkw:181248'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181248');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '公益活动（组织机构）', 'XKW-ENG-41821', '2', 2, '2', '0', 'admin', now(), 'xkw:41821'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41821');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人物传记', 'XKW-ENG-188808', '2', 1, '2', '0', 'admin', now(), 'xkw:188808'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188807'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188808');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '寓言童话', 'XKW-ENG-188809', '2', 2, '2', '0', 'admin', now(), 'xkw:188809'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188807'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188809');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诗歌文学', 'XKW-ENG-188810', '2', 3, '2', '0', 'admin', now(), 'xkw:188810'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188807'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188810');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文学形式与文学作品', 'XKW-ENG-41911', '2', 4, '2', '0', 'admin', now(), 'xkw:41911'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188807'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41911');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电影与戏剧', 'XKW-ENG-41862', '2', 1, '2', '0', 'admin', now(), 'xkw:41862'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41862');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '音乐与舞蹈', 'XKW-ENG-41863', '2', 2, '2', '0', 'admin', now(), 'xkw:41863'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41863');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '美术与摄影', 'XKW-ENG-41912', '2', 3, '2', '0', 'admin', now(), 'xkw:41912'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41912');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艺术作品', 'XKW-ENG-188798', '2', 4, '2', '0', 'admin', now(), 'xkw:188798'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188798');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艺术史', 'XKW-ENG-188799', '2', 5, '2', '0', 'admin', now(), 'xkw:188799'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188799');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诗歌', 'XKW-ENG-188801', '2', 1, '2', '0', 'admin', now(), 'xkw:188801'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188801');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '小说', 'XKW-ENG-188802', '2', 2, '2', '0', 'admin', now(), 'xkw:188802'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188802');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '戏剧', 'XKW-ENG-188803', '2', 3, '2', '0', 'admin', now(), 'xkw:188803'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188803');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '散文', 'XKW-ENG-188804', '2', 4, '2', '0', 'admin', now(), 'xkw:188804'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188804');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '童话', 'XKW-ENG-188805', '2', 5, '2', '0', 'admin', now(), 'xkw:188805'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188805');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '寓言', 'XKW-ENG-188806', '2', 6, '2', '0', 'admin', now(), 'xkw:188806'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188806');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '竞技/比赛', 'XKW-ENG-41864', '2', 1, '2', '0', 'admin', now(), 'xkw:41864'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41864');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体育健身 ', 'XKW-ENG-41852', '2', 2, '2', '0', 'admin', now(), 'xkw:41852'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41852');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体育精神', 'XKW-ENG-181251', '2', 3, '2', '0', 'admin', now(), 'xkw:181251'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181251');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '运动种类', 'XKW-ENG-188811', '2', 4, '2', '0', 'admin', now(), 'xkw:188811'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188811');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体育运动规则', 'XKW-ENG-188812', '2', 5, '2', '0', 'admin', now(), 'xkw:188812'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188812');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '新北京冬奥会', 'XKW-ENG-181223', '2', 6, '2', '0', 'admin', now(), 'xkw:181223'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-149010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181223');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '旅游观光', 'XKW-ENG-41866', '2', 1, '2', '0', 'admin', now(), 'xkw:41866'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181264'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41866');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '城市', 'XKW-ENG-181265', '2', 2, '2', '0', 'admin', now(), 'xkw:181265'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181264'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181265');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '建筑', 'XKW-ENG-181266', '2', 3, '2', '0', 'admin', now(), 'xkw:181266'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181264'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181266');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '问路', 'XKW-ENG-41869', '2', 1, '2', '0', 'admin', now(), 'xkw:41869'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41794'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41869');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交通方式', 'XKW-ENG-41870', '2', 2, '2', '0', 'admin', now(), 'xkw:41870'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41794'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41870');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交通规则', 'XKW-ENG-41871', '2', 3, '2', '0', 'admin', now(), 'xkw:41871'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41794'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41871');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '行程描绘', 'XKW-ENG-41872', '2', 4, '2', '0', 'admin', now(), 'xkw:41872'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41794'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41872');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交通与运输 ', 'XKW-ENG-41867', '2', 5, '2', '0', 'admin', now(), 'xkw:41867'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41794'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41867');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '历史知识', 'XKW-ENG-41899', '2', 1, '2', '0', 'admin', now(), 'xkw:41899'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41899');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '历史事件', 'XKW-ENG-41901', '2', 2, '2', '0', 'admin', now(), 'xkw:41901'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41901');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '考古发现', 'XKW-ENG-181260', '2', 3, '2', '0', 'admin', now(), 'xkw:181260'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181260');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '组织与机构', 'XKW-ENG-149013', '2', 1, '2', '0', 'admin', now(), 'xkw:149013'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149013');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '犯罪与惩罚', 'XKW-ENG-41894', '2', 2, '2', '0', 'admin', now(), 'xkw:41894'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41894');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '危险与安全', 'XKW-ENG-185713', '2', 3, '2', '0', 'admin', now(), 'xkw:185713'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185713');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '奖励与惩罚', 'XKW-ENG-188813', '2', 4, '2', '0', 'admin', now(), 'xkw:188813'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188813');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '可持续农业', 'XKW-ENG-188814', '2', 5, '2', '0', 'admin', now(), 'xkw:188814'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188814');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '贫困问题', 'XKW-ENG-188815', '2', 6, '2', '0', 'admin', now(), 'xkw:188815'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188815');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '劳工就业', 'XKW-ENG-188816', '2', 7, '2', '0', 'admin', now(), 'xkw:188816'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188816');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '意外事故', 'XKW-ENG-41898', '2', 8, '2', '0', 'admin', now(), 'xkw:41898'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41898');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '社会问题与社会现象', 'XKW-ENG-41897', '2', 9, '2', '0', 'admin', now(), 'xkw:41897'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41897');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宗教与文化', 'XKW-ENG-41907', '2', 1, '2', '0', 'admin', now(), 'xkw:41907'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41907');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化差异', 'XKW-ENG-181263', '2', 2, '2', '0', 'admin', now(), 'xkw:181263'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181263');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化保护', 'XKW-ENG-41892', '2', 3, '2', '0', 'admin', now(), 'xkw:41892'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41892');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化传播', 'XKW-ENG-185714', '2', 4, '2', '0', 'admin', now(), 'xkw:185714'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185714');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '未知文化', 'XKW-ENG-185715', '2', 5, '2', '0', 'admin', now(), 'xkw:185715'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185715');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化遗产', 'XKW-ENG-188824', '2', 6, '2', '0', 'admin', now(), 'xkw:188824'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188824');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国文化与节日', 'XKW-ENG-41908', '2', 7, '2', '0', 'admin', now(), 'xkw:41908'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41908');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '外国文化与节日', 'XKW-ENG-41839', '2', 8, '2', '0', 'admin', now(), 'xkw:41839'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181262'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41839');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电视与电台', 'XKW-ENG-149011', '2', 1, '2', '0', 'admin', now(), 'xkw:149011'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149011');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '印刷媒体', 'XKW-ENG-149012', '2', 2, '2', '0', 'admin', now(), 'xkw:149012'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-149012');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '观众和粉丝', 'XKW-ENG-41865', '2', 3, '2', '0', 'admin', now(), 'xkw:41865'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41865');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '广告/布告', 'XKW-ENG-41804', '2', 4, '2', '0', 'admin', now(), 'xkw:41804'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41804');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微信/微博/短视频', 'XKW-ENG-181250', '2', 5, '2', '0', 'admin', now(), 'xkw:181250'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181250');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '战争与和平', 'XKW-ENG-185712', '2', 1, '2', '0', 'admin', now(), 'xkw:185712'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185712');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '国家与民族 ', 'XKW-ENG-41884', '2', 2, '2', '0', 'admin', now(), 'xkw:41884'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41884');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '国籍和人民', 'XKW-ENG-41903', '2', 3, '2', '0', 'admin', now(), 'xkw:41903'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41903');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全球一体化', 'XKW-ENG-185710', '2', 4, '2', '0', 'admin', now(), 'xkw:185710'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185710');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '民族信仰', 'XKW-ENG-185711', '2', 5, '2', '0', 'admin', now(), 'xkw:185711'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185711');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人口 ', 'XKW-ENG-41885', '2', 6, '2', '0', 'admin', now(), 'xkw:41885'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41797'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41885');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科学家', 'XKW-ENG-181252', '2', 1, '2', '0', 'admin', now(), 'xkw:181252'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181252');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文学家', 'XKW-ENG-181253', '2', 2, '2', '0', 'admin', now(), 'xkw:181253'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181253');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '艺术家', 'XKW-ENG-181254', '2', 3, '2', '0', 'admin', now(), 'xkw:181254'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181254');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '政治家', 'XKW-ENG-181255', '2', 4, '2', '0', 'admin', now(), 'xkw:181255'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181255');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体育名人', 'XKW-ENG-181256', '2', 5, '2', '0', 'admin', now(), 'xkw:181256'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181256');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '商业人物', 'XKW-ENG-181257', '2', 6, '2', '0', 'admin', now(), 'xkw:181257'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181257');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他著名人物', 'XKW-ENG-181258', '2', 7, '2', '0', 'admin', now(), 'xkw:181258'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181258');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '法律法治', 'XKW-ENG-41905', '2', 1, '2', '0', 'admin', now(), 'xkw:41905'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188817'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41905');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '政治政策', 'XKW-ENG-41910', '2', 2, '2', '0', 'admin', now(), 'xkw:41910'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188817'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41910');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '市场与经济', 'XKW-ENG-181261', '2', 3, '2', '0', 'admin', now(), 'xkw:181261'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188817'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181261');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文化知识教育', 'XKW-ENG-188819', '2', 1, '2', '0', 'admin', now(), 'xkw:188819'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188818'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188819');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '习惯养成教育', 'XKW-ENG-188820', '2', 2, '2', '0', 'admin', now(), 'xkw:188820'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188818'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188820');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '才艺竞技教育', 'XKW-ENG-188821', '2', 3, '2', '0', 'admin', now(), 'xkw:188821'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188818'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188821');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '思想品德教育', 'XKW-ENG-188822', '2', 4, '2', '0', 'admin', now(), 'xkw:188822'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188818'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188822');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '当代教育问题', 'XKW-ENG-188823', '2', 5, '2', '0', 'admin', now(), 'xkw:188823'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-188818'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188823');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '叙事忆旧', 'XKW-ENG-181271', '2', 1, '2', '0', 'admin', now(), 'xkw:181271'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181270'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181271');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '畅想未来', 'XKW-ENG-41891', '2', 2, '2', '0', 'admin', now(), 'xkw:41891'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181270'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41891');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过去与未来', 'XKW-ENG-181272', '2', 3, '2', '0', 'admin', now(), 'xkw:181272'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181270'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181272');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生活故事', 'XKW-ENG-181273', '2', 1, '2', '0', 'admin', now(), 'xkw:181273'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41805'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181273');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '寓言故事', 'XKW-ENG-181274', '2', 2, '2', '0', 'admin', now(), 'xkw:181274'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41805'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181274');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '励志故事', 'XKW-ENG-181275', '2', 3, '2', '0', 'admin', now(), 'xkw:181275'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41805'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181275');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '历史故事', 'XKW-ENG-181276', '2', 4, '2', '0', 'admin', now(), 'xkw:181276'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41805'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181276');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物故事', 'XKW-ENG-181277', '2', 5, '2', '0', 'admin', now(), 'xkw:181277'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41805'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181277');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '京剧', 'XKW-ENG-197381', '2', 1, '2', '0', 'admin', now(), 'xkw:197381'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197381');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '地方戏剧', 'XKW-ENG-197382', '2', 2, '2', '0', 'admin', now(), 'xkw:197382'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197382');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '皮影戏', 'XKW-ENG-197383', '2', 3, '2', '0', 'admin', now(), 'xkw:197383'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197383');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '书法', 'XKW-ENG-197384', '2', 4, '2', '0', 'admin', now(), 'xkw:197384'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197384');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '棋类', 'XKW-ENG-197385', '2', 5, '2', '0', 'admin', now(), 'xkw:197385'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197385');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '国画', 'XKW-ENG-197386', '2', 6, '2', '0', 'admin', now(), 'xkw:197386'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197386');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '剪纸', 'XKW-ENG-197387', '2', 7, '2', '0', 'admin', now(), 'xkw:197387'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197387');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刺绣', 'XKW-ENG-197388', '2', 8, '2', '0', 'admin', now(), 'xkw:197388'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197388');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '丝绸', 'XKW-ENG-197389', '2', 9, '2', '0', 'admin', now(), 'xkw:197389'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197389');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传统乐器', 'XKW-ENG-197390', '2', 10, '2', '0', 'admin', now(), 'xkw:197390'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197390');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传统服饰', 'XKW-ENG-197391', '2', 11, '2', '0', 'admin', now(), 'xkw:197391'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197391');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '打招呼', 'XKW-ENG-197393', '2', 1, '2', '0', 'admin', now(), 'xkw:197393'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197392'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197393');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '婚礼', 'XKW-ENG-197394', '2', 2, '2', '0', 'admin', now(), 'xkw:197394'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197392'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197394');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '民族舞蹈', 'XKW-ENG-197395', '2', 3, '2', '0', 'admin', now(), 'xkw:197395'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197392'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197395');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '春节', 'XKW-ENG-197397', '2', 1, '2', '0', 'admin', now(), 'xkw:197397'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197397');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '元宵节', 'XKW-ENG-197398', '2', 2, '2', '0', 'admin', now(), 'xkw:197398'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197398');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '清明节', 'XKW-ENG-197399', '2', 3, '2', '0', 'admin', now(), 'xkw:197399'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197399');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '端午节', 'XKW-ENG-197400', '2', 4, '2', '0', 'admin', now(), 'xkw:197400'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197400');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '七夕节', 'XKW-ENG-197401', '2', 5, '2', '0', 'admin', now(), 'xkw:197401'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197401');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中秋节', 'XKW-ENG-197402', '2', 6, '2', '0', 'admin', now(), 'xkw:197402'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197402');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重阳节', 'XKW-ENG-197403', '2', 7, '2', '0', 'admin', now(), 'xkw:197403'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197403');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '腊八节', 'XKW-ENG-197404', '2', 8, '2', '0', 'admin', now(), 'xkw:197404'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197404');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '民族节日', 'XKW-ENG-197405', '2', 9, '2', '0', 'admin', now(), 'xkw:197405'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197405');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '二十四节气', 'XKW-ENG-197407', '2', 1, '2', '0', 'admin', now(), 'xkw:197407'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197407');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国龙', 'XKW-ENG-197408', '2', 2, '2', '0', 'admin', now(), 'xkw:197408'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197408');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国结', 'XKW-ENG-197409', '2', 3, '2', '0', 'admin', now(), 'xkw:197409'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197409');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '灯笼', 'XKW-ENG-197410', '2', 4, '2', '0', 'admin', now(), 'xkw:197410'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197410');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '算盘', 'XKW-ENG-197411', '2', 5, '2', '0', 'admin', now(), 'xkw:197411'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197411');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '文房四宝', 'XKW-ENG-197412', '2', 6, '2', '0', 'admin', now(), 'xkw:197412'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197412');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天干地支', 'XKW-ENG-197413', '2', 7, '2', '0', 'admin', now(), 'xkw:197413'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197413');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中医', 'XKW-ENG-197414', '2', 8, '2', '0', 'admin', now(), 'xkw:197414'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197414');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '扎染', 'XKW-ENG-197415', '2', 9, '2', '0', 'admin', now(), 'xkw:197415'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197415');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万年历', 'XKW-ENG-197416', '2', 10, '2', '0', 'admin', now(), 'xkw:197416'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197416');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国功夫', 'XKW-ENG-197418', '2', 1, '2', '0', 'admin', now(), 'xkw:197418'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197418');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '八段锦', 'XKW-ENG-197419', '2', 2, '2', '0', 'admin', now(), 'xkw:197419'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197419');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蹴鞠', 'XKW-ENG-197420', '2', 3, '2', '0', 'admin', now(), 'xkw:197420'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197420');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '太极拳', 'XKW-ENG-197421', '2', 4, '2', '0', 'admin', now(), 'xkw:197421'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197421');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '汉字', 'XKW-ENG-197423', '2', 1, '2', '0', 'admin', now(), 'xkw:197423'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197422'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197423');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中国颜色文化', 'XKW-ENG-197424', '2', 2, '2', '0', 'admin', now(), 'xkw:197424'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197422'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197424');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '成语与成语故事', 'XKW-ENG-197425', '2', 3, '2', '0', 'admin', now(), 'xkw:197425'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197422'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197425');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '寓言/神话故事/名著故事', 'XKW-ENG-197426', '2', 4, '2', '0', 'admin', now(), 'xkw:197426'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197422'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197426');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '茶文化', 'XKW-ENG-197428', '2', 1, '2', '0', 'admin', now(), 'xkw:197428'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197428');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传统食物', 'XKW-ENG-197429', '2', 2, '2', '0', 'admin', now(), 'xkw:197429'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197429');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '筷子', 'XKW-ENG-197430', '2', 3, '2', '0', 'admin', now(), 'xkw:197430'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197430');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '餐桌礼仪', 'XKW-ENG-197431', '2', 4, '2', '0', 'admin', now(), 'xkw:197431'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197431');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中华菜系', 'XKW-ENG-197432', '2', 5, '2', '0', 'admin', now(), 'xkw:197432'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197432');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '造纸术', 'XKW-ENG-197434', '2', 1, '2', '0', 'admin', now(), 'xkw:197434'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197433'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197434');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '指南针', 'XKW-ENG-197435', '2', 2, '2', '0', 'admin', now(), 'xkw:197435'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197433'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197435');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '火药', 'XKW-ENG-197436', '2', 3, '2', '0', 'admin', now(), 'xkw:197436'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197433'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197436');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '印刷术', 'XKW-ENG-197437', '2', 4, '2', '0', 'admin', now(), 'xkw:197437'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197433'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197437');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '古代诗人', 'XKW-ENG-197439', '2', 1, '2', '0', 'admin', now(), 'xkw:197439'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197438'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197439');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '儒家思想', 'XKW-ENG-197440', '2', 2, '2', '0', 'admin', now(), 'xkw:197440'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197438'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197440');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '道教哲学', 'XKW-ENG-197441', '2', 3, '2', '0', 'admin', now(), 'xkw:197441'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197438'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197441');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '佛教文化', 'XKW-ENG-197442', '2', 4, '2', '0', 'admin', now(), 'xkw:197442'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197438'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197442');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科学技术 ', 'XKW-ENG-41890', '2', 1, '2', '0', 'admin', now(), 'xkw:41890'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41798'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41890');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科学精神', 'XKW-ENG-181268', '2', 2, '2', '0', 'admin', now(), 'xkw:181268'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41798'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181268');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发明与创造 ', 'XKW-ENG-41888', '2', 3, '2', '0', 'admin', now(), 'xkw:41888'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41798'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41888');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科普知识 ', 'XKW-ENG-41886', '2', 4, '2', '0', 'admin', now(), 'xkw:41886'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41798'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41886');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '信息安全', 'XKW-ENG-181267', '2', 1, '2', '0', 'admin', now(), 'xkw:181267'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181267');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '信息技术 ', 'XKW-ENG-41887', '2', 2, '2', '0', 'admin', now(), 'xkw:41887'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41887');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '网络的利弊', 'XKW-ENG-181269', '2', 3, '2', '0', 'admin', now(), 'xkw:181269'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181269');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '通信技术', 'XKW-ENG-181225', '2', 4, '2', '0', 'admin', now(), 'xkw:181225'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181225');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '新能源汽车 ', 'XKW-ENG-197451', '2', 5, '2', '0', 'admin', now(), 'xkw:197451'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-197451');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '网络直播', 'XKW-ENG-181226', '2', 6, '2', '0', 'admin', now(), 'xkw:181226'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181226');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人工智能', 'XKW-ENG-185705', '2', 7, '2', '0', 'admin', now(), 'xkw:185705'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-185705');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '共享经济', 'XKW-ENG-181228', '2', 8, '2', '0', 'admin', now(), 'xkw:181228'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-197450'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181228');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '季节', 'XKW-ENG-41860', '2', 1, '2', '0', 'admin', now(), 'xkw:41860'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41792'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41860');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气候', 'XKW-ENG-41861', '2', 2, '2', '0', 'admin', now(), 'xkw:41861'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41792'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41861');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '描绘天气', 'XKW-ENG-41858', '2', 3, '2', '0', 'admin', now(), 'xkw:41858'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41792'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41858');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天气预报', 'XKW-ENG-41859', '2', 4, '2', '0', 'admin', now(), 'xkw:41859'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41792'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41859');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气候变化及影响', 'XKW-ENG-188825', '2', 5, '2', '0', 'admin', now(), 'xkw:188825'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41792'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188825');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自然地理', 'XKW-ENG-41879', '2', 1, '2', '0', 'admin', now(), 'xkw:41879'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181259'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41879');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人文地理', 'XKW-ENG-41900', '2', 2, '2', '0', 'admin', now(), 'xkw:41900'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181259'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41900');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '地形地貌', 'XKW-ENG-188828', '2', 3, '2', '0', 'admin', now(), 'xkw:188828'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-181259'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188828');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物', 'XKW-ENG-181279', '2', 1, '2', '0', 'admin', now(), 'xkw:181279'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41796'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181279');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物', 'XKW-ENG-41878', '2', 2, '2', '0', 'admin', now(), 'xkw:41878'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41796'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41878');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '季节 ', 'XKW-ENG-41880', '2', 3, '2', '0', 'admin', now(), 'xkw:41880'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41796'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41880');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '颜色 ', 'XKW-ENG-41881', '2', 4, '2', '0', 'admin', now(), 'xkw:41881'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41796'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41881');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自然遗产', 'XKW-ENG-181280', '2', 5, '2', '0', 'admin', now(), 'xkw:181280'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41796'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181280');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自然科学', 'XKW-ENG-181281', '2', 6, '2', '0', 'admin', now(), 'xkw:181281'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41796'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-181281');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人与动植物', 'XKW-ENG-41882', '2', 7, '2', '0', 'admin', now(), 'xkw:41882'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-41796'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-41882');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '海洋探险', 'XKW-ENG-188829', '2', 1, '2', '0', 'admin', now(), 'xkw:188829'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-185707'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188829');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '登山探险', 'XKW-ENG-188831', '2', 2, '2', '0', 'admin', now(), 'xkw:188831'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-185707'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188831');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '丛林探险', 'XKW-ENG-188832', '2', 3, '2', '0', 'admin', now(), 'xkw:188832'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-185707'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188832');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探险旅行', 'XKW-ENG-188833', '2', 4, '2', '0', 'admin', now(), 'xkw:188833'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-ENG-185707'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-ENG-188833');
