%%Deconvolution and sensitivity adjustment of experimental data
H2Supply_Expt = zeros(length(NeutralStruct),1);
meanCount_Expt = zeros(length(NeutralStruct),30);
stdCount_Expt = zeros(length(NeutralStruct),30);
for i = 1:length(NeutralStruct)
   H2Supply_Expt(i) = NeutralStruct(i).Scan.H2partialpressure*100;
   P = NeutralStruct(i).meanCount; %Process
   P(14) = P(14) - 0.05 * P(28);      %Remove N2 from N
   P(18) = P(18)/0.9; %Relative sensitivity for H2O
   P(17) = P(17) - 0.21 * P(18);  %Remove H2O from NH3
   P(16) = P(16) - 0.02 * P(18);  %Remove H2O from NH2
   P(17) = P(17)/1.3; %Relative sensitivity for NH3
   P(16) = P(16) - 0.80 * P(17);  %Remove NH3 from NH2
   P(15) = P(15) - 0.08 * P(17);  %Remove NH3 from NH
   P(16) = P(16)/1.61; %Relative sensitivity for NH2
   P(15) = P(15) - 0.55 * P(16); %Remove NH2 from NH
   P(15) = P(15)/1.61; %Relative sensitivity for NH
   P(14) = P(14) - 0.28 * P(15); %Remove NH from N
   P(2)  = P(2)/0.44; %Relative sensitivity for H2
   P(1)  = P(1)  - 0.02 * P(2);  %Remove H2 from H
   P(1)  = P(1)/0.25; %Relative sensitivity for H
   meanCount_Expt(i,:) = P;
   stdCount_Expt(i,:) = NeutralStruct(i).stdCount;
end
[H2Supply_Expt,sorting] = sort(H2Supply_Expt);
meanCount_Expt = meanCount_Expt(sorting,:);
stdCount_Expt  = stdCount_Expt(sorting,:);
clear i sorting