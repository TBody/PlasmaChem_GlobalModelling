function Species_DB_ReturnAttributes(Controller)
	%disp('Species_DB_ReturnAttributes called')
	Mode = Controller.H.GUI_4_ModeBtnGroup.SelectedObject.String;
	try
		SelectedSpeciesFormula = Controller.H.GUI_4_SpeciesListbox.String{Controller.H.GUI_4_SpeciesListbox.Value};
	catch
		BlankSpeciesAttributes(Controller);
		return
	end
	switch Mode
	case 'Define'
		DefineModeSpeciesProcess(Controller,SelectedSpeciesFormula);
	case 'Review'
		ReviewModeSpeciesProcess(Controller,SelectedSpeciesFormula);
	end
end
function BlankSpeciesAttributes(Controller)
	Controller.H.GUI_4_SpeciesFormula.String 					= blanks(0);
	Controller.H.GUI_4_SpeciesMass.String 						= blanks(0);
	Controller.H.GUI_4_SpeciesCharge.String 					= blanks(0);
	Controller.H.GUI_4_SpeciesType.Value 						= find(strcmp(Controller.H.GUI_4_SpeciesType.String,'Neutral'));
	Controller.H.GUI_4_SpeciesExcitedBtnGroup.SelectedObject 	= Controller.H.GUI_4_SpeciesExcitedGroundBtn;
	Controller.H.GUI_4_SpeciesInitialDensity.String 			= blanks(0);
	Controller.H.GUI_4_SpeciesInitialTemperature.String 		= blanks(0);
	Controller.H.GUI_4_SpeciesvdWArea.String 					= blanks(0);
end
function DefineModeSpeciesProcess(Controller,SelectedSpeciesFormula)
	Controller.H.GUI_4_SpeciesFormula.String 					= SelectedSpeciesFormula;
	Controller.H.GUI_4_SpeciesMass.String 						= blanks(0);
	Controller.H.GUI_4_SpeciesExcitedBtnGroup.SelectedObject 	= Controller.H.GUI_4_SpeciesExcitedGroundBtn;
	Controller.H.GUI_4_SpeciesInitialDensity.String 			= blanks(0);
	Controller.H.GUI_4_SpeciesInitialTemperature.String 		= blanks(0);
	Controller.H.GUI_4_SpeciesvdWArea.String 					= blanks(0);
	SpeciesProcess 												= strsplit(SelectedSpeciesFormula,'(');
	switch SpeciesProcess{1}(end)
	case '+'
		% Positive Ion
		Controller.H.GUI_4_SpeciesType.Value 		= find(strcmp(Controller.H.GUI_4_SpeciesType.String,'Positive Ion'));
		Controller.H.GUI_4_SpeciesCharge.String 	= '+1';
	case '-'
		% Negative Ion
		Controller.H.GUI_4_SpeciesType.Value 		= find(strcmp(Controller.H.GUI_4_SpeciesType.String,'Negative Ion'));
		Controller.H.GUI_4_SpeciesCharge.String 	= '-1';
	otherwise
		% Neutral
		Controller.H.GUI_4_SpeciesType.Value 		= find(strcmp(Controller.H.GUI_4_SpeciesType.String,'Neutral'));
		Controller.H.GUI_4_SpeciesCharge.String 	= '0';
	end
end
function ReviewModeSpeciesProcess(Controller,SelectedSpeciesFormula)
	load('physicalconstants','k_B_eV','amu2kg')
	Species = Controller.SpeciesDB.Key(SelectedSpeciesFormula);
	eV2K 	= Species.T./k_B_eV;
	kg2amu	= Species.m./amu2kg;
	Controller.H.GUI_4_SpeciesFormula.String 				= Species.Key;
	Controller.H.GUI_4_SpeciesMass.String 					= num2str(kg2amu,3);
	Controller.H.GUI_4_SpeciesCharge.String 				= num2str(Species.q,3);
	Controller.H.GUI_4_SpeciesType.Value 					= find(strcmp(Controller.H.GUI_4_SpeciesType.String,Species.Type));
	Controller.H.GUI_4_SpeciesInitialDensity.String 		= num2str(Species.n,3);
	Controller.H.GUI_4_SpeciesInitialTemperature.String 	= num2str(eV2K,3);
	Controller.H.GUI_4_SpeciesvdWArea.String 				= Species.vdW_Area.*1e20;
	switch char(Species.Excited)
	case 'Ground'
		Controller.H.GUI_4_SpeciesExcitedBtnGroup.SelectedObject = Controller.H.GUI_4_SpeciesExcitedGroundBtn;
	case 'Electronic'
		Controller.H.GUI_4_SpeciesExcitedBtnGroup.SelectedObject = Controller.H.GUI_4_SpeciesExcitedElectronicBtn;
	case 'Vibrational'
		Controller.H.GUI_4_SpeciesExcitedBtnGroup.SelectedObject = Controller.H.GUI_4_SpeciesExcitedVibrationBtn;
	otherwise
		error('Species excitation-state not recognised')
	end
end