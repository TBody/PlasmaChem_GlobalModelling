classdef REACTION_C <handle %Handle class prevents copies of identical reactions being made
    %REACTION Elementary reaction parameters

    properties
        Key
        ReactantSpeciesDict
        ProductSpeciesDict
        RateCoefficientForm
        E %Energy
        ReactionType %Reaction type (i.e. ionisation, excitation, or elastic)
    end

    methods
        function obj = REACTION_C(ReactionCode,ReactantSpeciesDict,ProductSpeciesDict,RateCoefficientForm,Energy,ReactionType)
            obj.Key                 =    ReactionCode;
            obj.ReactantSpeciesDict =    ReactantSpeciesDict;
            obj.ProductSpeciesDict  =    ProductSpeciesDict;
            obj.RateCoefficientForm =    RateCoefficientForm;
            obj.E                   =    Energy;
            obj.ReactionType        =    ReactionType;
        end
        function Return_RateCoefficient = RateCoefficient(obj)
            Return_RateCoefficient      =    str2func(obj.RateCoefficientForm);
        end
        function StructForm = StructForm(obj)
            warning('off','MATLAB:structOnObject')
            StructBuild = struct(obj);
            StructBuild.ReactantSpeciesDict = Display_dict(StructBuild.ReactantSpeciesDict);
            StructBuild.ProductSpeciesDict  = Display_dict(StructBuild.ProductSpeciesDict);
            StructBuild.E                   = StructBuild.E;
            StructBuild.RateCoefficientForm = StructBuild.RateCoefficientForm;
            StructForm = StructBuild;
        end
        function TableForm = TableForm(obj)
            warning('off','MATLAB:structOnObject')
            TableForm = struct2table(obj.StructForm);
        end
        function disp(obj)
            disp(obj.StructForm)
        end
    end
end