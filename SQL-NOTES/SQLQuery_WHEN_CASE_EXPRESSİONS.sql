--
-----------------------------------CASE EXPRESSİON---------------------------------- 
--> SİMPLE CASE EXPRESSİON 
CASE case_expression 
    WHEN ...when_expression....... THEN ....result_expression......
    WHEN ...when_expression....... THEN .....result_expression.....
    .....
    [ELSE ....else_result_expression......]
END

-----Create a new column with the meaning of the values in the order_status column.
--> 1=Pending ; 2=Processing ; 3=Rejected ; 4=Completed

SELECT order_id, order_status,
CASE order_status
    WHEN 4 then 'Completed'
    WHEN 3 then 'Rejected'
    WHEN 2 then 'Processing'
    ELSE 'Pending'
    END AS Order_Status
FROM sale.orders 

----Create a new column with the names of the stores to be consistent with the values in the store_ids column.
-- 1-'Davi techno Retail' , 2-'The BFLO Store' , 3- 'Burkes Outlet'

SELECT b.first_name,b.last_name,a.store_id,
CASE a.store_id 
     WHEN 1 then 'Davi techno Retail'
     when 2 then 'The BFLO Store'
     when 3 then 'Burkes Outlet'
     end as store_names
FROM sale.store a, sale.staff b 
WHERE a.store_id = b.store_id
ORDER BY store_id

--which product which is in the which store 
SELECT a.product_name,
CASE b.store_id 
     WHEN 1 then 'Davi techno Retail'
     when 2 then 'The BFLO Store'
     when 3 then 'Burkes Outlet'
     end as store_names
FROM product.product a, product.stock b, sale.store c 
WHERE a.product_id = b.product_id 
and b.store_id = c.store_id



--> SEARCHES CASE EXPRESSİON
--faklı columnlar üzerinde condition kullanmamıza izin veriyor.Ve farklı operatorlerle kullanılabiliyor
CASE  
    WHEN ...when_conditian1....... THEN ....result_1......
    WHEN ...when_condition2....... THEN .....result_2.....
    .....
    [ELSE ....else_result......]
END

-----Create a new column with the meaning of the values in the order_status column.with searches case expression
--> 1=Pending ; 2=Processing ; 3=Rejected ; 4=Completed

SELECT order_id, order_status,
CASE 
    WHEN order_status=4 then 'Completed'
    WHEN order_status=3 then 'Rejected'
    WHEN order_status=2 then 'Processing'
    ELSE 'Pending'
    END AS Order_Status
FROM sale.orders 

---Create a new column that shows which email servis provider.("gmial","hotmail","yahoo" or "other")

SELECT first_name, last_name, email,
CASE 
    WHEN email LIKE '%gmail%' then 'Gmail'
    WHEN email LIKE '%hotmail%' then 'Hotmail'
    WHEN email LIKE '%yahoo%' then 'Yahoo'
    ELSE 'Other'
    END AS email_service_provider
FROM sale.customer

---Write a query that gives the first and last names of customers who have order products from the computer accessories, speakers, and mp4player categories in the same order



 with T1 as (
            SELECT b.order_id,d.first_name,d.last_name,
                    sum(CASE WHEN  category_name= 'Computer Accessories' THEN 1 ELSE 0 END ) AS ctg1,
                    sum(CASE WHEN  category_name= 'mp4 player' THEN 1 ELSE 0 END ) AS ctg2,
                    sum(CASE WHEN  category_name= 'Speakers' THEN 1 ELSE 0 END ) AS ctg3
            FROM product.product a, sale.order_item b, sale.orders c, sale.customer d , product.category e
            WHERE a.product_id = b.product_id 
            and b.order_id = c.order_id 
            and c.customer_id = d.customer_id
            and a.category_id = e.category_id 
            group by b.order_id,d.first_name,d.last_name
            )
            SELECT first_name, last_name
            FROM T1
            WHERE ctg1>=1 and ctg2>=1  and ctg3>=1 

---aynı order_id içerisnde 4,5,6 categorili ürünler. Case kullanarak yapılacak.

---By creating a new column, label the orders according to the instructions below.
--> Label the product as 'Not Shipped' if they were Not shipped
--> Label the product as 'Fast' if they were shipped on the day of order.
--> Label the product as 'Normal' if they were shipped within two days of the order date.
--> Label the products as 'Slow' if they were shipped later than two days of the order date.

SELECT*,
CASE 
    WHEN  shipped_date = order_date then 'Fast'
    WHEN  difference(shipped_date,order_date) <= 2 then 'Normal'
    WHEN  difference(shipped_date,order_date) > 2 then 'Slow'
    ELSE 'Not Shipped'
    END as ORDER_LABEL
FROM sale.orders
ORDER by order_status 


--Write a query that returns the count of the orders day by day in a pivot table format that has been shipped two days later.

SELECT	
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Sunday' THEN 1 ELSE 0 END ) AS Sunday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Monday' THEN 1 ELSE 0 END )AS Monday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END )AS Tuesday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS Wednesday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Thursday' THEN 1 ELSE 0 END )AS Thursday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS Friday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Saturday' THEN 1 ELSE 0 END )AS Saturday
FROM	sale.orders
WHERE	DATEDIFF (DAY, order_date, shipped_date) >2


/*
CASE ile karşılaştırma yapmak : CASE deyimi ile karşılaştırma da yapabiliriz.
Örneğin seyehat bilgilerinin yer aldığı bir tablomuz olsun. Seyahat bilgilerinden bir sütunda otelde kalma süresi diğer bir sütunda yolda geçecek süre olsun. Bu iki sütundan hangisi büyük veya hangisi küçük olduğunu seçip ayrı bir kolonda tıpkı yeni bir sütun gibi gösterebiliriz.
SELECT VacationHours, SickLeaveHours, 
             CASE 
                   WHEN VacationHours > SickLeaveHours THEN VacationHours     
            ELSE SickLeaveHours 
            END AS 'Büyük Değer' 
FROM HumanResources.Employee
*/