%%Code for running a single variable scan

Global_UpdateMode(Controller,'Matrix');
Controller.H.ExpPowerAbsorbed.String = num2str(Power);
Controller.H.ExpStartingPressure.String = num2str(Pressure);
Controller.Experiment.GasSupply = containers.Map({'H2','N2'},{H2Supply,N2Supply});

Controller.Solver.PowerAbsorbedIndex = 1;
Controller.Solver.StartingPressureIndex = 1;
Controller.Solver.GasSupplyIndex = 1;

GasSupply_UpdatePanel(Controller);
EvaluateTab_Experiment(Controller);
Single_variable_setup_marker = true;
fprintf('System ready to run evaluation\n\n')
clear ans

ScanLength = length(Scan_values); %For some reason, ScanLength is being lost from the workspace.
%%Run Evaluation_CheckConvergence to find initial conditions for scan
fprintf('Running Evaluation_CheckConvergence to find initial conditions for the scan\nWarning: this may take a very long time if scan is significantly different to last run.\n')
fprintf('If evaluation diverges or takes too long, consider using the GUI in ''Control'' mode and stepping towards initial condition.\n\n')
%Make sure that you're looking at the start of the test
Controller.Solver.PowerAbsorbedIndex = 1; Controller.Solver.StartingPressureIndex = 1; Controller.Solver.GasSupplyIndex = 1;
%Run a convergence check to find initial conditions
Evaluation_CheckConvergence(Controller);
%Set results of convergence check to initial conditions
%Transpose PreviousDensity into a column
PreviousDensity = Controller.Solver.ConvergenceCheck_Y(end,1:end-1)';
PreviousTe = Controller.Solver.ConvergenceCheck_Y(end,end);

%Iterate through tests
R_Density = [];
R_DensityError = [];
R_Te = [];
R_TeError = [];
R_Rate = [];

tic
for iter = 1:ScanLength
	fprintf('Running test %d of %d\n',iter,ScanLength)
	switch Scan_parameter
	case 'Power'
		Controller.Solver.PowerAbsorbedIndex = iter;
	case 'Pressure'
		Controller.Solver.StartingPressureIndex = iter;
	otherwise
		Controller.Solver.GasSupplyIndex = iter;
	end
	[FinalDensity,DensityError,FinalTe,TeError,FinalRate,Converged] =...
	SolveBalanceEquations_v2(Controller,...
	RelTol,MaxStep,ConvergencePrecision,PreviousDensity,PreviousTe);
	toc
	PreviousDensity = FinalDensity;
	PreviousTe = FinalTe;

	%Store the results
	R_Density = [R_Density,FinalDensity];
	R_DensityError = [R_DensityError,DensityError];
	R_Te = [R_Te,FinalTe];
	R_TeError = [R_TeError,TeError];
	R_Rate = [R_Rate,FinalRate];
end
clear iter

Density = R_Density;
DensityError = R_DensityError;
Te = R_Te;
TeError = R_TeError;
Rate = R_Rate;
Species_I2E = Controller.Species_I2E.list;
Reaction_I2E = Controller.Reaction_I2E.list;

save(Save_filename,'Controller','Species_I2E','Reaction_I2E','Density','DensityError','Te','TeError','Rate','Scan_parameter','Scan_values','Power','Pressure','H2Supply','N2Supply')

clear R_Density R_DensityError R_Te R_TeError R_Rate Species_I2E Reaction_I2E Save_filename