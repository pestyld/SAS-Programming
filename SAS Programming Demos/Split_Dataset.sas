/*Program only works if the distinct values for dsn_names and make1-make<x> are in the same order*/
/******Program needs testing and review******/

%macro Make(dataset=,column=);
/*Find distinct values of the column to use as data set names*/
proc sql noprint;
	select distinct compress(&column,,'kad')/*data set names must follow naming conventions. Here we are removing special characters*/
		into :dsn_names separated by ' '
		from &dataset; /*Place list in macro variable called &dataset*/
run;

/*Find distinct values in a column to use in the conditional. These values CAN have special characters*/
proc sql noprint;
	select distinct &column
		into :make1 - /*Values will be placed in macro variables &make1 - however many needed*/
		from &dataset;
run;

data &dsn_names; /*Data set names list, no special characters*/
	set &dataset;/*Use original input data set*/
	%do i=1 %to &sqlobs;/*Run this loop for the amount of distinct values*/
/*Conditional below. If the column='a distinct value', then output to corresponding data set*/
	if &column="&&make&i" then output %sysfunc(compress(&&make&i,'- '));
	%end;
run;
%mend;

/*Create 3 data sets for each car origin*/
%Make(dataset=sashelp.cars,column=origin) /*Runs the program above. It's like you created you own little package*/

/*Creates 24 data sets for each team*/
%make(dataset=sashelp.baseball,column=team)

/*Try using another sashelp data set*/
%make(dataset=/*Enter Data Set*/,column=/*Enter Column*/)
