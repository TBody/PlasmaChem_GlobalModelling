function [Reaction_ratecoeff_vector,dn_indices,dn_rates] = build_Reaction_ratecoeff_vector(Reaction_I2E,Controller)
	load('physicalconstants')
	Reaction_ratecoeff_vector 						= cell(length(Reaction_I2E),1);
	dn_indices 						= [];
	dn_rates 						= {};
	for ReactionIndex 				= 1:length(Reaction_I2E)
		EvaluateReactionIndex		= true;
		ReactionKey 				= Reaction_I2E.Key(ReactionIndex);
		Reaction 					= Controller.ReactionDB.Key(ReactionKey);
		[Rate,FlagRate] 			= UI_interpreter_keepflag(Reaction.RateCoefficientForm);
		if strfind(Rate,'Tg')
			Rate = GasTemperature(Rate,Reaction,Controller);
			FlagRate = true;
		end
		if strfind(Rate,'MFP')
			Rate = MeanFreePath(Rate,Reaction,Controller);
			FlagRate = true;
		end
		if FlagRate
			nDependentRate = Rate;
			nFlag = false;
			Tokens 	= regexp(Rate,'<(.*?)>','tokens');
			for token = Tokens
				TokenString = char(token{:});
				try
					EvaluatedToken = eval(TokenString);
				catch ME
					error(sprintf('The rate for %s cannot be interpreted\n - Invalid token: %s\n - %s',ReactionKey,TokenString,ME.message));
				end
				switch class(EvaluatedToken)
				case 'double'
					TokenEvaluation = num2str(EvaluatedToken);
				case 'char'
					TokenEvaluation = EvaluatedToken;
				case ''
					switch class(EvaluatedToken)
					case 'double'
						TokenEvaluation = num2str(EvaluatedToken);
					case 'char'
						TokenEvaluation = EvaluatedToken;
					otherwise
						warning('Class %s not recognised',class(EvaluatedToken))
					end
				case 'function_handle'
					Reaction_ratecoeff_vector{ReactionIndex} 	= eval(TokenString);
					EvaluateReactionIndex		= false;
					break
				end
				if ~isempty(strfind(TokenString,'.MFP')) || ~isempty(strfind(TokenString,'.D'))
					nDependentRate = strrep(Rate,['<',TokenString,'>'],['(',TokenString,')']);
					nFlag = true;
				else
					nDependentRate = strrep(Rate,['<',TokenString,'>'],['(',TokenEvaluation,')']);
				end
				Rate = strrep(Rate,['<',TokenString,'>'],['(',TokenEvaluation,')']);
			end
			if nFlag
				dn_indices = [dn_indices,ReactionIndex];
				dn_rates = [dn_rates,['@(Te)',nDependentRate]];
			end
		end
		if EvaluateReactionIndex
			Reaction_ratecoeff_vector{ReactionIndex} 	= eval(['@(Te)',Rate]); %Will be a series of functions in terms of Te
		end
	end
end
function ReturnString = GasTemperature(InputString,Reaction,Controller)
	load('physicalconstants')
	Reactants = LIST_C(Reaction.ReactantSpeciesDict.keys);
	Reactants.remove('wall');
	GasTemperature 	= [];
	ReactantDensity = [];
	for Reactant = Reactants.list
		GasTemperature 	= [GasTemperature,Controller.SpeciesDB.Key(Reactant).T*Reaction.ReactantSpeciesDict(Reactant{:})];
		ReactantDensity = [ReactantDensity,Controller.SpeciesDB.Key(Reactant).n*Reaction.ReactantSpeciesDict(Reactant{:})];
	end
	GasTemperature = mean(GasTemperature.*(ReactantDensity./sum(ReactantDensity)))*k_B_eV^-1; %Density-weighted average of gas temperature
	ReturnString = strrep(InputString,'Tg',num2str(GasTemperature));
end
function ReturnString = MeanFreePath(InputString,Reaction,Controller)
	Reactants = LIST_C(Reaction.ReactantSpeciesDict.keys);
	Reactants.remove('wall');
	Numerator = {};
	Denominator = {};
	for Reactant = Reactants.list
		Species = sprintf('Controller.SpeciesDB.Key(''%s'')',Reactant{:});
		Numerator = [Numerator,sprintf('%s.n*%s.MFP',Species,Species)];
		Denominator = [Denominator,sprintf('%s.n',Species)];
	end
	ReturnString = strrep(InputString,'MFP',sprintf('(%s)/(%s)',strjoin(Numerator),strjoin(Denominator)));
end
function ReturnString = Exp2Methods(InputString)
	StringBuild = InputString;
	StringBuild = strrep(StringBuild,'*','.*');
	StringBuild = strrep(StringBuild,'/','./');
	StringBuild = strrep(StringBuild,'^','.^');
	ReturnString = strrep(StringBuild,'..','.');
end