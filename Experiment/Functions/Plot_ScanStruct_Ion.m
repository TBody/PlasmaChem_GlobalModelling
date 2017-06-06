function OutputFigure = Plot_ScanStruct_NeutralCracking2(ScanStruct,Variable,Labels)
	MassList = [1,2,14,15,16,17,18,28];
	ScanCellCount = cell(length(ScanStruct),length(MassList));
	ScanVariable = zeros(1,length(ScanStruct));
	for ScanIndex = 1:length(ScanStruct)
		ScanVariable(ScanIndex) = ScanStruct(ScanIndex).Scan.(Variable);
		Mass = ScanStruct(ScanIndex).Mass;
		ScanData = [ScanStruct(ScanIndex).Scan.DataStruct.CountRate];
		for MassIndex = 1:length(MassList)
			MassIndex_inScan = find(Mass == MassList(MassIndex));
			if MassIndex_inScan
				ScanCellCount{ScanIndex,MassIndex} = ScanData(MassIndex_inScan,:);
			else
				ScanCellCount{ScanIndex,MassIndex} = [];
			end
		end
	end
	UniqueVariable = unique(ScanVariable);
	ScanmeanCount = NaN(length(UniqueVariable),length(MassList));
	ScanstdCount = NaN(length(UniqueVariable),length(MassList));
	for Unique = 1:length(UniqueVariable)
		MatchedScans = find(ScanVariable == UniqueVariable(Unique));
		for MassIndex = 1:length(MassList)
			CombinedCounts = [ScanCellCount{MatchedScans,MassIndex}];
			ScanmeanCount(Unique,MassIndex) = mean(CombinedCounts);
			ScanstdCount(Unique,MassIndex) = std(CombinedCounts);
		end
	end
	ScanDependent = UniqueVariable;
	CountRaw = containers.Map('KeyType','double','ValueType','any');
	ErrorRaw = containers.Map('KeyType','double','ValueType','any');
	CountMap = containers.Map('KeyType','char','ValueType','any');
	ErrorMap = containers.Map('KeyType','char','ValueType','any');
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	CountMap('H+')	= ScanmeanCount(:,find(MassList == 1))*8.87*10^9;
	CountMap('H2+')	= ScanmeanCount(:,find(MassList == 2))*8.87*10^9;
	CountMap('N+')	= ScanmeanCount(:,find(MassList == 14))*8.87*10^9;
	CountMap('NH+')	= ScanmeanCount(:,find(MassList == 15))*8.87*10^9;
	CountMap('NH3+')= ScanmeanCount(:,find(MassList == 17))*8.87*10^9;
	CountMap('N2+')	= ScanmeanCount(:,find(MassList == 28))*8.87*10^9;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	ErrorMap('H+')	= ScanstdCount(:,find(MassList == 1))*8.87*10^9;
	ErrorMap('H2+')	= ScanstdCount(:,find(MassList == 2))*8.87*10^9;
	ErrorMap('N+')	= ScanstdCount(:,find(MassList == 14))*8.87*10^9;
	ErrorMap('NH+')	= ScanstdCount(:,find(MassList == 15))*8.87*10^9;
	ErrorMap('NH3+')= ScanstdCount(:,find(MassList == 17))*8.87*10^9;
	ErrorMap('N2+')	= ScanstdCount(:,find(MassList == 28))*8.87*10^9;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	OutputFigure = figure;
	hold on
	PlotH = errorbar(ScanDependent,CountMap('H+'),ErrorMap('H+'));
	PlotH.Color = [0.9290    0.6940    0.1250];
	PlotH2 = errorbar(ScanDependent,CountMap('H2+'),ErrorMap('H2+'));
	PlotH2.Color = [0.8500    0.3250    0.0980];
	PlotN = errorbar(ScanDependent,CountMap('N+'),ErrorMap('N+'));
	PlotN.Color = [0.4940    0.1840    0.5560];
	PlotNH = errorbar(ScanDependent,CountMap('NH+'),ErrorMap('NH+'));
	PlotNH.Color = [0.3010    0.7450    0.9330];
	PlotNH3 = errorbar(ScanDependent,CountMap('NH3+'),ErrorMap('NH3+'));
	PlotNH3.Color = [0.6350    0.0780    0.1840];
	PlotN2 = errorbar(ScanDependent,CountMap('N2+'),ErrorMap('N2+'));
	PlotN2.Color = [0.4660    0.6740    0.1880];
	OutputFigure.Children.FontSize = 16;
 	OutputFigure.Children.YScale = 'log';
 	legend({'H+','H2+','N+','NH+','NH3+','N2+'})
 	if nargin > 2
 		title(Labels{1})
 		xlabel(Labels{2})
 		ylabel(Labels{3})
 	end
end
function out = f(in)
	if in<0
		out = 0;
	else
		out = in;
	end
end