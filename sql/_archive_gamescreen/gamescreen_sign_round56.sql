-- 第五十六轮：签到墙对齐（可重复执行）

alter table gs_attendee add column if not exists sign_audit char(1) default '1';
alter table gs_activity add column if not exists sign_audit_mode char(1) default '0';
alter table gs_activity add column if not exists reserved_match_mode char(1) default '1';
alter table gs_activity add column if not exists reserved_verify_mode char(1) default '1';
alter table gs_sign_field add column if not exists field_type varchar(16) default 'text';
alter table gs_sign_field add column if not exists field_options text default '';
alter table gs_threedimensional add column if not exists page_sequence varchar(1024) default '';

update gs_attendee set sign_audit = '1' where sign_audit is null and signed = '1';
