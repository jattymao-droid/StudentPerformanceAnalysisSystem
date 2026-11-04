-- Per-member knowledge on checkout items
alter table spas_practice_checkout_item
  add column if not exists knowledge_ids varchar(500);
