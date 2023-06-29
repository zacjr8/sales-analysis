-- Sales Analysis Dashboard


--Create the sales data table
CREATE TABLE sales (
  transaction_id INT,
  product_id INT,
  customer_id INT,
  order_date DATE,
  quantity INT,
  price DECIMAL(10,2)
);

-- Insert sample data into the sales table
INSERT INTO sales (transaction_id, product_id, customer_id, order_date, quantity, price)
VALUES
  (1, 101, 1001, '2023-01-01', 2, 10.99),
  (2, 102, 1002, '2023-01-02', 3, 12.99),
  (3, 101, 1003, '2023-01-03', 1, 10.99),
  (4, 103, 1001, '2023-01-05', 2, 19.99),
  (5, 102, 1004, '2023-01-05', 1, 12.99),
  (6, 104, 1005, '2023-01-06', 5, 8.99);

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
