function ProceedAllowed = EvaluateTab_Experiment(Controller)
	%disp('EvaluateTab_Experiment called')
	Controller.Global.Results_Plot_PowerAbsorbedIndex = 1;
	Controller.Global.Results_Plot_StartingPressureIndex = 1;
	Controller.Global.Results_Plot_GasSupplyIndex = 1;
	Controller.Global.ExperimentUpdated = true;
	Mode = Controller.H.GUI_1_EvaluationMode.SelectedObject.String;
	Experiment 					= Controller.Experiment;
	Experiment.Key				= Controller.H.ExpReference.String;
	Experiment.Reactor 			= Controller.Reactor;
	[PowerAbsorbed,PA_OK] 		= str2num(Controller.H.ExpPowerAbsorbed.String);
	[StartingPressure,SP_OK] 	= str2num(Controller.H.ExpStartingPressure.String);
	if PA_OK
		Experiment.PowerAbsorbed	= PowerAbsorbed;
	end
	if SP_OK
		Experiment.StartingPressure	= StartingPressure*1e-3;
	end
	[ReturnMode,ProceedAllowed] = Global_CheckMode(Mode,Experiment);
	Global_UpdateMode(Controller,ReturnMode);
	Evaluation_SelectTest(Controller);
	if length(Controller.Experiment.GasSupply.keys) > 1
		GasSupplyVary 		= {};
		for GasSupplyKey 	= Controller.Experiment.GasSupply.keys;
			GasSupplyVary 	= [GasSupplyVary;sprintf('%s supply',GasSupplyKey{:})];
		end
		Controller.H.GUI_7_GasSupplyVary.Value 	= 1;
		Controller.H.GUI_7_GasSupplyVary.String = ['Total flow';GasSupplyVary];
	else
		Controller.H.GUI_7_GasSupplyVary.Value 	= 1;
		Controller.H.GUI_7_GasSupplyVary.String = {'Total flow'};
	end
end