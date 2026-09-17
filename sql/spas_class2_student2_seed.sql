-- Extra student in class 9103 for heatmap contrast (idempotent)

insert into sys_user(user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, dept_id, create_by, create_time, remark)
select 'demo003', U&'\8d75\540c\5b66', '00', '', '', '1', '',
       '$2b$10$sRmiFGbECf5T/je2AHQgru5.yfZSpKl/Z8hD9Wao5fTou.a.KXm8.',
       '0', '0', 9103, 'admin', now(), 'SPAS demo student class2 #2'
where not exists (select 1 from sys_user where user_name = 'demo003');

insert into sys_user_role(user_id, role_id)
select u.user_id, r.role_id from sys_user u cross join sys_role r
where u.user_name = 'demo003' and r.role_key = 'spas_student'
  and not exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = r.role_id);

insert into spas_student(student_no, student_name, gender, dept_id, grade_year, user_id, status, del_flag, create_by, create_time)
select 'demo003', U&'\8d75\540c\5b66', '1', 9103, '2024', u.user_id, '0', '0', 'admin', now()
from sys_user u
where u.user_name = 'demo003'
  and not exists (select 1 from spas_student where student_no = 'demo003');

-- scores on class2 paper: stronger than demo002 (Q1=8, Q2=7)
insert into spas_score_detail(paper_id, question_id, student_id, score, full_score, rate, create_time)
select p.paper_id, q.question_id, st.student_id, 8, 10, 0.8000, now()
from spas_paper p
join spas_paper_question q on q.paper_id = p.paper_id and q.question_no = '1'
join spas_student st on st.student_no = 'demo003'
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
  and not exists (
    select 1 from spas_score_detail d
    where d.paper_id = p.paper_id and d.question_id = q.question_id and d.student_id = st.student_id
  );

insert into spas_score_detail(paper_id, question_id, student_id, score, full_score, rate, create_time)
select p.paper_id, q.question_id, st.student_id, 7, 10, 0.7000, now()
from spas_paper p
join spas_paper_question q on q.paper_id = p.paper_id and q.question_no = '2'
join spas_student st on st.student_no = 'demo003'
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
  and not exists (
    select 1 from spas_score_detail d
    where d.paper_id = p.paper_id and d.question_id = q.question_id and d.student_id = st.student_id
  );

-- ALG ~ (0.8*0.7+0.7*0.3)=0.77; GEO ~ (0.8*0.3+0.7*0.7)=0.73
insert into spas_student_knowledge_stat(
  student_id, knowledge_id, subject_id, attempt_count, avg_rate, weighted_rate,
  last_paper_id, last_exam_date, weak_level, calc_time
)
select st.student_id, k.knowledge_id, k.subject_id, 2, 0.7700, 0.7700, p.paper_id, p.exam_date, '0', now()
from spas_student st
cross join spas_knowledge k
join spas_paper p on p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
where st.student_no = 'demo003' and k.knowledge_code = 'MATH-ALG'
  and not exists (
    select 1 from spas_student_knowledge_stat s
    where s.student_id = st.student_id and s.knowledge_id = k.knowledge_id
  );

insert into spas_student_knowledge_stat(
  student_id, knowledge_id, subject_id, attempt_count, avg_rate, weighted_rate,
  last_paper_id, last_exam_date, weak_level, calc_time
)
select st.student_id, k.knowledge_id, k.subject_id, 2, 0.7300, 0.7300, p.paper_id, p.exam_date, '1', now()
from spas_student st
cross join spas_knowledge k
join spas_paper p on p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
where st.student_no = 'demo003' and k.knowledge_code = 'MATH-GEO'
  and not exists (
    select 1 from spas_student_knowledge_stat s
    where s.student_id = st.student_id and s.knowledge_id = k.knowledge_id
  );
