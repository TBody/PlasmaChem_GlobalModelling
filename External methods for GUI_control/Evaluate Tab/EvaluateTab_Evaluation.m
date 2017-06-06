function ProceedAllowed = EvaluateTab_Evaluation(Controller)
	%disp('EvaluateTab_Evaluation')
	%if ~isempty(Controller.Results)
		Controller.H.GUI_7_ShowPlotElement.String = ['Te';Controller.Species_I2E.list'];
		ShowElement = zeros(1,length(Controller.H.GUI_7_ShowPlotElement.String));
		ShowElement(1) = true;
		for index = 1:length(Controller.Species_I2E)
			SpeciesKey = Controller.Species_I2E.Key(index);
			Species = Controller.SpeciesDB.Key(SpeciesKey);
			if strcmp(Species.Excited,'Ground')
				ShowElement(index+1) = true;
			end
		end
		Controller.Global.ShowPlotElement = ShowElement;
		Results_SelectTest(Controller);
		ProceedAllowed = true;
	%else
	%	ProceedAllowed = false;
	%end
end