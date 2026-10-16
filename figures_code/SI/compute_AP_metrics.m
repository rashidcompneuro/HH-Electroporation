function metrics = compute_AP_metrics(t, V, ton, varargin)
%COMPUTE_AP_METRICS  Spike latency, T50%/T90% (peak-to-X%-recovery), and AP
%   peak voltage from a single (t, V) trace -- ports the exact logic from
%   the bottom of your Fig6bcd_AP_features_1ns.m (lines 664-687) into a reusable function,
%   generalized to also report T90% as a cross-check on where in the
%   repolarization phase a duration change is actually concentrated.
%
%   metrics = compute_AP_metrics(t, V, ton)
%   metrics = compute_AP_metrics(t, V, ton, 'V_rest', -70, 'margin', 1.1e-3)
%
%   Inputs:
%     t      -- time vector (ms)
%     V      -- membrane potential vector (mV), same length as t
%     ton    -- pulse onset time (ms), e.g. 5
%
%   Name-value options:
%     'V_rest'  -- resting potential (mV). Default -70.
%     'margin'  -- how far past ton to start searching for the AP peak
%                  (ms), to skip over the pulse/RC artifact. Default
%                  1.1e-3 ms (matches your Fig6bcd_AP_features_1ns.m usage, comfortably
%                  past a 100 ns pulse + 10 ns RC window too).
%
%   Output struct fields:
%     spike_latency -- t_peak - ton (ms): time from pulse onset to AP peak
%     T50           -- t_down50 - t_peak (ms): time from peak to the point
%                       V decays to 50% of the amplitude above V_rest
%                       (i.e. V = V_rest + 0.5*amp). NaN if no such
%                       crossing is found. Identical definition/values to
%                       your Fig6bcd_AP_features_1ns.m algorithm.
%     T90           -- t_down90 - t_peak (ms): time from peak to 90%
%                       repolarization (V = V_rest + 0.1*amp). Same
%                       method as T50, just a later crossing threshold.
%                       Use this alongside T50 to check whether an
%                       EP-driven duration increase is concentrated in
%                       the early/fast repolarization phase (T50 moves)
%                       or the late/tail phase (T90 moves more than T50
%                       does, proportionally) -- see discussion in chat.
%     V_AP          -- peak V during the post-artifact window (mV)
%     t_peak        -- absolute time of the AP peak (ms)
%     amp           -- V_AP - V_rest (mV)

p = inputParser;
addParameter(p, 'V_rest', -70);
addParameter(p, 'margin', 1.1e-3);
parse(p, varargin{:});
V_rest = p.Results.V_rest;
margin = p.Results.margin;

t = t(:); V = V(:);

%% --- Restrict to the post-artifact window (mirrors your t>5+1.1e-3 usage) ---
mask = t > (ton + margin);
tt = t(mask);
VV = V(mask);

if isempty(tt)
    error('compute_AP_metrics:noData', ...
        'No samples found after t > ton + margin (%.6g ms) -- check ton/margin.', ton+margin);
end

%% --- 1. AP peak ---
[V_peak, idx_peak] = max(VV);
t_peak = tt(idx_peak);

%% --- 2. Amplitude ---
amp = V_peak - V_rest;

%% --- 3. Recovery-time metrics (T50%, T90%) ---
T50 = local_recovery_time(tt, VV, idx_peak, t_peak, V_rest, amp, 0.5);
T90 = local_recovery_time(tt, VV, idx_peak, t_peak, V_rest, amp, 0.9);

%% --- Pack results ---
metrics.spike_latency = t_peak - ton;
metrics.T50    = T50;
metrics.T90    = T90;
metrics.V_AP   = V_peak;
metrics.t_peak = t_peak;
metrics.amp    = amp;

end

%% ================================================================
function T = local_recovery_time(tt, VV, idx_peak, t_peak, V_rest, amp, frac)
%LOCAL_RECOVERY_TIME  Peak-to-(frac*100)%-recovery time, same two-stage
%   bounded-search method as your Fig6bcd_AP_features_1ns.m T50% code, generalized to an
%   arbitrary recovery fraction. frac=0.5 reproduces T50 exactly
%   (V_cut collapses to V_rest+0.2*amp, matching Fig6bcd_AP_features_1ns.m identically).

V_target = V_rest + (1 - frac) * amp;   % e.g. frac=0.5 -> V_rest+0.5*amp
V_cut    = V_target - 0.3 * amp;        % guard rail, same offset as original

idx_stop_rel = find(VV(idx_peak:end) < V_cut, 1, 'first');
if isempty(idx_stop_rel)
    idx_stop = numel(VV);   % never reaches the guard band within the trace
else
    idx_stop = idx_stop_rel + idx_peak - 1;
end

idx_cross_rel = find(VV(idx_peak:idx_stop) <= V_target, 1, 'first');
if isempty(idx_cross_rel)
    T = NaN;   % didn't recover to this fraction within the searched window
else
    idx_cross = idx_cross_rel + idx_peak - 1;
    if idx_cross > 1
        t_cross = interp1(VV(idx_cross-1:idx_cross), tt(idx_cross-1:idx_cross), V_target);
    else
        t_cross = tt(idx_cross);
    end
    T = t_cross - t_peak;
end

end
