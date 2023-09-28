/*********************************************/
/* CREATE ANNOTATION TABLE FOR VISUALIZATION */
/*********************************************/

/* Create annotation table */
%let playoffPosition = 140;
%let championPosition = %sysevalf(&playoffPosition+10);

/* Image annotations */
data annotable;
	length function $20 x1space $ 13 y1space $ 13 image $150 ;
	set out.season_overviews_final(keep=Season Points Playoffs) end=last;
	/* ADD PLAYOFF IMAGE */
	if Playoffs ne 'no playoffs' then do;
		image = "&images.\playoffs.png";
		function = 'image';
		x1space = "datavalue";
		y1space = "datavalue";
		x1 = &playoffPosition;
		yc1 = Season;
		output;
	end;
	/* ADD LEAGUE CHAMPION IMAGE AND ASSOCIATED LABEL */
	if Playoffs = 'League Champions' then do;
		/* TROPHY IMAGE */
		image = "&images.\trophy.png";
		function = 'image';
		x1space = "datavalue";
		y1space = "datavalue";
		x1 = &championPosition;
		yc1 = Season;
		output;
		
		/* LEAGUE CHAMPION TEXT */
		function = 'text';
		label = 'League Champions!';
		x1 = &championPosition + 12;
		width = 14;
		textweight='BOLD';
		textColor = "&modernGreen";
		output;
	end;

	if last=1 then do;
		/* ADD CHARLOTTE CHECKERS LOGO */
		call missing (of _all_);
		image = "&images.\charlotte_checkers2.png";
		function = 'image';
		x1 = 2;
		y1 = 98;
		x1space = "GRAPHPERCENT";
		y1space = "GRAPHPERCENT";
		anchor='TOPLEFT';
		output;
		
		/* ADD PLAYOFF LABEL TEXT ABOVE ALL IMAGES*/
		call missing (of _all_);
		function = 'text';
		label = 'Playoffs';
		x1space = "datavalue";
		x1 = &playoffPosition;
		y1 = 80;
		textcolor = "&labelColor";
		textsize = 12;
		textweight = 'bold';
		width = 13;
		output;
		
		/* ADD RECTANGLE WITH BLACK BACKGROUND COLOR AROUND TITLES */
		call missing (of _all_);
		function = 'rectangle';
		x1space = "GRAPHPERCENT";
		y1space = "GRAPHPERCENT";
		x1 = 0;
		y1 = 100;
		height = 19;
		width = 100;
		heightunit = 'PERCENT';
		widthunit = 'PERCENT';
		fillcolor = 'black';
		anchor = 'TOPLEFT';
		display = 'FILL';
		layer = 'BACK';
		output;
	end;
	drop Season Points Playoffs;
run;

/* Text Annotations */
proc print data=annotable;
run;