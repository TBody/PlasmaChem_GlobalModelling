%%Code for running a single variable scan

Pressure = 10;

% Save_filename = 'Power_scan_10mTorr_50_50sccm';
% Power = 10.^[1:0.1:5];
% H2Supply = 50;
% N2Supply = 50;
% Scan_parameter = 'Power';
% Scan_values = Power;
% disp('running Power_scan_10mTorr_50_50sccm')
% Run_scan_from_script;

Save_filename = 'Composition_scan_10mTorr_500W';
Power = 500;
H2Supply = [1:1:99];
N2Supply = 100-[1:1:99];
Scan_parameter = 'Power';
Scan_values = H2Supply;
disp('running Composition_scan_10mTorr_500W')
Run_scan_from_script;

Save_filename = 'Composition_scan_10mTorr_1000W';
Power = 1000;
H2Supply = [1:1:99];
N2Supply = 100-[1:1:99];
Scan_parameter = 'Power';
Scan_values = H2Supply;
disp('running Composition_scan_10mTorr_1000W')
Run_scan_from_script;

% Save_filename = 'Supply_scan_10mTorr_500W';
% Power = 500;
% H2Supply = [5:5:100];
% N2Supply = [5:5:100];
% Scan_parameter = 'Total_flow';
% Scan_values = H2Supply+N2Supply;
% disp('running Supply_scan_10mTorr_500W')
% Run_scan_from_script;

% Save_filename = 'Supply_scan_10mTorr_1000W';
% Power = 1000;
% H2Supply = [5:5:100];
% N2Supply = [5:5:100];
% Scan_parameter = 'Total_flow';
% Scan_values = H2Supply+N2Supply;
% disp('running Supply_scan_10mTorr_1000W')
% Run_scan_from_script;