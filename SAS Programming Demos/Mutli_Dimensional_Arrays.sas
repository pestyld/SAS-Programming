data test;
	array multi{3,2} (1,2,
					  3,4,
					  5,6);

	do i=1 to 3;
		do j=1 to 2;
			multi{i,j} = multi{I,j}*10;
			putlog i= j= multi{i,j}=;
		end;
	end;
run;