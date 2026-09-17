-- Demo seed for acceptance
insert into spas_subject(subject_code, subject_name, sort, status, create_by, create_time)
select 'MATH', '数学', 1, '0', 'admin', now()
where not exists (select 1 from spas_subject where subject_code='MATH');

insert into spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, order_num, difficulty_default, status, create_by, create_time)
select s.subject_id, 0, '0', '代数', 'MATH-ALG', 1, '2', '0', 'admin', now()
from spas_subject s
where s.subject_code='MATH'
  and not exists (select 1 from spas_knowledge k where k.knowledge_code='MATH-ALG');

insert into spas_knowledge(subject_id, parent_id, ancestors, knowledge_name, knowledge_code, order_num, difficulty_default, status, create_by, create_time)
select s.subject_id, 0, '0', '几何', 'MATH-GEO', 2, '2', '0', 'admin', now()
from spas_subject s
where s.subject_code='MATH'
  and not exists (select 1 from spas_knowledge k where k.knowledge_code='MATH-GEO');

insert into sys_user(user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, create_by, create_time, remark)
select 'demo001', '演示学生', '00', '', '', '0', '',
       '$2b$10$sRmiFGbECf5T/je2AHQgru5.yfZSpKl/Z8hD9Wao5fTou.a.KXm8.',
       '0', '0', 'admin', now(), 'SPAS demo student'
where not exists (select 1 from sys_user where user_name='demo001');

insert into sys_user_role(user_id, role_id)
select u.user_id, r.role_id
from sys_user u
cross join sys_role r
where u.user_name='demo001' and r.role_key='spas_student'
  and not exists (select 1 from sys_user_role ur where ur.user_id=u.user_id and ur.role_id=r.role_id);

insert into spas_student(student_no, student_name, gender, dept_id, grade_year, user_id, parent_mobile, status, del_flag, create_by, create_time)
select 'demo001', '演示学生', '0', coalesce((select dept_id from sys_dept where dept_id = 9102), 103), '2026', u.user_id, '13800138000', '0', '0', 'admin', now()
from sys_user u
where u.user_name='demo001'
  and not exists (select 1 from spas_student where student_no='demo001');

update spas_paper set paper_name='演示单元测' where paper_name like '%Demo%' or paper_name='演示单元测' or paper_id=1;

insert into spas_paper(paper_name, paper_type, subject_id, dept_id, exam_date, total_score, status, publish_time, create_by, create_time)
select '演示单元测', '1', s.subject_id, coalesce((select dept_id from sys_dept where dept_id = 9102), 103), current_date, 10, '1', now(), 'admin', now()
from spas_subject s
where s.subject_code='MATH'
  and not exists (select 1 from spas_paper where paper_name='演示单元测');

insert into spas_paper_question(paper_id, question_no, question_order, full_score, difficulty, create_by, create_time)
select p.paper_id, '1', 1, 10, '2', 'admin', now()
from spas_paper p
where p.paper_name='演示单元测'
  and not exists (select 1 from spas_paper_question q where q.paper_id=p.paper_id and q.question_no='1');

insert into spas_question_knowledge(question_id, knowledge_id, weight, is_primary)
select q.question_id, k.knowledge_id, 0.6000, '1'
from spas_paper_question q
join spas_paper p on p.paper_id=q.paper_id
join spas_knowledge k on k.knowledge_code='MATH-ALG'
where p.paper_name='演示单元测' and q.question_no='1'
  and not exists (select 1 from spas_question_knowledge qk where qk.question_id=q.question_id and qk.knowledge_id=k.knowledge_id);

insert into spas_question_knowledge(question_id, knowledge_id, weight, is_primary)
select q.question_id, k.knowledge_id, 0.4000, '0'
from spas_paper_question q
join spas_paper p on p.paper_id=q.paper_id
join spas_knowledge k on k.knowledge_code='MATH-GEO'
where p.paper_name='演示单元测' and q.question_no='1'
  and not exists (select 1 from spas_question_knowledge qk where qk.question_id=q.question_id and qk.knowledge_id=k.knowledge_id);

insert into spas_score_detail(paper_id, question_id, student_id, score, full_score, rate, create_time)
select p.paper_id, q.question_id, st.student_id, 6, 10, 0.6000, now()
from spas_paper p
join spas_paper_question q on q.paper_id=p.paper_id and q.question_no='1'
join spas_student st on st.student_no='demo001'
where p.paper_name='演示单元测'
  and not exists (
    select 1 from spas_score_detail d
    where d.paper_id=p.paper_id and d.question_id=q.question_id and d.student_id=st.student_id
  );

insert into spas_warning_rule(rule_name, rule_code, scope_type, scope_id, metric, operator, threshold, window_days, level, enabled, notify_channels, create_by, create_time, remark)
select '平均得分率偏低', 'AVG_RATE_LOW', '1', null, 'AVG_RATE', '<', 0.7000, 3, '2', '1', 'system', 'admin', now(), 'demo rule'
where not exists (select 1 from spas_warning_rule where rule_code='AVG_RATE_LOW');

insert into spas_parent(parent_name, mobile, status, create_time)
select '演示家长', '13800138000', '0', now()
where not exists (select 1 from spas_parent where mobile='13800138000');

insert into spas_parent_student(parent_id, student_id, bind_status, create_time)
select p.parent_id, s.student_id, '0', now()
from spas_parent p
cross join spas_student s
where p.mobile='13800138000' and s.student_no='demo001'
  and not exists (
    select 1 from spas_parent_student ps
    where ps.parent_id=p.parent_id and ps.student_id=s.student_id
  );
