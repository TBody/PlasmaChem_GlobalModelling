classdef REACTOR_C < handle
	%REACTOR_C Reactor class - contains all properties associated with the reactor.
	%	Properties include Name, Length, Radius, Volume. Methods include Constructor,
	properties
		Key
		Length
		Radius
        S_T
        gamma_H_ads
        gamma_N_ads
        gamma_NH_ads
        gamma_NH2_ads
        gamma_N_Ns_ER
        gamma_H_Hs_ER
        gamma_N_Hs_ER
        gamma_H_Ns_ER
        gamma_H_NHs_ER
        gamma_NH_Hs_ER
        gamma_H_NH2s_ER
        gamma_NH2_Hs_ER
        gamma_H2_NHs_ER
		gamma_N_LossCoefficient
        gamma_H_LossCoefficient %From wall material
        gamma_H2_Quenching
        gamma_N2_Quenching
        gamma_N_Quenching
	end
	properties(Dependent)
		Volume
	end
	methods
		function obj = REACTOR_C(Name,Radius,Length)
			if nargin > 0
				obj.Key		=	Name;
	            obj.Length 	=	Length;
	            obj.Radius 	=	Radius;
	        else
	        	obj.Key=NaN;
	            obj.Length=NaN;
	            obj.Radius=NaN;
	        end
        end

        function Volume = get.Volume(obj)
        	Volume = pi.*obj.Radius.^2.*obj.Length;
        end
        function Area = Area(obj)
            Area = (obj.Radius.^2.*2.*pi)+(obj.Radius.*obj.Length.*2.*pi);
        end
        function StructForm = StructForm(obj)
        	warning('off','MATLAB:structOnObject')
        	StructForm = struct(obj);
        end
        function TableForm = TableForm(obj)
        	warning('off','MATLAB:structOnObject')
        	StructForm   = obj.StructForm;
        	TableForm = struct2table(StructForm);
        end
        function EffectiveDiffusionLength = Lambda0(obj)
        	EffectiveDiffusionLength = ((obj.Length).^-2.*pi^2+(obj.Radius).^-2.*2.405^2).^(-1/2);
        end
        function EffectiveIonLossArea = A_eff(obj,MFP)
        	EffectiveIonLossArea = (obj.Radius.^2.*(obj.h_Linear(MFP))+obj.Radius.*obj.Length.*obj.h_Radial(MFP)).*(2*pi);
        end
        function Return_h_Linear = h_Linear(obj,MFP)
        	Return_h_Linear = 0.86*(3+obj.Length./(MFP.*2)).^(-1/2);
        end
        function Return_h_Radial = h_Radial(obj,MFP)
        	Return_h_Radial = 0.8*(4+obj.Radius./MFP).^(-1/2);
        end
        function disp(obj)
        	StructForm = obj.StructForm;
            for property = fieldnames(StructForm)'
                if isa(StructForm.(property{:}),'')
                    StructForm.(property{:}) = StructForm.(property{:}).value; %Should return a string which can be displayed
                end
            end
        	disp(StructForm)
        end
    end
end