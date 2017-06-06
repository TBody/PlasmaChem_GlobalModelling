function Reaction_UpdateMode(Controller)
	%disp('Reaction_UpdateMode called')
	Mode = Controller.H.GUI_3_ModeBtnGroup.SelectedObject.String;
	ReactionIndex 	= find(strcmp(Controller.H.GUI_3_ReactionListbox.String,Controller.H.GUI_3_ReactionCode));
	if isempty(ReactionIndex)
		ReactionIndex = 1;
	end
	switch Mode
	case 'Define'
		Controller.H.GUI_3_ReactionListboxHeader.String = 'Reactions not found in database';
		Controller.H.GUI_3_ReactionAttributes.String = 'Define reaction attributes';
		Controller.H.GUI_3_ReactionDefine.String = 'Associate with code selected in list';
		Controller.H.GUI_3_ReactionDefine.Position = [0.4660,0.0606,0.4494,0.1263];
		Controller.H.GUI_3_ReactionDelete.Visible = 'Off';
		Controller.H.GUI_3_ReactionListbox.Value = ReactionIndex;
	case 'Review'
		Controller.H.GUI_3_ReactionListboxHeader.String = 'Reactions found in database';
		Controller.H.GUI_3_ReactionAttributes.String = 'Review reaction attributes';
		Controller.H.GUI_3_ReactionDefine.String = 'Update selected code';
		Controller.H.GUI_3_ReactionDefine.Position = [0.4180,0.0606,0.2792,0.1263];
		Controller.H.GUI_3_ReactionDelete.Visible = 'On';
		Controller.H.GUI_3_ReactionListbox.Value = ReactionIndex;
	end
	Reaction_UpdateListbox(Controller)
end