addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% ========================================================================
%  plot_gating_variables_100ns.m
%
%  Plots the excitation/gating variables m1, n1, h1 (DP side) and
%  m2, n2, h2 (HP side) for the 100 ns pulse case.
%
%  For EACH of the 6 variables this produces TWO figures:
%    (A) "recovery" timescale : full window, t = 4-18 ms
%    (B) "pulse"    timescale : t = 0 at pulse onset, x-axis in ns
%  Neither figure carries a legend (per request). Instead, a single
%  standalone legend-only figure is generated at the very end and saved
%  separately, so it can be dropped into the manuscript/SI wherever
%  needed.
%
%  Styling (fonts, figure/axes position, tick length, line width, arrow
%  annotation on plot A, dashed pulse markers on plot B) mirrors the
%  n2 example already in the original script -- just without insets and
%  without legends, per your last message.
%
%  NOTE ON ASSUMPTIONS (confirmed with you before writing this):
%    - No inset axes on any of the 12 per-variable figures (simplified
%      vs. the n2 example, which had insets).
%    - The legend figure is a blank/dummy figure: 4 invisible lines
%      (one per trace color) plus the legend box, no real data/axes box.
%    - Files are saved into the SAME folder used for n2 in your script:
%      ".../figures/Supplementary Information/gating_variables_100ns/"
%      Naming: "<var>_ms.pdf" for the recovery-timescale figure and
%      "<var>_pulse_ns.pdf" for the pulse-timescale figure.
%
%  gating variables are physically bounded in [0,1], so plot (A) uses
%  ylim([0 1]) by default (same as your n2 example). Plot (B) is left
%  auto-scaled because the pulse-scale excursion size differs a lot
%  across m/n/h -- adjust VARS(k).ylimB below per-variable if you want
%  a fixed/zoomed range like you did for n2 (ylim([-0.05 0.4])).
%% ========================================================================
clear all;
clc;

%% ------------------------- Load the data -------------------------------
load([project_root '/data/raw/100ns_1e5/HHK_100ns_1e5_SAP_RS_DB.mat'])

gNa_max = 120;      % mS/cm^2
gK_max  = 36;

t_pulse = 5;         % ms, pulse onset time
tp      = 1e-4;      % ms, pulse duration (=100 ns)
tau     = 1e-5;      % ms, characteristic RC time

%% ------------------------- Output location ------------------------------
save_dir = fig_path('SI/S12_S13_Fig_gating/');
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

legend_labels = {'SAP (no EP)','SAP (EP)','RS','DB'};

%% ------------------- Variable definitions (edit here) -------------------
% idx    : column of y(:, idx) for this gating variable
% name   : used for the saved filename
% ylabel : LaTeX y-axis label
% ylimA  : y-limits for the recovery-timescale (ms) figure, [] = auto
% ylimB  : y-limits for the pulse-timescale (ns) figure,     [] = auto
VARS = struct( ...
    'idx',    {3,            4,            5,            6,            7,            8},        ...
    'name',   {'m1',         'n1',         'h1',         'm2',         'n2',         'h2'},     ...
    'ylabel', {'$m_{1}$',    '$n_{1}$',    '$h_{1}$',    '$m_{2}$',    '$n_{2}$',    '$h_{2}$'},...
    'ylimA',  {[0 1],        [0 1],        [0 1],        [0 1],        [0 1],        [0 1]},    ...
    'ylimB',  {[],           [],           [],           [],           [],           []} ...
);

cmap = lines(num_Vstim);   % consistent trace colors across all figures

%% ============================ Main loop ================================
for k = 1:numel(VARS)

    vname  = VARS(k).name;
    vidx   = VARS(k).idx;
    vylbl  = VARS(k).ylabel;

    %% ---------- Figure A: recovery timescale, t = 4-18 ms ---------------
    figure; clf; hold on
    for v = 1:num_Vstim
        t  = all_t_tot{v};
        y  = all_y_tot{v};
        yy = y(:, vidx);
        plot(t, yy, '-', 'LineWidth', 2, 'Color', cmap(v,:));
    end

    xlabel('time (ms)', 'Interpreter', 'latex', 'FontSize', 18);
    ylabel(vylbl,        'Interpreter', 'latex', 'FontSize', 18);

    % Styling (matches the given code)
    set(gcf, 'PaperPosition', [0 0 6 4]);
    set(gcf, 'Position', [15 15 550 420])
    set(gca, 'Position', [0.17 0.17 0.80 0.77])
    set(gca, 'FontSize', 25)
    set(gca, 'FontName', 'Times')
    set(gca, 'LineWidth', 1)
    set(gca, 'TickLength', [0.02 0.02])
    xlim([4 18])
    xticks([4 8 12 16])
    if ~isempty(VARS(k).ylimA)
        ylim(VARS(k).ylimA)
    end
    grid on

    % Red arrow marking pulse onset (t = 5 ms), drawn below the axis
    drawnow
    ax     = gca;
    axpos  = ax.Position;
    x_lim  = xlim;
    xn     = axpos(1) + (t_pulse - x_lim(1)) / (x_lim(2) - x_lim(1)) * axpos(3);
    yn     = axpos(2);
    yn_tail = yn - 0.07;
    annotation('arrow', [xn xn], [yn_tail yn], ...
        'Color', 'r', 'LineWidth', 1.6, 'HeadLength', 10, 'HeadWidth', 10);

    % Save as PDF
    h = gcf;
    set(h, 'Units', 'Inches');
    pos = get(h, 'Position');
    set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);
    finish_figure(h, fullfile(save_dir, [vname '_ms.pdf']));
    close(h)

    %% ---------- Figure B: pulse timescale, t = 0 at onset (ns) ----------
    figure; clf; hold on
    for v = 1:num_Vstim
        t       = all_t_tot{v};
        y       = all_y_tot{v};
        yy      = y(:, vidx);
        t_local = (t - t_pulse) * 1e6;     % ms -> ns, reset to pulse onset
        plot(t_local, yy, '-', 'LineWidth', 2, 'Color', cmap(v,:));
    end

    xline(0,   '--k', 'LineWidth', 1.5);   % pulse start
    xline(100, '--k', 'LineWidth', 1.5);   % pulse end (100 ns)

    xlabel('time (ns)', 'Interpreter', 'latex', 'FontSize', 18);
    % No ylabel on the B (pulse-timescale) panels: in your 6x2 Overleaf
    % grid the row identity is already given by the A panel's ylabel,
    % and dropping it avoids the clipping you were seeing when these
    % PDFs get squeezed into a narrower column width.

    % Styling (matches the given code)
    set(gcf, 'PaperPosition', [0 0 6 4]);
    set(gcf, 'Position', [15 15 550 420])
    set(gca, 'Position', [0.17 0.17 0.80 0.77])
    set(gca, 'FontSize', 25)
    set(gca, 'FontName', 'Times')
    set(gca, 'LineWidth', 1)
    set(gca, 'TickLength', [0.02 0.02])
    xlim([-10 120])
    if ~isempty(VARS(k).ylimB)
        ylim(VARS(k).ylimB)
    end
    grid on

    % Save as PDF
    h = gcf;
    set(h, 'Units', 'Inches');
    pos = get(h, 'Position');
    set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);
    finish_figure(h, fullfile(save_dir, [vname '_pulse_ns.pdf']));
    close(h)

end

%% ===================== Standalone legend figure =========================
% Blank figure containing only the 4 line entries + legend box, no data.
figure; clf; hold on
hLines = gobjects(num_Vstim,1);
for v = 1:num_Vstim
    hLines(v) = plot(nan, nan, '-', 'LineWidth', 2, 'Color', cmap(v,:));
end
axis off

if numel(legend_labels) ~= num_Vstim
    warning(['legend_labels has %d entries but num_Vstim = %d; ' ...
             'edit legend_labels at the top of the script to match.'], ...
             numel(legend_labels), num_Vstim);
end

lgd = legend(hLines, legend_labels, 'Interpreter', 'latex', 'FontSize', 16, ...
    'Box', 'off', 'Location', 'best', 'NumColumns', 2);

set(gcf, 'PaperPosition', [0 0 6 1.5]);
set(gcf, 'Position', [15 15 550 160])

h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);
finish_figure(h, fullfile(save_dir, 'legend_gating_variables.pdf'));
close(h)
