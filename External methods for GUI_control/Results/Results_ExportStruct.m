function [ResultsStruct,EvaluationData] = Results_ExportStruct(Controller,ShowSelection)
	ResultsStruct 			= rmfield(Controller.Results,{'T','Y','M'});
	EvaluationData 			= struct;
	switch Controller.Global.EvaluationMode
	case 'Scalar'
		ResultsStruct.Species_I2E 	= Controller.Species_I2E;
		ResultsEntry = Controller.Results;
		if ~ResultsEntry.Converged && ~Controller.H.GUI_7_IncludeFailed.Value
			error('Scalar entry did not converge. Select ''Include failed evaluations''.')
		end
		switch ShowSelection
		case 'Results'
			ResultsStruct.Species_N 	= ResultsEntry.Y(end,1:end-1)';
			ResultsStruct.Te 			= ResultsEntry.Y(end,end)';
		case 'Integration points'
			ResultsStruct.Species_N 	= ResultsEntry.Y(:,1:end-1)';
			ResultsStruct.Te 			= ResultsEntry.Y(:,end)';
		case 'Full evaluation data'
			ResultsStruct.Species_N 	= ResultsEntry.Y(:,1:end-1)';
			ResultsStruct.Te 			= ResultsEntry.Y(:,end)';
			EvaluationData.Reactor 		= Controller.Reactor;
			EvaluationData.ReactionDB 	= Controller.ReactionDB;
			EvaluationData.SpeciesDB 	= Controller.SpeciesDB;
			EvaluationData.CrosssectionDB = Controller.CrosssectionDB;
			EvaluationData.Experiment 	= Controller.Experiment;
		end
	case 'Vector'
		for RowIterator = 1:length(Controller.Results)
			ResultsStruct(RowIterator).Species_I2E 	= Controller.Species_I2E;
			ResultsEntry = Controller.Results(RowIterator);
			switch ShowSelection
			case 'Results'
				ResultsStruct(RowIterator).Species_N 	= ResultsEntry.Y(end,1:end-1)';
				ResultsStruct(RowIterator).Te 			= ResultsEntry.Y(end,end)';
			case 'Integration points'
				ResultsStruct(RowIterator).Species_N 	= ResultsEntry.Y(:,1:end-1)';
				ResultsStruct(RowIterator).Te 			= ResultsEntry.Y(:,end)';
			case 'Full evaluation data'
				ResultsStruct(RowIterator).Species_N 	= ResultsEntry.Y(:,1:end-1)';
				ResultsStruct(RowIterator).Te 			= ResultsEntry.Y(:,end)';
				EvaluationData.Reactor 					= Controller.Reactor;
				EvaluationData.ReactionDB 				= Controller.ReactionDB;
				EvaluationData.SpeciesDB 				= Controller.SpeciesDB;
				EvaluationData.CrosssectionDB 			= Controller.CrosssectionDB;
				EvaluationData.Experiment 				= Controller.Experiment;
			end
		end
		ResultsStruct = [ResultsStruct([ResultsStruct.Converged ~= -1])];
		if ~Controller.H.GUI_7_IncludeFailed.Value
			ResultsStruct = [ResultsStruct([ResultsStruct.Converged == 1])];
		end
	case 'Matrix'
		for PowerAbsorbedIndex 							= 1:size(Controller.Results,1)
		for StartingPressureIndex 						= 1:size(Controller.Results,2)
		for GasSupplyIndex 								= 1:size(Controller.Results,3)
			ResultsStruct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Species_I2E 	= Controller.Species_I2E;
			ResultsEntry = Controller.Results(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex);
			if (ResultsEntry.Converged == 0 && ~Controller.H.GUI_7_IncludeFailed.Value) || ResultsEntry.Converged == -1
				for field = fieldnames(ResultsStruct)' %Delete all the fields
					ResultsStruct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).(field{:}) = [];
				end
				continue
			end
			switch ShowSelection
			case 'Results'
				ResultsStruct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Species_N 	...
														= ResultsEntry.Y(end,1:end-1)';
				ResultsStruct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Te 			...
														= ResultsEntry.Y(end,end)';
			case 'Integration points'
				ResultsStruct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Species_N 	...
														= ResultsEntry.Y(:,1:end-1)';
				ResultsStruct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Te 			...
														= ResultsEntry.Y(:,end)';
			case 'Full evaluation data'
				ResultsStruct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Species_N 	...
														= ResultsEntry.Y(:,1:end-1)';
				ResultsStruct(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex).Te 			...
														= ResultsEntry.Y(:,end)';
				EvaluationData.Reactor 					= Controller.Reactor;
				EvaluationData.ReactionDB 				= Controller.ReactionDB;
				EvaluationData.SpeciesDB 				= Controller.SpeciesDB;
				EvaluationData.CrosssectionDB 			= Controller.CrosssectionDB;
				EvaluationData.Experiment 				= Controller.Experiment;
			end
		end
		end
		end
	end
end