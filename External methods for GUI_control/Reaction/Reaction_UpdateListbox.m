function Reaction_UpdateListbox(Controller)
	%disp('Reaction_UpdateListbox called')
	Mode = Controller.H.GUI_3_ModeBtnGroup.SelectedObject.String;
	switch Mode
	case 'Define'
		try ListPopulated = logical(Controller.Global.ReactionNotFoundList.length);
		catch
			ListPopulated = false;
		end
		if ListPopulated
			Controller.H.GUI_3_ReactionListbox.String 	= Controller.Global.ReactionNotFoundList.list';
		else
			Controller.H.GUI_3_ReactionListbox.Value 	= 1;
			Controller.H.GUI_3_ReactionListbox.String 	= blanks(0);
		end
	case 'Review'
		try ListPopulated = logical(Controller.Global.ReactionFoundList.length);
		catch
			ListPopulated = false;
		end
		if ListPopulated
			Controller.H.GUI_3_ReactionListbox.String 	= Controller.Global.ReactionFoundList.list';
		else
			Controller.H.GUI_3_ReactionListbox.Value 	= 1;
			Controller.H.GUI_3_ReactionListbox.String = blanks(0);
		end
	end
	Reaction_DB_ReturnAttributes(Controller);
end