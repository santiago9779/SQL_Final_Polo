drop database if exists curso_sql;
create database if not exists curso_sql;
use curso_sql;

show tables;

drop table productos;

create table productos(
id int unsigned not null auto_increment,
nombre varchar(50) not null,
descripcion text,
proveedorid int unsigned not null,
precio decimal(5,2),
cantidad smallint unsigned default 0,
primary key(id),
unique index (nombre),
foreign key(proveedorid) references proveedor(id)
);





describe productos;

select * from productos;
select * from productos where nombre regexp '^[a]';
select * from productos where left(nombre,1) in ("a"); -- hace lo mismo, recorre por izq al campo nombre y pide que la primera empiece en a
select * from productos where right(nombre,1) in ("o");

drop table if exists proveedor;

create table if not exists proveedor(
id int unsigned not null auto_increment,
nombre varchar(50),
primary key(id),
unique index (nombre)
);

select * from proveedor;

insert into proveedor (nombre) 
values('Lenovo'),
('Logitech'),
('Microsoft'), 
('HP');

insert into productos(nombre, descripcion, proveedorid, precio, cantidad)
values('Lenovo 310', 'La mejor laptop', 1, 100, 50),
('Mouse', 'mouse inalambrico', 2, 15.96, 5),
('Office 360', 'Paquete de Ofice', 3, 150.69, 30),
('HP Y700', 'La mejor laptop del mercado', 4, 10, 15),
('Alfombra Lenovo', 'Alfombras asombrosas', 1, 300, 40),
('laptop HP 1000', 'No funciona muy bien',4 , 500, 3),
('Volante Gamer', 'El mejor volante para jugar', 2, 800, 5),
('Disco duro', 'Obten mas capacidad', 3, 70, 80);

#Estructura del Join basico
select * from productos  -- es para mostrar registros,filas,columnas de varias tablas en una sola
join proveedor
;
select * from productos  -- con el on restringimos la busqueda a donde se cumpla nuestra condicion
join proveedor
on proveedor.id=productos.proveedorid;

#Estructura del Join para saber el nombre del proveedor
select proveedor.nombre, productos.nombre, productos.descripcion, productos.precio -- condicionamos que campos queremos mostrar
from productos 
join proveedor 
on productos.proveedorid=proveedor.id;

select prov.nombre, prod.nombre, prod.descripcion, prod.precio -- hace lo mismo pero con menor notacion
from productos as prod
join proveedor as prov
on prov.id=prod.proveedorid;

#Left Join
select * from proveedor -- toma primero 
left join productos -- pone a la izquierda
on proveedor.id=productos.proveedorid;

#Right join
select * from productos-- toma primero
right join proveedor -- pone a la derecha
on proveedor.id=productos.proveedorid;

#Inner Join
select * from productos-- toma primero
right join proveedor 
on proveedor.id=productos.proveedorid;

select p.nombre, p.descripcion, p.precio, pro.nombre from proveedor as pro -- muestro lo que quiero
inner join productos as p
on pro.id=p.proveedorid;

#Straight join
select * from productos-- toma primero
straight_join proveedor  -- pone a la derecha
on proveedor.id=productos.proveedorid;

select p.nombre, p.descripcion, p.precio, pro.nombre from proveedor as pro
straight_join productos as p
on pro.id=p.proveedorid;

#Funciones de agrupamiento group by

select prov.nombre as Marca, count(prod.proveedorid) as 'Cantidad de Productos'
from proveedor as prov
join productos as prod
on prov.id=prod.proveedorid
group by prov.nombre;

select prov.nombre, max(prod.precio) as 'Mayor Precio'
from proveedor as prov
left join productos as prod
on prod.proveedorid=prov.id
group by prov.nombre;

select p.nombre, descripcion, precio, proveedorid from productos as p
join proveedor as pro
on p.proveedorid=pro.id;

#Trabajando con mas de dos tablas
 
 drop table if exists libros, socios, prestamos;
 show tables;
 
 create table libros(
  codigo int unsigned auto_increment,
  titulo varchar(40) not null,
  autor varchar(20) default 'Desconocido',
  primary key (codigo)
 );

 create table socios(
  documento char(8) not null,
  nombre varchar(30),
  domicilio varchar(30),
  primary key (documento)
 );

 create table prestamos(
  documento char(8) not null,
  codigolibro int unsigned,
  fechaprestamo date not null,
  fechadevolucion date,
  primary key (codigolibro,fechaprestamo)
 );


 insert into socios values
 ('22333444','Juan Perez','Colon 345'),
('23333444','Luis Lopez','Caseros 940'),
('25333444','Ana Herrero','Sucre 120');

 insert into libros 
 values(1,'Manual de 2º grado','Molina Manuel'),
(25,'Aprenda PHP','Oscar Mendez'),
(42,'Martin Fierro','Jose Hernandez');

 insert into prestamos 
 values('22333444',1,'2016-08-10','2016-08-12'),
('22333444',1,'2016-08-15',null),
('25333444',25,'2016-08-10','2016-08-13'),
('25333444',42,'2016-08-10',null),
('25333444',25,'2016-08-15',null),
('30333444',42,'2016-08-02','2016-08-05'),
('25333444',2,'2016-08-02','2016-08-05');
 
 
select * from prestamos  -- Junto todo, forma basica
join proveedor,libros
;
 
 select nombre, titulo, fechaprestamo
 from prestamos as p
 join socios as s
 on s.documento=p.documento
 join libros as l
 on codigolibro=codigo;
 
 select nombre, titulo, fechaprestamo
 from prestamos as p
 left join socios as s
 on p.documento=s.documento
 left join libros as l
 on l.codigo=p.codigolibro;
 
 select nombre, titulo, fechaprestamo
 from prestamos as p
 left join socios as s
 on p.documento=s.documento
 join libros as l
 on p.codigolibro=l.codigo;
 
 #Funcion de control IF y CASE con varias tablas
 select prov.nombre,
 if(count(prod.proveedorid)>0, 'SI', 'NO') as hay
 from proveedor as prov
 left join productos as prod
 on prov.id=prod.proveedorid
 group by prov.nombre;
 
 select pro.nombre,
 case count(p.proveedorid) when 0 then 'NO'
 else 'SI' end as 'Hay'
 from proveedor as pro
 left join productos as p
 on pro.id=p.proveedorid
 group by pro.nombre;
 
 #variables de usuario
 
# @nombrevariable:= 
# int nombrevarible
 #$variable
 
 select @preciomayor:=max(precio) from productos;
 
 select * from productos where precio=@preciomayor;
 
 select  prod.nombre, prod.descripcion, pro.nombre
 from productos as prod
 join proveedor as pro
 on prod.proveedorid=pro.id
 where prod.precio = @preciomayor;
 
 #Crear table a partir de otra(CREATE-INSERT)
 
 drop table productos;
 drop table proveedor;
  drop table proveedores;
 
 create table if not exists productos(
id int unsigned not null auto_increment,
nombre varchar(50) not null,
descripcion text,
proveedor varchar(50),
precio decimal(5,2),
cantidad smallint unsigned default 0,
primary key(id),
unique index (nombre)
);

describe productos;

insert into productos(nombre, descripcion, proveedor, precio, cantidad) 
values('Lenovo 310', 'La mejor laptop', 'Lenovo', 100, 50);
insert into productos(nombre, descripcion, proveedor, precio, cantidad) 
values('Mouse', 'mouse inalambrico', 'Logitech', 15.96, 5);
insert into productos(nombre, descripcion, proveedor, precio, cantidad) 
values('Office 360', 'Paquete de Ofice', 'Microsoft', 150.69, 30);
insert into productos(nombre, descripcion, proveedor, precio, cantidad) 
values('HP Y700', 'La mejor laptop del mercado', 'HP', 10, 15);

# crear table a partir de otra

create table proveedores
select distinct proveedor as nombre
from productos; 
select * from productos;
select * from proveedores;

#Crear una tabla apartir de dos tablas(CREATE-INSERT-JOIN)

drop table productos;
create table if not exists productos(
id int unsigned not null auto_increment,
nombre varchar(50) not null,
descripcion text,
proveedorid int unsigned not null,
precio decimal(5,2),
cantidad smallint unsigned default 0,
primary key(id),
unique index (nombre),
foreign key(proveedorid) references proveedor(id)
);
describe productos;

select * from productos;

drop table if exists proveedor;

create table if not exists proveedor(
id int unsigned not null auto_increment,
nombre varchar(50),
primary key(id),
unique index (nombre)
);

select * from proveedor;

insert into proveedor (nombre) values('Lenovo');
insert into proveedor (nombre) values('Logitech');
insert into proveedor (nombre) values('Microsoft'); 
insert into proveedor (nombre) values('HP');

insert into productos(nombre, descripcion, proveedorid, precio, cantidad) 
values('Lenovo 310', 'La mejor laptop', 1, 100, 50);
insert into productos(nombre, descripcion, proveedorid, precio, cantidad) 
values('Mouse', 'mouse inalambrico', 2, 15.96, 5);
insert into productos(nombre, descripcion, proveedorid, precio, cantidad) 
values('Office 360', 'Paquete de Ofice', 3, 150.69, 30);
insert into productos(nombre, descripcion, proveedorid, precio, cantidad) 
values('HP Y700', 'La mejor laptop del mercado', 4, 10, 15);
insert into productos(nombre, descripcion, proveedorid, precio, cantidad) 
values('Alfombra Lenovo', 'Alfombras asombrosas', 1, 300, 40);
insert into productos(nombre, descripcion, proveedorid, precio, cantidad) 
values('laptop HP 1000', 'No funciona muy bien',4 , 500, 3);
insert into productos(nombre, descripcion, proveedorid, precio, cantidad) 
values('Volante Gamer', 'El mejor volante para jugar', 2, 800, 5);
insert into productos(nombre, descripcion, proveedorid, precio, cantidad) 
values('Disco duro', 'Obten mas capacidad', 3, 70, 80);

create table cantidadporproveedor
select prov.nombre,count(*) as cantidad
from productos as prod
join proveedor as prov
on prod.proveedorid=prod.id
group by prov.nombre;

select * from cantidadporproveedor;


#Insertar datos buscando en valor en otra tabla
select * from productos;

insert into productos(nombre,descripcion, precio, proveedorid, cantidad)
select 'Raton', 'El mejor mouse', 150, id, 50
from proveedor where nombre='Logitech';

select * from productos;

#Actualizar registros con valores de otra tabla(UPDATE)

alter table productos add proveedor varchar(50);

update productos
join proveedor
on productos.proveedorid=proveedor.id
set productos.proveedor=proveedor.nombre;

alter table productos drop proveedorid;
drop table proveedor;

select * from productos;
select * from proveedor;

#Actualizacion en cascada(UPDATE-JOIN)
update productos as prod
join proveedor as prov
on prod.proveedorid=prov.id
set prod.proveedorid=8, prov.id=8
where prov.nombre='Logitech';

#Borrar Registros consultando otras tablas(DELETE-JOIN)
delete productos
from productos
join proveedor
on productos.proveedorid=proveedor.id
where proveedor.nombre = 'HP';

select * from productos;
select * from proveedor;

#Borrar registros en cascada
delete productos, proveedor -- elimina de las tablas productos y proveedoe
from productos
join proveedor
on productos.proveedorid=proveedor.id
where proveedor.nombre='Lenovo'; -- los que contengan a la marca lenovo


#chequear y reparar tablas(CHECK-REPAIR)

check table productos; -- verifica si una tabla tiene o no errores

# quick
# fast
# changed
# medium
# extented

check table productos fast quick;

repair table productos;

#Encriptar valores de nuestra tabla

# aes_encrypt("dato a encriptar", "clave de encriptacion")

drop table if exists clientes;

create table clientes(
  nombre varchar(50),
  mail varchar(70),
  tarjetacredito blob,
  primary key (nombre)
);

insert into clientes 
  values ('Marcos Luis','marcosluis@gmail.com',aes_encrypt('5390700823285988','xyz123'));
insert into clientes 
  values ('Ganzalez Ana','gonzalesa@gmail.com',aes_encrypt('4567230823285445','xyz123'));
insert into clientes 
  values ('Lopez German','lopezg@yahoo.com',aes_encrypt('7840704453285443','xyz123'));
  
  select tarjetacredito from clientes;
  -- la funcion cast convierte un tipo de dato a otro tipo
  select cast(aes_decrypt(tarjetacredito, 'xyz123') as char) from clientes;
  
  