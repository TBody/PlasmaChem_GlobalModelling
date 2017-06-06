%%For processing a Scan struct corresponding to a single scan from
%%ResultsStruct
Results = CompScan.Results;
DataLength = length(Results);
StateVectorLength = length(CompScan.Results(1).Y(1,:));
%Preallocate
H2Supply = zeros(DataLength,1);
N2Supply = zeros(DataLength,1);
Density = zeros(DataLength,StateVectorLength-1);
ElectronT = zeros(DataLength,1);
%Loop extract
for Scan = 1:DataLength
    H2Supply(Scan) = CompScan.Results(Scan).GasSupply('H2');
    N2Supply(Scan) = CompScan.Results(Scan).GasSupply('N2');
    Density(Scan,:) = CompScan.Results(Scan).Y(end,1:end-1); %Extract the final value of state vector
    ElectronT(Scan,:) = CompScan.Results(Scan).Y(end,end);
end
clear Results DataLength StateVectorLength