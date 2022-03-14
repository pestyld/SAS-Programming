/*Filename technique*/

/*Proc HTTP*/
/*Info from blog post: https://blogs.sas.com/content/sasdummy/2017/12/04/scrape-web-page-data/*/

/*Create a text file in the following location named source that will contain
all HTML code from the website we scrape. You will need to change this location
to a location on your server or location machine depending on your install*/
filename src "C:\Users\pestyl\Documents\My SAS Files\9.4\MyMacs\source.txt";

proc http
 method="GET" /*Get html from website*/
 url="https://wwwn.cdc.gov/nndss/conditions/search/"/*this website*/
 out=src;/*Place the text in the text file from above*/
run;

/*Input one line into a column, ignore blanks*/
data rep;
	infile src length=len lrecl=32767;
	input line $varying32767. len;
	line = strip(line); /*Remove leading and trailing blanks*/
	NewColu=Len; /*See the length of each column*/
	if newcolu  >=1; /*Only see rows with text. Delete blank rows*/
run;
proc print ;
run
