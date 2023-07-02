-- Sales Analysis Dashboard


--Create the sales data table
CREATE TABLE sales (
  transaction_id INT,
  product_id INT,
  customer_id INT,
  order_date DATE,
  quantity INT,
  price DECIMAL(10,2),
  
);

ALTER TABLE sales
ADD COLUMN customer_type VARCAR(20);


-- Insert sample data into the sales table
INSERT INTO sales (transaction_id, product_id, customer_id, order_date, quantity, price, customer_type)
VALUES
  (1, 101, 1001, '2022-01-01', 2, 10.99, 'New'),
  (2, 102, 1002, '2022-01-02', 3, 12.99, 'New'),
  (3, 101, 1003, '2022-01-03', 1, 10.99, 'Returning'),
  (4, 103, 1001, '2022-02-05', 2, 19.99, 'Returning'),
  (5, 102, 1004, '2022-02-05', 1, 12.99, 'New'),
  (6, 104, 1005, '2023-01-06', 5, 8.99, 'New');


  DELETE FROM sales
WHERE customer_type IS NULL;



--View the table
SELECT * FROM sales;

 -- Calculate total sales revenue
SELECT SUM(quantity * price) AS total_revenue
FROM sales;

-- Calculate average order value
SELECT AVG(quantity * price) AS average_order_value
FROM sales;

-- Get top-selling products
SELECT product_id, COUNT(*) AS sales_count
FROM sales
GROUP BY product_id
ORDER BY sales_count DESC
LIMIT 5;

-- Calculate customer retention rate
--SELECT COUNT(DISTINCT customer_id) AS total_customers,
--       COUNT(DISTINCT CASE WHEN YEAR(order_date) = YEAR(CURRENT_DATE) - 1 THEN customer_id END) AS returning_customers,
--       COUNT(DISTINCT CASE WHEN YEAR(order_date) = YEAR(CURRENT_DATE) THEN customer_id END) AS new_customers,
--       (COUNT(DISTINCT CASE WHEN YEAR(order_date) = YEAR(CURRENT_DATE) THEN customer_id END) / COUNT(DISTINCT customer_id)) * 100 AS retention_rate
--FROM sales;

-- Calculate customer retention rate for SQLite
SELECT COUNT(DISTINCT customer_id) AS total_customers,
       COUNT(DISTINCT CASE WHEN strftime('%Y', order_date) = strftime('%Y', 'now', '-1 year') THEN customer_id END) AS returning_customers,
       COUNT(DISTINCT CASE WHEN strftime('%Y', order_date) = strftime('%Y', 'now') THEN customer_id END) AS new_customers,
       (COUNT(DISTINCT CASE WHEN strftime('%Y', order_date) = strftime('%Y', 'now') THEN customer_id END) / COUNT(DISTINCT customer_id)) * 100 AS retention_rate
FROM sales;

-- Generate a monthly sales report
--SELECT YEAR(order_date) AS year,
--       MONTH(order_date) AS month,
--       SUM(quantity * price) AS monthly_revenue
--FROM sales
--GROUP BY YEAR(order_date), MONTH(order_date)
--ORDER BY YEAR(order_date), MONTH(order_date);


-- Generate a monthly sales report for SQLite
SELECT strftime('%Y', order_date) AS year,
       strftime('%m', order_date) AS month,
       SUM(quantity * price) AS monthly_revenue
FROM sales
GROUP BY strftime('%Y', order_date), strftime('%m', order_date)
ORDER BY strftime('%Y', order_date), strftime('%m', order_date);


--View the table
SELECT * FROM sales;

--Total Sales Revenue by month
SELECT strftime('%Y-%m', order_date) AS month,
       SUM(quantity * price) AS revenue
FROM sales
GROUP BY month
ORDER BY month;

--Top Selling Product
SELECT product_id,
       COUNT(*) AS sales_count
FROM sales
GROUP BY product_id
ORDER BY sales_count DESC
LIMIT 5;

--Sales Distribution by Customer Type
SELECT CASE WHEN customer_type = 'New' THEN 'New Customer'
            WHEN customer_type = 'Returning' THEN 'Returning Customer'
            ELSE 'Unknown' END AS customer_type,
       COUNT(*) AS sales_count
FROM sales
GROUP BY customer_type;

--Monthly Revenue Comparison (Year-over-Year)
SELECT strftime('%Y-%m', order_date) AS month,
       SUM(CASE WHEN strftime('%Y', order_date) = '2022' THEN quantity * price END) AS revenue_2022,
       SUM(CASE WHEN strftime('%Y', order_date) = '2023' THEN quantity * price END) AS revenue_2023
FROM sales
WHERE strftime('%Y', order_date) IN ('2022', '2023')
GROUP BY month
ORDER BY month;



