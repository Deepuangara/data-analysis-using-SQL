/*finding duplicates**/
select *,row_number() over(partition by  `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`,
    `Customer Name`, `Segment`, `Country`, `City`, `State`, `Postal Code`,
    `Region`, `Product ID`, `Category`, `Sub-Category`, `Product Name`,
    `Sales`, `Quantity`, `Discount`, `Profit`) as row_num from project;
    
with duplicate_cte as (
select *,row_number() over(partition by  `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`,
    `Customer Name`, `Segment`, `Country`, `City`, `State`, `Postal Code`,
    `Region`, `Product ID`, `Category`, `Sub-Category`, `Product Name`,
    `Sales`, `Quantity`, `Discount`, `Profit`) as row_num from project
    )
    select* from duplicate_cte where row_num>2;
/*CHANGE COLUMN NAMES IN VIEW*/

    CREATE OR REPLACE VIEW project_clean AS
SELECT
  `Order ID` AS order_id,
  `Order Date` AS order_date,
  `Ship Date` AS ship_date,
  `Ship Mode` AS ship_mode,
  `Customer ID` AS customer_id,
  `Customer Name` AS customer_name,
  segment,
  country,
  city,
  state,
  `Postal Code` AS postal_code,
  region,
  `Product ID` AS product_id,
  category,
  `Sub-Category` AS sub_category,
  `Product Name` AS product_name,
  sales,
  quantity,
  discount,
  profit
FROM project;

select * from project_clean;

select* from project;

select `Ship Mode` from project;

/**top 10 selling product id**/
select `Product ID`, sum(`sales`) as total_sales  from Project group by `Product Id` Order by total_sales desc limit 10;

select sum(`sales`)as total_sales,sum(`Profit`)as total_profit,sum(`Quantity`) as total_quantity from project;

/*What is the average discount offered per category?*/
select `Category`, round(avg(`Discount`),2)as Discount_offered from project group by `category` Order by Discount_offered;

/*List the top 10 products by total sales*/
select `Product Id` ,sum(`Sales`) as total_sales from project group by `Product Id` order by total_sales desc limit 10;

/*Which customer has placed the most orders?*/
select `Customer Name` ,count(`Order Id`) as most_orders from project group by `Customer name` Order by most_orders desc limit 1;

/*Which region has the highest profit?*/
select `Region` , sum(`Profit`) as highest_profit from project group by `Region` order by highest_profit limit 1;

/*Show total sales and profit by category and sub-category*/
select `Category`,`Sub-Category`,sum(`sales`)as total_sales ,sum(`Profit`)as total_profit from project Group by `Category` ,`Sub-Category`;

/*Find the month-wise total sales (extract month & year).*/
select date_format(STR_TO_DATE(`Order Date`, '%m/%d/%Y'),'%Y-%m')as month_year, round(sum(Sales))as total_sales  from project group by month_year order by month_year asc;

/*Identify the top 5 cities by number of orders.*/
select City , count(`order id`) as total_orders from project group by city order by total_orders desc limit 5;

/*Compare Average Discount and Profit by Segment*/
select segment, round(avg(discount),2)as avg_discount,round(avg(profit))as avg_profit from project group by segment;

/*Use a CTE to find top 5 customers with highest profit.*/
with highest_profit as(
	select `Customer ID`,`customer name`,profit 
    from project 
    )
    select `Customer Id`,`Customer Name`, sum(profit)as total_profit from highest_profit  group by `Customer Id`,`Customer Name` 
    order by total_profit desc limit 5;
    
/*Use a subquery to get products where the average discount is above the overall average discount.*/
select `Product ID`, avg(discount) as avg_discount  
from project group by `Product ID` 
having  (avg_discount) > (select avg(discount)
from project);

/*Use a CTE to calculate running total of sales month-wise.*/
with running_total as(
	  select str_to_date(`Order Date`, '%m/%d/%Y') as Order_Date,sales
     from project
     )
     select date_format(Order_Date,'%m-%Y') as month_year,sales,
     sum(sales) over (partition by date_format(Order_Date,'%m-%Y') order by Order_Date)as running_total from running_total;
     
/*For each region, rank the cities by total profit.*/
with total_profit as (
select Region,City,sum(profit) as city_profit from project group by region,city
)
select city,Region,city_profit,rank() over (partition by Region order by city_profit desc ) as Total_rank from total_profit;

/*What is the cumulative sales over time for each segment?*/
WITH cumulative_sales AS (
    SELECT 
        Segment,
        STR_TO_DATE(`Order Date`, '%m/%d/%Y') AS order_date,
        Sales
    FROM 
        project
)
SELECT 
    Segment,
    DATE_FORMAT(order_date, '%Y-%m') AS month_year,
    SUM(Sales) OVER (PARTITION BY Segment ORDER BY order_date) AS cumulative_sales
FROM 
    cumulative_sales
ORDER BY 
    Segment, month_year;
    
/*Find the top-selling product in each category (using RANK()).*/
with top_selling as (
select sum(sales)as total_sales,`product name`,Category from project group by `product name`,category
)
select total_sales,`product name`,Category , rank() over(partition by Category order by total_sales desc) as top_selling_products from top_selling ;

/*For each customer, calculate their first and last purchase date.*/
with purchase_date as (
select  `Customer ID` ,str_to_date(`order date`,'%m/%d/%Y')as order_date from project 
)
select `customer ID`,max(order_date)as last_date,min(order_date)as first_date from purchase_date group by `Customer ID`;

/*For each product, calculate the average profit over time and compare it to its current sale's profit.*/
WITH average_profit AS (
    SELECT 
        `Product ID`,
        AVG(Profit) AS avg_profit 
    FROM 
        project 
    GROUP BY 
        `Product ID`
)

SELECT
    p.`Product ID`,
    DATE_FORMAT(STR_TO_DATE(p.`Order Date`, '%m/%d/%Y'),'%Y-%m') AS month_year,
    p.Profit AS current_profit,
    ap.avg_profit,
    CASE 
        WHEN p.Profit > ap.avg_profit THEN 'Above Average'
        WHEN p.Profit < ap.avg_profit THEN 'Below Average'
        ELSE 'Equal to Average'
    END AS profit_comparison
FROM 
    project p
JOIN 
    average_profit ap 
ON 
    p.`Product ID` = ap.`Product ID`
ORDER BY 
    p.`Product ID`, month_year;

/*select distinct region from project;*/

/*Analyze the monthly trend of sales for each region.*/
WITH monthly_trend AS (
    SELECT 
        region,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        DATE_FORMAT(STR_TO_DATE(`Order Date`, '%m/%d/%Y'), '%Y-%m') AS month_year
    FROM 
        project
    GROUP BY 
        region, month_year
)
SELECT 
    region,
    total_sales,
    month_year,
    ((total_sales - LAG(total_sales) OVER (PARTITION BY region ORDER BY month_year)) / 
    LAG(total_sales) OVER (PARTITION BY region ORDER BY month_year)) * 100 AS sales_percentage,
    
    ((total_profit - LAG(total_profit) OVER (PARTITION BY region ORDER BY month_year)) / 
    LAG(total_profit) OVER (PARTITION BY region ORDER BY month_year)) * 100 AS profit_percentage
FROM 
    monthly_trend
ORDER BY 
    month_year;
 

