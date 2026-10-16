function figs = plot_HHK(out, varargin)
% PLOT_HHK  Plot the result of run_HHK, or of HHK_single_pulse.m run directly.
%
%   plot_HHK(out)                    % all plots below, for out = run_HHK(...)
%   plot_HHK(out, 'TMP', 'radius')   % only the plots you name
%
%   Right after running a model script yourself (e.g. HHK_single_pulse in
%   model/RC_1e-5ms), call it without out; the results are then taken from
%   the workspace (t_tot, y_tot, gshunt_1, ...):
%   plot_HHK                         % all plots
%   plot_HHK('TMP_AP', 'gating')     % only the plots you name
%
%   Available plots (one figure each):
%     'TMP'          membrane potential V1, V2 over the whole run (log time)
%     'TMP_pulse'    membrane potential during the pulse and RC relaxation
%     'TMP_AP'       membrane potential, first 60 ms (action potentials)
%     'gating'       gating variables m, n, h on the DP and HP side
%     'N'            small-pore density N1, N2
%     'conductance'  electroporation conductance g_ep1, g_ep2
%     'FPA'          fractional pore area
%     'radius'       large-pore radius of each launched pore group, DP and HP
%                    side, from pulse onset until the pores have shrunk back
%
%   Side 1 is the depolarised (DP) side, side 2 the hyperpolarised (HP) side.
%   The red dashed line marks the pulse onset (t = 5 ms).
%   Returns the figure handles.

all_plots = {'TMP', 'TMP_pulse', 'TMP_AP', 'gating', 'N', 'conductance', 'FPA', 'radius'};
if nargin == 0 || ~isstruct(out)     % no run_HHK result: use the workspace
    if nargin > 0
        varargin = [{out}, varargin];
    end
    out = results_from_workspace();
end
if isempty(varargin)
    which = all_plots;
else
    which = varargin;
    bad = setdiff(which, all_plots);
    if ~isempty(bad)
        error('plot_HHK:name', 'Unknown plot "%s". Choose from: %s', bad{1}, strjoin(all_plots, ', '));
    end
end

t   = out.t;
ton = out.params.ton_ms;
tp  = out.params.tp_ms;
RC  = out.params.RC_s * 1e3;   % ms
ttl = sprintf('V_{stim} = %g mV, t_p = %s, RC = %g s', out.params.V_stim_mV, ...
    duration_str(tp), out.params.RC_s);
figs = gobjects(0);

%% 1. Membrane potential, whole run ---------------------------------------
if any(strcmp(which, 'TMP'))
    figs(end+1) = new_fig('Membrane potential');
    plot(t, out.V1, t, out.V2, 'LineWidth', 1.5);
    set(gca, 'XScale', 'log');
    mark_pulse(ton);
    xlabel('time (ms)'); ylabel('TMP (mV)');
    legend('V_1 (DP)', 'V_2 (HP)', 'Location', 'best');
    finish(ttl);
end

%% 2. Membrane potential during the pulse ---------------------------------
if any(strcmp(which, 'TMP_pulse'))
    figs(end+1) = new_fig('Membrane potential: pulse');
    win = tp + RC;
    [scale, unit] = time_unit(3 * win);
    idx = t >= ton - 0.2 * win & t <= ton + 3 * win;
    plot((t(idx) - ton) * scale, out.V1(idx), (t(idx) - ton) * scale, out.V2(idx), 'LineWidth', 1.5);
    xline(0, 'k--'); xline(tp * scale, 'k--'); xline((tp + RC) * scale, 'k:');
    xlabel(['time after pulse onset (' unit ')']); ylabel('TMP (mV)');
    legend('V_1 (DP)', 'V_2 (HP)', 'pulse on / off', '', 'pulse off + RC', 'Location', 'best');
    finish(ttl);
end

%% 3. Membrane potential, first 60 ms (action potentials) -----------------
if any(strcmp(which, 'TMP_AP'))
    figs(end+1) = new_fig('Membrane potential: action potentials');
    idx = t <= min(60, t(end));
    plot(t(idx), out.V1(idx), t(idx), out.V2(idx), 'LineWidth', 1.5);
    mark_pulse(ton);
    xlim([0 min(60, t(end))]); ylim([-100 60]);
    xlabel('time (ms)'); ylabel('TMP (mV)');
    legend('V_1 (DP)', 'V_2 (HP)', 'Location', 'best');
    finish([ttl ' (y-axis clipped to -100...60 mV)']);
end

%% 4. Gating variables ---------------------------------------------------
if any(strcmp(which, 'gating'))
    figs(end+1) = new_fig('Gating variables');
    sides = {'DP (side 1)', 'HP (side 2)'};
    for s = 1:2
        subplot(1, 2, s);
        plot(t, out.(sprintf('m%d', s)), t, out.(sprintf('n%d', s)), t, out.(sprintf('h%d', s)), 'LineWidth', 1.5);
        set(gca, 'XScale', 'log'); ylim([0 1]);
        mark_pulse(ton);
        xlabel('time (ms)'); ylabel('gating variable');
        legend('m', 'n', 'h', 'Location', 'best');
        finish(sides{s});
    end
    sgtitle(ttl);
end

%% 5. Small-pore density -------------------------------------------------
if any(strcmp(which, 'N'))
    figs(end+1) = new_fig('Small-pore density');
    plot(t, out.N1, t, out.N2, 'LineWidth', 1.5);
    set(gca, 'XScale', 'log', 'YScale', 'log');
    mark_pulse(ton);
    xlabel('time (ms)'); ylabel('N (m^{-2})');
    legend('N_1 (DP)', 'N_2 (HP)', 'Location', 'best');
    finish(ttl);
end

%% 6. Electroporation conductance ----------------------------------------
if any(strcmp(which, 'conductance'))
    figs(end+1) = new_fig('Electroporation conductance');
    plot(t, out.gep1, t, out.gep2, 'LineWidth', 1.5);
    set(gca, 'XScale', 'log');
    mark_pulse(ton);
    xlabel('time (ms)'); ylabel('g_{ep} (mS/cm^2)');
    legend('g_{ep,1} (DP)', 'g_{ep,2} (HP)', 'Location', 'best');
    finish(ttl);
end

%% 7. Fractional pore area -----------------------------------------------
if any(strcmp(which, 'FPA'))
    figs(end+1) = new_fig('Fractional pore area');
    plot(t, out.FPA1, t, out.FPA2, 'LineWidth', 1.5);
    set(gca, 'XScale', 'log');
    mark_pulse(ton);
    xlabel('time (ms)'); ylabel('fractional pore area');
    legend('FPA_1 (DP)', 'FPA_2 (HP)', 'Location', 'best');
    finish(ttl);
end

%% 8. Large-pore radius per pore group -----------------------------------
if any(strcmp(which, 'radius'))
    % Pores are launched in groups during the pulse and RC relaxation; each
    % line is one group. Time is shown from pulse onset until the last pore
    % has shrunk back (radius <= 0.85 nm), in ns, us or ms as appropriate.
    figs(end+1) = new_fig('Large-pore radius');
    sides = {'DP', 'HP'};
    tr = out.radius.t;
    open = any(out.radius.DP > 0.85e-9, 2) | any(out.radius.HP > 0.85e-9, 2);
    if any(open)
        span = 1.2 * (max(tr(open)) - ton);
    else
        span = 3 * (tp + RC);
    end
    [scale, unit] = time_unit(span);
    idx = tr >= ton - 0.05 * span & tr <= ton + span;
    for s = 1:2
        subplot(1, 2, s);
        R = out.radius.(sides{s});
        keep = any(~isnan(R), 1);
        if any(keep)
            plot((tr(idx) - ton) * scale, R(idx, keep) * 1e9, 'LineWidth', 1.2);
            xline(tp * scale, 'k--', 'HandleVisibility', 'off');
            legend(compose('launch %d', find(keep)), 'Location', 'best', 'FontSize', 9);
        else
            text(0.5, 0.5, 'no large pores formed', 'Units', 'normalized', 'HorizontalAlignment', 'center');
        end
        xlabel(['time after pulse onset (' unit ')']); ylabel('pore radius (nm)');
        finish([sides{s} ' side (dashed: pulse off)']);
    end
    sgtitle(ttl);
end
end


%% ---- helpers -----------------------------------------------------------
function out = results_from_workspace()
% Results left in the base workspace by HHK_single_pulse.m.
names = {'t_tot', 'y_tot', 't1', 'y1', 't2_full', 'y2_full', 't3_full', 'y3_full', ...
    't4', 'y4', 'gshunt_1', 'gshunt_2', 'A_p1_full', 'A_p2_full', 'A1', 'A2', ...
    'Pore1', 'Pore2', 'Pore1_formed', 'Pore2_formed', 'solutions1', 'solutions2', ...
    'V_stim', 'tp', 'tf', 'ton', 'time_constant'};
S = struct();
for k = 1:numel(names)
    if evalin('base', sprintf('exist(''%s'', ''var'')', names{k}))
        S.(names{k}) = evalin('base', names{k});
    end
end
if ~isfield(S, 't1') || ~isfield(S, 'gshunt_1')
    error('plot_HHK:noResults', ['No HHK results found in the workspace. Either run a ' ...
        'model script first (e.g. HHK_single_pulse in model/RC_1e-5ms), or use ' ...
        'out = run_HHK(V_stim, tp) and then plot_HHK(out).']);
end
out = collect_HHK(S);
out.params = struct('V_stim_mV', S.V_stim, 'tp_ms', S.tp, 'RC_s', S.time_constant * 1e-3, ...
    'tf_ms', S.tf, 'ton_ms', S.ton, 'model', 'workspace');
end

function f = new_fig(name)
f = figure('Name', name, 'NumberTitle', 'off', 'Color', 'w');
end

function mark_pulse(ton)
xline(ton, 'r--', 'HandleVisibility', 'off');
end

function finish(ttl)
ax = gca;
set(ax, 'FontName', 'Times', 'FontSize', 13, 'LineWidth', 1, 'Box', 'on');
grid(ax, 'on');
title(ttl, 'FontWeight', 'normal');
end

function [scale, unit] = time_unit(span_ms)
% Choose ns / us / ms so the zoomed time axis has readable numbers.
if span_ms < 1e-3
    scale = 1e6; unit = 'ns';
elseif span_ms < 1
    scale = 1e3; unit = '\mus';
else
    scale = 1; unit = 'ms';
end
end

function s = duration_str(tp)
if tp < 1e-3
    s = sprintf('%g ns', tp * 1e6);
elseif tp < 1
    s = sprintf('%g \\mus', tp * 1e3);
else
    s = sprintf('%g ms', tp);
end
end
