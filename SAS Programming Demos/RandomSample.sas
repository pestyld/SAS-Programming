data randomobs;
	Sample=10; /*Random sample*/
	ObsLeft=TotalObs; /*Total obs of data set*/

/*If I have samples left and obs to choose from, continue*/
	do while(Sample>0 and ObsLeft>0);
		PickIt + 1; /*Obs that is being selected*/
		PctRemaining=Sample/ObsLeft;
		Random=ranuni(0);
		if Random<PctRemaining then do;
			ObsPicked=PickIt;
			set sashelp.airline point=PickIt nobs=TotalObs;
			output;
			Sample=Sample-1; /*Decrease remaining samples*/
		end;
		ObsLeft=ObsLeft-1;/*Decrease remaining obs left*/
	end;
	stop; /*after sample size or remaining obs are selected, stop*/
	drop Sample Obsleft pctremaining random obspicked;
run;


title1 'Customer Satisfaction Survey';
title2 'Simple Random Sampling';
proc surveyselect data=sashelp.airline 
   method=srs n=15 out=SampleSRS;
run;

proc print data=samplesrs;
run;
proc print data=sashelp.airline;
run;