USE AdventureWorks2019;
SELECT FirstName + ' ' + LastName AS 'Name', EmailAddress, JobTitle FROM Person.Person a
INNER JOIN [Person].[EmailAddress] b ON a.BusinessEntityID = b.BusinessEntityID
INNER JOIN [HumanResources].[Employee] c ON a.BusinessEntityID = c.BusinessEntityID;

SELECT DISTINCT COUNT(ProductID) AS 'Total Products' FROM [Production].[Product];

SELECT CustomerID, SUM(TotalDue) AS 'Total Sales Amount' FROM [Sales].[SalesOrderHeader] 
GROUP BY CustomerID ORDER BY CustomerID;

SELECT AVG(ListPrice) AS 'Average_List_Price' FROM [Production].[Product];

SELECT C.Name, AVG(ListPrice) AS 'Avg_ListPrice', 
MIN(ListPrice) AS 'Min_ListPrice', MAX(ListPrice) AS 'Max_ListPrice'
FROM [Production].[Product] A

INNER JOIN [Production].[ProductSubcategory] B 
ON A.ProductSubcategoryID = B.ProductSubcategoryID

INNER JOIN [Production].[ProductCategory] C
ON B.ProductCategoryID = C.ProductCategoryID
GROUP BY C.Name;

SELECT B.Name, COUNT(BusinessEntityID) AS 'Total Employees' 
FROM [HumanResources].[EmployeeDepartmentHistory] A
INNER JOIN [HumanResources].[Department] B
ON A.DepartmentID = B.DepartmentID
GROUP BY B.Name HAVING COUNT(BusinessEntityID) > 10;

SELECT P.ProductID, P.Name AS 'Product_Never_Sold' FROM [Production].[Product] P 
LEFT JOIN [Sales].[SalesOrderDetail] O
ON P.ProductID = O.ProductID
WHERE O.ProductID IS NULL;

SELECT * FROM [HumanResources].[Employee] WHERE YEAR(HireDate) = 2019;

SELECT UPPER(FirstName)FirstName, UPPER(LastName)LastName FROM [Person].[Person];

SELECT O.SalesOrderID, P.Name AS 'ProductName', OrderQty, 
PP.FirstName+' '+PP.LastName AS SalesPersonName FROM [Production].[Product] P 
FULL OUTER JOIN [Sales].[SalesOrderDetail] O
ON P.ProductID = O.ProductID
INNER JOIN [Sales].[SalesOrderHeader] SOH
ON O.SalesOrderID = SOH.SalesOrderID
INNER JOIN [Person].[Person] PP
ON PP.BusinessEntityID = SOH.SalesPersonID;

SELECT P.BusinessEntityID, P.FirstName, P.LastName
FROM [Person].[Person] P
INNER JOIN Sales.SalesOrderHeader soh ON P.BusinessEntityID = soh.SalesPersonID
INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE sod.ProductID NOT IN (
    SELECT sod2.ProductID
    FROM Sales.SalesOrderDetail sod2
    INNER JOIN Sales.SalesOrderHeader soh2 ON sod2.SalesOrderID = soh2.SalesOrderID
    WHERE soh2.SalesPersonID != P.BusinessEntityID
)
GROUP BY P.BusinessEntityID, P.FirstName, P.LastName;

SELECT D.DepartmentID, D.Name, COALESCE(AVG(Rate), 0)  AS 'Average Salary' 
FROM [HumanResources].[Department] D
LEFT JOIN [HumanResources].[EmployeeDepartmentHistory] EDH
ON D.DepartmentID = EDH.DepartmentID
INNER JOIN [HumanResources].[EmployeePayHistory] EPH
ON EDH.BusinessEntityID = EPH.BusinessEntityID
GROUP BY D.DepartmentID, D.Name ORDER BY D.DepartmentID;

SELECT TOP 10 p.Name AS 'ProductName', SUM(sod.LineTotal) AS 'TotalSalesAmount', 
RANK() OVER (ORDER BY SUM(sod.LineTotal) DESC)RANK
FROM [Sales].[SalesOrderDetail] sod
INNER JOIN [Sales].[SalesOrderHeader] soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN [Production].[Product] p ON sod.ProductID = p.ProductID
GROUP BY p.Name;

SELECT P.ProductID, P.Name, COALESCE(SUM(OrderQty),0)Total_Qty_Sold FROM [Production].[Product] P
LEFT JOIN [Sales].[SalesOrderDetail] SOD
ON SOD.ProductID = P.ProductID GROUP BY P.ProductID, P.Name ORDER BY P.ProductID;

Find the second highest selling product in terms of total sales amount.

SELECT TOP 1 ProductID, Total_Sales_Amt FROM 
(SELECT TOP 2 ProductID, SUM(LineTotal)Total_Sales_Amt FROM [Sales].[SalesOrderDetail] 
GROUP BY ProductID ORDER BY Total_Sales_Amt DESC)Ranking
ORDER BY Total_Sales_Amt ASC;

SELECT PC.Name AS 'Category_Name', SUM(LineTotal)Total_Revenue,
CASE
	WHEN SUM(LineTotal) > 1000000 THEN 'High Revenue'
	WHEN SUM(LineTotal) BETWEEN 500000 AND 1000000 THEN 'Medium Revenue'
	ELSE 'Low Revenue'
END AS 'Revenue Classification'
FROM [Sales].[SalesOrderDetail] SOD
INNER JOIN [Production].[Product] P ON P.ProductID = SOD.ProductID
INNER JOIN [Production].[ProductSubcategory] PSC ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
INNER JOIN [Production].[ProductCategory] PC ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY PC.Name;