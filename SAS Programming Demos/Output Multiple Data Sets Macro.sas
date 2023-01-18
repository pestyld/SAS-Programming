/*=======================================================
PROGRAM: Macro program to create data sets based on distinct values of columns
CREATED BY: Peter Styliadis
DATE CREATED: 7/02/2018
FILE USED:
	1. SASHELP.cars and SASHELP.baseball to test. Will work on any table and column.

PROGRAM PURPOSE: 
	1. Program will take a input of a sas table and column. Program will find the distinct values
of the column and create tables based on the those distinct values. Program will then use conditional
logic to output rows to the correct tables. For example: SASHELP.cars has 3 distinct drivetrains(all,front,rear).
Program will create three tables based on the drivetrain, then output all rows with "ALL" drivetrain to the 
ALL table.

FUTURE ENHANCEMENTS/ISSUES:
	1. Clean up the code and comments

*************************************************************************************************
					Modification Log
DATE(MM/DD/YY)	USER		MODIFICATION
10/04/2018		Styliadis	Cleaned up code. Didn't need to SQL procs.
10/16/2018		Styliadis	Fixed code from last modification.
*************************************************************************************************/

/*********************/
/*Peter's Solution*/
/*********************/

/*-------------------------------------------------*/
/*What I want to do*/
/*Create a program that automatically does this for any column and table I choose*/

/*Using the unique values of a column*/
proc freq data=sashelp.cars;
	tables DriveTrain;
run;

/*Create those unique values as tables, then output each row to the correct table.*/
data All Front Rear;
	set sashelp.cars;
	if DriveTrain="All" then output all;
		else if drivetrain="Front" then output front;
		else if drivetrain="Rear" then output rear;
run;
/*-------------------------------------------------*/


*===========================================================;
/*Step by step breakdown. Is used in program later*/
*===========================================================;

/*I Want this:

Data uniquevalue1 uniquevalue2 ... uniquevalue-N(total num of uniques)
	set Original data;
	if Column=Uniquevalue1 then output uniquevalue1 table;
	else if column=Uniquevalue2 then output uniquevalue2 tale;
run;

HOW do I do this? I need:
	1. Count how many distinct columns are in the column I need to use
	2. Create unique values into data set names in macro variables.
	3. Watch out out for special characters when creating tables, such as mercedes-benz

Brainstorming done*/


/*Start with sample data to test my code*/
%let data=sashelp.cars; /*what table do I want to use*/
%let column=type;/*What column do I want to use*/

/*Step 1: Count how many distinct columns are in the column I need to use*/
proc sql;
	select count(distinct &column) as TotalDistinctValues
	into :total
	from &data;
quit;
%put Value with leading spaces: &=total;/*View macro value in log to check and see if it works*/
%let total=&total; /*Remove leading blanks. If create a number as a macro variable in sql it will have leading spaces*/
%put Leading spaces removed: &=total;/*View new value in log after I remove leading spaces*/


/*Step 2: Create data set names. Remove special characters because of SAS naming conventions*/
	/*Example: Mercedes-Benz will now equal MercedesBenz and can be used a sas table*/
	/*Example: Data Toyota Honda MercedesBenz;*/
proc sql;
	select distinct compress(&column,,'kad')
		into :dsn1 - 
	from &data;
quit;
%put &=dsn1 &=dsn3; /*View values in log for check*/
/*so now I can write: Data DSN1 DSN2 DSN-&total; for data set names;



/*Macro program. This program is now saved to multipledata. Think of it almost as a function*/
%macro multipledata(data=,column=);

/*A. count number of distinct values and store into the Total macro variable*/
proc sql noprint;
	select count(distinct &column)
	into :total
	from &data;
quit;
%let total=&total; /*Remove leading blanks*/

/*B. Find distinct values in a column for filtering and output. Can leave full value
	 with special characters*/
proc sql;
	select distinct compress(&column,,'kad')
		into :dsn1 - 
	from &data;
quit;

/*Final data step. This will create a data set for each distinct value of column*/

data %do i=1 %to &total; /*Enter total distinct number from A*/
		&&dsn&i /*Enter all data set names from B*/
	 %end;
	 ;/*End data statement semicolon*/

	 /*filter and output to correct tables. Select is similar to an if/then else*/
	set &data;
		select(compress(&column,,'kad'));/*Remove special characters from column for test only. Values still exist as normal*/
			%do i=1 %to &total;/*Enter total distinct from A*/
			when("&&dsn&i") output &&dsn&i;/*Enter distinct values from B*/
			%end;
			otherwise;
		end;
	run;
%mend;


/*test the new macro program on the SASHELP.CARS table and Origin column*/
%multipledata(data=sashelp.cars,column=origin)

/*test again*/
%multipledata(data=sashelp.baseball, column=team)



/***************************************************************************/
/*ANOTHER SOLUTION*/
/*Chris Hemedinger Solution Blog Post*/
/*https://blogs.sas.com/content/sasdummy/2015/01/26/how-to-split-one-data-set-into-many/*/
/***************************************************************************/
/* define which libname.member table, and by which column */
%let TABLE=sashelp.cars;
%let COLUMN=origin;
 
proc sql noprint;
/* build a mini program for each value */
/* create a table with valid chars from data value */
	select distinct cat("DATA out_",compress(&COLUMN.,,'kad'),"; 
							set &TABLE.(where=(&COLUMN.='", &COLUMN.,"')); 
						run;") length=500 
		into :allsteps separated by ';' 
  	from &TABLE.;
quit;
 %put &=allsteps;

/* macro that includes the program we just generated */
%macro runSteps;
 &allsteps.;
%mend;
 
/* and...run the macro when ready */
%runSteps;
/***************************************************************************/
/***************************************************************************/
