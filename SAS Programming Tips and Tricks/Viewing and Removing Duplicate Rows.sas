**********************************************************************;
* STUDENT QUESTION: How to remove duplicate rows?                    *;
**********************************************************************;
* PROGRAM DESCRIPTION: In this program I show a variety of techniques*;
*					   to entirely duplicate rows, only use a select *;
*					   few rows as a duplicate, count the number of  *;
*					   duplicate rows, filter to view only the       *;
* 					   duplicate rows							     *;
**********************************************************************;

/*Create fake table with duplicates*/
data duplicates;
	infile datalines dsd;
	input FName:$20. LName:$20. Age:8.;
	datalines;
Peter, Styliadis, 33
John, Smith,21
Kerry, Johnson,20
Peter, Styliadis, 33
John, Smith, 40
Steve, Wells, 41
John, Smith, 21
Steve, Wells, 41
John, Smith, 21
Steve, Wells, 41
John, Smith, 21
Steve, Wells, 44
John, Smith, 29
;
quit;


/*SELECT ALL ROWS*/
title "All rows";
proc sql number;
select *
	from duplicates;
quit;

/*REMOVE DUPLICATES USING ALL COLUMNS AS DUPLICATES*/
title "Remove duplicates";
proc sql number;
select distinct *
	from duplicates;
quit;

/*REMOVE DUPLICATES USING ONLY FIRST NAME AND LAST NAME COLUMNS*/
title "Remove duplicates";
proc sql number;
select distinct FName, LName
	from duplicates;
quit;

/*COUNT WHICH ROWS HAVE DUPLICATES*/
title "Count which rows have duplicates, and how many";
proc sql number;
select FName, LName, Age, count(*) as TotalDuplicates
	from duplicates
	group by FName, LName, Age;
quit;

/*VIEW ONLY DUPLICATE ROWS BY FILTERING USING HAVING*/
title "View only duplicates";
proc sql number;
select FName, LName, Age, count(*) as Total
	from duplicates
	group by FName, LName, Age
	having Total > 1;
quit;




/************SAS METHOD************/
proc sort data=duplicates       /*input table*/
		  out=NoDuplicates      /*clean table, no duplicates*/
		  dupout=DuplicateRows  /*contains the extra duplicate rows for investigation*/
		  nodupkey;             /*option to remove duplicates*/
	by _all_;                   /*Use all columns to determine duplicates*/
quit;