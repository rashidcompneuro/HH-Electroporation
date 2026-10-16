addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
clear all;
clc
%% loading the data
%
load([project_root '/data/raw/100ns_1e5/HHK_100ns_1e5_RS.mat'])
radius_HP_evolution;  % rebuild pore-radius traces (t<k>pore, r<k>pore)
%% data for SAP with SP Vstim = 2100 mV (Pores: DP -1 , HP - 9)
%% Pore Growth HP side
figure(2); clf
hold on


%plot(t2pore,r2pore,'LineWidth',2);
plot(t3pore,r3pore,'LineWidth',2);
plot(t4pore,r4pore,'LineWidth',2);
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

legend({'2$^{nd}$','3$^{rd}$','4$^{th}$','5$^{th}$','6$^{th}$','7$^{th}$','8$^{th}$','9$^{th}$',...
        '10$^{th}$', '11$^{th}$'},...
       'Location','best','NumColumns',4, ...
       'Interpreter','latex','Box','off', ...
       'FontSize',18,'FontWeight','bold')

xlim([3e0 3e4]);
ylim([-0.5e-10 14e-10])
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
plot(ax1,(t3pore-5)*1e6,  r3pore,'LineWidth',1.5);
plot(ax1,(t4pore-5)*1e6,  r4pore,'LineWidth',1.5);
plot(ax1,(t5pore-5)*1e6,  r5pore,'LineWidth',1.5);
plot(ax1,(t6pore-5)*1e6,  r6pore,'LineWidth',1.5);
plot(ax1,(t7pore-5)*1e6,  r7pore,'LineWidth',1.5);
plot(ax1,(t8pore-5)*1e6,  r8pore,'LineWidth',1.5);
plot(ax1,(t9pore-5)*1e6,  r9pore,'LineWidth',1.5);
plot(ax1,(t10pore-5)*1e6, r10pore,'LineWidth',1.5);
plot(ax1,(t11pore-5)*1e6, r11pore,'LineWidth',1.5);
plot(ax1,(t12pore-5)*1e6, r12pore,'LineWidth',1.5);

% 20 ns window
xlim(ax1,[0 110]);
ylim(ax1,[0.7e-9 1.4e-9]);      % Start y-axis at zero

% Vertical lines every 2 ns (optional)
% edges = 0:20:100;
% for i = 1:length(edges)
%     xline(ax1,edges(i),'k--','LineWidth',0.5);
% end
% 
% edges = 100:2:110;
% for i = 1:length(edges)
%     xline(ax1,edges(i),'k--','LineWidth',0.5);
% end

% Major ticks
xticks(ax1,[0 20 40 60 80 100]);

%xlabel(ax1,'time (ns)','Interpreter','latex','FontSize',18);
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
plot(ax2,(t3pore-5)*1e6, r3pore,'LineWidth',1.5);
plot(ax2,(t4pore-5)*1e6, r4pore,'LineWidth',1.5);
plot(ax2,(t5pore-5)*1e6,r5pore,'LineWidth',1.5);
plot(ax2,(t6pore-5)*1e6,r6pore,'LineWidth',1.5);
plot(ax2,(t7pore-5)*1e6,r7pore,'LineWidth',1.5);
plot(ax2,(t8pore-5)*1e6,r8pore,'LineWidth',1.5);
plot(ax2,(t9pore-5)*1e6,r9pore,'LineWidth',1.5);
plot(ax2,(t10pore-5)*1e6,r10pore,'LineWidth',1.5);
plot(ax2,(t11pore-5)*1e6,r11pore,'LineWidth',1.5);
plot(ax2,(t12pore-5)*1e6,r12pore,'LineWidth',1.5);

xlim(ax2,[0 1000])          % 0–150 ns
ylim(ax2,[7.9e-10 1.4e-9])

%xticks(ax2,[0  150])
%xlabel(ax2,'time (ns)','Interpreter','latex')

set(ax2,...
    'FontSize',22,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');
%%
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S15_Fig_d.pdf');

% Save as PDF
finish_figure(h, save_path);

close all
%%
%% loading the data
clear all;
clc;
%%
load([project_root '/data/raw/100ns_1e5/HHK_100ns_1e5_RS.mat'])
radius_DP_evolution;  % rebuild pore-radius traces (t<k>pore, r<k>pore)
%% data for SAP with SP Vstim = 2100 mV (Pores: DP - 1 , HP - 9)
%% Pore Growth DP side
figure(2); clf
hold on


%plot(t2pore,r2pore,'LineWidth',2); % 1st pore group
%plot(t3pore,r3pore,'LineWidth',2); % 2nd pore group
plot(t4pore,r4pore,'LineWidth',2);  % 3rd group
plot(t5pore,r5pore,'LineWidth',2); % 4th
plot(t6pore, r6pore, 'LineWidth',2); % 5th 
plot(t7pore, r7pore, 'LineWidth',2); % 6th
plot(t8pore, r8pore, 'LineWidth',2); % 7th 
plot(t9pore,r9pore,'LineWidth',2);  % 8th 
plot(t10pore,r10pore,'LineWidth',2); % 9th 
plot(t11pore,r11pore,'LineWidth',2); %10th
%plot(t12pore,r12pore,'LineWidth',2);


% legend('4','5','6','7','8','9','10','11', ...
%        'Location','best','NumColumns',2, ...
%        'Interpreter','latex','Box','off', ...
%        'FontSize',18,'FontWeight','bold')

% legend('7$^{th}$', ...
%        'Location','best','NumColumns',4, ...
%        'Interpreter','latex','Box','off', ...
%        'FontSize',18,'FontWeight','bold')

legend({'3$^{rd}$','4$^{th}$','5$^{th}$','6$^{th}$','7$^{th}$','8$^{th}$','9$^{th}$',...
        '10$^{th}$'},...
       'Location','best','NumColumns',4, ...
       'Interpreter','latex','Box','off', ...
       'FontSize',18,'FontWeight','bold')


xlim([3e0 3e4]);
ylim([-0.5e-10 1.4e-9])
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
%plot(ax1,(t3pore-5)*1e6,  r3pore,'LineWidth',1.5);
plot(ax1,(t4pore-5)*1e6,  r4pore,'LineWidth',1.5);
plot(ax1,(t5pore-5)*1e6,  r5pore,'LineWidth',1.5);
plot(ax1,(t6pore-5)*1e6,  r6pore,'LineWidth',1.5);
plot(ax1,(t7pore-5)*1e6,  r7pore,'LineWidth',1.5);
plot(ax1,(t8pore-5)*1e6,  r8pore,'LineWidth',1.5);
plot(ax1,(t9pore-5)*1e6,  r9pore,'LineWidth',1.5);
plot(ax1,(t10pore-5)*1e6, r10pore,'LineWidth',1.5);
plot(ax1,(t11pore-5)*1e6, r11pore,'LineWidth',1.5);
%plot(ax1,(t12pore-5)*1e6, r12pore,'LineWidth',1.5);

% 20 ns window
xlim(ax1,[0 110]);
ylim(ax1,[0.7e-9 1.4e-9]);      % Start y-axis at zero

% Vertical lines every 2 ns (optional)
% edges = 0:20:100;
% for i = 1:length(edges)
%     xline(ax1,edges(i),'k--','LineWidth',0.5);
% end
% 
% edges = 100:2:110;
% for i = 1:length(edges)
%     xline(ax1,edges(i),'k--','LineWidth',0.5);
% end

% Major ticks
xticks(ax1,[0 20 40 60 80 100]);

%xlabel(ax1,'time (ns)','Interpreter','latex','FontSize',18);
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
%plot(ax2,(t3pore-5)*1e6, r3pore,'LineWidth',1.5);
plot(ax2,(t4pore-5)*1e6, r4pore,'LineWidth',1.5);
plot(ax2,(t5pore-5)*1e6,r5pore,'LineWidth',1.5);
plot(ax2,(t6pore-5)*1e6,r6pore,'LineWidth',1.5);
plot(ax2,(t7pore-5)*1e6,r7pore,'LineWidth',1.5);
plot(ax2,(t8pore-5)*1e6,r8pore,'LineWidth',1.5);
plot(ax2,(t9pore-5)*1e6,r9pore,'LineWidth',1.5);
plot(ax2,(t10pore-5)*1e6,r10pore,'LineWidth',1.5);
plot(ax2,(t11pore-5)*1e6,r11pore,'LineWidth',1.5);
%plot(ax2,(t12pore-5)*1e6,r12pore,'LineWidth',1.5);
ax = gca;
ax.YAxis(1).Exponent = -9;    % force scientific notation with 1e-3
xlim(ax2,[0 1000])          % 0–150 ns
ylim(ax2,[7.9e-10 1.2e-9])

%xticks(ax2,[0  150])
%xlabel(ax2,'time (ns)','Interpreter','latex')

set(ax2,...
    'FontSize',22,...
    'FontName','Times',...
    'TickLabelInterpreter','latex',...
    'Box','on',...
    'LineWidth',1.5,...
    'XMinorTick','on',...
    'YMinorTick','on');
%%
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S15_Fig_c.pdf');

% Save as PDF
finish_figure(h, save_path);

close all
%%
