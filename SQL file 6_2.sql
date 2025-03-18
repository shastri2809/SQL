create table department (Did int primary key auto_increment, Dname varchar(50) NOT NULL UNIQUE);
create table employees (Eid int primary key auto_increment, Empname varchar(50) NOT NULL, Salary Decimal (10,2), Did int,
foreign key (Did) references department (Did));
insert into department (Dname) values ('HR'), ('Engineering'), ('Marketing');
select * from department;
insert into employees (Empname, Salary, Did) values ('Alice', 60000, 1), ('Bob',75000,2), ('Charlie',50000,3), ('Diana', 80000,2), ('Eve', 45000,1);
select * from employees;
select * from employees where Salary > (select avg(Salary) from employees);
select * from employees where Salary < (select avg(Salary) from employees);