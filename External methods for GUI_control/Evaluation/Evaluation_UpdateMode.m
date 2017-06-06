function Evaluation_UpdateMode(Controller,Mode)
	switch Mode
	case 'Control'
		Controller.H.GUI_6_ModeBtnGroup.SelectedObject = Controller.H.GUI_6_ControlBtn;
		if exist('Controller.Solver.ConvergenceCheck_Y')
			Evaluation_PlotSolution(Controller.Solver.ConvergenceCheck_T,Controller.Solver.ConvergenceCheck_Y,Controller.Solver.ConvergenceCheck_M,Controller)
		end
		Controller.H.MaxEvaluationsPanel.Visible 	= 'off';
		Controller.H.GUI_6_SelectTestPanel.Visible 	= 'on';
		Controller.H.GUI_6_EvaluateODE.String 		= 'Check convergence';
		Controller.H.GUI_6_RightPanelString.String 	= 'Check convergence';
		Controller.H.GUI_6_YaxisGroup.Visible 		= 'on';
		Controller.H.GUI_6_XaxisGroup.Visible 		= 'on';
		Controller.H.GUI_6_MonitorPanel.Visible 	= 'off';
		Controller.H.GUI_6_TimerString.String 		= {'Timer';'00:00.000'};
	case 'Monitor'
		Controller.H.GUI_6_ModeBtnGroup.SelectedObject = Controller.H.GUI_6_MonitorBtn;
		for PlotChild = Controller.H.GUI_6_PlotPanel.Children'
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
		Controller.H.MaxEvaluationsPanel.Visible 	= 'on';
		Controller.H.GUI_6_SelectTestPanel.Visible 	= 'off';
		Controller.H.GUI_6_EvaluateODE.String 		= 'Evaluate ODEs';
		Controller.H.GUI_6_RightPanelString.String 	= 'Monitor evaluation';
		Controller.H.GUI_6_YaxisGroup.Visible 		= 'off';
		Controller.H.GUI_6_XaxisGroup.Visible 		= 'off';
		Controller.H.GUI_6_MonitorPanel.Visible 	= 'on';
		Controller.H.GUI_6_TimerString.String 		= {'Timer';'00:00.000'};
	end
end