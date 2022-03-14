*******************************************************************;
* PROGRAM: Create a data dictionary of all tables in CAS          *;
* DESCRIPTION: Create a CASL program to create a data dictionary  *;
*              of every available CAS table.                      *;
*******************************************************************;
 
* Connect to the CAS server *;
cas conn;


**********;
* Step 1 *;
**********;
***********************************;
* Create the table and columns:   *;
*      -Caslib (string),          *;
*      -Description (string),     *; 
*      -Path (string),            *; 
*      -TableName (string),       *; 
*      -NRows (int32),            *;
*      -NCols (int32)"            *;
***********************************;
proc cas;
    newCols = {"Caslib", "Description", "Path", "TableName", "NRows", "NCols"};
    newColTypes = {"varchar", "varchar", "varchar", "varchar", "int32", "int32"};
    tbl = newTable("CASTableInfo", newCols, newColTypes);

* Preview the tbl object *;
    describe tbl;
    print "Number of rows in the table: " tbl.nrows;
quit;



**********;
* Step 2 *;
**********;
* Find all available caslibs. Store and view the result *;
proc cas;

* Find all available caslibs. Store the results in the caslibDict variable as a dictionary *;
    table.caslibInfo result=caslibDict;

* View the action result variable *;
    describe caslibDict;

* Access the result table in the dictionary by calling the caslibInfo key *;
    print caslibDict.caslibInfo;
quit;



***********;
* Step 3  *;
***********;
* Loop over the caslibInfo action result table and see each row is a dictionary *;
proc cas;

* Find all available caslibs *;
    table.caslibInfo result=caslibDict;
    print caslibDict.caslibInfo;

* Loop over each row of the caslibInfo table and view the data type and value of the row *;
* When you loop over a table, each row is a dictionary. The column name is the key.      *;
    do caslib over caslibDict.caslibInfo;
        print "------------Data type of the caslib variable------------";
        describe caslib;
        print caslib;
    end;
quit;



**********;
* Step 4 *;
**********;
* Use the Name column from the result table to view all in-memory tables in each caslib *;
proc cas;

* Find all available caslibs *;
    table.caslibInfo result=caslibDict;

* Loop over each caslib and reference the caslib name in the tableInfo action *;
    do caslib over caslibDict.CaslibInfo;
       
    * Find all available in-memory tables in each caslib *;
       table.tableInfo / caslib=caslib.Name;

    end;

quit;



**********;
* Step 5 *;
**********;
* Add each row of data to the table.  *;
* (NOTE) Warning might be returned if no in-memory tables are in a caslib. *;
proc cas;

* Create the table structure *;
    newCols = {"Caslib", "Description", "Path", "TableName", "NRows", "NCols"};
    newColTypes = {"string", "string", "string", "string", "int32", "int32"};
    tbl = newTable("CASTableInfo", newCols, newColTypes);


* Find all available caslibs *;
    table.caslibInfo result=caslibDict;

* Loop over each caslib and reference the caslib name in the tableInfo action *;
    do caslib over caslibDict.CaslibInfo;
       
    * Find all available in-memory tables in each caslib *;
        table.tableInfo result=tblList / caslib=caslib.Name;

    * Loop over each in-memory table and store the details in my table tbl *;
        do casTable over tblList.tableInfo;
             addrow(tbl, {caslib.Name, caslib.Description, caslib.Path,     /* Caslib info */
                          casTable.Name, casTable.Rows, casTable.Columns}); /* In-memory table info */
        end;

    end;

* Print the new table *;
    print tbl;

quit;



**********;
* Step 6 *;
**********;
* Do not add information to the table if the caslib does not have any in-memory tables *;
proc cas;

* Create the table structure *;
    newCols = {"Caslib", "Description", "Path", "TableName", "NRows", "NCols"};
    newColTypes = {"string", "string", "string", "string", "int32", "int32"};
    tbl = newTable("CASTableInfo", newCols, newColTypes);


* Find all available caslibs *;
    table.caslibInfo result=caslibDict;

* Loop over each caslib and reference the caslib name in the tableInfo action *;
    do caslib over caslibDict.CaslibInfo;
       
    * Find available in-memory tables in each caslib *;
        table.tableInfo result=tblList / caslib=caslib.Name;

        * Check to see if a key exists in the result of the tableInfo action for that caslib. If it does
          Loop over each in-memory table and store the details in my table tbl  *;
        if exists(tblList,"TableInfo") = 1 then 
            do casTable over tblList.tableInfo;
                 addrow(tbl, {caslib.Name, caslib.Description, caslib.Path,     /* Caslib info */
                              casTable.Name, casTable.Rows, casTable.Columns}); /* In-memory table info */
            end;
        else print "-------------- No in-memory tables found in: " caslib.Name " --------------"; 
   
    end;

* Print the new table for confirmation*;
    print tbl;

quit;



*************************************;
* Step 7 - Putting it all together! *;
*************************************;
* Save the new table as a SAS data set *;
proc cas;

* Create the table structure *;
    * Column names *;
    newCols = {"Caslib", "Description", "Path", "TableName", "NRows", "NCols"};
    * Column data types *;
    newColTypes = {"varchar", "varchar", "varchar", "varchar", "int32", "int32"};
    * Create the table *;
    tbl = newTable("CASTableInfo", newCols, newColTypes);


* Find all available caslibs and store the results in the variable caslibDict*;
    table.caslibInfo result=caslibDict;

* Loop over each available caslib and reference the caslib name in the tableInfo action to view all 
  in-memory tables. Then add the available in-memory tables to the new table object *;
    do caslib over caslibDict.CaslibInfo;
       
    * Find available in-memory tables in each caslib. Store the results *;
        table.tableInfo result=tblList / caslib=caslib.Name;

        * Check to see if a key exists in the result of the tableInfo action for that caslib. If it does
          Loop over each in-memory table and store the details in my table tbl  *;
        if exists(tblList,"TableInfo") = 1 then 
            do casTable over tblList.tableInfo;
                 addrow(tbl, {caslib.Name, caslib.Description, caslib.Path,     /* Caslib informatoin */
                              casTable.Name, casTable.Rows, casTable.Columns}); /* In-memory table information */
            end;
        else print "-------------- No in-memory tables found in: " caslib.Name " --------------"; 
    end;

* Save the result table to a SAS data set *;
    saveresult tbl dataout=work.CASTableInfo;
quit;

* View the data dictionary of CAS tables *;
proc print data=work.CASTableInfo(obs=10) noobs;
run;

title justify=left height=14pt color=gray "Total number of tables in each caslib";
proc sgplot data=work.CASTableInfo noborder;
    vbar caslib / categoryorder=respdesc
                  nooutline;
    yaxis label="Number of Tables";
    xaxis label="Caslib Name";
run;
title;