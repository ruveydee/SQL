

--------------------------SQL Stored Procedures for SQL Server------------------

---istenilen sorguyu yazıp analiz ettikten sonra kaydedip gerektiği zaman gerektiği yerde kullnabiliriz. Büyük tabloları joinlemek uzun sorgulara yola çıyor 
---Ve bunu her seferinde çalıştırıp rapor etmek zor oluyor bu yüzden viewlerle tablolara bölüp bunu kaydettiğimizde çağırıp kullanabiliyoruz.
---Kaydettiğimiz query update etme imkanı sağlıyor ve yetki veridiğimiz kişilerle paylaşıp farklı queryler görme imkanı sağlıyor.  
---performans açısından her seferinde büyük sorguları çalıştırmaktansa kaydettiğimizde tek seferde bu işlemi yapıp ve çağırdığımızda sorgu trafiğini azaltmış oluyoruz
---Sql injection sql kodunun arasına farklı keywordlerle müdahale etmek

-------> syntax of Stored Procedrues
/*
CREATE PROCEDURE procedure_name
AS
sql_statement
GO;

Execute a Stored Procedure
EXEC procedure_name;
*/

CREATE OR ALTER PROCEDURE sp_sampleproc2 AS
BEGIN
    PRINT 'CLARUSWAY'
END

EXEC sp_sampleproc2

Python:
print('CLARUSWAY')

CREATE TABLE ORDER_TBL
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);

INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 7, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 8, 'Johnson',GETDATE(), GETDATE()+5 )

CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan TESLİM TARİHİ
);
SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES 
	  	 	 	(1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )

SELECT*
FROM ORDER_TBL

SELECT*
FROM ORDER_DELIVERY

GO
CREATE OR ALTER PROC sp_sampleproc3 AS
BEGIN
	SELECT COUNT (ORDER_ID) AS CNT_ORDER
	FROM ORDER_TBL
END --bu proced. ne zaman çalıştırırsak anlık olarak order_id sayısını verecek. Verileri güncel tutmak için 

EXEC sp_sampleproc3 --8 order ıd var şuan

INSERT ORDER_TBL VALUES (9,9, 'Adam', NULL, NULL)
SELECT *
FROM ORDER_TBL --1 kişi ekledik

EXEC sp_sampleproc3 -- güncel değeriyle order id sayısını verdi 9 olarak
 

------PROCEDURE PARAMS
Go
CREATE OR ALTER PROC sp_sampleproc4 (@DAY DATE = '01-01-2022')
AS
BEGIN
	SELECT COUNT (ORDER_ID) AS CNT_ORDER
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @DAY
END

EXEC sp_sampleproc4 '2022-09-29'
-----
Go
CREATE OR ALTER PROC sp_sampleproc5 (@CUSTOMER VARCHAR(50), @DAY DATE = '01-01-2022')
AS
BEGIN
	SELECT COUNT (ORDER_ID) AS CNT_ORDER
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @DAY
	AND		CUSTOMER_NAME = @CUSTOMER
END

EXEC sp_sampleproc5 'Adam', '2022-10-02'
--bu şekilde de çağrılabilir.
EXEC sp_sampleproc5 @CUSTOMER = 'Adam', @DAY = '2022-10-02'

-----QUERY PARAMS---

DECLARE @V1 INT 
DECLARE @V2 INT 
DECLARE @RESULT INT 
--set ile değer atıyoruz.
SET @V1 = 5
SET @V2 = 6 
SET @RESULT = @V1 * @V2
--birlikte çalıştırılıyor.
--SELECT @RESULT AS RESULT

-- --Veya print ile de yazdırılabilir.
PRINT @RESULT
----Yine birlikte çalıştırıyoruz..
----

DECLARE @V1 INT = 5 , @V2 INT = 6 , @RESULT  INT 
SET @RESULT = @V1 * @V2
SELECT @RESULT

DECLARE @V1 INT 
DECLARE @V2 INT 
DECLARE @RESULT INT 
--birlikte çalıştırıyoruz.
SELECT @V1 = 5, @V2= 6, @RESULT = @V1 * @V2
SELECT @RESULT

----------
DECLARE @DAY DATE
SET @DAY = '2022-09-28'

SELECT*
FROM ORDER_TBL 
WHERE ORDER_DATE = @DAY

--------IF , ELSE IF , ELSE

SELECT*
FROM ORDER_TBL 

DECLARE @CUSTOMER_ID INT = 4
IF @CUSTOMER_ID = 1 
	PRINT 'CUSTOMER NAME IS ADAM'
ELSE IF @CUSTOMER_ID = 2
	PRINT 'CUSTOMER NAME IS SMITH'
ELSE 
	 PRINT 'CUSTOMER  NAME IS JOHN'

----
IF EXISTS (SELECT 1)
	SELECT * FROM ORDER_TBL

IF NOT EXISTS (SELECT 1)
	SELECT * FROM ORDER_TBL

DECLARE @CUSTOMER_ID INT 
SET @CUSTOMER_ID = 5
IF EXISTS (SELECT* FROM ORDER_TBL WHERE CUSTOMER_ID = @CUSTOMER_ID )
	SELECT COUNT(ORDER_ID )
	FROM ORDER_TBL 
	WHERE CUSTOMER_ID = @CUSTOMER_ID 

DECLARE @CUSTOMER_ID INT 
SET @CUSTOMER_ID = 5
IF NOT EXISTS (SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID = @CUSTOMER_ID )
	SELECT COUNT(ORDER_ID )
	FROM ORDER_TBL 
	WHERE CUSTOMER_ID = @CUSTOMER_ID 

--iki değişken tanımlayın
--1. değişken ikincisinden büyük ise iki değişkeni toplayın
--2. değişken birincisinden büyük ise 2. değişkenden 1. değişkeni çıkarın
--1. değişken 2. değişkene eşit ise iki değişkeni çarpın

DECLARE @V1 INT , @V2 INT 
SET @V1 = 3 
SET @V2 = 4
IF @V1 > @V2 
	SELECT @V2 + @V1 AS TOPLAM 
ELSE IF @V2 > @V1 
	 SELECT @V2 - @V1 AS FARK
ELSE 
	 SELECT @V2 * @V1 AS CARPIM

--istenilen tarihte verilen sipariş sayısı 5 ' ten küçükse 'lower than 5'
--5 ile 10 arasındaysa sipariş sayısı (kaç ise sayı)
--10' dan büyük ise 'upper than 10' yazdıran bir sorgu yazınız.

SELECT*
FROM ORDER_TBL

DECLARE @DATE DATE
DECLARE @COUNTORDER INT 
SET @DATE = '2022-10-05'
SELECT @COUNTORDER = COUNT(ORDER_ID) FROM ORDER_TBL WHERE ORDER_DATE = @DATE
IF @COUNTORDER < 5
	 SELECT 'LOWER THAN 5'
ELSE IF @COUNTORDER BETWEEN 5 AND 10
	SELECT @COUNTORDER
ELSE 
	 SELECT 'UPPER THAN 10'

------------WHILE------------

DECLARE @COUNTER INT  = 1

WHILE @COUNTER < 21
BEGIN
	 	PRINT @COUNTER 
	 	SET @COUNTER = @COUNTER + 1

END 
----------------------------
SELECT*
FROM ORDER_TBL 
--Tabloya while ile veri ekleyeceğiz 

DECLARE @ID INT  = 10

WHILE @ID < 21
BEGIN
	 INSERT ORDER_TBL VALUES(@ID, @ID, NULL, NULL, NULL)
	 SET @ID += 1
END 

SELECT*
FROM ORDER_TBL 
------------------------------
--                              <----FUNCTIONS---->(ikiye ayrılır)
---     >>>SCALAR VALUED FUNCTIONS                >>>TABLE VALUED FUNCTIONS 
--(Tek bir değer döndürüyor)                         (Bir tablo döndürüyor)

CREATE FUNCTION FUNCTION_NAME(@PAREMETER TYPE)      CREATE FUNCTION FUNCTION_NAME(@PAREMETER TYPE)
RETURNS TYPE                                        RETURN TABLE
AS												   	AS
BEGIN 												RETURN SQL_STATEMENT
    SQL_STATEMENT										
RETURN VALUE 										
END;												

GO
CREATE FUNCTION UPPER_FIRST_CHAR()
RETURNS NVARCHAR(MAX)
AS 
BEGIN
     RETURN UPPER(LEFT('CHARACTER', 1)) + LOWER(RIGHT('CHARACTER' , LEN('CHARACTER')-1))
END
----burda fonk sadce character kelimesinde değişiklik yapacak fakat bunu girdiğimiz bir kelimeye uygulatmak istesek değişken oluşturmamız gerekirdi.

GO
CREATE FUNCTION FUNCT_UPPER_FIRST_CHAR(@CHAR NVARCHAR(MAX)) ---değişken yazdık @char ve fonk oluşturduk.
RETURNS NVARCHAR(MAX)
AS 
BEGIN
     RETURN UPPER(LEFT(@CHAR, 1)) + LOWER(RIGHT(@CHAR , LEN(@CHAR)-1))
END

GO
SELECT dbo.FUNCT_UPPER_FIRST_CHAR('RÜVEYDE')

------TABLE- VALUED - FUNCT.
GO
CREATE FUNCTION FUNCT_TABLE()
RETURNS TABLE 
AS
	RETURN SELECT* FROM ORDER_TBL WHERE CUSTOMER_NAME = 'Adam'

GO
SELECT*
FROM dbo.FUNCT_TABLE()

----parametre koyalım ;
GO
CREATE FUNCTION FUNCT_TABLE_ORDER(@CUSTOMER_NAME NVARCHAR(MAX))
RETURNS TABLE 
AS
	RETURN SELECT* FROM ORDER_TBL WHERE CUSTOMER_NAME = @CUSTOMER_NAME

GO
SELECT*
FROM dbo.FUNCT_TABLE_ORDER('Adam')

-----
GO
CREATE FUNCTION TABLE_FUNCT()
RETURNS @TBL TABLE ( ORDER_ID INT, ORDER_DATE DATE)
AS
BEGIN
	INSERT @TBL VALUES(1, '2022-04-05')
	RETURN
END

GO
SELECT*
FROM dbo.TABLE_FUNCT()

GO
DECLARE @TBL TABLE (ORDER_ID INT , ORDER_DATE DATE) --Tablo değişkeni oluştruduk

SELECT*
FROM @TBL


