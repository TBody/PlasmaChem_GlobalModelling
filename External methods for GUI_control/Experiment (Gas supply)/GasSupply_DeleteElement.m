function GasSupply_DeleteElement(Controller);
	Listbox 		= Controller.H.GasSupplyListbox;
	SelectedSpecies = Listbox.String(Listbox.Value);
	GasSupply 		= Controller.Experiment.GasSupply;
	if ~isempty(SelectedSpecies)
		GasSupply.remove(SelectedSpecies);
		Listbox.Value  = 1;
		try %If the dictionary is empty this will generate an error
			Listbox.String = GasSupply.keys;
		catch
			Listbox.String = '';
		end
		Controller.H.GasSupplySpecies.String 	= '';
		Controller.H.GasSupplyRate.String 		= '';
	end
end