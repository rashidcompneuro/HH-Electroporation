addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
%% Plots showing TMV dynamics in SAP, RS and DB for 100 ns RC=1e-5 ms 
clear all;
clc
%% loading the data
%
load([project_root '/data/raw/100ns_1e5/HHK_100ns_1e5_SAP_RS_DB.mat'])
%% data for SAP
t_tot_SAP = all_t_tot{1};
y_tot_SAP = all_y_tot{1};
pulse = t_tot_SAP<=5+1e-4 & t_tot_SAP>=5; 
Vstims_SAP = V_stim_values(1,1).*(pulse);
%% ===================== Fig 2a: SAP =====================
    %% ===================== FIGURE =====================
figure(1); clf  % published version: draw on a clean figure

plot(t_tot_SAP, y_tot_SAP(:,1), t_tot_SAP, y_tot_SAP(:,2), LineWidth=2); 
hold on

xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('TMP (mV)', Interpreter='latex',FontSize=14);

legend('$V_1$','$V_{2}$','Box','off', ...
    Interpreter='latex',Location='northwest',fontsize=20)

ylim([-1000 1000])
set(gca, 'XScale', 'log');

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

xticks([1 10 100 1000 1e4])
xlim([0.5 20000])

hold off

% ===================== ARROW =====================
drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

annotation('arrow', ...
    [x_norm x_norm], ...
    [axpos(2)-0.08 axpos(2)], ...
    'Color','r', ...
    'LineWidth',1.6, ...
    'HeadLength',10, ...
    'HeadWidth',10);

% ===================== INSET 1: PULSE (ns SCALE) =====================
inset_ax1 = axes('Position',[0.60 0.65 0.25 0.25]);
hold(inset_ax1, 'on');

% Convert to ns (centered at 5 ms)
t_ns = (t_tot_SAP - 5)*1e6;

plot(inset_ax1, t_ns, y_tot_SAP(:,1), t_ns, y_tot_SAP(:,2), LineWidth=2);
plot(inset_ax1, t_ns, Vstims_SAP, LineWidth=2.5, Color='r', LineStyle='--');
%xlabel(inset_ax1, 'ns')
xlim(inset_ax1, [-10 120]);
ylim(inset_ax1, [-1200 2000]);

set(inset_ax1, 'FontSize', 20, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

% Optional subtle ticks (no labels)
xticks(inset_ax1, [0 100])
%xticklabels(inset_ax1, {'0', '100 ns'})
grid on
hold(inset_ax1, 'off');

% ===================== INSET 2: AP =====================
inset_ax2 = axes('Position',[0.60 0.25 0.25 0.25]);
hold(inset_ax2, 'on');

plot(inset_ax2, t_tot_SAP, y_tot_SAP(:,1), t_tot_SAP, y_tot_SAP(:,2), LineWidth=2);

xlim(inset_ax2, [10 20]);
ylim(inset_ax2, [-100 40]);

set(inset_ax2, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
grid on
hold(inset_ax2, 'off');
%% Plot for SAP
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig2a.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%
%% data for Repetitive Spiking
t_tot_RS = all_t_tot{3};
y_tot_RS = all_y_tot{3};
pulse = t_tot_RS<=5+1e-4 & t_tot_RS>=5; 
Vstims_RS = V_stim_values(3,1).*(pulse);

%% ===================== Fig 2b: RS =====================
figure(3); clf  % published version: draw on a clean figure
plot(t_tot_RS, y_tot_RS(:,1), t_tot_RS, y_tot_RS(:,2), LineWidth=2); 
hold on

xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('TMP (mV)', Interpreter='latex',FontSize=14);

legend('$V_1$','$V_{2}$','Box','off', ...
    Interpreter='latex',Location='southwest',fontsize=20)

ylim([-1400 1200])
set(gca, 'XScale', 'log');

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

xticks([1 10 100 1000 1e4])
xlim([0.5 20000])

hold off

% ===================== ARROW =====================
drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

annotation('arrow', ...
    [x_norm x_norm], ...
    [axpos(2)-0.08 axpos(2)], ...
    'Color','r', ...
    'LineWidth',1.6, ...
    'HeadLength',10, ...
    'HeadWidth',10);

% ===================== INSET 1: AP =====================
inset_ax2 = axes('Position',[0.68 0.66 0.25 0.25]);
hold(inset_ax2, 'on');

plot(inset_ax2, t_tot_RS, y_tot_RS(:,1), ...
                 t_tot_RS, y_tot_RS(:,2), LineWidth=2);

xlim(inset_ax2, [5+1e-2 30]);
ylim(inset_ax2, [-100 50]);

set(inset_ax2, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
grid on
hold(inset_ax2, 'off');

% ===================== INSET 2: LONG-TIME =====================
inset_ax1 = axes('Position',[0.68 0.26 0.25 0.25]);
hold(inset_ax1, 'on');

plot(inset_ax1, t_tot_RS, y_tot_RS(:,1), ...
                 t_tot_RS, y_tot_RS(:,2), LineWidth=2);

xlim(inset_ax1, [1800 2000]);
ylim(inset_ax1, [-100 50]);

set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
grid on
hold(inset_ax1, 'off');

% ===================== INSET 3: PULSE (FIXED → ns) =====================
inset_ax3 = axes('Position',[0.28 0.68 0.18 0.18]);
hold(inset_ax3, 'on');

% Convert to ns centered at 5 ms
t_ns = (t_tot_RS - 5)*1e6;

plot(inset_ax3, t_ns, y_tot_RS(:,1), ...
                 t_ns, y_tot_RS(:,2), LineWidth=2);

plot(inset_ax3, t_ns, Vstims_RS, ...
     'r', 'LineWidth',2.5, LineStyle='--');

xlim(inset_ax3, [-10 120]);
ylim(inset_ax3, [-1500 2600]);

set(inset_ax3, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

% Optional subtle ticks (no labels)
xticks(inset_ax3, [0 100])
grid on
hold(inset_ax3, 'off');
%% Plot for RS
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig2b.pdf');


% Save as PDF
finish_figure(h, save_path);

close all

%% data for Depolarization block
t_tot_DB = all_t_tot{4};
y_tot_DB = all_y_tot{4};
pulse = t_tot_DB<=5+1e-4 & t_tot_DB>=5; 
Vstims_DB = V_stim_values(4,1).*(pulse);
%% ===================== Fig 2c: DB =====================
figure(3); clf  % published version: draw on a clean figure
plot(t_tot_DB, y_tot_DB(:,1), t_tot_DB, y_tot_DB(:,2), LineWidth=2); 
hold on
plot([5 max(t_tot_DB)], [-70 -70], '--k', 'LineWidth', 2)

xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('TMP (mV)', Interpreter='latex',FontSize=14);

legend('$V_1$','$V_{2}$','Box','off', ...
    Interpreter='latex',Location='southwest',fontsize=20)

ylim([-1400 1200])
set(gca, 'XScale', 'log');

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

xticks([1 10 100 1000 1e4])
xlim([0.5 20000])

hold off

% ===================== ARROW =====================
drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

annotation('arrow', ...
    [x_norm x_norm], ...
    [axpos(2)-0.08 axpos(2)], ...
    'Color','r', ...
    'LineWidth',1.6, ...
    'HeadLength',10, ...
    'HeadWidth',10);

% ===================== INSET 1: AP =====================
inset_ax2 = axes('Position',[0.68 0.26 0.25 0.25]);
hold(inset_ax2, 'on');

plot(inset_ax2, t_tot_DB, y_tot_DB(:,1), ...
                 t_tot_DB, y_tot_DB(:,2), LineWidth=2);
plot(inset_ax2, [5 max(t_tot_DB)], [-70 -70], '--k', 'LineWidth', 2)

xlim(inset_ax2, [5+1e-2 30]);
ylim(inset_ax2, [-100 50]);

set(inset_ax2, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
grid on
hold(inset_ax2, 'off');

% ===================== INSET 2: LONG-TIME =====================
% inset_ax1 = axes('Position',[0.68 0.66 0.25 0.25]);
% hold(inset_ax1, 'on');
% 
% plot(inset_ax1, t_tot_DB, y_tot_DB(:,1), ...
%                  t_tot_DB, y_tot_DB(:,2), LineWidth=2);
% 
% xlim(inset_ax1, [1800 2000]);
% ylim(inset_ax1, [-100 50]);
% 
% set(inset_ax1, 'FontSize', 22, ...
%     'FontName', 'Times', ...
%     'Box', 'on', ...
%     'LineWidth', 1.5, ...
%     'XMinorTick', 'on', 'YMinorTick', 'on');
% grid on
% hold(inset_ax1, 'off');

% ===================== INSET 3: PULSE (FIXED → ns) =====================
inset_ax3 = axes('Position',[0.68 0.66 0.25 0.25]);
hold(inset_ax3, 'on');

% Convert to ns centered at 5 ms
t_ns = (t_tot_DB - 5)*1e6;

plot(inset_ax3, t_ns, y_tot_DB(:,1), ...
                 t_ns, y_tot_DB(:,2), LineWidth=2);

plot(inset_ax3, t_ns, Vstims_DB, ...
     'r', 'LineWidth',2.5, LineStyle='--');

xlim(inset_ax3, [-10 120]);
ylim(inset_ax3, [-1700 2800]);

set(inset_ax3, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

% Optional subtle ticks (no labels)
xticks(inset_ax3, [0 100])
grid on
hold(inset_ax3, 'off');

%% Plot for DB
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig2c.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
