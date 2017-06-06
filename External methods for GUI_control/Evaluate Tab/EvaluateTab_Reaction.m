function ProceedAllowed = EvaluateTab_Reaction(Controller)
	global IgnoreReactionsUndefined
	Controller.Global.SystemUpdated = true;
	disp('Evaluating reactions')
	try ReactionsUnfound = logical(Controller.Global.ReactionNotFoundList.length);
	catch %If the list isn't defined then the code for Reactions hasn't been run. Probably just skimming menus - so let them through
		ProceedAllowed = true;
		warning('''EvaluateTab_Reaction'' was called before defining reactions. Species will not auto-generate.')
		return
	end
	if ReactionsUnfound
		ReactionUndefinedWarning = WarnReactionsUndefined;
		uiwait(ReactionUndefinedWarning);
		if ~IgnoreReactionsUndefined
			Controller.H.GUI_3_ModeBtnGroup.SelectedObject = Controller.H.GUI_3_DefineBtn;
			Reaction_UpdateMode(Controller);
			ProceedAllowed = false;
			return
		end
	end
	if Controller.Global.ReactionsUpdated
		disp(' - loading DB_MAIN')
		load('DB_MAIN','ReactionDB_MAIN');
		for ReactionKey = Controller.ReactionDB.KeyList
			Reaction = Controller.ReactionDB.Key(ReactionKey);
			ReactionDB_MAIN.add(Reaction.Key,Reaction); %Also updates
		end
		disp(' - saving reactions to DB_MAIN')
		save('Databases/DB_MAIN','ReactionDB_MAIN','-append');
		Controller.Global.ReactionsUpdated = false;
	end
	disp(' - building list of species found in reactions')
	Build_SpeciesLists(Controller);
	Species_UpdateListbox(Controller);
	disp(' - done')
	ProceedAllowed = true;
end
function Build_SpeciesLists(Controller)
	Controller.Global.SpeciesFoundList 	  	= LIST_C;
	Controller.Global.SpeciesNotFoundList 	= LIST_C;
	try load('DB_MAIN')
	catch ME
			SpeciesDB_MAIN = DATABASE_C;
			disp(ME.message);
	end
	SpeciesList = generate_unique_SpeciesList(Controller);
	for SpeciesKey = SpeciesList
		if SpeciesDB_MAIN.KeyExists(SpeciesKey)
			Controller.Global.SpeciesFoundList.append(SpeciesKey);
			Controller.SpeciesDB.add(SpeciesKey,SpeciesDB_MAIN.Key(SpeciesKey));
		else
			Controller.Global.SpeciesNotFoundList.append(SpeciesKey);
		end
	end
end
function Return_unique_SpeciesList = generate_unique_SpeciesList(Controller)
	SpeciesList = LIST_C;
	for ReactionKey = Controller.Global.ReactionFoundList.list
		Reaction = Controller.ReactionDB.Key(ReactionKey);
	    SpeciesList.extend([Reaction.ProductSpeciesDict.keys,...
	    Reaction.ReactantSpeciesDict.keys]);
	end
	unique_SpeciesList = SpeciesList.unique;
	unique_SpeciesList.remove('wall');
	unique_SpeciesList.remove('e'); %All these quantities will be set by quasineutrality and rate-balancing
	unique_SpeciesList.remove('F_s');
	Return_unique_SpeciesList = unique_SpeciesList.list;
end
function ReactionUndefinedWarning = WarnReactionsUndefined
	ReactionUndefinedWarning 	= defaultFigure([450,450,400,140],'Reaction codes undefined.');
	WarningText		 			= defaultText(ReactionUndefinedWarning,[0,50,400,90],'Warning: Some of the reaction codes supplied to the program have not been defined yet');
	DefineNowButton 			= defaultPushbutton(ReactionUndefinedWarning,[210,5,140,40],'Define now',@CloseWarning);
	IgnoreWarningButton 		= defaultPushbutton(ReactionUndefinedWarning,[50,5,140,40],'Ignore',@IgnoreWarning);
	function CloseWarning(Source,Event)
		global IgnoreReactionsUndefined
		IgnoreReactionsUndefined = false;
		delete(Source.Parent);
	end
	function IgnoreWarning(Source,Event)
		global IgnoreReactionsUndefined
		IgnoreReactionsUndefined = true;
		delete(Source.Parent);
	end
end
function defaultFigure = defaultFigure(Position,Name)
	defaultFigure = figure('Units','pixels','Name',Name,'Position',Position,...
		'MenuBar','None','NumberTitle','Off','Resize','Off',...
		'Visible','Off','WindowStyle','Normal');
end
function defaultUIcontrol = defaultUIcontrol(Parent,Position,String,Callback)
	defaultUIcontrol = uicontrol('Units','pixels','String',String,'Callback',Callback,...
		'Parent',Parent,'Position',Position,'FontName','Avenir Next',...
		'FontSize',24);
end
function defaultPushbutton = defaultPushbutton(Parent,Position,String,Callback)
	defaultPushbutton = defaultUIcontrol(Parent,Position,String,Callback);
	defaultPushbutton.Style = 'pushbutton';
end
function defaultMainPushbutton = defaultMainPushbutton(Parent,Position,String,Callback)
	defaultMainPushbutton = defaultPushbutton(Parent,Position,String,Callback);
	defaultMainPushbutton.FontSize = 28;
end
function defaultString = defaultString(Parent,Position,String)
	defaultString = defaultUIcontrol(Parent,Position,String,'');
	defaultString.HorizontalAlignment = 'left';
	defaultString.Style = 'text';
end
function defaultText = defaultText(Parent,Position,String)
	defaultText = defaultString(Parent,Position,String);
	defaultText.FontSize = 20;
	defaultText.HorizontalAlignment = 'center';
end