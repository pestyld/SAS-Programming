/**************************************************************************************************
PROGRAM: PG194 TSA Claims Case Study Answer
CREATED BY: Peter Styliadis
DATE CREATED:7/20/2018
PROGRAM PURPOSE: 
	1. The program is the PG194 case study answer.
 
FILE(S) USED:
	1. TSAClaims2002_2017.csv - Combined all TSA Data from 2002 - 2017 and joined with
	FAA Airpot Facilities Data. The 2016 & 2017 TSA data was in PDF format, so there are 
	a few issues in it. The Facilities Data has the FAA LocationID not the IATA. 

	From Wikipedia (https://en.wikipedia.org/wiki/Location_identifier)
	"In the United States, the IATA identifier usually equals the FAA identifier, but 
	this is not always the case. A prominent example is Sawyer International Airport, 
	Michigan, which uses the FAA identifier SAW and the IATA identifier MQT."

FILE(S) CREATED:
	1. tsa.ClaimsImport - SAS table from CSV import
	2. tsa.Claims_NoDups - All entirely duplciated rows removed
	3. tsa.Claims_Cleaned - Fully prepared data
	4. ClaimsReports<StateName>.pdf - A PDF report based on a macro variable supplied for the State.

FUTURE ENHANCEMENTS/ISSUES:
	1. Create a bonus using the final data? Either bring in FAA data or visualizations.
*************************************************************************************************
					Modification Log
DATE(MM/DD/YY)	USER		MODIFICATION
7/22/2018		Styliadis	First draft of the answer
8/01/2018		Styliadis	Clean up and adjustments. Nothing major.
8/09/2018		Styliadis	Additional validation, cleaning.
9/17/2019 		Styliadis	Update comments, public review, post on repo
10/2/2019		Styliadis	Post on ELP
*************************************************************************************************/


*******************;
*ACCESS DATA      *;
*******************;
%let path=/*Writable location*/;
libname tsa "&path";

/*Import Results: The data set TSA.CLAIMSIMPORT has 220855 observations and 14 variables.*/
/*Takes a minute or two since data is being fully scanned using GUESSINGROWS=MAX*/
options validvarname=v7;
proc import datafile="&path/TSAClaims2002_2017.csv"
			dbms=csv
			out=tsa.ClaimsImport
			replace;
	guessingrows=max;
run;


*******************;
*EXPLORE DATA     *;
*******************;
/*View descriptor portion of the data*/
/*Rows: 220,855, Columns:14*/
proc print data=tsa.ClaimsImport (obs=20);
run;
proc contents data=tsa.ClaimsImport varnum;
run;

/*Explore Categories and Date Years*/
ods graphics on;
proc freq data=tsa.ClaimsImport;
	tables Claim_Site 
		   Disposition 
		   Claim_Type /nocum nopercent; /*Categories*/
	tables Date_Received 
		   Incident_Date /plots=freqplot nocum nopercent; /*Dates. Format dates as years*/
	format Date_Received Incident_Date year4.;
run;


/*---Fix Categories Plan---*/
/*1. Claim_Site, Claim_Type, Disposition = Change '-' to Unknown*/
/*2. Claim_Type = Change any values iwth a / and two categories to the first category*/
/*3. Disposition = 
		Change 'Closed: Canceled' to 'Closed:Canceled'
		Change 'losed: Contractor Claim' to 'Closed:Contractor Claim*/

/*---Explore Date Issues Further---*/

/*Why are dates after 2017 and prior to 2002 in Incident_Date?*/
proc print data=tsa.ClaimsImport;
	where 2001<= year(Incident_Date) >=2018;
	format Incident_Date Date_Received date9.;
run;

/*Why are dates after 2017 and prior to 2002 in Date_Received?*/
proc print data=tsa.ClaimsImport;
	where year(date_received) >=2018 or year(date_received) <=2001;
	format Incident_Date Date_Received date9.;
run;

/*View dates where Incident_Date comes after Date_Received. This should not happen.*/
proc print data=tsa.ClaimsImport;
	where Date_Received < Incident_Date;
	format Incident_Date Date_Received date9.;
run;


/*---Fix Dates Plan---*/
/*Our plan is to create a new column that is named Date_Issues, will a value of "Needs Review".
This will consist of all dates that:
	a. Having a missing value for Incident_Date or Date_Received
	b. Have a Incident_Date after the Date_Received
	c. Incident_Dates or Date_Received after 2018*/


/*Duplicate claim numbers have different values in columns. We will not clean these in this case study*/
/*proc sort data=tsa.Claims_NoDups  out=test dupout=DupClaimNumbers  nodupkey ;*/
/*	by Claim_Number;*/
/*run;*/
/*proc print data=tsa.Claims_NoDups ;*/
/*	where claim_number = '2014121819294';*/
/*	format Incident_Date Date_Received Date9.;*/
/*run;*/


*******************;
*PREPARE DATA     *;
*******************;
/*5 Remove entirely duplicated observations. Some claim_numbers are duplicates but different values in other columns. Consider those valid*/
proc sort data=tsa.ClaimsImport 
		out=tsa.Claims_NoDups 
		nodupkey;
	 by _all_;
run;

/*Sort data by Incident_Date*/
proc sort data=tsa.Claims_NoDups;
	by Incident_Date;
run;

/*Create new table*/
data tsa.Claims_Cleaned;
	set tsa.Claims_NoDups;
	if Claim_Site in ('-','') then Claim_Site="Unknown";
	if Claim_Type in ('-','') then Claim_Type="Unknown";
		else if Claim_Type = 'Passenger Property Loss/Personal Injur' then Claim_Type='Passenger Property Loss';
		else if Claim_Type = 'Passenger Property Loss/Personal Injury' then Claim_Type='Passenger Property Loss';
		else if Claim_Type = 'Property Damage/Personal Injury' then Claim_Type='Property Damage';
	if 	Disposition in ('-',"") then Disposition = 'Unknown';
		else if disposition = 'losed: Contractor Claim' then Disposition = 'Closed:Contractor Claim';
		else if Disposition = 'Closed: Canceled' then Disposition = 'Closed:Canceled';
	if (Incident_Date > Date_Received or /*Any dates with issues (missing, outside the range, incident after date received*/
			Incident_Date = . or
			Date_Received = . or
			year(Incident_Date) < 2002 or
			year(Incident_Date) > 2017 or
			year(Date_Received) < 2002 or
			year(Date_Received) > 2017) 
		then Date_Issues="Needs Review"; /*Create a new column to indicate date issues*/
	State=upcase(state);
	StateName=propcase(StateName);
	format Incident_Date Date_Received date9. Close_Amount Dollar20.2;
	label Airport_Code="Airport Code"
		  Airport_Name="Aiport Name"
		  Claim_Number="Claim Number"
		  Claim_Site="Claim Site"
		  Claim_Type="Claim Type"
		  Close_Amount="Close Amount"
		  Date_Issues="Date Issues"
		  Date_Received="Date Received"
		  Incident_Date="Incident Date"
		  Item_Category="Item Category";
	drop County City;
run;

/*Validate Prepare Data Stage*/
proc freq data=TSA.Claims_Cleaned;
	tables Date_Issues Claim_Site Claim_Type Disposition StateName /nocum nopercent;
	tables Incident_Date Date_Received /plots=freqplot nocum nopercent;
	format Incident_Date Date_Received year4.;
run;


*******************;
*EXPORT & ANALYSIS*;
*******************;
/*Macro Variables*/
%let outpath=&path;
%let StateName=Hawaii;

/*output to PDF*/
ods pdf file="&outpath\ClaimsReports&statename..pdf" style=Meadow pdftoc=1;

ods proctitle;
*ods proclabel "Overall Date Issues";
title "Overall Date Issues in the Data";
/*1. Overall Date issues in the data*/
proc freq data=TSA.Claims_Cleaned;
	table Date_Issues /missing nocum nopercent ;
run;
title;

ods proclabel "Overall Claims by Year";
ods graphics on;
title "Overall Claims by Year";
/*2. Overall claims by year*/
proc freq data=TSA.Claims_Cleaned;
	table Incident_Date /nocum nopercent plots=freqplot;
	format Incident_Date year4.;
	where Date_Issues is null;
run;
title;

/*SPECIFIC STATE ANALYSIS*/
ods proclabel "&StateName Claims Overview";
title "&StateName Claim Types, Claim Sites and Disposition";
proc freq data=TSA.Claims_Cleaned order=freq;
	table Claim_Type Claim_Site / nocum nopercent;
	table Disposition / nocum nopercent;
	where StateName="&StateName" and Date_Issues is null;
run;
title;

ods proclabel "&StateName Close Amount Statistics";
title "Close_Amount Statistics for &StateName";
proc means data=TSA.Claims_Cleaned mean min max sum maxdec=0;
	var Close_Amount;
	where StateName="&StateName" and Date_Issues is null;
run;
title;

ods pdf close;