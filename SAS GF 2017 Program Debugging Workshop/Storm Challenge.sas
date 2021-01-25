/*Set the macro variable path to the challenge data*/
%let path="C:\Workshop\Challenge\ProgramDebug";

/*Use macro variable in the libname statement*/
libname data "&path";

/*************************************************************
Create the category format by using the Saffir-Simpson Hurricane 
wind scale: https://www.nhc.noaa.gov/aboutsshws.php
	74-95 mph = Category 1
	96-110 mph = Category 2
	111-129 mph = Category 3
	130-156 mph = Category 4
	157+ mph = Category 5
	All other storms = 'N/A'
*************************************************************/
proc format;
	value StormCategory /*Using MPH*/
		74 - 96 = 'Category 1'
		96 - 111 = 'Category 2'
		111 - 130 = 'Category 3'
		130 - 157 = 'Category 4'
		157 - high = 'Category 5'
		other = 'N/A';
run;

/*************************************************************
The final data set should contain one observation per storm. Here is what each 
observation should have:
- Start_Date, End_Date, and LengthofStorm(in days)
- MaxWind (maximum wind speed) and MaxStatus for the tracked storm
- a MaxStatus value based on the StatusDescription Column in the Storm_lookup data set
- a new variable named Category that is created using the format provided
*************************************************************/

/***************
1. DATA Step
****************/
data Storms;
	set data.Storm_Details;
	retain MaxWindSpeed MaxStatus Start_Date;
	by StormKey;
	if _n_=1 then call symputx('BeginningYear',year(date)); /*Create the first year macro variable*/
	if first.StormKey then Start_Date=date; /*Set the storm Start_Date to the initial date*/
	if MaxWind > MaxWindSpeed then /*Test to determine the MaxWindSpeed of the storm*/
		MaxWindSpeed=MaxWind;
		MaxStatus=Status;
	if last.StormKey then do; /*Output at the last observation of a storm*/
		End_Date=Date;
		LengthofStorm=(End_Date - Start_Date)+1;
		Category=input(MaxWindSpeed,Stormcategory.);/*Convert a numeric value to a character value using a format*/
		output; 
	end;
	if last then call symputx('EndingYear',year(date));/*Create the last year macro variable*/
	format Start_Date End_Date date9.;
	drop Date Status MaxWind;
run;

/*************************************************************
Test macro variables
*************************************************************/
%put &=BeginningYear;
%put &=EndingYear;


/*************************************************************
2. Join ALL Storms with data.Storm_lookup to obtain the Status Description
and create the final SAS data set Storm_Answer
*************************************************************/
proc sql;
	create table Storm_Answer as
	select StormKey, Name, l.StatusDescription as MaxStatus, 
		MaxWindSpeed as MaxWind, Category, Start_Date, 
		End_Date, LengthofStorm
	from Storms as s inner join data.Storm_lookup as l
	on s.MaxStatus = l.Status
	order by Start_Date;
quit;


/*************************************************************
3. Report
*************************************************************/
options orientation=landscape nodate pageno=1 leftmargin=.1 rightmargin=.1;
ods pdf file="&path\FinalReport.pdf";
title 'Storms from &BeginningYear to &EndingYear';/*Add macro variables to the title*/
footnote "Report Generated on: &sysdate at &systime";/*Exact date and time report is run*/
proc print data=Storm_Answer noobs;
run;
title;
footnote;
ods pdf close;


/****************************************************************************************************
****************************END OF CHALLENGE, PLEASE READ THE COMMENTS BELOW*************************
****************************************************************************************************/

/************************************************************************
Validate your Results
*************************************************************************
- Please run the following procedures when you are complete to answer the 
validation questions in Section 1.2 of your document. After you run the code below,
check the results viewer for the answers.
*************************************************************************/
ods noproctitle;
title1 "Question 1";
title2 "How many total storms are in the final data set?";
proc sql;
	select count(*) as TotalStorms
	from storm_answer;
quit;

title1 "Question 2";
title2 "How many storms did not have a status description (if any)?";
proc sql;
	select count(*) as TotalMissing
	from storm_answer
	where MaxStatus is missing;
quit;

title1 "Question 3";
title2 "How many category 3 storms were in the final data set?";
proc freq data=storm_answer;
	tables Category;
run;

title1 "Question 4";
title2 "What is the total average wind speed?";
proc means data=storm_answer mean maxdec=1;
	var MaxWind;
run;
title;
ods proctitle;