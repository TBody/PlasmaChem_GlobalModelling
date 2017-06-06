function SS = Precalculate_SystemStruct(Controller)
	load('physicalconstants','eV2J')
	SS 									= struct;
	SS.Species_I2E						= Controller.Global.SpeciesFoundList;
	if ~ismember(SS.Species_I2E,'e'); SS.Species_I2E.append('e'); end
	if ~ismember(SS.Species_I2E,'F_s'); SS.Species_I2E.append('F_s'); end
	Controller.Species_I2E 										= SS.Species_I2E;
	SS.Reaction_I2E 											= Controller.Global.ReactionFoundList;
	Controller.Reaction_I2E 									= SS.Reaction_I2E;
	[SS.Reaction_ratecoeff_vector,SS.dn_indices,SS.dn_rates]				= build_Reaction_ratecoeff_vector(SS.Reaction_I2E,Controller);
	[SS.ReactantMatrix,SS.ProductMatrix,SS.ProductionMatrix] 	= build_particle_balance_Matrices(Controller,SS);
	[SS.Species_charge_vector,SS.e_index,SS.Species_surface_marker,SS.Fs_index,... 													  %%Vectors that have dimension equal to the number of species
	SS.Species_ionic_uBohm_vector,SS.Species_ionic_marker] 							= build_Boolean_alpha_vectors(Controller,SS); %%Vectors that have dimension equal to the number of ionic species
	[SS.Reaction_inelastic_marker,SS.Reaction_energy_vector] 							= build_Boolean_gamma_vectors(Controller,SS); %%Vector that have dimensions equal to the number of reactions
	SS.A_eff 													= build_effective_area_for_ion_loss(Controller,SS);
	SS.SparseJacobianMatrix 									= build_Jacobian_sparse_matrix(Controller,SS);
	SS.RecalculateTe											= 1;
	Controller.Global.SystemUpdated 							= false; %%Set the global state to "System initialised" - preventing having to re-precalculate static forms
end
function [ReactantMatrix,ProductMatrix,ProductionMatrix] = build_particle_balance_Matrices(Controller,SS)
	%%Pre-allocate as all zeros
	ReactantMatrix	= zeros(length(SS.Reaction_I2E),length(SS.Species_I2E));
	ProductMatrix 	= zeros(length(SS.Reaction_I2E),length(SS.Species_I2E));
	%%Find non-zero terms
	for ReactionIndex 	= 1:length(SS.Reaction_I2E);
		Reaction 		= Controller.ReactionDB.Key(SS.Reaction_I2E.Key(ReactionIndex));
		for SpeciesIndex 	= 1:length(SS.Species_I2E);
			SpeciesKey 					= SS.Species_I2E.Key(SpeciesIndex);
			if Reaction.ReactantSpeciesDict.isKey(SpeciesKey)
				ReactantMatrix(ReactionIndex,SpeciesIndex)	= Reaction.ReactantSpeciesDict(SpeciesKey);
			end
			if Reaction.ProductSpeciesDict.isKey(SpeciesKey)
				ProductMatrix(ReactionIndex,SpeciesIndex)	= Reaction.ProductSpeciesDict(SpeciesKey);
			end
		end
	end
	%%Calculate the transpose matrices
	LossMatrix 			= ReactantMatrix'; 
	GenerationMatrix 	= ProductMatrix';
	ProductionMatrix 	= GenerationMatrix-LossMatrix;
end
function [Species_charge_vector,e_index,Species_surface_marker,Fs_index,Species_ionic_uBohm_vector,Species_ionic_marker] = build_Boolean_alpha_vectors(Controller,SS)
	Species_charge_vector = zeros(length(SS.Species_I2E),1);
	Species_surface_marker = zeros(length(SS.Species_I2E),1);
	Species_ionic_marker 	= zeros(length(SS.Species_I2E),1);
	Species_ionic_uBohm_vector 	= cell(length(SS.Species_I2E),1);
	for SpeciesIndex = 1:length(SS.Species_I2E);
		Species 	= Controller.SpeciesDB.Key(SS.Species_I2E.Key(SpeciesIndex));
		%%Quasineutrality balance
		if strcmp(Species.Type,'Electron')
			e_index = SpeciesIndex;
		else
			%Don't give electron an entry in this vector, since otherwise will always need to remove when calculating QN
			Species_charge_vector(SpeciesIndex) = Species.q;
		end
		%%Surface species balance
		if strcmp(Species.Type,'Surface')
			if strcmp(Species.Key,'F_s')
				Fs_index = SpeciesIndex;
			else
				%Similar reasoning to above - don't consider Fs as surface site to simplify calc
				Species_surface_marker(SpeciesIndex) = 1;
			end
		end
		%%Positively charged species for power balance
		if strcmp(Species.Type,'Positive Ion')
			Species_ionic_uBohm_vector{SpeciesIndex} 	= eval(['@(Te)',Species.u_Bohm]);
			Species_ionic_marker(SpeciesIndex) = 1;
		end
	end
	Species_ionic_uBohm_vector = Species_ionic_uBohm_vector(logical(Species_ionic_marker));
end
function [Reaction_inelastic_marker,Reaction_energy_vector] = build_Boolean_gamma_vectors(Controller,SS)
	load('physicalconstants')
	syms Te
	Reaction_energy_vector 	= cell(length(SS.Reaction_I2E),1);
	Reaction_inelastic_marker 		= zeros(length(SS.Reaction_I2E),1);
	for ReactionIndex = 1:length(SS.Reaction_I2E)
		ReactionKey = SS.Reaction_I2E.Key(ReactionIndex);
		Reaction 					= Controller.ReactionDB.Key(ReactionKey);
		if Reaction.ReactantSpeciesDict.isKey('e');
			Reaction_inelastic_marker(ReactionIndex) = 1;
		end
		[Energy,FlagEnergy] 		= UI_interpreter_unitless(Reaction.E);
		if FlagEnergy
			Energy = char(eval(Energy)); %These functions depend on methods that are not copyable
			Reaction_energy_vector{ReactionIndex} = eval(['@(Te)',Energy]);
		else
			Reaction_energy_vector{ReactionIndex} = eval(Energy); %Make a function of Te to account for elastic rates
		end
	end
end
function A_eff = build_effective_area_for_ion_loss(Controller,SS)
	ReactantMFP 	= zeros(length(SS.Species_I2E),1);
	for SpeciesIndex = 1:length(SS.Species_I2E);
		Species 	= Controller.SpeciesDB.Key(SS.Species_I2E.Key(SpeciesIndex));
		switch Species.Type
		case 'Electron'
			ReactantMFP(SpeciesIndex) 	= 0;
		case 'Surface'
			ReactantMFP(SpeciesIndex) 	= 0;
		otherwise
			ReactantMFP(SpeciesIndex) 	= Species.MFP;
		end
	end
	IonicMFP 							= ReactantMFP(logical(SS.Species_ionic_marker))';
	A_eff								= Controller.Reactor.A_eff(IonicMFP)';
end
function SparseJacobianMatrix = build_Jacobian_sparse_matrix(Controller,SS)
	SpeciesInterdependency = SS.ProductionMatrix*SS.ReactantMatrix;
	Te_row = SS.Species_ionic_marker' + SS.Reaction_inelastic_marker' * SS.ReactantMatrix;
	Te_row(SS.e_index) = 1;
	Te_column = ones(length(SS.Species_I2E)+1,1);
	SparseJacobianMatrix = logical([[SpeciesInterdependency;Te_row],Te_column]);
end