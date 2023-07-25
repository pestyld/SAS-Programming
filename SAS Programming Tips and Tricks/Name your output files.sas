/****************************************************
Solution working directly with the excel workbook
****************************************************/

/*Set the location of your input files and output destination on your local machine*/
%let Location=C:\Users\pestyl\Documents\My SAS Files\; 

/*Changes options to convert excel column headers to valid SAS column(variable) names.
	Example: 
		- Excel Header= First Name
		- SAS = First_Name*/
options validvarname=v7; 

/*Depending on the SAS features you have*/
libname xlfile xlsx "&location/cars.xlsx";/*my preferred*/
*libname xlfile excel "&location/cars.xlsx";/*data set is named 'cars$'n when you use excel engine*/

/************************************
Code below will: 
	1. Output the data to an external files (Excel, PDF, CSV)
	2. Will automatically name the files using the current date, in the date9 format. 
	- Example: FileName23May2018.<extension>
************************************/

/*1. Output as an excel file*/
ods excel file="&location/FileName%sysfunc(today(),date9.).xlsx";
/*2. Output as a PDF file*/
ods csvall file="&location/FileName%sysfunc(today(),date9.).csv";
/*3. Output as a CSV File*/
ods pdf file="&location/FileName%sysfunc(today(),date9.).PDF";

Title "This report is the Make, Model, and MPG of Cars";
title2 "Report run on:%sysfunc(today(),weekdate.)";
proc print data=xlfile.cars noobs;
	var make model mpg_city mpg_highway;
	/*Additional SAS statements (where, by, etc..)*/
run;
title; /*Clear titles*/

ods excel close; 
ods pdf close; 
ods csvall close; 

/*Clear the connection with your excel workbook*/
libname xlfile clear; 