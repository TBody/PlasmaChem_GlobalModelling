function [ReturnString,Flag] = UI_interpreter_keepflag(InputString)
	ReturnString = InputString;
	Flag 	= false;
	Tokens 	= regexp(InputString,'<(.*?)>','tokens'); %regexp(SampleString,'<(.[^>]*)>','tokens') also works
	if ~isempty(Tokens);
		Flag = true;
		for token = Tokens
			TokenString = char(token{:});
			Keys = regexp(TokenString,'\:(.*)\.','tokens'); %Using escapes (\) to prevent regexp from interpreting the 'brackets' (: and .)
			for Key = Keys
				OldKeyString = char(Key{:});
				NewKeyString = strrep(char(Key{:}),'''','''''');
				TokenString = strrep(TokenString,[':',OldKeyString],sprintf('.Key(''%s'')',NewKeyString));
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
			otherwise
				error('Controller property not recognised by UI_interpreter')
			end
			TokenString = strjoin(TokenSplit,'.');
			ReturnString = strrep(ReturnString,char(token{:}),['(',TokenString,')']);
		end
		ReturnString = strrep(ReturnString,'*','.*');
		ReturnString = strrep(ReturnString,'/','./');
		ReturnString = strrep(ReturnString,'^','.^');
	end
end