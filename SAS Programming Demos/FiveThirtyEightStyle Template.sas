
/**/
/*'fivethirtyeight': RcParams({'axes.axisbelow': True,*/
/*           'axes.edgecolor': '#f0f0f0',*/
/*           'axes.facecolor': '#f0f0f0',*/
/*           'axes.grid': True,*/
/*           'axes.labelsize': 'large',*/
/*           'axes.linewidth': 3.0,*/
/*           'axes.prop_cycle': cycler('color', ['#008fd5', '#fc4f30', '#e5ae38', '#6d904f', '#8b8b8b', '#810f7c']),*/
/*           'axes.titlesize': 'x-large',*/
/*           'figure.facecolor': '#f0f0f0',*/
/*           'figure.subplot.bottom': 0.07,*/
/*           'figure.subplot.left': 0.08,*/
/*           'figure.subplot.right': 0.95,*/
/*           'font.size': 14.0,*/
/*           'grid.color': '#cbcbcb',*/
/*           'grid.linestyle': '-',*/
/*           'grid.linewidth': 1.0,*/
/*           'legend.fancybox': True,*/
/*           'lines.linewidth': 4.0,*/
/*           'lines.solid_capstyle': 'butt',*/
/*           'patch.edgecolor': '#f0f0f0',*/
/*           'patch.linewidth': 0.5,*/
/*           'savefig.edgecolor': '#f0f0f0',*/
/*           'savefig.facecolor': '#f0f0f0',*/
/*           'svg.fonttype': 'path',*/
/*           'xtick.major.size': 0.0,*/
/*           'xtick.minor.size': 0.0,*/
/*           'ytick.major.size': 0.0,*/ 
/*           'ytick.minor.size': 0.0}),*/


proc template;
	source styles.default /
		store=sashelp.tmplmst;
run;

proc template;
	source styles.htmlblue /
		store=sashelp.tmplmst;
run;


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
        'gdata6' = cx810f7c
		'gcdata7' = cx19bbb8
		'gdata7' = cx19bbb8
		'gcdata8' = cx8d2a90
		'gdata8' = cx8d2a90
		'gcdata9' = cx00b08d
		'gdata9' = cx00b08d
		'gcdata10' = cx04304b
		'gdata10' = cx04304b
;

************COLORS****************;
	class GraphTitleText / /*Enlarage title and make black*/
		color=GraphColors('maintext')
		fontSize=30px;
	class GraphBackground /
		color=GraphColors('background');
	class GraphWalls /
		color=GraphColors('background') 
		FrameBorder=off;
	class GraphAxisLines / 	/*X-, Y-, and Z-axis lines*/
      tickdisplay = "inside"
      linethickness = 0px
      linestyle = 1;
	class GraphBorderLines /
		linethickness=0;
	class GraphGridLines / /*Horizontal and vertical grid lines drawn at major tick marks*/
         displayopts = "on"
         color = cxcbcbcb
		 contrastcolor=cxcbcbcb
		 LineThickness=1;
	class GraphOutlines / /*Outline properties for fill areas such as bars, pie slices, box plots, ellipses, and histograms*/
		contrastcolor=GraphColors('background');
	class GraphLabelText /
		color=GraphColors('maintext')
		FontSize=20px;
	class GraphValueText /
		color=cx1B2A33
		fontsize=20px;
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
	class GraphData7 /
      fillpattern = "L1"
      markersymbol = "circlefilled"
      linestyle = 1;
   class GraphData8 /
      fillpattern = "L1"
      markersymbol = "circlefilled"
      linestyle = 1;
   class GraphData9 /
      fillpattern = "L1"
      markersymbol = "circlefilled"
      linestyle = 1;
   class GraphData10 /
      fillpattern = "L1"
      markersymbol = "circlefilled"
      linestyle = 1;
   class GraphData11 /
      fillpattern = "L1"
      markersymbol = "circlefilled"
      linestyle = 1;
   class GraphData12 /
      fillpattern = "L1"
      markersymbol = "circlefilled"
      linestyle = 1;
	end;
run;


ods html5 (ID=EGHTML) style=fivethirtyeight;
proc sgplot data=sashelp.cars;
	title "Test the title";
	vbar Origin / group=DriveTrain;
run;

proc sgplot data=sashelp.cars;
	vline Cylinders / group=DriveTrain markers legendlabel='test';
run;

ods html5 close;