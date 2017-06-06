Normalised = true;
SCompIndex = [Species_I2E.index('F_s'),Species_I2E.index('H_s'),Species_I2E.index('N_s'),Species_I2E.index('NH_s'),Species_I2E.index('NH2_s'),Species_I2E.index('NH3')];
SLegend = {'F_s','H_s','N_s','NH_s','NH2_s','NH3'};
SFigure = figure;
semilogy(X,Density(:,SCompIndex))
ax = SFigure.Children;
ax.YScale = 'log';
%ax.XLim = [0 100];
ax.FontSize = 12;
for i = 1:length(SCompIndex)
    ax.Children(i).LineWidth = 3;
end
ax.Children(1).LineStyle = '--';
title('Surface species concentrations')
xlabel('H_2 proportion of 100sccm supply (%)')
ylabel('Particle density (m^{-3})')
leg = legend(SLegend,'Location','northeastoutside');
leg.FontSize = 12;
clear mass Normalisation count i leg ax Normalised SExptIndex SCompIndex SLegend