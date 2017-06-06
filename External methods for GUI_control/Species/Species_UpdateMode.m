function Species_UpdateMode(Controller)
	%disp('Species_UpdateMode called')
	Mode = Controller.H.GUI_4_ModeBtnGroup.SelectedObject.String;
	SpeciesIndex 	= find(strcmp(Controller.H.GUI_4_SpeciesListbox.String,Controller.H.GUI_4_SpeciesFormula));
	if isempty(SpeciesIndex)
		SpeciesIndex = 1;
	end
	switch Mode
	case 'Define'
		Controller.H.GUI_4_SpeciesListboxHeader.String = 'Species not found in database';
		Controller.H.GUI_4_SpeciesAttributes.String = 'Define species attributes';
		Controller.H.GUI_4_SpeciesDefine.String = 'Associate with formula selected in list';
		Controller.H.GUI_4_SpeciesListbox.Value = SpeciesIndex;
	case 'Review'
		Controller.H.GUI_4_SpeciesListboxHeader.String = 'Species found in database';
		Controller.H.GUI_4_SpeciesAttributes.String = 'Review species attributes';
		Controller.H.GUI_4_SpeciesDefine.String = 'Update formula selected in list';
		Controller.H.GUI_4_SpeciesListbox.Value = SpeciesIndex;
	end
	Species_UpdateListbox(Controller);
end