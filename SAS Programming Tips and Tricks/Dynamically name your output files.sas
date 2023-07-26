/****************************************************
Dynamically name your output files
*****************************************************
- Name all of your output files by appeneding the current
  date to the end of the file name.
****************************************************/

/*Set the location of your output destination on your local machine*/
%let Location=C:/Users/pestyl/OneDrive - SAS/github repos/SAS Programming/SAS Programming Tips and Tricks/~output files; 


/************************************
Code below will: 
	1. Output the data to an external files (Excel, PDF, CSV)
	2. Will automatically name the files using the current date, in the date9 format. 
	- Example: FileName23May2018.<extension>
************************************/

/* Dynamically store the date in a macro variable */
%let dynamicDate = %sysfunc(today(),date9.);


/*1. Output as an excel file*/
ods excel file="&location/FileName&dynamicDate..xlsx";

/*2. Output as a PDF file*/
ods csvall file="&location/FileName&dynamicDate..csv";

/*3. Output as a CSV File*/
ods pdf file="&location/FileName&dynamicDate..PDF";


/* Create this report */
Title "This report is the Make, Model, and MPG of Cars";
title2 "Report run on:&dynamicDate";

proc print data=sashelp.cars(obs=10) noobs;
	var make model mpg_city mpg_highway;
run;
title;


/* Close the output destinations */
ods excel close; 
ods pdf close; 
ods csvall close; 