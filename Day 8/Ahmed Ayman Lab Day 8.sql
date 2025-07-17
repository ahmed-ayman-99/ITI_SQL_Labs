--Part 1
Use ITI
-------------
--1
alter view Student__Info as 
select CONCAT(s.st_fname, ' ' ,s.st_lname) as StudentFullName, crs.Crs_Name as CourseName
from Student as s 
join Stud_course as st_crs on s.St_id = st_crs.St_id 
join Course as crs on st_crs.Crs_Id = crs.Crs_Id
where st_crs.Grade > 50

select * from Student__Info
--------------------------------------------------------------------------
--2
alter view Manager_topic with encryption
as
select Ins_Name as ManagerName, Top_Name as TopicName
from Instructor as i join Department as d
on i.Ins_Id = d.Dept_Manager join Ins_Course as inscrs 
on i.Ins_Id = inscrs.Ins_Id join Course as crs
on inscrs.Crs_Id = crs.Crs_Id join Topic as tp
on crs.Top_Id = tp.Top_Id 

select * from Manager_topic
------------------------------------------------------------------------------
--3
create view SDJAVA as
select i.Ins_Name as instructor, d.Dept_Name as Department
from Instructor as i join Department as d
on i.Dept_Id = d.Dept_Id
where Dept_Name in ('SD', 'Java') 

select * from SDJAVA
-----------------------------------------------------------------------------
--4
create view V1 as 
select * from student 
where St_Address in ('Cairo','Alex')
with check option

select * from V1
------------------------------------------------------------------------------
--5
Use SD
create view No_Employee as
select P.ProjectName, count(e.EmpNo) as NumberOfEmployee
from [Human Resource].Employee as e join Works_on as wk
on e.EmpNo = wk.EmpNo join Company.Project as p
on wk.ProjectNo = p.ProjectNo
group by p.ProjectName

select * from No_Employee
----------------------------------------------------------------------------
--6
use ITI
create clustered index Manager_hireDate
on department (Manager_hiredate)      --Cannot create more than one clustered index on table there is a "PK"
----------------------------------------------------------------------------
--7
create unique index unique_age
on student (St_Age)                   --CREATE UNIQUE INDEX statement terminated, There is duplicate age found
----------------------------------------------------------------------------
--8
create table DailyT (UserID int,TransactionAmount int)
create table LastT (UserID int,TransactionAmount int)
insert into DailyT values (1,1000),(2,2000),(3,1000)
insert into LastT values (1,4000),(4,2000),(2,10000)

Merge into LastT as T
using  DailyT    as S
on T.UserID = S.UserID
when Matched then
	update
		set T.TransactionAmount = S.TransactionAmount
when not matched then
    insert
    values(s.UserID ,s.TransactionAmount);     ---(3 rows affected)
select * from LastT
-------------------------------------------------------------------------------
--9
use Company_SD
declare c1 cursor
for select salary from Employee
for update
declare @sal int
open c1
fetch c1 into @sal
while @@FETCH_STATUS=0
    begin
        if @sal>=3000
            update Employee
                set Salary=@sal*1.20
            where current of c1
        else if @sal<3000
            update Employee
                set Salary=@sal*1.10
            where current of c1
        fetch c1 into @sal
    end
close c1
deallocate c1
--------------------------------------------------------------------------
--10
use ITI
declare c1 cursor
for select d.Dept_Name, i.Ins_Name
from Instructor as i join Department as d 
on i.Ins_Id = d.Dept_Manager
for read only
declare @inst varchar(20),@dept varchar(20)
open c1
fetch c1 into @inst,@dept
while @@FETCH_STATUS=0
    begin
        select @inst,@dept
        fetch c1 into @inst,@dept
    end
close c1
deallocate c1
-----------------------------------------------------------------------------
--11
declare c1 cursor
for select st_fname from Student where st_fname is not null
for read only
declare @name varchar(20),@all_names varchar(300)=''
open c1
fetch c1 into @name
while @@FETCH_STATUS=0
    begin
        set @all_names=CONCAT(@all_names,',',@name)
        fetch c1 into @name 
    end
select @all_names
close c1
deallocate c1
-------------------------------------------------------------------------------
--Part 2
use SD
--1
alter view v_clerk as 
select EmpNo, ProjectNo, Enter_Date
from Works_on
where Job = 'Clerk'

select * from v_clerk
---------------------------------------------------------------------------------
--2
create view v_without_budget as 
select * from Company.Project
where budget is null

select * from v_without_budget
                                -----Which one?-----
create view v_without_budget2 as
select ProjectNo,ProjectName from Company.Project

select * from v_without_budget2
--------------------------------------------------------------------------------
--3
create view v_count as
select p.ProjectName as ProjectName,count(wk.EmpNo) as NumberOfJobs
from Company.Project as p join Works_on as wk
on p.ProjectNo = wk.ProjectNo
group by p.ProjectName

select * from v_count
---------------------------------------------------------------------------------
--4
alter view v_project_p2 as
select EmpNo
from v_clerk
where ProjectNo = 'p2'

select * from v_project_p2         
---------------------------------------------------------------------------------
--5
alter view v_without_budget2 as
select * from Company.Project
where ProjectNo IN ('p1', 'p2')

select * from v_without_budget2
--------------------------------------------------------------------------------
--6
drop view v_clerk
drop view v_count
--------------------------------------------------------------------------------
--7
create view Emp_d2 as
select EmpNo as EmployeeNumber ,EmpLname as EmployeeLastName
from [Human Resource].Employee
where DeptNo = 'd2'

select * from Emp_d2
--------------------------------------------------------------------------------
--8
create view EmpWithJ as
select EmployeeLastName 
from Emp_d2
where EmployeeLastName like '%j%'

select * from EmpWithJ
------------------------------------------------------------------------------
--9
create view v_dept as 
select DeptNo as DepartmentNumber, DeptName as DepartmentName
from Company.Department

select * from v_dept
-------------------------------------------------------------------------------
--10
insert into v_dept (DepartmentNumber,DepartmentName)
values ('d4','Development')

select * from v_dept
--------------------------------------------------------------------------------
--11
create view v_2006_check as 
select EmpNo as EmployeeNumber, ProjectNo as ProjectNumber, Job as Title, Enter_Date as HiringDate
from Works_on
where Enter_Date between '2006-01-01' and '2006-12-31'

select * from v_2006_check                         ---where he works????