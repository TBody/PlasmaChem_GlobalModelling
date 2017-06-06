classdef DATABASE_C < handle
	%DATABASE_C provides a dictionary with enhanced add and display functions
	%WARNING: requires all objects to have 'Key' as a property
	%	Properties
	%		DictForm	 	- containers.Map form, mutable for handle-class objects
	%	Properties (Dependent) - IMMUTABLE so are computed when called (WARNING - do not assign these forms)
	%		StructForm 		- indexed for easier computation, but not easily readable
	%		TableForm  		- readable form (returned by disp())
	%	Methods
	%		Constructor - provides DictForm, takes as arguments KeyList and ObjectList
	%		get.StructForm  - provides StructForm from DictForm
	%		get.TableForm 	- provides TableForm from StructForm
	%		disp()			- prints TableForm

	properties
		DictForm
	end
	properties(Dependent)
		StructForm
		TableForm
	end

	methods
	%Core constructor, get and disp functions
		function add(obj,Key,Object)
			obj.DictForm(char(Key)) = Object;
		end
		function rename(obj,OldKey,NewKey)
			Object = obj.Key(OldKey);
			Object.Key = NewKey;
			obj.add(NewKey,Object);
			obj.remove(OldKey);
		end
		function obj = DATABASE_C(KeyList,ObjectList)
			obj.DictForm = containers.Map('KeyType','char','ValueType','any');
			iterator = 1;
			if nargin == 0
				KeyList = [];
			end
			for Key = KeyList
				obj.add(Key,ObjectList(iterator))
				iterator = iterator+1;
			end
		end
		function StructForm = get.StructForm(obj)
			warning('off','MATLAB:structOnObject')
			StructBuild = [];
			for Key = obj.KeyList
				Key = char(Key);
				StructBuild=[StructBuild,obj.DictForm(Key).StructForm];
			end
			StructForm = StructBuild;
		end
		function TableForm = get.TableForm(obj)
			StructBuild	= obj.StructForm;
			FieldNames = fieldnames(StructBuild)';
			for Field = FieldNames
				if iscell(StructBuild(1).(Field{1}))
					for index = 1:length(StructBuild)
						StructBuild(index).(Field{1}) = strjoin(StructBuild(index).(Field{1}),', '); %Convert cell arrays to strings, for printing
					end
				end
			end
			TableForm = struct2table(StructBuild);
		end
		function disp(obj)
			try
				disp(obj.TableForm)
			catch
				KeyList = strjoin(obj.KeyList,', ');
				disp(sprintf('Database with keys: %s',KeyList));
			end
		end
		function ExportTable(obj)
			[Filename,Path] = uiputfile('*.txt','Select export location');
			if Filename
				writetable(obj.TableForm,[Path,Filename],'Delimiter','tab');
			end
		end
	%Modify functions
		function remove(obj,Key)
			%Deletes the element corresponding to the supplied key
			remove(obj.DictForm,char(Key));
		end
		function Return_KeyExists = KeyExists(obj,Key)
			%Checks whether there is an element corresponding to the supplied key
			Return_KeyExists = isKey(obj.DictForm,char(Key));
		end
		function Return_Key = Key(obj,Key)
			%Returns the database element corresponding to the supplied key
			Return_Key = obj.DictForm(char(Key));
		end
	%For processing
		function Return_KeyList = KeyList(obj,index)
			%Returns the list of keys
			if nargin == 1
				Return_KeyList = keys(obj.DictForm);
			elseif nargin == 2
				KeyList = keys(obj.DictForm);
				Return_KeyList = KeyList(index);
			else
				error('Incorrect number of inputs')
			end
		end
		function Return_Length  = length(obj)
			%Returns the number of keys
			Return_Length  = length(obj.KeyList);
		end
	end
end