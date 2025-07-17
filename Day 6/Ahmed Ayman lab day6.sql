use SD

--Create table Department
create table Department (
DeptNo nchar(2) Primary key,
DeptName varchar(50),
Location nchar(2))

---add datatype loc
sp_addtype loc , 'nchar(2)'
create rule loc_rule as @value in ('NY','DS','KW')
create default loc_def as 'NY'
sp_bindrule loc_rule,loc
sp_bindefault loc_def,loc

Alter Table Department alter column location loc

--inserting values to table department
insert into department (DeptNo,DeptName,Location)
values ('d1','Research','NY'),('d2','Accounting','DS'),('d3','Marketing','KW')

--Create employee table

create table Employee(
EmpNo int,
EmpFname varchar(50) not null,
EmpLname varchar(50) not null,
DeptNo nchar(2),
Salary int,
constraint PK primary key(EmpNo),
constraint FK foreign key(DeptNo) references Department (DeptNo),
constraint UNQ_salary unique(Salary),
constraint salary_limit check(Salary<6000))

--inserting values to table Employee
insert into Employee (EmpNo,EmpFname,EmpLname,DeptNo,Salary)
values (25348,'Mathew','Smith','d3',2500),(10102,'Ann','Jones','d3',3000),(18316,'John','Barrimore','d1',2400),
(29346,'James','James','d2',2800),(9031,'Lisa','Bertoni','d2',4000),(2581,'Elisa','Hansel','d2',3600),
(28559,'Sybl','Moser','d1',2900)

--inserting values to table Project
insert into Project (ProjectNo,ProjectName,Budget)
values ('p1','Apollo',120000),('p2','Gemini',95000),('p3','Mercury',185600)


Alter Table Works_on alter column Job varchar(50)

--inserting values to table Works_on
insert into Works_on (EmpNo,ProjectNo,Job,Enter_Date)
values (10102,'p1','Analyst','2006-10-1'),(10102,'p3','Manager','2012-01-01')

--Testing
--1
insert into Works_on (EmpNo, ProjectNo) 
values (11111, 'p1') 
---The INSERT statement conflicted with the FOREIGN KEY constraint --because EmpNo 11111 doesn't exist in the Employee table

--2
update Works_on
set EmpNo = 11111
where EmpNo = 10102
--The UPDATE statement conflicted with the FOREIGN KEY constraint --because EmpNo 11111 doesn't exist in the Employee table

--3
update Employee
set EmpNo = 22222
where EmpNo = 10102
-- The FK constraint will prevent to let records in Works_on pointing to a non-existent employee

--4
delete from Employee
where EmpNo = 10102
---- The FK constraint will prevent to let records in Works_on pointing to a non-existent employee

--Table Modification
--1
alter table Employee
add TelephoneNumber int
--2
alter table Employee
drop column TelephoneNumber

--No.2
create schema Company
create schema [Human Resource]

alter schema Company transfer Department
alter schema [Human Resource] transfer Employee

--No.3
select table_name,constraint_name,constraint_type from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where TABLE_NAME = 'Employee'

--No.4
create synonym Emp for [Human Resource].Employee
--a
Select * from Employee                   --- Error beacause Employee table is now inside the Human Resource schema
--b
Select * from [Human Resource].Employee  --- Run correctly
--c
Select * from Emp                        --- Run correctly
--d
Select * from [Human Resource].Emp       --- Error because the synonym is already a shortcut to the table within the schema
--so we don't use synonym name with the schema 

--No.5
update company.Project
set budget = budget * 1.1
where ProjectNo in (select p.ProjectNo 
					from Company.Project as p join Works_on as W 
					on p.ProjectNo = w.ProjectNo
					where w.EmpNo = 10102 and w.Job = 'Manager')

--No.6
update Company.Department
set DeptName = 'Sales'
where DeptNo in (select DeptNo 
				 from Emp
				 where EmpFname = 'James')

--No.7
update Works_on
set Enter_Date = '2007-12-12'
where ProjectNo = 'p1'	
					  and EmpNo in
									(select EmpNo
								     from Emp as e join Company.Department as d
									 on e.DeptNo = d.DeptNo
									 where DeptName = 'Sales')   --2 rows affected

--No.8
delete from Works_on
where EmpNo in (select EmpNo 
							from Emp as e join Company.Department as d 
							on e.DeptNo = d.DeptNo 
							where d.Location = 'KW')            --3 rows affected
