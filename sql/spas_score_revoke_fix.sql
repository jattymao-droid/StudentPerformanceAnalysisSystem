-- Score revoke fix: keep one-level previous values so re-import can be undone
ALTER TABLE spas_score_detail ADD COLUMN IF NOT EXISTS prev_batch_id int8;
ALTER TABLE spas_score_detail ADD COLUMN IF NOT EXISTS prev_score numeric(8,2);
ALTER TABLE spas_score_detail ADD COLUMN IF NOT EXISTS prev_full_score numeric(8,2);
ALTER TABLE spas_score_detail ADD COLUMN IF NOT EXISTS prev_rate numeric(6,4);

COMMENT ON COLUMN spas_score_detail.prev_batch_id IS 'previous batch before last upsert (for revoke restore)';
