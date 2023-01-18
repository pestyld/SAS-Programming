*************************************************************;
* Creating a User-Defined Style Template                    *;
*************************************************************;
*  Demo                                                     *;
*  1) *;
*  2) *;
*  3) *;
*  4) *;
*  5) *;
*************************************************************;

******************************************;
*Step 1 - Create HTML File Macro Program *;
******************************************;

%macro createHTML5(fileLoc=&outpath,        /*Location of output file*/
                   fileName=og03d03.html,   /*Name of output file*/
                   styleName=companyStyle); /*ODS style template*/

ods html5 path="&fileLoc" 
          file="&fileName" style=&styleName;

/*BAR*/
proc sgplot data=sashelp.cars;
    vbar Type;
run;



/*BAR with GROUP*/
proc sgplot data=sashelp.cars;
    vbar Type / group=Origin;
run;


/*VLINE*/
proc sgplot data=sashelp.cars;
    vline Type;
run; 


/*VLINE with GROUP*/
proc sgplot data=sashelp.cars;
    vline Type / group=Origin;
run;


/*SCATTER with GROUP*/
proc sgplot data=sashelp.cars;
    scatter x=MPG_City y=MPG_Highway / group=Origin;
run;


/*SCATTER with Added OUTLINES using ATTRS*/
title "Added outlines with ATTRS option";
title "How to add outlines in Style Template";
proc sgplot data=sashelp.cars;
    scatter x=MPG_City y=MPG_Highway / 
              group=Origin
              filledoutlinedmarkers
              markeroutlineattrs=(color=White);
run;
title;

ods html5 close;


%mend;
*********************************;
*End HTML File Macro Program    *;
*********************************;










*********************************;
*Step 2 - Style Template        *;
*********************************;

proc template;
    define style styles.companyStyle;
    parent=styles.htmlblue;
***************** Company Colors *****************;
    class Colors /          
    /*Company Specific Base Colors*/
          "vibrantColor1" = cx0379cd /*blue*/
          "vibrantColor2" = cxff8324 /*orange*/
          "vibrantColor3" = cxdd5757 /*red*/
          "vibrantColor4" = cx15b57a /*green*/
          "vibrantColor5" = cxff0bbd /*pink*/
          "vibrantColor6" = cxffcc32 /*yellow*/
          "vibrantColor7" = cx2ad1d1 /*teal*/
          "vibrantColor8" = cx9471ff /*violet*/
          "titleColor" = cx768396    /*gray*/
          "textColor" = cx768396;    /*gray*/
***************** Default Graph Style *****************;
    class GraphDataDefault /  
            markersize=9px                   
            markersymbol="circlefilled" 
            linethickness=3px                   
            linestyle=1                      
            color=colors("vibrantColor1")                 
            contrastcolor=colors("vibrantColor1");
***************** Default Graph Outilne *****************;
    class GraphOutlines /
            color=white
            contrastcolor=white
            linethickness = 1px
            linestyle = 1;
***************** Graph Axis Lines *****************;          
    class GraphAxisLines / /*X-, Y-, and Z-axis lines*/
          tickdisplay = "outside"
          linethickness = 1px
          linestyle = 1;
***************** Graph Wall *****************;      
    class GraphWalls /
          color=white
          frameBorder=off;
***************** Graph Border *****************;      
    class GraphBorderLines /
          contrastColor=white;
***************** Graph Title Text *****************;
    class GraphTitleText / 
            color=colors('textColor')
            fontsize=16pt
            fontFamily="Calibri";
***************** Graph Label *****************;
    class GraphValueText /
          color=colors('textColor')
          fontFamily="Calibri";
***************** Graph Label *****************;
    class GraphLabelText /
          color=colors('textColor')
          fontSize=14pt
          fontFamily="Calibri";
***************** Default Graph Style *****************;
    class GraphColors /  
       /*FILL COLORS*/
           'gdata1' = colors("vibrantColor1")
           'gdata2' = colors("vibrantColor2")  
           'gdata3' = colors("vibrantColor3")  
           'gdata4' = colors("vibrantColor4")  
           'gdata5' = colors("vibrantColor5")  
           'gdata6' = colors("vibrantColor6")
           'gdata7' = colors("vibrantColor7")
           'gdata8' = colors("vibrantColor8") 
       /*LINE and MARKER COLORS*/
           'gcdata1' = colors("vibrantColor1") 
           'gcdata2' = colors("vibrantColor2")  
           'gcdata3' = colors("vibrantColor3")  
           'gcdata4' = colors("vibrantColor4")  
           'gcdata5' = colors("vibrantColor5")  
           'gcdata6' = colors("vibrantColor6")
           'gcdata7' = colors("vibrantColor7")
           'gcdata8' = colors("vibrantColor8");
***************** Group Graph Attributes *****************;
    class GraphData1 /
        fillpattern = "L1"
        markersymbol = "circlefilled"
        linethickness=3pt
        linestyle = 1 ;
    class GraphData2 /
        fillpattern = "L1"
        markersymbol = "circlefilled"
        linestyle = 1;
    class GraphData3 /
        fillpattern = "L1"
        markersymbol = "circlefilled"
        linestyle = 1;
    class GraphData4 /
        fillpattern = "L1"
        markersymbol = "circlefilled"
        linestyle = 1;
    class GraphData5 /
        fillpattern = "L1"
        markersymbol = "circlefilled"
        linestyle = 1;
    class GraphData6 /
        fillpattern = "L1"
        markersymbol = "circlefilled"
        linestyle = 1;
    class GraphData7 /
        fillpattern = "L1"
        markersymbol = "circlefilled"
        linestyle = 1;
    class GraphData8 /
        fillpattern = "L1"
        markersymbol = "circlefilled"
        linestyle = 1;
    end;
run;




*********************************;
*Step 3 - Create Output File    *;
*********************************;
%createHTML5;