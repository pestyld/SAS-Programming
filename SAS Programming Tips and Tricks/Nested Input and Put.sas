data NestedIntput;
	x='1234567'; /*Bank account came in as character*/
/*Convert a character string to numeric with width, then
	use that to create character from a numeric for bank accounts with
	leading zeros*/
	LeadingZeros=put(input(x,15.),z15.);
run;

proc print data=NestedIntput;
run;