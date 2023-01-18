ODS HTML5 (ID=WEB) STYLE=ocean; 

proc sgplot data=sashelp.cars;
	vbar Origin;
run;

ods html5 close;