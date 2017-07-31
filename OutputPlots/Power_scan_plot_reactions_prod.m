% Comp_scan_plot_reactions
% Only needs a small modification to plot ions, but cleaner if kept as two files
% Produce the updated plots (16/6/17)
% Including updated experimental results
% Needs to have 'New scan' folder on path
% See main README to set-up this folder

% Load composition scan savestates% Computational
load 'Composition_scan_10mTorr_500W.mat'
% Turn off an annoying warning
warning('off','MATLAB:handle_graphics:exceptions:SceneNode')

% To convert to percentage, etc -- scale all x-results by constant value
xlabel_multiplier = 1;

% Crop Scan_values to the same length as Density

% Scan_values = Scan_values(1:size(Density,2));
Scan_values = Scan_values(1:20);
Rate = Rate(:,1:20);
Te = Te(1:20);

% What to plot? Store in a dictionary

Find_in_SI2E = @(Species_Key) find(strcmp(Species_I2E, Species_Key));
Find_in_RI2E = @(Reaction_Key) find(strcmp(Reaction_I2E, Reaction_Key));

% Plotting dictionary
% First element is SI2E index, second is mass index (for expt)
pD = containers.Map();
rD = containers.Map();
% Prod =
rD('CAR_W15') = Find_in_RI2E('CAR_W15');
rD('CAR_W14') = Find_in_RI2E('CAR_W14');
rD('CAR_W12') = Find_in_RI2E('CAR_W12');
rD('CAR_W13') = Find_in_RI2E('CAR_W13');
rD('CAR_N10') = Find_in_RI2E('CAR_N10');

% Loss =
rD('CAR_D6')  = Find_in_RI2E('CAR_D6');
rD('CAR_D7')  = Find_in_RI2E('CAR_D7');
rD('CAR_T25') = Find_in_RI2E('CAR_T25');
rD('CAR_I11') = Find_in_RI2E('CAR_I11');
rD('CAR_T22') = Find_in_RI2E('CAR_T22');
rD('CAR_T1')  = Find_in_RI2E('CAR_T1');
rD('CAR_T8')  = Find_in_RI2E('CAR_T8');
rD('CAR_I12') = Find_in_RI2E('CAR_I12');
rD('CAR_T4')  = Find_in_RI2E('CAR_T4');
rD('CAR_T20') = Find_in_RI2E('CAR_T20');
pD('NH3') = Find_in_SI2E('NH3');

% Find where NH3 production is highest
max_NH3_index = find(Density(pD('NH3'),:)==max(Density(pD('NH3'),:)));
max_rate = Rate(:,max_NH3_index);

production_keys = {'CAR_W15', 'CAR_W14', 'CAR_W12', 'CAR_W13', 'CAR_N10'};
production_indices = [rD('CAR_W15'),rD('CAR_W14'),rD('CAR_W12'),rD('CAR_W13'),rD('CAR_N10')];
[~,production_sorting] = sort(max_rate(production_indices),'descend');
production_keys = production_keys(production_sorting);
production_indices = production_indices(production_sorting);

loss_keys = {'CAR_D6','CAR_D7','CAR_T25','CAR_I11','CAR_T22','CAR_T1','CAR_T8','CAR_I12','CAR_T4','CAR_T20'};
loss_indices = [rD('CAR_D6'), rD('CAR_D7'), rD('CAR_T25'), rD('CAR_I11'), rD('CAR_T22'), rD('CAR_T1'), rD('CAR_T8'), rD('CAR_I12'), rD('CAR_T4'), rD('CAR_T20')];
[~,loss_sorting] = sort(max_rate(loss_indices),'descend');
loss_keys = loss_keys(loss_sorting);
loss_indices = loss_indices(loss_sorting);

table(production_keys', max_rate(production_indices),'VariableNames',{'Reaction','Rate'})
table(loss_keys', max_rate(loss_indices),'VariableNames',{'Reaction','Rate'})

reaction_figure = figure;

hold on;

ax = reaction_figure.Children;
ax.YScale = 'log';
ax.XScale = 'log';

%yyaxis left

% cplt = semilogy(Scan_values*xlabel_multiplier, Density(pD('NH3'),:));
% cplt.Color = MATLAB_colours(6,:);
% cplt.LineWidth = Computational_line_width;
% cplt.LineStyle = '--';
% cplt.Marker = 'none';

for iter = 1:5
    production_key = production_keys{iter};

    reactants = Controller.ReactionDB.Key(production_key).ReactantSpeciesDict.keys;
    products = Controller.ReactionDB.Key(production_key).ProductSpeciesDict.keys;

    process_string = reactants{1};
    process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
    display_string = process_string;
    for iter2 = 2:length(reactants)
        process_string = reactants{iter2};
        process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
        display_string = [display_string,'+',process_string];
    end
    display_string = [display_string,' \rightarrow '];
    process_string = products{1};
    process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
    display_string = [display_string,process_string];
    for iter2 = 2:length(products)
        process_string = products{iter2};
        process_string = strrep(strrep(process_string,process_string(regexp(process_string,'\d')),['_',process_string(regexp(process_string,'\d'))]),'+','^+'); process_string = strrep(process_string,process_string(regexp(process_string,'\d_s')),[process_string(regexp(process_string,'\d')),'_,']);
        display_string = [display_string,'+',process_string];
    end

    cplt = semilogy(Scan_values*xlabel_multiplier, Rate(rD(production_key),:),'DisplayName',display_string);
    cplt.Color = MATLAB_colours(iter,:);
    cplt.LineWidth = Computational_line_width;
    cplt.LineStyle = '-';
    cplt.Marker = 'none';
end
% for iter = 1:5
%     loss_key = loss_keys{iter};
%     cplt = semilogy(Scan_values*xlabel_multiplier, Rate(rD(loss_key),:),'DisplayName',strrep(loss_key,'_','\_'));
%     cplt.Color = MATLAB_colours(iter,:);
%     cplt.LineWidth = Computational_line_width;
%     cplt.LineStyle = '--';
%     cplt.Marker = 'none';
% end

ax.XLim = [Scan_values(1) Scan_values(20)];
grid('on')

%title('Composition scan at 500W, 10mTorr')
xlabel('Electron density (m^{-3})')
ylabel('Reaction rate (m^{-3})s^{-1}')
switch FigureWidth_control
case 'Full'
% Should always make full-width -- too complicated otherwise
    leg = legend('Location','northeastoutside');
case 'Column'
    leg = legend('Location','best'); %Changed from 'Location','southeast');
end
leg.FontSize = 12;

%yyaxis right
%plot(Scan_values*xlabel_multiplier,Te,'--','LineWidth',Computational_line_width,'DisplayName','Te')
%ylabel('Electron temperature (eV)')

clear('Density','DensityError','Find_in_RI2E','Find_in_SI2E','H2Supply','N2Supply','Power','Pressure','Rate','Reaction_I2E','Scan_parameter','Scan_values','Species_I2E','Te','TeError','ans','ax','cplt','iter','leg','loss_indices','loss_key','loss_keys','loss_sorting','max_NH3_index','max_rate','pD','production_indices','production_key','production_keys','production_sorting','rD','xlabel_multiplier')