/*PG2 Chapter 4*/
/*Shows how to use text string in column pointer controls*/
/*Difference of how I did it*/

data seminar_ratings;
	infile "C:\Users\pestyl\Desktop\pg2\seminar.dat" pad;
	input	@1 Name $15.
			@16 String $60.;
	Rating=scan(substr(string,find(string,'Rating')),2,":");
	Comments=substr(string,1,find(string,'Rating')-1);
	if find(comments,'Rating')>0 then Comments="";
	drop string;
run;


data xl.seminar_ratings;
	infile "C:\Users\pestyl\Desktop\pg2\seminar.dat";
	input @1 Name $15. @'Rating:' Rating 1.;
run;/*Using constant 'Rating:'*/
