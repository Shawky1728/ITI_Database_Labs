
--Note: Use ITI DB

/*
1. Create a view that displays student full name, course name if the student has a grade more than 50.
*/

create view StudentInfo
as
select s.St_Fname+' '+s.St_Lname as FullName ,c.Crs_Name,sc.Grade
from Student s inner join Stud_Course sc
on s.St_Id = sc.St_Id
inner join Course c
on c.Crs_Id = sc.Crs_Id
where sc.Grade>50

select * from  StudentInfo


/*
2. Create an Encrypted view that displays manager names and the topics they teach. 
*/

create view MangerTopic
with encryption
as
select ins.Ins_Name as MangerName ,t.Top_Name
from Department d inner join Instructor ins
on d.Dept_Manager = ins.Ins_Id
inner join Ins_Course insc 
on ins.Ins_Id = insc.Ins_Id
inner join Course c 
on c.Crs_Id = insc.Crs_Id
inner join Topic T 
on t.Top_Id = c.Top_Id


select * from MangerTopic


/*
3. Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
*/


Create view InsDeptInfo
as
select Ins_Name as InstuctorName , Dept_Name as DepartmentName 
from Instructor ins inner join Department D
on D.Dept_Id=Ins.Dept_Id and Dept_Name in ('SD','Java')
go
select * from InsDeptInfo


/*
4. Create a view “V1” that displays student data for student who lives in 
Alex or Cairo. 
Note: Prevent the users to run the following query 
Update V1 set st_address=’tanta’
Where st_address=’alex’;
*/

create view v1 
as 
select *
from Student
where St_Address in ('alex','cairo')
with check option


Update V1 set st_address='tanta'
Where st_address='alex';

select * from v1

/*
5. Create a view that will display the project name and the number of employees work on it. “Use Company DB”
*/

Use Company_SD

Create View ProjectInfo
as
select Pname as ProjectName , count(ESSn) as NumOFEmps from Project 
		inner join Works_for on Project.Pnumber = Works_for.Pno 
		inner join Employee on Employee.SSN = Works_for.ESSn
			group by Pname 

select * from ProjectInfo


/*
6. Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?
*/

----------Answer--------------

--we can't use clustered as there is a primary key use it but we can use Nonclustered


create Nonclustered index I
on department(Manager_hiredate)



/*
7. Create index that allow u to enter unique ages in student table. What will happen?
*/

create unique index I
on student(st_age)

-- can't make it as there are duplicate values


/*
8. Using Merge statement between the following two tables [User ID, Transaction Amount]
*/

create table [last Transaction](id int ,Amount int)
create table [daily Transaction](id int ,Amount int)

merge into [last Transaction] as l
using [daily transaction] as d
on l.Id =d.Id
when Matched then
update set l.Amount = d.Amount
when Not Matched by target then
insert
values(d.id,d.amount)
when Not Matched by source then
delete ;
