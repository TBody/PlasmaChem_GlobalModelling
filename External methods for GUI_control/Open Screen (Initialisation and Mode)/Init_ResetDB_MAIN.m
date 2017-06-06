function Init_ResetDB_MAIN(Source,Event)
	%disp('Init_ResetDB_MAIN called')
	ConfirmFigure = defaultFigure([450,450,350,50],'Are you sure you want clear all databases?');
	defaultPushbutton(ConfirmFigure,[45,5,120,40],'Yes',@ConfirmResetDB);
	defaultPushbutton(ConfirmFigure,[185,5,120,40],'No',@AbortResetDB);
	ConfirmFigure.Visible = 'on';
	function ConfirmResetDB(Source,Event)
		DBReset = NaN;
		save('Databases/DB_MAIN','DBReset')
		ReactionDB_MAIN = DATABASE_C;
		SpeciesDB_MAIN = DATABASE_C;
		save('Databases/DB_MAIN','ReactionDB_MAIN','-append')
		save('Databases/DB_MAIN','SpeciesDB_MAIN','-append')
		delete(ConfirmFigure)
	end
	function AbortResetDB(Source,Event)
		delete(ConfirmFigure);
	end
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