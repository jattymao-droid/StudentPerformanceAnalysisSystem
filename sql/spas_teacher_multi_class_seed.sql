-- Extra class for multi-class subject teacher demo (PostgreSQL, idempotent)
-- Dept 9103 = ��һ(2)�� under grade 9101; teacher001 also teaches this class

insert into sys_dept(dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
select 9103, 9101, '0,100,9100,9101', U&'\521d\4e00(2)\73ed', 2, '', '', '', '0', '0', 'admin', now()
where not exists (select 1 from sys_dept where dept_id = 9103);

-- teacher001 extra class assignment (primary remains 9102)
insert into spas_teacher_dept(teacher_id, dept_id)
select t.teacher_id, 9103
from spas_teacher t
where t.teacher_no = 'teacher001'
  and not exists (
    select 1 from spas_teacher_dept td
    where td.teacher_id = t.teacher_id and td.dept_id = 9103
  );

-- optional demo student in class 2 for scope verification
insert into sys_user(user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, dept_id, create_by, create_time, remark)
select 'demo002', U&'\674e\540c\5b66', '00', '', '', '0', '',
       '$2b$10$sRmiFGbECf5T/je2AHQgru5.yfZSpKl/Z8hD9Wao5fTou.a.KXm8.',
       '0', '0', 9103, 'admin', now(), 'SPAS demo student class2'
where not exists (select 1 from sys_user where user_name = 'demo002');

insert into sys_user_role(user_id, role_id)
select u.user_id, r.role_id from sys_user u cross join sys_role r
where u.user_name = 'demo002' and r.role_key = 'spas_student'
  and not exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = r.role_id);

insert into spas_student(student_no, student_name, gender, dept_id, grade_year, user_id, status, del_flag, create_by, create_time)
select 'demo002', U&'\674e\540c\5b66', '0', 9103, '2024', u.user_id, '0', '0', 'admin', now()
from sys_user u
where u.user_name = 'demo002'
  and not exists (select 1 from spas_student where student_no = 'demo002');
