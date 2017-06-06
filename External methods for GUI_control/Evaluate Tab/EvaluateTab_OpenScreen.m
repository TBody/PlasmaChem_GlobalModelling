function ProceedAllowed = EvaluateTab_OpenScreen(Controller)
	%disp('EvaluateTab_OpenScreen called')
	Mode = Controller.H.GUI_1_EvaluationMode.SelectedObject.String;
	[ReturnMode,ProceedAllowed] = Global_CheckMode(Mode,Controller.Experiment);
	if ProceedAllowed
		if isempty(Controller.CrosssectionDB)
			Controller.H.CrosssectionBuilder.BackgroundColor = [1,0.6,0.6];
			ProceedAllowed = false;
		end
	end
	Controller.Global.EvaluationMode = ReturnMode;
end