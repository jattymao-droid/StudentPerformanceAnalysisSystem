-- Optional link from ʵ������ to spas_paper (idempotent)
alter table spas_exam add column if not exists paper_id int8;
comment on column spas_exam.paper_id is 'optional spas_paper.paper_id for mastery overlay on rank trend';
create index if not exists idx_spas_exam_paper on spas_exam(paper_id) where paper_id is not null;
