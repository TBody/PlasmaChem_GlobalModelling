% Comp_scan_plot_reactions
% Only needs a small modification to plot ions, but cleaner if kept as two files
% Produce the updated plots (16/6/17)
% Including updated experimental results
% Needs to have 'New scan' folder on path
% See main README to set-up this folder

Computational_line_width = 2;
Experimental_line_width = 2;
Experimental_marker_size = 10;
Close_after_save = true;

MATLAB_colours = [         0    0.4470    0.7410; ...
    0.8500    0.3250    0.0980; ...
    0.9290    0.6940    0.1250; ...
    0.4940    0.1840    0.5560; ...
    0.4660    0.6740    0.1880; ...
    0.3010    0.7450    0.9330; ...
    0.6350    0.0780    0.1840];

CW = hgexport('readstyle','ColumnWidth');
FigureWidth_control = 'Column';

Species_Search = 'NH3';
figure_path = '~/Desktop';

% Load composition scan savestates% Computational
if ~exist('Controller')
    disp('Closing hidden figures')
    clc; close all hidden
    load 'Composition_scan_10mTorr_500W.mat'
end

% To convert to percentage, etc -- scale all Scan_values-results by constant value
xlabel_multiplier = 100;

% What to plot? Store in a dictionary

Find_in_SI2E = @(Species_Key) find(strcmp(Species_I2E, Species_Key));
Find_in_RI2E = @(Reaction_Key) find(strcmp(Reaction_I2E, Reaction_Key));

% Plotting dictionary
% First element is SI2E index, second is mass index (for expt)
pD = containers.Map();
rD = containers.Map();

Species_Search_Key = Find_in_SI2E(Species_Search);

loss_indices = find(Controller.Solver.SystemStruct.ProductionMatrix(Species_Search_Key,:)<0);
production_indices = find(Controller.Solver.SystemStruct.ProductionMatrix(Species_Search_Key,:)>0);

loss_keys = {};
production_keys = {};

for index = 1:length(loss_indices)
    Reaction_Key = Reaction_I2E(loss_indices(index));
    % Controller.ReactionDB.Key(Reaction_Key{:})
    loss_keys = [loss_keys,Reaction_Key{:}];
    rD(Reaction_Key{:}) = Find_in_RI2E(Reaction_Key{:});
end

for index = 1:length(production_indices)
    Reaction_Key = Reaction_I2E(production_indices(index));
    % Controller.ReactionDB.Key(Reaction_Key{:})
    production_keys = [production_keys,Reaction_Key{:}];
    rD(Reaction_Key{:}) = Find_in_RI2E(Reaction_Key{:});
end

pD('NH3') = Find_in_SI2E('NH3');

% Find where NH3 production is highest
max_NH3_index = find(Density(pD('NH3'),:)==max(Density(pD('NH3'),:)));
max_rate = Rate(:,max_NH3_index);

[~,production_sorting] = sort(max_rate(production_indices),'descend');
production_keys = production_keys(production_sorting);
production_indices = production_indices(production_sorting);

[~,loss_sorting] = sort(max_rate(loss_indices),'descend');
loss_keys = loss_keys(loss_sorting);
loss_indices = loss_indices(loss_sorting);

table(production_keys', max_rate(production_indices),'VariableNames',{'Reaction','Rate'})
table(loss_keys', max_rate(loss_indices),'VariableNames',{'Reaction','Rate'})

reaction_prod_figure = figure;

hold on;

ax = reaction_prod_figure.Children;
ax.YScale = 'log';

for iter = 1:min(length(production_keys),5)
    production_key = production_keys{iter};

    reactants = Controller.ReactionDB.Key(production_key).ReactantSpeciesDict.keys;
    products = Controller.ReactionDB.Key(production_key).ProductSpeciesDict.keys;

    process_string = reactants{1};
    process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
    process_string = strrep(process_string, '(_','(');
    display_string = process_string;
    for iter2 = 2:length(reactants)
        process_string = reactants{iter2};
        process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
        process_string = strrep(process_string, '(_','(');
        display_string = [display_string,'+',process_string];
    end
    display_string = [display_string,' \rightarrow '];
    process_string = products{1};
    process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
    process_string = strrep(process_string, '(_','(');
    display_string = [display_string,process_string];
    for iter2 = 2:length(products)
        process_string = products{iter2};
        process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
        process_string = strrep(process_string, '(_','(');
        display_string = [display_string,'+',process_string];
    end
    
    cplt = semilogy(Scan_values*xlabel_multiplier, Rate(rD(production_key),:),'DisplayName',display_string);
    cplt.Color = MATLAB_colours(iter,:);
    cplt.LineWidth = Computational_line_width;
    cplt.LineStyle = '-';
    cplt.Marker = 'none';

    clear reactants products
end

ax.XLim = [0 100];
grid('on')

%title('Composition scan at 500W, 10mTorr')
xlabel('H_2 proportion of 100sccm supply (%)')
ylabel('Reaction rate (m^{-3})s^{-1}')
switch FigureWidth_control
case 'Full'
% Should always make full-width -- too complicated otherwise
    leg = legend('Location','northeastoutside');
case 'Column'
    leg = legend('Location','best'); %Changed from 'Location','southeast');
end
leg.FontSize = 12;

reaction_loss_figure = figure;

hold on;

ax = reaction_loss_figure.Children;
ax.YScale = 'log';

for iter = 1:min(length(loss_keys),5)
    loss_key = loss_keys{iter};

    reactants = Controller.ReactionDB.Key(loss_key).ReactantSpeciesDict.keys;
    products = Controller.ReactionDB.Key(loss_key).ProductSpeciesDict.keys;

    process_string = reactants{1};
    process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
    process_string = strrep(process_string, '(_','(');
    display_string = process_string;
    for iter2 = 2:length(reactants)
        process_string = reactants{iter2};
        process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
        process_string = strrep(process_string, '(_','(');
        display_string = [display_string,'+',process_string];
    end
    display_string = [display_string,' \rightarrow '];
    process_string = products{1};
    process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
    process_string = strrep(process_string, '(_','(');
    display_string = [display_string,process_string];
    for iter2 = 2:length(products)
        process_string = products{iter2};
        process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
        process_string = strrep(process_string, '(_','(');
        display_string = [display_string,'+',process_string];
    end
    
    cplt = semilogy(Scan_values*xlabel_multiplier, Rate(rD(loss_key),:),'DisplayName',display_string);
    cplt.Color = MATLAB_colours(iter,:);
    cplt.LineWidth = Computational_line_width;
    cplt.LineStyle = '-';
    cplt.Marker = 'none';

    clear reactants products
end

% table((Scan_values*xlabel_multiplier)',(Rate(rD('CAR_D7'),:))','VariableNames',{'H2Supply','Rate'})
% table((Scan_values*xlabel_multiplier)',(Rate(rD('CAR_D5'),:))','VariableNames',{'H2Supply','Rate'})

ax.XLim = [0 100];
grid('on')

%title('Composition scan at 500W, 10mTorr')
xlabel('H_2 proportion of 100sccm supply (%)')
ylabel('Reaction rate (m^{-3})s^{-1}')
switch FigureWidth_control
case 'Full'
% Should always make full-width -- too complicated otherwise
    leg = legend('Location','northeastoutside');
case 'Column'
    leg = legend('Location','best'); %Changed from 'Location','southeast');
end
leg.FontSize = 12;


%Save to file
    % CW.Format = 'eps';
    % hgexport(reaction_prod_figure,sprintf('%s/%s_prod.eps',figure_path,Species_Search),CW);
    % hgexport(reaction_loss_figure,sprintf('%s/%s_loss_.eps',figure_path,Species_Search),CW);
    CW.Format = 'png';
    disp(sprintf('%s/%s_prod.png',figure_path,Species_Search))
    hgexport(reaction_prod_figure,sprintf('%s/%s_prod.png',figure_path,Species_Search),CW);
    disp(sprintf('%s/%s_loss.png',figure_path,Species_Search))
    hgexport(reaction_loss_figure,sprintf('%s/%s_loss_.png',figure_path,Species_Search),CW);
    % savefig(reaction_prod_figure,sprintf('%s/%s_prod.fig',figure_path,Species_Search),CW);
    % savefig(reaction_loss_figure,sprintf('%s/%s_loss_.fig',figure_path,Species_Search),CW);
    close(reaction_prod_figure);
    close(reaction_loss_figure);
    clear('reaction_prod_figure');
    clear('reaction_loss_figure');









