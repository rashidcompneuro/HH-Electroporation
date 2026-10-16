addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
clc;
clear all;
%% S5 Fig: benchmark of the HH model against Boinagrov et al. (2010), Fig 4:
%  HP-side TMP (V2) and stimulus for (a) a 0.5-us and (b) a 10-ns pulse,
%  cell with RC = 1e-7 s.
%  Present model: data/raw/SI_data/HH_Rashid_data_*.mat, made with
%  the HH model of model/HH_without_EP with R = 10^-4 in dynamics_HH.m (RC = 1e-7 s).
%  Boinagrov et al.: data/raw/SI_data/HH_boin_data_*.csv (digitised).
%  (Plotting codes originally plotting1.m and plotting2.m.)

%% ===================== (a) 0.5-us pulse =====================
% load the data from Boinagrov paper (RC=1e-4 ms, Fig4A)
data_boinagrov_TMP = readmatrix([project_root '/data/raw/SI_data/HH_boin_data_point5us_TMV.csv']);

time_boinagrov_TMP = data_boinagrov_TMP(:,1);
V2_boinagrov = data_boinagrov_TMP(:,2);

data_boinagrov_Vstim = readmatrix([project_root '/data/raw/SI_data/HH_boin_data_point5us_Vstim.csv']);
time_boinagrov_Vstim = data_boinagrov_Vstim(:,1);
Vstim_boinagrov = data_boinagrov_Vstim(:,2);
%%
data_Rashid = load([project_root '/data/raw/SI_data/HH_Rashid_data_point5us.mat']);

time_Rashid = (data_Rashid.t_tot-(5-0.5e-3))*1e3;
V2_Rashid = data_Rashid.y_tot(:,2);
t_on = (data_Rashid.ton-(5-0.5e-3))*1e3;
t_off = (data_Rashid.toff-(5-0.5e-3))*1e3;

Vstim = zeros(size(time_Rashid));
Vstim(time_Rashid >= t_on & time_Rashid <= t_off) = data_Rashid.V_stim;

%% Plotting for benchmarking

figure('Color','w');

% ==================== TMP ====================
subplot(2,1,1)

plot(time_Rashid, V2_Rashid, 'LineWidth',2);
hold on
scatter(time_boinagrov_TMP, V2_boinagrov, 35, 'filled');

xlim([0 2])

xlabel('time ($\mu$s)', 'FontName','Times', 'FontSize',25, Interpreter='latex')
ylabel('$V_2$ (mV)', 'Interpreter','latex', ...
    'FontName','Times', 'FontSize',25)

legend('Present model','Boinagrov et al.', ...
    'Location','best', ...
    'Box','off', ...
    'FontName','Times', ...
    'FontSize',18)

grid on;

set(gca,'FontSize',25);
set(gca,'FontName','Times');
set(gca,'LineWidth',1);
set(gca,'TickLength',[0.02 0.02]);
set(gca,'Box','on');


% ==================== STIMULUS ====================
subplot(2,1,2)

plot(time_Rashid, Vstim, 'LineWidth',2);
hold on
scatter(time_boinagrov_Vstim, Vstim_boinagrov, 35, 'filled');

xlim([0 2])

xlabel('time ($\mu$s)', 'FontName','Times', 'FontSize',25, Interpreter='latex')
ylabel('$V_{\mathrm{stim}}$ (mV)', ...
    'Interpreter','latex', ...
    'FontName','Times', ...
    'FontSize',25)

legend('Present model','Boinagrov et al.', ...
    'Location','best', ...
    'Box','off', ...
    'FontName','Times', ...
    'FontSize',18)

grid on;

set(gca,'FontSize',25);
set(gca,'FontName','Times');
set(gca,'LineWidth',1);
set(gca,'TickLength',[0.02 0.02]);
set(gca,'Box','on');


% ==================== FIGURE FORMATTING ====================
set(gcf,'PaperUnits','inches');
set(gcf,'PaperPosition',[0 0 6 7]);

set(gcf,'Position',[15 15 550 650]);

set(gca,'FontSize',25);
%%
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

finish_figure(h, fig_path('SI/S5_Fig_a.pdf'))

%% ===================== (b) 10-ns pulse =====================
% load the data from Boinagrov paper (RC=1e-4 ms, Fig4A)
data_boinagrov_TMP = readmatrix([project_root '/data/raw/SI_data/HH_boin_data_10ns_TMV.csv']);

time_boinagrov_TMP = data_boinagrov_TMP(:,1);
V2_boinagrov = data_boinagrov_TMP(:,2);

data_boinagrov_Vstim = readmatrix([project_root '/data/raw/SI_data/HH_boin_data_10ns_Vstim.csv']);
time_boinagrov_Vstim = data_boinagrov_Vstim(:,1);
Vstim_boinagrov = data_boinagrov_Vstim(:,2);
%%
data_Rashid = load([project_root '/data/raw/SI_data/HH_Rashid_data_10ns.mat']);

time_Rashid = (data_Rashid.t_tot-(5-10e-6))*1e6;
V2_Rashid = data_Rashid.y_tot(:,2);
t_on = (data_Rashid.ton-(5-10e-6))*1e6;
t_off = (data_Rashid.toff-(5-10e-6))*1e6;

Vstim = zeros(size(time_Rashid));
Vstim(time_Rashid >= t_on & time_Rashid <= t_off) = data_Rashid.V_stim;

%% Plotting for benchmarking

figure('Color','w');

% ==================== TMP ====================
subplot(2,1,1)

plot(time_Rashid, V2_Rashid, 'LineWidth',2);
hold on
scatter(time_boinagrov_TMP, V2_boinagrov, 35, 'filled');

xlim([0 100])
ylim([-1200 0])
xlabel('time (ns)', 'FontName','Times', 'FontSize',25, Interpreter='latex')
ylabel('$V_2$ (mV)', 'Interpreter','latex', ...
    'FontName','Times', 'FontSize',25)

legend('Present model','Boinagrov et al.', ...
    'Location','best', ...
    'Box','off', ...
    'FontName','Times', ...
    'FontSize',18)

grid on;

set(gca,'FontSize',25);
set(gca,'FontName','Times');
set(gca,'LineWidth',1);
set(gca,'TickLength',[0.02 0.02]);
set(gca,'Box','on');


% ==================== STIMULUS ====================
subplot(2,1,2)

plot(time_Rashid, Vstim, 'LineWidth',2);
hold on
scatter(time_boinagrov_Vstim, 10*Vstim_boinagrov, 35, 'filled');

xlim([0 100])
ylim([-100 12500])
xlabel('time (ns)', 'FontName','Times', 'FontSize',25, Interpreter='latex')
ylabel('$V_{\mathrm{stim}}$ (mV)', ...
    'Interpreter','latex', ...
    'FontName','Times', ...
    'FontSize',25)

legend('Present model','Boinagrov et al.', ...
    'Location','best', ...
    'Box','off', ...
    'FontName','Times', ...
    'FontSize',18)

grid on;

set(gca,'FontSize',25);
set(gca,'FontName','Times');
set(gca,'LineWidth',1);
set(gca,'TickLength',[0.02 0.02]);
set(gca,'Box','on');


% ==================== FIGURE FORMATTING ====================
set(gcf,'PaperUnits','inches');
set(gcf,'PaperPosition',[0 0 6 7]);

set(gcf,'Position',[15 15 550 650]);

set(gca,'FontSize',25);
%%
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

finish_figure(h, fig_path('SI/S5_Fig_b.pdf'))

