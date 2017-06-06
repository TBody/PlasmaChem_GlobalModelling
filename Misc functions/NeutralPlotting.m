Normalised = true;
NeutralCompIndex = [Species_I2E.index('H'),Species_I2E.index('H2'),Species_I2E.index('N'),Species_I2E.index('N2'),Species_I2E.index('NH'),Species_I2E.index('NH3')];
NeutralExptIndex = [1,2,14,28,15,17];
NeutralLegend = {'H','H_2','N','N_2','NH','NH_3'};

NeutralFigure = figure;
count = 0;
First = true;
Normal_store = [];
for mass = NeutralExptIndex
    count = count + 1;
    if Normalised
        Max_Expt = max(meanCount_n(:,mass));
        Max_Model = max(Density(2:end-1,NeutralCompIndex(count)));
        Normalisation = Max_Model/Max_Expt;
        Normal_store = [Normal_store,Normalisation];
        errorbar(H2Supply_Expt,meanCount_n(:,mass)*Normalisation,stdCount_n(:,mass)*Normalisation,'x');
    else
        errorbar(H2Supply_Expt,meanCount_n(:,mass)*1.08e14,stdCount_n(:,mass)*1.08e14+9e13,'x');
    end
    if First
        hold on;
        First = false;
    end
end
NormTable_neutral = table(NeutralExptIndex',Normal_store','VariableNames',{'mass','norm'});
clear First Max_Expt Max_Model Normalisation Normal_store
ax = NeutralFigure.Children;
ax.YScale = 'log';
ax.XLim = [0 100];
ax.ColorOrderIndex = 1;
plot(X,Density(:,NeutralCompIndex))
ax.FontSize = 12;
for i = 1:6
    ax.Children(i).LineWidth = 3;
end
for i = 6:12
    ax.Children(i).MarkerSize = 10;
    ax.Children(i).LineWidth = 2;
end
title('Experimental verification')
xlabel('H_2 proportion of 100sccm supply (%)')
ylabel('Particle density (m^{-3})')
leg = legend(NeutralLegend,'Location','northeastoutside');
leg.FontSize = 12;
clear mass count i leg ax Normalised NeutralExptIndex NeutralCompIndex NeutralLegend