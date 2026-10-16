%% ================================================================
%  SCRIPT: V_stim sweep for the standalone HH model (no electroporation)
%
%  Purpose:
%  Run the classical two-compartment HH model (dynamics_HH.m) across a
%  range of V_stim values spanning the excitation threshold through the
%  RS-onset boundary (as independently determined from the HHK SD
%  curves), and extract AP duration (APD50), peak amplitude, and peak
%  timing at each V_stim. Intended as the EP-free baseline against which
%  HHK-model (EP on) AP-duration trends are compared.
%
%  Requires on path: dynamics_HH.m, rectangular_input.m
%
%  Note: all three integration phases (equilibration, pulse, post-pulse)
%  use tight tolerances here -- unlike the original benchmarking script,
%  which left t1/t3 at MATLAB defaults. That was fine for a solver-vs-
%  solver validation check but would under-resolve the AP shape for the
%  duration measurements this script exists to produce.
%
%  REPRODUCIBILITY: this is the version (originally HH_Vstim_sweep_1.m) that
%  produced data/raw/HH_model_Boin/HH_Vstim_sweep_results.mat (used by S7
%  Table and S17 Fig); rerunning it reproduces the saved traces exactly
%  (checked for V_stim = 1560 mV). It needs
%  R = 10^-5 in dynamics_HH.m (RC = 1e-8 s); the results are saved to the
%  current folder, so the copy in data/ is not overwritten.
%% ================================================================
clear; clc; close all;
tic

global tp ton toff

%% -------------------- Fixed pulse parameters --------------------
tp  = 1e-4;         % pulse duration = 100 ns (ms)
ton = 5;            % pulse onset (ms)
toff = ton + tp;
tf  = 20;           % total integration time (ms)

y0 = [-70; -70; 0.053; 0.317; 0.596; 0.053; 0.317; 0.596];  % resting state

%% -------------------- V_stim sweep values (mV) --------------------
% Excitation threshold = 1557 mV, EP onset = 1784 mV, RS onset = 2004 mV
% (all at tp = 100 ns, from your SD-curve sweep).
%
% Denser sampling is placed around 1784 mV (the EP-onset boundary) since
% that's the transition of mechanistic interest; coarser sampling covers
% the "clean SAP, no EP yet" region (1557-1784) as a baseline segment,
% and the "SAP + growing EP" region (1784-2004) up to just below RS
% onset. Stops at 1995 mV to stay safely inside the single-spike regime.
Vstim_list = [1560, 1600, 1650, 1700, 1750, ...           % below EP onset (5 pts)
              1784, 1800, 1830, 1860, ...                  % around EP onset (4 pts)
              1900, 1940, 1970, 1995];                     % approaching RS onset (4 pts)
              % 13 points total. Add more inside any interval that turns
              % out to have an interesting kink once you see the first pass.

n_runs = numel(Vstim_list);
duration_APD50 = nan(n_runs,1);
peakV   = nan(n_runs,1);
peakT   = nan(n_runs,1);
t_all   = cell(n_runs,1);
V_all   = cell(n_runs,1);

%% -------------------- Solver options (tight throughout) --------------------
opts_eq   = odeset('RelTol',1e-9,'AbsTol',1e-12);
opts_pulse = odeset('RelTol',1e-9,'AbsTol',1e-12,'InitialStep',1e-9,'MaxStep',1e-9);
opts_post = odeset('RelTol',1e-9,'AbsTol',1e-12,'MaxStep',1e-3);

for k = 1:n_runs
    V_stim = Vstim_list(k);
    fprintf('Run %d/%d: V_stim = %d mV ... ', k, n_runs, V_stim);

    tspan1 = [0 ton];
    tspan2 = [ton toff];
    tspan3 = [toff tf];

    % Each phase gets a CONSTANT stimulus (0, V_stim, 0) rather than
    % calling rectangular_input(t) inside the RHS. rectangular_input uses
    % an inclusive t>=ton & t<=toff test, so evaluating it exactly at the
    % phase boundary (t=ton or t=toff) flips the stimulus discontinuously
    % at that single point -- harmless under loose default tolerances,
    % but fatal to a tight-tolerance solver trying to resolve the
    % boundary precisely. Since tspan1/tspan2/tspan3 already restrict
    % each phase to before/during/after the pulse, passing a constant
    % value is exact and avoids the discontinuity entirely.
    [t1,y1] = ode23s(@(t,y) dynamics_HH(t,y,0),      tspan1, y0,          opts_eq);
    [t2,y2] = ode23s(@(t,y) dynamics_HH(t,y,V_stim), tspan2, y1(end,:),   opts_pulse);
    [t3,y3] = ode23s(@(t,y) dynamics_HH(t,y,0),      tspan3, y2(end,:),   opts_post);

    t_tot = [t1; t2; t3];
    V_tot = [y1(:,1); y2(:,1); y3(:,1)];

    t_all{k} = t_tot;
    V_all{k} = V_tot;

    %% --- Peak amplitude/time restricted to the post-pulse AP window (t > 6 ms) ---
    mask_ap = t_tot > 6.0;
    t_ap = t_tot(mask_ap);
    V_ap = V_tot(mask_ap);
    [Vpk, idx_pk] = max(V_ap);
    tpk = t_ap(idx_pk);
    peakV(k) = Vpk;
    peakT(k) = tpk;

    %% --- APD50: duration V1(t) stays above half-max (relative to rest = -70 mV) ---
    V_rest = -70;
    half_level = V_rest + 0.5*(Vpk - V_rest);

    above = V_ap >= half_level;
    if any(above)
        idx_first = find(above, 1, 'first');
        idx_last  = find(above, 1, 'last');
        % linear interpolation for sub-sample crossing precision
        if idx_first > 1
            t_up = interp1(V_ap(idx_first-1:idx_first), t_ap(idx_first-1:idx_first), half_level);
        else
            t_up = t_ap(idx_first);
        end
        if idx_last < numel(V_ap)
            t_down = interp1(V_ap(idx_last:idx_last+1), t_ap(idx_last:idx_last+1), half_level);
        else
            t_down = t_ap(idx_last);
        end
        duration_APD50(k) = t_down - t_up;
    end

    fprintf('peakV=%.3f mV @ t=%.4f ms, APD50=%.5f ms\n', Vpk, tpk, duration_APD50(k));
end

toc

%% -------------------- Save results --------------------
save('HH_Vstim_sweep_results.mat', 'Vstim_list', 'duration_APD50', 'peakV', 'peakT', 't_all', 'V_all');

%% -------------------- Quick diagnostic plot --------------------
figure;
yyaxis left
plot(Vstim_list, duration_APD50, '-o', 'LineWidth', 1.5);
ylabel('APD50 (ms)');
yyaxis right
plot(Vstim_list, peakV, '-s', 'LineWidth', 1.5);
ylabel('Peak V (mV)');
xlabel('V_{stim} (mV)');
xline(1557, '--k', 'Excitation thr.');
xline(1784, '--r', 'EP onset');
xline(2004, '--m', 'RS onset');
title('HH-only (no EP) baseline: AP duration and amplitude vs V_{stim}');
grid on;
