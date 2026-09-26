-- 高中物理知识点树（来源：组卷网 lk_13.json / gzwl）
-- 幂等：按 knowledge_code=XKW-PHYS-{xkwId} 去重
-- 导入：psql -h HOST -p PORT -U USER -d DB -v ON_ERROR_STOP=1 -f sql/spas_phys_xkw_knowledge.sql
-- 或：python3 scripts/import_xkw_phys_knowledge.py

INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
SELECT 'PHYS', '物理', 2, '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'PHYS');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT s.subject_id, 0, '0', '高中物理综合库', 'XKW-PHYS-41934', '0', 1, '2', '0', 'admin', now(), 'xkw:41934'
FROM spas_subject s
WHERE s.subject_code = 'PHYS'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41934');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力学', 'XKW-PHYS-41935', '1', 1, '2', '0', 'admin', now(), 'xkw:41935'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41935');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁学', 'XKW-PHYS-41936', '1', 2, '2', '0', 'admin', now(), 'xkw:41936'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41936');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热学', 'XKW-PHYS-41937', '1', 3, '2', '0', 'admin', now(), 'xkw:41937'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41937');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光学', 'XKW-PHYS-41938', '1', 4, '2', '0', 'admin', now(), 'xkw:41938'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41938');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '近代物理', 'XKW-PHYS-41939', '1', 5, '2', '0', 'admin', now(), 'xkw:41939'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41939');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物理实验', 'XKW-PHYS-174892', '1', 6, '2', '0', 'admin', now(), 'xkw:174892'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174892');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物理学史、方法、单位制、常识', 'XKW-PHYS-41940', '1', 7, '2', '0', 'admin', now(), 'xkw:41940'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41940');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '初中衔接知识点', 'XKW-PHYS-131017', '1', 8, '2', '0', 'admin', now(), 'xkw:131017'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-131017');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '竞赛', 'XKW-PHYS-193', '1', 9, '2', '0', 'admin', now(), 'xkw:193'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41934'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-193');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '运动的描述', 'XKW-PHYS-41941', '1', 1, '2', '0', 'admin', now(), 'xkw:41941'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41941');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀变速直线运动', 'XKW-PHYS-41942', '1', 2, '2', '0', 'admin', now(), 'xkw:41942'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41942');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '相互作用', 'XKW-PHYS-41943', '1', 3, '2', '0', 'admin', now(), 'xkw:41943'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41943');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿运动定律', 'XKW-PHYS-41944', '1', 4, '2', '0', 'admin', now(), 'xkw:41944'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41944');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抛体运动', 'XKW-PHYS-41945', '1', 5, '2', '0', 'admin', now(), 'xkw:41945'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41945');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '圆周运动', 'XKW-PHYS-184063', '1', 6, '2', '0', 'admin', now(), 'xkw:184063'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-184063');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力与宇宙航行', 'XKW-PHYS-41946', '1', 7, '2', '0', 'admin', now(), 'xkw:41946'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41946');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能及其守恒定律', 'XKW-PHYS-41947', '1', 8, '2', '0', 'admin', now(), 'xkw:41947'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41947');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量及其守恒定律', 'XKW-PHYS-41948', '1', 9, '2', '0', 'admin', now(), 'xkw:41948'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41948');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械振动与机械波', 'XKW-PHYS-41949', '1', 10, '2', '0', 'admin', now(), 'xkw:41949'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41935'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41949');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静电场', 'XKW-PHYS-42586', '1', 1, '2', '0', 'admin', now(), 'xkw:42586'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42586');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '恒定电流', 'XKW-PHYS-42587', '1', 2, '2', '0', 'admin', now(), 'xkw:42587'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42587');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁场', 'XKW-PHYS-42588', '1', 3, '2', '0', 'admin', now(), 'xkw:42588'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42588');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁感应', 'XKW-PHYS-42589', '1', 4, '2', '0', 'admin', now(), 'xkw:42589'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42589');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流', 'XKW-PHYS-42590', '1', 5, '2', '0', 'admin', now(), 'xkw:42590'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42590');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁波', 'XKW-PHYS-43239', '1', 6, '2', '0', 'admin', now(), 'xkw:43239'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43239');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传感器', 'XKW-PHYS-42591', '1', 7, '2', '0', 'admin', now(), 'xkw:42591'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41936'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42591');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子动理论', 'XKW-PHYS-43093', '1', 1, '2', '0', 'admin', now(), 'xkw:43093'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41937'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43093');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体、固体和液体', 'XKW-PHYS-43094', '1', 2, '2', '0', 'admin', now(), 'xkw:43094'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41937'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43094');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热力学定律', 'XKW-PHYS-43096', '1', 3, '2', '0', 'admin', now(), 'xkw:43096'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41937'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43096');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的折射', 'XKW-PHYS-43204', '1', 1, '2', '0', 'admin', now(), 'xkw:43204'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43204');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全反射', 'XKW-PHYS-43205', '1', 2, '2', '0', 'admin', now(), 'xkw:43205'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43205');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的干涉', 'XKW-PHYS-43234', '1', 3, '2', '0', 'admin', now(), 'xkw:43234'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43234');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的衍射', 'XKW-PHYS-43235', '1', 4, '2', '0', 'admin', now(), 'xkw:43235'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43235');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的偏振', 'XKW-PHYS-43237', '1', 5, '2', '0', 'admin', now(), 'xkw:43237'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43237');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '激光', 'XKW-PHYS-43238', '2', 6, '2', '0', 'admin', now(), 'xkw:43238'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43238');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波粒二象性', 'XKW-PHYS-43290', '1', 1, '2', '0', 'admin', now(), 'xkw:43290'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43290');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '原子结构', 'XKW-PHYS-43291', '1', 2, '2', '0', 'admin', now(), 'xkw:43291'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43291');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '原子核', 'XKW-PHYS-43292', '1', 3, '2', '0', 'admin', now(), 'xkw:43292'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43292');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物理实验基础', 'XKW-PHYS-42130', '1', 1, '2', '0', 'admin', now(), 'xkw:42130'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42130');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力学实验', 'XKW-PHYS-174893', '1', 2, '2', '0', 'admin', now(), 'xkw:174893'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174893');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电学实验', 'XKW-PHYS-174898', '1', 3, '2', '0', 'admin', now(), 'xkw:174898'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174898');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热学实验', 'XKW-PHYS-174899', '1', 4, '2', '0', 'admin', now(), 'xkw:174899'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174899');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光学实验', 'XKW-PHYS-174900', '1', 5, '2', '0', 'admin', now(), 'xkw:174900'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174900');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '创新实验', 'XKW-PHYS-180666', '1', 6, '2', '0', 'admin', now(), 'xkw:180666'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-180666');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物理学史', 'XKW-PHYS-43435', '2', 1, '2', '0', 'admin', now(), 'xkw:43435'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41940'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43435');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物理方法', 'XKW-PHYS-43436', '1', 2, '2', '0', 'admin', now(), 'xkw:43436'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41940'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43436');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力学', 'XKW-PHYS-131018', '2', 1, '2', '0', 'admin', now(), 'xkw:131018'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-131017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-131018');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁学', 'XKW-PHYS-131019', '2', 2, '2', '0', 'admin', now(), 'xkw:131019'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-131017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-131019');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '声学', 'XKW-PHYS-168919', '2', 3, '2', '0', 'admin', now(), 'xkw:168919'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-131017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168919');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热学', 'XKW-PHYS-131020', '2', 4, '2', '0', 'admin', now(), 'xkw:131020'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-131017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-131020');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光学', 'XKW-PHYS-131021', '2', 5, '2', '0', 'admin', now(), 'xkw:131021'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-131017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-131021');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '科学探索', 'XKW-PHYS-131022', '2', 6, '2', '0', 'admin', now(), 'xkw:131022'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-131017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-131022');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物理学方法', 'XKW-PHYS-131023', '2', 7, '2', '0', 'admin', now(), 'xkw:131023'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-131017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-131023');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力学', 'XKW-PHYS-6411', '1', 1, '2', '0', 'admin', now(), 'xkw:6411'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-193'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6411');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁学', 'XKW-PHYS-6440', '1', 2, '2', '0', 'admin', now(), 'xkw:6440'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-193'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6440');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热学', 'XKW-PHYS-6461', '1', 3, '2', '0', 'admin', now(), 'xkw:6461'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-193'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6461');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光学', 'XKW-PHYS-6467', '1', 4, '2', '0', 'admin', now(), 'xkw:6467'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-193'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6467');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '近代物理', 'XKW-PHYS-6471', '1', 5, '2', '0', 'admin', now(), 'xkw:6471'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-193'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6471');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '狭义相对论', 'XKW-PHYS-6476', '1', 6, '2', '0', 'admin', now(), 'xkw:6476'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-193'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6476');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械运动', 'XKW-PHYS-41956', '2', 1, '2', '0', 'admin', now(), 'xkw:41956'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41956');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '质点', 'XKW-PHYS-41957', '2', 2, '2', '0', 'admin', now(), 'xkw:41957'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41957');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '参考系', 'XKW-PHYS-41958', '1', 3, '2', '0', 'admin', now(), 'xkw:41958'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41958');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时间', 'XKW-PHYS-41962', '2', 4, '2', '0', 'admin', now(), 'xkw:41962'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41962');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '位移', 'XKW-PHYS-208012', '1', 5, '2', '0', 'admin', now(), 'xkw:208012'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208012');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '速度', 'XKW-PHYS-41951', '1', 6, '2', '0', 'admin', now(), 'xkw:41951'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41951');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '加速度', 'XKW-PHYS-41955', '1', 7, '2', '0', 'admin', now(), 'xkw:41955'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41941'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41955');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀变速直线运动的特点', 'XKW-PHYS-208013', '2', 1, '2', '0', 'admin', now(), 'xkw:208013'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208013');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀变速直线运动速度与时间的关系', 'XKW-PHYS-41999', '2', 2, '2', '0', 'admin', now(), 'xkw:41999'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41999');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀变速直线运动位移与时间的关系', 'XKW-PHYS-42001', '2', 3, '2', '0', 'admin', now(), 'xkw:42001'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42001');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀变速直线运动速度与位移的关系', 'XKW-PHYS-42003', '2', 4, '2', '0', 'admin', now(), 'xkw:42003'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42003');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀变速直线运动推论', 'XKW-PHYS-41995', '1', 5, '2', '0', 'admin', now(), 'xkw:41995'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41995');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自由落体运动', 'XKW-PHYS-42023', '1', 6, '2', '0', 'admin', now(), 'xkw:42023'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42023');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '竖直上抛运动', 'XKW-PHYS-42025', '1', 7, '2', '0', 'admin', now(), 'xkw:42025'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42025');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '运动图像', 'XKW-PHYS-208014', '1', 8, '2', '0', 'admin', now(), 'xkw:208014'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208014');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '追及与相遇问题', 'XKW-PHYS-42026', '1', 9, '2', '0', 'admin', now(), 'xkw:42026'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42026');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刹车问题', 'XKW-PHYS-42027', '1', 10, '2', '0', 'admin', now(), 'xkw:42027'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42027');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '直线运动多过程问题', 'XKW-PHYS-42028', '2', 11, '2', '0', 'admin', now(), 'xkw:42028'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42028');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力', 'XKW-PHYS-42054', '1', 1, '2', '0', 'admin', now(), 'xkw:42054'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41943'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42054');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重力', 'XKW-PHYS-42055', '1', 2, '2', '0', 'admin', now(), 'xkw:42055'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41943'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42055');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹力', 'XKW-PHYS-42056', '1', 3, '2', '0', 'admin', now(), 'xkw:42056'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41943'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42056');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '摩擦力', 'XKW-PHYS-42057', '1', 4, '2', '0', 'admin', now(), 'xkw:42057'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41943'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42057');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力的合成', 'XKW-PHYS-42094', '1', 5, '2', '0', 'admin', now(), 'xkw:42094'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41943'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42094');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力的分解', 'XKW-PHYS-42095', '1', 6, '2', '0', 'admin', now(), 'xkw:42095'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41943'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42095');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '共点力的平衡', 'XKW-PHYS-42059', '1', 7, '2', '0', 'admin', now(), 'xkw:42059'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41943'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42059');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿第一定律', 'XKW-PHYS-42126', '1', 1, '2', '0', 'admin', now(), 'xkw:42126'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41944'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42126');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿第二定律', 'XKW-PHYS-42127', '1', 2, '2', '0', 'admin', now(), 'xkw:42127'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41944'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42127');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿第三定律', 'XKW-PHYS-42128', '2', 3, '2', '0', 'admin', now(), 'xkw:42128'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41944'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42128');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力学单位制', 'XKW-PHYS-42131', '1', 4, '2', '0', 'admin', now(), 'xkw:42131'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41944'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42131');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '超重与失重', 'XKW-PHYS-42157', '1', 5, '2', '0', 'admin', now(), 'xkw:42157'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41944'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42157');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿运动定律的应用', 'XKW-PHYS-42129', '1', 6, '2', '0', 'admin', now(), 'xkw:42129'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41944'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42129');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曲线运动的认识', 'XKW-PHYS-42200', '1', 1, '2', '0', 'admin', now(), 'xkw:42200'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41945'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42200');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '运动的合成与分解', 'XKW-PHYS-42201', '1', 2, '2', '0', 'admin', now(), 'xkw:42201'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41945'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42201');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛运动', 'XKW-PHYS-153289', '1', 3, '2', '0', 'admin', now(), 'xkw:153289'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41945'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153289');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '斜抛运动', 'XKW-PHYS-42236', '2', 4, '2', '0', 'admin', now(), 'xkw:42236'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41945'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42236');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '圆周运动的描述', 'XKW-PHYS-42203', '1', 1, '2', '0', 'admin', now(), 'xkw:42203'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-184063'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42203');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '向心力', 'XKW-PHYS-42258', '1', 2, '2', '0', 'admin', now(), 'xkw:42258'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-184063'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42258');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '向心加速度', 'XKW-PHYS-42257', '1', 3, '2', '0', 'admin', now(), 'xkw:42257'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-184063'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42257');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '水平面内的圆周运动', 'XKW-PHYS-42277', '1', 4, '2', '0', 'admin', now(), 'xkw:42277'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-184063'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42277');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '竖直平面内的圆周运动', 'XKW-PHYS-42276', '1', 5, '2', '0', 'admin', now(), 'xkw:42276'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-184063'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42276');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '离心运动', 'XKW-PHYS-42278', '2', 6, '2', '0', 'admin', now(), 'xkw:42278'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-184063'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42278');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '行星的运动', 'XKW-PHYS-42292', '1', 1, '2', '0', 'admin', now(), 'xkw:42292'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41946'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42292');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力定律', 'XKW-PHYS-42293', '1', 2, '2', '0', 'admin', now(), 'xkw:42293'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41946'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42293');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力定律的应用', 'XKW-PHYS-42294', '1', 3, '2', '0', 'admin', now(), 'xkw:42294'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41946'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42294');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿力学局限性与相对论初步', 'XKW-PHYS-208019', '1', 4, '2', '0', 'admin', now(), 'xkw:208019'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41946'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208019');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功', 'XKW-PHYS-42337', '1', 1, '2', '0', 'admin', now(), 'xkw:42337'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42337');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功率', 'XKW-PHYS-42338', '1', 2, '2', '0', 'admin', now(), 'xkw:42338'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42338');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动能和动能定理', 'XKW-PHYS-42339', '1', 3, '2', '0', 'admin', now(), 'xkw:42339'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42339');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '势能', 'XKW-PHYS-42340', '1', 4, '2', '0', 'admin', now(), 'xkw:42340'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42340');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律', 'XKW-PHYS-42341', '1', 5, '2', '0', 'admin', now(), 'xkw:42341'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42341');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功能关系', 'XKW-PHYS-42403', '1', 6, '2', '0', 'admin', now(), 'xkw:42403'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42403');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量守恒定律', 'XKW-PHYS-208020', '1', 7, '2', '0', 'admin', now(), 'xkw:208020'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41947'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208020');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量', 'XKW-PHYS-42432', '1', 1, '2', '0', 'admin', now(), 'xkw:42432'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41948'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42432');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冲量', 'XKW-PHYS-42431', '1', 2, '2', '0', 'admin', now(), 'xkw:42431'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41948'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42431');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量定理', 'XKW-PHYS-42433', '1', 3, '2', '0', 'admin', now(), 'xkw:42433'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41948'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42433');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量守恒定律', 'XKW-PHYS-42446', '1', 4, '2', '0', 'admin', now(), 'xkw:42446'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41948'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42446');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量守恒定律的应用', 'XKW-PHYS-42430', '1', 5, '2', '0', 'admin', now(), 'xkw:42430'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41948'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42430');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械振动', 'XKW-PHYS-42492', '1', 1, '2', '0', 'admin', now(), 'xkw:42492'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41949'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42492');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械波', 'XKW-PHYS-42493', '1', 2, '2', '0', 'admin', now(), 'xkw:42493'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41949'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42493');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电荷和静电现象', 'XKW-PHYS-208023', '1', 1, '2', '0', 'admin', now(), 'xkw:208023'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42586'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208023');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '库仑定律', 'XKW-PHYS-42600', '1', 2, '2', '0', 'admin', now(), 'xkw:42600'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42586'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42600');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场力的性质', 'XKW-PHYS-42593', '1', 3, '2', '0', 'admin', now(), 'xkw:42593'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42586'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42593');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场能的性质', 'XKW-PHYS-42594', '1', 4, '2', '0', 'admin', now(), 'xkw:42594'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42586'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42594');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器与电容', 'XKW-PHYS-42596', '1', 5, '2', '0', 'admin', now(), 'xkw:42596'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42586'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42596');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在电场中的运动', 'XKW-PHYS-42597', '1', 6, '2', '0', 'admin', now(), 'xkw:42597'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42586'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42597');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流', 'XKW-PHYS-42727', '1', 1, '2', '0', 'admin', now(), 'xkw:42727'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42727');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电阻', 'XKW-PHYS-42730', '1', 2, '2', '0', 'admin', now(), 'xkw:42730'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42730');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '串联电路和并联电路', 'XKW-PHYS-42728', '1', 3, '2', '0', 'admin', now(), 'xkw:42728'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42728');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电功和电功率', 'XKW-PHYS-42766', '1', 4, '2', '0', 'admin', now(), 'xkw:42766'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42766');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '焦耳定律', 'XKW-PHYS-42767', '1', 5, '2', '0', 'admin', now(), 'xkw:42767'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42767');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非纯电阻电路', 'XKW-PHYS-42768', '1', 6, '2', '0', 'admin', now(), 'xkw:42768'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42768');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电动势', 'XKW-PHYS-42734', '1', 7, '2', '0', 'admin', now(), 'xkw:42734'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42734');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '闭合电路的欧姆定律', 'XKW-PHYS-42799', '1', 8, '2', '0', 'admin', now(), 'xkw:42799'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42799');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多用电表', 'XKW-PHYS-208025', '2', 9, '2', '0', 'admin', now(), 'xkw:208025'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208025');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动态电路分析', 'XKW-PHYS-42800', '1', 10, '2', '0', 'admin', now(), 'xkw:42800'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42800');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '故障电路分析', 'XKW-PHYS-42801', '1', 11, '2', '0', 'admin', now(), 'xkw:42801'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42801');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含容电路分析', 'XKW-PHYS-42802', '1', 12, '2', '0', 'admin', now(), 'xkw:42802'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42802');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '黑箱问题', 'XKW-PHYS-42805', '2', 13, '2', '0', 'admin', now(), 'xkw:42805'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42805');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '家庭电路与安全用电', 'XKW-PHYS-208026', '2', 14, '2', '0', 'admin', now(), 'xkw:208026'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208026');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '简单逻辑电路', 'XKW-PHYS-42732', '2', 15, '2', '0', 'admin', now(), 'xkw:42732'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42587'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42732');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁现象和磁场', 'XKW-PHYS-42842', '1', 1, '2', '0', 'admin', now(), 'xkw:42842'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42588'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42842');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '安培力', 'XKW-PHYS-42843', '1', 2, '2', '0', 'admin', now(), 'xkw:42843'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42588'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42843');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '洛伦兹力', 'XKW-PHYS-42844', '1', 3, '2', '0', 'admin', now(), 'xkw:42844'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42588'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42844');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在磁场中的运动', 'XKW-PHYS-42845', '1', 4, '2', '0', 'admin', now(), 'xkw:42845'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42588'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42845');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在复合场中的运动', 'XKW-PHYS-42846', '1', 5, '2', '0', 'admin', now(), 'xkw:42846'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42588'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42846');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁感应现象', 'XKW-PHYS-42938', '1', 1, '2', '0', 'admin', now(), 'xkw:42938'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42589'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42938');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '感应电流方向的判断', 'XKW-PHYS-42939', '1', 2, '2', '0', 'admin', now(), 'xkw:42939'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42589'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42939');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '法拉第电磁感应定律', 'XKW-PHYS-42940', '1', 3, '2', '0', 'admin', now(), 'xkw:42940'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42589'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42940');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '法拉第电磁感应定律的应用', 'XKW-PHYS-208028', '1', 4, '2', '0', 'admin', now(), 'xkw:208028'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42589'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208028');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自感和涡流', 'XKW-PHYS-42942', '1', 5, '2', '0', 'admin', now(), 'xkw:42942'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42589'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42942');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流的概念', 'XKW-PHYS-43011', '2', 1, '2', '0', 'admin', now(), 'xkw:43011'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42590'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43011');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流的产生', 'XKW-PHYS-43016', '1', 2, '2', '0', 'admin', now(), 'xkw:43016'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42590'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43016');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '描述交变电流的物理量', 'XKW-PHYS-43012', '1', 3, '2', '0', 'admin', now(), 'xkw:43012'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42590'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43012');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电感和电容对交变电流的影响', 'XKW-PHYS-43013', '1', 4, '2', '0', 'admin', now(), 'xkw:43013'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42590'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43013');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变压器', 'XKW-PHYS-43014', '1', 5, '2', '0', 'admin', now(), 'xkw:43014'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42590'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43014');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '远距离输电', 'XKW-PHYS-43062', '1', 6, '2', '0', 'admin', now(), 'xkw:43062'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42590'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43062');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁波的产生与应用', 'XKW-PHYS-43275', '1', 1, '2', '0', 'admin', now(), 'xkw:43275'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43239'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43275');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁波谱', 'XKW-PHYS-43276', '1', 2, '2', '0', 'admin', now(), 'xkw:43276'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43239'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43276');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传感器及其元件', 'XKW-PHYS-43080', '1', 1, '2', '0', 'admin', now(), 'xkw:43080'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42591'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43080');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传感器的应用', 'XKW-PHYS-43081', '1', 2, '2', '0', 'admin', now(), 'xkw:43081'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42591'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43081');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物体是由大量分子组成的', 'XKW-PHYS-43098', '1', 1, '2', '0', 'admin', now(), 'xkw:43098'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43093'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43098');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子热运动', 'XKW-PHYS-43104', '1', 2, '2', '0', 'admin', now(), 'xkw:43104'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43093'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43104');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子运动速率分布规律', 'XKW-PHYS-208031', '1', 3, '2', '0', 'admin', now(), 'xkw:208031'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43093'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208031');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子间的相互作用力', 'XKW-PHYS-43105', '1', 4, '2', '0', 'admin', now(), 'xkw:43105'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43093'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43105');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物体的内能', 'XKW-PHYS-208032', '1', 5, '2', '0', 'admin', now(), 'xkw:208032'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43093'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208032');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '温度和温标', 'XKW-PHYS-43107', '1', 1, '2', '0', 'admin', now(), 'xkw:43107'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43107');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体', 'XKW-PHYS-194030', '1', 2, '2', '0', 'admin', now(), 'xkw:194030'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-194030');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '固体', 'XKW-PHYS-43160', '1', 3, '2', '0', 'admin', now(), 'xkw:43160'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43160');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '液体', 'XKW-PHYS-43161', '1', 4, '2', '0', 'admin', now(), 'xkw:43161'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43161');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '饱和汽和饱和汽压', 'XKW-PHYS-43173', '2', 5, '2', '0', 'admin', now(), 'xkw:43173'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43173');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物态变化中的能量转化', 'XKW-PHYS-43175', '2', 6, '2', '0', 'admin', now(), 'xkw:43175'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43175');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功、热和内能的改变', 'XKW-PHYS-43140', '2', 1, '2', '0', 'admin', now(), 'xkw:43140'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43096'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43140');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热力学第一定律', 'XKW-PHYS-43177', '1', 2, '2', '0', 'admin', now(), 'xkw:43177'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43096'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43177');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量守恒定律（热学背景）', 'XKW-PHYS-43178', '1', 3, '2', '0', 'admin', now(), 'xkw:43178'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43096'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43178');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热力学第二定律', 'XKW-PHYS-43179', '1', 4, '2', '0', 'admin', now(), 'xkw:43179'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43096'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43179');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热力学第三定律', 'XKW-PHYS-43180', '1', 5, '2', '0', 'admin', now(), 'xkw:43180'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43096'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43180');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能源与可持续发展', 'XKW-PHYS-43181', '1', 6, '2', '0', 'admin', now(), 'xkw:43181'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43096'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43181');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的折射现象', 'XKW-PHYS-43214', '2', 1, '2', '0', 'admin', now(), 'xkw:43214'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43204'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43214');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的折射定律', 'XKW-PHYS-43212', '2', 2, '2', '0', 'admin', now(), 'xkw:43212'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43204'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43212');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '折射率', 'XKW-PHYS-208033', '1', 3, '2', '0', 'admin', now(), 'xkw:208033'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43204'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208033');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全反射现象', 'XKW-PHYS-43222', '2', 1, '2', '0', 'admin', now(), 'xkw:43222'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43205'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43222');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全反射的条件', 'XKW-PHYS-43223', '1', 2, '2', '0', 'admin', now(), 'xkw:43223'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43205'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43223');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全反射的应用', 'XKW-PHYS-43224', '1', 3, '2', '0', 'admin', now(), 'xkw:43224'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43205'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43224');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '折射和全反射的综合问题', 'XKW-PHYS-43230', '1', 4, '2', '0', 'admin', now(), 'xkw:43230'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43205'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43230');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '双缝干涉', 'XKW-PHYS-43240', '1', 1, '2', '0', 'admin', now(), 'xkw:43240'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43234'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43240');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '干涉条纹间距与波长的关系', 'XKW-PHYS-230343', '1', 2, '2', '0', 'admin', now(), 'xkw:230343'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43234'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230343');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '薄膜干涉', 'XKW-PHYS-43242', '1', 3, '2', '0', 'admin', now(), 'xkw:43242'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43234'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43242');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '衍射现象', 'XKW-PHYS-43256', '1', 1, '2', '0', 'admin', now(), 'xkw:43256'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43235'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43256');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '衍射条件', 'XKW-PHYS-43257', '2', 2, '2', '0', 'admin', now(), 'xkw:43257'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43235'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43257');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '偏振现象及其解释', 'XKW-PHYS-43271', '2', 1, '2', '0', 'admin', now(), 'xkw:43271'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43237'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43271');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '偏振的应用', 'XKW-PHYS-43272', '2', 2, '2', '0', 'admin', now(), 'xkw:43272'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43237'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43272');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量的量子化', 'XKW-PHYS-43294', '1', 1, '2', '0', 'admin', now(), 'xkw:43294'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43290'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43294');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光电效应', 'XKW-PHYS-43295', '1', 2, '2', '0', 'admin', now(), 'xkw:43295'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43290'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43295');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '康普顿效应', 'XKW-PHYS-43296', '1', 3, '2', '0', 'admin', now(), 'xkw:43296'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43290'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43296');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的波粒二象性', 'XKW-PHYS-43325', '2', 4, '2', '0', 'admin', now(), 'xkw:43325'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43290'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43325');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '实物粒子的波粒二象性', 'XKW-PHYS-43297', '1', 5, '2', '0', 'admin', now(), 'xkw:43297'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43290'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43297');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电子的发现', 'XKW-PHYS-43334', '1', 1, '2', '0', 'admin', now(), 'xkw:43334'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43291'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43334');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核式结构模型', 'XKW-PHYS-43335', '1', 2, '2', '0', 'admin', now(), 'xkw:43335'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43291'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43335');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '玻尔的原子模型', 'XKW-PHYS-43336', '1', 3, '2', '0', 'admin', now(), 'xkw:43336'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43291'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43336');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '原子核的组成', 'XKW-PHYS-43362', '2', 1, '2', '0', 'admin', now(), 'xkw:43362'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43292'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43362');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '放射性元素衰变', 'XKW-PHYS-43363', '1', 2, '2', '0', 'admin', now(), 'xkw:43363'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43292'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43363');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核力与结合能', 'XKW-PHYS-43364', '1', 3, '2', '0', 'admin', now(), 'xkw:43364'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43292'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43364');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核能', 'XKW-PHYS-43365', '1', 4, '2', '0', 'admin', now(), 'xkw:43365'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43292'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43365');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基本粒子', 'XKW-PHYS-43416', '2', 5, '2', '0', 'admin', now(), 'xkw:43416'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43292'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43416');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '常用仪器的使用与读数', 'XKW-PHYS-42185', '1', 1, '2', '0', 'admin', now(), 'xkw:42185'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42130'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42185');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '误差和有效数字', 'XKW-PHYS-42186', '2', 2, '2', '0', 'admin', now(), 'xkw:42186'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42130'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42186');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测量做直线运动物体的瞬时速度', 'XKW-PHYS-41952', '1', 1, '2', '0', 'admin', now(), 'xkw:41952'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41952');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测定匀变速直线运动的加速度', 'XKW-PHYS-41996', '1', 2, '2', '0', 'admin', now(), 'xkw:41996'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41996');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究弹簧弹力与形变量的关系', 'XKW-PHYS-42072', '2', 3, '2', '0', 'admin', now(), 'xkw:42072'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42072');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测量动摩擦因数', 'XKW-PHYS-153422', '1', 4, '2', '0', 'admin', now(), 'xkw:153422'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153422');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究两个互成角度的力的合成规律', 'XKW-PHYS-42096', '1', 5, '2', '0', 'admin', now(), 'xkw:42096'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42096');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究加速度与物体受力、物体质量的关系', 'XKW-PHYS-42140', '1', 6, '2', '0', 'admin', now(), 'xkw:42140'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42140');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究平抛运动的特点', 'XKW-PHYS-42233', '1', 7, '2', '0', 'admin', now(), 'xkw:42233'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42233');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究向心力大小与半径、角速度、质量的关系', 'XKW-PHYS-42275', '1', 8, '2', '0', 'admin', now(), 'xkw:42275'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42275');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究动能定理', 'XKW-PHYS-42375', '1', 9, '2', '0', 'admin', now(), 'xkw:42375'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42375');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '验证机械能守恒定律', 'XKW-PHYS-42422', '2', 10, '2', '0', 'admin', now(), 'xkw:42422'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42422');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '验证动量守恒定律', 'XKW-PHYS-42447', '1', 11, '2', '0', 'admin', now(), 'xkw:42447'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42447');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用单摆测量重力加速度的大小', 'XKW-PHYS-42525', '2', 12, '2', '0', 'admin', now(), 'xkw:42525'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42525');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '描绘小灯泡的伏安特性曲线', 'XKW-PHYS-42754', '2', 1, '2', '0', 'admin', now(), 'xkw:42754'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42754');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测量未知电阻', 'XKW-PHYS-230403', '1', 2, '2', '0', 'admin', now(), 'xkw:230403'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230403');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测量电阻丝的电阻率', 'XKW-PHYS-42789', '2', 3, '2', '0', 'admin', now(), 'xkw:42789'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42789');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测量电源的电动势和内阻', 'XKW-PHYS-42803', '1', 4, '2', '0', 'admin', now(), 'xkw:42803'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42803');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用多用电表测量电学中的物理量', 'XKW-PHYS-42833', '2', 5, '2', '0', 'admin', now(), 'xkw:42833'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42833');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '观察电容器充、放电现象', 'XKW-PHYS-181284', '2', 6, '2', '0', 'admin', now(), 'xkw:181284'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-181284');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究影响感应电流方向的因素', 'XKW-PHYS-181285', '2', 7, '2', '0', 'admin', now(), 'xkw:181285'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-181285');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究变压器原、副线圈电压与匝数的关系', 'XKW-PHYS-181286', '2', 8, '2', '0', 'admin', now(), 'xkw:181286'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-181286');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用传感器制作简单的自动控制装置', 'XKW-PHYS-43082', '2', 9, '2', '0', 'admin', now(), 'xkw:43082'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174898'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43082');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用油膜法估测油酸分子的大小', 'XKW-PHYS-43116', '2', 1, '2', '0', 'admin', now(), 'xkw:43116'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43116');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究等温情况下一定质量气体压强与体积的关系', 'XKW-PHYS-181287', '2', 2, '2', '0', 'admin', now(), 'xkw:181287'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174899'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-181287');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测量玻璃的折射率', 'XKW-PHYS-43213', '1', 1, '2', '0', 'admin', now(), 'xkw:43213'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174900'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43213');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用双缝干涉实验测量光的波长', 'XKW-PHYS-43251', '2', 2, '2', '0', 'admin', now(), 'xkw:43251'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-174900'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43251');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力学创新实验', 'XKW-PHYS-180667', '2', 1, '2', '0', 'admin', now(), 'xkw:180667'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-180666'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-180667');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电学创新实验', 'XKW-PHYS-180668', '2', 2, '2', '0', 'admin', now(), 'xkw:180668'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-180666'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-180668');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热学创新实验', 'XKW-PHYS-180669', '2', 3, '2', '0', 'admin', now(), 'xkw:180669'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-180666'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-180669');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光学创新实验', 'XKW-PHYS-180670', '2', 4, '2', '0', 'admin', now(), 'xkw:180670'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-180666'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-180670');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '整体隔离法', 'XKW-PHYS-43440', '2', 1, '2', '0', 'admin', now(), 'xkw:43440'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43440');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '控制变量法', 'XKW-PHYS-43441', '2', 2, '2', '0', 'admin', now(), 'xkw:43441'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43441');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '假设法', 'XKW-PHYS-43442', '2', 3, '2', '0', 'admin', now(), 'xkw:43442'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43442');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等效法', 'XKW-PHYS-43443', '2', 4, '2', '0', 'admin', now(), 'xkw:43443'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43443');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '图像法', 'XKW-PHYS-43444', '2', 5, '2', '0', 'admin', now(), 'xkw:43444'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43444');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '极限法', 'XKW-PHYS-43445', '2', 6, '2', '0', 'admin', now(), 'xkw:43445'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43445');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '估算法', 'XKW-PHYS-43446', '2', 7, '2', '0', 'admin', now(), 'xkw:43446'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43446');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微元法', 'XKW-PHYS-43447', '2', 8, '2', '0', 'admin', now(), 'xkw:43447'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43447');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理想模型法', 'XKW-PHYS-168738', '2', 9, '2', '0', 'admin', now(), 'xkw:168738'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168738');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '放大法', 'XKW-PHYS-168739', '2', 10, '2', '0', 'admin', now(), 'xkw:168739'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168739');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '转换法', 'XKW-PHYS-168741', '2', 11, '2', '0', 'admin', now(), 'xkw:168741'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168741');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '比值定义法', 'XKW-PHYS-168742', '2', 12, '2', '0', 'admin', now(), 'xkw:168742'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168742');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '逆向思维法', 'XKW-PHYS-168743', '2', 13, '2', '0', 'admin', now(), 'xkw:168743'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168743');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '类比法', 'XKW-PHYS-168744', '2', 14, '2', '0', 'admin', now(), 'xkw:168744'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168744');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '归纳法', 'XKW-PHYS-168745', '2', 15, '2', '0', 'admin', now(), 'xkw:168745'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43436'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168745');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物体的运动', 'XKW-PHYS-6412', '1', 1, '2', '0', 'admin', now(), 'xkw:6412'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6411'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6412');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物体的平衡', 'XKW-PHYS-6417', '1', 2, '2', '0', 'admin', now(), 'xkw:6417'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6411'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6417');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '运动定律', 'XKW-PHYS-6424', '1', 3, '2', '0', 'admin', now(), 'xkw:6424'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6411'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6424');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量与动量', 'XKW-PHYS-6427', '1', 4, '2', '0', 'admin', now(), 'xkw:6427'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6411'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6427');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '角动量与天体运动', 'XKW-PHYS-6433', '1', 5, '2', '0', 'admin', now(), 'xkw:6433'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6411'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6433');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '振动与波动', 'XKW-PHYS-6437', '1', 6, '2', '0', 'admin', now(), 'xkw:6437'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6411'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6437');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场', 'XKW-PHYS-6441', '1', 1, '2', '0', 'admin', now(), 'xkw:6441'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6440'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6441');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电路', 'XKW-PHYS-6446', '1', 2, '2', '0', 'admin', now(), 'xkw:6446'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6440'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6446');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁场', 'XKW-PHYS-6452', '1', 3, '2', '0', 'admin', now(), 'xkw:6452'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6440'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6452');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁感应与交流电', 'XKW-PHYS-6457', '1', 4, '2', '0', 'admin', now(), 'xkw:6457'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6440'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6457');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体的性质', 'XKW-PHYS-6462', '2', 1, '2', '0', 'admin', now(), 'xkw:6462'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6461'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6462');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子动理论', 'XKW-PHYS-6463', '2', 2, '2', '0', 'admin', now(), 'xkw:6463'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6461'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6463');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '固体、液体的性质', 'XKW-PHYS-6464', '2', 3, '2', '0', 'admin', now(), 'xkw:6464'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6461'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6464');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '相变热传递', 'XKW-PHYS-6465', '2', 4, '2', '0', 'admin', now(), 'xkw:6465'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6461'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6465');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热力学定律', 'XKW-PHYS-6466', '2', 5, '2', '0', 'admin', now(), 'xkw:6466'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6461'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6466');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的反射与折射', 'XKW-PHYS-6468', '2', 1, '2', '0', 'admin', now(), 'xkw:6468'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6467'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6468');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '透镜成像与常用光学仪器', 'XKW-PHYS-6469', '2', 2, '2', '0', 'admin', now(), 'xkw:6469'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6467'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6469');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的波动性', 'XKW-PHYS-6470', '2', 3, '2', '0', 'admin', now(), 'xkw:6470'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6467'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6470');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光的粒子性', 'XKW-PHYS-6472', '2', 1, '2', '0', 'admin', now(), 'xkw:6472'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6471'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6472');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '原子结构', 'XKW-PHYS-6473', '2', 2, '2', '0', 'admin', now(), 'xkw:6473'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6471'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6473');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '原子核', 'XKW-PHYS-6474', '2', 3, '2', '0', 'admin', now(), 'xkw:6474'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6471'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6474');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '粒子', 'XKW-PHYS-6475', '2', 4, '2', '0', 'admin', now(), 'xkw:6475'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6471'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6475');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基本原理与洛伦兹变换', 'XKW-PHYS-6477', '2', 1, '2', '0', 'admin', now(), 'xkw:6477'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6476'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6477');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '相对论的运动学效应', 'XKW-PHYS-6478', '2', 2, '2', '0', 'admin', now(), 'xkw:6478'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6476'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6478');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '相对论动力学', 'XKW-PHYS-6479', '2', 3, '2', '0', 'admin', now(), 'xkw:6479'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6476'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6479');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '已知物体运动情况判断参考系', 'XKW-PHYS-41965', '2', 1, '2', '0', 'admin', now(), 'xkw:41965'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41965');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '已知参考系判断物体运动情况', 'XKW-PHYS-41966', '2', 2, '2', '0', 'admin', now(), 'xkw:41966'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41966');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同一运动在不同参考系中的描述', 'XKW-PHYS-149427', '2', 3, '2', '0', 'admin', now(), 'xkw:149427'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-149427');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '坐标系', 'XKW-PHYS-41959', '2', 1, '2', '0', 'admin', now(), 'xkw:41959'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41959');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '标量与矢量', 'XKW-PHYS-41960', '2', 2, '2', '0', 'admin', now(), 'xkw:41960'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41960');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '路程与位移', 'XKW-PHYS-41961', '1', 3, '2', '0', 'admin', now(), 'xkw:41961'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41961');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '速率与速度', 'XKW-PHYS-41976', '2', 1, '2', '0', 'admin', now(), 'xkw:41976'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41951'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41976');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平均速率', 'XKW-PHYS-230193', '2', 2, '2', '0', 'admin', now(), 'xkw:230193'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41951'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230193');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平均速度', 'XKW-PHYS-41982', '2', 3, '2', '0', 'admin', now(), 'xkw:41982'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41951'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41982');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '瞬时速度', 'XKW-PHYS-41983', '2', 4, '2', '0', 'admin', now(), 'xkw:41983'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41951'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41983');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '加速度的定义', 'XKW-PHYS-41989', '2', 1, '2', '0', 'admin', now(), 'xkw:41989'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41989');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '速度、速度变化量和加速度的区别', 'XKW-PHYS-41990', '2', 2, '2', '0', 'admin', now(), 'xkw:41990'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41990');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '加速度的方向与速度变化的关系', 'XKW-PHYS-41992', '2', 3, '2', '0', 'admin', now(), 'xkw:41992'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41992');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '加速度的计算', 'XKW-PHYS-41991', '2', 4, '2', '0', 'admin', now(), 'xkw:41991'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41991');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀变速直线运动的位移差Δx=aT²', 'XKW-PHYS-148954', '2', 1, '2', '0', 'admin', now(), 'xkw:148954'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41995'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-148954');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中间时刻的瞬时速度', 'XKW-PHYS-42018', '2', 2, '2', '0', 'admin', now(), 'xkw:42018'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41995'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42018');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中间位置的瞬时速度', 'XKW-PHYS-42021', '2', 3, '2', '0', 'admin', now(), 'xkw:42021'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41995'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42021');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '初速度为零的匀变速直线运动的规律', 'XKW-PHYS-42022', '1', 4, '2', '0', 'admin', now(), 'xkw:42022'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41995'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42022');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '伽利略对落体运动的研究', 'XKW-PHYS-42024', '2', 1, '2', '0', 'admin', now(), 'xkw:42024'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42024');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自由落体运动的特征', 'XKW-PHYS-42032', '2', 2, '2', '0', 'admin', now(), 'xkw:42032'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42032');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重力加速度', 'XKW-PHYS-42033', '2', 3, '2', '0', 'admin', now(), 'xkw:42033'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42033');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自由落体运动的规律及应用', 'XKW-PHYS-42034', '2', 4, '2', '0', 'admin', now(), 'xkw:42034'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42034');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自由落体运动的图像', 'XKW-PHYS-42035', '2', 5, '2', '0', 'admin', now(), 'xkw:42035'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42035');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '频闪照相法求解自由落体运动', 'XKW-PHYS-42038', '2', 6, '2', '0', 'admin', now(), 'xkw:42038'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42038');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '竖直上抛运动的规律及应用', 'XKW-PHYS-42039', '2', 1, '2', '0', 'admin', now(), 'xkw:42039'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42025'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42039');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '竖直上抛运动的图像', 'XKW-PHYS-42040', '2', 2, '2', '0', 'admin', now(), 'xkw:42040'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42025'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42040');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自由落体和竖直上抛相遇类问题', 'XKW-PHYS-42042', '2', 3, '2', '0', 'admin', now(), 'xkw:42042'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42025'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42042');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'v-t图像', 'XKW-PHYS-42000', '1', 1, '2', '0', 'admin', now(), 'xkw:42000'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42000');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'x-t图像', 'XKW-PHYS-42004', '2', 2, '2', '0', 'admin', now(), 'xkw:42004'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42004');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'a-t图像', 'XKW-PHYS-42005', '2', 3, '2', '0', 'admin', now(), 'xkw:42005'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42005');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非常规图像', 'XKW-PHYS-208015', '2', 4, '2', '0', 'admin', now(), 'xkw:208015'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208015');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用图像解决非匀变速直线运动', 'XKW-PHYS-230194', '1', 5, '2', '0', 'admin', now(), 'xkw:230194'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230194');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变速物体追匀速物体', 'XKW-PHYS-42043', '2', 1, '2', '0', 'admin', now(), 'xkw:42043'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42043');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变速物体追变速物体', 'XKW-PHYS-42044', '2', 2, '2', '0', 'admin', now(), 'xkw:42044'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42044');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀速物体追变速物体', 'XKW-PHYS-153415', '2', 3, '2', '0', 'admin', now(), 'xkw:153415'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153415');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '避免相撞类问题', 'XKW-PHYS-42045', '2', 4, '2', '0', 'admin', now(), 'xkw:42045'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42045');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '相遇次数问题', 'XKW-PHYS-42048', '2', 5, '2', '0', 'admin', now(), 'xkw:42048'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42048');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算停车时间和位移', 'XKW-PHYS-42050', '2', 1, '2', '0', 'admin', now(), 'xkw:42050'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42027'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42050');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '逆向思维求解匀变速直线运动', 'XKW-PHYS-153416', '2', 2, '2', '0', 'admin', now(), 'xkw:153416'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42027'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153416');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力的概念', 'XKW-PHYS-42060', '2', 1, '2', '0', 'admin', now(), 'xkw:42060'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42054'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42060');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力的图示及示意图', 'XKW-PHYS-230195', '2', 2, '2', '0', 'admin', now(), 'xkw:230195'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42054'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230195');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重力的概念、大小和方向', 'XKW-PHYS-42066', '2', 1, '2', '0', 'admin', now(), 'xkw:42066'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42055'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42066');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重心', 'XKW-PHYS-42068', '2', 2, '2', '0', 'admin', now(), 'xkw:42068'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42055'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42068');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹力定义及产生条件', 'XKW-PHYS-153417', '2', 1, '2', '0', 'admin', now(), 'xkw:153417'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153417');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断是否存在弹力', 'XKW-PHYS-42074', '2', 2, '2', '0', 'admin', now(), 'xkw:42074'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42074');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹力的大小和方向', 'XKW-PHYS-42075', '2', 3, '2', '0', 'admin', now(), 'xkw:42075'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42075');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '胡克定律', 'XKW-PHYS-42077', '2', 4, '2', '0', 'admin', now(), 'xkw:42077'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42077');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹簧劲度系数', 'XKW-PHYS-42078', '2', 5, '2', '0', 'admin', now(), 'xkw:42078'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42078');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹簧的串联与并联', 'XKW-PHYS-42079', '2', 6, '2', '0', 'admin', now(), 'xkw:42079'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42079');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹簧F-x图像问题', 'XKW-PHYS-42081', '2', 7, '2', '0', 'admin', now(), 'xkw:42081'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42081');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹簧弹力作用下的多解问题', 'XKW-PHYS-153418', '2', 8, '2', '0', 'admin', now(), 'xkw:153418'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153418');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '放大法观察微小形变', 'XKW-PHYS-153419', '2', 9, '2', '0', 'admin', now(), 'xkw:153419'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42056'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153419');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静摩擦力', 'XKW-PHYS-42084', '1', 1, '2', '0', 'admin', now(), 'xkw:42084'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42057'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42084');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '滑动摩擦力', 'XKW-PHYS-42085', '1', 2, '2', '0', 'admin', now(), 'xkw:42085'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42057'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42085');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '合力与分力的定义及关系', 'XKW-PHYS-42097', '2', 1, '2', '0', 'admin', now(), 'xkw:42097'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42097');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力的平行四边形定则及应用', 'XKW-PHYS-42098', '2', 2, '2', '0', 'admin', now(), 'xkw:42098'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42098');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '合力的取值范围', 'XKW-PHYS-42099', '2', 3, '2', '0', 'admin', now(), 'xkw:42099'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42099');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等大力的模型', 'XKW-PHYS-42100', '2', 4, '2', '0', 'admin', now(), 'xkw:42100'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42100');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '三角形法则及多边形法则', 'XKW-PHYS-42101', '2', 5, '2', '0', 'admin', now(), 'xkw:42101'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42094'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42101');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '正交分解法', 'XKW-PHYS-42102', '2', 1, '2', '0', 'admin', now(), 'xkw:42102'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42095'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42102');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '按实际效果分解', 'XKW-PHYS-42103', '2', 2, '2', '0', 'admin', now(), 'xkw:42103'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42095'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42103');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力的分解过程中多解和极值的问题', 'XKW-PHYS-42104', '2', 3, '2', '0', 'admin', now(), 'xkw:42104'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42095'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42104');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '共点力的平衡条件', 'XKW-PHYS-135617', '1', 1, '2', '0', 'admin', now(), 'xkw:135617'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42059'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-135617');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动态平衡问题', 'XKW-PHYS-42117', '1', 2, '2', '0', 'admin', now(), 'xkw:42117'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42059'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42117');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平衡问题中临界与极值问题', 'XKW-PHYS-42109', '1', 3, '2', '0', 'admin', now(), 'xkw:42109'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42059'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42109');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '伽利略的理想斜面实验', 'XKW-PHYS-42132', '2', 1, '2', '0', 'admin', now(), 'xkw:42132'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42126'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42132');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿第一定律的理解', 'XKW-PHYS-42133', '2', 2, '2', '0', 'admin', now(), 'xkw:42133'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42126'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42133');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '惯性', 'XKW-PHYS-42134', '2', 3, '2', '0', 'admin', now(), 'xkw:42134'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42126'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42134');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿第二定律的内容和表达式', 'XKW-PHYS-42146', '2', 1, '2', '0', 'admin', now(), 'xkw:42146'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42127'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42146');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿第二定律的初步应用', 'XKW-PHYS-42147', '2', 2, '2', '0', 'admin', now(), 'xkw:42147'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42127'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42147');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿第二定律求瞬时加速度问题', 'XKW-PHYS-42148', '2', 3, '2', '0', 'admin', now(), 'xkw:42148'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42127'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42148');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿第二定律在阻力变化问题中的应用', 'XKW-PHYS-230201', '2', 4, '2', '0', 'admin', now(), 'xkw:230201'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42127'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230201');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '基本单位', 'XKW-PHYS-42196', '2', 1, '2', '0', 'admin', now(), 'xkw:42196'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42131'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42196');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '导出单位', 'XKW-PHYS-42197', '2', 2, '2', '0', 'admin', now(), 'xkw:42197'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42131'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42197');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用量纲法解物理问题', 'XKW-PHYS-42199', '2', 3, '2', '0', 'admin', now(), 'xkw:42199'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42131'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42199');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '超重和失重的概念', 'XKW-PHYS-42164', '2', 1, '2', '0', 'admin', now(), 'xkw:42164'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42157'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42164');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '超重和失重现象分析', 'XKW-PHYS-42165', '2', 2, '2', '0', 'admin', now(), 'xkw:42165'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42157'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42165');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '完全失重', 'XKW-PHYS-42167', '2', 3, '2', '0', 'admin', now(), 'xkw:42167'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42157'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42167');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '超重和失重的图像问题', 'XKW-PHYS-42168', '2', 4, '2', '0', 'admin', now(), 'xkw:42168'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42157'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42168');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿运动定律的两类基本问题', 'XKW-PHYS-42156', '1', 1, '2', '0', 'admin', now(), 'xkw:42156'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42156');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '斜面模型', 'XKW-PHYS-42158', '1', 2, '2', '0', 'admin', now(), 'xkw:42158'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42158');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '连接体模型', 'XKW-PHYS-42159', '1', 3, '2', '0', 'admin', now(), 'xkw:42159'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42159');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传送带模型', 'XKW-PHYS-42160', '1', 4, '2', '0', 'admin', now(), 'xkw:42160'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42160');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '板块模型', 'XKW-PHYS-42161', '1', 5, '2', '0', 'admin', now(), 'xkw:42161'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42161');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿运动定律与图像结合', 'XKW-PHYS-153426', '2', 6, '2', '0', 'admin', now(), 'xkw:153426'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42129'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153426');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曲线运动概念和性质', 'XKW-PHYS-42207', '2', 1, '2', '0', 'admin', now(), 'xkw:42207'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42200'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42207');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '曲线运动瞬时速度的方向', 'XKW-PHYS-42209', '2', 2, '2', '0', 'admin', now(), 'xkw:42209'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42200'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42209');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物体做曲线运动的条件', 'XKW-PHYS-42210', '2', 3, '2', '0', 'admin', now(), 'xkw:42210'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42200'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42210');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物体运动轨迹、速度、受力(加速度)的相互判断', 'XKW-PHYS-42212', '2', 4, '2', '0', 'admin', now(), 'xkw:42212'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42200'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42212');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '位移和速度的合成与分解', 'XKW-PHYS-42214', '1', 1, '2', '0', 'admin', now(), 'xkw:42214'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42201'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42214');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '小船渡河问题', 'XKW-PHYS-42215', '1', 2, '2', '0', 'admin', now(), 'xkw:42215'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42201'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42215');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关联速度问题', 'XKW-PHYS-42217', '1', 3, '2', '0', 'admin', now(), 'xkw:42217'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42201'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42217');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛运动的概念', 'XKW-PHYS-42237', '2', 1, '2', '0', 'admin', now(), 'xkw:42237'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-153289'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42237');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛运动的规律', 'XKW-PHYS-42232', '1', 2, '2', '0', 'admin', now(), 'xkw:42232'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-153289'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42232');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛运动的推论', 'XKW-PHYS-42235', '1', 3, '2', '0', 'admin', now(), 'xkw:42235'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-153289'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42235');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生活中的平抛运动', 'XKW-PHYS-208016', '1', 4, '2', '0', 'admin', now(), 'xkw:208016'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-153289'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208016');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '圆周运动的定义和描述', 'XKW-PHYS-42253', '2', 1, '2', '0', 'admin', now(), 'xkw:42253'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42253');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀速圆周运动的定义', 'XKW-PHYS-42261', '2', 2, '2', '0', 'admin', now(), 'xkw:42261'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42261');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '线速度', 'XKW-PHYS-42259', '2', 3, '2', '0', 'admin', now(), 'xkw:42259'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42259');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '角速度的定义和计算式', 'XKW-PHYS-42262', '2', 4, '2', '0', 'admin', now(), 'xkw:42262'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42262');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '转速与周期、频率的关系', 'XKW-PHYS-42264', '2', 5, '2', '0', 'admin', now(), 'xkw:42264'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42264');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '线速度与角速度的关系', 'XKW-PHYS-42266', '2', 6, '2', '0', 'admin', now(), 'xkw:42266'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42266');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '角度的追及问题', 'XKW-PHYS-42263', '2', 7, '2', '0', 'admin', now(), 'xkw:42263'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42263');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '圆周运动的周期性多解问题', 'XKW-PHYS-153432', '2', 8, '2', '0', 'admin', now(), 'xkw:153432'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153432');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同轴传动问题', 'XKW-PHYS-42267', '2', 9, '2', '0', 'admin', now(), 'xkw:42267'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42267');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '皮带传动问题', 'XKW-PHYS-230907', '2', 10, '2', '0', 'admin', now(), 'xkw:230907'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230907');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '齿轮传动问题', 'XKW-PHYS-230908', '2', 11, '2', '0', 'admin', now(), 'xkw:230908'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42203'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230908');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '向心力的定义及特征', 'XKW-PHYS-42272', '2', 1, '2', '0', 'admin', now(), 'xkw:42272'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42258'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42272');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '向心力的来源', 'XKW-PHYS-42273', '2', 2, '2', '0', 'admin', now(), 'xkw:42273'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42258'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42273');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '向心力的计算', 'XKW-PHYS-42274', '2', 3, '2', '0', 'admin', now(), 'xkw:42274'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42258'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42274');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '向心加速度的概念、公式与推导', 'XKW-PHYS-42269', '2', 1, '2', '0', 'admin', now(), 'xkw:42269'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42257'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42269');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '向心加速度与角速度、周期的关系', 'XKW-PHYS-42270', '2', 2, '2', '0', 'admin', now(), 'xkw:42270'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42257'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42270');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '比较向心加速度的大小', 'XKW-PHYS-42271', '2', 3, '2', '0', 'admin', now(), 'xkw:42271'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42257'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42271');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '水平转盘上的物体', 'XKW-PHYS-42284', '2', 1, '2', '0', 'admin', now(), 'xkw:42284'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42284');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '圆锥摆问题', 'XKW-PHYS-42285', '2', 2, '2', '0', 'admin', now(), 'xkw:42285'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42285');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '汽车/自行车转弯问题', 'XKW-PHYS-42286', '2', 3, '2', '0', 'admin', now(), 'xkw:42286'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42286');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '火车和飞机转弯模型', 'XKW-PHYS-42287', '2', 4, '2', '0', 'admin', now(), 'xkw:42287'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42287');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '倾斜转盘上的圆周运动', 'XKW-PHYS-153434', '2', 5, '2', '0', 'admin', now(), 'xkw:153434'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42277'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153434');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '绳/单层轨道模型', 'XKW-PHYS-42279', '2', 1, '2', '0', 'admin', now(), 'xkw:42279'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42279');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杆/管道模型', 'XKW-PHYS-42280', '2', 2, '2', '0', 'admin', now(), 'xkw:42280'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42280');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '拱桥和凹桥模型', 'XKW-PHYS-42282', '2', 3, '2', '0', 'admin', now(), 'xkw:42282'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42282');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光滑斜面上的圆周运动', 'XKW-PHYS-153433', '2', 4, '2', '0', 'admin', now(), 'xkw:153433'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153433');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天体运动的探索历程', 'XKW-PHYS-42296', '2', 1, '2', '0', 'admin', now(), 'xkw:42296'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42292'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42296');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '开普勒行星运动定律', 'XKW-PHYS-208017', '1', 2, '2', '0', 'admin', now(), 'xkw:208017'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42292'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208017');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力定律的发现', 'XKW-PHYS-42300', '1', 1, '2', '0', 'admin', now(), 'xkw:42300'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42293'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42300');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力理论的成就', 'XKW-PHYS-42301', '1', 2, '2', '0', 'admin', now(), 'xkw:42301'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42293'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42301');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宇宙速度', 'XKW-PHYS-208018', '1', 1, '2', '0', 'admin', now(), 'xkw:208018'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208018');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同步卫星与近地卫星', 'XKW-PHYS-42315', '1', 2, '2', '0', 'admin', now(), 'xkw:42315'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42315');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般人造卫星', 'XKW-PHYS-42316', '1', 3, '2', '0', 'admin', now(), 'xkw:42316'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42316');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '双星（多星）问题', 'XKW-PHYS-42317', '1', 4, '2', '0', 'admin', now(), 'xkw:42317'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42317');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '潮汐问题', 'XKW-PHYS-153438', '2', 5, '2', '0', 'admin', now(), 'xkw:153438'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153438');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中子星与黑洞问题', 'XKW-PHYS-153439', '2', 6, '2', '0', 'admin', now(), 'xkw:153439'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153439');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '拉格朗日点', 'XKW-PHYS-42336', '2', 7, '2', '0', 'admin', now(), 'xkw:42336'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42336');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿力学的成就与局限性', 'XKW-PHYS-42295', '2', 1, '2', '0', 'admin', now(), 'xkw:42295'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208019'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42295');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '相对论时空观', 'XKW-PHYS-43293', '1', 2, '2', '0', 'admin', now(), 'xkw:43293'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208019'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43293');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '宇宙起源和恒星演化', 'XKW-PHYS-43417', '2', 3, '2', '0', 'admin', now(), 'xkw:43417'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208019'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43417');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功的理解和计算', 'XKW-PHYS-42343', '1', 1, '2', '0', 'admin', now(), 'xkw:42343'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42337'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42343');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '常见力做功', 'XKW-PHYS-42344', '1', 2, '2', '0', 'admin', now(), 'xkw:42344'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42337'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42344');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变力做功', 'XKW-PHYS-42345', '1', 3, '2', '0', 'admin', now(), 'xkw:42345'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42337'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42345');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功率及其计算', 'XKW-PHYS-42360', '1', 1, '2', '0', 'admin', now(), 'xkw:42360'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42338'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42360');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机车启动', 'XKW-PHYS-42361', '1', 2, '2', '0', 'admin', now(), 'xkw:42361'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42338'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42361');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动能', 'XKW-PHYS-42371', '2', 1, '2', '0', 'admin', now(), 'xkw:42371'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42339'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42371');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动能定理', 'XKW-PHYS-42372', '1', 2, '2', '0', 'admin', now(), 'xkw:42372'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42339'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42372');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动能定理的综合应用', 'XKW-PHYS-42373', '1', 3, '2', '0', 'admin', now(), 'xkw:42373'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42339'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42373');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重力势能', 'XKW-PHYS-42395', '1', 1, '2', '0', 'admin', now(), 'xkw:42395'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42340'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42395');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹性势能', 'XKW-PHYS-42396', '1', 2, '2', '0', 'admin', now(), 'xkw:42396'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42340'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42396');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能', 'XKW-PHYS-42404', '2', 1, '2', '0', 'admin', now(), 'xkw:42404'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42341'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42404');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律及其条件', 'XKW-PHYS-42405', '1', 2, '2', '0', 'admin', now(), 'xkw:42405'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42341'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42405');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律的应用', 'XKW-PHYS-42406', '1', 3, '2', '0', 'admin', now(), 'xkw:42406'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42341'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42406');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功能关系的理解', 'XKW-PHYS-42408', '2', 1, '2', '0', 'admin', now(), 'xkw:42408'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42403'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42408');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '常见力做功与相应的能量转化', 'XKW-PHYS-42409', '2', 2, '2', '0', 'admin', now(), 'xkw:42409'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42403'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42409');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量守恒定律的内容表述', 'XKW-PHYS-42425', '2', 1, '2', '0', 'admin', now(), 'xkw:42425'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208020'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42425');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量守恒定律的初步应用', 'XKW-PHYS-42426', '2', 2, '2', '0', 'admin', now(), 'xkw:42426'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208020'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42426');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量守恒定律在板块模型中的应用', 'XKW-PHYS-174891', '2', 3, '2', '0', 'admin', now(), 'xkw:174891'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208020'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174891');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量守恒定律在曲线运动中的应用', 'XKW-PHYS-169351', '2', 4, '2', '0', 'admin', now(), 'xkw:169351'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208020'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-169351');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量守恒定律在传送带模型中的应用', 'XKW-PHYS-169352', '2', 5, '2', '0', 'admin', now(), 'xkw:169352'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208020'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-169352');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量的定义、单位和矢量性', 'XKW-PHYS-42438', '2', 1, '2', '0', 'admin', now(), 'xkw:42438'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42432'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42438');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算物体的动量及动量的变化', 'XKW-PHYS-42439', '2', 2, '2', '0', 'admin', now(), 'xkw:42439'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42432'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42439');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量和动能的区别与联系', 'XKW-PHYS-42440', '2', 3, '2', '0', 'admin', now(), 'xkw:42440'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42432'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42440');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '冲量的定义、单位和矢量性', 'XKW-PHYS-42434', '2', 1, '2', '0', 'admin', now(), 'xkw:42434'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42434');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '求恒力的冲量', 'XKW-PHYS-42435', '2', 2, '2', '0', 'admin', now(), 'xkw:42435'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42435');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '求变力的冲量', 'XKW-PHYS-42436', '2', 3, '2', '0', 'admin', now(), 'xkw:42436'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42436');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用F-t图像求冲量', 'XKW-PHYS-42437', '2', 4, '2', '0', 'admin', now(), 'xkw:42437'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42431'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42437');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量定理的内容', 'XKW-PHYS-42441', '2', 1, '2', '0', 'admin', now(), 'xkw:42441'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42433'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42441');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量定理的应用', 'XKW-PHYS-208021', '1', 2, '2', '0', 'admin', now(), 'xkw:208021'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42433'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208021');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量守恒定律的内容、应用范围和推导', 'XKW-PHYS-42450', '2', 1, '2', '0', 'admin', now(), 'xkw:42450'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42446'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42450');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断系统动量是否守恒', 'XKW-PHYS-42452', '2', 2, '2', '0', 'admin', now(), 'xkw:42452'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42446'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42452');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量守恒定律的初步应用', 'XKW-PHYS-230337', '2', 3, '2', '0', 'admin', now(), 'xkw:230337'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42446'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230337');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹性碰撞', 'XKW-PHYS-42463', '1', 1, '2', '0', 'admin', now(), 'xkw:42463'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42430'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42463');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非弹性碰撞', 'XKW-PHYS-42464', '1', 2, '2', '0', 'admin', now(), 'xkw:42464'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42430'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42464');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '爆炸问题', 'XKW-PHYS-42466', '2', 3, '2', '0', 'admin', now(), 'xkw:42466'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42430'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42466');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '反冲问题', 'XKW-PHYS-42467', '1', 4, '2', '0', 'admin', now(), 'xkw:42467'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42430'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42467');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '板块/子弹打木块模型', 'XKW-PHYS-42476', '2', 5, '2', '0', 'admin', now(), 'xkw:42476'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42430'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42476');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '滑块斜（曲）面模型', 'XKW-PHYS-42477', '2', 6, '2', '0', 'admin', now(), 'xkw:42477'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42430'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42477');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '滑块弹簧模型', 'XKW-PHYS-42478', '2', 7, '2', '0', 'admin', now(), 'xkw:42478'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42430'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42478');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人船模型及其变式', 'XKW-PHYS-42486', '2', 8, '2', '0', 'admin', now(), 'xkw:42486'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42430'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42486');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量守恒定律解决多过程问题', 'XKW-PHYS-42468', '1', 9, '2', '0', 'admin', now(), 'xkw:42468'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42430'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42468');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '简谐运动', 'XKW-PHYS-42494', '1', 1, '2', '0', 'admin', now(), 'xkw:42494'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42492'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42494');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单摆', 'XKW-PHYS-42495', '1', 2, '2', '0', 'admin', now(), 'xkw:42495'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42492'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42495');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '外力作用下的振动', 'XKW-PHYS-42496', '1', 3, '2', '0', 'admin', now(), 'xkw:42496'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42492'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42496');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波的形成', 'XKW-PHYS-42536', '1', 1, '2', '0', 'admin', now(), 'xkw:42536'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42493'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42536');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波的描述', 'XKW-PHYS-42541', '1', 2, '2', '0', 'admin', now(), 'xkw:42541'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42493'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42541');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波的多解问题', 'XKW-PHYS-42543', '1', 3, '2', '0', 'admin', now(), 'xkw:42543'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42493'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42543');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波的反射和折射', 'XKW-PHYS-42539', '2', 4, '2', '0', 'admin', now(), 'xkw:42539'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42493'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42539');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波的衍射', 'XKW-PHYS-42564', '2', 5, '2', '0', 'admin', now(), 'xkw:42564'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42493'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42564');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波的干涉', 'XKW-PHYS-42563', '1', 6, '2', '0', 'admin', now(), 'xkw:42563'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42493'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42563');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多普勒效应', 'XKW-PHYS-42538', '2', 7, '2', '0', 'admin', now(), 'xkw:42538'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42493'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42538');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '超声波和次声波', 'XKW-PHYS-42579', '2', 8, '2', '0', 'admin', now(), 'xkw:42579'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42493'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42579');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电荷', 'XKW-PHYS-42598', '1', 1, '2', '0', 'admin', now(), 'xkw:42598'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42598');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静电现象', 'XKW-PHYS-42599', '1', 2, '2', '0', 'admin', now(), 'xkw:42599'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42599');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静电的应用和防护', 'XKW-PHYS-42595', '1', 3, '2', '0', 'admin', now(), 'xkw:42595'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42595');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '点电荷模型', 'XKW-PHYS-42610', '2', 1, '2', '0', 'admin', now(), 'xkw:42610'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42610');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '库仑定律内容和表达式', 'XKW-PHYS-42611', '2', 2, '2', '0', 'admin', now(), 'xkw:42611'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42611');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '库仑的实验——静电力常量', 'XKW-PHYS-42612', '2', 3, '2', '0', 'admin', now(), 'xkw:42612'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42612');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多个点电荷间库仑力合成', 'XKW-PHYS-42617', '2', 4, '2', '0', 'admin', now(), 'xkw:42617'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42617');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非点电荷间库仑力的计算', 'XKW-PHYS-42613', '2', 5, '2', '0', 'admin', now(), 'xkw:42613'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42613');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '共线的自由电荷的平衡问题', 'XKW-PHYS-42615', '2', 6, '2', '0', 'admin', now(), 'xkw:42615'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42615');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非共线带电体的平衡问题', 'XKW-PHYS-230215', '2', 7, '2', '0', 'admin', now(), 'xkw:230215'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230215');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含静电力作用下的直线运动', 'XKW-PHYS-42616', '2', 8, '2', '0', 'admin', now(), 'xkw:42616'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42616');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含静电力作用下的曲线运动', 'XKW-PHYS-153443', '2', 9, '2', '0', 'admin', now(), 'xkw:153443'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153443');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用动量守恒定律解决多个带电小球运动问题', 'XKW-PHYS-168731', '2', 10, '2', '0', 'admin', now(), 'xkw:168731'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42600'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168731');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场的概念', 'XKW-PHYS-42618', '2', 1, '2', '0', 'admin', now(), 'xkw:42618'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42593'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42618');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场强度', 'XKW-PHYS-42619', '1', 2, '2', '0', 'admin', now(), 'xkw:42619'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42593'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42619');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场线', 'XKW-PHYS-42620', '1', 3, '2', '0', 'admin', now(), 'xkw:42620'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42593'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42620');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势能', 'XKW-PHYS-42637', '1', 1, '2', '0', 'admin', now(), 'xkw:42637'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42594'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42637');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势', 'XKW-PHYS-42638', '1', 2, '2', '0', 'admin', now(), 'xkw:42638'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42594'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42638');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势差', 'XKW-PHYS-42639', '1', 3, '2', '0', 'admin', now(), 'xkw:42639'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42594'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42639');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等势面', 'XKW-PHYS-42640', '1', 4, '2', '0', 'admin', now(), 'xkw:42640'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42594'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42640');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势差与电场强度的关系', 'XKW-PHYS-42641', '1', 5, '2', '0', 'admin', now(), 'xkw:42641'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42594'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42641');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场线、等势面和运动轨迹的定性分析', 'XKW-PHYS-42709', '2', 6, '2', '0', 'admin', now(), 'xkw:42709'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42594'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42709');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场中的图像问题', 'XKW-PHYS-230217', '1', 7, '2', '0', 'admin', now(), 'xkw:230217'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42594'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230217');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器', 'XKW-PHYS-42683', '2', 1, '2', '0', 'admin', now(), 'xkw:42683'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42596'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42683');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容', 'XKW-PHYS-42684', '1', 2, '2', '0', 'admin', now(), 'xkw:42684'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42596'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42684');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平行板电容器的电容', 'XKW-PHYS-42685', '1', 3, '2', '0', 'admin', now(), 'xkw:42685'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42596'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42685');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器的动态分析', 'XKW-PHYS-42686', '1', 4, '2', '0', 'admin', now(), 'xkw:42686'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42596'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42686');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器的充放电与储能', 'XKW-PHYS-42687', '2', 5, '2', '0', 'admin', now(), 'xkw:42687'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42596'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42687');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在匀强电场中的直线运动', 'XKW-PHYS-42708', '1', 1, '2', '0', 'admin', now(), 'xkw:42708'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42597'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42708');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在匀强电场中的偏转', 'XKW-PHYS-42711', '1', 2, '2', '0', 'admin', now(), 'xkw:42711'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42597'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42711');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电微粒（计重力）在电场中的运动', 'XKW-PHYS-42710', '1', 3, '2', '0', 'admin', now(), 'xkw:42710'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42597'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42710');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '示波管及其应用', 'XKW-PHYS-42712', '1', 4, '2', '0', 'admin', now(), 'xkw:42712'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42597'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42712');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流强度的定义及单位', 'XKW-PHYS-42735', '2', 1, '2', '0', 'admin', now(), 'xkw:42735'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42727'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42735');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流的微观表达式及其应用', 'XKW-PHYS-42736', '2', 2, '2', '0', 'admin', now(), 'xkw:42736'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42727'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42736');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等效电流', 'XKW-PHYS-42737', '2', 3, '2', '0', 'admin', now(), 'xkw:42737'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42727'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42737');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电阻定律', 'XKW-PHYS-42782', '2', 1, '2', '0', 'admin', now(), 'xkw:42782'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42730'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42782');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '影响材料电阻率的因素', 'XKW-PHYS-42784', '2', 2, '2', '0', 'admin', now(), 'xkw:42784'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42730'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42784');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光敏电阻和热敏电阻', 'XKW-PHYS-42785', '2', 3, '2', '0', 'admin', now(), 'xkw:42785'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42730'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42785');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '超导体和半导体', 'XKW-PHYS-42786', '2', 4, '2', '0', 'admin', now(), 'xkw:42786'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42730'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42786');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '欧姆定律', 'XKW-PHYS-42741', '1', 1, '2', '0', 'admin', now(), 'xkw:42741'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42728'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42741');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '串并联电路的特点', 'XKW-PHYS-208024', '1', 2, '2', '0', 'admin', now(), 'xkw:208024'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42728'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208024');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电表改装', 'XKW-PHYS-42744', '1', 3, '2', '0', 'admin', now(), 'xkw:42744'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42728'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42744');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电功和电功率定义、表达式及简单应用', 'XKW-PHYS-157643', '2', 1, '2', '0', 'admin', now(), 'xkw:157643'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42766'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-157643');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算串联和并联电路的电功和电功率', 'XKW-PHYS-42769', '2', 2, '2', '0', 'admin', now(), 'xkw:42769'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42766'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42769');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算混联电路各电阻的电功和电功率', 'XKW-PHYS-42770', '2', 3, '2', '0', 'admin', now(), 'xkw:42770'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42766'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42770');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '焦耳定律的内容和含义', 'XKW-PHYS-42771', '2', 1, '2', '0', 'admin', now(), 'xkw:42771'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42767'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42771');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流生热与电流做功的关系', 'XKW-PHYS-42772', '2', 2, '2', '0', 'admin', now(), 'xkw:42772'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42767'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42772');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电动机工作时的能量转化', 'XKW-PHYS-42773', '2', 1, '2', '0', 'admin', now(), 'xkw:42773'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42768'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42773');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含有电动机电路综合计算', 'XKW-PHYS-42774', '2', 2, '2', '0', 'admin', now(), 'xkw:42774'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42768'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42774');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他非纯电阻元件', 'XKW-PHYS-42776', '2', 3, '2', '0', 'admin', now(), 'xkw:42776'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42768'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42776');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电源、电动势的定义、电动势与电势差的对比', 'XKW-PHYS-42738', '2', 1, '2', '0', 'admin', now(), 'xkw:42738'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42734'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42738');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '常见的电源种类及其电动势', 'XKW-PHYS-42739', '2', 2, '2', '0', 'admin', now(), 'xkw:42739'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42734'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42739');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断电源内部带电粒子移动方向和能量转化', 'XKW-PHYS-42740', '2', 3, '2', '0', 'admin', now(), 'xkw:42740'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42734'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42740');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '闭合电路欧姆定律的内容及公式', 'XKW-PHYS-42808', '2', 1, '2', '0', 'admin', now(), 'xkw:42808'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42799'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42808');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电源的U-I图像', 'XKW-PHYS-42809', '2', 2, '2', '0', 'admin', now(), 'xkw:42809'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42799'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42809');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用电源的U-I图像求解可变电阻的实际功率', 'XKW-PHYS-42810', '2', 3, '2', '0', 'admin', now(), 'xkw:42810'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42799'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42810');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '路端电压随负载的变化规律', 'XKW-PHYS-42811', '2', 4, '2', '0', 'admin', now(), 'xkw:42811'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42799'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42811');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算电源的电动势和内阻', 'XKW-PHYS-42812', '2', 5, '2', '0', 'admin', now(), 'xkw:42812'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42799'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42812');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算电源的输出电压、总功率、输出功率、效率', 'XKW-PHYS-42814', '2', 6, '2', '0', 'admin', now(), 'xkw:42814'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42799'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42814');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电源的最大输出功率及其条件', 'XKW-PHYS-42815', '2', 7, '2', '0', 'admin', now(), 'xkw:42815'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42799'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42815');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用局部→整体→局部的方法分析动态电路', 'XKW-PHYS-42816', '2', 1, '2', '0', 'admin', now(), 'xkw:42816'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42816');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '根据串反并同判断电阻电压和电流的变化', 'XKW-PHYS-42817', '2', 2, '2', '0', 'admin', now(), 'xkw:42817'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42800'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42817');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断电路中发生故障的元件和原因', 'XKW-PHYS-42818', '2', 1, '2', '0', 'admin', now(), 'xkw:42818'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42818');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电路发生故障后电表示数变化问题', 'XKW-PHYS-42819', '2', 2, '2', '0', 'admin', now(), 'xkw:42819'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42819');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电路发生故障后小灯泡亮度变化问题', 'XKW-PHYS-42820', '2', 3, '2', '0', 'admin', now(), 'xkw:42820'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42801'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42820');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断电路中电容器极板的电性', 'XKW-PHYS-42821', '2', 1, '2', '0', 'admin', now(), 'xkw:42821'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42802'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42821');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含容电路中有关电荷量及其变化的计算', 'XKW-PHYS-42822', '2', 2, '2', '0', 'admin', now(), 'xkw:42822'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42802'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42822');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算含容电路的电流和电压', 'XKW-PHYS-42823', '2', 3, '2', '0', 'admin', now(), 'xkw:42823'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42802'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42823');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含有电容的电桥问题', 'XKW-PHYS-42824', '2', 4, '2', '0', 'admin', now(), 'xkw:42824'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42802'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42824');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁场与磁感线', 'XKW-PHYS-42847', '1', 1, '2', '0', 'admin', now(), 'xkw:42847'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42842'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42847');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁感应强度', 'XKW-PHYS-42848', '1', 2, '2', '0', 'admin', now(), 'xkw:42848'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42842'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42848');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '几种常见的磁场', 'XKW-PHYS-42849', '1', 3, '2', '0', 'admin', now(), 'xkw:42849'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42842'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42849');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁通量', 'XKW-PHYS-42850', '1', 4, '2', '0', 'admin', now(), 'xkw:42850'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42842'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42850');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流的磁效应', 'XKW-PHYS-42851', '1', 5, '2', '0', 'admin', now(), 'xkw:42851'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42842'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42851');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '安培分子电流假说', 'XKW-PHYS-42852', '2', 6, '2', '0', 'admin', now(), 'xkw:42852'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42842'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42852');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '安培力的方向', 'XKW-PHYS-42872', '1', 1, '2', '0', 'admin', now(), 'xkw:42872'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42843'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42872');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '安培力的大小', 'XKW-PHYS-42873', '1', 2, '2', '0', 'admin', now(), 'xkw:42873'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42843'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42873');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁电式电流表', 'XKW-PHYS-42874', '2', 3, '2', '0', 'admin', now(), 'xkw:42874'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42843'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42874');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '洛伦兹力的方向', 'XKW-PHYS-42886', '2', 1, '2', '0', 'admin', now(), 'xkw:42886'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42844'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42886');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '洛伦兹力的大小', 'XKW-PHYS-208027', '1', 2, '2', '0', 'admin', now(), 'xkw:208027'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42844'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208027');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电子束的磁偏转', 'XKW-PHYS-42889', '2', 3, '2', '0', 'admin', now(), 'xkw:42889'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42844'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42889');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在无边界匀强磁场中运动', 'XKW-PHYS-42891', '1', 1, '2', '0', 'admin', now(), 'xkw:42891'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42845'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42891');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子（微粒）在非匀强磁场中的运动', 'XKW-PHYS-42892', '1', 2, '2', '0', 'admin', now(), 'xkw:42892'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42845'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42892');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在有边界磁场中运动', 'XKW-PHYS-42893', '1', 3, '2', '0', 'admin', now(), 'xkw:42893'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42845'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42893');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在磁场中运动的多解问题', 'XKW-PHYS-42894', '1', 4, '2', '0', 'admin', now(), 'xkw:42894'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42845'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42894');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '速度选择器', 'XKW-PHYS-42906', '2', 1, '2', '0', 'admin', now(), 'xkw:42906'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42846'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42906');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '质谱仪', 'XKW-PHYS-42907', '2', 2, '2', '0', 'admin', now(), 'xkw:42907'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42846'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42907');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '回旋加速器', 'XKW-PHYS-42911', '1', 3, '2', '0', 'admin', now(), 'xkw:42911'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42846'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42911');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '霍尔效应', 'XKW-PHYS-42910', '1', 4, '2', '0', 'admin', now(), 'xkw:42910'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42846'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42910');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁流体发电机', 'XKW-PHYS-42908', '1', 5, '2', '0', 'admin', now(), 'xkw:42908'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42846'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42908');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁流量计', 'XKW-PHYS-42909', '1', 6, '2', '0', 'admin', now(), 'xkw:42909'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42846'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42909');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在组合场中的运动', 'XKW-PHYS-42912', '1', 7, '2', '0', 'admin', now(), 'xkw:42912'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42846'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42912');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在叠加场中的运动', 'XKW-PHYS-42913', '1', 8, '2', '0', 'admin', now(), 'xkw:42913'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42846'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42913');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁感应的发现过程', 'XKW-PHYS-42943', '2', 1, '2', '0', 'admin', now(), 'xkw:42943'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42943');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '导体棒切割磁感线产生感应电流', 'XKW-PHYS-42945', '2', 2, '2', '0', 'admin', now(), 'xkw:42945'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42945');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '插入拔出铁芯电流表指针变化', 'XKW-PHYS-42946', '2', 3, '2', '0', 'admin', now(), 'xkw:42946'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42946');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '开关闭合断开的瞬间线圈电流变化', 'XKW-PHYS-42947', '2', 4, '2', '0', 'admin', now(), 'xkw:42947'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42947');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '调节滑动变阻器分析电流表变化', 'XKW-PHYS-42948', '2', 5, '2', '0', 'admin', now(), 'xkw:42948'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42948');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '在地磁场作用下的摇绳发电', 'XKW-PHYS-42949', '2', 6, '2', '0', 'admin', now(), 'xkw:42949'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42949');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹簧线圈收缩产生感应电流', 'XKW-PHYS-42950', '2', 7, '2', '0', 'admin', now(), 'xkw:42950'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42950');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '线圈在进出磁场时产生电流', 'XKW-PHYS-42951', '2', 8, '2', '0', 'admin', now(), 'xkw:42951'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42951');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁铁靠近或远离线圈时产生感应电流', 'XKW-PHYS-42952', '2', 9, '2', '0', 'admin', now(), 'xkw:42952'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42952');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究感应电流产生的条件', 'XKW-PHYS-42953', '2', 10, '2', '0', 'admin', now(), 'xkw:42953'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42938'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42953');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '右手定则', 'XKW-PHYS-42954', '2', 1, '2', '0', 'admin', now(), 'xkw:42954'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42954');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '楞次定律', 'XKW-PHYS-42955', '1', 2, '2', '0', 'admin', now(), 'xkw:42955'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42939'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42955');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '法拉第电磁感应定律的内容', 'XKW-PHYS-42964', '1', 1, '2', '0', 'admin', now(), 'xkw:42964'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42940'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42964');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动生电动势', 'XKW-PHYS-42965', '1', 2, '2', '0', 'admin', now(), 'xkw:42965'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42940'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42965');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '感生电动势', 'XKW-PHYS-42966', '1', 3, '2', '0', 'admin', now(), 'xkw:42966'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42940'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42966');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '线框模型', 'XKW-PHYS-42977', '1', 1, '2', '0', 'admin', now(), 'xkw:42977'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208028'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42977');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单杆模型', 'XKW-PHYS-208029', '1', 2, '2', '0', 'admin', now(), 'xkw:208029'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208028'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208029');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '双杆模型', 'XKW-PHYS-208030', '1', 3, '2', '0', 'admin', now(), 'xkw:208030'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208028'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-208030');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自感与互感', 'XKW-PHYS-42994', '1', 1, '2', '0', 'admin', now(), 'xkw:42994'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42994');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '涡流', 'XKW-PHYS-42995', '1', 2, '2', '0', 'admin', now(), 'xkw:42995'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42995');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁阻尼 电磁驱动', 'XKW-PHYS-42996', '1', 3, '2', '0', 'admin', now(), 'xkw:42996'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42942'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42996');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交流发电机原理和示意图', 'XKW-PHYS-43019', '2', 1, '2', '0', 'admin', now(), 'xkw:43019'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43019');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断线圈转到不同位置的电流方向', 'XKW-PHYS-43020', '2', 2, '2', '0', 'admin', now(), 'xkw:43020'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43020');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '中性面及其性质', 'XKW-PHYS-43021', '2', 3, '2', '0', 'admin', now(), 'xkw:43021'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43021');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交流电的图像', 'XKW-PHYS-43023', '1', 1, '2', '0', 'admin', now(), 'xkw:43023'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43023');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流的频率和峰值', 'XKW-PHYS-43024', '1', 2, '2', '0', 'admin', now(), 'xkw:43024'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43024');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流的瞬时值', 'XKW-PHYS-43025', '1', 3, '2', '0', 'admin', now(), 'xkw:43025'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43025');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流的有效值', 'XKW-PHYS-43026', '1', 4, '2', '0', 'admin', now(), 'xkw:43026'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43026');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流的平均值', 'XKW-PHYS-43027', '1', 5, '2', '0', 'admin', now(), 'xkw:43027'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43012'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43027');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电感器对交变电流的影响', 'XKW-PHYS-43051', '2', 1, '2', '0', 'admin', now(), 'xkw:43051'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43013'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43051');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器对交变电流的影响', 'XKW-PHYS-43050', '1', 2, '2', '0', 'admin', now(), 'xkw:43050'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43013'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43050');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变压器的原理', 'XKW-PHYS-43060', '1', 1, '2', '0', 'admin', now(), 'xkw:43060'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43060');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变压器的应用', 'XKW-PHYS-43061', '1', 2, '2', '0', 'admin', now(), 'xkw:43061'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43014'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43061');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '升压变压器和降压变压器', 'XKW-PHYS-43073', '2', 1, '2', '0', 'admin', now(), 'xkw:43073'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43062'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43073');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算输电线路损耗', 'XKW-PHYS-43076', '2', 2, '2', '0', 'admin', now(), 'xkw:43076'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43062'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43076');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '高压输电的原理与优点', 'XKW-PHYS-43075', '2', 3, '2', '0', 'admin', now(), 'xkw:43075'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43062'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43075');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用户端功率改变判断输电线路中物理量变化', 'XKW-PHYS-43078', '2', 4, '2', '0', 'admin', now(), 'xkw:43078'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43062'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43078');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算用户端用电器的数量', 'XKW-PHYS-43079', '2', 5, '2', '0', 'admin', now(), 'xkw:43079'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43062'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43079');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁场理论与电磁波的发现', 'XKW-PHYS-43277', '2', 1, '2', '0', 'admin', now(), 'xkw:43277'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43277');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '振荡回路', 'XKW-PHYS-43278', '2', 2, '2', '0', 'admin', now(), 'xkw:43278'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43278');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁波的发射和接收', 'XKW-PHYS-43279', '2', 3, '2', '0', 'admin', now(), 'xkw:43279'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43279');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁波与信息化社会', 'XKW-PHYS-43280', '2', 4, '2', '0', 'admin', now(), 'xkw:43280'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43280');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁波的波长和频率的关系', 'XKW-PHYS-43281', '2', 1, '2', '0', 'admin', now(), 'xkw:43281'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43281');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无线电波的特性及作用', 'XKW-PHYS-43282', '2', 2, '2', '0', 'admin', now(), 'xkw:43282'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43282');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '红外线的特性及作用', 'XKW-PHYS-43283', '2', 3, '2', '0', 'admin', now(), 'xkw:43283'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43283');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '紫外线的特性及作用', 'XKW-PHYS-43285', '2', 4, '2', '0', 'admin', now(), 'xkw:43285'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43285');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'X射线的特性及作用', 'XKW-PHYS-43286', '2', 5, '2', '0', 'admin', now(), 'xkw:43286'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43286');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'γ射线的特性及作用', 'XKW-PHYS-43287', '2', 6, '2', '0', 'admin', now(), 'xkw:43287'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43287');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁波的能量', 'XKW-PHYS-43288', '2', 7, '2', '0', 'admin', now(), 'xkw:43288'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43288');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '了解光谱和太阳光谱', 'XKW-PHYS-43284', '2', 8, '2', '0', 'admin', now(), 'xkw:43284'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43276'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43284');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传感器定义及原理', 'XKW-PHYS-43083', '2', 1, '2', '0', 'admin', now(), 'xkw:43083'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43080'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43083');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光敏电阻', 'XKW-PHYS-43084', '2', 2, '2', '0', 'admin', now(), 'xkw:43084'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43080'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43084');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热敏电阻', 'XKW-PHYS-43085', '2', 3, '2', '0', 'admin', now(), 'xkw:43085'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43080'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43085');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '金属热电阻', 'XKW-PHYS-43086', '2', 4, '2', '0', 'admin', now(), 'xkw:43086'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43080'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43086');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '霍尔元件', 'XKW-PHYS-43087', '2', 5, '2', '0', 'admin', now(), 'xkw:43087'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43080'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43087');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '压（拉）力传感器', 'XKW-PHYS-43088', '2', 1, '2', '0', 'admin', now(), 'xkw:43088'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43081'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43088');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '温度传感器', 'XKW-PHYS-43089', '2', 2, '2', '0', 'admin', now(), 'xkw:43089'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43081'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43089');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光传感器', 'XKW-PHYS-43090', '2', 3, '2', '0', 'admin', now(), 'xkw:43090'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43081'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43090');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光控开关', 'XKW-PHYS-43091', '2', 4, '2', '0', 'admin', now(), 'xkw:43091'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43081'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43091');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '温度报警器', 'XKW-PHYS-43092', '2', 5, '2', '0', 'admin', now(), 'xkw:43092'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43081'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43092');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物质是由大量分子组成的', 'XKW-PHYS-230957', '2', 1, '2', '0', 'admin', now(), 'xkw:230957'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43098'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230957');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '阿伏加德罗常数及计算', 'XKW-PHYS-43110', '2', 2, '2', '0', 'admin', now(), 'xkw:43110'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43098'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43110');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子的大小', 'XKW-PHYS-43113', '2', 3, '2', '0', 'admin', now(), 'xkw:43113'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43098'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43113');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子热运动的基本概念', 'XKW-PHYS-43124', '2', 1, '2', '0', 'admin', now(), 'xkw:43124'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43124');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '影响分子热运动的因素', 'XKW-PHYS-43125', '2', 2, '2', '0', 'admin', now(), 'xkw:43125'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43125');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '扩散现象', 'XKW-PHYS-43102', '2', 3, '2', '0', 'admin', now(), 'xkw:43102'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43102');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '布朗运动', 'XKW-PHYS-43103', '2', 4, '2', '0', 'admin', now(), 'xkw:43103'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43104'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43103');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体温度的微观意义、气体分子速率分布图像', 'XKW-PHYS-43147', '2', 1, '2', '0', 'admin', now(), 'xkw:43147'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208031'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43147');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体压强的微观意义', 'XKW-PHYS-43148', '2', 2, '2', '0', 'admin', now(), 'xkw:43148'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208031'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43148');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子间存在间隙', 'XKW-PHYS-43126', '2', 1, '2', '0', 'admin', now(), 'xkw:43126'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43105'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43126');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子间作用力的宏观表现', 'XKW-PHYS-43127', '2', 2, '2', '0', 'admin', now(), 'xkw:43127'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43105'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43127');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子间的相互作用力和距离的的关系图像', 'XKW-PHYS-43128', '2', 3, '2', '0', 'admin', now(), 'xkw:43128'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43105'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43128');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子动能', 'XKW-PHYS-43133', '2', 1, '2', '0', 'admin', now(), 'xkw:43133'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43133');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分子势能', 'XKW-PHYS-43129', '2', 2, '2', '0', 'admin', now(), 'xkw:43129'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43129');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内能', 'XKW-PHYS-43108', '1', 3, '2', '0', 'admin', now(), 'xkw:43108'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208032'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43108');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热平衡定律', 'XKW-PHYS-43134', '2', 1, '2', '0', 'admin', now(), 'xkw:43134'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43134');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热力学温标、摄氏温标', 'XKW-PHYS-43135', '2', 2, '2', '0', 'admin', now(), 'xkw:43135'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43135');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '状态参量', 'XKW-PHYS-43141', '2', 3, '2', '0', 'admin', now(), 'xkw:43141'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43107'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43141');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体的等温变化', 'XKW-PHYS-43142', '1', 1, '2', '0', 'admin', now(), 'xkw:43142'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-194030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43142');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体的等容变化', 'XKW-PHYS-43143', '1', 2, '2', '0', 'admin', now(), 'xkw:43143'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-194030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43143');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体的等压变化', 'XKW-PHYS-43144', '1', 3, '2', '0', 'admin', now(), 'xkw:43144'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-194030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43144');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理想气体状态方程', 'XKW-PHYS-43145', '1', 4, '2', '0', 'admin', now(), 'xkw:43145'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-194030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43145');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体实验定律的综合应用', 'XKW-PHYS-230958', '1', 5, '2', '0', 'admin', now(), 'xkw:230958'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-194030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230958');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '晶体和非晶体', 'XKW-PHYS-43164', '2', 1, '2', '0', 'admin', now(), 'xkw:43164'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43160'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43164');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '晶体的微观结构', 'XKW-PHYS-43165', '2', 2, '2', '0', 'admin', now(), 'xkw:43165'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43160'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43165');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '各向同性、各向异性', 'XKW-PHYS-43166', '2', 3, '2', '0', 'admin', now(), 'xkw:43166'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43160'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43166');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '液体的表面张力', 'XKW-PHYS-43167', '2', 1, '2', '0', 'admin', now(), 'xkw:43167'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43161'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43167');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '浸润和不浸润', 'XKW-PHYS-43169', '2', 2, '2', '0', 'admin', now(), 'xkw:43169'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43161'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43169');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '毛细现象', 'XKW-PHYS-43170', '2', 3, '2', '0', 'admin', now(), 'xkw:43170'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43161'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43170');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '液晶', 'XKW-PHYS-43171', '2', 4, '2', '0', 'admin', now(), 'xkw:43171'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43161'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43171');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解热力学第一定律的表述和表达式', 'XKW-PHYS-43182', '2', 1, '2', '0', 'admin', now(), 'xkw:43182'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43182');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热力学第一定律的应用', 'XKW-PHYS-43183', '2', 2, '2', '0', 'admin', now(), 'xkw:43183'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43177'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43183');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量守恒定律的内容（热学背景）', 'XKW-PHYS-43185', '2', 1, '2', '0', 'admin', now(), 'xkw:43185'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43185');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '第一类永动机不可制成', 'XKW-PHYS-43186', '2', 2, '2', '0', 'admin', now(), 'xkw:43186'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43186');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量守恒定律在科技中的应用', 'XKW-PHYS-43187', '2', 3, '2', '0', 'admin', now(), 'xkw:43187'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43178'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43187');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热力学第二定律两种表述', 'XKW-PHYS-43188', '2', 1, '2', '0', 'admin', now(), 'xkw:43188'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43179'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43188');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '第二类永动机不可制成', 'XKW-PHYS-43189', '2', 2, '2', '0', 'admin', now(), 'xkw:43189'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43179'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43189');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '熵和熵增加原理', 'XKW-PHYS-43191', '2', 3, '2', '0', 'admin', now(), 'xkw:43191'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43179'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43191');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热机、制冷机', 'XKW-PHYS-43097', '2', 4, '2', '0', 'admin', now(), 'xkw:43097'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43179'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43097');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '绝对零度', 'XKW-PHYS-43192', '2', 1, '2', '0', 'admin', now(), 'xkw:43192'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43180'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43192');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '热力学第三定律的内容', 'XKW-PHYS-43193', '2', 2, '2', '0', 'admin', now(), 'xkw:43193'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43180'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43193');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量的多种形式', 'XKW-PHYS-42424', '2', 1, '2', '0', 'admin', now(), 'xkw:42424'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42424');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能源与环境', 'XKW-PHYS-43194', '2', 2, '2', '0', 'admin', now(), 'xkw:43194'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43181'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43194');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '折射率的波长表达式和速度表达式', 'XKW-PHYS-43217', '2', 1, '2', '0', 'admin', now(), 'xkw:43217'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208033'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43217');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '了解各色光在真空中的频率和波长', 'XKW-PHYS-43266', '2', 2, '2', '0', 'admin', now(), 'xkw:43266'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208033'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43266');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光疏介质和光密介质', 'XKW-PHYS-43227', '2', 1, '2', '0', 'admin', now(), 'xkw:43227'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43223'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43227');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发生全反射的条件、临界角', 'XKW-PHYS-43228', '2', 2, '2', '0', 'admin', now(), 'xkw:43228'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43223'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43228');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全反射棱镜', 'XKW-PHYS-43232', '2', 1, '2', '0', 'admin', now(), 'xkw:43232'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43224'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43232');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光导纤维', 'XKW-PHYS-43233', '2', 2, '2', '0', 'admin', now(), 'xkw:43233'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43224'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43233');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“三棱镜”模型', 'XKW-PHYS-230338', '2', 1, '2', '0', 'admin', now(), 'xkw:230338'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43230'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230338');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平行玻璃砖模型', 'XKW-PHYS-230339', '2', 2, '2', '0', 'admin', now(), 'xkw:230339'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43230'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230339');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“球形玻璃砖”模型', 'XKW-PHYS-230340', '2', 3, '2', '0', 'admin', now(), 'xkw:230340'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43230'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230340');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '几何体组合模型', 'XKW-PHYS-230341', '2', 4, '2', '0', 'admin', now(), 'xkw:230341'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43230'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230341');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '全反射遮挡问题', 'XKW-PHYS-230342', '2', 5, '2', '0', 'admin', now(), 'xkw:230342'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43230'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230342');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发生双缝干涉的条件', 'XKW-PHYS-43243', '2', 1, '2', '0', 'admin', now(), 'xkw:43243'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43240'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43243');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单色光与白光的双缝干涉图样', 'XKW-PHYS-43244', '2', 2, '2', '0', 'admin', now(), 'xkw:43244'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43240'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43244');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'Δx=Lλ /d公式简单计算', 'XKW-PHYS-43245', '2', 1, '2', '0', 'admin', now(), 'xkw:43245'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43245');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '已知光程差和频率判断某点的明暗条纹', 'XKW-PHYS-43246', '2', 2, '2', '0', 'admin', now(), 'xkw:43246'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43246');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '更换光的颜色判断条纹间距的变化', 'XKW-PHYS-43247', '2', 3, '2', '0', 'admin', now(), 'xkw:43247'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43247');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '改变双缝到光屏距离判断条纹间距的变化', 'XKW-PHYS-43249', '2', 4, '2', '0', 'admin', now(), 'xkw:43249'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43249');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '改变双缝间距判断条纹间距的变化', 'XKW-PHYS-43248', '2', 5, '2', '0', 'admin', now(), 'xkw:43248'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43248');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '薄膜干涉现象和原理', 'XKW-PHYS-43253', '2', 1, '2', '0', 'admin', now(), 'xkw:43253'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43242'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43253');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '检查工件的平整度', 'XKW-PHYS-43254', '2', 2, '2', '0', 'admin', now(), 'xkw:43254'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43242'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43254');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '增透膜与增反膜', 'XKW-PHYS-43255', '2', 3, '2', '0', 'admin', now(), 'xkw:43255'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43242'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43255');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿环', 'XKW-PHYS-234859', '2', 4, '2', '0', 'admin', now(), 'xkw:234859'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43242'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-234859');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单缝衍射和小孔衍射图样', 'XKW-PHYS-43258', '2', 1, '2', '0', 'admin', now(), 'xkw:43258'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43258');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '泊松亮斑', 'XKW-PHYS-43259', '2', 2, '2', '0', 'admin', now(), 'xkw:43259'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43259');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '衍射光栅', 'XKW-PHYS-43260', '2', 3, '2', '0', 'admin', now(), 'xkw:43260'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43256'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43260');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '黑体与黑体辐射', 'XKW-PHYS-43301', '2', 1, '2', '0', 'admin', now(), 'xkw:43301'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43301');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '能量子', 'XKW-PHYS-43302', '2', 2, '2', '0', 'admin', now(), 'xkw:43302'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43294'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43302');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光电效应的规律', 'XKW-PHYS-43304', '1', 1, '2', '0', 'admin', now(), 'xkw:43304'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43295'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43304');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '康普顿效应的现象及其解释', 'XKW-PHYS-43319', '2', 1, '2', '0', 'admin', now(), 'xkw:43319'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43296'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43319');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光子的动量及其公式', 'XKW-PHYS-43320', '2', 2, '2', '0', 'admin', now(), 'xkw:43320'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43296'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43320');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '德布罗意波', 'XKW-PHYS-43327', '2', 1, '2', '0', 'admin', now(), 'xkw:43327'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43297'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43327');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '概率波', 'XKW-PHYS-43329', '2', 2, '2', '0', 'admin', now(), 'xkw:43329'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43297'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43329');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不确定性关系', 'XKW-PHYS-43333', '2', 3, '2', '0', 'admin', now(), 'xkw:43333'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43297'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43333');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发现阴极射线——电子的实验装置', 'XKW-PHYS-43339', '2', 1, '2', '0', 'admin', now(), 'xkw:43339'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43334'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43339');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算电子的比荷', 'XKW-PHYS-43340', '2', 2, '2', '0', 'admin', now(), 'xkw:43340'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43334'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43340');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '密立根实验测电子的电荷量', 'XKW-PHYS-43341', '2', 3, '2', '0', 'admin', now(), 'xkw:43341'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43334'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43341');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '枣糕模型', 'XKW-PHYS-43338', '2', 1, '2', '0', 'admin', now(), 'xkw:43338'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43335'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43338');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'α粒子散射实验', 'XKW-PHYS-43344', '2', 2, '2', '0', 'admin', now(), 'xkw:43344'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43335'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43344');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '原子核式结构模型', 'XKW-PHYS-43346', '2', 3, '2', '0', 'admin', now(), 'xkw:43346'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43335'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43346');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光谱分析', 'XKW-PHYS-43351', '2', 1, '2', '0', 'admin', now(), 'xkw:43351'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43336'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43351');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '氢原子光谱', 'XKW-PHYS-43354', '2', 2, '2', '0', 'admin', now(), 'xkw:43354'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43336'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43354');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '玻尔原子理论的基本假设', 'XKW-PHYS-43356', '2', 3, '2', '0', 'admin', now(), 'xkw:43356'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43336'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43356');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '定态和原子的能级结构', 'XKW-PHYS-43357', '2', 4, '2', '0', 'admin', now(), 'xkw:43357'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43336'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43357');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '玻尔理论对氢原子光谱的解释', 'XKW-PHYS-43359', '2', 5, '2', '0', 'admin', now(), 'xkw:43359'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43336'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43359');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '玻尔理论的局限性', 'XKW-PHYS-43361', '2', 6, '2', '0', 'admin', now(), 'xkw:43361'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43336'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43361');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天然放射现象', 'XKW-PHYS-43367', '1', 1, '2', '0', 'admin', now(), 'xkw:43367'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43363'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43367');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '原子核的衰变', 'XKW-PHYS-43376', '1', 2, '2', '0', 'admin', now(), 'xkw:43376'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43363'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43376');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '半衰期', 'XKW-PHYS-43377', '1', 3, '2', '0', 'admin', now(), 'xkw:43377'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43363'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43377');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '原子核的人工转变', 'XKW-PHYS-43378', '1', 4, '2', '0', 'admin', now(), 'xkw:43378'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43363'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43378');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探测射线的方法', 'XKW-PHYS-43379', '1', 5, '2', '0', 'admin', now(), 'xkw:43379'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43363'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43379');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '放射性的应用与防护', 'XKW-PHYS-43380', '1', 6, '2', '0', 'admin', now(), 'xkw:43380'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43363'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43380');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核力、四种基本相互作用', 'XKW-PHYS-42061', '2', 1, '2', '0', 'admin', now(), 'xkw:42061'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43364'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42061');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '结合能与比结合能', 'XKW-PHYS-43399', '2', 2, '2', '0', 'admin', now(), 'xkw:43399'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43364'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43399');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '质能方程', 'XKW-PHYS-43406', '2', 1, '2', '0', 'admin', now(), 'xkw:43406'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43365'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43406');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核裂变', 'XKW-PHYS-43409', '2', 2, '2', '0', 'admin', now(), 'xkw:43409'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43365'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43409');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核聚变', 'XKW-PHYS-43413', '2', 3, '2', '0', 'admin', now(), 'xkw:43413'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43365'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43413');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刻度尺的使用与读数', 'XKW-PHYS-42187', '2', 1, '2', '0', 'admin', now(), 'xkw:42187'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42187');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '秒表的使用与读数', 'XKW-PHYS-42188', '2', 2, '2', '0', 'admin', now(), 'xkw:42188'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42188');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '打点计时器的原理及使用', 'XKW-PHYS-133576', '2', 3, '2', '0', 'admin', now(), 'xkw:133576'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-133576');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹簧测力计的读数', 'XKW-PHYS-42080', '2', 4, '2', '0', 'admin', now(), 'xkw:42080'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42080');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '螺旋测微器的读数', 'XKW-PHYS-42189', '2', 5, '2', '0', 'admin', now(), 'xkw:42189'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42189');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '游标卡尺的使用与读数', 'XKW-PHYS-42190', '2', 6, '2', '0', 'admin', now(), 'xkw:42190'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42190');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流表与电压表的读数', 'XKW-PHYS-42758', '2', 7, '2', '0', 'admin', now(), 'xkw:42758'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42185'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42758');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用打点计时器测物体的速度', 'XKW-PHYS-41984', '2', 1, '2', '0', 'admin', now(), 'xkw:41984'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41952'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41984');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'DIS测量速度', 'XKW-PHYS-153409', '2', 2, '2', '0', 'admin', now(), 'xkw:153409'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41952'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153409');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光电门测量速度', 'XKW-PHYS-153410', '2', 3, '2', '0', 'admin', now(), 'xkw:153410'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41952'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153410');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '频闪照相测量速度', 'XKW-PHYS-153411', '2', 4, '2', '0', 'admin', now(), 'xkw:153411'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41952'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153411');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '雷达测速', 'XKW-PHYS-153412', '2', 5, '2', '0', 'admin', now(), 'xkw:153412'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41952'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153412');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '滴水法测物体的速度', 'XKW-PHYS-230394', '2', 6, '2', '0', 'admin', now(), 'xkw:230394'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41952'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230394');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究小车速度随时间变化规律', 'XKW-PHYS-42006', '2', 1, '2', '0', 'admin', now(), 'xkw:42006'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42006');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算某点的瞬时速度', 'XKW-PHYS-42008', '2', 2, '2', '0', 'admin', now(), 'xkw:42008'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42008');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用逐差法计算加速度', 'XKW-PHYS-42009', '2', 3, '2', '0', 'admin', now(), 'xkw:42009'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42009');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '描绘实验的v-t图像并求加速度', 'XKW-PHYS-42010', '2', 4, '2', '0', 'admin', now(), 'xkw:42010'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42010');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用DIS研究匀变速运动', 'XKW-PHYS-42011', '2', 5, '2', '0', 'admin', now(), 'xkw:42011'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42011');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用光电门研究匀变速运动', 'XKW-PHYS-42012', '2', 6, '2', '0', 'admin', now(), 'xkw:42012'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42012');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用频闪相机研究匀变速运动', 'XKW-PHYS-42013', '2', 7, '2', '0', 'admin', now(), 'xkw:42013'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42013');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用力的平衡测量动摩擦因数', 'XKW-PHYS-174894', '2', 1, '2', '0', 'admin', now(), 'xkw:174894'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-153422'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174894');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用牛顿第二定律测量动摩擦因数', 'XKW-PHYS-174895', '2', 2, '2', '0', 'admin', now(), 'xkw:174895'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-153422'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174895');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用动能定理测量动摩擦因数', 'XKW-PHYS-174896', '2', 3, '2', '0', 'admin', now(), 'xkw:174896'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-153422'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174896');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用能量守恒定律测量动摩擦因数', 'XKW-PHYS-174897', '2', 4, '2', '0', 'admin', now(), 'xkw:174897'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-153422'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-174897');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '验证力的平行四边形定则', 'XKW-PHYS-42105', '2', 1, '2', '0', 'admin', now(), 'xkw:42105'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42096'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42105');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用其他方法验证力的平行四边形定则', 'XKW-PHYS-42107', '2', 2, '2', '0', 'admin', now(), 'xkw:42107'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42096'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42107');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '验证加速度与力成正比的实验', 'XKW-PHYS-42142', '2', 1, '2', '0', 'admin', now(), 'xkw:42142'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42142');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '验证加速度与质量成反比的实验', 'XKW-PHYS-42143', '2', 2, '2', '0', 'admin', now(), 'xkw:42143'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42143');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '验证牛顿第二定律实验方法的改进', 'XKW-PHYS-42145', '2', 3, '2', '0', 'admin', now(), 'xkw:42145'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42140'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42145');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '验证平抛运动在竖直及水平方向的运动规律', 'XKW-PHYS-230395', '2', 1, '2', '0', 'admin', now(), 'xkw:230395'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42233'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230395');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用水平挡板探究平抛运动的规律', 'XKW-PHYS-230396', '2', 2, '2', '0', 'admin', now(), 'xkw:230396'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42233'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230396');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用竖直挡板探究平抛运动的规律', 'XKW-PHYS-230397', '2', 3, '2', '0', 'admin', now(), 'xkw:230397'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42233'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230397');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用频闪相机研究平抛运动', 'XKW-PHYS-42247', '2', 4, '2', '0', 'admin', now(), 'xkw:42247'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42233'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42247');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用向心力演示仪探究向心力大小与半径、角速度、质量的关系', 'XKW-PHYS-230398', '2', 1, '2', '0', 'admin', now(), 'xkw:230398'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230398');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用传感器探究向心力大小与半径、角速度、质量的关系', 'XKW-PHYS-230399', '2', 2, '2', '0', 'admin', now(), 'xkw:230399'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42275'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230399');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '探究功与物体速度变化的关系', 'XKW-PHYS-42391', '2', 1, '2', '0', 'admin', now(), 'xkw:42391'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42375'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42391');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用光电门验证动能定理', 'XKW-PHYS-42394', '2', 2, '2', '0', 'admin', now(), 'xkw:42394'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42375'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42394');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛后落在水平面验证动量守恒定律', 'XKW-PHYS-42456', '2', 1, '2', '0', 'admin', now(), 'xkw:42456'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42447'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42456');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛后落在竖直面验证动量守恒定律', 'XKW-PHYS-42458', '2', 2, '2', '0', 'admin', now(), 'xkw:42458'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42447'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42458');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛后落在斜面上验证动量守恒定律', 'XKW-PHYS-42459', '2', 3, '2', '0', 'admin', now(), 'xkw:42459'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42447'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42459');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛后落在圆轨道上验证动量守恒定律', 'XKW-PHYS-230400', '2', 4, '2', '0', 'admin', now(), 'xkw:230400'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42447'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230400');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '结合弹簧验证动量守恒定律', 'XKW-PHYS-230401', '2', 5, '2', '0', 'admin', now(), 'xkw:230401'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42447'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230401');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用悬挂小球碰撞验证动量守恒定律', 'XKW-PHYS-230402', '2', 6, '2', '0', 'admin', now(), 'xkw:230402'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42447'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230402');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用频闪相机和气垫导轨验证动量守恒定律', 'XKW-PHYS-42460', '2', 7, '2', '0', 'admin', now(), 'xkw:42460'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42447'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42460');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用光电门和气垫导轨验证动量守恒定律', 'XKW-PHYS-42461', '2', 8, '2', '0', 'admin', now(), 'xkw:42461'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42447'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42461');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '伏安法测量未知电阻', 'XKW-PHYS-159607', '2', 1, '2', '0', 'admin', now(), 'xkw:159607'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230403'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-159607');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用双安法测量电阻', 'XKW-PHYS-42794', '2', 2, '2', '0', 'admin', now(), 'xkw:42794'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230403'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42794');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用双伏法测量电阻', 'XKW-PHYS-42795', '2', 3, '2', '0', 'admin', now(), 'xkw:42795'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230403'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42795');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用电阻箱替代电阻测量阻值', 'XKW-PHYS-42796', '2', 4, '2', '0', 'admin', now(), 'xkw:42796'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230403'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42796');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电桥法测电阻问题', 'XKW-PHYS-42797', '2', 5, '2', '0', 'admin', now(), 'xkw:42797'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230403'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42797');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '半偏法测量电表内阻', 'XKW-PHYS-42763', '2', 6, '2', '0', 'admin', now(), 'xkw:42763'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230403'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42763');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用伏安法测量电源的电动势和内阻', 'XKW-PHYS-42826', '2', 1, '2', '0', 'admin', now(), 'xkw:42826'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42803'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42826');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用电流表和电阻箱测量电源的电动势和内阻', 'XKW-PHYS-42828', '2', 2, '2', '0', 'admin', now(), 'xkw:42828'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42803'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42828');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用电压表和电阻箱测量电源的电动势和内阻', 'XKW-PHYS-42829', '2', 3, '2', '0', 'admin', now(), 'xkw:42829'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42803'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42829');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测平行玻璃砖的折射率', 'XKW-PHYS-43219', '2', 1, '2', '0', 'admin', now(), 'xkw:43219'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43219');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测三角玻璃砖的折射率', 'XKW-PHYS-230404', '2', 2, '2', '0', 'admin', now(), 'xkw:230404'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230404');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测半圆柱体玻璃砖的折射率', 'XKW-PHYS-230405', '2', 3, '2', '0', 'admin', now(), 'xkw:230405'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230405');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '测透明液体的折射率', 'XKW-PHYS-230406', '2', 4, '2', '0', 'admin', now(), 'xkw:230406'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230406');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '特殊方法测量折射率', 'XKW-PHYS-230407', '2', 5, '2', '0', 'admin', now(), 'xkw:230407'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43213'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230407');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '运动学的基础内容', 'XKW-PHYS-6413', '2', 1, '2', '0', 'admin', now(), 'xkw:6413'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6412'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6413');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抛体运动', 'XKW-PHYS-6414', '2', 2, '2', '0', 'admin', now(), 'xkw:6414'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6412'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6414');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '圆周运动', 'XKW-PHYS-6415', '2', 3, '2', '0', 'admin', now(), 'xkw:6415'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6412'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6415');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刚体的平动与定轴转动', 'XKW-PHYS-6416', '2', 4, '2', '0', 'admin', now(), 'xkw:6416'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6412'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6416');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '几种常见的力', 'XKW-PHYS-6418', '2', 1, '2', '0', 'admin', now(), 'xkw:6418'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6418');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '共点力作用下的物体平衡', 'XKW-PHYS-6419', '2', 2, '2', '0', 'admin', now(), 'xkw:6419'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6419');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '力矩有固定转轴的物体平衡', 'XKW-PHYS-6420', '2', 3, '2', '0', 'admin', now(), 'xkw:6420'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6420');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一般物体的平衡', 'XKW-PHYS-6421', '2', 4, '2', '0', 'admin', now(), 'xkw:6421'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6421');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平衡的稳度', 'XKW-PHYS-6422', '2', 5, '2', '0', 'admin', now(), 'xkw:6422'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6422');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '流体静力学', 'XKW-PHYS-6423', '2', 6, '2', '0', 'admin', now(), 'xkw:6423'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6417'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6423');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '牛顿运动定律', 'XKW-PHYS-6425', '2', 1, '2', '0', 'admin', now(), 'xkw:6425'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6424'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6425');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '惯性力', 'XKW-PHYS-6426', '2', 2, '2', '0', 'admin', now(), 'xkw:6426'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6424'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6426');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动能与势能', 'XKW-PHYS-6428', '2', 1, '2', '0', 'admin', now(), 'xkw:6428'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6428');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功能原理与机械能守恒定律', 'XKW-PHYS-6429', '2', 2, '2', '0', 'admin', now(), 'xkw:6429'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6429');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量与动量守恒定律', 'XKW-PHYS-6430', '2', 3, '2', '0', 'admin', now(), 'xkw:6430'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6430');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '碰撞', 'XKW-PHYS-6431', '2', 4, '2', '0', 'admin', now(), 'xkw:6431'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6431');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变质量体系的运动', 'XKW-PHYS-6432', '2', 5, '2', '0', 'admin', now(), 'xkw:6432'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6427'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6432');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '角动量', 'XKW-PHYS-6434', '2', 1, '2', '0', 'admin', now(), 'xkw:6434'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6433'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6434');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刚体动力学', 'XKW-PHYS-6435', '2', 2, '2', '0', 'admin', now(), 'xkw:6435'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6433'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6435');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力定律', 'XKW-PHYS-6436', '2', 3, '2', '0', 'admin', now(), 'xkw:6436'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6433'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6436');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '振动', 'XKW-PHYS-6438', '2', 1, '2', '0', 'admin', now(), 'xkw:6438'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6437'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6438');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波动', 'XKW-PHYS-6439', '2', 2, '2', '0', 'admin', now(), 'xkw:6439'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6437'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6439');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '库伦定律', 'XKW-PHYS-6442', '2', 1, '2', '0', 'admin', now(), 'xkw:6442'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6441'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6442');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势', 'XKW-PHYS-6443', '2', 2, '2', '0', 'admin', now(), 'xkw:6443'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6441'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6443');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器', 'XKW-PHYS-6444', '2', 3, '2', '0', 'admin', now(), 'xkw:6444'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6441'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6444');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电偶极子', 'XKW-PHYS-6445', '2', 4, '2', '0', 'admin', now(), 'xkw:6445'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6441'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6445');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电路中的基本物理量', 'XKW-PHYS-6447', '2', 1, '2', '0', 'admin', now(), 'xkw:6447'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6446'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6447');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电路的基本规律', 'XKW-PHYS-6448', '2', 2, '2', '0', 'admin', now(), 'xkw:6448'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6446'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6448');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电表电桥补偿电路', 'XKW-PHYS-6449', '2', 3, '2', '0', 'admin', now(), 'xkw:6449'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6446'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6449');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '网络电路的简化', 'XKW-PHYS-6450', '2', 4, '2', '0', 'admin', now(), 'xkw:6450'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6446'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6450');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物质的导电性', 'XKW-PHYS-6451', '2', 5, '2', '0', 'admin', now(), 'xkw:6451'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6446'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6451');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流的磁场', 'XKW-PHYS-6453', '2', 1, '2', '0', 'admin', now(), 'xkw:6453'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6452'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6453');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁场对电流的作用', 'XKW-PHYS-6454', '2', 2, '2', '0', 'admin', now(), 'xkw:6454'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6452'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6454');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁场对运动电荷的作用', 'XKW-PHYS-6455', '2', 3, '2', '0', 'admin', now(), 'xkw:6455'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6452'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6455');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁场应用的常见模型', 'XKW-PHYS-6456', '2', 4, '2', '0', 'admin', now(), 'xkw:6456'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6452'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6456');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁感应与交流电', 'XKW-PHYS-6458', '2', 1, '2', '0', 'admin', now(), 'xkw:6458'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6457'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6458');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交流电', 'XKW-PHYS-6459', '2', 2, '2', '0', 'admin', now(), 'xkw:6459'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6457'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6459');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁振荡和电磁波', 'XKW-PHYS-6460', '2', 3, '2', '0', 'admin', now(), 'xkw:6460'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-6457'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-6460');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '位移的定义、路程与位移', 'XKW-PHYS-41971', '2', 1, '2', '0', 'admin', now(), 'xkw:41971'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41961'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41971');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '路程和位移的计算', 'XKW-PHYS-41972', '2', 2, '2', '0', 'admin', now(), 'xkw:41972'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-41961'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-41972');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '连续相等时间内的运动比例规律', 'XKW-PHYS-42029', '2', 1, '2', '0', 'admin', now(), 'xkw:42029'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42022'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42029');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '连续相等位移的运动比例规律', 'XKW-PHYS-42031', '2', 2, '2', '0', 'admin', now(), 'xkw:42031'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42022'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42031');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'v-t图像反映的物理量', 'XKW-PHYS-153413', '2', 1, '2', '0', 'admin', now(), 'xkw:153413'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153413');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用v-t图像求加速度', 'XKW-PHYS-42014', '2', 2, '2', '0', 'admin', now(), 'xkw:42014'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42014');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用v-t图像求位移', 'XKW-PHYS-42015', '2', 3, '2', '0', 'admin', now(), 'xkw:42015'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42000'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42015');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用v-t图像解决变速运动的问题', 'XKW-PHYS-42016', '2', 1, '2', '0', 'admin', now(), 'xkw:42016'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230194'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42016');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用a-t图像解决非匀变速运动', 'XKW-PHYS-42052', '2', 2, '2', '0', 'admin', now(), 'xkw:42052'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230194'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42052');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静摩擦力概念及产生条件', 'XKW-PHYS-42086', '2', 1, '2', '0', 'admin', now(), 'xkw:42086'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42084'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42086');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断是否存在静摩擦力及其方向', 'XKW-PHYS-42087', '2', 2, '2', '0', 'admin', now(), 'xkw:42087'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42084'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42087');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静摩擦力的大小计算', 'XKW-PHYS-42088', '2', 3, '2', '0', 'admin', now(), 'xkw:42088'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42084'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42088');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '最大静摩擦力', 'XKW-PHYS-42089', '2', 4, '2', '0', 'admin', now(), 'xkw:42089'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42084'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42089');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '滑动摩擦力的产生条件与影响因素', 'XKW-PHYS-42090', '2', 1, '2', '0', 'admin', now(), 'xkw:42090'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42085'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42090');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '滑动摩擦力的大小与方向', 'XKW-PHYS-42091', '2', 2, '2', '0', 'admin', now(), 'xkw:42091'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42085'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42091');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '最大静摩擦力与滑动摩擦力的关系', 'XKW-PHYS-42092', '2', 3, '2', '0', 'admin', now(), 'xkw:42092'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42085'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42092');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多个接触面叠加时的滑动摩擦力', 'XKW-PHYS-42093', '2', 4, '2', '0', 'admin', now(), 'xkw:42093'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42085'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42093');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平衡状态的定义及条件', 'XKW-PHYS-153423', '2', 1, '2', '0', 'admin', now(), 'xkw:153423'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-135617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153423');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '分析物体受力个数', 'XKW-PHYS-42110', '2', 2, '2', '0', 'admin', now(), 'xkw:42110'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-135617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42110');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用平衡推论求力大小或方向', 'XKW-PHYS-42111', '2', 3, '2', '0', 'admin', now(), 'xkw:42111'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-135617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42111');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '直接合成法解决三力平衡问题', 'XKW-PHYS-42112', '2', 4, '2', '0', 'admin', now(), 'xkw:42112'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-135617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42112');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '整体法与隔离法解决共点力平衡问题', 'XKW-PHYS-42113', '2', 5, '2', '0', 'admin', now(), 'xkw:42113'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-135617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42113');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '正交分解法解共点力平衡问题', 'XKW-PHYS-42114', '2', 6, '2', '0', 'admin', now(), 'xkw:42114'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-135617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42114');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '三角形法则解决共点力平衡问题', 'XKW-PHYS-42115', '2', 7, '2', '0', 'admin', now(), 'xkw:42115'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-135617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42115');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '三维空间的共点力平衡问题', 'XKW-PHYS-230196', '2', 8, '2', '0', 'admin', now(), 'xkw:230196'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-135617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230196');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '刚体平衡条件及其应用', 'XKW-PHYS-42119', '2', 9, '2', '0', 'admin', now(), 'xkw:42119'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-135617'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42119');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用相似三角形解决平衡问题', 'XKW-PHYS-42116', '2', 1, '2', '0', 'admin', now(), 'xkw:42116'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42117'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42116');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用解析法解决平衡问题', 'XKW-PHYS-230197', '2', 2, '2', '0', 'admin', now(), 'xkw:230197'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42117'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230197');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用图解法解决平衡问题', 'XKW-PHYS-230198', '2', 3, '2', '0', 'admin', now(), 'xkw:230198'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42117'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230198');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用辅助圆解决平衡问题', 'XKW-PHYS-230199', '2', 4, '2', '0', 'admin', now(), 'xkw:230199'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42117'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230199');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用正弦定理解决平衡问题', 'XKW-PHYS-230200', '2', 5, '2', '0', 'admin', now(), 'xkw:230200'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42117'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230200');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“活结”、“死结”问题', 'XKW-PHYS-42120', '2', 1, '2', '0', 'admin', now(), 'xkw:42120'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42120');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“定杆”、“动杆”问题', 'XKW-PHYS-42125', '2', 2, '2', '0', 'admin', now(), 'xkw:42125'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42125');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '恰好发生相对滑动的临界问题', 'XKW-PHYS-42123', '2', 3, '2', '0', 'admin', now(), 'xkw:42123'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42123');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平衡问题中的极值问题', 'XKW-PHYS-42124', '2', 4, '2', '0', 'admin', now(), 'xkw:42124'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42124');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自锁问题', 'XKW-PHYS-42118', '2', 5, '2', '0', 'admin', now(), 'xkw:42118'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42109'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42118');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '已知受力求运动', 'XKW-PHYS-42162', '2', 1, '2', '0', 'admin', now(), 'xkw:42162'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42156'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42162');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '已知运动求受力', 'XKW-PHYS-42163', '2', 2, '2', '0', 'admin', now(), 'xkw:42163'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42156'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42163');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无外力，物体在光滑斜面滑动', 'XKW-PHYS-42169', '2', 1, '2', '0', 'admin', now(), 'xkw:42169'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42158'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42169');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无外力，物块在粗糙斜面滑动', 'XKW-PHYS-42170', '2', 2, '2', '0', 'admin', now(), 'xkw:42170'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42158'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42170');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有外力，物体在光滑斜面滑动', 'XKW-PHYS-42171', '2', 3, '2', '0', 'admin', now(), 'xkw:42171'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42158'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42171');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有外力，物块在粗糙斜面滑动', 'XKW-PHYS-230202', '2', 4, '2', '0', 'admin', now(), 'xkw:230202'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42158'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230202');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含有斜面的连接体问题分析', 'XKW-PHYS-42172', '2', 5, '2', '0', 'admin', now(), 'xkw:42172'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42158'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42172');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '斜面模型中的临界极值的问题', 'XKW-PHYS-42173', '2', 6, '2', '0', 'admin', now(), 'xkw:42173'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42158'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42173');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等时圆模型', 'XKW-PHYS-153424', '2', 7, '2', '0', 'admin', now(), 'xkw:153424'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42158'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153424');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '绳连接体问题', 'XKW-PHYS-42175', '2', 1, '2', '0', 'admin', now(), 'xkw:42175'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42159'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42175');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杆连接体问题', 'XKW-PHYS-230203', '2', 2, '2', '0', 'admin', now(), 'xkw:230203'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42159'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230203');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹簧连接体问题', 'XKW-PHYS-230204', '2', 3, '2', '0', 'admin', now(), 'xkw:230204'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42159'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230204');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '接触面间接连接', 'XKW-PHYS-230205', '2', 4, '2', '0', 'admin', now(), 'xkw:230205'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42159'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230205');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物块在水平传送带上运动分析', 'XKW-PHYS-42178', '2', 1, '2', '0', 'admin', now(), 'xkw:42178'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42160'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42178');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物块在倾斜传送带上运动分析', 'XKW-PHYS-42179', '2', 2, '2', '0', 'admin', now(), 'xkw:42179'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42160'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42179');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物块在组合传送带上运动分析', 'XKW-PHYS-230206', '2', 3, '2', '0', 'admin', now(), 'xkw:230206'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42160'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230206');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '物体在传送带上的划痕长度问题', 'XKW-PHYS-42181', '2', 4, '2', '0', 'admin', now(), 'xkw:42181'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42160'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42181');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无外力接触面光滑的板块模型', 'XKW-PHYS-42182', '2', 1, '2', '0', 'admin', now(), 'xkw:42182'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42161'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42182');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无外力接触面粗糙的板块模型', 'XKW-PHYS-230207', '2', 2, '2', '0', 'admin', now(), 'xkw:230207'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42161'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230207');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有外力接触面光滑的板块模型', 'XKW-PHYS-42183', '2', 3, '2', '0', 'admin', now(), 'xkw:42183'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42161'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42183');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有外力接触面粗糙的板块模型', 'XKW-PHYS-42184', '2', 4, '2', '0', 'admin', now(), 'xkw:42184'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42161'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42184');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '研究蜡块运动的分解', 'XKW-PHYS-42218', '2', 1, '2', '0', 'admin', now(), 'xkw:42218'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42218');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '合运动与分运动的概念及关系', 'XKW-PHYS-153427', '2', 2, '2', '0', 'admin', now(), 'xkw:153427'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153427');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '互成角度的两个匀速直线运动的合成', 'XKW-PHYS-42220', '2', 3, '2', '0', 'admin', now(), 'xkw:42220'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42220');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '一个匀速和一个变速运动的合成', 'XKW-PHYS-42221', '2', 4, '2', '0', 'admin', now(), 'xkw:42221'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42221');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '两个变速直线运动的合成', 'XKW-PHYS-42222', '2', 5, '2', '0', 'admin', now(), 'xkw:42222'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42222');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用相对运动规律处理运动的合成与分解', 'XKW-PHYS-153428', '2', 6, '2', '0', 'admin', now(), 'xkw:153428'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42214'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153428');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '过河时间最短问题', 'XKW-PHYS-42223', '2', 1, '2', '0', 'admin', now(), 'xkw:42223'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42215'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42223');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '船速大于水速时最短过河位移问题', 'XKW-PHYS-42224', '2', 2, '2', '0', 'admin', now(), 'xkw:42224'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42215'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42224');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '船速小于水速时最短过河位移问题', 'XKW-PHYS-42225', '2', 3, '2', '0', 'admin', now(), 'xkw:42225'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42215'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42225');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '水速变化的小船过河问题', 'XKW-PHYS-230208', '2', 4, '2', '0', 'admin', now(), 'xkw:230208'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42215'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230208');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '杆连接关联速度问题', 'XKW-PHYS-42228', '2', 1, '2', '0', 'admin', now(), 'xkw:42228'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42217'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42228');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '绳连接关联速度问题', 'XKW-PHYS-42230', '2', 2, '2', '0', 'admin', now(), 'xkw:42230'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42217'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42230');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他的关联速度问题', 'XKW-PHYS-230209', '2', 3, '2', '0', 'admin', now(), 'xkw:230209'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42217'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230209');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛运动速度的计算', 'XKW-PHYS-42241', '2', 1, '2', '0', 'admin', now(), 'xkw:42241'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42232'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42241');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛运动位移的计算', 'XKW-PHYS-42242', '2', 2, '2', '0', 'admin', now(), 'xkw:42242'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42232'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42242');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '速度偏转角的正切值与位移偏转角正切值的关系', 'XKW-PHYS-42249', '2', 1, '2', '0', 'admin', now(), 'xkw:42249'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42235'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42249');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '速度反向延长线的特点', 'XKW-PHYS-42250', '2', 2, '2', '0', 'admin', now(), 'xkw:42250'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42235'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42250');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '飞机投弹问题', 'XKW-PHYS-153430', '2', 1, '2', '0', 'admin', now(), 'xkw:153430'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153430');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛运动中追及相遇问题', 'XKW-PHYS-153429', '2', 2, '2', '0', 'admin', now(), 'xkw:153429'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153429');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平抛运动中的临界问题', 'XKW-PHYS-230210', '2', 3, '2', '0', 'admin', now(), 'xkw:230210'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230210');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '与斜面结合的平抛运动', 'XKW-PHYS-42251', '2', 4, '2', '0', 'admin', now(), 'xkw:42251'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42251');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '与曲面结合的平抛运动', 'XKW-PHYS-153431', '2', 5, '2', '0', 'admin', now(), 'xkw:153431'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153431');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '空间抛体问题', 'XKW-PHYS-230211', '2', 6, '2', '0', 'admin', now(), 'xkw:230211'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230211');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '类平抛运动', 'XKW-PHYS-42252', '2', 7, '2', '0', 'admin', now(), 'xkw:42252'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208016'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42252');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '开普勒第一定律', 'XKW-PHYS-42297', '2', 1, '2', '0', 'admin', now(), 'xkw:42297'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42297');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '开普勒第二定律', 'XKW-PHYS-42298', '2', 2, '2', '0', 'admin', now(), 'xkw:42298'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42298');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '开普勒第三定律', 'XKW-PHYS-42299', '2', 3, '2', '0', 'admin', now(), 'xkw:42299'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208017'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42299');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力定律的内容、推导及适用范围', 'XKW-PHYS-42302', '2', 1, '2', '0', 'admin', now(), 'xkw:42302'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42300'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42302');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力常量', 'XKW-PHYS-42303', '2', 2, '2', '0', 'admin', now(), 'xkw:42303'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42300'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42303');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力的计算', 'XKW-PHYS-42304', '2', 3, '2', '0', 'admin', now(), 'xkw:42304'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42300'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42304');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '空壳内及地表下的万有引力', 'XKW-PHYS-153435', '2', 4, '2', '0', 'admin', now(), 'xkw:153435'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42300'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153435');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '万有引力与重力的关系', 'XKW-PHYS-153436', '2', 1, '2', '0', 'admin', now(), 'xkw:153436'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42301'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153436');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他星球表面的重力加速度', 'XKW-PHYS-42322', '2', 2, '2', '0', 'admin', now(), 'xkw:42322'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42301'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42322');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '预言彗星的回归，发现未知天体', 'XKW-PHYS-42305', '2', 3, '2', '0', 'admin', now(), 'xkw:42305'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42301'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42305');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算中心天体的质量', 'XKW-PHYS-42306', '2', 4, '2', '0', 'admin', now(), 'xkw:42306'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42301'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42306');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算中心天体的密度', 'XKW-PHYS-42307', '2', 5, '2', '0', 'admin', now(), 'xkw:42307'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42301'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42307');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '第一宇宙速度', 'XKW-PHYS-42318', '2', 1, '2', '0', 'admin', now(), 'xkw:42318'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208018'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42318');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '其他星球的第一宇宙速度', 'XKW-PHYS-42320', '2', 2, '2', '0', 'admin', now(), 'xkw:42320'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208018'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42320');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '第二宇宙速度', 'XKW-PHYS-42312', '2', 3, '2', '0', 'admin', now(), 'xkw:42312'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208018'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42312');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '第三宇宙速度', 'XKW-PHYS-42313', '2', 4, '2', '0', 'admin', now(), 'xkw:42313'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208018'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42313');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同步卫星的特点', 'XKW-PHYS-42323', '2', 1, '2', '0', 'admin', now(), 'xkw:42323'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42315'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42323');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同步卫星、近地卫星与赤道上物体的比较', 'XKW-PHYS-42326', '2', 2, '2', '0', 'admin', now(), 'xkw:42326'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42315'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42326');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算卫星的各个物理量', 'XKW-PHYS-42327', '2', 1, '2', '0', 'admin', now(), 'xkw:42327'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42327');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '比较不同轨道上的卫星物理量', 'XKW-PHYS-42328', '2', 2, '2', '0', 'admin', now(), 'xkw:42328'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42328');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卫星发射及变轨问题', 'XKW-PHYS-42331', '2', 3, '2', '0', 'admin', now(), 'xkw:42331'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42331');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卫星对接问题', 'XKW-PHYS-230212', '2', 4, '2', '0', 'admin', now(), 'xkw:230212'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230212');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '航天器中的失重现象', 'XKW-PHYS-42283', '2', 5, '2', '0', 'admin', now(), 'xkw:42283'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42283');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '卫星的追及相遇问题', 'XKW-PHYS-161100', '2', 6, '2', '0', 'admin', now(), 'xkw:161100'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-161100');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天体运动中机械能的变化', 'XKW-PHYS-180665', '2', 7, '2', '0', 'admin', now(), 'xkw:180665'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42316'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-180665');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '双星问题', 'XKW-PHYS-42333', '2', 1, '2', '0', 'admin', now(), 'xkw:42333'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42317'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42333');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多星问题', 'XKW-PHYS-42335', '2', 2, '2', '0', 'admin', now(), 'xkw:42335'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42317'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42335');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '经典相对性原理', 'XKW-PHYS-43425', '2', 1, '2', '0', 'admin', now(), 'xkw:43425'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43293'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43425');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '狭义相对论的两个基本假设', 'XKW-PHYS-43426', '2', 2, '2', '0', 'admin', now(), 'xkw:43426'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43293'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43426');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '时间延缓效应', 'XKW-PHYS-43429', '2', 3, '2', '0', 'admin', now(), 'xkw:43429'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43293'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43429');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '长度收缩效应', 'XKW-PHYS-43428', '2', 4, '2', '0', 'admin', now(), 'xkw:43428'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43293'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43428');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '相对论速度变换公式', 'XKW-PHYS-43430', '2', 5, '2', '0', 'admin', now(), 'xkw:43430'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43293'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43430');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '相对论质量', 'XKW-PHYS-43431', '2', 6, '2', '0', 'admin', now(), 'xkw:43431'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43293'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43431');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '广义相对论', 'XKW-PHYS-43434', '2', 7, '2', '0', 'admin', now(), 'xkw:43434'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43293'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43434');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功的定义（式）', 'XKW-PHYS-42346', '2', 1, '2', '0', 'admin', now(), 'xkw:42346'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42346');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功的正负及判断', 'XKW-PHYS-42347', '2', 2, '2', '0', 'admin', now(), 'xkw:42347'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42343'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42347');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重力做功', 'XKW-PHYS-42348', '2', 1, '2', '0', 'admin', now(), 'xkw:42348'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42344'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42348');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹力（非弹簧）做功', 'XKW-PHYS-42349', '2', 2, '2', '0', 'admin', now(), 'xkw:42349'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42344'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42349');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹簧弹力做功', 'XKW-PHYS-42350', '2', 3, '2', '0', 'admin', now(), 'xkw:42350'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42344'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42350');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '摩擦力做功', 'XKW-PHYS-42351', '2', 4, '2', '0', 'admin', now(), 'xkw:42351'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42344'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42351');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多个力做的总功', 'XKW-PHYS-42353', '2', 5, '2', '0', 'admin', now(), 'xkw:42353'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42344'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42353');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等值法求变力做功', 'XKW-PHYS-42354', '2', 1, '2', '0', 'admin', now(), 'xkw:42354'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42345'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42354');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功率法求变力做功', 'XKW-PHYS-42355', '2', 2, '2', '0', 'admin', now(), 'xkw:42355'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42345'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42355');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平均力法求变力做功', 'XKW-PHYS-42356', '2', 3, '2', '0', 'admin', now(), 'xkw:42356'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42345'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42356');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '图像法求变力做功', 'XKW-PHYS-42357', '2', 4, '2', '0', 'admin', now(), 'xkw:42357'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42345'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42357');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微元法求变力做功', 'XKW-PHYS-42358', '2', 5, '2', '0', 'admin', now(), 'xkw:42358'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42345'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42358');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功率的定义（式）', 'XKW-PHYS-42362', '2', 1, '2', '0', 'admin', now(), 'xkw:42362'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42360'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42362');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '功率推导式：P=Fvcosθ', 'XKW-PHYS-42363', '2', 2, '2', '0', 'admin', now(), 'xkw:42363'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42360'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42363');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平均功率', 'XKW-PHYS-42364', '2', 3, '2', '0', 'admin', now(), 'xkw:42364'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42360'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42364');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '瞬时功率', 'XKW-PHYS-230909', '2', 4, '2', '0', 'admin', now(), 'xkw:230909'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42360'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230909');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械的额定功率和实际功率', 'XKW-PHYS-42365', '2', 1, '2', '0', 'admin', now(), 'xkw:42365'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42361'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42365');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机车的额定功率、阻力与最大速度的关系', 'XKW-PHYS-42366', '2', 2, '2', '0', 'admin', now(), 'xkw:42366'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42361'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42366');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '以额定功率启动', 'XKW-PHYS-42367', '2', 3, '2', '0', 'admin', now(), 'xkw:42367'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42361'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42367');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '以恒定加速度启动', 'XKW-PHYS-42368', '2', 4, '2', '0', 'admin', now(), 'xkw:42368'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42361'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42368');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '求解机车启动时变力做功问题', 'XKW-PHYS-42369', '2', 5, '2', '0', 'admin', now(), 'xkw:42369'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42361'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42369');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '起重机牵引物体类问题', 'XKW-PHYS-42370', '2', 6, '2', '0', 'admin', now(), 'xkw:42370'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42361'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42370');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动能定理的表述及其推导过程', 'XKW-PHYS-42380', '2', 1, '2', '0', 'admin', now(), 'xkw:42380'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42372'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42380');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动能定理的初步应用', 'XKW-PHYS-42381', '2', 2, '2', '0', 'admin', now(), 'xkw:42381'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42372'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42381');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '应用动能定理求变力做功', 'XKW-PHYS-42383', '2', 1, '2', '0', 'admin', now(), 'xkw:42383'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42373'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42383');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '应用动能定理解决多段过程问题', 'XKW-PHYS-42384', '2', 2, '2', '0', 'admin', now(), 'xkw:42384'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42373'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42384');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '应用动能定理解决机车启动问题', 'XKW-PHYS-42385', '2', 3, '2', '0', 'admin', now(), 'xkw:42385'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42373'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42385');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '应用动能定理解决物体在传送带运动问题', 'XKW-PHYS-42386', '2', 4, '2', '0', 'admin', now(), 'xkw:42386'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42373'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42386');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重力势能的定义和性质', 'XKW-PHYS-42397', '2', 1, '2', '0', 'admin', now(), 'xkw:42397'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42395'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42397');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重力势能的相对性', 'XKW-PHYS-42398', '2', 2, '2', '0', 'admin', now(), 'xkw:42398'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42395'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42398');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '重力势能的变化和重力做功的关系', 'XKW-PHYS-42399', '2', 3, '2', '0', 'admin', now(), 'xkw:42399'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42395'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42399');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹性势能的定义和性质', 'XKW-PHYS-42400', '2', 1, '2', '0', 'admin', now(), 'xkw:42400'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42400');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹性势能的影响因素和计算', 'XKW-PHYS-42401', '2', 2, '2', '0', 'admin', now(), 'xkw:42401'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42401');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹性势能的变化和弹力做功的关系', 'XKW-PHYS-42402', '2', 3, '2', '0', 'admin', now(), 'xkw:42402'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42396'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42402');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律的内容及条件', 'XKW-PHYS-42413', '2', 1, '2', '0', 'admin', now(), 'xkw:42413'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42405'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42413');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断系统机械能是否守恒', 'XKW-PHYS-42414', '2', 2, '2', '0', 'admin', now(), 'xkw:42414'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42405'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42414');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律的初步应用', 'XKW-PHYS-42415', '2', 3, '2', '0', 'admin', now(), 'xkw:42415'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42405'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42415');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律在曲线运动中的应用', 'XKW-PHYS-42416', '2', 1, '2', '0', 'admin', now(), 'xkw:42416'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42416');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非质点类物体的机械能守恒', 'XKW-PHYS-42417', '2', 2, '2', '0', 'admin', now(), 'xkw:42417'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42417');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律在杆连接系统中的应用', 'XKW-PHYS-42418', '2', 3, '2', '0', 'admin', now(), 'xkw:42418'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42418');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律在绳连接系统中的应用', 'XKW-PHYS-42419', '2', 4, '2', '0', 'admin', now(), 'xkw:42419'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42419');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律在弹簧类问题中的应用', 'XKW-PHYS-42420', '2', 5, '2', '0', 'admin', now(), 'xkw:42420'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42420');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械能守恒定律中的图像问题', 'XKW-PHYS-230213', '2', 6, '2', '0', 'admin', now(), 'xkw:230213'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42406'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230213');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用动量定理解释缓冲现象', 'XKW-PHYS-42442', '2', 1, '2', '0', 'admin', now(), 'xkw:42442'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208021'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42442');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用动量定理求蹦极类的问题', 'XKW-PHYS-42443', '2', 2, '2', '0', 'admin', now(), 'xkw:42443'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208021'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42443');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动量定理与v-t图像结合的问题', 'XKW-PHYS-42444', '2', 3, '2', '0', 'admin', now(), 'xkw:42444'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208021'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42444');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '用动量定理解决流体问题', 'XKW-PHYS-42445', '2', 4, '2', '0', 'admin', now(), 'xkw:42445'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208021'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42445');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用动量定理求解其他问题', 'XKW-PHYS-168729', '2', 5, '2', '0', 'admin', now(), 'xkw:168729'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208021'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168729');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹性碰撞：动碰静', 'XKW-PHYS-42471', '2', 1, '2', '0', 'admin', now(), 'xkw:42471'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42463'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42471');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '弹性碰撞：动碰动', 'XKW-PHYS-42472', '2', 2, '2', '0', 'admin', now(), 'xkw:42472'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42463'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42472');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '完全非弹性碰撞', 'XKW-PHYS-42474', '2', 1, '2', '0', 'admin', now(), 'xkw:42474'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42464'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42474');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非完全弹性碰撞问题', 'XKW-PHYS-42480', '2', 2, '2', '0', 'admin', now(), 'xkw:42480'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42464'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42480');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '反冲现象中的动量守恒', 'XKW-PHYS-42484', '2', 1, '2', '0', 'admin', now(), 'xkw:42484'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42467'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42484');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '火箭的原理', 'XKW-PHYS-42485', '2', 2, '2', '0', 'admin', now(), 'xkw:42485'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42467'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42485');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '抛接体问题', 'XKW-PHYS-42488', '2', 3, '2', '0', 'admin', now(), 'xkw:42488'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42467'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42488');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单次碰撞的多过程问题', 'XKW-PHYS-42489', '2', 1, '2', '0', 'admin', now(), 'xkw:42489'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42468'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42489');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '两物体多次碰撞问题', 'XKW-PHYS-42490', '2', 2, '2', '0', 'admin', now(), 'xkw:42490'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42468'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42490');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '多物体多次碰撞问题', 'XKW-PHYS-42491', '2', 3, '2', '0', 'admin', now(), 'xkw:42491'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42468'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42491');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '简谐运动的定义及特征', 'XKW-PHYS-42500', '2', 1, '2', '0', 'admin', now(), 'xkw:42500'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42494'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42500');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '简谐运动的描述', 'XKW-PHYS-42503', '2', 2, '2', '0', 'admin', now(), 'xkw:42503'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42494'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42503');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '简谐运动的回复力和能量', 'XKW-PHYS-42505', '2', 3, '2', '0', 'admin', now(), 'xkw:42505'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42494'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42505');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单摆模型及条件', 'XKW-PHYS-42513', '2', 1, '2', '0', 'admin', now(), 'xkw:42513'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42495'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42513');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单摆的回复力', 'XKW-PHYS-42514', '2', 2, '2', '0', 'admin', now(), 'xkw:42514'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42495'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42514');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单摆的速度、加速度和位移', 'XKW-PHYS-42515', '2', 3, '2', '0', 'admin', now(), 'xkw:42515'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42495'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42515');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单摆的振动图像及其表达式', 'XKW-PHYS-42517', '2', 4, '2', '0', 'admin', now(), 'xkw:42517'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42495'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42517');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '单摆的周期', 'XKW-PHYS-42519', '2', 5, '2', '0', 'admin', now(), 'xkw:42519'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42495'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42519');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等效单摆', 'XKW-PHYS-42520', '2', 6, '2', '0', 'admin', now(), 'xkw:42520'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42495'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42520');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '阻尼振动', 'XKW-PHYS-42531', '2', 1, '2', '0', 'admin', now(), 'xkw:42531'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42496'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42531');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '受迫振动与共振', 'XKW-PHYS-42533', '2', 2, '2', '0', 'admin', now(), 'xkw:42533'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42496'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42533');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械波及其形成', 'XKW-PHYS-42544', '2', 1, '2', '0', 'admin', now(), 'xkw:42544'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42536'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42544');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '横波和纵波', 'XKW-PHYS-42546', '2', 2, '2', '0', 'admin', now(), 'xkw:42546'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42536'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42546');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '机械振动和机械波的关系', 'XKW-PHYS-42547', '2', 3, '2', '0', 'admin', now(), 'xkw:42547'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42536'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42547');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波长、频率和波速的关系', 'XKW-PHYS-42550', '2', 1, '2', '0', 'admin', now(), 'xkw:42550'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42541'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42550');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波的图像', 'XKW-PHYS-42552', '2', 2, '2', '0', 'admin', now(), 'xkw:42552'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42541'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42552');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '振动图像与波形图的结合', 'XKW-PHYS-42557', '2', 3, '2', '0', 'admin', now(), 'xkw:42557'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42541'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42557');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '求周期的多解问题', 'XKW-PHYS-42558', '2', 1, '2', '0', 'admin', now(), 'xkw:42558'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42543'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42558');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '求波长的多解问题', 'XKW-PHYS-42559', '2', 2, '2', '0', 'admin', now(), 'xkw:42559'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42543'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42559');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '求波速的多解问题', 'XKW-PHYS-42560', '2', 3, '2', '0', 'admin', now(), 'xkw:42560'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42543'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42560');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '传播方向的多解问题', 'XKW-PHYS-42561', '2', 4, '2', '0', 'admin', now(), 'xkw:42561'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42543'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42561');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波的叠加原理', 'XKW-PHYS-42567', '2', 1, '2', '0', 'admin', now(), 'xkw:42567'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42567');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波发生稳定干涉的条件', 'XKW-PHYS-42568', '2', 2, '2', '0', 'admin', now(), 'xkw:42568'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42568');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '波的干涉图样、判断干涉加强和减弱区', 'XKW-PHYS-42569', '2', 3, '2', '0', 'admin', now(), 'xkw:42569'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42569');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '生活中常见的波的干涉现象', 'XKW-PHYS-42570', '2', 4, '2', '0', 'admin', now(), 'xkw:42570'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42563'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42570');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电荷间相互作用', 'XKW-PHYS-42602', '2', 1, '2', '0', 'admin', now(), 'xkw:42602'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42598'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42602');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断物体是否带电及电性', 'XKW-PHYS-42603', '2', 2, '2', '0', 'admin', now(), 'xkw:42603'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42598'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42603');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电荷守恒定律', 'XKW-PHYS-42604', '2', 3, '2', '0', 'admin', now(), 'xkw:42604'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42598'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42604');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '元电荷、电荷量和比荷', 'XKW-PHYS-42605', '2', 4, '2', '0', 'admin', now(), 'xkw:42605'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42598'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42605');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '接触起电', 'XKW-PHYS-42606', '2', 1, '2', '0', 'admin', now(), 'xkw:42606'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42599'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42606');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '摩擦起电', 'XKW-PHYS-42607', '2', 2, '2', '0', 'admin', now(), 'xkw:42607'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42599'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42607');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '感应起电', 'XKW-PHYS-42608', '2', 3, '2', '0', 'admin', now(), 'xkw:42608'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42599'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42608');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静电平衡', 'XKW-PHYS-42675', '2', 1, '2', '0', 'admin', now(), 'xkw:42675'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42595'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42675');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '尖端放电', 'XKW-PHYS-42676', '2', 2, '2', '0', 'admin', now(), 'xkw:42676'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42595'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42676');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静电屏蔽', 'XKW-PHYS-42681', '2', 3, '2', '0', 'admin', now(), 'xkw:42681'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42595'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42681');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静电吸附', 'XKW-PHYS-230214', '2', 4, '2', '0', 'admin', now(), 'xkw:230214'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42595'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230214');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场强度的定义和单位', 'XKW-PHYS-42623', '2', 1, '2', '0', 'admin', now(), 'xkw:42623'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42623');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '点电荷与均匀球体（球壳）周围的场强', 'XKW-PHYS-42624', '2', 2, '2', '0', 'admin', now(), 'xkw:42624'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42624');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '割补法求电场强度', 'XKW-PHYS-42625', '2', 3, '2', '0', 'admin', now(), 'xkw:42625'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42625');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀强电场的场强', 'XKW-PHYS-42626', '2', 4, '2', '0', 'admin', now(), 'xkw:42626'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42626');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场强度的叠加法则', 'XKW-PHYS-42627', '2', 5, '2', '0', 'admin', now(), 'xkw:42627'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42627');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '微元法求场强', 'XKW-PHYS-230216', '2', 6, '2', '0', 'admin', now(), 'xkw:230216'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230216');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用静电平衡求场强', 'XKW-PHYS-42677', '2', 7, '2', '0', 'admin', now(), 'xkw:42677'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42619'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42677');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场线定义及其性质', 'XKW-PHYS-42628', '2', 1, '2', '0', 'admin', now(), 'xkw:42628'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42628');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀强电场的电场线分布', 'XKW-PHYS-42629', '2', 2, '2', '0', 'admin', now(), 'xkw:42629'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42629');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '正负点电荷的电场线分布', 'XKW-PHYS-42630', '2', 3, '2', '0', 'admin', now(), 'xkw:42630'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42630');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '根据电场线的疏密比较电场强弱', 'XKW-PHYS-42631', '2', 4, '2', '0', 'admin', now(), 'xkw:42631'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42631');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '异种等量点电荷电场线分布', 'XKW-PHYS-42632', '2', 5, '2', '0', 'admin', now(), 'xkw:42632'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42632');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '同种等量点电荷电场线分布', 'XKW-PHYS-42633', '2', 6, '2', '0', 'admin', now(), 'xkw:42633'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42633');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不等量点电荷或多个点电荷周围的电场分布规律', 'XKW-PHYS-42636', '2', 7, '2', '0', 'admin', now(), 'xkw:42636'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42620'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42636');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静电力做功的特点', 'XKW-PHYS-42642', '2', 1, '2', '0', 'admin', now(), 'xkw:42642'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42637'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42642');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势能的概念及计算', 'XKW-PHYS-42643', '2', 2, '2', '0', 'admin', now(), 'xkw:42643'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42637'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42643');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '比较电势能的大小', 'XKW-PHYS-42644', '2', 3, '2', '0', 'admin', now(), 'xkw:42644'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42637'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42644');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场力做功和电势能变化的关系', 'XKW-PHYS-42645', '2', 4, '2', '0', 'admin', now(), 'xkw:42645'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42637'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42645');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势的概念、定义式、单位和物理意义', 'XKW-PHYS-42646', '2', 1, '2', '0', 'admin', now(), 'xkw:42646'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42646');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '零电势的选取与电势高低的判断', 'XKW-PHYS-42647', '2', 2, '2', '0', 'admin', now(), 'xkw:42647'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42647');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势和电场线的关系', 'XKW-PHYS-42648', '2', 3, '2', '0', 'admin', now(), 'xkw:42648'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42648');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电体周围的电势分布', 'XKW-PHYS-42649', '2', 4, '2', '0', 'admin', now(), 'xkw:42649'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42649');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等量同种电荷周围电势的分布', 'XKW-PHYS-42651', '2', 5, '2', '0', 'admin', now(), 'xkw:42651'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42651');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等量异种电荷周围电势的分布', 'XKW-PHYS-42652', '2', 6, '2', '0', 'admin', now(), 'xkw:42652'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42652');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '不等量点电荷周围的电势分布', 'XKW-PHYS-42655', '2', 7, '2', '0', 'admin', now(), 'xkw:42655'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42655');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀强电场中电势的计算', 'XKW-PHYS-42656', '2', 8, '2', '0', 'admin', now(), 'xkw:42656'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42656');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '点电荷周围电势及叠加计算', 'XKW-PHYS-42657', '2', 9, '2', '0', 'admin', now(), 'xkw:42657'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42657');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '比较静电平衡后不同位置电势的高低', 'XKW-PHYS-42678', '2', 10, '2', '0', 'admin', now(), 'xkw:42678'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42638'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42678');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势差的概念、单位和物理意义', 'XKW-PHYS-42658', '2', 1, '2', '0', 'admin', now(), 'xkw:42658'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42639'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42658');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '静电力做功与电势差的关系', 'XKW-PHYS-42660', '2', 2, '2', '0', 'admin', now(), 'xkw:42660'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42639'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42660');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算电势差的大小', 'XKW-PHYS-42661', '2', 3, '2', '0', 'admin', now(), 'xkw:42661'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42639'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42661');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电势与电势差的关系', 'XKW-PHYS-42662', '2', 4, '2', '0', 'admin', now(), 'xkw:42662'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42639'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42662');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '点电荷周围的等势面', 'XKW-PHYS-42665', '2', 1, '2', '0', 'admin', now(), 'xkw:42665'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42640'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42665');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '等势面和电场线的关系', 'XKW-PHYS-42666', '2', 2, '2', '0', 'admin', now(), 'xkw:42666'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42640'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42666');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算带电粒子穿越不同等势面时电场力做功和能量变化', 'XKW-PHYS-42667', '2', 3, '2', '0', 'admin', now(), 'xkw:42667'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42640'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42667');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀强电场中电势差与电场强度的关系', 'XKW-PHYS-42668', '2', 1, '2', '0', 'admin', now(), 'xkw:42668'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42641'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42668');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算匀强电场中两点的电势差', 'XKW-PHYS-42669', '2', 2, '2', '0', 'admin', now(), 'xkw:42669'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42641'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42669');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场强度与电势的关系', 'XKW-PHYS-42670', '2', 3, '2', '0', 'admin', now(), 'xkw:42670'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42641'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42670');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断非匀强电场中等距的两点电势差大小', 'XKW-PHYS-42671', '2', 4, '2', '0', 'admin', now(), 'xkw:42671'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42641'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42671');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'E-x图像', 'XKW-PHYS-230218', '2', 1, '2', '0', 'admin', now(), 'xkw:230218'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230217'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230218');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'Ep-x图像', 'XKW-PHYS-166913', '2', 2, '2', '0', 'admin', now(), 'xkw:166913'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230217'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-166913');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'ψ-x图像', 'XKW-PHYS-42650', '2', 3, '2', '0', 'admin', now(), 'xkw:42650'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230217'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42650');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电场中的其他图像问题', 'XKW-PHYS-230219', '2', 4, '2', '0', 'admin', now(), 'xkw:230219'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230217'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230219');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容的概念、定义式、单位和物理意义', 'XKW-PHYS-42690', '2', 1, '2', '0', 'admin', now(), 'xkw:42690'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42684'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42690');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '利用电容定义式计算两极板的电势差和电量', 'XKW-PHYS-42691', '2', 2, '2', '0', 'admin', now(), 'xkw:42691'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42684'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42691');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器的Q-U图像', 'XKW-PHYS-42692', '2', 3, '2', '0', 'admin', now(), 'xkw:42692'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42684'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42692');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器的额定电压与击穿电压', 'XKW-PHYS-42693', '2', 4, '2', '0', 'admin', now(), 'xkw:42693'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42684'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42693');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平板电容器电容的决定式', 'XKW-PHYS-42694', '2', 1, '2', '0', 'admin', now(), 'xkw:42694'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42685'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42694');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电介质对电容器电容的影响', 'XKW-PHYS-42695', '2', 2, '2', '0', 'admin', now(), 'xkw:42695'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42685'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42695');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平板电容器中的电场强度', 'XKW-PHYS-42696', '2', 3, '2', '0', 'admin', now(), 'xkw:42696'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42685'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42696');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '平行板电容器中某一点的电势', 'XKW-PHYS-42697', '2', 4, '2', '0', 'admin', now(), 'xkw:42697'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42685'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42697');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器内的受力平衡问题', 'XKW-PHYS-230220', '2', 5, '2', '0', 'admin', now(), 'xkw:230220'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42685'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230220');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器的动态分析(U不变）', 'XKW-PHYS-42699', '2', 1, '2', '0', 'admin', now(), 'xkw:42699'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42686'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42699');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器的动态分析(Q不变）', 'XKW-PHYS-42700', '2', 2, '2', '0', 'admin', now(), 'xkw:42700'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42686'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42700');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器内部的电势随电容的变化', 'XKW-PHYS-42701', '2', 3, '2', '0', 'admin', now(), 'xkw:42701'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42686'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42701');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器与静电计组合的动态分析', 'XKW-PHYS-42702', '2', 4, '2', '0', 'admin', now(), 'xkw:42702'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42686'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42702');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器串并联问题', 'XKW-PHYS-42703', '2', 5, '2', '0', 'admin', now(), 'xkw:42703'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42686'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42703');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在匀强电场中做直线运动', 'XKW-PHYS-42713', '2', 1, '2', '0', 'admin', now(), 'xkw:42713'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42708'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42713');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在周期性变化电场中做直线运动', 'XKW-PHYS-42714', '2', 2, '2', '0', 'admin', now(), 'xkw:42714'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42708'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42714');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在匀强电场中做类抛体运动的相关计算', 'XKW-PHYS-42721', '2', 1, '2', '0', 'admin', now(), 'xkw:42721'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42711'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42721');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子离开匀强电场时方向的反向延长线经过极板中点', 'XKW-PHYS-42722', '2', 2, '2', '0', 'admin', now(), 'xkw:42722'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42711'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42722');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在周期性变化的电场运动（初速度垂直电场）', 'XKW-PHYS-42723', '2', 3, '2', '0', 'admin', now(), 'xkw:42723'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42711'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42723');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '在匀强电场中做非平抛曲线运动', 'XKW-PHYS-179622', '2', 4, '2', '0', 'admin', now(), 'xkw:179622'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42711'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-179622');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在径向电场中的运动', 'XKW-PHYS-166914', '2', 5, '2', '0', 'admin', now(), 'xkw:166914'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42711'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-166914');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电物体（计重力）在电场中的平衡问题', 'XKW-PHYS-127891', '2', 1, '2', '0', 'admin', now(), 'xkw:127891'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42710'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-127891');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电物体（计重力）在匀强电场中的直线运动', 'XKW-PHYS-42718', '2', 2, '2', '0', 'admin', now(), 'xkw:42718'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42710'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42718');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电物体（计重力）在匀强电场中的圆周运动', 'XKW-PHYS-42719', '2', 3, '2', '0', 'admin', now(), 'xkw:42719'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42710'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42719');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电物体（计重力）在匀强电场中的一般运动', 'XKW-PHYS-42720', '2', 4, '2', '0', 'admin', now(), 'xkw:42720'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42710'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42720');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电物体（计重力）在非匀强电场中的直线运动', 'XKW-PHYS-173695', '2', 5, '2', '0', 'admin', now(), 'xkw:173695'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42710'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-173695');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电物体（计重力）在非匀强电场中的一般运动', 'XKW-PHYS-173696', '2', 6, '2', '0', 'admin', now(), 'xkw:173696'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42710'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-173696');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '示波器的原理、用途与相关操作', 'XKW-PHYS-42724', '2', 1, '2', '0', 'admin', now(), 'xkw:42724'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42712'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42724');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '示波器的相关计算', 'XKW-PHYS-42725', '2', 2, '2', '0', 'admin', now(), 'xkw:42725'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42712'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42725');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '根据示波器原理推断荧光屏上图像', 'XKW-PHYS-42726', '2', 3, '2', '0', 'admin', now(), 'xkw:42726'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42712'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42726');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '欧姆定律的内容、表达式及初步应用', 'XKW-PHYS-42746', '2', 1, '2', '0', 'admin', now(), 'xkw:42746'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42741'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42746');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '线性元件的伏安特性曲线', 'XKW-PHYS-42747', '2', 2, '2', '0', 'admin', now(), 'xkw:42747'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42741'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42747');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '非线性元件的伏安特性曲线', 'XKW-PHYS-42748', '2', 3, '2', '0', 'admin', now(), 'xkw:42748'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42741'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42748');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流表内接', 'XKW-PHYS-234857', '2', 4, '2', '0', 'admin', now(), 'xkw:234857'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42741'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-234857');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流表外接', 'XKW-PHYS-234858', '2', 5, '2', '0', 'admin', now(), 'xkw:234858'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42741'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-234858');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算电阻串联或并联时的电压、电流和电阻', 'XKW-PHYS-42749', '2', 1, '2', '0', 'admin', now(), 'xkw:42749'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208024'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42749');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算电阻混联时的电压、电流和电阻', 'XKW-PHYS-42750', '2', 2, '2', '0', 'admin', now(), 'xkw:42750'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208024'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42750');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '滑动变阻器的限流接法', 'XKW-PHYS-42751', '2', 3, '2', '0', 'admin', now(), 'xkw:42751'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208024'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42751');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '滑动变阻器的分压接法', 'XKW-PHYS-42752', '2', 4, '2', '0', 'admin', now(), 'xkw:42752'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208024'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42752');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '灵敏电流计改装成电流表', 'XKW-PHYS-42759', '2', 1, '2', '0', 'admin', now(), 'xkw:42759'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42744'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42759');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '灵敏电流计改装成电压表', 'XKW-PHYS-42760', '2', 2, '2', '0', 'admin', now(), 'xkw:42760'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42744'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42760');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电表的校准原理及其电路', 'XKW-PHYS-42761', '2', 3, '2', '0', 'admin', now(), 'xkw:42761'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42744'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42761');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁现象、磁性和磁极、磁性材料', 'XKW-PHYS-42853', '2', 1, '2', '0', 'admin', now(), 'xkw:42853'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42853');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁感线的概念与特征', 'XKW-PHYS-42854', '2', 2, '2', '0', 'admin', now(), 'xkw:42854'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42847'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42854');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁感应强度的定义（式）', 'XKW-PHYS-42858', '2', 1, '2', '0', 'admin', now(), 'xkw:42858'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42848'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42858');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁感应强度的矢量性与叠加', 'XKW-PHYS-42859', '2', 2, '2', '0', 'admin', now(), 'xkw:42859'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42848'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42859');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁感线与小磁针的偏转', 'XKW-PHYS-42861', '2', 1, '2', '0', 'admin', now(), 'xkw:42861'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42861');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '地磁场及其磁感线分布', 'XKW-PHYS-42855', '2', 2, '2', '0', 'admin', now(), 'xkw:42855'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42855');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '条形磁铁和蹄形磁铁', 'XKW-PHYS-42862', '2', 3, '2', '0', 'admin', now(), 'xkw:42862'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42862');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '匀强磁场', 'XKW-PHYS-42863', '2', 4, '2', '0', 'admin', now(), 'xkw:42863'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42849'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42863');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁通量的定义（式）', 'XKW-PHYS-42864', '2', 1, '2', '0', 'admin', now(), 'xkw:42864'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42850'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42864');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算磁通量的大小', 'XKW-PHYS-42865', '2', 2, '2', '0', 'admin', now(), 'xkw:42865'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42850'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42865');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算磁通量的变化量', 'XKW-PHYS-42866', '2', 3, '2', '0', 'admin', now(), 'xkw:42866'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42850'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42866');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '奥斯特实验与安培定则', 'XKW-PHYS-42867', '2', 1, '2', '0', 'admin', now(), 'xkw:42867'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42851'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42867');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '直线电流周围的磁场', 'XKW-PHYS-42868', '2', 2, '2', '0', 'admin', now(), 'xkw:42868'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42851'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42868');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '环形电流和通电螺线管周围的磁场', 'XKW-PHYS-42869', '2', 3, '2', '0', 'admin', now(), 'xkw:42869'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42851'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42869');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '左手定则的内容及初步应用', 'XKW-PHYS-165284', '2', 1, '2', '0', 'admin', now(), 'xkw:165284'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42872'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-165284');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '两根通电导线之间的作用力方向', 'XKW-PHYS-42877', '2', 2, '2', '0', 'admin', now(), 'xkw:42877'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42872'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42877');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '通电导线在磁场中的作用力方向', 'XKW-PHYS-42878', '2', 3, '2', '0', 'admin', now(), 'xkw:42878'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42872'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42878');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断通电直导线在磁场中的运动趋势', 'XKW-PHYS-42879', '2', 4, '2', '0', 'admin', now(), 'xkw:42879'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42872'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42879');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '安培力的计算式及初步应用', 'XKW-PHYS-42880', '2', 1, '2', '0', 'admin', now(), 'xkw:42880'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42873'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42880');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算非直导线的安培力大小', 'XKW-PHYS-42881', '2', 2, '2', '0', 'admin', now(), 'xkw:42881'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42873'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42881');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算安培力的冲量', 'XKW-PHYS-42882', '2', 3, '2', '0', 'admin', now(), 'xkw:42882'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42873'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42882');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '斜轨道上的导体棒受力分析', 'XKW-PHYS-42883', '2', 4, '2', '0', 'admin', now(), 'xkw:42883'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42873'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42883');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁炮', 'XKW-PHYS-42884', '2', 5, '2', '0', 'admin', now(), 'xkw:42884'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42873'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42884');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '直流电动机', 'XKW-PHYS-42885', '2', 6, '2', '0', 'admin', now(), 'xkw:42885'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42873'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42885');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '洛伦兹力的公式及初步应用', 'XKW-PHYS-42887', '2', 1, '2', '0', 'admin', now(), 'xkw:42887'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208027'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42887');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '推导洛伦兹力与安培力的关系', 'XKW-PHYS-42888', '2', 2, '2', '0', 'admin', now(), 'xkw:42888'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208027'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42888');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在匀强磁场中的圆周运动：半径、周期公式', 'XKW-PHYS-42895', '2', 1, '2', '0', 'admin', now(), 'xkw:42895'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42891'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42895');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在磁场中做圆周运动的相关计算', 'XKW-PHYS-42896', '2', 2, '2', '0', 'admin', now(), 'xkw:42896'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42891'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42896');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在直导线周围的运动', 'XKW-PHYS-42897', '2', 1, '2', '0', 'admin', now(), 'xkw:42897'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42897');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电微粒（计重力）在磁场中的运动', 'XKW-PHYS-42898', '2', 2, '2', '0', 'admin', now(), 'xkw:42898'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42892'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42898');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在直边界磁场中运动', 'XKW-PHYS-42900', '2', 1, '2', '0', 'admin', now(), 'xkw:42900'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42900');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在矩形边界磁场中的运动', 'XKW-PHYS-230951', '2', 2, '2', '0', 'admin', now(), 'xkw:230951'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230951');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在三角形边界磁场中的运动', 'XKW-PHYS-230952', '2', 3, '2', '0', 'admin', now(), 'xkw:230952'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230952');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在圆（弧）形边界磁场中运动', 'XKW-PHYS-42901', '2', 4, '2', '0', 'admin', now(), 'xkw:42901'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42901');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在多个组合边界磁场中的运动', 'XKW-PHYS-230953', '2', 5, '2', '0', 'admin', now(), 'xkw:230953'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230953');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '根据粒子运动确定磁场区域的范围', 'XKW-PHYS-42902', '2', 6, '2', '0', 'admin', now(), 'xkw:42902'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42893'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42902');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子电性不确定形成的多解', 'XKW-PHYS-42903', '2', 1, '2', '0', 'admin', now(), 'xkw:42903'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42894'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42903');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁场方向的不确定形成的多解', 'XKW-PHYS-42904', '2', 2, '2', '0', 'admin', now(), 'xkw:42904'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42894'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42904');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '临界状态的不唯一形成多解', 'XKW-PHYS-42905', '2', 3, '2', '0', 'admin', now(), 'xkw:42905'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42894'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42905');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '动态圆模型', 'XKW-PHYS-230954', '2', 4, '2', '0', 'admin', now(), 'xkw:230954'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42894'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230954');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '回旋加速器的原理', 'XKW-PHYS-42924', '2', 1, '2', '0', 'admin', now(), 'xkw:42924'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42911'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42924');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '粒子在回旋加速器中的最大动能', 'XKW-PHYS-42925', '2', 2, '2', '0', 'admin', now(), 'xkw:42925'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42911'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42925');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '粒子在回旋加速器中的运动时间', 'XKW-PHYS-42926', '2', 3, '2', '0', 'admin', now(), 'xkw:42926'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42911'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42926');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '回旋加速器中电场变化的周期', 'XKW-PHYS-42927', '2', 4, '2', '0', 'admin', now(), 'xkw:42927'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42911'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42927');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '回旋加速器的综合计算', 'XKW-PHYS-42928', '2', 5, '2', '0', 'admin', now(), 'xkw:42928'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42911'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42928');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '霍尔效应的原理', 'XKW-PHYS-42921', '2', 1, '2', '0', 'admin', now(), 'xkw:42921'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42910'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42921');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '霍尔效应的相关计算', 'XKW-PHYS-42922', '2', 2, '2', '0', 'admin', now(), 'xkw:42922'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42910'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42922');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '霍尔元件的应用', 'XKW-PHYS-42923', '2', 3, '2', '0', 'admin', now(), 'xkw:42923'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42910'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42923');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁流体发电机的原理', 'XKW-PHYS-42917', '2', 1, '2', '0', 'admin', now(), 'xkw:42917'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42917');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁流体发电机的相关计算', 'XKW-PHYS-42918', '2', 2, '2', '0', 'admin', now(), 'xkw:42918'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42908'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42918');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁流量计的原理', 'XKW-PHYS-42919', '2', 1, '2', '0', 'admin', now(), 'xkw:42919'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42919');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁流量计的相关计算', 'XKW-PHYS-42920', '2', 2, '2', '0', 'admin', now(), 'xkw:42920'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42909'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42920');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '粒子由磁场进入电场', 'XKW-PHYS-42929', '2', 1, '2', '0', 'admin', now(), 'xkw:42929'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42912'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42929');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '粒子由电场进入磁场', 'XKW-PHYS-42930', '2', 2, '2', '0', 'admin', now(), 'xkw:42930'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42912'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42930');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '粒子在电场和磁场中的往复运动', 'XKW-PHYS-42931', '2', 3, '2', '0', 'admin', now(), 'xkw:42931'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42912'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42931');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在交变磁场中的运动', 'XKW-PHYS-153444', '2', 4, '2', '0', 'admin', now(), 'xkw:153444'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42912'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153444');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在组合场中含动量问题', 'XKW-PHYS-168733', '2', 5, '2', '0', 'admin', now(), 'xkw:168733'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42912'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168733');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在组合场中的立体空间问题', 'XKW-PHYS-230955', '2', 6, '2', '0', 'admin', now(), 'xkw:230955'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42912'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230955');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在叠加场中做直线运动', 'XKW-PHYS-42932', '2', 1, '2', '0', 'admin', now(), 'xkw:42932'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42913'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42932');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在叠加场中做匀速圆周运动', 'XKW-PHYS-42933', '2', 2, '2', '0', 'admin', now(), 'xkw:42933'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42913'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42933');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在叠加场中的变速圆周运动', 'XKW-PHYS-42934', '2', 3, '2', '0', 'admin', now(), 'xkw:42934'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42913'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42934');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在叠加场中做旋进运动', 'XKW-PHYS-42935', '2', 4, '2', '0', 'admin', now(), 'xkw:42935'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42913'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42935');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在叠加场中的一般曲线运动', 'XKW-PHYS-42936', '2', 5, '2', '0', 'admin', now(), 'xkw:42936'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42913'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42936');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电视显像管的工作原理', 'XKW-PHYS-42937', '2', 6, '2', '0', 'admin', now(), 'xkw:42937'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42913'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42937');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在叠加场中含动量问题', 'XKW-PHYS-168734', '2', 7, '2', '0', 'admin', now(), 'xkw:168734'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42913'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-168734');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '带电粒子在叠加场中的立体空间问题', 'XKW-PHYS-230956', '2', 8, '2', '0', 'admin', now(), 'xkw:230956'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42913'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230956');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '楞次定律的内容及理解', 'XKW-PHYS-42959', '2', 1, '2', '0', 'admin', now(), 'xkw:42959'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42959');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '增反减同', 'XKW-PHYS-42960', '2', 2, '2', '0', 'admin', now(), 'xkw:42960'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42960');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '来拒去留', 'XKW-PHYS-42961', '2', 3, '2', '0', 'admin', now(), 'xkw:42961'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42961');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '增缩减扩', 'XKW-PHYS-42962', '2', 4, '2', '0', 'admin', now(), 'xkw:42962'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42955'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42962');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '法拉第电磁感应定律的表述和表达式', 'XKW-PHYS-42967', '2', 1, '2', '0', 'admin', now(), 'xkw:42967'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42964'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42967');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '磁通量的变化量与变化率', 'XKW-PHYS-42968', '2', 2, '2', '0', 'admin', now(), 'xkw:42968'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42964'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42968');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '导体棒平动切割磁感线', 'XKW-PHYS-42969', '2', 1, '2', '0', 'admin', now(), 'xkw:42969'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42965'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42969');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '导体棒转动切割磁感线', 'XKW-PHYS-153445', '2', 2, '2', '0', 'admin', now(), 'xkw:153445'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42965'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153445');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '已知磁感应强度随时间的变化的关系式求电动势', 'XKW-PHYS-42973', '2', 1, '2', '0', 'admin', now(), 'xkw:42973'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42966'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42973');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '由B-t图像计算感生电动势的大小', 'XKW-PHYS-42974', '2', 2, '2', '0', 'admin', now(), 'xkw:42974'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42966'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42974');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '小球在感生电场中的运动', 'XKW-PHYS-42975', '2', 3, '2', '0', 'admin', now(), 'xkw:42975'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42966'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42975');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '感生电动势与动生电动势并存', 'XKW-PHYS-42976', '2', 4, '2', '0', 'admin', now(), 'xkw:42976'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42966'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42976');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '线框进出磁场产生的等效电路相关计算', 'XKW-PHYS-42980', '2', 1, '2', '0', 'admin', now(), 'xkw:42980'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42977'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42980');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '描绘线框两点间电势差的U-t图像', 'XKW-PHYS-42981', '2', 2, '2', '0', 'admin', now(), 'xkw:42981'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42977'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42981');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '描绘线框进出磁场区域的I-t图像', 'XKW-PHYS-42982', '2', 3, '2', '0', 'admin', now(), 'xkw:42982'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42977'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42982');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断线框进出磁场区域的a-t图像', 'XKW-PHYS-42983', '2', 4, '2', '0', 'admin', now(), 'xkw:42983'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42977'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42983');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '求线框进出磁场时电阻上生热', 'XKW-PHYS-42984', '2', 5, '2', '0', 'admin', now(), 'xkw:42984'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42977'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42984');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '求线框进出磁场时通过导体截面的电量', 'XKW-PHYS-42985', '2', 6, '2', '0', 'admin', now(), 'xkw:42985'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42977'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42985');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '无外力作用下，水平导轨上的单杆模型', 'XKW-PHYS-42986', '2', 1, '2', '0', 'admin', now(), 'xkw:42986'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208029'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42986');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有外力作用下，水平导轨上的单杆模型', 'XKW-PHYS-42987', '2', 2, '2', '0', 'admin', now(), 'xkw:42987'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208029'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42987');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有电源存在的导轨单杆模型', 'XKW-PHYS-42990', '2', 3, '2', '0', 'admin', now(), 'xkw:42990'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208029'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42990');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含有电容器的导轨单杆模型', 'XKW-PHYS-42988', '2', 4, '2', '0', 'admin', now(), 'xkw:42988'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208029'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42988');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '竖直平面内的导轨单杆模型', 'XKW-PHYS-42989', '2', 5, '2', '0', 'admin', now(), 'xkw:42989'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208029'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42989');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '倾斜平面内的导轨单杆模型', 'XKW-PHYS-42991', '2', 6, '2', '0', 'admin', now(), 'xkw:42991'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208029'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42991');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '双杆在等宽导轨上运动问题', 'XKW-PHYS-42992', '2', 1, '2', '0', 'admin', now(), 'xkw:42992'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42992');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '双杆在不等宽导轨上运动问题', 'XKW-PHYS-42993', '2', 2, '2', '0', 'admin', now(), 'xkw:42993'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-208030'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42993');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自感和自感电动势', 'XKW-PHYS-42997', '2', 1, '2', '0', 'admin', now(), 'xkw:42997'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42994'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42997');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '线圈的自感系数', 'XKW-PHYS-42998', '2', 2, '2', '0', 'admin', now(), 'xkw:42998'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42994'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42998');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '根据公式计算自感电动势', 'XKW-PHYS-42999', '2', 3, '2', '0', 'admin', now(), 'xkw:42999'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42994'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-42999');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含自感线圈的电路闭合及断开后电流的变化及其图像', 'XKW-PHYS-43000', '2', 4, '2', '0', 'admin', now(), 'xkw:43000'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42994'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43000');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '判断灯泡是否闪亮', 'XKW-PHYS-43001', '2', 5, '2', '0', 'admin', now(), 'xkw:43001'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42994'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43001');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '日光灯镇流器的原理和作用', 'XKW-PHYS-43002', '2', 6, '2', '0', 'admin', now(), 'xkw:43002'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42994'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43002');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '互感', 'XKW-PHYS-43003', '2', 7, '2', '0', 'admin', now(), 'xkw:43003'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42994'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43003');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '涡流的原理、应用与防止', 'XKW-PHYS-43004', '2', 1, '2', '0', 'admin', now(), 'xkw:43004'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42995'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43004');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁灶的结构和原理', 'XKW-PHYS-43005', '2', 2, '2', '0', 'admin', now(), 'xkw:43005'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42995'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43005');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '安检警报器结构和原理', 'XKW-PHYS-43006', '2', 3, '2', '0', 'admin', now(), 'xkw:43006'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42995'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43006');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁驱动', 'XKW-PHYS-43010', '2', 1, '2', '0', 'admin', now(), 'xkw:43010'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43010');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电磁阻尼', 'XKW-PHYS-43007', '2', 2, '2', '0', 'admin', now(), 'xkw:43007'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-42996'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43007');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交流电的u-t图像和i-t图像', 'XKW-PHYS-43028', '2', 1, '2', '0', 'admin', now(), 'xkw:43028'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43028');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流的Φ-t图像', 'XKW-PHYS-43029', '2', 2, '2', '0', 'admin', now(), 'xkw:43029'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43023'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43029');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流的频率', 'XKW-PHYS-43030', '2', 1, '2', '0', 'admin', now(), 'xkw:43030'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43024'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43030');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流的峰值', 'XKW-PHYS-43031', '2', 2, '2', '0', 'admin', now(), 'xkw:43031'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43024'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43031');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '正弦式交变电流瞬时值的表达式及其推导', 'XKW-PHYS-43033', '2', 1, '2', '0', 'admin', now(), 'xkw:43033'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43025'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43033');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算氖灯泡/霓虹灯等灯泡的发光时间和次数', 'XKW-PHYS-43039', '2', 2, '2', '0', 'admin', now(), 'xkw:43039'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43025'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43039');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '有效值的定义、一般交流电的有效值', 'XKW-PHYS-43040', '2', 1, '2', '0', 'admin', now(), 'xkw:43040'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43040');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '正弦式交流电的电动势和电流有效值', 'XKW-PHYS-43041', '2', 2, '2', '0', 'admin', now(), 'xkw:43041'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43041');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电表示数的含义、铭牌上的额定电压', 'XKW-PHYS-43042', '2', 3, '2', '0', 'admin', now(), 'xkw:43042'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43042');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算交变流电路中的电功、电功率和焦耳热', 'XKW-PHYS-43043', '2', 4, '2', '0', 'admin', now(), 'xkw:43043'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43043');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '交变电流在家庭电路中的应用', 'XKW-PHYS-43045', '2', 5, '2', '0', 'admin', now(), 'xkw:43045'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43026'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43045');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算线圈转动过程中电动势和电流的平均值', 'XKW-PHYS-43047', '2', 1, '2', '0', 'admin', now(), 'xkw:43047'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43027'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43047');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算转动过程中通过线圈截面的电量', 'XKW-PHYS-43048', '2', 2, '2', '0', 'admin', now(), 'xkw:43048'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43027'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43048');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电容器对交流电的导通和阻碍作用', 'XKW-PHYS-43055', '2', 1, '2', '0', 'admin', now(), 'xkw:43055'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43050'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43055');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '含有电感器和电容器的滤波电路', 'XKW-PHYS-43059', '2', 2, '2', '0', 'admin', now(), 'xkw:43059'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43050'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43059');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变压器原理与结构', 'XKW-PHYS-43063', '2', 1, '2', '0', 'admin', now(), 'xkw:43063'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43060'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43063');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理想变压器两端电压与匝数的关系', 'XKW-PHYS-43064', '2', 2, '2', '0', 'admin', now(), 'xkw:43064'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43060'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43064');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理想变压器两端功率的计算', 'XKW-PHYS-43065', '2', 3, '2', '0', 'admin', now(), 'xkw:43065'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43060'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43065');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理想变压器原副线圈的电流关系及其推导', 'XKW-PHYS-43066', '2', 4, '2', '0', 'admin', now(), 'xkw:43066'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43060'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43066');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变压器两端电路的动态分析', 'XKW-PHYS-43067', '2', 5, '2', '0', 'admin', now(), 'xkw:43067'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43060'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43067');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '变压器原副线圈频率和相位的关系', 'XKW-PHYS-43069', '2', 6, '2', '0', 'admin', now(), 'xkw:43069'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43060'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43069');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '自耦变压器', 'XKW-PHYS-43070', '2', 1, '2', '0', 'admin', now(), 'xkw:43070'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43061'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43070');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电压互感器', 'XKW-PHYS-43071', '2', 2, '2', '0', 'admin', now(), 'xkw:43071'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43061'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43071');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '电流互感器', 'XKW-PHYS-43072', '2', 3, '2', '0', 'admin', now(), 'xkw:43072'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43061'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43072');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理解内能的概念', 'XKW-PHYS-43136', '2', 1, '2', '0', 'admin', now(), 'xkw:43136'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43108'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43136');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '内能与机械能的区别', 'XKW-PHYS-43137', '2', 2, '2', '0', 'admin', now(), 'xkw:43137'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43108'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43137');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '玻意耳定律的理解及初步应用', 'XKW-PHYS-43149', '2', 1, '2', '0', 'admin', now(), 'xkw:43149'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43142'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43149');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体等温变化的图象', 'XKW-PHYS-43150', '2', 2, '2', '0', 'admin', now(), 'xkw:43150'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43142'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43150');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '查理定律的理解及初步应用', 'XKW-PHYS-43152', '2', 1, '2', '0', 'admin', now(), 'xkw:43152'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43143'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43152');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体等容变化的图象', 'XKW-PHYS-43153', '2', 2, '2', '0', 'admin', now(), 'xkw:43153'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43143'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43153');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '盖-吕萨克定律的理解及初步应用', 'XKW-PHYS-43155', '2', 1, '2', '0', 'admin', now(), 'xkw:43155'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43144'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43155');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气体等压变化的图象', 'XKW-PHYS-43156', '2', 2, '2', '0', 'admin', now(), 'xkw:43156'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43144'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43156');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理想气体', 'XKW-PHYS-166298', '2', 1, '2', '0', 'admin', now(), 'xkw:166298'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43145'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-166298');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '理想气体的状态方程的理解及初步应用', 'XKW-PHYS-43158', '2', 2, '2', '0', 'admin', now(), 'xkw:43158'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43145'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43158');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“玻璃管液封”模型', 'XKW-PHYS-230959', '2', 1, '2', '0', 'admin', now(), 'xkw:230959'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230959');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“气缸活塞类”模型', 'XKW-PHYS-230960', '2', 2, '2', '0', 'admin', now(), 'xkw:230960'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230960');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '“变质量气体”模型', 'XKW-PHYS-230961', '2', 3, '2', '0', 'admin', now(), 'xkw:230961'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230961');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '关联气体模型', 'XKW-PHYS-230962', '2', 4, '2', '0', 'admin', now(), 'xkw:230962'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230962');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '汽缸和液柱组合模型', 'XKW-PHYS-230963', '2', 5, '2', '0', 'admin', now(), 'xkw:230963'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-230958'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-230963');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光电效应现象及其解释', 'XKW-PHYS-43307', '2', 1, '2', '0', 'admin', now(), 'xkw:43307'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43304'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43307');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '爱因斯坦光子说', 'XKW-PHYS-43313', '2', 2, '2', '0', 'admin', now(), 'xkw:43313'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43304'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43313');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '爱因斯坦光电效应方程', 'XKW-PHYS-43314', '2', 3, '2', '0', 'admin', now(), 'xkw:43314'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43304'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43314');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光电效应的瞬时性', 'XKW-PHYS-43311', '2', 4, '2', '0', 'admin', now(), 'xkw:43311'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43304'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43311');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光电效应的极限频率', 'XKW-PHYS-43308', '2', 5, '2', '0', 'admin', now(), 'xkw:43308'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43304'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43308');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光电子的最大初动能', 'XKW-PHYS-43310', '2', 6, '2', '0', 'admin', now(), 'xkw:43310'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43304'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43310');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '光电流及其影响因素', 'XKW-PHYS-43309', '2', 7, '2', '0', 'admin', now(), 'xkw:43309'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43304'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43309');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '遏止电压的本质及其决定因素', 'XKW-PHYS-43318', '2', 8, '2', '0', 'admin', now(), 'xkw:43318'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43304'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43318');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '天然放射现象的发现过程', 'XKW-PHYS-43369', '2', 1, '2', '0', 'admin', now(), 'xkw:43369'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43367'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43369');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '放射性元素与放射性现象', 'XKW-PHYS-43370', '2', 2, '2', '0', 'admin', now(), 'xkw:43370'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43367'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43370');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'α和β、γ三种射线的性质', 'XKW-PHYS-153446', '2', 1, '2', '0', 'admin', now(), 'xkw:153446'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43376'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-153446');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'α衰变的特点、本质及其方程的写法', 'XKW-PHYS-43381', '2', 2, '2', '0', 'admin', now(), 'xkw:43381'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43376'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43381');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, 'β衰变的特点、本质及其方程的写法', 'XKW-PHYS-43382', '2', 3, '2', '0', 'admin', now(), 'xkw:43382'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43376'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43382');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '计算发生α衰变和β衰变的次数', 'XKW-PHYS-43383', '2', 4, '2', '0', 'admin', now(), 'xkw:43383'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43376'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43383');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '半衰期的概念', 'XKW-PHYS-43384', '2', 1, '2', '0', 'admin', now(), 'xkw:43384'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43377'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43384');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '半衰期相关的计算', 'XKW-PHYS-43385', '2', 2, '2', '0', 'admin', now(), 'xkw:43385'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43377'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43385');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '发现质子和中子的核反应', 'XKW-PHYS-43386', '2', 1, '2', '0', 'admin', now(), 'xkw:43386'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43386');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核反应方程的书写', 'XKW-PHYS-43387', '2', 2, '2', '0', 'admin', now(), 'xkw:43387'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43387');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '人工放射性同位素', 'XKW-PHYS-43388', '2', 3, '2', '0', 'admin', now(), 'xkw:43388'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43378'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43388');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '威尔逊云室', 'XKW-PHYS-43389', '2', 1, '2', '0', 'admin', now(), 'xkw:43389'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43389');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '气泡室', 'XKW-PHYS-43390', '2', 2, '2', '0', 'admin', now(), 'xkw:43390'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43390');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '盖革-米勒计数器', 'XKW-PHYS-43391', '2', 3, '2', '0', 'admin', now(), 'xkw:43391'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43379'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43391');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '放射性同位素的应用', 'XKW-PHYS-43392', '2', 1, '2', '0', 'admin', now(), 'xkw:43392'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43392');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time, remark)
SELECT p.subject_id, p.knowledge_id, CASE WHEN p.ancestors IS NULL OR p.ancestors = '' THEN '0,' || p.knowledge_id::varchar ELSE p.ancestors || ',' || p.knowledge_id::varchar END, '核辐射和安全', 'XKW-PHYS-43393', '2', 2, '2', '0', 'admin', now(), 'xkw:43393'
FROM spas_knowledge p
WHERE p.knowledge_code = 'XKW-PHYS-43380'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'XKW-PHYS-43393');
