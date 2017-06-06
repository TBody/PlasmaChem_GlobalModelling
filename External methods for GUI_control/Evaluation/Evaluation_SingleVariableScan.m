function Results = Evaluation_SingleVariableScan(Controller)
	Controller.Solver.EvaluationCancel		= false;
	Results 								= struct; %Results outside of GUI
	RelTol 									= str2num(Controller.H.RelTolerance.String);
	MaxStep 								= str2num(Controller.H.MaxStep.String);
	ConvergenceMonitorMode 					= Controller.H.GUI_6_ConvergenceCheckBtnGroup.SelectedObject.String;
	EvaluationTimeMonitor 					= [];
	FailedIntegrations 						= 0;
	DivergedIntegrations					= 0;
	PowerAbsorbedLength 					= length(Controller.Experiment.PowerAbsorbed);
	StartingPressureLength 					= length(Controller.Experiment.StartingPressure);
	GasSupplyLength 						= unique(cellfun(@length,Controller.Experiment.GasSupply.values));
	Controller.Solver.EvaluationStartTime 	= now;
	Controller.H.GUI_6_TimerString.String 	= {'Initialising';'0/2'}; pause(1e-3)
	switch ConvergenceMonitorMode
	case 'Auto'
		ConvergenceTolerance 				= str2num(Controller.H.GUI_6_ConvergenceParameter.String);
	case 'Manual'
		error('Only for auto convergence mode')
	end
	[ScanLength,ScanElement] = max([PowerAbsorbedLength,StartingPressureLength,GasSupplyLength]);
	Iterator = 1;
	EvaluationLength = PowerAbsorbedLength*StartingPressureLength*GasSupplyLength;
	if EvaluationLength ~= ScanLength
		error('Only univariate scan allowed');
	end
	Y = false;
	for PowerAbsorbedIterator = 1:PowerAbsorbedLength
		for StartingPressureIterator = 1:StartingPressureLength
			for GasSupplyIterator = 1:GasSupplyLength
				tic
				if Controller.Solver.EvaluationCancel
					break
				end
				%Update the .Solver indices for this evaluation
				Controller.Solver.PowerAbsorbedIndex 		= PowerAbsorbedIterator;
				Controller.Solver.StartingPressureIndex 	= StartingPressureIterator;
				Controller.Solver.GasSupplyIndex 			= GasSupplyIterator;
				%Save the results of the integration to the .Results struct
				if Y
					[T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,'Auto',ConvergenceTolerance,Y); %Use previous result.
				else
					[T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,'Auto',ConvergenceTolerance);
				end
				if Converged == 0
					FailedIntegrations = FailedIntegrations + 1;
				elseif Converged == -1
					DivergedIntegrations = DivergedIntegrations + 1;
				end
				Results(PowerAbsorbedIterator,StartingPressureIterator,GasSupplyIterator).PowerAbsorbed 		= Controller.Experiment.PowerAbsorbed(PowerAbsorbedIterator);
				Results(PowerAbsorbedIterator,StartingPressureIterator,GasSupplyIterator).StartingPressure 		= Controller.Experiment.StartingPressure(StartingPressureIterator);
				Results(PowerAbsorbedIterator,StartingPressureIterator,GasSupplyIterator).GasSupply 			= GasSupplyIndexing(Controller.Experiment.GasSupply,GasSupplyIterator);
				Results(PowerAbsorbedIterator,StartingPressureIterator,GasSupplyIterator).T 					= T;
				Results(PowerAbsorbedIterator,StartingPressureIterator,GasSupplyIterator).Y 					= Y;
				Results(PowerAbsorbedIterator,StartingPressureIterator,GasSupplyIterator).R 					= R;
				Results(PowerAbsorbedIterator,StartingPressureIterator,GasSupplyIterator).E 					= E;
				Results(PowerAbsorbedIterator,StartingPressureIterator,GasSupplyIterator).M 					= M;
				Results(PowerAbsorbedIterator,StartingPressureIterator,GasSupplyIterator).Converged 			= Converged;
				EvaluationTimeMonitor = [EvaluationTimeMonitor,toc];
				%Update monitor screen
				Controller.H.GUI_6_CalculationsToPeform.String		= num2str(EvaluationLength - Iterator);
				Controller.H.GUI_6_CalculationsCompleted.String		= sprintf('%s (%s failed, %s diverged)',num2str(Iterator),num2str(FailedIntegrations),num2str(DivergedIntegrations));
				Controller.H.GUI_6_AverageTimePerCalc.String		= num2str(mean(EvaluationTimeMonitor));
				Controller.H.GUI_6_ProgressBar.Position(3) 			= Iterator/EvaluationLength;
				Controller.H.GUI_6_EstimatedTimeOfCompletion.String	= datestr(now+datenum(0,0,0,0,0,((EvaluationLength - Iterator)*mean(EvaluationTimeMonitor))),'HH:MM:SS');
				Iterator = Iterator + 1;
			end
		end
	end
	Controller.Results = Results;
	save(sprintf('Results/%s',matlab.lang.makeValidName(strrep(char(datetime),' ','_time_'),'Prefix','date_')),'Results')
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