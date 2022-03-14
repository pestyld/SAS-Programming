
/*Create formats to remove leading zeros from date and times*/
proc format;
	picture mytimes (default=10) 
		low-high='%M:%S.%s' (datatype=time);
run;

proc format;
	picture mydate (default=10) 
		low-high='%m/%d/%y' (datatype=date);
run;

data test;
	xtime='00:08:20.02't;
	NewTime=xtime;
	ydate=today();
	NewDate=ydate;
	format newtime mytimes. newdate mydate.;
run;