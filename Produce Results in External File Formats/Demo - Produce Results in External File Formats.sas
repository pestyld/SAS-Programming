/*********************************************/
/* Produce Results in Excel Demo             */
/*********************************************/

/****************************************************************************************************/
/* ODS Statements by Category                                                                       */
/****************************************************************************************************/
/* https://go.documentation.sas.com/doc/en/pgmsascdc/default/odsug/p1d1clmh7f8594n1puspnnds2kzt.htm */
/****************************************************************************************************/


/***********************************/
/* DATA PREPARATION                */
/***********************************/

data cars_final;
	set sashelp.cars;
	
	/* Calculate average Mile Per Gallon (MPG) */
	MPG_Avg = round(mean(MPG_City, MPG_Highway));
	
	/* Calculate percent increase of the Manufacturer's Suggested Retail Price (MSRP) */
	MSRP_Increase = round((MSRP - Invoice)/(Invoice), .001);
	
	/* Drop unnecessary columns */
	drop Weight Length Wheelbase;
	
	/* Format column */
	format MSRP_Increase percent7.1;
	
	/* Add column labels */
	label MPG_Avg = 'Average Miles Per Gallon'
	      MSRP_Increase = 'MSRP Increase Percentage';
run;

proc print data=cars_final(obs=10);
run;



/***************************************/
/* SET MACRO VALUES                    */
/***************************************/ 

/* Specify your output folder path */
%let outpath = ;

/* Dynamically store today's date */
%let currentDate = %sysfunc(today(), yymmdd10.);
%put &=currentDate;

/* Store company color as a hex value (Blue) */
%let companyColor=CX439CEF;



/***************************************/
/* CREATE EXCEL REPORT                 */
/***************************************/ 
/* Modify ODS Excel options */
/*
ods excel file = "&outpath./FinalReport_&currentDate..xlsx"
		  options(
		  	embedded_titles = 'ON'
		  	sheet_interval='NONE'
	  	  );
*/

/***************************/
/* LIST OF CAR INVENTORY   */
/***************************/
/* Modify ODS Excel options - Worksheet 1 */
/*
ods excel options(
			sheet_name="Inventory"
			autofilter='ALL'
			frozen_rowheaders='2'
			frozen_headers='3'
		  );
*/
	  
title justify=left height=16pt "Car Inventory";
proc print data=cars_final;
	id Make Model;
quit;
title;


/* Modify ODS Excel options - Worksheet 2 */
/*
ods excel options(
			sheet_name='CarsUnder10Pct'
			sheet_interval='NOW'
			autofilter='NONE'
			frozen_rowheaders='OFF'
			frozen_headers='OFF'
		  );
*/

/*****************/
/* VISUALIZATION */
/*****************/
/* Modify image size */
ods graphics / width=8in height=5in;

title justify=left height=16pt "Average Percentage MSRP Increase Over Invoice by Make";
proc sgplot data=cars_final
			noborder;
	vbar Make / 
		response=MSRP_Increase
		stat=mean 
		categoryorder=respdesc 
		fillattrs=(color=&companyColor)
		nooutline;
	refline .1 / 
		axis=y 
		label='Goal is above 10%' 
		lineattrs=(thickness=2)
		labelloc=inside
		labelattrs=(size=11pt);
	xaxis display=(nolabel);
	yaxis labelpos=top;
run;
title;

/* Reset image size to defaults */
ods graphics / reset;


/*********************************/
/* REPORT ON CARS UNDER 10%      */
/*********************************/
proc report data=cars_final;                                                           
    column Make Model Type MPG_Avg MSRP Invoice MSRP_Increase; 
    by Make;
    define Make / order display; 
    define Model / order;
    define MPG_Avg / display format=6.1; 
    define MSRP / display;
    define Invoice / display;
    define MSRP_Increase / display;
    compute MSRP_Increase;
    	if MSRP_Increase < .1 then do;
    		call define(_row_,"style","style={background=cxffa9a9}");
    	end;
    	else do;
    		call define(_row_,"style","style={background=white}");
    	end;
    endcomp;
run;

/* ods excel close; */