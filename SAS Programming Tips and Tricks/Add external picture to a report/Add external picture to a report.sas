*****************************************;
*Adding external pictures to reports    *;
*****************************************;


**************************************;
* 1. How to add an image to a title  *;
**************************************;

/*Location of the image - Dynamically finds the location of this saved program and uses it*/
%let fileName =  %scan(&_sasprogramfile,-1,'/');
%let outpath = %sysfunc(tranwrd(&_sasprogramfile, &fileName,));

/*Output to PDF*/
ods pdf file="&outpath/PicturePDF.pdf";

/*Use ^ as an escape to pull images*/
ods escapechar="^";

ods listing gpath='s:/';
ods graphics / imagename="test" imagefmt=png;
/* title "^S={preimage='&outpath/sasimage.png'}"; */
/* title2 j=left "^S={preimage='&outpath/sasimage.png'}"; /*You can also add title options like left align */
ods text="^S={preimage='&outpath/sasimage.png'}";
proc sgplot data=sashelp.cars;
	vbar Type;
run;
title;

ods graphics / reset;

ods pdf close;






*********************************************************************;
* 2. Create a table with a list of what the image is and image name *;
*********************************************************************;
data ImagesTable;
	ImageTitle='Data Science Academy';
	Name='sasimage.png';
	output;
	ImageTitle='Global Forum';
	Name='sasgf.jpg';
	output;
run;

*Dynamically combining the image name with the location to show the image *;
ods escapechar="^"; /*Allow SAS to not treat the S={ as a string and use it to find a image*/

/*Image location*/
%let image=&outpath;

/*Create a table that pulls in the image location and name*/
data test;
	set ImagesTable;
	ImageLoc=cats('^S={preimage="&image/',Name,'"}'); /*Tell SAS to pull the image*/
run;

/*Print the table to see the image title, name and image*/
proc print data=test;
run;