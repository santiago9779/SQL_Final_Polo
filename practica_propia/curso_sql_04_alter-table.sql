drop database if exists curso_sql;
create database if not exists curso_sql;
use curso_sql;

#Modificando nuestras tablas (Alter Table)

#alter table add

drop table productos;

create table productos1(
id int unsigned not null,
nombre varchar(50)
);

describe productos1;
show create table productos1;

#Agregando un campo ADD
alter table productos1 add precio int;
alter table productos1 add cantidad smallint unsigned not null;

#Eliminando un campo DROP
alter table productos1 drop precio;
alter table productos1 drop precio, drop cantidad;

#Modificar campos de las tablas MODIFY
alter table productos1 modify nombre varchar(100) not null;
alter table productos1 modify precio decimal(4,2) not null;

#Cambiar el nombre de un campo CHANGE
alter table productos1 change cantidad stock int;
alter table productos1 change nombre titulo varchar(50); -- el not null tambien lo podria haber puesto aqui

alter table productos1 modify titulo varchar(50) not null;

#Agregando y eliminando clave Primaria ADD-DROP
alter table productos1 add primary key(id);
alter table productos1 add primary key(nombre);
alter table productos1 modify id int unsigned auto_increment not null;

alter table productos1 drop primary key; -- para borrar el PK siempre le debemos quitar el autoincremental
alter table productos1 modify id int unsigned;
alter table productos1 drop primary key; -- ahora si

describe productos1;

#Agregar Indices ADD-DROP-INDEX
alter table productos add index i_preciocantida (precio,cantida);
alter table productos drop index i_precicantidad;

#Renombrar una tabla RENAME-TO

show tables;

alter table productos rename cliente; 
rename table cliente to productos;

    -- para tablas en las que queremos intercambiar sus nombres entre ellas
rename table productos to auxiliar,
clientes to productos,
auxiliar to clientes;












