drop database if exists curso_sql;

create database if not exists curso_sql;

use curso_sql;

#Indice

#Primary
#index
#unique

show index from libro; -- para ver indices

#indice Primary
create table if not exists libro(
id int unsigned auto_increment not null,
titulo varchar(100),
autor varchar(50),
descripcion text,
editorial varchar(15),
primary key(id)
);
drop table libros;

#tipo index comun
create table if not exists libros(
id int unsigned auto_increment not null,
titulo varchar(100),
autor varchar(50) not null,
descripcion text,
editorial varchar(15) not null,
primary key(id),
index i_autoreditorial (autor, editorial) -- se referencia a 2 columnas autor y editorial
-- otra forma para tener lo mismo seria
-- index i_autor (autor) 
-- index i_editorial (editorial) 
);
show index from libros;

#tipo unique (unico)
-- no pueden haber 2 registro iguales con el mismo parametro que toma la llave unique
-- en nuestro caso la llave unique se referencia titulo
-- pueden coincidir todas las demas cosas pero menos en el titulo
create table if not exists libros1(
id int unsigned auto_increment not null,
titulo varchar(100),
autor varchar(50) not null,
descripcion text,
editorial varchar(15) not null,
primary key(id),
index i_autor(autor),
unique uq_titulo(titulo)
);
show index from libros1;

insert into libros1(titulo, autor, editorial) values('Java en 10 minutos', 'Alejandro', 'La Maravilla');
insert into libros1(titulo, autor, editorial) values('Java', 'Alejandro', 'La Maravilla');
insert into libros1(titulo, autor, editorial) values('Java principiantes', 'Alejandro', 'La Maravilla');

#Eliminar un indice
drop index i_autor on libros1;
drop index uq_titulo on libros1;

create index i_editorial on libros1 (editorial);
create unique index uq_titulo on libros1 (titulo);

select * from libros1;