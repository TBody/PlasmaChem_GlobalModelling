function OutputFigure = Results_Plot_TeN(X,Y_Te,Y_N,Title,Controller,toflag)
	%disp('Results_Plot_TeN called')
	TempFigure 			= figure;
	TempFigure.Visible 	= 'off';
	IndependentVariable = Controller.H.GUI_7_IndependentVar.String{Controller.H.GUI_7_IndependentVar.Value};
	ShowPlotElement 	= logical(Controller.Global.ShowPlotElement(2:end));
	Species_List 		= Controller.Species_I2E.list;
	Legend 				= ['Te',Species_List(ShowPlotElement)];
	[ax,p1,p2] 			= plotyy(X,Y_Te,X,Y_N,'plot','semilogy');
	LogDensityMin 		= floor(log10(min(min(Y_N))));
	LogDensityMax 		= ceil(log10(max(max(Y_N))));
	TeMin 				= floor(min(Y_Te));
	TeMax 				= ceil(max(Y_Te));
	ax(2).YLim 			= [10^(LogDensityMin) 10^(LogDensityMax)];
	ax(2).YTick 		= 10.^[LogDensityMin:1:LogDensityMax];
	ax(2).FontSize 		= 16;
	ax(1).YLim 			= [TeMin TeMax];
	ax(1).YTick 		= round(linspace(TeMin,TeMax,5),2);
	ax(1).FontSize 		= 16;
	switch IndependentVariable
	case 'Test #'
		xlabel('Test index','FontSize',18)
	case 'Power absorbed'
		xlabel('Power absorbed (W)','FontSize',18)
	case 'Starting pressure'
		xlabel('Starting pressure (mTorr)','FontSize',18)
	case 'Gas supply'
		switch Controller.H.GUI_7_GasSupplyVary.String{Controller.H.GUI_7_GasSupplyVary.Value}
		case 'Total flow'
			xlabel('Total gas supply (sccm)','FontSize',18)
		otherwise
			ParameterSplit 	= strsplit(Controller.H.GUI_7_GasSupplyVary.String{Controller.H.GUI_7_GasSupplyVary.Value});
			GasSupplyKey 	= ParameterSplit{1};
			TotalFlow 		= Controller.H.GUI_7_GasSupplyAt.String{Controller.H.GUI_7_GasSupplyAt.Value};
			xlabel(sprintf('%s proportion (%%) of %ssccm total flow',GasSupplyKey,TotalFlow),'FontSize',18)
		end
	end
	ylabel(ax(2),'Particle Density (m^{-3})','FontSize',18)
	ylabel(ax(1),'Electron Temperature (eV)','FontSize',18)
	title(Title)
	legend(Legend,'Location','northeast','FontSize',16,'FontUnits','Normalized')
	for LineIndex = 1:length(p2)
		p2(LineIndex).LineWidth = 3;
		p2(LineIndex).Marker 			= '.';
		p2(LineIndex).MarkerSize 		= 16;
	end
	p1.LineWidth 		= 3;
	p1.LineStyle 		= '--';
	p1.Marker 			= '.';
	p1.MarkerSize 		= 16;
	warning('off','MATLAB:handle_graphics:exceptions:SceneNode');
	set( findall(TempFigure, '-property', 'Units' ), 'Units', 'Normalized' );
	set( findall(TempFigure, '-property', 'FontUnits' ), 'FontUnits', 'Normalized' );
	ax(1).OuterPosition = [0 0 1 1];
	ax(2).OuterPosition = [0 0 1 1];
	switch toflag
	case 'GUI'
		ax(1).Parent = Controller.H.GUI_7_PlotPanel;
		ax(2).Parent = Controller.H.GUI_7_PlotPanel;
		delete(TempFigure)
	case 'figure'
		if nargout == 1
			OutputFigure = TempFigure;
			OutputFigure.Visible = 'on';
		else
			TempFigure.Visible = 'on';
		end
	otherwise
		warning('invalid flag for Results_Plot')
	end
end