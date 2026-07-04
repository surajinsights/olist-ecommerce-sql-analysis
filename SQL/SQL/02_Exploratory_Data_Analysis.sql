-- Exploratory Data Analysis

-- Total Orders
SELECT COUNT(DISTINCT order_id)Total_Orders
FROM [dbo].[olist_orders_dataset$]

-- Total Customers
SELECT COUNT(DISTINCT customer_id)Total_Customers
FROM [dbo].[olist_customers_dataset$]

-- Total Sellers
SELECT COUNT(DISTINCT seller_id)Total_Sellers
FROM [dbo].[olist_sellers_dataset$]

-- Total Products
SELECT COUNT(DISTINCT product_id)Total_Products
FROM [dbo].[olist_products_dataset$]

-- Total Revenue
SELECT ROUND(SUM(payment_value),2)Total_Revenue
FROM [dbo].[olist_order_payments_dataset$]

-- Average Order Value
SELECT ROUND(AVG(Order_value),2)AVG_Order_Value
FROM (
SELECT order_id, ROUND(SUM(payment_value),2)Order_value
FROM [dbo].[olist_order_payments_dataset$]
GROUP BY order_id) AS Orders


-- FIRST ORDER DATE
SELECT CAST(MIN(order_purchase_timestamp)AS DATE)First_Order_Date
FROM [dbo].[olist_orders_dataset$]

-- Last Order Date
SELECT CAST(MAX(order_purchase_timestamp)AS DATE)Last_Order_Date
FROM [dbo].[olist_orders_dataset$]

-- Total Months of Data
SELECT DATEDIFF(MONTH,MIN(order_purchase_timestamp),MAX(order_purchase_timestamp)) AS Total_Months
FROM [dbo].[olist_orders_dataset$]

-- Number of States Served
SELECT COUNT(DISTINCT customer_state)Total_States_Served
FROM [dbo].[olist_customers_dataset$]

-- Number of Cities Served
SELECT COUNT(DISTINCT customer_city)Total_Cities_Served
FROM [dbo].[olist_customers_dataset$]

-- Average Review Score
SELECT ROUND(AVG(review_score),2)AVG_Review_Score
FROM [dbo].[olist_order_reviews_dataset$]

-- Most Used Payment Type
SELECT  TOP 1 payment_type, COUNT(*)Use_Count
FROM [dbo].[olist_order_payments_dataset$]
GROUP BY payment_type
ORDER BY COUNT(*) DESC

-- Average Delivery Time
SELECT AVG(DATEDIFF(DAY,order_purchase_timestamp, order_delivered_customer_date))Avg_Days_To_Deliver
FROM [dbo].[olist_orders_dataset$]
