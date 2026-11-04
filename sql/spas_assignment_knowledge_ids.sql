-- Assignment default themes (multi): knowledge_ids CSV; knowledge_id kept as primary/first
alter table spas_practice_assignment add column if not exists knowledge_ids varchar(500);
comment on column spas_practice_assignment.knowledge_ids is 'default theme ids CSV for checkout seed';

update spas_practice_assignment
set knowledge_ids = knowledge_id::text
where knowledge_id is not null
  and (knowledge_ids is null or knowledge_ids = '');
