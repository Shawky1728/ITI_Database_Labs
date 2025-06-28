/*
1. Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 
*/

create proc p1
as
select d.Dept_Name,count(s.St_Id)
from Department d inner join Student s
on d.Dept_Id = s.Dept_Id
group by d.Dept_Name

p1

/*
2. Create a stored procedure that will check for the # of employees in the 
project p1 if they are more than 3 print message to the user “'The number 
of employees in the project p1 is 3 or more'” if they are less display a 
message to the user “'The following employees work for the project p1'” in 
addition to the first name and last name of each one. [Company DB]
*/

use Company_SD

create proc p2 @name varchar(20)
as
declare @num int
select @num=count(wf.ESSn)
from Project p inner join Works_for wf
on p.Pnumber = wf.Pno
where p.Pname=@name

if @num >= 3
select 'The number of employees in the project ' +@name+' is 3 or more'
else
begin
select 'The following employees work for the project '+@name
union all
select  e.Fname+' '+e.Lname
from Project p inner join Works_for wf
on p.Pnumber = wf.Pno
inner join Employee e
on e.SSN = wf.ESSn
where p.Pname=@name
end

p2 'Pitcho american'

/*
3. Create a stored procedure that will be used in case there is an old 
employee has left the project and a new one become instead of him. The 
procedure should take 3 parameters (old Emp. number, new Emp. number 
and the project number) and it will be used to update works_on table. 
[Company DB]
*/

create proc p3 @Id_old int ,@id_new int ,@pnum int
as
begin try
update Works_for
set ESSn = @id_new
where 
ESSn=@Id_old and Pno=@pnum
end try
begin catch
select @@ERROR
end catch

p3 22323, 43343, 4433



/*
4. add column budget in project table and insert any draft values
*/

alter table project add budget int

/*
 Create an Audit table with the following structure 
*/

create table AuditTable(
ProjectNo  int ,
UserName  varchar(100),
ModifiedDate date,
Budget_Old int,
Budget_New int
)

/*
If a user updated the budget column then the project number, user name 
that made that update, the date of the modification and the value of the 
old and the new budget will be inserted into the Audit table
Note: This process will take place only if the user updated the budget 
column
*/

create trigger t1
on project
after  update
as
if update(budget)
begin
declare @newbudg int,@oldbudg int,@pno int
select @newbudg = budget from inserted
select @oldbudg = budget from deleted
select @pno = Pnumber from deleted
insert into  AuditTable
values(@pno,SUSER_NAME(),GETDATE(),@oldbudg,@newbudg)
end

update Project set budget =11
where Pnumber=100


/*
5. Create a trigger to prevent anyone from inserting a new record in the 
Department table [ITI DB]
“Print a message for user to tell him that he can’t insert a new record in 
that table”
*/

create trigger t on department
instead of insert
as
select 'You can’t insert a new record in that table'

insert into Department(Dept_Id,Dept_Name)
values(2121,'dd')


/*
6. Create a trigger that prevents the insertion Process for Employee table in 
March [Company DB].
*/

use Company_SD

create trigger t2 on employee
after insert
as
if FORMAT(GETDATE(),'MMMM')='March'
rollback



/*
7. Create a trigger on student table after insert to add Row in Student Audit 
table (Server User Name , Date, Note) where note will be “[username] 
Insert New Row with Key=[Key Value] in table [table name]”
*/

create table StudentAudit
(
Server_User_Name varchar(100),
Date Date,
Note varchar(300)
)

create trigger t3 on student
after insert
as
insert into StudentAudit
values(SUSER_NAME(),GETDATE(),SUSER_NAME()+' Insert New Row with Key = '+convert(varchar(30),(select st_id from inserted))+' in table student')



/*
8. Create a trigger on student table instead of delete to add Row in Student
Audit table (Server User Name, Date, Note) where note will be“ try to 
delete Row with Key=[Key Value]”
*/

create trigger t4 on student
instead of delete
as
insert into StudentAudit
values(SUSER_NAME(),GETDATE(),'try to delete Row with Key = '+convert(varchar(6),(select st_id from deleted)))


/*
10. Display Each Department Name with its instructors. “Use ITI DB”
A) Use XML Auto
B) Use XML Path
*/


--A
select d.Dept_Name,ins.Ins_Name
from Department d inner join Instructor ins
on d.Dept_Id = ins.Dept_Id
for xml auto


--B

select d.Dept_Id '@ID'
,d.Dept_Name 'DepartmentName'
,ins.Ins_Name 'InstructorName'
from Department d inner join Instructor ins
on d.Dept_Id = ins.Dept_Id
for xml path


/*
11. Use the following variable to create a new table “customers” inside the company DB.
Use OpenXML
*/

declare @docs xml =
'<customers>
 <customer FirstName="Bob" Zipcode="91126">
 <order ID="12221">Laptop</order>
 </customer>
 <customer FirstName="Judy" Zipcode="23235">
 <order ID="12221">Workstation</order>
 </customer>
 <customer FirstName="Howard" Zipcode="20009">
 <order ID="3331122">Laptop</order>
 </customer>
 <customer FirstName="Mary" Zipcode="12345">
 <order ID="555555">Server</order>
 </customer>
 </customers>' declare @hdocs int  exec sp_xml_preparedocument @hdocs output,@docs select * into customers from openxml(@hdocs,'//customer') with( FirstName varchar(20) '@FirstName', Zipcode varchar(20) '@Zipcode', orderId varchar(20) 'order/@ID', [order] varchar(20) 'order' ) exec sp_xml_removedocument @hdocs