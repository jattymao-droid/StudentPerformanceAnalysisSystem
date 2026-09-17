-- Class 2 (dept 9103) demo paper + scores for multi-class analysis (idempotent, U& escapes)

-- paper: ????????-(2)??
insert into spas_paper(paper_name, paper_type, subject_id, dept_id, exam_date, total_score, status, publish_time, create_by, create_time, remark)
select U&'\6f14\793a\5355\5143\6d4b-(2)\73ed', '1', s.subject_id, 9103, current_date, 20, '1', now(), 'admin', now(),
       'multi-class demo for teacher001'
from spas_subject s
where s.subject_code = 'MATH'
  and not exists (
    select 1 from spas_paper p where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
  );

-- Q1 algebra-heavy
insert into spas_paper_question(paper_id, question_no, question_order, full_score, difficulty, create_by, create_time)
select p.paper_id, '1', 1, 10, '2', 'admin', now()
from spas_paper p
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
  and not exists (select 1 from spas_paper_question q where q.paper_id = p.paper_id and q.question_no = '1');

insert into spas_question_knowledge(question_id, knowledge_id, weight, is_primary)
select q.question_id, k.knowledge_id, 0.7000, '1'
from spas_paper_question q
join spas_paper p on p.paper_id = q.paper_id
join spas_knowledge k on k.knowledge_code = 'MATH-ALG'
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed' and q.question_no = '1'
  and not exists (select 1 from spas_question_knowledge qk where qk.question_id = q.question_id and qk.knowledge_id = k.knowledge_id);

insert into spas_question_knowledge(question_id, knowledge_id, weight, is_primary)
select q.question_id, k.knowledge_id, 0.3000, '0'
from spas_paper_question q
join spas_paper p on p.paper_id = q.paper_id
join spas_knowledge k on k.knowledge_code = 'MATH-GEO'
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed' and q.question_no = '1'
  and not exists (select 1 from spas_question_knowledge qk where qk.question_id = q.question_id and qk.knowledge_id = k.knowledge_id);

-- Q2 geometry-heavy
insert into spas_paper_question(paper_id, question_no, question_order, full_score, difficulty, create_by, create_time)
select p.paper_id, '2', 2, 10, '3', 'admin', now()
from spas_paper p
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
  and not exists (select 1 from spas_paper_question q where q.paper_id = p.paper_id and q.question_no = '2');

insert into spas_question_knowledge(question_id, knowledge_id, weight, is_primary)
select q.question_id, k.knowledge_id, 0.3000, '0'
from spas_paper_question q
join spas_paper p on p.paper_id = q.paper_id
join spas_knowledge k on k.knowledge_code = 'MATH-ALG'
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed' and q.question_no = '2'
  and not exists (select 1 from spas_question_knowledge qk where qk.question_id = q.question_id and qk.knowledge_id = k.knowledge_id);

insert into spas_question_knowledge(question_id, knowledge_id, weight, is_primary)
select q.question_id, k.knowledge_id, 0.7000, '1'
from spas_paper_question q
join spas_paper p on p.paper_id = q.paper_id
join spas_knowledge k on k.knowledge_code = 'MATH-GEO'
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed' and q.question_no = '2'
  and not exists (select 1 from spas_question_knowledge qk where qk.question_id = q.question_id and qk.knowledge_id = k.knowledge_id);

-- demo002 scores: Q1=4/10, Q2=5/10 (weaker than demo001)
insert into spas_score_detail(paper_id, question_id, student_id, score, full_score, rate, create_time)
select p.paper_id, q.question_id, st.student_id, 4, 10, 0.4000, now()
from spas_paper p
join spas_paper_question q on q.paper_id = p.paper_id and q.question_no = '1'
join spas_student st on st.student_no = 'demo002'
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
  and not exists (
    select 1 from spas_score_detail d
    where d.paper_id = p.paper_id and d.question_id = q.question_id and d.student_id = st.student_id
  );

insert into spas_score_detail(paper_id, question_id, student_id, score, full_score, rate, create_time)
select p.paper_id, q.question_id, st.student_id, 5, 10, 0.5000, now()
from spas_paper p
join spas_paper_question q on q.paper_id = p.paper_id and q.question_no = '2'
join spas_student st on st.student_no = 'demo002'
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
  and not exists (
    select 1 from spas_score_detail d
    where d.paper_id = p.paper_id and d.question_id = q.question_id and d.student_id = st.student_id
  );

-- import batch row for dashboard recent list
insert into spas_score_batch(paper_id, file_name, total_rows, success_rows, fail_rows, status, create_by, create_time)
select p.paper_id, 'demo_class2_seed.xlsx', 1, 1, 0, '1', 'admin', now()
from spas_paper p
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
  and not exists (
    select 1 from spas_score_batch b where b.paper_id = p.paper_id and b.file_name = 'demo_class2_seed.xlsx'
  );

-- link details to latest batch for this paper
update spas_score_detail d
set batch_id = b.batch_id
from spas_paper p
join spas_score_batch b on b.paper_id = p.paper_id and b.file_name = 'demo_class2_seed.xlsx'
join spas_student st on st.student_no = 'demo002'
where p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
  and d.paper_id = p.paper_id
  and d.student_id = st.student_id
  and d.batch_id is null;

-- knowledge stats for demo002
-- Q1 rate 0.4 * (0.7 ALG + 0.3 GEO) + Q2 rate 0.5 * (0.3 ALG + 0.7 GEO)
-- ALG weighted ?? (0.4*0.7 + 0.5*0.3) / (0.7+0.3) = 0.43
-- GEO weighted ?? (0.4*0.3 + 0.5*0.7) / (0.3+0.7) = 0.47
insert into spas_student_knowledge_stat(
  student_id, knowledge_id, subject_id, attempt_count, avg_rate, weighted_rate,
  last_paper_id, last_exam_date, weak_level, calc_time
)
select st.student_id, k.knowledge_id, k.subject_id, 2, 0.4300, 0.4300, p.paper_id, p.exam_date, '2', now()
from spas_student st
cross join spas_knowledge k
join spas_paper p on p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
where st.student_no = 'demo002' and k.knowledge_code = 'MATH-ALG'
  and not exists (
    select 1 from spas_student_knowledge_stat s
    where s.student_id = st.student_id and s.knowledge_id = k.knowledge_id
  );

insert into spas_student_knowledge_stat(
  student_id, knowledge_id, subject_id, attempt_count, avg_rate, weighted_rate,
  last_paper_id, last_exam_date, weak_level, calc_time
)
select st.student_id, k.knowledge_id, k.subject_id, 2, 0.4700, 0.4700, p.paper_id, p.exam_date, '2', now()
from spas_student st
cross join spas_knowledge k
join spas_paper p on p.paper_name = U&'\6f14\793a\5355\5143\6d4b-(2)\73ed'
where st.student_no = 'demo002' and k.knowledge_code = 'MATH-GEO'
  and not exists (
    select 1 from spas_student_knowledge_stat s
    where s.student_id = st.student_id and s.knowledge_id = k.knowledge_id
  );

-- open warning for demo002 (avg rate low)
insert into spas_warning_record(rule_id, student_id, subject_id, level, title, content, metric_value, status, create_time)
select wr.rule_id, st.student_id, s.subject_id, '2',
       U&'\5e73\5747\5f97\5206\7387\504f\4f4e',
       U&'\5b66\751f' || ' demo002 ' || U&'\5e73\5747\5f97\5206\7387' || ' 0.45' || U&'\ff0c\4f4e\4e8e\9608\503c' || ' 0.70',
       0.4500, '0', now()
from spas_warning_rule wr
cross join spas_student st
cross join spas_subject s
where wr.rule_code = 'AVG_RATE_LOW'
  and st.student_no = 'demo002'
  and s.subject_code = 'MATH'
  and not exists (
    select 1 from spas_warning_record r
    where r.student_id = st.student_id and r.rule_id = wr.rule_id and r.status = '0'
  );
