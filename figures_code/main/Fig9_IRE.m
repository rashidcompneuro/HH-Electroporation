addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
%% Plotting IRE figures for 2.9 microseconds for RC1e-5 ms
%% Load the data
load([project_root '/data/raw/Cell_Death/2.9microseconds_1e5ms.mat'])
radius_HP_evolution;  % rebuild pore-radius traces (t<k>pore, r<k>pore)


%% Pore statistics for 2.9 mus for RC=1e-5 ms using HP-IRE for Vstim = 1890 mV


%% Pore radii

figure(1); clf
hold on

% --- Store data in cell arrays (clean approach) ---
t = {t2pore,t3pore,t4pore,t5pore,t6pore,...
     t7pore,t8pore,t9pore,t10pore,t11pore};

r = {r2pore,r3pore,r4pore,r5pore,r6pore,...
     r7pore,r8pore,r9pore,r10pore,r11pore};

% --- Colorblind-friendly palette ---
colors = [
    0.0000, 0.4470, 0.7410;
    0.8500, 0.3250, 0.0980;
    0.9290, 0.6940, 0.1250;
    0.4940, 0.1840, 0.5560;
    0.4660, 0.6740, 0.1880;
    0.3010, 0.7450, 0.9330;
    0.6350, 0.0780, 0.1840;
    0.25,   0.25,   0.25;
    0.75,   0.25,   0.75;
    0.1,    0.6,    0.4
];

% --- Line styles ---
styles = {'-','--',':','-.','-','--',':','-.','-','--'};

% --- Plot loop ---
for i = 1:10
    plot(t{i}, r{i}, ...
        'LineWidth', 2, ...
        'Color', colors(i,:), ...
        'LineStyle', styles{i});
end

% --- Legend ---
legend({'1$^{st}$','2$^{nd}$','3$^{rd}$','4$^{th}$','5$^{th}$','6$^{th}$',...
        '7$^{th}$','8$^{th}$','9$^{th}$','10$^{th}$'}, ...
       'Location','best','NumColumns',1, ...
       'Interpreter','latex','Box','off', ...
       'FontSize',18,'FontWeight','bold')

% --- Labels ---
xlabel('time (ms)', 'Interpreter','latex','FontSize',10);
ylabel('Pore radius (m)', 'Interpreter','latex','FontSize',14);

% --- Axes settings ---
xlim([3e0 3e4])
ylim([-0.1e-6 1.7e-6])

set(gca, 'XScale', 'log');
ax = gca;
ax.YAxis.Exponent = -6;

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

xticks([1 10 100 1000 1e4])

hold off
%% --- MUST BE AFTER set(gca,'XScale','log') ---
drawnow

ax = gca;
axpos = ax.Position;        % normalized position of axes
xlim_ = ax.XLim;

x_data = 5;                % time (ms) where arrow is needed

% Log-aware normalization
x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

% Arrow (pointing UP)
y_head = axpos(2);          % x-axis
y_tail = y_head - 0.08;     % below axis

annotation('arrow', ...
    [x_norm x_norm], ...
    [y_tail y_head], ...
    'Color','r', ...
    'LineWidth',1.6, ...
    'HeadLength',10, ...
    'HeadWidth',10);

 
%% % --- Inset A: Pulse duration ---

% --- Inset B: very fine zoom ---
ax2 = axes('Position',[0.25 0.25 0.4 0.4]);
box on; hold(ax2,'on');

% --- Plot using SAME colors + styles ---
for i = 1:10
    plot(ax2, (t{i}-5)*1e3, r{i}, ...
        'LineWidth', 2, ...
        'Color', colors(i,:), ...
        'LineStyle', styles{i});
end

% --- Zoom limits ---
xlim(ax2,[0 50]);
xticks([0 25 50])
ylim(ax2,[5e-10 20e-9]);

% --- Axis styling ---
set(ax2,'FontSize',22,'FontName','Times');
set(ax2,'LineWidth',1);
set(ax2,'TickLength',[0.02 0.02]);
% text(ax2,...
%     0.08,0.88,'$\mu$s',...
%     'Units','normalized',...
%     'FontSize',18,...
%     'FontName','Times', Interpreter='latex');


% Optional (recommended for clarity in inset)
%set(ax2,'XScale','log');   % only if main plot is log
%% Saving the fig as PDF file
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig9a.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%% Membrane Potential

plot(t_tot, y_tot(:,1),t_tot, y_tot(:,2), LineWidth=2); hold on
% plot(t_tot_SAP, Vstims_SAP, LineWidth=1.5, LineStyle="--")
hold off

xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('TMP (mV)', Interpreter='latex',FontSize=14);
% title('Membrane Potential at DP side vs time',Interpreter='latex',FontSize=12);
%legend('$V_1$','$V_{2}$','Box','off', Interpreter='latex',Location='northwest', fontsize=18)
%
% grid on
% set(gca, 'FontSize', 12); % Set axes font size
% % Adjust figure properties for high-quality output
% set(gcf, 'PaperUnits', 'inches');       % Set units to inches
% set(gcf, 'PaperPosition', [0 0 6 4]);   % Set the figure size [left, bottom, width, height]
set(gca, 'XScale', 'log');
%ylim([-300 1700])
xlim([2e0 3e4])
ylim([-1200 1100])
yline(-70, '--k', '$-70$ mV', 'Interpreter', 'latex', 'LineWidth', 2, 'LabelHorizontalAlignment', 'right','LabelVerticalAlignment', 'bottom', FontSize=17);


set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

% --- MUST BE AFTER set(gca,'XScale','log') ---
drawnow

ax = gca;
axpos = ax.Position;        % normalized position of axes
xlim_ = ax.XLim;

x_data = 5;                % time (ms) where arrow is needed

% Log-aware normalization
x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

% Arrow (pointing UP)
y_head = axpos(2);          % x-axis
y_tail = y_head - 0.08;     % below axis

legend('$V_1$','$V_{2}$','Box','off', Interpreter='latex',Location='best', fontsize=20)

annotation('arrow', ...
    [x_norm x_norm], ...
    [y_tail y_head], ...
    'Color','r', ...
    'LineWidth',1.5, ...
    'HeadLength',10, ...
    'HeadWidth',10);

%% Inset for pulse duration 
inset_ax1 = axes('Position',[0.50 0.50 0.25 0.25]); % Adjust position/size
hold(inset_ax1, 'on');

plot(inset_ax1, (t_tot-5)*1e3, y_tot(:,1),(t_tot-5)*1e3, y_tot(:,2), LineWidth=2);
%xline(inset_ax1,5, LineWidth=1.5,Color='k', LineStyle="--");


xlim(inset_ax1, [-0.1 3]); % in ms (i.e., pulse duration)
ylim(inset_ax1, [-1500 1500]); % in ms (i.e., pulse duration)

grid on
% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
% ylim(inset_ax, [0.1 0.9]);

set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

%% Inset for post pulse duration 
inset_ax = axes('Position',[0.50 0.25 0.25 0.25]); % Adjust position/size
hold(inset_ax, 'on');

plot(inset_ax, (t_tot-5)*1e3, y_tot(:,1),(t_tot-5)*1e3, y_tot(:,2), LineWidth=2); hold on
yline(inset_ax, -70, '--k', '$-70$ mV', 'Interpreter', 'latex', 'LineWidth', 2, 'LabelHorizontalAlignment', 'right','LabelVerticalAlignment', 'top', FontSize=15);

%xline(inset_ax,5, LineWidth=1.5,Color='k', LineStyle="--");

grid on
%xlim(inset_ax, [19000 20000]); % in ms (i.e., pulse duration)
%xticks(inset_ax, [19000 20000]); % in ms (i.e., pulse duration)
xlim(inset_ax, [-10 200]); % in ms (i.e., pulse duration)

ylim(inset_ax, [-100 50]); % in ms (i.e., pulse duration)

% grid on
% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
% ylim(inset_ax, [0.1 0.9]);

set(inset_ax, 'FontSize', 20, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
% legend('$V_1$','$V_{2}$','Box','off', Interpreter='latex',Location='northwest', fontsize=18)

%%
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig9d.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%% Fractional pore area
hold on
plot(t_tot, A_p1_full/A1,t_tot,A_p2_full/A1,LineWidth=2); 
%yline(0.0126, '--r', 'LineWidth', 2);  % vertical black line at t = 5
yline(0.0126, 'r-.', 'FPA$_{lim}$ = 0.0126', 'LineWidth', 2, ...
      'FontSize', 14, 'FontName', 'Times', Interpreter='latex');

% plot(t_tot_SAP, Vstims_SAP, LineWidth=1.5, LineStyle="--")
hold off
ax = gca;
ax.YAxis(1).Exponent = -3;    % force scientific notation with 1e-3
ylim([-1e-3 14e-3])

xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('Fractional Pore Area', 'FontSize', 18, 'FontName','Times', Interpreter='latex')
%title('Membrane Potential at DP side vs time',Interpreter='latex',FontSize=12);
legend('$\mathrm{FPA}_1$','$\mathrm{FPA}_{2}$','Box','off', Interpreter='latex',Location='southeast', Fontsize = 19)

% grid on
% set(gca, 'FontSize', 12); % Set axes font size
% % Adjust figure properties for high-quality output
% set(gcf, 'PaperUnits', 'inches');       % Set units to inches
% set(gcf, 'PaperPosition', [0 0 6 4]);   % Set the figure size [left, bottom, width, height]
set(gca, 'XScale', 'log');
% ylim([-300 1700])
xlim([2e0 3e4])
%yline(-70, '--k', 'RMP=$-70$ mV', 'Interpreter', 'latex', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'center','LabelVerticalAlignment', 'bottom', FontSize=17);


set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

%% --- MUST BE AFTER set(gca,'XScale','log') ---
drawnow

ax = gca;
axpos = ax.Position;        % normalized position of axes
xlim_ = ax.XLim;

x_data = 5;                % time (ms) where arrow is needed

% Log-aware normalization
x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

% Arrow (pointing UP)
y_head = axpos(2);          % x-axis
y_tail = y_head - 0.08;     % below axis


annotation('arrow', ...
    [x_norm x_norm], ...
    [y_tail y_head], ...
    'Color','r', ...
    'LineWidth',1.5, ...
    'HeadLength',10, ...
    'HeadWidth',10);

%% Inset for pulse duration 
inset_ax = axes('Position',[0.50 0.50 0.35 0.35]); % Adjust position/size
hold(inset_ax, 'on');

plot(inset_ax, (t_tot-5)*1e3, A_p1_full/A1,(t_tot-5)*1e3,A_p2_full/A1,LineWidth=2);


xlim(inset_ax, [-2 100]); % in ms (i.e., pulse duration)
ylim(inset_ax, [-2e-7 5.5e-6]); % in ms (i.e., pulse duration)

grid on
% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
% ylim(inset_ax, [0.1 0.9]);

set(inset_ax, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
%%
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig9b.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%% Membrane Tension 
%% Membrane tension at HP side
sig_0= 1e-3; %Tension of the bilayer without pores
sig_1= 2e-2; %Tension of hydrocarbon-water interface

sig_eff2=2*sig_1-(2*sig_1-sig_0)./(1-A_p2_full/A2).^2;
%% Membrane Tension at DP side
sig_0= 1e-3; %Tension of the bilayer without pores
sig_1= 2e-2; %Tension of hydrocarbon-water interface

sig_eff1=2*sig_1-(2*sig_1-sig_0)./(1-A_p1_full/A1).^2;
%%
plot(t_tot, sig_eff1,t_tot,sig_eff2,LineWidth=2); hold on
%yline(0.0126, '--r', 'LineWidth', 2);  % vertical black line at t = 5

% plot(t_tot_SAP, Vstims_SAP, LineWidth=1.5, LineStyle="--")
hold off
ax = gca;
ax.YAxis(1).Exponent = -3;    % force scientific notation with 1e-3
ylim([-1e-4 1.1e-3])

xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('$\sigma_{eff}$ (J/m$^{2}$)', Interpreter='latex',FontSize=14);
%title('Membrane Potential at DP side vs time',Interpreter='latex',FontSize=12);
legend('$\sigma_{eff_1}$','$\sigma_{eff_2}$','Box','off', Interpreter='latex',Location='northwest', Fontsize=20)

% grid on
% set(gca, 'FontSize', 12); % Set axes font size
% % Adjust figure properties for high-quality output
% set(gcf, 'PaperUnits', 'inches');       % Set units to inches
% set(gcf, 'PaperPosition', [0 0 6 4]);   % Set the figure size [left, bottom, width, height]
set(gca, 'XScale', 'log');
% ylim([-300 1700])
xlim([2e0 3e4])
%yline(-70, '--k', 'RMP=$-70$ mV', 'Interpreter', 'latex', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'center','LabelVerticalAlignment', 'bottom', FontSize=17);


set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

%% --- MUST BE AFTER set(gca,'XScale','log') ---
drawnow

ax = gca;
axpos = ax.Position;        % normalized position of axes
xlim_ = ax.XLim;

x_data = 5;                % time (ms) where arrow is needed

% Log-aware normalization
x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

% Arrow (pointing UP)
y_head = axpos(2);          % x-axis
y_tail = y_head - 0.08;     % below axis

annotation('arrow', ...
    [x_norm x_norm], ...
    [y_tail y_head], ...
    'Color','r', ...
    'LineWidth',1.6, ...
    'HeadLength',10, ...
    'HeadWidth',10);



%% Inset for pulse duration 
inset_ax = axes('Position',[0.50 0.50 0.35 0.35]); % Adjust position/size
hold(inset_ax, 'on');

plot(inset_ax, (t_tot-5)*1e3, sig_eff1,(t_tot-5)*1e3,sig_eff2,LineWidth=2);
%xline(inset_ax,5, LineWidth=1.5,Color='k', LineStyle="--");

ax = gca;
ax.YAxis(1).Exponent = -3;    % force scientific notation with 1e-3
xlim(inset_ax, [-1 100]); % in ms (i.e., pulse duration)
ylim(inset_ax, [9.9955e-4 10.0003e-4]); % in ms (i.e., pulse duration)

grid on
% Automatically scale y-limits based on data in that range
% Or hardcode if needed:
% ylim(inset_ax, [0.1 0.9]);

set(inset_ax, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');
%%
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig9c.pdf');


% Save as PDF
finish_figure(h, save_path);

close all