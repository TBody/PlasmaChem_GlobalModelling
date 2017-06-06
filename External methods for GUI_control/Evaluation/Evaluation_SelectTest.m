function Evaluation_SelectTest(Controller)
	if isfield(Controller.Global,'ConvergenceCheck_PowerAbsorbedIndex') && isfield(Controller.Global,'ConvergenceCheck_StartingPressureIndex') && isfield(Controller.Global,'ConvergenceCheck_GasSupplyIndex') && ~Controller.Global.ExperimentUpdated
		PowerAbsorbedIndex 		= Controller.Global.ConvergenceCheck_PowerAbsorbedIndex;
		StartingPressureIndex 	= Controller.Global.ConvergenceCheck_StartingPressureIndex;
		GasSupplyIndex 			= Controller.Global.ConvergenceCheck_GasSupplyIndex;
	else
		Controller.Global.ConvergenceCheck_PowerAbsorbedIndex = 1;
		Controller.Global.ConvergenceCheck_StartingPressureIndex = 1;
		Controller.Global.ConvergenceCheck_GasSupplyIndex = 1;
		PowerAbsorbedIndex 		= Controller.Global.ConvergenceCheck_PowerAbsorbedIndex;
		StartingPressureIndex 	= Controller.Global.ConvergenceCheck_StartingPressureIndex;
		GasSupplyIndex 			= Controller.Global.ConvergenceCheck_GasSupplyIndex;
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
	TestSelected = Controller.H.GUI_6_SelectParameter.String{Controller.H.GUI_6_SelectParameter.Value};
	switch TestSelected
	case 'Power absorbed'
		if ~isempty(Controller.Experiment.PowerAbsorbed)
			Controller.H.GUI_6_SelectTest.String 	= Controller.Experiment.PowerAbsorbed;
		else
			Controller.H.GUI_6_SelectTest.String 	= 'N/A';
		end
		Controller.H.GUI_6_SelectTest.Value 	= PowerAbsorbedIndex;
	case 'Starting pressure'
		if ~isempty(Controller.Experiment.StartingPressure)
			Controller.H.GUI_6_SelectTest.String 	= Controller.Experiment.StartingPressure.*1e3;
		else
			Controller.H.GUI_6_SelectTest.String 	= 'N/A';
		end
		Controller.H.GUI_6_SelectTest.Value 	= StartingPressureIndex;
	case 'Gas supply'
		Controller.H.GUI_6_SelectTest.String 	= GasSupplyDisplay;
		Controller.H.GUI_6_SelectTest.Value 	= GasSupplyIndex;
	end
end
function Return_Display_dict = Display_dict(Dictionary,index)
   	element_list    = LIST_C;
   	for Key = Dictionary.keys
   	    Value = Dictionary(Key{:});
   	    element_list.append(sprintf('%s: %s',Key{:},num2str(Value(index))));
   	end
   	Return_Display_dict = strjoin(element_list.list,', ');
end