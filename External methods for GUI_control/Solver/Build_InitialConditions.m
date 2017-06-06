function InitialConditions = Build_InitialConditions(Controller)
	SS 							= Controller.Solver.SystemStruct;
	ES							= Controller.Solver.ExperimentStruct;
	InitialConcentration 		= build_ReactantConcentration(Controller,SS);
	InitialTe 					= find_InitialTe(Controller,SS,ES,InitialConcentration);
	InitialConditions 			= [InitialConcentration;InitialTe];
end
function ReactantDensity = build_ReactantConcentration(Controller,SS)
	ReactantDensity = zeros(length(SS.Species_I2E),1);
	for SpeciesIndex = 1:length(SS.Species_I2E);
		Species 	= Controller.SpeciesDB.Key(SS.Species_I2E.Key(SpeciesIndex));
		ReactantDensity(SpeciesIndex) 	= Species.n;
	end
end
function Te = find_InitialTe(Controller,SS,ES,InitialConcentration)
	load('physicalconstants','eV2J','m_e')
	persistent TS
	if isempty(TS) || SS.RecalculateTe
		TS 					= struct;
		TS.TeList 			= 10.^[-1:0.005:1.5];
		TS.RateMatrix		= zeros(length(SS.Reaction_ratecoeff_vector),length(TS.TeList));
		DensityFactor 	= evaluate_PowerProduct(SS.ReactantMatrix,InitialConcentration);
		for index = 1:length(TS.TeList)
			RateCoeff = zeros(length(SS.Reaction_ratecoeff_vector),1);
			for RateIndex = 1:length(SS.Reaction_ratecoeff_vector)
				RateCoeff(RateIndex) = SS.Reaction_ratecoeff_vector{RateIndex}(TS.TeList(index));
			end
			ReactionRate 			= RateCoeff.*DensityFactor;
			TS.RateMatrix(:,index) 	= ReactionRate;
		end
	end
	PowerLoss 							= zeros(1,length(TS.TeList));
	for index = 1:length(TS.TeList)
		Te 						= TS.TeList(index);
		[Energy,uBohm] 			= Evaluate_Te_dependent_vectors(SS.Reaction_energy_vector,SS.Species_ionic_uBohm_vector,Te); %%!!Different from form in SolveBalanceEquations.m
		%%Loss due to electron collisions
		ElectronCollisionalLoss = sum(SS.Reaction_inelastic_marker.*TS.RateMatrix(:,index).*Energy); %Will return in Watts
		%%Loss due to ion-electron loss at walls
		BohmDensityProduct 		= uBohm.*InitialConcentration(logical(SS.Species_ionic_marker));
		WallLossEnergy 			= -log(4*BohmDensityProduct/(InitialConcentration(SS.e_index)*sqrt(8*eV2J*Te/(pi*m_e))))+2.5;
		IonWallLoss 			= Te * sum(SS.A_eff.*BohmDensityProduct.*WallLossEnergy)/Controller.Reactor.Volume;
		%%Total loss
		PowerLoss(index)		= ElectronCollisionalLoss + IonWallLoss;
    end
	[~,Te_index] = min(abs(PowerLoss-ES.PowerAbsorbed(Controller.Solver.PowerAbsorbedIndex)/(eV2J*Controller.Reactor.Volume)));
	disp(sprintf('Initial electron temperature set to %s eV',num2str(TS.TeList(Te_index))))
	Te = TS.TeList(Te_index);
end
function [Energy,uBohm] = Evaluate_Te_dependent_vectors(Reaction_energy_vector,Species_ionic_uBohm_vector,Te)
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