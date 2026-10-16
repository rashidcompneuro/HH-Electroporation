addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
%% Plots for Cell death via EP for (main figure)
clear all;
clc
%% Load the data

load([project_root '/data/raw/Cell_Death/HHK_supraEP_10ns.mat'])
radius_DP_evolution;  % rebuild pore-radius traces (t<k>pore, r<k>pore)

%% Pore statistics for 10 ns for RC=1e-5 ms using HP-IRE for Vstim = 4364
tp = 1e-5;        % pulse duration (10 ns)
tau = 1e-5;       % time constant (10ns)

% Example pore counts (21 values, not cumulative)
pore_formed = Pore1_formed';   % vector length = 21

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
save_path = fig_path('SI/S20_Fig_a.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%% Pore Growth HP side
figure(2); clf
hold on

%plot(t5pore,r5pore,'LineWidth',2);
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

legend({'5$^{th}$','6$^{th}$','7$^{th}$','8$^{th}$','9$^{th}$',...
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
%plot(ax1,(t5pore-5)*1e6,  r5pore,'LineWidth',1.5);
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

%plot(ax2,(t5pore-5)*1e6,r5pore,'LineWidth',1.5);
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
save_path = fig_path('SI/S20_Fig_b.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
