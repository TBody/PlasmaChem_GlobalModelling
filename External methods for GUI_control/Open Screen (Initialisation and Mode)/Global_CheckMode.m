function [ReturnMode,ProceedAllowed] = Global_CheckMode(Mode,Experiment)
	%disp('Global_CheckMode called')
	global ProgramFix
	ProgramFix 	= true;
	VectorInput = false;
	EqualLength = true;
	try
		GasSupplyLengthArray = cellfun(@length,Experiment.GasSupply.values);
	catch
		GasSupplyLengthArray = 0;
	end
	if ~isempty(find(GasSupplyLengthArray>1))
		if length(unique(GasSupplyLengthArray))>1
			ProceedAllowed 	= false;
			ReturnMode 		= Mode;
			GasSupplyLength = NaN;
			GasSupplyWarningFigure = WarnGasSupply;
			uiwait(GasSupplyWarningFigure);
			return
		else
			GasSupplyLength = unique(GasSupplyLengthArray);
		end
	else
		GasSupplyLength = 1;
	end
	LengthArray = [	length(Experiment.PowerAbsorbed),... %length(Experiment.DutyCycle),... %length(Experiment.PowerFreq),...
					length(Experiment.StartingPressure),...
					length(Experiment.OutletPressure),...
					GasSupplyLength];
	LengthArray(LengthArray==0) = []; %Remove 0-length (empty) elements - since these haven't been defined yet
	LengthArray(LengthArray==1) = []; %Remove 1-length elements - since these will be treated as scalars
	if ~isempty(LengthArray)
		VectorInput = true;
		if length(unique(LengthArray))>1
			EqualLength = false;
		end
	end
	if ProgramFix
		switch Mode
		case 'Scalar'
			if VectorInput
				ModeWarningFigure = WarnScalar;
				uiwait(ModeWarningFigure);
				if ProgramFix
					ProceedAllowed = true;
					ReturnMode = 'Matrix';
				else
					ProceedAllowed = false;
					ReturnMode = Mode;
				end
			else
				ProceedAllowed = true;
				ReturnMode = Mode;
			end
		case 'Vector'
			if ~EqualLength
				ModeWarningFigure = WarnVector;
				uiwait(ModeWarningFigure);
				if ProgramFix
					ProceedAllowed = true;
					ReturnMode = 'Matrix';
				else
					ProceedAllowed = false;
					ReturnMode = Mode;
				end
			else
				ProceedAllowed = true;
				ReturnMode = Mode;
			end
		case 'Matrix'
			%Accepts all inputs
			ProceedAllowed = true;
			ReturnMode = Mode;
		end
	else
		ProceedAllowed = false;
		ReturnMode = Mode;
	end
	clear ProgramFix
end
function GasSupplyWarningFigure = WarnGasSupply
	GasSupplyWarningFigure = defaultFigure([450,450,400,140],'Gas supply rate lengths must be equal');
	defaultText(GasSupplyWarningFigure,[0,50,400,90],'Gas supply rates are indexed simultaneously and therefore must be equal in length');
	defaultPushbutton(GasSupplyWarningFigure,[140,5,120,40],'OK',@CancelProceed);
end
function ModeWarningFigure = WarnScalar
	ModeWarningFigure = defaultFigure([450,450,400,110],'Warning: switching to Matrix evaluation mode');
	defaultText(ModeWarningFigure,[20,50,360,60],'Vectorial ''Experiment'' inputs not allowed in Scalar mode');
	defaultPushbutton(ModeWarningFigure,[220,5,120,40],'OK',@ContinueProceed);
	defaultPushbutton(ModeWarningFigure,[60,5,120,40],'Cancel',@CancelProceed);
end
function ModeWarningFigure = WarnVector
	ModeWarningFigure = defaultFigure([450,450,400,110],'Warning: switching to Matrix evaluation mode');
	defaultText(ModeWarningFigure,[20,50,360,60],'Variable-length ''Experiment'' inputs not allowed in Vector mode');
	defaultPushbutton(ModeWarningFigure,[220,5,120,40],'OK',@ContinueProceed);
	defaultPushbutton(ModeWarningFigure,[60,5,120,40],'Cancel',@CancelProceed);
end
function ContinueProceed(Source,event)
	global ProgramFix
	ProgramFix = true;
	delete(Source.Parent);
end	
function CancelProceed(Source,event)
	global ProgramFix
	ProgramFix = false;
	delete(Source.Parent);
end
function defaultFigure = defaultFigure(Position,Name)
	defaultFigure = figure('Units','pixels','Name',Name,'Position',Position,...
		'MenuBar','None','NumberTitle','Off','Resize','Off',...
		'Visible','Off','WindowStyle','Normal');
end
function defaultUIcontrol = defaultUIcontrol(Parent,Position,String,Callback)
	defaultUIcontrol = uicontrol('Units','pixels','String',String,'Callback',Callback,...
		'Parent',Parent,'Position',Position,'FontName','Avenir Next',...
		'FontSize',24);
end
function defaultPushbutton = defaultPushbutton(Parent,Position,String,Callback)
	defaultPushbutton = defaultUIcontrol(Parent,Position,String,Callback);
	defaultPushbutton.Style = 'pushbutton';
end
function defaultString = defaultString(Parent,Position,String)
	defaultString = defaultUIcontrol(Parent,Position,String,'');
	defaultString.HorizontalAlignment = 'left';
	defaultString.Style = 'text';
end
function defaultText = defaultText(Parent,Position,String)
	defaultText = defaultString(Parent,Position,String);
	defaultText.FontSize = 20;
	defaultText.HorizontalAlignment = 'center';
end