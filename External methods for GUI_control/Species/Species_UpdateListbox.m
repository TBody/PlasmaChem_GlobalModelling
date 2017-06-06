function Species_UpdateListbox(Controller)
	%disp('Species_UpdateListbox called')
	Mode = Controller.H.GUI_4_ModeBtnGroup.SelectedObject.String;
	switch Mode
	case 'Define'
		try ListPopulated = logical(Controller.Global.SpeciesNotFoundList.length);
		catch
			ListPopulated = false;
		end
		if ListPopulated
			Controller.H.GUI_4_SpeciesListbox.String 	= Controller.Global.SpeciesNotFoundList.list';
		else
			Controller.H.GUI_4_SpeciesListbox.Value 	= 1;
			Controller.H.GUI_4_SpeciesListbox.String 	= blanks(0);
		end
	case 'Review'
		try ListPopulated = logical(Controller.Global.SpeciesFoundList.length);
		catch
			ListPopulated = false;
		end
		if ListPopulated
			Controller.H.GUI_4_SpeciesListbox.String 	= Controller.Global.SpeciesFoundList.list';
		else
			Controller.H.GUI_4_SpeciesListbox.Value 	= 1;
			Controller.H.GUI_4_SpeciesListbox.String = blanks(0);
		end
	end
	Species_DB_ReturnAttributes(Controller);
end