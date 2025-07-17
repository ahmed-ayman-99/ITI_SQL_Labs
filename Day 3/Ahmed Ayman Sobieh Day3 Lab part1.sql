use Company_SD
--1
select d.Dnum,d.Dname,d.MGRSSN,e.Fname
from Departments as d,Employee as e
where d.MGRSSN = e.SSN

--2
select d.Dname,P.Pname
from Departments as d , Project as p
where d.Dnum = p.Dnum

--3
select d.* , e.Fname
from Dependent as d , Employee as e 
where e.SSN = d.ESSN

--4
select Pnumber, Pname, Plocation
from Project
where City = 'Cairo' or City = 'Alex'

--5
select p.*
from Project as p
where Pname like 'a%'

--6
select Fname
from Employee
where Dno = 30 and salary > 1000 and salary < 2000

--7
select Fname, Lname
from Employee as e 
join Works_for as wf
on e.SSN = wf.ESSn
join Project as p 
on wf.Pno = p.Pnumber
where Dno = 10 and Hours >= 10 and Pname = 'AL Rabwah'

--8
select Fname , Lname
from employee
where Superssn in 
(select SSN from Employee 
where Fname = 'Kamel' and Lname = 'Mohamed')

--9
select e.Fname, e.Lname , p.Pname
from Employee as e 
join Works_for as wf
on e.SSN = wf.ESSn
join Project as p
on wf.Pno = p.Pnumber
order by p.Pname

--10
select p.Pnumber, d.Dname, m.Lname as ManagerLastName,m.Address,m.Bdate
from Project as p
join Departments as d 
On p.Dnum = d.Dnum
join Employee as m
On d.Mgrssn = m.SSN
Where p.City = 'Cairo'

--11
select *
from Employee
where SSN in (select MGRSSN from Departments)

--12
select * 
from Employee as e left outer join Dependent as d
on e.SSN = d.ESSN

--13
insert into Employee (Fname,Lname,SSN,Address,Sex,Salary,Superssn,Dno)
values('Ahmed','Ayman',102672,'Portsaid','M',3000,112233,30)

--14
insert into Employee (Fname,Lname,SSN,Sex,Dno)
values('seif','mohamed',102660,'M',30)

--15
update Employee
set Salary = Salary * 1.2
where SSN = 102672