function ProceedAllowed = EvaluateTab_Reactor(Controller)
	%disp('EvaluateTab_Reactor called')
	Controller.Global.SystemUpdated = true;
	Controller.Reactor.Key 	= Controller.H.ReactorName.String;
	Controller.Reactor.Length 	= str2double(Controller.H.ReactorLength.String);
	Controller.Reactor.Radius 	= str2double(Controller.H.ReactorRadius.String);
	switch Controller.H.ReactorWallType.String{Controller.H.ReactorWallType.Value}
	case 'Pyrex'
		Controller.Reactor.S_T 		= 1e18.*Controller.Reactor.Area/Controller.Reactor.Volume;
		%CAR-W
		Controller.Reactor.gamma_H_ads 				= 0.01;
		Controller.Reactor.gamma_N_ads 				= 0.03;
		Controller.Reactor.gamma_NH_ads 			= 0.05;
		Controller.Reactor.gamma_NH2_ads 			= 0.05;
		Controller.Reactor.gamma_N_Ns_ER 			= 6.0e-3;
		Controller.Reactor.gamma_H_Hs_ER 			= 1.5e-3;
		Controller.Reactor.gamma_N_Hs_ER 			= 1.0e-2;
		Controller.Reactor.gamma_H_Ns_ER 			= 8.0e-3;
		Controller.Reactor.gamma_H_NHs_ER 			= 8.0e-3;
		Controller.Reactor.gamma_NH_Hs_ER 			= 1.0e-2;
		Controller.Reactor.gamma_H_NH2s_ER 			= 8.0e-3;
		Controller.Reactor.gamma_NH2_Hs_ER 			= 1.0e-2;
		Controller.Reactor.gamma_H2_NHs_ER 			= 8.0e-4;
		%HJA_60, THO_57
		Controller.Reactor.gamma_H_LossCoefficient 	= 3.2e-3; %UNITS:
		Controller.Reactor.gamma_N_LossCoefficient 	= 0.07;
		%HJA_61, THO_58, H_wall*
		Controller.Reactor.gamma_H2_Quenching 		= 1;
		Controller.Reactor.gamma_N2_Quenching 		= 1;
		Controller.Reactor.gamma_N_Quenching 		= 0.93;
	case 'Stainless Steel'
		Controller.Reactor.S_T 		= 1e19.*Controller.Reactor.Area/Controller.Reactor.Volume;
		%CAR-W
		Controller.Reactor.gamma_H_ads 				= 1;
		Controller.Reactor.gamma_N_ads 				= 1;
		Controller.Reactor.gamma_NH_ads 			= 1;
		Controller.Reactor.gamma_NH2_ads 			= 1;
		Controller.Reactor.gamma_N_Ns_ER 			= 6.0e-3;
		Controller.Reactor.gamma_H_Hs_ER 			= 1.5e-3;
		Controller.Reactor.gamma_N_Hs_ER 			= 1.0e-2;
		Controller.Reactor.gamma_H_Ns_ER 			= 8.0e-3;
		Controller.Reactor.gamma_H_NHs_ER 			= 8.0e-3;
		Controller.Reactor.gamma_NH_Hs_ER 			= 1.0e-2;
		Controller.Reactor.gamma_H_NH2s_ER 			= 8.0e-3;
		Controller.Reactor.gamma_NH2_Hs_ER 			= 1.0e-2;
		Controller.Reactor.gamma_H2_NHs_ER 			= 8.0e-4;
		%HJA_60, THO_57
		Controller.Reactor.gamma_H_LossCoefficient 	= 3.2e-3; %UNITS:
		Controller.Reactor.gamma_N_LossCoefficient 	= 0.07;
		%HJA_61, THO_58, H_wall*
		Controller.Reactor.gamma_H2_Quenching 		= 1;
		Controller.Reactor.gamma_N2_Quenching 		= 1;
		Controller.Reactor.gamma_N_Quenching 		= 0.93;
	otherwise
		error('The reactor wall type is not recogised - please add the case in ''EvaluateTab_Reactor.m''.')
	end
	ProceedAllowed = true;
end