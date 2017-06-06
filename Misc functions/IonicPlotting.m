Normalised = true;
IonicCompIndex = [Species_I2E.index('H+'),Species_I2E.index('H2+'),Species_I2E.index('N+'),Species_I2E.index('N2+'),Species_I2E.index('NH+'),Species_I2E.index('NH3+')];
IonicExptIndex = [1,2,14,28,15,17];
IonicLegend = {'H^+','H_2^+','N^+','N_2^+','NH^+','NH_3^+'};

IonicFigure = figure;
count = 0;
First = true;
Normal_store = [];
for mass = [1,2,14,28,15,17]
    count = count + 1;
    if Normalised
        Max_Expt = max(meanCount_i(:,mass));
        Max_Model = max(Density(2:end,IonicCompIndex(count)));
        Normalisation = Max_Model/Max_Expt;
        Normal_store = [Normal_store,Normalisation];
        errorbar(H2Supply_Expt,meanCount_i(:,mass)*Normalisation,stdCount_i(:,mass)*Normalisation+2e12,'x');
    else
        errorbar(H2Supply_Expt,meanCount_i(:,mass)*8.87e9,stdCount_i(:,mass)*8.87e9,'x');
    end
    if First
        hold on;
        First = false;
    end
end
NormTable_ionic = table(IonicExptIndex',Normal_store','VariableNames',{'mass','norm'});
clear First Max_Expt Max_Model Normalisation
ax = IonicFigure.Children;
ax.YScale = 'log';
ax.XLim = [0 100];
ax.ColorOrderIndex = 1;
plot(X,Density(:,IonicCompIndex))
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
leg = legend(IonicLegend,'Location','northeastoutside');
leg.FontSize = 12;
clear mass Normalisation count i leg ax Normalised IonicExptIndex IonicCompIndex IonicLegend