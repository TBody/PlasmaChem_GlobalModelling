function Init_FinishButton(Controller)
	ModeWarningFigure = defaultFigure([450,450,400,110],'Warning: switching to Matrix evaluation mode');
	defaultText(ModeWarningFigure,[20,50,360,60],'Vectorial ''Experiment'' inputs not allowed in Scalar mode');
	defaultPushbutton(ModeWarningFigure,[220,5,120,40],'OK',@ContinueProceed);
	defaultPushbutton(ModeWarningFigure,[60,5,120,40],'Cancel',@CancelProceed);
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