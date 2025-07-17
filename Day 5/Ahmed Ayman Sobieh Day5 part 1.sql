--Day 5 - part 1

use ITI

--1
select  count(*) as NumberOfStudentWithAge
from Student
where St_Age is not NULL

--2
select Distinct Ins_Name
from Instructor

--3
select St_Id as [Student ID],
	   ISNULL(s.St_Fname,'')+' '+ISNULL(s.St_Lname,' ') as [Student Full Name],
	   ISNULL(d.Dept_Name,'No Department') as [Department Name]
from Student as s left join Department as d
on s.Dept_id = d.Dept_id

--4
select Ins_Name, ISNULL(d.Dept_name,'No Department')
from Instructor as i left join Department as d 
on i.Dept_id = d.Dept_id

--5
select s.St_Fname +' '+ s.St_Lname as [Student Full Name],Crs_Name as [course name]
from Stud_course as st_crs join Student as s  
on s.St_Id = st_crs.St_Id
join Course as crs on crs.Crs_Id = st_crs.Crs_Id
where Grade IS Not NULL

--6
select Top_Name, count (crs_id) as [NumberOfCourses]
from Topic as t join Course as cr
on t.Top_Id = cr.Top_Id
group by Top_Name

--7
select max(Salary) as Max_Salary , min(Salary) as Min_salary
from Instructor

--8
select Ins_Name
from Instructor
where Salary < (select AVG(salary) from Instructor)

--9
select Dept_Name
from Department as d join Instructor as i
on d.Dept_id = i.Dept_id
where salary = (select Min(salary) from instructor)

--10
select Distinct top 2 salary
from Instructor
order by Salary desc

--11
select Ins_Name,
				COALESCE(CAST(Salary AS VARCHAR), 'instructor bonus') as SalaryOrBonus
from Instructor

--12
select AVG(salary) as AverageSalary
from Instructor

--13
select s.St_Fname +' '+ s.St_Lname as [Student Full Name],
	   super.St_Fname +' '+ super.St_Lname as [Student Supervisor]
from Student as s join Student as super 
on s.St_super = super.St_id

--14
select Ins_Name, Dept_Id, Salary 
from (select Ins_Name, Dept_Id,Salary, 
									 ROW_NUMBER() over (PARTITION BY Dept_Id ORDER BY Salary DESC) 
									 as SalaryRank
									 from Instructor 
									 where Salary IS NOT NULL) as RankedSalaries
where SalaryRank <= 2

--15
select St_Id, St_Fname,St_Lname, Dept_Id
from (select St_Id, St_Fname, St_Lname, Dept_Id, 
												ROW_NUMBER() OVER (PARTITION BY Dept_Id ORDER BY NEWID()) 
												as rn 
												from Student) AS RankedStudents
WHERE rn = 1 AND Dept_Id IS NOT NULL
