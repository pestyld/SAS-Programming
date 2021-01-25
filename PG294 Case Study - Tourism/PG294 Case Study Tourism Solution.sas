/**************************************************************************************************
PROGRAM: PG294 TSA Claims Case Study Answer
CREATED BY: Peter Styliadis
DATE CREATED:8/05/2018
PROGRAM PURPOSE: 
	1. The program is the PG294 case study answer.
 
FILE(S) USED:
	1. cs_tourism.sas - Creates the tables for the case study.
		- work.tourism: Table to be restructored and cleaned
		- work.country_info: Country lookup table using continent and country name.
FILE(S) CREATED:
	1. cleaned_tourism - Cleans and prepares the work.tourism table
	2. country_sorted - Sort the country_info table. Rename the columns of the original table. Prep for MERGE.
	3. final_tourism - Final table that contains all matches from the tourism and country_info table.
	4. NoCountryFound - Table with countries that were not found in the country_info table. 

FUTURE ENHANCEMENTS/ISSUES:
	1. Create a bonus using the final data? Either bring in FAA data or visualizations?
	2. Separate the dollar and number rows in the final data. The column contains two types of values. Taken out from original
	   to save time.
*************************************************************************************************
					Modification Log
DATE(MM/DD/YY)	USER		MODIFICATION
7/22/2018		Styliadis	First draft of the answer
8/01/2018		Styliadis	Clean up and adjustments. Nothing major.
8/09/2018		Styliadis	Additional validation, cleaning.
9/17/2019 		Styliadis	Update comments, thorough public review, post on repo.
10/01/2019		Styliadis	Final clean up. Post on ELP
*************************************************************************************************/


/******************************************
Step 1 - Access
*******************************************/
options validvarname=v7;

/*Tables are in the WORK library by default. Run the cs_tourism.sas program to create the tables.*/
%let path=/*Location of cs_tourism.sas*/;
%include "&path\cs_tourism.sas";

/*Make WORK tables permanent*/
libname PG2_Case "&path";
data pg2_case.tourism;
	set work.tourism;
run;

data pg2_case.country_info;
	set work.country_info;
run;



/******************************************
Step 2 - Explore
*******************************************/
/*EXPLORE TOURISM DATA*/
title "View Contents and Preview Excel Tourist Data";
proc contents data=PG2_Case.Tourism;
run;
proc print data=PG2_Case.Tourism (obs=10);
run;
proc freq data=PG2_Case.Tourism;
	tables country series;
run;


/*EXPLORE COUNTRY ATTRIBUTES*/
title "View Contents and Preview World Attributes";
proc contents data=PG2_Case.country_info;
run;
title;
proc print data=PG2_Case.country_info (obs=10);
run;

proc sql;
	select distinct continent
	from PG2_Case.country_info;
quit;

/******************************************
Step 3 - Prepare Data
*******************************************/
data cleaned_tourism;
/*Put variables in specific order*/
	length Country_Name $300 Tourism_Type $20 ConversionType $20 Category $150;
/*Input table*/
	set PG2_Case.Tourism (drop=_1995-_2013);
/*Retain Country Name and Tourism_Type to create new columns. Initialize them to blank*/
	retain Country_Name "" Tourism_Type "";
/*Create new column for country if you find a number in column A*/
	if A ne . then Country_Name=Country;
/*Create new column for inbound or outbound*/
	if lowcase(Country) = "inbound tourism" then Tourism_Type = "Inbound tourism";
		else if lowcase(Country) = 'outbound tourism' then Tourism_Type = "Outbound tourism";
/*================================================================
Subsetting IF to remove country value row AND Inbound/Outbound row
=================================================================*/
if Country_Name ne Country and Country ne Tourism_Type;
/*****************************************************/
/*Upcase the Series columns and set .. to ""*/
	Series=upcase(series);
	if Series = ".." then Series = "";
/*Determine conversion type*/
	ConversionType=strip(scan(country,-1,' '));
/*Fix the double missing problem for Years*/
	if _2014 = '..' then _2014 = '.';
/*Convert abbreviated values to thousands or millions. Use excplicit conversion*/
	/*Multiple all by a 1,000,000*/
	if ConversionType = 'Mn' then do;
		if input(_2014,16.) ne . then Y2014 = input(_2014,16.) * 1000000;
			else Y2014 = .;
	/*Clean up category for currency*/
		Category=cat(scan(country,1,'-','r')," - US$");
	end;
	/*Multiple all by a 1,000*/
	else if ConversionType = 'Thousands' then do;
		if input(_2014,16.) ne . then Y2014 = input(_2014,16.) * 1000;
			else Y2014 = .;
	/*Clean up category for currency*/
		Category=scan(country,1,'-','r');
	end;
	/*Set all to missing if conversion type is unknown*/
	format Y2014 comma25.;
	drop A ConversionType Country _2014; *_2010-_2014 ConversionType Country TotalReported;
run; 


/*****************************DATA PREP VALIDATION*****************************/
/*Final clean data count*/
title "Count Total Countries: 218";
proc sql;
	select count(distinct country_name) as Total_Countries
	from cleaned_tourism;
quit;
title;

/*View distinct value counts*/
proc freq data=cleaned_tourism nlevels;
	tables Category Series Tourism_Type;
	tables Country_Name /noprint;
run;

proc means data=cleaned_tourism mean;
	var Y:;
run;
/*Preview new data*/
proc print data=cleaned_tourism (obs=10);
run;
/*****************************END DATA PREP VALIDATION*****************************/




/******************************************/
/****************MERGE DATA****************/
/******************************************/

proc format;
	value continents
		1 = "North America"
		2 = "South America"
		3 = "Europe"
		4 = "Africa"
		5 = "Asia"
		6 = "Oceania"
		7 = "Antarctica";
run;


proc sort data=pg2_case.country_info(rename=(Country=Country_Name)) 
          out=Country_Sorted;
	by Country_Name;
run;

/******************************************
Step 4 - Create Final Tables
*******************************************/
data 	Final_Tourism
		NoCountryFound(keep=Country_Name); 
	merge cleaned_tourism(in=t) Country_Sorted(in=c);
	by country_name;
	if t=1 and c=1 then output Final_Tourism;
	if (t=1 and c=0) and first.country_name then output NoCountryFound;
	format continent continents.;
run;




/*****************************FINAL DATA VALIDATION*****************************/
title "Countries in the tourism table without a match";
proc print data=nocountryfound noobs;
run;
title;

title "Frequency values and levels of categorical variables";
proc freq data=final_tourism nlevels;
	tables Category Series Tourism_Type Continent /nopercent nocum;
run;
title;

title "Mean of year values";
proc means data=final_tourism min mean max maxdec=0;
	var y2014;
run;
title;
/*****************************FINAL DATA VALIDATION*****************************/


/*Drop tables*/
proc sql;
drop table pg2_case.tourism;
drop table pg2_case.country_info;
quit;

/*Clear library*/
libname PG2_Case clear;