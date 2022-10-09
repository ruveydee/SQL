CREATE DATABASE E_Commerce ;
USE E_Commerce 


--tabloları bağladık
ALTER TABLE dbo.Market_Fact ADD CONSTRAINT FK1 FOREIGN KEY (Ord_ID) REFERENCES dbo.Orders_Dimen 

ALTER TABLE dbo.Market_Fact ADD CONSTRAINT FK2 FOREIGN KEY (Prod_ID) REFERENCES dbo.prod_dimen

ALTER TABLE dbo.Market_Fact ADD CONSTRAINT FK3 FOREIGN KEY (Ship_ID) REFERENCES dbo.Shipping_Dimen

ALTER TABLE dbo.Market_Fact ADD CONSTRAINT FK4 FOREIGN KEY (Cust_ID) REFERENCES dbo.cust_dimen


--DaWSQL ---

--1.We created a new table named "combined_table" consisting these tables (“market_fact”, “cust_dimen”, “orders_dimen”, “prod_dimen”, “shipping_dimen”,)
--"combined_table" adında yeni bir tablo oluşturduk diğer tabloları joinleyerek.

select A.Sales, A.Discount, A.Order_Quantity, A.Product_Base_Margin, B.*,C.*,D.*,E.*
INTO combined_table
  from market_fact A
        FULL OUTER JOIN orders_dimen B ON B.Ord_id = A.Ord_id
        FULL OUTER JOIN prod_dimen C ON C.Prod_id = A.Prod_id
        FULL OUTER JOIN cust_dimen D ON D.Cust_id = A.Cust_id
        FULL OUTER JOIN Shipping_Dimen E ON E.Ship_id = A.Ship_id 


------------------

--2. Find the top 3 customers who have the maximum count of orders.


SELECT TOP 3 Cust_ID, Customer_Name, COUNT(DISTINCT Ord_ID) AS count_of_order
FROM combined_table
GROUP BY Cust_ID, Customer_Name
ORDER BY count_of_order DESC 


--3.Create a new column at combined_table as DaysTakenForShipping that contains the date difference of Order_Date and Ship_Date.

Alter table combined_table add DaysTakenForShipping INT;

UPDATE combined_table
SET DaysTakenForShipping = DATEDIFF(DAY,Order_Date,Ship_date)

SELECT DaysTakenForShipping
FROM combined_table

--4. Find the customer whose order took the maximum time to get shipping.

SELECT top 1 Cust_ID, Customer_Name, Order_Date, Ship_Date, DaysTakenForShipping
FROM combined_table
ORDER BY DaysTakenForShipping DESC


--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011.

--Ocak ayındaki toplam benzersiz müşteri sayısını ve 2011'de tüm yıl boyunca her ay bunlardan kaçının geri geldiğini sayın.

---2011 yılında ve ocak  ayında kayıtlı olan müşteriler 


SELECT MONTH(Order_Date) as month, count(DISTINCT Cust_ID) as count_of_customer
FROM combined_table
WHERE Cust_ID IN(
                    SELECT Cust_ID
                    FROM combined_table
                    WHERE Datepart(MONTH, Order_Date) = 1 and YEAR(Order_Date) = 2011  
                )
AND YEAR(Order_Date) = 2011
GROUP BY MONTH(Order_Date)

--6. Write a query to return for each user the time elapsed between the first purchasing and the third purchasing, in ascending order by Customer ID.


--Her kullanıcı için ilk satın alma ile üçüncü satın alma arasında geçen süreyi Müşteri Kimliğine göre artan sırada döndürecek bir sorgu yazın.

GO

WITH T1 AS
(
SELECT Cust_ID,Order_Date,
MIN(Order_Date) OVER (PARTITION BY Cust_ID order by Order_Date, Cust_ID) first_order,
DENSE_RANK() OVER (PARTITION BY Cust_ID order by Order_Date, Cust_ID) dn_rnk
FROM combined_table 
)
SELECT distinct Cust_ID, Order_Date, DATEDIFF(DAY,first_order,Order_Date ) AS elapsed_time
FROM  T1 
WHERE dn_rnk  = 3 
ORDER BY Cust_ID

--7.Write a query that returns customers who purchased both product 11 and product 14, as well as the ratio of these products to the total number of products purchased by the customer.

--7. Hem 11. ürünü hem de 14. ürünü satın alan müşterileri ve bu ürünlerin müşterinin satın aldığı toplam ürün sayısına oranını döndüren bir sorgu yazın.



WITH T1 AS 
(
SELECT  Cust_ID, COUNT(Prod_ID) total_prod,
        SUM(CASE WHEN Prod_ID = 'Prod_11' THEN 1 ELSE 0 END) AS PRO_11,
        SUM(CASE WHEN Prod_ID = 'Prod_14' THEN 1 ELSE 0 END) AS PRO_14
FROM combined_table
WHERE Cust_ID in (SELECT Cust_ID
                  FROM combined_table 
                  WHERE Prod_ID = 'Prod_11'
                  INTERSECT
                  SELECT Cust_ID
                  FROM combined_table 
                  WHERE Prod_ID = 'Prod_14')
GROUP BY Cust_ID
)
SELECT Cust_ID, ROUND((cast(PRO_11 as float) ) / cast(total_prod as float),2) RATIO_11,
ROUND((cast(PRO_14 as float)) / cast(total_prod as float),2) RATIO_14
FROM T1


--Customer Segmentation
--Categorize customers based on their frequency of visits. The following steps will guide you. If you want, you can track your own way.

--1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)

--1-Müşterilerin ziyaret günlüklerini aylık olarak tutan bir "görünüm" oluşturun. (Her log için üç alan tutulur: Cust_id,Year, Month)

CREATE VIEW logs_of_customer
AS 
SELECT Cust_ID, YEAR(Order_Date) [Year], MONTH(Order_Date) [Month]
FROM combined_table

SELECT*
FROM logs_of_customer
ORDER by Cust_ID,[Year]


--2. Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning business)

--2. Kullanıcıların aylık ziyaretlerinin sayısını tutan bir "görünüm" oluşturun. (İş başlangıcından itibaren tüm ayları ayrı ayrı gösterin)


CREATE VIEW montly_visits
AS 
SELECT Cust_ID, MONTH(Order_Date) Month_order, COUNT(Order_Date) cnt_order
FROM combined_table
GROUP BY Cust_ID, MONTH(Order_Date)


SELECT*
FROM montly_visits
ORDER BY Cust_ID

--3. For each visit of customers, create the next month of the visit as a separate column.

--3. Müşterilerin her ziyareti için, ziyaretin bir sonraki ayını ayrı bir sütun olarak oluşturun.


CREATE VIEW Next_Visit_Month AS

SELECT Cust_ID, Year_order , Month_order,
LEAD(Month_order) OVER (partition by Cust_ID order by Year_order, Month_order) Next_Order,
DENSE_RANK() OVER(partition by Cust_ID ORDER BY Year_order, Month_order) dns_rnk
FROM montly_visits
;

--4. Calculate the monthly time gap between two consecutive visits by each customer.

--4. Her müşterinin birbirini takip eden iki ziyareti arasındaki aylık zaman aralığını hesaplayın.

CREATE VIEW montly_time_gaps AS
WITH T2  AS
(
SELECT distinct Cust_ID, Order_Date,
lead(Order_Date) over (partition by Cust_ID ORDER by Order_Date) next_order
FROM combined_table
)
SELECT*, DATEDIFF(MONTH, Order_Date, next_order) as monthly_time_gap
FROM T2


--5. Categorise customers using average time gaps. Choose the most fitted labeling model for you.
---For example:
-- Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
-- Labeled as regular if the customer has made a purchase every month.

--5. Ortalama zaman boşluklarını kullanarak müşterileri kategorilere ayırın. Size en uygun etiketleme modelini seçin.
---Örneğin:
-- Müşteri, ilk satın alma işleminden sonraki aylar içinde başka bir satın alma işlemi yapmadıysa, kayıp olarak etiketlenir.
-- Müşteri her ay alışveriş yaptıysa normal olarak etiketlenir.


select Cust_ID,
case when AVG(monthly_time_gap) is Null then 'Churn' 
     when AVG(monthly_time_gap) <= 3 then 'Regular' 
     ELSE 'Irregular' END Labeling
FROM montly_time_gaps 
GROUP BY Cust_ID


/*
Month-Wise Retention Rate
Find month-by-month customer retention ratei since the start of the business.
There are many different variations in the calculation of Retention Rate. But we will try to calculate the month-wise retention rate in this project.
So, we will be interested in how many of the customers in the previous month could be retained in the next month.
Proceed step by step by creating “views”. You can use the view you got at the end of the Customer Segmentation section as a source.

Ay Bazında Elde Tutma Oranı
İşin başlangıcından bu yana aylık müşteri elde tutma oranını bulun.
Tutma Oranının hesaplanmasında birçok farklı varyasyon vardır. Ancak bu projede aylık elde tutma oranını hesaplamaya çalışacağız.
Bu nedenle, bir önceki aydaki müşterilerin kaçının gelecek ay elde tutulabileceği ile ilgileneceğiz.
"Görünümler" oluşturarak adım adım ilerleyin. Müşteri Segmentasyonu bölümünün sonunda elde ettiğiniz görünümü kaynak olarak kullanabilirsiniz.

1. Find the number of customers retained month-wise. (You can use time gaps)
2. Calculate the month-wise retention rate.
Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

1. Ay bazında elde tutulan müşteri sayısını bulun. (Zaman boşluklarını kullanabilirsiniz)
2. Ay bazında elde tutma oranını hesaplayın.
*/


---1

SELECT distinct YEAR(Order_Date) year, Month(Order_Date) month, COUNT(Cust_ID) OVER(partition by YEAR(Order_Date),MONTH(Order_Date)) retained_month_wise
FROM montly_time_gaps
WHERE monthly_time_gap = 1
ORDER by YEAR(Order_Date), Month(Order_Date)


---2

WITH CTE as 
(
SELECT top 50 YEAR(Order_Date) year, MONTH(Order_Date) month, Count(Cust_ID) as TotalCustomer,
sum(case when monthly_time_gap = 1 then 1 END) RetainedCustomer
FROM montly_time_gaps
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER by YEAR(Order_Date), MONTH(Order_Date)
)
select*, round(1.0 *(cast(RetainedCustomer as float) / cast(TotalCustomer as float)), 2) MonthWise_RetentionRate
FROM CTE 
WHERE RetainedCustomer is not null