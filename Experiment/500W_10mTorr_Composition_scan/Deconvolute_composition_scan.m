% Run the code Process_composition_scan_expt.m to process the directory for the composition scan

% load('500W_10mTorr_Composition_scan.mat')
% Variables are
% expt_Density_electron
% expt_Density_ion
% expt_Density_ion_error
% expt_Density_neutral
% expt_Density_neutral_error
% expt_H2Supply
% expt_Mass
% expt_N2Supply
% expt_Power
% expt_Pressure
% expt_Scan_parameter
% expt_Scan_values

% Shape of expt_Density_* is (masses, tests) 

if abs(expt_Mass-[1:1:30])>1e2
    error('Assuming standard test');
end
if exist('Deconvolution_flag')
    error('Have already deconvoluted - don''t run twice')
else
    Deconvolution_flag = true;
end

eD = expt_Density_neutral;
% eDe = expt_Density_neutral_error; Don't worry about error propagation just yet
% See table 5.1 (p69) in thesis
% Nitrogen N2
eD(14,:) = eD(14,:) - 0.05 * eD(28,:);
eD(29,:) = eD(29,:) - 0.01 * eD(28,:);
% Water H20
eD(18,:) = eD(18,:)/0.9; %Apply relative sens
eD(17,:) = eD(17,:) - 0.21 * eD(18,:);
eD(16,:) = eD(16,:) - 0.02 * eD(18,:);
% Ammonia NH3
eD(17,:) = eD(17,:)/1.3; %Apply relative sens
eD(16,:) = eD(16,:) - 0.8 * eD(17,:);
eD(15,:) = eD(15,:) - 0.08 * eD(17,:);
% Hydrogen H2
eD(2,:) = eD(2,:)/0.44; %Apply relative sens
eD(1,:) = eD(1,:) - 0.02 * eD(2,:);

expt_Density_neutral = eD;
% expt_Density_neutral_error = eDe;

clear eD eDe

save('500W_10mTorr_Composition_scan',...
'expt_Power',...
'expt_Pressure',...
'expt_H2Supply',...
'expt_N2Supply',...
'expt_Mass',...
'expt_Scan_parameter',...
'expt_Scan_values',...
'expt_Density_electron',...
'expt_Density_neutral',...
'expt_Density_neutral_error',...
'expt_Density_ion',...
'expt_Density_ion_error',...
'Deconvolution_flag')