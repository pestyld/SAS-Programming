ods path work.mytemps(update) sashelp.tmplmst(read);

proc template;
    define statgraph multipanel;
    notes 'HOW TO USE THE GRAPH TEMPLATE';
    notes 'Required Variables: XVAR and YVAR';
    
    dynamic 
          test;
          
      begingraph;
  if (exists(test))=0;
     test="peter";
  else
      	
        entrytitle "Does it work? " test;
        layout lattice / rows=2 rowweights=(0.3 0.7) 
                         rowgutter=15px rowdatarange=union 
                         columns=2 columnweights=(0.7 0.3) 
                         columngutter=10px columndatarange=union;
          columnaxes;
            columnaxis / display=(tickvalues label) 
                         griddisplay=on
                         gridattrs=(color=white);
            columnaxis / display=none 
                         griddisplay=on
                         gridattrs=(color=white);
          endcolumnaxes;
          rowaxes;
            rowaxis / display=none 
                      griddisplay=on
                      gridattrs=(color=white);
            rowaxis / display=(tickvalues label) 
                      griddisplay=on
                      gridattrs=(color=white);
          endrowaxes;
          *Cell 1;
          layout overlay / walldisplay=(fill) wallcolor=cxF0F0F0;
            histogram Sales /
                   fillattrs=(color=thistle)
                   outlineattrs=(color=white);
            densityplot Sales / kernel()
                   lineattrs=(color=mediumpurple);
          endlayout;
          *Cell 2;
          layout overlay / walldisplay=(fill) wallcolor=cxF0F0F0;
            entry ' '; /*empty*/
          endlayout;
          *Cell 3;
          layout overlay / walldisplay=(fill) wallcolor=cxF0F0F0;
            modelband 'myreg' /  fillattrs=(color=mistyrose);
            scatterplot x=Sales y=Profit /
                   markerattrs=(color=thistle
                                symbol=circlefilled
                                size=6pt);
            regressionplot x=Sales y=Profit / 
                   clm='myreg' alpha=0.01
                   lineattrs=(color=mediumpurple);
          endlayout;
          *Cell 4;
          layout overlay / walldisplay=(fill) wallcolor=cxF0F0F0;
            histogram Profit / orient=horizontal
                   fillattrs=(color=thistle)
                   outlineattrs=(color=white);
            densityplot Profit / kernel() orient=horizontal
                   lineattrs=(color=mediumpurple);
          endlayout;
        endlayout;         
      endgraph;
    end;
run;

proc sgrender data=og.profit 
              template=multipanel;
run;


proc template;
    source multipanel; 
run;

proc template;
	list / store=work.mytemps;
run;

ods path show;

ods path reset;

ods path show;