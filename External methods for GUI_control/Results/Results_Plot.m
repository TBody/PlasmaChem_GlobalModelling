function OutputFigure = Results_Plot(Controller,toflag)
	Results_Struct = Results_ExportStruct(Controller,'Results');
	if strcmp(toflag,'GUI')
		for PlotChild = Controller.H.GUI_7_PlotPanel.Children'
			switch PlotChild.Type
			case 'uicontrol'
				%Do nothing - deal with this in a different bit of code.
			case 'legend'
				delete(PlotChild);
			case 'axes'
				delete(PlotChild);
			otherwise
				error('Child of PlotPanel not recognised')
			end
		end
	end
	PowerAbsorbedIndex 		= Controller.Global.Results_Plot_PowerAbsorbedIndex;
	StartingPressureIndex 	= Controller.Global.Results_Plot_StartingPressureIndex;
	GasSupplyIndex 			= Controller.Global.Results_Plot_GasSupplyIndex;
	ShowPlotElement 		= Controller.Global.ShowPlotElement;
	switch Controller.Global.EvaluationMode
	case 'Vector'
			plotX 		= 1:length(Controller.Results);
			plotY_N 	= [Results_Struct(:).Species_N];
			plotY_Te	= [Results_Struct(:).Te];
	case 'Matrix'
		IndependentVariable = Controller.H.GUI_7_IndependentVar.String{Controller.H.GUI_7_IndependentVar.Value};
		switch IndependentVariable
		case 'Power absorbed'
			plotX 		= [Results_Struct(:,StartingPressureIndex,GasSupplyIndex).PowerAbsorbed];
			plotY_N 	= [Results_Struct(:,StartingPressureIndex,GasSupplyIndex).Species_N];
			plotY_Te	= [Results_Struct(:,StartingPressureIndex,GasSupplyIndex).Te];
			plotTitle 	= sprintf('p=%smTorr, %ssccm',Results_SelectTest(Controller,'Starting pressure'),Results_SelectTest(Controller,'Gas supply'));
		case 'Starting pressure'
			plotX 		= [Results_Struct(PowerAbsorbedIndex,:,GasSupplyIndex).StartingPressure].*1e3;
			plotY_N 	= [Results_Struct(PowerAbsorbedIndex,:,GasSupplyIndex).Species_N];
			plotY_Te	= [Results_Struct(PowerAbsorbedIndex,:,GasSupplyIndex).Te];
			plotTitle 	= sprintf('P=%sW, %ssccm',Results_SelectTest(Controller,'Power absorbed'),Results_SelectTest(Controller,'Gas supply'));
		case 'Gas supply'
			[plotX,plotY_N,plotY_Te] = evaluate_GasSupply(Controller,Results_Struct);
			plotTitle 	= sprintf('P=%sW, p=%smTorr',Results_SelectTest(Controller,'Power absorbed'),Results_SelectTest(Controller,'Starting pressure'));
		end
	end
	Show_Te = logical(ShowPlotElement(1));
	Show_N 	= logical(ShowPlotElement(2:end));
	plotY_N(~Show_N,:) = []; %Remove rows corresponding to elements which are not to be shown
	if nargout == 0
		if length(Show_N(Show_N~=0)) > 0 && Show_Te
			Results_Plot_TeN(plotX,plotY_Te,plotY_N,plotTitle,Controller,toflag);
		elseif length(Show_N(Show_N~=0)) > 0 && ~Show_Te
			Results_Plot_N(plotX,plotY_N,plotTitle,Controller,toflag);
		elseif length(Show_N(Show_N~=0)) == 0 && Show_Te
			Results_Plot_Te(plotX,plotY_Te,plotTitle,Controller,toflag);
		else
			error('No elements displayed in plot')
		end
	elseif nargout == 1
		if length(Show_N(Show_N~=0)) > 0 && Show_Te
			OutputFigure = Results_Plot_TeN(plotX,plotY_Te,plotY_N,plotTitle,Controller,'figure');
		elseif length(Show_N(Show_N~=0)) > 0 && ~Show_Te
			OutputFigure = Results_Plot_N(plotX,plotY_N,plotTitle,Controller,'figure');
		elseif length(Show_N(Show_N~=0)) == 0 && Show_Te
			OutputFigure = Results_Plot_Te(plotX,plotY_Te,plotTitle,Controller,'figure');
		else
			error('No elements displayed in plot')
		end
	end
end
function [plotX,plotY_N,plotY_Te] = evaluate_GasSupply(Controller,Results_Struct)
	PowerAbsorbedIndex 		= Controller.Global.Results_Plot_PowerAbsorbedIndex;
	StartingPressureIndex 	= Controller.Global.Results_Plot_StartingPressureIndex;
	plotX 					= zeros(1,size(Results_Struct,3));
	plotY_N 				= zeros(length(Controller.Species_I2E),size(Results_Struct,3));
	plotY_Te 				= zeros(1,size(Results_Struct,3));
	DelIndices 				= zeros(1,size(Results_Struct,3));
	switch Controller.H.GUI_7_GasSupplyVary.String{Controller.H.GUI_7_GasSupplyVary.Value}
	case 'Total flow'
		for GasSupplyIndex = 1:size(Results_Struct,3)
			if ~isempty(Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).GasSupply)
				plotX(GasSupplyIndex) 		= sum(cell2mat(Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).GasSupply.values));
				plotY_N(:,GasSupplyIndex) 	= Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Species_N;
				plotY_Te(GasSupplyIndex) 	= Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Te;
			else
				DelIndices(GasSupplyIndex)	= 1;
			end
		end
	otherwise
		ParameterSplit = strsplit(Controller.H.GUI_7_GasSupplyVary.String{Controller.H.GUI_7_GasSupplyVary.Value});
		GasSupplyKey = ParameterSplit{1};
		for GasSupplyIndex = 1:size(Results_Struct,3)
			if ~isempty(Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).GasSupply)
				TotalFlow = sum(cell2mat(Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).GasSupply.values));
				if TotalFlow == str2num(Controller.H.GUI_7_GasSupplyAt.String{Controller.H.GUI_7_GasSupplyAt.Value})
					plotX(GasSupplyIndex) 		= Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).GasSupply(GasSupplyKey)/TotalFlow*1e2;
					plotY_N(:,GasSupplyIndex) 	= Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Species_N;
					plotY_Te(GasSupplyIndex) 	= Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Te;
				else
					DelIndices(GasSupplyIndex)  = 1;
				end
			else
				DelIndices(GasSupplyIndex) 		= 1;
			end
		end
	end
	plotY_N(:,logical(DelIndices)) 	= [];
	plotY_Te(logical(DelIndices)) 	= [];
	plotX(logical(DelIndices)) 		= [];
end