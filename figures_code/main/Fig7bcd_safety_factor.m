addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% Plotting safety gap as RC increases for 10 ns pulse
clear all; clc; 
%Data
RC = [1e-8; 1e-7; 1e-6];  % time constants in seconds
log_RC = log([1e-8; 1e-7; 1e-6]); 

% thresholds in mV
Excitation_threshold = [2451; 11055; 81956]; 
EP_threshold         = [2393; 11178; 94985];
RS_threshold         = [2853; 13424; 117023];
DB_threshold         = [3020; 14234; 124719];
Cell_death           = [4383; 17534; 157796];

% log 
log_Excitation_threshold = log(Excitation_threshold); 
log_EP_threshold         = log(EP_threshold);
log_RS_threshold         = log(RS_threshold);
log_DB_threshold         = log(DB_threshold);
log_Cell_death           = log(Cell_death);

%% PLots
% % RC range (log-spaced for better resolution on log-log plot)
% RC_vals = logspace(-8, -6, 100);  % From 1e-8 to 1e-6 seconds
% 
% % Coefficients from your fit
% p1 = [0.762, 0.7993, 0.8067, 0.808, 0.792];
% p2 = [21.7614, 22.405, 22.7192, 22.7948, 22.7225];
% 
% % Compute predicted thresholds
% Vstim = zeros(length(p1), length(RC_vals));
% for i = 1:length(p1)
%     a = exp(p2(i));
%     b = p1(i);
%     Vstim(i, :) = a * RC_vals.^b;
% end



% Plot
figure(1);
%plot(RC,Excitation_threshold,'^','MarkerFaceColor','g', "MarkerSize",12 )

plot(RC,(EP_threshold-Excitation_threshold)./Excitation_threshold,'d','MarkerFaceColor','m', "MarkerSize",12 ); hold on
plot(RC,(RS_threshold-Excitation_threshold)./Excitation_threshold,'>','MarkerFaceColor',[0.5, 0.2, 0.8], "MarkerSize",12)
plot(RC,(DB_threshold-Excitation_threshold)./Excitation_threshold,'<','MarkerFaceColor',"#EDB120", "MarkerSize",12  )
plot(RC,(Cell_death-Excitation_threshold)./Excitation_threshold,'h','MarkerFaceColor','k',"MarkerSize",12 )
yline( 0, 'k--','LineWidth',2);
hold off

ylabel('Safety factor');

ylim([-0.2 1.1]);
xlim([5e-9 1.5e-6]);
grid on;
ax = gca;
ax.TickLabelInterpreter = 'latex';
set(gca,'FontSize',25,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');
xlabel('$RC$ (s)','FontSize',20,'Interpreter','Latex');
ylabel('Safety factor','FontSize',20,'Interpreter','Latex');
% legend({
%     'Electroporation threshold','Repetitive spiking','Depolarization block', 'Cell death'}, ...
%     'Location', 'best', 'NumColumns', 1, 'Interpreter','latex','Box', 'off',FontSize=18, FontWeight='bold');

%set(gca,'yscale','log')
set(gca,'xscale','log')

grid on;
set(gca, 'FontSize', 12); 
set(gcf, 'PaperUnits', 'inches');      
set(gcf, 'PaperPosition', [0 0 6 4]);   

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])



% text(3e-8, 4e4, '$\tau=10$ ns', 'Interpreter', 'latex', ...
%      'FontSize', 20, 'FontWeight', 'bold')
grid off

%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig7c.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%% safety factor vs pulse duration - 10 ns, 1 microsecond, and 100 microseconds
% RC=1e-8 s

pulse_duration = [1e-8; 1e-6; 1e-4];  % pulse in seconds
Excitation_threshold = [2451; 1159; 81]; 
EP_threshold         = [2393; 1603; 842];
RS_threshold         = [2853];
DB_threshold         = [3020];
Cell_death           = [4383; 2606; 867];

% Plot
figure(1);
%plot(RC,Excitation_threshold,'^','MarkerFaceColor','g', "MarkerSize",12 )

plot(pulse_duration,(EP_threshold-Excitation_threshold)./Excitation_threshold,'d','MarkerFaceColor','m', "MarkerSize",12 ); hold on
plot(pulse_duration(1,1),(RS_threshold(1,1)-Excitation_threshold(1,1))/Excitation_threshold(1,1),'>','MarkerFaceColor',[0.5, 0.2, 0.8], "MarkerSize",12)
plot(pulse_duration(1,1),(DB_threshold(1,1)-Excitation_threshold(1,1))/Excitation_threshold(1,1),'<','MarkerFaceColor',"#EDB120", "MarkerSize",12  )
plot(pulse_duration,(Cell_death-Excitation_threshold)./Excitation_threshold,'h','MarkerFaceColor','k',"MarkerSize",12 )
yline( 0, 'k--','LineWidth',2);
hold off

ylabel('Safety factor');
xticks([1e-8 1e-6 1e-4])
ylim([-2 12]);
xlim([1e-9 1e-3]);
grid on;
ax = gca;
ax.TickLabelInterpreter = 'latex';
set(gca,'FontSize',21,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');
xlabel('$\tau$ (s)','FontSize',20,'Interpreter','Latex');
ylabel('Safety factor','FontSize',20,'Interpreter','Latex');
% legend({
%     'Electroporation threshold','Repetitive spiking','Depolarization block', 'Cell death'}, ...
%     'Location', 'best', 'NumColumns', 2, 'Interpreter','latex','Box', 'off',FontSize=16, FontWeight='bold');

%set(gca,'yscale','log')
set(gca,'xscale','log')

grid on;
set(gcf, 'PaperUnits', 'inches');      
set(gcf, 'PaperPosition', [0 0 6 4]);   

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])



% text(3e-8, 4e4, '$\tau=10$ ns', 'Interpreter', 'latex', ...
%      'FontSize', 20, 'FontWeight', 'bold')
grid off
%%
%% --- Insets (thresholds only) ---
% Inset around RC = 1e-8
ax1 = axes('Position',[0.45 0.50 0.18 0.22]);

% Relative differences (threshold - Excitation) / Excitation
plot(pulse_duration,(EP_threshold-Excitation_threshold)./Excitation_threshold, ...
     'd','MarkerFaceColor','m', "MarkerSize",12); hold on
plot(pulse_duration,(Cell_death-Excitation_threshold)./Excitation_threshold, ...
     'h','MarkerFaceColor','k',"MarkerSize",12)

% Zero reference line
yline(0, 'k--','LineWidth',2);
hold off
xlim([0.9e-6 1.1e-6]); ylim([-0.2 1.5])

set(ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');


% Force exponent offset notation like ScalarFormatter in Matplotlib
ax1.XAxis.Exponent = -6;   % <-- show ×10⁻⁸ outside axis
ax1.YAxis.Exponent = 0;    % keep y-axis normal (no scaling)

% Inset 2
ax1 = axes('Position',[0.68 0.50 0.18 0.22]);

% Relative differences (threshold - Excitation) / Excitation
plot(pulse_duration,(EP_threshold-Excitation_threshold)./Excitation_threshold, ...
     'd','MarkerFaceColor','m', "MarkerSize",12); hold on
plot(pulse_duration,(Cell_death-Excitation_threshold)./Excitation_threshold, ...
     'h','MarkerFaceColor','k',"MarkerSize",12)

% Zero reference line
yline(0, 'k--','LineWidth',2);
hold off
xlim([0.9e-4 1.1e-4]); ylim([8.8 10.2])

set(ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');


% Force exponent offset notation like ScalarFormatter in Matplotlib
ax1.XAxis.Exponent = -4;   % <-- show ×10⁻⁸ outside axis
ax1.YAxis.Exponent = 0;    % keep y-axis normal (no scaling)

%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig7b.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%%
pulse_duration =[1.00e-09;1.00e-08;2.00e-08;2.90e-08]; % pulse under 30 ns
safety_factor=[-7.325185644;-2.366381069;1.461693548;4.50597177];


% Plot
figure(1);
%plot(RC,Excitation_threshold,'^','MarkerFaceColor','g', "MarkerSize",12 )

plot(pulse_duration,safety_factor,'s','MarkerFaceColor','r', "MarkerSize",12 ); hold on
yline( 0, 'k--','LineWidth',2);
hold off

ylabel('Safety factor');

%ylim([-2 11]);
xlim([-5e-9 40e-9]);
ylim([-10 10])
grid on;
ax = gca;
ax.TickLabelInterpreter = 'latex';
set(gca,'FontSize',21,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');
xlabel('$\tau$ (s)','FontSize',20,'Interpreter','Latex');
ylabel('\% Safety factor','FontSize',20,'Interpreter','Latex');



% Define ticks at 1 ns, 10 ns, 20 ns, 30 ns
xticks([1e-9 1e-8 2e-8 3e-8]);

% Show them as '1 ns', '10 ns', etc.
%xticklabels({'1 ns','10 ns','20 ns','30 ns'});

% legend({
%     'Electroporation threshold','Repetitive spiking','Depolarization block', 'Cell death'}, ...
%     'Location', 'best', 'NumColumns', 1, 'Interpreter','latex','Box', 'off',FontSize=15, FontWeight='bold');

%set(gca,'yscale','log')
%set(gca,'xscale','log')

grid on;
set(gcf, 'PaperUnits', 'inches');      
set(gcf, 'PaperPosition', [0 0 6 4]);   

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])



% text(3e-8, 4e4, '$\tau=10$ ns', 'Interpreter', 'latex', ...
%      'FontSize', 20, 'FontWeight', 'bold')
grid off

ax = gca;                % current axis (or inset axis handle, e.g., ax1)
ax.XAxis.Exponent = -9;  % show ×10⁻⁹ on x-axis
ax.YAxis.Exponent = 0;   % keep y-axis labels as-is
%%
%% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig7d.pdf');


% Save as PDF
finish_figure(h, save_path);

close all

