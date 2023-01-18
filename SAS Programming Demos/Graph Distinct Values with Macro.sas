/***************************************
Step1: CREATE FAKE DATA SET
***************************************/
data summary;
	infile datalines dlm=' ' dsd;
	input ID:8.;
	do month=1 to 12; /*Create column month with values 1-12*/
		total=rand('integer',1,10); /*Create the random value for total*/
		output;
	end;
/*fake ids*/
	datalines;
123123
125152
222222
333333
444444
425744
989289
;
/*Feel free to add more IDS here to test*/
run;

/*Preview table*/
proc print;
run;


/***************************************
Step 2: CREATE TWO MACRO VARIABLES
	1. STORED VALUES OF DISTINCT IDS
	2. TOTAL NUMBER OF DISTINCT IDS
***************************************/

/*You will need to change the ID colum to the column you would like, and in the FROM clause change the summary table to your table*/

proc sql /*noprint*/ /*No print option does not print results, cleans up results viewer*/;
	select distinct id  /*select distinct ids from the column*/
		into :id_list separated by ' ' /*place ids in a list in a variable named id_list*/
	from summary; /*from this table*/
quit;

/*View what was just created in the log*/
%put &=id_list; 

/*Again will need to change the ID column to your column, and the table in the FROM clause again*/

proc sql;
	select count(distinct id) as TotalDistinctIDs /*counts the number of distinct ids. Use in macro loop*/
		into :total_ids trimmed/*Store number in total_ids variable. The trimmed option removes leading spaces from the macro variable we create.*/
	from summary;			   /*To see what I mean with that, remove trimmed option and run the SQL procedure, then the %put below. You will see why you need trimmed*/
quit;

/*View what was just created in the log*/
%put &=total_ids;



/*******************************
Step 3: SEE THE VALUES OF THE NEWLY CREATED MACRO VARIABLES
********************************/
%put View values of Macro Variables;
%put &=id_list; 
%put &=total_ids;


/*******************************
Step 4: TEST SGPLOT FOR MACRO PROGRAM
********************************/

/*need to create a loop of this code for however many distinct ids there are*/
title "ID = 123123";
proc sgplot data=summary;
	vbar month / response=total;
	where id=123123; /*Need to substitute this with each value in the list of id_list*/
run;



/**************************************************************
Step 5: CREATE MACRO PROGRAM TO PRINT A GRAPH FOR EACH DISTINCT ID
***************************************************************/

%let outpath =S:\Files; /*Change this to a location where you want these*/

/*You will eventually have to change the tables, category and response inside here. Please let me know if you have questions.*/

%macro graphs();
/*Run this loop for the number of the distinct ids (this case 7 times)*/
%do i=1 %to &total_ids;

/*this add a new value to currentid for each loop*/
	%let currentid = %scan(&id_list,&i);

/******Run the following for each distinct ID******/

	/*Create PDF file for each ID*/
	ods pdf file="&outpath/ReportID_&currentid..pdf" 
				startpage=no;
	/*Create graph*/
		title "Summary of ID: &currentid";
		footnote "Created on: %sysfunc(today(),date9)"; /*Footnote the day the program was run*/
		proc sgplot data=summary;
			vbar month / response=total;
			where id=&currentid;/*Filter for only current ID*/
		run;
	/*Create summary report*/
		proc freq data=summary; /*This is just a random frequency as a placeholder*/
			tables id; 
			where id = &currentid;
		run;

	/*Close pdf*/
	ods pdf close;
/******Run the following for each distinct ID******/

%end;/*Go back to the top and pick the next id*/
%mend;



/**************************
Step 6: RUN MACRO PROGRAM
***************************/
options mprint mlogic symbolgen;/*this options allow you to see what's happening to the program in the log. It's a great way
					   to validate your macro program and make sure everything. Eventually when you have validated everything you will want 
					   to turn them off.*/
%graphs()

options nomprint nomlogic nosymbolgen;




/**************************************************************
Step 7: MAKE THAT MACRO PROGRAM MORE DYNAMIC
- WIth extra time you can make it so your macro program takes the inputs of
table, row, category and response and uses that information to create
the reports you want. This is not complete, but it's a start. To do this
it takes time to validate everything. I don't think it works yet, but if you
have questions please let me know! It's a nice start.
***************************************************************/
%macro dynamic_graphs(table /*Table to use*/,
					  row /*Row for distinct values*/,
					  response /*Response value for graph*/,
					  category /*category for bar*/
					  filelocation /*Where to place the PDF*/);
proc sql noprint;/*Don't show results*/
	select distinct &row  /*select distinct ids from the column*/
		into :id_list separated by ' ' /*place ids in a list in a variable named id_list*/
	from &table; /*from this table*/
quit;

proc sql noprint;/*Don't show results*/
	select count(distinct &row) /*counts the number of distinct ids. Use in macro loop*/
		into :total_ids /*Store number in total_ids variable*/
	from &table;
quit;

/*total ids needs to be left aligned. This happens with numeric values in SQL*/
%let total_ids=&total_ids;


/*Run this loop for the number of the distinct ids (this case 4 times)*/
%do i=1 %to &total_ids;

/*this add a new value to currentid for each loop*/
	%let currentid = %scan(&id_list,&i);


	ods pdf file="&outpath/ReportID_&currentid..pdf" 
				startpage=no;

/******Run the following for each distinct ID******/
		title "Summary of ID: &currentid";
		footnote "Created on: %sysfunc(today(),date9)";
		proc sgplot data=&table;
			vbar &category / response=&response;
			where id=&currentid;/*Filter for only current ID*/
		run;
		
		proc freq data=&table; /*This is just a random frequency as a placeholder*/
			tables &category; 
			where id = &currentid;
		run;

	ods pdf close;

/******Run the following for each distinct ID******/

%end;/*Go back to the top and pick the next id*/
%mend;

%dynamic_graphs(summary,id,total,month, s:/workshop/output)


