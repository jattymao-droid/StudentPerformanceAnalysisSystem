-- SPAS QB visual annotate: session + question crop image columns (PostgreSQL idempotent)

alter table spas_qb_question add column if not exists stem_image varchar(500);
alter table spas_qb_question add column if not exists options_image varchar(500);
alter table spas_qb_question add column if not exists answer_image varchar(500);
alter table spas_qb_question add column if not exists analysis_image varchar(500);

comment on column spas_qb_question.stem_image is 'Cropped stem image path under /profile';
comment on column spas_qb_question.options_image is 'Cropped options image path';
comment on column spas_qb_question.answer_image is 'Cropped answer image path';
comment on column spas_qb_question.analysis_image is 'Cropped analysis image path';

create table if not exists spas_qb_annotate_session (
  session_id varchar(64) not null,
  subject_id int8 not null,
  file_name varchar(255),
  file_path varchar(500),
  page_count int4 default 0,
  status char(1) default '0',
  create_by varchar(64) default '',
  create_time timestamp,
  primary key (session_id)
);

comment on table spas_qb_annotate_session is 'Visual annotate upload session (page renders under profile/qb-annotate/{sessionId})';
comment on column spas_qb_annotate_session.status is '0 open 1 committed 2 expired';

create index if not exists idx_spas_qb_ann_subject on spas_qb_annotate_session(subject_id, create_time);
