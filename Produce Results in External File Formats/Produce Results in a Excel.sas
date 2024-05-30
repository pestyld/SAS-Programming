/*********************************************/
/* Produce Results in a Excel File           */
/*********************************************/

/* 1 - Specify your output destination for the Excel file below */
%let outpath = C:/Users/example; /*<-- Modify path */


/* 2 */
%let carMake = Toyota;


/***************************************/
/* CREATE EXCEL FILE                   */
/***************************************/
ods excel file = "&outpath./Report.xlsx"          /* 3 */
          options(embedded_titles="on"            /* 4 */
          		  sheet_interval='NONE'           /* 5 */
          		  sheet_name="&carMake._Cars");   /* 6 */


/************/
/* REPORT   */
/************/
/* 7 */
title justify=left height=16pt "All Available &carMake Cars";
proc print data=sashelp.cars;
	id Model;
	var Type Origin MSRP Invoice EngineSize Cylinders Horsepower
	    MPG_City MPG_Highway;
	where Make = "&carMake";

quit;
title;


/*****************/
/* VISUALIZATION */
/*****************/
/* 8 */
title justify=left height=16pt "Miles Per Gallon by MSRP for &carMake Cars";        
proc sgplot data=sashelp.cars;
	scatter x=MPG_Highway y=MSRP;
	where Make = "&carMake";
quit;
title;


/***************************************/
/* CLOSE EXCEL DESTINATIONEXCEL        */
/***************************************/
ods excel close;    /* 9 */