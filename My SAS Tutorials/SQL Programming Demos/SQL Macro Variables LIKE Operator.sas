**********************************************************************;
* STUDENT QUESTION: *;
**********************************************************************;
* PROGRAM DESCRIPTION: *;
**********************************************************************;


%let carMake=Toy;

/*Search for any make that begins with 'Toy'*/
proc sql;
select *
    from sashelp.cars
	where Make like "&carMake%"; *<----Macro variables must be enclosed in double quotes;
quit;

/*Search for any model that has the letters XLE in it anywhere*/
%let carModel=XLE;

/*This first one will cause an error because SAS see's the percent sign and SAS resolves
carModel to XLE, then searches for %XLE as a macro. That does not work since it doesn't exist.
However what we want is for SAS to look for (any characters)XLE(any characters)/.
To do that you need to use a macro quoting function to mask the %. Masking it tells SAS to not use
it as a macro, just keep it a string. In this case keep it as a string %.*/

/*This won't work. Issue above*/
proc sql;
select *
    from sashelp.cars
	where Model like "%&carModel%";
quit;

%let carModel=XLE;
/*Using Macro quoting function*/
proc sql;
select *
    from sashelp.cars
	where Model like "%nrquote(%)&carModel%";*<--Mask the % signs and use as wildcards as intended;
quit;


%let carModel=XLE;
/*Try something like this:*/
proc sql;
select *
    from sashelp.cars
    where Model like "%%&carModel%";
quit;



/*In this example I can use CONTAINS since I don't care where XLE is. Always be careful using contains
since it's looking for the string anywhere. Less control than with LIKE.*/
proc sql;
select *
    from sashelp.cars
	where Model contains "&carModel";
quit;