function [MainWindow,TabGroup] = GUI_Make(Controller)
%Elements
	MainWindow 											= defaultFigure(														[20,20,1280,750],	'Global Modelling of Plasma Chemistry');
	TabGroup 											= defaultTabgroup(		MainWindow,										[0,40,1280,700],	@Controller.TabSelectionChanged);
	%Tabs 									%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Controller.H.GUI_1 									= defaultTab(			TabGroup,	'Open Screen',	'1');
	Controller.H.GUI_2 									= defaultTab(			TabGroup,	'Reactor',		'2');
	Controller.H.GUI_3 									= defaultTab(			TabGroup,	'Reaction',		'3');
	Controller.H.GUI_4 									= defaultTab(			TabGroup,	'Species',		'4');
	Controller.H.GUI_5 									= defaultTab(			TabGroup,	'Experiment',	'5');
	Controller.H.GUI_6 									= defaultTab(			TabGroup,	'Evaluation',	'6');
	Controller.H.GUI_7 									= defaultTab(			TabGroup,	'Results',		'7');
	%MainWindow Buttons 					%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Controller.H.NextButton 							= defaultMainPushbutton(MainWindow, 									[1120,5,150,40],	'Next',		@Controller.NextButton);
	Controller.H.BackButton 							= defaultMainPushbutton(MainWindow, 									[970,5,150,40],		'Back',		@Controller.BackButton);
	Controller.H.CancelButton 							= defaultMainPushbutton(MainWindow, 									[820,5,150,40],		'Cancel',	@Controller.CancelButton);
	%GUI_1 (Open Screen) elements 			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_1_Title 										= defaultTitle(			Controller.H.GUI_1,	'Global Modelling of Plasma Chemistry');
	GUI_1_OpeningText 									= defaultText(			Controller.H.GUI_1,								[50,370,1100,200],...
														{'Author: Thomas Body';...
														'Contact for support: thomas.body@anu.edu.au';...
														blanks(0);...
														'This program was developed as part of an Honours thesis project. If used please cite Body, T, 2015, ''Production of Ammonia in a fusion-relevant plasma''.'});
	GUI_1_OpeningText.HorizontalAlignment = 'left';
	Controller.H.GUI_1_EvaluationMode 					= defaultButtonGroup(	Controller.H.GUI_1,								[50,230,1150,170],	@Controller.Global_EvaluationMode												);
	EvaluationModeString 								= defaultString(		Controller.H.GUI_1_EvaluationMode,				[30,130,300,30],	'Select Evaluation Mode'														);
	Controller.H.ScalarModeButton						= defaultRadio(			Controller.H.GUI_1_EvaluationMode, 				[140,80,300,50],	'Scalar'																		);
	ScalarModeText										= defaultText(			Controller.H.GUI_1_EvaluationMode,				[30,10,350,70],		'Single run - ''Experiment'' parameters will only accept single (scalar) input'	);
	Controller.H.VectorModeButton						= defaultRadio(			Controller.H.GUI_1_EvaluationMode, 				[530,80,300,50],	'Vector'																		);
	VectorModeText										= defaultText(			Controller.H.GUI_1_EvaluationMode,				[410,10,350,70],	'Simultaneously vary vectorised input parameters (must be equal length)'		);
	Controller.H.MatrixModeButton						= defaultRadio(			Controller.H.GUI_1_EvaluationMode, 				[900,80,300,50],	'Matrix'																		);
	MatrixModeText										= defaultText(			Controller.H.GUI_1_EvaluationMode,				[790,10,350,70],	'Independently vary vectorised input parameters (high computation time)'		);
	GUI_1_InitButtonPanel								= defaultPanel(			Controller.H.GUI_1,								[50,30,1150,170]																					);
	InitialisationString 								= defaultString(		GUI_1_InitButtonPanel,							[30,130,300,30],	'Initialisation Scripts'														);
	Controller.H.CheckDatabase							= defaultPushbutton(	GUI_1_InitButtonPanel,							[20,70,350,50],		'Check databases',							@Controller.Init_CheckDB			); Controller.H.CheckDatabase.TooltipString = 'Checks that DB_MAIN & CrosssectionDB exist, contain the correct elements and are non-empty.';															;
    CheckDatabaseText 									= defaultText(			GUI_1_InitButtonPanel,							[20,0,350,60],		'Looks for and inspects DB_MAIN and CrosssectionDB.'							);
	Controller.H.ResetDatabase 							= defaultPushbutton(	GUI_1_InitButtonPanel,							[400,70,350,50],	'Reset databases',							@Init_ResetDB_MAIN					);
	ResetDatabaseText 									= defaultText(			GUI_1_InitButtonPanel,							[400,0,350,60],		'Resets ReactionDB and Species DB in DB_MAIN.'									);
	Controller.H.CrosssectionBuilder					= defaultPushbutton(	GUI_1_InitButtonPanel,							[780,70,350,50],	'Launch crosssection builder',				@Controller.LaunchXCBuilder			); Controller.H.CrosssectionBuilder.TooltipString = 'To check CrosssectionDB contents type ''Controller.CrosssectionDB.KeyList''';																							;
	CrosssectionBuilderText 							= defaultText(			GUI_1_InitButtonPanel,							[780,0,350,60],		'Build and manage CrosssectionDB.'												);
	%GUI_2 (Reactor) elements 				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_2_Title 										= defaultTitle(			Controller.H.GUI_2,													'Define (cylindrical) reactor characteristics');
	GUI_2_MainPanel 									= defaultPanel(			Controller.H.GUI_2,								[100,190,590,350]												);
	ReactorNamePanel 									= defaultPanel(			GUI_2_MainPanel,								[20 260 550 60]													);
	ReactorNameString 									= defaultString(		ReactorNamePanel,								[15 10 300 40],		'Reactor name'								);
	Controller.H.ReactorName 							= defaultEditString(	ReactorNamePanel,								[270,10,250,40]													);
	ReactorLengthPanel 									= defaultPanel(			GUI_2_MainPanel,								[20 180 550 60]													);
	ReactorLengthString 								= defaultString(		ReactorLengthPanel,								[15 10 300 40],		'Reactor length (m)'						);
	Controller.H.ReactorLength 							= defaultEditString(	ReactorLengthPanel,								[270,10,250,40]													);
	ReactorRadiusPanel 									= defaultPanel(			GUI_2_MainPanel,								[20 100 550 60])												;
	ReactorRadiusString 								= defaultString(		ReactorRadiusPanel,								[15 10 300 40],		'Reactor radius (m)'						);
	Controller.H.ReactorRadius 							= defaultEditString(	ReactorRadiusPanel,								[270,10,250,40]													);
	ReactorWallTypePanel 								= defaultPanel(			GUI_2_MainPanel,								[20 20 550 60])													;
	ReactorWallTypeString 								= defaultString(		ReactorWallTypePanel,							[15 10 300 40],		'Reactor wall type'							);
	Controller.H.ReactorWallType 						= defaultPopupMenu(		ReactorWallTypePanel,							[270,10,250,40],	{'Pyrex','Stainless Steel'}					);
	%GUI_3 Reaction screen 					%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_3_Title 										= defaultTitle(			Controller.H.GUI_3,													'Provide reactions to include in model'		);
	Controller.H.GUI_3_MainPanel 						= defaultPanel(			Controller.H.GUI_3,								[50 25 1150 400]												);
	%Supply reaction codes 					%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_3_ReactionCodeListPanel 						= defaultPanel(			Controller.H.GUI_3,								[50 450 1150 120]												);
	ReactionCodeListString 								= defaultString(		GUI_3_ReactionCodeListPanel,					[50 60 1100 50],	'Supply reaction codes (comma-separated, whitespace allowed)');
	Controller.H.ReactionCodeList 						= defaultEditString(	GUI_3_ReactionCodeListPanel,					[20 10 700 50]													);
	Controller.H.ReactionCodeListQueryDB 				= defaultPushbutton(	GUI_3_ReactionCodeListPanel,					[730 10 350 50],	'Query database for codes',					@(Source,Event)Reaction_DB_Query(Controller));
	%Undefined reactions panel 				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_3_ReactionUndefinedPanel 						= defaultPanel(			Controller.H.GUI_3_MainPanel,					[0 0 435 400]													);
	Controller.H.GUI_3_ModeBtnGroup 					= defaultButtonGroup(	GUI_3_ReactionUndefinedPanel,					[15,325,400,50],	@(Source,Event)Reaction_UpdateMode(Controller));
	GUI_3_ModeString 									= defaultString(		Controller.H.GUI_3_ModeBtnGroup,				[5 5 100 40],		'Mode: '									);
	Controller.H.GUI_3_DefineBtn 						= defaultRadio(			Controller.H.GUI_3_ModeBtnGroup,				[125 5 125 40],		'Define'									);
	Controller.H.GUI_3_ReviewBtn 						= defaultRadio(			Controller.H.GUI_3_ModeBtnGroup,				[250 5 125 40],		'Review'									);
	Controller.H.GUI_3_ReactionListboxHeader 			= defaultString(		GUI_3_ReactionUndefinedPanel,					[0 275 440 40],		'Reactions not found in database'			); Controller.H.GUI_3_ReactionListboxHeader.HorizontalAlignment = 'center'																										;
	Controller.H.GUI_3_ReactionListbox 					= defaultListbox(		GUI_3_ReactionUndefinedPanel,					[15 15 400 250],	@(Source,Event)Reaction_UpdateListbox(Controller));
	%Define reaction characteristics		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Controller.H.GUI_3_ReactionAttributes				= defaultString(		Controller.H.GUI_3_MainPanel,					[460 340 350 50],	'Define reaction attributes'				);
	GUI_3_ReactionCodeString 							= defaultString(		Controller.H.GUI_3_MainPanel,					[450 300 125 50],	'Code'										);
	Controller.H.GUI_3_ReactionCode 					= defaultEditString(	Controller.H.GUI_3_MainPanel,					[580 310 200 40]												); Controller.H.GUI_3_ReactionCode.Enable = 'inactive'																															;
	GUI_3_ReactionReactantsString 						= defaultString(		Controller.H.GUI_3_MainPanel,					[450 245 125 50],	'Reactants'									);
	Controller.H.GUI_3_ReactionReactants 				= defaultEditString(	Controller.H.GUI_3_MainPanel,					[580 245 200 40]												); Controller.H.GUI_3_ReactionReactants.TooltipString = 'Supply species as comma-separated chem-formulae with multiples as X,X instead of 2X'										;
	GUI_3_ReactionProductsString 						= defaultString(		Controller.H.GUI_3_MainPanel,					[800 235 125 50],	'Products'									);
	Controller.H.GUI_3_ReactionProducts 				= defaultEditString(	Controller.H.GUI_3_MainPanel,					[920 245 200 40]												); Controller.H.GUI_3_ReactionProducts.TooltipString = 'Supply species as comma-separated chem-formulae with multiples as X,X instead of 2X'										;
	GUI_3_ReactionEnergyString 							= defaultString(		Controller.H.GUI_3_MainPanel,					[450 170 150 50],	'E (eV)'									);
	Controller.H.GUI_3_ReactionEnergy 					= defaultEditString(	Controller.H.GUI_3_MainPanel,					[580 180 200 40]												); Controller.H.GUI_3_ReactionEnergy.TooltipString = 'Supply threshold energy, or 0 if not applicable'																		;
	GUI_3_ReactionRateString 							= defaultString(		Controller.H.GUI_3_MainPanel,					[450 100 75 50],	'Rate'										);
	Controller.H.GUI_3_ReactionRate 					= defaultEditString(	Controller.H.GUI_3_MainPanel,					[530 110 600 40]												); Controller.H.GUI_3_ReactionRate.TooltipString = sprintf('For implicit reference use <ControllerProperty.Property> \nor <ControllerProperty:DB_Key.Property>\nController properties: G->Global, R->Reactor, E->Experiment,\nRR->ReactionDB, S->SpeciesDB, C->CrosssectionDB.');
	%Controller.H.GUI_3_ReactionRateUnits 				= defaultPopupMenu(		Controller.H.GUI_3_MainPanel,					[990 60 140 50], 	{'m^3/s';'1/s'}								);
	GUI_3_ReactionTypeString 							= defaultString(		Controller.H.GUI_3_MainPanel,					[800 300 150 50],	'Type'										);
	Controller.H.GUI_3_ReactionType 					= defaultPopupMenu(		Controller.H.GUI_3_MainPanel,					[880 295 250 50],	{'Ionisation'; 'Excitation'; 'e-Impact Dissociation/Neutralisation'; 'Ion-Neutral Chemical'; 'Wall Neutralisation'; 'Surface (Heterogeneous)';'Elastic'});
	Controller.H.GUI_3_ReactionDefine 					= defaultPushbutton(	Controller.H.GUI_3_MainPanel,					[535 25 515 50],	'Associate with code selected in list',		@(Source,Event)Reaction_DB_AddElement(Controller));
	Controller.H.GUI_3_ReactionDelete 					= defaultPushbutton(	Controller.H.GUI_3_MainPanel,					[805 25 320 50],	'Delete selected code',						@(Source,Event)Reaction_DB_RemoveElement(Controller)); Controller.H.GUI_3_ReactionDelete.Visible = 'off'																																;
	%GUI_4 Species screen					%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_4_Title 										= defaultTitle(			Controller.H.GUI_4,													'Provide details for species detected in reactions');
	Controller.H.GUI_4_MainPanel 						= defaultPanel(			Controller.H.GUI_4,								[50 25 1150 500]												);
	%Species undefined						%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_4_SpeciesUndefinedPanel 						= defaultPanel(			Controller.H.GUI_4_MainPanel,					[0 0 435 500]													);
	Controller.H.GUI_4_SpeciesListbox 					= defaultListbox(		GUI_4_SpeciesUndefinedPanel,					[15 15 400 350],	@(Source,Event)Species_UpdateListbox(Controller));
	Controller.H.GUI_4_SpeciesListboxHeader 			= defaultString(		GUI_4_SpeciesUndefinedPanel,					[0 375 440 40],		'Species not found in database'				); Controller.H.GUI_4_SpeciesListboxHeader.HorizontalAlignment = 'center';
	Controller.H.GUI_4_ModeBtnGroup 					= defaultButtonGroup(	GUI_4_SpeciesUndefinedPanel,					[15,425,400,50],	@(Source,Event)Species_UpdateMode(Controller));
	GUI_4_ModeString 									= defaultString(		Controller.H.GUI_4_ModeBtnGroup,				[5 5 100 40],		'Mode:'										);
	Controller.H.GUI_4_DefineBtn 						= defaultRadio(			Controller.H.GUI_4_ModeBtnGroup,				[125 5 125 40],		'Define'									);
	Controller.H.GUI_4_ReviewBtn 						= defaultRadio(			Controller.H.GUI_4_ModeBtnGroup,				[250 5 125 40],		'Review'									);
	%Define species characteristics			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Controller.H.GUI_4_SpeciesAttributes 				= defaultString(		Controller.H.GUI_4_MainPanel,					[460 440 350 50],	'Define species attributes'					);
	GUI_4_SpeciesFormulaString 							= defaultString(		Controller.H.GUI_4_MainPanel,					[470 380 150 50],	'Formula'									);
	Controller.H.GUI_4_SpeciesFormula 					= defaultEditString(	Controller.H.GUI_4_MainPanel,					[630 390 150 40]												); Controller.H.GUI_4_SpeciesFormula.Enable = 'inactive'																																					;
	GUI_4_SpeciesvdWAreaString 							= defaultString(		Controller.H.GUI_4_MainPanel,					[470 200 300 50],	'vdW Area (Angstrom^2)'						);
	Controller.H.GUI_4_SpeciesvdWArea					= defaultEditString(	Controller.H.GUI_4_MainPanel,					[730 210 380 40]												);
	GUI_4_SpeciesMassString 							= defaultString(		Controller.H.GUI_4_MainPanel,					[470 320 150 50],	'Mass (amu)'								);
	Controller.H.GUI_4_SpeciesMass 						= defaultEditString(	Controller.H.GUI_4_MainPanel,					[630 330 150 40]												);
	GUI_4_SpeciesChargeString 							= defaultString(		Controller.H.GUI_4_MainPanel,					[470 260 150 50],	'Charge (e)'								);
	Controller.H.GUI_4_SpeciesCharge 					= defaultEditString(	Controller.H.GUI_4_MainPanel,					[630 270 150 40]												);
	GUI_4_SpeciesTypeString 							= defaultString(		Controller.H.GUI_4_MainPanel,					[800 380 150 50],	'Type'										);
	Controller.H.GUI_4_SpeciesType 						= defaultPopupMenu(		Controller.H.GUI_4_MainPanel,					[920 385 195 40],	{'Neutral'; 'Positive Ion'; 'Negative Ion'; 'Surface'});
	GUI_4_SpeciesExcitedString 							= defaultString(		Controller.H.GUI_4_MainPanel,					[800 320 150 50],	'Excited'									);
	Controller.H.GUI_4_SpeciesExcitedBtnGroup 			= defaultButtonGroup(	Controller.H.GUI_4_MainPanel,					[920 275 190 100],	''											);
	Controller.H.GUI_4_SpeciesExcitedGroundBtn 			= defaultRadio(			Controller.H.GUI_4_SpeciesExcitedBtnGroup,		[10 65 150 25],		'Ground'									);
	Controller.H.GUI_4_SpeciesExcitedElectronicBtn 		= defaultRadio(			Controller.H.GUI_4_SpeciesExcitedBtnGroup,		[10 35 150 25],		'Electronic'								);
	Controller.H.GUI_4_SpeciesExcitedVibrationBtn 		= defaultRadio(			Controller.H.GUI_4_SpeciesExcitedBtnGroup,		[10 5 150 25],		'Vibrational'								);
	GUI_4_InitialPanel 									= defaultPanel(			Controller.H.GUI_4_MainPanel,					[450 85 680 65]													);
	Controller.H.GUI_4_InitialString 					= defaultString(		Controller.H.GUI_4_MainPanel,					[470 150 400 40],	'Initial Values'							);
	GUI_4_InitialDensityString 							= defaultString(		GUI_4_InitialPanel,								[20 0 	200 50],	'Density (m^-3)'							);
	Controller.H.GUI_4_SpeciesInitialDensity 			= defaultEditString(	GUI_4_InitialPanel,								[220 12 150 40]													);
	Controller.H.GUI_4_InitialTemperatureString 		= defaultString(		GUI_4_InitialPanel,								[410 0 	200 50],	'Temp (K)' 									);
	Controller.H.GUI_4_SpeciesInitialTemperature 		= defaultEditString(	GUI_4_InitialPanel,								[520 12 150 40]													);
	Controller.H.GUI_4_SpeciesDefine 					= defaultPushbutton(	Controller.H.GUI_4_MainPanel,					[535 25 515 50],	'Associate with formula selected in list',	@(Source,Event)Species_DB_AddElement(Controller));
	%GUI_5 Experiment screen 				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_5_Title 										= defaultTitle(			Controller.H.GUI_5,													'Define experiment characteristics'			);
	GUI_5_MainPanel 									= defaultPanel(			Controller.H.GUI_5,								[50,50,1150,500]												);
	ExpReferencePanel 									= defaultPanel(			GUI_5_MainPanel,								[20 415 685 60]													);
	ExpReferenceString 									= defaultString(		ExpReferencePanel,								[10 10 310 40],		'Experiment reference'						);
	Controller.H.ExpReference 							= defaultEditString(	ExpReferencePanel,								[350 10 310 40]													);
	ExpPowerAbsorbedPanel 								= defaultPanel(			GUI_5_MainPanel,								[20 335 685 60]													);
	ExpPowerAbsorbedString 								= defaultString(		ExpPowerAbsorbedPanel,							[10 10 310 40],		'Power absorbed (W)'						);
	Controller.H.ExpPowerAbsorbed 						= defaultEditString(	ExpPowerAbsorbedPanel,							[350 10 310 40]													);
	ExpDutyCyclePanel 									= defaultPanel(			GUI_5_MainPanel,								[20 255 685 60]													);
	ExpDutyCycleString 									= defaultString(		ExpDutyCyclePanel,								[10 10 310 40],		'Pulsed power freq (Hz)'					);
	Controller.H.ExpDutyCycle 							= defaultEditString(	ExpDutyCyclePanel,								[350 10 310 40]													); Controller.H.ExpDutyCycle.Enable = 'off'																																		;
	ExpPowerFreqPanel 									= defaultPanel(			GUI_5_MainPanel,								[20 175 685 60]													);
	ExpPowerFreqString 									= defaultString(		ExpPowerFreqPanel,								[10 10 310 40],		'Pulse duration (s)'						);
	Controller.H.ExpPowerFreq 							= defaultEditString(	ExpPowerFreqPanel,								[350 10 310 40]													); Controller.H.ExpPowerFreq.Enable = 'off'																																		;
	ExpStartingPressurePanel 							= defaultPanel(			GUI_5_MainPanel,								[20 90 685 60]													);
	ExpStartingPressureString 							= defaultString(		ExpStartingPressurePanel,						[10 10 310 40],		'Starting pressure (mTorr)'					);
	Controller.H.ExpStartingPressure 					= defaultEditString(	ExpStartingPressurePanel,						[350 10 310 40]													);
	%Right panel - gas supply 				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_5_GasSupplyPanel 								= defaultPanel(			GUI_5_MainPanel,								[725 10 400 470]												);
	GasSupply_String 									= defaultString(		GUI_5_GasSupplyPanel,							[11 372 375 87],	'Add species to gas supply'					);
	GasSupplySpeciesString 								= defaultString(		GUI_5_GasSupplyPanel,							[50 350 200 50],	'Species'									);
	Controller.H.GasSupplySpecies 						= defaultEditString(	GUI_5_GasSupplyPanel,							[30 305 340 50]													);
	GasSupplyRateString 								= defaultString(		GUI_5_GasSupplyPanel,							[50 255 300 50],	'Supply rate (sccm)'						);
	Controller.H.GasSupplyRate 							= defaultEditString(	GUI_5_GasSupplyPanel,							[30 210 340 50]													);
	Controller.H.GasSupplyListbox 						= defaultListbox(		GUI_5_GasSupplyPanel,							[30 24 340 113],												@(Source,Event)GasSupply_UpdatePanel(Controller));
	Controller.H.GasSupplyUpdate 						= defaultPushbutton(	GUI_5_GasSupplyPanel,							[30 150 150 50],	'Update',									@(Source,Event)GasSupply_UpdateDictionary(Controller));
	Controller.H.GasSupplyDelete 						= defaultPushbutton(	GUI_5_GasSupplyPanel,							[210 150 150 50],	'Delete',									@(Source,Event)GasSupply_DeleteElement(Controller));
	%GUI_6 Evaluate screen					%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_6_Title 										= defaultTitle(			Controller.H.GUI_6,													'Control & monitor evaluation of the balance equations');
	Controller.H.GUI_6_MainPanel 						= defaultPanel(			Controller.H.GUI_6,								[50 25 1150 500]												);
	GUI_6_InitialisePanel 								= defaultPanel(			Controller.H.GUI_6_MainPanel, 					[0 0 435 500]													);
	Controller.H.GUI_6_ModeBtnGroup 					= defaultButtonGroup(	GUI_6_InitialisePanel,							[15,425,400,50],	@Controller.Evaluation_Mode_Callback		);
	GUI_6_ModeString 									= defaultString(		Controller.H.GUI_6_ModeBtnGroup,				[10 5 100 40],		'Mode:'										);
	Controller.H.GUI_6_ControlBtn 						= defaultRadio(			Controller.H.GUI_6_ModeBtnGroup,				[125 5 125 40],		'Control'									);
	Controller.H.GUI_6_MonitorBtn 						= defaultRadio(			Controller.H.GUI_6_ModeBtnGroup,				[250 5 125 40],		'Monitor'									); Controller.H.GUI_6_MonitorBtn.Enable = 'off';
	RelTolerancePanel 									= defaultPanel(			GUI_6_InitialisePanel,							[15 360 400 50]													);
	RelToleranceString 									= defaultString(		RelTolerancePanel,								[10 5 220 40],		'Relative tolerance'						);
	Controller.H.RelTolerance 							= defaultEditString(	RelTolerancePanel,								[230 7.5 160 35]												); Controller.H.RelTolerance.String = '1e-6';
	MaxStepPanel 										= defaultPanel(			GUI_6_InitialisePanel,							[15 300 400 50]													);
	MaxStepString 										= defaultString(		MaxStepPanel,									[10 5 220 40],		'Max step-size'								);
	Controller.H.MaxStep 								= defaultEditString(	MaxStepPanel,									[230 7.5 160 35]												); Controller.H.MaxStep.String = '1';
	Controller.H.GUI_6_ConvergenceCheckBtnGroup 		= defaultButtonGroup(	GUI_6_InitialisePanel,							[15,240,400,50],	@Controller.Evaluation_Monitor_Callback		);
	GUI_6_ModeString 									= defaultString(		Controller.H.GUI_6_ConvergenceCheckBtnGroup,	[10 5 200 40],		'Monitor: '									);
	Controller.H.GUI_6_AutoBtn 							= defaultRadio(			Controller.H.GUI_6_ConvergenceCheckBtnGroup,	[125 5 125 40],		'Auto'										);
	Controller.H.GUI_6_ManualBtn 						= defaultRadio(			Controller.H.GUI_6_ConvergenceCheckBtnGroup,	[250 5 125 40],		'Manual'									);
	ConvergenceParameterPanel 							= defaultPanel(			GUI_6_InitialisePanel,							[15 180 400 50]													);
	Controller.H.GUI_6_ConvergenceParameterString 		= defaultString(		ConvergenceParameterPanel,						[10 5 220 40],		'Convergence tol.'							);
	Controller.H.GUI_6_ConvergenceParameter 			= defaultEditString(	ConvergenceParameterPanel,						[230 7.5 160 35]												); Controller.H.GUI_6_ConvergenceParameter.String = '1';
	Controller.H.GUI_6_SelectTestPanel 					= defaultPanel(			GUI_6_InitialisePanel,							[15 120 400 50]													);
	Controller.H.GUI_6_SelectParameter 					= defaultPopupMenu(		Controller.H.GUI_6_SelectTestPanel,				[10 7.5 220 35],	{'Power absorbed';'Starting pressure';'Gas supply'}); Controller.H.GUI_6_SelectParameter.Callback = @(Source,Event)Evaluation_SelectTest(Controller);
	Controller.H.GUI_6_SelectTest 						= defaultPopupMenu(		Controller.H.GUI_6_SelectTestPanel,				[230 7.5 160 35],	{'N/A'}										); Controller.H.GUI_6_SelectTest.Callback = @(Source,Event)Evaluation_SaveTestIndex(Controller);
	Controller.H.MaxEvaluationsPanel 					= defaultPanel(			GUI_6_InitialisePanel,							[15 120 400 50]													); Controller.H.MaxEvaluationsPanel.Visible = 'off';
	Controller.H.MaxEvaluationsString 					= defaultString(		Controller.H.MaxEvaluationsPanel,				[10 5 220 40],		'Max Evaluations'							);
	Controller.H.MaxEvaluations 						= defaultEditString(	Controller.H.MaxEvaluationsPanel,				[230 7.5 160 35]												); Controller.H.MaxEvaluations.String = '10000';
	Controller.H.GUI_6_EvaluateODE 						= defaultPushbutton(	GUI_6_InitialisePanel,							[30 20 375 70], 	'Check convergence',						@Controller.Evaluation_Evaluate);
	Controller.H.GUI_6_ShowPanel 						= defaultPanel(			Controller.H.GUI_6_MainPanel, 					[430 0 720 500]													);
	Controller.H.GUI_6_ShowPanelString 					= defaultString(		Controller.H.GUI_6_ShowPanel,					[30 440 350 50],	'Check convergence'							);
	Controller.H.GUI_6_YaxisGroup 						= defaultButtonGroup(	Controller.H.GUI_6_ShowPanel,					[25,400,250,50],	@Controller.Evaluation_AxesChange_Callback	);
	GUI_6_YaxisString 									= defaultString(		Controller.H.GUI_6_YaxisGroup,					[10 5 80 40],		'Y-axis: '									);
	Controller.H.GUI_6_Y 								= defaultRadio(			Controller.H.GUI_6_YaxisGroup,					[90 5 50 40],		'Y'											);
	Controller.H.GUI_6_Err 								= defaultRadio(			Controller.H.GUI_6_YaxisGroup,					[150 5 80 40],		'Err/Y'										);
	Controller.H.GUI_6_XaxisGroup 						= defaultButtonGroup(	Controller.H.GUI_6_ShowPanel,					[275,400,250,50],	@Controller.Evaluation_AxesChange_Callback	);
	GUI_6_XaxisString 									= defaultString(		Controller.H.GUI_6_XaxisGroup,					[10 5 80 40],		'X-axis: '									);
	Controller.H.GUI_6_Step 							= defaultRadio(			Controller.H.GUI_6_XaxisGroup,					[90 5 50 40],		'T'											);
	Controller.H.GUI_6_T 								= defaultRadio(			Controller.H.GUI_6_XaxisGroup,					[150 5 80 40],		'Step'										);
	Controller.H.GUI_6_PlotPanel 						= defaultPanel(			Controller.H.GUI_6_ShowPanel, 					[25 20 670 370]													);
	Controller.H.GUI_6_MonitorPanel 					= defaultPanel(			Controller.H.GUI_6_ShowPanel,					[25 20 670 370]													); Controller.H.GUI_6_MonitorPanel.Visible 			= 'off';
	Controller.H.GUI_6_CalculationsToPeformString		= defaultString(		Controller.H.GUI_6_MonitorPanel,				[20 300 350 40],	'Calculations to perform: '					); Controller.H.GUI_6_CalculationsToPeformString.HorizontalAlignment = 'right';
	Controller.H.GUI_6_CalculationsToPeform 			= defaultString(		Controller.H.GUI_6_MonitorPanel,				[400 300 350 40],	'0'											);
	Controller.H.GUI_6_CalculationsCompletedString		= defaultString(		Controller.H.GUI_6_MonitorPanel,				[20 250 350 40],	'Calculations completed: '					); Controller.H.GUI_6_CalculationsCompletedString.HorizontalAlignment = 'right';
	Controller.H.GUI_6_CalculationsCompleted 			= defaultString(		Controller.H.GUI_6_MonitorPanel,				[400 250 350 40],	'0'											);
	Controller.H.GUI_6_AverageTimePerCalcString			= defaultString(		Controller.H.GUI_6_MonitorPanel,				[20 200 350 40],	'Average time per calc. (s): '				); Controller.H.GUI_6_AverageTimePerCalcString.HorizontalAlignment = 'right';
	Controller.H.GUI_6_AverageTimePerCalc 				= defaultString(		Controller.H.GUI_6_MonitorPanel,				[400 200 350 40],	'0'											);
	Controller.H.GUI_6_EstimatedTimeOfCompletionString	= defaultString(		Controller.H.GUI_6_MonitorPanel,				[20 150 350 40],	'Estimated time of completion: '			); Controller.H.GUI_6_EstimatedTimeOfCompletionString.HorizontalAlignment = 'right';
	Controller.H.GUI_6_EstimatedTimeOfCompletion 		= defaultString(		Controller.H.GUI_6_MonitorPanel,				[400 150 350 40],	'0'											);
	Controller.H.GUI_6_ProgressBarPanel					= defaultPanel(			Controller.H.GUI_6_MonitorPanel,				[60 100 550 30]													); Controller.H.GUI_6_ProgressBarPanel.BackgroundColor = 'white';
	Controller.H.GUI_6_ProgressBar 						= defaultPanel(			Controller.H.GUI_6_ProgressBarPanel,			[-1 2 0 26]														); Controller.H.GUI_6_ProgressBar.BackgroundColor = 'red';
	Controller.H.GUI_6_TimerString 						= defaultString(		Controller.H.GUI_6_ShowPanel,					[550 400 145 80],	{'Timer';'00:00:00'}						); Controller.H.GUI_6_TimerString.HorizontalAlignment = 'center'; Controller.H.GUI_6_TimerString.ForegroundColor = 'red';
	%GUI_7 Results screen					%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	GUI_7_Title 										= defaultTitle(			Controller.H.GUI_7,													'Examine the solutions to the balance equations');
	Controller.H.GUI_7_MainPanel 						= defaultPanel(			Controller.H.GUI_7,								[50 25 1150 500]												);
	GUI_7_ControlPanel 									= defaultPanel(			Controller.H.GUI_7_MainPanel, 					[0 0 435 500]													);
	Controller.H.GUI_7_ModeBtnGroup 					= defaultButtonGroup(	GUI_7_ControlPanel,								[15,425,400,50],	@Controller.Results_Mode_Callback			);
	GUI_7_ModeString 									= defaultString(		Controller.H.GUI_7_ModeBtnGroup,				[10 5 100 40],		'Mode:'										);
	Controller.H.GUI_7_PlotBtn 							= defaultRadio(			Controller.H.GUI_7_ModeBtnGroup,				[125 5 125 40],		'Plot'										); Controller.H.GUI_7_PlotBtn.Enable = 'off';
	Controller.H.GUI_7_ExportBtn 						= defaultRadio(			Controller.H.GUI_7_ModeBtnGroup,				[250 5 125 40],		'Export'									); Controller.H.GUI_7_ModeBtnGroup.SelectedObject = Controller.H.GUI_7_ExportBtn;
	Controller.H.GUI_7_IndependentVarPanel 				= defaultPanel(			GUI_7_ControlPanel,								[15 360 400 50]													); Controller.H.GUI_7_IndependentVarPanel.Visible = 'off';
	IndependentVarString 								= defaultString(		Controller.H.GUI_7_IndependentVarPanel,			[10 5 300 40],		'Independent var.'							);
	Controller.H.GUI_7_IndependentVar 					= defaultPopupMenu(		Controller.H.GUI_7_IndependentVarPanel,			[200 7.5 200 35],	{'Power absorbed';'Starting pressure';'Gas supply'}); Controller.H.GUI_7_IndependentVar.Callback = @(Source,Event)Results_SelectIndependentVar(Controller);
	Controller.H.GUI_7_SelectTestPanel 					= defaultPanel(			GUI_7_ControlPanel,								[15 270 400 80]													); Controller.H.GUI_7_SelectTestPanel.Visible = 'off';
	Controller.H.GUI_7_DependentVar 					= defaultPopupMenu(		Controller.H.GUI_7_SelectTestPanel,				[10 37.5 220 35],	{'Starting pressure';'Gas supply'}); Controller.H.GUI_7_DependentVar.Callback = @(Source,Event)Results_SelectTest(Controller);
	Controller.H.GUI_7_SelectTest 						= defaultPopupMenu(		Controller.H.GUI_7_SelectTestPanel,				[230 37.5 160 35],	{'N/A'}										); Controller.H.GUI_7_SelectTest.Callback = @(Source,Event)Results_SaveTestIndex(Controller);
	Controller.H.GUI_7_HoldTest 						= defaultCheckbox(		Controller.H.GUI_7_SelectTestPanel,				[30 10 20 20],		false 										); Controller.H.GUI_7_HoldTest.Callback = @Controller.Results_Plot_HoldDependentVar; Controller.H.GUI_7_HoldTest.Enable = 'off';
	GUI_7_HoldTestString 								= defaultString(		Controller.H.GUI_7_SelectTestPanel,				[60 0 100 40],		'hold'										);
	Controller.H.GUI_7_ShowTest 						= defaultCheckbox(		Controller.H.GUI_7_SelectTestPanel,				[250 10 20 20],		true										); Controller.H.GUI_7_ShowTest.Enable = 'off'; Controller.H.GUI_7_ShowTest.Callback = @Controller.Results_Plot_UpdateShowDependentVar;
	GUI_7_ShowTestString								= defaultString(		Controller.H.GUI_7_SelectTestPanel,				[280 0 100 40],		'show'										);
	Controller.H.GUI_7_ShowPlotElementPanel 			= defaultPanel(			GUI_7_ControlPanel,								[15 210 400 50]													); Controller.H.GUI_7_ShowPlotElementPanel.Visible = 'off';
	Controller.H.GUI_7_ShowPlotElement 					= defaultPopupMenu(		Controller.H.GUI_7_ShowPlotElementPanel,		[10 7.5 220 35],	{'N/A'}										); Controller.H.GUI_7_ShowPlotElement.Callback = @Controller.Results_Plot_LookupShowPlotElement;
	Controller.H.GUI_7_ShowPlotElementCheckbox 			= defaultCheckbox(		Controller.H.GUI_7_ShowPlotElementPanel,		[250 15 20 20],		true										); Controller.H.GUI_7_ShowPlotElementCheckbox.Callback = @Controller.Results_Plot_UpdatePlotShowElement;
	ShowPlotElementString 								= defaultString(		Controller.H.GUI_7_ShowPlotElementPanel,		[280 5 100 40],		'show'										);
	Controller.H.GUI_7_IncludeFailedPanel 				= defaultPanel(			GUI_7_ControlPanel,								[15 150 400 50]													);
	Controller.H.GUI_7_IncludeFailed 					= defaultCheckbox(		Controller.H.GUI_7_IncludeFailedPanel,			[15 15 20 20],		false 										);
	IncludeFailedString 								= defaultString(		Controller.H.GUI_7_IncludeFailedPanel,			[50 5 400 40],		'Include failed evaluations'				);
	Controller.H.GUI_7_GasSupplyVarPanel 				= defaultPanel(			GUI_7_ControlPanel, 							[15 90 400 50]													); Controller.H.GUI_7_GasSupplyVarPanel.Visible = 'off';
	GasSupplyVaryString 								= defaultString(		Controller.H.GUI_7_GasSupplyVarPanel, 			[10 5 100 40],		'vary'										);
	Controller.H.GUI_7_GasSupplyVary 					= defaultPopupMenu(		Controller.H.GUI_7_GasSupplyVarPanel,			[60 7.5 147.5 35], 	{'Total flow'}								); Controller.H.GUI_7_GasSupplyVary.Callback = @(Source,Event)Results_GasSupplyVarMode(Controller);
	GasSupplyAtString 									= defaultString(		Controller.H.GUI_7_GasSupplyVarPanel, 			[215 5 100 40],		'at'										);
	Controller.H.GUI_7_GasSupplyAt 						= defaultPopupMenu(		Controller.H.GUI_7_GasSupplyVarPanel,			[250 7.5 147.5 35], {'N/A'}										); Controller.H.GUI_7_GasSupplyAt.Enable = 'off';
	Controller.H.GUI_7_SavePanel 						= defaultPanel(			GUI_7_ControlPanel,								[15 360 400 50]													);
	SaveString 											= defaultString(		Controller.H.GUI_7_SavePanel,					[10 5 100 40],		'Save'										);
	Controller.H.GUI_7_Save 							= defaultPopupMenu(		Controller.H.GUI_7_SavePanel,					[150 7.5 240 35],	{'Results','Integration points','Full evaluation data'}); Controller.H.GUI_7_Save.Callback = @Controller.Results_Export_Save;
	Controller.H.GUI_7_SaveToPanel 						= defaultPanel(			GUI_7_ControlPanel,								[15 300 400 50]													);
	SaveToString 										= defaultString(		Controller.H.GUI_7_SaveToPanel,					[10 5 100 40],		'Save to'									);
	Controller.H.GUI_7_SaveTo 							= defaultPopupMenu(		Controller.H.GUI_7_SaveToPanel,					[150 7.5 240 35],	{'MATLAB workspace','MATLAB data file (.mat)','Text file (.csv)'}); Controller.H.GUI_7_SaveTo.Callback = @Controller.Results_Export_SaveTo;
	Controller.H.GUI_7_FileLocationPanel 				= defaultPanel(			GUI_7_ControlPanel,								[15 210 400 80]													);
	LocationString 										= defaultString(		Controller.H.GUI_7_FileLocationPanel,			[10 35 100 40],		'Location'									);
	Controller.H.GUI_7_FileLocation 					= defaultEditString(	Controller.H.GUI_7_FileLocationPanel,			[150 37.5 240 35] 												);
	Controller.H.GUI_7_GetFileLocationButton 			= defaultPushbutton(	Controller.H.GUI_7_FileLocationPanel,			[340 5 50 30],		'...',										@Controller.Results_Export_FileLocation); Controller.H.GUI_7_FileLocation.Enable = 'off'; Controller.H.GUI_7_GetFileLocationButton.Enable = 'off';
	Controller.H.GUI_7_AnalyseButton 					= defaultPushbutton(	GUI_7_ControlPanel,								[30 10 375 70], 	'Export',									@Controller.Results_Analyse);
	Controller.H.GUI_7_PlotPanel 						= defaultPanel(			Controller.H.GUI_7_MainPanel, 					[435 0 725 500]													);
	%%Change pixel units to 'Normalized' so they are resizeable
	set( findall(MainWindow, '-property', 'Units' ), 'Units', 'Normalized' )
	set( findall(MainWindow, '-property', 'FontUnits' ), 'FontUnits', 'Normalized' )
%End elements
end
function defaultFigure = defaultFigure(Position,Name)
	defaultFigure = figure('Units','pixels',...
	                       'Name',Name,...
	                       'Position',Position,...
	                       'MenuBar','None',...
	                       'NumberTitle','Off',...
	                       'Resize','On',...
	                       'Visible','Off',...
	                       'WindowStyle','Normal');
end
function defaultTabgroup = defaultTabgroup(Parent,Position,SelectionChangedFcn)
	defaultTabgroup = uitabgroup('Units','pixels',...
	                             'Parent',Parent,...
	                             'Position',Position,...
	                             'SelectionChangedFcn',SelectionChangedFcn);
end
function defaultTab = defaultTab(Parent,Title,Tag)
	defaultTab = uitab('Units','pixels',...
	                   'Parent',Parent,...
	                   'Title',Title,...
	                   'Tag',Tag);
end
function defaultUIcontrol = defaultUIcontrol(Parent,Position,String,Callback)
	defaultUIcontrol = uicontrol('Units','pixels',...
	                             'String',String,...
	                             'Callback',Callback,...
	                             'Parent',Parent,...
	                             'Position',Position,...
	                             'FontName','Avenir Next',...
	                             'FontSize',24);
end
function defaultPushbutton = defaultPushbutton(Parent,Position,String,Callback)
	defaultPushbutton 		= defaultUIcontrol(Parent,Position,String,Callback);
	defaultPushbutton.Style = 'pushbutton';
end
function defaultMainPushbutton = defaultMainPushbutton(Parent,Position,String,Callback)
	defaultMainPushbutton 			= defaultPushbutton(Parent,Position,String,Callback);
	defaultMainPushbutton.FontSize 	= 28;
end
function defaultTitle = defaultTitle(Parent,String)
	defaultTitle 						= defaultUIcontrol(Parent,[30,570,1250,70],String,'');
	defaultTitle.HorizontalAlignment 	= 'left';
	defaultTitle.Style 					= 'text';
	defaultTitle.FontSize 				= 48;
end
function defaultString = defaultString(Parent,Position,String)
	defaultString 						= defaultUIcontrol(Parent,Position,String,'');
	defaultString.HorizontalAlignment 	= 'left';
	defaultString.Style 				= 'text';
end
function defaultEditString = defaultEditString(Parent,Position)
	defaultEditString 						= defaultUIcontrol(Parent,Position,'','');
	defaultEditString.HorizontalAlignment 	= 'center';
	defaultEditString.Style 				= 'edit';
end
function defaultText = defaultText(Parent,Position,String)
	defaultText 					= defaultString(Parent,Position,String);
	defaultText.FontSize 			= 20;
	defaultText.HorizontalAlignment = 'center';
end
function defaultPanel = defaultPanel(Parent,Position)
	defaultPanel = uipanel('Units','pixels','Parent',Parent,'Position',Position);
end
function defaultRadio = defaultRadio(Parent,Position,String)
	defaultRadio 		= defaultUIcontrol(Parent,Position,String,'');
	defaultRadio.Style 	= 'radiobutton';
end
function defaultButtonGroup = defaultButtonGroup(Parent,Position,SelectionChangedFcn)
	defaultButtonGroup = uibuttongroup('Units','pixels',...
	                                   'Parent',Parent,...
	                                   'Position',Position,...
	                                   'SelectionChangedFcn',SelectionChangedFcn);
end
function defaultListbox = defaultListbox(Parent,Position,SelectionChangedFcn)
	defaultListbox = uicontrol('Units',		'pixels',...
	                           'Parent',	Parent,...
	                           'Position',	Position,...
	                           'Callback',	SelectionChangedFcn,...
	                           'HorizontalAlignment','left',...
	                           'min',		0,...
	                           'max',		1,...
	                           'String',	blanks(0),...
	                           'Style',		'Listbox',...
	                           'Value',		1,...
	                           'FontName',	'Avenir Next',...
	                           'FontSize',	24);
end
function defaultPopupMenu = defaultPopupMenu(Parent,Position,String)
	defaultPopupMenu 			= defaultUIcontrol(Parent,Position,String,'');
	defaultPopupMenu.FontSize 	= 18;
	defaultPopupMenu.Style 		= 'popupmenu';
	defaultPopupMenu.Value 		= 1;
end
function defaultCheckbox = defaultCheckbox(Parent,Position,State)
	defaultCheckbox 		= defaultUIcontrol(Parent,Position,'','');
	defaultCheckbox.Style 	= 'checkbox';
	defaultCheckbox.Value 	= State;
end