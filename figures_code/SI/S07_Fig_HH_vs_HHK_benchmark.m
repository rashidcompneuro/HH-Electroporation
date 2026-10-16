addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% ================================================================
% Benchmarking HH vs HHK without Electroporation
%
% Vstim = 1589 mV
% Pulse duration = 100 ns
% RC = 1e-8 s
%
% Purpose:
% Quantitatively compare the excitation response of:
%   1. Conventional HH model
%   2. HHK model with EP inactive
%
% The two simulations use different adaptive solver configurations,
% and therefore have different temporal discretizations.
% ================================================================

clear;
clc;
close all;


%% ================================================================
% % 1. File paths
% % ================================================================
% 
% folder_path = ...
%     [project_root '/data/raw/100ns_1e5/'];
% 
% HH_file = fullfile(folder_path, ...
%     'HH_100ns_1e5_APthreshold.mat');
% 
% HHK_file = fullfile(folder_path, ...
%     'HHKv_100ns_1e5_APthreshold.mat');

%%
% 1. File paths
% ================================================================

folder_path = ...
    [project_root '/data/raw/100ns_1e5/'];

HH_file = fullfile(folder_path, ...
    'HH_100ns_1e5_2000mV.mat');

HHK_file = fullfile(folder_path, ...
    'HHKv_100ns_1e5_2000mV.mat');

%% ================================================================
% 2. Load data
% ================================================================

HH_data = load(HH_file);
HHK_data = load(HHK_file);


%% ================================================================
% 3. Extract time and membrane potential
% ================================================================

% t_HH = HH_data.t_tot_HH_1589mV_100ns;
% V_HH = HH_data.y_tot_HH_1589mV_100ns(:,1);
% 
% t_HHK = HHK_data.t_tot_HHKv_1589mV_100ns;
% V_HHK = HHK_data.y_tot_HHKv_1589mV_100ns(:,1);

%%
%% ================================================================
% 3. Extract time and membrane potential
% ================================================================

t_HH = HH_data.t_tot_HH_2000mV_100ns;
V_HH = HH_data.y_tot_HH_2000mV_100ns(:,1);

t_HHK = HHK_data.t_tot_HHKv_2000mV_100ns;
V_HHK = HHK_data.y_tot_HHKv_2000mV_100ns(:,1);


%% ================================================================
% 4. Basic information about the original data
% ================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('Original data\n');
fprintf('============================================================\n');

fprintf('HH  total points  = %d\n', length(t_HH));
fprintf('HH  unique points = %d\n', length(unique(t_HH)));

fprintf('HHK total points  = %d\n', length(t_HHK));
fprintf('HHK unique points = %d\n', length(unique(t_HHK)));

fprintf('\n');


%% ================================================================
% 5. Sort time vectors
%
% This does NOT modify the original saved data.
% We create sorted copies for interpolation.
% ================================================================

[t_HH_sorted, idx_HH_sort] = sort(t_HH);
V_HH_sorted = V_HH(idx_HH_sort);

[t_HHK_sorted, idx_HHK_sort] = sort(t_HHK);
V_HHK_sorted = V_HHK(idx_HHK_sort);


%% ================================================================
% 6. Remove repeated time points
%
% If the same time occurs more than once, retain the last
% corresponding voltage value.
% ================================================================

[t_HH_unique, idx_HH_unique] = ...
    unique(t_HH_sorted, 'last');

V_HH_unique = V_HH_sorted(idx_HH_unique);


[t_HHK_unique, idx_HHK_unique] = ...
    unique(t_HHK_sorted, 'last');

V_HHK_unique = V_HHK_sorted(idx_HHK_unique);


fprintf('After removing repeated points:\n');

fprintf('HH  points  = %d\n', length(t_HH_unique));
fprintf('HHK points  = %d\n', length(t_HHK_unique));

fprintf('\n');


%% ================================================================
% 7. Determine common time interval
% ================================================================

t_start = max( ...
    t_HH_unique(1), ...
    t_HHK_unique(1));

t_end = min( ...
    t_HH_unique(end), ...
    t_HHK_unique(end));


fprintf('Common time interval:\n');
fprintf('t = %.8g to %.8g ms\n', ...
    t_start, t_end);

fprintf('\n');


%% ================================================================
% 8. FULL-SIMULATION COMPARISON
%
% Use an independent common grid.
% ================================================================

N_full = 100000;

t_common_full = ...
    linspace(t_start, t_end, N_full);


%% ================================================================
% 9. Interpolate both solutions onto common grid
% ================================================================

V_HH_full = interp1( ...
    t_HH_unique, ...
    V_HH_unique, ...
    t_common_full, ...
    'pchip');

V_HHK_full = interp1( ...
    t_HHK_unique, ...
    V_HHK_unique, ...
    t_common_full, ...
    'pchip');


%% ================================================================
% 10. Full-simulation error
% ================================================================

error_full = ...
    V_HH_full - V_HHK_full;

absolute_error_full = ...
    abs(error_full);


%% ================================================================
% 11. Full-simulation RMSE
% ================================================================

RMSE_full = ...
    sqrt(mean(error_full.^2));


%% ================================================================
% 12. Full-simulation maximum absolute error
% ================================================================

max_error_full = ...
    max(absolute_error_full);


%% ================================================================
% 13. Full-simulation relative L2 error
% ================================================================

relative_L2_full = ...
    norm(error_full) / norm(V_HH_full);

relative_L2_full_percent = ...
    100 * relative_L2_full;


%% ================================================================
% 14. Peak membrane potential
% ================================================================

[Vpeak_HH, idx_peak_HH] = ...
    max(V_HH_full);

[Vpeak_HHK, idx_peak_HHK] = ...
    max(V_HHK_full);


tpeak_HH = ...
    t_common_full(idx_peak_HH);

tpeak_HHK = ...
    t_common_full(idx_peak_HHK);


delta_Vpeak = ...
    abs(Vpeak_HH - Vpeak_HHK);

delta_tpeak = ...
    abs(tpeak_HH - tpeak_HHK);


%% ================================================================
% 15. Print full-simulation results
% ================================================================

fprintf('============================================================\n');
fprintf('FULL-SIMULATION COMPARISON\n');
fprintf('============================================================\n');

fprintf('RMSE                    = %.8g mV\n', ...
    RMSE_full);

fprintf('Maximum absolute error  = %.8g mV\n', ...
    max_error_full);

fprintf('Relative L2 error       = %.8g %%\n', ...
    relative_L2_full_percent);

fprintf('\n');

fprintf('HH peak voltage         = %.8g mV\n', ...
    Vpeak_HH);

fprintf('HHK peak voltage        = %.8g mV\n', ...
    Vpeak_HHK);

fprintf('Peak voltage difference = %.8g mV\n', ...
    delta_Vpeak);

fprintf('\n');

fprintf('HH peak time            = %.8g ms\n', ...
    tpeak_HH);

fprintf('HHK peak time           = %.8g ms\n', ...
    tpeak_HHK);

fprintf('Peak time difference    = %.8g ms\n', ...
    delta_tpeak);

fprintf('============================================================\n');



%% ================================================================
% 16. Plot full membrane-potential comparison
% ================================================================

figure;

plot(t_common_full, ...
     V_HH_full, ...
     'LineWidth', 1.5);

hold on;

plot(t_common_full, ...
     V_HHK_full, ...
     '--', ...
     'LineWidth', 1.5);

xlabel('Time (ms)');
ylabel('Membrane Potential (mV)');

legend('HH', ...
       'HHK without EP', ...
       'Location', 'best');

title('HH vs HHK without Electroporation');

box on;



%% ================================================================
% 17. Plot full-simulation error
% ================================================================

figure;

plot(t_common_full, ...
     error_full, ...
     'LineWidth', 1.5);

hold on;

yline(0, '--');

xlabel('Time (ms)');

ylabel('$V_{\mathrm{HH}}-V_{\mathrm{HHK}}$ (mV)', ...
       'Interpreter', 'latex');

title('Difference between HH and HHK');

box on;



%% ================================================================
% 18. EXCITATION-WINDOW COMPARISON
%
% Stimulus is applied at t = 5 ms.
%
% We use a dense independent grid around the stimulus and AP.
% ================================================================

t_exc_start = 4.9;
t_exc_end   = 6.0;

N_exc = 100000;

t_common_exc = ...
    linspace(t_exc_start, t_exc_end, N_exc);


%% ================================================================
% 19. Interpolate HH and HHK in excitation window
% ================================================================

V_HH_exc = interp1( ...
    t_HH_unique, ...
    V_HH_unique, ...
    t_common_exc, ...
    'pchip');

V_HHK_exc = interp1( ...
    t_HHK_unique, ...
    V_HHK_unique, ...
    t_common_exc, ...
    'pchip');


%% ================================================================
% 20. Excitation-window error
% ================================================================

error_exc = ...
    V_HH_exc - V_HHK_exc;

absolute_error_exc = ...
    abs(error_exc);


%% ================================================================
% 21. Excitation-window RMSE
% ================================================================

RMSE_exc = ...
    sqrt(mean(error_exc.^2));


%% ================================================================
% 22. Excitation-window maximum error
% ================================================================

max_error_exc = ...
    max(absolute_error_exc);


%% ================================================================
% 23. Excitation-window relative L2 error
% ================================================================

relative_L2_exc = ...
    norm(error_exc) / norm(V_HH_exc);

relative_L2_exc_percent = ...
    100 * relative_L2_exc;


%% ================================================================
% 24. Excitation-window peak voltage
% ================================================================

[Vpeak_HH_exc, idx_peak_HH_exc] = ...
    max(V_HH_exc);

[Vpeak_HHK_exc, idx_peak_HHK_exc] = ...
    max(V_HHK_exc);


tpeak_HH_exc = ...
    t_common_exc(idx_peak_HH_exc);

tpeak_HHK_exc = ...
    t_common_exc(idx_peak_HHK_exc);


delta_Vpeak_exc = ...
    abs(Vpeak_HH_exc - Vpeak_HHK_exc);

delta_tpeak_exc = ...
    abs(tpeak_HH_exc - tpeak_HHK_exc);


%% ================================================================
% 25. Print excitation-window results
% ================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('EXCITATION-WINDOW COMPARISON\n');
fprintf('Window: %.3f - %.3f ms\n', ...
    t_exc_start, t_exc_end);
fprintf('============================================================\n');

fprintf('RMSE                    = %.8g mV\n', ...
    RMSE_exc);

fprintf('Maximum absolute error  = %.8g mV\n', ...
    max_error_exc);

fprintf('Relative L2 error       = %.8g %%\n', ...
    relative_L2_exc_percent);

fprintf('\n');

fprintf('HH peak voltage         = %.8g mV\n', ...
    Vpeak_HH_exc);

fprintf('HHK peak voltage        = %.8g mV\n', ...
    Vpeak_HHK_exc);

fprintf('Peak voltage difference = %.8g mV\n', ...
    delta_Vpeak_exc);

fprintf('\n');

fprintf('HH peak time            = %.8g ms\n', ...
    tpeak_HH_exc);

fprintf('HHK peak time           = %.8g ms\n', ...
    tpeak_HHK_exc);

fprintf('Peak time difference    = %.8g ms\n', ...
    delta_tpeak_exc);

fprintf('============================================================\n');



%% ================================================================
% 26. Plot excitation response
% ================================================================

figure;

plot(t_common_exc, ...
     V_HH_exc, ...
     'LineWidth', 1.5);

hold on;

plot(t_common_exc, ...
     V_HHK_exc, ...
     '--', ...
     'LineWidth', 1.5);

xlabel('Time (ms)');
ylabel('Membrane Potential (mV)');

legend('HH', ...
       'HHK without EP', ...
       'Location', 'best');

title('Excitation Response: HH vs HHK');

xlim([t_exc_start t_exc_end]);

box on;



%% ================================================================
% 27. Plot excitation error
% ================================================================

figure;

plot(t_common_exc, ...
     error_exc, ...
     'LineWidth', 1.5);

hold on;

yline(0, '--');

xlabel('Time (ms)');

ylabel('$V_{\mathrm{HH}}-V_{\mathrm{HHK}}$ (mV)', ...
       'Interpreter', 'latex');

title('HH-HHK Difference During Excitation');

xlim([t_exc_start t_exc_end]);

box on;



%% ================================================================
% 28. Plot absolute excitation error
% ================================================================

figure;

plot(t_common_exc, ...
     absolute_error_exc, ...
     'LineWidth', 1.5);

xlabel('Time (ms)');

ylabel('$|V_{\mathrm{HH}}-V_{\mathrm{HHK}}|$ (mV)', ...
       'Interpreter', 'latex');

title('Absolute Error During Excitation');

xlim([t_exc_start t_exc_end]);

box on;
%% ================================================================
% AP-WINDOW COMPARISON
% AP occurs from 6 to 20 ms
% ================================================================

t_AP_start = 6.0;
t_AP_end   = 20.0;

N_AP = 100000;

t_common_AP = linspace(t_AP_start, t_AP_end, N_AP);


%% ----------------------------------------------------------------
% Interpolate both solutions onto common AP grid
% -----------------------------------------------------------------

V_HH_AP = interp1( ...
    t_HH_unique, ...
    V_HH_unique, ...
    t_common_AP, ...
    'pchip');

V_HHK_AP = interp1( ...
    t_HHK_unique, ...
    V_HHK_unique, ...
    t_common_AP, ...
    'pchip');


%% ----------------------------------------------------------------
% Difference between AP waveforms
% -----------------------------------------------------------------

error_AP = V_HH_AP - V_HHK_AP;

absolute_error_AP = abs(error_AP);


%% ----------------------------------------------------------------
% RMSE
% -----------------------------------------------------------------

RMSE_AP = sqrt(mean(error_AP.^2));


%% ----------------------------------------------------------------
% Maximum absolute error
% -----------------------------------------------------------------

max_error_AP = max(absolute_error_AP);


%% ----------------------------------------------------------------
% Relative L2 error
% -----------------------------------------------------------------

relative_L2_AP = ...
    norm(error_AP) / norm(V_HH_AP);

relative_L2_AP_percent = ...
    100 * relative_L2_AP;


%% ----------------------------------------------------------------
% Peak membrane potential
% -----------------------------------------------------------------

[Vpeak_HH_AP, idx_HH_peak] = max(V_HH_AP);
[Vpeak_HHK_AP, idx_HHK_peak] = max(V_HHK_AP);

tpeak_HH_AP = t_common_AP(idx_HH_peak);
tpeak_HHK_AP = t_common_AP(idx_HHK_peak);


%% ----------------------------------------------------------------
% Peak differences
% -----------------------------------------------------------------

delta_Vpeak_AP = ...
    abs(Vpeak_HH_AP - Vpeak_HHK_AP);

delta_tpeak_AP = ...
    abs(tpeak_HH_AP - tpeak_HHK_AP);


%% ================================================================
% Print AP benchmarking results
% ================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('AP BENCHMARK: 6-20 ms\n');
fprintf('============================================================\n');

fprintf('RMSE                    = %.8g mV\n', ...
    RMSE_AP);

fprintf('Maximum absolute error  = %.8g mV\n', ...
    max_error_AP);

fprintf('Relative L2 error       = %.8g %%\n', ...
    relative_L2_AP_percent);

fprintf('\n');

fprintf('HH peak voltage         = %.8g mV\n', ...
    Vpeak_HH_AP);

fprintf('HHK peak voltage        = %.8g mV\n', ...
    Vpeak_HHK_AP);

fprintf('Peak voltage difference = %.8g mV\n', ...
    delta_Vpeak_AP);

fprintf('\n');

fprintf('HH peak time            = %.8g ms\n', ...
    tpeak_HH_AP);

fprintf('HHK peak time           = %.8g ms\n', ...
    tpeak_HHK_AP);

fprintf('Peak time difference    = %.8g ms\n', ...
    delta_tpeak_AP);

fprintf('============================================================\n');


%% ================================================================
% Plot AP comparison
% ================================================================

figure;

plot(t_common_AP, V_HH_AP, ...
    'LineWidth', 2);

hold on;

plot(t_common_AP, V_HHK_AP, '--', ...
    'LineWidth',2);

xlabel('time (ms)', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('$V_{1}$ (mV)', 'Interpreter', 'latex', 'FontSize', 18);
%

legend('HH', ...
       'HHK without EP', ...
       'Location', 'best');



box on;


% Styling main plot
set(gcf, 'PaperPosition', [0 0 6 4]); 
set(gcf, 'Position', [15 15 550 420])
set(gca, 'Position', [0.17 0.17 0.80 0.77])
set(gca, 'FontSize', 25)
set(gca, 'FontName', 'Times')
set(gca, 'LineWidth', 1)
set(gca, 'TickLength', [0.02 0.02])
xlim([6 20])
xticks([6 8 12 16 20])
grid on



%ylim([-100 50])
%%
%% saving the fig file as PDF
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S7_Fig_a.pdf');

% Save as PDF
finish_figure(h, save_path);

close all

%% ================================================================
% Plot AP difference
% ================================================================

figure;

plot(t_common_AP, error_AP, ...
    'LineWidth', 2);

hold on;

yline(0, '--');

xlabel('time (ms)');

ylabel('$V_{1_{\mathrm{HH}}}-V_{1_{\mathrm{HHK}}}$ (mV)', ...
    'Interpreter', 'latex');

xlim([6 20]);

box on;
% Styling main plot
set(gcf, 'PaperPosition', [0 0 6 4]); 
set(gcf, 'Position', [15 15 550 420])
set(gca, 'Position', [0.17 0.17 0.80 0.77])
set(gca, 'FontSize', 25)
set(gca, 'FontName', 'Times')
set(gca, 'LineWidth', 1)
set(gca, 'TickLength', [0.02 0.02])
xlim([6 20])
xticks([6 8 12 16 20])
grid on



%ylim([-100 50])
%% saving the fig file as PDF
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S7_Fig_b.pdf');

% Save as PDF
finish_figure(h, save_path);

close all

%% ================================================================
% Plot absolute AP error
% ================================================================

figure;

plot(t_common_AP, absolute_error_AP, ...
    'LineWidth', 1.5);

xlabel('Time (ms)');

ylabel('$|V_{\mathrm{HH}}-V_{\mathrm{HHK}}|$ (mV)', ...
    'Interpreter', 'latex');

title('Absolute AP Error');

xlim([6 20]);

box on;

%%
[max_error_AP, idx_max_error] = max(abs(error_AP));

t_max_error = t_common_AP(idx_max_error);

V_HH_at_error  = V_HH_AP(idx_max_error);
V_HHK_at_error = V_HHK_AP(idx_max_error);

fprintf('\nMaximum error occurs at:\n');
fprintf('t = %.8f ms\n', t_max_error);
fprintf('HH  = %.8f mV\n', V_HH_at_error);
fprintf('HHK = %.8f mV\n', V_HHK_at_error);
fprintf('Difference = %.8f mV\n', ...
    V_HH_at_error - V_HHK_at_error);
