function [ReturnString,Flag] = UI_interpreter_unitless(InputString)
	ReturnString = InputString;
	if isnumeric(ReturnString)
		ReturnString = num2str(ReturnString);
	end
	Flag    = false;
	Tokens  = regexp(ReturnString,'<(.*?)>','tokens'); %regexp(SampleString,'<(.[^>]*)>','tokens') also works
	if ~isempty(Tokens);
		Flag = true;
		for token = Tokens
			TokenString = char(token{:});
			Keys = regexp(TokenString,'\:(.*)\.','tokens'); %Using escapes (\) to prevent regexp from interpreting the 'brackets' (: and .)
			for Key = Keys
				KeyString = char(Key{:});
				TokenString = strrep(TokenString,[':',KeyString],sprintf('.Key(''%s'')',KeyString));
			end
			TokenSplit = strsplit(TokenString,'.');
			switch TokenSplit{1}
			case 'G'
				TokenSplit(1) = cellstr('Controller.Global');
			case 'R'
				TokenSplit(1) = cellstr('Controller.Reactor');
			case 'E'
				TokenSplit(1) = cellstr('Controller.Experiment');
			case 'RR'
				TokenSplit(1) = cellstr('Controller.ReactionDB');
			case 'S'
				TokenSplit(1) = cellstr('Controller.SpeciesDB');
			case 'C'
				TokenSplit(1) = cellstr('Controller.CrosssectionDB');
			case 'P'
				TokenSplit(1) = []; %Physicalconstants
			otherwise
				error('Controller property not recognised by UI_interpreter')
			end
			TokenSplit{end} = TokenSplit{end};
			if length(TokenSplit) > 1
				TokenString 	= strjoin(TokenSplit,'.');
			else
				TokenString 	= TokenSplit{1};
			end
			ReturnString 	= strrep(ReturnString,['<',char(token{:}),'>'],['(',TokenString,')']);
		end
		ReturnString = strrep(ReturnString,'*','.*');
		ReturnString = strrep(ReturnString,'/','./');
		ReturnString = strrep(ReturnString,'^','.^');
	end
end