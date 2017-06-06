function TempFigure = Evaluation_PlotSolution_YT(T,Y,Controller,toflag)
	TempFigure = figure;
	TempFigure.Visible = 'off';
	[ax,p1,p2] = plotyy(T,Y(:,end),T,Y(:,1:end-1),'plot','semilogy');
	LogDensityMin 	= real(floor(log10(min(min(Y(:,1:end-1))))));
	LogDensityMax 	= real(ceil(log10(max(max(Y(:,1:end-1))))));
	TeMin 			= real(floor(min(min(Y(:,end)))));
	TeMax 			= real(ceil(max(max(Y(:,end)))));
	ax(2).YLim = [10^(LogDensityMin-1) 10^(LogDensityMax+1)];
	ax(2).YTick = 10.^[LogDensityMin:2:LogDensityMax];
	ax(2).FontSize = 16;
	ax(1).YLim = [TeMin*0.9 TeMax*1.1];
	ax(1).YTick = round(linspace(TeMin,TeMax,5),2);
	ax(1).FontSize = 16;
	xlabel('Evaluation Time (s)','FontSize',18)
	ylabel(ax(2),'Particle Density (m^{-3})','FontSize',18)
	ylabel(ax(1),'Electron Temperature (eV)','FontSize',18)
	legend(['Te',Controller.Species_I2E.list],'Location','northeast','FontSize',16,'FontUnits','Normalized')
	for LineIndex = 1:length(p2)
		p2(LineIndex).LineWidth = 3;
	end
	p1.LineWidth = 3;
	p1.LineStyle = '--';
	warning('off','MATLAB:handle_graphics:exceptions:SceneNode');
	set( findall(TempFigure, '-property', 'Units' ), 'Units', 'Normalized' );
	set( findall(TempFigure, '-property', 'FontUnits' ), 'FontUnits', 'Normalized' );
	ax(1).OuterPosition = [0 0 1 1];
	ax(2).OuterPosition = [0 0 1 1];
	switch toflag
	case 'GUI'
		ax(1).Parent = Controller.H.GUI_6_PlotPanel;
		ax(2).Parent = Controller.H.GUI_6_PlotPanel;
	case 'figure'
		TempFigure.Visible = 'on';
	otherwise
		warning('invalid flag for Evaluation_PlotSolution')
	end
end