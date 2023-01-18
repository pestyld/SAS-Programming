/*Creating Formats and viewing the catalog*/

libname orion 'C:\Users\pestyl\Desktop\Programming I and II\Demo Programs';

/*Create a permanent format in the Orion library. By default it is put in the Orion.Formats catalog*/
proc format lib=orion;
	value $Gender
		'M' = 'Male'
		'F' = 'Female';
run;

/*Create a permanent format in the Orion library, testformat catalog*/
proc format lib=orion.testformat;
	value numgend
		1 = 'Male'
		2 = 'Female';
run;

/*Add a description to a format in a specific library*/
proc catalog cat=orion.formats /* library.<catlog_name> */;
	modify Gender.formatc /*'c' for character, nothing for numeric */ 
		(description="Adding a description to a format") /*What is the description of the format*/;
run;


/*View description*/
proc catalog cat=orion.formats;
	contents;
run;


/*Delete a format by using Proc Catalog. This is deleting a format in the Orion.Formats catalog*/
proc catalog cat=orion.formats;
	delete testing (entrytype=formatc) /*et=EntryType, use formatc for character*/;
run;


/*Search for a format in orion, then work*/
/*Default is (work formats)*/
options fmtsearch=(orion work);


/*Print formats in the orion lib, testcat catlog*/
proc format fmtlib lib=orion.testformat;
run;

