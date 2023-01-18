options emailhost='mailhost.fyi.sas.com' emailsys=smtp;

filename msg EMAIL 
	TO=("Email Address 1" "Email Address 2 (optional)") /*Where to email*/
	FROM = "Your Email Address" /*From who*/
	SUBJECT="Your Subject Line"; /*Subject line*/
/*If you want to attach a file, add the following option after subject inside the semi 
colon. It will find that file and attach it for you.*/ 
*ATTACH = "FileLocation.csv" ;

/*Email message. Must run the entire program*/
data _null_;
	file msg;
		put "I am emailing myself from SAS!";
		put "I can also attached files to my email if I would like!";
		put "I can keep writing things!";
		put "";
		put "Or put a space between lines!";
run;