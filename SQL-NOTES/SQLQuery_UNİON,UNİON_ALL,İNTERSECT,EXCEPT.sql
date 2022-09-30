----------------------SET OPERATORS---------------------------
--------------------------------------UNION / UNION ALL--------------------------------------

--List the products sold in the cities of Charlotte and Aurora

--UNION
SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Aurora' --103 row

UNION

SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Charlotte' --75 row 
--132 row 

--union all ile yapsaydık.
SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Aurora' --103 row

UNION ALL

SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Charlotte' --75 row 
--178 row duplic değerler oluşuyor

--Question : Write a query that returns all customers whose first or last name is Thomas.

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'

UNION ALL

SELECT first_name,last_name
FROM sale.customer
WHERE last_name = 'Thomas'
--37 row
----union ile duplicate olan staır gelmemiş oldu.
SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'

UNION 

SELECT first_name,last_name
FROM sale.customer
WHERE last_name = 'Thomas'
--36 row

--------------------------------------------INTERSECT-----------------------------------------------

--Write a query that returns all brands with products for both 2018 and 2020 model year.

SELECT distinct b.brand_id, b.brand_name
FROM product.product a,product.brand b
WHERE model_year = 2018
and a.brand_id = b.brand_id --37 row

INTERSECT 

SELECT distinct b.brand_id, b.brand_name
FROM product.brand b, product.product a
WHERE  model_year = 2020
and a.brand_id = b.brand_id --31 row

/*
SELECT distinct b.brand_id, b.brand_name, model_year
FROM product.product a,product.brand b
WHERE model_year = 2018
and a.brand_id = b.brand_id --37 row

INTERSECT 

SELECT distinct b.brand_id, b.brand_name, model_year
FROM product.brand b, product.product a
WHERE  model_year = 2020
and a.brand_id = b.brand_id --31 row 

Eğer bir sutun daha eklemiş isteseydik nasıl olurdu? intersect işleminde ortak alıyordu ve ortak olmayan bir sutunla bu işlem boş sonuç döndürür. 
*/

--Write a query that returns the first and last names of the customers, who placed orders in all of 2018, 2019 and 2020.
 

SELECT customer_id, first_name, last_name
FROM sale.customer
WHERE customer_id  in  (
                        SELECT DISTINCT customer_id
                        FROM sale.orders 
                        WHERE order_date BETWEEN '2018-01-01 ' and '2018-12-31'

                        INTERSECT


                        SELECT DISTINCT customer_id
                        FROM sale.orders 
                        WHERE order_date BETWEEN '2019-01-01 ' and '2019-12-31'

                        INTERSECT

                        SELECT DISTINCT customer_id
                        FROM sale.orders 
                        WHERE order_date BETWEEN '2020-01-01 ' and '2020-12-31'
                        )

---------------------------EXCEPT------------------------
--haricinde ,değili,A-B A Da olup B de olmayanlar vs 
--Write a query that returns the brands have 2018 model products but not 2019 model products.

SELECT distinct B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = b.brand_id
and A.model_year = 2018

EXCEPT

SELECT distinct B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = b.brand_id
and A.model_year = 2019
--distinct kullanılmasa da aynı sonucu verir.

---Write a query that contains that only products ordered in 2019.(Result not include products ordered in other years).
 
SELECT distinct a.product_id, a.product_name
FROM product.product a, sale.order_item b, sale.orders c 
WHERE a.product_id = b.product_id
and b.order_id = c.order_id
and year(c.order_date ) = 2019 ---2019 yılındaki siparişleri verilen ürünler aynı ürün_name başka bir yılda sipariş verilmiş de olabilir

EXCEPT 

SELECT distinct a.product_id, a.product_name
FROM product.product a, sale.order_item b, sale.orders c 
WHERE a.product_id = b.product_id
and b.order_id = c.order_id
and year(c.order_date ) <> 2019 ---2019 yılı haricindeki siparişi verilen ürünler 
-- sonuç olarak sadece 2019 yılında sipariş verilen ürünleri görmüş oluyoruz.

