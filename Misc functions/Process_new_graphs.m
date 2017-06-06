H_index = Species_I2E.index('H');
H2_index = Species_I2E.index('H2');
N_index = Species_I2E.index('N');
N2_index = Species_I2E.index('N2');
Ionic_H_indices = [...
    Species_I2E.index('H+'),...
    Species_I2E.index('H2+'),...
    Species_I2E.index('H3+')];
Ionic_N_indices = [...
    Species_I2E.index('N+'),...
    Species_I2E.index('N2+'),...
    Species_I2E.index('N3+'),...
    Species_I2E.index('N4+')];
Total_H_indices = [H_index,H2_index,Ionic_H_indices];
Total_N_indices = [N_index,N2_index,Ionic_N_indices];
Total_neutral_indices = [];
Total_ionic_indices = [];
for i = 1:length(Species_I2E)
    SpeciesKey = Species_I2E.Key(i);
    switch Controller.SpeciesDB.Key(SpeciesKey).Type
        case 'Neutral'
            Total_neutral_indices = [Total_neutral_indices,i];
        case 'Positive Ion'
            Total_ionic_indices = [Total_ionic_indices,i];
    end
end

H_Dissoc = Density(:,H_index)./sum(Density(:,[H_index,H2_index]),2);
H_Ioniz = sum(Density(:,Ionic_H_indices),2)./sum(Density(:,Total_H_indices),2);
N_Dissoc = Density(:,N_index)./sum(Density(:,[N_index,N2_index]),2);
N_Ioniz = sum(Density(:,Ionic_N_indices),2)./sum(Density(:,Total_N_indices),2);
Total_Ioniz = sum(Density(:,Total_ionic_indices),2)./sum(Density(:,[Total_ionic_indices,Total_neutral_indices]),2);
PlotFigure = figure;

co =    [0    0.4470    0.7410;
    0.8500    0.3250    0.0980;
    0.9290    0.6940    0.1250;
    0.4940    0.1840    0.5560;
    0.4660    0.6740    0.1880;
    0.3010    0.7450    0.9330;
    0.6350    0.0780    0.1840];

plot(X,H_Dissoc,'Color',co(2,:),'LineStyle','-');
hold on;
plot(X,10^4*H_Ioniz,'Color',co(2,:),'LineStyle','--');
plot(X,N_Dissoc,'Color',co(1,:),'LineStyle','-');
plot(X,10^4*N_Ioniz,'Color',co(1,:),'LineStyle','--');
plot(X,10^4*Total_Ioniz,'Color',co(3,:),'LineStyle','--');
legend({'H dissoc.','H ioniz.','N dissoc.', 'N ioniz.', 'Total ioniz.'});

Axes = PlotFigure.Children(2);
if Axes.YLim(2) < 1
    Axes.YLim(2) = 1;
end
Axes.FontSize = 16;
for i=1:length(Axes.Children)
    Line = Axes.Children(i);
    Line.LineWidth = 3;
end
clear i Line Axes

xlabel(Xlabel)
ylabel('Fraction (\times 10^{-4} for ioniz.)')
title(Title)

clear co
clear H_Dissoc H_Ioniz N_Dissoc N_Ioniz Total_Ioniz
clear H_index H2_index N_index N2_index
clear Ionic_H_indices Ionic_N_indices Total_H_indices Total_N_indices
clear Total_neutral_indices Total_ionic_indices
clear SpeciesKey i ans
