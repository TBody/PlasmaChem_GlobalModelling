function Global_UpdateMode(Controller,NewMode)
	%disp('Global_UpdateMode called')
	EvaluationModeButtons = [Controller.H.ScalarModeButton,Controller.H.VectorModeButton,Controller.H.MatrixModeButton];
	switch NewMode
	case 'Scalar'
		Controller.H.GUI_1_EvaluationMode.SelectedObject 	= Controller.H.ScalarModeButton;
		Controller.H.GUI_6_ModeBtnGroup.SelectedObject 		= Controller.H.GUI_6_ControlBtn;
		Controller.H.GUI_6_MonitorBtn.Enable 				= 'off';
		Controller.H.GUI_7_PlotBtn.Enable 					= 'off';
		Evaluation_UpdateMode(Controller,'Control');
		Evaluation_SelectTest(Controller);
		Results_UpdateMode(Controller,'Export');
	case 'Vector'
		Controller.H.GUI_1_EvaluationMode.SelectedObject 	= Controller.H.VectorModeButton;
		Controller.H.GUI_6_MonitorBtn.Enable 				= 'on';
		Controller.H.GUI_7_PlotBtn.Enable 					= 'on';
		Evaluation_SelectTest(Controller);
		Results_UpdateMode(Controller,'Plot');
		Controller.H.GUI_7_IndependentVar.Value 			= 1;
		Controller.H.GUI_7_IndependentVar.String 			= {'Test #'};
		Controller.H.GUI_7_IndependentVar.Enable 			= 'off';
		Controller.H.GUI_7_DependentVar.Value				= 1;
		Controller.H.GUI_7_DependentVar.String 				= {'N/A'};
		Controller.H.GUI_7_DependentVar.Enable 				= 'off';
		Controller.H.GUI_7_SelectTest.Value					= 1;
		Controller.H.GUI_7_SelectTest.String 				= {'N/A'};
		Controller.H.GUI_7_SelectTest.Enable 				= 'off';
	case 'Matrix'
		Controller.H.GUI_1_EvaluationMode.SelectedObject 	= Controller.H.MatrixModeButton;
		Controller.H.GUI_6_MonitorBtn.Enable 				= 'on';
		Controller.H.GUI_7_PlotBtn.Enable 					= 'on';
		Evaluation_SelectTest(Controller);
		Results_UpdateMode(Controller,'Plot');
		Controller.H.GUI_7_IndependentVar.String 			= {'Power absorbed';'Starting pressure';'Gas supply'};
		Controller.H.GUI_7_IndependentVar.Enable 			= 'on';
		Controller.H.GUI_7_DependentVar.String 				= {'Starting pressure';'Gas supply'};
		Controller.H.GUI_7_DependentVar.Enable 				= 'on';
		Controller.H.GUI_7_SelectTest.String				= 'N/A';
		Controller.H.GUI_7_SelectTest.Enable				= 'on';
	otherwise
		error('Evaluation mode not recognised in Global_UpdateMode')
	end
	Controller.Global.EvaluationMode = NewMode;
end