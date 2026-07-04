-- Check if we have any duplicate Order ID

SELECT order_id, COUNT(*)
FROM [dbo].[olist_orders_dataset$]
GROUP BY order_id
HAVING COUNT(*) > 1;	

-- Check if Customer ID & Order ID have null values

SELECT COUNT(*)
FROM [dbo].[olist_orders_dataset$]
WHERE customer_id IS NULL OR
order_id IS NULL

-- Check if Order ID have null values in Payment Dataset

SELECT COUNT(*)
FROM [dbo].[olist_order_payments_dataset$]
WHERE order_id IS NULL

-- Check if Order ID have null values in Order Items Dataset

SELECT COUNT(*)
FROM [dbo].[olist_order_items_dataset$]
WHERE order_id IS NULL

-- Customer ID, Foreign Key Integration Check

SELECT C.customer_id
FROM [dbo].[olist_customers_dataset$] C
RIGHT JOIN [dbo].[olist_orders_dataset$] O
ON C.customer_id = O.customer_id
WHERE C.customer_id is NULL

-- Order ID, Foreign Key Integration Check

SELECT O.order_id
FROM [dbo].[olist_orders_dataset$] O
RIGHT JOIN [dbo].[olist_order_payments_dataset$] P
ON P.order_id = O.order_id
WHERE O.order_id is NULL

-- Is there any Problem with Delivery Mechanism

SELECT *
FROM [dbo].[olist_orders_dataset$]
WHERE order_purchase_timestamp>order_delivered_customer_date

-- Is there any Negative Payment Values (Error Detection)

SELECT *
FROM [dbo].[olist_order_payments_dataset$]
WHERE payment_value<0

-- Is there any Empty Product Categories

SELECT *
FROM [dbo].[olist_products_dataset$]
WHERE product_category_name IS NULL

-- These 610 products have no assigned category. 
-- For reporting purposes, they are labeled as 'Unknown'

UPDATE [dbo].[olist_products_dataset$]
SET product_category_name = 'Unknown'
WHERE product_category_name IS NULL
