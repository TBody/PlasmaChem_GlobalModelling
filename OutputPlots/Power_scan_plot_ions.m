% Power_scan_plot_ions
% Only needs a small modification to plot ions, but cleaner if kept as two files
% Produce the updated plots (16/6/17)
% Including updated experimental results
% Needs to have 'New scan' folder on path
% See main README to set-up this folder

% Load composition scan savestates
% Computational
load 'Power_scan_10mTorr_50_50sccm.mat'

% Turn off an annoying warning
warning('off','MATLAB:handle_graphics:exceptions:SceneNode')

% To convert to percentage, etc -- scale all x-results by constant value
xlabel_multiplier = 1;

% Crop Scan_values to the same length as Density

% Scan_values = Scan_values(1:size(Density,2));
Scan_values = Scan_values(1:20);
Density = Density(:,1:20);
Te = Te(1:20);

% What to plot? Store in a dictionary

Find_in_SI2E = @(Species_Key) find(strcmp(Species_I2E, Species_Key));
Find_in_RI2E = @(Reaction_Key) find(strcmp(Reaction_I2E, Reaction_Key));

% Find and sort electron density
electron_density = Density(Find_in_SI2E('e'),:);
% Update Scan_values and Density to be sorted on electron_density
[Scan_values, electron_density_sorting] = sort(electron_density);
Density = Density(:,electron_density_sorting);

% Plotting dictionary
% First element is SI2E index, second is mass index (for expt)
pD = containers.Map();


pD('H')      = Find_in_SI2E('H');
pD('H2')     = Find_in_SI2E('H2');
pD('N')      = Find_in_SI2E('N');
pD('N2')     = Find_in_SI2E('N2');
pD('NH3')    = Find_in_SI2E('NH3');

pD('H+')     = Find_in_SI2E('H+');
pD('H2+')    = Find_in_SI2E('H2+');
pD('N+')     = Find_in_SI2E('N+');
pD('N2+')    = Find_in_SI2E('N2+');
pD('NH3+')   = Find_in_SI2E('NH3+');

% Plot ions first
ion_figure_p = figure;
%yyaxis left

hold on;
ax = ion_figure_p.Children;
ax.XScale = 'log';
ax.YScale = 'log';

normal_n_store = [];
ion_legend = {};
ion_handles = [];
pDkeys = pD.keys;

iter2 = 0;
for iter = 1:length(pDkeys)
    % Look into the plotting dictionaries
    pDkey = pDkeys{iter};
    if find(pDkey=='+'|pDkey=='-')
        % Process ionic species
        key_format = strrep(strrep(pDkey,pDkey(regexp(pDkey,'\d')),['_',pDkey(regexp(pDkey,'\d'))]),'+','^+');
        ion_legend = [ion_legend,key_format];
    else
        continue
    end
    iter2 = iter2 + 1;

    % Plot the computational result
    cplt = semilogy(Scan_values*xlabel_multiplier,Density(pD(pDkey),:));
    cplt.Color = MATLAB_colours(iter2,:);
    cplt.LineWidth = 3;
    cplt.LineStyle = '-';
    cplt.Marker = 'none';
    ion_handles = [ion_handles, cplt];

    clear cplt
end
% Plot the electrons? very low - plot with ions
clear iter iter2

ax.XLim = [Scan_values(1) Scan_values(20)];
grid('on')

%title('Power scan at 10mTorr, 50-50sccm (ions)')
xlabel('Electron density (m^{-3})')
ylabel('Particle density (m^{-3})')

switch FigureWidth_control
case 'Full'
    leg = legend(ion_handles,ion_legend,'Location','northeastoutside');
case 'Column'
    leg = legend(ion_handles,ion_legend,'Location','best'); %Changed from 'Location','southeast');
end
leg.FontSize = 12;

%yyaxis right
%plot(Scan_values*xlabel_multiplier,Te,'--','LineWidth',Computational_line_width,'DisplayName','Te')
%ylabel('Electron temperature (eV)')

clear pD pDkeys pDkey iter
clear('Deconvolution_flag', 'Density', 'DensityError', 'Find_in_RI2E', 'Find_in_SI2E', 'H2Supply', 'H2_index', 'H_Dissoc', 'H_Ioniz', 'H_index', 'Ionic_H_indices', 'Ionic_N_indices', 'N2Supply', 'N2_index', 'N_Dissoc', 'N_Ioniz', 'N_index', 'Norm_n_table', 'Power', 'Pressure', 'Rate', 'Reaction_I2E', 'Scan_parameter', 'Scan_values', 'Species_I2E', 'Te', 'TeError', 'Total_H_indices', 'Total_Ioniz', 'Total_N_indices', 'ax', 'comp_points', 'e_index', 'expt_Density_electron', 'expt_Density_ion', 'expt_Density_ion_error', 'expt_Density_ion', 'expt_Density_ion_error', 'expt_H2Supply', 'expt_Mass', 'expt_N2Supply', 'expt_Power', 'expt_Pressure', 'expt_Scan_parameter', 'expt_Scan_values', 'expt_points', 'leg', 'normal_n_store', 'pDe', 'test_points', 'xlabel_multiplier')