-- P1: revoke restore also restores score_source (one-level prev)
ALTER TABLE spas_score_detail ADD COLUMN IF NOT EXISTS prev_score_source char(1);

COMMENT ON COLUMN spas_score_detail.prev_score_source IS 'previous score_source before last upsert (for revoke restore)';
