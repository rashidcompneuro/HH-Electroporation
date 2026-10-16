addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
%% Plotting interplay of electroporation and excitation for 1 ns and 10 ns
clear all; clc; 
%% Load the data
% load 13457 mV HHK data -
load([project_root '/data/raw/excitation_data/HHK_1ns_13457mV.mat'])

% load 13457 mV HH data - AP threshold
load([project_root '/data/raw/excitation_data/HH_1ns_13457mV.mat'])

%% TMV at 13457(HH) vs TMV at 13457(HHK)

t_tot_1ns_13457mV_HHK = t_tot; 
y_tot_1ns_13457mV_HHK = y_tot;
pulse = t_tot_1ns_13457mV_HHK<=5+1e-6 & t_tot_1ns_13457mV_HHK>=5; 
Vstims = 13457.*(pulse);

figure(1)

plot(t_tot_1ns_13457mV_HH, y_tot_1ns_13457mV_HH(:,2),t_tot_1ns_13457mV_HHK, y_tot_1ns_13457mV_HHK(:,2),LineWidth=2); hold on
%xline(5, '--k', 'LineWidth', 1.5);  % vertical black line at t = 5

xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('$V_2$ (mV)', Interpreter='latex',FontSize=14);

legend('13457 mV (HH)','13457 mV (HHK)','Box','off','Location','best', fontsize=20)

% text(6.5, 84, '$RC=10^{-6}$ s', 'Interpreter', 'latex','FontSize', 17, 'FontWeight', 'bold')
% text(5.5, 72, 'Pulse duration=9.8 $\mu$s', 'Interpreter', 'latex', ...
%      'FontSize', 17, 'FontWeight', 'bold')

grid off
ylim([-100 100])
xlim([0 30])

grid off
set(gca, 'FontSize', 12); 
set(gcf, 'PaperUnits', 'inches');      
set(gcf, 'PaperPosition', [0 0 6 4]);   

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.01 0.01])
xticks([0 4 8 12 16 20 24 28])

% Get axis position in normalized figure units
ax = gca;
axpos = ax.Position;   % [x y width height]

% Compute normalized x-position of t=5 on the axis
x_lim = xlim;
xn = axpos(1) + (5 - x_lim(1)) / (x_lim(2)-x_lim(1)) * axpos(3);

% Arrow tail BELOW the axis, outside plot
xn_tail = xn - 0.00;               % left shift for angle
yn     = axpos(2);                 % x-axis in normalized units
yn_tail = yn - 0.07;               % below the axis

% Draw the arrow
annotation('arrow', [xn_tail xn], [yn_tail yn], ...
           'Color','r','LineWidth',1.6,'HeadLength',10,'HeadWidth',10);

t_local_HH  = (t_tot_1ns_13457mV_HH-5)*1e6;
t_local_HHK = (t_tot_1ns_13457mV_HHK-5)*1e6;

ax1 = axes('Position',[0.63 0.63 0.25 0.25]);
hold(ax1,'on')

plot(ax1,...
    t_local_HH,...
    y_tot_1ns_13457mV_HH(:,1),...
    'LineWidth',2);

plot(ax1,...
    t_local_HHK,...
    y_tot_1ns_13457mV_HHK(:,1),...
    'LineWidth',2);

xlim(ax1,[-0.2 1.2])
ylim(ax1,[-200 1300])

xticks(ax1,[0 1])

set(ax1,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'Box','on');

grid(ax1,'on')

text(ax1,...
    0.08,0.88,...
    'DP side',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');

text(ax1,...
    0.92,-0.18,...
    '1 ns',...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',18);

%%
ax2 = axes('Position',[0.63 0.28 0.25 0.25]);
hold(ax2,'on')

plot(ax2,...
    t_local_HH,...
    y_tot_1ns_13457mV_HH(:,2),...
    'LineWidth',2);

plot(ax2,...
    t_local_HHK,...
    y_tot_1ns_13457mV_HHK(:,2),...
    'LineWidth',2);

xlim(ax2,[-0.2 1.2])
ylim(ax2,[-1400 0])

xticks(ax2,[0 1])

set(ax2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'Box','on');

grid(ax2,'on')

text(ax2,...
    0.08,0.88,...
    'HP side',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');

text(ax2,...
    0.92,-0.18,...
    '1 ns',...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',18);


%% Save Fig 6a
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);
finish_figure(h, fig_path('main/Fig6a.pdf'));
close all
