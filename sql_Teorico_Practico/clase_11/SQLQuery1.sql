-- CREAMOS BASE DE DATOS
CREATE DATABASE Tienda; 
-- ACTIVAMOS LA BASE DE DATOS
USE Tienda; 
-- CREAMOS UN SCHEMA
CREATE SCHEMA stg; -- STAGGING AREA
-- CREAMOS TABLA STG.VENTAS
CREATE TABLE stg.Ventas(
[ID Transaccion] VARCHAR(255) NOT NULL,
[ID Factura] VARCHAR(255) NOT NULL,
[Fecha de Venta] VARCHAR(255) NOT NULL,
[Fecha de Recepcion] VARCHAR(255) NOT NULL,
[ID Producto] VARCHAR(255) NOT NULL,
[Producto] VARCHAR(255) NOT NULL,
[Marca] VARCHAR(255) NOT NULL,
[Centro Logistico] VARCHAR(255) NOT NULL,
[Latitud] VARCHAR(255) NOT NULL,
[Longitud] VARCHAR(255) NOT NULL,
[ID Vendedor] VARCHAR(255) NOT NULL,
[Nombre Vendedor] VARCHAR(255) NOT NULL,
[Apellido Vendedor] VARCHAR(255) NOT NULL,
[Fecha Nacimiento] VARCHAR(255) NOT NULL,
[Mercados] VARCHAR(255) NOT NULL,
[ID Cliente] VARCHAR(255) NOT NULL,
[Cliente] VARCHAR(255) NOT NULL,
[Pais Cliente] VARCHAR(255) NOT NULL,
[Cantidad] VARCHAR(255) NOT NULL,
[Venta] VARCHAR(255) NOT NULL,
[Costo] VARCHAR(255) NOT NULL); 

SELECT * FROM stg.ventas;

-- CREAMOS SCHEMA DE PRODUCCION
CREATE SCHEMA prod; 

-- CREAMOS LA TABLA DE CLIENTES
CREATE TABLE prod.DimClientes(
[ID Cliente] INT PRIMARY KEY,
[Nombre] VARCHAR(255) NOT NULL,
[Pais Cliente] VARCHAR(255) NOT NULL);

SELECT * FROM prod.DimClientes;

-- INGESTA DE CLIENTES EN LA TABLA DIM.CLIENTES
INSERT INTO prod.DimClientes
SELECT DISTINCT	[ID Cliente],
				[Cliente],
				[Pais Cliente] 
FROM stg.Ventas;

SELECT * FROM prod.DimClientes;


-- CREACION DE LA TABLA PROVEEDORES
CREATE TABLE prod.DimMarcas(
[ID Marca] INT PRIMARY KEY IDENTITY,
[Nombre] VARCHAR(255) NOT NULL,
[Centro Logistico] VARCHAR(255) NOT NULL,
[Latitud] DECIMAL(9,5) NOT NULL,
[Longitud] DECIMAL(9,5) NOT NULL); 

-- INGESTA DE PROVEEDORES EN TABLA DIM.MARCAS
INSERT INTO prod.DimMarcas
SELECT DISTINCT [Marca],
				[Centro Logistico],
				CONVERT(DECIMAL(9,5),REPLACE([Latitud],',','.')) AS Lat,
				CONVERT(DECIMAL(9,5),REPLACE([Longitud],',','.')) AS Long
FROM stg.Ventas; 

SELECT * FROM prod.DimMarcas;


-- CREACION DE TABLA PRODUCTOS
CREATE TABLE prod.DimProductos(
[ID Producto] INT PRIMARY KEY,
[Producto] TEXT NOT NULL,
[Marca] INT); 
-- GENERAMOS UN CAMPO NUEVO
ALTER TABLE prod.DimProductos
ADD [Stock] INT;  

SELECT * FROM prod.DimProductos;

-- GENERAMOS LA RELACION ENTRE PRODUCTOS Y MARCAS
ALTER TABLE prod.DimProductos
ADD CONSTRAINT FK_Prod_Marcas
FOREIGN KEY([Marca]) REFERENCES prod.DimMarcas([ID Marca])
ON DELETE SET NULL ON UPDATE SET NULL; 

-- 
INSERT INTO prod.DimProductos
SELECT DISTINCT T1.[ID Producto],
				T1.[Producto],
				T2.[ID Marca],
				SUM(CONVERT(INT,T1.[Cantidad])) AS Stock
FROM stg.Ventas AS T1
LEFT JOIN prod.DimMarcas AS T2
	ON T1.Marca = T2.Nombre
GROUP BY T1.[ID Producto], T1.Producto, T2.[ID Marca];

SELECT * FROM prod.DimProductos;


-- CREACION DE TABLA REGIONES/MERCADOS

CREATE TABLE prod.DimMercados(
[ID Region] INT PRIMARY KEY IDENTITY,
[Nombre] VARCHAR(255) NOT NULL); 

-- INGESTA DE TABLA MERCADOS
INSERT INTO prod.DimMercados 
SELECT DISTINCT [Mercados] FROM stg.Ventas; 

-- CREACION DE TABLA VENDEDORES
CREATE TABLE prod.DimVendedores(
[ID Vendedor] INT PRIMARY KEY,
[Vendedor] VARCHAR(255) NOT NULL,
[Fecha Nacimiento] DATE NOT NULL,
[Mercados] INT); 


SELECT DISTINCT		T1.[ID Vendedor],
					CONCAT(T1.[Nombre Vendedor],' ',T1.[Apellido Vendedor]) AS Nombre,
					CONVERT(DATE,T1.[Fecha Nacimiento]) AS Fecha,
					T2.[ID Region]
FROM stg.Ventas AS T1
LEFT JOIN prod.DimMercados AS T2
	ON T1.Mercados = T2.Nombre

-- IMPACTAR EN LA TABLA DE VENDEDORES > FECHA DE NACIMIENTO VALORES TIPO DATE
-- DESDE STG.VENTAS CAMPO FECHA DE NACIMIENTO. 
