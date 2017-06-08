%%GlobalModel.m
%%This code will initialise the GUI ready to run an evaluation (scalar test) of a standard test

%%Clear terminal and close any hidden figures (to prevent stacking of GUI figures)
clc; close all hidden

fprintf('Called GlobalModel.m\n\nInitialising a GUI_control object saved in workspace as ''Controller''\nSetting standard scan conditions\n\n')
Controller = GUI_control;
% Controller.Show('on');
% Controller.Show('off');

%%EvaluationMode
Controller.H.GUI_1_EvaluationMode.SelectedObject.String = 'Scalar';
fprintf('Operating in %s mode\n\n',Controller.H.GUI_1_EvaluationMode.SelectedObject.String)
% Controller.H.GUI_1_EvaluationMode.SelectedObject.String = 'Vector';
% Controller.H.GUI_1_EvaluationMode.SelectedObject.String = 'Matrix';
EvaluateTab_OpenScreen(Controller);

%%Reactor
Controller.H.ReactorName.String = 'MAGPIE';
Controller.H.ReactorLength.String = '1';
Controller.H.ReactorRadius.String = '9.8e-2';
Controller.H.ReactorWallType.Value = 1;
fprintf('Setting reactor parameters\nName: %s\nLength: %s\nRadius: %s\nWall type: %s\n\n',...
        Controller.H.ReactorName.String, Controller.H.ReactorLength.String, Controller.H.ReactorRadius.String,...
        Controller.H.ReactorWallType.String{Controller.H.ReactorWallType.Value})

EvaluateTab_Reactor(Controller);

%%Reaction
Controller.H.ReactionCodeList.String = 'HJA*,THO*,CEL*,CAR*,KIM_[7-8],H2_*,H_*,N2_*,N_*,H2_Elastic';
fprintf('Setting reaction dataset\nCode list: %s\n\n', Controller.H.ReactionCodeList.String)
Reaction_DB_Query(Controller);
EvaluateTab_Reaction(Controller);
% Controller.ReactionDB

%%Species
fprintf('Auto-evaluating species dataset\n\n')
EvaluateTab_Species(Controller);
% Controller.SpeciesDB

%%Experiment
Controller.H.ExpReference.String = 'runtime';
Controller.H.ExpPowerAbsorbed.String = '500';
Controller.H.ExpStartingPressure.String = '10';
Controller.Experiment.GasSupply = containers.Map({'H2','N2'},{50,50});
Controller.H.GasSupplyListbox.String = {'H2','N2'};
Controller.H.GasSupplyListbox.Value = 1;
GasSupply_UpdatePanel(Controller);
fprintf('\nSetting experiment parameters\nReference: %s\nPower: %sW\nPressure: %smTorr\nGas supply: %d-%dsccm H2-N2\n\n',...
        Controller.H.ExpReference.String, Controller.H.ExpPowerAbsorbed.String, Controller.H.ExpStartingPressure.String,...
        Controller.Experiment.GasSupply('H2'),Controller.Experiment.GasSupply('N2'))
EvaluateTab_Experiment(Controller);

%%Evaluation
fprintf('Switching to evaluation mode\nSetting evaluation parameters\n\n')
Controller.TabGroup.SelectedTab = Controller.TabGroup.Children(6); %Tab to eval
Controller.H.RelTolerance.String = '1e-6';
Controller.H.MaxStep.String = '1';
Controller.Solver.MaxEvaluations = 20000;

fprintf('Adding RelTol, MaxStep, ConvergenceTolerance to user workspace\n\n')
Controller.Solver.PowerAbsorbedIndex 	= Controller.Global.ConvergenceCheck_PowerAbsorbedIndex;
Controller.Solver.StartingPressureIndex	= Controller.Global.ConvergenceCheck_StartingPressureIndex;
Controller.Solver.GasSupplyIndex 		= Controller.Global.ConvergenceCheck_GasSupplyIndex;
RelTol = 1e-6;
MaxStep = 1;
ConvergencePrecision = 1e-2;

fprintf('GUI ready to perform standard scan\nCan perform in command window with\n[T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,''Auto'',ConvergenceTolerance);\n\n')

ShowGUI = input('Show GUI window (y/n)?','s');
switch ShowGUI
	case 'y'
		Controller.Show('on');
	case 'n'
		Controller.Show('off');
	otherwise
		fprintf('Not recognised - use Controller.Show(''on'') to show GUI\n\n')
end
clear ShowGUI ans;
GUI_ready_marker = true;