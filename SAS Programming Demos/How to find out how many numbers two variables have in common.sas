/*Hi, I am trying to find out how many numbers two variables have in common.*/
/**/
/*For example, I have data as follows,*/
/**/
/* */
/**/
/*#                 Variable_1                 Variable_2*/
/**/
/*1                 |14|22|58|59|82|         |17|58|*/
/**/
/*2                 |7|35|79|                     |27|35|45|66|79|93|*/
/**/
/*3                 |2|13|                          |9|45|49|78|*/
/**/
/* */
/**/
/*I hope to get the results as follows,*/
/**/
/* */
/**/
/*#                 Variable_1                 Variable_2                      Output*/
/**/
/*1                 |14|22|58|59|82|         |17|58|                               1*/
/**/
/*2                 |7|35|79|                     |27|35|45|66|79|93|           2*/
/**/
/*3                 |2|13|                          |9|45|49|78|                       0*/
/**/
/* */
/**/
/*Thanks!*/
/**/
/*https://communities.sas.com/t5/SAS-Programming/How-to-find-out-how-many-numbers-two-variables-have-in-common/m-p/618751/highlight/false#M181555*/

data raw;
	infile datalines dsd;
	input row var1:$20. var2:$20.;
	datalines;
1,|14|22|58|59|82|,|17|58|
2,|7|35|79|,|27|35|45|66|79|93|
3,|2|13|,|9|45|49|78|
;
run;

data test;
	set raw;
	Var1Num=countw(var1,'|')-1; /*Find number of numbers in the var1 column*/
/*Loop through how many numbers to test if one exists in var2*/
	do i=1 to Var1Num;
		TestValue=scan(var1,i,'|','r');/*loop through numbers*/
		if findw(var2,strip(put(TestValue,3.)))>0 then Found=1;/*If found then found=1*/
			else Found=0;
		output;
	end;
run;

/*Summarize the data*/
data final;
	set test;
	by row;
	if first.row then sum=0; /*Sum column set = 0 at the start of a group*/
	sum+found; /*Begin to sum if found*/
	if last.row then output; /*output the last row with the total sum*/
run;