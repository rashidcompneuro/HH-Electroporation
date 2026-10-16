addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
%% Plotting IRE figures for 2.9 microseconds for RC1e-5 ms
%% Load the data
load([project_root '/data/raw/Cell_Death/2.9microseconds_1e5ms.mat'])
radius_DP_evolution;  % rebuild pore-radius traces (t<k>pore, r<k>pore)


%% Pore statistics for 2.9 mus for RC=1e-5 ms using HP-IRE for Vstim = 1890 mV


%% Pore radii

figure(1); clf
hold on

% --- Store data in cell arrays (clean approach) ---
t = {t5pore,t8pore,t11pore};

r = {r5pore,r8pore,r11pore};

% --- Colorblind-friendly palette ---
colors = [
    0.0000, 0.4470, 0.7410;
    0.8500, 0.3250, 0.0980;
    0.4940, 0.1840, 0.5560;  
];

% --- Line styles ---
styles = {'-','-','-'};

% --- Plot loop ---
for i = 1:3
    plot(t{i}, r{i}, ...
        'LineWidth', 2, ...
        'Color', colors(i,:), ...
        'LineStyle', styles{i});
end

% --- Legend ---
legend({'4$^{th}$','7$^{th}$','10$^{th}$'}, ...
       'Location','best','NumColumns',1, ...
       'Interpreter','latex','Box','off', ...
       'FontSize',18,'FontWeight','bold')

% --- Labels ---
xlabel('time (ms)', 'Interpreter','latex','FontSize',10);
ylabel('Pore radius (m)', 'Interpreter','latex','FontSize',14);

% --- Axes settings ---
xlim([3e0 3e4])
%ylim([-0.1e-6 1.7e-6])

set(gca, 'XScale', 'log');
ax = gca;
ax.YAxis.Exponent = -9;

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
for i = 1:3
    plot(ax2, (t{i}-5)*1e3, r{i}, ...
        'LineWidth', 2, ...
        'Color', colors(i,:), ...
        'LineStyle', styles{i});
end

% --- Zoom limits ---
xlim(ax2,[0 20]);
%xticks([0 25 50])
ylim(ax2,[5e-10 8e-9]);

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

%%%% % --- Inset A: Pulse duration ---

% --- Inset B: very fine zoom ---
ax2 = axes('Position',[0.25 0.25 0.4 0.4]);
box on; hold(ax2,'on');

% --- Plot using SAME colors + styles ---
for i = 1:3
    plot(ax2, (t{i}-5)*1e3, r{i}, ...
        'LineWidth', 2, ...
        'Color', colors(i,:), ...
        'LineStyle', styles{i});
end

% --- Zoom limits ---
xlim(ax2,[0 20]);
%xticks([0 25 50])
ylim(ax2,[5e-10 8e-9]);

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

%% --- Inset C: dedicated close-up of the 10th pore (r11pore, 0.82 nm) ---
% This curve sits near the bottom of ax2's shared y-range and its
% resealing/absorption behavior (radius collapsing back down toward the
% membrane's resting pore radius r_m) is hard to see at that shared
% scale, so it gets its own small axes with its own limits.
ax3 = axes('Position',[0.68 0.60 0.2 0.2]);
box on; hold(ax3,'on');

t3 = (t{3}-5)*1e3;   % same time-shift/scaling convention as ax2, in microseconds
r3 = r{3};

plot(ax3, t3, r3, ...
'LineWidth', 2, ...
'Color', colors(3,:), ...
'LineStyle', styles{3});


ylim(ax3, [7.99e-10, 8.1e-10]);
xlim(ax3, [2.89,2.92]);

% --- Axis styling (kept consistent with ax2) ---
set(ax3,'FontSize',16,'FontName','Times');
set(ax3,'LineWidth',1);
set(ax3,'TickLength',[0.02 0.02]);

%% Saving the fig as PDF file
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S21_Fig.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
close all