-- SPAS warning quartz job (daily 02:00).
-- status: 0=normal(enabled), 1=pause
insert into sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, remark)
select 100, 'SPAS Warning Engine', 'DEFAULT', 'spasWarningTask.run()', '0 0 2 * * ?', '3', '1', '0', 'admin', now(), 'Evaluate spas warning rules'
where not exists (select 1 from sys_job where job_id = 100);

-- Enable existing paused job (idempotent)
update sys_job
   set status = '0',
       invoke_target = 'spasWarningTask.run()',
       cron_expression = '0 0 2 * * ?',
       remark = 'Evaluate spas warning rules'
 where job_id = 100;
