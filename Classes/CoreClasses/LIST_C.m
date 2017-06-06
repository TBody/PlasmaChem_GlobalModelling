classdef LIST_C < handle
	%LIST provides python-like methods to LIST structure
	%Used for lists in GlobalModel.m

	properties
		DictForm
	end

	methods
		function obj = LIST_C(input_list)
			obj.DictForm = containers.Map('KeyType','double','ValueType','any');
			if nargin == 0
				input_list = [];
			end
			for element = input_list
				obj.append(element);
			end
		end

		function Return_list = list(obj)
			Return_list = obj.DictForm.values;
		end
		function disp(obj)
			if obj.length
				disp(list(obj))
			else
				disp('Null')
			end
		end
		function Return_length = length(obj)
			Return_length = length(obj.DictForm.keys);
		end
		function Return_append = append(obj,element)
			newindex = length(obj)+1;
			if strcmp(class(element),'cell')
					element = element{1}; %convert cell to char
			end
			obj.DictForm(newindex) = element;
			Return_append = obj;
		end
		function Return_extend = extend(obj,list)
			for element = list
				obj.append(element);
			end
			Return_extend = obj;
		end
		function insert(obj,element,index)
			if index > length(obj)
				error('Index is outside of list.')
			end
			for iterator = length(obj):-1:1
				if iterator == index
					obj.DictForm(iterator+1)=obj.DictForm(iterator);
					obj.DictForm(index) = element;
					break
				else
					obj.DictForm(iterator+1)=obj.DictForm(iterator);
				end
			end
		end
		function remove(obj,element)
			%May be issues with over-defining. Try varying calling command if there are issues.
			remove_index = obj.index(element);
			if remove_index
				for iterator = remove_index:length(obj)-1
					obj.DictForm(iterator) = obj.DictForm(iterator+1);
				end
				obj.DictForm.remove(length(obj));
			end
		end
		function Return_index = index(obj,element)
			element_class = class(element);
			singletonCheck = false;
			for index = 1:length(obj)
				if ~singletonCheck
					if element_class == 'char'
						if strcmp(obj.DictForm(index),element)
							Return_index = index;
							singletonCheck = true;
							%disp(sprintf('%s found at position %d.',element, index));
						end
					elseif element_class == 'cell'
						if obj.DictForm(index) == element{1}
							Return_index = index;
							singletonCheck = true;
						end
					elseif obj.DictForm(index) == element
						Return_index = index;
						singletonCheck = true;
						%disp(sprintf('%s found at position %d.',element, index));
						break
					end
				end
			end
			if ~singletonCheck
				%warning(sprintf('(in LIST_C/index) - ''%s'' not found in list',element));
				Return_index = [];
			end
		end
		function Return_Key = Key(obj,index)
			Return_Key = obj.DictForm(index);
		end
		function Return_ismember = ismember(obj,element)
			Return_ismember = logical(count(obj,element));
		end
		function Return_count = count(obj,element)
			Return_count = sum(ismember(obj.list,element));
		end
		function Return_unique = unique(obj)
			Return_unique = LIST_C;
			for element = list(obj)
				element = char(element);
				if ~ismember(Return_unique,element)
					Return_unique.append(element);
				else
					continue
				end
			end
		end
		function Return_char = char(obj)
			for index = 1:length(obj)
				obj.DictForm(index) = char(obj.DictForm(index));
			end
			Return_char = obj;
		end
	end
end