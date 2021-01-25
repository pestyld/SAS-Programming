********************
*  ACCESS DATA     *
********************;
%let path=C:\Users\pestyl\Desktop\github repos\SAS Case Studies and Workshops\SAS GF 2017 Data Cleansing Workshop;
libname quakes "&path";


*********************************;
*Step 1: Clean the data         *;
*********************************;
data earthquakes_clean; 
	length ID $10 REGION_CODE $10 FLAG_TSUNAMI $3 DATE_TIME 8 EQ_PRIMARY 8; /*Set default lengths*/
    set quakes.earthquakes_dirty;
/*1. Create two variables from the ID_REGIONCODE variable. Name one variable ID and the other REGION_CODE. 
	 When you are finished, drop the original ID_REGIONCODE variable. */
    ID=scan(ID_RegionCode,1,'-');
    Region_Code=scan(ID_RegionCode,-1,'-'); 
/*2. All character values of FLAG_TSUNAMI should be converted to uppercase.*/
    Flag_Tsunami=upcase(flag_tsunami); 
/*3. Create a SAS datetime variable named DATE_TIME from the date and time variables in the Earthquakes_dirty data set.*/
    Date_Time=dhms(mdy(month,day,year),hour,minute,seconds);
/*4. Create the EQ_PRIMARY variable to determine the primary earthquake magnitude.*/
    Eq_Primary=Coalesce(eq_mag_mw, eq_mag_ms, eq_mag_mb, eq_mag_ml, eq_mag_mfa, eq_mag_unk); 
    keep ID Region_Code Flag_Tsunami Date_Time EQ_Primary Focal_Depth Country Location_Name; 
    format Date_Time datetime21. EQ_Primary 8.1; 
run;


**********************************************;
*Step 2: Create a valid and invalid data set *;
**********************************************;

/*******************Check for duplicates *******************/ 
proc freq data=earthquakes_clean order=freq; 
	tables ID; 
run;

data earthquakes_valid invalid; 
	set earthquakes_clean;
/*The following are the valid values. Will output to earthquakes_valid*/ 
	if (ID ne '10301' and /*Everything except the duplicate value*/
		Region_code in ("1", "10", "15", "20", "30", "40", "50", "60", "70", "80", "90","100", "110", "120", "130", "140", "150", "160", "170") and /*Only valid region_code values*/
		Flag_Tsunami in ('','TSU') and  /*Only valid Flag_Tsunami values*/ 
		Date_time ne . and /*Only Date_time values that are not missing*/
		(0 <= EQ_Primary <= 9.9) and (0 <= Focal_Depth <= 700)) then output earthquakes_valid;
/*Everythign else is invalid, output to invalid*/
	else output invalid; 
run;


**********************************************;
*BONUS									     *;
**********************************************;
data invalid; 
	set invalid; 
	length INVALID_DESCRIPTION $60; 
	Invalid_description="";
/*Test the following conditions. If one is true add the reason why to the Invalid_description value. Value will concatenate*/
	if ID='10301' then Invalid_description = catx(',','DuplicateID', Invalid_description); 
	if Region_code not in ("1", "10", "15", "20", "30", "40", "50", "60", "70", "80", "90","100", "110", "120", "130", "140", "150", "160", "170") 
	     then Invalid_description = catx(',','Region Code', Invalid_description); 
	if Flag_Tsunami not in ('','TSU') then Invalid_description = catx(',','Flag_Tsunami', Invalid_description); 
	if Date_time = . then Invalid_description = catx(',','Date Time', Invalid_description); 
	if not(0 <= Focal_Depth <= 700) then Invalid_description = catx(',','Focal Depth', Invalid_description); 
	if not(0 <= EQ_Primary <= 9.9 ) then Invalid_description = catx(',','EQ Primary', Invalid_description); 
run;



/****************************************************************************************************
****************************END OF CHALLENGE, PLEASE READ THE COMMENTS BELOW*************************
****************************************************************************************************/

/************************************************************************
Validate your Results
*************************************************************************
- Please run the following procedures when you are complete to answer the 
validation questions in Section 1.3 of your document. After you run the code below,
check the results viewer for the answers.
*************************************************************************/
ods noproctitle;

title "Question 1";
title2 "What is the average magnitude for the EQ_PRIMARY variable in the Earthquakes_valid data set?";
proc means data=earthquakes_valid mean maxdec=2;
	var eq_primary;
run;

title "Question 2";
title2 "How many earthquakes have a missing value for DATE_TIME in the Invalid data set?";
proc freq data=invalid;
	tables date_time / nocum nopercent missing;
	where date_time = .;
run;

title "Question 3";
title2 "How many observations are in the Invalid data set?";
proc sql;
	select count(*) as Total_Invalid_Obs
	from invalid;
quit;
title;

ods proctitle;
