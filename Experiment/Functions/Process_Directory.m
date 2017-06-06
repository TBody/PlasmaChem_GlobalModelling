function [IonStruct,NeutralStruct] = Process_Directory(Directory,PropertyQuery)
	dirfiles = dir(Directory)';
	dirStruct = struct;
	IonCount = 0;
	IonStruct = struct;
	NeutralCount = 0;
	NeutralStruct = struct;
	for file = dirfiles
		Filename = strrep(Directory,'*.csv',file.name);
		if nargin > 1
			LS = LineScan(Filename,PropertyQuery);
		else
			LS = LineScan(Filename);
		end
		if strfind(Filename,'ions')
			IonCount = IonCount + 1;
			IonStruct(IonCount).Scan = LS;
			IonStruct(IonCount).Mass = LS.Mass;
			IonStruct(IonCount).meanCount = LS.meanCount;
			IonStruct(IonCount).stdCount = LS.stdCount;
		elseif strfind(Filename,'neutrals')
			NeutralCount = NeutralCount + 1;
			NeutralStruct(NeutralCount).Scan = LS;
			NeutralStruct(NeutralCount).Mass = LS.Mass;
			NeutralStruct(NeutralCount).meanCount = LS.meanCount;
			NeutralStruct(NeutralCount).stdCount = LS.stdCount;
		else
			disp(sprintf('%s not identified as ionic or neutral - skipped',file.name))
		end
			
	end
end