/*Dave's Length Function*/


data All FirstNameMax LastNameMax;
	infile datalines dsd dlm="," missover;
	input First:$8. Last:$10. Salary:8.;
	TotalFirst=length(First);
	TotalLast=length(Last);
	if TotalFirst=8 then output FirstNameMax; /*If the first name equals the max, then output to this table to investigate the row*/
	if TotalLast=10 then output LastNameMax; /*If the last name equals the max, then output to this table to investigate the row*/
	output All;
	datalines;
Panagiotis, Styliadis, 200000
Dave, Timmermanmanness, 1000000
Alexanderness, Johnsonettenamester, 1000000000
John, Doe, 20493
Steve, Wills, 342023
Joe, Smith, 38402
Don, Johsnon, 2084932
Peter, Styles 290030
Lohansontanamoteo, Choles
;
run;
/*3 first names are long*/
/*3 last names are long*/





/* ATTEMPT TWO */
/* Fix the length issues by adding a few characters to the legnths*/
/* Change to 12 for First and 15 for Last*/
data All FirstNameMax LastNameMax;
	infile datalines dsd dlm="," missover;
	input First:$12. Last:$15. Salary:8.;
	TotalFirst=length(First);
	TotalLast=length(Last);
	if TotalFirst=12 then output FirstNameMax; /*If the first name equals the max, then output to this table to investigate the row*/
	if TotalLast=15 then output LastNameMax; /*If the last name equals the max, then output to this table to investigate the row*/
	output All;
	datalines;
Panagiotis, Styliadis, 200000
Dave, Timmermanmanness, 1000000
Alexanderness, Johnsonettenamester, 1000000000
John, Doe, 20493
Steve, Wills, 342023
Joe, Smith, 38402
Don, Johsnon, 2084932
Peter, Styles 290030
Lohansontanamoteo, Choles
;
run;
/*2 first names are long*/
/*2 last names are long*/




/* ATTEMPT THREE */
/* Fix the length issues by adding a few characters to the legnths*/
/* Change to 15 for First and 20 for Last*/
data All FirstNameMax LastNameMax;
	infile datalines dsd dlm="," missover;
	input First:$15. Last:$20. Salary:8.;
	TotalFirst=length(First);
	TotalLast=length(Last);
	if TotalFirst=15 then output FirstNameMax; /*If the first name equals the max, then output to this table to investigate the row*/
	if TotalLast=20 then output LastNameMax; /*If the last name equals the max, then output to this table to investigate the row*/
	output All;
	datalines;
Panagiotis, Styliadis, 200000
Dave, Timmermanmanness, 1000000
Alexanderness, Johnsonettenamester, 1000000000
John, Doe, 20493
Steve, Wills, 342023
Joe, Smith, 38402
Don, Johsnon, 2084932
Peter, Styles 290030
Lohansontanamoteo, Choles
;
run;
/*1 first names are long*/
/*0 last names are long*/