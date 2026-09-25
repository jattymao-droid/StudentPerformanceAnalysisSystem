-- PHYS demo subject + prerequisite edges (idempotent). from = prerequisite of to.
-- Aligns with MATH edge seed pattern for compact demo trees.

-- 0) Subject
INSERT INTO spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
SELECT 'PHYS', U&'\7269\7406', 2, '0', 'admin', now()
WHERE NOT EXISTS (SELECT 1 FROM spas_subject WHERE subject_code = 'PHYS');

-- 1) Compact leaves: 力学 / 电学
INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\529b\5b66', 'PHYS-MECH', '2', 1, '2', '0', 'admin', now()
FROM spas_subject s
WHERE s.subject_code = 'PHYS'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'PHYS-MECH');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT s.subject_id, 0, '0', U&'\7535\5b66', 'PHYS-ELEC', '2', 2, '2', '0', 'admin', now()
FROM spas_subject s
WHERE s.subject_code = 'PHYS'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge k WHERE k.knowledge_code = 'PHYS-ELEC');

-- 2) Compact edge: 力学 -> 电学（演示跨章依赖）
INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'PHYS demo: MECH -> ELEC'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'PHYS-MECH'
  AND t.knowledge_code = 'PHYS-ELEC'
  AND coalesce(f.node_type, '2') = '2'
  AND coalesce(t.node_type, '2') = '2'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id
      AND e.to_knowledge_id = t.knowledge_id
      AND e.relation = 'prerequisite'
  );

-- 3) Finer leaves under mechanics / electricity
INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\8fd0\52a8\5b66', 'PHYS-MECH-KIN', '2', 1, '2', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code = 'PHYS-MECH'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'PHYS-MECH-KIN');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\529b\4e0e\725b\987f', 'PHYS-MECH-FORCE', '2', 2, '2', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code = 'PHYS-MECH'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'PHYS-MECH-FORCE');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\7535\8def', 'PHYS-ELEC-CIR', '2', 1, '2', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code = 'PHYS-ELEC'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'PHYS-ELEC-CIR');

INSERT INTO spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, node_type, order_num, difficulty_default, status, create_by, create_time)
SELECT p.subject_id, p.knowledge_id, '0,' || p.knowledge_id::varchar, U&'\7535\529f\7387', 'PHYS-ELEC-PWR', '2', 2, '3', '0', 'admin', now()
FROM spas_knowledge p
WHERE p.knowledge_code = 'PHYS-ELEC'
  AND NOT EXISTS (SELECT 1 FROM spas_knowledge x WHERE x.knowledge_code = 'PHYS-ELEC-PWR');

-- 4) Finer edges: 运动学 -> 力与牛顿；电路 -> 电功率
INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'PHYS demo: KIN -> FORCE'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'PHYS-MECH-KIN'
  AND t.knowledge_code = 'PHYS-MECH-FORCE'
  AND coalesce(f.node_type, '2') = '2'
  AND coalesce(t.node_type, '2') = '2'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id
      AND e.to_knowledge_id = t.knowledge_id
      AND e.relation = 'prerequisite'
  );

INSERT INTO spas_knowledge_edge(subject_id, from_knowledge_id, to_knowledge_id, relation, weight, status, create_by, create_time, remark)
SELECT f.subject_id, f.knowledge_id, t.knowledge_id, 'prerequisite', 1.0000, '0', 'admin', now(), 'PHYS demo: CIR -> PWR'
FROM spas_knowledge f
JOIN spas_knowledge t ON t.subject_id = f.subject_id
WHERE f.knowledge_code = 'PHYS-ELEC-CIR'
  AND t.knowledge_code = 'PHYS-ELEC-PWR'
  AND coalesce(f.node_type, '2') = '2'
  AND coalesce(t.node_type, '2') = '2'
  AND NOT EXISTS (
    SELECT 1 FROM spas_knowledge_edge e
    WHERE e.from_knowledge_id = f.knowledge_id
      AND e.to_knowledge_id = t.knowledge_id
      AND e.relation = 'prerequisite'
  );
