/*Customized proc print settings examples*/
/*Directions: You can run each step and view customized reports*/


/*SAS Documentation URL: http://go.documentation.sas.com/?docsetId=proc&docsetVersion=9.4&docsetTarget=n1prb5fbpuk828n1ama5ky37do0e.htm&locale=en*/
proc print data=sashelp.cars n obs='Observation Number'
	     style(n)={backgroundcolor=light blue fontstyle=italic}
	     style(header obs obsheader)={backgroundcolor=light yellow 
									 color=blue 
									 fontstyle=italic
									 just=c};/*Variety of options for headings*/
     var make weight / style(data)={backgroundcolor=very light blue};/*Change data options*/
	 var model MPG_City MPG_Highway;/*Leave these at the defaults, no changes*/
run;

/*URL = https://communities.sas.com/t5/Base-SAS-Programming/Proc-print-Center-justify-column-heading/td-p/106814*/
title color=firebrick 'Make the report very wide to see justification' ;
proc print data=sashelp.class(obs=20)
  			style(header)={just=c foreground=black}
  			style(table)={width=100%};/*Change heading options*/
  var name / style(data)={just=r}/*Right align*/
             style(header)={background=pink};/*background color for heading for name only*/
  var age / style(data)={just=l}; /*Left alone data for age only*/
  var sex height / style(data)={just=c} /*Right align data for sex and height*/
                   style(header)={background=yellow}; /*Header yellow for sex and height*/
  var weight / style(data)={just=l}; /*left justify weight data*/
run;