% New_scans_plot_all
% Produce the updated plots (16/6/17)
% Including updated experimental results
% Needs to have 'New scan' folder on path
% See main README to set-up this folder

% Load composition scan
% Experimental
load '500W_10mTorr_Composition_scan.mat'
% Computational
load 'Composition_scan_10mTorr_500W.mat'

MATLAB_colours = [         0    0.4470    0.7410; ...
    0.8500    0.3250    0.0980; ...
    0.9290    0.6940    0.1250; ...
    0.4940    0.1840    0.5560; ...
    0.4660    0.6740    0.1880; ...
    0.3010    0.7450    0.9330; ...
    0.6350    0.0780    0.1840];

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
Neutral_figure = figure;
yyaxis left

semilogy(Scan_values,[Density(pD('H'),:);Density(pD('H2'),:);Density(pD('N'),:);Density(pD('N2'),:);Density(pD('NH3'),:)]);
comp_lines = Neutral_figure.Children.Children;
for iter = 1:length(comp_lines);
    comp_lines(iter).Color = MATLAB_colours(iter,:);
    comp_lines(iter).LineWidth = 3;
    comp_lines(iter).LineStyle = '-';
    comp_lines(iter).Marker = 'none';
end
clear comp_lines iter

yyaxis right
plot(Scan_values,Te,'--','LineWidth',3)
return
hold on;
ax = Neutral_figure.Children;
ax.ColorOrderIndex = 1; %Reset the colour order

normal_n_store = [];
neutral_legend = {};
pDkeys = pD.keys;
for iter = 1:length(pDkeys)
    pDkey = pDkeys{iter};
    if find(pDkey=='+'|pDkey=='-')
        % Skip ionic species
        continue
    else
        neutral_legend = [neutral_legend,pDkey];
    end
    max_model = max(Density(pD(pDkey),:));
    max_expt = max(expt_Density_neutral(pDe(pDkey),:));
    normalisation = max_model/max_expt;
    clear max_model max_expt
    normal_n_store = [normal_n_store, normalisation];
    errorbar(expt_Scan_values,...
             expt_Density_neutral(pDe(pDkey),:) * normalisation,...
             expt_Density_neutral_error(pDe(pDkey),:) * normalisation,...
             'x');
    clear normalisation
end
ax.XLim = [0 1];

for i = 5:10
    ax.Children(i).LineWidth = 3;
end
for i = 1:5
    ax.Children(i).MarkerSize = 10;
    ax.Children(i).LineWidth = 2;
end

title('Composition scan at 500W, 10mTorr (neutrals)')
xlabel('H_2 proportion of 100sccm supply (%)')
ylabel('Particle density (m^{-3})')
leg = legend(neutral_legend,'Location','southeast');
leg.FontSize = 12;

clear pDkeys pDkey iter