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

-- CREAMOS SCHEMA DE PRODUCCION
CREATE SCHEMA prod; 

-- CREAMOS LA TABLA DE CLIENTES
CREATE TABLE prod.DimClientes(
[ID Cliente] INT PRIMARY KEY,
[Nombre] VARCHAR(255) NOT NULL,
[Pais Cliente] VARCHAR(255) NOT NULL); 

-- INGESTA DE CLIENTES EN LA TABLA DIM.CLIENTES
INSERT INTO prod.DimClientes
SELECT DISTINCT	[ID Cliente],
				[Cliente],
				[Pais Cliente] 
FROM stg.Ventas

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

-- CREACION DE TABLA PRODUCTOS
CREATE TABLE prod.DimProductos(
[ID Producto] INT PRIMARY KEY,
[Producto] TEXT NOT NULL,
[Marca] INT); 

-- GENERAMOS UN CAMPO NUEVO
ALTER TABLE prod.DimProductos
ADD [Stock] INT;  

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
GROUP BY T1.[ID Producto], T1.Producto, T2.[ID Marca]

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

-- INGESTAMOS LA TABLA DE DIMVENDEDORES.

INSERT INTO prod.DimVendedores 
SELECT DISTINCT	T1.[ID Vendedor], 
				CONCAT(T1.[Nombre Vendedor],' ',T1.[Apellido Vendedor]) AS Nombre, 
				TRY_CONVERT(date, T1.[Fecha Nacimiento]) AS [Fecha de Venta], 
				T2.[ID Region] 
FROM stg.Ventas AS T1 
LEFT JOIN prod.DimMercados AS T2 
	ON T1.Mercados = T2.Nombre

SELECT * FROM prod.DimVendedores;

-- IMPACTAR EN LA TABLA DE VENDEDORES > FECHA DE NACIMIENTO VALORES TIPO DATE
-- DESDE STG.VENTAS CAMPO FECHA DE NACIMIENTO. 


SELECT DISTINCT	T1.[ID Vendedor], 
				CONCAT(T1.[Nombre Vendedor],' ',T1.[Apellido Vendedor]) AS Nombre, 
				TRY_CONVERT(date, T1.[Fecha Nacimiento]) AS [Fecha de Venta], 
				T2.[ID Region] 
FROM stg.Ventas AS T1 
LEFT JOIN prod.DimMercados AS T2 
	ON T1.Mercados = T2.Nombre; 

-- GENERAMOS LA RELACION ENTRE VENDEDORES Y MERCADOS
ALTER TABLE prod.DimVendedores
ADD CONSTRAINT FK_Vendedores_Mercados
FOREIGN KEY([Mercados]) REFERENCES prod.DimMercados([ID Region])
ON DELETE SET NULL ON UPDATE SET NULL; 

ALTER TABLE prod.DimVendedores
DROP CONSTRAINT FK_Vendedores_Mercados; 

-- CREACION DE TABLA DE FACTURAS
CREATE TABLE prod.FactInvoice(
[ID Factura] INT PRIMARY KEY,
[Fecha de Venta] DATE NOT NULL,
[ID Vendedor] INT,
[ID Cliente] INT,
[ID Region] INT); 

-- INSERCION DE DATOS EN TABLA DE FACTURAS

INSERT INTO prod.FactInvoice 
SELECT DISTINCT T1.[ID Factura], 
                TRY_CONVERT(date, T1.[Fecha de Venta]) AS [Fecha de Venta], 
                T1.[ID Vendedor], 
                T1.[ID Cliente], 
                T2.[ID Region] 
FROM stg.Ventas AS T1 
LEFT JOIN prod.DimMercados AS T2 
    ON T1.Mercados = T2.Nombre; 

SELECT * FROM prod.FactInvoice;

-- GENERAR RELACIONES ENTRE INVOICE Y VENDEDORES
ALTER TABLE prod.FactInvoice
ADD CONSTRAINT FK_Invoice_Vendedores
FOREIGN KEY ([ID Vendedor]) REFERENCES prod.DimVendedores([ID Vendedor])
ON DELETE SET NULL ON UPDATE SET NULL; 


-- GENERAR RELACIONES ENTRE INVOICE Y CLIENTES
ALTER TABLE prod.FactInvoice
ADD CONSTRAINT FK_Invoice_Clientes
FOREIGN KEY([ID Cliente]) REFERENCES prod.DimClientes([ID Cliente])
ON DELETE NO ACTION ON UPDATE NO ACTION; 

-- GENERAR RELACIONES ENTRE INVOICE Y MERCADOS
ALTER TABLE prod.FactInvoice
ADD CONSTRAINT FK_Invoice_Mercados
FOREIGN KEY([ID Region]) REFERENCES prod.DimMercados([ID Region])
ON DELETE NO ACTION ON UPDATE NO ACTION; 

-- CREACION DE TABLA DE TRANSACCIONES
CREATE TABLE prod.FactTransacciones(
[ID Transaccion] INT PRIMARY KEY,
[Fecha de Recepcion] DATE NOT NULL,
[ID Factura] INT,
[ID Producto] INT,
[Cantidad] INT NOT NULL,
[Precio Unitario] DECIMAL(9,2) NOT NULL,
[Costo Unitario] DECIMAL(9,2) NOT NULL); 

INSERT INTO prod.FactTransacciones 
SELECT	[ID Transaccion], 
		TRY_CONVERT(date, [Fecha de Recepcion]) AS [Fecha de Recepcion], 
		[ID Factura], 
		[ID Producto], 
		[Cantidad], 
		CONVERT(DECIMAL(9,2),REPLACE([Venta],',','.')) AS [Precio Unitario], 
		CONVERT(DECIMAL(9,2),REPLACE([Costo],',','.')) AS [Costo Unitario] 
FROM stg.Ventas; 

SELECT * FROM prod.FactTransacciones;


--			GENERAR RELACIONES ENTRE TRANSACCIONES Y PRODUCTOS
ALTER TABLE prod.FactTransacciones
ADD CONSTRAINT FK_Transacciones_Productos
FOREIGN KEY([ID Producto]) REFERENCES prod.DimProductos([ID Producto])
ON DELETE SET NULL ON UPDATE SET NULL; 

--			GENERAR RELACIONES ENTRE TRANSACCIONES Y FACTURAS
ALTER TABLE prod.FactTransacciones
ADD CONSTRAINT FK_Transacciones_Invoice
FOREIGN KEY([ID Factura]) REFERENCES prod.FactInvoice([ID Factura])
ON DELETE SET NULL ON UPDATE SET NULL; 


-- CREAR TABLA LOG

CREATE TABLE LOG (
    ID_Transaccion INT PRIMARY KEY,
    Usuario VARCHAR(255),
    Fecha DATETIME,
    ID_Factura INT FOREIGN KEY REFERENCES prod.FactInvoice([ID Factura])
);

-- TRIGGER

CREATE TRIGGER trg_InsertTransaction
ON prod.FactTransacciones
AFTER INSERT
AS
BEGIN
    --1) Insertar registro de control en la tabla LOG
    INSERT INTO LOG (ID_Transaccion, Usuario, Fecha, ID_Factura)
    SELECT [ID Transaccion], SUSER_SNAME(), GETDATE(), [ID Factura]
    FROM inserted;

    --2) Actualizar el campo Stock en la tabla DimProductos
    UPDATE prod.DimProductos
    SET [Stock] = [Stock] - i.[Cantidad]
    FROM prod.DimProductos p
    INNER JOIN inserted i ON p.[ID Producto] = i.[ID Producto];
END;

-- CASO DE PRUEBA

INSERT INTO prod.FactTransacciones ([ID Transaccion], [Fecha de Recepcion],
[ID Factura], [ID Producto], [Cantidad], [Precio Unitario], [Costo Unitario]) 
VALUES (34488, '2016-03-12', 12548, 214, 1, 8.99, 6.75); 

--VERIFICACION 
select * from LOG;


-- PARA PROCEDIMIENTOSSS

--1) PROC. ALMACENADO PARA : reportar todas las transacciones de una determinada sucursal/region:

CREATE PROCEDURE sp_ReporteTransaccionesPorRegion
    @Region VARCHAR(255)
AS
BEGIN
    SELECT ft.[ID Transaccion], ft.[Fecha de Recepcion], ft.[ID Factura],
	ft.[ID Producto], ft.[Cantidad], ft.[Precio Unitario], ft.[Costo Unitario]
    FROM prod.FactTransacciones AS ft
    INNER JOIN prod.FactInvoice AS fi 
	ON ft.[ID Factura] = fi.[ID Factura]
    INNER JOIN prod.DimMercados AS dm 
	ON fi.[ID Region] = dm.[ID Region]
    WHERE dm.[Nombre] = @Region;
END;

--2) PROC. ALM PARA : reportar el vendedor con mayor rentabilidad de la region.
-- Encontrar el Nombre del Vendedor y La Rentabilidad)

CREATE PROCEDURE sp_ReporteVendedorRentabilidad
    @Region VARCHAR(255)
AS
BEGIN
    SELECT TOP 1 dv.[Vendedor], SUM(ft.[Precio Unitario] - ft.[Costo Unitario]) AS Rentabilidad
    FROM prod.FactTransacciones AS ft
    INNER JOIN prod.FactInvoice AS fi 
	ON ft.[ID Factura] = fi.[ID Factura]
    INNER JOIN prod.DimVendedores AS dv 
	ON fi.[ID Vendedor] = dv.[ID Vendedor]
    INNER JOIN prod.DimMercados AS dm 
	ON fi.[ID Region] = dm.[ID Region]
    WHERE dm.[Nombre] = @Region
    GROUP BY dv.[Vendedor]
    ORDER BY Rentabilidad DESC;
END;

SELECT * FROM prod.DimMercados;

-- CASOS DE PRUEBA

EXEC sp_ReporteTransaccionesPorRegion 'Brazil';
EXEC sp_ReporteVendedorRentabilidad 'Brazil';

