create database UserDB;
Use UserDB;
create table Usertbl (uid int auto_increment primary key, uname varchar(50), uemail varchar(50) unique, upswd varchar(30), ucontact int unique);
desc Usertbl;
select * from Usertbl;
