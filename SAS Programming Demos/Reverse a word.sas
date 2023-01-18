data temp;
input list $50.;
cards;
hellothere
thankyou
goodbye
welcome
;
run;


data test;
	set temp;
	length newword $100; /*create a new column with a length of 100*/
	newword=""; /*Start the value of the new column as a blank*/
	l = length(list); /*find the length of the word*/
	do i=l to 1 by -1; /*start from the last character and go to the first*/
		letter=char(list,i); /*get the last letter, go down by one each loop*/
		newword=cats(newword,letter); /*concatenate every letter throughout the loop*/
	end;
run;
