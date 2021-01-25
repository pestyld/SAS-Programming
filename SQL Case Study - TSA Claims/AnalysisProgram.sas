*******************************************************************************************************;
*                                      ANALYZE AND EXPORT DATA                                        *;
* NOTE: Do not edit the code below. Run the program after all data preparation has been complete.     *;
* NOTE: The Claims_Cleaned and ClaimsByAirport tables must reside in the WORK library.                *;
* NOTE: The code below will create a report in the location of the PATH macro variable you set in the *;
*       StarterProgram.sas program. The report will be named FinalReport.html.                        *;
*******************************************************************************************************;


/******************************************BEGIN HTML REPORT************************************************/

/*Location of the input tables*/
%let inputLib=work;

/*Close all default ODS output*/
ods _all_ close;

/*Output the HTML file to this location. Name the file 'FinalReport.html'*/
ods html5 file="FinalReport.html" path="&path";

/*Set up the HTML grid*/
ods layout gridded columns=3 rows=4 column_gutter=.25in row_gutter=.25in;

/*Set up the options*/
ods escapechar='^'; /*Used as an escape character for ODS TEXT*/
ods noproctitle; /*Remove all proctitles from the output*/
title;footnote; /*Clear any previously set titles or footnotes*/

/*Set colors and sizes for titles and text in the report*/
%let MainTitleColor=cx081d58;
%let MainTitleSize=28pt;
%let TitleColor=cx081d58;
%let TitleSize=16pt;
%let EmphasisNumbers=cx1d91c0;
%let EmphasisNumbersSize=26pt;
%let EmphasisText=14pt;


************************************************;
*Row 1                                         *;
************************************************;
ods region row=1 column=1 column_span=3;

/*Add the report's main title*/
ods text="^{style[textalign=c fontsize=&MainTitleSize color=&MainTitleColor]TSA Claims Case Study Check}";


************************************************;
*Row 2                                         *;
************************************************;
**************;
*COLUMN 1 & 2*;
**************;
ods region row=2 column=1 column_span=2;

/*Create a new table with the count of overall claims by year using the work.claims_cleaned table*/
proc sql;
create table TotalClaimsByYear as
select put(Incident_Date, year4.) as Year,
       count(*) as TotalClaims format=comma16.
    from &inputlib..Claims_Cleaned
    group by calculated Year
    order by Year;
quit;

/*Visualize the newly created table in a bar chart*/
ods graphics on /width=11in height=4.5in imagemap=on;
title h=&TitleSize color=&TitleColor "Total Claims by Year";
footnote "NOTE: Using the Claims Cleaned Table";
proc sgplot data=TotalClaimsByYear;
   vbar Year / response=TotalClaims colorresponse=TotalClaims
                dataskin=pressed
                barwidth=.8
                datalabel
                colormodel=(cxedf8b1 cx7fcdbb cx2c7fb8)
                tip=(Year TotalClaims);
   gradlegend / notitle;
   yaxis display=(noline noticks) grid label="Total Claims Filed";
quit;
title;
footnote;

**************;
*COLUMN 3    *;
**************;
ods region row=2 column=3;

/*Store the total enplanements value in a macro variable using the work.ClaimsByAirport table*/
proc sql noprint;
select sum(Enplanement) as TotalDateIssues format=comma16.
    into :TotalEnplanements trimmed
   from &inputlib..ClaimsByAirport;
quit;
ods text="^{style[just=c fontsize=&EmphasisText]Total Enplanements}";
ods text="^{style[just=r fontsize=&EmphasisNumbersSize color=&EmphasisNumbers]&TotalEnplanements}";

/*Store the total claims filed value in a macro variable*/
proc sql noprint;
select count(*) as TotalClaims format=comma16.
    into :TotalClaims trimmed
   from &inputlib..Claims_Cleaned;
quit;
ods text="^{style[textalign=c fontsize=&EmphasisText color=&MainTitleColor]Total Claims Filed}";
ods text="^{style[textalign=c fontsize=&EmphasisNumbersSize color=&EmphasisNumbers]&TotalClaims}";

/*Store the percentage of claims filed value in a macro variable*/
     /*Step 1. Remove commas from the macro variables*/
%let TotalEnplanementsNum=%sysfunc(compress("&TotalEnplanements",","));
%let TotalClaimsNum=%sysfunc(compress("&TotalClaims",","));
     /*Step 2. Calculate the percentage of total claims by enplanements and store in a macro variable*/
data _null_;
   Total=&TotalClaimsNum/&TotalEnplanementsNum;
   PercentValue=put(Total,percent8.4);
   call symputx('PctClaimsTotal',PercentValue);
run;
ods text="^{style[textalign=c fontsize=&EmphasisText color=&MainTitleColor]Percentage of Claims Filed by Enplanements}";
ods text="^{style[textalign=c fontsize=&EmphasisNumbersSize color=&EmphasisNumbers]&PctClaimsTotal}";

/*Store the average days of claim value in a macro variable*/
proc sql noprint;
select sum(Date_Received-Incident_Date)/count(*) as AvgDays format=5.1
    into :AvgDays
    from &inputlib..claims_cleaned;
quit;
ods text="^{style[textalign=c fontsize=&EmphasisText color=&MainTitleColor]Average Time (in days) to File a Claim}";
ods text="^{style[textalign=c fontsize=&EmphasisNumbersSize color=&EmphasisNumbers]&AvgDays}";

/*Store average days of claim value in a macro variable*/
proc sql noprint;
select count(*) as TotalUnknownAirports format=comma5.
    into :TotalUnknownAirports
    from &inputlib..claims_cleaned
   where Airport_Code = "Unknown";
quit;
ods text="^{style[textalign=c fontsize=&EmphasisText color=&MainTitleColor]Total Unknown Airports}";
ods text="^{style[textalign=c fontsize=&EmphasisNumbersSize color=&EmphasisNumbers]&TotalUnknownAirports}";


************************************************;
*Row 3                                         *;
************************************************;
**************;
*COLUMN 1    *;
**************;
ods region row=3 column=1;

/*Visualize the frequency of Claim_Type*/
ods graphics on /width=5.5in height=4in;
title h=&TitleSize color=&TitleColor "Types of Claims Filed (Claim_Type)";
proc sgplot data=&inputlib..claims_Cleaned;
   hbar Claim_Type / categoryorder=respdesc datalabel fillattrs=(color= cx7fcdbb);
   yaxis display=(nolabel noticks noline)
          valueattrs=(color=gray33 size=9pt);
    xaxis grid labelattrs=(color=gray33 size=9pt)
          valueattrs=(color=gray33 size=9pt);
run;
title;

**************;
*COLUMN 2    *;
**************;
ods region row=3 column=2;

/*Visualize the frequency of Disposition*/
ods graphics on /width=5.5in height=4in ;
title h=&TitleSize color=&TitleColor "Final Result of a Claim (Disposition)";
proc sgplot data=&inputlib..claims_Cleaned;
   hbar Disposition / categoryorder=respdesc
                      datalabel
                      fillattrs=(color=cxedf8b1);
   yaxis display=(nolabel noticks noline)
          valueattrs=(color=gray33 size=9pt);
    xaxis grid labelattrs=(color=gray33 size=9pt)
          valueattrs=(color=gray33 size=9pt);
run;
title;

**************;
*COLUMN 3    *;
**************;
ods region row=3 column=3;

/*Visualize the frequency of Claim_Site*/
ods graphics on /width=5.5in height=4in;
title h=&TitleSize color=&TitleColor "Location Site of a Claim (Claim_Site)";
proc sgplot data=&inputlib..Claims_Cleaned;
   hbar Claim_Site / categoryorder=respdesc datalabel fillattrs=(color=cx2c7fb8);
   yaxis display=(nolabel noticks noline)
          valueattrs=(color=gray33 size=9pt);
    xaxis grid labelattrs=(color=gray33 size=9pt)
          valueattrs=(color=gray33 size=9pt);
run;


************************************************;
*Row 4                                         *;
************************************************;
**************;
*COLUMN 1 & 2*;
**************;
ods region row=4 column=1 column_span=2;

/*Create a tablet view the top 20 airports by PctClaims with over 10,000,000 passengers*/
proc sql outobs=20;
create table top20airports as
select *
   from &inputlib..ClaimsByAirport
   where Enplanement > 10000000
   order by PctClaims desc;
quit;

/*Visualize the top20airports table*/
ods graphics on /width=12in height=4in;
title1 h=&TitleSize color=&TitleColor "Top 20 Airports by Highest Percetage of Claims Filed";
title2 h=&TitleSize color=&TitleColor "For Airports With More Than 10 Million Passengers";
proc sgplot data=top20airports;
   bubble x=Enplanement y=PctClaims size=TotalClaims / group=Airport_Code
                                                       datalabel=Airport_Code
                                                       transparency=.3
                                                       tip=(Airport_Name PctClaims Enplanement TotalClaims State)
                                                       datalabelattrs=(size=8 weight=bold);
   inset "Bubble size represents total number of claims" / position=topleft
                                                           textattrs=(size=8);
   yaxis grid label="Percentage of Claims Per Passengers";
   xaxis grid label="Total Passengers";
run;
title;

**************;
*COLUMN 3    *;
**************;
ods region row=4 column=3;

/*Store values of the airport with the highest PctClaims for airports over 10,000,000 passengers.*/
proc sql noprint;
select Airport_Name, Year, PctClaims format=percent8.4
    into :Name trimmed, :Year trimmed, :PctClaims trimmed
    from top20airports(obs=1);
quit;

ods text=";
ods text=";
/*Airport Name*/
ods text="^{style[textalign=c fontsize=&EmphasisText color=&MainTitleColor]Airport with the Highest Percentage of Claims}";
ods text="^{style[textalign=c fontsize=&EmphasisNumbersSize color=&EmphasisNumbers]&Name}";
/*Year*/
ods text="^{style[textalign=c fontsize=&EmphasisText color=&MainTitleColor]Year}";
ods text="^{style[textalign=c fontsize=&EmphasisNumbersSize color=&EmphasisNumbers]&Year}";
/*PctClaims*/
ods text="^{style[textalign=c fontsize=&EmphasisText color=&MainTitleColor]Percentage of Claims Per Passengers}";
ods text="^{style[textalign=c fontsize=&EmphasisNumbersSize color=&EmphasisNumbers]&PctClaims}";

/*End gridded layout*/
ods layout end;

/*Close output to HTML5*/
ods html5 close;

/********************************************END REPORT************************************************/
