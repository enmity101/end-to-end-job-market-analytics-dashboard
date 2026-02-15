SELECT * FROM customers
LIMIT 5;

SHOW COLUMNS FROM orders;
DESCRIBE customers;

SELECT * FROM orders
where order_date LIKE '%/%';

DESCRIBE order_items;
SELECT * FROM order_items;

-- Is Orders Same???

-- Create Orders_Month
SELECT *,
	MONTH(order_date) order_month
from orders;

-- Monthly Order Count -->  monthly orders are same
SELECT 
    MONTH(order_date) AS order_month,
    COUNT(order_id) AS total_orders
FROM Orders
GROUP BY MONTH(order_date)
ORDER BY order_month;  

-- Created a new table further research (do not use original table for your research)

CREATE TABLE orders_staging LIKE orders;
INSERT INTO orders_staging SELECT * FROM orders;
SELECT * FROM orders_staging;

-- Added a new column order_month
ALTER TABLE orders_staging
ADD COLUMN order_month INT;

UPDATE orders_staging
SET order_month = MONTH(order_date);

-- Created a View which helps me access both total order and order_month collumn

CREATE VIEW orders_monthly_summary AS
SELECT MONTH(order_date) AS order_month,
       COUNT(order_id) AS total_orders
FROM orders_staging
GROUP BY MONTH(order_date)
ORDER BY order_month;

SELECT * FROM orders_monthly_summary;

-- Made a new staging table for analysis
CREATE TABLE order_items_staging LIKE order_items;
INSERT INTO order_items_staging SELECT * FROM order_items;
SELECT * FROM order_items_staging;

-- Revenue Trends
SELECT * FROM order_items_staging;
SELECT * FROM orders_staging;

SELECT ois.*,
	os.order_date,
	os.customer_id,
    os.order_month,
    (quantity * selling_price - discount_amount) revenue
 FROM order_items_staging ois
LEFT JOIN orders_staging os ON ois.order_id = os.order_id;

-- Monthly Sales Revenue
SELECT 
    os.order_month,
    SUM(ois.quantity * ois.selling_price - ois.discount_amount) AS monthly_revenue
FROM order_items_staging ois
LEFT JOIN orders_staging os 
    ON ois.order_id = os.order_id
GROUP BY os.order_month
ORDER BY os.order_month;

-- Average Order Value
SELECT 
    os.order_month,
    COUNT(os.order_id) as Total_order,
    SUM(ois.quantity * ois.selling_price - ois.discount_amount) AS monthly_revenue,
    SUM(ois.quantity * ois.selling_price - ois.discount_amount) / COUNT(os.order_id) AS AOV
FROM order_items_staging ois
LEFT JOIN orders_staging os 
    ON ois.order_id = os.order_id
GROUP BY os.order_month
ORDER BY os.order_month;

-- Monthly Discount
SELECT 
    os.order_month,
    SUM(ois.discount_amount) AS monthly_discount
FROM order_items_staging ois
LEFT JOIN orders_staging os 
    ON ois.order_id = os.order_id
GROUP BY os.order_month
ORDER BY os.order_month;

-- Return Months
SELECT 
    MONTH(return_date) AS return_month,
    SUM(refund_amount) AS monthly_refund
FROM returns
WHERE return_date IS NOT NULL
GROUP BY MONTH(return_date)
ORDER BY return_month;

-- Net Revenue
WITH revenue AS (
    SELECT 
        os.order_month,
        SUM(ois.quantity * ois.selling_price - ois.discount_amount) AS monthly_revenue
    FROM order_items_staging ois
    LEFT JOIN orders_staging os 
        ON ois.order_id = os.order_id
    GROUP BY os.order_month
),
refunds AS (
    SELECT 
        MONTH(return_date) AS return_month,
        SUM(refund_amount) AS monthly_refund
    FROM returns
    WHERE return_date IS NOT NULL
    GROUP BY MONTH(return_date)
)
SELECT 
    r.order_month,
    r.monthly_revenue,
    COALESCE(f.monthly_refund, 0) AS monthly_refund,
    (r.monthly_revenue - COALESCE(f.monthly_refund, 0)) AS net_revenue
FROM revenue r
LEFT JOIN refunds f
    ON r.order_month = f.return_month
ORDER BY r.order_month;
 
-- when revenue decline
-- break it into volumes,value,discounts,returns

-- done




