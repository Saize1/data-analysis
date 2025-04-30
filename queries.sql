Task 1: Order & Sales Analysis
-- Order Status Distribution
SELECT 
  order_status,
  COUNT(*) AS total_orders,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM customer_orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Monthly Sales Trend (2020-2025)
SELECT 
  TO_CHAR(order_date, 'YYYY-MM') AS month,
  SUM(order_amount) AS total_sales,
  COUNT(*) AS orders_completed
FROM customer_orders
WHERE order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- Fulfillment Rate
SELECT
  ROUND(100.0 * SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fulfillment_rate
FROM customer_orders;

Task 2: Customer Analysis
-- Repeat Customers
WITH customer_stats AS (
  SELECT 
    customer_id,
    COUNT(*) AS order_count
  FROM customer_orders
  GROUP BY customer_id
)
SELECT
  'Repeat Customers' AS segment,
  COUNT(*) AS customer_count
FROM customer_stats 
WHERE order_count > 1;

-- Monthly Active Customers
SELECT 
  TO_CHAR(order_date, 'YYYY-MM') AS month,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM customer_orders
GROUP BY month
ORDER BY month;

Task 3: Payment Status Analysis
-- Payment Success/Failure Rates
SELECT 
  payment_status,
  COUNT(*) AS total_payments,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM payments
GROUP BY payment_status;

-- Payment Method Failure Analysis
SELECT
  payment_method,
  COUNT(*) AS total_transactions,
  SUM(CASE WHEN payment_status = 'failed' THEN 1 ELSE 0 END) AS failed_count,
  ROUND(100.0 * SUM(CASE WHEN payment_status = 'failed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate
FROM payments
GROUP BY payment_method
ORDER BY failure_rate DESC;

Task 4: Order Details Report
SELECT 
  o.order_id,
  o.customer_id,
  o.order_date,
  o.order_amount,
  o.order_status,
  p.payment_method,
  p.payment_status,
  p.payment_date
FROM customer_orders o
LEFT JOIN payments p ON o.order_id = p.order_id
ORDER BY o.order_date DESC;
