%% ================================================================
%  NUMERICAL CONVERGENCE TEST FOR THE HHK MODEL (for SI)
%  -- ODE SOLVER TOLERANCE ONLY (RelTol and AbsTol, tested separately) --
%
%  Two V_stim cases:
%
%    Case A (SAP, pore-nucleation point): V_stim = 1784 mV, tp = 100 ns.
%       This is the exact stimulus from subsection 3.4.2 where the first
%       HP-side large pore nucleates -- the most numerically sensitive
%       SAP-regime point.
%
%    Case B (near RS onset): V_stim = 14500 mV, tp = 1 ns. Sits right at
%       the RS boundary of the 1 ns-pulse sweep, where g_shunt grows to
%       within about an order of magnitude of g_K,max/g_Na,max (vs. 2-3
%       orders of magnitude below it in the SAP regime) -- the regime
%       flagged as an open question for whether the "g_shunt is a
%       spectator" argument from 3.4.2 still holds. To test DB instead,
%       set V_STIM_B = 15500 and swap the metric block (DB does not
%       repolarize, so use peak-plateau V1 / max g_shunt rather than
%       spike_train_metrics).
%
%  Two SEPARATE one-at-a-time tolerance sweeps per case (this is
%  deliberately not a joint RelTol x AbsTol grid -- varying one axis while
%  holding the other at its production value isolates which tolerance
%  actually drives any change, rather than conflating the two):
%    (1) RelTol swept, AbsTol held at the model's production value.
%    (2) AbsTol swept, RelTol held at the model's production value.
%  InitialStep/MaxStep are held fixed at the production step size
%  throughout -- this test is scoped to RelTol/AbsTol only, not the launch-
%  interval discretization (n_sub_pulse/dt_RC are held fixed at their
%  production values, 10 and 1e-6 ms, for every run here).
%
%  Requires (same folder): run_HHK_case.m, dynamics_HH_with_electroporation.m,
%  dynamics__HH_with_EP_shunt.m, rectangular_input.m, compute_AP_metrics.m.
%
%  tf is deliberately shortened for this sweep (see TF_A / TF_B below) --
%  every metric used here resolves within a few tens of ms of pulse onset.
%  Set them to 20000 to reproduce the full production time window; it will
%  not change any of the metrics tested here.
% ================================================================
clear; clc; close all;

%% -------------------- Case definitions --------------------
V_STIM_A = 1784;   TP_A = 1e-4;  TF_A = 60;   % SAP / pore-nucleation point (100 ns pulse)
V_STIM_B = 14500;  TP_B = 1e-6;  TF_B = 80;   % near RS onset (1 ns pulse)

% Fixed launch-interval discretization (production values, NOT swept here)
N_SUB_PULSE = 10;
DT_RC       = 1e-6;

% Production step size (InitialStep = MaxStep), matching HHK_single_pulse.m's
% own tp-bucket choice: tp=1e-4 falls in the "1e-4<=tp<1e-2" bucket (1e-6 ms
% step); tp=1e-6 falls in the "tp<=1e-5" bucket (1e-8 ms step).
STEP_A = 1e-6;
STEP_B = 1e-8;

% Production tolerance (the value each sweep holds fixed on its "other" axis)
RELTOL_PROD   = 1e-8;
ABSTOL_PROD_A = 1e-12;   % Case A production AbsTol
ABSTOL_PROD_B = 1e-13;   % Case B production AbsTol

%% -------------------- Tolerance ladders --------------------
% RelTol ladder (same for both cases): coarse -> production -> tight -> very tight
RelTol_levels = [1e-4, 1e-6, 1e-8, 1e-10];

% AbsTol ladders (case-specific, centered on each case's production value).
% Not pushed below ~1e-15: MATLAB double precision has ~2.2e-16 machine
% epsilon, so an AbsTol tighter than that is not meaningful and can make
% the solver's error estimate noise-dominated rather than more accurate.
AbsTol_levels_A = [1e-8,  1e-10, 1e-12, 1e-14];
AbsTol_levels_B = [1e-9,  1e-11, 1e-13, 1e-15];

fprintf('======================================================================\n');
fprintf('CASE A: SAP / pore-nucleation point, V_stim = %g mV, tp = %.0e ms (100 ns)\n', V_STIM_A, TP_A);
fprintf('======================================================================\n');

%% ---- Case A: RelTol sweep (AbsTol held at production) ----
fprintf('\n-- RelTol sweep (AbsTol=%.0e fixed) --\n', ABSTOL_PROD_A);
resA_rtol = table();
for k = 1:numel(RelTol_levels)
    tol = struct('RelTol', RelTol_levels(k), 'AbsTol', ABSTOL_PROD_A, ...
                 'InitialStep', STEP_A, 'MaxStep', STEP_A);
    r = run_HHK_case(V_STIM_A, TP_A, N_SUB_PULSE, DT_RC, tol, TF_A);
    mtr = compute_AP_metrics(r.t_tot, r.y_tot(:,1), r.ton);
    lat = mtr.spike_latency; T50 = mtr.T50; T90 = mtr.T90; V_AP = mtr.V_AP;
    g2pk = max(r.gshunt_2);
    row = table(RelTol_levels(k), lat, T50, T90, V_AP, g2pk, sum(r.Pore2_formed), ...
                'VariableNames', {'RelTol','latency_ms','T50_ms','T90_ms','V_AP_mV','max_gshunt2','pore2_sum'});
    resA_rtol = [resA_rtol; row]; %#ok<AGROW>
    fprintf('  RelTol=%.0e | lat=%.4f T50=%.4f T90=%.4f Vap=%.3f g2pk=%.5f pore2_sum=%d\n', ...
        RelTol_levels(k), lat, T50, T90, V_AP, g2pk, sum(r.Pore2_formed));
end
disp(resA_rtol);

%% ---- Case A: AbsTol sweep (RelTol held at production) ----
fprintf('\n-- AbsTol sweep (RelTol=%.0e fixed) --\n', RELTOL_PROD);
resA_atol = table();
for k = 1:numel(AbsTol_levels_A)
    tol = struct('RelTol', RELTOL_PROD, 'AbsTol', AbsTol_levels_A(k), ...
                 'InitialStep', STEP_A, 'MaxStep', STEP_A);
    r = run_HHK_case(V_STIM_A, TP_A, N_SUB_PULSE, DT_RC, tol, TF_A);
    mtr = compute_AP_metrics(r.t_tot, r.y_tot(:,1), r.ton);
    lat = mtr.spike_latency; T50 = mtr.T50; T90 = mtr.T90; V_AP = mtr.V_AP;
    g2pk = max(r.gshunt_2);
    row = table(AbsTol_levels_A(k), lat, T50, T90, V_AP, g2pk, sum(r.Pore2_formed), ...
                'VariableNames', {'AbsTol','latency_ms','T50_ms','T90_ms','V_AP_mV','max_gshunt2','pore2_sum'});
    resA_atol = [resA_atol; row]; %#ok<AGROW>
    fprintf('  AbsTol=%.0e | lat=%.4f T50=%.4f T90=%.4f Vap=%.3f g2pk=%.5f pore2_sum=%d\n', ...
        AbsTol_levels_A(k), lat, T50, T90, V_AP, g2pk, sum(r.Pore2_formed));
end
disp(resA_atol);

fprintf('\n======================================================================\n');
fprintf('CASE B: near RS onset, V_stim = %g mV, tp = %.0e ms (1 ns)\n', V_STIM_B, TP_B);
fprintf('======================================================================\n');

%% ---- Case B: RelTol sweep (spike-train metrics, not single-AP metrics) ----
fprintf('\n-- RelTol sweep (AbsTol=%.0e fixed) --\n', ABSTOL_PROD_B);
resB_rtol = table();
for k = 1:numel(RelTol_levels)
    tol = struct('RelTol', RelTol_levels(k), 'AbsTol', ABSTOL_PROD_B, ...
                 'InitialStep', STEP_B, 'MaxStep', STEP_B);
    r = run_HHK_case(V_STIM_B, TP_B, N_SUB_PULSE, DT_RC, tol, TF_B);
    m = spike_train_metrics(r.t_tot, r.y_tot(:,1), r.ton, r.toff);
    g2pk = max(r.gshunt_2);
    row = table(RelTol_levels(k), m.n_spikes, m.first_latency, m.mean_isi, g2pk, sum(r.Pore2_formed), ...
                'VariableNames', {'RelTol','n_spikes','first_latency_ms','mean_ISI_ms','max_gshunt2','pore2_sum'});
    resB_rtol = [resB_rtol; row]; %#ok<AGROW>
    fprintf('  RelTol=%.0e | n_spk=%d first_lat=%.4f ISI=%.4f g2pk=%.4f pore2_sum=%d\n', ...
        RelTol_levels(k), m.n_spikes, m.first_latency, m.mean_isi, g2pk, sum(r.Pore2_formed));
end
disp(resB_rtol);

%% ---- Case B: AbsTol sweep (RelTol held at production) ----
fprintf('\n-- AbsTol sweep (RelTol=%.0e fixed) --\n', RELTOL_PROD);
resB_atol = table();
for k = 1:numel(AbsTol_levels_B)
    tol = struct('RelTol', RELTOL_PROD, 'AbsTol', AbsTol_levels_B(k), ...
                 'InitialStep', STEP_B, 'MaxStep', STEP_B);
    r = run_HHK_case(V_STIM_B, TP_B, N_SUB_PULSE, DT_RC, tol, TF_B);
    m = spike_train_metrics(r.t_tot, r.y_tot(:,1), r.ton, r.toff);
    g2pk = max(r.gshunt_2);
    row = table(AbsTol_levels_B(k), m.n_spikes, m.first_latency, m.mean_isi, g2pk, sum(r.Pore2_formed), ...
                'VariableNames', {'AbsTol','n_spikes','first_latency_ms','mean_ISI_ms','max_gshunt2','pore2_sum'});
    resB_atol = [resB_atol; row]; %#ok<AGROW>
    fprintf('  AbsTol=%.0e | n_spk=%d first_lat=%.4f ISI=%.4f g2pk=%.4f pore2_sum=%d\n', ...
        AbsTol_levels_B(k), m.n_spikes, m.first_latency, m.mean_isi, g2pk, sum(r.Pore2_formed));
end
disp(resB_atol);

%% -------------------- Relative-change diagnostic (coarsest vs finest) --------------------
fprintf('\n======================================================================\n');
fprintf('RELATIVE CHANGE, coarsest -> finest (report these numbers in the SI text)\n');
fprintf('======================================================================\n');
report_rel_change('Case A, RelTol sweep', resA_rtol, {'latency_ms','T50_ms','T90_ms','V_AP_mV','max_gshunt2','pore2_sum'});
report_rel_change('Case A, AbsTol sweep', resA_atol, {'latency_ms','T50_ms','T90_ms','V_AP_mV','max_gshunt2','pore2_sum'});
report_rel_change('Case B, RelTol sweep', resB_rtol, {'first_latency_ms','mean_ISI_ms','max_gshunt2','pore2_sum'});
report_rel_change('Case B, AbsTol sweep', resB_atol, {'first_latency_ms','mean_ISI_ms','max_gshunt2','pore2_sum'});

save('Convergence_Test_HHK_results.mat', 'resA_rtol','resA_atol','resB_rtol','resB_atol');

%% -------------------- Figures (SI-ready) --------------------
figure('Position',[50 50 1200 850]);

subplot(2,2,1); hold on; box on;
yyaxis left
semilogx(resA_rtol.RelTol, resA_rtol.T50_ms, '-ok','LineWidth',1.5,'MarkerFaceColor','k'); ylabel('$T_{50\%}$ (ms)','Interpreter','latex');
yyaxis right
semilogx(resA_rtol.RelTol, resA_rtol.latency_ms, '-sr','LineWidth',1.5,'MarkerFaceColor','r'); ylabel('Latency (ms)');
set(gca,'XDir','reverse','FontSize',11); xlabel('RelTol');
title('(a) Case A: RelTol convergence','Interpreter','latex');

subplot(2,2,2); hold on; box on;
yyaxis left
semilogx(resA_atol.AbsTol, resA_atol.T50_ms, '-ok','LineWidth',1.5,'MarkerFaceColor','k'); ylabel('$T_{50\%}$ (ms)','Interpreter','latex');
yyaxis right
semilogx(resA_atol.AbsTol, resA_atol.latency_ms, '-sr','LineWidth',1.5,'MarkerFaceColor','r'); ylabel('Latency (ms)');
set(gca,'XDir','reverse','FontSize',11); xlabel('AbsTol');
title('(b) Case A: AbsTol convergence','Interpreter','latex');

subplot(2,2,3); hold on; box on;
yyaxis left
semilogx(resB_rtol.RelTol, resB_rtol.first_latency_ms, '-ok','LineWidth',1.5,'MarkerFaceColor','k'); ylabel('First-spike latency (ms)');
yyaxis right
semilogx(resB_rtol.RelTol, resB_rtol.max_gshunt2, '-sb','LineWidth',1.5,'MarkerFaceColor','b'); ylabel('max $g_{\mathrm{shunt,HP}}$ (mS/cm$^2$)','Interpreter','latex');
set(gca,'XDir','reverse','FontSize',11); xlabel('RelTol');
title('(c) Case B (near RS): RelTol convergence','Interpreter','latex');

subplot(2,2,4); hold on; box on;
yyaxis left
semilogx(resB_atol.AbsTol, resB_atol.first_latency_ms, '-ok','LineWidth',1.5,'MarkerFaceColor','k'); ylabel('First-spike latency (ms)');
yyaxis right
semilogx(resB_atol.AbsTol, resB_atol.max_gshunt2, '-sb','LineWidth',1.5,'MarkerFaceColor','b'); ylabel('max $g_{\mathrm{shunt,HP}}$ (mS/cm$^2$)','Interpreter','latex');
set(gca,'XDir','reverse','FontSize',11); xlabel('AbsTol');
title('(d) Case B (near RS): AbsTol convergence','Interpreter','latex');

sgtitle('Numerical convergence of the HHK model: ODE solver RelTol and AbsTol', 'Interpreter','latex','FontSize',14);


%% ================================================================
function m = spike_train_metrics(t_tot, V1, ton, toff)
    % Spike-train diagnostics for regimes (RS/DB) where a single
    % latency/T50/T90/V_AP summary doesn't apply. Masks out the pulse +
    % RC-relaxation transient (V1 driven to non-physiological values by
    % the (Vstim-V1+V2)/R term while the pulse is literally on) before
    % looking for spikes, exactly as needed when analyzing the 1 ns
    % RS/DB dataset earlier in this project.
    time_constant = 1e-5;
    mask = t_tot >= (toff + time_constant + 1e-3);
    tt = t_tot(mask); VV = V1(mask);
    % Pass tt as the x-vector so the minimum peak distance is specified
    % directly in ms, not in samples -- ode23s's adaptive step means sample
    % spacing is highly non-uniform (dense near transitions, sparse in
    % quiescent stretches), so a sample-count-based distance is unreliable.
    % find_spikes (below) is plain MATLAB and gives exactly the same result
    % as the Signal Processing Toolbox call, which can be used instead:
    %   [pks, spike_times] = findpeaks(VV, tt, 'MinPeakHeight', -20, 'MinPeakDistance', 0.5);
    [pks, spike_times] = find_spikes(VV, tt, -20, 0.5); %#ok<ASGLU>
    spike_times = spike_times - ton;
    m.n_spikes = numel(spike_times);
    if m.n_spikes >= 1
        m.first_latency = spike_times(1);
    else
        m.first_latency = NaN;
    end
    if m.n_spikes >= 2
        m.mean_isi = mean(diff(spike_times));
    else
        m.mean_isi = NaN;
    end
end

function report_rel_change(label, T, cols)
    fprintf('\n%s:\n', label);
    for c = 1:numel(cols)
        v = T.(cols{c});
        v = v(~isnan(v));
        if numel(v) < 2, continue; end
        rel = 100*(v(end)-v(1))/max(abs(v(1)),eps);
        fprintf('  %-18s coarsest=%.5g  finest=%.5g  relative change=%.3f%%\n', cols{c}, v(1), v(end), rel);
    end
end

function [pks, locs] = find_spikes(y, x, min_height, min_dist)
% Peaks of y above min_height that are at least min_dist apart in x, using
% the same rules as findpeaks(y, x, 'MinPeakHeight', min_height,
% 'MinPeakDistance', min_dist): a peak is higher than the sample before it
% and not lower than the one after (the first sample of a flat top), end
% points are never peaks, and among peaks closer than min_dist only the
% tallest is kept.
y = y(:); x = x(:);
n = numel(y);
idx = zeros(0, 1);
i = 2;
while i < n
    if y(i) > y(i-1)
        j = i;
        while j < n && y(j+1) == y(i)
            j = j + 1;
        end
        if j < n && y(j+1) < y(i)
            idx(end+1, 1) = i; %#ok<AGROW>
        end
        i = j + 1;
    else
        i = i + 1;
    end
end
idx = idx(y(idx) > min_height);
[~, order] = sort(y(idx), 'descend');
idx = idx(order);
drop = false(size(idx));
for k = 1:numel(idx)
    if ~drop(k)
        drop = drop | (x(idx) >= x(idx(k)) - min_dist & x(idx) <= x(idx(k)) + min_dist);
        drop(k) = false;
    end
end
idx = sort(idx(~drop));
pks = y(idx);
locs = x(idx);
end
