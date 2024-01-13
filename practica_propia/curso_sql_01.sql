#Eliminar la base de datos ya existente.
drop database if exists curso_sql;

#show databases;
select * from usuario;
create database if not exists curso_sql;
use curso_sql;
show create table usuario;

create table if not exists usuario(
nombre varchar(50),
apellido varchar(50),
correo varchar(100),
primary key(nombre)
);
insert into usuario(nombre,apellido,correo) values('Juan','Perez','juan@juan.com');
insert into usuario(nombre,apellido,correo) values('Agus','Lopez','juan@Lopez.com');
describe usuario;


drop table if exists producto;

create table if not exists producto(
id int not null auto_increment,
producto varchar(50) not null,
descripcion text null,
precio float not null,
primary key(id)
);
select * from producto;

describe producto;
insert into producto values(null,'Laptop','La mejor laptop del mercado.',128.6);
insert into producto(id, producto, descripcion, precio) values(null,'','Mejor producto.',78.5);
insert into producto values(null,'Mouse','Prende luz.',5.8);
insert into producto(id, producto, descripcion, precio) values(null,'Laptop','La mejor laptop del mercado.',128.6);
select * from producto;

delete from producto;
truncate table producto;


#unsigned
create table persona(
id integer unsigned not null,
nombre varchar(50),
edad integer unsigned, -- el usigned solo acepta positivos
primary key(id)
);
describe persona;
select * from persona;

#Tipos de datos

#numericos

#enteros
-- TINYINT -127 128 UNSIGNED 
-- SMALLINT 
-- MEDIUMINT 
-- INT O INTEGER
-- BIGINT -- para numeros mallores a 2mil millones 
#decimales
-- FLOAT
-- precio float(6.24) donde longitud =6 decimales =24
-- DOUBLE
-- precio double(4.53)
-- DECIMAL


#cadenas

--  CHAR es para 255 caracteres 
-- nombre char(100) juan aqui quedan 96 caracteres disponibles

-- VARCHAR 255 - 65.534
-- nombre varchar(100) juan aqui solo guarda los 4 caracteres

-- BINARY Y VARBINARY

-- TEXT se usaba hasta que aparecio varchar 

-- BLOB

-- TINYBLOB 255, MEDIUMBLOB  Y LONGBLOB 4GB

-- ENUM 

-- SET 

#fecha

-- DATE
-- AAAA-MM-DD

-- 20190715
-- 2019-07-15 son li mismo

# DATETIME
-- AAAA-MM-DD HH:MM:SS

-- TIME
-- HH:MM:SS

-- TIMESTAMP

-- AAAA-MM-DD
-- AA-MM-DD

-- ON UPDATE CURRENT_TIMESTAMP para que se actualicen automaticamente

-- YEAR




