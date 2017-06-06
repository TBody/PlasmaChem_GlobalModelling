function Species_DB_AddElement(Controller)
	%disp('Species_DB_AddElement called')
	Mode 			= Controller.H.GUI_4_ModeBtnGroup.SelectedObject.String;
	SpeciesFormula 	= Controller.H.GUI_4_SpeciesFormula.String;
	UpdateSpecies(Controller,SpeciesFormula);
	switch Mode
	case 'Define'
		Controller.Global.SpeciesFoundList.append(SpeciesFormula);
		Controller.Global.SpeciesNotFoundList.remove(SpeciesFormula);
		Species_UpdateListbox(Controller);
	case 'Review'
		%Do nothing
	end
end
function UpdateSpecies(Controller,SpeciesFormula)
	load('physicalconstants','q_e','k_B_eV','amu2kg')
	Formula		= Controller.H.GUI_4_SpeciesFormula.String;
	Mass		= eval(Controller.H.GUI_4_SpeciesMass.String).*amu2kg;
	Charge		= str2num(Controller.H.GUI_4_SpeciesCharge.String);
	Density		= str2num(Controller.H.GUI_4_SpeciesInitialDensity.String);
	Temp		= str2num(Controller.H.GUI_4_SpeciesInitialTemperature.String).*k_B_eV; %Store in eV
	Type		= Controller.H.GUI_4_SpeciesType.String{Controller.H.GUI_4_SpeciesType.Value};
	Excited		= Controller.H.GUI_4_SpeciesExcitedBtnGroup.SelectedObject.String;
	vdWArea 	= str2num(Controller.H.GUI_4_SpeciesvdWArea.String).*1e-20;
	Species = SPECIES_C(...
		Formula,...
		Mass,...
		Charge,...
		Density,...
		Temp,...
		Type,...
		Excited,...
		vdWArea);
	Controller.Global.SpeciesUpdated = true;
	Controller.SpeciesDB.add(Species.Key,Species);
end