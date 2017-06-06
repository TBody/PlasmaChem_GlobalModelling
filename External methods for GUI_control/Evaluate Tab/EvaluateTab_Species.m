function ProceedAllowed = EvaluateTab_Species(Controller)
	%disp('EvaluateTab_Species called')
	Controller.Global.SystemUpdated = true;
	disp('Evaluating species')
	if Controller.Global.SpeciesUpdated
		disp(' - loading DB_MAIN')
		load('DB_MAIN','SpeciesDB_MAIN');
		disp(' - saving species to DB_MAIN')
		for SpeciesKey = Controller.SpeciesDB.KeyList
			Species = Controller.SpeciesDB.Key(SpeciesKey);
			SpeciesDB_MAIN.add(Species.Key,Species); %Also updates
		end
		save('Databases/DB_MAIN','SpeciesDB_MAIN','-append');
		Controller.Global.SpeciesUpdated = false;
	end
	if Controller.SpeciesDB.KeyExists('e')
		Controller.SpeciesDB.remove('e'); %Clear electron from database - since this will cause issues with eval
	end
	if Controller.SpeciesDB.KeyExists('F_s')
		Controller.SpeciesDB.remove('F_s'); %Clear surface species from database - since this will cause issues with eval
	end
	disp(' - calculating mean free paths')
	generate_Species_MFP(Controller);
	disp(' - adding electrons to SpeciesDB')
	generate_Electron_Species(Controller);
	disp(' - adding surface sites to SpeciesDB')
	generate_Surface_Species(Controller);
	disp(' - done')
	ProceedAllowed = true;
end
function generate_Species_MFP(Controller)
	for SpeciesKey  = Controller.SpeciesDB.KeyList
		Species     = Controller.SpeciesDB.Key(SpeciesKey);
		%UNIT Check% InverseScatteringSum = (0,1/m);
		InverseScatteringSum = 0;
		for Species2Key  = Controller.SpeciesDB.KeyList
			Species2     = Controller.SpeciesDB.Key(Species2Key);
			%UNIT Check% InverseScatteringSum = InverseScatteringSum + Species2.n.*pi.*(Species.vdW_Area+Species2.vdW_Area+2.*sqrt(Species.vdW_Area.*Species2.vdW_Area));
			InverseScatteringSum = InverseScatteringSum + Species2.n*(Species.vdW_Area+Species2.vdW_Area+2*sqrt(Species.vdW_Area*Species2.vdW_Area));
		end
		Species.MFP = InverseScatteringSum.^-1;
	end
end
function generate_Electron_Species(Controller)
	load('physicalconstants','m_e')
	ElectronDensity = 0;
	PositiveIonDensity = 0;
	NegativeIonDensity = 0;
	for SpeciesKey 	= Controller.SpeciesDB.KeyList
		Species 	= Controller.SpeciesDB.Key(SpeciesKey);
		if ~strcmp(Species.Type,'Electron')
			ElectronDensity = ElectronDensity + Species.n.*Species.q;
		end
		% switch Species.Type
		% case 'Positive Ion'
		% 	PositiveIonDensity = PositiveIonDensity + Species.n;
		% case 'Negative Ion'
		% 	NegativeIonDensity = NegativeIonDensity + Species.n;
		% case 'Neutral'
		% 	continue
		% case 'Surface'
		% 	continue
		% otherwise
		% 	error(sprintf('Error in generate_Electron_Species<EvaluateTab_Species: species type %s not recognised',Species.Type))
		% end
	end
	% disp(sprintf('Electron density: %e', ElectronDensity))
	% disp(sprintf('Positive ion density: %e', PositiveIonDensity))
	% disp(sprintf('Negative ion density: %e', NegativeIonDensity))
	% disp(sprintf('Total charge: %e', ElectronDensity + NegativeIonDensity - PositiveIonDensity))
	Electron = SPECIES_C('e',m_e,-1,ElectronDensity,NaN,'Electron','Ground',0);
	Controller.SpeciesDB.add(Electron.Key,Electron);
end
function generate_Surface_Species(Controller)
	FreeSurfaceDensity = Controller.Reactor.S_T;
	for SpeciesKey 	= Controller.SpeciesDB.KeyList
		Species 	= Controller.SpeciesDB.Key(SpeciesKey);
		if strcmp(Species.Type,'Surface')
			FreeSurfaceDensity = FreeSurfaceDensity - Species.n;
		end
	end
	Surface = SPECIES_C('F_s',NaN,0,FreeSurfaceDensity,NaN,'Surface','Ground',0);
	Controller.SpeciesDB.add(Surface.Key,Surface);
end