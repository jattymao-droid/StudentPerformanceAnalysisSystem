-- Multi-subject content packs (idempotent): CHN / ENG / CHEM
-- Compact knowledge tree + prerequisite edges + question types + thresholds via yml.

-- ========== 语文 CHN ==========
INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
SELECT 'CHN', U&'\8bed\6587', 3, '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'CHN');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\6587\8a00\6587', 'CHN-CLASSIC', '2', 1, '2', '0', 'admin', now()
FROM spas_subject s WHERE s.subject_code = 'CHN'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'CHN-CLASSIC');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\73b0\4ee3\6587\9605\8bfb', 'CHN-MODERN', '2', 2, '2', '0', 'admin', now()
FROM spas_subject s WHERE s.subject_code = 'CHN'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'CHN-MODERN');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\5199\4f5c', 'CHN-WRITE', '2', 3, '3', '0', 'admin', now()
FROM spas_subject s WHERE s.subject_code = 'CHN'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'CHN-WRITE');

INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'CHN: CLASSIC -> MODERN'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'CHN-CLASSIC' AND t.knowledge_code = 'CHN-MODERN'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id AND e.to_knowledge_id = t.knowledge_id AND e.relation = 'prerequisite'
  );

INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'CHN: MODERN -> WRITE'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'CHN-MODERN' AND t.knowledge_code = 'CHN-WRITE'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id AND e.to_knowledge_id = t.knowledge_id AND e.relation = 'prerequisite'
  );

-- ========== 英语 ENG ==========
INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
SELECT 'ENG', U&'\82f1\8bed', 4, '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'ENG');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\8bcd\6c47', 'ENG-VOCAB', '2', 1, '1', '0', 'admin', now()
FROM spas_subject s WHERE s.subject_code = 'ENG'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'ENG-VOCAB');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\8bed\6cd5', 'ENG-GRAM', '2', 2, '2', '0', 'admin', now()
FROM spas_subject s WHERE s.subject_code = 'ENG'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'ENG-GRAM');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\9605\8bfb', 'ENG-READ', '2', 3, '3', '0', 'admin', now()
FROM spas_subject s WHERE s.subject_code = 'ENG'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'ENG-READ');

INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'ENG: VOCAB -> GRAM'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'ENG-VOCAB' AND t.knowledge_code = 'ENG-GRAM'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id AND e.to_knowledge_id = t.knowledge_id AND e.relation = 'prerequisite'
  );

INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'ENG: GRAM -> READ'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'ENG-GRAM' AND t.knowledge_code = 'ENG-READ'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id AND e.to_knowledge_id = t.knowledge_id AND e.relation = 'prerequisite'
  );

-- ========== 化学 CHEM ==========
INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
SELECT 'CHEM', U&'\5316\5b66', 5, '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'CHEM');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\57fa\672c\6982\5ff5', 'CHEM-BASE', '2', 1, '2', '0', 'admin', now()
FROM spas_subject s WHERE s.subject_code = 'CHEM'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'CHEM-BASE');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\5316\5b66\53cd\5e94', 'CHEM-REACT', '2', 2, '2', '0', 'admin', now()
FROM spas_subject s WHERE s.subject_code = 'CHEM'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'CHEM-REACT');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\5b9e\9a8c', 'CHEM-LAB', '2', 3, '3', '0', 'admin', now()
FROM spas_subject s WHERE s.subject_code = 'CHEM'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'CHEM-LAB');

INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'CHEM: BASE -> REACT'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'CHEM-BASE' AND t.knowledge_code = 'CHEM-REACT'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id AND e.to_knowledge_id = t.knowledge_id AND e.relation = 'prerequisite'
  );

INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'CHEM: REACT -> LAB'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'CHEM-REACT' AND t.knowledge_code = 'CHEM-LAB'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id AND e.to_knowledge_id = t.knowledge_id AND e.relation = 'prerequisite'
  );

-- Default question types for any subject still missing them
INSERT INTO spas_subject_question_type(subject_id, type_code, type_name, sort, status, create_by, create_time)
SELECT s.subject_id, v.code, v.name, v.sort, '0', 'admin', now()
FROM spas_subject s
CROSS JOIN (VALUES
  ('single', U&'\5355\9009\9898', 1),
  ('multi',  U&'\591a\9009\9898', 2),
  ('judge',  U&'\5224\65ad\9898', 3),
  ('fill',   U&'\586b\7a7a\9898', 4),
  ('short',  U&'\7b80\7b54\9898', 5),
  ('calc',   U&'\8ba1\7b97\9898', 6)
) AS v(code, name, sort)
WHERE COALESCE(s.status, '0') = '0'
  AND NOT EXISTS (
    SELECT 1 FROM spas_subject_question_type t
    WHERE t.subject_id = s.subject_id AND t.type_code = v.code
  );
