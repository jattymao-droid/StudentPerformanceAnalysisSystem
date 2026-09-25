-- Migrate existing spas_exam_score: drop subject_id hard-bind, use subject_name from Excel

alter table spas_exam_score add column if not exists subject_name varchar(64);

update spas_exam_score s
set subject_name = sub.subject_name
from spas_subject sub
where s.subject_id is not null
  and s.subject_id = sub.subject_id
  and (s.subject_name is null or s.subject_name = '');

drop index if exists uk_spas_exam_score;

alter table spas_exam_score drop column if exists subject_id;

create unique index uk_spas_exam_score
  on spas_exam_score (exam_id, student_id, score_type, (coalesce(subject_name, '')));

comment on column spas_exam_score.subject_name is 'subject label from Excel; null when score_type=2';
