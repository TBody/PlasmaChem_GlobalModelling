NeutralCompIndex = [Species_I2E.index('H'),Species_I2E.index('H2'),Species_I2E.index('N'),Species_I2E.index('N2'),Species_I2E.index('NH'),Species_I2E.index('NH3')];
IonicCompIndex = [Species_I2E.index('H+'),Species_I2E.index('H2+'),Species_I2E.index('N+'),Species_I2E.index('N2+'),Species_I2E.index('NH+'),Species_I2E.index('NH3+')];
Mass_list = [1,2,14,28,15,17];
NeutralLegend = {'H','H_2','N','N_2','NH','NH_3'};
IonicLegend = {'H^+','H_2^+','N^+','N_2^+','NH^+','NH_3^+'};

NeutralFigure = figure;
semilogy(X,Density(:,NeutralCompIndex));
NeutralAxes = NeutralFigure.Children;
title('Neutral particle densities; dependance on electron density')
xlabel('Electron density (m^{-3})')
ylabel('Particle density (m^{-3})')
leg = legend(NeutralLegend,'Location','northeastoutside');
leg.FontSize = 12;

IonicFigure = figure;
semilogy(X,Density(:,IonicCompIndex));
IonicAxes = IonicFigure.Children;
title('Ionic particle densities; dependance on electron density')
xlabel('Electron density (m^{-3})')
ylabel('Particle density (m^{-3})')
leg = legend(IonicLegend,'Location','northeastoutside');
leg.FontSize = 12;

NeutralAxes.FontSize = 12;
IonicAxes.FontSize = 12;
for i = 1:length(Mass_list)
    NeutralAxes.Children(i).LineWidth = 3;
    IonicAxes.Children(i).LineWidth = 3;
end

clear NeutralCompIndex IonicCompIndex Mass_list NeutralLegend IonicLegend
clear NeutralAxes IonicAxes i leg