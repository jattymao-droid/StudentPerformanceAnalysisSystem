-- Demo: subject MATH with chapter tree + leaf knowledge points
-- PostgreSQL unicode: U&'\XXXX' (no leading u)

ALTER TABLE spas_knowledge ADD COLUMN IF NOT EXISTS node_type char(1) DEFAULT '2';

UPDATE spas_knowledge k
SET node_type = '1'
WHERE k.knowledge_code IN ('MATH-ALG', 'MATH-GEO')
  AND k.parent_id = 0
  AND NOT EXISTS (SELECT 1 FROM spas_question_knowledge qk WHERE qk.knowledge_id = k.knowledge_id);

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\4e00\5143\4e00\6b21\65b9\7a0b', 'MATH-ALG-EQ', '2', 1, '2', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code = 'MATH-ALG' AND p.node_type = '1'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'MATH-ALG-EQ');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\56e0\5f0f\5206\89e3', 'MATH-ALG-FAC', '2', 2, '2', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code = 'MATH-ALG' AND p.node_type = '1'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'MATH-ALG-FAC');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\4e09\89d2\5f62', 'MATH-GEO-TRI', '2', 1, '2', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code = 'MATH-GEO' AND p.node_type = '1'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'MATH-GEO-TRI');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\5706', 'MATH-GEO-CIR', '2', 2, '3', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code = 'MATH-GEO' AND p.node_type = '1'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'MATH-GEO-CIR');

UPDATE spas_question_knowledge qk
SET knowledge_id = leaf.knowledge_id
FROM spas_knowledge ch
JOIN spas_knowledge leaf ON leaf.parent_id = ch.knowledge_id AND leaf.knowledge_code = 'MATH-ALG-EQ'
WHERE qk.knowledge_id = ch.knowledge_id
  AND ch.knowledge_code = 'MATH-ALG'
  AND ch.node_type = '1';

UPDATE spas_question_knowledge qk
SET knowledge_id = leaf.knowledge_id
FROM spas_knowledge ch
JOIN spas_knowledge leaf ON leaf.parent_id = ch.knowledge_id AND leaf.knowledge_code = 'MATH-GEO-TRI'
WHERE qk.knowledge_id = ch.knowledge_id
  AND ch.knowledge_code = 'MATH-GEO'
  AND ch.node_type = '1';

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\7b2c\4e00\7ae0 \4ee3\6570', 'MATH-CH-ALG', '1', 1, '2', '0', 'admin', now()
FROM spas_subject s
WHERE s.subject_code = 'MATH'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'MATH-CH-ALG')
  AND EXISTS (SELECT 1 FROM spas_knowledge a WHERE a.knowledge_code = 'MATH-ALG' AND coalesce(a.node_type,'2') = '2' AND a.parent_id = 0);

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\7b2c\4e8c\7ae0 \51e0\4f55', 'MATH-CH-GEO', '1', 2, '2', '0', 'admin', now()
FROM spas_subject s
WHERE s.subject_code = 'MATH'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'MATH-CH-GEO')
  AND EXISTS (SELECT 1 FROM spas_knowledge a WHERE a.knowledge_code = 'MATH-GEO' AND coalesce(a.node_type,'2') = '2' AND a.parent_id = 0);

UPDATE spas_knowledge k
SET parent_id = c.knowledge_id,
    ancestors = '0,' || c.knowledge_id::varchar,
    node_type = '2'
FROM spas_knowledge c
WHERE k.knowledge_code = 'MATH-ALG'
  AND c.knowledge_code = 'MATH-CH-ALG'
  AND k.parent_id = 0
  AND coalesce(k.node_type,'2') = '2';

UPDATE spas_knowledge k
SET parent_id = c.knowledge_id,
    ancestors = '0,' || c.knowledge_id::varchar,
    node_type = '2'
FROM spas_knowledge c
WHERE k.knowledge_code = 'MATH-GEO'
  AND c.knowledge_code = 'MATH-CH-GEO'
  AND k.parent_id = 0
  AND coalesce(k.node_type,'2') = '2';
