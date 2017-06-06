function Reaction_DB_ReturnAttributes(Controller)
	%disp('Reaction_DB_ReturnAttributes called')
	Mode = Controller.H.GUI_3_ModeBtnGroup.SelectedObject.String;
	try
		SelectedReactionCode = Controller.H.GUI_3_ReactionListbox.String{Controller.H.GUI_3_ReactionListbox.Value};
	catch
		BlankReactionAttributes(Controller);
		Controller.H.GUI_3_ReactionCode.String = blanks(0);
		return
	end
	switch Mode
	case 'Define'
		Controller.H.GUI_3_ReactionCode.String = SelectedReactionCode;
		BlankReactionAttributes(Controller);
	case 'Review'
		SelectedReaction 							= Controller.ReactionDB.Key(SelectedReactionCode);
		Controller.H.GUI_3_ReactionCode.String 		= SelectedReaction.Key;
		Controller.H.GUI_3_ReactionReactants.String = ReactionSpeciesList(SelectedReaction.ReactantSpeciesDict);
		Controller.H.GUI_3_ReactionProducts.String 	= ReactionSpeciesList(SelectedReaction.ProductSpeciesDict);
		Controller.H.GUI_3_ReactionEnergy.String 	= SelectedReaction.E;
		Controller.H.GUI_3_ReactionRate.String 		= SelectedReaction.RateCoefficientForm;
		Controller.H.GUI_3_ReactionType.Value 		= find(strcmp(Controller.H.GUI_3_ReactionType.String,SelectedReaction.ReactionType));
		%Controller.H.GUI_3_ReactionRateUnits.Value 	= find(strcmp(Controller.H.GUI_3_ReactionRateUnits.String,char(SelectedReaction.RateCoefficientForm.units)));
	end
end
function BlankReactionAttributes(Controller)
	%disp('BlankReactionAttributes called')
	Controller.H.GUI_3_ReactionReactants.String 	= blanks(0);
	Controller.H.GUI_3_ReactionProducts.String 		= blanks(0);
	Controller.H.GUI_3_ReactionEnergy.String 		= blanks(0);
	Controller.H.GUI_3_ReactionRate.String 			= blanks(0);
%	Controller.H.GUI_3_ReactionRateUnits.Value 		= find(strcmp(Controller.H.GUI_3_ReactionRateUnits.String,'m^3/s'));
end
function SpeciesString = ReactionSpeciesList(SpeciesDict)
	SpeciesList = {};
	for Species = SpeciesDict.keys
		if SpeciesDict(Species{:}) ~= 1
			SpeciesList = [SpeciesList,sprintf('%s*%s',num2str(SpeciesDict(Species{:})),Species{:})];
		else
			SpeciesList = [SpeciesList,Species];
		end
	end
	SpeciesString = strjoin(SpeciesList,',');
end