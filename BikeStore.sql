
/* QUERY THE DATABASE FOR BUILDING REVENUE REPORT*/

SELECT
	ord.order_id,
	cus.customer_id,
	CONCAT(cus.first_name,' ',cus.last_name) AS 'customer_name',
	cus.city, 
	cus.state,
	ord.order_date,
	ite.quantity,
	(ite.quantity*ite.list_price) AS 'revenue',
	pro.product_name,
	cat.category_name,
	bra.brand_name,
	sto.store_name
FROM sales.staffs sta
JOIN sales.stores sto
	ON sta.store_id = sto.store_id
JOIN sales.orders ord
	ON ord.store_id=sto.store_id
JOIN sales.order_items ite
	ON ite.order_id = ord.order_id
JOIN sales.customers sal
	ON sal.customer_id = ord.customer_id
JOIN production.stocks stk
	ON stk.store_id = sto.store_id
JOIN production.products pro
 ON pro.product_id = ite.product_id
JOIN production.brands bra
	ON bra.brand_id = pro.brand_id
JOIN production.categories cat
	ON pro.category_id = cat.category_id
JOIN sales.customers cus
	ON cus.customer_id = ord.customer_id 
GROUP BY
	ord.order_id,
	cus.customer_id,
	CONCAT(cus.first_name,' ',cus.last_name),
	cus.city, 
	cus.state,
	ord.order_date,
	ite.quantity,
	ite.list_price,
	pro.product_name,
	cat.category_name,
	bra.brand_name,
	sto.store_name
ORDER BY order_id, order_date