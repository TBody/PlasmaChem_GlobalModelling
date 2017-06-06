classdef CROSSSECTION_C < handle
	properties
		Key
		Energy
		Crosssection
		RateCoefficient
		Rate
	end

	methods
		function obj = CROSSSECTION_C(Filename_str,Key,HeaderLines,EnergyUnits,CrosssectionUnits)
			%CROSSSECTION_C class for handling crosssection files
			%Inputs:
			%	Filename_str should be a filename in your current MATLAB path
			%	HeaderLines should be the number of non-numeric lines in the file
			%	Energy units should be a cell-array {power-of-ten factor, unit string}. Unit strings allowed are eV, J.
			%	Crosssection units should be a cell-array {power-of-ten factor, unit string}. Units strings allowed are m2, cm2
			if ~strcmp(Key,'Manual')
			load('physicalconstants','eV2J')
			if ~exist(Filename_str)
				if ~exist([Filename_str,'.csv'])
					error(sprintf('File %s not found',Filename_str))
				else
					Filename_str = [Filename_str,'.csv'];
				end
			end
			if strcmpi(EnergyUnits{2},'J')
				EnergyUnits{1} = EnergyUnits{1}*eV2J^-1;
			elseif ~strcmpi(EnergyUnits{2},'eV')
				error('EnergyUnits not recognised')
			end
			if strcmpi(CrosssectionUnits{2},'cm2')
				CrosssectionUnits{1} = CrosssectionUnits{1}/(10^4);
			elseif ~strcmpi(CrosssectionUnits{2},'m2')
				error('CrosssectionUnits not recognised')
			end
			[obj.Energy, obj.Crosssection] = ImportFromFile(Filename_str,HeaderLines,EnergyUnits{1},CrosssectionUnits{1});
			obj.Key 			= Key;
			obj.RateCoefficient = obj.RateCoefficient_from_PP(obj.Energy')';
			pp = obj.RateCoefficient_PiecewisePolynomial;
			obj.Rate = @(Te)ppval(pp,Te);
			else
			obj.Key = 'Manual';
		 	end
		 	function [Energy,Crosssection] = ImportFromFile(Filename_str,HeaderLines,EnergyConversion,CrosssectionConversion)
				CrosssectionTable = readtable(Filename_str,'HeaderLines',HeaderLines,'Format','%f%f','ReadVariableNames',false);
				CrosssectionArray = table2array(CrosssectionTable);
				Energy = CrosssectionArray(:,1).*EnergyConversion;
				Crosssection = CrosssectionArray(:,2).*CrosssectionConversion;
			end
		end
		function obj = XCManualAdd(obj,Key,Energy,Crosssection)
			obj.Energy = Energy;
			obj.Crosssection = Crosssection;
			obj.Key = Key;
			obj.RateCoefficient = obj.RateCoefficient_from_PP(obj.Energy')';
			pp = obj.RateCoefficient_PiecewisePolynomial;
			obj.Rate = @(Te)ppval(pp,Te);
		end
		function Return_TableForm = TableForm(obj)
			%Converts the Energy and Crosssection column vectors to a combined table
			Return_TableForm = table(obj.Energy,obj.Crosssection,'VariableNames',{'Energy_eV','Crosssection_m2'});
		end
		function disp(obj)
			disp(sprintf('Crosssection for Key: %s. \nColumns: Energy (eV), Crosssection (m^2)\nData length: %d\nUse method obj.TableForm to inspect',obj.Key,length(obj.Energy)));
		end
		function Return_Crosssection_Interpolation = Crosssection_Interpolation(obj,EnergyLookup)
			%disp('Crosssection_Interpolation called')
			[SortedEnergy,SortIndicies,~] = unique(obj.Energy);
			SortedCrosssection = obj.Crosssection(SortIndicies);
			Return_Crosssection_Interpolation = interp1(SortedEnergy,SortedCrosssection,EnergyLookup,'linear','extrap');
		end
		function Return_RateCoefficient_from_PP = RateCoefficient_from_PP(obj,Te)
			%RATECOEFFICIENT_FROM_PP determines the rate-coefficient from the piecewise linear interpolation of the cross-section
			%	Assumes a Maxwellian electron energy distribution function
			%disp('RateCoefficient_from_PP called')
			load('physicalconstants','eV2J','m_e')
			RateCoefficientList 	= LIST_C;
			EvaluationEnergies 		= 10.^[-3:0.01:3];
			SpeedFactor 			= sqrt(2*eV2J/m_e.*EvaluationEnergies);
			Crosssection 			= obj.Crosssection_Interpolation(EvaluationEnergies);
			Crosssection([Crosssection<=0]) = 0;
			EEDF 					= MaxwellianEnergy(Te,EvaluationEnergies);
			for EEDFrow = EEDF' %To evaluate for multiple supplied Te values
				EvaluationPoints = SpeedFactor.*Crosssection.*EEDFrow';
				EvaluationPoints(EvaluationPoints<0) = 0;
				RateCoefficientList.append(trapz(EvaluationEnergies,EvaluationPoints));
			end
			Return_RateCoefficient_from_PP = real(cell2mat(RateCoefficientList.list));
			function Return_MaxwellianEnergy = MaxwellianEnergy(Te,EnergyList) %For Te in eV
				%disp('MaxwellianEnergy called')
				Results_List = LIST_C;
				for Energy = EnergyList;
					Maxwellian = (2/sqrt(pi)*Te.^(-3/2))*Energy^(1/2).*exp(-Energy./Te);
					Results_List.extend(Maxwellian');
				end
				Return_MaxwellianEnergy = cell2mat(Results_List.list);
			end
		end
		function [EvaluationEnergies,EvaluationPoints] = RateCoefficient_Evaluation_Vectors(obj)
			%disp('RateCoefficient_Evaluation_Vectors called')
			EvaluationEnergies 	= 10.^[-3:0.01:3];
			EvaluationPoints 	= obj.RateCoefficient_from_PP(EvaluationEnergies);
		end
		%function InterpolationRC = RateCoefficient_Interpolation(obj,EnergyLookup)
		%	EvaluationEnergies 	= 10.^[-1:0.01:2];
		%	EvaluationPoints 	= obj.RateCoefficient_from_PP(EvaluationEnergies);
		%	InterpolationRC 	= interp1(EvaluationEnergies,EvaluationPoints,EnergyLookup,'linear',0);
		%end
		function PiecewisePolynomial = RateCoefficient_PiecewisePolynomial(obj)
			EvaluationEnergies 	= 10.^[-0.5:0.1:2]; %Minimise points to speed-up ppval
			EvaluationPoints 	= obj.RateCoefficient_from_PP(EvaluationEnergies);
			PiecewisePolynomial = spline(EvaluationEnergies,EvaluationPoints);
		end
		%function FitFormula = RateCoefficient_AnalyticalFit(obj)
		%	ScalingFactor = 10/max(obj.RateCoefficient);
		%	[xData, yData] = prepareCurveData(obj.Energy, obj.RateCoefficient.*ScalingFactor);
		%	ftype = fittype(@(A1,B1,C1,A2,B2,C2,D,Te)A1.*Te.^(B1).*exp(C1./Te)+A2.*Te.^B2.*exp(C2./(Te+D)),'Independent','Te');
		%	foptions = fitoptions('Method','NonLinearLeastSquares','StartPoint',[-20 -20 0.5 0.5 0.5 0.5 10],'MaxFunEvals',1000,'MaxIter',1000);
		%	[fitresult, gof] = fit( xData, yData, ftype, foptions );
		%	FitFormula = formula(fitresult);
		%	CoefficientNames = coeffnames(fitresult);
		%	CoefficientValues = coeffvalues(fitresult)';
		%	for index = 1:length(CoefficientNames)
		%		if strcmp(CoefficientNames{index},'A1') || strcmp(CoefficientNames{index},'A2')
		%			FitFormula = strrep(FitFormula,CoefficientNames{index},num2str(CoefficientValues(index)/ScalingFactor));
		%		else
		%			FitFormula = strrep(FitFormula,CoefficientNames{index},num2str(CoefficientValues(index)));
		%		end
		%	end
		%	WhitespaceIndex = find(FitFormula==char(13) | FitFormula==char(10) | FitFormula==' ');
		%	%FitFormula(WhitespaceIndex) = [];
		%end
		%function SetRate(obj,fitresult)
		%	ScalingFactor = 10/max(obj.RateCoefficient);
		%	FitFormula = formula(fitresult);
		%	CoefficientNames = coeffnames(fitresult);
		%	CoefficientValues = coeffvalues(fitresult)';
		%	for index = 1:length(CoefficientNames)
		%		if strcmp(CoefficientNames{index},'A1') || strcmp(CoefficientNames{index},'A2')
		%			FitFormula = strrep(FitFormula,CoefficientNames{index},num2str(CoefficientValues(index)/ScalingFactor));
		%		else
		%			FitFormula = strrep(FitFormula,CoefficientNames{index},num2str(CoefficientValues(index)));
		%		end
		%	end
		%	WhitespaceIndex = find(FitFormula==char(13) | FitFormula==char(10) | FitFormula==' ');
		%	obj.Rate = FitFormula;
		%end
		function Plot_Return = Plot_Crosssection(obj,Visible)
			EvaluationEnergies = 10.^[-3:0.01:3];
			EvaluationCrosssection = obj.Crosssection_Interpolation(EvaluationEnergies);
			EvaluationCrosssection([EvaluationCrosssection<=0]) = 0;
			Plot_Return = figure('Visible',Visible);
			semilogx(obj.Energy,obj.Crosssection,'r*')
			hold on
			semilogx(EvaluationEnergies,EvaluationCrosssection);
			xlabel('Energy (eV)','FontName','Avenir Next','FontSize',20);
			ylabel('Cross-section (m^2)','FontName','Avenir Next','FontSize',20);
			title(sprintf('Crosssection for %s',obj.Key),'interpreter','none','FontName','Avenir Next','FontSize',24,'FontWeight','normal');
			legend({'Data','Interpolation'})
			axis([0,Inf,0,Inf])
			hold off
		end
		function Plot_Return = Plot_RateCoefficient(obj,Visible)
			%EvaluatedRate = eval(['@(Te)',obj.Rate]);
			EvaluationEnergies 	= 10.^[-0.5:0.1:2];
			%EvaluationRateCoefficient = EvaluatedRate(EvaluationEnergies);
			EvaluationRateCoefficient = [];
			for Energy = EvaluationEnergies
				EvaluationRateCoefficient = [EvaluationRateCoefficient,obj.Rate(Energy)];
			end
			Plot_Return = figure('Visible',Visible);
			semilogx(obj.Energy,obj.RateCoefficient,'r*');
			hold on
			semilogx(EvaluationEnergies,EvaluationRateCoefficient);
			xlabel('Energy (eV)','FontName','Avenir Next','FontSize',20);
			ylabel('Rate Co-efficient (m^3/s)','FontName','Avenir Next','FontSize',20);
			title(sprintf('Rate Co-efficient for %s',obj.Key),'interpreter','none','FontName','Avenir Next','FontSize',24,'FontWeight','normal');
			legend({'Calculated','Interpolation'})
			axis([0,Inf,0,Inf])
			hold off
		end
	end
end