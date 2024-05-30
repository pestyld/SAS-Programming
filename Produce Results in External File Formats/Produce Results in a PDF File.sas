/*********************************************/
/* Produce Results in a PDF File             */
/*********************************************/

/* 1 - Specify your output destination for the PDF file below */
%let outpath = C:/Users/example; /*<-- Modify path */


/* 2 */
%let carMake = Toyota;


/***************************************/
/* CREATE PDF FILE                     */
/***************************************/
ods pdf file = "&outpath./Report.pdf"    /* 3 */
        contents=yes;                    /* 4 */


/************/
/* REPORT   */
/************/

ods proclabel="List of &carMake Cars";   /* 5 */

/* 6 */
title justify=left height=16pt "All Available &carMake Cars";
proc print data=sashelp.cars contents='List';
	id Model;
	var Type Origin MSRP Invoice EngineSize Cylinders Horsepower
	    MPG_City MPG_Highway;
	where Make = "&carMake";

quit;
title;


/*****************/
/* VISUALIZATION */
/*****************/

ods proclabel="MPG by MSRP for &carMake"; /* 7 */

/* 8 */
title justify=left height=16pt "Miles Per Gallon by MSRP for &carMake Cars";        
proc sgplot data=sashelp.cars des='Visualization';
	scatter x=MPG_Highway y=MSRP;
	where Make = "&carMake";
quit;
title;


/***************************************/
/* CLOSE PDF DESTINATION               */
/***************************************/
ods pdf close;    /* 9 */