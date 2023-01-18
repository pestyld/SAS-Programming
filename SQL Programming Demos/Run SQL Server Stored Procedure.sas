****************************************************************************************;
*MICROSOFT SQL SERVER STORED QUERY

USE [AdventureWorksDW2014]
GO
/****** Object:  StoredProcedure [dbo].[LastName]    Script Date: 9/13/2019 10:28:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[LastName] @Last nvarchar(25) 
as
select top 10 *
from dbo.DimCustomer
where LastName=@Last;
****************************************************************************************;

proc sql;
connect to odbc (datasrc=development /*User=.... password=....*/);
create table Results as
select * 
    from connection to odbc 
       (execute LastName @Last='Johnson'); /*<---Run the LastName stored procedure using the Last value of 'Johnson'*/
disconnect from odbc;
quit;


proc sql;
connect to odbc (datasrc=development /*User=.... password=....*/);
create table Results as
select * 
    from connection to odbc 
       (execute LastName @Last='Smith'); /*<---Run the LastName stored procedure using the Last value of 'Johnson'*/
disconnect from odbc;
quit;


/*Automate Changes using Macro Variables*/
%let LastNameValue=Smith;
proc sql;
connect to odbc (datasrc=development /*User=.... password=....*/);
create table Results as
select * 
    from connection to odbc 
       (execute LastName @Last="&LastNameValue"); /*<---Run the LastName stored procedure using the Last value of 'Johnson'*/
disconnect from odbc;
quit;