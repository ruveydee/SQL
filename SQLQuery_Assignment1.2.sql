--QUESTİON 2: 
/* 
Conversion Rate
Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements 
given by an E-Commerce company. Write a query to return the conversion rate for each Advertisement type.
a.    Create above table (Actions) and insert values,
b.    Retrieve count of total Actions and Orders for each Advertisement Type,
c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.
*/

CREATE TABLE ACTİONS(
                    [Visitor_ID] INT PRIMARY KEY  NOT NULL,
                    [Adv_Type] VARCHAR(10),
                    [Action ] VARCHAR(10)
                    );


INSERT INTO ACTİONS(Visitor_ID, Adv_Type, [Action ]) 
VALUES 
(1,'A','Left'),
(2,'A','Order'),
(3,'B','Left'),
(4,'A','Order'),
(5,'A','Review'),
(6,'A','Left'),
(7,'B','Left'),
(8,'B','Order'),
(9,'B','Review'),
(10,'A','Review');
----Return all table ------
select*
FROM ACTİONS

----return count of total Actions for each advertisement--- 
SELECT Adv_Type,COUNT(Visitor_ID) Total_cnt
FROM ACTİONS
GROUP by Adv_Type

--create new table from above query---
SELECT Adv_Type,COUNT(Visitor_ID) Total_cnt
INTO total_table
FROM ACTİONS 
GROUP by Adv_Type

----return order count for each advertisement-----
SELECT Adv_Type,COUNT(Visitor_ID) Order_cnt 
FROM ACTİONS
WHERE [Action ]= 'order'
GROUP BY Adv_Type

----Create new table above query---
select Adv_Type, COUNT(Visitor_ID) Order_cnt 
INTO total_order
FROM ACTİONS
WHERE [Action ]= 'order'
GROUP BY Adv_Type

----- The result is query to return the conversion rate for each Advertisement type.---
SELECT a.Adv_Type, ROUND(cast(b.Order_cnt as float) / a.Total_cnt, 2,1) Conversion_Rate
FROM total_table a, total_order b
WHERE a.Adv_Type = b.Adv_Type

