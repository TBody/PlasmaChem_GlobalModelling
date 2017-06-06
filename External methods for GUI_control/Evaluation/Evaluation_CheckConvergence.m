function Evaluation_CheckConvergence(Controller)
	%disp(sprintf('Checking convergence at %dW, %dmTorr with a gas supply of %s',Controller.Experiment.PowerAbsorbed(Controller.Global.ConvergenceCheck_PowerAbsorbedIndex),1e3*Controller.Experiment.StartingPressure(Controller.Global.ConvergenceCheck_StartingPressureIndex),Display_dict(Controller.Experiment.GasSupply)))
	Controller.Solver.EvaluationStartTime 	= now;
	Controller.H.GUI_6_TimerString.String 	= {'Initialising';'0/2'}; pause(1e-3)
	Controller.Solver.PowerAbsorbedIndex 	= Controller.Global.ConvergenceCheck_PowerAbsorbedIndex;
	Controller.Solver.StartingPressureIndex	= Controller.Global.ConvergenceCheck_StartingPressureIndex;
	Controller.Solver.GasSupplyIndex 		= Controller.Global.ConvergenceCheck_GasSupplyIndex;
	StartTime = now;
	RelTol = str2num(Controller.H.RelTolerance.String);
	MaxStep = str2num(Controller.H.MaxStep.String);
	ConvergenceMonitorMode = Controller.H.GUI_6_ConvergenceCheckBtnGroup.SelectedObject.String;
	switch ConvergenceMonitorMode
	case 'Auto'
		ConvergenceTolerance = str2num(Controller.H.GUI_6_ConvergenceParameter.String);
		[T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,'Auto',ConvergenceTolerance);
	case 'Manual'
		EvaluationTime = str2num(Controller.H.GUI_6_ConvergenceParameter.String);
		[T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,'Manual',EvaluationTime);
	end
	Controller.H.GUI_6_TimerString.String = {'Evaluated in';datestr(now-StartTime,'MM:SS.FFF')};
	Controller.Solver.ConvergenceCheck_T = T; Controller.Solver.ConvergenceCheck_Y = Y; Controller.Solver.ConvergenceCheck_M = M;
	Evaluation_PlotSolution(T,Y,M,Controller);
	switch Controller.Global.EvaluationMode
	case 'Scalar'
		disp('Saving results to Controller.Results');
		Results 					= struct; %Reset results;
		Results.PowerAbsorbed 		= Controller.Experiment.PowerAbsorbed(Controller.Solver.PowerAbsorbedIndex);
		Results.StartingPressure 	= Controller.Experiment.StartingPressure(Controller.Solver.StartingPressureIndex);
		Results.GasSupply 			= GasSupplyIndexing(Controller.Experiment.GasSupply,Controller.Solver.GasSupplyIndex);
		Results.T					= T;
		Results.Y					= Y;
		Results.R 					= R;
		Results.E 					= E;
		Results.M					= M;
		Results.Converged			= Converged;
		Controller.Results 			= Results;
		save(sprintf('Results/%s',matlab.lang.makeValidName(strrep(char(datetime),' ','_time_'),'Prefix','date_')),'Results')
	otherwise
		%Don't save/overwrite results
	end
	if ~Controller.Solver.EvaluationCancel
		if Converged == 1
			disp('Updating Species concentrations')
			UpdateSpeciesConcentrations_ConvergenceCheck(Controller);
		end
	end
	%Controller.Global.SystemUpdated = true;
	disp(' - done')
	Controller.H.GUI_6_TimerString.String = {'Evaluated in';datestr(now-Controller.Solver.EvaluationStartTime,'MM:SS.FFF')}; pause(1e-3)
	beep
end
function IndexDictionary = GasSupplyIndexing(GasSupplyDictionary,GasSupplyIndex)
   	IndexDictionary = containers.Map;
   	for Key = GasSupplyDictionary.keys
   		GasSupply = GasSupplyDictionary(Key{:});
   		IndexDictionary(Key{:}) = GasSupply(GasSupplyIndex);
   	end
end
function UpdateSpeciesConcentrations_ConvergenceCheck(Controller)
	for index = 1:length(Controller.Species_I2E)
		SpeciesKey = Controller.Species_I2E.Key(index);
		Controller.SpeciesDB.Key(SpeciesKey).n = Controller.Solver.ConvergenceCheck_Y(end,index);
	end
	ReEvaluate_SpeciesMFP(Controller)
end
function ReEvaluate_SpeciesMFP(Controller)
	for SpeciesKey  = Controller.SpeciesDB.KeyList
		if ~strcmp(SpeciesKey{:},'e') || ~strcmp(SpeciesKey{:},'F_s')
			Species     = Controller.SpeciesDB.Key(SpeciesKey);
			InverseScatteringSum = 0;
			for Species2Key  = Controller.SpeciesDB.KeyList
				if ~strcmp(Species2Key{:},'e') || ~strcmp(SpeciesKey{:},'F_s')
					Species2     = Controller.SpeciesDB.Key(Species2Key);
					InverseScatteringSum = InverseScatteringSum + Species2.n*pi*(Species.vdW_Area+Species2.vdW_Area+2*sqrt(Species.vdW_Area*Species2.vdW_Area));
				end
			end
			Species.MFP = InverseScatteringSum.^-1;
		end
	end
end