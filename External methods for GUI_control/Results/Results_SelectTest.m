function ReturnTest = Results_SelectTest(Controller,DependentVar)
	try
		PowerAbsorbedIndex 		= Controller.Global.Results_Plot_PowerAbsorbedIndex;
		StartingPressureIndex 	= Controller.Global.Results_Plot_StartingPressureIndex;
		GasSupplyIndex 			= Controller.Global.Results_Plot_GasSupplyIndex;
	catch
		Controller.Global.Results_Plot_PowerAbsorbedIndex 		= 1;
		Controller.Global.Results_Plot_StartingPressureIndex 	= 1;
		Controller.Global.Results_Plot_GasSupplyIndex 			= 1;
		PowerAbsorbedIndex 		= Controller.Global.Results_Plot_PowerAbsorbedIndex;
		StartingPressureIndex 	= Controller.Global.Results_Plot_StartingPressureIndex;
		GasSupplyIndex 			= Controller.Global.Results_Plot_GasSupplyIndex;
	end
	if ~isempty(Controller.Experiment.GasSupply)
		GasSupplyLength = unique(cellfun(@length,Controller.Experiment.GasSupply.values));
		GasSupplyDisplay = {};
		for GSIndex = 1:GasSupplyLength;
			GasSupplyDisplay = [GasSupplyDisplay;Display_dict(Controller.Experiment.GasSupply,GSIndex)];
		end
	else
		GasSupplyDisplay = 'N/A';
	end
	if nargin == 1 && nargout == 0
		TestSelected = Controller.H.GUI_7_DependentVar.String{Controller.H.GUI_7_DependentVar.Value};
		switch TestSelected
		case 'Power absorbed'
			if ~isempty(Controller.Experiment.PowerAbsorbed)
				Controller.H.GUI_7_SelectTest.String 	= Controller.Experiment.PowerAbsorbed;
			else
				Controller.H.GUI_7_SelectTest.String 	= 'N/A';
			end
			Controller.H.GUI_7_SelectTest.Value 		= PowerAbsorbedIndex;
		case 'Starting pressure'
			if ~isempty(Controller.Experiment.StartingPressure)
				Controller.H.GUI_7_SelectTest.String 	= Controller.Experiment.StartingPressure.*1e3;
			else
				Controller.H.GUI_7_SelectTest.String 	= 'N/A';
			end
			Controller.H.GUI_7_SelectTest.Value 		= StartingPressureIndex;
		case 'Gas supply'
			Controller.H.GUI_7_SelectTest.String 		= GasSupplyDisplay;
			Controller.H.GUI_7_SelectTest.Value 		= GasSupplyIndex;
		end
	elseif nargin == 2 && nargout == 1
		switch DependentVar
		case 'Power absorbed'
			if ~isempty(Controller.Experiment.PowerAbsorbed)
				ReturnTest 	= num2str(Controller.Experiment.PowerAbsorbed(PowerAbsorbedIndex),3);
			else
				ReturnTest 	= 'N/A';
			end
		case 'Starting pressure'
			if ~isempty(Controller.Experiment.StartingPressure)
				ReturnTest 	= num2str(Controller.Experiment.StartingPressure(StartingPressureIndex).*1e3,3);
			else
				ReturnTest 	= 'N/A';
			end
		case 'Gas supply'
			ReturnTest 		= GasSupplyDisplay{GasSupplyIndex};
		end
	else
		error('Incorrect combination of nargin & nargout')
	end

	Controller.Results_Plot_LookupShowDependentVar
end
function Return_Display_dict = Display_dict(Dictionary,index)
   	element_list    = LIST_C;
   	for Key = Dictionary.keys
   	    Value = Dictionary(Key{:});
   	    element_list.append(sprintf('%s: %s',Key{:},num2str(Value(index),3)));
   	end
   	Return_Display_dict = strjoin(element_list.list,', ');
end