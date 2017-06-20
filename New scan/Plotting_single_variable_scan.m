function Plotting_single_variable_scan(Test_name,plot_style,plot_species,plot_Te,plot_error)
    %Inputs: Test_name (.mat file generated by Run_single_variable_scan.m)
    %        plot_style (function handle - either @plot, @semilogx, @semilogy, @loglog)
    %        plot_species (cell array with species keys)
    %        plot_Te (Boolean)
    %        plot_error (Boolean)
%% Function for plotting from a save-state generated by the Run_single_variable_scan.m function
%% This function will save a .mat file with the following variables --> (dims) <type>: description;
%% Number of species is S
%% Number of reactions is R
%% Number of tests is T
% Information                                                                      cstorage
    % Controller --------> GUI_control object    : stored for compatibility (use Controller.show('on') to show)
    % Species_I2E -------> (S,1) <cell array>    : list of species keys
    % Reaction_I2E ------> (R,1) <cell array>    : list of reaction keys
% Scan results
    % Converged ---------> (1,T) <vector bool>   : boolean vector of whether the test converged
    % Density -----------> (S,T) <vector double> : final density for species
    % DensityError ------> (S,T) <vector double> : error estimate on this result
    % Te ----------------> (1,T) <vector double> : final electron temperature
    % TeError -----------> (1,T) <vector double> : error estimate on this result
    % Rate --------------> (R,T) <vector double> : final evaluated rate coefficient
% Scan parameters
    % Scan_parameter ----> (1,1) <char string>   : text of which variable was scanned (Power, Pressure, Composition or Total_flow)
    % Scan_values -------> (T,1) <vector double> : values taken by the scanned parameter
% System parameters (length will be T for the Scan_parameter, and 1 otherwise)
    % H2Supply ----------> (*,1) <vector double> : sccm -> value supplied to gas supply for H2
    % N2Supply ----------> (*,1) <vector double> : sccm -> value supplied to gas supply for N2
    % Power -------------> (*,1) <vector double> : W -> value supplied as power absorbed
    % Pressure ----------> (*,1) <vector double> : mTorr -> value supplied to starting/background pressure

    load(Test_name)
    
    % species_indices stores the indices corresponding to the elements in plot_species
    species_indices = [];
    for species_index = 1:length(plot_species)
        species_indices = [species_indices, find(strcmp(Species_I2E, plot_species{species_index}))];
    end
    clear species_index

    %plot the density in the style specified
    
    yyaxis left
    figure; plot_style(Scan_values,Density(species_indices,:))
    hold on;

    title(sprintf('%s scan',Scan_parameter))
    xlabel(Scan_parameter)
    ylabel('Species concentration (m^{-3})')
    
    yyaxis right
    plot(Scan_values,Te,'b--')
    ylabel('Electron temperature (eV)','Color','b')
    legend([plot_species,'T_e'])

end