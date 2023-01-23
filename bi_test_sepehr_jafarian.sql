
--الف) 

--1

SELECT SUM(Quantity * UnitPrice) AS [Total Sale] FROM [Sale Table]

--2

SELECT COUNT(DISTINCT Customer) AS [Customer Count] FROM [Sale Table]

--3

SELECT Product, SUM(Quantity * UnitPrice) AS [Sale Per Product] FROM [Sale Table]
GROUP BY Product;

--4
SELECT Customer, SUM(Quantity * UnitPrice) AS Sale, COUNT(DISTINCT OrderID) [Count Order], COUNT(DISTINCT Product) [Count Item]
FROM [Sale Table]
WHERE Customer IN(
SELECT Customer FROM [Sale Table] GROUP BY Customer, OrderID HAVING SUM(Quantity * UnitPrice) > 1500)
GROUP BY Customer
;

-- 5
WITH 
	Product_Sale AS (
						SELECT ST.Product, SUM(Quantity * UnitPrice) Sale FROM [Sale Table] ST 
						GROUP BY ST.Product),
	Product_Profit AS (
						SELECT PS.Product, Sale, Sale * ISNULL(ProfitRatio, 0.1) Profit
						FROM Product_Sale PS LEFT JOIN [Sale Profit] SP ON PS.Product = SP.Product)
SELECT SUM(Profit) AS Profit, FORMAT(SUM(Profit) / SUM(Sale), '%##.##') AS Profit_Margin

FROM Product_Profit;

-- 6
WITH T AS (
SELECT COUNT(DISTINCT OrderID) [Count], [Date] FROM [Sale Table]
GROUP BY [Date])
SELECT SUM([Count]) AS [Count] FROM T;

-- ب
WITH managers AS (
					SELECT Id, [name], manager, ManagerID, 1 AS org_level
					FROM OrgChart WHERE ManagerId IS NULL

					UNION ALL
					SELECT O.Id, O.[name], O.manager, O.ManagerId, M.org_level + 1

					FROM OrgChart O INNER JOIN managers M ON O.ManagerId = M.ID

			)
SELECT * INTO org_chart_with_level
FROM managers ORDER BY org_level