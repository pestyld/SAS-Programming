/*Access the SAS Data sets*/
libname quakes "C:\Workshop\Challenge\DataCleansing";


/*Step 1: Clean the data*/
data earthquakes_clean;
	set quakes.earthquakes_dirty;
/*Enter Code Here*/

/*Keep only the following variables*/
	keep ID Region_Code Flag_Tsunami Date_Time 
		EQ_Primary Focal_Depth Country Location_Name;
run;



/*Step 2: Create a valid and invalid data set*/
data earthquakes_valid invalid;
	set earthquakes_clean;
/*Enter Code Here*/
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
