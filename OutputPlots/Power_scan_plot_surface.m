% Power_scan_plot_surface
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

% Plotting dictionary
% First element is SI2E index, second is mass index (for expt)
clear pD
pD = containers.Map();
pD('F_s')    = Find_in_SI2E('F_s');
pD('H_s')    = Find_in_SI2E('H_s');
pD('N_s')    = Find_in_SI2E('N_s');
pD('NH_s')   = Find_in_SI2E('NH_s');
pD('NH2_s')  = Find_in_SI2E('NH2_s');
pD('NH3')    = Find_in_SI2E('NH3');

% Plot surfaces first
surface_figure_p = figure;
% yyaxis left

hold on;
ax = surface_figure_p.Children;
ax.XScale = 'log';
ax.YScale = 'log';

normal_n_store = [];
surface_legend = {};
surface_handles = [];
pDkeys = {'F_s','H_s','N_s','NH_s','NH2_s','NH3'};

for iter = 1:length(pDkeys)
    % Look into the plotting dictionaries
    pDkey = pDkeys{iter};
    surface_legend = [surface_legend,pDkey];
    
    % Plot the computational result
    cplt = semilogy(Scan_values*xlabel_multiplier,Density(pD(pDkey),:));
    cplt.Color = MATLAB_colours(iter,:);
    cplt.LineWidth = 3;
    if strcmpi(pDkey,'NH3')
        cplt.LineStyle = '--';
    else
        cplt.LineStyle = '-';
    end
    cplt.Marker = 'none';
    surface_handles = [surface_handles, cplt];

    clear cplt
end
% Plot the electrons? very low - plot with ions
clear iter

% ax.XLim = [0 100];
grid('on')

%title('Power scan at 10mTorr, 50-50sccm (surface species)')
xlabel('Electron density (m^{-3})')
ylabel('Particle density (m^{-3})')
switch FigureWidth_control
case 'Full'
    leg = legend(surface_handles,surface_legend,'Location','northeastoutside');
case 'Column'
    leg = legend(surface_handles,surface_legend,'Location','southwest');
end
leg.FontSize = 12;

clear surface_handles surface_legend

% yyaxis right
% plot(Scan_values,Te,'--','LineWidth',Computational_line_width,'DisplayName','Te')
% ylabel('Electron temperature (eV)')

clear pD pDkeys pDkey iter
clear('Deconvolution_flag', 'Density', 'DensityError', 'Find_in_RI2E', 'Find_in_SI2E', 'H2Supply', 'H2_index', 'H_Dissoc', 'H_Ioniz', 'H_index', 'Ionic_H_indices', 'Ionic_N_indices', 'N2Supply', 'N2_index', 'N_Dissoc', 'N_Ioniz', 'N_index', 'Norm_n_table', 'Power', 'Pressure', 'Rate', 'Reaction_I2E', 'Scan_parameter', 'Scan_values', 'Species_I2E', 'Te', 'TeError', 'Total_H_indices', 'Total_Ioniz', 'Total_N_indices', 'ax', 'comp_points', 'e_index', 'expt_Density_electron', 'expt_Density_ion', 'expt_Density_ion_error', 'expt_Density_neutral', 'expt_Density_neutral_error', 'expt_H2Supply', 'expt_Mass', 'expt_N2Supply', 'expt_Power', 'expt_Pressure', 'expt_Scan_parameter', 'expt_Scan_values', 'expt_points', 'leg', 'normal_n_store', 'pDe', 'test_points', 'xlabel_multiplier')