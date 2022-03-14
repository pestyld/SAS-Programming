/*Student Question: How can I remove leading and trailing zeros from a value?*/

/*Create test table*/
data test;
	infile datalines;
	input x $30.;
	datalines;
000ABDE2347290028390A0
0ABD392400000KL0
00000JAFD239402000000K0
;
run;

/*Remove leading and trailing zeros*/
data final;
	set test;
	leadingzero=findc(x,'123456789','a');/*Find position of leading 0*/
	trailingzero=findc(x,'123456789','ba');/*Find position of trailing 0*/
	NewValue=substr(x,leadingzero,trailingzero-leadingzero+1);/*Use above info to extract string*/
run;

proc print data=final;
run;