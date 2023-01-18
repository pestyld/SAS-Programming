/************************************************************************
Create a Dataset of Variable Names
************************************************************************/
/*Program can be enhanced and made more dynamic and fool proof*/
%let LibraryName=SASHELP; /*Library that contains table. Needs to be all upcase*/
%let DataSetName=CARS; /*Change data set name.. Needs to be all upcase*/


/*Method 1: PROC CONTENTS Step*/
proc contents data=&LibraryName..&datasetname
			  out=vars(keep=Name) /*Creates data set Vars*/
			  noprint;
run;


/*Method 2: DATA STEP*/
data vars2;/*Creats data set vars2*/
	set sashelp.vcolumn;
	where libname="&LibraryName" and memname="&DataSetName";
	keep Name;
run;

/************************************************************************
Create a macro variable to holds list of variables from original dataset
************************************************************************/

/*Method 1: Create One Macro to hold all Variable Names*/
proc sql noprint;
	select Name
		into :Var_List separated by ' '
		from dictionary.columns
		where libname="&LibraryName" and memname="&DataSetName";
quit;
/*Preview macro variable list of columns*/
%put &Var_List;


/*Method 2: Create Macro for each Variable Name*/
proc sql noprint;
	select Name
		into :Var_Name1-
		from dictionary.columns
		where libname="&LibraryName" and memname="&DataSetName";
quit;
/*Preview macro variables*/
%put &Var_Name1;
%put &Var_Name2;
%put &Var_Name3;
%put &Var_Name4;
%put &Var_Name5;