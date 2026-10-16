function [V_th, fired] = HH_SD_threshold(tp, V_lo, V_hi, tol)
% HH_SD_THRESHOLD  Excitation threshold of the HH model (no electroporation)
% for one rectangular pulse, by bisection on V_stim.
%
%   V_th = HH_SD_threshold(tp)                 % tp in ms, search 1-100 mV
%   V_th = HH_SD_threshold(tp, V_lo, V_hi, tol)
%
%   Uses the same equations and solver calls as HH_single_pulse.m (rest,
%   pulse, relaxation; ode23s) with the RC set by R in dynamics_HH.m.
%   A run counts as an action potential when V1 or V2 rises above 0 mV.
%   This criterion is meant for pulses of about 0.5 ms and longer, where the
%   pulse itself only shifts the membrane by a few tens of mV.
%   Used for the 2-20 ms points of the HH-only curve in S6 Fig.
%
%   Run from model/HH_without_EP (so this folder's dynamics_HH.m is used).

if nargin < 2, V_lo = 1; end
if nargin < 3, V_hi = 100; end
if nargin < 4, tol = 0.01; end
fired = @(V) fires(V, tp);
if fired(V_lo) || ~fired(V_hi)
    error('HH_SD_threshold:bracket', 'Threshold for tp = %g ms is not between %g and %g mV.', tp, V_lo, V_hi);
end
while V_hi - V_lo > tol
    V_mid = (V_lo + V_hi) / 2;
    if fired(V_mid)
        V_hi = V_mid;
    else
        V_lo = V_mid;
    end
end
V_th = V_hi;
end


function ap = fires(V_stim, tp_ms)
global tp ton toff
tp = tp_ms; ton = 5; toff = ton + tp;
tf = max(60, toff + 40);   % leave time for a delayed spike after long pulses
y0 = [-70; -70; 0.053; 0.317; 0.596; 0.053; 0.317; 0.596];
[~, y1] = ode23s(@(t, y) dynamics_HH(t, y, V_stim * rectangular_input(t)), [0 ton], y0);
[~, y2] = ode23s(@(t, y) dynamics_HH(t, y, V_stim * rectangular_input(t)), [ton toff], y1(end, :));
[~, y3] = ode23s(@(t, y) dynamics_HH(t, y, V_stim * rectangular_input(t)), [toff tf], y2(end, :));
y = [y2; y3];
ap = max(max(y(:, 1:2))) > 0;
end
