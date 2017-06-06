classdef LineScan < handle
	properties
		Filename
		Datetime
		Pressure
		H2partialpressure
		Power
		Comment
		HeaderStruct
		DataStruct
		Mass
		meanCount
		stdCount
	end
	methods
		function obj = LineScan(Filename,PropertyQuery)
			obj.Filename                = Filename;
			obj.HeaderStruct            = struct;
			obj.DataStruct              = struct;
			if nargin > 1
				ShortFilename = strsplit(Filename,'/');
				disp(sprintf('Importing file %s',ShortFilename{end}))
				obj.Process_PropertyQuery(PropertyQuery)
			end
			[Cycle,Time,Mass,CountRate] = obj.Read_MS_csv(Filename);
			obj.Build_DataStruct(Cycle,Time,Mass,CountRate);
			obj.Calculate_uncertainty(Cycle,Mass,CountRate);
		end
		function Process_PropertyQuery(obj,PropertyQuery) 
			if ismember('Power',PropertyQuery)
				obj.Power                  = input('Power (W): ');
			end
			if ismember('Pressure',PropertyQuery)
				obj.Pressure               = input('Pressure (mTorr): ');
			end
			if ismember('Composition',PropertyQuery)
				obj.H2partialpressure          = input('H2 proportion (%): ')/100;
			end
			if ismember('Comment',PropertyQuery)
				obj.Comment                = input('Comment: ','s');
			end
		end
		function Build_DataStruct(obj,Cycle,Time,Mass,CountRate)
			for index                       = min(Cycle):max(Cycle)
			obj.DataStruct(index).Time      = Time(Cycle==index);
			obj.DataStruct(index).Mass      = Mass(Cycle==index);
			obj.DataStruct(index).CountRate = CountRate(Cycle==index);
			end
		end
		function [Cycle,Time,Mass,CountRate] = Read_MS_csv(obj,Filename)
			%%Open file at Filename
				fileID           = fopen(Filename);
			%%Skip first line
				TotalScansSplit  = strsplit(fgetl(fileID),',');
				TotalScans       = str2num(TotalScansSplit{1});
				Count            = 0;
				Cycle            = zeros(TotalScans,1);
				Time             = zeros(TotalScans,1);
				Mass             = zeros(TotalScans,1);
				CountRate        = zeros(TotalScans,1);
			%%Read the header info line
				Read_file_header(obj,fileID)
			%%Skip the data header line
				fgetl(fileID);
			%%Loop through the data
				DataLine         = fgetl(fileID);
				while ischar(DataLine)
				Count            = Count + 1;
				DataSplit        = strsplit(DataLine,',');
				Cycle(Count)     = str2num(DataSplit{1});
				Time(Count)      = str2num(DataSplit{3});
				Mass(Count)      = str2num(DataSplit{4});
				CountRate(Count) = str2num(DataSplit{5});
				DataLine         = fgetl(fileID);
				end
			%%Close the file
				frewind(fileID);
				fclose(fileID);
		end
		function Read_file_header(obj,fileID)
			%%Read header line
			Raw                    = fgetl(fileID);
			%%Process to find number of header lines
			RawSplit               = strsplit(Raw,',');
			HeaderLines            = str2num(RawSplit{2});
			%%Read date and time
			DatetimeLine           = fgetl(fileID);
			DatetimeSplit          = strsplit(DatetimeLine,',');
			obj.Datetime           = datetime(strjoin(DatetimeSplit([2,4])),'InputFormat','dd/MM/uuuu hh:mm:ss aa');
			%%Read the rest of the header and save into obj.HeaderStruct
			for i                  = 1:HeaderLines - 3
			hLine                  = fgetl(fileID);
			hSplit                 = strsplit(hLine,',');
			hValue                 = strjoin(hSplit(2:end));
			hValue                 = strrep(hValue,',','');
			hValue                 = strrep(hValue,'"','');
			hID                    = matlab.lang.makeValidName(hSplit{1},'ReplacementStyle','delete');
			if strcmpi('ScanID',hID)
				fgetl(fileID);
			elseif strcmpi('Environment',hID)
			else
				%disp(sprintf('%s: %s',hID,hValue))
			obj.HeaderStruct.(hID) = hValue;
				end
			end
		end
		function Calculate_uncertainty(obj,Cycle,Mass,CountRate)
			Count                = 0;
			obj.Mass             = unique(Mass);
			obj.meanCount        = zeros(1,length(obj.Mass));
			obj.stdCount         = zeros(1,length(obj.Mass));
			for mass             = obj.Mass'
			Count                = Count + 1;
			obj.meanCount(Count) = mean(CountRate(Mass == mass));
			obj.stdCount(Count)  = std(CountRate(Mass  == mass));
			end
		end
		function return_BarPlot = BarPlot(obj,errorbar_on)
			return_BarPlot = figure;
			BarPlot = bar(obj.Mass,obj.meanCount,0.3);
			%BarPlot.Parent.YScale = 'log';
			FilenameSplit = strsplit(obj.Filename,'/');
			PlotTitle = strrep(FilenameSplit{end},'.csv','');
			title(PlotTitle)
			xlabel('Mass (amu)')
			ylabel('Counts per second')
			if strcmpi(errorbar_on,'on')
				hold on	
				errorbar(obj.Mass,obj.meanCount,obj.stdCount,'.');
			end
		end
	end
end