/**************************************************************************************************
PROGRAM: SQL TSA Claims Case Study Solution
CREATED BY: Peter Styliadis
DATE CREATED: 5/2/2019
PROGRAM PURPOSE: Solution code to the SQL Essentials course case study. Goal of the case study is for learners
                 to following the directions and access/explore/prepare data using SQL. Once complete, they
                 will run the given to them from the analyze stage. That code in the analyze stage is to show them
                 some visuals using SAS to confirm the answers. They are out of scope of the SQL course. Comments 
                 are throughout the program. The code is broken up into the SAS Programming Process:
		            - Access, Explore, Prepare, Analyze, Export
			          * The analyze code will be given named AnalysisProgram.sas

FILE(S) USED:
	1. Cre8data.sas - Run the progrma to create the files for the case study. The SAS programs created will be located in the location
                      specified by the PATH macro variable given by the user. The tables will be created in the WORK library. The program
                      Will create the following:
      *SAS TABLES:
		a. work.ClaimsRaw - TSA claims for years 2013-2017
		b. work.Enplanement2017 - Enplanements for airports by year. Year is character here.
		c. work.boarding2013_2016 - Enplanements(called Boarding) for airports by year. Year is numeric.
      *SAS PROGRAMS:
        e. AnalysisProgram.sas - Program that analyzes the tables from this solution. Created in the PATH macro variable location.
	    f. StartProgram.sas - Program starter code to begin the case study.

FILE(S) CREATED:
	1. ClaimsCleaned - Cleans the data issues in work.claimsraw following requirements
	2. Claims_NoDup - Removes duplicate rows from the data (5 rows)
	3. TotalClaims - View that counts the number of claims for each airport by year
	4. TotalEnplanements - View that uses a set operator to concatenate the Enplanement2017 and Boarding2013_2016 tables
	4. ClaimsByAirport - Joins the TotalClaims and TotalEnplanements views to calculates percentage of claims for airport by year
	5. FinalResults.html - HTML results

FUTURE ENHANCEMENTS/ISSUES:
(Complete) 1. Probably need to limit the data by years. It's around 200,000 + rows and goes slow at times.
			- Maybe years 2010 - 2017? Last 5 years? Something like that to help speed up processing.
(Complete) 2. Finalize the Analyze stage. This can really be anything, I went a bit overboard with the visualizations. 
              Goal of this case study is for the learners to access/explore/prepare the data. The analyze stage will be 
              some cool SAS tricks and allow the learners to compare their data and make sure it matches. The learner 
              will complete the prepare data stage then run the code in the Analyze stage. They then can compare the 
              results of that stage with the graphs/results we provide in in the PDF. Feel free to change anything here.
(Complete) 3. Check all code and verify it is correct.
(Complete) 4. Check everything on University Edition, SAS On Demand, Virtual Lab, and Classroom for processing speed
	          and ensure everything works.
           5. Test in the virtual lab environment.
*************************************************************************************************
					Modification Log
DATE(MM/DD/YY)	USER		MODIFICATION
08/19/2019		Styliadis	Reduce data size, clean up visuals, include only basic visuals.
08/22/2019		Styliadis	Beginning finalizing the solution and results page.
09/05/2019		Styliadis	Boarding2013_2016 had 2012 data. The rows were removed.
							Added step to explore the boarding and enplanement tables
9/09/2019		Styliadis	TR Updates. Small changes, cleaning up " and ' to be consistent, comments.
9/16/2019		Styliadis	Clean up directions throughout code, cre8data program, final review.	
9/18/2019		Styliadis	Issue with default ODS output in SODA and UE. Used ODS _all_ close to fix problem. Runs in both interfaces.
							Issues is that Studio tries to create the PDF and WORD document. Causes a lot of warnings. Also had a warning
							because another font was chosen for ODS text. Removed that and left the default.
9/20/2019		Styliadis	All data is now in the WORK library. Made necessary change to reflect that all input/output tables need to be in WORK.
9/23/2019		Styliadis	Uploaded the SQL Case Study solution to the ELP.	
*************************************************************************************************/

*************************************************************************************;
*  The following is the step by step solution for the Intermediate/Beginner Sections*; 
*************************************************************************************;

*******************;
*ACCESS DATA      *;
*******************;
/*1. Specify the location of the AnalysisProgram.sas. This is also the location for the FinalReport.html output.
     All tables are located in the WORK library for this case study.*/
%let path=/*Enter directory*/;


*******************;
*EXPLORE DATA     *;
*******************;
/*2. Preview the first 10 rows and descriptor portion of the following tables*/
*********;
* NOTES *; 
******************************************************************************************************************;
* a. Year is character in the enplanement table, numeric in the boarding table.                                  *;
* b. The number of passengers is called enplanement in the enplanement table, and boarding in the boarding table *;
******************************************************************************************************************;
proc sql outobs=10;
title "Table: CLAIMSRAW";
describe table work.claimsraw;
select * 
    from work.claimsraw;
title "Table: ENPLANEMENT2017";
describe table work.enplanement2017;
select * 
    from work.enplanement2017;
title "Table: BOARDING2013_2016";
describe table work.boarding2013_2016;
select * 
    from work.boarding2013_2016;
title;
quit;


/*3. Count the number of nonmissing values in the following:*/
/* TotalRow  TotalAirportCode  TotalClaimSite TotalDisposition  TotalClaimType TotalDateReceived  TotalIncidentDate
   42,528    42,179            42,295         33,469            42,303         42,528             42,528             */
title "Total Nonmissing Rows";
proc sql;
select count(*) as TotalRow format=comma16.,
       count(Airport_Code) as TotalAirportCode format=comma16.,
       count(Claim_Site) as TotalClaimSite format=comma16.,
       count(Disposition) as TotalDisposition format=comma16.,
       count(Claim_Type) as TotalClaimType format=comma16.,
       count(Date_Received) as TotalDateReceived format=comma16.,
	  count(Incident_Date) as TotalIncidentDate format=comma16.
    from work.claimsraw;
quit;
title;


/*4. View percentage of missing values in the columns*/
/*Create a macro variable with the total number of rows - 42,528*/
proc sql noprint;
select count(*)
    into :TotalRows trimmed
    from work.claimsraw;
quit;
%put &=TotalRows;

/*PctAirportCode PctClaimSite PctDisposition PctClaimType PctDateReceived PctIncidentDate 
  0.82%          0.55%        21.3%          0.53%        0.00%           0.00%*/
title "Percentage of Missing Rows";
proc sql;
select 1-(count(Airport_Code)/&TotalRows) as PctAirportCode 
                                             format=percent7.2, 
       1-(count(Claim_Site)/&TotalRows) as PctClaimSite 
                                             format=percent7.2,
       1-(count(Disposition)/&TotalRows) as PctDisposition 
                                            format=percent7.2,
       1-(count(Claim_Type)/&TotalRows) as PctClaimType 
                                           format=percent7.2,
       1-(count(Date_Received)/&TotalRows) as PctDateReceived 
                                              format=percent7.2,
       1-(count(Incident_Date)/&TotalRows) as PctIncidentDate 
                                              format=percent7.2
    from work.claimsraw;
quit;
title;


/*5. View the distinct values and frequencies*/
title "Column Distinct Values";
proc sql number;
/*Claim_Site*/
title2 "Column: Claim_Site";
select distinct Claim_Site
    from work.claimsraw
    order by Claim_Site;
/*Disposition*/
title2 "Column: Disposition";
select distinct Disposition
    from work.claimsraw
    order by Disposition;
/*Claim_Type*/
title2 "Column: Claim_Type"; 
select distinct Claim_Type
    from work.claimsraw
    order by Claim_Type;
/*Date_Received*/
title2 "Column: Date_Received";
select distinct put(Date_Received, year4.) as Date_Received
    from work.claimsraw
    order by Date_Received;
/*Incident_Date*/
title2 "Column: Incident_Date";
select distinct put(Incident_Date, year4.) as Incident_Date
    from work.claimsraw
    order by Incident_Date;
quit;
title;

/*****************/
/*USING PROC FREQ*/
/*****************/
/*title "PROC FREQ Distinct Values and Frequencies";*/
/*proc freq data=work.claimsraw;*/
/*	tables Claim_Site Disposition Claim_Type Date_Received Incident_Date/nocum nopercent;*/
/*	format Date_Received Incident_Date year4.;*/
/*run;*/
/*title;*/



/*When using the PUT function to create a new column the calculated keyword is needed in the GROUP BY clause*/
/************************RANDOM CALCULATED test in the GROUP BY clause, IGNORE******************************/
/*/*The above causes issues without calculated*/*/
/*proc sql;*/
/*select put(Incident_Date, year4.) as Incident_Date, */
/*       count(*) as Frequency*/
/*   from work.claimsraw*/
/*   group by Incident_Date*/
/*   order by Incident_Date;*/
/*quit;*/
/**/
/*proc sql;*/
/*select put(Incident_Date, year4.) as Incident_Date, */
/*       count(*) as Frequency*/
/*   from work.claimsraw*/
/*   group by calculated Incident_Date*/
/*   order by Incident_Date;*/
/*quit;*/
/************************RANDOM CALCULATED test in the GROUP BY clause, IGNORE******************************/


/*6. Count the number of rows where Incident_Date occurs AFTER Date_Recieved - 65 rows*/;
title "Number of Claims where Incident Date Occurred After the Date Received";
proc sql;
select count(*) label="Date Needs Review"
    from work.claimsraw
    where Incident_Date > Date_Received;
quit;
title;


/*7. Run a query to view all rows and columns where Incident_Date occurs AFTER Date_Received. 
What assumption can you make about the dates in your results?*/
proc sql;
select Claim_Number, Date_Received, Incident_Date 
    from work.claimsraw
    where Incident_Date > Date_Received;
quit;


*******************;
*PREPARE DATA     *;
*******************;
/*8. Create a new table named Claims_NoDup that removes entirely duplicated rows. 
     A duplicate claim exists if every value is duplicated.*/
/*
NOTE: The data set work.CLAIMS_NODUP has 42524 observations and 13 variables.
*/
proc sql;
create table Claims_NoDup as 
select distinct * 
    from work.claimsraw;
quit;


/*****************/
/*USING PROC SORT*/
/*****************/
/*proc sort data=work.claimsraw */
/*          out=work.Claims_NoDup */
/*          dupout=DuplicateRows nodupkey;*/
/*	by _all_;*/
/*run;*/


/*9. Prepare Data*/
proc sql;
create table work.Claims_Cleaned as
select 
/*a. Select the Claim_Number, Incident Date columns.*/
       Claim_Number label="Claim Number",
       Incident_Date format=date9. label="Incident Date",
/*b. Fix the 65 date issues you identified earlier by replacing the year 2017 with 2018 in the Date_Received column.*/
	   case 
		    when Incident_Date > Date_Received then intnx("year",Date_Received,1,"sameday")
			else Date_Received
	   end as Date_Received label="Date Received" format=date9.,
/*c. Select the Airport_Name column*/
	   Airport_Name label="Airport Name",
/*d. Replace missing values in the Airport_Code column with the value Unknown.*/
       case 
            when Airport_Code is null then "Unknown"
	        else Airport_Code
	   end as Airport_Code label="Airport Code",
/*e1. Clean the Claim_Type column.*/
       case 
           when Claim_Type is null then "Unknown"
		   else scan(Claim_Type,1,"/","r") /*If I find a '/', scan and retrieve the first word*/
       end as Claim_Type label="Claim Type",
/*e2. Clean the Claim_Site column.*/
       case 
           when Claim_Site is null then "Unknown" 
           else Claim_Site 
       end as Claim_Site label="Claim Site",
/*e3. Clean the Disposition column.*/
       case 
           when Disposition is null then "Unknown"
           when Disposition="Closed: Canceled" then "Closed:Canceled"
           when Disposition="losed: Contractor Claim" then "Closed:Contractor Claim" 
           else Disposition
       end as Disposition,
/*f. Select the Close_Amount column.*/
       Close_Amount format=Dollar20.2 label="Close Amount", 
/*g. Select the State column and upper case all values.*/
       upcase(State) as State,
/*h. Select the StateName, County and City column. Proper case all values.*/
	   propcase(StateName) as StateName label="State Name",
       propcase(County) as County,
       propcase(City) as City
	from Claims_NoDup
/*i. Remove all rows where year of Incident_Date occurs after 2017. */
    where year(Incident_Date) <= 2017
/*j. Order the results by Airport_Code, Incident_Date.*/
    order by Airport_Code, Incident_Date;
quit;


/***************Validate the Prepared Data***************/
proc sql;
select count(*) as TotalRows
    from work.claims_cleaned;
quit;

title "SQL Distinct Values Validation";
proc sql;
/*Claim_Site*/
title2 "Column: Claim_Site";
select distinct Claim_Site
    from work.claims_cleaned
    order by Claim_Site;
/*Disposition*/
title2 "Column: Disposition";
select distinct Disposition
    from work.claims_cleaned
    order by Disposition;
/*Claim_Type*/
title2 "Column: Claim_Type"; 
select distinct Claim_Type
    from work.claims_cleaned
    order by Claim_Type;
/*Date_Received*/
title2 "Column: Date_Received";
select distinct put(Date_Received, year4.) as Date_Received
    from work.claims_cleaned
    order by Date_Received;
/*Incident_Date*/
title2 "Column: Incident_Date";
select distinct put(Incident_Date, year4.) as Incident_Date
    from work.claims_cleaned
    order by Incident_Date;
quit;
title;
/***************End Validation****************************************/




/*10. Use the work.Claims_Cleaned table to create a view named TotalClaims to count the number of claims for each Airport_Code and Year.*/
/*NOTE: View work.TOTALCLAIMS created, with 1491 rows and 5 columns.*/
proc sql;
create view TotalClaims as
select Airport_Code, Airport_Name, City, State, 
       year(Incident_date) as Year, 
       count(*) as TotalClaims
    from work.claims_cleaned
    group by Airport_Code, Airport_Name, City, State, calculated Year
    order by Airport_Code, Year;
quit;


/*11. Create a view name TotalEnplanements by using the OUTER UNION set operator to concatenate the enplanement2017 and boarding2013_2016 tables.*/
proc sql;
create view TotalEnplanements as
select LocID, Enplanement, input(Year,4.) as Year
    from work.enplanement2017 
    outer union corr
select LocID, Boarding as Enplanement, Year
    from work.boarding2013_2016
    order by Year, LocID;
quit;

/*12. Create a table named work.ClaimsByAirport by joining the TotalClaims and TotalEnplanements views.*/
proc sql;
create table work.ClaimsByAirport as
select t.Airport_Code,t.Airport_Name, t.City, t.State, 
       t.Year, t.TotalClaims, e.Enplanement, 
       TotalClaims/Enplanement as PctClaims format=percent10.4
    from TotalClaims as t inner join
	     TotalEnplanements as e
	on t.Airport_Code = e.LocID and 
       t.Year = e.Year
	order by Airport_Code, Year;
quit;



**************************************************************************;
*  SOLVE STEPS 10-12 USING ONE QUERY WITH IN-LINE VIEWS                  *; 
**************************************************************************;
/*
proc sql;
create table work.ClaimsByAirport as
select t.Airport_Code,t.Airport_Name, t.City, t.State, 
       t.Year, t.TotalClaims, e.Enplanement, 
       TotalClaims/Enplanement as PctClaims format=percent10.4
    from (select Airport_Code, Airport_Name, City, State, 
                 year(Incident_date) as Year, 
                 count(*) as TotalClaims
              from work.claims_cleaned
              group by Airport_Code, Airport_Name, City, State, calculated Year) as t inner join
	     (select LocID, Enplanement, input(Year,4.) as Year
              from work.enplanement2017 
              outer union corr
          select LocID, Boarding as Enplanement, Year
              from work.boarding2013_2016) as e
	on t.Airport_Code = e.LocID and 
       t.Year = e.Year
	order by Airport_Code, Year;
quit;
*/
**************************************************************************;


*******************;
*EXPORT & ANALYSIS*;
*******************;
/*Run the following when complete. Calls the AnalysisProgram.sas to create the FinalResults.html in the location of the PATH macro variable.*/
%include "&path/AnalysisProgram.sas";