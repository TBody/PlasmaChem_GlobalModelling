function Evaluation_SaveTestIndex(Controller)
	TestSelected = Controller.H.GUI_6_SelectParameter.String{Controller.H.GUI_6_SelectParameter.Value};
	switch TestSelected
	case 'Power absorbed'
		Controller.Global.ConvergenceCheck_PowerAbsorbedIndex = Controller.H.GUI_6_SelectTest.Value;
	case 'Starting pressure'
		Controller.Global.ConvergenceCheck_StartingPressureIndex = Controller.H.GUI_6_SelectTest.Value;
	case 'Gas supply'
		Controller.Global.ConvergenceCheck_GasSupplyIndex = Controller.H.GUI_6_SelectTest.Value;
	end
end