function Rate = ppvalfast(pp,Te)
	offset = pp.breaks - Te;
	index  = find(offset>0,1)-1;
	if index
		x_shift = -offset(index);
		coefs = pp.coefs(index,:);
		Rate = coefs(1)*x_shift^3+coefs(2)*x_shift^2+coefs(3)*x_shift+coefs(4);
	elseif index == 0
		x_shift = -(pp.breaks(1) - Te);
		coefs = pp.coefs(1,:);
		Rate = coefs(3)*x_shift+coefs(4);
	elseif isempty(index)
		x_shift = (Te - pp.breaks(end));
		coefs = pp.coefs(end,:);
		Rate = coefs(3)*x_shift+coefs(4);
	end
end