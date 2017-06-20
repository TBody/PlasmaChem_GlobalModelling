H2 = [0:10:100];

ne = [1.32 1.6 1.67 1.84 1.94 2.11 2.47 2.63 2.73 2.61 1.66]

figure(1)
plot(H2, ne, 'ko', 'Markersize', 12)


set(gca,'FontSize',24,'FontName','Times')
xlabel('H2 (%)', 'FontName', 'Times', 'FontSize', 24); 
ylabel('Electron density (x 10^{16} m^{-3}', 'FontName', 'Times', 'FontSize', 24);

box on