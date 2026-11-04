-- SPAS: checkout sheet knowledge themes (leader picks weak / custom when submitting)
-- PostgreSQL · idempotent

alter table spas_practice_checkout
  add column if not exists knowledge_ids varchar(500);

comment on column spas_practice_checkout.knowledge_ids is '本组检查主题知识ID，逗号分隔';
