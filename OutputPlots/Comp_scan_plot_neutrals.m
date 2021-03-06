% Comp_scan_plot_neutrals
% Only needs a small modification to plot ions, but cleaner if kept as two files
% Produce the updated plots (16/6/17)
% Including updated experimental results
% Needs to have 'New scan' folder on path
% See main README to set-up this folder

% Load composition scan savestates
% Experimental
load '500W_10mTorr_Composition_scan.mat'
% Computational
load 'Composition_scan_10mTorr_500W.mat'

% To convert to percentage, etc -- scale all x-results by constant value
xlabel_multiplier = 100;

% What to plot? Store in a dictionary

Find_in_SI2E = @(Species_Key) find(strcmp(Species_I2E, Species_Key));
Find_in_RI2E = @(Reaction_Key) find(strcmp(Reaction_I2E, Reaction_Key));

% Plotting dictionary
% First element is SI2E index, second is mass index (for expt)
pD = containers.Map();
pDe = containers.Map();
pD('H')      = Find_in_SI2E('H');    pDe('H')   =  1;
pD('H2')     = Find_in_SI2E('H2');   pDe('H2')  =  2;
pD('N')      = Find_in_SI2E('N');    pDe('N')   = 14;
pD('N2')     = Find_in_SI2E('N2');   pDe('N2')  = 28;
pD('NH3')    = Find_in_SI2E('NH3');  pDe('NH3') = 17;

pD('H+')     = Find_in_SI2E('H+');   pDe('H+')   =  1;
pD('H2+')    = Find_in_SI2E('H2+');  pDe('H2+')  =  2;
pD('N+')     = Find_in_SI2E('N+');   pDe('N+')   = 14;
pD('N2+')    = Find_in_SI2E('N2+');  pDe('N2+')  = 28;
pD('NH3+')   = Find_in_SI2E('NH3+'); pDe('NH3+') = 17;

% Plot neutrals first
neutral_figure = figure;
%yyaxis left

hold on;
ax = neutral_figure.Children;
ax.YScale = 'log';

normal_n_store = [];
neutral_legend = {};
neutral_handles = [];
pDkeys = pD.keys;

iter2 = 0;
for iter = 1:length(pDkeys)
    % Look into the plotting dictionaries
    pDkey = pDkeys{iter};
    if find(pDkey=='+'|pDkey=='-')
        % Skip ionic species
        continue
    else
        key_format = strrep(strrep(pDkey,pDkey(regexp(pDkey,'\d')),['_',pDkey(regexp(pDkey,'\d'))]),'+','^+');
        neutral_legend = [neutral_legend,key_format];
    end
    iter2 = iter2 + 1;

    % Plot the computational result
    cplt = semilogy(Scan_values*xlabel_multiplier,Density(pD(pDkey),:));
    cplt.Color = MATLAB_colours(iter2,:);
    cplt.LineWidth = 3;
    cplt.LineStyle = '-';
    cplt.Marker = 'none';
    neutral_handles = [neutral_handles, cplt];

    % Find normalisation (from mean)
    expt_points = expt_Density_neutral(pDe(pDkey),:);
    % Remove the 0% and 100% cases - since these are special cases for modelling (unphysical to have perfect gas supply also)
    test_points = expt_Scan_values(expt_Scan_values ~= 0 & expt_Scan_values ~= 1);
    expt_points = expt_points(expt_Scan_values ~= 0 & expt_Scan_values ~= 1);
    % vq = interp1(x,v,xq,method,extrapolation)
    comp_points = interp1(Scan_values, Density(pD(pDkey),:), test_points, 'linear', 'extrap');

    normalisation = mean(comp_points./expt_points);
    normal_n_store = [normal_n_store, normalisation];
    
    ebar = errorbar(expt_Scan_values*xlabel_multiplier,...
             expt_Density_neutral(pDe(pDkey),:) * normalisation,...
             expt_Density_neutral_error(pDe(pDkey),:) * normalisation,...
             'x');

    ebar.Color = MATLAB_colours(iter2,:);
    ebar.MarkerSize = Experimental_marker_size;
    ebar.LineWidth = Experimental_line_width;
    clear normalisation ebar cplt
end
% Plot the electrons? very low - plot with ions
clear iter iter2

ax.XLim = [0 100];
grid('on')

%title('Composition scan at 500W, 10mTorr (neutrals)')
xlabel('H_2 proportion of 100sccm supply (%)')
ylabel('Particle density (m^{-3})')
switch FigureWidth_control
case 'Full'
    leg = legend(neutral_handles,neutral_legend,'Location','northeastoutside');
case 'Column'
    leg = legend(neutral_handles,neutral_legend,'Location','best'); %Changed from 'Location','southeast');
end
leg.FontSize = 12;
Norm_n_table = table(neutral_legend', normal_n_store','VariableNames',{'Species','Norm'})
clear neutral_handles neutral_legend

%yyaxis right
%plot(Scan_values*xlabel_multiplier,Te,'--','LineWidth',Computational_line_width,'DisplayName','Te')
%ylabel('Electron temperature (eV)')

clear pD pDkeys pDkey iter
clear('Deconvolution_flag', 'Density', 'DensityError', 'Find_in_RI2E', 'Find_in_SI2E', 'H2Supply', 'H2_index', 'H_Dissoc', 'H_Ioniz', 'H_index', 'Ionic_H_indices', 'Ionic_N_indices', 'N2Supply', 'N2_index', 'N_Dissoc', 'N_Ioniz', 'N_index', 'Norm_n_table', 'Power', 'Pressure', 'Rate', 'Reaction_I2E', 'Scan_parameter', 'Scan_values', 'Species_I2E', 'Te', 'TeError', 'Total_H_indices', 'Total_Ioniz', 'Total_N_indices', 'ax', 'comp_points', 'e_index', 'expt_Density_electron', 'expt_Density_ion', 'expt_Density_ion_error', 'expt_Density_neutral', 'expt_Density_neutral_error', 'expt_H2Supply', 'expt_Mass', 'expt_N2Supply', 'expt_Power', 'expt_Pressure', 'expt_Scan_parameter', 'expt_Scan_values', 'expt_points', 'leg', 'normal_n_store', 'pDe', 'test_points', 'xlabel_multiplier')