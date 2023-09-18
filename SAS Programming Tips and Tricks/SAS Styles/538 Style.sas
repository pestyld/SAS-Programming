proc template;
     define style styles.fivethirtyeight;
     parent=styles.htmlblue;
************COLORS****************;
     class GraphColors /
          'gdata' = cx008fd5
          'background' = cxf0f0f0 
          'maintext' = cx1B2A33
          'gcdata1' = cx008fd5
        'gdata1' = cx008fd5
          'gcdata2' = cxfc4f30
        'gdata2' = cxfc4f30
          'gcdata3' = cxe5ae38
        'gdata3' = cxe5ae38
          'gcdata4' = cx6d904f
        'gdata4' = cx6d904f
          'gcdata5' = cx8b8b8b
        'gdata5' = cx8b8b8b
          'gcdata6' = cx810f7c
        'gdata6' = cx810f7c;
************COLORS****************;
     class GraphTitleText / /*Enlarage title and make black*/
          color=GraphColors('maintext')
          fontSize=30px;
     class GraphBackground /
          color=GraphColors('background');
     class GraphWalls /
          color=GraphColors('background') 
          FrameBorder=off;
     class GraphAxisLines / /*X-, Y-, and Z-axis lines*/
      tickdisplay = "inside"
      linethickness = 0px
      linestyle = 1;
     class GraphBorderLines /
          linethickness=0;
     class GraphGridLines / /*Horizontal and vertical grid lines drawn at major tick marks*/
         displayopts = "on"
         color = cxcbcbcb
         contrastcolor=cxcbcbcb
         lineThickness=1;
     class GraphOutlines / /*Outline properties for fill areas such as bars, pie slices, box plots, ellipses, and histograms*/
          contrastcolor=GraphColors('background');
     class GraphLabelText /
          color=GraphColors('maintext')
          FontSize=20px;
     class GraphLegendBackground / 
          color=GraphColors('background');
     class GraphDataDefault /
          contrastcolor=GraphColors('gdata') 
          color=GraphColors('gdata')
          linethickness=4px 
          markersize=9px
          markersymbol = "circlefilled";
     class GraphData1 /
      fillpattern = "L1"
      markersymbol = "circlefilled"
      linestyle = 1;
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
     end;
run;



%macro createHTML5(fileLoc=S:\,        /*<---Location of output file*/
                   fileName=style538.html,   /*<---Name of output file*/
                   styleName=fivethirtyeight); /*<---ODS style template*/

ods html5 path="&fileLoc" 
          file="&fileName" style=&styleName;

/*BAR*/
title "Type of Cars";
proc sgplot data=sashelp.cars;
    vbar Type;
run;
title;

/*BAR with GROUP*/
title "Type w/Group";
proc sgplot data=sashelp.cars;
    vbar Type / group=Origin;
run;
title;

/*VLINE*/
title "Origin";
proc sgplot data=sashelp.cars;
    vline Origin / markers;
run;
title;

/*VLINE with GROUP*/
title "Origin w/Group";
proc sgplot data=sashelp.cars;
    vline Origin / group=Type markers;
run;
title;

/*SCATTER with GROUP*/
title "City vs Highway by Make";
proc sgplot data=sashelp.cars;
    scatter x=MPG_City y=MPG_Highway /group=Make;
run;

ods html5 close;
%mend;


%createHTML5;