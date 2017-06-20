% Process_composition_scan_expt
%   Must be run in the same directory as a composition scan with files labelled as
%   H2Supply_i/n.csv where i => ionic, n => neutral
% !Need to set scan constants manually in this script
%   Should be reasonably easy to modify for a new scan
%   Will output a .mat and .csv file with
%   Results
%   expt_Density_electron
%   expt_Density_neutral
%   expt_Density_neutral_error
%   expt_Density_ion
%   expt_Density_ion_error
%   Parameters: expt_H2/N2Supply, expt_Power, expt_Pressure, expt_Scan_parameter, expt_Scan_values
%   to match result from Run_single_variable_scan.m
%  
%  Te results will be inputted manually from CC expt

expt_Power = 500; %W
expt_Pressure = 10; %mTorr
expt_H2Supply = [0:10:100]; %sccm
expt_N2Supply = [100:-10:0]; %sccm
expt_Scan_parameter = 'Composition';
expt_Scan_values = [0:0.1:1]; %0 <= c <= 1, H2 proportion

process_total_flow = 100; %sccm
process_number_of_tests = length(expt_Scan_values);

minMass = 1; %amu
stepMass = 1; %amu
maxMass = 30; %amu
expt_Mass = [minMass:stepMass:maxMass];
massLength = length(expt_Mass);
clear minMass stepMass maxMass

% Variables to store the output
expt_Density_electron = [1.32 1.6 1.67 1.84 1.94 2.11 2.47 2.63 2.73 2.61 1.66] .* (10^16); %From Cormac, *10^16 m^-3
expt_Density_neutral = zeros(massLength,process_number_of_tests);
expt_Density_neutral_error = zeros(massLength,process_number_of_tests);
expt_Density_ion = zeros(massLength,process_number_of_tests);
expt_Density_ion_error = zeros(massLength,process_number_of_tests);

H2Supply_n_sortlist = []; %use this list to sort by supply
H2Supply_i_sortlist = []; %use this list to sort by supply
neutral_iterator = 0;
ion_iterator = 0;

dirfiles = dir()';
for file = dirfiles
    filename = file.name;
    filesplit = strsplit(filename,'.');

    if ~strcmpi(filesplit{2},'csv')
        continue
    end
    % Process the prefix
    prefixsplit = strsplit(filesplit{1},'_');
    test_H2Supply = str2num(prefixsplit{1})/process_total_flow;
    test_i_n_switch = prefixsplit{2}; %will be i or n

    % Open the file
    % Read the file
    %%Open file at Filename
        fileID           = fopen(filename);
    %%Skip first line
        totalScansSplit  = strsplit(fgetl(fileID),',');
        totalScans       = str2num(totalScansSplit{1});
        raw_count        = zeros(massLength, totalScans/massLength); %Make a matrix - collapse to find avg and std
        clear totalScansSplit
    %%Read the header info line
        %%Read header line
        raw                    = fgetl(fileID);
        %%Process to find number of header lines
        rawSplit               = strsplit(raw,',');
        headerLines            = str2num(rawSplit{2});
        for i                  = 1:headerLines;
            % Skip over the header
            fgetl(fileID);
        end
        clear raw rawSplit headerLines
        for scanIterator = 1:totalScans/massLength;
            massIterator = 0;
            for test_mass = expt_Mass;
                massIterator = massIterator +1;
                raw                    = fgetl(fileID);
                
                rawSplit               = strsplit(raw,',');
                if abs(test_mass - str2num(rawSplit{4})) > 1e-2
                    error('Analysis has screwed up - reading wrong test_mass')
                end
                raw_count(massIterator,scanIterator) = str2num(rawSplit{5});
            end
        end
    switch test_i_n_switch
        case 'n'
            neutral_iterator = neutral_iterator +1;
            % Neutral suite
            H2Supply_n_sortlist = [H2Supply_n_sortlist, test_H2Supply];
            expt_Density_neutral(:,neutral_iterator) = mean(raw_count,2);
            expt_Density_neutral_error(:,neutral_iterator) = std(raw_count,[],2);
        case 'i'
            ion_iterator = ion_iterator +1;
            % Ion suite
            H2Supply_i_sortlist = [H2Supply_i_sortlist, test_H2Supply];
            expt_Density_ion(:,ion_iterator) = mean(raw_count,2);
            expt_Density_ion_error(:,ion_iterator) = std(raw_count,[],2);
        otherwise
            disp(sprintf('%s not identified as ionic or neutral - skipped',file.name))
    end
end

%Sort into correct order
[n_check,n_sort] = sort(H2Supply_n_sortlist);
[i_check,i_sort] = sort(H2Supply_i_sortlist);
if sum(n_check-expt_Scan_values>1e-2) || sum(i_check-expt_Scan_values>1e-2)
    error('Check your sorting of tests - doesn''t match expt_Scan_values')
end
clear n_check i_check
expt_Density_neutral(:,:) = expt_Density_neutral(:,n_sort);
expt_Density_neutral_error(:,:) = expt_Density_neutral_error(:,n_sort);
expt_Density_ion(:,:) = expt_Density_ion(:,i_sort);
expt_Density_ion_error(:,:) = expt_Density_ion_error(:,i_sort);

clear test_i_n_switch totalScans

clear ans dirfiles file fileID filename filesplit H2Supply_i_sortlist H2Supply_n_sortlist
clear i i_sort n_sort ion_iterator neutral_iterator
clear massIterator massLength prefixsplit process_number_of_tests raw_count raw scanIterator test_H2Supply test_mass process_total_flow rawSplit mass

% save everything to file
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
'expt_Density_ion_error')

Deconvolute_composition_scan;