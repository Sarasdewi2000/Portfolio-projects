/* Project Data Analysis for Retail: Sales Performance Report
Created by Nelda Ampulembang Parenta, Senior Data Analyst, Logisly */

--Cek fields in the table dqlab_sales_store
SHOW COLUMNS FROM dqlab_sales_store

--Preview table
SELECT *
FROM dqlab_sales_store
LIMIT 5;

--Check order status
SELECT DISTINCT order_status
FROM dqlab_sales_store;

--Count rows
SELECT count(*) as rows
FROM dqlab_sales_store;

--Total order for each status
SELECT order_status,
	count(*) total
FROM dqlab_sales_store
GROUP BY 1
ORDER BY 2 DESC;

--Check product
SELECT product_category,
	product_sub_category
FROM dqlab_sales_store
GROUP BY 1,2
ORDER BY 1,2 ASC;

--Overall Performance by Year
SELECT YEAR(order_date) years,
	SUM(sales) sales,
	COUNT(order_id) number_of_order
FROM dqlab_sales_store
WHERE order_status = 'Order Finished'
GROUP BY 1
ORDER BY 1 ASC;

--Overall Performance by Product Sub Category in 2011 and 2012
ELECT YEAR(order_date) years,
	product_sub_category,
	SUM(sales) as sales
FROM dqlab_sales_store
WHERE order_status = 'Order Finished' AND 
	YEAR(order_date) BETWEEN 2011 AND 2012
GROUP BY 1,2
ORDER BY 1,3 DESC;

--Promotion Effectiveness and Efficiency by Years
SELECT YEAR(order_date) as years, 
	SUM(sales) as sales, 
	SUM(discount_value) as promotion_value, 
	ROUND(SUM(discount_value)/SUM(sales)*100, 2) as burn_rate_percentage
FROM dqlab_sales_store
WHERE order_status = 'Order Finished'
GROUP BY year(order_date)
ORDER BY year(order_date);

--Promotion Effectiveness and Efficiency by Product Sub Category
SELECT YEAR(order_date) AS years, 
	product_sub_category, product_category, 
	SUM(sales) as sales, SUM(discount_value) as promotion_value,
	ROUND(SUM(discount_value)/SUM(sales)*100,2) as burn_rate_percentage
FROM dqlab_sales_store
WHERE order_status = 'Order Finished' AND YEAR(order_date) = '2012'
GROUP BY product_sub_category, years, product_category
ORDER BY sales DESC;

--Customers Transactions per Year
SELECT YEAR(order_date) as years,
	COUNT(DISTINCT customer) as number_of_customer
FROM dqlab_sales_store
WHERE order_status = 'Order Finished'
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

--New customers every year
SELECT YEAR(first_order) year,
	COUNT(customer) new_customer
FROM (
	SELECT customer,
		MIN(order_date) as first_order
	FROM dqlab_sales_store
	WHERE order_status = 'Order Finished'
	GROUP BY 1
) f
GROUP BY 1;
