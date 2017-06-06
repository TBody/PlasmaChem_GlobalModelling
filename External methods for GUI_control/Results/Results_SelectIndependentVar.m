function Results_SelectIndependentVar(Controller)
	switch Controller.H.GUI_7_IndependentVar.String{Controller.H.GUI_7_IndependentVar.Value}
	case 'Power absorbed'
		Controller.H.GUI_7_DependentVar.String = {'Starting pressure';'Gas supply'};
		Controller.H.GUI_7_GasSupplyVarPanel.Visible = 'off';
	case 'Starting pressure'
		Controller.H.GUI_7_DependentVar.String = {'Power absorbed';'Gas supply'};
		Controller.H.GUI_7_GasSupplyVarPanel.Visible = 'off';
	case 'Gas supply'
		Controller.H.GUI_7_DependentVar.String = {'Power absorbed';'Starting pressure'};
		if length(Controller.Experiment.GasSupply.keys) > 1
			Controller.H.GUI_7_GasSupplyVarPanel.Visible = 'on';
		else
			Controller.H.GUI_7_GasSupplyVarPanel.Visible = 'off';
		end
	end
	Results_SelectTest(Controller);
end