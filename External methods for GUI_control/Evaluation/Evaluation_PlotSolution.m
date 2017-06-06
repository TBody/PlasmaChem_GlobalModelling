function Evaluation_PlotSolution(T,Y,M,Controller)
	for PlotChild = Controller.H.GUI_6_PlotPanel.Children'
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
	YAxisMode = Controller.H.GUI_6_YaxisGroup.SelectedObject.String;
	XAxisMode = Controller.H.GUI_6_XaxisGroup.SelectedObject.String;
	switch YAxisMode
	case 'Y'
		switch XAxisMode
		case 'T'
			Evaluation_PlotSolution_YT(T,Y,Controller,'GUI');
		case 'Step'
			Evaluation_PlotSolution_YStep(Y,Controller,'GUI');
		end
	case 'Err/Y'
		switch XAxisMode
		case 'T'
			Evaluation_PlotSolution_ErrT(M,Controller,'GUI');
		case 'Step'
			Evaluation_PlotSolution_ErrStep(M,Controller,'GUI');
		end
	end
end