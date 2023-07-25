
/************************************************************************************************************/
/* Kaggle Spanish Corpus */
/* https://www.kaggle.com/datasets/rtatman/120-million-word-spanish-corpus?select=spanishText_200000_205000 */
/* Read in the text file */
/************************************************************************************************************/

proc import datafile = "C:\Users\jobake\Desktop\Spanish_Corpus\Spanish_Corpus_Kaggle.txt"
out = kaggle_span_data
replace; getnames=no;
run;

data mycorp (drop=var1 flag);
set kaggle_span_data;
length documents $32000;
retain documents "";
where var1 is not null and var1 ne "</doc>";
flag = find(var1,"<doc id=");
if flag>0 then do;
	documents="";
	delete;
end;
documents = catx(" ",documents,var1);
if var1="ENDOFARTICLE." then do; 
	documents = tranwrd(documents, "ENDOFARTICLE.", "");
	output mycorp;
end;
run;

data mycorp;
set mycorp;
	docid+1;
run;

proc contents data=mycorp;
run;

libname spancorp "C:\Users\jobake\Desktop\Spanish_Corpus";

data spancorp.spanish_corpus_kaggle_data;
set mycorp;
run;

/*************************************/
/* View the Corpus as a SAS data set */
/*************************************/

libname spancorp "C:\Users\jobake\Desktop\Spanish_Corpus";

data mycorp;
set spancorp.spanish_corpus_kaggle_data;
run;

proc print data=mycorp (obs=20);
run;

proc contents data=mycorp;
run;


