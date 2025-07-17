--Part 1
use ITI
--1
create procedure NoStudentPerDepart as 
select  d.Dept_Name, count(s.St_Id) as NumberOfStudent
from Department as d join Student as s
on d.Dept_Id = s.Dept_Id
group by d.Dept_Name

NoStudentPerDepart
execute NoStudentPerDepart
exec NoStudentPerDepart
--------------------------------------------------------------
use SD
--2
alter procedure p1NoEmployee as
declare @NoEmployee int
select @NoEmployee = count(wk.ProjectNo)
from Works_on as wk
where wk.ProjectNo ='p1'
if @NoEmployee > 3
select 'The number of employees in the project p1 is 3 or more'
else 
print 'The following employees work for the project p1'
select e.EmpFname,e.EmpLname
from [Human Resource].Employee as e join Works_on as wk
on e.EmpNo = wk.EmpNo
where wk.ProjectNo ='p1'

execute p1NoEmployee
--------------------------------------------------------------------------
--3
use Company_SD
create procedure UpdateEmployee 
@OldEmployeeNumber int,
@NewEmployeeNumber int,
@ProjectNumber varchar (10)
as
begin
update Works_for
set ESSn = @NewEmployeeNumber
where ESSn = @OldEmployeeNumber and Pno = @ProjectNumber
end

execute UpdateEmployee 968574,321654,700
-----------------------------------------------------------------------------------------
use Company_SD
--4
alter table project
add budget int  --insert random values in budget column using wizard

create table audit
(ProjectNo int,
 UserName varchar(100),
 Modificationdate date,
 BudgetOld int,
 BudgetNew int)

alter trigger tr
on project
after update
as
	if update(budget)
		begin
			declare @old int,@new int,@PNO int
				select @old =budget from deleted
				select @new = budget from inserted
				select @PNO = Pnumber from inserted
			insert into audit
			values(@PNO,suser_name(),getdate(),@old,@new)
		end
--edit some values in budget column then
select * from audit
-----------------------------------------------------------------------------------
--5
create trigger t_ins
on departments
instead of insert
as
select 'you can’t insert a new record in that table'

insert into Departments (Dname,Dnum) values ('iti',10001)
-----------------------------------------------------------------------------------
--6
alter trigger t_ins1
on employee
instead of insert
as
	if format(getdate(),'MMMM')='April'
		select 'not allowed'
	else	
		insert into Employee
		select * from inserted

insert into Employee(SSN) values (10001)
--------------------------------------------------------------------------------------
--7
use ITI
create table Student_audit
(ServerUsername varchar(100),
 Date date,
 Note varchar(200))

alter trigger tr_in_student
on student
after insert
as
declare @Key_value int
select @key_value = St_ID from inserted
insert into Student_audit
values(suser_name(),getdate(),host_name()+ 'Insert New Row with Key= '+ cast(@Key_value as varchar(10)) +'in table student')


insert into Student(St_id,St_Fname,St_Lname) values (5041,'Ahmed','Ayman')
select * from Student_audit
-------------------------------------------------------------------------------------------
--8
create trigger tr_del_student
on student
instead of delete
as
declare @Key_value int
select @key_value = St_ID from deleted
insert into Student_audit
values(suser_name(),getdate(),host_name()+ 'try to delete Row with Key='+ cast(@Key_value as varchar(10)) +'in table student')

delete from student where st_id=5041
select * from Student_audit
--------------------------------------------------------------------------------------------
--8--1--sequence
create sequence Test_Sequence
start with 1
increment by 1
MinValue 1
MaxValue 10

select next value for Test_Sequence --return 1
select next value for Test_Sequence --return 2
select next value for Test_Sequence --return 3
select next value for Test_Sequence --return 4
select next value for Test_Sequence --return 5
----------------------------------------------------------------------------------------------
--8--2
backup database SD
to disk='D:\ITI PowerBI Development\ITI Course Materials\Database & SQL\Day 9\Lab'

backup database SD
to disk='D:\ITI PowerBI Development\ITI Course Materials\Database & SQL\Day 9\Lab'
with differential
---------------------------------------------------------------------------------------------
---Part2--Transform all functions in lab7 to be stored procedures
use ITI
--1
alter procedure month_name1
@x Date,
@m varchar(15) output
as

select @m = datename(mm,@x)

declare @result varchar(15)
execute month_name1 '1999-01-24',@result output
select @result as MonthName
--------------------------------------------------------------------------------------------
--2
alter procedure value_betweenp
@x int , @y int
as 
create table Values_betweenp (value int)
if @x < @y
begin
		while (@x<@y)
		begin
			set @x+=1  
			if @x=@y
				break
		insert into Values_betweenp values (@x)
		end
end
else
begin
		while (@x>@y)
		begin
			set @y+=1  
			if @y=@x
				break
		insert into Values_betweenp values (@y)
		end
end
select value from Values_betweenp
drop table Values_betweenp

execute value_betweenp 5,12
-------------------------------------------------------------------------------------------
--3
create procedure student_infop 
@St_Id int
as
select concat(s.St_Fname, ' ',s.St_Lname) as student_fullName,d.Dept_Name
		from Student as s join Department as d
		on s.Dept_Id=d.Dept_Id
		where s.St_Id = @St_Id

execute student_infop 10
execute student_infop 7
-------------------------------------------------------------------------------------------
--4
create procedure Is_name_nullp 
@St_Id int,
@message nvarchar(50) output
as

declare @firstname varchar(20)
declare @lastname varchar(20)

select @firstname = St_Fname, @lastname = St_Lname 
		from Student
		where St_Id = @St_Id
if @firstname is null and @lastname is null 
	set @message = 'First name & last name are null'
else if @firstname is null 
	set @message = 'First name is null'
else if @lastname is null
	set @message = 'Last name is null'
else
	set @message = 'First name & last name are not null'

declare @result nvarchar(50)
execute Is_name_nullp 1,@result output
select @result as IsNameNull

declare @result nvarchar(50)
execute Is_name_nullp 13,@result output
select @result as IsNameNull

declare @result nvarchar(50)
execute Is_name_nullp 20,@result output
select @result as IsNameNull
------------------------------------------------------------------------------------------
--5
create procedure Manager_infop 
@MG_Id int
as
select d.Dept_Name as department_Name, i.Ins_Name as Manager_Name,d.Manager_hiredate as Hiring_date
from Instructor as i join Department as d
on i.Ins_Id=d.Dept_Manager
where @MG_Id = I.Ins_Id

execute Manager_infop 1
---------------------------------------------------------------------------------------------
--6
alter procedure student_namep
@format nvarchar(50)
as
	if @format='fullname'
		select isnull(st_fname, '') + ' ' + isnull(st_lname, '') as Student_Full_name
		from student
	else
	if @format='firstname'
		select st_fname as Student_First_name
		from student
	else 
	if @format = 'lastname'
	select st_lname as Student_second_name
	from Student

execute student_namep 'fullname'
execute student_namep 'firstname'
execute student_namep 'lastname'
-----------------------------------------------------------------------------------------------------------