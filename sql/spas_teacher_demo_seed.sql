-- Demo teachers (password 123456 for all)
-- teacher001 subject / bzr001 homeroom / grade001 grade / school001 school

insert into sys_user(user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, dept_id, create_by, create_time, remark)
select 'teacher001', U&'\738b\8001\5e08', '00', '', '13900000001', '0', '',
       '$2b$10$sRmiFGbECf5T/je2AHQgru5.yfZSpKl/Z8hD9Wao5fTou.a.KXm8.',
       '0', '0', 9102, 'admin', now(), 'SPAS demo subject teacher'
where not exists (select 1 from sys_user where user_name = 'teacher001');

insert into sys_user(user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, dept_id, create_by, create_time, remark)
select 'bzr001', U&'\674e\73ed\4e3b\4efb', '00', '', '13900000002', '1', '',
       '$2b$10$sRmiFGbECf5T/je2AHQgru5.yfZSpKl/Z8hD9Wao5fTou.a.KXm8.',
       '0', '0', 9102, 'admin', now(), 'SPAS demo homeroom teacher'
where not exists (select 1 from sys_user where user_name = 'bzr001');

insert into sys_user(user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, dept_id, create_by, create_time, remark)
select 'grade001', U&'\5f20\5e74\7ea7', '00', '', '13900000003', '0', '',
       '$2b$10$sRmiFGbECf5T/je2AHQgru5.yfZSpKl/Z8hD9Wao5fTou.a.KXm8.',
       '0', '0', 9101, 'admin', now(), 'SPAS demo grade leader'
where not exists (select 1 from sys_user where user_name = 'grade001');

insert into sys_user(user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, dept_id, create_by, create_time, remark)
select 'school001', U&'\6821\957f', '00', '', '13900000004', '0', '',
       '$2b$10$sRmiFGbECf5T/je2AHQgru5.yfZSpKl/Z8hD9Wao5fTou.a.KXm8.',
       '0', '0', 9100, 'admin', now(), 'SPAS demo school leader'
where not exists (select 1 from sys_user where user_name = 'school001');

-- assign roles
insert into sys_user_role(user_id, role_id)
select u.user_id, r.role_id from sys_user u cross join sys_role r
where u.user_name = 'teacher001' and r.role_key = 'spas_teacher'
  and not exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = r.role_id);

insert into sys_user_role(user_id, role_id)
select u.user_id, r.role_id from sys_user u cross join sys_role r
where u.user_name = 'bzr001' and r.role_key = 'spas_bzr'
  and not exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = r.role_id);

insert into sys_user_role(user_id, role_id)
select u.user_id, r.role_id from sys_user u cross join sys_role r
where u.user_name = 'grade001' and r.role_key = 'spas_grade_leader'
  and not exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = r.role_id);

insert into sys_user_role(user_id, role_id)
select u.user_id, r.role_id from sys_user u cross join sys_role r
where u.user_name = 'school001' and r.role_key = 'spas_school_leader'
  and not exists (select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = r.role_id);

-- teacher profiles
insert into spas_teacher(teacher_no, teacher_name, teacher_type, dept_id, user_id, mobile, gender, status, del_flag, create_by, create_time)
select 'teacher001', U&'\738b\8001\5e08', '1', 9102, u.user_id, '13900000001', '0', '0', '0', 'admin', now()
from sys_user u where u.user_name = 'teacher001'
  and not exists (select 1 from spas_teacher where teacher_no = 'teacher001');

insert into spas_teacher(teacher_no, teacher_name, teacher_type, dept_id, user_id, mobile, gender, status, del_flag, create_by, create_time)
select 'bzr001', U&'\674e\73ed\4e3b\4efb', '2', 9102, u.user_id, '13900000002', '1', '0', '0', 'admin', now()
from sys_user u where u.user_name = 'bzr001'
  and not exists (select 1 from spas_teacher where teacher_no = 'bzr001');

insert into spas_teacher(teacher_no, teacher_name, teacher_type, dept_id, user_id, mobile, gender, status, del_flag, create_by, create_time)
select 'grade001', U&'\5f20\5e74\7ea7', '3', 9101, u.user_id, '13900000003', '0', '0', '0', 'admin', now()
from sys_user u where u.user_name = 'grade001'
  and not exists (select 1 from spas_teacher where teacher_no = 'grade001');

insert into spas_teacher(teacher_no, teacher_name, teacher_type, dept_id, user_id, mobile, gender, status, del_flag, create_by, create_time)
select 'school001', U&'\6821\957f', '4', 9100, u.user_id, '13900000004', '0', '0', '0', 'admin', now()
from sys_user u where u.user_name = 'school001'
  and not exists (select 1 from spas_teacher where teacher_no = 'school001');

-- link dept leaders
update sys_dept set leader = U&'\674e\73ed\4e3b\4efb' where dept_id = 9102;
update sys_dept set leader = U&'\5f20\5e74\7ea7' where dept_id = 9101;
update sys_dept set leader = U&'\6821\957f' where dept_id = 9100;
