/*********************************************/
/* Produce Results in a HTML File            */
/*********************************************/

/* 1 - Specify your output destination for the HTML file below */
%let outpath = C:/Users/example; /*<-- Modify path */


/* 2 */
%let carMake = Toyota;


/***************************************/
/* CREATE HTML FILE                    */
/***************************************/
ods html5 path = "&outpath"           /* 3 */
          file="Report.html";         /* 4 */


/************/
/* REPORT   */
/************/
/* 5 */
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
/* 6 */
title justify=left height=16pt "Miles Per Gallon by MSRP for &carMake Cars";        
proc sgplot data=sashelp.cars des='Visualization';
	scatter x=MPG_Highway y=MSRP;
	where Make = "&carMake";
quit;
title;


/***************************************/
/* CLOSE HTML DESTINATION              */
/***************************************/
ods html5 close;    /* 7 */