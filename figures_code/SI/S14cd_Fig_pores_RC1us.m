addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% Plot pore statistics (RC = 1e-3 ms or 1e-6 s) nsPEF range
%% Loading data
clear all
clc
data = csvread([project_root '/data/strength_duration/RC1e-3ms_new-Table 1.csv']); % reading data from SD file

%% Extraction of data
% Pulse duration
pulse_duration = data(1:9, 9)*1e-3; % from ms to s

%% Pores formed at Depolarized Side
Pore_electroporation_DP = data(1:9,15); % Threshold for Electroporation
Pore_RS_DP = data(1:9,19); % Repititon Spiking Threshold
Pore_RSlim_DP = data(1:9,23); % Depolarization block threshold
% Pore_DB_DP = data(1:9,27); % AP followed by Depolarization block
Pore_CD_DP = data(1:9,31); % IRE detected for the first time

% HP side
Pore_electroporation_HP = data(1:9,16); % Threshold for Electroporation
Pore_RS_HP = data(1:9,20); % RS threshold
Pore_RSlim_HP = data(1:9,24); % DB threshold
%Pore_DB_HP = data(1:9,28); % AP followed by Depolarization block
Pore_CD_HP = data(1:9,32); % IRE detected for the first time

%% Plotting DP Side for RC = 1e-3 ms (nsPEF)

loglog(pulse_duration(1:9), Pore_RS_DP,'>-', 'Color', [0.5, 0.2, 0.8], 'MarkerFaceColor', [0.5, 0.2, 0.8], 'LineWidth',1.5,'MarkerSize',12);
hold on
loglog(pulse_duration(1:9), Pore_RSlim_DP,'<-', 'Color', "#EDB120", 'MarkerFaceColor', "#EDB120", 'LineWidth',1.5,'MarkerSize',12);
%loglog(pulse_duration(1:9), Pore_DB_DP,'p-', 'Color', "#D95319", 'MarkerFaceColor', "#D95319", 'LineWidth',1.5,'MarkerSize',12);
loglog(pulse_duration(1:9), Pore_CD_DP,'h-', 'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth',1.5,'MarkerSize',12,'MarkerSize',12);


% Customize the semilog (labels, title, grid, etc.)
grid on;
set(gcf,'Position',[15 15 550 420]);
set(gca,'Position',[0.17 0.17 0.80 0.77]);
set(gca,'FontSize',25);
set(gca,'FontName','Times');
xlabel('Pulse duration (s)','FontSize',25,'Interpreter','Latex');
ylabel('Pores (DP side)','FontSize',25,'Interpreter','Latex');
set(gca,'LineWidth',1);
set(gca,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');
ylim([5e-1 1e7])
yticks([1e0 1e2 1e4 1e6])
xlim([0.8e-8 2.2e-6])
ax = gca;              % Get current axes
ax.XMinorGrid = 'off'; % Turn off minor grid for X-axis
ax.YMinorGrid = 'off'; % Turn off minor grid for Y-axis
hold off;
legend('Repetitive spiking','Depolarization block', 'Cell death' )
legend('Location', 'best', 'Box', 'off');  % 'best' places the legend in the least intrusive spot, 'Box', 'off' removes the box
legend('Location', 'best', 'NumColumns', 1, 'Interpreter','latex','Box', 'off', FontSize=18);

text(2e-8, 1e5, '$RC=10^{-6}\ \mathrm{s}$', 'Interpreter', 'latex', ...
     'FontSize', 25, 'FontWeight', 'bold')

%% Sacing the fig file as PDF
h = gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
finish_figure(h, fig_path('SI/S14_Fig_c.pdf'))

close all
%************************** END OF DP SIDE *********************************

%% Pores formed at HP side
Pore_electroporation_HP = data(1:9,16); % Threshold for Electroporation
Pore_RS_HP = data(1:9,20); % RS threshold
Pore_RSlim_HP = data(1:9,24); % DB threshold
%Pore_DB_HP = data(1:9,28); % AP followed by Depolarization block
Pore_CD_HP = data(1:9,32); % IRE detected for the first time

%% Plotting HP Side for RC = 1e-3 ms (nsPEF)

loglog(pulse_duration(1:9), Pore_electroporation_HP(1:9),'d-', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineWidth',1.5,'MarkerSize',12);
hold on
loglog(pulse_duration(1:9), Pore_RS_HP,'>-', 'Color', [0.5, 0.2, 0.8], 'MarkerFaceColor', [0.5, 0.2, 0.8], 'LineWidth',1.5,'MarkerSize',12);
loglog(pulse_duration(1:9), Pore_RSlim_HP,'<-', 'Color', "#EDB120", 'MarkerFaceColor', "#EDB120", 'LineWidth',1.5,'MarkerSize',12);
%loglog(pulse_duration(1:9), Pore_DB_HP,'p-', 'Color', "#D95319", 'MarkerFaceColor', "#D95319", 'LineWidth',1.5,'MarkerSize',12);
loglog(pulse_duration(1:9), Pore_CD_HP(1:9),'h-', 'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth',1.5,'MarkerSize',12,'MarkerSize',12);

% Customize the semilog (labels, title, grid, etc.)
grid on;
set(gcf,'Position',[15 15 550 420]);
set(gca,'Position',[0.17 0.17 0.80 0.77]);
set(gca,'FontSize',25);
set(gca,'FontName','Times');
xlabel('Pulse duration (s)','FontSize',25,'Interpreter','Latex');
ylabel('Pores (HP side)','FontSize',25,'Interpreter','Latex');
set(gca,'LineWidth',1);
set(gca,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');
ylim([5e-1 1e7])
yticks([1e0 1e2 1e4 1e6])
xlim([0.8e-8 2.2e-6])

ax = gca;              % Get current axes
ax.XMinorGrid = 'off'; % Turn off minor grid for X-axis
ax.YMinorGrid = 'off'; % Turn off minor grid for Y-axis
hold off;
legend('Electroporation threshold','Repetitive spiking','Depolarization block', 'Cell death' )
legend('Location', 'best', 'Box', 'off');  % 'best' places the legend in the least intrusive spot, 'Box', 'off' removes the box
legend('Location', 'best', 'NumColumns', 1, 'Interpreter','latex','Box', 'off', Fontsize=18);

text(2e-8, 1e7, '$RC=10^{-6}\ \mathrm{s}$', 'Interpreter', 'latex', ...
     'FontSize', 25, 'FontWeight', 'bold')

%% Saving the fig file as PDF
h = gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
finish_figure(h, fig_path('SI/S14_Fig_d.pdf'))