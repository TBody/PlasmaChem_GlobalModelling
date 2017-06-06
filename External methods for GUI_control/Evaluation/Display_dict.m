function Return_Display_dict = Display_dict(Dictionary)
	element_list    = LIST_C;
	for Key = Dictionary.keys
		Value = Dictionary(Key{:});
		element_list.append(sprintf('%s: %s',Key{:},num2str(Value)));
	end
	Return_Display_dict = strjoin(element_list.list,', ');
end