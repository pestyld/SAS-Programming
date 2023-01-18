
data test;
	infile datalines  dsd;
	input AcctNum $ Gender $ Name $;
	datalines;
12345,M,Peter
12389,F,Kristi
12341,,Steve
12010,,Kelly
;
run;

filename Peter "C:\Users\pestyl\Desktop\Programming I and II\Demo Programs\will.txt";
data _null_;
	file peter;
	set test;
	if missing(gender) then put "Account:" AcctNum "has a missing value for gender";
title "Missing Gender Accounts";
run;

proc freq data=check_for_missing;
	tables gender /nopercent;
run;