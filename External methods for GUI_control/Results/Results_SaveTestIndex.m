function Results_SaveTestIndex(Controller)
	TestSelected = Controller.H.GUI_7_DependentVar.String{Controller.H.GUI_7_DependentVar.Value};
	switch TestSelected
	case 'Power absorbed'
		Controller.Global.Results_Plot_PowerAbsorbedIndex = Controller.H.GUI_7_SelectTest.Value;
	case 'Starting pressure'
		Controller.Global.Results_Plot_StartingPressureIndex = Controller.H.GUI_7_SelectTest.Value;
	case 'Gas supply'
		Controller.Global.Results_Plot_GasSupplyIndex = Controller.H.GUI_7_SelectTest.Value;
	end
	Controller.Results_Plot_LookupShowDependentVar;
end