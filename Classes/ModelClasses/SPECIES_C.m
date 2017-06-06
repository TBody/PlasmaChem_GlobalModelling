classdef SPECIES_C <handle %handle class prevents identical copies of species being made
    %SPECIES Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Key
        m       %mass
        q       %charge
        n       %density
        T       %temperature
        Type    %Ion or neutral?
        Excited %Excited or ground?
        vdW_Area
        %MFPForm     %MeanFreePath (Use .MFP to evaluate)
        MFP
    end

    methods
    	function obj = SPECIES_C(Key,Mass,Charge,Density,Temp,Type,Excited,vdW_Area) %MFPForm)
        %SPECIES Constructor for the SPECIES class. Takes as input the name (as a chemical formula)
        %mass, density and temperature.
    		obj.Key     = Key;
            obj.m       = Mass;
            obj.q       = Charge;
            obj.n       = Density;
            obj.T       = Temp;
            obj.Type    = Type;
            obj.Excited = Excited;
            obj.vdW_Area= vdW_Area;
            %obj.MFPForm     = MFPForm;
    	end
        function Return_StructForm = StructForm(obj)
            warning('off','MATLAB:structOnObject')
            StructBuild = struct(obj);
            for property = fieldnames(StructBuild)'
                if isa(StructBuild.(property{:}),'')
                    StructBuild.(property{:}) = StructBuild.(property{:}).value; %Should return a string which can be displayed
                end
            end
            Return_StructForm = StructBuild;
        end
        function Return_TableForm = TableForm(obj)
            warning('off','MATLAB:structOnObject')
            Return_TableForm    = struct2table(obj.StructForm);
        end
        function disp(obj)
            disp(obj.StructForm)
        end
        %function Return_u_Bohm = u_Bohm_Fcn(obj)
        %    load('physicalconstants','q_e','amu2kg','k_B_eV')
        %    Return_u_Bohm = @(Te)eval(obj.u_Bohm);
        %    %Return_u_Bohm = @(Te,alpha_eneg,gamma_eneg)sqrt((q_e*Te*(1+alpha_eneg))/(obj.m*amu2kg*(1+alpha_eneg*gamma_eneg)));
        %end
        function Return_u_Bohm = u_Bohm(obj)
            load('physicalconstants','k_B_eV','eV2J')
            %Makes a function in terms of system variables for electronegative u_Bohm
            if ~strcmp(obj.Type,'Positive Ion')
                error('u_Bohm evaluated for neutral or negative ion')
            end
            %@(Te)sqrt(eV2J./obj.m).*sqrt(Te) %Will give a function in terms of Te: note Te must have units eV
            Prefactor = sqrt(eV2J./obj.m);
            Return_u_Bohm = [num2str(Prefactor),'*sqrt(Te)'];
        end
        function Return_D = D(obj)
            load('physicalconstants','eV2J')
            Prefactor = eV2J.*obj.MFP./(obj.m.*obj.v_avg);
            Return_D = [num2str(Prefactor),'*Te'];
            %Return_u_Bohm = @(Te,alpha_eneg,gamma_eneg)sqrt((q_e*Te*(1+alpha_eneg))/(obj.m*amu2kg*(1+alpha_eneg*gamma_eneg)));
        end
        function Return_v_avg = v_avg(obj)
            load('physicalconstants','eV2J')
            Return_v_avg = sqrt((8.*eV2J.*obj.T)./(pi.*obj.m));
        end
    end

end