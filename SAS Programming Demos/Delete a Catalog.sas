libname orion 'C:\Users\pestyl\Desktop\Programming I and II\Demo Programs';

/*Create the formats*/
proc format lib=orion.newformats;
	value $Gender
		'M' = 'Male'
		'F' = 'Female';
run;

proc format lib=orion.newformats;
	value GenderNum
		1 = 'Male'
		2 = 'Female';
run;

/*Check the formats*/
proc format lib=orion.newformats fmtlib;
run;

/*Delete the formats catalog*/
proc delete lib=orion data=newformats (memtype=catalog);
run; 

/*Check the formats catalog again. Nothing should be inside*/
proc format lib=orion.newformats fmtlib;
run;