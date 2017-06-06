process = Results(end).Y;
%Hydrogen!!
Y = zeros(size(process,1),length(SI2E_main)+1);
Y(:,end) = process(:,end); %copy T_e
for i = 1:length(SI2E_main)
   SpeciesKey = SI2E_main.Key(i);
   j = SI2E_H2.index(SpeciesKey);
   if j %skip element not found
       Y(:,i) = process(:,j);
   end
end
Results(end).Y = Y;
clear process Y i j SpeciesKey