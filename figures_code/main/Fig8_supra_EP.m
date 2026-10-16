addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
%% Plots for Cell death via EP for (main figure)
clear all;
clc
%% Load the data

load([project_root '/data/raw/Cell_Death/HHK_supraEP_10ns.mat'])
radius_HP_evolution;  % rebuild pore-radius traces (t<k>pore, r<k>pore)

%% Pore statistics for 10 ns for RC=1e-5 ms using HP-IRE for Vstim = 4364
tp = 1e-5;        % pulse duration (10 ns)
tau = 1e-5;       % time constant (10ns)

% Example pore counts (21 values, not cumulative)
pore_formed = Pore2_formed';   % vector length = 21

% 1. Use last 20 entries (skip first)
pore_counts_bins = pore_formed(2:end);

% 2. Construct time edges
%edges_tp  = linspace(0, tp, 11);  
edges_tp  = linspace(0, 10, 11);  

%edges_tau = linspace(tp, tp+tau, 11);    
edges_tau = linspace(10, 20, 11);      

time_edges = [edges_tp edges_tau(2:end)];  

% 3. Bin centers and widths
bin_centers = 0.5 * (time_edges(1:end-1) + time_edges(2:end));
bin_widths  = diff(time_edges);

% 4. Plot variable-width bars with two colors + numbers
figure;
for i = 1:20
    if i <= 10
        c = [0.85 0.2 0.2];  % red for pulse
    else
        c = [0.2 0.4 0.8];   % blue for relaxation
    end
    % Draw rectangle
    % rectangle('Position',[time_edges(i)*1e3, 1, bin_widths(i)*1e3, pore_counts_bins(i)], ...
    %           'FaceColor',c, 'EdgeColor','k'); hold on;
    rectangle('Position',[time_edges(i), 1, bin_widths(i), pore_counts_bins(i)], ...
              'FaceColor',c, 'EdgeColor','k'); hold on;
    % Add bar number (slightly above the bar top)
    % text(bin_centers(i)*1e3, pore_counts_bins(i)*1.2, num2str(i), ...
    %      'HorizontalAlignment','center', 'FontSize', 21, 'FontWeight','bold',"Interpreter","latex");

    text(bin_centers(i), pore_counts_bins(i)*1.2, num2str(i), ...
         'HorizontalAlignment','center', 'FontSize', 21, 'FontWeight','bold',"Interpreter","latex");
end
% 5. Add legend (using dummy patches)
h1 = patch(NaN, NaN, [0.85 0.2 0.2], 'EdgeColor','k'); % red
h2 = patch(NaN, NaN, [0.2 0.4 0.8], 'EdgeColor','k');  % blue
legend([h1 h2], {'Pulse phase','Relaxation phase'}, 'Location','best', 'Box', 'off',FontSize=15)
ylim([1e0 1e7])
set(gca,'YScale','log')
xlabel('time (ns)','Interpreter','latex')
ylabel('Number of pores formed','Interpreter','latex')
%title('Pore formation across pulse and relaxation phase')
ax = gca;
ax.TickLabelInterpreter = 'latex';
set(gca,'FontSize',21,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');

set(gcf, 'PaperUnits', 'inches');      
set(gcf, 'PaperPosition', [0 0 6 4]);   

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])


%% Saving the fig as PDF file
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig8a.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%% Pore Growth HP side
figure(2); clf
hold on

plot(t5pore,r5pore,'LineWidth',2);
plot(t6pore, r6pore, 'LineWidth',2);
plot(t7pore, r7pore, 'LineWidth',2);
plot(t8pore, r8pore, 'LineWidth',2);
plot(t9pore,r9pore,'LineWidth',2);
plot(t10pore,r10pore,'LineWidth',2);
plot(t11pore,r11pore,'LineWidth',2);
plot(t12pore,r12pore,'LineWidth',2);


% legend('4','5','6','7','8','9','10','11', ...
%        'Location','best','NumColumns',2, ...
%        'Interpreter','latex','Box','off', ...
%        'FontSize',18,'FontWeight','bold')

legend({'4$^{th}$','5$^{th}$','6$^{th}$','7$^{th}$','8$^{th}$','9$^{th}$',...
        '10$^{th}$','11$^{th}$'}, ...
       'Location','best','NumColumns',4, ...
       'Interpreter','latex','Box','off', ...
       'FontSize',18,'FontWeight','bold')

xlim([3e0 3e4]);
ylim([-0.5e-10 9e-10])
set(gca,'XScale','log')
xlabel('time (ms)',Interpreter='latex',FontSize=10);
ylabel('Pore radius (m)', Interpreter='latex',FontSize=14);
%title('Pore radius evolution (DP side)')
%xticks()

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

% %% --- Inset A: pore launching window ---
% ax1 = axes('Position',[0.55 0.55 0.25 0.25]); % inset position
% box on; hold on;
% plot(ax1,t5pore,r5pore,'LineWidth',1.5);
% plot(ax1,t6pore,r6pore,'LineWidth',1.5);
% plot(ax1,t7pore,r7pore,'LineWidth',1.5);
% plot(ax1,t8pore,r8pore,'LineWidth',1.5);
% plot(ax1,t9pore,r9pore,'LineWidth',1.5);
% plot(ax1,t10pore,r10pore,'LineWidth',1.5);
% plot(ax1,t11pore,r11pore,'LineWidth',1.5);
% plot(ax1,t12pore,r12pore,'LineWidth',1.5);
% 
% xlim(ax1,[5 5+tp+time_constant])
% % Markers: 10 in tp, 10 in tau
% tp_edges  = linspace(5, 5+tp, 11);
% tau_edges = linspace(5+tp, 5+tp+time_constant, 11);
% all_edges = [tp_edges tau_edges(2:end)];
% for i = 1:length(all_edges)
%     xline(all_edges(i),'k--','LineWidth',0.5);
% end
% 
% % xticks(ax1,[5 5+tp 5+tp+time_constant])
% % xticklabels(ax1,{'5','5+tp','5+tp+\tau'})
% set(ax1, 'FontSize', 22, ...
%     'FontName', 'Times', ...
%     'TickLabelInterpreter', 'latex', ...
%     'Box', 'on', ...
%     'LineWidth', 1.5, ...
%     'XMinorTick', 'on', 'YMinorTick', 'on');
%% --- Inset A: Pore launching phase (20 ns) ---
ax1 = axes('Position',[0.55 0.55 0.25 0.25]);
box on; hold on;

% Shift time so inset starts at 0 ns
plot(ax1,(t5pore-5)*1e6,  r5pore,'LineWidth',1.5);
plot(ax1,(t6pore-5)*1e6,  r6pore,'LineWidth',1.5);
plot(ax1,(t7pore-5)*1e6,  r7pore,'LineWidth',1.5);
plot(ax1,(t8pore-5)*1e6,  r8pore,'LineWidth',1.5);
plot(ax1,(t9pore-5)*1e6,  r9pore,'LineWidth',1.5);
plot(ax1,(t10pore-5)*1e6, r10pore,'LineWidth',1.5);
plot(ax1,(t11pore-5)*1e6, r11pore,'LineWidth',1.5);
plot(ax1,(t12pore-5)*1e6, r12pore,'LineWidth',1.5);

% 20 ns window
xlim(ax1,[0 20]);
ylim(ax1,[0.795e-9 0.87e-9]);      % Start y-axis at zero

% Vertical lines every 2 ns (optional)
edges = 0:2:20;
for i = 1:length(edges)
    xline(ax1,edges(i),'k--','LineWidth',0.5);
end

% Major ticks
xticks(ax1,[0 10 20]);

xlabel(ax1,'time (ns)','Interpreter','latex','FontSize',18);
%ylabel(ax1,'Pore radius (nm)','Interpreter','latex','FontSize',18);

set(ax1,...
    'FontSize',22,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');
%% --- Inset B: very fine zoom ---
% ax2 = axes('Position',[0.25 0.25 0.25 0.25]); % inset position
% box on; hold on;
% plot(ax2,t5pore,r5pore,'LineWidth',1.5);
% plot(ax2,t6pore,r6pore,'LineWidth',1.5);
% plot(ax2,t7pore,r7pore,'LineWidth',1.5);
% plot(ax2,t8pore,r8pore,'LineWidth',1.5);
% plot(ax2,t9pore,r9pore,'LineWidth',1.5);
% plot(ax2,t10pore,r10pore,'LineWidth',1.5);
% plot(ax2,t11pore,r11pore,'LineWidth',1.5);
% plot(ax2,t12pore,r12pore,'LineWidth',1.5);
% 
% xlim(ax2,[5 5.00015])
% ylim(ax2,[7.8e-10 9e-10])
% set(ax2, 'FontSize', 22, ...
%     'FontName', 'Times', ...
%     'TickLabelInterpreter', 'latex', ...
%     'Box', 'on', ...
%     'LineWidth', 1.5, ...
%     'XMinorTick', 'on', 'YMinorTick', 'on');
%% --- Inset B: 150 ns window ---
ax2 = axes('Position',[0.25 0.25 0.25 0.25]);
box on; hold on;

plot(ax2,(t5pore-5)*1e6,r5pore,'LineWidth',1.5);
plot(ax2,(t6pore-5)*1e6,r6pore,'LineWidth',1.5);
plot(ax2,(t7pore-5)*1e6,r7pore,'LineWidth',1.5);
plot(ax2,(t8pore-5)*1e6,r8pore,'LineWidth',1.5);
plot(ax2,(t9pore-5)*1e6,r9pore,'LineWidth',1.5);
plot(ax2,(t10pore-5)*1e6,r10pore,'LineWidth',1.5);
plot(ax2,(t11pore-5)*1e6,r11pore,'LineWidth',1.5);
plot(ax2,(t12pore-5)*1e6,r12pore,'LineWidth',1.5);

xlim(ax2,[0 150])          % 0–150 ns
ylim(ax2,[7.95e-10 8.7e-10])

xticks(ax2,[0  150])
%xlabel(ax2,'time (ns)','Interpreter','latex')

set(ax2,...
    'FontSize',22,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');
%% Saving the fig as PDF file
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('main/Fig8b.pdf');


% Save as PDF
finish_figure(h, save_path);

close all

%% Membrane tension (same parameters and formula as Fig9_IRE.m)
sig_0 = 1e-3; %Tension of the bilayer without pores
sig_1 = 2e-2; %Tension of hydrocarbon-water interface
sig_eff1 = 2*sig_1-(2*sig_1-sig_0)./(1-A_p1_full/A1).^2;
sig_eff2 = 2*sig_1-(2*sig_1-sig_0)./(1-A_p2_full/A2).^2;
%% FPA and sigma_eff
figure(3); clf; hold on

% --- Left axis: FPA ---
yyaxis left
plot(t_tot, A_p2_full/A2, 'LineWidth', 2); hold on
yline(0.0126, 'b-.', 'FPA = 0.0126', 'LineWidth', 2, ...
      'FontSize', 14, 'FontName', 'Times');
ax = gca;
ax.YAxis(1).Exponent = -3;    % force scientific notation with 1e-3
ylim([-1e-3 14e-3])
ylabel('Fractional Pore Area (FPA)', 'FontSize', 18, 'FontName','Times')

% --- Right axis: sigma_eff ---
yyaxis right
plot(t_tot, sig_eff2, 'LineWidth', 2)
yl = yline(0, 'r-.', '$\sigma_{eff}=0$', ...
           'LineWidth', 2, ...
           'Interpreter','latex', ...
           'FontSize', 14, 'FontName','Times');

% Put label at right end, below the line
yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment   = 'bottom';   % below the line
ylabel('$\sigma_{eff}$ ($\mathrm{Jm^{-2}}$)', ...
       'Interpreter','latex','FontSize',18,'FontName','Times')

% --- X axis ---
xlim([5-0.1*tp 5+tp+5*time_constant])
%xticks([5, 5+tp, 5+tp+time_constant])
%xticklabels({'5','5+tp','5+tp+\tau'})
xlabel('time (ms)', 'FontSize',18,'FontName','Times')

% --- Formatting ---
% set(gca,'FontSize',16,'FontName','Times','LineWidth',1.2,'TickLength',[0.02 0.02])
% set(gcf,'Position',[100 100 650 450])  % figure size
% 
% % --- Vertical markers ---
% %xline(5, 'k--', 'LineWidth',1.2);
% % xline(5+tp, 'k--', 'LineWidth',1.2);
% % xline(5+tp+time_constant, 'k--', 'LineWidth',1.2);
% % 
% %title('FPA and Effective Tension during Pulse and Relaxation', ...
%       %'FontSize',18,'FontName','Times')
% set(gca,'FontSize',21)

%% FPA only
figure(3); clf; hold on

plot(t_tot, A_p1_full/A1,t_tot, A_p2_full/A2,'LineWidth', 2); hold on
yline(0.0126, 'r-.', 'FPA$_{lim}$ = 0.0126', 'LineWidth', 2, ...
      'FontSize', 14, 'FontName', 'Times', Interpreter='latex');
ax = gca;
ax.YAxis(1).Exponent = -3;    % force scientific notation with 1e-3
ylim([-1e-3 14e-3])
legend('FPA$_1$','FPA$_{2}$','Box','off', ...
    Interpreter='latex',Location='northwest',fontsize=20)
% % --- Right axis: sigma_eff ---
% yyaxis right
% plot(t_tot, sig_eff2, 'LineWidth', 2)
% yl = yline(0, 'r-.', '$\sigma_{eff}=0$', ...
%            'LineWidth', 2, ...
%            'Interpreter','latex', ...
%            'FontSize', 14, 'FontName','Times');

% Put label at right end, below the line
% yl.LabelHorizontalAlignment = 'right';
% yl.LabelVerticalAlignment   = 'bottom';   % below the line
% ylabel('$\sigma_{eff}$ ($\mathrm{Jm^{-2}}$)', ...
%        'Interpreter','latex','FontSize',18,'FontName','Times')

% --- X axis ---
%xlim([5-0.1*tp 5+tp+5*time_constant])
%xticks([5, 5+tp, 5+tp+time_constant])
%xticklabels({'5','5+tp','5+tp+\tau'})
xlabel('time (ms)', 'FontSize',18,Interpreter='latex')
ylabel('FPA', 'FontSize',18,Interpreter='latex')

set(gca, 'XScale', 'log');

% --- Formatting ---
% set(gca,'FontSize',16,'FontName','Times','LineWidth',1.2,'TickLength',[0.02 0.02])
% set(gcf,'Position',[100 100 650 450])  % figure size
% 
% % --- Vertical markers ---
% %xline(5, 'k--', 'LineWidth',1.2);
% % xline(5+tp, 'k--', 'LineWidth',1.2);
% % xline(5+tp+time_constant, 'k--', 'LineWidth',1.2);
% % 
% %title('FPA and Effective Tension during Pulse and Relaxation', ...
%       %'FontSize',18,'FontName','Times')
% set(gca,'FontSize',21)
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

xticks([1 10 100 1000 1e4])
xlim([0.5 20000])


%% Get axis position in normalized figure units
drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

annotation('arrow', ...
    [x_norm x_norm], ...
    [axpos(2)-0.08 axpos(2)], ...
    'Color','r', ...
    'LineWidth',1.6, ...
    'HeadLength',10, ...
    'HeadWidth',10);
%%
% ===================== INSET 1: PULSE ( 20 ns SCALE) =====================
inset_ax1 = axes('Position',[0.60 0.65 0.25 0.25]);
hold(inset_ax1, 'on');

% Convert to ns (centered at 5 ms)
t_ns = (t_tot - 5)*1e6;

plot(inset_ax1,t_ns, A_p1_full/A1,t_ns, A_p2_full/A2 , LineWidth=2);
yline(0.0126, 'r-.', 'LineWidth', 2, ...
      'FontSize', 14, 'FontName', 'Times');
%xlabel(inset_ax1, 'ns')
xlim(inset_ax1, [0 20]);
ylim(inset_ax1, [-1e-3 14e-3]);

set(inset_ax1, 'FontSize', 22, ...
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
save_path = fig_path('main/Fig8c.pdf');


% Save as PDF
finish_figure(h, save_path);

close all

%% SigmaEff only
figure(4); clf; hold on

plot(t_tot, sig_eff1,t_tot, sig_eff2,'LineWidth', 2); hold on
yline(0, 'r-.', '$\sigma_{eff}$ = 0', 'LineWidth', 2, ...
      'FontSize', 14, 'FontName', 'Times', Interpreter='latex');
ax = gca;
ax.YAxis(1).Exponent = -3;    % force scientific notation with 1e-3
ylim([-0.05e-3 1.1e-3])
legend('$\sigma_{eff_1}$','$\sigma_{eff_2}$','Box','off', ...
    Interpreter='latex',Location='northwest',fontsize=20)
% % --- Right axis: sigma_eff ---
% yyaxis right
% plot(t_tot, sig_eff2, 'LineWidth', 2)
% yl = yline(0, 'r-.', '$\sigma_{eff}=0$', ...
%            'LineWidth', 2, ...
%            'Interpreter','latex', ...
%            'FontSize', 14, 'FontName','Times');

% Put label at right end, below the line
% yl.LabelHorizontalAlignment = 'right';
% yl.LabelVerticalAlignment   = 'bottom';   % below the line
% ylabel('$\sigma_{eff}$ ($\mathrm{Jm^{-2}}$)', ...
%        'Interpreter','latex','FontSize',18,'FontName','Times')

% --- X axis ---
%xlim([5-0.1*tp 5+tp+5*time_constant])
%xticks([5, 5+tp, 5+tp+time_constant])
%xticklabels({'5','5+tp','5+tp+\tau'})
xlabel('time (ms)', 'FontSize',18,Interpreter='latex')
ylabel('$\sigma_{eff}$ ($\mathrm{J/m^{2}}$)', ...
        'Interpreter','latex','FontSize',18,'FontName','Times')

set(gca, 'XScale', 'log');

% --- Formatting ---
% set(gca,'FontSize',16,'FontName','Times','LineWidth',1.2,'TickLength',[0.02 0.02])
% set(gcf,'Position',[100 100 650 450])  % figure size
% 
% % --- Vertical markers ---
% %xline(5, 'k--', 'LineWidth',1.2);
% % xline(5+tp, 'k--', 'LineWidth',1.2);
% % xline(5+tp+time_constant, 'k--', 'LineWidth',1.2);
% % 
% %title('FPA and Effective Tension during Pulse and Relaxation', ...
%       %'FontSize',18,'FontName','Times')
% set(gca,'FontSize',21)
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

xticks([1 10 100 1000 1e4])
xlim([0.5 20000])


%% Get axis position in normalized figure units
drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

annotation('arrow', ...
    [x_norm x_norm], ...
    [axpos(2)-0.08 axpos(2)], ...
    'Color','r', ...
    'LineWidth',1.6, ...
    'HeadLength',10, ...
    'HeadWidth',10);
%%
% ===================== INSET 1: PULSE ( 20 ns SCALE) =====================
inset_ax1 = axes('Position',[0.60 0.65 0.25 0.25]);
hold(inset_ax1, 'on');

% Convert to ns (centered at 5 ms)
t_ns = (t_tot - 5)*1e6;

plot(inset_ax1,t_ns,sig_eff1,t_ns, sig_eff2 , LineWidth=2);
yline(0, 'r-.', 'LineWidth', 2, ...
      'FontSize', 14, 'FontName', 'Times');
%xlabel(inset_ax1, 'ns')
xlim(inset_ax1, [0 20]);
ylim(inset_ax1, [-0.1e-3 1.1e-3]);

set(inset_ax1, 'FontSize', 22, ...
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
save_path = fig_path('main/Fig8d.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%%
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
xlim([0.5 6e4])
xticks([1e0 1e1 1e2 1e3 1e4])
ylim([-1700 1700])
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
%% ===================== INSET 1: PULSE ( 20 ns SCALE) DP side =====================
inset_ax1 = axes('Position',[0.60 0.65 0.25 0.25]);
hold(inset_ax1, 'on');

% Convert to ns (centered at 5 ms)
t_ns = (t_tot - 5)*1e6;

plot(inset_ax1,t_ns, y_tot(:,1),t_ns, y_tot(:,2),LineWidth=2);

%xlabel(inset_ax1, 'ns')
xlim(inset_ax1, [0 20]);
%ylim(inset_ax1, [1e9 1e16]);
%yticks(inset_ax1,[1e10 1e12 1e14 1e16])
%set(gca, 'YScale', 'log');

set(inset_ax1, 'FontSize', 22, ...
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
save_path = fig_path('main/Fig8f.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%% Small Pore density for 60s run time

figure(4); clf; hold on

h1 = plot(t_tot, y_tot(:,9),'LineWidth', 2); hold on
h2 = plot(t_tot, y_tot(:,10),'LineWidth', 2);

% ax = gca;
% ax.YAxis(1).Exponent = -3;    % force scientific notation with 1e-3
%ylim([-1e-3 14e-3])
legend('$N_1$','$N_{2}$','Box','off', ...
    Interpreter='latex',Location='northwest',fontsize=20)
% % --- Right axis: sigma_eff ---
% yyaxis right
% plot(t_tot, sig_eff2, 'LineWidth', 2)
% yl = yline(0, 'r-.', '$\sigma_{eff}=0$', ...
%            'LineWidth', 2, ...
%            'Interpreter','latex', ...
%            'FontSize', 14, 'FontName','Times');

% Put label at right end, below the line
% yl.LabelHorizontalAlignment = 'right';
% yl.LabelVerticalAlignment   = 'bottom';   % below the line
% ylabel('$\sigma_{eff}$ ($\mathrm{Jm^{-2}}$)', ...
%        'Interpreter','latex','FontSize',18,'FontName','Times')

% --- X axis ---
%xlim([5-0.1*tp 5+tp+5*time_constant])
%xticks([5, 5+tp, 5+tp+time_constant])
%xticklabels({'5','5+tp','5+tp+\tau'})
xlabel('time (ms)', 'FontSize',18,Interpreter='latex')
ylabel('$N$ (m$^{-2})$', 'FontSize',18,Interpreter='latex')

set(gca, 'XScale', 'log');

% --- Formatting ---
% set(gca,'FontSize',16,'FontName','Times','LineWidth',1.2,'TickLength',[0.02 0.02])
% set(gcf,'Position',[100 100 650 450])  % figure size
% 
% % --- Vertical markers ---
% %xline(5, 'k--', 'LineWidth',1.2);
% % xline(5+tp, 'k--', 'LineWidth',1.2);
% % xline(5+tp+time_constant, 'k--', 'LineWidth',1.2);
% % 
% %title('FPA and Effective Tension during Pulse and Relaxation', ...
%       %'FontSize',18,'FontName','Times')
% set(gca,'FontSize',21)
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])

xticks([1 10 100 1000 1e4])
yticks([1e10 1e12 1e14 1e16])
xlim([0.5 60000])
ylim([1e9 1e16])
set(gca, 'YScale', 'log');

%% Get axis position in normalized figure units
drawnow

ax = gca;
axpos = ax.Position;
xlim_ = ax.XLim;

x_data = 5;

x_norm = axpos(1) + ...
    (log10(x_data) - log10(xlim_(1))) / ...
    (log10(xlim_(2)) - log10(xlim_(1))) * axpos(3);

annotation('arrow', ...
    [x_norm x_norm], ...
    [axpos(2)-0.08 axpos(2)], ...
    'Color','r', ...
    'LineWidth',1.6, ...
    'HeadLength',10, ...
    'HeadWidth',10);
%%
% ===================== INSET 1: PULSE ( 20 ns SCALE) DP side =====================
inset_ax1 = axes('Position',[0.60 0.65 0.25 0.25]);
hold(inset_ax1, 'on');

% Convert to ns (centered at 5 ms)
t_ns = (t_tot - 5)*1e6;

plot(inset_ax1,t_ns, y_tot(:,9), LineWidth=2,Color= h1.Color);

%xlabel(inset_ax1, 'ns')
xlim(inset_ax1, [0 20]);
ylim(inset_ax1, [1e9 1e16]);
yticks(inset_ax1,[1e10 1e12 1e14 1e16])
set(gca, 'YScale', 'log');

set(inset_ax1, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

% ===================== INSET 2: PULSE ( 20 ns SCALE) HP side =====================
inset_ax2 = axes('Position',[0.60 0.25 0.25 0.25]);
hold(inset_ax2, 'on');

% Convert to ns (centered at 5 ms)
t_ns = (t_tot - 5)*1e6;

plot(inset_ax2 ,t_ns, y_tot(:,10) , LineWidth=2, Color=h2.Color);

%xlabel(inset_ax1, 'ns')
xlim(inset_ax2, [0 20]);
ylim(inset_ax2, [1e9 1e16]);
yticks(inset_ax2,[1e10 1e12 1e14 1e16])
set(gca, 'YScale', 'log');

set(inset_ax2, 'FontSize', 22, ...
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
save_path = fig_path('main/Fig8e.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
