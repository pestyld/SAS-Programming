%let dataFile = C:/Users/pestyl/OneDrive - SAS/github repos/SAS Programming/SAS Programming Demos/data/boston_housing.csv;

proc import datafile="&dataFile"
			dbms = csv
			out=work.boston_housing(drop=VAR1)
			replace;
	guessingrows=300;
run;

proc print data=work.boston_housing(obs=10);
run;