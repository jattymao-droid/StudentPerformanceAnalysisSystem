-- 高中生物知识点树（来源：组卷网 lk_15.json / gzsw）
-- 幂等：knowledge_code=XKW-BIO-{xkwId}
-- 导入：bash scripts/import_bio_xkw_knowledge.sh

INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
SELECT 'BIO', '生物', 6, '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'BIO');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT s.subject_id, 0, '0', '高中生物综合库', 'XKW-BIO-44886', '0', 1, '2', '0', 'admin', now(), 'xkw:44886'
FROM spas_subject s
WHERE s.subject_code = 'BIO'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44886');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子与细胞', 'XKW-BIO-44887', '1', 1, '2', '0', 'admin', now(), 'xkw:44887'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44886'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44887');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传与进化', 'XKW-BIO-44888', '1', 2, '2', '0', 'admin', now(), 'xkw:44888'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44886'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44888');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '稳态与调节', 'XKW-BIO-44889', '1', 3, '2', '0', 'admin', now(), 'xkw:44889'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44886'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44889');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物与环境', 'XKW-BIO-188732', '1', 4, '2', '0', 'admin', now(), 'xkw:188732'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44886'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188732');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物技术与工程', 'XKW-BIO-44890', '1', 5, '2', '0', 'admin', now(), 'xkw:44890'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44886'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44890');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物学热点聚焦', 'XKW-BIO-161101', '1', 6, '2', '0', 'admin', now(), 'xkw:161101'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44886'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-161101');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实验与探究', 'XKW-BIO-44894', '1', 7, '2', '0', 'admin', now(), 'xkw:44894'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44886'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44894');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实验', 'XKW-BIO-112', '1', 8, '2', '0', 'admin', now(), 'xkw:112'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44886'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-112');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '组成细胞的分子', 'XKW-BIO-44898', '1', 1, '2', '0', 'admin', now(), 'xkw:44898'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44887'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44898');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的结构和功能', 'XKW-BIO-44900', '1', 2, '2', '0', 'admin', now(), 'xkw:44900'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44887'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44900');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的代谢', 'XKW-BIO-44902', '1', 3, '2', '0', 'admin', now(), 'xkw:44902'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44887'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44902');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的生命历程', 'XKW-BIO-44904', '1', 4, '2', '0', 'admin', now(), 'xkw:44904'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44887'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44904');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传的细胞基础', 'XKW-BIO-45029', '1', 1, '2', '0', 'admin', now(), 'xkw:45029'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44888'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45029');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传的基本规律', 'XKW-BIO-45030', '1', 2, '2', '0', 'admin', now(), 'xkw:45030'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44888'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45030');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传的分子基础', 'XKW-BIO-45032', '1', 3, '2', '0', 'admin', now(), 'xkw:45032'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44888'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45032');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物的变异与育种', 'XKW-BIO-45034', '1', 4, '2', '0', 'admin', now(), 'xkw:45034'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44888'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45034');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传与人类健康', 'XKW-BIO-45036', '1', 5, '2', '0', 'admin', now(), 'xkw:45036'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44888'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45036');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物的进化', 'XKW-BIO-45038', '1', 6, '2', '0', 'admin', now(), 'xkw:45038'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44888'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45038');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物界是一个相对稳定的生命系统', 'XKW-BIO-45128', '2', 1, '2', '0', 'admin', now(), 'xkw:45128'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44889'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45128');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内环境与稳态', 'XKW-BIO-45129', '1', 2, '2', '0', 'admin', now(), 'xkw:45129'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44889'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45129');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物体对外界信息的获取', 'XKW-BIO-45145', '1', 3, '2', '0', 'admin', now(), 'xkw:45145'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44889'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45145');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经调节', 'XKW-BIO-45146', '1', 4, '2', '0', 'admin', now(), 'xkw:45146'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44889'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45146');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体液调节', 'XKW-BIO-45147', '1', 5, '2', '0', 'admin', now(), 'xkw:45147'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44889'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45147');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '免疫调节', 'XKW-BIO-45148', '1', 6, '2', '0', 'admin', now(), 'xkw:45148'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44889'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45148');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物和人体生命活动的调节综合', 'XKW-BIO-45132', '2', 7, '2', '0', 'admin', now(), 'xkw:45132'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44889'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45132');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物生命活动的调节', 'XKW-BIO-45133', '1', 8, '2', '0', 'admin', now(), 'xkw:45133'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44889'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45133');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群和群落', 'XKW-BIO-45135', '1', 1, '2', '0', 'admin', now(), 'xkw:45135'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188732'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45135');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统及其稳定性', 'XKW-BIO-45137', '1', 2, '2', '0', 'admin', now(), 'xkw:45137'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188732'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45137');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人与环境', 'XKW-BIO-45139', '1', 3, '2', '0', 'admin', now(), 'xkw:45139'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188732'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45139');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发酵工程', 'XKW-BIO-188928', '1', 1, '2', '0', 'admin', now(), 'xkw:188928'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188928');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因工程', 'XKW-BIO-45305', '1', 2, '2', '0', 'admin', now(), 'xkw:45305'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45305');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞工程', 'XKW-BIO-45307', '1', 3, '2', '0', 'admin', now(), 'xkw:45307'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45307');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胚胎工程', 'XKW-BIO-45309', '1', 4, '2', '0', 'admin', now(), 'xkw:45309'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45309');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物技术的安全性和伦理问题', 'XKW-BIO-45311', '1', 5, '2', '0', 'admin', now(), 'xkw:45311'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45311');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物技术与工程综合', 'XKW-BIO-44893', '2', 6, '2', '0', 'admin', now(), 'xkw:44893'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44890'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44893');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '碳达峰和碳中和', 'XKW-BIO-182181', '2', 1, '2', '0', 'admin', now(), 'xkw:182181'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-182181');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '丙型肝炎病毒', 'XKW-BIO-179652', '2', 2, '2', '0', 'admin', now(), 'xkw:179652'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-179652');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '阿尔茨海默病', 'XKW-BIO-179653', '2', 3, '2', '0', 'admin', now(), 'xkw:179653'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-179653');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '新型冠状病毒及相关', 'XKW-BIO-161102', '2', 4, '2', '0', 'admin', now(), 'xkw:161102'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-161102');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '垃圾分类及处理', 'XKW-BIO-164585', '2', 5, '2', '0', 'admin', now(), 'xkw:164585'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-164585');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '2020年沙漠蝗灾与生态', 'XKW-BIO-161103', '2', 6, '2', '0', 'admin', now(), 'xkw:161103'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-161103');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '2019年澳洲大火与生态', 'XKW-BIO-161104', '2', 7, '2', '0', 'admin', now(), 'xkw:161104'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-161104');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因编辑技术', 'XKW-BIO-161105', '2', 8, '2', '0', 'admin', now(), 'xkw:161105'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-161105');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞感知和适应氧气变化的机制', 'XKW-BIO-161106', '2', 9, '2', '0', 'admin', now(), 'xkw:161106'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-161106');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '世界首例体细胞克隆猴“中中”和“华华”', 'XKW-BIO-161107', '2', 10, '2', '0', 'admin', now(), 'xkw:161107'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-161107');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '屠呦呦与青蒿素的发现', 'XKW-BIO-161108', '2', 11, '2', '0', 'admin', now(), 'xkw:161108'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-161108');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '控制昼夜节律的分子机制', 'XKW-BIO-192088', '2', 12, '2', '0', 'admin', now(), 'xkw:192088'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-192088');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞自噬机制', 'XKW-BIO-192089', '2', 13, '2', '0', 'admin', now(), 'xkw:192089'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-192089');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抑制负面免疫调节的癌症疗法', 'XKW-BIO-192090', '2', 14, '2', '0', 'admin', now(), 'xkw:192090'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-161101'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-192090');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实验基本理论', 'XKW-BIO-45361', '2', 1, '2', '0', 'admin', now(), 'xkw:45361'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44894'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45361');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实验基本技术', 'XKW-BIO-45362', '2', 2, '2', '0', 'admin', now(), 'xkw:45362'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44894'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45362');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '验证性实验与探究性实验', 'XKW-BIO-45363', '2', 3, '2', '0', 'admin', now(), 'xkw:45363'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44894'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45363');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '研究性学习', 'XKW-BIO-45364', '2', 4, '2', '0', 'admin', now(), 'xkw:45364'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44894'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45364');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实验与探究综合', 'XKW-BIO-44895', '2', 5, '2', '0', 'admin', now(), 'xkw:44895'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44894'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44895');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子与细胞', 'XKW-BIO-624', '1', 1, '2', '0', 'admin', now(), 'xkw:624'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-112'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-624');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传与进化', 'XKW-BIO-636', '1', 2, '2', '0', 'admin', now(), 'xkw:636'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-112'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-636');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '稳态与调节', 'XKW-BIO-645', '1', 3, '2', '0', 'admin', now(), 'xkw:645'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-112'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-645');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物与环境', 'XKW-BIO-648', '1', 4, '2', '0', 'admin', now(), 'xkw:648'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-112'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-648');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物技术与工程', 'XKW-BIO-656', '1', 5, '2', '0', 'admin', now(), 'xkw:656'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-112'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-656');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的元素和化合物', 'XKW-BIO-44906', '1', 1, '2', '0', 'admin', now(), 'xkw:44906'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44906');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的无机物', 'XKW-BIO-44910', '1', 2, '2', '0', 'admin', now(), 'xkw:44910'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44910');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的糖类和脂质', 'XKW-BIO-44909', '1', 3, '2', '0', 'admin', now(), 'xkw:44909'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44909');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质是生命活动的主要承担者', 'XKW-BIO-44907', '1', 4, '2', '0', 'admin', now(), 'xkw:44907'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44907');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核酸', 'XKW-BIO-44908', '1', 5, '2', '0', 'admin', now(), 'xkw:44908'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44908');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物大分子以碳链为骨架', 'XKW-BIO-44911', '2', 6, '2', '0', 'admin', now(), 'xkw:44911'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44911');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的分子组成综合', 'XKW-BIO-44899', '2', 7, '2', '0', 'admin', now(), 'xkw:44899'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44899');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞是生命活动的基本单位', 'XKW-BIO-44925', '1', 1, '2', '0', 'admin', now(), 'xkw:44925'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44900'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44925');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的多样性和统一性', 'XKW-BIO-44926', '1', 2, '2', '0', 'admin', now(), 'xkw:44926'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44900'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44926');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞膜和细胞壁', 'XKW-BIO-44927', '1', 3, '2', '0', 'admin', now(), 'xkw:44927'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44900'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44927');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞质', 'XKW-BIO-44928', '1', 4, '2', '0', 'admin', now(), 'xkw:44928'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44900'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44928');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞核', 'XKW-BIO-44929', '1', 5, '2', '0', 'admin', now(), 'xkw:44929'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44900'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44929');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的结构和功能综合', 'XKW-BIO-44901', '2', 6, '2', '0', 'admin', now(), 'xkw:44901'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44900'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44901');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物质跨膜运输的实例', 'XKW-BIO-44956', '1', 1, '2', '0', 'admin', now(), 'xkw:44956'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44902'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44956');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的物质输入和输出', 'XKW-BIO-44957', '1', 2, '2', '0', 'admin', now(), 'xkw:44957'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44902'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44957');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶与ATP', 'XKW-BIO-44958', '1', 3, '2', '0', 'admin', now(), 'xkw:44958'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44902'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44958');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞呼吸', 'XKW-BIO-44959', '1', 4, '2', '0', 'admin', now(), 'xkw:44959'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44902'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44959');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用', 'XKW-BIO-44960', '1', 5, '2', '0', 'admin', now(), 'xkw:44960'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44902'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44960');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '糖类、脂质和蛋白质的代谢', 'XKW-BIO-44961', '1', 6, '2', '0', 'admin', now(), 'xkw:44961'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44902'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44961');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的代谢综合', 'XKW-BIO-44903', '2', 7, '2', '0', 'admin', now(), 'xkw:44903'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44902'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44903');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的增殖', 'XKW-BIO-45008', '1', 1, '2', '0', 'admin', now(), 'xkw:45008'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45008');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无性生殖和有性生殖', 'XKW-BIO-154694', '2', 2, '2', '0', 'admin', now(), 'xkw:154694'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-154694');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的增殖综合', 'XKW-BIO-45009', '2', 3, '2', '0', 'admin', now(), 'xkw:45009'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45009');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的分化、衰老、死亡', 'XKW-BIO-45010', '1', 4, '2', '0', 'admin', now(), 'xkw:45010'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45010');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的生命历程综合', 'XKW-BIO-44905', '2', 5, '2', '0', 'admin', now(), 'xkw:44905'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44904'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44905');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '减数分裂和受精作用', 'XKW-BIO-45040', '1', 1, '2', '0', 'admin', now(), 'xkw:45040'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45029'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45040');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因的分离定律', 'XKW-BIO-45051', '1', 1, '2', '0', 'admin', now(), 'xkw:45051'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45051');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因的自由组合定律', 'XKW-BIO-45052', '1', 2, '2', '0', 'admin', now(), 'xkw:45052'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45052');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因位于染色体上', 'XKW-BIO-45053', '1', 3, '2', '0', 'admin', now(), 'xkw:45053'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45053');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '性别决定和伴性遗传', 'XKW-BIO-45054', '1', 4, '2', '0', 'admin', now(), 'xkw:45054'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45054');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传的基本规律综合', 'XKW-BIO-45031', '2', 5, '2', '0', 'admin', now(), 'xkw:45031'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45031');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人类探索遗传物质的历程', 'XKW-BIO-45074', '1', 1, '2', '0', 'admin', now(), 'xkw:45074'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45074');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA分子的结构和复制', 'XKW-BIO-45075', '1', 2, '2', '0', 'admin', now(), 'xkw:45075'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45075');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因通常是有遗传效应的DNA片段', 'XKW-BIO-45076', '1', 3, '2', '0', 'admin', now(), 'xkw:45076'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45076');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因指导蛋白质的合成', 'XKW-BIO-45077', '1', 4, '2', '0', 'admin', now(), 'xkw:45077'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45077');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因表达与性状的关系', 'XKW-BIO-45078', '1', 5, '2', '0', 'admin', now(), 'xkw:45078'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45078');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传密码的破译', 'XKW-BIO-45079', '1', 6, '2', '0', 'admin', now(), 'xkw:45079'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45079');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因表达的调控过程', 'XKW-BIO-45080', '2', 7, '2', '0', 'admin', now(), 'xkw:45080'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45080');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传的分子基础综合', 'XKW-BIO-45033', '2', 8, '2', '0', 'admin', now(), 'xkw:45033'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45033');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因突变和基因重组', 'XKW-BIO-45104', '1', 1, '2', '0', 'admin', now(), 'xkw:45104'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45034'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45104');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '染色体变异', 'XKW-BIO-45105', '1', 2, '2', '0', 'admin', now(), 'xkw:45105'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45034'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45105');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '育种', 'XKW-BIO-45106', '1', 3, '2', '0', 'admin', now(), 'xkw:45106'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45034'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45106');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物的变异与育种综合', 'XKW-BIO-45035', '2', 4, '2', '0', 'admin', now(), 'xkw:45035'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45034'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45035');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人类遗传病', 'XKW-BIO-45118', '1', 1, '2', '0', 'admin', now(), 'xkw:45118'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45036'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45118');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物有共同祖先的证据', 'XKW-BIO-157965', '2', 1, '2', '0', 'admin', now(), 'xkw:157965'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45038'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-157965');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自然选择与适应的形成', 'XKW-BIO-45124', '2', 2, '2', '0', 'admin', now(), 'xkw:45124'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45038'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45124');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '适应的普遍性与相对性', 'XKW-BIO-196654', '2', 3, '2', '0', 'admin', now(), 'xkw:196654'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45038'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196654');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '获得性遗传与自然选择学说', 'XKW-BIO-196655', '2', 4, '2', '0', 'admin', now(), 'xkw:196655'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45038'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196655');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因频率的改变与生物进化', 'XKW-BIO-45125', '2', 5, '2', '0', 'admin', now(), 'xkw:45125'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45038'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45125');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究抗生素对细菌的选择作用实验', 'XKW-BIO-196656', '2', 6, '2', '0', 'admin', now(), 'xkw:196656'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45038'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196656');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '隔离与物种的形成', 'XKW-BIO-45126', '2', 7, '2', '0', 'admin', now(), 'xkw:45126'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45038'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45126');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '协同进化与生物多样性', 'XKW-BIO-45127', '2', 8, '2', '0', 'admin', now(), 'xkw:45127'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45038'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45127');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物的进化综合', 'XKW-BIO-45039', '2', 9, '2', '0', 'admin', now(), 'xkw:45039'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45038'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45039');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞生活的环境', 'XKW-BIO-196657', '2', 1, '2', '0', 'admin', now(), 'xkw:196657'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196657');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内环境的组成及成分', 'XKW-BIO-45141', '2', 2, '2', '0', 'admin', now(), 'xkw:45141'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45141');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内环境的理化性质', 'XKW-BIO-45142', '2', 3, '2', '0', 'admin', now(), 'xkw:45142'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45142');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内环境是外界与细胞进行物质交换的媒介', 'XKW-BIO-45143', '2', 4, '2', '0', 'admin', now(), 'xkw:45143'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45143');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内环境的稳态', 'XKW-BIO-196658', '1', 5, '2', '0', 'admin', now(), 'xkw:196658'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196658');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物体对物理信息的获取', 'XKW-BIO-45149', '2', 1, '2', '0', 'admin', now(), 'xkw:45149'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45145'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45149');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物体对化学信息的获取', 'XKW-BIO-45150', '2', 2, '2', '0', 'admin', now(), 'xkw:45150'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45145'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45150');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经调节的结构基础', 'XKW-BIO-45151', '1', 1, '2', '0', 'admin', now(), 'xkw:45151'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45146'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45151');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经调节的基本方式', 'XKW-BIO-188717', '1', 2, '2', '0', 'admin', now(), 'xkw:188717'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45146'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188717');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经冲动的产生和传导', 'XKW-BIO-188718', '1', 3, '2', '0', 'admin', now(), 'xkw:188718'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45146'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188718');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经系统的分级调节', 'XKW-BIO-45158', '1', 4, '2', '0', 'admin', now(), 'xkw:45158'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45146'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45158');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人脑的高级功能', 'XKW-BIO-45159', '1', 5, '2', '0', 'admin', now(), 'xkw:45159'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45146'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45159');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '激素与内分泌系统', 'XKW-BIO-188720', '1', 1, '2', '0', 'admin', now(), 'xkw:188720'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45147'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188720');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '激素调节的过程', 'XKW-BIO-188721', '1', 2, '2', '0', 'admin', now(), 'xkw:188721'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45147'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188721');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经调节和体液调节的关系', 'XKW-BIO-188722', '1', 3, '2', '0', 'admin', now(), 'xkw:188722'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45147'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188722');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '免疫系统的组成和功能', 'XKW-BIO-45173', '1', 1, '2', '0', 'admin', now(), 'xkw:45173'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45148'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45173');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '特异性免疫', 'XKW-BIO-188725', '1', 2, '2', '0', 'admin', now(), 'xkw:188725'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45148'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188725');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '免疫功能异常', 'XKW-BIO-45177', '1', 3, '2', '0', 'admin', now(), 'xkw:45177'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45148'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45177');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '免疫学的应用', 'XKW-BIO-45178', '1', 4, '2', '0', 'admin', now(), 'xkw:45178'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45148'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45178');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '与免疫调节相关的实验', 'XKW-BIO-45179', '2', 5, '2', '0', 'admin', now(), 'xkw:45179'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45148'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45179');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物生长素', 'XKW-BIO-45181', '1', 1, '2', '0', 'admin', now(), 'xkw:45181'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45133'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45181');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他植物激素', 'XKW-BIO-45183', '1', 2, '2', '0', 'admin', now(), 'xkw:45183'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45133'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45183');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物生长调节剂及应用', 'XKW-BIO-45195', '2', 3, '2', '0', 'admin', now(), 'xkw:45195'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45133'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45195');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '环境因素参与调节植物的生命活动', 'XKW-BIO-45180', '1', 4, '2', '0', 'admin', now(), 'xkw:45180'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45133'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45180');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物生命活动的调节综合', 'XKW-BIO-45134', '2', 5, '2', '0', 'admin', now(), 'xkw:45134'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45133'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45134');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群', 'XKW-BIO-45196', '1', 1, '2', '0', 'admin', now(), 'xkw:45196'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45135'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45196');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '群落', 'XKW-BIO-45197', '1', 2, '2', '0', 'admin', now(), 'xkw:45197'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45135'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45197');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群和群落综合', 'XKW-BIO-45136', '2', 3, '2', '0', 'admin', now(), 'xkw:45136'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45135'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45136');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的结构', 'XKW-BIO-45210', '1', 1, '2', '0', 'admin', now(), 'xkw:45210'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45137'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45210');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的功能', 'XKW-BIO-45211', '1', 2, '2', '0', 'admin', now(), 'xkw:45211'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45137'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45211');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的结构和功能综合', 'XKW-BIO-163096', '2', 3, '2', '0', 'admin', now(), 'xkw:163096'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45137'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-163096');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的生产量和生物量', 'XKW-BIO-45212', '2', 4, '2', '0', 'admin', now(), 'xkw:45212'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45137'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45212');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的稳定性', 'XKW-BIO-45213', '1', 5, '2', '0', 'admin', now(), 'xkw:45213'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45137'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45213');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统及其稳定性综合', 'XKW-BIO-45138', '2', 6, '2', '0', 'admin', now(), 'xkw:45138'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45137'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45138');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人类活动对生态环境的影响', 'XKW-BIO-45237', '1', 1, '2', '0', 'admin', now(), 'xkw:45237'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45139'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45237');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物多样性及其保护', 'XKW-BIO-45238', '1', 2, '2', '0', 'admin', now(), 'xkw:45238'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45139'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45238');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态工程', 'XKW-BIO-45313', '1', 3, '2', '0', 'admin', now(), 'xkw:45313'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45139'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45313');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人与环境综合', 'XKW-BIO-45140', '2', 4, '2', '0', 'admin', now(), 'xkw:45140'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45139'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45140');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传统发酵技术的应用', 'XKW-BIO-45249', '1', 1, '2', '0', 'admin', now(), 'xkw:45249'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45249');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微生物的培养与应用', 'XKW-BIO-45243', '1', 2, '2', '0', 'admin', now(), 'xkw:45243'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45243');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶的研究与应用', 'XKW-BIO-45247', '1', 3, '2', '0', 'admin', now(), 'xkw:45247'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45247');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA和蛋白质技术', 'XKW-BIO-45251', '1', 4, '2', '0', 'admin', now(), 'xkw:45251'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45251');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发酵工程及其应用', 'XKW-BIO-181983', '1', 5, '2', '0', 'admin', now(), 'xkw:181983'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-181983');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发酵技术综合', 'XKW-BIO-44891', '2', 6, '2', '0', 'admin', now(), 'xkw:44891'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44891');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因工程的基本工具', 'XKW-BIO-45315', '1', 1, '2', '0', 'admin', now(), 'xkw:45315'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45305'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45315');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因工程的基本操作程序', 'XKW-BIO-45316', '1', 2, '2', '0', 'admin', now(), 'xkw:45316'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45305'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45316');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因工程的应用', 'XKW-BIO-45317', '1', 3, '2', '0', 'admin', now(), 'xkw:45317'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45305'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45317');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质工程', 'XKW-BIO-45318', '1', 4, '2', '0', 'admin', now(), 'xkw:45318'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45305'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45318');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因工程综合', 'XKW-BIO-45306', '2', 5, '2', '0', 'admin', now(), 'xkw:45306'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45305'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45306');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物细胞工程的基本技术及应用', 'XKW-BIO-45331', '1', 1, '2', '0', 'admin', now(), 'xkw:45331'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45307'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45331');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物细胞的培养和核移植技术', 'XKW-BIO-45332', '1', 2, '2', '0', 'admin', now(), 'xkw:45332'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45307'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45332');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物细胞融合与单克隆抗体的制备', 'XKW-BIO-45333', '2', 3, '2', '0', 'admin', now(), 'xkw:45333'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45307'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45333');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '干细胞工程', 'XKW-BIO-45335', '2', 4, '2', '0', 'admin', now(), 'xkw:45335'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45307'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45335');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞工程综合', 'XKW-BIO-45308', '2', 5, '2', '0', 'admin', now(), 'xkw:45308'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45307'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45308');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体内受精和胚胎发育', 'XKW-BIO-45341', '1', 1, '2', '0', 'admin', now(), 'xkw:45341'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45309'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45341');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体外受精和早期胚胎的培养', 'XKW-BIO-45342', '1', 2, '2', '0', 'admin', now(), 'xkw:45342'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45309'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45342');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胚胎工程的应用及前景', 'XKW-BIO-45343', '1', 3, '2', '0', 'admin', now(), 'xkw:45343'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45309'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45343');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胚胎工程综合', 'XKW-BIO-45310', '2', 4, '2', '0', 'admin', now(), 'xkw:45310'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45309'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45310');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '转基因生物安全性', 'XKW-BIO-45353', '2', 1, '2', '0', 'admin', now(), 'xkw:45353'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45311'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45353');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物技术中的伦理问题', 'XKW-BIO-45354', '2', 2, '2', '0', 'admin', now(), 'xkw:45354'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45311'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45354');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '禁止生物武器', 'XKW-BIO-45355', '2', 3, '2', '0', 'admin', now(), 'xkw:45355'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45311'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45355');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物技术的安全性和伦理问题综合', 'XKW-BIO-45312', '2', 4, '2', '0', 'admin', now(), 'xkw:45312'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45311'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45312');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '使用高倍显微镜观察几种细胞', 'XKW-BIO-625', '2', 1, '2', '0', 'admin', now(), 'xkw:625'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-625');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '检测生物组织中的糖类、脂肪和蛋白质', 'XKW-BIO-626', '2', 2, '2', '0', 'admin', now(), 'xkw:626'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-626');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用高倍显微镜观察叶绿体和细胞质的流动', 'XKW-BIO-627', '2', 3, '2', '0', 'admin', now(), 'xkw:627'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-627');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '真核细胞的三维结构模型', 'XKW-BIO-628', '2', 4, '2', '0', 'admin', now(), 'xkw:628'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-628');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '通过模拟实验探究膜的透性', 'XKW-BIO-629', '2', 5, '2', '0', 'admin', now(), 'xkw:629'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-629');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的吸水和失水', 'XKW-BIO-630', '2', 6, '2', '0', 'admin', now(), 'xkw:630'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-630');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶的活性与影响酶活性的因素', 'XKW-BIO-631', '2', 7, '2', '0', 'admin', now(), 'xkw:631'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-631');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究酵母菌细胞呼吸的方式', 'XKW-BIO-632', '2', 8, '2', '0', 'admin', now(), 'xkw:632'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-632');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '绿叶中色素的提取和分离实验', 'XKW-BIO-633', '2', 9, '2', '0', 'admin', now(), 'xkw:633'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-633');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究环境因素对光合作用强度的影响', 'XKW-BIO-634', '2', 10, '2', '0', 'admin', now(), 'xkw:634'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-634');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有丝分裂实验', 'XKW-BIO-635', '2', 11, '2', '0', 'admin', now(), 'xkw:635'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-624'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-635');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '性状分离比的模拟实验', 'XKW-BIO-637', '2', 1, '2', '0', 'admin', now(), 'xkw:637'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-636'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-637');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '观察细胞的减数分裂实验', 'XKW-BIO-638', '2', 2, '2', '0', 'admin', now(), 'xkw:638'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-636'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-638');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '建立减数分裂中染色体变化的模型', 'XKW-BIO-639', '2', 3, '2', '0', 'admin', now(), 'xkw:639'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-636'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-639');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '制作DNA双螺旋结构模型', 'XKW-BIO-640', '2', 4, '2', '0', 'admin', now(), 'xkw:640'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-636'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-640');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '低温诱导植物染色体数目的变化实验', 'XKW-BIO-641', '2', 5, '2', '0', 'admin', now(), 'xkw:641'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-636'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-641');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '调查人群中的遗传病', 'XKW-BIO-642', '2', 6, '2', '0', 'admin', now(), 'xkw:642'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-636'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-642');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究自然选择对种群基因频率变化的影响', 'XKW-BIO-643', '2', 7, '2', '0', 'admin', now(), 'xkw:643'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-636'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-643');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究抗生素对细菌的选择作用', 'XKW-BIO-644', '2', 8, '2', '0', 'admin', now(), 'xkw:644'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-636'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-644');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '模拟生物体维持pH的稳定', 'XKW-BIO-646', '2', 1, '2', '0', 'admin', now(), 'xkw:646'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-645'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-646');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探索植物生长调节剂的应用', 'XKW-BIO-647', '2', 2, '2', '0', 'admin', now(), 'xkw:647'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-645'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-647');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '调查草地中某种双子叶植物的总群密度', 'XKW-BIO-649', '2', 1, '2', '0', 'admin', now(), 'xkw:649'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-648'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-649');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究培养液中酵母菌种群数量的变化', 'XKW-BIO-650', '2', 2, '2', '0', 'admin', now(), 'xkw:650'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-648'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-650');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究土壤小动物类群的丰富度', 'XKW-BIO-651', '2', 3, '2', '0', 'admin', now(), 'xkw:651'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-648'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-651');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '调查当地某生态系统中能量流动情况', 'XKW-BIO-652', '2', 4, '2', '0', 'admin', now(), 'xkw:652'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-648'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-652');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究土壤微生物的分解作用', 'XKW-BIO-653', '2', 5, '2', '0', 'admin', now(), 'xkw:653'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-648'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-653');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '设计制作生态缸，观察其稳定性', 'XKW-BIO-654', '2', 6, '2', '0', 'admin', now(), 'xkw:654'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-648'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-654');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '搜索保护生物多样性的实例', 'XKW-BIO-655', '2', 7, '2', '0', 'admin', now(), 'xkw:655'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-648'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-655');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '调查当地的环境情况，提出保护环境的建议或行动计划', 'XKW-BIO-12789', '2', 8, '2', '0', 'admin', now(), 'xkw:12789'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-648'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-12789');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '制作传统发酵食品', 'XKW-BIO-657', '2', 1, '2', '0', 'admin', now(), 'xkw:657'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-656'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-657');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酵母菌的纯培养', 'XKW-BIO-658', '2', 2, '2', '0', 'admin', now(), 'xkw:658'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-656'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-658');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '土壤中分解尿素的细菌的分离与计数', 'XKW-BIO-659', '2', 3, '2', '0', 'admin', now(), 'xkw:659'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-656'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-659');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用植物组织培养技术培育植物幼苗', 'XKW-BIO-660', '2', 4, '2', '0', 'admin', now(), 'xkw:660'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-656'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-660');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交流讨论单克隆抗体在临床上的应用', 'XKW-BIO-661', '2', 5, '2', '0', 'admin', now(), 'xkw:661'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-656'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-661');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA的粗提取与鉴定的实验设计', 'XKW-BIO-662', '2', 6, '2', '0', 'admin', now(), 'xkw:662'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-656'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-662');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA片段的扩增及电泳鉴定', 'XKW-BIO-663', '2', 7, '2', '0', 'admin', now(), 'xkw:663'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-656'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-663');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '组成细胞的元素', 'XKW-BIO-44912', '2', 1, '2', '0', 'admin', now(), 'xkw:44912'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44906'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44912');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '组成细胞的化合物', 'XKW-BIO-44913', '2', 2, '2', '0', 'admin', now(), 'xkw:44913'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44906'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44913');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '检测生物组织中的糖类、脂肪和蛋白质', 'XKW-BIO-44914', '2', 3, '2', '0', 'admin', now(), 'xkw:44914'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44906'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44914');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的元素和化合物综合', 'XKW-BIO-153290', '2', 4, '2', '0', 'admin', now(), 'xkw:153290'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44906'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153290');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的水', 'XKW-BIO-44923', '2', 1, '2', '0', 'admin', now(), 'xkw:44923'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44910'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44923');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的无机盐', 'XKW-BIO-44924', '2', 2, '2', '0', 'admin', now(), 'xkw:44924'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44910'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44924');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的水和无机盐综合', 'XKW-BIO-153303', '2', 3, '2', '0', 'admin', now(), 'xkw:153303'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44910'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153303');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '糖类的元素组成', 'XKW-BIO-153298', '2', 1, '2', '0', 'admin', now(), 'xkw:153298'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153298');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '糖类的种类及分布', 'XKW-BIO-153299', '2', 2, '2', '0', 'admin', now(), 'xkw:153299'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153299');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '糖类的功能', 'XKW-BIO-153300', '2', 3, '2', '0', 'admin', now(), 'xkw:153300'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153300');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的糖类综合', 'XKW-BIO-44921', '2', 4, '2', '0', 'admin', now(), 'xkw:44921'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44921');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '脂质的元素组成', 'XKW-BIO-153301', '2', 5, '2', '0', 'admin', now(), 'xkw:153301'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153301');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '脂质的种类及功能', 'XKW-BIO-153302', '2', 6, '2', '0', 'admin', now(), 'xkw:153302'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153302');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的脂质综合', 'XKW-BIO-44922', '2', 7, '2', '0', 'admin', now(), 'xkw:44922'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44922');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质的元素组成', 'XKW-BIO-153291', '2', 1, '2', '0', 'admin', now(), 'xkw:153291'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44907'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153291');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质的基本组成单位--氨基酸', 'XKW-BIO-44915', '2', 2, '2', '0', 'admin', now(), 'xkw:44915'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44907'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44915');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质的结构及多样性', 'XKW-BIO-44916', '2', 3, '2', '0', 'admin', now(), 'xkw:44916'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44907'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44916');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质的功能', 'XKW-BIO-44917', '2', 4, '2', '0', 'admin', now(), 'xkw:44917'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44907'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44917');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '与蛋白质相关的计算', 'XKW-BIO-44918', '2', 5, '2', '0', 'admin', now(), 'xkw:44918'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44907'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44918');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质的变性', 'XKW-BIO-153292', '2', 6, '2', '0', 'admin', now(), 'xkw:153292'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44907'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153292');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质的结构和功能综合', 'XKW-BIO-153293', '2', 7, '2', '0', 'admin', now(), 'xkw:153293'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44907'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153293');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核酸的元素组成及基本单位', 'XKW-BIO-153294', '2', 1, '2', '0', 'admin', now(), 'xkw:153294'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153294');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核酸的种类及分布', 'XKW-BIO-44919', '2', 2, '2', '0', 'admin', now(), 'xkw:44919'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44919');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA与RNA的异同', 'XKW-BIO-153295', '2', 3, '2', '0', 'admin', now(), 'xkw:153295'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153295');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核酸的功能', 'XKW-BIO-153296', '2', 4, '2', '0', 'admin', now(), 'xkw:153296'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153296');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '观察DNA和RNA在细胞中的分布实验', 'XKW-BIO-44920', '2', 5, '2', '0', 'admin', now(), 'xkw:44920'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44920');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核酸综合', 'XKW-BIO-153297', '2', 6, '2', '0', 'admin', now(), 'xkw:153297'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153297');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞学说及其建立过程', 'XKW-BIO-44936', '2', 1, '2', '0', 'admin', now(), 'xkw:44936'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44925'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44936');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '病毒结构、分类和增殖', 'XKW-BIO-44930', '2', 2, '2', '0', 'admin', now(), 'xkw:44930'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44925'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44930');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生命活动与细胞的关系', 'XKW-BIO-44931', '2', 3, '2', '0', 'admin', now(), 'xkw:44931'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44925'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44931');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞是基本的生命系统', 'XKW-BIO-44932', '2', 4, '2', '0', 'admin', now(), 'xkw:44932'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44925'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44932');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '显微镜的构造及使用', 'XKW-BIO-44933', '1', 1, '2', '0', 'admin', now(), 'xkw:44933'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44926'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44933');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '真核细胞与原核细胞', 'XKW-BIO-44934', '2', 2, '2', '0', 'admin', now(), 'xkw:44934'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44926'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44934');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的大小和形态', 'XKW-BIO-44935', '2', 3, '2', '0', 'admin', now(), 'xkw:44935'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44926'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44935');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞壁的成分及功能', 'XKW-BIO-44940', '2', 1, '2', '0', 'admin', now(), 'xkw:44940'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44927'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44940');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞膜的结构与功能', 'XKW-BIO-44941', '1', 2, '2', '0', 'admin', now(), 'xkw:44941'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44927'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44941');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物膜系统', 'XKW-BIO-44942', '1', 3, '2', '0', 'admin', now(), 'xkw:44942'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44927'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44942');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞骨架', 'XKW-BIO-44948', '2', 1, '2', '0', 'admin', now(), 'xkw:44948'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44948');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞质基质（细胞溶胶）', 'XKW-BIO-44949', '2', 2, '2', '0', 'admin', now(), 'xkw:44949'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44949');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞器的结构、功能及分离方法', 'XKW-BIO-44950', '2', 3, '2', '0', 'admin', now(), 'xkw:44950'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44950');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内共生学说', 'XKW-BIO-230047', '2', 4, '2', '0', 'admin', now(), 'xkw:230047'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-230047');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '观察叶绿体、线粒体和细胞质流动实验', 'XKW-BIO-44951', '2', 5, '2', '0', 'admin', now(), 'xkw:44951'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44951');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞器之间的协调配合', 'XKW-BIO-44952', '2', 6, '2', '0', 'admin', now(), 'xkw:44952'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44928'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44952');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞核的结构', 'XKW-BIO-44955', '2', 1, '2', '0', 'admin', now(), 'xkw:44955'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44929'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44955');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞核的功能及有关的实验探究', 'XKW-BIO-44954', '2', 2, '2', '0', 'admin', now(), 'xkw:44954'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44929'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44954');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '真核细胞的三维结构模型', 'XKW-BIO-153307', '2', 3, '2', '0', 'admin', now(), 'xkw:153307'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44929'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153307');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞核的结构和功能综合', 'XKW-BIO-153308', '2', 4, '2', '0', 'admin', now(), 'xkw:153308'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44929'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153308');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '渗透作用', 'XKW-BIO-44962', '2', 1, '2', '0', 'admin', now(), 'xkw:44962'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44956'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44962');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的吸水和失水', 'XKW-BIO-44963', '2', 2, '2', '0', 'admin', now(), 'xkw:44963'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44956'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44963');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '质壁分离及其复原实验', 'XKW-BIO-44964', '2', 3, '2', '0', 'admin', now(), 'xkw:44964'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44956'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44964');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '质壁分离及其复原实验的应用', 'XKW-BIO-44965', '2', 4, '2', '0', 'admin', now(), 'xkw:44965'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44956'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44965');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物质跨膜运输的其他实例', 'XKW-BIO-44966', '2', 5, '2', '0', 'admin', now(), 'xkw:44966'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44956'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44966');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '被动运输', 'XKW-BIO-44967', '1', 1, '2', '0', 'admin', now(), 'xkw:44967'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44957'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44967');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '主动运输', 'XKW-BIO-44968', '2', 2, '2', '0', 'admin', now(), 'xkw:44968'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44957'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44968');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胞吞和胞吐', 'XKW-BIO-44969', '2', 3, '2', '0', 'admin', now(), 'xkw:44969'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44957'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44969');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物质出入细胞的方式综合', 'XKW-BIO-153309', '2', 4, '2', '0', 'admin', now(), 'xkw:153309'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44957'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153309');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶', 'XKW-BIO-44970', '1', 1, '2', '0', 'admin', now(), 'xkw:44970'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44970');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'ATP在能量代谢中的作用', 'XKW-BIO-44972', '1', 2, '2', '0', 'admin', now(), 'xkw:44972'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44972');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '吸能反应与放能反应', 'XKW-BIO-153312', '2', 3, '2', '0', 'admin', now(), 'xkw:153312'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153312');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞呼吸的方式及过程', 'XKW-BIO-44980', '1', 1, '2', '0', 'admin', now(), 'xkw:44980'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44959'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44980');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞呼吸的影响因素及应用', 'XKW-BIO-44981', '1', 2, '2', '0', 'admin', now(), 'xkw:44981'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44959'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44981');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞呼吸综合', 'XKW-BIO-153314', '2', 3, '2', '0', 'admin', now(), 'xkw:153314'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44959'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153314');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '捕获光能的色素与结构', 'XKW-BIO-44990', '1', 1, '2', '0', 'admin', now(), 'xkw:44990'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44960'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44990');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用的原理和应用', 'XKW-BIO-44991', '1', 2, '2', '0', 'admin', now(), 'xkw:44991'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44960'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44991');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '化能合成作用', 'XKW-BIO-45001', '2', 3, '2', '0', 'admin', now(), 'xkw:45001'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44960'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45001');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用与呼吸作用', 'XKW-BIO-44992', '1', 4, '2', '0', 'admin', now(), 'xkw:44992'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44960'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44992');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '糖类、脂质和蛋白质的代谢过程及与生活的关系', 'XKW-BIO-45006', '2', 1, '2', '0', 'admin', now(), 'xkw:45006'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44961'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45006');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '三大有机物质代谢的相互转化', 'XKW-BIO-45007', '2', 2, '2', '0', 'admin', now(), 'xkw:45007'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44961'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45007');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞不能无限长大', 'XKW-BIO-45011', '1', 1, '2', '0', 'admin', now(), 'xkw:45011'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45008'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45011');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞周期与有丝分裂', 'XKW-BIO-45012', '1', 2, '2', '0', 'admin', now(), 'xkw:45012'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45008'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45012');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无丝分裂', 'XKW-BIO-45013', '1', 3, '2', '0', 'admin', now(), 'xkw:45013'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45008'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45013');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的分化', 'XKW-BIO-45023', '2', 1, '2', '0', 'admin', now(), 'xkw:45023'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45023');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的全能性', 'XKW-BIO-45024', '2', 2, '2', '0', 'admin', now(), 'xkw:45024'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45024');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的衰老', 'XKW-BIO-45025', '2', 3, '2', '0', 'admin', now(), 'xkw:45025'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45025');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的死亡', 'XKW-BIO-45026', '1', 4, '2', '0', 'admin', now(), 'xkw:45026'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45010'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45026');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '减数分裂概念、四分体、同源染色体、非同源染色体', 'XKW-BIO-45042', '2', 1, '2', '0', 'admin', now(), 'xkw:45042'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45042');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '精子的形成过程', 'XKW-BIO-45043', '2', 2, '2', '0', 'admin', now(), 'xkw:45043'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45043');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卵细胞的形成过程', 'XKW-BIO-45044', '2', 3, '2', '0', 'admin', now(), 'xkw:45044'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45044');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '精子和卵细胞的形成过程异同', 'XKW-BIO-153317', '2', 4, '2', '0', 'admin', now(), 'xkw:153317'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153317');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '减数分裂过程中的变化规律', 'XKW-BIO-45045', '2', 5, '2', '0', 'admin', now(), 'xkw:45045'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45045');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '减数分裂异常情况分析', 'XKW-BIO-153447', '2', 6, '2', '0', 'admin', now(), 'xkw:153447'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153447');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '观察细胞的减数分裂实验', 'XKW-BIO-45046', '2', 7, '2', '0', 'admin', now(), 'xkw:45046'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45046');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '受精作用', 'XKW-BIO-45047', '2', 8, '2', '0', 'admin', now(), 'xkw:45047'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45047');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物的个体发育', 'XKW-BIO-45048', '2', 9, '2', '0', 'admin', now(), 'xkw:45048'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45048');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物的个体发育', 'XKW-BIO-45049', '2', 10, '2', '0', 'admin', now(), 'xkw:45049'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45049');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞的减数分裂综合', 'XKW-BIO-153318', '2', 11, '2', '0', 'admin', now(), 'xkw:153318'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153318');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '减数分裂和有丝分裂的综合', 'XKW-BIO-45050', '2', 12, '2', '0', 'admin', now(), 'xkw:45050'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45040'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45050');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '融合遗传', 'XKW-BIO-153319', '2', 1, '2', '0', 'admin', now(), 'xkw:153319'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153319');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '性状与相对性状', 'XKW-BIO-153320', '2', 2, '2', '0', 'admin', now(), 'xkw:153320'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153320');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '纯合子与杂合子', 'XKW-BIO-154599', '2', 3, '2', '0', 'admin', now(), 'xkw:154599'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-154599');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '性状的显、隐性关系及基因型、表现型、等位基因', 'XKW-BIO-154600', '2', 4, '2', '0', 'admin', now(), 'xkw:154600'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-154600');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孟德尔一对相对性状的杂交实验', 'XKW-BIO-45055', '2', 5, '2', '0', 'admin', now(), 'xkw:45055'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45055');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '性状分离比的模拟实验', 'XKW-BIO-45058', '2', 6, '2', '0', 'admin', now(), 'xkw:45058'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45058');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因分离定律的实质和应用', 'XKW-BIO-45057', '2', 7, '2', '0', 'admin', now(), 'xkw:45057'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45057');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分离定律综合问题分析（异常现象分析）', 'XKW-BIO-45059', '2', 8, '2', '0', 'admin', now(), 'xkw:45059'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45059');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '完全显性、不完全显性和共显性', 'XKW-BIO-153321', '2', 9, '2', '0', 'admin', now(), 'xkw:153321'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153321');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用测交的方法检验F1的基因型', 'XKW-BIO-154601', '2', 10, '2', '0', 'admin', now(), 'xkw:154601'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45051'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-154601');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孟德尔两对相对性状的杂交实验', 'XKW-BIO-45060', '2', 1, '2', '0', 'admin', now(), 'xkw:45060'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45052'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45060');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因自由组合定律的实质和应用', 'XKW-BIO-45062', '2', 2, '2', '0', 'admin', now(), 'xkw:45062'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45052'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45062');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孟德尔获得成功的原因', 'XKW-BIO-45063', '2', 3, '2', '0', 'admin', now(), 'xkw:45063'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45052'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45063');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用分离定律思维解决自由组合定律的问题', 'XKW-BIO-45064', '2', 4, '2', '0', 'admin', now(), 'xkw:45064'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45052'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45064');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '9:3:3:1和1:1:1:1的变式类型及应用', 'XKW-BIO-45065', '2', 5, '2', '0', 'admin', now(), 'xkw:45065'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45052'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45065');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因连锁与交换定律', 'XKW-BIO-45066', '2', 6, '2', '0', 'admin', now(), 'xkw:45066'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45052'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45066');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '萨顿的假说', 'XKW-BIO-45067', '2', 1, '2', '0', 'admin', now(), 'xkw:45067'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45053'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45067');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因位于染色体上的实验证据', 'XKW-BIO-45068', '2', 2, '2', '0', 'admin', now(), 'xkw:45068'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45053'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45068');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '孟德尔遗传规律的细胞学解释', 'XKW-BIO-45069', '2', 3, '2', '0', 'admin', now(), 'xkw:45069'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45053'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45069');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '染色体组型和性别决定', 'XKW-BIO-45070', '2', 1, '2', '0', 'admin', now(), 'xkw:45070'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45054'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45070');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '伴性遗传的遗传规律及应用', 'XKW-BIO-45071', '2', 2, '2', '0', 'admin', now(), 'xkw:45071'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45054'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45071');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传系谱图中遗传方式的判定及应用', 'XKW-BIO-45072', '2', 3, '2', '0', 'admin', now(), 'xkw:45072'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45054'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45072');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因在染色体上位置的判定方法问题', 'XKW-BIO-45073', '2', 4, '2', '0', 'admin', now(), 'xkw:45073'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45054'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45073');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA是遗传物质的间接证据', 'XKW-BIO-45081', '2', 1, '2', '0', 'admin', now(), 'xkw:45081'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45074'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45081');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '肺炎链球菌的转化实验', 'XKW-BIO-45082', '2', 2, '2', '0', 'admin', now(), 'xkw:45082'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45074'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45082');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '噬菌体侵染细菌的实验', 'XKW-BIO-45083', '2', 3, '2', '0', 'admin', now(), 'xkw:45083'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45074'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45083');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'RNA是遗传物质的实验证据', 'XKW-BIO-45084', '2', 4, '2', '0', 'admin', now(), 'xkw:45084'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45074'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45084');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA是主要的遗传物质', 'XKW-BIO-45085', '2', 5, '2', '0', 'admin', now(), 'xkw:45085'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45074'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45085');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“加法原理”与“减法原理”', 'XKW-BIO-196651', '2', 6, '2', '0', 'admin', now(), 'xkw:196651'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45074'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196651');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA分子的结构和特点', 'XKW-BIO-45086', '2', 1, '2', '0', 'admin', now(), 'xkw:45086'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45075'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45086');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA分子中碱基的相关计算', 'XKW-BIO-45087', '2', 2, '2', '0', 'admin', now(), 'xkw:45087'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45075'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45087');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '制作DNA双螺旋结构模型', 'XKW-BIO-45088', '2', 3, '2', '0', 'admin', now(), 'xkw:45088'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45075'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45088');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不同生物中核酸、核苷酸和碱基的比较', 'XKW-BIO-45089', '2', 4, '2', '0', 'admin', now(), 'xkw:45089'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45075'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45089');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA分子的复制', 'XKW-BIO-45090', '1', 5, '2', '0', 'admin', now(), 'xkw:45090'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45075'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45090');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因的结构及功能', 'XKW-BIO-45094', '2', 1, '2', '0', 'admin', now(), 'xkw:45094'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45076'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45094');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '染色体、DNA、基因和核苷酸之间的关系', 'XKW-BIO-45095', '2', 2, '2', '0', 'admin', now(), 'xkw:45095'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45076'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45095');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA分子的多样性与特异性', 'XKW-BIO-196652', '2', 3, '2', '0', 'admin', now(), 'xkw:196652'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45076'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196652');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传信息的转录', 'XKW-BIO-45096', '2', 1, '2', '0', 'admin', now(), 'xkw:45096'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45096');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传信息的翻译', 'XKW-BIO-45097', '2', 2, '2', '0', 'admin', now(), 'xkw:45097'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45097');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因表达过程中的相关计算', 'XKW-BIO-45098', '2', 3, '2', '0', 'admin', now(), 'xkw:45098'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45098');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因的表达综合', 'XKW-BIO-153322', '2', 4, '2', '0', 'admin', now(), 'xkw:153322'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45077'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153322');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中心法则及其发展', 'XKW-BIO-45099', '2', 1, '2', '0', 'admin', now(), 'xkw:45099'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45078'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45099');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因、蛋白质与性状的关系', 'XKW-BIO-45100', '2', 2, '2', '0', 'admin', now(), 'xkw:45100'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45078'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45100');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '表观遗传', 'XKW-BIO-154695', '2', 3, '2', '0', 'admin', now(), 'xkw:154695'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45078'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-154695');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传密码的阅读方式', 'XKW-BIO-45101', '2', 1, '2', '0', 'admin', now(), 'xkw:45101'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45079'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45101');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '克里克的实验证据', 'XKW-BIO-45102', '2', 2, '2', '0', 'admin', now(), 'xkw:45102'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45079'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45102');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传密码对应规则的发现', 'XKW-BIO-45103', '2', 3, '2', '0', 'admin', now(), 'xkw:45103'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45079'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45103');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因突变', 'XKW-BIO-45107', '2', 1, '2', '0', 'admin', now(), 'xkw:45107'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45107');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA分子上碱基对的改变对后代性状的影响', 'XKW-BIO-45108', '2', 2, '2', '0', 'admin', now(), 'xkw:45108'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45108');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '癌细胞的概念及主要特征', 'XKW-BIO-45027', '2', 3, '2', '0', 'admin', now(), 'xkw:45027'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45027');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞癌变的原因及防治', 'XKW-BIO-45028', '2', 4, '2', '0', 'admin', now(), 'xkw:45028'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45028');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因重组', 'XKW-BIO-45109', '2', 5, '2', '0', 'admin', now(), 'xkw:45109'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45109');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '染色体结构的变异', 'XKW-BIO-45110', '2', 1, '2', '0', 'admin', now(), 'xkw:45110'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45105'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45110');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '染色体数目的变异', 'XKW-BIO-45111', '2', 2, '2', '0', 'admin', now(), 'xkw:45111'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45105'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45111');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '染色体结构变异和数目变异综合', 'XKW-BIO-153323', '2', 3, '2', '0', 'admin', now(), 'xkw:153323'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45105'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153323');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '低温诱导植物染色体数目的变化实验', 'XKW-BIO-45112', '2', 4, '2', '0', 'admin', now(), 'xkw:45112'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45105'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45112');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因突变、基因重组和染色体变异综合', 'XKW-BIO-45113', '2', 5, '2', '0', 'admin', now(), 'xkw:45113'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45105'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45113');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '染色体组、单倍体、二倍体、多倍体概念', 'XKW-BIO-153324', '2', 6, '2', '0', 'admin', now(), 'xkw:153324'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45105'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153324');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杂交育种', 'XKW-BIO-45114', '2', 1, '2', '0', 'admin', now(), 'xkw:45114'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45114');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '诱变育种', 'XKW-BIO-153325', '2', 2, '2', '0', 'admin', now(), 'xkw:153325'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153325');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单倍体育种', 'XKW-BIO-45115', '2', 3, '2', '0', 'admin', now(), 'xkw:45115'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45115');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多倍体育种', 'XKW-BIO-132840', '2', 4, '2', '0', 'admin', now(), 'xkw:132840'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-132840');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他育种方式', 'XKW-BIO-45117', '2', 5, '2', '0', 'admin', now(), 'xkw:45117'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45106'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45117');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人类遗传病的类型及实例', 'XKW-BIO-45119', '2', 1, '2', '0', 'admin', now(), 'xkw:45119'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45119');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传病的检测和预防', 'XKW-BIO-45120', '2', 2, '2', '0', 'admin', now(), 'xkw:45120'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45120');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人类基因组计划', 'XKW-BIO-45121', '2', 3, '2', '0', 'admin', now(), 'xkw:45121'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45121');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '调查人群中的遗传病', 'XKW-BIO-45122', '2', 4, '2', '0', 'admin', now(), 'xkw:45122'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45122');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传病与人类未来', 'XKW-BIO-45123', '2', 5, '2', '0', 'admin', now(), 'xkw:45123'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45123');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因治疗', 'XKW-BIO-196653', '2', 6, '2', '0', 'admin', now(), 'xkw:196653'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196653');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遗传与人类健康综合', 'XKW-BIO-45037', '2', 7, '2', '0', 'admin', now(), 'xkw:45037'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45118'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45037');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '稳态的概念及调节机制', 'XKW-BIO-196659', '2', 1, '2', '0', 'admin', now(), 'xkw:196659'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-196658'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196659');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '模拟生物体维持pH的稳定', 'XKW-BIO-196660', '2', 2, '2', '0', 'admin', now(), 'xkw:196660'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-196658'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196660');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内环境的稳态及意义', 'XKW-BIO-45144', '2', 3, '2', '0', 'admin', now(), 'xkw:45144'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-196658'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45144');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '稳态概念的发展', 'XKW-BIO-196661', '2', 4, '2', '0', 'admin', now(), 'xkw:196661'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-196658'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196661');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人体的内环境与稳态综合', 'XKW-BIO-45130', '2', 5, '2', '0', 'admin', now(), 'xkw:45130'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-196658'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45130');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经系统的基本结构', 'XKW-BIO-186889', '2', 1, '2', '0', 'admin', now(), 'xkw:186889'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45151'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-186889');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交感神经与副交感神经', 'XKW-BIO-196662', '2', 2, '2', '0', 'admin', now(), 'xkw:196662'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45151'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196662');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '组成神经系统的细胞', 'XKW-BIO-188716', '2', 3, '2', '0', 'admin', now(), 'xkw:188716'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45151'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188716');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '反射与反射弧', 'XKW-BIO-45152', '2', 1, '2', '0', 'admin', now(), 'xkw:45152'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188717'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45152');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非条件反射与条件反射', 'XKW-BIO-45153', '2', 2, '2', '0', 'admin', now(), 'xkw:45153'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188717'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45153');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '兴奋在神经纤维上的传导', 'XKW-BIO-45154', '2', 1, '2', '0', 'admin', now(), 'xkw:45154'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188718'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45154');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '兴奋在神经元之间的传递', 'XKW-BIO-45155', '2', 2, '2', '0', 'admin', now(), 'xkw:45155'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188718'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45155');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '膜电位的变化及相关曲线', 'XKW-BIO-45156', '2', 3, '2', '0', 'admin', now(), 'xkw:45156'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188718'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45156');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '兴奋传导和传递的相关实验', 'XKW-BIO-45157', '2', 4, '2', '0', 'admin', now(), 'xkw:45157'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188718'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45157');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电表偏转问题分析', 'XKW-BIO-196663', '2', 5, '2', '0', 'admin', now(), 'xkw:196663'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188718'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196663');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '药物对兴奋传导及传递的影响', 'XKW-BIO-173703', '2', 6, '2', '0', 'admin', now(), 'xkw:173703'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188718'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-173703');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经系统对内脏活动的分级调节', 'XKW-BIO-186968', '2', 1, '2', '0', 'admin', now(), 'xkw:186968'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45158'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-186968');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经系统对躯体运动的分级调节', 'XKW-BIO-188719', '2', 2, '2', '0', 'admin', now(), 'xkw:188719'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45158'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188719');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '语言', 'XKW-BIO-186969', '2', 1, '2', '0', 'admin', now(), 'xkw:186969'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45159'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-186969');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '学习、记忆、情绪', 'XKW-BIO-186970', '2', 2, '2', '0', 'admin', now(), 'xkw:186970'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45159'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-186970');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '激素调节的发现历程及相关实验分析', 'XKW-BIO-45160', '2', 1, '2', '0', 'admin', now(), 'xkw:45160'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188720'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45160');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内分泌系统的组成和功能', 'XKW-BIO-45161', '2', 2, '2', '0', 'admin', now(), 'xkw:45161'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188720'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45161');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '激素分泌的分级调节', 'XKW-BIO-45162', '2', 1, '2', '0', 'admin', now(), 'xkw:45162'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188721'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45162');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '激素分泌的反馈调节', 'XKW-BIO-187981', '2', 2, '2', '0', 'admin', now(), 'xkw:187981'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188721'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-187981');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '激素调节的特点', 'XKW-BIO-45163', '2', 3, '2', '0', 'admin', now(), 'xkw:45163'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188721'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45163');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '激素调节信号转导的分子机制', 'XKW-BIO-45164', '2', 4, '2', '0', 'admin', now(), 'xkw:45164'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188721'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45164');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '神经调节与体液调节的比较', 'XKW-BIO-45165', '2', 1, '2', '0', 'admin', now(), 'xkw:45165'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188722'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45165');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体温调节', 'XKW-BIO-45166', '2', 2, '2', '0', 'admin', now(), 'xkw:45166'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188722'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45166');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '水盐平衡调节', 'XKW-BIO-45167', '2', 3, '2', '0', 'admin', now(), 'xkw:45167'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188722'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45167');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '血糖调节', 'XKW-BIO-45168', '2', 4, '2', '0', 'admin', now(), 'xkw:45168'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188722'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45168');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '血脂代谢及其调节', 'XKW-BIO-45169', '2', 5, '2', '0', 'admin', now(), 'xkw:45169'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188722'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45169');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '血压及其调节', 'XKW-BIO-45170', '2', 6, '2', '0', 'admin', now(), 'xkw:45170'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188722'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45170');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物激素的调节和应用', 'XKW-BIO-45171', '2', 7, '2', '0', 'admin', now(), 'xkw:45171'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188722'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45171');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '验证（探究）人或动物某种激素的生理作用', 'XKW-BIO-45172', '2', 8, '2', '0', 'admin', now(), 'xkw:45172'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188722'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45172');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他体液成分参与稳态的调节', 'XKW-BIO-186972', '2', 9, '2', '0', 'admin', now(), 'xkw:186972'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188722'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-186972');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '免疫系统的组成', 'XKW-BIO-188723', '2', 1, '2', '0', 'admin', now(), 'xkw:188723'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45173'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188723');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '免疫系统的功能', 'XKW-BIO-188724', '2', 2, '2', '0', 'admin', now(), 'xkw:188724'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45173'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188724');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非特异性免疫与特异性免疫', 'XKW-BIO-45174', '2', 3, '2', '0', 'admin', now(), 'xkw:45174'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45173'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45174');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体液免疫', 'XKW-BIO-45175', '2', 1, '2', '0', 'admin', now(), 'xkw:45175'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188725'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45175');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞免疫', 'XKW-BIO-45176', '2', 2, '2', '0', 'admin', now(), 'xkw:45176'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188725'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45176');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体液免疫和细胞免疫的协调配合', 'XKW-BIO-188726', '2', 3, '2', '0', 'admin', now(), 'xkw:188726'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188725'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188726');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过敏反应', 'XKW-BIO-188727', '2', 1, '2', '0', 'admin', now(), 'xkw:188727'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188727');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自身免疫病', 'XKW-BIO-188728', '2', 2, '2', '0', 'admin', now(), 'xkw:188728'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188728');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '免疫缺陷病', 'XKW-BIO-188729', '2', 3, '2', '0', 'admin', now(), 'xkw:188729'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188729');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '疫苗', 'XKW-BIO-188730', '2', 1, '2', '0', 'admin', now(), 'xkw:188730'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188730');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '器官移植', 'XKW-BIO-188731', '2', 2, '2', '0', 'admin', now(), 'xkw:188731'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188731');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生长素的发现过程', 'XKW-BIO-45187', '2', 1, '2', '0', 'admin', now(), 'xkw:45187'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45187');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生长素的产生、分布及运输', 'XKW-BIO-45188', '2', 2, '2', '0', 'admin', now(), 'xkw:45188'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45188');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不同处理方案下植物的向性运动', 'XKW-BIO-45189', '2', 3, '2', '0', 'admin', now(), 'xkw:45189'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45189');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生长素的生理作用', 'XKW-BIO-45182', '1', 4, '2', '0', 'admin', now(), 'xkw:45182'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45182');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他植物激素的产生、分布和功能', 'XKW-BIO-45193', '2', 1, '2', '0', 'admin', now(), 'xkw:45193'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45193');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不同的植物激素对植物生命活动的调节', 'XKW-BIO-45194', '2', 2, '2', '0', 'admin', now(), 'xkw:45194'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45183'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45194');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物的向性运动', 'XKW-BIO-45184', '2', 1, '2', '0', 'admin', now(), 'xkw:45184'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45180'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45184');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '参与调节植物生命活动的其他环境因素', 'XKW-BIO-45185', '2', 2, '2', '0', 'admin', now(), 'xkw:45185'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45180'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45185');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物对不良环境的适应性反应', 'XKW-BIO-45186', '2', 3, '2', '0', 'admin', now(), 'xkw:45186'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45180'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45186');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群的数量特征', 'XKW-BIO-188733', '1', 1, '2', '0', 'admin', now(), 'xkw:188733'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45196'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188733');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群数量的变化', 'XKW-BIO-188734', '1', 2, '2', '0', 'admin', now(), 'xkw:188734'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45196'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188734');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '影响种群数量变化的因素', 'XKW-BIO-45202', '2', 3, '2', '0', 'admin', now(), 'xkw:45202'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45196'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45202');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群综合', 'XKW-BIO-163094', '2', 4, '2', '0', 'admin', now(), 'xkw:163094'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45196'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-163094');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '群落的结构', 'XKW-BIO-188735', '1', 1, '2', '0', 'admin', now(), 'xkw:188735'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45197'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188735');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '群落的主要类型', 'XKW-BIO-173704', '2', 2, '2', '0', 'admin', now(), 'xkw:173704'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45197'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-173704');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '群落的演替及其影响因素', 'XKW-BIO-45209', '2', 3, '2', '0', 'admin', now(), 'xkw:45209'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45197'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45209');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '群落综合', 'XKW-BIO-163095', '2', 4, '2', '0', 'admin', now(), 'xkw:163095'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45197'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-163095');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '环境对生物的重要性', 'XKW-BIO-45214', '2', 1, '2', '0', 'admin', now(), 'xkw:45214'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45210'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45214');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的概念和类型', 'XKW-BIO-45215', '2', 2, '2', '0', 'admin', now(), 'xkw:45215'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45210'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45215');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的组成成分', 'XKW-BIO-45216', '2', 3, '2', '0', 'admin', now(), 'xkw:45216'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45210'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45216');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '食物链和食物网', 'XKW-BIO-45217', '2', 4, '2', '0', 'admin', now(), 'xkw:45217'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45210'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45217');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物圈的概念、范围', 'XKW-BIO-45218', '2', 5, '2', '0', 'admin', now(), 'xkw:45218'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45210'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45218');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的能量流动', 'XKW-BIO-45219', '1', 1, '2', '0', 'admin', now(), 'xkw:45219'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45211'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45219');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的物质循环', 'XKW-BIO-45220', '1', 2, '2', '0', 'admin', now(), 'xkw:45220'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45211'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45220');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统的信息传递', 'XKW-BIO-45221', '1', 3, '2', '0', 'admin', now(), 'xkw:45221'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45211'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45221');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态平衡与生态系统的稳定性及自我调节能力', 'XKW-BIO-45233', '2', 1, '2', '0', 'admin', now(), 'xkw:45233'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45233');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抵抗力稳定性和恢复力稳定性', 'XKW-BIO-45234', '2', 2, '2', '0', 'admin', now(), 'xkw:45234'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45234');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '提高生态系统稳定性的措施', 'XKW-BIO-45235', '2', 3, '2', '0', 'admin', now(), 'xkw:45235'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45235');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '设计并制作生态瓶，观察其稳定性', 'XKW-BIO-45236', '2', 4, '2', '0', 'admin', now(), 'xkw:45236'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45236');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人口增长与生态足迹', 'XKW-BIO-45239', '2', 1, '2', '0', 'admin', now(), 'xkw:45239'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45237'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45239');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关注全球性生态环境问题', 'XKW-BIO-45240', '2', 2, '2', '0', 'admin', now(), 'xkw:45240'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45237'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45240');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全球性的环境问题及环境污染的防治', 'XKW-BIO-45241', '2', 1, '2', '0', 'admin', now(), 'xkw:45241'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45238'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45241');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物多样性及其价值', 'XKW-BIO-154697', '2', 2, '2', '0', 'admin', now(), 'xkw:154697'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45238'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-154697');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物多样性丧失原因及其保护措施', 'XKW-BIO-45242', '2', 3, '2', '0', 'admin', now(), 'xkw:45242'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45238'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45242');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态工程的特点及基本原理', 'XKW-BIO-45356', '2', 1, '2', '0', 'admin', now(), 'xkw:45356'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45313'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45356');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态工程实例及发展前景', 'XKW-BIO-45357', '1', 2, '2', '0', 'admin', now(), 'xkw:45357'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45313'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45357');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态工程综合', 'XKW-BIO-45314', '2', 3, '2', '0', 'admin', now(), 'xkw:45314'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45313'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45314');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '果酒和果醋的制作', 'XKW-BIO-45284', '1', 1, '2', '0', 'admin', now(), 'xkw:45284'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45284');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '腐乳的制作', 'XKW-BIO-45285', '1', 2, '2', '0', 'admin', now(), 'xkw:45285'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45285');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '泡菜的制作', 'XKW-BIO-45286', '1', 3, '2', '0', 'admin', now(), 'xkw:45286'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45286');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酸奶的制作', 'XKW-BIO-230048', '2', 4, '2', '0', 'admin', now(), 'xkw:230048'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-230048');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物有效成分的提取', 'XKW-BIO-45287', '1', 5, '2', '0', 'admin', now(), 'xkw:45287'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45287');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传统发酵技术的应用综合', 'XKW-BIO-45250', '2', 6, '2', '0', 'admin', now(), 'xkw:45250'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45249'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45250');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微生物的实验室培养', 'XKW-BIO-45253', '1', 1, '2', '0', 'admin', now(), 'xkw:45253'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45243'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45253');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分离特定微生物并测定其数量', 'XKW-BIO-45254', '1', 2, '2', '0', 'admin', now(), 'xkw:45254'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45243'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45254');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微生物的培养与应用综合', 'XKW-BIO-45244', '2', 3, '2', '0', 'admin', now(), 'xkw:45244'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45243'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45244');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶的制备和应用', 'XKW-BIO-45272', '1', 1, '2', '0', 'admin', now(), 'xkw:45272'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45272');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '固定化酶的制备及应用', 'XKW-BIO-45273', '1', 2, '2', '0', 'admin', now(), 'xkw:45273'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45273');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶的研究与应用综合', 'XKW-BIO-45248', '2', 3, '2', '0', 'admin', now(), 'xkw:45248'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45247'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45248');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质的提取和分离', 'XKW-BIO-45297', '1', 1, '2', '0', 'admin', now(), 'xkw:45297'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45251'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45297');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA和蛋白质技术综合', 'XKW-BIO-45252', '2', 2, '2', '0', 'admin', now(), 'xkw:45252'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45251'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45252');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发酵工程的基本环节', 'XKW-BIO-181984', '2', 1, '2', '0', 'admin', now(), 'xkw:181984'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-181983'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-181984');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发酵工程的应用', 'XKW-BIO-181985', '2', 2, '2', '0', 'admin', now(), 'xkw:181985'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-181983'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-181985');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因工程的概念及原理', 'XKW-BIO-45319', '2', 1, '2', '0', 'admin', now(), 'xkw:45319'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45315'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45319');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA重组技术的基本工具', 'XKW-BIO-45320', '2', 2, '2', '0', 'admin', now(), 'xkw:45320'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45315'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45320');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA的粗提取及鉴定', 'XKW-BIO-45298', '2', 3, '2', '0', 'admin', now(), 'xkw:45298'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45315'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45298');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '目的基因的筛选、获取', 'XKW-BIO-45321', '1', 1, '2', '0', 'admin', now(), 'xkw:45321'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45321');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因表达载体的构建', 'XKW-BIO-45322', '2', 2, '2', '0', 'admin', now(), 'xkw:45322'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45322');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '将目的基因导入受体细胞', 'XKW-BIO-45323', '2', 3, '2', '0', 'admin', now(), 'xkw:45323'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45323');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '目的基因的检测与鉴定', 'XKW-BIO-45324', '2', 4, '2', '0', 'admin', now(), 'xkw:45324'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45324');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电泳鉴定', 'XKW-BIO-196665', '2', 5, '2', '0', 'admin', now(), 'xkw:196665'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196665');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因工程的操作程序综合', 'XKW-BIO-157370', '2', 6, '2', '0', 'admin', now(), 'xkw:157370'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-157370');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因工程在农牧业、制药及环境等方面的应用', 'XKW-BIO-45325', '2', 1, '2', '0', 'admin', now(), 'xkw:45325'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45317'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45325');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因诊断和基因治疗', 'XKW-BIO-45326', '2', 2, '2', '0', 'admin', now(), 'xkw:45326'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45317'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45326');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基因芯片', 'XKW-BIO-45327', '2', 3, '2', '0', 'admin', now(), 'xkw:45327'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45317'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45327');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质工程原理及操作流程', 'XKW-BIO-45328', '2', 1, '2', '0', 'admin', now(), 'xkw:45328'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45318'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45328');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质工程的应用及实例分析', 'XKW-BIO-45329', '2', 2, '2', '0', 'admin', now(), 'xkw:45329'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45318'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45329');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物的组织培养技术', 'XKW-BIO-45245', '1', 1, '2', '0', 'admin', now(), 'xkw:45245'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45331'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45245');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物组织培养技术综合', 'XKW-BIO-45336', '2', 2, '2', '0', 'admin', now(), 'xkw:45336'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45331'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45336');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物体细胞杂交技术', 'XKW-BIO-45337', '2', 3, '2', '0', 'admin', now(), 'xkw:45337'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45331'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45337');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物细胞工程的实际应用', 'XKW-BIO-45338', '2', 4, '2', '0', 'admin', now(), 'xkw:45338'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45331'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45338');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物细胞培养技术', 'XKW-BIO-45339', '2', 1, '2', '0', 'admin', now(), 'xkw:45339'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45332'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45339');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物体细胞核移植技术和克隆', 'XKW-BIO-45340', '1', 2, '2', '0', 'admin', now(), 'xkw:45340'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45332'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45340');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物细胞工程的实际应用', 'XKW-BIO-45334', '2', 3, '2', '0', 'admin', now(), 'xkw:45334'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45332'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45334');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '精子和卵子的发生', 'XKW-BIO-45344', '2', 1, '2', '0', 'admin', now(), 'xkw:45344'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45341'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45344');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '体内受精', 'XKW-BIO-45345', '2', 2, '2', '0', 'admin', now(), 'xkw:45345'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45341'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45345');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胚胎发育', 'XKW-BIO-45346', '2', 3, '2', '0', 'admin', now(), 'xkw:45346'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45341'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45346');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物的体外受精', 'XKW-BIO-45347', '2', 1, '2', '0', 'admin', now(), 'xkw:45347'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45342'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45347');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胚胎的体外培养', 'XKW-BIO-45348', '2', 2, '2', '0', 'admin', now(), 'xkw:45348'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45342'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45348');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胚胎移植技术', 'XKW-BIO-45349', '2', 1, '2', '0', 'admin', now(), 'xkw:45349'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45349');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胚胎分割技术', 'XKW-BIO-45350', '2', 2, '2', '0', 'admin', now(), 'xkw:45350'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45350');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胚胎干细胞技术', 'XKW-BIO-45351', '2', 3, '2', '0', 'admin', now(), 'xkw:45351'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45351');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胚胎工程的应用', 'XKW-BIO-45352', '2', 4, '2', '0', 'admin', now(), 'xkw:45352'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45352');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '显微镜的种类、构造及使用', 'XKW-BIO-44937', '2', 1, '2', '0', 'admin', now(), 'xkw:44937'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44933'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44937');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '显微镜放大倍数及细胞个数的计算', 'XKW-BIO-44938', '2', 2, '2', '0', 'admin', now(), 'xkw:44938'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44933'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44938');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '显微镜的成像特点及装片的移动方向问题', 'XKW-BIO-44939', '2', 3, '2', '0', 'admin', now(), 'xkw:44939'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44933'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44939');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞膜的成分', 'XKW-BIO-44943', '2', 1, '2', '0', 'admin', now(), 'xkw:44943'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44943');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '制备细胞膜', 'XKW-BIO-44944', '2', 2, '2', '0', 'admin', now(), 'xkw:44944'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44944');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞膜的功能', 'XKW-BIO-44945', '2', 3, '2', '0', 'admin', now(), 'xkw:44945'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44945');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞膜的结构和功能综合', 'XKW-BIO-153304', '2', 4, '2', '0', 'admin', now(), 'xkw:153304'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153304');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物膜结构的探索历程', 'XKW-BIO-44946', '2', 1, '2', '0', 'admin', now(), 'xkw:44946'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44946');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物膜的流动镶嵌模型', 'XKW-BIO-44947', '2', 2, '2', '0', 'admin', now(), 'xkw:44947'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44947');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物膜的结构特点', 'XKW-BIO-153305', '2', 3, '2', '0', 'admin', now(), 'xkw:153305'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153305');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物膜的功能特性', 'XKW-BIO-153306', '2', 4, '2', '0', 'admin', now(), 'xkw:153306'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153306');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物膜系统的组成、功能及应用', 'XKW-BIO-44953', '2', 5, '2', '0', 'admin', now(), 'xkw:44953'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44953');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自由扩散', 'XKW-BIO-188576', '2', 1, '2', '0', 'admin', now(), 'xkw:188576'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44967'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188576');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '协助扩散', 'XKW-BIO-188577', '2', 2, '2', '0', 'admin', now(), 'xkw:188577'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44967'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188577');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶的作用及机理', 'XKW-BIO-44973', '2', 1, '2', '0', 'admin', now(), 'xkw:44973'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44970'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44973');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶的本质', 'XKW-BIO-44974', '2', 2, '2', '0', 'admin', now(), 'xkw:44974'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44970'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44974');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶的特性', 'XKW-BIO-44975', '2', 3, '2', '0', 'admin', now(), 'xkw:44975'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44970'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44975');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶促反应的因素及实验', 'XKW-BIO-44971', '2', 4, '2', '0', 'admin', now(), 'xkw:44971'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44970'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44971');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶综合', 'XKW-BIO-153310', '2', 5, '2', '0', 'admin', now(), 'xkw:153310'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44970'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153310');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞中的能源物质', 'XKW-BIO-44976', '2', 1, '2', '0', 'admin', now(), 'xkw:44976'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44972'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44976');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'ATP的结构', 'XKW-BIO-44979', '2', 2, '2', '0', 'admin', now(), 'xkw:44979'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44972'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44979');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'ATP与ADP的相互转化', 'XKW-BIO-44978', '2', 3, '2', '0', 'admin', now(), 'xkw:44978'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44972'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44978');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'ATP的功能及利用', 'XKW-BIO-44977', '2', 4, '2', '0', 'admin', now(), 'xkw:44977'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44972'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44977');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'ATP在能量代谢中的作用综合', 'XKW-BIO-153311', '2', 5, '2', '0', 'admin', now(), 'xkw:153311'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44972'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153311');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究酵母菌细胞呼吸的方式', 'XKW-BIO-44982', '2', 1, '2', '0', 'admin', now(), 'xkw:44982'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44982');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有氧呼吸过程', 'XKW-BIO-44983', '2', 2, '2', '0', 'admin', now(), 'xkw:44983'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44983');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无氧呼吸过程', 'XKW-BIO-44984', '2', 3, '2', '0', 'admin', now(), 'xkw:44984'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44984');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有氧呼吸和无氧呼吸的异同', 'XKW-BIO-153313', '2', 4, '2', '0', 'admin', now(), 'xkw:153313'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153313');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞呼吸的实质及意义', 'XKW-BIO-44985', '2', 5, '2', '0', 'admin', now(), 'xkw:44985'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44985');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞呼吸类型判断及相关实验', 'XKW-BIO-44986', '2', 6, '2', '0', 'admin', now(), 'xkw:44986'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44986');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有氧呼吸与无氧呼吸的有关计算', 'XKW-BIO-44987', '2', 7, '2', '0', 'admin', now(), 'xkw:44987'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44980'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44987');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '影响细胞呼吸的因素', 'XKW-BIO-44988', '2', 1, '2', '0', 'admin', now(), 'xkw:44988'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44988');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞呼吸原理在生产和生活中的应用', 'XKW-BIO-44989', '2', 2, '2', '0', 'admin', now(), 'xkw:44989'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44981'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44989');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合色素的种类、含量及功能', 'XKW-BIO-44993', '2', 1, '2', '0', 'admin', now(), 'xkw:44993'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44990'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44993');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '绿叶中色素的提取和分离实验', 'XKW-BIO-44994', '2', 2, '2', '0', 'admin', now(), 'xkw:44994'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44990'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44994');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '叶绿体的结构与功能', 'XKW-BIO-44995', '2', 3, '2', '0', 'admin', now(), 'xkw:44995'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44990'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44995');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用原理实验', 'XKW-BIO-44996', '2', 1, '2', '0', 'admin', now(), 'xkw:44996'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44991'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44996');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光反应、暗（碳）反应的物质变化和能量变化', 'XKW-BIO-44997', '2', 2, '2', '0', 'admin', now(), 'xkw:44997'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44991'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44997');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用的实质和意义', 'XKW-BIO-153315', '2', 3, '2', '0', 'admin', now(), 'xkw:153315'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44991'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153315');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '影响光合作用的因素', 'XKW-BIO-44998', '2', 4, '2', '0', 'admin', now(), 'xkw:44998'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44991'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44998');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '环境条件骤变时光合作用过程中各种物质含量变化规律', 'XKW-BIO-44999', '2', 5, '2', '0', 'admin', now(), 'xkw:44999'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44991'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-44999');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用原理的应用', 'XKW-BIO-45000', '2', 6, '2', '0', 'admin', now(), 'xkw:45000'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44991'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45000');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用综合', 'XKW-BIO-153316', '2', 7, '2', '0', 'admin', now(), 'xkw:153316'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44991'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-153316');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用与细胞呼吸在物质和能量代谢上的区别与联系', 'XKW-BIO-45002', '2', 1, '2', '0', 'admin', now(), 'xkw:45002'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44992'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45002');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '总、净光合与呼吸', 'XKW-BIO-45003', '2', 2, '2', '0', 'admin', now(), 'xkw:45003'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44992'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45003');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用与呼吸作用的综合计算问题', 'XKW-BIO-45004', '2', 3, '2', '0', 'admin', now(), 'xkw:45004'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44992'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45004');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光合作用与呼吸作用的综合实验分析与设计', 'XKW-BIO-45005', '2', 4, '2', '0', 'admin', now(), 'xkw:45005'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-44992'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45005');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多细胞生物体生长及细胞不能无限长大的原因', 'XKW-BIO-45014', '2', 1, '2', '0', 'admin', now(), 'xkw:45014'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45011'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45014');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究细胞大小与物质运输的关系', 'XKW-BIO-45015', '2', 2, '2', '0', 'admin', now(), 'xkw:45015'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45011'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45015');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞增殖的方式及细胞周期', 'XKW-BIO-45016', '2', 1, '2', '0', 'admin', now(), 'xkw:45016'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45016');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有丝分裂中染色体的形态结构', 'XKW-BIO-45041', '2', 2, '2', '0', 'admin', now(), 'xkw:45041'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45041');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物细胞的有丝分裂', 'XKW-BIO-45017', '2', 3, '2', '0', 'admin', now(), 'xkw:45017'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45017');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动物细胞的有丝分裂', 'XKW-BIO-45018', '2', 4, '2', '0', 'admin', now(), 'xkw:45018'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45018');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动、植物细胞有丝分裂异同', 'XKW-BIO-45019', '2', 5, '2', '0', 'admin', now(), 'xkw:45019'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45019');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有丝分裂的物质的变化规律', 'XKW-BIO-45020', '2', 6, '2', '0', 'admin', now(), 'xkw:45020'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45020');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有丝分裂的特征和意义', 'XKW-BIO-45021', '2', 7, '2', '0', 'admin', now(), 'xkw:45021'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45021');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有丝分裂实验', 'XKW-BIO-45022', '2', 8, '2', '0', 'admin', now(), 'xkw:45022'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45022');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有丝分裂与无丝分裂的异同', 'XKW-BIO-195831', '2', 1, '2', '0', 'admin', now(), 'xkw:195831'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45013'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-195831');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞凋亡', 'XKW-BIO-188578', '2', 1, '2', '0', 'admin', now(), 'xkw:188578'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188578');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞坏死', 'XKW-BIO-188579', '2', 2, '2', '0', 'admin', now(), 'xkw:188579'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188579');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '细胞自噬', 'XKW-BIO-188580', '2', 3, '2', '0', 'admin', now(), 'xkw:188580'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188580');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究DNA的复制过程', 'XKW-BIO-45091', '2', 1, '2', '0', 'admin', now(), 'xkw:45091'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45090'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45091');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA分子的复制过程、特点及意义', 'XKW-BIO-45092', '2', 2, '2', '0', 'admin', now(), 'xkw:45092'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45090'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45092');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DNA分子复制的相关计算', 'XKW-BIO-45093', '2', 3, '2', '0', 'admin', now(), 'xkw:45093'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45090'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45093');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生长素的生理作用以及实例分析', 'XKW-BIO-45190', '2', 1, '2', '0', 'admin', now(), 'xkw:45190'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45190');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生长素类似物在农业生产中的应用', 'XKW-BIO-45191', '2', 2, '2', '0', 'admin', now(), 'xkw:45191'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45191');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探索生长素类似物促进插条生根的最适浓度', 'XKW-BIO-45192', '2', 3, '2', '0', 'admin', now(), 'xkw:45192'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45182'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45192');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群的概念及特征', 'XKW-BIO-45198', '2', 1, '2', '0', 'admin', now(), 'xkw:45198'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188733'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45198');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群密度的调查方法及应用', 'XKW-BIO-45199', '2', 2, '2', '0', 'admin', now(), 'xkw:45199'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188733'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45199');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群的存活曲线', 'XKW-BIO-45200', '2', 1, '2', '0', 'admin', now(), 'xkw:45200'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188734'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45200');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '种群数量增长曲线', 'XKW-BIO-45201', '2', 2, '2', '0', 'admin', now(), 'xkw:45201'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188734'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45201');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究培养液中酵母菌种群数量的变化', 'XKW-BIO-45203', '2', 3, '2', '0', 'admin', now(), 'xkw:45203'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188734'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45203');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '群落的概念', 'XKW-BIO-45208', '2', 1, '2', '0', 'admin', now(), 'xkw:45208'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45208');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '群落的物种组成以及丰富度的相关探究实验', 'XKW-BIO-45204', '2', 2, '2', '0', 'admin', now(), 'xkw:45204'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45204');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '群落的季节性', 'XKW-BIO-196664', '2', 3, '2', '0', 'admin', now(), 'xkw:196664'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-196664');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '群落中生物的种间关系', 'XKW-BIO-45205', '2', 4, '2', '0', 'admin', now(), 'xkw:45205'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45205');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物的生长型和群落结构', 'XKW-BIO-45206', '2', 5, '2', '0', 'admin', now(), 'xkw:45206'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45206');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物种在群落中的生态位', 'XKW-BIO-45207', '2', 6, '2', '0', 'admin', now(), 'xkw:45207'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-188735'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45207');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量流动的概念和过程', 'XKW-BIO-45222', '2', 1, '2', '0', 'admin', now(), 'xkw:45222'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45219'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45222');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量流动的特点以及研究能量流动的意义', 'XKW-BIO-45223', '2', 2, '2', '0', 'admin', now(), 'xkw:45223'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45219'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45223');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量流动的相关计算', 'XKW-BIO-45224', '2', 3, '2', '0', 'admin', now(), 'xkw:45224'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45219'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45224');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态金字塔的种类及特点', 'XKW-BIO-45225', '2', 4, '2', '0', 'admin', now(), 'xkw:45225'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45219'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45225');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物质循环的概念和特点', 'XKW-BIO-45226', '2', 1, '2', '0', 'admin', now(), 'xkw:45226'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45220'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45226');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '碳循环', 'XKW-BIO-45227', '2', 2, '2', '0', 'admin', now(), 'xkw:45227'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45220'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45227');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物质循环与能量流动的关系', 'XKW-BIO-45228', '2', 3, '2', '0', 'admin', now(), 'xkw:45228'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45220'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45228');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究土壤微生物的分解作用', 'XKW-BIO-45229', '2', 4, '2', '0', 'admin', now(), 'xkw:45229'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45220'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45229');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '水体富营养化', 'XKW-BIO-45230', '2', 5, '2', '0', 'admin', now(), 'xkw:45230'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45220'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45230');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生物富集', 'XKW-BIO-173705', '2', 6, '2', '0', 'admin', now(), 'xkw:173705'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45220'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-173705');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态系统中信息的种类、作用及传递过程', 'XKW-BIO-45231', '2', 1, '2', '0', 'admin', now(), 'xkw:45231'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45221'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45231');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '信息传递在农业生产中的应用', 'XKW-BIO-45232', '2', 2, '2', '0', 'admin', now(), 'xkw:45232'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45221'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45232');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态工程的实例分析', 'XKW-BIO-45358', '2', 1, '2', '0', 'admin', now(), 'xkw:45358'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45357'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45358');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态工程的意义和生态工程发展的前景', 'XKW-BIO-45359', '2', 2, '2', '0', 'admin', now(), 'xkw:45359'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45357'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45359');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生态农业', 'XKW-BIO-45360', '2', 3, '2', '0', 'admin', now(), 'xkw:45360'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45357'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45360');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '果酒和果醋的制作原理', 'XKW-BIO-45288', '2', 1, '2', '0', 'admin', now(), 'xkw:45288'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45284'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45288');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '果酒和果醋的制作流程及实验分析', 'XKW-BIO-45289', '2', 2, '2', '0', 'admin', now(), 'xkw:45289'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45284'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45289');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '腐乳制作的原理', 'XKW-BIO-45290', '2', 1, '2', '0', 'admin', now(), 'xkw:45290'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45285'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45290');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '腐乳制作的步骤及注意事项', 'XKW-BIO-45291', '2', 2, '2', '0', 'admin', now(), 'xkw:45291'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45285'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45291');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '影响腐乳品质的因素', 'XKW-BIO-45292', '2', 3, '2', '0', 'admin', now(), 'xkw:45292'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45285'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45292');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '泡菜的腌制', 'XKW-BIO-45293', '2', 1, '2', '0', 'admin', now(), 'xkw:45293'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45286'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45293');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '亚硝酸盐含量的测定', 'XKW-BIO-45294', '2', 2, '2', '0', 'admin', now(), 'xkw:45294'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45286'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45294');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物芳香油的提取', 'XKW-BIO-45295', '2', 1, '2', '0', 'admin', now(), 'xkw:45295'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45287'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45295');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物色素的提取', 'XKW-BIO-45296', '2', 2, '2', '0', 'admin', now(), 'xkw:45296'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45287'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45296');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '培养基的成分及其功能', 'XKW-BIO-45255', '2', 1, '2', '0', 'admin', now(), 'xkw:45255'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45255');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '培养基的类型及其应用', 'XKW-BIO-45256', '2', 2, '2', '0', 'admin', now(), 'xkw:45256'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45256');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无菌技术', 'XKW-BIO-45257', '2', 3, '2', '0', 'admin', now(), 'xkw:45257'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45257');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '培养基的制备', 'XKW-BIO-45258', '2', 4, '2', '0', 'admin', now(), 'xkw:45258'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45258');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微生物的接种方法', 'XKW-BIO-45259', '2', 5, '2', '0', 'admin', now(), 'xkw:45259'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45259');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微生物的培养与菌种保藏', 'XKW-BIO-45260', '2', 6, '2', '0', 'admin', now(), 'xkw:45260'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45260');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '显微镜直接计数', 'XKW-BIO-154698', '2', 7, '2', '0', 'admin', now(), 'xkw:154698'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-154698');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微生物传染病的传播和预防', 'XKW-BIO-154699', '2', 8, '2', '0', 'admin', now(), 'xkw:154699'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45253'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-154699');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '土壤中分解尿素的细菌的分离与计数', 'XKW-BIO-45261', '2', 1, '2', '0', 'admin', now(), 'xkw:45261'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45254'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45261');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分解纤维素的微生物的分离', 'XKW-BIO-45262', '2', 2, '2', '0', 'admin', now(), 'xkw:45262'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45254'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45262');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他微生物的分离与计数', 'XKW-BIO-45263', '2', 3, '2', '0', 'admin', now(), 'xkw:45263'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45254'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45263');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '加酶洗衣粉', 'XKW-BIO-45274', '2', 1, '2', '0', 'admin', now(), 'xkw:45274'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45272'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45274');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究加酶洗衣粉洗涤效果的实验设计', 'XKW-BIO-45275', '2', 2, '2', '0', 'admin', now(), 'xkw:45275'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45272'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45275');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'α-淀粉酶的固定化及淀粉水解作用的检测', 'XKW-BIO-45276', '2', 3, '2', '0', 'admin', now(), 'xkw:45276'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45272'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45276');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '果胶酶在果汁生产中的作用', 'XKW-BIO-45277', '1', 4, '2', '0', 'admin', now(), 'xkw:45277'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45272'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45277');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '固定化酶和固定化细胞及其应用', 'XKW-BIO-45282', '2', 1, '2', '0', 'admin', now(), 'xkw:45282'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45282');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '制备固定化酵母细胞', 'XKW-BIO-45283', '2', 2, '2', '0', 'admin', now(), 'xkw:45283'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45273'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45283');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质分离的原理及方法', 'XKW-BIO-45300', '2', 1, '2', '0', 'admin', now(), 'xkw:45300'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45297'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45300');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '蛋白质的提取和分离的实验操作', 'XKW-BIO-45301', '2', 2, '2', '0', 'admin', now(), 'xkw:45301'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45297'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45301');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '乳酸脱氢同工酶的分离', 'XKW-BIO-45302', '2', 3, '2', '0', 'admin', now(), 'xkw:45302'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45297'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45302');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '筛选、获取合适的目的基因', 'XKW-BIO-188940', '2', 1, '2', '0', 'admin', now(), 'xkw:188940'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45321'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-188940');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'PCR扩增的原理与过程', 'XKW-BIO-45299', '2', 2, '2', '0', 'admin', now(), 'xkw:45299'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45321'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45299');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '菊花的组织培养', 'XKW-BIO-45264', '1', 1, '2', '0', 'admin', now(), 'xkw:45264'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45245'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45264');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '月季的花药培养', 'XKW-BIO-45265', '1', 2, '2', '0', 'admin', now(), 'xkw:45265'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45245'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45265');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '克隆', 'XKW-BIO-45330', '2', 1, '2', '0', 'admin', now(), 'xkw:45330'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45340'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45330');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '果胶酶的组成和作用', 'XKW-BIO-45278', '2', 1, '2', '0', 'admin', now(), 'xkw:45278'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45278');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '酶的活性与影响酶活性的因素', 'XKW-BIO-45279', '2', 2, '2', '0', 'admin', now(), 'xkw:45279'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45279');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究温度和pH对酶活性的影响', 'XKW-BIO-45280', '2', 3, '2', '0', 'admin', now(), 'xkw:45280'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45280');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究果胶酶用量的实验设计', 'XKW-BIO-45281', '2', 4, '2', '0', 'admin', now(), 'xkw:45281'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45281');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '植物组织的培养及基本过程', 'XKW-BIO-45266', '2', 1, '2', '0', 'admin', now(), 'xkw:45266'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45264'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45266');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '影响植物组织培养的因素', 'XKW-BIO-45267', '2', 2, '2', '0', 'admin', now(), 'xkw:45267'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45264'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45267');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实验操作', 'XKW-BIO-45268', '2', 3, '2', '0', 'admin', now(), 'xkw:45268'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45264'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45268');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '被子植物的花粉发育', 'XKW-BIO-45269', '2', 1, '2', '0', 'admin', now(), 'xkw:45269'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45265'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45269');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '产生花粉植株的两种途径', 'XKW-BIO-45270', '2', 2, '2', '0', 'admin', now(), 'xkw:45270'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45265'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45270');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '花药离体培养', 'XKW-BIO-45271', '2', 3, '2', '0', 'admin', now(), 'xkw:45271'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-BIO-45265'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-BIO-45271');
