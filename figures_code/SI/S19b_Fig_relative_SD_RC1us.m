addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% Load CSV Data
clc; clear all;
data = csvread([project_root '/data/strength_duration/%SD-RC1e-3ms.csv']);

%% Extract data

time_EP_HH = data(1:8,1); % time in seconds

% thresholds in percentage of HH model 
HHKSth = data(1:8,2); % Stimulation threshold HHK
EPth = data(1:8,3); % Electroporation thrshold 
RPth = data(1:8,4); % Repitition spike threshold
RPlim = data(1:8,5); % Depolariation block threshold
CDire = data(1:8,6); % IRE detected for the first time
%% Plots
yline(0, LineStyle="--", Color='k',LineWidth=1.5);
hold on
semilogx(time_EP_HH, HHKSth,'^-', 'Color', 'g', 'MarkerFaceColor', 'g', 'LineWidth',2);
semilogx(time_EP_HH, EPth ,'d-', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineWidth',2);
semilogx(time_EP_HH, RPth,'>-','Color', [0.5, 0.2, 0.8], 'MarkerFaceColor', [0.5, 0.2, 0.8], 'LineWidth',2);
semilogx(time_EP_HH, RPlim,'<-', 'Color', "#EDB120", 'MarkerFaceColor', "#EDB120", 'LineWidth',2);
%semilogx(time_EP_HH, DBth,'p-', 'Color', "#D95319", 'MarkerFaceColor', "#D95319", 'LineWidth',1);
semilogx(time_EP_HH, CDire,'h-', 'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth',2);

% Adding the legend
% legend('Location', 'best', 'Box', 'off');  % 'best' places the legend in the least intrusive spot, 'Box', 'off' removes the box
% legend('Excitation threshold (HH)','Excitation threshold (HHK)','Electroporation threshold','Repetitive spiking','Depolarization block', 'Cell death' )
% legend('Location', 'best', 'NumColumns', 1, 'Interpreter','latex','Box', 'off', FontSize=14, FontWeight='bold');
% xlim([4e-8 2e-6;]); 
% ylim([1e3 4e4]);
ylim([-20 2500])
xlim([0.8e-8 1.2e-6])
set(gca, 'XScale', 'log');
% Customize the semilog (labels, title, grid, etc.)
grid on;
set(gcf,'Position',[15 15 550 420]);
set(gca,'Position',[0.17 0.17 0.80 0.77]);
set(gca,'FontSize',22);
set(gca,'FontName','Times');
xlabel('$\tau$ (s)','FontSize',25,'Interpreter','Latex');
ylabel('$\%-$Excitation threshold (HH)','FontSize',25,'Interpreter','Latex');
set(gca,'LineWidth',1);
set(gca,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');
hold off;

text(2e-8, 90, '$RC=10^{-6}\ \mathrm{s}$', 'Interpreter', 'latex', ...
     'FontSize', 20, 'FontWeight', 'bold')
%% ---------------- INSET AXES (ns–µs regime) ----------------
inset_ax1 = axes('Position',[0.55 0.55 0.32 0.32]);
hold(inset_ax1, 'on');
box(inset_ax1, 'on');

% idx = 1:8; % ns–µs regime data

% Plot all relevant curves on inset
yline(inset_ax1,0, LineStyle="--",Color='k', LineWidth=1.5);
hold on
semilogx(inset_ax1, time_EP_HH, HHKSth,'^-', 'Color', 'g', 'MarkerFaceColor', 'g', 'LineWidth',2);

semilogx(inset_ax1,time_EP_HH, EPth ,'d-', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineWidth',2);
semilogx(inset_ax1,time_EP_HH, RPth,'>-','Color', [0.5, 0.2, 0.8], 'MarkerFaceColor', [0.5, 0.2, 0.8], 'LineWidth',2);
semilogx(inset_ax1,time_EP_HH, RPlim,'<-', 'Color', "#EDB120", 'MarkerFaceColor', "#EDB120", 'LineWidth',2);
%semilogx(time_EP_HH, DBth,'p-', 'Color', "#D95319", 'MarkerFaceColor', "#D95319", 'LineWidth',1);
semilogx(inset_ax1,time_EP_HH, CDire,'h-', 'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth',2);

% ----------- LOG SCALE SETTINGS -----------
%set(inset_ax1, 'XScale', 'log', 'YScale', 'log');
set(inset_ax1, 'XScale', 'log');
xlim(inset_ax1,[1e-8 1e-6]); 
ylim(inset_ax1,[-10 70])
yticks(inset_ax1,[-10 0 20 40 60])

% Axis limits (strictly positive for log scale)
%xlim(inset_ax1, [1e-9 1e-6]);

% y_all = [Excitation_threshold(idx); EP_threshold(idx); RS_threshold(idx); RS_limit(idx)];
% ylim(inset_ax1, [min(y_all)*0.8 max(y_all)*1.2]);

% ----------- FORMATTING -----------
set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

grid(inset_ax1, 'on');

%% Saving the figure as PDF
h = gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
finish_figure(h, fig_path('SI/S19_Fig_b.pdf'))

