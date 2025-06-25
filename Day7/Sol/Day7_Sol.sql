/*
1. Create a scalar function that takes date and returns Month name of that 
date.
*/

create function Month_Name (@date date)
returns varchar(20)
begin
declare @name varchar(20)
select @name = format(@date,'MMMM')
return @name
end


select dbo.Month_Name(getdate()) 


/*
2. Create a multi-statements table-valued function that takes 2 integers 
and returns the values between them.
*/

create function betweenNumbers(@x int ,@y int)
returns @t table (
nums int
)
as
begin
while @x<(@y-1)
begin
select @x+=1
insert into @t
select @x
end
return
end


select * from betweenNumbers(1,11)

/*
3. Create inline function that takes Student No and returns Department 
Name with Student full name.
*/

create function studentInfo(@id int)
returns table as
return
(
select s.St_Fname+' '+s.St_Lname as FullName ,d.Dept_Name  as DeptName
from student s inner join Department d 
on d.Dept_Id = s.Dept_Id
where St_Id =@id
)


select * from studentInfo(1)


/*
4. Create a scalar function that takes Student ID and returns a message to 
user 
a. If first name and Last name are null then display 'First name & 
last name are null'
b. If First name is null then display 'first name is null'
c. If Last name is null then display 'last name is null'
d. Else display 'First name & last name are not null'
*/

create function fun(@id int)
returns varchar(70)
begin
declare @result varchar(70)
declare @fname varchar(70)
declare @lname varchar(70)

select @fname=St_Fname,@lname=St_Lname
from Student
where St_Id =@id

if @fname is null and @lname  is null
set @result ='First name & last name are null'
else if  @fname  is null
set @result ='First name is null'
else if  @lname  is null
set @result ='last name is null'
else
set @result = 'First name & last name are not null'
return @result
end


select dbo.fun(13)

/*
5. Create inline function that takes integer which represents manager ID 
and displays department name, Manager Name and hiring date
*/


create function getdetails(@mgr_id int)
returns table 
		as return(
			 select Dept_Name , Ins_Name , Manager_hiredate
			 from Department D inner join Instructor Ins
			 on Ins.Ins_Id=D.Dept_Manager and D.Dept_Manager=@mgr_id
		)
select * from  dbo.getdetails(1)


/*
6. Create multi-statements table-valued function that takes a string
If string='first name' returns student first name
If string='last name' returns student last name 
If string='full name' returns Full Name from student table 
Note: Use “ISNULL” function
*/

create function getstname(@string nvarchar(50))
returns @t table 
(
	studentName nvarchar(50)
)
		as
		begin
	 if @string ='first name'
				 insert into @t
	 			 select isnull(St_Fname,'Fname') from Student
	 else if @string ='last name'
				 insert into @t
	 			 select isnull(St_Lname,'Lname') from Student
	 else if @string ='full name'
				 insert into @t
	 			 select isnull(St_Fname+' '+St_Lname,'Fullname')  from Student
			return
		end

/*
7. Write a query that returns the Student No and Student first name without the last char
*/

select St_Id,SUBSTRING(St_Fname,1,len(st_fname)-1)
from student 

/*
8. Wirte query to delete all grades for the students Located in SD Department
*/

update Stud_Course set Grade=null
from student s inner join Department d
on d.Dept_Id = s.Dept_Id
inner join
Stud_Course sc on 
sc.St_Id=s.St_Id
where d.Dept_Name='sd'


--Bouns

/*
2. Create a batch that inserts 3000 rows in the employee table. The values of 
the emp_no column should be unique and between 1 and 3000. All values 
of the columns emp_lname, emp_fname, and dept_no should be set to 
'Jane', ' Smith', and ' d1', respectively.”USE CompnayDB
*/

use Company_SD
declare @i int =1
while @i <=3000
begin
insert into Employee(ssn,lname,fname,dno)
values(@i,'jane','smith',10)
set @i+=1
end