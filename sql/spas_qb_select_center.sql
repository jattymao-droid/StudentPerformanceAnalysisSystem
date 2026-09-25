-- SPAS QB select-center / compose enhancements (PostgreSQL idempotent)
alter table spas_qb_question add column if not exists source_year int4;
alter table spas_qb_question add column if not exists source_region varchar(64);
alter table spas_qb_question add column if not exists source_exam varchar(64);
comment on column spas_qb_question.source_year is 'Exam year parsed from stem e.g. 2025';
comment on column spas_qb_question.source_region is 'Region';
comment on column spas_qb_question.source_exam is 'Exam tag';
create index if not exists idx_spas_qb_q_source_year on spas_qb_question(subject_id, source_year) where del_flag = '0';
alter table spas_qb_paper add column if not exists section_json text;
comment on column spas_qb_paper.section_json is 'JSON sections: [{name,questionType,fromOrder,toOrder}]';
insert into sys_menu(menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
select 2320, '选题中心', 2300, 0, 'select', 'spas/qb/select/index', '', '', 1, 0, 'C', '0', '0', 'spas:qb:question:list', 'search', 'admin', current_timestamp, 'Knowledge/chapter select + basket'
where not exists (select 1 from sys_menu where menu_id=2320);
update sys_menu set menu_name = '组卷中心', remark = 'Compose center' where menu_id = 2310;
update sys_menu set order_num = 1 where menu_id = 2301;
update sys_menu set order_num = 2 where menu_id = 2310;
insert into sys_role_menu(role_id, menu_id)
select r.role_id, m.menu_id
from sys_role r
cross join sys_menu m
where r.role_key in ('admin', 'spas_admin', 'spas_jw', 'spas_teacher', 'spas_bzr', 'spas_grade_leader')
  and m.menu_id = 2320
  and not exists (
    select 1 from sys_role_menu rm where rm.role_id = r.role_id and rm.menu_id = m.menu_id
  );
