-----CTE---------
---ORDİNARY CTE'S
/*
COMMON TABLE ESPRESSIONS (CTE), başka bir SELECT, INSERT, DELETE veya UPDATE deyiminde başvurabileceğiniz veya içinde kullanabileceğiniz geçici bir sonuç kümesidir.
Başka bir SQL sorgusu içinde tanımlayabileceğiniz bir sorgudur. Bu nedenle, diğer sorgular CTE'yi bir tablo gibi kullanabilir.
CTE, daha büyük bir sorguda kullanılmak üzere yardımcı ifadeler yazmamızı sağlar.
*/

---------- Query Time ----------------------------------------------------------------------
---List customers who have an order prior to the last order date of a customer named Jerald Berray and are residents of the city of Austin.
---Jerald Berray isimli müşterinin son siparişinden önce sipariş vermiş ve Austin şehrinde ikamet eden müşterileri listeleyin.

WITH T1 AS (SELECT  max(b.order_date) as last_order_date
            FROM sale.customer a, sale.orders b
            WHERE a.first_name ='Jerald'
            and a.last_name = 'Berray'
            and a.customer_id = b.customer_id)
SELECT a.first_name, a.last_name
FROM sale.customer a, sale.orders b, T1
WHERE a.customer_id = b.customer_id
and T1.last_order_date > b.order_date 
and a.city = 'Austin'

---List all customers their orders are on the same dates with Laurel Goldammer.

WITH T1 AS (
            SELECT b.order_date Laurel_order_date
            FROM sale.customer a, sale.orders b
            WHERE a.first_name ='Laurel'
            and a.last_name = 'Goldammer'
            and a.customer_id = b.customer_id
            ),
T2 AS
(
            SELECT distinct a.first_name, a.last_name, b.order_date
            FROM sale.customer a, sale.orders b
            WHERE a.customer_id = b.customer_id
)
SELECT*
FROM T1,T2
WHERE T1.Laurel_order_date = T2.order_date

------------------------RECURSİVE CTE'S----------------------------
/*CTE, Subquery mantığı ile aynı. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazıyoruz.
Sadece WITH kısmını yazarsan tek başına çalışmaz. WITH ile belirttiğim query'yi birazdan kullanacağım demek bu. 
Asıl SQL statementimin içinde bunu kullanıyoruz.*/

---Create a table with a number in each row in ascending order from 0 to 9

WITH CTE AS 
(
    SELECT 0 AS NUMBER
    UNION ALL 
    SELECT NUMBER + 1
    FROM CTE 
    WHERE NUMBER < 9
)
SELECT*
FROM CTE

---List the stores whose turnovers are under the average store turnovers in 2018

WITH T1 as
(
SELECT C.store_name, sum(list_price * quantity* (1-discount)) Store_Earn
FROM  sale.order_item A, sale.orders B , sale.store C
WHERE A.order_id = B.order_id
and B.store_id = C.store_id
and YEAR(B.order_date) = 2018
GROUP BY C.store_name
),
T2 AS 
(
  SELECT AVG(Store_Earn) Avg_earn
  FROM T1
)
SELECT*
FROM T1, T2
WHERE T1.Store_Earn < T2.Avg_Earn

---Write a quary that creates a new column named "total price" calculating the total prices of the products on each order.

SELECT order_id, SUM(A.list_price) as total_price
FROM product.product A, sale.order_item B
WHERE A.product_id = B.product_id
GROUP BY order_id
ORDER BY order_id

--subquery ile farklı bir çözüm ;
SELECT order_id ,
    (
        select SUM(list_price)
        FROM sale.order_item A
        WHERE A.order_id = B.order_id
    )
FROM sale.orders B

---order_item tablosuyla da yapılabilir.
SELECT distinct order_id ,
    (
        select SUM(list_price)
        FROM sale.order_item A
        WHERE A.order_id = B.order_id
    )
FROM sale.order_item B

