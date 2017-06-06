function Print_RateData(Key)
	load CrosssectionDB
	%CrosssectionDB.Key(Key).Plot_Crosssection('on')
	%CrosssectionDB.Key(Key).Plot_RateCoefficient('on')
	%Proceed = input('Proceed (Y/N): ','s');
	%if strcmpi(Proceed,'Y')
		FileID = fopen(['RateData/',Key],'w');
		fprintf(FileID,'%s\n',['Key: ',Key]);
		fprintf(FileID,'Te (eV), Rate Coefficient (m^3s^-1)\n');
		TeList = [0.5:0.1:10];
		for Te = TeList
			fprintf(FileID,'%g,\t%g\n',Te,CrosssectionDB.Key(Key).Rate(Te));
		end
	%end
	fclose(FileID);
end