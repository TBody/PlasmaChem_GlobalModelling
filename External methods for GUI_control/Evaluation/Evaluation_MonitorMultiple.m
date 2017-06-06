function Evaluation_MonitorMultiple(Controller)
	Results 						= struct; %Reset results;
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
		EvaluationTime 						= str2num(Controller.H.GUI_6_ConvergenceParameter.String);
	end
	switch Controller.Global.EvaluationMode
	case 'Vector'
		VectorLength = max([PowerAbsorbedLength,StartingPressureLength,GasSupplyLength]);
		for Iterator = 1:VectorLength
			tic
			pause(1e-2) %Let GUI input be evaluated
			if Controller.Solver.EvaluationCancel
				break
			end
			%Update the .Solver indices for this evaluation.
			Controller.Solver.PowerAbsorbedIndex			= min([Iterator,PowerAbsorbedLength]);
			Controller.Solver.StartingPressureIndex 		= min([Iterator,StartingPressureLength]);
			Controller.Solver.GasSupplyIndex 				= min([Iterator,GasSupplyLength]);
			%Save the results of the integration to the .Results struct
			switch ConvergenceMonitorMode
			case 'Auto'
				[T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,'Auto',ConvergenceTolerance);
				if Converged == 0
					FailedIntegrations = FailedIntegrations + 1;
				elseif Converged == -1
					DivergedIntegrations = DivergedIntegrations + 1;
				end
			case 'Manual'
				[T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,'Manual',EvaluationTime);
			end
			Results(Iterator).PowerAbsorbed 		= Controller.Experiment.PowerAbsorbed(Controller.Solver.PowerAbsorbedIndex);
			Results(Iterator).StartingPressure 	= Controller.Experiment.StartingPressure(Controller.Solver.StartingPressureIndex);
			Results(Iterator).GasSupply 			= GasSupplyIndexing(Controller.Experiment.GasSupply,Controller.Solver.GasSupplyIndex);
			Results(Iterator).T					= T;
			Results(Iterator).Y					= Y;
			Results(Iterator).R					= R;
			Results(Iterator).E					= E;
			Results(Iterator).M					= M;
			Results(Iterator).Converged			= Converged;
			EvaluationTimeMonitor = [EvaluationTimeMonitor,toc];
			%Update monitor screen
			Controller.H.GUI_6_CalculationsToPeform.String		= num2str(VectorLength - Iterator);
			Controller.H.GUI_6_CalculationsCompleted.String		= sprintf('%s (%s failed, %s diverged)',num2str(Iterator),num2str(FailedIntegrations),num2str(DivergedIntegrations));
			Controller.H.GUI_6_AverageTimePerCalc.String		= num2str(mean(EvaluationTimeMonitor));
			Controller.H.GUI_6_ProgressBar.Position(3) 			= Iterator/VectorLength;
			Controller.H.GUI_6_EstimatedTimeOfCompletion.String	= datestr(now+datenum(0,0,0,0,0,((VectorLength - Iterator)*mean(EvaluationTimeMonitor))),'HH:MM:SS');
		end
	case 'Matrix'
		Iterator = 1;
		EvaluationLength = PowerAbsorbedLength*StartingPressureLength*GasSupplyLength;
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
					switch ConvergenceMonitorMode
					case 'Auto'
						[T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,'Auto',ConvergenceTolerance);
						if Converged == 0
							FailedIntegrations = FailedIntegrations + 1;
						elseif Converged == -1
							DivergedIntegrations = DivergedIntegrations + 1;
						end
					case 'Manual'
						[T,Y,R,E,M,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,'Manual',EvaluationTime);
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