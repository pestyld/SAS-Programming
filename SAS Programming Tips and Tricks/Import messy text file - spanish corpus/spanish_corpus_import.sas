/************************************************************************************************************/
/* Kaggle Spanish Corpus */
/* https://www.kaggle.com/datasets/rtatman/120-million-word-spanish-corpus?select=spanishText_200000_205000 */
/* Read in the text file */
/************************************************************************************************************/


/* Download file from GitHub */
filename data TEMP;
proc http 
   url='https://github.com/pestyld/SAS-Programming/raw/master/SAS%20Programming%20Tips%20and%20Tricks/Import%20messy%20text%20file%20-%20spanish%20corpus/Spanish_Corpus_Kaggle.txt'
   out=data;
run;


/* Import txt file as SAS data set */
proc import 
		datafile="data"
		out=kaggle_span_data
		dbms=tab
		replace;
	getnames=no;
run;


title 'Original data';
proc print data=kaggle_span_data(obs=100);
run;
title;

/* Clean up text file */
data mycorp;
	set kaggle_span_data;
	length DOCID $10 DOCUMENTS $32000;  /* Set the length of the comments for the new column */
	retain DOCID documents "";      /* Create a variable to accumulate all comments */
	
	/* Filter out unneccessary rows */
	where var1 is not null and 
	      var1 ne "</doc>";
	
	/* Flag the start of a new record */
	flag=find(var1, "<doc id=");

	if flag>0 then do;
		documents="";  /* Set accumulator to blank for start of new record */
		DOCID = tranwrd(scan(compress(var1,' "'),2,'='),'title',''); /*Store the DOCID from the text file */
		delete;        /* Delete row with doc id= */
	end;
	
	/* Accumulate each new row in a single value */
	documents=catx(" ", documents, var1);

	/* Use ENDOFARTICLE line as flag for new line and output new accumulator variable as new row */
	if var1="ENDOFARTICLE." then do;
		documents=tranwrd(documents, "ENDOFARTICLE.", ""); /*Remove ENDOFARTICLE from string */
		output mycorp;  /* Output final row to new table */
		docid="";
	end;
	
	drop var1 flag;
run;


ods select variables;
proc contents data=mycorp;
run;

title 'cleaned up text file';
proc print data=mycorp(obs=30);
run;
title;
