function Results_Export(Controller)
	TestIdentifier 	= matlab.lang.makeValidName(sprintf('%s_%s',Controller.H.ReactorName.String,Controller.H.ExpReference.String));
	FileNameSplit 	= strsplit(Controller.H.GUI_7_FileLocation.String,'.');
	FileNameSplit{1} = [FileNameSplit{1},':',TestIdentifier];
	FileName 		= strjoin(FileNameSplit,'.');
	FileFormat 		= Controller.H.GUI_7_SaveTo.String{Controller.H.GUI_7_SaveTo.Value};
	SaveSelection 	= Controller.H.GUI_7_Save.String{Controller.H.GUI_7_Save.Value};
	if ~strcmp(FileFormat,'MATLAB workspace')
		ExportFolder 	= Controller.Global.ExportFolder;
	end
	switch SaveSelection
	case 'Results'
		switch FileFormat
		case 'Text file (.csv)'
			OutputTable = Results_ExportTable(Controller);
			writetable(OutputTable,sprintf('%s%s',ExportFolder,FileName),'WriteVariableNames',false);
		case 'MATLAB data file (.mat)'
			SaveStruct = struct(TestIdentifier,Results_ExportStruct(Controller,SaveSelection));
			save(sprintf('%s%s',ExportFolder,FileName),'-struct','SaveStruct');
		case 'MATLAB workspace'
			OutputStruct = Results_ExportStruct(Controller,SaveSelection);
			assignin('base',TestIdentifier,OutputStruct);
		end
	case 'Integration points'
		switch FileFormat
		case 'Text file (.csv)'
			error('Integration points cannot be exported to csv')
		case 'MATLAB data file (.mat)'
			SaveStruct = struct(TestIdentifier,Results_ExportStruct(Controller,SaveSelection));
			save(sprintf('%s%s',ExportFolder,FileName),'-struct','SaveStruct');
		case 'MATLAB workspace'
			OutputStruct = Results_ExportStruct(Controller,SaveSelection);
			assignin('base',TestIdentifier,OutputStruct);
		end
	case 'Full evaluation data'
		switch FileFormat
		case 'Text file (.csv)'
			error('Full evaluation data cannot be exported to csv')
		case 'MATLAB data file (.mat)'
			[ResultsStruct,EvaluationData] = Results_ExportStruct(Controller,SaveSelection);
			SaveStruct = struct([TestIdentifier,'_Results'],ResultsStruct,[TestIdentifier,'_EvalData'],EvaluationData);
			save(sprintf('%s%s',ExportFolder,FileName),'-struct','SaveStruct');
		case 'MATLAB workspace'
			[ResultsStruct,EvaluationData] = Results_ExportStruct(Controller,SaveSelection);
			assignin('base',[TestIdentifier,'_Results'],ResultsStruct);
			assignin('base',[TestIdentifier,'_EvalData'],EvaluationData);
		end
	case 'Figure'
		OutputFigure = Results_Plot(Controller,'figure');
		switch FileFormat
		case 'MATLAB figure file (.fig)'
			savefig(OutputFigure,sprintf('%s%s',ExportFolder,FileName));
			delete(OutputFigure)
		case 'PDF file (.pdf)'
			print(OutputFigure,sprintf('%s%s',ExportFolder,FileName),'-dpdf','-painters');
			delete(OutputFigure)
		case 'PNG file (.png)'
			print(OutputFigure,sprintf('%s%s',ExportFolder,FileName),'-dpng','-painters');
			delete(OutputFigure)
		case 'MATLAB workspace'
			assignin('base',[TestIdentifier,'_Figure'],OutputFigure)
		end
	end
end