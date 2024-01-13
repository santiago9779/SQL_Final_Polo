show databases;
create database dim_espejo;
use dim_espejo;
show tables;
create table if not exists usuario (
	id int not null auto_increment,
	nombre varchar(50),
    apellido varchar(50),
    primary key(id)
);
insert into usuario(nombre,apellido) values ("Santiago","Velasquez");
insert into usuario(nombre,apellido) 
	values ("Nadia","Velasquez"),
			("Agostina","Caceres")
;
 
select * from usuario;

drop table usuario;
delete from usuario where id=1;
truncate table usuario;
show create table usuario;
drop table megan;

