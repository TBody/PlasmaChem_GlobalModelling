function Builder = CrosssectionBuilder_Make(obj)
%Elements
	Builder 					= defaultFigure(			 [140,75,1000,600],	'Cross-section database builder');
	FileNameString 				= defaultString 	(Builder,[50,525,350,50],	'Cross-section filename (.csv):');
	obj.H.FileName 				= defaultEditString (Builder,[400,530,450,50]);
	UIgetFile 					= defaultUIcontrol 	(Builder,[870,530,100,50],	'Load',@obj.CrosssectionUIgetFile);
	DBKeyString 				= defaultString		(Builder,[50,450,200,50],	'Database Key:');
	obj.H.DBKey 				= defaultEditString	(Builder,[250,455,230,50]);
	HeaderLinesString			= defaultString		(Builder,[50,380,200,50],	'Header Lines:');
	obj.H.HeaderLines 			= defaultEditString	(Builder,[250,385,230,50]);
		obj.H.HeaderLines.String = '3';
	EnergyUnitsString 			= defaultString		(Builder,[50,310,250,50],	'Energy Units');
	obj.H.EnergyUnitsExp		= defaultEditString	(Builder,[270,315,100,50]);
		obj.H.EnergyUnitsExp.String = '1';
	obj.H.EnergyUnitsType 		= defaultPopupMenu	(Builder,[385,310,100,50],	{'eV','J'});
	CrosssectionUnitsString 	= defaultString		(Builder,[50,240,250,50],	'Crosssection Units');
	obj.H.CrosssectionUnitsExp 	= defaultEditString	(Builder,[270,245,100,50]);
	obj.H.CrosssectionUnitsType = defaultPopupMenu	(Builder,[385,240,100,50],	{'cm2','m2'});
	PowerOfTenString			= defaultText 	 	(Builder,[195,210,250,30],	'Power of ten');
	obj.H.PlotModeButtonGroup 	= defaultButtonGroup(Builder,[50,140,430,60], 	@obj.ModeChangedFunction);
	PlotModeString 				= defaultString 	(obj.H.PlotModeButtonGroup,[10,15,70,30],	'Show: ');
	PlotCrosssectionButton 		= defaultRadio 		(obj.H.PlotModeButtonGroup,[100,10,100,30],	'Data');
	PlotRateCoefficientButton 	= defaultRadio 		(obj.H.PlotModeButtonGroup,[250,10,100,30],	'Rate');
	OverwritePanel 				= defaultPanel 		(Builder,[310+20,15,200,50]);
	obj.H.OverwriteCheckbox 	= defaultUIcontrol 	(OverwritePanel,[25,0,200,50],'Overwrite','');
		obj.H.OverwriteCheckbox.Style = 'Checkbox';
	obj.H.PlotPanel 			= defaultPanel 		(Builder,[520 140 450 370]);
	obj.H.Evaluate 				= defaultPushbutton (obj.H.PlotPanel,[80,160,300,50],	'Evaluate Crosssection',@obj.CrosssectionEvaluate);
	obj.H.PlotIDString 			= defaultString 	(Builder,[520,70,450,50],'Rate Coefficient');
		obj.H.PlotIDString.HorizontalAlignment = 'center';
	CancelButton 				= defaultMainPushbutton(Builder,[50 15 200 50],'Cancel',@obj.CrosssectionCancel);
	SaveAndCloseButton 			= defaultMainPushbutton(Builder,[530+20 15 200 50],'Save & close',@obj.CrosssectionSaveAndClose);
	AddAnotherButton 			= defaultMainPushbutton(Builder,[750+20 15 200 50],'Add another',@obj.CrosssectionAddAnother);
%End elements
end
function defaultFigure = defaultFigure(Position,Name)
	defaultFigure = figure('Units','pixels','Name',Name,'Position',Position,...
		'MenuBar','None','NumberTitle','Off','Resize','Off',...
		'Visible','Off','WindowStyle','Normal');
end
function defaultTabgroup = defaultTabgroup(Parent,Position,SelectionChangedFcn)
	defaultTabgroup = uitabgroup('Units','pixels','Parent',Parent,...
		'Position',Position,'SelectionChangedFcn',SelectionChangedFcn);
end
function defaultTab = defaultTab(Parent,Title,Tag)
	defaultTab = uitab('Units','pixels','Parent',Parent,'Title',Title,'Tag',Tag);
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
function defaultTitle = defaultTitle(Parent,String)
	defaultTitle = defaultUIcontrol(Parent,[30,570,1000,70],String,'');
	defaultTitle.HorizontalAlignment = 'left';
	defaultTitle.Style = 'text';
	defaultTitle.FontSize = 48;
end
function defaultString = defaultString(Parent,Position,String)
	defaultString = defaultUIcontrol(Parent,Position,String,'');
	defaultString.HorizontalAlignment = 'left';
	defaultString.Style = 'text';
end
function defaultEditString = defaultEditString(Parent,Position)
	defaultEditString = defaultUIcontrol(Parent,Position,'','');
	defaultEditString.HorizontalAlignment = 'center';
	defaultEditString.Style = 'edit';
end
function defaultText = defaultText(Parent,Position,String)
	defaultText = defaultString(Parent,Position,String);
	defaultText.FontSize = 20;
	defaultText.HorizontalAlignment = 'center';
end
function defaultPanel = defaultPanel(Parent,Position)
	defaultPanel = uipanel('Units','pixels','Parent',Parent,'Position',Position);
end
function defaultRadio = defaultRadio(Parent,Position,String)
	defaultRadio = defaultUIcontrol(Parent,Position,String,'');
	defaultRadio.Style = 'radiobutton';
end
function defaultButtonGroup = defaultButtonGroup(Parent,Position,SelectionChangedFcn)
	defaultButtonGroup = uibuttongroup('Units','pixels','Parent',Parent,'Position',Position,...
		'SelectionChangedFcn',SelectionChangedFcn);
end
function defaultListbox = defaultListbox(Parent,Position,SelectionChangedFcn)
	defaultListbox = uicontrol('Units','pixels','Parent',Parent,'Position',Position,...
		'Callback',SelectionChangedFcn,'HorizontalAlignment','left',...
		'min',0,'max',1,'String',blanks(0),'Style','Listbox','Value',1,...
		'FontName','Avenir Next','FontSize',24);
end
function defaultPopupMenu = defaultPopupMenu(Parent,Position,String)
	defaultPopupMenu = defaultUIcontrol(Parent,Position,String,'');
	defaultPopupMenu.FontSize = 18;
	defaultPopupMenu.Style = 'popupmenu';
	defaultPopupMenu.Value = 1;
end