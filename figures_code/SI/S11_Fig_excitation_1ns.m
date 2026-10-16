addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% Plots AP
clear all;
clc
%% TMV dynamics V1 to compare AP at excitation thresholds for HHK and HH model

% load 13457 mV HH data - AP threshold
load([project_root '/data/raw/excitation_data/HH_1ns_13457mV.mat'])

% load 12982 mV HHK data
load([project_root '/data/raw/excitation_data/HHK_1ns_12982mV.mat'])

%% TMP - HH and HHk
figure(1)

plot(t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,1),...
    t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,2),LineWidth=2); hold on
plot(t_tot_1ns_13457mV_HH, y_tot_1ns_13457mV_HH(:,1),...
    t_tot_1ns_13457mV_HH, y_tot_1ns_13457mV_HH(:,2),LineWidth=2);
hold off

xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('TMP (mV)', Interpreter='latex',FontSize=14);
%title('Membrane Potential at DP side vs time',Interpreter='latex',FontSize=12);
legend('$V_1$ (HHK)','$V_2$ (HHK)','$V_1$ (HH)','$V_2$ (HH)','Box','off', Location='east',Interpreter='latex',NumColumns=4)

% grid on
% set(gca, 'FontSize', 12); % Set axes font size
% % Adjust figure properties for high-quality output
% set(gcf, 'PaperUnits', 'inches');       % Set units to inches
% set(gcf, 'PaperPosition', [0 0 6 4]);   % Set the figure size [left, bottom, width, height]
xlim([0 40])
%ylim([-1500 1400])
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])
legend('$V_1$ (HHK)','$V_2$ (HHK)','$V_1$ (HH)','$V_2$ (HH)','Box','off', Location='northwest',Interpreter='latex',NumColumns=4,fontsize=17)

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
grid on

%ylim([-100 50])


%Inset for pulse duration 
inset_ax1 = axes('Position',[0.66 0.62 0.25 0.25]); % Adjust position/size
hold(inset_ax1, 'on');

plot(inset_ax1, (t_tot_1ns_12982mV_HHK-5)*1e6, y_tot_1ns_12982mV_HHK(:,1),(t_tot_1ns_12982mV_HHK-5)*1e6, y_tot_1ns_12982mV_HHK(:,2),LineWidth=2);
plot(inset_ax1,(t_tot_1ns_13457mV_HH-5)*1e6, y_tot_1ns_13457mV_HH(:,1),(t_tot_1ns_13457mV_HH-5)*1e6, y_tot_1ns_13457mV_HH(:,2),LineWidth=2);



xlim(inset_ax1, [-0.1 1.2]); % in ms (i.e., pulse duration)

% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
ylim(inset_ax1, [-1500 1400]);

set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

% 2nd inset for AP

%Inset for 5-15 ms 
inset_ax2 = axes('Position',[0.66 0.24 0.25 0.25]); % Adjust position/size
hold(inset_ax2, 'on');

plot(inset_ax2, t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,1),t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,2),LineWidth=2);
plot(inset_ax2,t_tot_1ns_13457mV_HH, y_tot_1ns_13457mV_HH(:,1),t_tot_1ns_13457mV_HH, y_tot_1ns_13457mV_HH(:,2),LineWidth=2);



xlim(inset_ax2, [13 19]); % in ms (i.e., pulse duration)

% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
ylim(inset_ax2, [-100 40]);
yticks(inset_ax2,[-70 0 40])

set(inset_ax2, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
%
%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S11_Fig_a.pdf');


% Save as PDF
finish_figure(h, save_path);

close all

%% ************************* ION CHANNEL DYNAMICS *********************************************
%% m1 dynamics at excitations thresholds comparisons (HHK)

figure(2)

plot(t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,3),LineWidth=2); hold on %m1
plot(t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,6),LineWidth=2); %m2

%plot(t_tot_1ns_404mV_HH, y_tot_1ns_404mV_HH(:,3),LineWidth=1.5);
hold off



xlabel('time (ms)', 'Interpreter','latex','FontSize',10);
ylabel('$m$', 'Interpreter','latex','FontSize',14);
%legend('m1 (391 mV)', 'm2 (391 mV)','m1 (1428 mV)', 'm2 (1428 mV)', 'm1 (1428 mV HH)', 'm2 (1428 mV HH)','Location', 'best');
%legend('HHK','HH', 'Location', 'northwest','Box','off')
grid on

xlim([0 40])
ylim([-0.05 1.05])
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])
legend('$m_1$','$m_2$', 'Location', 'northwest','Box','off',Fontsize=25, Interpreter='latex')

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
grid on

%ylim([-100 50])


%Inset for 5–15 µs (i.e., 0.005–0.015 ms)
inset_ax1 = axes('Position',[0.62 0.60 0.3 0.30]); % Adjust position/size
hold(inset_ax1, 'on');

plot(inset_ax1, (t_tot_1ns_12982mV_HHK-5)*1e6, y_tot_1ns_12982mV_HHK(:,3),LineWidth=2);
plot(inset_ax1,(t_tot_1ns_12982mV_HHK-5)*1e6, y_tot_1ns_12982mV_HHK(:,6),LineWidth=2);



xlim(inset_ax1, [-0.1 1.2]); % in ms (i.e., pulse duration)

% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
ylim(inset_ax1, [-0.01 0.08]);

set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

grid on
%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S11_Fig_b.pdf');

% Save as PDF
finish_figure(h, save_path);

close all
%% n1 dynamics

figure(3)

plot(t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,4),LineWidth=2); hold on %n1
plot(t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,7),LineWidth=2); %n2
hold off



xlabel('time (ms)', 'Interpreter','latex','FontSize',10);
ylabel('$n$', 'Interpreter','latex','FontSize',14);
%legend('m1 (391 mV)', 'm2 (391 mV)','m1 (1428 mV)', 'm2 (1428 mV)', 'm1 (1428 mV HH)', 'm2 (1428 mV HH)','Location', 'best');
%legend('HHK','HH', 'Location', 'northwest','Box','off')
grid on

xlim([0 40])
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])
legend('$n_1$','$n_2$', 'Location', 'northwest','Box','off',Fontsize=25, Interpreter='latex')

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
grid on

%ylim([-100 50])


%Inset for 5–15 µs (i.e., 0.005–0.015 ms)
inset_ax1 = axes('Position',[0.66 0.62 0.28 0.28]); % Adjust position/size
hold(inset_ax1, 'on');

plot(inset_ax1, (t_tot_1ns_12982mV_HHK-5)*1e6, y_tot_1ns_12982mV_HHK(:,4),LineWidth=2);
plot(inset_ax1,(t_tot_1ns_12982mV_HHK-5)*1e6, y_tot_1ns_12982mV_HHK(:,7),LineWidth=2);



xlim(inset_ax1, [-0.1 2]); % in ms (i.e., pulse duration)

% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
ylim(inset_ax1, [0.27 0.33]);

set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

grid on
%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S11_Fig_d.pdf');

% Save as PDF
finish_figure(h, save_path);

close all

%% h1 dynamics

figure(4)

plot(t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,5),LineWidth=2); hold on %h1
plot(t_tot_1ns_12982mV_HHK, y_tot_1ns_12982mV_HHK(:,8),LineWidth=2); %h2
hold off



xlabel('time (ms)', 'Interpreter','latex','FontSize',10);
ylabel('$h$', 'Interpreter','latex','FontSize',14);
%legend('m1 (391 mV)', 'm2 (391 mV)','m1 (1428 mV)', 'm2 (1428 mV)', 'm1 (1428 mV HH)', 'm2 (1428 mV HH)','Location', 'best');
%legend('HHK','HH', 'Location', 'northwest','Box','off')
grid on

xlim([0 40])
ylim([0 1.05])
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])
legend('$h_1$','$h_2$', 'Location', 'northeast','Box','off',Fontsize=25, Interpreter='latex')

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
grid on

%ylim([-100 50])


%Inset for 5–15 µs (i.e., 0.005–0.015 ms)
inset_ax1 = axes('Position',[0.65 0.26 0.3 0.30]); % Adjust position/size
hold(inset_ax1, 'on');

plot(inset_ax1, (t_tot_1ns_12982mV_HHK-5)*1e6, y_tot_1ns_12982mV_HHK(:,5),LineWidth=2);
plot(inset_ax1,(t_tot_1ns_12982mV_HHK-5)*1e6, y_tot_1ns_12982mV_HHK(:,8),LineWidth=2);



xlim(inset_ax1, [-0.1 1.2]); % in ms (i.e., pulse duration)

% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
ylim(inset_ax1, [0.5 1.05]);

set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
grid on


%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S11_Fig_c.pdf');

% Save as PDF
finish_figure(h, save_path);

close all


%% Na-conductance dynamics
gK_max=36; gNa_max=120; gL=0.3;    % milli-siemens/cm^2

figure(5)

% ion channels dynamics
m1 = y_tot_1ns_12982mV_HHK(:,3); n1 = y_tot_1ns_12982mV_HHK(:,4); h1 = y_tot_1ns_12982mV_HHK(:,5); 
m2 = y_tot_1ns_12982mV_HHK(:,6); n2 = y_tot_1ns_12982mV_HHK(:,7); h2 = y_tot_1ns_12982mV_HHK(:,8);

% Sodium and Potassium current
gNa1 = gNa_max*m1.^3.*h1; gK1 = gK_max*n1.^4; 
gNa2 = gNa_max*m2.^3.*h2; gK2 = gK_max*n2.^4; 


plot(t_tot_1ns_12982mV_HHK, gNa1,LineWidth=2); hold on
plot(t_tot_1ns_12982mV_HHK, gNa2,LineWidth=2);
hold off


xlabel('time (ms)', 'Interpreter','latex','FontSize',10);
ylabel('$g_{Na}$ (mS/cm$^2$)', 'Interpreter','latex','FontSize',14);

xlim([0 40])
ylim([-2 30])
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])
legend('$g_{Na_1}$','$g_{Na_2}$', 'Location', 'northwest','Box','off',Fontsize=25, Interpreter='latex')

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
grid on

%ylim([-100 50])


%Inset for 5–15 µs (i.e., 0.005–0.015 ms)
inset_ax1 = axes('Position',[0.60 0.55 0.3 0.30]); % Adjust position/size
hold(inset_ax1, 'on');

plot(inset_ax1, (t_tot_1ns_12982mV_HHK-5)*1e6, gNa1,LineWidth=2);
plot(inset_ax1,(t_tot_1ns_12982mV_HHK-5)*1e6, gNa2,LineWidth=2);



xlim(inset_ax1, [-0.1 1.2]); % in ms (i.e., pulse duration)

% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
ylim(inset_ax1, [-0.002 0.015]);

set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

text(inset_ax1,...
    0.08,0.88,'1-ns',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');

grid on
%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S11_Fig_e.pdf');
% Save as PDF
finish_figure(h, save_path);

close all

%% Potassium conductance

figure(6)

plot(t_tot_1ns_12982mV_HHK, gK1,LineWidth=2); hold on
plot(t_tot_1ns_12982mV_HHK, gK2,LineWidth=2);
hold off


xlabel('time (ms)', 'Interpreter','latex','FontSize',10);
ylabel('$g_{K}$ (mS/cm$^2$)', 'Interpreter','latex','FontSize',14);

xlim([0 40])
ylim([-1 14])
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])
legend('$g_{K_1}$','$g_{K_2}$', 'Location', 'northwest','Box','off',Fontsize=25, Interpreter='latex')

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
grid on

%ylim([-100 50])


%Inset for 5–15 µs (i.e., 0.005–0.015 ms)
inset_ax1 = axes('Position',[0.68 0.65 0.25 0.25]); % Adjust position/size
hold(inset_ax1, 'on');

plot(inset_ax1, (t_tot_1ns_12982mV_HHK-5)*1e6, gK1,LineWidth=2);
plot(inset_ax1,(t_tot_1ns_12982mV_HHK-5)*1e6, gK2,LineWidth=2);



xlim(inset_ax1, [-0.1 2]); % in ms (i.e., pulse duration)

% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
ylim(inset_ax1, [0.15 0.45]);

set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
text(inset_ax1,...
    0.08,0.88,'1-ns',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');

grid on

%Inset II showing activation post pulse
inset_ax2 = axes('Position',[0.68 0.32 0.25 0.25]); % Adjust position/size
hold(inset_ax2, 'on');

plot(inset_ax2, t_tot_1ns_12982mV_HHK, gK1,LineWidth=2);
plot(inset_ax2,t_tot_1ns_12982mV_HHK, gK2,LineWidth=2);



xlim(inset_ax2, [4 16]); % in ms (i.e., pulse duration)

% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
ylim(inset_ax2, [0.1 1.4]);
yticks(inset_ax2, [0.2 0.6 1.0 1.4])
set(inset_ax2, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
text(inset_ax2,...
    0.08,0.88,'ms',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');

grid on

%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S11_Fig_f.pdf');
% Save as PDF
finish_figure(h, save_path);

close all





