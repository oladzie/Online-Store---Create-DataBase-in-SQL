--Stw�rz baz� danych.
--Baza danych ma zawiera� minimum 4 tabel po��czonych ze sob� relacjami (jedna z tabel musi ��czy� si� z minimum dwoma innymi).
--Tabela ma zawiera� minimum 4 kolumn w tym klucz g��wny i obcy. 
--Tabele maj� zawiera� instrukcj� `CHECK` lub `DEFAULT`.
--Kolumny musz� by� zar�wno typu tekstowego, jak i liczbowego.
--Do tabeli dodaj minimum 2-3 rekordy.


--Utw�rz zapytanie wy�wietlaj�ce rekordy z minimum dw�ch tabel.
CREATE DATABASE OnlineStore

USE OnlineStore CREATE TABLE Categories

(		CategoryID int primary key identity (2310, 1),
		CategoryName nvarchar(30) not null
		)

INSERT INTO Categories VALUES ('Outdoor')
INSERT INTO Categories VALUES ('Jackets')
INSERT INTO Categories VALUES ('Trousers')
INSERT INTO Categories VALUES ('Shirts')
INSERT INTO Categories VALUES ('Skirts')
INSERT INTO Categories VALUES ('Dresses')
INSERT INTO Categories VALUES ('Knitwear')
INSERT INTO Categories VALUES ('Jersey')
INSERT INTO Categories VALUES ('Denim')

SELECT * FROM Categories

USE OnlineStore CREATE TABLE Products

(		ProductID int primary key identity (1000,100),
		ProductName nvarchar(40) unique not null,
		CategoryID int foreign key references Categories(CategoryID),
		UnitsInStock int,
		UnitPrice float,
		Currency char(3) not null default 'PLN' check (currency in ('EUR', 'PLN', 'NOK', 'GBP'))
		)
INSERT INTO Products VALUES ('Charlie', 2310, 20, 1000.00, default)
INSERT INTO Products VALUES ('Andraa', 2317, 600, 80.00, default)
INSERT INTO Products VALUES ('Marry', 2312, 118, 300.00, default)
INSERT INTO Products VALUES ('Susa', 2313, 15, 250.00, default)
INSERT INTO Products VALUES ('Quizo', 2316, 44, 650.00, default)

SELECT * FROM Products

USE OnlineStore CREATE TABLE Region

(		RegionID int primary key identity (40,1),
		RegionName nchar(10) not null
		)

INSERT INTO Region VALUES ('Eastern')
INSERT INTO Region VALUES ('Western')
INSERT INTO Region VALUES ('Northern')
INSERT INTO Region VALUES ('Southern')

SELECT * FROM Region	

USE OnlineStore CREATE TABLE Employees

(		EmployeeID int primary key identity (10,1),
		EmployeeName nvarchar(20) not null,
		RegionID int foreign key references Region(RegionID),
		Sex char(1) check (Sex IN ('m', 'f'))
		)

INSERT INTO Employees VALUES ('Ola',40,'f')
INSERT INTO Employees VALUES ('Kasia',41,'f')
INSERT INTO Employees VALUES ('Piotr',42,'m')
INSERT INTO Employees VALUES ('Artur',43,'m')

SELECT * FROM Employees

USE OnlineStore CREATE TABLE Customers

(		CustomerID int primary key identity (1,1),
		CustomerName nvarchar(40) not null,
		CustomerLastName nvarchar(40) not null,
		CustomerCity nvarchar(30),
		RegionID int foreign key references Region(RegionID),
		EmployeeID int foreign key references Employees(EmployeeID),
		CustomerCountry nvarchar(30) default 'Polska',
		CustomerPhone char(11) check (CustomerPhone LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]')
		)
		
INSERT INTO Customers VALUES ('Zofia', 'Pola�ska', 'Katowice', 43, 13, default, '506-625-677')
INSERT INTO Customers VALUES ('Jan', 'Kowalski', 'Gda�sk', 42, 12, default, '808-123-555')
INSERT INTO Customers VALUES ('Anna', 'Zi�ba', 'Wroc�aw', 41, 11, default, '604-111-600')
INSERT INTO Customers VALUES ('Waleria', 'Konieczny', 'Warszawa', 40, 10, default, '604-111-600')

SELECT * FROM Customers

USE OnlineStore CREATE TABLE Orders

(		OrderID int primary key identity (500, 1),
		CustomerID int foreign key references Customers(CustomerID),
		OrderDate date not null,
		ShipName nvarchar(3) check (ShipName IN ('DHL', 'DPD', 'TNT')),
		ProductID int foreign key references Products(ProductID),
		Quantity int,
		EmployeeID int foreign key references Employees(EmployeeID)
		)

INSERT INTO Orders VALUES (1, '2022-12-06', 'DHL', 1000, 2, 13)
INSERT INTO Orders VALUES (2, '2022-12-07', 'DPD', 1200, 1, 12)
INSERT INTO Orders VALUES (3, '2022-12-08', 'DPD', 1100, 1, 11)
INSERT INTO Orders VALUES (4, '2022-12-10', 'TNT', 1400, 3, 10)
INSERT INTO Orders VALUES (1, '2022-12-11', 'DHL', 1300, 2, 13)

SELECT * FROM Orders

--Wy�wietl nazw� klienta oraz liczb� jego zam�wie�.

SELECT CustomerName, COUNT(*) AS 'Liczba zam�wie�'
FROM Customers c
	INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY CustomerName
ORDER BY 2 DESC

--Wy�wietl ID klienta oraz nazw� produktu z zam�wie� realizowanych przez Ol�

SELECT o.CustomerID, p.ProductName,  e.EmployeeName
FROM Orders o
	INNER JOIN Products p ON o.ProductID = p.ProductID
	INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE EmployeeName LIKE 'Ola'

--Wy�wietl wszystkich klient�w oraz dat� sk�adanych zam�wie�

SELECT c.CustomerName, o.OrderDate
FROM Customers c 
	LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY 2