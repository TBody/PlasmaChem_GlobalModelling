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
	if strcmp(Variable,'H2partialpressure')
		ScanDependent = UniqueVariable*100;
	else
		ScanDependent = UniqueVariable;
	end
	CountRaw = containers.Map('KeyType','double','ValueType','any');
	ErrorRaw = containers.Map('KeyType','double','ValueType','any');
	CountMap = containers.Map('KeyType','char','ValueType','any');
	ErrorMap = containers.Map('KeyType','char','ValueType','any');
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	CountRaw(1)		= ScanmeanCount(:,find(MassList == 1))*1.08*10^14;
	CountRaw(2)		= ScanmeanCount(:,find(MassList == 2))*1.08*10^14;
	CountRaw(14)	= ScanmeanCount(:,find(MassList == 14))*1.08*10^14;
	CountRaw(15)	= ScanmeanCount(:,find(MassList == 15))*1.08*10^14;
	CountRaw(16)	= ScanmeanCount(:,find(MassList == 16))*1.08*10^14;
	CountRaw(17)	= ScanmeanCount(:,find(MassList == 17))*1.08*10^14;
	CountRaw(18)	= ScanmeanCount(:,find(MassList == 18))*1.08*10^14;
	CountRaw(28)	= ScanmeanCount(:,find(MassList == 28))*1.08*10^14;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	ErrorRaw(1)		= ScanstdCount(:,find(MassList == 1))*1.08*10^14;
	ErrorRaw(2)		= ScanstdCount(:,find(MassList == 2))*1.08*10^14;
	ErrorRaw(14)	= ScanstdCount(:,find(MassList == 14))*1.08*10^14;
	ErrorRaw(15)	= ScanstdCount(:,find(MassList == 15))*1.08*10^14;
	ErrorRaw(16)	= ScanstdCount(:,find(MassList == 16))*1.08*10^14;
	ErrorRaw(17)	= ScanstdCount(:,find(MassList == 17))*1.08*10^14;
	ErrorRaw(18)	= ScanstdCount(:,find(MassList == 18))*1.08*10^14;
	ErrorRaw(28)	= ScanstdCount(:,find(MassList == 28))*1.08*10^14;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	NH3_Adjust                    = CountRaw(18)*0.21;
	NH3_Adjust(isnan(NH3_Adjust)) = 0;
	NH3_Adjust(NH3_Adjust<0)      = 0;
	CountMap('NH3')	              = (CountRaw(17) - NH3_Adjust)/1.33;

	NH2_Adjust 					  = 0.8*CountMap('NH3');
	NH2_Adjust(isnan(NH2_Adjust)) = 0;
	NH2_Adjust(NH2_Adjust<0)      = 0;
	CountMap('NH2')               = (CountRaw(16)-NH2_Adjust)/1.61;

	NH_Adjust 					  = 0.55*CountMap('NH2');
	NH_Adjust(isnan(NH_Adjust))   = 0;
	NH_Adjust(NH_Adjust<0)        = 0;
	CountMap('NH')	              = (CountRaw(15) - NH_Adjust)/1.61;

	N_Adjust1                     = CountRaw(28)*0.0489;
	N_Adjust1(isnan(N_Adjust1))   = 0;
	N_Adjust1(N_Adjust1<0)        = 0;
	N_Adjust2                     = CountMap('NH')*0.28;
	N_Adjust2(isnan(N_Adjust2))   = 0;
	N_Adjust2(N_Adjust2<0)        = 0;
	CountMap('N')                 = (CountRaw(14)-N_Adjust1-N_Adjust2)/1.1;

	H_Adjust                      = CountRaw(2)*0.25;
	H_Adjust(isnan(H_Adjust))     = 0;
	H_Adjust(H_Adjust<0)          = 0;
	CountMap('H')                 = (CountRaw(1)-H_Adjust)/0.25;

	CountMap('N2')	              = (CountRaw(28))/1;
	CountMap('H2')	              = (CountRaw(2))/0.44;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	NH3_Error                   = ErrorRaw(18)*0.21;
	NH3_Error(isnan(NH3_Error)) = 0;
	NH3_Error(NH3_Error<0)      = 0;
	ErrorMap('NH3')	            = (ErrorRaw(17) + NH3_Error)/1.33;

	NH2_Error 					             = 0.8*ErrorMap('NH3');
	NH2_Error(isnan(NH2_Error)) = 0;
	NH2_Error(NH2_Error<0)      = 0;
	ErrorMap('NH2')             = (ErrorRaw(16)+NH2_Error)/1.61;

	NH_Error 					              = 0.55*ErrorMap('NH2');
	NH_Error(isnan(NH_Error))   = 0;
	NH_Error(NH_Error<0)        = 0;
	ErrorMap('NH')	             = (ErrorRaw(15) + NH_Error)/1.61;

	N_Error1                    = ErrorRaw(28)*0.0489;
	N_Error1(isnan(N_Error1))   = 0;
	N_Error1(N_Error1<0)        = 0;
	N_Error2                    = ErrorMap('NH')*0.28;
	N_Error2(isnan(N_Error2))   = 0;
	N_Error2(N_Error2<0)        = 0;
	ErrorMap('N')               = (ErrorRaw(14)+N_Error1+N_Error2)/1.1;

	H_Error                     = ErrorRaw(2)*0.25;
	H_Error(isnan(H_Error))     = 0;
	H_Error(H_Error<0)          = 0;
	ErrorMap('H')               = (ErrorRaw(1)+H_Error)/0.25;

	ErrorMap('N2')	             = (ErrorRaw(28))/1;
	ErrorMap('H2')	             = (ErrorRaw(2))/0.44;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	CountH = CountMap('H');
	CountH2 = CountMap('H2');
	CountN = CountMap('N');
	CountNH = CountMap('NH');
	CountNH3 = CountMap('NH3');
	CountN2 = CountMap('N2');

	OutputFigure = figure;
	CountMap('H') 	= interp1(ScanDependent(MD(CountMap('H'))),CountH(MD(CountMap('H'))),ScanDependent);
	CountMap('H2') 	= interp1(ScanDependent(MD(CountMap('H2'))),CountH2(MD(CountMap('H2'))),ScanDependent);
	CountMap('N') 	= interp1(ScanDependent(MD(CountMap('N'))),CountN(MD(CountMap('N'))),ScanDependent);
	CountMap('NH') 	= interp1(ScanDependent(MD(CountMap('NH'))),CountNH(MD(CountMap('NH'))),ScanDependent);
	CountMap('NH3') = interp1(ScanDependent(MD(CountMap('NH3'))),CountNH3(MD(CountMap('NH3'))),ScanDependent);
	CountMap('N2') 	= interp1(ScanDependent(MD(CountMap('N2'))),CountN2(MD(CountMap('N2'))),ScanDependent);

	hold on
	PlotH	=	errorbar(ScanDependent, CountMap('H'),   ErrorMap('H'));
	PlotH.Color = [0.9290    0.6940    0.1250];
	PlotH2	=	errorbar(ScanDependent, CountMap('H2'),  ErrorMap('H2'));
	PlotH2.Color = [0.8500    0.3250    0.0980];
	PlotN	=	errorbar(ScanDependent, CountMap('N'),   ErrorMap('N'));
	PlotN.Color = [0.4940    0.1840    0.5560];
	PlotNH	=	errorbar(ScanDependent, CountMap('NH'),  ErrorMap('NH'));
	PlotNH.Color = [0.3010    0.7450    0.9330];
	PlotNH3	=	errorbar(ScanDependent, CountMap('NH3'), ErrorMap('NH3'));
	PlotNH3.Color = [0.6350    0.0780    0.1840];
	PlotN2	=	errorbar(ScanDependent, CountMap('N2'),  ErrorMap('N2'));
	PlotN2.Color = [0.4660    0.6740    0.1880];
	OutputFigure.Children.FontSize = 16;
 	OutputFigure.Children.YScale = 'log';
 	legend({'H','H2','N','NH','NH3','N2'})
 	if nargin > 2
 		title(Labels{1})
 		xlabel(Labels{2})
 		ylabel(Labels{3})
 	end
end
function MissingData = MD(Vector)
	MissingData = logical(~isnan(Vector));
end
function out = f(in)
	if in<0
		out = 0;
	else
		out = in;
	end
end