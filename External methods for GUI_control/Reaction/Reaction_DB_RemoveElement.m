function Reaction_DB_RemoveElement(Controller)
	%disp('Reaction_DB_RemoveElement called')
	Mode 			= Controller.H.GUI_3_ModeBtnGroup.SelectedObject.String;
	ReactionCode 	= Controller.H.GUI_3_ReactionCode.String;
	if isempty(ReactionCode)
		return
	end
	switch Mode
	case 'Define'
		error('Err: ReactionDelete called in Define mode - not allowed')
	case 'Review'
		%load('DB_MAIN','ReactionDB_MAIN')
		%ReactionDB_MAIN.remove(ReactionCode);
		%save('Databases/DB_MAIN','ReactionDB_MAIN','-append')
		Controller.ReactionDB.remove(ReactionCode);
		Controller.Global.ReactionFoundList.remove(ReactionCode);
	end
	if Controller.H.GUI_3_ReactionListbox.Value <= length(Controller.H.GUI_3_ReactionListbox.String) - 1
	elseif Controller.H.GUI_3_ReactionListbox.Value - 1 <= length(Controller.H.GUI_3_ReactionListbox.String) - 1
		Controller.H.GUI_3_ReactionListbox.Value = Controller.H.GUI_3_ReactionListbox.Value - 1;
	else
		Controller.H.GUI_3_ReactionListbox.Value = 1;
	end
	Reaction_UpdateListbox(Controller)
end