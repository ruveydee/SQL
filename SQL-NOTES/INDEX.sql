/*
Tablo üzerinde bir veri araması yaptığımızı varsayalım. Veritabanında saklanan verilerin sayısı arttıkça bu performansta düşüklüğe neden olur.
Dağınık yapıda olan verilerde istenilen veriyi aramak için tablo taraması işlemi yapılır. Sql’de indexe sahip olmayan tablolara heap adı verilir. 
Heap bir tabloda bir select çektiğimizde, sql tablodaki kaydı bulabilmek için bütün kayıtları bir bir dolaşır. 
Hatta kaydı bulsa dahi, birden fazla kayıt olma ihtimaline karşı tabloyu dolaşmaya devam eder. 
Bu da sql için ciddi bir performans kaybına yol açar. Bu işlemi küçük boyutlu bir tabloda yapmak kolaydır. 
Ancak artan veri miktarına göre bu işlem vakit kaybettirir. 
Indexler ise tablolardan veri çekmek için gerekli sorgular çalıştırılırken gereken süreyi azaltmak için kullanılırlar. 
İşte tam da bu noktada , sorgu işlemlerimi yaparken CLUSTERED index ve NON-CLUSTERED index kavramlarını bilmemiz sql performansı açısından işimize yarayacaktır.

*makale alıntıdır.(http://cagataykiziltan.net/clustred-index-vs-non-clustred-index/)
*/
/*
Tablomuzda aşağıdaki gibi binlerce hatta yüzbinlerce kayıt olduğunu varsayalım. 
Bu tabloda kayıtları spesifikleştiren hiç bir index bulunmamaktadır. Bu yüzden insert durumunda kayıtlar tamamen free olarak tabloya yerleşir.   
Bu gibi tablodan select * from website_visitor where first_name = 'visitor_name17' şeklinde bir select attığımzda , 
sql kolonları unique yapacak bir veriye sahip olmadığı için 1. kayıttan itibaren sırayla Name’i 'visitor_name17' olan kaydı aramaya başlar. 
Bu tip arama işlemine scan denir. Bulsa dahi birden fazla Tobb isimli kayıt olup olmadığını bilmediğinden, aramaya devam eder. 
Al sana performans problemi 
*/


create table website_visitor 
(
visitor_id int,
first_name varchar(50),
last_name varchar(50),
phone_number bigint,
city varchar(50)
);

DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200000
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT @i , 'visitor_name' + cast (@i as varchar(20)), 'visitor_surname' + cast (@i as varchar(20)),
		5326559632 + @i, 'city' + cast(@RAND as varchar(2))
	SET @i +=1
END;

SELECT top 100 *
FROM
website_visitor

SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT *
FROM
website_visitor
where
visitor_id = 100

---TABLE SCAN yapacak yani tablonun her satırını tek tek dolaşarakk visitor_id 100 bulana kadar.
/*
-----Clustred Index
Clustred index , veriyi sql’de fiziksel olarak sıraya sokan yapıdır. Aslında hepimiz clustred index’i tablolarımızda kullanıyoruz. 
Tablolarımıza tanımladığımız her bir Primary key aslında otomatik olarak bir Clustred index yapısıdır. 
Çünkü tablolarımız bu pk’ya göre fiziksel olarak sıralanır.

Clustered index ile ilgili önemli noktalar
Her tabloda yalnızca 1 adet clustered index olabilir.
Sql query sonucu sıralı dataları dönerken de clustered indexe göre aynı sırada döner.
Tablodaki bir clustered index pk olabileceği gibi aynı zamanda birden fazla kolonun birleşiminden oluşan bir yapı da olabilir. 
Buna composite clustered index denir.

Primary key – Clustered Index farkı nedir?
Tam bu noktada kafa karışıklığını önlemek için primary key ve clustered indexin farkını netleştirmek istiyorum. 
Primary key dediğimiz, tablodaki kaydın uniqueliğini garantileyen bir alandır ve kaydın kimliğidir. 
Tanımlandığı gibi de clustered index özelliği taşır. Peki clustered index nedir? 
Yukarıda da anlattığımız gibi bir veri yapısı, dataya daha hızlı ulaşmak için oluşturulmuş bir indexleme şeklidir.
Genel olarak datanın fiziksel sıralamasını düzenleyerek dataya ulaşma süresini optimize etmeyi amaçlarken, keyler ise datanın uniqueliğini sağlar.

Aşağıdaki query ile 2 kolona bağlı clustered index yaratmış olduk. 
Bu query’nin bize söylediği şey, tablomdaki kayıtları Gender’a göre diz , genderi aynı olanları da artan sırada salary’e göre diz. Siz insertlerinizi ne şekilde atarsanız atın, dizilim bu yönde olacaktır.

>>create clustered index myClusteredIndex On tblEmployee (Gender Desc,Salary Asc)

>>Drop index tblEmploye



Non-Clustered Index 
Non-clustered indexlemede durum biraz daha farklıdır. 
Bir kolonu Non-clustered index olarak indexlediğinizde, arka tarafta yeni bir tablo oluşur ve bu tablo sizin indexlediğiniz kolona karşılık kolon adresini tutar. 
Yani bir nevi pointer yapısı gibi düşünebilirsiniz. Non-clustered indekste verilere direkt erişilemez. Elde edilen indeksleme yapısına erişmek için kümelenmiş indeks yapısı kullanılmış olur. 
Verileri herhangi bir alana göre sıralandığında erişim kümelenmiş indeks üzerinden anahtar değer referans alınarak yapılır. 

Non-cluster indexlemeyi kafanızda oturtabilmek için klasikleşmiş kitap örneğini düşünebilirsiniz. 
Kitapların başında içerik kısmı vardır. Bu içerik kısmında her bir konu başlığının hangi sayfa numarasında veya sayfa numaraları aralığında olduğunu gösterir. 
Siz kitabı açtığınızda önce içerik sayfasına bakarsınız. Daha sonra aradığınız içeriğin sayfasını ya da sayfa aralığını öğrenip direkt olarak bu sayfalara geçersiniz. 
Non-cluster index de tam olarak bunu yapmakta.

Non clustered index ile ilgili önemli noktalar

>>Bir tablonun birden fazla non-cluster indexi olabilir.
>>Bir tabloya non-cluster index eklemek, tablonun fiziksel dizilimini etkilemez.
*/

CREATE CLUSTERED INDEX CLS_INDX_1 ON website_visitor (visitor_id);

SELECT visitor_id
FROM
website_visitor
where
visitor_id = 100
---Execution Plan da Clustered Index Seek oldu.

SELECT *
FROM
website_visitor
where
visitor_id = 100
--Tümsutunları çagırdığımda ise de Execution Plan da Clustered Index Seek oldu. index bilgilerini elde ettiğimizde diğer tüm sutunları da elde etmiş oluyorum.

SELECT first_name
FROM
website_visitor
where
first_name = 'visitor_name17'

Create unique NONCLUSTERED INDEX ix_NoN_CLS_2 ON website_visitor (first_name) include (last_name);

SELECT first_name, last_name
FROM
website_visitor
where
first_name = 'visitor_name17'

CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[website_visitor] ([last_name])

SELECT last_name
FROM
website_visitor
where
last_name = 'visitor_surname10'


Execute sp_helpindex website_visitor --tablomuzdaki Cluster indexleri non cluster indexleri görmemizi sağlıyor.

---NOTE:Medium Makale
/*

<a href="https://berkemrecabuk.medium.com/execution-plan-nas%C4%B1l-i%CC%87ncelenmelidir-part-1-70f30be0f88d"></a>
<a href="https://berkemrecabuk.medium.com/execution-plan-nas%C4%B1l-i%CC%87ncelenmelidir-part-2-b475c35fcfe9"></a>
<a href="https://berkemrecabuk.medium.com/execution-plan-nasil-incelenmelidir-part-3-e2a1a38fb285"></a>
*/