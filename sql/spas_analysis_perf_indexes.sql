-- Student analysis query indexes (safe to re-run)
-- Helps selectScoreRowsForScope joins and exam-date window filters.

create index if not exists idx_spas_score_detail_paper_stu
  on spas_score_detail(paper_id, student_id);

create index if not exists idx_spas_qk_question
  on spas_question_knowledge(question_id);

create index if not exists idx_spas_paper_exam_date
  on spas_paper(exam_date);

create index if not exists idx_spas_score_detail_stu_paper_q
  on spas_score_detail(student_id, paper_id, question_id);
