addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% Plot pore statistics (RC = 1e-5 ms or 1e-8 s) nsPEF range
%% Loading data
close all
clear all
clc
data = csvread([project_root '/data/strength_duration/SD_till_1ms_RC1e-5.csv']);  % for RC = 1e-5ms 
%% Extraction of data
% pulse duration
pulse_duration = data(1:9, 4)*1e-3; % from ms to s

%% Pores formed at Depolarized Side
Pore_stimulation_DP = data(1:9,11); % Pores formed at Threshold for Stimulation
Pore_electroporation_DP = data(1:9,15); % Threshold for Electroporation
Pore_RS_DP = data(1:9,19); % Ringing begins
Pore_RSlim_DP = data(1:9,23); % Ringing stops
Pore_DB_DP = data(1:9,27); % AP followed by Depolarization block
Pore_CDfpa_DP = data(1:9,31); % IRE detected for the first time

%loglog(pulse_duration, Pore_stimulation_DP,'^-', 'Color', 'g', 'MarkerFaceColor', 'g', 'LineWidth',1.5,'MarkerSize',12);
%hold on
%loglog(pulse_duration, Pore_electroporation_DP,'d-', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineWidth',1.5,'MarkerSize',12);

loglog(pulse_duration(1:9), Pore_RS_DP,'>-', 'Color', [0.5, 0.2, 0.8], 'MarkerFaceColor', [0.5, 0.2, 0.8], 'LineWidth',1.5,'MarkerSize',12);
hold on
loglog(pulse_duration(1:9), Pore_RSlim_DP,'<-', 'Color', "#EDB120", 'MarkerFaceColor', "#EDB120", 'LineWidth',1.5,'MarkerSize',12);
%loglog(pulse_duration(1:8), Pore_DB_DP,'p-', 'Color', "#D95319", 'MarkerFaceColor', "#D95319", 'LineWidth',1.5,'MarkerSize',12);
loglog(pulse_duration, Pore_CDfpa_DP,'h-', 'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth',1.5,'MarkerSize',12,'MarkerSize',12);

xlim([0.8e-9 1.2e-6])
ylim([0.5e0 1e7])
yticks([1e0 1e2 1e4 1e6])
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


ax = gca;              % Get current axes
ax.XMinorGrid = 'off'; % Turn off minor grid for X-axis
ax.YMinorGrid = 'off'; % Turn off minor grid for Y-axis
hold off;
legend('Repetitive spiking','Depolarization block', 'Cell death' )
legend('Location', 'best', 'Box', 'off');  % 'best' places the legend in the least intrusive spot, 'Box', 'off' removes the box
legend('Location', 'best', 'NumColumns', 1, 'Interpreter','latex','Box', 'off', FontSize=18);


text(2e-8, 1e5, '$RC=10^{-8}\ \mathrm{s}$', 'Interpreter', 'latex', ...
     'FontSize', 25, 'FontWeight', 'bold')
%% Saving the fig into PDF file

h = gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
finish_figure(h, fig_path('SI/S14_Fig_a.pdf'))

close all
%************************** END OF DP SIDE *********************************

%% Pores formed at HP side
% HP side
Pore_stimulation_HP = data(1:9,12); % Pores formed at Threshold for Stimulation
Pore_electroporation_HP = data(1:9,16); % Threshold for Electroporation
Pore_RS_HP = data(1:9,20); % Ringing begins
Pore_RSlim_HP = data(1:9,24); % Ringing stops
%Pore_DB_HP = data(1:8,28); % AP followed by Depolarization block
Pore_CDfpa_HP = data(1:9,32); % IRE detected for the first time

%% Plot
loglog(pulse_duration, Pore_stimulation_HP,'^-', 'Color', 'g', 'MarkerFaceColor', 'g', 'LineWidth',1.5,'MarkerSize',12);
hold on
loglog(pulse_duration, Pore_electroporation_HP,'d-', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineWidth',1.5,'MarkerSize',12);

loglog(pulse_duration(1:9), Pore_RS_HP,'>-', 'Color', [0.5, 0.2, 0.8], 'MarkerFaceColor', [0.5, 0.2, 0.8], 'LineWidth',1.5,'MarkerSize',12);
loglog(pulse_duration(1:9), Pore_RSlim_HP,'<-', 'Color', "#EDB120", 'MarkerFaceColor', "#EDB120", 'LineWidth',1.5,'MarkerSize',12);
%loglog(pulse_duration(1:8), Pore_DB_HP,'p-', 'Color', "#D95319", 'MarkerFaceColor', "#D95319", 'LineWidth',1.5,'MarkerSize',12);
loglog(pulse_duration(1:9), Pore_CDfpa_HP,'h-', 'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth',1.5,'MarkerSize',12,'MarkerSize',12);


% Adding the legend
%legend('Location', 'best', 'Box', 'off');  % 'best' places the legend in the least intrusive spot, 'Box', 'off' removes the box
%legend('Location', 'best', 'NumColumns', 2, 'Interpreter','latex','Box', 'off');
% xlim([4e-8 2e-6;]); 
% ylim([1e3 4e4]);

% Customize the semilog (labels, title, grid, etc.)
grid on;
set(gcf,'Position',[15 15 550 420]);
set(gca,'Position',[0.17 0.17 0.80 0.77]);
set(gca,'FontSize',25);
set(gca,'FontName','Times');
xlabel('Pulse duration (s)','FontSize',25,'Interpreter','Latex');
ylabel('Pores (HP side)','FontSize',25,'Interpreter','Latex');
set(gca,'LineWidth',1);
%set(gca,'TickLength',[0.02 0.02]);
%set(gca,'XMinorTick','on','YMinorTick','on');
ylim([2e-1 1e7])
yticks([1e0 1e2 1e4 1e6])
xlim([0.8e-9 1.2e-6])
ax = gca;              % Get current axes
ax.XMinorGrid = 'off'; % Turn off minor grid for X-axis
ax.YMinorGrid = 'off'; % Turn off minor grid for Y-axis
hold off;
legend('Excitation thrershold','Electroporation threshold','Repetitive spiking','Depolarization block', 'Cell death' )
legend('Location', 'best', 'Box', 'off');  % 'best' places the legend in the least intrusive spot, 'Box', 'off' removes the box
legend('Location', 'best', 'NumColumns', 2, 'Interpreter','latex','Box', 'off', FontSize=15);

text(2e-8, 2e4, '$RC=10^{-8}\ \mathrm{s}$', 'Interpreter', 'latex', ...
     'FontSize', 25, 'FontWeight', 'bold')

%% Saving the fig into PDF file

h = gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
finish_figure(h, fig_path('SI/S14_Fig_b.pdf'))

close all
