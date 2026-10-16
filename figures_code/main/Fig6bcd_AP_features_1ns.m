addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
%% Plotting interplay of electroporation and excitation for 1 ns and 10 ns
clear all; clc; 
%%
% load 13457 mV HHK data -
load([project_root '/data/raw/excitation_data/HHK_1ns_13457mV.mat'])

% load 13457 mV HH data - AP threshold
load([project_root '/data/raw/excitation_data/HH_1ns_13457mV.mat'])
%% TMV at 13457(HH) vs TMV at 13457(HHK)

t_tot_1ns_13457mV_HHK = t_tot; 
y_tot_1ns_13457mV_HHK = y_tot;
%% T50%
Vstims_1ns = [13457; 14000; 14100; 14200; 14500; 15000;15500; 15600; 15700; 15800; 15900; 16000];
T_50_HH = [1.0893; 1.27; 1.2656; 1.2746; 1.2720; 1.30; 1.3185;1.3186; 1.3169; 1.3181; 1.3188; 1.3189];
T_50_HHK = [1.2739; 1.3439; 1.3591; 1.3676; 1.3779; 1.4705; 2.0122; 2.5382; 8.2164; 879.1115; 1748.4; 2590.9];

Vstims_SAP = [13457; 14000];      T_50_SAP_HHK = [1.2739; 1.3439];
Vstims_RS  = [14100; 14200; 14500];             T_50_RS_HHK  = [1.3591; 1.3676; 1.3779]; 
Vstims_DB  = [15000;15500;15600;15700;15800;15900;16000]; 
T_50_DB_HHK = [1.4705; 2.0122; 2.5382; 8.2164; 879.1115; 1748.4; 2590.9];

%Main figure
figure;

% HHK line
plot(Vstims_1ns, T_50_HHK, 'LineWidth', 2, 'LineStyle', '-', 'Color', 'k'); hold on
% HH line
plot(Vstims_1ns, T_50_HH, 'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');

% Markers (unfilled with colored edges)
h_SAP = plot(Vstims_SAP, T_50_SAP_HHK, 'd', 'MarkerSize', 10, ...
    'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2);

h_RS = plot(Vstims_RS, T_50_RS_HHK, '>', 'MarkerSize', 10, ...
    'MarkerEdgeColor',[0.5,0.2,0.8],'MarkerFaceColor','none','LineWidth',1.2);

h_DB = plot(Vstims_DB, T_50_DB_HHK, '<', 'MarkerSize', 10, ...
    'MarkerEdgeColor',[0 0.5 0],'MarkerFaceColor','none','LineWidth',1.2);

h_HH = plot(Vstims_1ns, T_50_HH, 's', 'MarkerSize', 10, ...
    'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2);

% Axes labels
%xlabel('$V_{\text{stim}}$ (mV)', 'Interpreter','latex', 'FontSize', 16);
xlabel('$V_{\mathrm{stim}}$ (mV)', 'Interpreter', 'latex')
ylabel('$T_{50\%}$ (ms)', 'Interpreter','latex', 'FontSize', 18);

% Legend (only markers, no lines)
legend([h_SAP h_RS h_DB h_HH], ...
       {'SAP (HHK)', 'Repetitive Spike (HHK)', 'Depolarization Block (HHK)', ...
        'SAP (HH)'}, ...
       'Box','off','Location','best','Interpreter','latex','FontSize',15, NumColumns=2);

% Axes formatting
set(gca,'YScale','log','FontSize',21,'FontName','Times','LineWidth',1)
xlim([1.3e4 1.65e4])
ylim([0.5 3e3])
yticks([1e0 1e1 1e2 1e3])

ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 0;

% set(gcf,'Position',[15 15 550 420])
% set(gca,'Position',[0.17 0.17 0.80 0.77])

set(gcf, 'PaperPosition', [0 0 6 4]); 
set(gcf, 'Position', [15 15 550 420])
set(gca, 'Position', [0.17 0.17 0.80 0.77])
set(gca, 'FontSize', 25)
set(gca, 'FontName', 'Times')
set(gca, 'LineWidth', 1)
set(gca, 'TickLength', [0.02 0.02])


% Inset
inset_ax = axes('Position',[0.55 0.45 0.30 0.3]);
hold(inset_ax,'on')

% HHK/HH lines (background only)
plot(inset_ax, Vstims_1ns(1:6), T_50_HHK(1:6), 'LineWidth', 2, 'Color','k', LineStyle='-')
plot(inset_ax, Vstims_1ns(1:6), T_50_HH(1:6), 'LineWidth', 2, 'Color','k', LineStyle='--')

% Markers (unfilled with colored edges)
plot(inset_ax, Vstims_SAP, T_50_SAP_HHK, 'd', 'MarkerSize', 10, ...
    'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2)

plot(inset_ax, Vstims_RS, T_50_RS_HHK, '>', 'MarkerSize', 10, ...
    'MarkerEdgeColor',[0.5,0.2,0.8],'MarkerFaceColor','none','LineWidth',1.2)

plot(inset_ax, Vstims_DB(1), T_50_DB_HHK(1), '<', 'MarkerSize', 10, ...
    'MarkerEdgeColor',[0 0.5 0],'MarkerFaceColor','none','LineWidth',1.2)

plot(inset_ax, Vstims_1ns(1:6), T_50_HH(1:6), 's', 'MarkerSize', 10, ...
    'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2)

ylim(inset_ax, [1 1.5])
set(inset_ax,'FontSize',15,'FontName','Times','TickLabelInterpreter','latex', ...
    'Box','on','LineWidth',1.2,'XMinorTick','on','YMinorTick','on')

% Inset formatting

set(inset_ax, 'FontSize', 22, 'FontName', 'Times')
set(inset_ax, 'LineWidth', 1.5, 'TickLength', [0.02 0.02])
inset_ax.TickLabelInterpreter = 'latex';
grid on
%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig6c.pdf');
 

% Save as PDF
finish_figure(h, save_path);

close all
%
%% AP Amplitude vs Vstim (1 ns pulse)

% Data
Vstims_1ns = [13457; 14000; 14100; 14200; 14500; 15000;15500; 15600; 15700; 15800; 15900; 16000];
TMV_response_HH  = [29.3441; 36.5007; 36.8135; 37.0548; 37.6338; 38.3941; 38.8318; 38.8929; 38.9530; 38.9931; 39.0266; 39.0548];
TMV_response_HHK = [36.6111; 38.5742; 38.8349; 39.086; 39.5553; 38.3559; 29.4263; 25.9495; 22.0148; 17.8647; 13.8668; 10.3533];

% Sub-classify HHK responses
Vstims_SAP = [13457; 14000];      
Amp_SAP_HHK = TMV_response_HHK(1:2);

Vstims_RS  = [14100; 14200; 14500];             
Amp_RS_HHK = TMV_response_HHK(3:5);

Vstims_DB  = [15000;15500;15600;15700;15800;15900;16000]; 
Amp_DB_HHK = TMV_response_HHK(6:end);

% Main figure
figure;

% HHK line
plot(Vstims_1ns, TMV_response_HHK, 'LineWidth', 2, 'LineStyle', '-', 'Color', 'k'); hold on
% HH line
plot(Vstims_1ns, TMV_response_HH, 'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');

% Markers (unfilled with colored edges)
h_SAP = plot(Vstims_SAP, Amp_SAP_HHK, 'd', 'MarkerSize', 10, ...
    'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2);

h_RS = plot(Vstims_RS, Amp_RS_HHK, '>', 'MarkerSize', 10, ...
    'MarkerEdgeColor',[0.5,0.2,0.8],'MarkerFaceColor','none','LineWidth',1.2);

% h_DB = plot(Vstims_DB, Amp_DB_HHK, '<', 'MarkerSize', 9, ...
%     'MarkerEdgeColor',[0.85,0.65,0.13],'MarkerFaceColor','none','LineWidth',1.2);

h_DB = plot(Vstims_DB, Amp_DB_HHK, '<', 'MarkerSize', 10, ...
    'MarkerEdgeColor',[0 0.5 0],'MarkerFaceColor','none','LineWidth',1.2);

h_HH = plot(Vstims_1ns, TMV_response_HH, 's', 'MarkerSize', 10, ...
    'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2);

% Axes labels
%xlabel('$V_{stim}$ (mV)', 'Interpreter','latex', 'FontSize', 16);
xlabel('$V_{\mathrm{stim}}$ (mV)', 'Interpreter', 'latex')
%ylabel('AP amplitude (mV)', 'Interpreter','latex', 'FontSize', 25);
%ylabel('V_{peak}^{post} (mV)')
ylabel('$V_{\mathrm{peak}}^{\mathrm{AP}}$ (mV)', 'Interpreter','latex', 'FontSize', 25);


% Legend
legend([h_SAP h_RS h_DB h_HH], ...
       {'SAP (HHK)', 'Repetitive Spike (HHK)', 'Depolarization Block (HHK)', ...
        'SAP (HH)'}, ...
       'Box','off','Location','best','Interpreter','latex','FontSize',18);

% Axes formatting
%set(gca,'FontSize',25,'FontName','Times','LineWidth',1)
xlim([1.3e4 1.65e4])
ylim([8 42])
set(gcf, 'PaperPosition', [0 0 6 4]); 
set(gcf, 'Position', [15 15 550 420])
set(gca, 'Position', [0.17 0.17 0.80 0.77])
set(gca, 'FontSize', 25)
set(gca, 'FontName', 'Times')
set(gca, 'LineWidth', 1)
set(gca, 'TickLength', [0.02 0.02])

ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 0;

% set(gcf,'Position',[15 15 550 420])
% set(gca,'Position',[0.17 0.17 0.80 0.77])


%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig6d.pdf');
 

% Save as PDF
finish_figure(h, save_path);

close all
%% Spike latency vs Vstim (1 ns pulse)

% Data
Vstims_1ns = [13457; 14000; 14100; 14200; 14500; 15000;15500; 15600; 15700; 15800; 15900; 16000];
spike_latency_HH  = [15.0882; 9.7975; 9.5953; 9.4167; 9.0585; 8.7346; 8.6358; 8.6291; 8.6256; 8.6207; 8.6175; 8.6156]-5;
spike_latency_HHK = [3.9657; 2.0765; 1.8247; 1.6155; 1.1327; 0.6421; 0.4867; 0.4833; 0.4928; 0.5304; 0.5422; 0.5286];

% Sub-classify HHK responses
Vstims_SAP = [13457; 14000];      
spike_latency_SAP_HHK = spike_latency_HHK(1:2);

Vstims_RS  = [14100; 14200; 14500];             
spike_latency_RS_HHK = spike_latency_HHK(3:5);

Vstims_DB  = [15000;15500;15600;15700;15800;15900;16000]; 
spike_latency_DB_HHK = spike_latency_HHK(6:end);

% Main figure
figure;

% HHK line
plot(Vstims_1ns, spike_latency_HHK, 'LineWidth', 2, 'LineStyle', '-', 'Color', 'k'); hold on
% HH line
plot(Vstims_1ns, spike_latency_HH, 'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');

% Markers (unfilled with colored edges)
h_SAP = plot(Vstims_SAP, spike_latency_SAP_HHK, 'd', 'MarkerSize', 10, ...
    'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2);

h_RS = plot(Vstims_RS, spike_latency_RS_HHK, '>', 'MarkerSize', 10, ...
    'MarkerEdgeColor',[0.5,0.2,0.8],'MarkerFaceColor','none','LineWidth',1.2);

% h_DB = plot(Vstims_DB, Amp_DB_HHK, '<', 'MarkerSize', 9, ...
%     'MarkerEdgeColor',[0.85,0.65,0.13],'MarkerFaceColor','none','LineWidth',1.2);

h_DB = plot(Vstims_DB, spike_latency_DB_HHK, '<', 'MarkerSize', 10, ...
    'MarkerEdgeColor',[0 0.5 0],'MarkerFaceColor','none','LineWidth',1.2);

h_HH = plot(Vstims_1ns, spike_latency_HH, 's', 'MarkerSize', 10, ...
    'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2);

% Axes labels
% xlabel('$V_{stim}$ (mV)', 'Interpreter','latex', 'FontSize', 16);
xlabel('$V_{\mathrm{stim}}$ (mV)', 'Interpreter', 'latex')
ylabel('Spike latency (ms)', 'Interpreter','latex', 'FontSize', 16);

% Legend
legend([h_SAP h_RS h_DB h_HH], ...
       {'SAP (HHK)', 'Repetitive Spike (HHK)', 'Depolarization Block (HHK)', ...
        'SAP (HH)'}, ...
       'Box','off','Location','best','Interpreter','latex','FontSize',18);

% Axes formatting
%set(gca,'FontSize',25,'FontName','Times','LineWidth',1)
xlim([1.3e4 1.65e4])
ylim([-2 12])
yticks([0 2 4 6 8 10 12])
ax = gca;
ax.XAxis.Exponent = 4;
ax.YAxis.Exponent = 0;

set(gcf, 'PaperPosition', [0 0 6 4]); 
set(gcf, 'Position', [15 15 550 420])
set(gca, 'Position', [0.17 0.17 0.80 0.77])
set(gca, 'FontSize', 25)
set(gca, 'FontName', 'Times')
set(gca, 'LineWidth', 1)
set(gca, 'TickLength', [0.02 0.02])

% set(gcf,'Position',[15 15 550 420])
% set(gca,'Position',[0.17 0.17 0.80 0.77])
%
%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig6b.pdf');
 

% Save as PDF
finish_figure(h, save_path);

close all


%% How the AP features above were measured (example: 13457 mV runs; see compute_AP_metrics.m)
%% for HH 13457 1 ns
time_for_inv_2 = t_tot_1ns_13457mV_HH(t_tot_1ns_13457mV_HH>5+1.1e-3);
TMV_inv_2 = y_tot_1ns_13457mV_HH(t_tot_1ns_13457mV_HH>5+1.1e-3);
TMP_amp_2 = max(TMV_inv_2)
V = TMV_inv_2;
t = time_for_inv_2;
%% for HHK 13457 1 ns
time_for_inv_1 = t_tot_1ns_13457mV_HHK(t_tot_1ns_13457mV_HHK>5+1.1e-3);
TMV_inv_1 = y_tot_1ns_13457mV_HHK(t_tot_1ns_13457mV_HHK>5+1.1e-3);
TMP_amp_1 = max(TMV_inv_1);

V = TMV_inv_1;
t = time_for_inv_1;
%%
time_for_inv_3 = t_tot(t_tot>5+1.1e-3);
TMV_inv_3 = y_tot(t_tot>5+1.1e-3);
TMP_amp_3 = max(TMV_inv_3);

V = TMV_inv_3;
t = time_for_inv_3;

%%
V_rest = -70;   % or compute from baseline window

% --- 1. First AP peak ---
[V_peak, idx_peak] = max(V)
t_peak = t(idx_peak)

% --- 2. Amplitude & thresholds ---
amp = V_peak - V_rest
V_APD50 = V_rest + 0.5*amp;   % for 50% recovery
V_APD90 = V_rest + 0.1*amp;   % for 90% recovery

% Guard rail: stop searching once Vm is close to rest
V_cut = V_rest + 0.2*amp;     % 20% above rest

% --- 3. Find recovery crossing (after peak only) ---
% Limit search until signal is near baseline again
idx_stop = find(V(idx_peak:end) < V_cut, 1, 'first') + idx_peak - 1;

% 50% recovery
idx_down50 = find(V(idx_peak:idx_stop) <= V_APD50, 1, 'first') + idx_peak - 1;
t_down50 = interp1(V(idx_down50-1:idx_down50), t(idx_down50-1:idx_down50), V_APD50);
recov50 = t_down50 - t(idx_peak)
