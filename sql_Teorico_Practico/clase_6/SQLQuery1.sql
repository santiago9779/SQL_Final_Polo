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