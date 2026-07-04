-- Revenue Analysis
-- Top 10 product categories by revenue
SELECT TOP 10 Tra.product_category_name_english AS Product_Category, ROUND(SUM(O.price),2)Total_Revenue
FROM [dbo].[olist_order_items_dataset$] O
INNER JOIN [dbo].[olist_products_dataset$] Pro
ON Pro.product_id = O.product_id
INNER JOIN [dbo].[product_category_name_translati$] Tra
ON Pro.product_category_name = Tra.product_category_name
GROUP BY Tra.product_category_name_english
ORDER BY Total_Revenue DESC;
-- Health_Beauty is our Top Product Category with Total Revenue of 1.26 Million


-- Monthly revenue trend
SELECT FORMAT(O.order_purchase_timestamp,'yyyy-MM') AS Months, ROUND(SUM(payment_value),2) AS Revenue
FROM [dbo].[olist_order_payments_dataset$] P
INNER JOIN [dbo].[olist_orders_dataset$] O
ON P.order_id = O.order_id
GROUP BY FORMAT(O.order_purchase_timestamp,'yyyy-MM')
ORDER BY Months;
-- Revenue declined sharply in September 2018


-- Top 10 cities by revenue
SELECT TOP 10 customer_city AS City, ROUND(SUM(payment_value),2)Revenue
FROM [dbo].[olist_order_payments_dataset$] P
INNER JOIN [dbo].[olist_orders_dataset$] O
ON P.order_id = O.order_id
INNER JOIN [dbo].[olist_customers_dataset$] C
ON O.customer_id = C.customer_id
GROUP BY customer_city
ORDER BY Revenue DESC
-- Sao Paulo city generated the highest revenue among all cities.


-- Top 10 states by revenue
SELECT TOP 10 customer_state AS State, ROUND(SUM(payment_value),2)Revenue
FROM [dbo].[olist_order_payments_dataset$] P
INNER JOIN [dbo].[olist_orders_dataset$] O
ON P.order_id = O.order_id
INNER JOIN [dbo].[olist_customers_dataset$] C
ON O.customer_id = C.customer_id
GROUP BY customer_state
ORDER BY Revenue DESC
-- São Paulo (SP) generated the highest revenue among all states.


-- Customer Analysis
-- Top spending customers
SELECT TOP 10 C.customer_unique_id, ROUND(SUM(P.payment_value),2)Total_Spend
FROM [dbo].[olist_order_payments_dataset$] P
INNER JOIN [dbo].[olist_orders_dataset$] O
ON O.order_id = P.order_id
INNER JOIN [dbo].[olist_customers_dataset$] C
ON O.customer_id = C.customer_id
GROUP BY C.customer_unique_id
ORDER BY Total_Spend DESC
-- Top-spending customers represent the marketplace's most valuable customer segment.


-- Customer distribution by state
SELECT customer_state AS State, COUNT(*)Customer_Count
FROM [dbo].[olist_customers_dataset$]
GROUP BY customer_state
ORDER BY Customer_Count DESC
-- São Paulo (SP) have most Customers among all States


-- New vs repeat customers
SELECT New_Repeat, COUNT(*) AS 'Customer_Count' 
FROM 
(SELECT C.customer_unique_id, 
	CASE 
	WHEN COUNT(order_id) > 1 THEN 'Repeat'
	ELSE 'New'
	END AS 'New_Repeat'
FROM [dbo].[olist_orders_dataset$] O
INNER JOIN [dbo].[olist_customers_dataset$] C
ON O.customer_id = C.customer_id
GROUP BY C.customer_unique_id)Sub_query
GROUP BY New_Repeat
-- Need to work on Retaining Customers as there are only 2997 Customers with Repeat Purchase


-- Average customer spending
SELECT ROUND(AVG(Total_Spend),2)Avg_Spend
FROM
(SELECT ROUND(SUM(P.payment_value),2)Total_Spend
FROM [dbo].[olist_orders_dataset$] O
INNER JOIN [dbo].[olist_order_payments_dataset$] P
ON O.order_id = P.order_id
GROUP BY O.customer_id)Sub_Queryy


-- Delivery Analysis
-- Average delivery time by state
SELECT C.customer_state, AVG(DATEDIFF(DAY,O.order_purchase_timestamp,O.order_delivered_customer_date))AS Avg_Delivery_Days
FROM [dbo].[olist_orders_dataset$] O
INNER JOIN [dbo].[olist_customers_dataset$] C
ON O.customer_id = C.customer_id
GROUP BY C.customer_state
ORDER BY Avg_Delivery_Days DESC
-- Customers in RR, AP, AM, AL, and PA experience the longest average
-- delivery times, indicating potential opportunities to improve
-- logistics efficiency in these regions.


-- Late delivery percentage
SELECT 
CAST(
(
SELECT COUNT(*)
FROM [dbo].[olist_orders_dataset$]
WHERE order_estimated_delivery_date < order_delivered_customer_date
) 
* 100.0 /
(SELECT COUNT(*) 
FROM [dbo].[olist_orders_dataset$]
WHERE order_delivered_customer_date IS NOT NULL) AS DECIMAL(4,2)) AS Delay_Percentage
-- Approximately 92% of orders were delivered on or before the estimated delivery date


-- Fastest sellers
SELECT TOP 20 S.seller_id,COUNT(*)Order_Count, ROUND(AVG(DATEDIFF(HOUR,O.order_approved_at,O.order_delivered_carrier_date)),2)AS Hours_to_courier
FROM [dbo].[olist_sellers_dataset$] S
INNER JOIN [dbo].[olist_order_items_dataset$] OI
ON S.seller_id = OI.seller_id
INNER JOIN [dbo].[olist_orders_dataset$] O
ON O.order_id = OI.order_id
WHERE order_delivered_carrier_date IS NOT NULL AND O.order_approved_at < O.order_delivered_carrier_date
GROUP BY S.seller_id
HAVING COUNT(*)>=30
ORDER BY Hours_to_courier
--	Top sellers dispatch orders to the carrier in the shortest average time


-- Slowest sellers
SELECT TOP 20 S.seller_id,COUNT(*)Order_Count, ROUND(AVG(DATEDIFF(HOUR,O.order_approved_at,O.order_delivered_carrier_date)),2)AS Hours_to_courier
FROM [dbo].[olist_sellers_dataset$] S
INNER JOIN [dbo].[olist_order_items_dataset$] OI
ON S.seller_id = OI.seller_id
INNER JOIN [dbo].[olist_orders_dataset$] O
ON O.order_id = OI.order_id
WHERE order_delivered_carrier_date IS NOT NULL AND O.order_approved_at < O.order_delivered_carrier_date
GROUP BY S.seller_id
HAVING COUNT(*)>=30
ORDER BY Hours_to_courier DESC;
--	Sellers with the longest average dispatch time to the carrier


-- Product Analysis
-- Lowest Product Categories by Revenue
SELECT TOP 1 Tra.product_category_name_english AS Product_Category, ROUND(SUM(O.price),2)Total_Revenue
FROM [dbo].[olist_order_items_dataset$] O
INNER JOIN [dbo].[olist_products_dataset$] Pro
ON Pro.product_id = O.product_id
INNER JOIN [dbo].[product_category_name_translati$] Tra
ON Pro.product_category_name = Tra.product_category_name
GROUP BY Tra.product_category_name_english
ORDER BY Total_Revenue ASC;
-- Security & Services is the Lowest Revenue generating Category

-- Products Never Sold
SELECT Pro.product_id
FROM [dbo].[olist_order_items_dataset$] O
RIGHT JOIN [dbo].[olist_products_dataset$] Pro
ON Pro.product_id = O.product_id
WHERE O.order_id IS NULL


--.Review Analysis (3 queries)
-- Does delivery time affect reviews?
SELECT R.review_score,AVG(DATEDIFF(DAY,O.order_purchase_timestamp,O.order_delivered_customer_date))AS Avg_Delivery_Days
FROM [dbo].[olist_order_reviews_dataset$] R
INNER JOIN [dbo].[olist_orders_dataset$] O
ON O.order_id = R.order_id
GROUP BY R.review_score
ORDER BY Avg_Delivery_Days DESC
-- Yes, Delivery time does affect the review scores by Customers.

-- Average review by category
SELECT PN.product_category_name_english AS Product_Name, ROUND(AVG(R.review_score),2)Review_Score, COUNT(*)Total_Reviews
FROM [dbo].[olist_order_reviews_dataset$] R
INNER JOIN [dbo].[olist_order_items_dataset$] O
ON O.order_id = R.order_id
INNER JOIN [dbo].[olist_products_dataset$] P
ON P.product_id = O.product_id
INNER JOIN [dbo].[product_category_name_translati$] PN
ON PN.product_category_name = P.product_category_name
GROUP BY PN.product_category_name_english
HAVING COUNT(*) >=10
ORDER BY Review_Score
-- "Diapers & Hygiene" have lowest review score


-- Sellers with best ratings
SELECT TOP 10 O.seller_id, ROUND(AVG(R.review_score),2)Review_Score, COUNT(*)Total_Reviews
FROM [dbo].[olist_order_reviews_dataset$] R
INNER JOIN [dbo].[olist_order_items_dataset$] O
ON O.order_id = R.order_id
GROUP BY O.seller_id
HAVING COUNT(*) >=50
ORDER BY Review_Score DESC


-- Payment Analysis
-- Installment distribution
SELECT payment_installments, COUNT(*)AS Total_Orders
FROM [dbo].[olist_order_payments_dataset$]
GROUP BY payment_installments
HAVING COUNT(*)>=20
ORDER BY payment_installments
--Most Customers are preferring 1 or 2 Installments only


-- Payment Method vs Order Value
SELECT payment_type,ROUND(AVG(payment_value),2)Total_Amount
FROM [dbo].[olist_order_payments_dataset$]
GROUP BY payment_type
HAVING COUNT(*) >=20
ORDER BY Total_Amount DESC
-- voucher gets mostly used on low order value orders
