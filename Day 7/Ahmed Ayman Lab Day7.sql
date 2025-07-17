Use ITI
---------
--1
create function month_name(@x Date)
returns nvarchar(20)
as
begin
declare @m nvarchar(20)
select @m=datename(mm,@x)
return @m
end

select dbo.month_name('01/24/1999')
----------------------------------------------------------
--2
create function values_between0 (@x int, @y int)
returns @t table (values_between int)
as
begin
if @x < @y
begin
		while (@x<@y)
		begin
			set @x+=1  
			if @x=@y
				break
		insert into @t values (@x)
		end
end
else
begin
		while (@x>@y)
		begin
			set @y+=1  
			if @y=@x
				break
		insert into @t values (@y)
		end
end
return
end

select * from dbo.values_between0 (10,1)
-------------------------------------------------------
--3
create function student_info (@St_Id int)
returns table
as
return (select concat(s.St_Fname, ' ',s.St_Lname) as student_fullName,d.Dept_Name
		from Student as s join Department as d
		on s.Dept_Id=d.Dept_Id
		where s.St_Id = @St_Id)

select * from dbo.student_info(10)
select * from dbo.student_info(7)
-------------------------------------------------------
--4
create function Is_name_null (@St_Id int)
returns nvarchar(50)
as
begin
declare @firstname varchar(20)
declare @lastname varchar(20)
declare @message varchar(50)
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
return @message
end

select dbo.Is_name_null(1)
select dbo.Is_name_null(13)
select dbo.Is_name_null(14)
select dbo.Is_name_null(20)
---------------------------------------------------------
--5
alter function Manager_info (@MG_Id int)
returns table
as
return (select d.Dept_Name as department_Name, i.Ins_Name as Manager_Name,
		d.Manager_hiredate as Hiring_date
		from Instructor as i join Department as d
		on i.Ins_Id=d.Dept_Manager
		where @MG_Id = I.Ins_Id)

select * from dbo.Manager_info(1)
-------------------------------------------------------------
--6
create function student_names(@format nvarchar(50))
returns @t table (student_name nvarchar(50))
as
begin
	if @format='fullname'
		insert @t
		select isnull(st_fname, '') + ' ' + isnull(st_lname, '')
		from student
	else
	if @format='firstname'
		insert  into @t
		select st_fname
		from student
	else 
	if @format = 'lastname'
	insert into @t
	select st_lname
	from Student
return
end

select * from student_names('fullname')
select * from student_names('firstname')
select * from student_names('lastname')
-----------------------------------------------------------
--7
select St_ID, substring (St_Fname,1,len(St_Fname)-1) 
from Student
-----------------------------------------------------------
--8
delete
from Stud_Course as s_crs join Student as s 
on s.St_Id = s_crs.St_Id 
join Department as d
on s.Dept_Id = d.Dept_Id
where Dept_Name = 'SD'

----Searched----
UPDATE Stud_Course
SET Grade = NULL  
WHERE St_Id IN (SELECT s.St_Id FROM Student s JOIN Department d ON s.Dept_Id = d.Dept_Id WHERE Dept_Name = 'SD')
--(24 rows affected)