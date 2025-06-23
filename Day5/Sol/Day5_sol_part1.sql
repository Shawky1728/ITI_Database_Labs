/*
1. Retrieve number of students who have a value in their age.
*/

select count(St_Age)
from Student

/*
2. Get all instructors Names without repetition
*/

select distinct Ins_Name
from Instructor

/*
3. Display student with the following Format (use isNull function)
-------------------------------------------------------
Student ID   |   Student Full Name   |  Department name |
-------------------------------------------------------
*/

select St_Id as [Student ID],isnull(St_Fname+' '+St_Lname ,'No name')as[Student Full Name],Dept_Name  as [Department name]
from Student s inner join Department d
on s.Dept_Id = s.Dept_Id

/*
4. Display instructor Name and Department Name 
Note: display all the instructors if they are attached to a department or not
*/


select i.Ins_Name,d.Dept_Name
from Instructor i left outer join Department d
on d.Dept_Id = i.Dept_Id


/*
5. Display student full name and the name of the course he is taking
For only courses which have a grade
*/

select St_Fname+' '+St_Lname as Fullname ,c.Crs_Name
from Student s inner join Stud_Course sc
on s.St_Id = sc.St_Id
inner join Course c
on c.Crs_Id = sc.Crs_Id
where Grade is not null


/*
6. Display number of courses for each topic name
*/

select Top_Name,count(c.Crs_Id) as [Number Of Courses]
from Topic t inner join Course c
on t.Top_Id = c.Top_Id
group by Top_Name


/*
7. Display max and min salary for instructors
*/

select max(Salary) as maximum , min(Salary)as minimum
from Instructor


/*
8. Display instructors who have salaries less than the average salary of all 
instructors
*/

select *
from Instructor
where Salary <(select AVG(Salary) from Instructor)

/*
9. Display the Department name that contains the instructor who receives the 
minimum salary.
*/

select d.Dept_Name
from Department d inner join Instructor i
on d.Dept_Id = i.Dept_Id
where i.Salary =(select min(Salary) from Instructor)

/*
10. Select max two salaries in instructor table.
*/

select top 2 Salary
from Instructor
order by Salary desc

/*
11. Select instructor name and his salary but if there is no salary display instructor 
bonus. “use one of coalesce Function”
*/

select Ins_Name,coalesce(convert(varchar(5),Salary),'instructor bonus') as Salary
from Instructor


/*
12.Select Average Salary for instructors
*/

select avg(Salary) as AvgSalary
from Instructor

/*
13.Select Student first name and the data of his supervisor
*/

select s2.St_Fname,s1.*
from student s1 inner join student s2 
on s1.St_Id = s2.St_super

/*
14.Write a query to select the highest two salaries in Each Department for 
instructors who have salaries. “using one of Ranking Functions
*/
select *
from(select Dept_Name,Salary,ROW_NUMBER() over(partition by dept_name order by salary desc) as RN
from Department d inner join Instructor i
on d.Dept_Id = i.Dept_Id) as Newtable
where Rn<3

/*
15. Write a query to select a random student from each department. “using one 
of Ranking Functions
*/
select *
from
(select  Dept_Name,St_Id,St_Fname,ROW_NUMBER() over(partition by dept_name order by newid()) as rn
from Student s inner join Department d
on d.Dept_Id = s.Dept_Id) as newTable
where rn<2