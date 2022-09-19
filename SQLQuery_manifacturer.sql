CREATE DATABASE Manufacturer;
USE Manufacturer

CREATE SCHEMA Component;

CREATE SCHEMA Product;

CREATE SCHEMA Supplier;

----------------------product table-------------------
CREATE TABLE Product.product
(
prod_id INT PRIMARY KEY NOT NULL,
prod_name nvarchar(50),
quantity INT,
)
----------------------Prod_comp table-------------------
CREATE TABLE Product.Prod_Comp
(
prod_id INT NOT NULL,
comp_id INT NOT NULL,
quantitiy_comp INT
PRIMARY KEY(prod_id,comp_id)
)
----------------------Component Table-------------------
CREATE TABLE Component.Component
(
comp_id INT PRIMARY KEY NOT NULL,
comp_name nvarchar(50),
description nvarchar(50),
quantitiy_comp INT,
)
----------------------supplier table-------------------
CREATE TABLE Supplier.Supplier
(
supp_id INT PRIMARY KEY NOT NULL,
supp_name nvarchar(50),
supp_location nvarchar(50),
supp_country nvarchar(50),
is_active BIT,
)
----------------------comp_supp table-------------------
CREATE TABLE Component.comp_supp
(
supp_id INT NOT NULL,
comp_id INT NOT NULL,
order_date DATE,
quantitive INT ,
PRIMARY KEY(supp_id,comp_id)
)

ALTER TABLE Product.Prod_Comp ADD CONSTRAINT FK1 FOREIGN KEY (prod_id) REFERENCES Product.product(prod_id)

ALTER TABLE Product.Prod_Comp ADD CONSTRAINT FK2 FOREIGN KEY (comp_id) REFERENCES Component.Component(comp_id)

ALTER TABLE Component.comp_supp ADD CONSTRAINT FK1 FOREIGN KEY (supp_id) REFERENCES Supplier.Supplier(supp_id)

ALTER TABLE Component.comp_supp ADD CONSTRAINT FK2 FOREIGN KEY (comp_id) REFERENCES Component.Component(comp_id)