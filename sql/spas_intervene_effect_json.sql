-- P2 E8: per-knowledge retest delta payload
ALTER TABLE spas_intervene_task ADD COLUMN IF NOT EXISTS effect_json text;
COMMENT ON COLUMN spas_intervene_task.effect_json IS 'retest detail JSON: [{knowledgeId,knowledgeName,baselineRate,effectRate,delta}]';
