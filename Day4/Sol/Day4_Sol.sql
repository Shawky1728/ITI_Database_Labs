/*
1. Display (Using Union Function)
a. The name and the gender of the dependence that's gender is Female and 
depending on Female Employee.
b. And the male dependence that depends on Male Employee
*/

select depend.Dependent_name,depend.Sex
from Employee emp inner join Dependent depend
on emp.SSN = depend.ESSN
where emp.Sex ='f' and depend.Sex='f'
union 
select depend.Dependent_name,depend.Sex
from Employee emp inner join Dependent depend
on emp.SSN = depend.ESSN
where emp.Sex ='m' and depend.Sex='m'


/*
2. For each project, list the project name and the total hours per week (for all 
employees) spent on that project.
*/

select p.Pname,sum(w.Hours) as [Total hours per week]
from Project p left join Works_for w
on p.Pnumber = w.Pno
group by p.Pname

/*
3. Display the data of the department which has the smallest employee ID over all
employees' ID.
*/
select d.*
from Departments d inner join Employee e
on d.Dnum = e.Dno
where e.SSN =(select min(SSN) from Employee)


/*
4. For each department, retrieve the department name and the maximum, minimum and 
average salary of its employees.
*/

select Dname,max(Salary) as maximum ,min(Salary) as  minimum,avg(Salary)as average
from Departments d left join Employee e
on d.Dnum =e.Dno
group by Dname


/*
5. List the last name of all managers who have no dependents
*/

select e.Lname
from Employee e inner join Departments d
on e.SSN=d.MGRSSN
where e.SSN not in(select ESSN from Dependent)

/*
6. For each department-- if its average salary is less than the average salary of all 
employees
display its number, name and number of its employees.
*/

select Dnum,Dname,count(e.SSN)
from Departments d inner join Employee e
on d.Dnum = e.Dno
group by Dnum,Dname
having AVG(e.Salary)<(select AVG(Salary) from Employee)

/*
7. Retrieve a list of employees and the projects they are working on ordered by 
department and within each department, ordered alphabetically by last name, first 
name
*/

select e.Fname,e.Lname,p.Pname
from Employee e inner join Works_for w
on e.SSN = w.ESSn
inner join Project p on p.Pnumber =w.Pno
inner join Departments d on d.Dnum = e.Dno
order by d.Dnum,e.Lname,e.Fname

/*
8. Try to get the max 2 salaries using subquery
*/

select Salary
from Employee
where Salary in (select top 2 Salary from Employee order by Salary desc)


/*
9. Get the full name of employees that is similar to any dependent name
*/

select Fname+' '+Lname as FullName
from Employee e inner join Dependent d
on e.SSN = d.ESSN
where d.Dependent_name like '%'+ Fname+' '+Lname+ '%'

/*
10. Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
*/

update  Employee 
set Salary =1.3*Salary
from Employee e inner join Works_for w
on e.SSN = w.ESSn
inner join Project p on p.Pnumber = w.Pno
where p.Pname ='Al Rabwah'

/*
11. Display the employee number and name if at least one of them have dependents (use 
exists keyword) self-study
*/

select SSN,Fname+' '+Lname as FullName
from Employee
where exists (select 1 from Dependent where SSN = ESSN)


--DML

/*1. In the department table insert new department called "DEPT IT" , with id 100, employee 
with SSN = 112233 as a manager for this department. The start date for this manager is 
'1-11-2006'
*/
insert into Departments
values('DEPT IT',100,112233,'1-11-2006')


/*
Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574) moved to be 
the manager of the new department (id = 100), and they give you(your SSN =102672) her 
position (Dept. 20 manager) 
a. First try to update her record in the department table
b. Update your record to be department 20 manager.
c. Update the data of employee number=102660 to be in your teamwork (he will be 
supervised by you) (your SSN =102672
*/

--a
update Departments
set MGRSSN=968574,[MGRStart Date]=GETDATE()
where Dnum =100

--b
update Departments
set MGRSSN=102672,[MGRStart Date]=GETDATE()
where Dnum=20

--c
update Employee
set Superssn = 102672,Dno=20
where SSN=102660

/*
3. Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) 
so try to delete his data from your database in case you know that you will be temporarily 
in his position.
Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises 
any employees or works in any projects and handle these cases)
*/

-- delete all dependents
delete from Dependent
where ESSN =223344
--update the manager of his department
update Departments
set MGRSSN =102672
where MGRSSN=223344
--update the superssn of his employee
update Employee
set Superssn=102672
where Superssn=223344
--update projects  he works for
update Works_for
set ESSn =102672
where ESSn=223344
--then delete him
delete from Employee
where SSN=223344
