
-----------------------------------WİNDOW FUNCTİONS------------------------------- 

--->Window Function ile Group by arasındaki fark 
--->Window Function types 
--->Window Function syntax and Keywords
--->Window Frames
--->How to apply Window Function

--birden çok sorguda elde edebilceğimiz agg değerlerini tek bir sorguda elde ediyoruz sadece agg işlemlerinde değil satırlara numaralnadırma işlemi de yapıyor.
--sıralanmış satır değerleri arasından istediğimizi alabiliyoruz.
--bize sağladığı esnekliğin temel sebebi group by gibi gruplama yapmayıp, gruplama yapıldıktan sonraki değerleri satırların karşına getiriyor.
--Aslında bize bir pencere açıyor.Tablonun yapısını bozmuyor.
--window Function içinde order yapılabiliyor.
--Performans açısından ise [Group by] da grouplanmış işlemleri arkada temporary table olarak tutuyor ve onun üzerinden işlemler yapıyor
--Fakat WF tablonun yapısında herhangi değişiklik yapmadığı için daha hızlı sonuç alabiliyoruz


---Differences with WF & Group by
--Question: Write a query that returns the total stock amount of each product in the stock table.

--->>Group by 
SELECT product_id, SUM(quantity) total_quantitiy 
FROM product.stock 
GROUP BY product_id 
ORDER by 1
---->>WF
SELECT*, 
        SUM(quantity) OVER (PARTITION BY product_id) Total_Quantity --WF over keyword kullanmak zorundasınız.partt. by gruplamayı sağlıyor.
FROM product.stock

SELECT distinct product_id , 
        SUM(quantity) OVER (PARTITION BY product_id) Total_Quantity --group by ile aynı sonucu aldık.
FROM product.stock

---Question:Write a query that returns avarage product prices of brands.

SELECT *, AVG(list_price) OVER(PARTITION BY brand_id)
FROM product.product 

------->>>>Types of WindowFunction(Analytic functions)
---->>Analaytic Aggregate functions--MIN()--MAX()--SUM()--AVG()--COUNT()
---->>Analytic Navigation Functions--FIRST_VALUE()--LAST_VALUE()--LEAD()--LAG()
---->>Analytic Numbering Functions--ROW_NUMBER()--RANK()--DENSE_RANK()--NTİLE()--PERCENT_RANK()

---SYNTAX:
/*
SELECT {COLUMNS}, FUNCTION() OVER(PARTITION By .... ORDER BY...WINDOW FRAME) --bazı durumlarda order by zorunlu olacak.
FROM TABLE1;
*/
--Window frame; yazmak zorunda değiliz default u : UNBOUNDED PRECEDING AND CURRENT ROW
--rows between ....1 PRECEDİNG AND CURRENT ROW
--range between .... 
--ROW_veya_RANGE : Veri gruplarının tüm verisi ile değil belirli bir alandaki verileri için hesaplama yapabilmemizi sağlar.
-- Özellikle hareketli ortalama hesaplayabilmek için çok kullanışlıdır. Opsiyoneldir.

PARTITION 
UNBOUNDED PRECEDING --(öncesi sınırlandırılmamış):  current row'a kadar olan bölümde fonksiyonu uygula.
-->N PRECEDING
.
. 
-->CURRENT ROW 
. 
. 
-->M FOLLOWING 
UNBOUNDED FOLLOWING --(sonrası sınırlandırılmamış) : current row'dan sonuna kadar olan bölümde fonksiyonu uygula.

--ex. 1 PRECEDING AND 1 FOLLOWING --> CURRENT ROW 1. SATIR OLSUN 1. SATIRDAN ÖNCESİ YOK SONRASI 2. SATIR. YANİ İŞLEME 1 VE 2. SATIRI DAHİL EDECEK
--daha sonra 2. satıra gecti ve 2 den öncesi 1. satır ve 2. satırdan sonrası 3. satır .yani işleme 1 2 3 staırları dahil edecek. Window function satır satır işlem yapıyor.
--Hareketli ortalama-kümülatif toplam gibi işlemleri bu fonksiyonlarla grup bazında kolayca yapabiliriz.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id
;

SELECT brand_id, model_year, COUNT(*) OVER() NOTHING --hiçbir gruplama yapmadan tüm satırları say 
                            ,COUNT(*) OVER(PARTITION BY brand_id)
                            ,COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year) --bize kümülatif işlem yaptırdı.
FROM product.product

!!!! 
OVER işlemi içindeki ORDER BY --> window fonksiyonu uygularken dikkate alacağı order by'dır.
Query sonundaki ORDER BY --> SELECT işlemi neticesindeki sonucun order by'ıdır.

SELECT brand_id, model_year
            ,COUNT(*) OVER(PARTITION BY brand_id)
            ,COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )--DEFAULT FRAME(RANGE)
            ,COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM product.product

SELECT brand_id, model_year
            ,COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year RANGE BETWEEN CURRENT ROW  AND UNBOUNDED FOLLOWING )
FROM product.product
--kümülatif gittiğini göstermeye çalışıyoruz.

SELECT brand_id, model_year
            ,COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year RANGE BETWEEN  UNBOUNDED PRECEDING  AND UNBOUNDED FOLLOWING )
FROM product.product
--bir partition da bütün satırlarda işlem yaptı ve brand_id 1 olandan kaç tane var hepsinin karşısına yazdı.
----> ROW İLR RANGE ARASINDAKİ FARK ;
--işlem olarak bir fark yok ama keywordlerle range kullanıyoruz, specific değer giriyorsak da row function kullanıyoruz.

--------Query Time----------
--What is the cheapest product price for each categroy?

SELECT distinct category_id,MIN(list_price) OVER(PARTITION BY category_id)
FROM product.product

---How many different product in the product table?

SELECT distinct COUNT(product_id) OVER()
FROM product.product

--- How many different product in the order_item table?

SELECT COUNT(product_id)
FROM(
        select distinct product_id 
        FROM sale.order_item
    )A
--Distinct window functionlarda kullanamıyoruz.

---Write a query that returns how many products are in each order?

SELECT distinct order_id, SUM(quantity) OVER (partition by order_id) num_of_prod
FROM sale.order_item 

----- How many different product are in each brand in each category?

SELECT	DISTINCT category_id, brand_id, COUNT (product_id) OVER (PARTITION BY category_id, brand_id)
FROM	product.product
ORDER BY category_id, brand_id

------------------FIRST VALUE FUNCTİON-------------
--verideki ilk değeri alıyor ve 
--Write a query that returns one of the most stocked product in each store.
SELECT *
FROM	product.stock
ORDER BY
		store_id, quantity DESC

SELECT	DISTINCT store_id,
		FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC)
FROM	product.stock


SELECT *,
	FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC ROWS BETWEEN 1 PRECEDING AND CURRENT ROW )
FROM product.stock;

--Write a query that returns customers and their most valuable order with total amount of it.

WITH T1 As
(
SELECT distinct a.customer_id, b.order_id, sum(list_price*quantity*(1-discount)) total_amount
FROM sale.orders a, sale.order_item b
WHERE a.order_id = b.order_id
group BY a.customer_id, b.order_id
)
select distinct customer_id,
FIRST_VALUE(order_id) OVER(partition by customer_id ORDER by total_amount desc ) most_val_order_id,
FIRST_VALUE(total_amount) OVER(partition by customer_id ORDER by total_amount desc ) total_amount
FROM T1

-----Write a query that returns first order date by month
SELECT	DISTINCT YEAR(order_date) Year, MONTH(order_date) Month,
		FIRST_VALUE (order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) first_order_date	
FROM	sale.orders


------------------LAST VALUE FUNCTİON-------------

SELECT	DISTINCT store_id,
		FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC),
        LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity, product_id desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	product.stock
--firt value ve last value kullanarak aynı değeri elde ettik.


------------------LAG() FUNCTİON-------------(Analytic Navigation Functions)
--RETURNS THE VALUE İN PREVİOUS ROWS FOR EACH ROW OF SORTED COLUMN VALUES.

--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)
SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LAG(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) prev_order_date
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id

------------------LEAD() FUNCTİON-------------(Analytic Navigation Functions)
--RETURNS THE VALUE İN NEXT ROWS FOR EACH ROW OF SORTED COLUMN VALUES.

--Write a query that returns the order date of the one next sale of each staff (use the lead function)
SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LEAD (order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) next_order_date
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id

----------------------Analytic Numbering Functions--ROW_NUMBER()--RANK()--DENSE_RANK()--NTİLE()--PERCENT_RANK()--------------

--ROW_NUMBER()--kayıt setinin herbir bölümüne atamak üzere 1 'den başlayarak sıralı giden bir sayı üretir.
--RANK()----fonksiyonu ile tekrar eden satırlara aynı numaralar verilir ve kullanılmayan numaralar geçilir.
--DENSE_RANK()--fonksiyonunda aynı değere sahip satırlara aynı değer veriliyor ama sıralama algoritmasında hiç bir rakam atlanmıyor.(kaç farklı değer var görmüş oluyoruz.)
--NTİLE()--fonksiyonu SELECT ifadenizde WHERE koşuluna uyan kayıtları OVER ve ORDER BY ile belirtilen sıralamaya göre dizilmiş şekilde
   --sizin parametre olarak geçeceğiniz bir sayıya bölerek her bölüme bir sıra numarası verir.
--PERCENT_RANK() = (row_number-1)/(total_rows-1)
--CUME_DIST() = row_number/total_rows

----Assign a rank number and dense_rank number to the product prices for each category in ascending order.

select category_id, list_price,
rank() over(partition by category_id order by list_price ) as rnk,
dense_rank() over(partition by category_id order by list_price ) as dense_rnk,
row_number() over(partition by category_id order by list_price ) as rn
from product.product;

SELECT *
FROM(
	SELECT category_id, list_price,
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) as ord_number
FROM product.product
	) A
WHERE ord_number < 4

--->>Write a query that returns both of the followings:
-->Average product price.
-->The average product price of orders.

SELECT DISTINCT order_id, 
AVG(list_price) OVER() avg_price,
AVG(list_price) OVER(PARTITION BY order_id) avg_price_by_orders
FROM sale.order_item

--Which orders' average product price is lower than the overall average price?

WITH T1 AS (
    SELECT DISTINCT order_id, 
    AVG(list_price) OVER() avg_price,
    AVG(list_price) OVER(PARTITION BY order_id) avg_price_by_orders
    FROM sale.order_item
           )
SELECT*
FROM T1 
WHERE avg_price_by_orders < avg_price
ORDER BY 3 DESC

--Calculate the Stores' weekly cumulative number of orders for 2018.

SELECT distinct a.store_id, a.store_name, datepart(week, b.order_date) weeek_of_year,
COUNT(*) OVER(PARTITION BY a.store_id, datepart(WEEK, b.order_date)) weeks_order,
COUNT(*) OVER(PARTITION BY a.store_id ORDER BY datepart(WEEK, b.order_date)) cume_total_order
FROM sale.store a, sale.orders b 
WHERE a.store_id = b.store_id 
and year(b.order_date) = 2018
ORDER by store_id

--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
WITH T1 AS
(
SELECT distinct a.order_date, SUM(b.quantity) OVER (PARTITION by order_date) daily_product_cnt
FROM sale.orders a, sale.order_item b
WHERE a.order_date between '2018-03-12' and '2018-04-12'
and a.order_id = b.order_id
)
SELECT order_date, daily_product_cnt,
AVG(daily_product_cnt) OVER(ORDER by order_date ROWS BETWEEN 6 preceding and CURRENT ROW)
FROM T1

--->another view
WITH T1 AS
(
SELECT	DISTINCT order_date, 
		SUM(quantity) OVER (PARTITION BY order_date) daily_product_cnt
FROM	sale.orders A, sale.order_item B
WHERE	A.order_date BETWEEN  '2018-03-12' and '2018-04-12'
AND		A.order_id = B.order_id
) 
SELECT	order_date, 
		daily_product_cnt,
		AVG(daily_product_cnt) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING)
FROM	T1


--Write a query that returns the highest daily turnover amount for each week on a yearly basis.


​
--List customers whose have at least 2 consecutive orders are not shipped.
