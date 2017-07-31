%%Composition_scan_langmuir
% Plots experimental and computational results for Langmuir probe data
% Hard-coded
% 

% Load composition scan savestates
% Experimental
load '500W_10mTorr_Composition_scan.mat'
% Computational
load 'Composition_scan_10mTorr_500W.mat'

% To convert to percentage, etc -- scale all x-results by constant value
xlabel_multiplier = 100;

H2_supply = [0:10:100];


kTe = [5.53,4.17,3.97,4.24,4.2,4.2,4.28,4.37,4.44,4.59,4.87];
Te_eedf = [7.27,5.65,5.65,5.72,5.71,5.56,5.74,5.87,5.83,6.27,6.7];

Find_in_SI2E = @(Species_Key) find(strcmp(Species_I2E, Species_Key));

langmuir_figure = figure;
% To make outline on figures in MATLAB
% axes('Position',[.005 .005 .99 .99],'xtick',[],'ytick',[],'box','on','handlevisibility','off')
yyaxis left

hold on;
ax = langmuir_figure.Children;
% ax.YScale = 'log';

cplt = semilogy(Scan_values*xlabel_multiplier, Density(Find_in_SI2E('e'),:));
cplt.Color = MATLAB_colours(1,:);
cplt.LineWidth = 3;
cplt.LineStyle = '-';
cplt.Marker = 'none';

max_model = max(Density(Find_in_SI2E('e'),:));
max_expt = max(expt_Density_electron);
% normalisation = max_model/max_expt;
normalisation = 1;
clear max_model max_expt
% normal_n_store = [normal_n_store, normalisation];
ebar = plot(expt_Scan_values*xlabel_multiplier, expt_Density_electron * normalisation, 'x');
% ebar = errorbar(expt_Scan_values,...
%          expt_Density_ion(pDe(pDkey),:) * normalisation,...
%          expt_Density_ion_error(pDe(pDkey),:) * normalisation,...
%          'x');

ebar.Color = MATLAB_colours(1,:);
ebar.MarkerSize = Experimental_marker_size;
ebar.LineWidth = Experimental_line_width;

ax.XLim = [0 100];
grid on
% grid minor

xlabel('H_2 proportion of 100sccm supply (%)')
ylabel('Electron density (m^{-3})')

yyaxis right

cplt = plot(Scan_values*xlabel_multiplier,Te,'--','LineWidth',Computational_line_width,'DisplayName','Te');
cplt.Color = MATLAB_colours(2,:);
cplt.LineWidth = 3;
cplt.LineStyle = '-';
cplt.Marker = 'none';
ylabel('Electron temperature (eV)')

ebar = plot(H2_supply, kTe, 'x');
% ebar = plot(H2_supply, Te_eedf, 'x')
ebar.Color = MATLAB_colours(2,:);
ebar.MarkerSize = Experimental_marker_size;
ebar.LineWidth = Experimental_line_width;

leg = legend({'Density (comp.)','Density (expt.)','T_e (comp.)','T_e (expt.)'},'Location','northwest');


leg.FontSize = 12;