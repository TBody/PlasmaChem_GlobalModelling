function rebuild_physicalconstants
	amu2kg 		= 1.660538921e-27;
	c 			= 299792458;
	epsilon_0 	= 8.854187817e-12;
	k_B_eV 		= 8.6173324e-5;
	k_B_J 		= 1.3806488e-23;
	m_e 		= 9.10938215e-31;
	mu_0 		= 4e-7*pi;
	N_A 		= 6.022140857e23;
	q_e 		= 1.6021766208e-19;
	eV2J 		= 1.6021766208e-19;
	Torr2Pa 	= 133.322;
	save('Databases/physicalconstants')
	DatabaseElementsStruct = whos('-file','Databases/physicalconstants');
	DatabaseElements = LIST_C;
	for StructIndex = 1:length(DatabaseElementsStruct)
		DatabaseElements.append(DatabaseElementsStruct(StructIndex).name);
	end
	save('Databases/physicalconstants','DatabaseElements','-append')
end