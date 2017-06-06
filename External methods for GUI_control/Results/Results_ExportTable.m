function OutputTable = Results_ExportTable(Controller)
	FailedEvaluationIndices 	= [];
	DivergedEvaluationIndices 	= [];
	HeaderRow 			= {'PowerAbsorbed','StartingPressure'};
	UnitsRow 			= {'W','Torr'};
	for GasSupplyKey 	= Controller.Results(1,1).GasSupply.keys;
		HeaderRow 		= [HeaderRow,sprintf('%ssupply',GasSupplyKey{:})];
		UnitsRow 		= [UnitsRow,'sccm'];
	end
	for ResultsIndex 	= 1:length(Controller.Results(1,1).Y(end,:))
		if ResultsIndex <= Controller.Species_I2E.length
			HeaderRow 	= [HeaderRow,Controller.Species_I2E.Key(ResultsIndex)];
			UnitsRow 	= [UnitsRow,'m^-3'];
		else
			HeaderRow 	= [HeaderRow,'Te','Converged'];
			UnitsRow 	= [UnitsRow,'eV','NaN'];
		end
	end
	%Add junk ColumnNames so non-valid HeaderRow entries can be used
	ColumnNames = {};
	for Column = 1:length(HeaderRow)
		ColumnNames = [ColumnNames,sprintf('Col%d',Column)];
	end
	switch Controller.Global.EvaluationMode
	case 'Scalar'
		ResultsEntry 		= Controller.Results;
		ValueMatrix 		= [ResultsEntry.PowerAbsorbed,ResultsEntry.StartingPressure];
		for GasSupplyKey 	= ResultsEntry.GasSupply.keys;
			ValueMatrix 	= [ValueMatrix,ResultsEntry.GasSupply(GasSupplyKey{:})];
		end
		ValueMatrix 		= [ValueMatrix,ResultsEntry.Y(end,:)];
		if ~ResultsEntry.Converged && ~Controller.H.GUI_7_IncludeFailed.Value
			error('Scalar entry did not converge. Select ''Include failed evaluations''.')
		end
	case 'Vector'
		ResultsLength									= length(Controller.Results);
		ValueMatrix 									= cell(ResultsLength,length(HeaderRow));
		for RowIterator 								= 1:ResultsLength
			ResultsEntry								= Controller.Results(RowIterator);
			ValueMatrix(RowIterator,1:2) 				= num2cell([ResultsEntry.PowerAbsorbed,ResultsEntry.StartingPressure]);
			ColumnIterator 								= 3;
			for GasSupplyKey 							= ResultsEntry.GasSupply.keys;
				ValueMatrix{RowIterator,ColumnIterator} = ResultsEntry.GasSupply(GasSupplyKey{:});
				ColumnIterator 							= ColumnIterator + 1;
			end
			ValueMatrix(RowIterator,ColumnIterator:end-1) = num2cell(ResultsEntry.Y(end,:));
			ValueMatrix(RowIterator,end)				= num2cell(ResultsEntry.Converged);
			if ResultsEntry.Converged == 0
				FailedEvaluationIndices = [FailedEvaluationIndices,RowIterator];
			elseif ResultsEntry.Converged == -1
				DivergedEvaluationIndices = [DivergedEvaluationIndices,RowIterator];
			end
		end
	case 'Matrix'
		RowIterator 									= 1;
		ResultsLength 									= size(Controller.Results,1)*size(Controller.Results,2)*size(Controller.Results,3);
		ValueMatrix 									= cell(ResultsLength,length(HeaderRow));
		for PowerAbsorbedIndex 							= 1:size(Controller.Results,1)
		for StartingPressureIndex 						= 1:size(Controller.Results,2)
		for GasSupplyIndex 								= 1:size(Controller.Results,3)
			ResultsEntry 								= Controller.Results(PowerAbsorbedIndex,StartingPressureIndex,GasSupplyIndex);
			ValueMatrix(RowIterator,1:2) 				= num2cell([ResultsEntry.PowerAbsorbed,ResultsEntry.StartingPressure]);
			ColumnIterator 								= 3;
			for GasSupplyKey 							= ResultsEntry.GasSupply.keys;
				ValueMatrix{RowIterator,ColumnIterator} = ResultsEntry.GasSupply(GasSupplyKey{:});
				ColumnIterator 							= ColumnIterator + 1;
			end
			ValueMatrix(RowIterator,ColumnIterator:end-1) = num2cell(ResultsEntry.Y(end,:));
			ValueMatrix(RowIterator,end)				= num2cell(ResultsEntry.Converged);
			if ResultsEntry.Converged == 0
				FailedEvaluationIndices = [FailedEvaluationIndices,RowIterator];
			elseif ResultsEntry.Converged == -1
				DivergedEvaluationIndices = [DivergedEvaluationIndices,RowIterator];
			end
			RowIterator 								= RowIterator + 1;
		end
		end
		end
	end
	HeaderRow 	= cell2table(HeaderRow,'VariableNames',ColumnNames);
	UnitsRow 	= cell2table(UnitsRow,'VariableNames',ColumnNames);
	TableValues = array2table(ValueMatrix,'VariableNames',ColumnNames);
	if Controller.H.GUI_7_IncludeFailed.Value
		TableValues(DivergedEvaluationIndices,:) 	= []; %always delete diverged entries
	else
		TableValues([DivergedEvaluationIndices,FailedEvaluationIndices],:) 	= []; %delete the FailedEvaluationIndices rows
	end
	OutputTable = [HeaderRow;UnitsRow;TableValues];
end