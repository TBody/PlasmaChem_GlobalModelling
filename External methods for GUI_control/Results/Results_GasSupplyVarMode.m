function Results_GasSupplyVarMode(Controller)
	EvaluationMode = Controller.H.GUI_7_GasSupplyVary.String{Controller.H.GUI_7_GasSupplyVary.Value};
	switch EvaluationMode
	case 'Total flow'
		Controller.H.GUI_7_GasSupplyAt.Value 	= 1;
		Controller.H.GUI_7_GasSupplyAt.String 	= {'N/A'};
		Controller.H.GUI_7_GasSupplyAt.Enable 	= 'off';
	otherwise
		Results_Struct 			= Results_ExportStruct(Controller,'Results');
		PowerAbsorbedIndex 		= Controller.Global.Results_Plot_PowerAbsorbedIndex;
		StartingPressureIndex 	= Controller.Global.Results_Plot_StartingPressureIndex;
		TotalFlowVector 		= zeros(1,size(Results_Struct,3));
		DelIndices 				= zeros(1,size(Results_Struct,3));
		for GasSupplyIndex = 1:size(Results_Struct,3)
			if ~isempty(Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).GasSupply)
				TotalFlowVector(GasSupplyIndex) = sum(cell2mat(Results_Struct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).GasSupply.values));
			else
				DelIndices(GasSupplyIndex) 		= 1;
			end
		end
		TotalFlowVector(logical(DelIndices)) = [];
		TotalFlowString = {};
		for TotalFlow = unique(TotalFlowVector);
			TotalFlowString = [TotalFlowString;num2str(TotalFlow)];
		end
		Controller.H.GUI_7_GasSupplyAt.Value 	= 1;
		Controller.H.GUI_7_GasSupplyAt.String 	= TotalFlowString;
		Controller.H.GUI_7_GasSupplyAt.Enable 	= 'on';
	end
end