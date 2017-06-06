function Results_UpdateMode(Controller,Mode)
	switch Mode
	case 'Plot'
		Controller.H.GUI_7_ModeBtnGroup.SelectedObject  = Controller.H.GUI_7_PlotBtn;
		Controller.H.GUI_7_IndependentVarPanel.Visible 	= 'on';
		Controller.H.GUI_7_SelectTestPanel.Visible 		= 'on';
		Controller.H.GUI_7_ShowPlotElementPanel.Visible = 'on';
		Controller.H.GUI_7_SavePanel.Visible 			= 'off';
		Controller.H.GUI_7_SaveToPanel.Visible 			= 'off';
		Controller.H.GUI_7_FileLocationPanel.Visible 	= 'off';
		Controller.H.GUI_7_AnalyseButton.String 		= 'Plot';
	case 'Export'
		Controller.H.GUI_7_ModeBtnGroup.SelectedObject  = Controller.H.GUI_7_ExportBtn;
		Controller.H.GUI_7_IndependentVarPanel.Visible 	= 'off';
		Controller.H.GUI_7_SelectTestPanel.Visible 		= 'off';
		Controller.H.GUI_7_ShowPlotElementPanel.Visible = 'off';
		Controller.H.GUI_7_SavePanel.Visible 			= 'on';
		Controller.H.GUI_7_SaveToPanel.Visible 			= 'on';
		Controller.H.GUI_7_FileLocationPanel.Visible 	= 'on';
		Controller.H.GUI_7_AnalyseButton.String 		= 'Export';
	end
end