-- 第五十七轮：P3 视觉资源与默认 BGM 种子
insert into gs_content (activity_id, content_type, title, body, image_url, order_num, extra)
select 1, 'music', 'qdq', '', '/themes/meepo/assets/music/default-bgm.mp3', 10, '{"plugName":"qdq","bgmusicstatus":"2"}'::jsonb
where not exists (
  select 1 from gs_content where activity_id = 1 and content_type = 'music' and extra::text like '%"plugName":"qdq"%'
);
