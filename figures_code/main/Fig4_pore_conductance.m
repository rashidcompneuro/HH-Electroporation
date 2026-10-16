addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% Plots  Pore conductances in  SAP, RS and DB for 100 ns RC=1e-5 ms 
clear all;
clc
%% loading the data
%
load([project_root '/data/raw/100ns_1e5/HHK_100ns_1e5_SAP_RS_DB.mat'])

%% SAP (Single Action Potential)
% Vstim = 2100 mV

t_tot_SAP = all_t_tot{2};
g_ep      = all_gshunt{2};

pulse = (t_tot_SAP >= 5) & (t_tot_SAP <= 5+1e-4);
Vstims_SAP = V_stim_values(2,1).*pulse;

figure(1)

%% ===================== Main figure ===============================

yyaxis left
h1 = plot(t_tot_SAP,g_ep(:,1),'LineWidth',2);
ylim([-1e-2 10e-2])
ylabel('$g_{ep}$ (mS/cm$^2$)', Interpreter='latex',FontSize=14);

yyaxis right
h2 = plot(t_tot_SAP,g_ep(:,2),'LineWidth',2);
ylim([-0.1 1])

xlabel('Time (ms)','Interpreter','latex','FontSize',10)
ylabel('$g_{ep}$ (mS/cm$^2$)', Interpreter='latex',FontSize=14);

legend('$g_{ep_1}$','$g_{ep_2}$',...
    'Interpreter','latex',...
    'Location','northwest',...
    'Box','off')

ax = gca;
ax.YAxis(1).Exponent = -2;

set(gca,'XScale','log')

set(gcf,'Position',[15 15 550 420])

set(gca,...
    'Position',[0.17 0.17 0.80 0.77],...
    'FontSize',25,...
    'FontName','Times',...
    'LineWidth',1,...
    'TickLength',[0.02 0.02])

xticks([1 100 10000])

xlim([0.5 2e4])

%% Save handle of MAIN axes
main_ax = gca;

%% ===================== Inset =====================================
%% ==========================================================
%                    Insets (SAP)
% ==========================================================

% Local time with pulse onset at t = 0
t_local = (t_tot_SAP - 5)*1e6;      % Convert ms to ns

%% ---------------- Inset : g_ep2 -------------------------

inset1 = axes('Position',[0.64 0.65 0.25 0.25]);
hold(inset1,'on')

plot(inset1,...
    t_local,...
    g_ep(:,2),...
    'LineWidth',2,...
    'Color',h2.Color);

xlim(inset1,[-10 120])
ylim(inset1,[-0.05 0.7])

xticks(inset1,[0 100])

grid(inset1,'on')

text(0.05,0.88,'$g_{ep_2}$',...
    'Units','normalized',...
    'Interpreter','latex',...
    'FontSize',20)

set(inset1,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');


%% ---------------- Inset : g_ep1 -------------------------

inset2 = axes('Position',[0.64 0.33 0.25 0.25]);
hold(inset2,'on')

plot(inset2,...
    t_local,...
    g_ep(:,1),...
    'LineWidth',2,...
    'Color',h1.Color);

xlim(inset2,[-10 120])
ylim(inset2,[-1e-2 9.5e-2])

xticks(inset2,[0 100])

grid(inset2,'on')

text(0.05,0.88,'$g_{ep_1}$',...
    'Units','normalized',...
    'Interpreter','latex',...
    'FontSize',20)

set(inset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');

%% ===================== Pulse arrow ===============================

drawnow

axpos = main_ax.Position;
xlim_ = main_ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data)-log10(xlim_(1))) / ...
    (log10(xlim_(2))-log10(xlim_(1))) * ...
    axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.08 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);

% %% ===================== Save ======================================
%% saving the fig file as PDF
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig4a.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%% ==========================================================
%% RS (Repetitive Spiking)
%% ==========================================================

t_tot_RS = all_t_tot{3};
g_ep      = all_gshunt{3};

pulse = (t_tot_RS >= 5) & (t_tot_RS <= 5+1e-4);
Vstims_RS = V_stim_values(3,1).*pulse;

figure(2)

%% ===================== Main figure ===============================

yyaxis left
h1 = plot(t_tot_RS,g_ep(:,1),'LineWidth',2);
ylim([-0.05 0.8])
ylabel('$g_{ep}$ (mS/cm$^2$)',Interpreter='latex',FontSize=14);

yyaxis right
h2 = plot(t_tot_RS,g_ep(:,2),'LineWidth',2);
ylim([-2 20])

xlabel('Time (ms)','Interpreter','latex','FontSize',10)
ylabel('$g_{ep}$ (mS/cm$^2$)',Interpreter='latex',FontSize=14);

legend('$g_{ep_1}$','$g_{ep_2}$',...
    'Interpreter','latex',...
    'Location','northwest',...
    'Box','off')

set(gca,'XScale','log')

set(gcf,'Position',[15 15 550 420])

set(gca,...
    'Position',[0.17 0.17 0.80 0.77],...
    'FontSize',25,...
    'FontName','Times',...
    'LineWidth',1,...
    'TickLength',[0.02 0.02])

xticks([1 100 10000])

xlim([0.5 2e4])

%% Save handle of MAIN axes

main_ax = gca;

%% ==========================================================
%                    Insets (RS)
%% ==========================================================

% Local time with pulse onset at t = 0
t_local = (t_tot_RS - 5)*1e6;      % Convert ms to ns

%% ---------------- Inset : g_ep2 -------------------------

inset1 = axes('Position',[0.64 0.65 0.25 0.25]);
hold(inset1,'on')

plot(inset1,...
    t_local,...
    g_ep(:,2),...
    'LineWidth',2,...
    'Color',h2.Color);

xlim(inset1,[-10 120])
ylim(inset1,[-2 20])

xticks(inset1,[0 100])

grid(inset1,'on')

text(0.05,0.88,'$g_{ep_2}$',...
    'Units','normalized',...
    'Interpreter','latex',...
    'FontSize',20)

set(inset1,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');

%% ---------------- Inset : g_ep1 -------------------------

inset2 = axes('Position',[0.64 0.33 0.25 0.25]);
hold(inset2,'on')

plot(inset2,...
    t_local,...
    g_ep(:,1),...
    'LineWidth',2,...
    'Color',h1.Color);

xlim(inset2,[-10 120])
ylim(inset2,[-0.05 0.8])

xticks(inset2,[0 100])

grid(inset2,'on')

text(0.05,0.88,'$g_{ep_1}$',...
    'Units','normalized',...
    'Interpreter','latex',...
    'FontSize',20)

set(inset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');

%% ===================== Pulse arrow ===============================

drawnow

axpos = main_ax.Position;
xlim_ = main_ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data)-log10(xlim_(1))) / ...
    (log10(xlim_(2))-log10(xlim_(1))) * ...
    axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.08 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);

%% ===================== Save ======================================

h = gcf;

set(h,'Units','Inches');
pos = get(h,'Position');

set(h,...
    'PaperPositionMode','Auto',...
    'PaperUnits','Inches',...
    'PaperSize',[pos(3) pos(4)]);

save_path = fig_path('main/Fig4b.pdf');

finish_figure(h, save_path);

close all


%% DB (Depolarization Block)

%% ==========================================================

t_tot_DB = all_t_tot{4};

g_ep      = all_gshunt{4};

pulse = (t_tot_DB >= 5) & (t_tot_DB <= 5+1e-4);

Vstims_DB = V_stim_values(4,1).*pulse;

figure(3)

%% ===================== Main figure ===============================
yyaxis left
h1 = plot(t_tot_DB,g_ep(:,1),'LineWidth',2);
ylim([-0.05 1])

ylabel('$g_{ep}$ (mS/cm$^2$)',...
    'Interpreter','latex',...
    'FontSize',14,...
    'Color','k')      % Label black only

yyaxis right
h2 = plot(t_tot_DB,g_ep(:,2),'LineWidth',2);
ylim([-5 95])

% No ylabel on right axis

xlabel('time (ms)',...
    'Interpreter','latex',...
    'FontSize',10)

legend('$g_{ep_1}$','$g_{ep_2}$',...
    'Interpreter','latex',...
    'Location','northwest',...
    'Box','off')

set(gca,'XScale','log')

set(gcf,'Position',[15 15 550 420])

set(gca,...
    'Position',[0.17 0.17 0.80 0.77],...
    'FontSize',25,...
    'FontName','Times',...
    'LineWidth',1,...
    'TickLength',[0.02 0.02])

xticks([1 100 10000])
xlim([0.5 2e4])

main_ax = gca;

%% ==========================================================
%                    Insets (DB)
%% ==========================================================

% Local time with pulse onset at t = 0
t_local = (t_tot_DB - 5)*1e6;

%% ---------------- Inset : g_ep2 -------------------------

inset1 = axes('Position',[0.64 0.65 0.25 0.25]);
hold(inset1,'on')

plot(inset1,...
    t_local,...
    g_ep(:,2),...
    'LineWidth',2,...
    'Color',h2.Color);

xlim(inset1,[-10 120])
ylim(inset1,[-50 600])

xticks(inset1,[0 100])

grid(inset1,'on')

text(0.05,0.88,'$g_{ep_2}$',...
    'Units','normalized',...
    'Interpreter','latex',...
    'FontSize',20)

set(inset1,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');

%% ---------------- Inset : g_ep1 -------------------------

inset2 = axes('Position',[0.64 0.33 0.25 0.25]);
hold(inset2,'on')

plot(inset2,...
    t_local,...
    g_ep(:,1),...
    'LineWidth',2,...
    'Color',h1.Color);

xlim(inset2,[-10 120])
ylim(inset2,[-0.2 3.5])

xticks(inset2,[0 100])

grid(inset2,'on')

text(0.05,0.88,'$g_{ep_1}$',...
    'Units','normalized',...
    'Interpreter','latex',...
    'FontSize',20)

set(inset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');

%% ===================== Pulse arrow ===============================

drawnow

axpos = main_ax.Position;
xlim_ = main_ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data)-log10(xlim_(1))) / ...
    (log10(xlim_(2))-log10(xlim_(1))) * ...
    axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.08 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);

%% ===================== Save ======================================

h = gcf;

set(h,'Units','Inches');
pos = get(h,'Position');

set(h,...
    'PaperPositionMode','Auto',...
    'PaperUnits','Inches',...
    'PaperSize',[pos(3) pos(4)]);

save_path = fig_path('main/Fig4c.pdf');

finish_figure(h, save_path);

close all
%%
t_tot_100ns = all_t_tot{2};
y_tot_100ns = all_y_tot{2};
gep_100ns = all_gshunt{2};

load([project_root '/data/raw/100mus_1e5/HHK_100mus_1e5.mat'])

t_tot_100mus = all_t_tot{1};
y_tot_100mus = all_y_tot{1};
gep_100mus = all_gshunt{1};
figure(4)

%% ===================== Main figure ===============================

h100us = plot(t_tot_100mus, gep_100mus(:,2), 'LineWidth',2); hold on
h100ns = plot(t_tot_100ns,  gep_100ns(:,2),  'LineWidth',2);
hold off

xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('$g_{ep_2}$ (mS/cm$^2$)',Interpreter='latex',FontSize=14);

legend('100 $\mu$s','100 ns',...
    'Interpreter','latex',...
    'Location','northwest',...
    'Box','off')

set(gca,'XScale','log')
ylim([-0.01 0.1])

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

xticks([1 100 10000])
xlim([0.5 2e4])

%% Save handle of main axes

main_ax = gca;

%% ===================== Arrow ===============================

drawnow

axpos = main_ax.Position;
xlim_ = main_ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data)-log10(xlim_(1))) / ...
    (log10(xlim_(2))-log10(xlim_(1))) * axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.08 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);

%% ==========================================================
%% 100 ns inset
%% ==========================================================

t_ns = (t_tot_100ns-5)*1e6;      % ns

inset1 = axes('Position',[0.60 0.63 0.25 0.25]);
hold(inset1,'on')

plot(inset1,...
    t_ns,...
    gep_100ns(:,2),...
    'LineWidth',2,...
    'Color',h100ns.Color);

xlim(inset1,[-10 120])
ylim(inset1,[-0.05 0.8])

xticks(inset1,[0 100])

text(0.05,0.90,'100 ns',...
    'Units','normalized',...
    'FontSize',18,...
    'FontWeight','bold')

grid(inset1,'on')

set(inset1,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');

%% ==========================================================
%% 100 microsecond inset
%% ==========================================================

t_us = (t_tot_100mus-5)*1e3;     % microseconds

inset2 = axes('Position',[0.60 0.28 0.25 0.25]);
hold(inset2,'on')

plot(inset2,...
    t_us,...
    gep_100mus(:,2),...
    'LineWidth',2,...
    'Color',h100us.Color);

xlim(inset2,[-10 120])
ylim(inset2,[-0.005 0.06])

xticks(inset2,[0 50 100])

text(0.05,0.90,'100 $\mu$s',...
    'Units','normalized',...
    'Interpreter','latex',...
    'FontSize',18,...
    'FontWeight','bold')

grid(inset2,'on')

set(inset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');

%% saving the fig file as PDF
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig4d.pdf');


% Save as PDF
finish_figure(h, save_path);

close all

