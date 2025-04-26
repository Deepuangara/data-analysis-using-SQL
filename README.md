# data-analysis-using-SQL
This repository contains a collection of SQL queries used for performing various data analysis tasks on a dataset from a project. The dataset includes information about orders, customers, products, sales, profits, and other relevant business details. These SQL queries help analyze trends, patterns, and insights such as sales performance, customer behavior, product performance, and more.

Queries Overview
1. Find Duplicates in the Dataset
Query: Identifies and returns duplicate records from the project table based on key columns such as Order ID, Order Date, Ship Date, and more.

Method: Uses the ROW_NUMBER() window function to assign unique numbers to each row, and selects rows with a row_num greater than 1.

2. Top 10 Selling Product IDs
Query: Retrieves the top 10 products based on total sales.

Method: Aggregates total sales per product and orders them in descending order.

3. Average Discount Offered Per Category
Query: Calculates the average discount offered for each product category.

Method: Uses AVG() function grouped by Category.

4. Customer with Most Orders
Query: Identifies the customer who has placed the most orders.

Method: Counts the number of orders per customer and orders them by the count in descending order.

5. Region with Highest Profit
Query: Determines which region has the highest profit.

Method: Aggregates profit by region and orders by the sum of profit in descending order.

6. Sales and Profit by Category and Sub-Category
Query: Shows total sales and profit for each product category and sub-category.

Method: Aggregates sales and profit grouped by Category and Sub-Category.

7. Month-wise Total Sales
Query: Computes the total sales per month.

Method: Extracts the month and year from the Order Date and groups the results accordingly.

8. Top 5 Cities by Number of Orders
Query: Identifies the top 5 cities with the highest number of orders.

Method: Counts orders per city and orders the results in descending order.

9. Compare Average Discount and Profit by Segment
Query: Compares average discount and profit by customer segment.

Method: Calculates average discount and profit for each segment using AVG().

10. Top 5 Customers with Highest Profit
Query: Finds the top 5 customers with the highest profit.

Method: Aggregates total profit per customer and orders them by the sum of profit in descending order.

11. Products with Average Discount Above Overall Average
Query: Identifies products with an average discount greater than the overall average discount.

Method: Uses a subquery to calculate the overall average discount and compares individual product averages to it.

12. Running Total of Sales Month-wise
Query: Calculates the running total of sales for each month.

Method: Uses the SUM() window function over partitioned data by month.

13. Top Cities Ranked by Profit
Query: Ranks cities by total profit within each region.

Method: Uses the RANK() window function partitioned by Region.

14. Cumulative Sales Over Time for Each Segment
Query: Calculates cumulative sales for each segment over time.

Method: Uses the SUM() window function partitioned by Segment.

15. Top-selling Products by Category
Query: Finds the top-selling product in each category using ranking.

Method: Uses the RANK() window function partitioned by Category.

16. First and Last Purchase Date for Each Customer
Query: Calculates the first and last purchase date for each customer.

Method: Uses MIN() and MAX() to find the first and last purchase dates.

17. Comparison of Product Profit Over Time and Current Sale's Profit
Query: Compares a product's average profit over time to its current sale's profit.

Method: Joins product data with its average profit and calculates a comparison.

18. Monthly Sales Trend for Each Region
Query: Analyzes the monthly trend of sales and profit for each region.

Method: Uses window functions to calculate percentage changes in sales and profit over time.
