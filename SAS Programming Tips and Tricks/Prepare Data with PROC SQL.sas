/*************************************/
/* Prepare Data with PROC SQL        */
/*************************************/


/*****************************/
/* Create demonstration data */
/*****************************/
/* - work.cars               */
/* - work.cars_country       */
/*****************************/
data work.cars;
	set sashelp.cars;
	drop Weight Wheelbase Weight Length Horsepower; /* Drop columns   */
	format _NUMERIC_ _CHARACTER_;                   /* Remove formats */
	attrib _all_ label='';                          /* Remove labels  */
run;

data work.cars_country;
   infile datalines delimiter=',' dsd; 
   input Country:$13. Make:$13. ;
   datalines;                      
England,Jaguar
England,Land Rover
England,MINI
Germany,Audi
Germany,BMW
Germany,Mercedes-Benz
Germany,Porsche
Germany,Volkswagen
Japan,Acura
Japan,Honda
Japan,Infiniti
Japan,Isuzu
Japan,Lexus
Japan,Mazda
Japan,Mitsubishi
Japan,Nissan
Japan,Scion
Japan,Subaru
Japan,Suzuki
Japan,Toyota
South Korea,Hyundai
South Korea,Kia
Sweden,Saab
Sweden,Volvo
United States,Buick
United States,Cadillac
United States,Chevrolet
United States,Chrysler
United States,Dodge
United States,Ford
United States,GMC
United States,Hummer
United States,Jeep
United States,Lincoln
United States,Mercury
United States,Oldsmobile
United States,Pontiac
United States,Saturn
;
run;

/* Preview the new tables */
proc print data=work.cars(obs=10) noobs;
run;
proc print data=work.cars_country(obs=10) noobs;
run;



/***********************************/
/* Getting Started with SQL in SAS */
/***********************************

/* Preview 10 rows and all columns of a table */
proc sql;
	select *
	from work.cars(obs=10);
quit;


/* Select specific columns */
proc sql;
	select Make, Model, MSRP, Invoice, MPG_City, MPG_Highway
	from work.cars(obs=10);
quit;


/* Filter and sort */
proc sql;
	select Make, Model, MSRP, Invoice, MPG_City, MPG_Highway
	from work.cars
	where Make = 'Toyota'
	order by MSRP desc;
quit;


/* Create columns */
proc sql;
	select Make, 
		   Model, 
		   MSRP format=dollar16., 
		   Invoice format=dollar16.,
		   mean(MPG_City, MPG_Highway) as avgMPG,
		   MSRP - Invoice as Difference format=dollar16.
	from work.cars
	where Make = 'Toyota'
	order by avgMPG desc;
quit;


/* Summarize columns */
proc sql;
	select mean(MSRP) as avgMSRP format=dollar16.,
		   round(mean(MPG_City)) as avgMPG_City,
		   round(mean(MPG_Highway)) as avgMPG_Highway
	from work.cars;
quit;


/* Summarize the data by a group (Make) */
proc sql;
	select Make,
		   mean(MSRP) as avgMSRP format=dollar16.,
		   round(mean(MPG_City)) as avgMPG_City,
		   round(mean(MPG_Highway)) as avgMPG_Highway
	from work.cars
	group by Make
	order by avgMSRP desc;
quit;


/******************/
/* Perform a JOIN */
/******************/

/* Preview the tables */
proc sql;
	select *
	from work.cars(obs=5);
	
	select *
	from work.cars_country(obs=5);
quit;


/* Join the tables */

/* All columns from both tables */
proc sql;
	select *
	from work.cars as c inner join
		 work.cars_country as ctry
	on c.Make = ctry.Make;
quit;


/* All columns from the cars table and the Country column from the cars_country table */
proc sql;
	select c.*, 
		   ctry.Country
	from work.cars as c inner join
		 work.cars_country as ctry
	on c.Make = ctry.Make;
quit;


/**************************/
/* Create the final table */
/**************************/
proc sql;
create table work.cars_final as
	select c.Make,
		   c.Model,
		   c.Type,
		   c.Origin,
		   ctry.Country,
		   c.DriveTrain,
		   c.MSRP format=dollar16.,
		   c.Invoice format=dollar16.,
		   c.MSRP - c.Invoice as Difference format=dollar16.,
		   c.EngineSize label='Engine Size',
		   c.Cylinders,
		   c.MPG_City label='MPG City',
		   c.MPG_Highway label='MPG City',
		   mean(c.MPG_City, c.MPG_Highway) as avgMPG label='MPG Average'
	from work.cars as c inner join
		 work.cars_country as ctry
	on c.Make = ctry.Make;
quit;