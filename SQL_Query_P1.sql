CREATE Database Projects;

Use Projects;

CREATE table retail_sales
( 
  transactions_id INT,
  sale_date	DATE,
  sale_time TIME,
  customer_id INT,	
  gender Varchar(25),	
  age	INT,
  category Varchar(25),
  quantiy	INT,
  price_per_unit FLOAT,	
  cogs	FLOAT,
  total_sale FLOAT
);

SELECT COUNT(*) from retail_sales;

-- Data Cleaning
SELECT * from retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- Data Exploration
-- How Many Unique customers we have 
SELECT COUNT( DISTINCT customer_id) from retail_sales;
SELECT DISTINCT category from retail_sales;

-- Data Analysis on business key problems and Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * 
FROM retail_sales 
WHERE 
  category = 'Clothing' 
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11' 
  AND quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT SUM(total_sale) as total_sale, category, COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT AVG(age), category 
FROM retail_sales
WHERE category = 'beauty'
GROUP BY category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale >1000;  

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select count(transactions_id), category, gender
from retail_sales
GROUP BY category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH cte as
(Select ROUND(avg(total_sale),2) as avgsale,
date_format(sale_date, '%Y') as year,
date_format(sale_date, '%M') as month,
RANK() OVER(partition by date_format(sale_date, '%Y') order by ROUND(avg(total_sale),2) DESC) as rk 
from retail_sales
GROUP BY year, month)
SELECT year,month,avgsale
from cte
where rk <2;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale)
from retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select COUNT(DISTINCT customer_id) as unique_customers , category 
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale as
(SELECT *,
CASE 
    WHEN HOUR(sale_time) <= 12 THEN 'MOrning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
    END AS shift
From retail_sales)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
    



