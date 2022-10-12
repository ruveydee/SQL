---LOWER küçük harfe çeviriyor.
---upper büyük harf yapıyor.
---string-split 

---Lower-Upper-string_split

SELECT LOWER('CLARUSWAY'), UPPER('clarusway')

SELECT [value]
from  string_split('Ezgi,Senem,Mustafa', ',')

SELECT [value]
FROM  string_split('Ezgi/Senem/Mustafa', '/')

---question : clarusway kelimesinin sadece ilk harfini büyütün --
 
SELECT left('clarusway',1)

SELECT SUBSTRING('clarusway',2,len('clarusway'))

SELECT left('clarusway',1) + SUBSTRING('clarusway',2,len('clarusway'))

SELECT upper(left('clarusway',1)) + lower(SUBSTRING('clarusway',2,len('clarusway')))

----sampleRetail database--
SELECT *
FROM sale.store

SELECT *, UPPER(LEFT(email,1)) + LOWER(SUBSTRING(email,2,LEN(email))) New_Email
FROM sale.store

----Trim , Ltrim, rtrim---boşlukları kaldırıyor
SELECT TRIM('        Clarusway     ')
SELECT TRIM('?' FROM '?      Clarusway     ?')    --? ni şurdan kaldır demek 
SELECT TRIM('?, ' FROM '?       CLARUSWAY     ?' )  --hem boşluk hem ? kaldır 
SELECT LTRIM('      CLARUSWAY     ')
SELECT RTRIM('      CLARUSWAY     ')

------REPLACE, STR FONKSİYONLARI -----

SELECT REPLACE('CLARUSWAY','C', 'A')
SELECT REPLACE('CLAR USWAY',' ', '')

SELECT STR(1234.25, 7, 2) --7 karakter . dan sonra 2 charcter var
SELECT STR(1234.25, 7, 1)

--cast----
SELECT CAST(123.56 AS varchar(6)) -----6 karakter sayısı
SELECT CAST(123.56 AS int)  
SELECT CAST(123.56 AS NUMERIC(4,1)) ----toplamda 4 basamak olucak noktadan sonra 1 basamak var numeric '.' yı  karakter olarak algılamıyor
--Converting a datatime to a varchar--
--Converting a Varchar to a Date---
--CONVERT---
SELECT CONVERT (NUMERIC(4,1) , 123.56) --format değiştirdik ..
SELECT GETDATE() --bugünün tarihini döbdürüür.
SELECT CONVERT (VARCHAR , GETDATE(), 6)  --hangi stile dmnüştür 6 numaralı stile döndü.
SELECT CONVERT (DATE, '19 Sep 22', 6)  ---6 numaralı stile döndü date veri tipi yaptık.

--ROUND FUNCTİONS---
--(Positive number rounds on the right side of the decimal point! Negative number rounds on the left side of the decimal point!)
--ROUND = sayıyı istenilen haneye göre yuvarlama.
--FLOOR = sayıyı aşağıya yuvarlama.
--CEILING = sayıyı yukarıya yuvarlama.
SELECT ROUND (123.56, 1) --virgülden sonra 1 hane yuvarlar
SELECT ROUND (123.54, 1)
SELECT ROUND (123.54, 1, 0)
SELECT ROUND (123.56, 1, 0)
SELECT ROUND (123.56, 1, 1) --sadace virgülden sonraki ilk basamağı yuvarlar gerisini atar
SELECT ROUND (123.54, 1, 1)

SELECT ROUND(12.4563,2)		 --sayıyı virgülden sonra 2 haneye yuvarlar.
SELECT FLOOR(12.6512) AS deger -- sayının virgülden sonraki değerini atarak 12 olarak yuvarlar.
SELECT CEILING(12.4512) AS deger -- sayının virgülden sonraki hanesini yukarı yuvarlar ve 13 elde edilir.

-- Desimal (Ondalık) veri türü ve çeşitli uzunluk parametreleriyle yuvarlama:
DECLARE @value decimal(10,2)  -- değişken deklare ettik.
SET @value = 11.05 -- değişkene değer atadık.
SELECT ROUND(@value, 1)  -- 11.10
SELECT ROUND(@value, -1) -- 10.00 
SELECT ROUND(@value, 2)  -- 11.05 
SELECT ROUND(@value, -2) -- 0.00 
SELECT ROUND(@value, 3)  -- 11.05
SELECT ROUND(@value, -3) -- 0.00
SELECT CEILING(@value)   -- 12 
SELECT FLOOR(@value)     -- 11 

-- Float veri türü ile yuvarlama fonksiyonları.
DECLARE @value float(10)
SET @value = .1234567890
SELECT ROUND(@value, 1)  -- 0.1
SELECT ROUND(@value, 2)  -- 0.12
SELECT ROUND(@value, 3)  -- 0.123
SELECT ROUND(@value, 4)  -- 0.1235
SELECT ROUND(@value, 5)  -- 0.12346
SELECT ROUND(@value, 6)  -- 0.123457
SELECT ROUND(@value, 7)  -- 0.1234568
SELECT ROUND(@value, 8)  -- 0.12345679
SELECT ROUND(@value, 9)  -- 0.123456791
SELECT ROUND(@value, 10) -- 0.123456791
SELECT CEILING(@value)   -- 1
SELECT FLOOR(@value)     -- 0

--Pozitif bir tamsayı yuvarlama (1 keskinlik değeri için):
DECLARE @value int
SET @value = 6
SELECT ROUND(@value, 1)  -- 6 - No rounding with no digits right of the decimal point
SELECT CEILING(@value)   -- 6 - Smallest integer value
SELECT FLOOR(@value)     -- 6 - Largest integer value 

--Kesinlik değeri olarak bir negatif sayının etkilerini de görelim:
DECLARE @value int
SET @value = 6
SELECT ROUND(@value, -1) -- 10 - Rounding up with digits on the left of the decimal point
SELECT ROUND(@value, 2)  -- 6  - No rounding with no digits right of the decimal point 
SELECT ROUND(@value, -2) -- 0  - Insufficient number of digits
SELECT ROUND(@value, 3)  -- 6  - No rounding with no digits right of the decimal point
SELECT ROUND(@value, -3) -- 0  - Insufficient number of digits

 --Bu örnekteki rakamları genişletelim ve ROUND fonksiyonu kullanarak etkilerini görelim:
SELECT ROUND(444,  1) -- 444  - No rounding with no digits right of the decimal point
SELECT ROUND(444, -1) -- 440  - Rounding down
SELECT ROUND(444,  2) -- 444  - No rounding with no digits right of the decimal point
SELECT ROUND(444, -2) -- 400  - Rounding down
SELECT ROUND(444,  3) -- 444  - No rounding with no digits right of the decimal point
SELECT ROUND(444, -3) -- 0    - Insufficient number of digits
SELECT ROUND(444,  4) -- 444  - No rounding with no digits right of the decimal point
SELECT ROUND(444, -4) -- 0    - Insufficient number of digits

--Negatif bir tamsayı yuvarlayalım ve etkilerini görelim:
SELECT ROUND(-444, -1) -- -440  - Rounding down
SELECT ROUND(-444, -2) -- -400  - Rounding down
SELECT ROUND(-555, -1) -- -560  - Rounding up
SELECT ROUND(-555, -2) -- -600  - Rounding up
SELECT ROUND(-666, -1) -- -670  - Rounding up
SELECT ROUND(-666, -2) -- -700  - Rounding up

--ISNULL--
SELECT ISNULL(NULL, 0) 
SELECT ISNULL(1, 0)
SELECT ISNULL('NOTNULL', 0)
SELECT phone, ISNULL(phone, 0) --- phone sutunundaki null yerine 0 yazıyor 
FROM sale.customer

----COALESCE, NULLIF, ISNUMERIC
SELECT COALESCE(NULL, NULL, 'ALİ', NULL) ---null olmayan ilk değeri yakalıyor
SELECT NULLIF(0, 0) --
SELECT phone, ISNULL(phone, 0), NULLIF (ISNULL(phone, 0), '0') -- varcahar 0 gördüğü yere null yazıyor veri tipi numeric olmadığı için '0' yaptık
FROM sale.customer

-------ISNUMERİC------
SELECT ISNUMERIC(1)
SELECT ISNUMERIC('1')
SELECT ISNUMERIC('1,5')
SELECT ISNUMERIC('1.5')
SELECT ISNUMERIC('1ALİ')

---Question: How many customers have yahoo mail?
SELECT email
FROM sale.customer
WHERE email  LIKE '%yahoo%'

--farkli çözüm--
SELECT	COUNT (*)
FROM	sale.customer
WHERE	PATINDEX('%yahoo%', email) > 0

--OUESTİON2- Write a query that returns the characters before the '@' character in the email column.

SELECT email, LEFT(email,CHARINDEX('@',email)-1) AS Chars
from sale.customer

--OUESTİON2----Add a new column to the customers table that contains the customers' contact information.
--If the phone is not null, the phone information will be printed, if not, the email information will be printed.

SELECT phone,email,isnull(phone, email) as contact
FROM sale.customer

SELECT phone,email, Coalesce(phone, email, 'no contact') contact --mail ve phone bilgisi olmasaydı no contact yazacaktı.
FROM sale.customer
ORDER BY 3  --3.sutüna göre sırala

-----joins -----
--Quetsion: List products with cotegory names 
--select productID, product name , category ID and category names 

SELECT A.product_id, A.product_name, B.*
FROM product.product as A
INNER JOIN product.category as B
ON A.category_id = B.category_id
ORDER BY A.category_id

--inner join default olarak var bu yüzden , ile jin yapabiliyoruz on yerine where condition kurarak
SELECT A.product_id, A.product_name, B.*
FROM product.product as A, product.category as B
WHERE A.category_id = B.category_id
ORDER BY A.category_id

--Quetsion: List employees of stores with their store information
SELECT a.first_name, a.last_name, b.store_name
FROM sale.staff as a, sale.store as b 
WHERE a.store_id = b.store_id

--Question: Write a querry that returns streets. Third char of the streets is numerical.
SELECT street, SUBSTRING(street, 3, 1)
From sale.customer

SELECT street , SUBSTRING(street, 3, 1) third_char, ISNUMERIC(SUBSTRING(street, 3, 1)) isnumerical
FROM sale.customer 
WHERE ISNUMERIC(SUBSTRING(street, 3, 1))=1

SELECT street , SUBSTRING(street, 3, 1) third_char
FROM sale.customer 
WHERE ISNUMERIC(SUBSTRING(street, 3, 1))=1

----------------LEFFT JOIN---------------
--Questin : Write a query that returns products that have never been ordered 
--Select product ID, product name, orderID

SELECT Distinct a.product_id, a.product_name,b.product_id, b.order_id
FROM product.product a 
LEFT JOIN sale.order_item b 
ON a.product_id = b.product_id
WHERE order_id IS NULL
ORDER BY b.product_id

---Question: Report the stock status of the products that product id greater than 310 in the stores 
--Expected columns : product_id, produc_name, store_id, product_id,quantitiy

SELECT a.product_id, a.product_name, b.*
FROM product.product a 
left JOIN product.stock b 
on a.product_id = b.product_id
WHERE a.product_id > 310

SELECT a.product_id, a.product_name, b.*
FROM product.product a 
left JOIN product.stock b 
on a.product_id = b.product_id
WHERE b.product_id > 310 ---b.product_id içinde null değerler var bu yüzden 159 satır getirdi.

-----right join----
SELECT a.product_id, a.product_name, b.*
FROM product.stock b
RIGHT JOIN  product.product a 
on a.product_id = b.product_id
WHERE b.product_id > 310

--Question: Report the order information made by all staffs 
--Expected columns: staff_id, first_name, last_name, all the information about orders

SELECT a.staff_id, a.first_name, a.last_name, b.*
FROM sale.staff a
left JOIN sale.orders b
on a.staff_id = b.staff_id
ORDER BY order_id

SELECT COUNT(staff_id)
FROM sale.staff;

SELECT count(DISTINCT(staff_id))
FROM sale.orders;

--Note: 4 staff haven't got order ID

------------Full Outer Join----
--Question:Write a query taht returns stock and order information together for all products. retırn only top 100 rows. 
--Expected columns: Product_id, store_id, quantitiy, order_id, list_price

SELECT COUNT(DISTINCT product_id)
FROM product.product

SELECT COUNT(DISTINCT product_id)
FROM product.stock

SELECT COUNT(DISTINCT product_id)
FROM sale.order_item

SELECT	DISTINCT A.product_id, A.product_name, B.product_id, C.product_id
FROM	product.product A
		FULL OUTER JOIN
		product.stock B
		ON	A.product_id = B.product_id
		FULL OUTER JOIN
		sale.order_item C
		ON A.product_id = C.product_id
ORDER BY B.product_id, C.product_id

---------Cross Join----------
/*In the stock table, there are not all products store on the product table and you want to insert these products into the stock table.
You have to insret all these products for every three stores with "0(zero)" quantity. 
Write a query to prepare this data */

/*
1 443
2 443
3 443
1 444
2 444
3 444 */

SELECT DISTINCT a.store_id, b.product_id, '0' as quantity
From product.stock a 
     CROSS JOIN 
     product.product b
WHERE b.product_id NOT IN (select product_id from product.stock)

-------SELF JOİN--------
--QUESTİON : Write a query that returns the staff names with their manager names 
--Expectedcolumns :staff frist_name, staff_last_name, manager name

SELECT	A.*, B.staff_id, B.first_name, B.last_name
FROM	sale.staff A, sale.staff B
WHERE	A.manager_id = B.staff_id

SELECT	A.*, B.staff_id, B.first_name, B.last_name
FROM	sale.staff A
		LEFT JOIN
		sale.staff B
		ON	A.manager_id = B.staff_id

/*
Hem staff'ler hem manager'ler aynı sales.staffs tablosu içindeler.
Bu tablo kendi kendine ilişki içerisinde. bu tabloda iki tane sütun birbiri ile aynı bilgiyi taşıyor.
Burda staff_id ile manager_id birbiri ile ilişki içinde. her staff'in bir manageri var ve bu manager aynı zamanda bir staff..
Mesela staff_id si 2 olan Charles'ın manager_id'si 1,  yani staff_id'si 1 olan kişi Charles'ın manageri demektir.
*/

-----------VİEW--------------
/*
CREATE VIEW view_name AS
   SELECT columns 
   FROM tables 
   [WHERE conditions ] 
*/
--advanteges of Views: Performans,security,Simplicity, Storage

CREATE VIEW [v_sample_summary] AS
SELECT A.customer_id, COUNT(B.order_id) as cnt_order
FROM sale.customer as A, sale.orders as B
WHERE A.customer_id = B.customer_id
AND A.city = 'Charleston'
GROUP BY A.customer_id

SELECT *
FROM v_sample_summary

--Geçici tablo---
SELECT *
INTO #v_sample_summary
FROM v_sample_summary

/*
SQL'İN KENDİ İÇİNDEKİ İŞLEM SIRASI:

FROM : hangi tablolara gitmem gerekiyor?
WHERE : o tablolardan hangi verileri çekmem gerekiyor?
GROUP BY : bu bilgileri ne şekilde gruplayayım?
SELECT : neleri getireyim ve hangi aggragate işlemine tabi tutayım.
HAVING : yukardaki sorgu sonucu çıkan tablo üzerinden nasıl bir filtreleme yapayım (mesela list_price>1000)
Gruplama yaptığımız aynı sorgu içinde bir filtreleme yapmak istiyorsak HAVING kullanacağız
HAVING kullanmadan; HAVING'ten yukarısını alıp başka bir SELECT sorgusunda WHERE şartı ile de bu filtrelemeyi yapabiliriz.
ORDER BY : Çıkan sonucu hangi sıralama ile getireyim? 

-Soruda average veya toplam gibi aggregate işlemi gerektirecek bir istek varsa hemen "GROUP BY" kullanmam gerektiğini anlamalıyım.
-Bir sayma işlemi, bir gruplandırma bir aggregate işlemi yapıyorsan isimle değil ID ile yap. ID'ler her zaman birer defa geçer (Unique’tir), 
isimler tekrar edebilir (ör: bir kaç product'a aynı isim verilmiş olabilir)

SELECT satırında yazdığın sütunların hepsi GROUP BY'da olması gerekiyor!
HAVING ile sadece aggregate ettiğimiz sütuna koşul verebiliriz!
HAVING’de kullandığın sütun, aggregate te kullandığın sütunla aynı olmalı.
*/

--Question: Write a query that checks if any product id is duplicated in product
SELECT*
FROM product.product

SELECT product_id, COUNT(*) cnt_product_id
FROM product.product
GROUP BY product_id
HAVING COUNT(*) > 1

/*
HAVING İLE AGGREGATE ETTİĞİMİZ SÜTUNA FİLTRELEME YAPIYORUZ!
HAVING’DE KULLANDIĞIN SÜTUN, AGGREGATE TE KULLANDIĞIN SÜTUN İSMİYLE AYNI OLMALI!
*/

--Question: Write a query that returns category ids with conditions max list price and min list price

SELECT category_id, MAX(list_price) max_price, MIN(list_price) min_price
FROM product.product
GROUP by category_id

--with conditions max list is gerater than 4000 price and min list price is less than 500
SELECT category_id, MAX(list_price) max_price, MIN(list_price) min_price
FROM product.product
GROUP by category_id
HAVING MAX(list_price) > 4000 or MIN(list_price) < 500

--- and model year is less than 2020
SELECT category_id, MAX(list_price) max_price, MIN(list_price) min_price
FROM product.product
GROUP by category_id
HAVING 
       (MAX(list_price) > 4000 
       or 
       MIN(list_price) < 500)
       and 
       model_year < 2020
/*
SELECT category_id, MIN(list_price) AS min_price, MAX(list_price) AS max_price 
-- Grupladığımız şey "category_id" olduğu için SELECT'te onu getiriyoruz. Group By'da Select'te yazdığın sütunlar muhakkak olmalı.
FROM product.product
-- ana tablo içinde herhangi bir kısıtlamam var mı yani WHERE işlemi var mı? yok. O zaman Group By ile devam ediyorum.
-- Ana tablo içinde herhangi bir kısıtlama yapmayacaksan WHERE satırı kullanmayacaksın demektir.
GROUP BY
          category_id
HAVING
          MIN(list_price) < 500 
	OR 
	MAX(list_price) > 4000;
--GROUP BY ve aggregate neticesinde çıkan tabloyu yukardaki conditionlara göre filtreleyip getirdik. HAVING’in yaptığı iş budur.
-- Dikkat! soruyu iyi okumalısın. soruda “veya” dediği için OR kullandık.
*/

--Question: Find the average product prices of the brands. Display brand name and avarege prices in descending order.

SELECT a.brand_name, AVG(b.list_price) as avg_list_price
FROM product.product b , product.brand a
WHERE a.brand_id = b.brand_id
GROUP BY a.brand_name 

--Soruda average veya toplama gibi Aggregate işlemi gerektirecek bir istek varsa hemen "Group By" kullanmam gerektiğini anlamalıyım.
--Question: Find the average product prices of the brands. Display brand name and avarege prices greater than 1000 in descending order.

SELECT a.brand_name, AVG(b.list_price) as avg_list_price
FROM product.product b , product.brand a
WHERE a.brand_id = b.brand_id
GROUP BY a.brand_name 
HAVING AVG(b.list_price) > 1000
ORDER BY avg_list_price DESC

--Queation: --Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)

SELECT order_id, SUM(quantity * list_price * ( 1-discount )) net_price
FROM sale.order_item
GROUP BY order_id

--Question: Write a query that returns montly order counts of the States 

SELECT order_id, order_date, YEAR(order_date) Years ,MONTH(order_date) Monthly
from sale.orders

SELECT a.[state], year(b.order_date) years, MONTH(b.order_date) monthly, Count(order_id) cnt_order
FROM sale.customer a , sale.orders b
where a.customer_id = b.customer_id
GROUP BY a.[state], year(b.order_date), MONTH(b.order_date)
ORDER BY years, monthly, [state]

-----------------SUMMARY TABLE----------------
SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year

----------GROUPİNG SETS-------------------

--AYNI Sorguda hem markalara ait net amount bilgisini,
--Kategorilere ait net amount bilgisini
--Tüm veriye ait  net amount bilgisini,
--Marka ve Kategori kırılımında net amount bilgisii getiriniz.

SELECT	Brand, Category, SUM(total_sales_price) net_amount
FROM	sale.sales_summary
GROUP BY
		GROUPING SETS (
						(Brand),
						(category),
						(),       --tüm veriye ait bilgi
						(Brand, Category)
						)
ORDER BY 1

/*
SELECT
    column1,
    column2,
    aggregate_function (column3)
FROM
    table_name
GROUP BY
    GROUPING SETS (
        (column1, column2),
        (column1),
        (column2),
        ()
);
*/
-----------------ROLLUP------------------

SELECT Brand, Category, SUM(total_sales_price) net_amount
FROM sale.sales_summary
GROUP BY 
    ROLLUP(Brand, Category) 
ORDER BY 2
--It makes grouping combinations by subtracting one at a time from the column names written in parentheses, in the order from right to left.
/*
SELECT
    d1,
    d2,
    d3,
    aggregate_function(c4)
FROM
    table_name
GROUP BY
    ROLLUP (d1, d2, d3);
--------
d1, d2, d3
d1, d2, NULL
d1, NULL, NULL
NULL, NULL, NULL
*/

------------------CUBE--------------------
SELECT Brand, Category, SUM(total_sales_price) net_amount
FROM sale.sales_summary
GROUP BY 
    CUBE(Brand, Category)
ORDER BY 1

SELECT Brand, Category, SUM(total_sales_price) net_amount
FROM sale.sales_summary
GROUP BY 
    CUBE(Brand, Category,Model_Year)
ORDER BY 1

/*
SELECT
    d1,
    d2,
    d3,
    aggregate_function (c4)
FROM
    table_name
GROUP BY
    CUBE (d1, d2, d3);
------------
d1, d2, d3
d1, d2, NULL
d1, d3, NULL
d2, d3, NULL
d1, NULL, NULL
d2, NULL, NULL
d3, NULL, NULL
NULL, NULL, NULL
*/


-------------------PİVOT---------------------
/*
SELECT [column_name], [pivot_value1], [pivot_value2], ...[pivot_value_n]
FROM 
table_name
PIVOT 
(
 aggregate_function(aggregate_column)
 FOR pivot_column
 IN ([pivot_value1], [pivot_value2], ... [pivot_value_n])
) AS pivot_table_name;
*/

--------------------------------EXTRA NOTE------------------
/*
----date functions
GETDATE()
DATENAME(datepart, date)
DATEPART(datepart, date)
DAY(date)
MONTH(date)
YEAR(date)
DATEDIFF(datepart, startdate, enddate)
DATEADD(datepart, number, date)
EOMONTH(startdate [, month to add])
ISDATE(expression)

---string functions
LEN(input string)
CHARINDEX(substring, string [, start location])
PATINDEX('%PATTERN%', input string)
LEFT(input string, number of characters)
RIGHT(input string, number of characters)
SUBSTRING(input string, start, length)----SUBSTRING() function takes three arguments
LOWER(input string)
UPPER(input string)
STRING_SPLIT(input string, seperator)
TRIM([removed characters, from] input string)
LTRIM(input string, seperator)
RTRIM(input string, seperator)
REPLACE(input string, seperator)
STR(input string, seperator)

💡Tips:
If either pattern or expression is NULL, PATINDEX() returns NULL.
The starting position for PATINDEX() is 1.
PATINDEX works just like LIKE, so you can use any of the wildcards. You do not have to enclose the pattern between percents. 
Unlike LIKE, PATINDEX() returns a position, similar to what CHARINDEX() does..
*/

SELECT *
FROM
(
SELECT	Category, Model_Year, total_sales_price
FROM	sale.sales_summary
) A
PIVOT
(
	SUM(total_sales_price)
	FOR model_year
	IN ([2018], [2019], [2020], [2021])
) as pvt_tbl

----Category çıkarıp yaptık

SELECT *
FROM
(
SELECT Model_Year, total_sales_price
FROM sale.sales_summary 
) a
PIVOT
(
SUM(total_sales_price) 
FOR model_year
IN ([2018],[2019],[2020],[2021])  
) pvt_tbl

--Question:Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.
SELECT *
FROM
(
SELECT	order_id, DATENAME(DW, order_date) order_weekday
FROM	sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) > 2
)A
PIVOT
(
	COUNT(order_id)
	FOR order_weekday
	IN  ([Monday], [Tuesday],  [Wednesday], [Thursday], [Friday], [Saturday], [Sunday])
) as pvt_tbl

--Question : Write a query that shows all employees in the store where Davis Thomas works 

SELECT store_id
FROM sale.staff
WHERE first_name='Davis' 
and    last_name='Thomas'

SELECT*
FROM sale.staff 
WHERE store_id = (SELECT store_id
                  FROM sale.staff
                  WHERE first_name='Davis' 
                  and   last_name='Thomas')

--Question: Write a query that shows the employees for whom Charles Cussona is a first-degree manager.
--(To which employees are Charles Cussona a first-degree manager?)

SELECT*
FROM sale.staff
where manager_id = ( select staff_id
                     FROM sale.staff
                     WHERE first_name = 'Charles'
                     and    last_name = 'Cussona'
                    )

----------
--Write a query that shows the employees for whom Charles Cussona is a first-degree manager.
--(To which employees are Charles Cussona a first-degree manager?)

SELECT	staff_id
FROM	sale.staff
WHERE	first_name = 'Charles'
AND		last_name = 'Cussona'
SELECT *
FROM	sale.staff
WHERE	manager_id = (SELECT	staff_id
						FROM	sale.staff
						WHERE	first_name = 'Charles'
						AND		last_name = 'Cussona')

-- Write a query that returns the customers located where ‘The BFLO Store' is located.
-- 'The BFLO Store' isimli mağazanın bulunduğu şehirdeki müşterileri listeleyin.

SELECT	city
FROM	sale.store
WHERE	 store_name = 'The BFLO Store'
SELECT *
FROM	SALE.customer
WHERE	city = (SELECT	city
				FROM	sale.store
				WHERE	 store_name = 'The BFLO Store')

--Qouestion:Write a query that returns the list of products that are more expensive than 
--the product named 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'

SELECT list_price
FROM product.product
WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'

SELECT*
FROM product.product
WHERE list_price >  (SELECT list_price
                    FROM product.product
                    WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')

-----
--Question:Write a query that returns customer first names, last names and order dates.
-- The customers who are order on the same dates as Laurel Goldammer.

SELECT*
FROM sale.orders A, sale.customer B 
WHERE A.customer_id = B.customer_id
AND  B.first_name = 'Laurel'
AND  B.last_name = 'Goldammer'

Select b.first_name, b.last_name, a.order_date
FROM sale.orders A, sale.customer B 
WHERE A.customer_id = B.customer_id
AND A.order_date IN (SELECT*
                    FROM sale.orders A, sale.customer B 
                    WHERE A.customer_id = B.customer_id
                    AND  B.first_name = 'Laurel'
                    AND  B.last_name = 'Goldammer'
                    )

--Question:List the products that ordered in the last 10 orders in Buffalo city.

Select a.order_id, b.product_name
FROM sale.order_item a, product.product b
WHERE order_id  IN (SELECT Top 10 order_id
                    FROM sale.customer A, sale.orders B 
                    WHERE A.customer_id = B.customer_id
                    and city = 'Buffalo'
                    ORDER BY order_id DESC 
                    )
and a.product_id = b.product_id

--Question:Write a query that returns the list of product names that were made in 2020
--and whose prices are higher than maximum product list price of Receivers Amplifiers category.

SELECT product_name,model_year, list_price
FROM product.product
WHERE model_year = '2020'
and list_price > ( SELECT max(b.list_price)
                     FROM product.category a, product.product b 
                     where a.category_id = b.category_id
                     and a.category_name = 'Receivers Amplifiers'
                    )
ORDER BY list_price DESC

---All kullanarak ;
SELECT *
FROM	product.product
WHERE	model_year = 2020
AND		list_price > ALL (
						SELECT	list_price
						FROM	product.product A, product.category B
						WHERE	A.category_id = B.category_id
						AND		b.category_name = 'Receivers Amplifiers'
						)

----------------Corelated Subquery------------------
/*
EXISTS komutu, belirtilen bir alt sorguda herhangi bir veri varlığını test etmek için kullanılır.
WHERE bloğunda kullanmış olduğumuz IN ifadesinin kullanımına benzer olarak, EXISTS ve NOT EXISTS ifadeleri de alt sorgudan getirilen değerlerin içerisinde bir değerin olması veya olmaması durumunda işlem yapılmasını sağlar.
EXISTS: alt sorguda istenilen şartların yerine getirildiği durumlarda ilgili kaydın listelenmesini sağlar.
NOT EXITS : EXISTS‘in tam tersi olarak alt sorguda istenilen şartların sağlanmadığı durumlarda ilgili kaydın listelenmesini sağlar. 

 customer tablosundan state'leri getiren bir sorgumuz var fakat gelecek olan state'ler WHERE kısmındaki koşula göre listelenecek.
Buna göre: NOT EXIST kullandığımız için; product_name değeri 'Apple - Pre-Owned iPad 3...' DEĞİL İSE ilgilli state listelenecektir. (edited) 

EXIST kullandığın zaman; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIŞTIR anlamına geliyor.
NOT EXIST ; subquery herhangi bir sonuç döndürürse üstteki query'i ÇALIŞTIRMA anlamına geliyor.
*/

--Question:Write a query that returns a list of States where 'Apple - Pre-Owned iPad 3 - 32GB - White'
--product is not ordered

SELECT DISTINCT [state]
FROM sale.customer X
WHERE  EXISTS (
                    SELECT*
                    FROM product.product A, sale.order_item B, sale.orders C, sale.customer D
                    WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
                    AND A.product_id = B.product_id
                    AND B.order_id = C.order_id
                    AND C.customer_id = D.customer_id
                    AND D.[state] = X.state
                 )


SELECT DISTINCT [state]
FROM sale.customer X
WHERE  NOT EXISTS (
                    SELECT*
                    FROM product.product A, sale.order_item B, sale.orders C, sale.customer D
                    WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
                    AND A.product_id = B.product_id
                    AND B.order_id = C.order_id
                    AND C.customer_id = D.customer_id
                    AND D.[state] = X.state
                 )
--aynı sorguyu not in ile de yapabiliriz.
SELECT DISTINCT [state]
FROM sale.customer X
WHERE [state] NOT IN(
                    SELECT [state]
                    FROM product.product A, sale.order_item B, sale.orders C, sale.customer D
                    WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
                    AND A.product_id = B.product_id
                    AND B.order_id = C.order_id
                    AND C.customer_id = D.customer_id
                    
                 )
--Question:Write a query that returns stock information of the products in Davi techno Retail store.
--The BFLO Store hasn't  got any stock of that products.

SELECT X.*
FROM product.stock X, sale.store Y
WHERE X.store_id = Y.store_id 
AND Y.store_name = 'Davi techno Retail'
AND EXISTS (
              SELECT A.*
               FROM product.stock A, sale.store B
               WHERE A.store_id = B.store_id 
               AND B.store_name = 'The BFLO Store'
               AND A.quantity = 0 
               AND X.product_id =A.product_id
             )

SELECT DISTINCT X.product_id
FROM product.stock X, sale.store Y
WHERE X.store_id = Y.store_id 
AND Y.store_name = 'Davi techno Retail'
AND NOT EXISTS (
              SELECT A.*
               FROM product.stock A, sale.store B
               WHERE A.store_id = B.store_id 
               AND B.store_name = 'The BFLO Store'
               AND A.quantity > 0 
               AND X.product_id =A.product_id
             )

SELECT*
FROM product.stock
WHERE product_id = 320             

---ORDİNARY CTE'S
/*
COMMON TABLE ESPRESSIONS (CTE), başka bir SELECT, INSERT, DELETE veya UPDATE deyiminde başvurabileceğiniz veya içinde kullanabileceğiniz geçici bir sonuç kümesidir.
Başka bir SQL sorgusu içinde tanımlayabileceğiniz bir sorgudur. Bu nedenle, diğer sorgular CTE'yi bir tablo gibi kullanabilir.
CTE, daha büyük bir sorguda kullanılmak üzere yardımcı ifadeler yazmamızı sağlar.
*/
-- Query Time
--List customers who have an order prior to the last order date of a customer named Jerald Berray and are residents of the city of Austin.
-- Jerald Berray isimli müşterinin son siparişinden önce sipariş vermiş
--ve Austin şehrinde ikamet eden müşterileri listeleyin.

WITH T1 AS 
(
SELECT Max(order_date) last_order_date
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Jerald'
AND A.last_name = 'Berray'
)
SELECT A.customer_id, A.first_name, A.last_name
FROM sale.customer A, sale.orders B, T1
WHERE A.customer_id = B.customer_id
AND T1.last_order_date > B.order_date
AND A.city ='Austin'



----List all customers their orders are on the same dates with Laurel Goldammer.

WITH T1 AS 
(
SELECT order_date 
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id
AND A.first_name = 'Laurel'
AND A.last_name = 'Goldammer'
)
SELECT DISTINCT A.customer_id, A.first_name, A.last_name
FROM sale.customer A, sale.orders B, T1
WHERE A.customer_id = B.customer_id
AND T1.order_date = B.order_date

With T1 AS
(
select order_date 
from sale.orders B, sale.customer A
where A.customer_id=B.customer_id
and A.first_name='Laurel'
and A.last_name='Goldammer'
)
select Distinct A.customer_id,A.first_name,A.last_name
from sale.customer A, sale.orders B, T1
where A.customer_id=B.customer_id
and B.order_date= T1.order_date 

--------------------RECURSİVE CTE'S----------------------------
/*CTE, Subquery mantığı ile aynı. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazıyoruz.
Sadece WITH kısmını yazarsan tek başına çalışmaz. WITH ile belirttiğim query'yi birazdan kullanacağım demek bu. 
Asıl SQL statementimin içinde bunu kullanıyoruz.*/

WITH T1 AS 
(
    SELECT 0 [NUMBER]
    UNION ALL
    SELECT [NUMBER]+1
    FROM T1
    WHERE NUMBER <9
)
SELECT*
FROM T1 

--List the stores whose turnovers are under the average store turnovers in 2018

WITH T1 AS
(
SELECT	C.store_name, SUM (quantity*list_price*(1-discount)) turnover_of_stores
FROM	sale.order_item A, sale.orders B, sale.store C
WHERE	A.order_id = B.order_id
AND		B.store_id = C.store_id
AND		YEAR (B.order_date) = 2018
GROUP BY
		C.store_id, C.store_name
) , T2 AS
(
SELECT	 AVG(turnover_of_stores) avg_turnover_2018
FROM	 T1
)
SELECT *
FROM	T1, T2
WHERE	T1.turnover_of_stores < T2.avg_turnover_2018

--Question:Write a quary that creates a new column named "total price" calculating the total prices of the products on each order.

SELECT order_id, sum(list_price*(1-discount)*quantity) as total_price
FROM sale.order_item
GROUP BY order_id 


-------SET OPERATORS
-- UNION / UNION ALL
--List the products sold in the cities of Charlotte and Aurora


SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Aurora'
UNION
--75
SELECT	DISTINCT D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
AND		C.product_id = D.product_id
AND		A.city = 'Charlotte'

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


