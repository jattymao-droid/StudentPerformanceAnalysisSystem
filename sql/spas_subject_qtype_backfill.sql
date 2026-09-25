-- Idempotent: ensure every active subject has default question types
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
