CREATE DATABASE Global_Superstore;

USE Global_Superstore;

DROP TABLE IF EXISTS [superstore];




CREATE TABLE Superstore (
    Category NVARCHAR(100),
    City NVARCHAR(100),
    Country NVARCHAR(100),
    Customer_ID NVARCHAR(20),
    Customer_Name NVARCHAR(100),
    Discount DECIMAL(5,2),
    Market NVARCHAR(50),
    Record_Number INT,
    Order_Date DATETIME,
    Order_ID NVARCHAR(50),
    Order_Priority NVARCHAR(50),
    Product_ID NVARCHAR(50),
    Product_Name NVARCHAR(255),
    Profit DECIMAL(10,4),
    Quantity INT,
    Region NVARCHAR(50),
    Row_ID INT,
    Sales DECIMAL(10,2),
    Segment NVARCHAR(50),
    Ship_Date DATETIME,
    Ship_Mode NVARCHAR(50),
    Shipping_Cost DECIMAL(10,2),
    State NVARCHAR(100),
    Sub_Category NVARCHAR(100),
    Year INT,
    Market2 NVARCHAR(100),
    Weeknum INT
);


select * from dbo.Superstore;

-- Remove duplicates if any
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY Order_ID, Product_ID ORDER BY Row_ID) AS rn
    FROM Superstore
)
DELETE FROM CTE WHERE rn > 1;

--Standardize

UPDATE Superstore
SET 
    Category = LTRIM(RTRIM(Category)),
    City = LTRIM(RTRIM(City)),
    State = LTRIM(RTRIM(State)),
    Product_Name = LTRIM(RTRIM(Product_Name));

-- -- Total Sales by Year
SELECT Year, SUM(Sales) AS TotalSales
FROM Superstore
GROUP BY Year
ORDER BY Year;

-- Top 10 Products by Profit
SELECT TOP 10 Product_Name, SUM(Profit) AS TotalProfit
FROM Superstore
GROUP BY Product_Name
ORDER BY TotalProfit DESC;


-- Total Sales by Region and Segment
SELECT Region, Segment, SUM(Sales) AS TotalSales
FROM Superstore
GROUP BY Region, Segment
ORDER BY TotalSales DESC;

-- Average Discount by Category
SELECT Category, AVG(Discount) AS AvgDiscount
FROM Superstore
GROUP BY Category
ORDER BY AvgDiscount DESC;


-- Shipping Cost and Sales 
SELECT Ship_Mode, SUM(Shipping_Cost) AS TotalShipCost, SUM(Sales) AS TotalSales
FROM Superstore
GROUP BY Ship_Mode
ORDER BY TotalSales DESC;

-- Profit Margin per Product
SELECT Product_Name, SUM(Profit)/SUM(Sales)*100 AS ProfitMargin
FROM Superstore
GROUP BY Product_Name
ORDER BY ProfitMargin DESC;

--week 
SELECT Year, WeekNum, SUM(Sales) AS WeeklySales
FROM Superstore
GROUP BY Year, WeekNum
ORDER BY Year, WeekNum;

-- High Priority Orders 
SELECT Order_ID, Customer_Name, Sales, Order_Priority
FROM Superstore
WHERE Order_Priority = 'High' AND Sales > 500
ORDER BY Sales DESC;

-- Top Customers by Total Sales
SELECT Customer_ID, Customer_Name, SUM(Sales) AS TotalSales
FROM Superstore
GROUP BY Customer_ID, Customer_Name
ORDER BY TotalSales DESC;


-- Top 10 Customers by Sales
SELECT TOP 10 Customer_Name, SUM(Sales) AS Total_Sales
FROM Superstore
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;

-- Orders with High Priority 
SELECT Order_ID, Customer_Name, Sales, Order_Priority
FROM Superstore
WHERE Order_Priority = 'High' AND Sales > 500
ORDER BY Sales DESC;

-- Top 20 Products by Profit
SELECT TOP 20 Product_Name, SUM(Profit) AS Total_Profit, SUM(Sales) AS Total_Sales
FROM Superstore
GROUP BY Product_Name
ORDER BY Total_Profit DESC;



-- Sales and Profit 
SELECT Category, Sub_Category, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Superstore
GROUP BY Category, Sub_Category
ORDER BY Total_Sales DESC;

-- Top Products
SELECT Segment, Product_Name, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Superstore
GROUP BY Segment, Product_Name
ORDER BY Total_Sales DESC;

-- Match Orders 20% to Profit
SELECT Order_ID, Customer_Name, Discount, Sales, Profit
FROM Superstore
WHERE Discount > 0.2
ORDER BY Profit DESC;

-- Compare High vs Low 
SELECT Order_Priority, COUNT(Order_ID) AS Total_Orders, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM Superstore
GROUP BY Order_Priority;

select * from dbo.Superstore;

SELECT 
    Order_ID,
    Product_ID,
    Sales,
    Quantity,
    CASE WHEN Quantity = 0 THEN 0 ELSE Sales / Quantity END AS SalesPerQuantity
FROM Superstore;

SELECT 
    Order_ID,
    Product_ID,
    Sales,
    Quantity,
    CASE 
        WHEN Quantity = 0 THEN 0 
        ELSE Sales / Quantity 
    END AS SalesPerQuantity
FROM Superstore;


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Superstore'
  AND TABLE_SCHEMA = 'dbo';
