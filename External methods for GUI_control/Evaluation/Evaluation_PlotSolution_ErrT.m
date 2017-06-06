function TempFigure = Evaluation_PlotSolution_ErrT(M,Controller,toflag)
	TempFigure = figure;
	TempFigure.Visible = 'off';
	p = semilogy(M(1,:),M(2:end,:));
	ax = TempFigure.Children;
	ax.FontSize = 16;
	xlabel('Evaluation Time (s)','FontSize',18)
	ylabel('Step change/value','FontSize',18);
	legend(['Te',Controller.Species_I2E.list],'Location','northeast','FontSize',16,'FontUnits','Normalized')
	for LineIndex = 1:length(p)
		p(LineIndex).LineWidth = 2;
	end
	p(1).LineStyle = '--';
	warning('off','MATLAB:handle_graphics:exceptions:SceneNode');
	set( findall(TempFigure, '-property', 'Units' ), 'Units', 'Normalized' );
	set( findall(TempFigure, '-property', 'FontUnits' ), 'FontUnits', 'Normalized' );
	ax.OuterPosition = [0 0 1 1];
	switch toflag
	case 'GUI'
		ax.Parent = Controller.H.GUI_6_PlotPanel;
	case 'figure'
		TempFigure.Visible = 'on';
	otherwise
		warning('invalid flag for Evaluation_PlotSolution')
	end
end