-- Demo school org: school -> grade -> class (PostgreSQL UTF-8)
-- Dept IDs: 9100 school, 9101 grade, 9102 class

insert into sys_dept(dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
select 9100, 100, '0,100', U&'\793a\8303\5b66\6821', 10, U&'\6559\52a1', '', '', '0', '0', 'admin', now()
where not exists (select 1 from sys_dept where dept_id = 9100);

insert into sys_dept(dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
select 9101, 9100, '0,100,9100', '2024' || U&'\7ea7', 1, U&'\5e74\7ea7\4e3b\4efb', '', '', '0', '0', 'admin', now()
where not exists (select 1 from sys_dept where dept_id = 9101);

insert into sys_dept(dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time)
select 9102, 9101, '0,100,9100,9101', U&'\521d\4e00(1)\73ed', 1, U&'\73ed\4e3b\4efb', '', '', '0', '0', 'admin', now()
where not exists (select 1 from sys_dept where dept_id = 9102);

update spas_student set dept_id = 9102 where student_no = 'demo001' and dept_id <> 9102;
update spas_paper set dept_id = 9102 where paper_name = U&'\6f14\793a\5355\5143\6d4b' and dept_id <> 9102;
