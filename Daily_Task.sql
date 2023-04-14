/* DAILY TASK*/

--1. Top 5 best-selling products

     SELECT TOP(5) 
		ite.product_id,
		pro.product_name, 
		bra.brand_name,
		sum(ite.quantity) as total_unit 
     FROM sales.order_items ite
     JOIN production.products pro
		ON ite.product_id = pro.product_id
     JOIN production.brands bra
		ON bra.brand_id = pro.brand_id
     GROUP BY 
		ite.product_id,
		pro.product_name, 
		bra.brand_name
     ORDER BY sum(ite.quantity) desc

--2. Top 5 stores with the highest revenue

     SELECT 
		sto.store_id, 
		sto.store_name,
		sto.phone,
		sto.email,
		sto.city,
		sto.state,
     SUM(ite.quantity*ite.list_price) as total_revenue
     FROM [sales].[stores] sto
     JOIN sales.orders ord
		ON sto.store_id = ord.store_id
     JOIN sales.order_items ite
		ON ite.order_id=ord.order_id
     group by 
		sto.store_id, 
		sto.store_name,
		sto.phone,
		sto.email,
		sto.city,
		sto.state
     Order by total_revenue DESC

--3. Top 5 excellent employees
     
	 SELECT TOP (5)
		sta.staff_id, 
		CONCAT (sta.first_name,' ', sta.last_name) as 'Staff_name',
		sta.email,
		sta.phone,
		sto.store_name,
		SUM (ite.quantity*ite.list_price) as total_revenue
	FROM sales.staffs sta
	JOIN sales.stores sto
		ON sta.store_id = sto.store_id
	JOIN sales.orders ord
		ON ord.store_id=sto.store_id
	JOIN sales.order_items ite
		ON ite.order_id = ord.order_id
	GROUP BY 
		sta.staff_id,
		CONCAT (sta.first_name,' ', sta.last_name),
		sta.email,
		sta.phone,
		sto.store_name
	ORDER BY total_revenue DESC

--4. Top 5 Customers with highest total bill

	SELECT TOP (5)
		cus.customer_id, 
		CONCAT(cus.first_name,' ', cus.last_name) as 'Customer_name',
		cus.phone, 
		cus.email,
		SUM((ite.quantity*ite.list_price)*(1 - ite.discount)) as total_bill
	FROM sales.customers cus
	JOIN sales.orders ord
	ON cus.customer_id = ord.customer_id
	JOIN sales.order_items ite
	ON ite.order_id=ord.order_id
	GROUP BY
		cus.customer_id, 
		CONCAT(cus.first_name,' ', cus.last_name),
		cus.phone, 
		cus.email
	ORDER BY total_bill DESC

--5. Total Revenue by Year
	WITH Trend_By_Year AS
	(SELECT 
		year(order_date) as year, 
		SUM(ite.quantity*ite.list_price) AS Total_revenue
	FROM sales.orders ord
	JOIN sales.order_items ite
		ON ord.order_id = ite.order_id
	WHERE order_date is NOT NULL
	GROUP BY year(order_date),order_date)

	SELECT 
		year, 
		SUM (Total_revenue) AS Total_revenue
	FROM Trend_By_Year
	GROUP BY Year
	ORDER BY  Total_revenue DESC, year

--6. Total Revenue by Month
	WITH Trend_By_Year AS
	(SELECT 
		year(order_date) as year,
		month(order_date) as month,
		SUM(ite.quantity*ite.list_price) AS Total_revenue
	FROM sales.orders ord
	JOIN sales.order_items ite
		ON ord.order_id = ite.order_id
	WHERE order_date is NOT NULL
	GROUP BY year(order_date),order_date)

	SELECT Year,Month, SUM (Total_revenue) AS Total_revenue
	FROM Trend_By_Year
	GROUP BY Year, Month
	ORDER BY year, Total_revenue DESC