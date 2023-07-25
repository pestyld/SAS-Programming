
options nolabel;
options sastrace=',,,d' sastraceloc=saslog nostsuffix;
proc sql  ;
	select * 
	from sashelp.baseball(obs=10);
quit;
options label;
