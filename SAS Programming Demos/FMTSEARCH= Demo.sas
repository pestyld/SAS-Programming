data formattest;
	infile datalines;
	input Name $ Gender $;
	datalines;
John M
Steve M
Kristi F
Peter M
Kelly F
Chris M
Kacie F
Sarah F
Alex M
;
run;

/*Temp Format*/
proc format;
	value $workgender
		'M' = 'Malework'
		'F' = 'Femalework';
run;

/*Perm Format*/
proc format lib=orion;
	value $workgender
		'M' = 'Male_perm'
		'F' = 'Female_perm';
run;

/*NOTE: options fmtsearch= is a global statement. Once set, it is set for the session*/

/*Search only the permanent library. Notice the perm format is not loaded*/
*options fmtsearch=(orion);

/*Search the permanent library THEN the work library. Notice the permanent format is loaded*/
*options fmtsearch=(orion work);

/*Search the work library THEN the permanent. Notice the work format is loaded*/
*options fmtsearch=(work orion);

proc print data=formattest;
	format gender $workgender.;
run;

