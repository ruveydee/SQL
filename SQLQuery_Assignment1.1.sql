--Question 1 
/*
1. Product Sales
You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)

To generate this report, you are required to use the appropriate SQL Server Built-in functions or expressions as well as basic SQL knowledge.*/
---------------------------------------------------------
--this guery is customers who purchased product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' but not the item Polk Audio - 50 W Woofer - Black'

SELECT customer_id,first_name,last_name, 'No' Other_Product
FROM sale.customer
WHERE customer_id IN(SELECT customer_id
FROM sale.orders 
WHERE order_id IN (SELECT order_id
                   FROM sale.order_item
                   WHERE product_id IN (SELECT product_id
                                        FROM product.product 
                                        WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
                                       )
                   )
AND order_id NOT IN (SELECT order_id
                   FROM sale.order_item
                   WHERE product_id IN (SELECT product_id
                                        FROM product.product 
                                        WHERE product_name = 'Polk Audio - 50 W Woofer - Black'
                                       )
))
---------------------------------------------------------
SELECT customer_id,first_name,last_name, 'YES' Other_Product
FROM sale.customer
WHERE customer_id IN(SELECT customer_id
FROM sale.orders 
WHERE order_id IN (SELECT order_id
                   FROM sale.order_item
                   WHERE product_id IN (SELECT product_id
                                        FROM product.product 
                                        WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
                                       )
                   )
AND order_id  IN(SELECT order_id
                   FROM sale.order_item
                   WHERE product_id IN (SELECT product_id
                                        FROM product.product 
                                        WHERE product_name = 'Polk Audio - 50 W Woofer - Black'
                                       )
))
-----------------------------------------------------------------
---cerate new table named table_No
SELECT customer_id,first_name,last_name, 'NO' Other_Product
INTO table_No
FROM sale.customer
WHERE customer_id IN(SELECT customer_id
FROM sale.orders 
WHERE order_id IN (SELECT order_id
                   FROM sale.order_item
                   WHERE product_id IN (SELECT product_id
                                        FROM product.product 
                                        WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
                                       )
                   )
AND order_id NOT IN(SELECT order_id
                   FROM sale.order_item
                   WHERE product_id IN (SELECT product_id
                                        FROM product.product 
                                        WHERE product_name = 'Polk Audio - 50 W Woofer - Black'
                                       )
))
---------------------------------------------------------
---cerate new table named table_Yes
SELECT customer_id,first_name,last_name, 'YES' Other_Product
INTO table_Yes 
FROM sale.customer
WHERE customer_id IN(SELECT customer_id
FROM sale.orders 
WHERE order_id IN (SELECT order_id
                   FROM sale.order_item
                   WHERE product_id IN (SELECT product_id
                                        FROM product.product 
                                        WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
                                       )
                   )
AND order_id  IN(SELECT order_id
                   FROM sale.order_item
                   WHERE product_id IN (SELECT product_id
                                        FROM product.product 
                                        WHERE product_name = 'Polk Audio - 50 W Woofer - Black'
                                       )
))

--add pk of table_yes
ALTER TABLE table_Yes  ADD PRIMARY KEY (customer_id)

/*
combine the result-set with Union operator of the two tables and we get whether customers 
who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.
*/
SELECT*
FROM table_No 
UNION 
SELECT*
FROM table_YES