/*Method 1: Excel Engine*/
libname XL excel "&path\class.xlsb";/*Type the xlsb engine*/
data XL.class_sheet;
	set sashelp.class;
run;
libname XL clear;

/*Method 2: PCFiles Engine*/
libname XL pcfiles path="&path\class.xlsb";/*Type the xlsb engine*/
data XL.class_sheet;
	set sashelp.class;
run;
libname XL clear;

/*Method 3: PROC EXPORT*/
proc export data=sashelp.class
	outfile="&path\class.xlsb"/*Type the xlsb engine*/
	dbms=excel
	replace;
run;