% function Controller = GlobalModel
	Controller = GUI_control;
	% Controller.Show('on');
	% Controller.Show('off');

	%%EvaluationMode
	Controller.H.GUI_1_EvaluationMode.SelectedObject.String = 'Scalar';
	disp('Operating in scalar mode')
	fprintf('\n')
	% Controller.H.GUI_1_EvaluationMode.SelectedObject.String = 'Vector';
	% Controller.H.GUI_1_EvaluationMode.SelectedObject.String = 'Matrix';
	EvaluateTab_OpenScreen(Controller);

	%%Reactor
	Controller.H.ReactorName.String = 'MAGPIE';
	Controller.H.ReactorLength.String = '1';
	Controller.H.ReactorRadius.String = '9.8e-2';
	Controller.H.ReactorWallType.Value = 1;
	disp('Setting Reactor')
	disp('Name: MAGPIE')
	disp('Length: 1m')
	disp('Radius: 9.8e-2')
	disp('Wall type: Pyrex')
	fprintf('\n')
	EvaluateTab_Reactor(Controller);

	%%Reaction
	Controller.H.ReactionCodeList.String = 'HJA*,THO*,CEL*,CAR*,KIM_[7-8],H2_*,H_*,N2_*,N_*,H2_Elastic';
	disp('Setting Reaction')
	disp('Code list: HJA*,THO*,CEL*,CAR*,KIM_[7-8],H2_*,H_*,N2_*,N_*,H2_Elastic')
	fprintf('\n')
	Reaction_DB_Query(Controller);
	EvaluateTab_Reaction(Controller);
	% Controller.ReactionDB

	%%Species
	disp('Auto-evaluating Species')
	fprintf('\n')
	EvaluateTab_Species(Controller);
	% Controller.SpeciesDB

	%%Experiment
	disp('Setting Experiment')
	disp('Reference: runtime')
	disp('Power: 500W')
	disp('Pressure: 10mTorr')
	disp('Gas supply: 50-50sccm H2-N2')
	fprintf('\n')
	Controller.H.ExpReference.String = 'runtime';
	Controller.H.ExpPowerAbsorbed.String = '500';
	Controller.H.ExpStartingPressure.String = '10';
	Controller.Experiment.GasSupply = containers.Map({'H2','N2'},{50,50});
	EvaluateTab_Experiment(Controller);

	%%Evaluation
	disp('Switching to evaluation mode')
	Controller.TabGroup.SelectedTab = Controller.TabGroup.Children(6); %Tab to eval
	Controller.H.RelTolerance.String = '1e-6';
	Controller.H.MaxStep.String = '1';
	Controller.Solver.MaxEvaluations = 20000;
	fprintf('\n')

	Controller.Solver.PowerAbsorbedIndex 	= Controller.Global.ConvergenceCheck_PowerAbsorbedIndex;
	Controller.Solver.StartingPressureIndex	= Controller.Global.ConvergenceCheck_StartingPressureIndex;
	Controller.Solver.GasSupplyIndex 		= Controller.Global.ConvergenceCheck_GasSupplyIndex;
	RelTol = 1e-6;
	MaxStep = 1;
	ConvergenceTolerance = 1e-2;

	% [T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,'Auto',ConvergenceTolerance);
	% [R_Times,R_ConcTe,FinalRate,ErrorMonitor,Converged] = SolveBalanceEquations(Controller,1e-6,1,'Auto',10);

% end