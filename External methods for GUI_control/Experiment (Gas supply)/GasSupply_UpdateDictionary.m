function GasSupply_UpdateDictionary(Controller)
	Listbox 	= Controller.H.GasSupplyListbox;
	GasSupply 	= Controller.Experiment.GasSupply;
	Species 	= Controller.H.GasSupplySpecies.String;
	[Rate,OK] 	= str2num(Controller.H.GasSupplyRate.String);
	if isempty(GasSupply)
		GasSupply = containers.Map('KeyType','char','ValueType','any');
	end
	if OK
		GasSupply(Species) 	= Rate; %UNITS
		Listbox.String 		= GasSupply.keys;
		Listbox.Value 		= find(strcmp(GasSupply.keys,Species));
		Controller.Experiment.GasSupply = GasSupply;
	else
		Controller.H.GasSupplyRate.String = 'Err: str2num failed';
	end
end