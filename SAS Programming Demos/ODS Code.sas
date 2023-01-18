/*Explore the data*/
proc print data=sashelp.cars (obs=20);
run;

proc freq data=sashelp.cars;
	tables make;
run;


/*Create the new data sets*/
data Toyota Honda;
	set sashelp.cars;
	if make="Toyota" then output Toyota;
		else if Make='Honda' then output Honda;
	MPG_Average=mean(mpg_city,mpg_highway);
	Keep Make Model Type MPG_City MPG_Highway MPG_Average;
run;

/****************************************
BONUS: Create an excel workbook
- Make sure to change the path of the file location below
****************************************/
/*Output to an excel workbook*/

/*USING %SYSFUNC()
This will get today's date using the today() function, then 
convert the date to text to name the new excel workbook using the format provided.
In this example I used monyy7. You can use whatever date format you would like*/

ods excel file="s:/workshop/Cars%sysfunc(today(),monyy7.).xlsx" style=festival;

/*Change sheet name and print report*/
ods excel options(sheet_name="Toyota Cars");
proc print data=toyota noobs;
run;

/*Change sheet name and print report*/
ods excel options(sheet_name="Honda Cars");
proc print data=honda noobs;
run;

/*Close excel workbook*/
ods excel close;


/****************************************
BONUS - Create a PowerPoint
- Be sure to change the PowerPoint location
****************************************/
/*Output to powerpoint*/
ods powerpoint file='s:/workshop/test.pptx';

/*Add text to title slide*/
proc odstext;
	p "Toyota and Honda Cars" / style=PresentationTitle;
	p "Descriptive Statistics" / style=PresentationTitle2;
	p "Peter Styliadis" / style=PresentationTitle2;
run;

/*Turn off labeling options in reports*/
options nolabel;
ods noproctitle;

/*Toyota descriptive statistics*/
title "Toyota Car Statistics by Type";
proc means data=toyota min median max maxdec=1;
	var MPG_City MPG_Highway MPG_Average;
	class type;
run;

/*Honda descriptive statistics*/
title "Honda Car Statistics by Type";
proc means data=Honda min median max maxdec=1;
	var MPG_City MPG_Highway MPG_Average;
	class type;
run;
title;

/*Turn on options*/
options label;
ods proctitle;

/*Close output*/
ods powerpoint close;