classdef EXPERIMENT_C <handle
	%EXPERIMENT Reactor parameters which may be varied between runs

	properties
		Key
		Reactor
		PowerAbsorbed
		%DutyCycle
		%PowerFreq
		StartingPressure
		OutletPressure
		GasSupply
	end
	properties(Dependent)
		R_pump_in
		k_pump_out
	end
	methods
		function obj = EXPERIMENT_C
			obj.Key = NaN;
		end
		function Return_R_pump_in = get.R_pump_in(obj)

			R_pump_in = containers.Map;
			for SupplySpecies   = obj.GasSupply.keys
				R_pump_in(SupplySpecies{:}) = 4.483e+17.*obj.GasSupply(SupplySpecies{:})./obj.Reactor.Volume;
			end
			Return_R_pump_in    = R_pump_in;
		end
		function Return_k_pump_out = get.k_pump_out(obj)
			%Returns the effective rate co-efficient for pumping out (for all positive or neutral species)
			%   - multiply by species density to return the effective rate
			%   - from Thorsteinsson PhD Thesis
			pump_in_total = 0;
			for GasSupply = obj.GasSupply.values
				pump_in_total = pump_in_total + GasSupply{:};
			end
			ConstantTerms = 1.27e-5;
			VectorTerms = zeros(length(obj.OutletPressure),length(pump_in_total));
			V_pump_in_total 	= pump_in_total;
			V_OutletPressure 	= obj.OutletPressure;
			V_ReactorVolume 	= obj.Reactor.Volume;
			for StartingPressureIndex = 1:length(obj.OutletPressure)
				for GasSupplyIndex = 1:length(pump_in_total)
					VectorTerms(StartingPressureIndex,GasSupplyIndex) = V_pump_in_total(GasSupplyIndex)/(V_OutletPressure(StartingPressureIndex)*V_ReactorVolume);
				end
			end
			Return_k_pump_out = VectorTerms.*ConstantTerms;
		end
		function Return_OutletPressure = get.OutletPressure(obj)
			%While main chamber pressure is more readily accessible most formulae refer instead to the 'outlet pressure'. This calculates that quantity from rate balancing;
			load('physicalconstants','Torr2Pa','k_B_J')
			Return_OutletPressure = 1.27e-5./4.483e+17.*obj.StartingPressure.*Torr2Pa./(k_B_J.*300);
		end
		function StructForm = StructForm(obj)
			warning('off','MATLAB:structOnObject')
			StructForm = struct(obj);
		end
		function Return_Display_dict = Display_dict(obj,Dictionary)
			element_list    = LIST_C;
			for Key = Dictionary.keys
				Value = Dictionary(Key{:});
				element_list.append(sprintf('%s: %s',Key{:},num2str(Value)));
			end
			Return_Display_dict = strjoin(element_list.list,', ');
		end
		function TableForm = TableForm(obj)
			warning('off','MATLAB:structOnObject')
			StructForm = rmfield(obj.StructForm,{'Reactor','R_pump_in','k_pump_out'});%,'DutyCycle','PowerFreq'});
			StructForm.GasSupply = obj.Display_dict(obj.GasSupply);
			TableForm = struct2table(StructForm);
		end
		function disp(obj)
			StructForm = rmfield(obj.StructForm,{'Reactor','R_pump_in','k_pump_out'});%,'DutyCycle','PowerFreq'});
			for property = fieldnames(StructForm)'
				if isa(StructForm.(property{:}),'')
					StructForm.(property{:}) = StructForm.(property{:}).value; %Should return a string which can be displayed
				end
			end
			StructForm.GasSupply = obj.Display_dict(obj.GasSupply);
			disp(StructForm)
		end
	end
end