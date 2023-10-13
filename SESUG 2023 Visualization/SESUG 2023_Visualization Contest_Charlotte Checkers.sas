/****************************************************************/
/* SESUG VISUALIZATION PROJECT 1                                */
/****************************************************************/

/**************/
/* SET PATHS  */
/**************/
/* Find the current project root folder. */
%let fileName =  /%scan(&_sasprogramfile,-1,'/');
%let path = %sysfunc(tranwrd(&_sasprogramfile, &fileName,));

/* Outpath to data folder */
%let data = &path./data;

/* Path to images */
%let images = &path./images;



/**********************/
/* LIBNAME references */
/**********************/

/* Raw data Excel file */
options validvarname=v7;
libname xl xlsx "&data./SESUG 2023_Visualization Contest_Charlotte Checkers.xlsx";

/* Final data output folder */
libname out "&data/";



/************************/
/* SEASON OVERVIEW      */
/************************/
proc print data=xl.'season overviews'n;
run;



/*************************************/
/* DATA PREP                         */
/*************************************/

/* Create custom sort order for Season */
proc format; 
	invalue $seasonOrder 
		'2022 - 2023' = 5 
		'2021 - 2022' = 4
		'2019 - 2020' = 3 	
		'2018 - 2019' = 2 
		'2017 - 2018' = 1;
run; 


/* Prepare the Excel data and create a SAS data set */
options validvarname=v7;
data season_overviews;
	set xl.'season overviews'n;
	
	/* Remove random missing rows */
	where season is not null;
	
	/* Add a column to use a the sort value for seasons */
	sortSeason = input(Season, $seasonOrder.);
	
	/* Create character columns to use as data labels (ex. 10 W, 10 L, 100 Points) */
	PointsLabel=cat('  ',Points,' ','Points');
	WinsLabel=catx(' ',Wins, 'W');
	LossesLabel=catx(' ',Losses, 'L');
	OTLabel = catx(' ', OT_Losses, 'OT');
	
	/* Create goal differential. Not sure if using */
	Diff_num = Goals_Scored - Goals_Allowed;
	Diff = cats('+',Diff_num);
	
	/* Create a column indicating the year without playoffs. Not sure if using */
	if Playoffs = 'no playoffs' then NoPlayoffs=Points + 23;
		else NoPlayoffs=.;
		
	/* Create labels */
	label
		points = 'Total Points'
		diff = 'Goal Differential'
	;
run;

libname xl clear;

/* Sort the data by descending season */
proc sort data=season_overviews out=out.season_overviews_final;
	by descending sortSeason;
run;

/* Final preview */
proc print data=out.season_overviews_final;
run;



/*****************************************/
/* DATA VISUALIZATION                    */
/*****************************************/

/* COLORS */
%let barColorGray = cxDADEDF;
%let modernBlue = cx0066FF;
%let modernRed = cxFF4040;
%let modernGray = cx636363;
%let modernGreen = cx009C41;
%let LabelColor = charcoal;
%let titleTextColor = white;

/* FONTS */
%let labelSize = 13pt;
%let tickSize = 11pt;
%let smDataLabels=9pt;
%let lgDataLables=13pt;
%let smMarkerSize=11pt;

/* MISC */
%let barWidthSize=.08;

/* ANNOTATION TABLE */
%include "&path./anno_table.sas";

/* DATA VISUALIZATION */
ods graphics / width=10in height=5in;
title  height=19pt justify=left color=&titleTextColor  "            The Charlotte Checkers have made the playoffs in 4 out of the";
title2 height=19pt justify=left color=&titleTextColor  "            last 5 seasons";
title3 height=7pt justify= left color=&titleTextColor italic '                                *Checkers did not participate in the 2020-21 season during the Covid pandemic';
footnote height=8pt justify=left color=&LabelColor italic 'Teams will be awarded two points for a win (in regulation, in overtime or in a shootout), one point for an overtime loss or a shootout loss and zero points for a regulation loss.';
footnote2 height=8pt justify=left color=&LabelColor italic 'The shootout showings information is not shown in the visualization.';
proc sgplot data=out.season_overviews_final
			nowall 
			noborder
			sganno=annotable;
	symbolimage name=puck image="&images\flat_hockey_puck.png";
	hbarparm category=Season response=points / 
		nooutline 
		fillattrs=(color=&barColorGray) 
		barwidth=&barWidthSize 
		legendLabel='Bar Points'
	;
	scatter x=Points y=Season /
		markerattrs=(size=18pt symbol=puck) 
		filledoutlinedmarkers
		legendlabel='Total Points'
		datalabel=PointsLabel datalabelpos=right datalabelattrs=(size=&lgDataLables color=&labelColor)
	;
	scatter x=OT_Losses y=Season /
		markerattrs=(size=&smMarkerSize symbol=CircleFilled ) 
		markerfillattrs=(color=&modernGray)
		markeroutlineattrs=(color=white)
		filledoutlinedmarkers
		legendlabel='Overtime Losses'
		datalabel=OTLabel datalabelpos=top datalabelattrs=(size=&smDataLabels color=&labelColor) 
	;
	scatter x=Losses y=Season /
		markerattrs=(size=&smMarkerSize symbol=CircleFilled ) 
		markerfillattrs=(color=&modernRed)
		markeroutlineattrs=(color=white)
		filledoutlinedmarkers
		legendlabel='Losses'
		datalabel=LossesLabel datalabelpos=top datalabelattrs=(size=&smDataLabels color=&labelColor)
	;
	scatter x=Wins y=Season /
		markerattrs=(size=&smMarkerSize symbol=CircleFilled) 
		markerfillattrs=(color=&modernBlue)
		markeroutlineattrs=(color=white)
		filledoutlinedmarkers
		legendlabel='Wins'
		datalabel=WinsLabel datalabelpos=top datalabelattrs=(size=&smDataLabels color=&labelColor)
	;
/* 	hbarparm category=Season response=NoPlayoffs /  */
/* 		nooutline */
/* 		fillattrs=(color=&modernRed transparency=.7); */
	xaxis min=2 
	      offsetmin=0 
	      values=(0 to 120 by 20)
	      valueattrs=(color=&LabelColor size=&labelSize)
	      labelattrs=(color=&LabelColor size=&labelSize)
	      display=NONE
	      ;
	yaxis valueattrs=(color=&LabelColor size=&labelSize)
		  labelattrs=(color=&LabelColor size=&labelSize)
		  display=(NOTICKS) 
		  labelpos=top  
		  ;
	keylegend /
		position=topleft 
		exclude=('Bar Points' 'NoPlayoffs')
		noborder
		noopaque
		;
run;
title;
footnote;

ods graphics / reset;