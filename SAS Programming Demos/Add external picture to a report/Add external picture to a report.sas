********************************;
*How to add an image to a title*;
********************************;

/*Location of the image*/
%let outpath=C:\Users\Student\Desktop\Follow Up; 

/*Output to PDF*/
ods pdf file="&outpath/PicturePDF.pdf";

/*Use ^ as an escape to pull images*/
ods escapechar="^";

title "^S={preimage='&outpath/sasimage.png'}";
title2 j=left "^S={preimage='&outpath/sasimage.png'}"; /*You can also add title options like left align*/
proc print data=sashelp.class;
run;
title;

*****************************************************************;
*Create a table with a list of what the image is and image name *;
*****************************************************************;
data ImagesTable;
	ImageTitle='Data Science Academy';
	Name='sasimage.png';
	output;
	ImageTitle='Global Forum';
	Name='sasgf.jpg';
	output;
run;


***************************************************************************;
*Dynamically combining the image name with the location to show the image *;
***************************************************************************;
ods escapechar="^"; /*Allow SAS to not treat the S={ as a string and use it to find a image*/

/*Image location*/
%let image=C:\Users\Student\Desktop\Follow Up;

/*Create a table that pulls in the image location and name*/
data test;
	set ImagesTable;
	ImageLoc=cats('^S={preimage="&image/',Name,'"}'); /*Tell SAS to pull the image*/
run;

/*Print the table to see the image title, name and image*/
proc print data=test;
run;