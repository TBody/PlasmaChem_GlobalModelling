function Reaction_DB_Query(Controller)
	%disp('Reaction_DB_Query called')
	Controller.Global.ReactionFoundList 	= LIST_C;
	Controller.Global.ReactionNotFoundList  = LIST_C;
	ReactionCodeList 				= LIST_C(strtrim(strsplit(char(Controller.H.ReactionCodeList.String),','))).unique;
	try ReactionCodeList.remove(blanks(0));
	end
	if length(ReactionCodeList) == 0
		return %If Query called when no codes have been edited - ignore the call
	end
	disp('Loading reactions from DB_MAIN')
	try load('DB_MAIN','ReactionDB_MAIN')
	catch ME
		ReactionDB_MAIN = DATABASE_C;
		disp(ME.message);
	end
	for ReactionCode = ReactionCodeList.list;
		if sum(strfind(ReactionCode{:},'*'))
			RegExpCode = strrep(ReactionCode,'*','+');
			for ExistingCode = ReactionDB_MAIN.KeyList
				if regexp(ExistingCode{:},RegExpCode{:}) == 1
					Controller.Global.ReactionFoundList.append(ExistingCode{:});
					Controller.ReactionDB.add(ExistingCode{:},ReactionDB_MAIN.Key(ExistingCode{:}));
				end
			end
		elseif sum(strfind(ReactionCode{:},'[')) && sum(strfind(ReactionCode{:},']'))
			[Header,StartInt,StopInt] = ProcessReactionArray(ReactionCode{:});
			for Index = StartInt:StopInt
				IndexCode = [Header,num2str(Index)];
				ReactionCodeLookup(Controller,ReactionDB_MAIN,IndexCode);
			end
		else
			ReactionCodeLookup(Controller,ReactionDB_MAIN,ReactionCode)
		end
	end
	Reaction_UpdateListbox(Controller);
	disp(' - done')
end
function [Header,StartInt,StopInt]	 = ProcessReactionArray(ReactionCode)
	StrSplitReturn 	= strsplit(ReactionCode,'[');
	Header 			= StrSplitReturn{1};
	process 		= strsplit(StrSplitReturn{2},']');
	process 		= strsplit(process{1},'-');
	StartInt 		= str2num(process{1});
	StopInt 		= str2num(process{2});
end
function ReactionCodeLookup(Controller,ReactionDB_MAIN,Code)
	if ReactionDB_MAIN.KeyExists(Code)
		Controller.Global.ReactionFoundList.append(Code);
		Controller.ReactionDB.add(Code,ReactionDB_MAIN.Key(Code));
	else
		Controller.Global.ReactionNotFoundList.append(Code);
	end
end