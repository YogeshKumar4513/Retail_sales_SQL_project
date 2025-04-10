-- Retail sales Analysis
drop table if exists retail_sales;

# Create table

create table retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity INT,
                price_per_unit FLOAT,	
                cogs FLOAT,
                total_sale FLOAT
            );




select * from retail_sales;
limit 10;

select count(*) from retail_sales;


-- Data Cleaning

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    


-- Data Exploration

#total number of sales
select count(*) as total_sale from retail_sales;

#Number of Unique customers
select count(distinct(customer_id)) as Customers from retail_sales;

#Unique category
select distinct(category) from retail_sales;

-- Data Analysis & Business Key Problems

#SQL query to retrieve all columns for sales made on '2022-11-05
select *
from retail_sales
where sale_date = '2022-11-05';

#SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Retrieve all 'Clothing' category transactions with quantity > 4 in November 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 3
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';


#SQL query to calculate the total sales (total_sale) for each category

select 
	category,
	sum(total_sale) as Net_sales,
	count(*) as total_order
from  retail_sales
group by category;

#SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT
    category,round(avg(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

#SQL query to find all transactions where the total_sale is greater than 1000
select *)
from retail_sales
where total_sale > 1000;

#SQL query to find the total number of transactions (transaction_id) made by each gender in each category

select 
	category,
	gender,
	count(*) as total_transaction
from retail_sales
group by 
	category,
	gender
order by category;

#SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
    year,
    month,
    avg_sale 
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS ranks
    FROM retail_sales
    GROUP BY year, month
) AS t1
WHERE ranks = 1;


#SQL query to find the top 5 customers based on the highest total sales

select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by retail_sales.customer_id 
order by total_sales desc
limit 5;


#SQL query to find the number of unique customers who purchased items from each category

select 
	category,
	count(DISTINCT customer_id) as cnt_unique_customer
from retail_sales
group by category;


#SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- end of project
