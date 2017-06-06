classdef CrosssectionBuilder<handle
	properties
		CurrentCrosssection
		CrosssectionDB
		Controller
		Global
		H
	end
	methods
	function obj = CrosssectionBuilder
		obj.Controller = CrosssectionBuilder_Make(obj);
		try
			load('CrosssectionDB')
			obj.Global.CrosssectionDBFound = true;
		catch ME
			warning(sprintf('%s. Loading a blank database instead.',ME.message));
			CrosssectionDB = DATABASE_C;
			obj.Global.CrosssectionDBFound = false;
		end
		obj.CrosssectionDB = CrosssectionDB;
	end
	function XCController(obj)
		%The GUI_control object is initially made invisible - to minimise flashing
		obj.Controller.Visible = 'On';
	end
	function CrosssectionUIgetFile(obj,Source,Event)
		CrosssectionFolderLocation = sprintf('%s/Crosssections/*.csv',cd);
		CrosssectionFileName = uigetfile(CrosssectionFolderLocation);
		obj.H.FileName.String = CrosssectionFileName;
		obj.H.DBKey.String = CrosssectionFileName(1:end-4);
	end
	function CrosssectionEvaluate(obj,Source,Event)
		Source.String = 'Evaluating';
		CrosssectionLocation	= sprintf('%s/Crosssections/%s',cd,obj.H.FileName.String);
		Key 					= obj.H.DBKey.String;
		HeaderLines 			= str2num(obj.H.HeaderLines.String);
		EnergyUnits 			= {str2num(obj.H.EnergyUnitsExp.String),obj.H.EnergyUnitsType.String{obj.H.EnergyUnitsType.Value}}; %UNITS
		CrosssectionUnits 		= {str2num(obj.H.CrosssectionUnitsExp.String),obj.H.CrosssectionUnitsType.String{obj.H.CrosssectionUnitsType.Value}}; %UNITS
		obj.CurrentCrosssection = CROSSSECTION_C(CrosssectionLocation,Key,HeaderLines,EnergyUnits,CrosssectionUnits);
		obj.ResetPlotPanel;
		switch obj.H.PlotModeButtonGroup.SelectedObject.String
		case 'Data'
			Plot_Return = obj.CurrentCrosssection.Plot_Crosssection('off').CurrentAxes;
			obj.H.PlotIDString.String = 'Crosssection data';
		case 'Rate'
			Plot_Return = obj.CurrentCrosssection.Plot_RateCoefficient('off').CurrentAxes;
			obj.H.PlotIDString.String = 'Rate Coefficient';
		end
		Plot_Return.Parent = obj.H.PlotPanel;
        Source.Visible = 'off';
        Source.String = 'Evaluate';
	end
	function AddCrosssection = AddCurrentCrosssectionToDB(obj)
		CrosssectionKey = obj.CurrentCrosssection.Key;
		if strtrim(CrosssectionKey) %Make sure CrosssectionKey isn't empty
			if obj.H.OverwriteCheckbox.Value
				AddCrosssection = true;
			elseif ~obj.CrosssectionDB.KeyExists(CrosssectionKey)
				AddCrosssection = true;
			else
				AddCrosssection = false;
			end
		else
			AddCrosssection = false;
		end
		if AddCrosssection
			obj.CrosssectionDB.add(CrosssectionKey,obj.CurrentCrosssection);
			disp('Cross-section added to local CrosssectionDB')
			obj.ResetCrosssectionBuilderScreen;
		else
			obj.H.PlotIDString.String = 'Err: Key already in CrosssectionDB';
		end
	end
	function CrosssectionAddAnother(obj,Source,Event)
		obj.AddCurrentCrosssectionToDB;
	end
	function CrosssectionSaveAndClose(obj,Source,Event)
		AddCrosssection = obj.AddCurrentCrosssectionToDB;
		if AddCrosssection
			CrosssectionDB = obj.CrosssectionDB;
			save('Databases/CrosssectionDB','CrosssectionDB');
			disp('local CrosssectionDB saved to file')
			delete(obj.Controller);
		end
	end
	function ResetCrosssectionBuilderScreen(obj)
		obj.H.FileName.String				= blanks(0);
     	obj.H.DBKey.String					= blanks(0);
     	obj.H.HeaderLines.String			= 3;
     	obj.H.EnergyUnitsExp.String			= 1;
    	obj.H.EnergyUnitsType.Value			= 1;
		obj.H.CrosssectionUnitsExp.String	= blanks(0);
		obj.H.CrosssectionUnitsType.Value 	= 1;
		obj.ResetPlotPanel;
		obj.H.Evaluate.Visible 				= 'on';
	end
	function ResetPlotPanel(obj)
		for PlotChild = obj.H.PlotPanel.Children'
			switch PlotChild.Type
			case 'uicontrol'
				%Do nothing - deal with this in a different bit of code.
			case 'legend'
				delete(PlotChild);
			case 'axes'
				delete(PlotChild);
			otherwise
				error('Child of PlotPanel not recognised')
			end
		end
	end
	function CrosssectionCancel(obj,Source,Event)
		delete(obj.Controller);
	end
	function ModeChangedFunction(obj,Source,Event)
		NewMode = Event.NewValue.String;
		obj.ResetPlotPanel;
		try %Will fail if obj.CurrentCrosssection hasn't been defined yet
			switch NewMode
			case 'Data'
				Plot_Return = obj.CurrentCrosssection.Plot_Crosssection('off').CurrentAxes;
				obj.H.PlotIDString.String = 'Crosssection data';
			case 'Rate'
				Plot_Return = obj.CurrentCrosssection.Plot_RateCoefficient('off').CurrentAxes;
				obj.H.PlotIDString.String = 'Rate Coefficient';
			end
		catch ME
			ME.message
		end
		Plot_Return.Parent = obj.H.PlotPanel;
	end
	end
end