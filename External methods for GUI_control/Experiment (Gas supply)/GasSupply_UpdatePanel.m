function GasSupply_UpdatePanel(Controller)
	Listbox = Controller.H.GasSupplyListbox;
	SelectedSpecies = Listbox.String{Listbox.Value};
	if ~isempty(SelectedSpecies)
		SelectedRate 	= Controller.Experiment.GasSupply(SelectedSpecies); %UNITS
		SpeciesEditBox 	= Controller.H.GasSupplySpecies;
		RateEditBox 	= Controller.H.GasSupplyRate;
		SpeciesEditBox.String 	= SelectedSpecies;
		if length(SelectedRate) == 1
			RateEditBox.String 		= num2str(SelectedRate);
		elseif length(SelectedRate) > 1
			RateEditBox.String 		= ['[',strjoin(strsplit(num2str(SelectedRate),' '),','),']'];
		end
	end
end