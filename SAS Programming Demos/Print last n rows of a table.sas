/*Tail End*/


/*This is a test with a static table to make sure my logic is correct*/
proc sql;
select count(*)
	into :TotalRows trimmed
	from sashelp.cars;
quit;
%put &=totalrows;

proc print data=sashelp.cars(firstobs=%eval(&TotalRows-10) obs=&TotalRows);
run;



/*Create a program that can be used on any table named %tail*/
%macro tail(table,n=10);
proc sql noprint;
select count(*)
	into :TotalRows trimmed /*Store total rows in variable TotalRows*/
	from &table;
quit;

proc print data=sashelp.cars(firstobs=%eval(&TotalRows-&n) /*Total rows minus value specified,default 10*/
                             obs=&TotalRows); /*Go to the max number of rows*/
run;
%mend;


/*Now I can use my program on any table*/
%tail(sashelp.cars)

%tail(sashelp.cars,n=20)/*Change default n=10 to n=20*/

%tail(sashelp.baseball)