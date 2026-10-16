addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
clc;
clear all;
%data = csvread([project_root '/data/strength_duration/RC1e-3ms_10nsto1ms.csv']); % reading data from SD file
data = csvread([project_root '/data/strength_duration/RC1e-3ms_new-Table 1.csv']); % reading data from SD file

%%
% S-D curve with Boinagrov's work plotted on the same figure

% Extracted data from paper
time_Boingrov = data(3:20,1)*1e-3; % (sec) pulse-duration-time extracted from Boinagrov's paper
Vstim_Boinagrov = data(3:20,2); % (mV) Vstim extracted from Boinagrov's paper

% Benchmarked data for HH without including EP model
time_benchmark_HH = data(1:20,4)*1e-3; % (sec) pulse-duration-time used for benchmarking
Vstim_benchmark_HH = data(1:20,3); % (mV) Vstim used for benchamrking 

% S-D data using Hodgkin-Huxley-Krassowska(HHK) model for different responses
time_EP_HH = data(1:20,9)*1e-3; % (sec) pulse-duration-time used for HHK model. Mult by 1e-3 for ms to sec conv.
Excitation_threshold = data(1:20, 10); % (mV) excitation threshold - first AP is seen
EP_threshold = data(1:20,14); % EP threshold - first pore forms
RS_threshold = data(1:10,18); % Repetitive Spiking begins - more than one AP seen
RS_limit = data(1:10,22); % Repetitive Spiking ends - more than than one AP
%DB_threshold = data(1:9,26); % Depolarizaton Block threshold - Hyperpolarizing arm of AP fails to go below -40 mV
Cell_Death = data(1:20,30); % Stimulus beyond this sees cell death 

% Brief period of no excitation (BPNE)
time_no_excitation = data(15:20,9)*1e-3; % (sec) pulse-duration-time for BPNE exists

% (mV)
ll_BPNE = [589; 407; 342; 332; 312; 245]; % Lower limit for BPNE
ul_BPNE = [604; 418; 353; 347; 359; 376]; % Upper limit for BPNE

%%
% editing version
% Plots
 
% Excitation and Electroporation threshold
%loglog(time_Boingrov, Vstim_Boinagrov,'o-', 'Color', 'r', 'MarkerFaceColor', 'r', 'LineWidth',2);


loglog(time_benchmark_HH, Vstim_benchmark_HH,'s-', 'Color', 'b', 'MarkerFaceColor', 'b', 'LineWidth',2);
hold on;
loglog(time_EP_HH, Excitation_threshold,'^-', 'Color', 'g', 'MarkerFaceColor', 'g', 'LineWidth',2);
loglog(time_EP_HH, EP_threshold,'d-', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineWidth',1.5);

% Repetitive Spiking happens in ns-µs regime only
loglog(time_EP_HH(1:10),RS_threshold ,'>-', 'Color', [0.5, 0.2, 0.8], 'MarkerFaceColor', [0.5, 0.2, 0.8], 'LineWidth',2);
loglog(time_EP_HH(1:10), RS_limit,'<-', 'Color', "#EDB120", 'MarkerFaceColor', "#EDB120", 'LineWidth',2);

% Depolarization block 
%loglog(time_EP_HH(1:9), DB_threshold,'p-', 'Color', "#D95319", 'MarkerFaceColor', "#D95319", 'LineWidth',1.5);

% Cell Death
loglog(time_EP_HH, Cell_Death,'h-', 'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth',2);

% Adding range of no stimulation
loglog(time_no_excitation,ll_BPNE, 'Color','r', 'LineWidth', 2)
loglog(time_no_excitation,ul_BPNE, 'Color','r', 'LineWidth', 2)



% Adding the legend
% legend('Excitation threshold (HH)', 'Excitation threshold (HHK)','Electroporation threshold','Repetitive spiking','Depolarization block', 'Cell death','stimulation gap(*)','stimiulation gap(**)' )
% legend('Location', 'best', 'Box', 'off');  % 'best' places the legend in the least intrusive spot, 'Box', 'off' removes the box
% legend('Location', 'best', 'NumColumns', 2, 'Interpreter','latex','Box', 'off', FontSize=12, FontWeight='bold');
xlim([5e-9 1.5e-3;]); 
ylim([1e1 2e5]);
yticks([1e1 1e2 1e3 1e4 1e5])
% Customize the loglog (labels, title, grid, etc.)
grid on;
set(gcf,'Position',[15 15 550 420]);
set(gca,'Position',[0.17 0.17 0.80 0.77]);
set(gca,'FontSize',22);
set(gca,'FontName','Times');
xlabel('$\tau$ (s)','FontSize',25,'Interpreter','Latex', FontWeight='bold');
ylabel('$V_{\mathrm{stim}}$ (mV)','FontSize',25,'Interpreter','Latex', FontWeight='bold');
set(gca,'LineWidth',1);
set(gca,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');

text(1e-5, 1e4, '$RC=10^{-6}$ s', 'Interpreter', 'latex', ...
     'FontSize', 20, 'FontWeight', 'bold')
hold off;

%%
h = gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
finish_figure(h, fig_path('SI/S18_Fig_a.pdf'))


