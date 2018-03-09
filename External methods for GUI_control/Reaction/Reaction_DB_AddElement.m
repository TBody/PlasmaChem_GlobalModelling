function Reaction_DB_AddElement(Controller)
	%disp('Reaction_DB_AddElement called')
	Mode 			= Controller.H.GUI_3_ModeBtnGroup.SelectedObject.String;
	ReactionCode 	= Controller.H.GUI_3_ReactionCode.String;
	UpdateReaction(Controller,ReactionCode);
	switch Mode
	case 'Define'
		Controller.Global.ReactionFoundList.append(ReactionCode);
		Controller.Global.ReactionNotFoundList.remove(ReactionCode);
		Reaction_UpdateListbox(Controller);
	case 'Review'
		%Do nothing
	end
end
function UpdateReaction(Controller,ReactionCode)
	ReactantSpeciesList		= LIST_C(strtrim(strsplit(Controller.H.GUI_3_ReactionReactants.String,',')));
	ReactantSpeciesDict		= CountList(ReactantSpeciesList);
	ProductSpeciesList		= LIST_C(strtrim(strsplit(Controller.H.GUI_3_ReactionProducts.String,',')));
	ProductSpeciesDict		= CountList(ProductSpeciesList);
	%RateCoefficientUnits 	= eval(Controller.H.GUI_3_ReactionRateUnits.String{Controller.H.GUI_3_ReactionRateUnits.Value});
	RateCoefficientForm		= strtrim(Controller.H.GUI_3_ReactionRate.String);
	Energy 					= strtrim(Controller.H.GUI_3_ReactionEnergy.String);
	ReactionType 			= Controller.H.GUI_3_ReactionType.String{Controller.H.GUI_3_ReactionType.Value};
	Reaction = REACTION_C(...
		ReactionCode,...
		ReactantSpeciesDict,...
		ProductSpeciesDict,...
		RateCoefficientForm,...
		Energy,...
		ReactionType);
	Controller.Global.ReactionsUpdated = true;
    load('DB_MAIN','ReactionDB_MAIN');
	ReactionDB_MAIN.add(Reaction.Key,Reaction); %Also updates
	save('Databases/DB_MAIN','ReactionDB_MAIN','-append');
	Controller.ReactionDB.add(Reaction.Key,Reaction);
end
function SpeciesDict = CountList(SpeciesList)
	SpeciesDict		= containers.Map;
	for Species = SpeciesList.list
		if strfind(Species{:},'*') %Multiplication factor
			SpeciesSplit = strsplit(Species{:},'*');
			if length(SpeciesSplit) == 2
				SpeciesDict(SpeciesSplit{2}) = str2num(SpeciesSplit{1});
			else
				error('Error in interpreting UI reactant or species mutlipliers')
			end
		else
			SpeciesDict(Species{:}) = SpeciesList.count(Species{:});
		end
	end
end