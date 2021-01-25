/*Change the following macro variables*/

%let logpath =/*Log file directory*/;
%let filename = /*Log file full name*/;

data logdata;
   retain flag 0;
   drop flag;
   infile "&logpath.\&filename" truncover end=last;
   logfile = "&filename";
   line+1;
   input text $1024.;
   if (    find(text, 'ERROR:')  
        or find(text, 'WARNING:') 
        or find(text, 'REPEATS OF BY VALUES','i') 
        or find(text, 'UNINITIALIZED','i') 
        or find(text, 'FORMAT WAS TOO SMALL','i') 
        or find(text, 'HAVE BEEN CONVERTED TO','i') 
        or find(text, 'INVALID ARGUMENT','i') 
        or find(text, 'OPERATIONS COULD NOT BE PERFORMED','i') 
        or find(text, 'BECAUSE OF ERRORS','i')
        or find(text, 'SYNTAX CHECKING MODE','i')
       )
       and not index(text, 'NO MATCHING MEMBERS IN DIRECTORY') then
      do;
         flag = 1;
         output;
      end;
   else if last and flag = 0 then
      do;
         text = '(none)';
         output;
      end;
   label text='Log entry requiring explanation';
run;

title "Errors, warnings and notes in the SAS log requiring justification:";
proc sql;
select * from logdata;
quit;
