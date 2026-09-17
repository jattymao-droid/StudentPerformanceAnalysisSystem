-- Parent OpenAPI demo seed (idempotent)
-- Demo client: appId=parent-demo / appSecret=spas-open-demo-secret
-- Demo parent mobile: 13800138000

insert into spas_open_client(app_id, app_secret, app_name, status, create_time)
select 'parent-demo', 'spas-open-demo-secret', 'Parent Demo App', '0', now()
where not exists (select 1 from spas_open_client where app_id = 'parent-demo');

insert into spas_parent(parent_name, mobile, status, create_time)
select 'Demo Parent', '13800138000', '0', now()
where not exists (select 1 from spas_parent where mobile = '13800138000');

-- Bind demo parent to first active student if any and not already bound
insert into spas_parent_student(parent_id, student_id, bind_status, create_time)
select p.parent_id, s.student_id, '0', now()
from spas_parent p
cross join lateral (
  select student_id from spas_student
  where del_flag = '0' and status = '0'
  order by student_id
  limit 1
) s
where p.mobile = '13800138000'
  and not exists (
    select 1 from spas_parent_student ps
    where ps.parent_id = p.parent_id and ps.student_id = s.student_id
  );
