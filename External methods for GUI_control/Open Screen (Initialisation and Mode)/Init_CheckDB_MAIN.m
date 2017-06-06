function [CheckPassed,ReturnString] = Init_CheckDB_MAIN(Source,Event)
	%disp('Init_CheckDB_MAIN called')
	if exist('DB_MAIN.mat','file')
		DB_MAIN_exists = true;
		load DB_MAIN
	else
		DB_MAIN_exists = false;
		ReturnString = 'DB_MAIN not found';
		CheckPassed = false;
		return
	end
	if exist('CrosssectionDB.mat','file')
		CrosssectionDB_exists = true;
		load CrosssectionDB
	else
		CrosssectionDB_exists = false;
		ReturnString = 'CrosssectionDB not found';
		CheckPassed = false;
		return
	end
	if DB_MAIN_exists && CrosssectionDB_exists
		if exist('ReactionDB_MAIN','var') && exist('SpeciesDB_MAIN','var') & exist('CrosssectionDB','var')
			DB_elements_exists = true;
		else
			DB_elements_exists = false;
			ReturnString = 'DB_MAIN err: bad elements';
			CheckPassed = false;
			return
		end
	end
	if DB_elements_exists
		if length(ReactionDB_MAIN) > 0 && length(SpeciesDB_MAIN) > 0 & length(CrosssectionDB) > 0
			DB_elements_populated = true;
		else
			DB_elements_populated = false;
			ReturnString = 'Warning: empty databases';
			CheckPassed = false;
			return
		end
	end
	if DB_MAIN_exists && DB_elements_exists && DB_elements_populated && CrosssectionDB_exists
		CheckPassed = true;
		ReturnString = 'Check passed';
	else
		CheckPassed = false;
	end	
end