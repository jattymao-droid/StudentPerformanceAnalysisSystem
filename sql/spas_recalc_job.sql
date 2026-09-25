-- Nightly full-school mastery recalc (after warning job).
-- status: 0=normal(enabled), 1=pause
insert into sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, remark)
select 101, 'SPAS Mastery Recalc', 'DEFAULT', 'spasRecalcTask.run()', '0 30 2 * * ?', '3', '1', '0', 'admin', now(),
       'Nightly full mastery snapshot recalc + warning refresh'
where not exists (select 1 from sys_job where job_id = 101);

update sys_job
   set status = '0',
       invoke_target = 'spasRecalcTask.run()',
       cron_expression = '0 30 2 * * ?',
       remark = 'Nightly full mastery snapshot recalc + warning refresh'
 where job_id = 101;
