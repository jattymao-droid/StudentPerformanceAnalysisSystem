-- MATH demo prerequisite edges (idempotent). from = prerequisite of to.
-- Works with both chapter-leaf trees and the compact demo (MATH-ALG / MATH-GEO leaves).

-- 1) Compact demo: 代数 -> 几何
INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'MATH demo: ALG -> GEO'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'MATH-ALG'
  AND t.knowledge_code = 'MATH-GEO'
  AND coalesce(f.node_type, '2') = '2'
  AND coalesce(t.node_type, '2') = '2'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id
      AND e.to_knowledge_id = t.knowledge_id
      AND e.relation = 'prerequisite'
  );

-- 2) Ensure finer leaves under chapter parents (no-op if already present)
INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\4e00\5143\4e00\6b21\65b9\7a0b', 'MATH-ALG-EQ', '2', 1, '2', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code IN ('MATH-ALG', 'MATH-CH-ALG')
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'MATH-ALG-EQ')
ORDER BY CASE WHEN p.knowledge_code = 'MATH-CH-ALG' THEN 0 ELSE 1 END
LIMIT 1;

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\56e0\5f0f\5206\89e3', 'MATH-ALG-FAC', '2', 2, '2', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code IN ('MATH-ALG', 'MATH-CH-ALG')
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'MATH-ALG-FAC')
ORDER BY CASE WHEN p.knowledge_code = 'MATH-CH-ALG' THEN 0 ELSE 1 END
LIMIT 1;

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\4e09\89d2\5f62', 'MATH-GEO-TRI', '2', 1, '2', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code IN ('MATH-GEO', 'MATH-CH-GEO')
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'MATH-GEO-TRI')
ORDER BY CASE WHEN p.knowledge_code = 'MATH-CH-GEO' THEN 0 ELSE 1 END
LIMIT 1;

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\5706', 'MATH-GEO-CIR', '2', 2, '3', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code IN ('MATH-GEO', 'MATH-CH-GEO')
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'MATH-GEO-CIR')
ORDER BY CASE WHEN p.knowledge_code = 'MATH-CH-GEO' THEN 0 ELSE 1 END
LIMIT 1;

-- 3) Finer edges when leaves exist
INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'MATH demo: EQ -> FAC'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'MATH-ALG-EQ'
  AND t.knowledge_code = 'MATH-ALG-FAC'
  AND coalesce(f.node_type, '2') = '2'
  AND coalesce(t.node_type, '2') = '2'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id
      AND e.to_knowledge_id = t.knowledge_id
      AND e.relation = 'prerequisite'
  );

INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'MATH demo: TRI -> CIR'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'MATH-GEO-TRI'
  AND t.knowledge_code = 'MATH-GEO-CIR'
  AND coalesce(f.node_type, '2') = '2'
  AND coalesce(t.node_type, '2') = '2'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id
      AND e.to_knowledge_id = t.knowledge_id
      AND e.relation = 'prerequisite'
  );
