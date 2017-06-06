classdef GUI_control<handle
	properties
		Global
		H %Graphics handles
		GUI
		TabGroup
		Reactor
		Experiment
		ReactionDB
		Reaction_I2E
		SpeciesDB
		Species_I2E
		CrosssectionDB
		Solver
		Results
	end
	methods
		function Controller = GUI_control
			Controller.Reactor 						= REACTOR_C;
			Controller.Experiment 					= EXPERIMENT_C;
			Controller.ReactionDB 					= DATABASE_C;
			Controller.SpeciesDB 					= DATABASE_C;
			try load('CrosssectionDB','CrosssectionDB')
				Controller.CrosssectionDB  			= CrosssectionDB;
			catch ME
				warning(sprintf('%s Click ''Launch crosssection builder'' to build CrosssectionDB.',ME.message));
			end
			Controller.Global = struct('ReactionsUpdated',false,'SpeciesUpdated',false,'ExperimentUpdated',false,'EvaluationMode','Scalar','SystemUpdated',false,'ReactionFoundList',[],'ReactionsNotFoundList',[],'SpeciesFoundList',[],'SpeciesNotFoundList',[],'Results_Plot_PowerAbsorbedIndex',1,'Results_Plot_StartingPressureIndex',1,'Results_Plot_GasSupplyIndex',1,'ConvergenceCheck_PowerAbsorbedIndex',1,'ConvergenceCheck_StartingPressureIndex',1,'ConvergenceCheck_GasSupplyIndex',1,'ShowPlotElement',[]);
			%Controller.Global.ReactionsUpdated 		= false;
			%Controller.Global.SpeciesUpdated 		= false;
			Controller.Solver = struct('MaxEvaluations',[],'EvaluationCancel',false,'EvaluationStartTime',[],'PowerAbsorbedIndex',[],'StartingPressureIndex',[],'GasSupplyIndex',[],'ConvergenceCheck_T',[],'ConvergenceCheck_Y',[],'ConvergenceCheck_M',[]);
			Controller.Results = struct('PowerAbsorbed',[],'StartingPressure',[],'GasSupply',[],'T',[],'Y',[],'R',[],'M',[],'Converged',[]);
			[Controller.GUI,Controller.TabGroup] 	= GUI_Make(Controller);
		end
		function Controller(Controller)
			%The GUI_control Controllerect is initially made invisible - to minimise flashing
			Controller.GUI.Visible = 'On';
		end
		function Show(Controller,ShowStatus)
			%The GUI_control Controllerect is initially made invisible - to minimise flashing
			Controller.GUI.Visible = ShowStatus;
		end
		function TabSelectionChanged(Controller,Source,Event)
			OldTab = Event.OldValue;
			NewTab = Event.NewValue;
			if ~ Controller.Evaluate_Tab(OldTab)
				Source.SelectedTab = OldTab; %If Evaluate_Tab returns ProceedAllowed = false, prevent the change of tab.
			end %Else - do nothing and allow the change. Evaluate_Tab has already run.
		end
		function NextButton(Controller,Source,Event)
			OldTab = Controller.TabGroup.SelectedTab;
			if ~ Controller.Evaluate_Tab(OldTab)
				Controller.TabGroup.SelectedTab = OldTab;
			else
				NewTag = str2num(OldTab.Tag) + 1;
				if NewTag <= length(Controller.TabGroup.Children) %Prevent indexing past the last element in the list
					Controller.TabGroup.SelectedTab = Controller.TabGroup.Children(NewTag);
				else
					delete(Controller.GUI); %If it is the last element in the list - use 'Next' as 'Finish' (should change button string in EvaluateTab_Evaluation)
				end
			end
		end
		function ProceedAllowed = Evaluate_Tab(Controller,OldTab)
			switch OldTab.Title
			case 'Open Screen'
				ProceedAllowed = EvaluateTab_OpenScreen(Controller);
			case 'Reactor'
				ProceedAllowed = EvaluateTab_Reactor(Controller);
			case 'Experiment'
				ProceedAllowed = EvaluateTab_Experiment(Controller);
			case 'Reaction'
				ProceedAllowed = EvaluateTab_Reaction(Controller);
			case 'Species'
				ProceedAllowed = EvaluateTab_Species(Controller);
			case 'Evaluation'
				ProceedAllowed = EvaluateTab_Evaluation(Controller);
			case 'Results'
				ProceedAllowed = EvaluateTab_Results(Controller);
			otherwise
				ProceedAllowed = false;
				error(sprintf('Tab ''%s'' not recognised',OldTab.Title));
			end
		end
		function BackButton(Controller,Source,Event)
			OldTab = Controller.TabGroup.SelectedTab;
			NewTag = str2num(OldTab.Tag) - 1;
			if NewTag > 0
				Controller.TabGroup.SelectedTab = Controller.TabGroup.Children(NewTag);
			end
		end
		function CancelButton(Controller,Source,Event)
			%Deletes the GUI Controllerect only. Use close all to delete all figures.
			delete(Controller.GUI)
		end
		function Global_EvaluationMode(Controller,Source,Event)
			OldMode 	= Event.OldValue.String;
			NewMode 	= Event.NewValue.String;
			ReturnMode 	= Global_CheckMode(NewMode,Controller.Experiment);
			Global_UpdateMode(Controller,ReturnMode);
		end
		function Init_CheckDB(Controller,Source,Event)
			[CheckPassed,ReturnString] = Init_CheckDB_MAIN;
			if CheckPassed
				Source.BackgroundColor = [0.6,1,0.6];
			else
				Source.BackgroundColor = [1,0.6,0.6];
			end
			Source.String = ReturnString;
		end
		function LaunchXCBuilder(Controller,Source,Event)
			XCBuilder = CrosssectionBuilder; XCBuilder.XCController;
			uiwait(XCBuilder.Controller)
			try
				load('CrosssectionDB','CrosssectionDB')
				Controller.CrosssectionDB = CrosssectionDB;
				Source.BackgroundColor = [0.6,1,0.6];
			catch ME
				disp(sprintf('Error in CrosssectionBuilder: %s',ME.message));
				Source.BackgroundColor = [1,0.6,0.6];
			end
			Controller.Global.SystemUpdated = true;
		end
		function Evaluation_Mode_Callback(Controller,Source,Event)
			Mode = Controller.H.GUI_6_ModeBtnGroup.SelectedObject.String;
			Evaluation_UpdateMode(Controller,Mode);
		end
		function Evaluation_Monitor_Callback(Controller,Source,Event)
			Mode = Controller.H.GUI_6_ConvergenceCheckBtnGroup.SelectedObject.String;
			switch Mode
			case 'Auto'
				Controller.H.GUI_6_ConvergenceParameterString.String 	= 'Convergence tol.';
				Controller.H.GUI_6_ConvergenceParameter.String 		= blanks(0);
			case 'Manual'
				Controller.H.GUI_6_ConvergenceParameterString.String 	= 'Evaluation time';
				Controller.H.GUI_6_ConvergenceParameter.String 		= blanks(0);
			end
		end
		function Evaluation_Evaluate(Controller,Source,Event)
			Mode = Controller.H.GUI_6_ModeBtnGroup.SelectedObject.String;
			Controller.Solver.MaxEvaluations = str2num(Controller.H.MaxEvaluations.String);
			switch Controller.H.GUI_6_EvaluateODE.String
			case 'Cancel'
				Controller.Solver.EvaluationCancel = true;
				disp('Evaluation cancelled')
				switch Mode
				case 'Control'
					Controller.H.GUI_6_EvaluateODE.String = 'Check convergence';
				case 'Monitor'
					Controller.H.GUI_6_EvaluateODE.String = 'Evaluate ODEs';
				end
			otherwise
				Controller.Solver.EvaluationCancel = false;
				switch Mode
				case 'Control'
					Controller.H.GUI_6_EvaluateODE.String = 'Cancel';
					Evaluation_CheckConvergence(Controller);
					Controller.H.GUI_6_EvaluateODE.String = 'Check convergence';
				case 'Monitor'
					Controller.H.GUI_6_EvaluateODE.String = 'Cancel';
					PowerAbsorbedLength 							= length(Controller.Experiment.PowerAbsorbed);
					StartingPressureLength 							= length(Controller.Experiment.StartingPressure);
					GasSupplyLength 								= unique(cellfun(@length,Controller.Experiment.GasSupply.values));
					switch Controller.Global.EvaluationMode
					case 'Vector'
						Controller.H.GUI_6_CalculationsToPeform.String	= max([PowerAbsorbedLength,StartingPressureLength,GasSupplyLength]);
					case 'Matrix'
						Controller.H.GUI_6_CalculationsToPeform.String	= PowerAbsorbedLength*StartingPressureLength*GasSupplyLength;
					end
					Controller.H.GUI_6_CalculationsCompleted.String		= 0;
					Controller.H.GUI_6_AverageTimePerCalc.String		= 0;
					Controller.H.GUI_6_ProgressBar.Position(3) 			= 0;
					Controller.H.GUI_6_EstimatedTimeOfCompletion.String	= 0;
					pause(1e-3)
					Evaluation_MonitorMultiple(Controller);
					Controller.H.GUI_6_EvaluateODE.String = 'Evaluate ODEs';
				end
			end
		end
		function Evaluation_AxesChange_Callback(Controller,Source,Event)
			if ~isempty(Controller.Solver.ConvergenceCheck_T) || isempty(Controller.Solver.ConvergenceCheck_Y) || isempty(Controller.Solver.ConvergenceCheck_M);
				Evaluation_PlotSolution(Controller.Solver.ConvergenceCheck_T,Controller.Solver.ConvergenceCheck_Y,Controller.Solver.ConvergenceCheck_M,Controller)
			end
		end
		function Results_Mode_Callback(Controller,Source,Event)
			Mode = Controller.H.GUI_7_ModeBtnGroup.SelectedObject.String;
			Results_UpdateMode(Controller,Mode);
		end
		function Results_Export_Save(Controller,Source,Event)
			switch Controller.H.GUI_7_Save.String{Controller.H.GUI_7_Save.Value}
			case 'Results'
				Controller.H.GUI_7_SaveTo.String 				= {'MATLAB workspace','MATLAB data file (.mat)','Text file (.csv)'};
				Controller.H.GUI_7_SaveTo.Value  				= 1;
			case 'Integration points'
				Controller.H.GUI_7_SaveTo.String 				= {'MATLAB workspace','MATLAB data file (.mat)'};
				Controller.H.GUI_7_SaveTo.Value  				= 1;
				Controller.H.GUI_7_FileLocation.String 			= blanks(0);
				Controller.H.GUI_7_FileLocation.Enable 			= 'off';
				Controller.H.GUI_7_GetFileLocationButton.Enable	= 'off';
			case 'Full evaluation data'
				Controller.H.GUI_7_SaveTo.String 				= {'MATLAB workspace','MATLAB data file (.mat)'};
				Controller.H.GUI_7_SaveTo.Value  				= 1;
				Controller.H.GUI_7_FileLocation.String 			= blanks(0);
				Controller.H.GUI_7_FileLocation.Enable 			= 'off';
				Controller.H.GUI_7_GetFileLocationButton.Enable	= 'off';
			case 'Figure'
				Controller.H.GUI_7_SaveTo.String 				= {'MATLAB workspace','MATLAB figure file (.fig)','PDF file (.pdf)','PNG file (.png)'};
				Controller.H.GUI_7_SaveTo.Value  				= 1;
				Controller.H.GUI_7_FileLocation.String 			= blanks(0);
				Controller.H.GUI_7_FileLocation.Enable 			= 'off';
				Controller.H.GUI_7_GetFileLocationButton.Enable	= 'off';
			end
		end
		function Results_Export_SaveTo(Controller,Source,Event)
			FileFormat 		= Controller.H.GUI_7_SaveTo.String{Controller.H.GUI_7_SaveTo.Value};
			switch FileFormat
			case 'MATLAB workspace'
				Controller.H.GUI_7_FileLocation.String 			= blanks(0);
				Controller.H.GUI_7_FileLocation.Enable 			= 'off';
				Controller.H.GUI_7_GetFileLocationButton.Enable	= 'off';
			otherwise
				Controller.H.GUI_7_FileLocation.String 			= blanks(0);
				Controller.H.GUI_7_FileLocation.Enable 			= 'on';
				Controller.H.GUI_7_GetFileLocationButton.Enable	= 'on';
			end
		end
		function Results_Export_FileLocation(Controller,Source,Event)
			try
				ExportFolder	= Controller.Global.ExportFolder;
			catch
				ExportFolder	= cd;
			end
			FileFormat 			= Controller.H.GUI_7_SaveTo.String{Controller.H.GUI_7_SaveTo.Value};
			switch FileFormat
			case 'Text file (.csv)'
				[FileName,Path] = uiputfile(sprintf('%s/*.csv',ExportFolder));
			case 'MATLAB data file (.mat)'
				[FileName,Path] = uiputfile(sprintf('%s/*.mat',ExportFolder));
			case 'MATLAB figure file (.fig)'
				[FileName,Path] = uiputfile(sprintf('%s/*.fig',ExportFolder));
			case 'PDF file (.pdf)'
				[FileName,Path] = uiputfile(sprintf('%s/*.pdf',ExportFolder));
			case 'PNG file (.png)'
				[FileName,Path] = uiputfile(sprintf('%s/*.png',ExportFolder));
			otherwise
				error('File format not recognised')
			end
			Controller.H.GUI_7_FileLocation.String = FileName;
			if FileName
				Controller.Global.ExportFolder	= Path;
			end
		end
		function Results_Analyse(Controller,Source,Event)
			Mode = Controller.H.GUI_7_ModeBtnGroup.SelectedObject.String;
			switch Mode
			case 'Plot'
				Results_Plot(Controller,'GUI');
				Controller.H.GUI_7_Save.String = {'Results','Integration points','Full evaluation data','Figure'};
			case 'Export'
				Results_Export(Controller);
			end
		end
		function Results_Plot_HoldDependentVar(Controller,Source,Event)
			if Controller.H.GUI_7_HoldTest.Value
				Controller.H.GUI_7_ShowTest.Enable = 'on';
			else
				Controller.H.GUI_7_ShowTest.Enable = 'off';
				Controller.H.GUI_7_ShowTest.Value 	= true;
			end
		end
		function Results_Plot_LookupShowDependentVar(Controller,Source,Event)
			%disp('Results_Plot_LookupShowDependentVar called')
		end
		function Results_Plot_UpdateShowDependentVar(Controller,Source,Event)
			%disp('Results_Plot_UpdateShowDependentVar called')
		end
		function Results_Plot_LookupShowPlotElement(Controller,Source,Event)
			%disp('Results_Plot_LookupShowPlotElement called')
			try
				Controller.H.GUI_7_ShowPlotElementCheckbox.Value = Controller.Global.ShowPlotElement(Controller.H.GUI_7_ShowPlotElement.Value);
			catch
				Controller.Global.ShowPlotElement = ones(1,length(Controller.H.GUI_7_ShowPlotElement.String));
				Controller.H.GUI_7_ShowPlotElementCheckbox.Value = Controller.Global.ShowPlotElement(Controller.H.GUI_7_ShowPlotElement.Value);
			end
		end
		function Results_Plot_UpdatePlotShowElement(Controller,Source,Event)
			%disp('Results_Plot_UpdateShowPlotElement called')
			try
				Controller.Global.ShowPlotElement(Controller.H.GUI_7_ShowPlotElement.Value) = Controller.H.GUI_7_ShowPlotElementCheckbox.Value;
			catch
				Controller.Global.ShowPlotElement = ones(1,length(Controller.H.GUI_7_ShowPlotElement.String));
				Controller.Global.ShowPlotElement(Controller.H.GUI_7_ShowPlotElement.Value) = Controller.H.GUI_7_ShowPlotElementCheckbox.Value;
			end
		end
	end %End methods
end %End classdef