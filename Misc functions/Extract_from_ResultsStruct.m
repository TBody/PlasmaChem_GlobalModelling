Density = [];
ElectronT = [];
for i = 1:length(Results)
    Density = [Density;Results(i).Y(end,1:end-1)];
    ElectronT = [ElectronT;Results(i).Y(end,end)];
end