-- D1: add experiment question type per subject (idempotent)
INSERT INTO spas_subject_question_type(subject_id, type_code, type_name, sort, status, create_by, create_time)
SELECT s.subject_id, 'experiment', U&'\5b9e\9a8c\9898', 7, '0', 'admin', now()
FROM spas_subject s
WHERE NOT EXISTS (
  SELECT 1 FROM spas_subject_question_type t
  WHERE t.subject_id = s.subject_id AND t.type_code = 'experiment'
);
