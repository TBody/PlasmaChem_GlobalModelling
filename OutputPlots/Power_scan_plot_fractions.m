% Power_scan_plot_fractions
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
e_index = Find_in_SI2E('e');

H_index = Find_in_SI2E('H');
H2_index = Find_in_SI2E('H2');
N_index = Find_in_SI2E('N');
N2_index = Find_in_SI2E('N2');
Ionic_H_indices = [...
    Find_in_SI2E('H+'),...
    Find_in_SI2E('H2+'),...
    Find_in_SI2E('H3+')];
Ionic_N_indices = [...
    Find_in_SI2E('N+'),...
    Find_in_SI2E('N2+'),...
    Find_in_SI2E('N3+'),...
    Find_in_SI2E('N4+')];
Total_H_indices = [H_index,H2_index,Ionic_H_indices];
Total_N_indices = [N_index,N2_index,Ionic_N_indices];

H_Dissoc = Density(H_index,:)./sum(Density([H_index,H2_index],:),1);
H_Ioniz = sum(Density(Ionic_H_indices,:),1)./sum(Density(Total_H_indices,:),1);
N_Dissoc = Density(N_index,:)./sum(Density([N_index,N2_index],:),1);
N_Ioniz = sum(Density(Ionic_N_indices,:),1)./sum(Density(Total_N_indices,:),1);
Total_Ioniz = Density(e_index,:)./sum(Density);

fractions_figure_p = figure;
yyaxis left

plot(Scan_values*xlabel_multiplier,100 * H_Dissoc,'Color',MATLAB_colours(3,:),'LineStyle','-','Marker','none','LineWidth',Computational_line_width);
hold on;
plot(Scan_values*xlabel_multiplier,100 * 10^3*H_Ioniz,'Color',MATLAB_colours(3,:),'LineStyle','--','Marker','none','LineWidth',Computational_line_width);
plot(Scan_values*xlabel_multiplier,100 * N_Dissoc,'Color',MATLAB_colours(1,:),'LineStyle','-','Marker','none','LineWidth',Computational_line_width);
plot(Scan_values*xlabel_multiplier,100 * 10^3*N_Ioniz,'Color',MATLAB_colours(1,:),'LineStyle','--','Marker','none','LineWidth',Computational_line_width);
plot(Scan_values*xlabel_multiplier,100 * 10^3*Total_Ioniz,'Color',MATLAB_colours(5,:),'LineStyle','--','Marker','none','LineWidth',Computational_line_width);

ax = fractions_figure_p.Children;
% ax.YScale = 'log';
ax.XScale = 'log';

% ax.XLim = [0 100];
grid('on')

%title('Power scan at 10mTorr, 50-50sccm (neutrals)')
xlabel('Electron density (m^{-3})')
% ylabel('Particle density (m^{-3})')
ylabel('Fraction (%, \times 10^{3} for ioniz.)')

switch FigureWidth_control
case 'Full'
    leg = legend({'H dissoc.','H ioniz.','N dissoc.', 'N ioniz.', 'Total ioniz.'},'Location','northeastoutside');
case 'Column'
    leg = legend({'H dissoc.','H ioniz.','N dissoc.', 'N ioniz.', 'Total ioniz.'},'Location','southwest');
end
leg.FontSize = 12;

clear fractions_handles fractions_legend

yyaxis right
plot(Scan_values*xlabel_multiplier,Te,'--','LineWidth',Computational_line_width,'DisplayName','Te')
ylabel('Electron temperature (eV)')

clear pD pDkeys pDkey iter
clear('Deconvolution_flag', 'Density', 'DensityError', 'Find_in_RI2E', 'Find_in_SI2E', 'H2Supply', 'H2_index', 'H_Dissoc', 'H_Ioniz', 'H_index', 'Ionic_H_indices', 'Ionic_N_indices', 'N2Supply', 'N2_index', 'N_Dissoc', 'N_Ioniz', 'N_index', 'Norm_n_table', 'Power', 'Pressure', 'Rate', 'Reaction_I2E', 'Scan_parameter', 'Scan_values', 'Species_I2E', 'Te', 'TeError', 'Total_H_indices', 'Total_Ioniz', 'Total_N_indices', 'ax', 'comp_points', 'e_index', 'expt_Density_electron', 'expt_Density_ion', 'expt_Density_ion_error', 'expt_Density_neutral', 'expt_Density_neutral_error', 'expt_H2Supply', 'expt_Mass', 'expt_N2Supply', 'expt_Power', 'expt_Pressure', 'expt_Scan_parameter', 'expt_Scan_values', 'expt_points', 'leg', 'normal_n_store', 'pDe', 'test_points', 'xlabel_multiplier')