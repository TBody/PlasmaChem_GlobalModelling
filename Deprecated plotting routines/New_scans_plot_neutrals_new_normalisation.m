% New_scans_plot_neutrals
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

Computational_line_width = 2;
Experimental_line_width = 2;
Experimental_marker_size = 10;

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

% semilogy(Scan_values,[Density(pD('H'),:);Density(pD('H2'),:);Density(pD('N'),:);Density(pD('N2'),:);Density(pD('NH3'),:)]);
% comp_lines = Neutral_figure.Children.Children;
% for iter = 1:length(comp_lines);
%     comp_lines(iter).Color = MATLAB_colours(iter,:);
%     comp_lines(iter).LineWidth = 3;
%     comp_lines(iter).LineStyle = '-';
%     comp_lines(iter).Marker = 'none';
% end
% clear comp_lines iter

% hold on;
% ax = Neutral_figure.Children;
% ax.ColorOrderIndex = 1; %Reset the colour order

hold on;
ax = Neutral_figure.Children;
ax.YScale = 'log';

normal_n_store = [];
neutral_legend = {};
neutral_handles = [];
pDkeys = pD.keys;
iter2 = 0;

p0_store = [];
p1_store = [];

for iter = 1:length(pDkeys)
    % Look into the plotting dictionaries
    pDkey = pDkeys{iter};
    if find(pDkey=='+'|pDkey=='-')
        % Skip ionic species
        continue
    else
        neutral_legend = [neutral_legend,pDkey];
    end
    iter2 = iter2 + 1;

    % Plot the computational result
    % cplt = semilogy(Scan_values,Density(pD(pDkey),:));
    % cplt.Color = MATLAB_colours(iter2,:);
    % cplt.LineWidth = 3;
    % cplt.LineStyle = '-';
    % cplt.Marker = 'none';
    % neutral_handles = [neutral_handles, cplt];

    % New normalisation technique (mean of values)
    % Use interpolation to find computational results corresponding to experimental points
    expt_points = expt_Density_neutral(pDe(pDkey),:);
    % Remove the 0% and 100% cases - since these are special cases for modelling (unphysical to have perfect gas supply also)
    test_points = expt_Scan_values(expt_Scan_values ~= 0 & expt_Scan_values ~= 1);
    expt_points = expt_points(expt_Scan_values ~= 0 & expt_Scan_values ~= 1);
    % vq = interp1(x,v,xq,method,extrapolation)
    comp_points = interp1(Scan_values, Density(pD(pDkey),:), test_points, 'linear', 'extrap');
    % comp_points./expt_points
    % normalisation = mean(comp_points./expt_points);
    [~,expt_sorting] = sort(expt_points);
    sorted_expt = expt_points(expt_sorting);
    sorted_comp = comp_points(expt_sorting);
    sorted_norm = sorted_comp./sorted_expt;

    % Seems like there is a linear dependance on number of counts (for all masses) -- looks like detector response
    p = polyfit(sorted_expt,sorted_norm,1);
    fitted_p = polyval(p, sorted_expt);
    
    p0_store = [p0_store,p(2)]; %intercept
    % p1_store = [p1_store,p(1)]; %gradient

    % Remove the gradient dependance
    % figure; plot(sorted_expt, sorted_norm-p(1)*sorted_expt);
    % hold on;
    % plot(sorted_expt, fitted_p-p(1)*sorted_expt);
    % title(pDkey)
    clear test_points expt_points comp_points expt_sorting
end
for iter = 1:length(pDkeys)

    continue

    normal_n_store = [normal_n_store, normalisation];
    ebar = errorbar(expt_Scan_values,...
             expt_Density_neutral(pDe(pDkey),:) .* normalisation,...
             expt_Density_neutral_error(pDe(pDkey),:) .* normalisation,...
             'x');

    return

    % Find normalisation
    max_model = max(Density(pD(pDkey),:));
    max_expt = max(expt_Density_neutral(pDe(pDkey),:));
    normalisation = max_model/max_expt;
    clear max_model max_expt
    normal_n_store = [normal_n_store, normalisation];
    ebar = errorbar(expt_Scan_values,...
             expt_Density_neutral(pDe(pDkey),:) * normalisation,...
             expt_Density_neutral_error(pDe(pDkey),:) * normalisation,...
             'x');

    ebar.Color = MATLAB_colours(iter2,:);
    ebar.MarkerSize = Experimental_marker_size;
    ebar.LineWidth = Experimental_line_width;
    clear normalisation ebar cplt
end

mean(p0_store)

figure; plot([1,2,14,17,28],p0_store([1,2,3,5,4]))
% figure; plot([1,2,14,17,28],p1_store([1,2,3,5,4]))

% Plot the electrons? very low - plot with ions
clear iter iter2

return
ax.XLim = [0 1];


title('Composition scan at 500W, 10mTorr (neutrals)')
xlabel('H_2 proportion of 100sccm supply (%)')
ylabel('Particle density (m^{-3})')
leg = legend(neutral_handles,neutral_legend,'Location','southeast');
leg.FontSize = 12;
Norm_n_table = table(neutral_legend', normal_n_store','VariableNames',{'Species','Norm'})
clear neutral_handles neutral_legend

yyaxis right
plot(Scan_values,Te,'--','LineWidth',Computational_line_width)
ylabel('Electron temperature (eV)')

clear pDkeys pDkey iter

clear Computational_line_width Experimental_line_width Experimental_marker_size MATLAB_colours

% Code for finding the linear dependance of the normalisation on count

% p0_store = [];
% p1_store = [];

% for iter = 1:length(pDkeys)
%     % Look into the plotting dictionaries
%     pDkey = pDkeys{iter};
%     if find(pDkey=='+'|pDkey=='-')
%         % Skip ionic species
%         continue
%     else
%         neutral_legend = [neutral_legend,pDkey];
%     end
%     iter2 = iter2 + 1;

%     % New normalisation technique (mean of values)
%     % Use interpolation to find computational results corresponding to experimental points
%     expt_points = expt_Density_neutral(pDe(pDkey),:);
%     % Remove the 0% and 100% cases - since these are special cases for modelling (unphysical to have perfect gas supply also)
%     test_points = expt_Scan_values(expt_Scan_values ~= 0 & expt_Scan_values ~= 1);
%     expt_points = expt_points(expt_Scan_values ~= 0 & expt_Scan_values ~= 1);
%     % vq = interp1(x,v,xq,method,extrapolation)
%     comp_points = interp1(Scan_values, Density(pD(pDkey),:), test_points, 'linear', 'extrap');
%     % comp_points./expt_points
%     % normalisation = mean(comp_points./expt_points);
%     [~,expt_sorting] = sort(expt_points);
%     sorted_expt = expt_points(expt_sorting);
%     sorted_comp = comp_points(expt_sorting);
%     sorted_norm = sorted_comp./sorted_expt;

%     % Seems like there is a linear dependance on number of counts (for all masses) -- looks like detector response
%     p = polyfit(sorted_expt,sorted_norm,1);
%     fitted_p = polyval(p, sorted_expt);

%     % figure; plot(sorted_expt,sorted_norm);
%     % hold on;
%     % plot(sorted_expt,fitted_p);
%     % title(pDkey)
    
%     p0_store = [p0_store,p(2)]; %intercept
%     p1_store = [p1_store,p(1)]; %gradient

%     % figure; plot(sorted_expt, sorted_norm-fitted_p);
%     % hold on;
%     % plot(sorted_expt, fitted_p-fitted_p);
%     % title(pDkey)

%     clear test_points expt_points comp_points expt_sorting
% end

% figure; plot([1,2,14,17,28],p0_store([1,2,3,5,4]))
% figure; plot([1,2,14,17,28],p1_store([1,2,3,5,4]))
