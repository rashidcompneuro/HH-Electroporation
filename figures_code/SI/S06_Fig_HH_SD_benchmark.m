addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
clc;
clear all;
%% S6 Fig: strength-duration curve of the HH model (no electroporation),
%  planar cell with RC = 1e-6 s, benchmarked against Boinagrov et al. (2010), Fig 3.
%
%  Present work: excitation thresholds of model/HH_without_EP (R = 10^-3 in
%  dynamics_HH.m). Up to 1 ms: found with HH_single_pulse.m, one run per
%  pulse duration, raising V_stim until the first action potential.
%  2-20 ms: computed with HH_SD_threshold.m (bisection to 0.01 mV) at
%  Boinagrov's pulse durations.

data = csvread([project_root '/data/strength_duration/RC1e-3ms_new-Table 1.csv']); % reading data from SD file
long = csvread([project_root '/data/strength_duration/SD_rheobase_1e-3ms.csv']);   % Boinagrov points for 2-20 ms pulses
long_HH = csvread([project_root '/data/strength_duration/SD_HH_long_1e-3ms.csv']); % present work, 2-20 ms pulses

% Digitised from Boinagrov et al. (2010), Fig 3: up to 1 ms (table) and 2-20 ms (rheobase file)
time_Boinagrov = [data(3:20,1); long(:,1)];  % (ms) pulse duration
Vstim_Boinagrov = [data(3:20,2); long(:,2)]; % (mV) threshold

% Present work: HH model without EP, up to 1 ms (table) and 2-20 ms (HH_SD_threshold.m)
time_HH = [data(3:20,4); long_HH(:,1)];  % (ms) pulse duration
Vstim_HH = [data(3:20,3); long_HH(:,2)]; % (mV) excitation threshold

%% Plot
figure;
loglog(time_HH, Vstim_HH, '-', 'Color', 'k', 'LineWidth', 2);
hold on;
loglog(time_Boinagrov, Vstim_Boinagrov, 'o', 'Color', [0.85 0.33 0.10], 'MarkerSize', 7, 'LineWidth', 1.5);
legend('Present work', 'Boinagrov (2010)', 'Location', 'northeast', 'Box', 'off', 'FontSize', 16);

xlim([3e-5 3e1]);
ylim([5e0 3e4]);
xticks([1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
yticks([1e1 1e2 1e3 1e4]);
grid on;
set(gcf,'Position',[15 15 550 420]);
set(gca,'Position',[0.17 0.17 0.80 0.77]);
set(gca,'FontSize',22);
set(gca,'FontName','Times');
xlabel('$\tau$ (ms)','FontSize',25,'Interpreter','Latex', FontWeight='bold');
ylabel('$V_{\mathrm{stim}}$ (mV)','FontSize',25,'Interpreter','Latex', FontWeight='bold');
set(gca,'LineWidth',1);
set(gca,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');
hold off;

%%
h = gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
finish_figure(h, fig_path('SI/S6_Fig.pdf'))
