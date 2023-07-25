***********************************************;
* CREATE CUSTOM EXCEL STYLE TEMPLATE          *;
***********************************************;

* Find current saved program file location *;
%let fileName =  %scan(&_sasprogramfile,-1,'/');
%let outpath = %sysfunc(tranwrd(&_sasprogramfile, &fileName,));

/*Set the location of your input file and output destination*/
%let data=&outpath.~data; 
%let outpath=&outpath.~output files;


/*Lets you see all the SAS styles (long list), and user styles (short one at the top)*/
proc template;
    list styles;
run;


proc template;
    define style styles.matt;     /*Name of your new style*/
    parent=styles.excel;          /*Use styles.excel as the foundation*/
   
/*Options for the data*/
    class data /                  /*after the slash, change the options*/
        borderstyle=solid
        borderwidth=1px
        bordercolor=black;   
        
/*Options for the header*/
    class header /                /*after the slash, change the options*/
        backgroundcolor=bgr       /*this is some sort of gray*/
        borderstyle=solid
        borderwidth=2px
        bordercolor=black;
    end;
run;



/*Lets you see all the SAS styles (long list), and user styles (short one at the top)*/
proc template;
    list styles;
run;


/* Create custom formats */
proc format;
    value $favorites
        'Acura' = 'green'
        'Honda' ='yellow'
        'Toyota' = 'pink';
run;



/*Keep SAS naming conventions from input file*/
options validvarname=v7;

/*This create a SAS data set named 'cars' using the csv file*/
proc import datafile="&data/cars.csv"     /*points to the csv file for SAS to connect too*/
            out=cars                      /*What do you want your SAS data set name to be*/
            dbms=csv                      /*What type of data are you importing*/
            replace;                      /*If the data set exists, you can replace it*/
    guessingrows=Max; /*Determine length of columns using all rows*/
    
run;

/* Preview imported data */
proc print data=cars (obs=10);
run;







/* Create an excel file from the data. Uncomment #2 and #3 to create additional files */
/* style the Excel spreadsheet with borders and colors */

/*1. Output as an excel file and give it the name of the current data*/
ods excel file="&outpath/FileNameCSV%sysfunc(today(),date9.).xlsx" 
        style=styles.matt
        options(sheet_name="Test" tab_color='red');
        
/*2. Output as a PDF file*/
*ods csvall file="&location/FileNameCSV%sysfunc(today(),date9.).csv";

/*3. Output as a CSV File*/
*ods pdf file="&location/FileNameCSV%sysfunc(today(),date9.).PDF";

title "My favorite cars";

proc print data=cars noobs;
    var make / style={backgroundcolor=$favorites.};  /* Style the make column from the format created above */
    var model mpg_city mpg_highway;
    where make in("Honda","Toyota","Acura");         /*limit to my favorite cars*/
    /*Additional SAS statements (where, by, etc..)*/
run;

title;

ods _all_ close;