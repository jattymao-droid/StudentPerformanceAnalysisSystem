-- SPAS: expire overnight unconfirmed checkout items (member_ack=3)
-- Daily 00:30. status: 0=enabled, 1=paused
insert into sys_job(job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, remark)
select 102, 'SPAS Checkout Ack Timeout', 'DEFAULT', 'spasCheckoutTask.expirePendingAck()', '0 30 0 * * ?', '3', '1', '0', 'admin', now(), 'Mark overnight unconfirmed checkout items as timeout'
where not exists (select 1 from sys_job where job_id = 102);

update sys_job
   set status = '0',
       invoke_target = 'spasCheckoutTask.expirePendingAck()',
       cron_expression = '0 30 0 * * ?',
       remark = 'Mark overnight unconfirmed checkout items as timeout'
 where job_id = 102;
