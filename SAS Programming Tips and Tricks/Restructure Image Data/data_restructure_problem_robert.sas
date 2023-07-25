* Input raw file *;
%let folderPath = S:/robert;
%let fileName = detection_table.csv;

* SAS output tables and library *;
%let libraryName = r;
%let rawData = detection_raw;
%let finalOutputTable = detection_final;
libname &libraryName "&folderPath";




***********************;
* Import the CSV file *;
***********************;
* detection_table.csv *;
***********************;
proc import datafile="&folderPath./&fileName"
			out=&libraryName..&rawData
			dbms=csv
			replace;
	guessingrows=max;
run;

* View column metadata. Make sure all columns are numeric (except ImageID) *;
proc contents data=&libraryName..&rawData varnum;
run;


*****************************************************************;
* Create a macro variable with a list of similar columns        *;
* These will be placed in an array to select columns            *;
*****************************************************************;
* MACRO VARIABLE         VALUES                                 *; 
* object_column_names =  _Object1_ to _Object#_                 *;
*            object_x =  _Object1_x to _Object#_x               *;
*            object_y =  _Object1_y to _Object#_y               *; 
*            object_y =  _Object1_y to _Object#_y               *; 
*        object_width = _Object1_width to _Object#_width        *;
*       object_height = _Object1_height to _Object#_height      *;
*****************************************************************;

* Uncomment noprint in the SQL statement to close the printed output for cleaner output *;
proc sql /*noprint*/;

* Dynamically find all columns like _Object#_ and store in a macro variable *;
	select name 
		into :object_column_names separated by ' '
		from dictionary.columns
		where libname = upcase("&libraryName") and 
			  memname = upcase("&rawData") and
			  name like '_Object%^_' escape '^';
			  
* Dynamically find all columns like _Object#_x and store in a macro variable *;
	select name 
		into :object_x separated by ' '
		from dictionary.columns
		where libname = upcase("&libraryName") and 
			  memname = upcase("&rawData") and
			  name like '_Object%^_x' escape '^';
			  
* Dynamically find all columns like _Object#_y and store in a macro variable *;
	select name 
		into :object_y separated by ' '
		from dictionary.columns
		where libname = upcase("&libraryName") and 
			  memname = upcase("&rawData") and
			  name like '_Object%^_y' escape '^';
			  
* Dynamically find all columns like _Object#_width and store in a macro variable *;
	select name 
		into :object_width separated by ' '
		from dictionary.columns
		where libname = upcase("&libraryName") and 
			  memname = upcase("&rawData") and
			  name like '_Object%^_width' escape '^';
			  
* Dynamically find all columns like _Object#_width and store in a macro variable *;
	select name 
		into :object_height separated by ' '
		from dictionary.columns
		where libname = upcase("&libraryName") and 
			  memname = upcase("&rawData") and
			  name like '_Object%^_height' escape '^';
quit;

* Print all macro varaibles and confirm the correct columns were selected for each macro variable *;
%put &=object_column_names;
%put &=object_x;
%put &=object_y;
%put &=object_width;
%put &=object_height;



******************************************************;
* Create the final table                             *;
******************************************************;
* DESCRIPTION                                        *;
* - Find where _Object#_ = 2                         *;
* - If so, move values that object #'s x,y,height,   *;
*   width to the first available _Object#_ column    *;
* - Build a column with every _Object#_ column that  *; 
*   contains a 2 value  (objects_with_2)             *;
* - Build a column that counts the number of 2 values*;
* - it finds in each row                             *;
* - Drop a row if no _Object#_ equals 2???           *;
* - Drop unncessary sub columns ????                 *;
******************************************************;
data &libraryName..&finalOutputTable;
	length objectsWith2 $300 total2Objects 8.; * validation columns *;
	set &libraryName..&rawData;
	
	* Set array references to columns *;
	array object_column {*} &object_column_names;
	array x_column {*} &object_x;
	array y_column {*} &object_y;
	array width_column {*} &object_width;
	array height_column {*} &object_height;
	retain objectNameHolder xHolder yHolder heightHolder widthHolder 0 objectsWith2 "";
	
	* Counter to indicate where to replace the original values with the 2 values *;
	new_column_placement=1;
	* Column to holder which columns have a 2 value *;
	objectsWith2 = "";
	
	* Loop over each _object#_ column to test for 2 *;
	do column=1 to dim(object_column);
	
		* Test to see if that _Object#_ has a value of 2. If so replace object column values from left to right (1 to n) *;
		if object_column[column] = 2 then do;
			
			* Store the values in temporary columns *;
			objectNameHolder = object_column[column];
			xHolder = x_column[column];
			yHolder = y_column[column];
			heightHolder = height_column[column];
			widthHolder = width_column[column];
			
			* Set all the current select column values to missing since they are being moved *;
			call missing (object_column[column],
			              x_column[column],
			              y_column[column],
			              width_column[column],
			              height_column[column]);
			              
			* Move the _Object#_ columns values to a forward position since a 2 value was found *;
			object_column[new_column_placement] = objectNameHolder;
			x_column[new_column_placement] = xHolder;
			y_column[new_column_placement] = yHolder;
			width_column[new_column_placement] = widthHolder;
			height_column[new_column_placement] = heightHolder;
			
			* Increase the new column position since columns were replaced: _Object#+1_ *;
			new_column_placement=new_column_placement + 1;
			
			* Create a list of values for all _Object#_ columns with a 2 value for verification *;
			objectsWith2 = catx(", ",objectsWith2,cats('_Object',column-1,'_'));
		end;
		
		* If a _Object#_ = 2 is not found, set all current selected column values to missing *;
		else do;
			call missing (object_column[column],
			              x_column[column],
			              y_column[column],
			              width_column[column],
			              height_column[column]);
		end;
		
	* End loop*;
	end;
	
	* Count how many _Object#_ have a 2 value *;
	total2Objects = countw(objectsWith2);
	
	* drop rows without a 2 value uncomment the code below *;
	*if total2Objects > 0 then output;
	drop sub_:;
run;





************************************;
* Validation check s               *;
************************************;
title1 height=20pt "Validate the final outcome";

* Preview final data *;
title2 height=14pt justify=left 'Final Table Preview (sub columns removed)';
proc print data=&libraryName..&finalOutputTable(obs=10);
run;
title;

* Preview original data by merging the columns in the new table that indicate which columns have a 2 value *;
data remove_subs;
	merge &libraryName..&finalOutputTable(keep=objectsWith2 total2Objects) 
	      &libraryName..&rawData;
	drop sub:;
run;

title2 height=14pt justify=left 'Original Table Preview (merged identifier columns, sub columns removed)';
proc print data=remove_subs(obs=10);
run;





****************************************************;
* ???? More validation testing???? ?               *;
****************************************************;
* - take raw data                                 *;
* - only keep the _Object#_ columns               *;
* - If the value is not 2, make the value missing *;
data wide_object_table;
	id + 1;
	set &libraryName..&rawData;
	array object_column {*} &object_column_names;
	keep ID &object_column_names;
	do column=1 to dim(object_column);
		if object_column[column] ne 2 then object_column[column] = .;
	end;
run;

* Tranpose the data from wide to long. Goal is to count the total number of _Object#_ columns with a value of 2 *;
proc transpose data=wide_object_table out=long_object_table name=Column;
	by ID;
run;

* Count the number of rows with _Object#_ = 2 *;
title2 "Total _Object#_ with a value of 2 using the long_object_table";
proc sql;
	select count(col1) as TotalObjectsWith2 format=comma16.
		from long_object_table;
quit;
title;


title2 "Total _Object#_ with a value using the final table";
proc print data=&libraryName..&finalOutputTable(obs=10);
run;

proc sql;
	select sum(total2Objects) as TotalObjectsWith2 format=comma16.
		from &libraryName..&finalOutputTable;
quit;

