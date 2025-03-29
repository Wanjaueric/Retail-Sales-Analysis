CREATE DATABASE Retail_Sales;
USE Retail_Sales;

---- Create Table
CREATE TABLE Retail_Sales(
Transaction_ID INT PRIMARY KEY,
Sales_Date DATE,
Sales_Time TIME,
Customer_ID INT,
Gender VARCHAR(10),
Age INT,
Category VARCHAR(20),
Quantity INT,
Price_Per_Unit FLOAT,
COGS FLOAT,
Total_Sales FLOAT
);
SELECT * FROM retail_sales;


SELECT COUNT(*)
FROM retail_sales;

# Data Cleaning

SELECT * FROM Retail_sales
WHERE 
    Transaction_ID IS NULL
    OR
	Sales_Date IS NULL
    OR
    Sales_Time IS NULL
    OR 
    Customer_ID IS NULL 
    OR 
    Gender IS NULL 
    OR 
    Age IS NULL 
    OR 
    Category IS NULL 
    OR 
    Quantity IS NULL 
    OR 
    Price_Per_Unit IS NULL 
    OR 
    COGS IS NULL 
    OR 
    Total_Sales IS NULL;
    
# Data Exploration
-- How many sales we have?
SELECT COUNT(*) AS Total_sales 
FROM retail_sales;

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT Customer_ID)AS Customers 
FROM retail_sales;

-- How many uniuque category we have ?
SELECT DISTINCT Category AS Category 
FROM retail_sales;


# Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE Sales_Date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE 
     Category = 'Clothing'
     AND 
     DATE_FORMAT(Sales_Date, '%Y-%m') = '2022-11'
     AND 
     Quantity >= 4;
	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT Category, 
               SUM(Total_Sales) AS Net_Sales,
               COUNT(*) AS Total_Orders
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
      ROUND(AVG(Age), 2) AS Average_Age
FROM retail_sales
WHERE Category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE Total_Sales > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    Gender,
    Category,
    COUNT(*) AS Total_Transcactions 
FROM retail_sales
GROUP BY Gender, Category
ORDER BY 1;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM
(
 SELECT
       YEAR(Sales_Date) AS `Year`,
       MONTH(Sales_Date) AS `Month`,
       AVG(Total_Sales) AS Average_Sales,
       RANK() OVER(PARTITION BY YEAR(Sales_Date) ORDER BY AVG(Total_Sales) DESC) AS Best_Selling_Month
 FROM retail_sales
 GROUP BY `Year`, `Month`
 ORDER BY 1,2
 ) AS T1
WHERE Best_Selling_Month = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	  Customer_ID,
      SUM(Total_Sales) AS Total_Sales
FROM retail_sales
GROUP BY Customer_ID
ORDER BY Total_Sales DESC
LIMIT 5;
 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
      Category,
      COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM retail_sales
GROUP BY Category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH Hourly_Sales AS
(
SELECT *,
        CASE
            WHEN HOUR(Sales_Time) < 12 THEN 'Morning'
            WHEN HOUR(Sales_Time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
		END AS Shift
FROM retail_sales
)
SELECT 
	 Shift,
	 COUNT(*) AS Total_Orders
FROM Hourly_Sales
GROUP BY Shift;

