%%Code for running a single variable scan

fprintf('Called Run_single_variable_scan.m\n\nSetting parameters for a single variable scan\n\n')
if ~exist('Single_variable_setup_marker')
	fprintf('Single_variable_setup_marker not in workspace\nLikely need to run Setup_single_variable_scan.m\n\n')
	SetupScan = input('Run setup (y/n)?','s');
	switch SetupScan
	case 'y'
		Single_variable_setup_marker = false;
		Setup_single_variable_scan;
		if ~Single_variable_setup_marker
			clear Single_variable_setup_marker
			return
		end
	case 'n'
		warning('continuing without initialisation')
	otherwise
		clear SetupScan
		fprintf('Not recognised - run GlobalModel to initialise, then rerun Run_single_variable_scan\n\n')
		return
	end
	clear SetupScan
end

ScanLength = length(Scan_values); %For some reason, ScanLength is being lost from the workspace.
%%Run Evaluation_CheckConvergence to find initial conditions for scan
fprintf('Running Evaluation_CheckConvergence to find initial conditions for the scan\nWarning: this may take a very long time if scan is significantly different to last run.\n')
fprintf('If evaluation diverges or takes too long, consider using the GUI in ''Control'' mode and stepping towards initial condition.\n\n')
%Make sure that you're looking at the start of the test
Controller.Solver.PowerAbsorbedIndex = 1; Controller.Solver.StartingPressureIndex = 1; Controller.Solver.GasSupplyIndex = 1;
%Run a convergence check to find initial conditions
% Evaluation_CheckConvergence(Controller);
%Set results of convergence check to initial conditions
%Transpose PreviousDensity into a column
PreviousDensity = Density+1;
PreviousTe = Te+1;

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

Save_filename = input('Save results of scan under what filename? ', 's');
save(Save_filename,'Controller','Species_I2E','Reaction_I2E','Density','DensityError','Te','TeError','Rate','Scan_parameter','Scan_values','Power','Pressure','H2Supply','N2Supply')

clear R_Density R_DensityError R_Te R_TeError R_Rate Species_I2E Reaction_I2E Save_filename

fprintf('Scan completed.\n\n To run another scan; run the following\n')
fprintf('clear Single_variable_setup_marker Scan_parameter Scan_values %%To force setup code to rerun\n')
fprintf('clear Power Pressure Composition Total_flow H2Supply N2Supply %%To clear fixed parameters\n')
fprintf('Run_single_variable_scan %%To rerun single variable scan code\n\n')