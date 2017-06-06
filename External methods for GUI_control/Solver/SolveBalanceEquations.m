function [R_Times,R_ConcTe,FinalRate,FinalError,ErrorMonitor,Converged] = SolveBalanceEquations(Controller,RelTol,MaxStep,ConvergenceMode,ConvergenceParameter,PreviousResult)
	%%Use custom warnings.
		warning('off','MATLAB:ode15s:IntegrationTolNotMet')
		warning('off','backtrace')
	if ~isfield(Controller.Solver,'SystemStruct') || Controller.Global.SystemUpdated
		disp('Vectorising balance equations'); Controller.H.GUI_6_TimerString.String = {'Initialising';'1/2'}; pause(1e-3)
		Controller.Solver.SystemStruct 			= Precalculate_SystemStruct(Controller);
	end
	if ~isfield(Controller.Solver,'ExperimentStruct') || Controller.Global.ExperimentUpdated
		disp('Calculating experiment matrix'); Controller.H.GUI_6_TimerString.String = {'Initialising';'2/2'}; pause(1e-3)
		Controller.Solver.ExperimentStruct 		= Precalculate_ExperimentStruct(Controller);
		Controller.Solver.EvaluationStartTime 	= now;
	end
	%%Unpack from the structs for quicker evaluation
		SS 						= Controller.Solver.SystemStruct;
		ES 						= Controller.Solver.ExperimentStruct;
		Reaction_ratecoeff_vector 		= SS.Reaction_ratecoeff_vector;
		Reaction_energy_vector 			= SS.Reaction_energy_vector;
		Species_ionic_uBohm_vector 			= SS.Species_ionic_uBohm_vector;
		ReactantMatrix 			= SS.ReactantMatrix;
		ProductionMatrix 		= SS.ProductionMatrix;
		e_index 				= SS.e_index;
		Species_charge_vector 				= SS.Species_charge_vector;
		Fs_index 				= SS.Fs_index;
		Species_surface_marker 				= SS.Species_surface_marker;
		Reaction_inelastic_marker 				= SS.Reaction_inelastic_marker;
		Species_ionic_marker 			= SS.Species_ionic_marker;
		A_eff 					= SS.A_eff;
		Total_surface_sites 	= Controller.Reactor.S_T;
		Volume 					= Controller.Reactor.Volume;
		PowerAbsorbed 			= ES.PowerAbsorbed(Controller.Solver.PowerAbsorbedIndex);
		PumpInVector 			= ES.PumpInMatrix(:,Controller.Solver.GasSupplyIndex);
		PumpOutVector 			= ES.PumpOutMatrix(:,Controller.Solver.StartingPressureIndex,Controller.Solver.GasSupplyIndex);
	%%Preallocation
		ReactionLength 	= length(Controller.Reaction_I2E);
		SpeciesLength 	= length(Controller.Species_I2E);
		DensityFactor	= zeros(ReactionLength,1);
	%%Initial conditions
	if ~isfield(SS,'RecalculateTe')
		SS.RecalculateTe = true;
		Controller.Solver.SystemStruct = SS;
	end
	if nargin == 6
		InitialConditions 	= PreviousResult(end,:)';
	else
		[InitialConditions]	= Build_InitialConditions(Controller);
	end
	SS.RecalculateTe = false;
	Controller.Solver.SystemStruct = SS;
	%InitialConditions(IgnoredIndices) = 1; %prevents division by zero
	ErrorMonitor 					= zeros(length(InitialConditions)+1,Controller.Solver.MaxEvaluations); %!!Preallocation
	Controller.H.GUI_6_TimerString.String = {'Evaluating';datestr(now-Controller.Solver.EvaluationStartTime,'MM:SS.FFF')}; pause(1e-3)
	disp(sprintf('Evaluating system at %sW, %smTorr with a gas supply of %s',num2str(Controller.Experiment.PowerAbsorbed(Controller.Solver.PowerAbsorbedIndex)),...
						        num2str(Controller.Experiment.StartingPressure(Controller.Solver.StartingPressureIndex)*1e3),...
						        Display_dict(Controller.Experiment.GasSupply,Controller)));
	load('physicalconstants','eV2J','m_e')
	switch ConvergenceMode
	case 'Auto'
		ConvergencePrecision 		= ConvergenceParameter;
		options 					= odeset('RelTol',RelTol,'MaxStep',1,'Events',@Evaluation_CheckConvergence,'OutputFcn',@CountMonitor,'NonNegative',[1:length(InitialConditions)]);%,'JPattern',SS.SparseJacobianMatrix);
		Error 						= Inf; Count = 1;
		tic
		[R_Times,R_ConcTe] 			= ode15s(@BalanceEquations,[0 Inf],InitialConditions,options);
		ErrorMonitor(:,Count:end) 	= []; %Clean up over-allocated preallocation
		FinalRate 					= ReactionRate;
		FinalError					= [abs(dDensity)./Density; abs(dTe)./Te];
	case 'Manual'
		EvaluationTime 				= ConvergenceParameter;
		options 					= odeset('RelTol',RelTol,'MaxStep',1,'OutputFcn',@CountMonitor,'NonNegative',[1:length(InitialConditions)]);%,'JPattern',SS.SparseJacobianMatrix);
		Count 						= 1;
		[R_Times,R_ConcTe] 			= ode15s(@BalanceEquations,[0 EvaluationTime],InitialConditions,options);
		ErrorMonitor(:,Count:end) 	= []; %Clean up over-allocated preallocation
		FinalRate 					= ReactionRate;
		FinalError					= [abs(dDensity)./Density; abs(dTe)./Te];
	otherwise
		disp('Err: convergence monitor mode not recognised in SolveBalanceEquations')
	end
	warning('on','MATLAB:ode15s:IntegrationTolNotMet')
	warning('on','backtrace')
	function dy = BalanceEquations(t,y)
		%%Unpack the state vector
		Density 				= y(1:end-1);
		Te 						= y(end);
		
		%%Force QN and FS conditions. N.b. their respective calculation vectors have zeros at e_index and Fs_index to simplify calculation
		Density(e_index) = sum(Density.*Species_charge_vector);
		Density(Fs_index) = Total_surface_sites - sum(Density.*Species_surface_marker);

		%%Check that QN and FS conditions are met
		% disp(sprintf('Charge imbalance      : %e', sum(Density.*Species_charge_vector)-Density(e_index)));
		% disp(sprintf('Surface site imbalance: %e', Total_surface_sites - (sum(Density.*Species_surface_marker) + Density(Fs_index))));
		

		%% Calculate terms which depend on Te
		[RateCoeff,Energy,uBohm] = Evaluate_Te_dependent_vectors(Reaction_ratecoeff_vector,Reaction_energy_vector,Species_ionic_uBohm_vector,Te);
		RateCoeff(RateCoeff<0) 	= 0;
		%%Calculate the rates
		for ReactionIndex = 1:ReactionLength
			DensityFactor(ReactionIndex) = prod((Density').^ReactantMatrix(ReactionIndex,:));
		end
		ReactionRate 			= RateCoeff.*DensityFactor;
		%%Calculate the change in particle concentration
		Production				= ProductionMatrix*ReactionRate;
		dDensity 				= Production + PumpInVector - (PumpOutVector.*Density);
		dDensity(e_index) 		= sum(dDensity.*Species_charge_vector);
		dDensity(Fs_index)		= -sum(dDensity.*Species_surface_marker);
		

		%%Calculate the power loss in eVm^(-3)s^(-1)
			%%Loss due to electron collisions
			ElectronCollisionalLoss = sum(Reaction_inelastic_marker.*ReactionRate.*Energy);
			%%Loss due to ion-electron loss at walls
			BohmDensityProduct 		= uBohm.*Density(logical(Species_ionic_marker));
			WallLossEnergy 			= -log(4*BohmDensityProduct/(Density(e_index)*sqrt(8*eV2J*Te/(pi*m_e))))+2.5;
			IonWallLoss 			= Te * sum(A_eff.*BohmDensityProduct.*WallLossEnergy)/Volume;
			%%Total loss
			PowerLoss				= ElectronCollisionalLoss + IonWallLoss;
		%%Calculate the change in the electron temperature
		PowerImbalance 			= 2/3*(PowerAbsorbed/(eV2J*Volume) - PowerLoss);
		dTe 					= 1/Density(e_index)*(PowerImbalance-dDensity(e_index)*Te);
		%%Repack dY
		dy 						= zeros(length(y),1);
		dy(1:end-1) 			= dDensity;
		dy(end) 				= dTe;
		%%Calculate the per-second 'error'
		Error					= max([abs(dTe)./Te; abs(dDensity)./Density]);
		ErrorMonitor(:,Count) 	= [t; abs(dTe)./Te; abs(dDensity)./Density]; %Error monitor
		%%Add one to the count of successful steps
		Count 					= Count + 1;
	end
	function [ErrorToleranceReached,isterminal,direction] = Evaluation_CheckConvergence(t,y)
		ErrorToleranceReached = double(Error > ConvergencePrecision); %Report zero when error is less than ConvergencePrecision
		isterminal 	= 1; %ErrorToleranceReached == 0 will stop evaluation
		direction 	= 0; %Doesn't matter which direction the zero is approached from
	end
	function StopIntegration = CountMonitor(~,~,flag)
		persistent MaxEvaluations Count2
		switch flag
		case 'init'
			MaxEvaluations = Controller.Solver.MaxEvaluations;
			Count2 = 1;
			Controller.H.GUI_6_TimerString.String = {'Evaluating';datestr(now-Controller.Solver.EvaluationStartTime,'MM:SS.FFF')}; pause(1e-3)
			StopIntegration = false;
		case 'done'
			switch ConvergenceMode
			case 'Manual'
					Converged = NaN;
			case 'Auto'
				if double(Error < ConvergencePrecision)
					Converged = 1;
					[RateCoeff,Energy,uBohm] = Evaluate_Te_dependent_vectors(Reaction_ratecoeff_vector,Reaction_energy_vector,Species_ionic_uBohm_vector,Te);
					NegativeRateIndices = find(RateCoeff<0)';
					if length(NegativeRateIndices)
						for index = NegativeRateIndices
							warning('Reaction %s had k<0, was set to zero',Controller.Reaction_I2E.Key(index))
						end
					end
				else
					ErrorMonitor(:,Count:end) 	= [];
					Converged = CheckFinalStep(Controller,ConvergencePrecision,ErrorMonitor);
				end
			end
		otherwise
			Count2 = Count2 + 1;
			if sum(Density<0) || Te <0 || ~isreal(ErrorMonitor(:,Count-1))
				StopIntegration = true;
				CheckIllegalSystemConditions(Controller,Density,Te,ErrorMonitor,Count)
			end
			if Count >= MaxEvaluations || Controller.Solver.EvaluationCancel
				StopIntegration = true;
			else
				if Count2 > 100
					Controller.H.GUI_6_TimerString.String = {'Evaluating';datestr(now-Controller.Solver.EvaluationStartTime,'MM:SS.FFF')}; pause(1e-3)
					for index = 1:length(SS.dn_indices)
						RateVector{SS.dn_indices(index)} = eval(SS.dn_rates{index});
					end
					Count2 = 0;
				end
				StopIntegration = false;
			end
		end
	end
end
function [RateCoeff,Energy,uBohm] = Evaluate_Te_dependent_vectors(Reaction_ratecoeff_vector,Reaction_energy_vector,Species_ionic_uBohm_vector,Te)
	RateCoeff = zeros(length(Reaction_ratecoeff_vector),1);
	for RateIndex = 1:length(Reaction_ratecoeff_vector)
		RateCoeff(RateIndex) = Reaction_ratecoeff_vector{RateIndex}(Te);
	end
	Energy = zeros(length(Reaction_energy_vector),1);
	for EnergyIndex = 1:length(Reaction_energy_vector)
		Reaction_energy_vectorEntry = Reaction_energy_vector{EnergyIndex};
		if isfloat(Reaction_energy_vectorEntry)
			Energy(EnergyIndex) = Reaction_energy_vectorEntry;
		else
			Energy(EnergyIndex) = Reaction_energy_vectorEntry(Te);
		end
	end
	uBohm = zeros(length(Species_ionic_uBohm_vector),1);
	for uBohmIndex = 1:length(Species_ionic_uBohm_vector)
		uBohm(uBohmIndex) = Species_ionic_uBohm_vector{uBohmIndex}(Te);
	end
end
function Return_Display_dict = Display_dict(Dictionary,Controller)
	element_list    = LIST_C;
	for Key = Dictionary.keys
		Value = Dictionary(Key{:});
		element_list.append(sprintf('%s: %s',Key{:},num2str(Value(Controller.Solver.GasSupplyIndex))));
	end
	Return_Display_dict = strjoin(element_list.list,', ');
end
function CheckIllegalSystemConditions(Controller,Density,Te,ErrorMonitor,Count)
	if sum(Density<0)
		NegativeIndices = find(Density<0);
		NegSpecies = Controller.Species_I2E.Key(NegativeIndices(1));
		warning('GUI_control:SolveBalanceEquations:IllegalSystemConditions','%s reached negative density',NegSpecies)
	elseif Te < 0
		warning('GUI_control:SolveBalanceEquations:IllegalSystemConditions','Negative electron temperature reached')
	elseif ~isreal(ErrorMonitor(:,Count-1))
		warning('GUI_control:SolveBalanceEquations:IllegalSystemConditions','Derivative is non-real')
	else
		error('GUI_control:SolveBalanceEquations:IllegalSystemConditions did not detect which error case to report')
	end
end