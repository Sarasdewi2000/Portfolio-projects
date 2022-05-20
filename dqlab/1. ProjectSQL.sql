/* Project 1 : Data Analysis for Retail: Sales Performance Report
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

/* Project 2 : Data Engineer Challenge with SQL
Created by Xeratic */

--Multiple choice about LEFT JOIN, INNER JOIN
SELECT * FROM table1
INNER JOIN table2 ON table2.nama = table1.nama;

--Filtering
SELECT * FROM table1 WHERE nama = 'Cyntia' OR nama = 'Rheny';
SELECT * FROM table1 WHERE nama IN ('Cyntia', 'Rheny');
SELECT * FROM table1 WHERE nama LIKE 'Cyntia' OR nama LIKE 'Rheny';

--Multiple choice about UNION
SELECT nama FROM table1
UNION
SELECT nama FROM table2;

--Product in DQLab Mart
SELECT no_urut, 
	kode_produk,
	nama_produk,
	harga
FROM ms_produk
WHERE harga BETWEEN 50000 AND 150000;

SELECT no_urut, 
	kode_produk,
	nama_produk,
	harga
FROM ms_produk
WHERE nama_produk like '%Flashdisk%';

--Customers in DQLab Mart
SELECT nama_pelanggan
FROM ms_pelanggan
ORDER BY 1;

--Customers' name with title
SELECT no_urut,
	kode_pelanggan,
	nama_pelanggan,
	alamat
FROM ms_pelanggan
WHERE nama_pelanggan LIKE '%S.H%' OR nama_pelanggan LIKE '%Ir.%' OR nama_pelanggan LIKE '%Drs%' ;

--Sort customers' name without title 
SELECT nama_pelanggan
FROM ms_pelanggan
ORDER BY SUBSTRING_INDEX(nama_pelanggan,'. ', -1)

--Longest customer's name
SELECT nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) IN
	(SELECT MAX(LENGTH(nama_pelanggan))
	FROM ms_pelanggan);

--Longest and shortest customer's name with title
SELECT nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) IN (
  (SELECT MAX(LENGTH(nama_pelanggan)) FROM ms_pelanggan)) OR
	LENGTH(nama_pelanggan) IN
 ((SELECT MIN(LENGTH(nama_pelanggan)) FROM ms_pelanggan)
)
ORDER BY LENGTH(nama_pelanggan) DESC;

--Quantity of Products Sold
SELECT p.kode_produk,
	p.nama_produk,
	SUM(d.qty) as total_qty
FROM ms_produk as p
INNER JOIN tr_penjualan_detail as d
ON p.kode_produk = d.kode_produk
GROUP BY 1,2
ORDER BY SUM(d.qty) DESC
LIMIT 2;

SELECT p.kode_produk,
	p.nama_produk,
	SUM(d.qty) as total_qty
FROM ms_produk as p
INNER JOIN tr_penjualan_detail as d
ON p.kode_produk = d.kode_produk
GROUP BY 1,2
HAVING total_qty >=7 ;

--Customer high quality based on the Highest Shopping Value
SELECT ms_pelanggan.kode_pelanggan,
	ms_pelanggan.nama_pelanggan,
	SUM(tr_penjualan_detail.qty*tr_penjualan_detail.harga_satuan) AS total_harga
FROM ms_pelanggan 
INNER JOIN 
	tr_penjualan ON ms_pelanggan.kode_pelanggan = tr_penjualan.kode_pelanggan
INNER JOIN 
	tr_penjualan_detail ON tr_penjualan_detail.kode_transaksi = tr_penjualan.kode_transaksi
GROUP BY 1,2
ORDER BY total_harga DESC
LIMIT 1;

--Customer have never shop
SELECT kode_pelanggan,
	nama_pelanggan,
	alamat
FROM ms_pelanggan
WHERE kode_pelanggan NOT IN (
	SELECT kode_pelanggan
 	FROM tr_penjualan
)

--Customers with transactions more than one
SELECT t1.kode_transaksi,
	t1.kode_pelanggan,
	p1.nama_pelanggan,
	t1.tanggal_transaksi,
	COUNT(t2.kode_transaksi) as jumlah_detail
FROM tr_penjualan as t1
	JOIN ms_pelanggan as p1 ON t1.kode_pelanggan = p1.kode_pelanggan
	JOIN tr_penjualan_detail as t2 ON t1.kode_transaksi = t2.kode_transaksi
GROUP BY 1,2,3,4
HAVING jumlah_detail > 1;

/* Project 3 : Fundamental SQL Group By and Having
Created by Xeratic */

/* Project 4 : Data Analysis for B2B Retail: Customer Analytics Report
Created by Trisna Yulia Junita, Data Scientist, PT. BUMA  */

/* Project 5 : Data Analysis for E-Commerce Challenge
Created by DQLab */
