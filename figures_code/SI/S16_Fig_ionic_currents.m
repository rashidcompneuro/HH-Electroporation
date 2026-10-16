addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
% Plotting Excitation variables (V, m, n and h) vs time(ms)
% RC=1e-5 ms (1e-8s) for 10ns pulse
% diferent thresold Vstims as each single figure. 
clear all;
clc;

% Loading the data
load([project_root '/data/raw/100ns_1e5/HHK_100ns_1e5_SAP_RS_DB.mat'])

gNa_max = 120;      % mS/cm^2
gK_max  = 36;



%% ===================== Sodium currents ==========================
v = 2;

t = all_t_tot{v};
y = all_y_tot{v};

ENa = 45;      % mV

V1 = y(:,1);
V2 = y(:,2);

m1 = y(:,3);
h1 = y(:,5);

m2 = y(:,6);
h2 = y(:,8);

gNa1 = gNa_max .* m1.^3 .* h1;
gNa2 = gNa_max .* m2.^3 .* h2;

INa1 = gNa1 .* (V1 - ENa);
INa2 = gNa2 .* (V2 - ENa);

figure(1); clf; hold on

plot(t,INa1,'LineWidth',2);

plot(t,INa2,'LineWidth',2);

xlabel('time (ms)',...
    'Interpreter','latex',...
    'FontSize',18)

ylabel('$I_{Na}$ ($\mu$A/cm$^2$)',...
    'Interpreter','latex',...
    'FontSize',18)

legend({'$I_{Na_1}$',...
        '$I_{Na_2}$'},...
    'Interpreter','latex',...
    'FontSize',18,...
    'Location','northeast',...
    'Box','off')

% ---------------- Figure formatting ----------------

set(gcf,'PaperPosition',[0 0 6 4])
set(gcf,'Position',[15 15 550 420])

set(gca,...
    'Position',[0.17 0.17 0.80 0.77],...
    'FontSize',25,...
    'FontName','Times',...
    'LineWidth',1,...
    'TickLength',[0.02 0.02])

xlim([4 18])
ylim([-1200 100])

xticks([4 8 12 16])
grid on
%% ---------------- Pulse arrow ----------------

drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (x_data-xlim_(1))/(xlim_(2)-xlim_(1))*axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.07 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);
%%
%% ==========================================================
%% Inset 1 : Pulse dynamics (100 ns)
%% ==========================================================

tp      = 1e-4;      % Pulse duration (ms)
tau     = 1e-5;      % Characteristic time (ms)
t_pulse = 5;         % Pulse onset (ms)

t_local = (t - t_pulse)*1e6;      % ms -> ns

axInset = axes('Position',[0.35 0.57 0.25 0.25]);
box(axInset,'on');
hold(axInset,'on')

plot(axInset,...
    t_local,INa1, 'LineWidth',2);

plot(axInset,...
    t_local, INa2,'LineWidth',2);

xlim(axInset,[-10 120])
ylim(axInset,[-5 30])

xticks(axInset,[0 100])

set(axInset,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset,'on')

text(axInset,...
    0.08,0.88,'100 ns',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');

%% ==========================================================
%% Inset 2 : Recovery dynamics (ms)
%% ==========================================================

axInset2 = axes('Position',[0.35 0.25 0.25 0.25]);
box(axInset2,'on');
hold(axInset2,'on')

plot(axInset2,t,INa1,'LineWidth',2);

plot(axInset2,t,INa2,'LineWidth',2);

xlim(axInset2,[5 8])
ylim(axInset2,[-50 5])

xticks(axInset2,[5 6 7 8])

set(axInset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset2,'on')

text(axInset2,...
    0.90,0.88,'ms',...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',18,...
    'FontName','Times');
%% saving the fig file as PDF
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S16_Fig_a.pdf');
% Save as PDF
finish_figure(h, save_path);

close all
%% ==========================================================
%%                 Potassium Current (IK)
%% ==========================================================

v = 2;

t = all_t_tot{v};
y = all_y_tot{v};

EK = -82;      % mV

V1 = y(:,1);
V2 = y(:,2);

n1 = y(:,4);
n2 = y(:,7);

gK1 = gK_max .* n1.^4;
gK2 = gK_max .* n2.^4;

IK1 = gK1 .* (V1 - EK);
IK2 = gK2 .* (V2 - EK);


figure(2); clf; hold on

plot(t,IK1,'LineWidth',2);

plot(t,IK2,'LineWidth',2);

xlabel('time (ms)',...
    'Interpreter','latex',...
    'FontSize',18)

ylabel('$I_{K}$ ($\mu$A/cm$^2$)',...
    'Interpreter','latex',...
    'FontSize',18)

legend({'$I_{K_1}$',...
        '$I_{K_2}$'},...
    'Interpreter','latex',...
    'FontSize',18,...
    'Location','northeast',...
    'Box','off')

% ---------------- Figure formatting ----------------

set(gcf,'PaperPosition',[0 0 6 4])
set(gcf,'Position',[15 15 550 420])

set(gca,...
    'Position',[0.17 0.17 0.80 0.77],...
    'FontSize',25,...
    'FontName','Times',...
    'LineWidth',1,...
    'TickLength',[0.02 0.02])

xlim([4 18])
ylim([-400 1200])
yticks([-300 0 300 600 900])
xticks([4 8 12 16])

%% ---------------- Pulse arrow ----------------

drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (x_data-xlim_(1))/(xlim_(2)-xlim_(1))*axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.07 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);

%%
%%
%% ==========================================================
%% Inset 1 : Pulse dynamics (100 ns)
%% ==========================================================

tp      = 1e-4;      % Pulse duration (ms)
tau     = 1e-5;      % Characteristic time (ms)
t_pulse = 5;         % Pulse onset (ms)

t_local = (t - t_pulse)*1e6;      % ms -> ns

axInset = axes('Position',[0.35 0.57 0.25 0.25]);
box(axInset,'on');
hold(axInset,'on')

plot(axInset,...
    t_local,IK1,'LineWidth',2);

plot(axInset,...
    t_local,IK2,'LineWidth',2);

xlim(axInset,[-10 120])
ylim(axInset,[-500 500])

xticks(axInset,[0 100])

set(axInset,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset,'on')

text(axInset,...
    0.08,0.88,'100 ns',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');


%%
%% ==========================================================
%% Inset 2 : Recovery dynamics (ms)
%% ==========================================================

axInset2 = axes('Position',[0.35 0.25 0.25 0.25]);
box(axInset2,'on');
hold(axInset2,'on')

plot(axInset2,...
    t,IK1,'LineWidth',2);

plot(axInset2,...
    t,IK2,'LineWidth',2);

xlim(axInset2,[5 8])
ylim(axInset2,[-5 40])

xticks(axInset2,[5 6 7 8])

set(axInset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset2,'on')

text(axInset2,...
    0.90,0.88,'ms',...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',18,...
    'FontName','Times');
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
save_path = fig_path('SI/S16_Fig_b.pdf');


% Save as PDF
finish_figure(h, save_path);

close all

%% ===================== REPETITIVE SPIKING ==========================                
%% ===================== Sodium currents ==========================
v = 3;

t = all_t_tot{v};
y = all_y_tot{v};

ENa = 45;      % mV

V1 = y(:,1);
V2 = y(:,2);

m1 = y(:,3);
h1 = y(:,5);

m2 = y(:,6);
h2 = y(:,8);

gNa1 = gNa_max .* m1.^3 .* h1;
gNa2 = gNa_max .* m2.^3 .* h2;

INa1 = gNa1 .* (V1 - ENa);
INa2 = gNa2 .* (V2 - ENa);

figure(1); clf; hold on

plot(t,INa1,'LineWidth',2);

plot(t,INa2,'LineWidth',2);

xlabel('time (ms)',...
    'Interpreter','latex',...
    'FontSize',18)

ylabel('$I_{Na}$ ($\mu$A/cm$^2$)',...
    'Interpreter','latex',...
    'FontSize',18)

legend({'$I_{Na_1}$',...
        '$I_{Na_2}$'},...
    'Interpreter','latex',...
    'FontSize',18,...
    'Location','northeast',...
    'Box','off')

% ---------------- Figure formatting ----------------

set(gcf,'PaperPosition',[0 0 6 4])
set(gcf,'Position',[15 15 550 420])

set(gca,...
    'Position',[0.17 0.17 0.80 0.77],...
    'FontSize',25,...
    'FontName','Times',...
    'LineWidth',1,...
    'TickLength',[0.02 0.02])

xlim([4 18])
ylim([-1200 100])

xticks([4 8 12 16])
grid on
%% ---------------- Pulse arrow ----------------

drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (x_data-xlim_(1))/(xlim_(2)-xlim_(1))*axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.07 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);
%%
%% ==========================================================
%% Inset 1 : Pulse dynamics (100 ns)
%% ==========================================================

tp      = 1e-4;      % Pulse duration (ms)
tau     = 1e-5;      % Characteristic time (ms)
t_pulse = 5;         % Pulse onset (ms)

t_local = (t - t_pulse)*1e6;      % ms -> ns

axInset = axes('Position',[0.35 0.57 0.25 0.25]);
box(axInset,'on');
hold(axInset,'on')

plot(axInset,...
    t_local,INa1, 'LineWidth',2);

plot(axInset,...
    t_local, INa2,'LineWidth',2);

xlim(axInset,[-10 120])
ylim(axInset,[-5 30])

xticks(axInset,[0 100])

set(axInset,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset,'on')

text(axInset,...
    0.08,0.88,'100 ns',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');

%% ==========================================================
%% Inset 2 : Recovery dynamics (ms)
%% ==========================================================

axInset2 = axes('Position',[0.35 0.25 0.25 0.25]);
box(axInset2,'on');
hold(axInset2,'on')

plot(axInset2,t,INa1,'LineWidth',2);

plot(axInset2,t,INa2,'LineWidth',2);

xlim(axInset2,[5 6])
ylim(axInset2,[-100 5])

%xticks(axInset2,[5 6 7 8])

set(axInset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset2,'on')

text(axInset2,...
    0.90,0.88,'ms',...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',18,...
    'FontName','Times');
%% saving the fig file as PDF
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S16_Fig_c.pdf');
% Save as PDF
finish_figure(h, save_path);

close all
%% ==========================================================
%%                 Potassium Current (IK) (Repititive Spiking)
%% ==========================================================

v = 3;

t = all_t_tot{v};
y = all_y_tot{v};

EK = -82;      % mV

V1 = y(:,1);
V2 = y(:,2);

n1 = y(:,4);
n2 = y(:,7);

gK1 = gK_max .* n1.^4;
gK2 = gK_max .* n2.^4;

IK1 = gK1 .* (V1 - EK);
IK2 = gK2 .* (V2 - EK);


figure(2); clf; hold on

plot(t,IK1,'LineWidth',2);

plot(t,IK2,'LineWidth',2);

xlabel('time (ms)',...
    'Interpreter','latex',...
    'FontSize',18)

ylabel('$I_{K}$ ($\mu$A/cm$^2$)',...
    'Interpreter','latex',...
    'FontSize',18)

legend({'$I_{K_1}$',...
        '$I_{K_2}$'},...
    'Interpreter','latex',...
    'FontSize',18,...
    'Location','northeast',...
    'Box','off')

% ---------------- Figure formatting ----------------

set(gcf,'PaperPosition',[0 0 6 4])
set(gcf,'Position',[15 15 550 420])

set(gca,...
    'Position',[0.17 0.17 0.80 0.77],...
    'FontSize',25,...
    'FontName','Times',...
    'LineWidth',1,...
    'TickLength',[0.02 0.02])

xlim([4 18])
ylim([-400 1200])
yticks([-300 0 300 600 900])
xticks([4 8 12 16])

%% ---------------- Pulse arrow ----------------

drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (x_data-xlim_(1))/(xlim_(2)-xlim_(1))*axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.07 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);

%%
%%
%% ==========================================================
%% Inset 1 : Pulse dynamics (100 ns)
%% ==========================================================

tp      = 1e-4;      % Pulse duration (ms)
tau     = 1e-5;      % Characteristic time (ms)
t_pulse = 5;         % Pulse onset (ms)

t_local = (t - t_pulse)*1e6;      % ms -> ns

axInset = axes('Position',[0.35 0.57 0.25 0.25]);
box(axInset,'on');
hold(axInset,'on')

plot(axInset,...
    t_local,IK1,'LineWidth',2);

plot(axInset,...
    t_local,IK2,'LineWidth',2);

xlim(axInset,[-10 120])
ylim(axInset,[-500 500])

xticks(axInset,[0 100])

set(axInset,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset,'on')

text(axInset,...
    0.08,0.88,'100 ns',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');


%%
%% ==========================================================
%% Inset 2 : Recovery dynamics (ms)
%% ==========================================================

axInset2 = axes('Position',[0.35 0.25 0.25 0.25]);
box(axInset2,'on');
hold(axInset2,'on')

plot(axInset2,...
    t,IK1,'LineWidth',2);

plot(axInset2,...
    t,IK2,'LineWidth',2);

xlim(axInset2,[5 6.2])
ylim(axInset2,[-5 40])

xticks(axInset2,[5 6 7 8])

set(axInset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset2,'on')

text(axInset2,...
    0.90,0.88,'ms',...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',18,...
    'FontName','Times');
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
save_path = fig_path('SI/S16_Fig_d.pdf');


% Save as PDF
finish_figure(h, save_path);

close all

%% ===================== Depolarization Block ==========================                
%% ===================== Sodium currents ==========================
v = 4;

t = all_t_tot{v};
y = all_y_tot{v};

ENa = 45;      % mV

V1 = y(:,1);
V2 = y(:,2);

m1 = y(:,3);
h1 = y(:,5);

m2 = y(:,6);
h2 = y(:,8);

gNa1 = gNa_max .* m1.^3 .* h1;
gNa2 = gNa_max .* m2.^3 .* h2;

INa1 = gNa1 .* (V1 - ENa);
INa2 = gNa2 .* (V2 - ENa);

figure(1); clf; hold on

plot(t,INa1,'LineWidth',2);

plot(t,INa2,'LineWidth',2);

xlabel('time (ms)',...
    'Interpreter','latex',...
    'FontSize',18)

ylabel('$I_{Na}$ ($\mu$A/cm$^2$)',...
    'Interpreter','latex',...
    'FontSize',18)

legend({'$I_{Na_1}$',...
        '$I_{Na_2}$'},...
    'Interpreter','latex',...
    'FontSize',18,...
    'Location','northeast',...
    'Box','off')

% ---------------- Figure formatting ----------------

set(gcf,'PaperPosition',[0 0 6 4])
set(gcf,'Position',[15 15 550 420])

set(gca,...
    'Position',[0.17 0.17 0.80 0.77],...
    'FontSize',25,...
    'FontName','Times',...
    'LineWidth',1,...
    'TickLength',[0.02 0.02])

xlim([4 18])
ylim([-1200 100])

xticks([4 8 12 16])
grid on
%% ---------------- Pulse arrow ----------------

drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (x_data-xlim_(1))/(xlim_(2)-xlim_(1))*axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.07 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);
%%
%% ==========================================================
%% Inset 1 : Pulse dynamics (100 ns)
%% ==========================================================

tp      = 1e-4;      % Pulse duration (ms)
tau     = 1e-5;      % Characteristic time (ms)
t_pulse = 5;         % Pulse onset (ms)

t_local = (t - t_pulse)*1e6;      % ms -> ns

axInset = axes('Position',[0.35 0.57 0.25 0.25]);
box(axInset,'on');
hold(axInset,'on')

plot(axInset,...
    t_local,INa1, 'LineWidth',2);

plot(axInset,...
    t_local, INa2,'LineWidth',2);

xlim(axInset,[-10 120])
ylim(axInset,[-5 30])

xticks(axInset,[0 100])

set(axInset,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset,'on')

text(axInset,...
    0.08,0.88,'100 ns',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');

%% ==========================================================
%% Inset 2 : Recovery dynamics (ms)
%% ==========================================================

axInset2 = axes('Position',[0.35 0.25 0.25 0.25]);
box(axInset2,'on');
hold(axInset2,'on')

plot(axInset2,t,INa1,'LineWidth',2);

plot(axInset2,t,INa2,'LineWidth',2);

%plot(axInset2,t, (INa1-INa2), 'LineWidth',2);

xlim(axInset2,[5 6])
%ylim(axInset2,[-100 5])

%xticks(axInset2,[5 6 7 8])

set(axInset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset2,'on')

text(axInset2,...
    0.90,0.88,'ms',...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',18,...
    'FontName','Times');
%% saving the fig file as PDF
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S16_Fig_e.pdf');
% Save as PDF
finish_figure(h, save_path);

close all
%% ==========================================================
%%                 Potassium Current (IK) (Repititive Spiking)
%% ==========================================================

v = 4;

t = all_t_tot{v};
y = all_y_tot{v};

EK = -82;      % mV

V1 = y(:,1);
V2 = y(:,2);

n1 = y(:,4);
n2 = y(:,7);

gK1 = gK_max .* n1.^4;
gK2 = gK_max .* n2.^4;

IK1 = gK1 .* (V1 - EK);
IK2 = gK2 .* (V2 - EK);


figure(2); clf; hold on

plot(t,IK1,'LineWidth',2);

plot(t,IK2,'LineWidth',2);

xlabel('time (ms)',...
    'Interpreter','latex',...
    'FontSize',18)

ylabel('$I_{K}$ ($\mu$A/cm$^2$)',...
    'Interpreter','latex',...
    'FontSize',18)

legend({'$I_{K_1}$',...
        '$I_{K_2}$'},...
    'Interpreter','latex',...
    'FontSize',18,...
    'Location','northeast',...
    'Box','off')

% ---------------- Figure formatting ----------------

set(gcf,'PaperPosition',[0 0 6 4])
set(gcf,'Position',[15 15 550 420])

set(gca,...
    'Position',[0.17 0.17 0.80 0.77],...
    'FontSize',25,...
    'FontName','Times',...
    'LineWidth',1,...
    'TickLength',[0.02 0.02])

xlim([4 18])
ylim([-400 1200])
yticks([-300 0 300 600 900])
xticks([4 8 12 16])

%% ---------------- Pulse arrow ----------------

drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (x_data-xlim_(1))/(xlim_(2)-xlim_(1))*axpos(3);

annotation('arrow',...
    [x_norm x_norm],...
    [axpos(2)-0.07 axpos(2)],...
    'Color','r',...
    'LineWidth',1.6,...
    'HeadLength',10,...
    'HeadWidth',10);

%%
%%
%% ==========================================================
%% Inset 1 : Pulse dynamics (100 ns)
%% ==========================================================

tp      = 1e-4;      % Pulse duration (ms)
tau     = 1e-5;      % Characteristic time (ms)
t_pulse = 5;         % Pulse onset (ms)

t_local = (t - t_pulse)*1e6;      % ms -> ns

axInset = axes('Position',[0.35 0.57 0.25 0.25]);
box(axInset,'on');
hold(axInset,'on')

plot(axInset,...
    t_local,IK1,'LineWidth',2);

plot(axInset,...
    t_local,IK2,'LineWidth',2);

xlim(axInset,[-10 120])
ylim(axInset,[-500 600])

xticks(axInset,[0 100])

set(axInset,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset,'on')

text(axInset,...
    0.08,0.88,'100 ns',...
    'Units','normalized',...
    'FontSize',18,...
    'FontName','Times');


%%
%% ==========================================================
%% Inset 2 : Recovery dynamics (ms)
%% ==========================================================

axInset2 = axes('Position',[0.35 0.25 0.25 0.25]);
box(axInset2,'on');
hold(axInset2,'on')

plot(axInset2,...
    t,IK1,'LineWidth',2);

plot(axInset2,...
    t,IK2,'LineWidth',2);

xlim(axInset2,[5 6])
%ylim(axInset2,[-5 40])

xticks(axInset2,[5 6 7 8])

set(axInset2,...
    'FontSize',20,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'LineWidth',1.5,...
    'TickLength',[0.02 0.02],...
    'Box','on',...
    'XMinorTick','on',...
    'YMinorTick','on');

grid(axInset2,'on')

text(axInset2,...
    0.90,0.88,'ms',...
    'Units','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',18,...
    'FontName','Times');
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
save_path = fig_path('SI/S16_Fig_f.pdf');


% Save as PDF
finish_figure(h, save_path);

close all

