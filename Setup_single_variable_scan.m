%%Code for setting up a single variable scan
%%Messy - but handles most of the behind-the-scenes as a script to ensure that the workspace is transparent
%%Check that the Controller object has been initialised correctly (i.e. with the GlobalModel script)
fprintf('Called Setup_single_variable_scan.m\nSetting parameters for a single variable scan\n')
if ~exist('GUI_ready_marker')
	fprintf('GUI_ready_marker not in workspace\nLikely need to initialise Controller\n\n')
	InitGUI = input('Initialise Controller (y/n)?','s');
	switch InitGUI
	case 'y'
		GUI_ready_marker = false;
		GlobalModel;
		if ~GUI_ready_marker
			clear GUI_ready_marker
			return
		end
	case 'n'
		warning('continuing without initialisation')
	otherwise
		clear InitGUI
		fprintf('Not recognised - run GlobalModel to initialise, then rerun Run_single_variable_scan\n\n')
		return
	end
	clear InitGUI
end

if ~exist('Scan_parameter')
	fprintf('Select variable to scan\n(1) -> Power\n(2) -> Pressure\n(3) -> Composition\n(4) -> Total flow\n')
	SelectVariable = input('Which test (#): ','s');
	switch SelectVariable
	case '1'
		Scan_parameter = 'Power';
		Power = NaN;
		if ~exist('Pressure')
			Pressure = input('Set constant pressure (mTorr): ');
		elseif isnan(Pressure)
			Pressure = input('Set constant pressure (mTorr): ');
		else
			fprintf('Pressure = %g mTorr\n',Pressure)
		end
		if ~exist('Composition')
			Composition = input('Set constant composition (0 < prop.H2 < 1): ');
		elseif isnan(Composition)
			Composition = input('Set constant composition (0 < prop.H2 < 1): ');
		else
			fprintf('Composition = %g H2\n',Composition)
		end
		if ~exist('Total_flow')
			Total_flow = input('Set constant total flow (sccm): ');
		elseif isnan(Total_flow)
			Total_flow = input('Set constant total flow (sccm): ');
		else
			fprintf('Total_flow = %g sccm\n',Total_flow)
		end
	case '2'
		Scan_parameter = 'Pressure';
		Pressure = NaN;
		if ~exist('Power')
			Power = input('Set constant power (W): ');
		elseif isnan(Power)
			Power = input('Set constant power (W): ');
		else
			fprintf('Power = %g W\n',Power)
		end
		if ~exist('Composition')
			Composition = input('Set constant composition (0 < prop.H2 < 1): ');
		elseif isnan(Composition)
			Composition = input('Set constant composition (0 < prop.H2 < 1): ');
		else
			fprintf('Composition = %g H2\n',Composition)
		end
		if ~exist('Total_flow')
			Total_flow = input('Set constant total flow (sccm): ');
		elseif isnan(Total_flow)
			Total_flow = input('Set constant total flow (sccm): ');
		else
			fprintf('Total_flow = %g sccm\n',Total_flow)
		end
	case '3'
		Scan_parameter = 'Composition';
		Composition = NaN;
		if ~exist('Power')
			Power = input('Set constant power (W): ');
		elseif isnan(Power)
			Power = input('Set constant power (W): ');
		else
			fprintf('Power = %g W\n',Power)
		end
		if ~exist('Pressure')
			Pressure = input('Set constant pressure (mTorr): ');
		elseif isnan(Pressure)
			Pressure = input('Set constant pressure (mTorr): ');
		else
			fprintf('Pressure = %g mTorr\n',Pressure)
		end
		if ~exist('Total_flow')
			Total_flow = input('Set constant total flow (sccm): ');
		elseif isnan(Total_flow)
			Total_flow = input('Set constant total flow (sccm): ');
		else
			fprintf('Total_flow = %g sccm\n',Total_flow)
		end
	case '4'
		Scan_parameter = 'Total_flow';
		Total_flow = NaN;
		if ~exist('Power')
			Power = input('Set constant power (W): ');
		elseif isnan(Power)
			Power = input('Set constant power (W): ');
		else
			fprintf('Power = %g W\n',Power)
		end
		if ~exist('Pressure')
			Pressure = input('Set constant pressure (mTorr): ');
		elseif isnan(Pressure)
			Pressure = input('Set constant pressure (mTorr): ');
		else
			fprintf('Pressure = %g mTorr\n',Pressure)
		end
		if ~exist('Composition')
			Composition = input('Set constant composition (0 < prop.H2 < 1): ');
		elseif isnan(Composition)
			Composition = input('Set constant composition (0 < prop.H2 < 1): ');
		else
			fprintf('Composition = %g H2\n',Composition)
		end
	otherwise
		fprintf('Not recognised. ')
	end
	clear SelectVariable
end

fprintf('\nConstant values for scan set\n\n')
fprintf('Scan_parameter: ''%s''\n',Scan_parameter)
if length(Power) > 1 || length(Pressure) > 1 || length(Composition) > 1 || length(Total_flow) > 1
	error('Can only scan one parameter at a time (look for parameter which has printed multiple times above, clear this)')
end
% fprintf('Power = %gW \n',Power)
% fprintf('Pressure = %g mTorr\n',Pressure)
% fprintf('Composition = %g H2\n',Composition)
% fprintf('Total_flow = %g sccm\n',Total_flow)
% fprintf('To scan another variable, clear Scan_parameter and rerun\n\n')

if ~exist('Scan_values')
	fprintf('Scan_values unititialised\nSet Scan_values in command window then rerun script\n\n')
	return
else
	fprintf('Using Scan_values; \n')
	ScanLength = length(Scan_values);
	for iter = 1:ScanLength
		fprintf('%d -> %g \n',iter, Scan_values(iter));
	end
	clear iter
	fprintf('\n')
	Use_prev_scan_values = input('Use these values (y/n)?','s');
	switch Use_prev_scan_values
	case 'y'
		%Do nothing, continue
	otherwise
		clear ScanLength
		clear Scan_values
		clear Use_prev_scan_values
		fprintf('Scan_values cleared\nSet Scan_values in command window then rerun script\n\n')
		return
	end
	clear Use_prev_scan_values
end

switch Scan_parameter
case 'Power'
	Power = Scan_values;
	H2Supply = Total_flow.*Composition;
	N2Supply = Total_flow.*(1-Composition);
case 'Pressure'
	Pressure = Scan_values;
	H2Supply = Total_flow.*Composition;
	N2Supply = Total_flow.*(1-Composition);
case 'Composition'
	H2Supply = Total_flow.*Scan_values;
	N2Supply = Total_flow.*(1-Scan_values);
case 'Total_flow'
	H2Supply = Scan_values.*Composition;
	N2Supply = Scan_values.*(1-Composition);
otherwise
	error('Oops - something went wrong')
end
Global_UpdateMode(Controller,'Matrix');
Controller.H.ExpPowerAbsorbed.String = num2str(Power);
Controller.H.ExpStartingPressure.String = num2str(Pressure);
Controller.Experiment.GasSupply = containers.Map({'H2','N2'},{H2Supply,N2Supply});

Controller.Solver.PowerAbsorbedIndex = 1;
Controller.Solver.StartingPressureIndex = 1;
Controller.Solver.GasSupplyIndex = 1;

GasSupply_UpdatePanel(Controller);
EvaluateTab_Experiment(Controller);
fprintf('Setting these values to GUI (improves compatibility with previous code)\nNote that scanned parameter may print oddly, but seems functional\n\n')
Single_variable_setup_marker = true;
fprintf('System ready to run evaluation\n\n')
clear ans 