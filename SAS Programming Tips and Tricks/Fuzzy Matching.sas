**********************************************************************;
* STUDENT QUESTION: Use Fuzzy Matching to Join Values*;
**********************************************************************;
* PROGRAM DESCRIPTION: *;
**********************************************************************;
* DOCUMENTATION: 					   *;
*	-  *;
**********************************************************************;


data table1;
	infile datalines dsd;
	input First:$10. Last:$20. Gender:$1.;
	datalines;
Peter, Styliadis, M
Anna, Yarbrough, F
Kristi, Bull, F
Steve, Bull, M
Agapi, Styliadis, F
;
run;

data table2;
	infile datalines dsd;
	input First:$10. Last:$20. State:$2.;
	datalines;
Peter, Styliadis, NC
Ann, Yarbrough, NC
Kristina, Bull, NC
Stephen, Bull, NY
Agape, Styliadis, NY
;
run;

proc sql;
select *, 
       spedis(a.First,b.First) as FirstMatch_SPEDIS,
	   spedis(a.Last,b.Last) as LastMatch_SPEDIS,
	   compged(a.First,b.First) as FirstMatch_COMPGED,
	   compged(a.Last,b.Last) as LastMatch_COMPGED,
	   complev(a.First,b.Last) as FirstMatch_COMPLEV,
	   complev(a.Last,b.Last) as LastMatch_COMPLEV
	from table1 as a, table2 as b;
quit;

/*Here is SPEDIS*/
/*See doc for scoring: https://go.documentation.sas.com/?docsetId=lefunctionsref&docsetTarget=p0vmuxh8ljfn7on164nsgvmdrc5d.htm&docsetVersion=9.4&locale=en*/
/*Close but it matches Peter STyliadis with Stephen Bull, which is weird*/
/*You could add another criteria which should match if you have that available. Like if State was in both tables*/
proc sql;
select *
	from table1 as a inner join table2 as b
	on spedis(a.First,b.First) <=100 and spedis(a.Last,b.Last) <=100;
quit;

/*Less than 50 works better*/
proc sql;
select *
	from table1 as a inner join table2 as b
	on spedis(a.First,b.First) <=60 and spedis(a.Last,b.Last) <=60;
quit;


/*Here is COMPGED*/
/*DOC: https://go.documentation.sas.com/?docsetId=lefunctionsref&docsetTarget=p1r4l9jwgatggtn1ko81fyjys4s7.htm&docsetVersion=9.4&locale=en*/
proc sql;
select *
	from table1 as a inner join table2 as b
	on COMPGED(a.First,b.First) <=100 and COMPGED(a.Last,b.Last) <=100;
quit;


/*I didn't do COMPLEV. You can see from the original cartesian product everything is less than 10*/
	