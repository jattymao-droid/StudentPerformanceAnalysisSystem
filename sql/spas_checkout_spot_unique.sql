-- Ensure one spot record per checkout item (idempotent)
create unique index if not exists uk_spas_practice_spot_item on spas_practice_spot(item_id);
