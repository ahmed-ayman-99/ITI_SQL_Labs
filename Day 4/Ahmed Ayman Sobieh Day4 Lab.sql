use Company_SD

--1
select Dependent_name, d.Sex
from Dependent d join Employee e
on d.ESSN = e.SSN
where d.Sex = 'f' and e.Sex = 'f'
union
select Dependent_name, d.Sex
from Dependent d join Employee e
on d.ESSN = e.SSN
where d.Sex = 'm' and e.Sex = 'm'

--2
select p.Pname,sum(w.Hours) as Total_hours
from Project as p inner join Works_for as w
on p.Pnumber = w.Pno
group by p.Pname

--3
select d.*
from Departments as d join Employee as e
on d.Dnum = e.Dno
where e.SSN = (select min (SSN) from Employee)

--4
select d.Dname , Max(e.salary) as max_salary , MIN(e.salary) as min_salary , AVG(e.salary) as avg_salary
from Departments as d join Employee as e
on d.Dnum = e.Dno
group by d.Dname

--5
select Fname + ' ' + Lname as Full_name
from Employee as e 
where e.SSN in (select MGRSSN from Departments) 
and e.SSN not in (select ESSN from Dependent)

--6
select d.Dnum, d.Dname, count (e.SSN) as Number_of_employees
from Departments as d join Employee as e
on d.Dnum = e.Dno
group by d.Dname,d.Dnum
having avg(e.Salary) < (select avg(Salary) from employee as e)

--7
select Fname + ' ' + Lname as Full_name, p.Pname
from Employee as e join Works_for as wf
on e.SSN = wf.ESSn
join Project as p
on wf.Pno = p.Pnumber
order by e.Dno,e.Lname,e.Fname

--8
select top(2) Salary
from Employee
where Salary in (select distinct Salary from Employee)
order by Salary desc

--9
select  Fname + ' ' + Lname as Full_name
from Employee as e , Dependent as d
where e.Fname = d.Dependent_name

--10
select SSN, Fname + ' ' + Lname as Full_name
from Employee as e
where exists ( select * from Dependent as d 
				where d.ESSN = e.SSN)

--11
insert into Departments (Dname,Dnum,MGRSSN,[MGRStart Date])
values ('DEPT IT',100,112233,2006-11-1)

--12
--a
update Departments
set MGRSSN = 968574
where Dnum =100
--b
update Departments
set MGRSSN = 102672
where Dnum =20
--c
update Employee
set Superssn = 102672
where SSN = 102660

--13
delete from Dependent where ESSN = 223344
delete from Works_for where ESSn = 223344
update Employee set Superssn = NULL where Superssn = 223344
update Departments set MGRSSN = NULL where MGRSSN = 223344
delete from Employee where SSN = 223344

--14
update Employee
set Salary = Salary * 1.3 where SSN in
									(select ESSn from Works_for wf join Project p
										on wf.Pno = p.Pnumber
										where p.Pname = 'Al Rabwah')