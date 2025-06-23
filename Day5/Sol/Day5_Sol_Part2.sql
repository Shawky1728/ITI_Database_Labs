
/*
1. Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales 
schema) to designate SalesOrders that occurred within the period 
‘7/28/2002’ and ‘7/29/2014’
*/

select SalesOrderID,ShipDate
from SalesLT.SalesOrderHeader
where ShipDate between'7/28/2002' and '7/29/2014'

/*
2. Display only Products(Production schema) with a StandardCost below 
$110.00 (show ProductID, Name only)
*/

select ProductID,Name
from production.Product
where StandardCost<110

/*
3. Display ProductID, Name if its weight is unknown
*/

select ProductID,Name
from  Production.Product
where Weight is null

/*
4. Display all Products with a Silver, Black, or Red Color
*/

select *
from Production.Product
where Color in ('Silver','Black','Red')

/*
5. Display any Product with a Name starting with the letter B
*/

select *
from  Production.Product
where Name like 'b%'

/*
6. Run the following Query
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

Then write a query that displays any Product description with underscore 
value in its description
*/

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

select *
from Production.Product
where Production.ProductDescription like '%[_]%'

/*
7. Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader 
table for the period between '7/1/2001' and '7/31/2014'
*/

select sum(TotalDue)
from SalesLT.SalesOrderHeader
where OrderDate between '7/1/2001' and '7/31/2014'

/*
8. Display the Employees HireDate (note no repeated values are allowed)
*/

select distinct(HireDate)
from HumanResources.Employee 

/*
9. Calculate the average of the unique ListPrices in the Product table
*/

select AVG(distinct (ListPrice))
from Production.Product

/*
10.Display the Product Name and its ListPrice within the values of 100 and 120 
the list should has the following format "The [product name] is only! [List 
price]" (the list will be sorted according to its ListPrice value)
*/

select     'The ' + Name + ' is only! ' + CAST(ListPrice AS VARCHAR) AS ProductList
from production.Product
where ListPrice between 100 and 120
order by listprice


/*
11
a) Transfer the rowguid ,Name, SalesPersonID, Demographics from
Sales.Store table in a newly created table named [store_Archive]
*/

select rowguid ,Name, SalesPersonID, Demographics into store_Archive 
from Sales.Store

/*
b) Try the previous query but without transferring the data? 
*/

select rowguid ,Name, SalesPersonID, Demographics into store_Archive 
from Sales.Store
where 1=2

/*
12.Using union statement, retrieve the today’s date in different styles
*/

select FORMAT(GETDATE(),'dddd/MMMM/yyyy')
union
select FORMAT(GETDATE(),'ddd/MMM/yyy')
union
select FORMAT(GETDATE(),'dd/MM/yy')
union
select FORMAT(GETDATE(),'dddd-MMMM-yyyy')
union
select FORMAT(GETDATE(),'dddd')
union
select FORMAT(GETDATE(),'MMM')
union
select FORMAT(GETDATE(),'yyy')