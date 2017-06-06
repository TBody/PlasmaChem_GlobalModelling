function ES = Precalculate_ExperimentStruct(Controller)
	ES 									= struct;
	ES.PowerAbsorbed					= Controller.Experiment.PowerAbsorbed;
	[ES.PumpInMatrix,ES.PumpOutMatrix] 	= build_PumpingMatrices(Controller,ES);
	Controller.Global.ExperimentUpdated = false;
end
function [PumpInMatrix,PumpOutMatrix] = build_PumpingMatrices(Controller,ES)
	StartingPressureLength 	= length(Controller.Experiment.StartingPressure);
	GasSupplyLength 		= unique(cellfun(@length,Controller.Experiment.GasSupply.values));
	PumpOutMatrix 			= zeros(length(Controller.Species_I2E),StartingPressureLength,GasSupplyLength);
	PumpInMatrix 			= zeros(length(Controller.Species_I2E),GasSupplyLength);
	for GasSupplyIndex = 1:GasSupplyLength
		for StartingPressureIndex = 1:StartingPressureLength
			PumpOutMatrix(:,StartingPressureIndex,GasSupplyIndex) = Controller.Experiment.k_pump_out(StartingPressureIndex,GasSupplyIndex);
		end
		for SpeciesIndex = 1:length(Controller.Species_I2E)
			Species 	= Controller.SpeciesDB.Key(Controller.Species_I2E.Key(SpeciesIndex));
			if Controller.Experiment.GasSupply.isKey(Species.Key)
				R_pump_in = Controller.Experiment.R_pump_in(Species.Key);
				PumpInMatrix(SpeciesIndex,GasSupplyIndex) = R_pump_in(GasSupplyIndex);
			end
			if strcmp(Species.Type,'Negative Ion') || strcmp(Species.Type,'Electron') || strcmp(Species.Type,'Surface')
				PumpOutMatrix(SpeciesIndex,:,:) = 0;
			end
		end
	end
end