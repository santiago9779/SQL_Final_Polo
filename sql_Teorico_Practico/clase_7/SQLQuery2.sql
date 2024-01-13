USE AdventureWorks2019; 

SELECT * FROM HumanResources.Employee; 
SELECT * FROM Production.Product; 
SELECT * FROM Sales.SalesTerritory; 

-- UTILIZAR LA TABLA SALES.SALESTERRITORY

SELECT TerritoryID, [Name], CountryRegionCode, [Group] 
FROM Sales.SalesTerritory
WHERE [CountryRegionCode] = 'US' -- PASO EL VALOR EXACTO.

SELECT BusinessEntityID, NationalIDNumber, LoginID, JobTitle
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Manager%' -- ESTIMA EL RESULTADO EN BASE A UN PATRON.

-- UTILIZAR LA TABLA PERSON.PERSON
-- TRAER AQUELLAS PERSONAS QUE EN SU NOMBRE CONTENGAN CON LA LETRA S
-- EXCEPTUANDO QUE SEA EL PRIMER CARACTER
-- ADEMAS, SU APELLIDO COMIENCE CON LA LETRA A

SELECT * FROM Person.Person
WHERE FirstName LIKE '_S%' OR LastName LIKE 'A%';
-- WHERE FirstName LIKE '_S%' AND LastName LIKE 'A%'; -- SE DEBEN CUMPLIR LAS DOS CONDICIONES

-- 4 UTILIZANDO LA TABLA PRODUCTION.PRODUCT
-- RETORNAR AQUELLOS PRODUCTOS DONDE EL PRECIO DE LISTA NO SEA 0.00 
-- Y SU NOMBRE CONTENGA LA PALABRA Mountain
-- RETORNAR EL ID_PRODUCT, NOMBRE, NUMERO DE PRODUCTO Y PRECIO LISTA

SELECT ProductID, [Name], ProductNumber, ListPrice
FROM Production.Product
WHERE ListPrice <> 0.00 AND [Name] LIKE '%mountain%' -- AND Color LIKE 'White'; 
ORDER BY ListPrice, ProductID DESC

-- OPERADORES ARITMETICOS + ALIAS

SELECT ProductID, [Name], ProductNumber, ListPrice, (ListPrice * 1.21) AS [Precio + IVA]
FROM Production.Product
WHERE ListPrice <> 0.00

-- SENTENCIA BETWEEN

SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2011-06-01' AND '2011-06-30'

SELECT ProductID, [Name], ProductNumber, ListPrice, (ListPrice * 1.21) AS [Precio + IVA]
FROM Production.Product
WHERE ListPrice BETWEEN 50 AND 100

-- 4.A UTILIZANDO LA TABLA PERSON.PERSON
-- RETORNAR IDPERSON, NOMBRE Y APELLIDO DE LOS EMPLEADOS 
-- RETORNAR SOLO AQUELLOS EMPLEADOS QUE SU NOMBRE SEA JORDAN Y SU APELLIDO SEA ADAMS

SELECT DISTINCT FirstName, LastName
FROM Person.Person
WHERE FirstName LIKE 'Jordan' AND LastName LIKE '%Adams%'; 

-- 5. RETORNAR TODO EL LISTADO DE PRODUCTION.PRODUCT
-- NECESITAMOS SABER CON QUE GAMA DE COLORES TRABAJA LA EMPRESA EN SUS RESPECTIVOS PRODUCTOS.
-- NECESITAMOS UNA LISTA UNICAMENTE CON LA GAMA DE COLORES QUE TRABAJAMOS.

SELECT DISTINCT Color
FROM Production.Product
WHERE Color IS NOT NULL; 

SELECT DISTINCT [GROUP] 
FROM Sales.SalesTerritory

-- SENTENCIAS TOP X

SELECT TOP 1 ProductID, [Name], ProductNumber, ListPrice
FROM Production.Product
WHERE ListPrice <> 0.00 AND [Name] LIKE '%mountain%' -- AND Color LIKE 'White'; 
ORDER BY ListPrice, ProductID DESC

--------------------------------------- CLASE NRO 7 FUNCIONES NATIVAS ---------------------------------------

-- CANTIDAD DE FILAS EN LA TABLA PERSON.PERSON
SELECT COUNT(BusinessEntityID) AS [Cantidad de Empleados Historicos]
FROM Person.Person; 

-- DE LA TABLA PERSON.PERSON
-- CONCATENAR NOMBRE Y APELLIDO Y RENOMBAR EL CAMPO COMO NOMBRE COMPLETO
-- FILTRAR AQUELLAS PERSONAS CON APELLIDO ACKERMAN

SELECT	BusinessEntityID,
		UPPER(CONCAT(FirstName,' ',LastName)) AS [Nombre]
FROM Person.Person
WHERE LastName LIKE '%Ackerman%'

-- 4. UTILIZAR LA TABLA PERSON.ADDRESS
-- RETORNAR DIRECCION-ID Y DRECCIONLINE Y LOS ULTIMOS 4 DIGITOS DEL ZIPCODE.
-- FILTRAR POR POSTALCODE 7205
-- ORDENAR POR ID-ADDRESS Y TRAER LOS PRIMEROS 40 RESULTADOS.

SELECT	AddressID, 
		AddressLine1,
		-- PostalCode,
		TRIM(RIGHT(PostalCode,4)) AS [Codigo Postal]
FROM Person.Address
WHERE TRIM(RIGHT(PostalCode,4)) = '1S2'

-- 5. ************* UTILIZAR LA TABLA PERSON.PERSON
-- Traer el Titulo de Person.Person. Si es NULL devolver ?No Hay Titulo?

SELECT	BusinessEntityID,
		FirstName,
		LastName,
		ISNULL(Title,'No Hay Titulo') AS Titulo -- El valor a ingresar debe respetar la cantidad de caracteres del campo.
FROM Person.Person

SELECT	*,
		ISNULL(Color,'Generico') AS Color
FROM Production.Product; 

-- 6. UTILIZAR LA TABLA PRODUCTION.PRODUCTPHOTO
-- RETORNAR EL PRODUCTPHOTOID, LARGEPHOTOFILENAME
-- REMPLAZAR LA EXTENSION DE .GIF POR .JPEG - LLAMAR A ESTA COLUMNA FORMATO
-- RETORNAR LOS PRIMEROS 10 REGISTROS DEL RESULTADO.

SELECT	ProductPhotoID, 
		ThumbnailPhotoFileName,
		REPLACE(ThumbnailPhotoFileName,'.gif','.jpg') AS [File Name]
FROM Production.ProductPhoto

------------------------- FUNCION TIEMPO -----------------------------
SELECT SYSDATETIME(); 

SELECT	GETDATE() AS [Datetime Actual], 
		MONTH(GETDATE()) AS [Mes Actual],
		DAY(GETDATE()) AS [Dia Actual],
		YEAR(GETDATE()) AS [A?o Actual],
		DATEPART(HOUR,GETDATE()) AS [Hora Actual],
		DATEPART(MINUTE,GETDATE()) AS [Minutos Actuales],
		DATEPART(SECOND,GETDATE()) AS [Segundos Actuales]; 

SELECT DATEFROMPARTS(2010,12,31) AS [Fin de A?o]; 

SELECT	SalesOrderID,
		OrderDate,
		MONTH(OrderDate) AS [Mes de la Factura],
		DATENAME(MONTH,OrderDate) AS [Nombre del Mes],
		DATENAME(DW,OrderDate) AS [Nombre del Dia],
		DATEADD(MONTH,-12,OrderDate) AS [3 MESES ANTES]
FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43659

-- 3. UTILIZAR LA TABLA HUMANRESOURCES.EMPLOYEE
-- RETORNAR BUSINESSENTITYID, NATIONALIDNUMBER, LOGINID, BIRTHDATE
-- GENERAR COLUMNA CALCULADA CON EL A?O PARA EL BIRTHDATE - RENOMBRAR "CATEGORIA" A ESTA COLUMNA
-- GENERAR UNA COLUMNA NUEVA CON LA EDAD DE CADA EMPLEADO EN BASE AL BIRTHDATE (UTILIZAR DATEDIFF + GETDATE())
-- FILTRAR A LAS EMPLEADOS QUE TIENE COMO JOBTITLE LA PALABRA "PRODUCTION" Y TIENEN MENOS DE 50 A?OS.
-- RENOMBRAR LA COLUMNA DEL DATEDIIFF COMO EDAD.

SELECT	BusinessEntityID, 
		NationalIDNumber,
		LoginID,
		JobTitle,
		BirthDate,
		YEAR(BirthDate) AS [Categoria],
		DATEDIFF(YEAR,BirthDate,GETDATE()) AS [Edad]
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Production%' AND DATEDIFF(YEAR,BirthDate,GETDATE()) < 50
ORDER BY [Categoria] DESC

---------------------------- FUNCIONES DE CONVERSION -------------------------------

SELECT	SalesOrderID,
		CONVERT(DATE,OrderDate) AS [Fecha de Orden],
		CONVERT(DATE,DueDate) AS [Fecha de Entrega],
		CAST(OrderDate AS DATE) AS [Fecha de Order 2],
		CAST(DueDate AS DATE) AS [Fecha de Entrega 2],
		CustomerID,
		SalesPersonID
FROM Sales.SalesOrderHeader; 

SELECT CONVERT(DATE,GETDATE()) AS [Fecha Actual]; 

SELECT	SalesOrderID,
		ProductID,
		OrderQty,
		UnitPrice,
		CONVERT(DECIMAL(10,2),(OrderQty * UnitPrice)) AS [Importe Total]
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43659; 

--- 4. TABLA HumanResources.Employee
-- SOBRE EL CAMPO LOGINID QUEDARSE UNICAMENTE CON EL NOMBRE DEL USUARIO (ROMPER LA BARRA ESPACIADORA).
-- RETORNAR EN BASE AL BIRTHDATE LA EDAD DE LOS EMPLEADOS
-- FUNCION: SUBSTRING + CHARINDEX (tener en cuenta concepto de funcion anidada)

-- 5. Sobre la tabla Sales.SalesOrderHeader
-- Calcular para cada Orden de la tabla la cantidad de dias que pasan:
-- Entre la fecha de venta (orderdate) y la fecha de entrega (duedate)