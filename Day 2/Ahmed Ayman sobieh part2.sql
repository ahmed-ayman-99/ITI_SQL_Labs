select *
from Employee

select Fname,Lname,salary,Dno
from Employee

select Pname,Plocation,Dnum
from Project

select Fname +' '+ Lname as [Full name], Salary * 12 * 0.1 as AnnualComm 
from employee

select SSN, Fname +' '+ Lname as [Full name]
from Employee
where Salary > 1000

select SSN, Fname +' '+ Lname as [Full name]
from Employee
where Salary*12 > 10000

select Fname +' '+ Lname as [Full name] , Salary
from Employee
where Sex = 'F'

select Dnum,Dname
from Departments
where MGRSSN = 968574

select Pnumber,Pname,Plocation
from Project
where Dnum = 10