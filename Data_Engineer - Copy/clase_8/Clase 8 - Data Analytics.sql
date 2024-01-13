USE AdventureWorks2019;

-- 1 UTILIZANDO LA TABLA SALES.SALESTERRITORY 
-- RETORNAR AQUELLOS REGISTROS QUE TIENEN COMO COUNTRYREGIONCODE US

SELECT * FROM Sales.SalesTerritory
WHERE [Group] LIKE '%America' AND [Name] = 'Canada'; 

-- 2 UTILIZANDO LA TABLA HUMANRESOURCES.EMPLOYEE
-- RETORNAR EMPLEADOS CON GENERO FEMENINO Y ESTADO MARITAL CASADOS.

SELECT * FROM HumanResources.Employee
WHERE Gender = 'F' AND (MaritalStatus = 'M' OR JobTitle LIKE '%Marketing%');

-- 3 UTILIZANDO LA TABLA PRODUCTION.PRODUCT
-- RETORNAR AQUELLOS PRODUCTOS DONDE SU NOMBRE CONTIENE LA PALABRA MOUNTAIN

SELECT * FROM Production.Product
WHERE [Name] LIKE '%Mountain%'; 

-- 4 UTILIZANDO LA TABLA PERSON.PERSON
-- RETORNAR AQUELLOS NOMBRES (firstname) QUE CONTENGAN LA LETRA 'S' EXCEPTUANDO QUE SEA EL PRIMER CARACTER.

SELECT * FROM person.person
WHERE FirstName LIKE '_S%'

-- 5 UTILIZANDO LA TABLA PERSON.PERSON
-- RETORNAR NOMBRE Y APELLIDO DE LOS EMPLEADOS Y RENOMBRAR LOS CAMPOS AL ESPAÑOL
-- RETORNAR SOLO AQUELLOS EMPLEADOS QUE CONTENGAN APELLIDOS COMO LOPEZ O ADAMS

SELECT FirstName AS [Nombre], LastName AS [Apellido] 
FROM person.person
WHERE LastName LIKE '%Adams%' OR LastName LIKE '%Lopez%'; 

-- 5.A UTILIZANDO LA TABLA PERSON.PERSON
-- RETORNAR IDPERSON, NOMBRE Y APELLIDO DE LOS EMPLEADOS 
-- RETORNAR SOLO AQUELLOS EMPLEADOS QUE SU NOMBRE SEA JORDAN Y SU APELLIDO SEA ADAMS

SELECT DISTINCT FirstName AS [Nombre], LastName AS [Apellido]
FROM person.person
WHERE FirstName LIKE 'Jordan' AND LastName LIKE 'Adams'; 

-- 6 UTILIZANDO LA TABLA PRODUCTION.PRODUCT
-- RETORNAR AQUELLOS PRODUCTOS DONDE EL PRECIO DE LISTA NO SEA 0.00 Y SU NOMBRE CONTENGA LA PALABRA Mountain
-- RETORNAR EL ID_PRODUCT, NOMBRE, NUMERO DE PRODUCTO Y PRECIO LISTA
-- ORDENAR POR PRECIO LISTA

SELECT ProductID, [Name], ProductNumber, ListPrice  
FROM production.product
WHERE ListPrice <> 0.00 AND [Name] LIKE '%Mountain%'
ORDER BY ListPrice DESC, ProductID DESC

-- 7 RETORNAR TODO EL LISTADO DE PRODUCTION.PRODUCT
-- SOLO TRAER LA COLUMNA COLOR DE ESTA TABLA
-- Y NO CONSIDERAR LOS VALORES NULOS
-- SACAR COLORES DUPLICADOS EN EL RESULTADO

SELECT DISTINCT Color FROM Production.Product
WHERE Color IS NOT NULL; 
 
-- 8 RETORNAR TODO EL LISTADO DE SALES.SALESORDERHEADER -- VENTAS
-- FILTRAR CON FECHA DE OPERACION ENTRE EL INTERVALO DE TIEMPO DE '2011-05-31' AND '2011-07-01';

SELECT * FROM sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2011-05-31' AND '2011-07-01'; 

SELECT * FROM sales.SalesOrderHeader
WHERE OrderDate >= '2011-05-31' AND OrderDate <= '2011-07-01'; 

-- MATERIA D PPT -- DESAFIO CONSULTAS BASICAS -- ADVENTUREWORKS-DW-2019

-- 1. LISTAR TODAS LAS VENTAS DE INTERNET (FactInternetSales) CUYA ORDER FUE REALIZADA EN ENERO 2011

SELECT * FROM FactInternetSales
WHERE OrderDate BETWEEN '2011-01-01' AND '2011-01-31';
 
-- 2. LISTAR TODAS LAS VENTAS DE INTERNET CUYO PRECIO UNITARIO SEA MAYOR A 3500

SELECT * FROM FactInternetSales
WHERE UnitPrice >= 3500.00; 

-- 3. LISTAR NOMBRE Y APELLIDO DE LOS CLIENTES QUE REALIZARON LAS VENTAS LISTADAS EN EL PRIMER PUNTO

SELECT DISTINCT  CustomerKey FROM FactInternetSales
WHERE UnitPrice >= 3500.00; 

-- 4. LISTAR LOS NOMBRES Y APELLIDOS DE LOS CLIENTES QUE NO HAYAN REALIZADO UNA COMPRA EN ENERO 2011

------------------------------------------ CLASE 6 - FX INTEGRADAS ----------------------------------------

-- 1. Concatenar Nombre y Apellido 
-- Renombar el campo Nombre Completo
-- Filtrar por Apellido Smith
-- Tabla: Person.Person

USE AdventureWorks2019; 

SELECT BusinessEntityID, FirstName, LastName, CONCAT(FirstName,' ',MiddleName,' ',LastName) as 'Nombre Completo'
FROM Person.Person
WHERE lastname Like '%Smith%'

-- 2. Utilizar la tabla Person.Address
-- Retornar la direccion ID y Direccion-Line
-- Extraer los ultimos 4 digitos del Codigo Postal
-- Filtrar a partir de los ultimos 4 digitos del CP aquellos que son 7205
-- Order por Id-Address y traer los primeros 40 registros

SELECT TOP 40 AddressID, AddressLine1, TRIM(RIGHT(PostalCode,4)) AS 'CP' 
FROM Person.Address
WHERE TRIM(RIGHT(PostalCode,4)) = '7205'
ORDER BY AddressID DESC; 

-- 3. Utilizar la tabla Person.Person
-- Traer el titulo/JobTitle de cada usuarios
-- Remplazar para NULL sobre este campo por Un Valor Valido

SELECT BusinessEntityID, FirstName, LastName, ISNULL(Title,'Mx.') as 'Title'
FROM Person.Person; 

-- 4. Utilizar la tabla Production.Product
-- Retonar el ProductPhotoID, ThumbnailPhotoFileName
-- Modificar el .GIF de cada elemento por .JPG
-- Renombrar a este nuevo campo Formato de ArchivO

SELECT ProductPhotoID, REPLACE(ThumbnailPhotoFileName,'.GIF','.jpg') as 'Formato de Archivo'
FROM Production.ProductPhoto

------------------------------------------------ FX DE TIEMPO ---------------------------------------------

SELECT	GETDATE() as [Fecha Actual], 
		MONTH(GETDATE()) as [Mes],
		YEAR(GETDATE()) as [Año],
		DAY(GETDATE()) as [Dia],
		DATEPART(HOUR,GETDATE()) as [Hora],
		DATEPART(MINUTE,GETDATE()) as [Minutos],
		DATEPART(SECOND,GETDATE()) as [Segundos]; 

-- 1. Utilizar la tabla HumanResources.Employee
-- Retornar BusinessEntityID, NationalIDNumber, LoginID, BirthDate. 
-- Generar columna calculada que indique el año del BirthDate - Renombrar como Categoria
-- Generar una columna nueva con la edad de cada empleado en base al BirthDate
-- Filtrar aquellos empleados que trabajan en Production y tienen menos de 50 años.

SELECT	BusinessEntityID, 
		NationalIDNumber, 
		LoginID,
		JobTitle,
		BirthDate,
		YEAR(BirthDate) as [Categoria],
		DATEDIFF(Year,BirthDate,GETDATE()) as [Edad]
FROM HumanResources.Employee
WHERE (JobTitle LIKE '%Production%') AND (DATEDIFF(Year,BirthDate,GETDATE()) < 50)

-- 2. Tabla HumanResources.Employee
-- Sobre el campo LOGINID, retornar unicamente el nombre de usuario a partir de la barra oblicua. 

SELECT	BusinessEntityID, 
		NationalIDNumber, 
		LoginID,
		SUBSTRING(LoginID,CHARINDEX('\',LoginID)+1,17) AS [Usuario],
		BirthDate,
		YEAR(BirthDate) as [Categoria],
		DATEDIFF(Year,BirthDate,GETDATE()) as [Edad]
FROM HumanResources.Employee

------------------------------------------------------- FX AGREGACION ------------------------------------

-- 1. Cuantas Filas tiene la tabla Person.Person?

SELECT COUNT(BusinessEntityID) as [NroLegajo]
FROM Person.Person; 

-- 2. Cuantas Ventas genero el negocio?
-- tabla: Sales.SalesOrderDetail

SELECT SUM(OrderQty) as [Ventas] FROM Sales.SalesOrderDetail

-- 3. En base al ejemplo anterior, desglozar por SalesOrderID
-- Utilizar Group By

SELECT SalesOrderID, SUM(OrderQty) as [Ventas] 
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID; 

-- 4. Reconocer la Orden Con la Mayor cantidad de articulos vendidos. 

SELECT SalesOrderID, SUM(OrderQty) as [Ventas] 
FROM Sales.SalesOrderDetail
-- WHERE SalesOrderID = 47400 -- WHERE FILTRAR POR UN CAMPO ORIGINAL DE LA TABLA.
GROUP BY SalesOrderID
HAVING SUM(OrderQty) >= 400
ORDER BY Ventas DESC

-- 5.Retornar la Facturacion Total del negocio?
-- AGRUPADA POR TERRITORIO.

SELECT TerritoryID, SUM(TotalDue) as [Ingresos] 
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID; 

-- 7. UTILIZAR TABLA SALES.SALESORDERHEADER
-- TRABAJAR SOBRE LAS COLUMNAS SALESPERSONID (VENDEDORES) Y TOTALDUE (IMPORTE BRUTO DE VENTA)
-- NO CONSIDERAR EN LA TABLA DE RESULTADO AQUELLAS VENTAS QUE NO TIENE VENDEDOR ASIGNADO (NULL)
-- APLICAR UNA FUNCION DE AGREGACION SOBRE EL TOTALDUE Y AGRUPAR POR SALESPERSONID.. 
-- OBTENIENDO LA RENTABILIDAD GENERRADA POR CADA VENDEDOR
-- ORDERNAR POR MONTO DESCENDENTE.
-- QUEDARME CON AQUELLOS VENDEDORES QUE GENERARON MAS DE 10.000.000,00

SELECT	SalesPersonID, 
		ROUND(SUM(TotalDue),2) as [Ingresos]
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL -- FILTRA LA TABLA ORIGINAL
GROUP BY SalesPersonID
HAVING ROUND(SUM(TotalDue),2) >= 10000000.00
ORDER BY Ingresos DESC;

-- 2 RECONOCER LA TRANSACCION CON LA MAYOR CANTIDAD DE ARTICULOS ASOCIADOS Y LA MENOR.

SELECT MAX(OrderQty) as [MaxQuantity], MIN(OrderQty) as [MinQuantity] 
FROM Sales.SalesOrderDetail

-------------------------------------------- FX CONVERSION -------------------------------------------------

SELECT CAST(GETDATE() AS DATE) AS [FechaActual] 
SELECT CONVERT(DATE, GETDATE()) AS [FechaActual]  
SELECT CAST(OrderDate AS DATE) AS [FechaOrden] FROM Sales.SalesOrderHeader;
SELECT CONVERT(DATE, OrderDate) AS [FechaOrden] FROM Sales.SalesOrderHeader;

-------- CONVERSION DE VALORES NUMERICOS.

-- 5.Retornar la Facturacion Total del negocio?
-- AGRUPADA POR TERRITORIO.
SELECT TerritoryID, ROUND(SUM(TotalDue),2) as [Ingresos] 
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID; 
---------------- CAST
SELECT TerritoryID, CAST(SUM(TotalDue) AS DECIMAL(10,2)) as [Ingresos] 
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID; 
---------------- CONVERT
SELECT TerritoryID, CONVERT(INT, SUM(TotalDue)) as [Ingresos] 
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID; 

-------------------------------------------- FX CONVERSION -------------------------------------------------

-- 1. RETORNAR LA FACTURACION DEL NEGOCIO
-- SEGMENTARLA POR TERRITORIO
-- ESPECIFICAMENTE CANADA. 

SELECT TerritoryID, ROUND(SUM(TotalDue),2) AS [Facturacion] 
FROM Sales.SalesOrderHeader
WHERE TerritoryID = (	SELECT [TerritoryID] FROM Sales.SalesTerritory
						WHERE [Name] LIKE '%Canada%')
GROUP BY TerritoryID

-- 2. RETORNAR EL NOMBRE Y APELLIDO DE AQUELLOS EMPLEADOS ACTUALES.
-- EMPLEADOS ACTUALES = HUMANRESOURCES.EMPLOYEE
-- NOMBRE Y APELLIDO EN EMPLEADOS HISTORICOS = PERSON.PERSON

SELECT * FROM Person.Person; -- EMPLEADOS HISTORICOS
SELECT * FROM HumanResources.Employee; -- EMPLEADOS ACTUALES

SELECT BusinessEntityId, FirstName, LastName 
FROM Person.Person
WHERE BusinessEntityID IN (SELECT DISTINCT BusinessEntityID FROM HumanResources.Employee)

-- 3. RETORNAR DE LA TABLA DE PRODUCTOS NOMBRE Y PRODUCTNUMBER
-- FILTRAR MEDIANTE SUBCONSULTA CON UN CONJUNTO DE VALORES
-- AQUELLOS PRODUCTOS QUE TIENEN MAS DE 1000 ARTICULOS EN STOCK.

SELECT ProductID, ProductNumber, [Name], ListPrice 
FROM Production.Product -- TABLA DE PRODUCTOS
WHERE ProductID IN (	SELECT ProductID
						FROM Production.ProductInventory
						GROUP BY ProductID
						HAVING SUM(Quantity) >= 1000); 

------------------------------------------- JOINS ---------------------------------------------------------

USE Master; 

CREATE DATABASE TestJoin; 
USE TestJoin; 

CREATE TABLE Departamentos(
ID int,
Nombre NVARCHAR(255)); 

CREATE TABLE Empleados(
Nombre NVARCHAR(255),
DepartamentoID INT); 

INSERT INTO Departamentos VALUES(31, 'Sales');
INSERT INTO Departamentos VALUES(33, 'Engineering');
INSERT INTO Departamentos VALUES(34, 'Clerical');
INSERT INTO Departamentos VALUES(35, 'Marketing');

INSERT INTO Empleados VALUES('Rafferty', 31);
INSERT INTO Empleados VALUES('Jones', 33);
INSERT INTO Empleados VALUES('Heisenberg', 33);
INSERT INTO Empleados VALUES('Robinson', 34);
INSERT INTO Empleados VALUES('Smith', 34);
INSERT INTO Empleados VALUES('Williams', NULL);

SELECT * FROM Empleados; 
SELECT * FROM Departamentos; 

SELECT * FROM Empleados AS [T1]
INNER JOIN Departamentos AS [T2] 
	ON [T1].[DepartamentoID] = [T2].[ID]; 

----------------------------- LEFT JOIN -----------------------------

SELECT * FROM Empleados AS [T1]
LEFT JOIN Departamentos AS [T2]
	ON T1.DepartamentoID = T2.ID;

----------------------------- RIGHT JOIN -----------------------------

SELECT * FROM Empleados AS [T1]
RIGHT JOIN Departamentos AS [T2]
	ON T1.DepartamentoID = T2.ID

----------------------------- FULL JOIN -----------------------------

SELECT * FROM Empleados AS [T1]
FULL JOIN Departamentos AS [T2]
	ON T1.DepartamentoID = T2.ID

--------------------------------------------------------------------------

USE AdventureWorks2019; 

-- 1. Retornar en la tabla de Empleados Actuales 
-- El nombre y apellido a partir de la relacion de BusinessEntityID
-- Existente entre Person.Person y HumanResources.Employee. 

SELECT * FROM person.person
SELECT * FROM HumanResources.Employee; 

SELECT T1.BusinessEntityID, T1.LoginID,T1.NationalIDNumber, T2.FirstName, T2.LastName 
FROM HumanResources.Employee AS [T1]
LEFT JOIN Person.Person AS [T2]
	ON T1.BusinessEntityID = T2.BusinessEntityID; 

-- 2. Hacer un join entre Production.Product y Production.ProductInventory 
-- sólo cuando los productos aparecen en ambas tablas. 
-- Retonar el Nombre del Producto, Cantidad en Stock del Producto, RowGuid y PrecioLista

SELECT T1.[Name], T1.Color, SUM(T2.Quantity) AS [Articulos en Stock], SUM(T1.ListPrice) AS [Monto Total] 
FROM Production.Product AS [T1]
INNER JOIN Production.ProductInventory AS [T2]
	ON T1.ProductID = T2.ProductID
WHERE T1.Color IS NOT NULL
GROUP BY T1.Name, T1.Color
HAVING SUM(T1.ListPrice) <> 0.00; 

 -- 3. LA CANTIDAD DE ORDENES QUE TIENE CADA CRC JUNTO CON SU RENTABILIDAD. 
-- JOINEAR SALES.SALESORDERHEADER CON SALES.SALESTERRITORY

SELECT	T2.[Name], 
		COUNT(T1.SalesOrderID) AS [Ordenes],
		ROUND(SUM(T1.TotalDue),2) AS [Facturacion]
FROM Sales.SalesOrderHeader AS [T1]
LEFT JOIN Sales.SalesTerritory AS [T2]
	ON T1.TerritoryID = T2.TerritoryID
GROUP BY T2.[Name]; 

-- 4. UTILIZANDO LA TABLA SALES.SALESPERSON DE VENDEDORES
-- RETORNAR EL NOMBRE Y APELLIDO DE CADA VENDEDOR -- 
-- AGREGAR EL PAIS DE DONDE ES CADA VENDEDOR
-- NO CONSIDERAR AQUELLOS VENDEDORES QUE NO TIENEN TERRITORY ID ASIGNADO (INTERNET)

SELECT	T1.BusinessEntityID, 
		ROUND((T1.SalesYTD),2) AS [Facturacion Anual], 
		T2.FirstName, 
		T2.LastName, 
		T1.TerritoryID, 
		CASE
			WHEN T3.[CountryRegionCode] LIKE 'US' THEN 'Estados Unidos'
			WHEN T3.[CountryRegionCode] LIKE 'CA' THEN 'Canada'
			WHEN T3.[CountryRegionCode] LIKE 'AU' THEN 'Australia'
			WHEN T3.[CountryRegionCode] LIKE 'FR' THEN 'Francia'
			WHEN T3.[CountryRegionCode] LIKE 'GB' THEN 'Gran Bretaña'
			ELSE 'Alemania' 
		END AS Pais
FROM Sales.SalesPerson AS [T1]
LEFT JOIN Person.Person AS [T2]
	ON T1.BusinessEntityID = T2.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS [T3]
	ON T1.TerritoryID = T3.TerritoryID
WHERE T1.TerritoryID IS NOT NULL 

---------------------------------------------- UNION VS UNION ALL -------------------------------------------

-- TRAER EN UNA UNICA TABLA DE RESULTADOS 
-- LAS ORDENES CON MAYOR Y MENOR CANTIDAD DE PRODUCTOS ASOCIADOS.
-- TRABAJAR SOBRE SUBCONSULTAS EN CADA QUERY PARA PARAMETRIZAR LA CANTIDAD DE ARTICULOS VENDIDOS
-- APLICAR UNA TERCERA COLUMNA INDICANDO MAX O MIN SEGUN CANTIDAD DE ORDENES. 

-- SELECT TOP 1 SUM(OrderQty) as [Cantidad Articulos Vendidos] 
-- FROM Sales.SalesOrderDetail
	-- WHERE SalesOrderID = 43659
-- GROUP BY SalesOrderID
-- ORDER BY [Cantidad Articulos Vendidos] DESC; 

SELECT SalesOrderID, SUM(OrderQty) as [Cantidad Articulos Vendidos], 'Maximo' AS [Cantidad]
FROM Sales.SalesorderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) =	(SELECT TOP 1 SUM(OrderQty) as [Cantidad Articulos Vendidos] 
							FROM Sales.SalesOrderDetail
							-- WHERE SalesOrderID = 43659
							GROUP BY SalesOrderID
							ORDER BY [Cantidad Articulos Vendidos] DESC)

UNION 

SELECT SalesOrderID, SUM(OrderQty) as [Cantidad Articulos Vendidos], 'Minimo' AS [Cantidad]
FROM Sales.SalesorderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) =	(SELECT TOP 1 SUM(OrderQty) as [Cantidad Articulos Vendidos] 
							FROM Sales.SalesOrderDetail
							-- WHERE SalesOrderID = 43659
							GROUP BY SalesOrderID
							ORDER BY [Cantidad Articulos Vendidos] ASC);


-- 1 EN DOS QUERIES DISTINTAS RETORNAR LOS PRODUCTOS CON SUBCATEGORY WHEELS Y ROAD BIKES
-- ANEXARLOS

SELECT	-- T1.ProductID, 
		-- T1.[Name], 
		T2.[Name] AS [SubCategoria]
FROM Production.Product AS [T1]
LEFT JOIN Production.ProductSubcategory AS [T2]
	ON T1.ProductSubcategoryID = T2.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS [T3]
	ON T2.ProductCategoryID = T3.ProductCategoryID
WHERE T2.[Name] LIKE 'Wheels'

UNION ALL

SELECT	-- T1.ProductID, 
		-- T1.[Name], 
		T2.[Name] AS [SubCategoria]
FROM Production.Product AS [T1]
LEFT JOIN Production.ProductSubcategory AS [T2]
	ON T1.ProductSubcategoryID = T2.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS [T3]
	ON T2.ProductCategoryID = T3.ProductCategoryID
WHERE T2.[Name] LIKE 'Road Bikes'

-- MEDIR LA CANTIDAD DE ORDENES POR AÑO
-- EN BASE AL AÑO DE OPERACION DE CADA SalesOrderID 
-- GENERAR UNA NUEVA COLUMNA CONDICIONAL
-- PARA LAS ORDENES DE 2011 > PRIMER AÑO DE OPERACION 
-- PARA LAS ORDENES DE 2012 > SEGUNDO AÑO DE OPERACION
-- PARA LAS ORDENES DE 2013 > TERCER AÑO DE OPERACION
-- PARA LAS ORDENES DE 2014 > CUARTO AÑO DE OPERACION. 


SELECT	YEAR(OrderDate) AS [Año], 
		COUNT(SalesOrderID) AS [Cantidad Ordenes],
		CASE
			WHEN YEAR(OrderDate) = 2011 THEN 'Primer Año Operacion'
			WHEN YEAR(OrderDate) = 2012 THEN 'Segundo Año Operacion'
			WHEN YEAR(OrderDate) = 2013 THEN 'Tercer Año Operacion'
			ELSE 'Cuarto Año Operacion' 
		END AS 'Operacion Año'
FROM Sales.SalesOrderHeader 
GROUP BY YEAR(OrderDate)
ORDER BY Año; 

-- 1. GENERAR UNA TABLA RESULTANTE DONDE...
--    SE ENCUENTRA EL TOTAL-DUE TOTAL POR CADA PROVEEDOR(VENDOR). Renombrar [Fact por Vendor]
--    Y EL TOTAL-DUE POR METODO DE PAGO(SHIPMETHODID) EN OTRA COLUMNA. Renombrar [Fact por MetodoPago]
--    ACOMPAÑAR TAMBIEN UN CAMPO QUE CONTABILIZE LA CANTIDAD DE ORDENES POR PROVEEDOR. Renombrar [Ordenes]

SELECT * FROM Purchasing.Vendor; -- Proveedores
SELECT * FROM Purchasing.ShipMethod; -- Metodo de Pago

SELECT	DISTINCT T3.[Name] as [Vendor],
		T2.[Name] as [ShipMethod], 
		SUM(T1.TotalDue) OVER(PARTITION BY T2.[Name]) AS [Fact Metodo Pago],
		SUM(T1.TotalDue) OVER(PARTITION BY T3.[Name]) AS [Fact Proveedor],
		COUNT(T1.PurchaseOrderID) OVER(PARTITION BY T3.[Name]) AS [Ordenes Proveedor]
FROM Purchasing.PurchaseOrderHeader AS [T1]
LEFT JOIN Purchasing.ShipMethod AS [T2]
	ON T1.ShipMethodID = T2.ShipMethodID
LEFT JOIN Purchasing.Vendor AS [T3]
	ON T1.VendorID = T3.BusinessEntityID
-- GROUP BY T1.VendorID, T3.[Name], T2.[Name]
-- ORDER BY VendorID; 

-- EVALUAR LA CANTIDAD DE VENTAS GENERADA POR VENDEDOR
-- COMPARAR CONTRA LA VENTA GENERAL DEL NEGOCIO
-- ORDER QUANTITY

SELECT * FROM Sales.SalesPerson; 

SELECT	DISTINCT T2.SalesPersonID,
		SUM(ROUND(T2.TotalDue,2)) OVER(PARTITION BY T2.SalesPersonID) as [Ganancia por Vendedor],
		SUM(ROUND(T2.TotalDue,2)) OVER () AS [Ganancia General],
		SUM(ROUND(T2.TotalDue,2)) OVER(PARTITION BY T2.SalesPersonID)/SUM(ROUND(T2.TotalDue,2)) OVER ()
FROM Sales.SalesOrderDetail AS [T1]
INNER JOIN Sales.SalesOrderHeader AS [T2]
	ON T1.SalesOrderID = T2.SalesOrderID
INNER JOIN Sales.SalesPerson AS [T3]
	ON T2.SalesPersonID = T3.BusinessEntityID;
-- 
