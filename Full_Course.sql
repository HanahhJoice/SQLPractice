/* BEGINNER LEVEL*/

/* Select Statement - Top, Distinct, Count, As, Max, Min, Avg */

-- 1. Select 

	  SELECT * 
	  FROM sales.customers
	  
	  SELECT 
	  customer_id, 
	  first_name, 
	  last_name, 
	  phone
	  FROM sales.customers

-- TOP
     
	  SELECT TOP 5 * 
	  FROM sales.customers

-- DISTINCT
      
	  SELECT COUNT(customer_id)
	  FROM sales.customers

-- AS
      
	  SELECT COUNT(customer_id) AS customer_id_count
	  FROM sales.customers

-- MAX
      
	  SELECT MAX(list_price) 
	  FROM sales.order_items

-- MIN
      
	  SELECT MIN(list_price) 
	  FROM sales.order_items

-- AVG
      
	  SELECT AVG(list_price) 
	  FROM sales.order_items

/* Where Statement - =, <>, <, >, And, Or, Like, Null, Not Null, In */

-- 1. Where 
 
	  SELECT * 
	  FROM sales.order_items
	  WHERE
	  list_price = 599.99

-- <>
	  SELECT * 
	  FROM sales.order_items
	  WHERE
	  list_price <> 599.99

-- <
      
	  SELECT * 
	  FROM sales.order_items
	  WHERE
	  list_price < 599.99
-- >
      
	  SELECT * 
	  FROM sales.order_items
	  WHERE
	  list_price > 599.99

-- AND
      
	  SELECT * 
	  FROM sales.order_items
	  WHERE
	  list_price > 599.99 AND discount = 0.2

-- OR
       
	  SELECT * 
	  FROM sales.order_items
	  WHERE
	  list_price > 599.99 OR discount = 0.2

-- LIKE
       
	  SELECT * 
	  FROM sales.customers
	  WHERE first_name LIKE 'D%'

-- NULL
       
	  SELECT * 
	  FROM sales.customers
	  WHERE phone is NULL

-- NOT NULL
      
	  SELECT * 
	  FROM sales.customers
	  WHERE phone is NOT NULL

-- IN
       
	  SELECT * 
	  FROM sales.customers
	  WHERE first_name IN ('Debra','Daryl')

/* Group by - Order by */

-- 1. Group by 
      SELECT order_id, list_price, COUNT(quantity) as total_unit
	  FROM sales.order_items as ite
	  GROUP BY order_id,list_price
-- 2. Order by 
      SELECT order_id, list_price, COUNT(quantity) as total_unit
	  FROM sales.order_items as ite
	  GROUP BY order_id,list_price
	  ORDER BY order_id, list_price DESC


/* INTERMIDIATE LEVEL*/
 
 /* Inner Joins, Full/Left/Right Outer Joins*/

 --1. Inner Joins

      SELECT *
	  FROM sales.customers cus
	  INNER JOIN sales.orders ord
	  ON cus.customer_id =ord.customer_id

 --2. Full Outer Joins

      SELECT *
	  FROM sales.customers cus
	  FULL OUTER JOIN sales.orders ord
	  ON cus.customer_id =ord.customer_id

 --3. Left Outer Joins

	  SELECT *
	  FROM sales.customers cus
	  LEFT OUTER JOIN sales.orders ord
	  ON cus.customer_id =ord.customer_id

 --4. Right Outer Joins

	  SELECT *
	  FROM sales.customers cus
	  RIGHT OUTER JOIN sales.orders ord
	  ON cus.customer_id =ord.customer_id

/* Union, Union All - This database is not suitable for Union Operator*/

/* Case Statement*/

      SELECT CONCAT(first_name,' ' ,last_name) as Full_name, quantity, SUM(quantity*list_price) as Total_Revenue,  
	  CASE
			WHEN SUM(quantity*list_price) > 500000 THEN 'GOOD'
			ELSE 'BAD'
	  END AS KPI
	  FROM sales.staffs sta
	  JOIN sales.orders ord
	  ON sta.staff_id = ord.staff_id
	  JOIN sales.order_items ite
	  ON ite.order_id =ord.order_id
	  GROUP BY 
	  CONCAT(first_name,' ' ,last_name),
	  quantity
	  ORDER BY Total_Revenue DESC

/* HAVING clause*/
      SELECT CONCAT(first_name,' ' ,last_name) as Full_name, quantity, SUM(quantity*list_price) as Total_Revenue
	  FROM sales.staffs sta
	  JOIN sales.orders ord
	  ON sta.staff_id = ord.staff_id
	  JOIN sales.order_items ite
	  ON ite.order_id =ord.order_id
	  GROUP BY 
	  CONCAT(first_name,' ' ,last_name),
	  quantity
	  HAVING SUM(quantity*list_price) > 500000
	  ORDER BY Total_Revenue DESC, Full_name

/* Updating/Delete Table*/

--1. UPDATING
      SELECT *
	  FROM sales.customers
	  
	  UPDATE sales.customers
	  SET phone = '(716) 996-3359'
	  WHERE customer_id = 1

--2. DELETE

      SELECT *
	  FROM production.stocks
	  
	  DELETE FROM  production.stocks
	  WHERE quantity = 0

/* Aliasing*/ 

      SELECT TOP (5)
      sta.staff_id, 
      CONCAT (sta.first_name,' ', sta.last_name) AS 'Staff_name',
      sta.email,
      sta.phone,
      sto.store_name,
      SUM (ite.quantity*ite.list_price) AS total_revenue
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

/* Partition by*/

      SELECT * 
	  FROM production.products
      
	  SELECT *, COUNT (brand_id) OVER (PARTITION BY brand_id) as Total_Products 
	  FROM production.products

/* ADVANCED LEVEL*/

--1. CTEs
      ;
	  With Top_5_Staff as
      (SELECT TOP (5)
      sta.staff_id, 
      CONCAT (sta.first_name,' ', sta.last_name) AS 'Staff_name',
      sta.email,
      sta.phone,
      sto.store_name,
      SUM (ite.quantity*ite.list_price) AS total_revenue
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
	  ORDER BY total_revenue DESC)

	  SELECT * FROM Top_5_Staff

--2. Temp Tables

     CREATE TABLE #temp_Top5BestStaff (
	 staff_id int, 
     staff_name varchar(50),
     email varchar(255),
     phone varchar(25),
     store_name varchar(255),
	 total_revenue int)

	 INSERT INTO #temp_Top5BestStaff
	 SELECT TOP (5)
     sta.staff_id, 
     CONCAT (sta.first_name,' ', sta.last_name) AS Staff_name,
     sta.email,
     sta.phone,
     sto.store_name,
     SUM (ite.quantity*ite.list_price) AS total_revenue
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

	 SELECT * FROM #temp_Top5BestStaff

--3. String Function - TRIM, LTRIM, RTRIM, Replace, Upper, Lower

     CREATE TABLE Staff (
	 staff_id varchar(50), 
     staff_name varchar(50))

	 INSERT INTO Staff VALUES
	 ('1001 ', 'Jim'),
	 (' 1002', 'Hanah'),
	 (' 1003 ', 'Pamela')
	 	 
	 SELECT * FROM Staff

--Using TRIM, LTRIM, RTRIM

	 SELECT TRIM(staff_id)
	 FROM Staff

	 SELECT LTRIM(staff_id)
	 FROM Staff

	 SELECT RTRIM(staff_id)
	 FROM Staff

--Using Replace

	 SELECT staff_id, REPLACE(staff_name, 'Hanah', 'Joice')
	 FROM Staff

--Using Substring

     SELECT staff_id, SUBSTRING(staff_name, 1,3)
	 FROM Staff

--Using UPPER, lower

     SELECT staff_id, UPPER(staff_name)
	 FROM Staff

	 SELECT staff_id, LOWER(staff_name)
	 FROM Staff

--4. Stored Procedures

-- CREATE PROCEDURE

     CREATE PROCEDURE Bike_Store_Full
	 AS
	 CREATE TABLE #temp_BestStaffs (
	 staff_id int, 
     staff_name varchar(50),
     email varchar(255),
     phone varchar(25),
     store_name varchar(255),
	 total_revenue int)

	 INSERT INTO #temp_BestStaffs
	 SELECT TOP (5)
     sta.staff_id, 
     CONCAT (sta.first_name,' ', sta.last_name) AS Staff_name,
     sta.email,
     sta.phone,
     sto.store_name,
     SUM (ite.quantity*ite.list_price) AS total_revenue
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

	 SELECT * From #temp_BestStaffs

	 EXEC Bike_Store_Full

--4. Subqueries

     SELECT *
	 FROM sales.order_items

	 SELECT AVG(discount)
	 FROM sales.order_items

-- Subquery in SELECT 

     SELECT item_id,discount, (SELECT AVG(discount) FROM sales.order_items) as AvgDis
	 FROM sales.order_items
	 ORDER BY item_id

-- Subquery in FROM 

     SELECT *
	 FROM (SELECT item_id,discount, (SELECT AVG(discount) FROM sales.order_items) as AvgDis
	 FROM sales.order_items) a
	
-- Subquery in WHERE 
     
	 SELECT *
	 FROM sales.staffs
	 Where staff_id IN (SELECT staff_id FROM [sales].[orders])

	 SELECT * 
	 FROM[sales].[orders]
	 