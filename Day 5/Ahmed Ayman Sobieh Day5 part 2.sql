--Day 5 - part2

use AdventureWorks2012

--1
select SalesOrderID, ShipDate
from sales.SalesOrderHeader
where OrderDate between '2002-07-28' and '2014-07-29'

--2
select ProductID,Name
from Production.Product
where StandardCost < 110

--3
select ProductID,Name
from Production.Product
where Weight is NULL

--4
select ProductID,Name
from Production.Product
where Color in ('Silver', 'Black', 'Red')

--5
select ProductID,Name
from Production.Product
where Name like 'B_%'

--6
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3


select *
from Production.ProductDescription
where Description like '%[_]%'

--7
select OrderDate, sum(TotalDue) as TotalDue
from sales.SalesOrderHeader
where OrderDate between '2001-01-07' and '2014-07-31'
group by OrderDate 

--8
select distinct HireDate
from HumanResources.Employee

--9
select distinct AVG(ListPrice) as AverageListPrice
from Production.Product

--10
select 'The' + Name + 'is only!' + cast(ListPrice as varchar) + 'Price' as [Product price]
from Production.Product
where ListPrice between '100' and '120'
order by ListPrice

--11 a)
select rowguid, Name, SalesPersonID, Demographics
into store_Archive
from Sales.Store
-------check--------200

-- b)
select rowguid, Name, SalesPersonID, Demographics
from Sales.Store

--12
select convert (varchar,GETDATE()) as [Today's Date]
union
select FORMAT (GETDATE(),'yyyy-MM-dd')
union 
select FORMAT (GETDATE(),'dd/MM/yyyy')
