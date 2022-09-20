*************************;
* View Files and Tables *;
*************************;
proc cas;
	table.tableInfo / caslib='casuser';
	table.fileInfo / caslib='casuser';
quit;







********************************************************************;
* Extra Utility: Uncomment to delete course data source files only *;
********************************************************************;
/*
proc cas;
	table.fileInfo result=fi / caslib='casuser';
	dsFileNames={'loans_raw.sashdat','customers_raw.csv','cars.csv','cars.txt','cars.sas7bdat','heart.sashdat'};
	do file over dsFileNames;
		table.deleteSource / source=file, caslib='casuser', quiet=TRUE;
	end;
	table.fileInfo;
quit;
*/



