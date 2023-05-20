database-- iacsdmar23

--easy 
delimiter //
create procedure displayAllEmp()
BEGIN
select *
from emp;
End //
delimiter ;
------------------------------------------------------------------------------------------------------------------------
/*
. write a procedure to insert record into employee table.
the procedure should accept empno, ename, sal, job, hiredate as input parameter
write insert statement inside procedure insert_rec to add one record into table
*/

delimiter //
create procedure insert_rec(in pempno int, in pename varchar(30),in psal double(9,2),in pjob varchar(20),in phireDate DATE)
BEGIN
insert into emp(empno,ename,sal,job,hiredate) values(pempno,pename,psal,pjob,phireDate);
END //
delimiter ;

call insert_rec(1211,'joe',5000,'clerk','2018-05-12');

------------------------------------------------------------------------------------------------------------------------

/*
write a procedure to delete record from employee table.
the procedure should accept empno as input parameter.
write delete statement inside procedure delete_emp to delete one record from emp 
table
*/

delimiter //
create procedure delete_emp(in pempno int)
BEGIN
DELETE FROM emp 
WHERE empno = pempno;
END //
delimiter ;

call delete_emp(1211);

------------------------------------------------------------------------------------------------------------------------------
/*
3. write a procedure to display empno,ename,deptno,dname for all employees with 
sal > given salary. pass salary as a parameter to procedure
*/

delimiter //
create procedure display_Emp(in psal double(9,2))
BEGIN
select e.empno,e.ename,e.deptno,d.dname
from emp e , dept d 
where e.deptno = d.deptno and e.sal > psal;
END //
delimiter ;

call display_Emp(500);

----------------------------------------------------------------------------------------------------------------------------------
/*
4. write a procedure to find min,max,avg of salary and number of employees in the 
given deptno.
deptno --→ in parameter 
min,max,avg and count ---→ out type parameter
execute procedure and then display values min,max,avg and count
*/

delimiter //
create procedure aggregateProcedure(in pdeptno int)
BEGIN 
select min(sal) min , max(sal) max, AVG(sal) avg, count(*)
from emp 
where deptno = pdeptno;
END //
delimiter ;

call aggregateProcedure(20);

-------------------------------------------------------------------------------------------------------------------------------------
insert into salesman values(10,'Rajesh','mumbai');
insert into salesman values(11,'Seema','Nashik');
insert into salesman values(12,'Rakhi','Pune');

/*
5. write a procedure to display all pid,pname,cid,cname and salesman name(use 
product,category and salesman table)
*/
delimiter //
create procedure display_AllRec()
BEGIN

select p.pid,p.pname,c.cid,c.cname,s.sname
from category c left join product p on 
c.cid = p.cid 
left join salesman s on p.sid = s.sid
union 
select p.pid,p.pname,null,null,s.sname
from product p right join salesman s ON 
p.sid = s.sid
where p.pname is null; 

END //
delimiter ;

call display_AllRec();

------------------------------------------------------------------------------------------------------------------------------
/*
6. write a procedure to display all vehicles bought by a customer. pass cutome name as 
a parameter.(use vehicle,salesman,custome and relation table)
*/

--------------------------------------------------------------------------------------------------------------------------------

delimiter //

create procedure display_rec()
BEGIN

select empno,ename,job,sal,deptno, 
CASE 
when sal < 1000 then 'Lesser'
when sal > 1000 then 'Greater'
when sal = 1000 then 'Equal'
else 'Error'
END as Status
from emp;

END //
delimiter ;

/*
7. Write a procedure that displays the following information of all emp
Empno,Name,job,Salary,Status,deptno
Note: - Status will be (Greater, Lesser or Equal) respective to average salary of their own
department. Display an error message Emp table is empty if there i s no matching
record.
*/

delimiter //
create procedure getStatus()
BEGIN

declare finished int default 0;
declare vempno, vdeptno int ;
declare vename,vjob, status varchar(30);
declare vsal, avgSal double(9,2);
declare emp_cur cursor for select empno,ename,job,sal,deptno from emp;
declare continue handler for not found 
set finished = 1;

OPEN emp_cur;

L1:LOOP

fetch emp_cur into vempno,vename,vjob,vsal,vdeptno; 
if finished = 1 then leave L1;
end if;

select floor(avg(sal)) into avgSal
from emp
where deptno = vdeptno;

if vsal > avgSal then 
set status = 'Greater';
elseif vsal < avgSal then 
set status ='Lesser' ;
elseif vsal = avgSal then
set status ='Equal';
else set status ='error..no matching rec';
end if;

select vempno,vename,vjob,vsal,vdeptno,status;
END LOOP L1;

close emp_cur;

END //
delimiter ;
---------------------------------------------------------------------------------------------------------------------------

how to calculate experience in emp TABLE

soln.
select empno, ename , job, sal , hiredate, floor(DATEDIFF(curdate(),hiredate) / 365) Experience
from emp;

------------------------------------------------------------------------------------------------------------------------------
8. Write a procedure to update salary in emp table based on following rules.
Exp <= 35 then no Update
Exp > 35 and <= 38 then 20% of salary
Exp > 38 then 25% of salary


delimiter //
create procedure updateSalExp()
BEGIN

declare finished int default 0;
declare vempno, experience int ;
declare vname varchar(30);
declare vsal, newSal double(9,2);
declare vhiredate DATE ;

declare emp_cur cursor for select empno,ename,sal,hiredate from emp;

declare continue handler for not found 
set finished = 1;

open emp_cur;

L1 : LOOP

fetch emp_cur into vempno,vname,vsal,vhiredate;

IF finished =1 
then leave L1;
end if;

select floor(DATEDIFF(curdate(),hiredate)/365) into experience
from emp where empno = vempno;

if experience > 35 and experience <= 38 
then 
update emp 
set sal = sal + vsal * 0.2 
where empno = vempno;

elseif experience > 38 
then 
update emp 
set sal = sal + vsal * 0.25
where empno = vempno;

else
update emp 
set sal = vsal
where empno = vempno;

end if;

select sal into newSal
from emp 
where empno = vempno;

select vempno,vname,vsal,vhiredate,vsal,newSal,experience;

end LOOP L1;

close emp_cur;

END //
delimiter ;

-------------------------------------------------------------------------------------------------------------------------
write a function to add two numbers..

delimiter //
Create function add_numbers(a int ,b int)
returns INT
begin 

return a + b;

end //
delimiter ;

-- select  add_numbers(35,15) as sum;

------------------------------------------------------------------------------------------------------------------------------
/*
9. Write a procedure and a function.
Function: write a function to calculate number of years of experience of employee.(note: 
pass hiredate as a parameter)

create table emp_allowance(
empno int,
ename varchar(20),
hiredate date,
experience int,
allowance decimal(9,2));
*/

create table emp_allowance(
empno int,
ename varchar(20),
hiredate date,
experience int,
allowence double(9,2)
);

--function to calculate experience..
delimiter //
create function calExperience(hiredate DATE)
returns int  
BEGIN
return floor(DATEDIFF(curdate(),hiredate)/365);
END //
delimiter ;

/*
Procedure: Capture the value returned by the above function to calculate the additional
allowance for the emp based on the experience.
Additional Allowance = Year of experience x 3000
Calculate the additional allowance 
and store Empno, ename,Date of Joining, and Experience in
years and additional allowance in Emp_Allowance table.
*/


delimiter //
create procedure calAllowence()
begin 
declare finished int default 0;
declare vempno,experience int ;
declare vename varchar(30);
declare vhiredate Date;
declare additionalAllowance double(9,2);

declare emp_cur cursor for select empno,ename,hiredate from emp;

declare continue handler for not found 
set finished =1;

open emp_cur;

L1 : LOOP

fetch emp_cur into vempno,vename,vhiredate;

if finished = 1 then leave L1;
end if;

set experience = calExperience(vhiredate);
set additionalAllowance = experience * 3000;

insert into emp_allowance values(vempno,vename,vhiredate,experience,additionalAllowance);

end LOOP L1;

close emp_cur;

END //

delimiter ;

----------------------------------------------------------------------------------------------------------------------------        
/*
10. Write a function to compute the following. Function should take sal and hiredate 
as i/p and return the cost to company.
DA = 15% Salary, HRA= 20% of Salary, TA= 8% of Salary.
Special Allowance will be decided based on the service in the company.
< 1 Year Nil
>=1 Year< 2 Year 10% of Salary
>=2 Year< 4 Year 20% of Salary
>4 Year 30% of Salary
*/
  
delimiter //
create function computeSal(sal double(9,2),hiredate DATE) 
returns double(9,2)
BEGIN
declare DA , HRA, TA, specialAllowence, costToCompany double(9,2);
declare expr int;
set DA = sal * 0.15;
set HRA = sal * 0.20;
set TA = sal * 0.8;
set expr = floor(DATEDIFF(curdate(),hiredate)/365);
if expr < 1 then 
set specialAllowence = 0;
elseif expr >=1 and expr < 2 THEN
set specialAllowence = sal * 0.10;
elseif expr >= 2 and expr < 4 then 
set specialAllowence = sal * 0.20;
else 
set specialAllowence = sal * 0.30;

end if;

set costToCompany = DA + HRA + TA + specialAllowence + sal;

return costToCompany;

END //
delimiter ;

-------------------------------------------------------------------------------------------------------------------

--11. Write query to display empno,ename,sal,cost to company for all employees(note: 
--use function written in question 10)

select empno,ename,sal,computeSal(sal,hiredate) CostToCompany
from emp;

-----------------------------------------------------------------------------------------------------------------
/*
Q2. Write trigger
1. Write a tigger to store the old salary details in Emp _Back (Emp _Back has the 
same structure as emp table without any
constraint) table.
(note :create emp_back table before writing trigger)
----- to create emp_back table
create table emp_back(
empno int,
ename varchar(20),
oldsal decimal(9,2),
newsal decimal(9,2)
)
(note :
execute procedure written in Q8 and 
check the entries in EMP_back table after execution of the procedure)
*/

create table emp_back(
empno int,
ename varchar(20),
oldsal double(9,2),
newsal double(9,2)
)


delimiter //
create trigger update_sal after update on emp 
for each ROW
begin 
insert into emp_back values (old.empno,old.ename,old.sal,new.sal);
End //
delimiter ;


--after executing Q8
 select *
 from emp_back;
 -----------------------------------------------------------------------------------------------------------------------
 /*
 2. Write a trigger which add entry in audit table when user tries to insert or delete 
records in employee table store empno,name,username and date on which 
operation performed and which action is done insert or delete. in emp_audit table.
create table before writing trigger.
create table empaudit(
 empno int;
 ename varchar(20),
 username varchar(20);
 chdate date;
 action varchar(20)
);
*/

create table empaudit(
empno int,
ename varchar(30),
chdate date,
action varchar(20)
);

delimiter //
create trigger insert_rec 
after insert on emp
for each ROW
BEGIN
insert into empaudit values(new.empno,new.ename,curdate(),'insert');
END //
delimiter ;

delimiter //
create trigger update_rec after update on emp
for each ROW
BEGIN
insert into empaudit values(new.empno,new.ename,curdate(),'update');
END //
delimiter ;

delimiter //
create trigger delete_rec after delete on emp
for each ROW
BEGIN
insert into empaudit values(old.empno,old.ename,curdate(),'delete');
END //
delimiter ;

--------------------------------------------------------------------------------------------------------------------
delimiter //
create procedure procedureName()
BEGIN

declare finished int default 0;

declare ----

declare emp_cur Cursor for select a,b,c from tableName;

declare continue handler for not found 
set finished = 1;

open emp_cur;

L1:LOOP 

fetch emp into va ,vb, vc;

if finished =1 then 
leave L1;
end if;



END LOOP L1;
close emp_cur;

end //
delimiter ;






















