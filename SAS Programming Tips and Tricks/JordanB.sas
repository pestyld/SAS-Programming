data raw;
input myvar $;
datalines;
1a
1b
1c
1d
comment
other
2a
2b
2c
comment
other
3a
3b
comment
other
;
run;

data new;
	set raw;
	length letter $3. previousletter $3.;
/*Will use this to retain the previous value if needed*/
	retain NumValue 1 previousletter 'a' charrank 0;
/*Use scan to find the number in the original string. a modifier uses characters as a separator*/
	num = scan(myvar,1,,'a');
/*Use scan to find the letter in the original string. d modifier uses digits as a separator*/
	letter = scan(myvar,1,,'d');
/*If there is no digit in the string, then it has comment/other in the value*/
	if anydigit(num)=0 then do; 
		/*Set the num here to be the previous numValue. First case will use the default 1*/
		num=NumValue;
		/*If it's comment/other that means we need the next letter in the series. Use the charrank value*/
		charrank=charrank+1;
	end;
	else do;
		/*If it's a a digit then set the NumValue as the normal number from scan*/
		NumValue=num;
		/*If it's a a digit then set the previousletter as the normal letter from scan*/
		previousletter=letter;
		/*Get the character number in the ASCII sequence*/
		charrank = rank(previousletter);
	end;
	/*Get the character from the byte function which uses a number to determine the letter in ASCII*/
	bytetest=byte(charrank);
	NewValue=cats(NumValue,bytetest);
	drop num letter;
run;

