/*Graphing demos using SASHELP.CARS*/
proc print data=sashelp.cars (obs=10);
run;

/*Scatter Plot*/
proc sgplot data=sashelp.cars;
	scatter x=make y=MSRP /group=origin;
run;

/*Line graph*/
proc sgplot data=rw.profit;
	series x=Month y=Sales / group=country;
	where year=2007 and Country in ('France','Italy');
run;

/*Histogram and Density Curve*/
proc sgplot data=sashelp.cars;
	histogram msrp / datalabel=percent;
	density msrp;
run;

/*Horizontal Bar chart*/
proc sgplot data=sashelp.cars;
	hbar make / categoryorder=respasc /*order ascending*/
				group=origin
				response=msrp 
				stat=median;
run;

/*Bar-Line Chart (2 y axis)*/
proc sgplot data=sashelp.cars;
	vbar make / response=msrp stat=median;
	vline make / response=mpg_city stat=median y2axis;
run;

/*Intro to panels. Similar to above, but uses a by group to create
graphs for each grouping*/
proc sgpanel data=sashelp.cars;
	panelby make;
	histogram msrp;
run;


/*Creates multiple scatter plots*/
/*Plots, compare or matrix*/
proc sgscatter data=sashelp.cars;
	plot mpg_city*mpg_highway msrp*weight msrp*horsepower;
run;

proc sgscatter data=sashelp.cars;
	compare x=(origin cylinders) /*Compare multiple variables*/
	y=msrp;
run;

proc sgscatter data=rw.profit;
	where Country in ('France','Italy','UK');
	matrix sales salaries profit / group=company
		diagonal=(histogram normal);
run;