function result = run_HHK_case(V_stim, tp, n_sub_pulse, dt_RC, tol, tf)
% RUN_HHK_CASE  Single-Vstim HHK simulation with the discretization/tolerance
% knobs exposed as arguments, for the numerical convergence study.
%
% This is a parameterized, faithful port of HHK_single_pulse.m (same
% t1 -> t2 (pulse) -> t3 (RC relaxation) -> pore-absorption -> t4 (long
% relaxation) structure, same event functions, same physics via
% dynamics_HH_with_electroporation.m / dynamics__HH_with_EP_shunt.m).
% The two things HHK_single_pulse.m hard-codes are exposed here instead:
%
%   n_sub_pulse : number of sub-intervals the pulse duration tp is split
%                 into (HHK_single_pulse.m hard-codes this via
%                 launch_interval = tp/10, i.e. n_sub_pulse = 10). Each
%                 sub-interval boundary is where the model checks whether
%                 a new discrete large pore has nucleated (floor(N*A)~=0)
%                 and, if so, resets the mean-field density and appends a
%                 pore-radius state. This is NOT the ODE solver's internal
%                 step size -- it's the model's own "how often do we allow
%                 a large pore to be born" bookkeeping granularity.
%
%   dt_RC       : sub-interval size (ms) used for the same bookkeeping
%                 during the post-pulse RC-relaxation window (0 to
%                 time_constant after pulse-off). HHK_single_pulse.m
%                 hard-codes this to 1e-6 ms (1 ns) via launch_interval_2.
%
%   tol         : struct with fields RelTol, AbsTol, InitialStep, MaxStep,
%                 applied uniformly to every ode23s call (t2, t3, t4).
%                 HHK_single_pulse.m instead picks these from a tp-bucket
%                 if/elseif chain; for a convergence test we want explicit,
%                 identical control across every run so tolerance is the
%                 only thing that changes between runs.
%
% tf is exposed too (ms, measured from t=0) so the convergence sweep can
% use a short observation window (enough to resolve the AP / spike train
% and its metrics) instead of the production tf=20000 ms, which exists in
% the original script only for long-tail pore-absorption/IRE bookkeeping
% far beyond where any AP-shape metric is read off. Pass tf=20000 to
% reproduce the full production window.
%
% Returns a struct with t_tot, y_tot (columns 1:10 = V1 V2 m1 n1 h1 m2 n2
% h2 N1 N2, exactly as in the user's saved data), Pore1_formed,
% Pore2_formed, gshunt_1, gshunt_2, A_p1_full, A_p2_full -- same names/
% shapes as HHK_single_pulse.m so compute_AP_metrics.m and the existing
% pore/g_shunt extraction code work on it unchanged.

% rectangular_input.m reads ton/toff via these globals (it does not use tp,
% which is this function's own input argument -- must NOT be declared
% global here, since MATLAB disallows making a function's input argument
% global inside that same function).
global ton toff %#ok<GVMIS>
ton = 5; toff = ton + tp;

%% -------------------- Fixed physical/threshold parameters (unchanged from HHK_single_pulse.m) --------------------
irr_ep_threshold = 100e-9;
abs_pore_threshold = 0.83e-9;
FPA_threshold = 0.0126;

A1 = 1.26e-9/2;
A2 = 1.26e-9/2;
r_m = 0.8e-9;

flag1 = 1; flag2 = 1;
time_constant = 1e-5; % RC (ms) -- fixed, matches the "RC1e-5ms" code family

%% -------------------- Time discretization built from the exposed knobs --------------------
launch_interval   = tp / n_sub_pulse;
launch_interval_2 = dt_RC;

number_of_launches   = round(tp / launch_interval) + 1;
number_of_launches_2 = round(time_constant / launch_interval_2) + 1;

tspan1 = [0 ton];
tspan2 = ton:launch_interval:toff;
tspan3 = toff:launch_interval_2:(toff + time_constant);
tspan4 = [toff + time_constant, tf];

%% -------------------- Uniform ODE options from tol (replaces the tp-bucket branching) --------------------
opts_pore = odeset('RelTol', tol.RelTol, 'AbsTol', tol.AbsTol, ...
                    'InitialStep', tol.InitialStep, 'MaxStep', tol.MaxStep, ...
                    'Events', @(t, y) myEventFcn(t, y, irr_ep_threshold));

%% -------------------- Initial conditions --------------------
y0 = [-70;-70;0.053;0.317;0.596;0.053;0.317;0.596;1.5e9;1.5e9];

%% -------------------- t1: equilibration --------------------
[t1, y1] = ode23s(@(t1,y1) dynamics_HH_with_electroporation(t1,y1,V_stim*rectangular_input(t1), flag1, flag2), tspan1, y0);

t2_full = []; y2_full = []; t3_full = []; y3_full = [];
y0_2 = [y1(end,:), r_m, r_m];

Pore1 = floor(y1(end,9)*A1);
Pore2 = floor(y1(end,10)*A2);

gep_t1 = 0.0041;
gshunt_1 = gep_t1*ones(length(t1),1);
gshunt_2 = gep_t1*ones(length(t1),1);
A_p1_full = zeros(length(t1),1);
A_p2_full = zeros(length(t1),1);

%% -------------------- t2: pulse duration, n_sub_pulse launches --------------------
for i = 1:number_of_launches-1
    [t2, y2, te, ~, ~] = ode23s(@(t2,y2) dynamics__HH_with_EP_shunt(t2,y2,V_stim*rectangular_input(t2), i, Pore1, Pore2, flag1, flag2), [tspan2(i) tspan2(i+1)], y0_2, opts_pore);

    [~, g_shunt_1, g_shunt_2, A_p1_tilda, A_p2_tilda] = cellfun(@(t2,y2) dynamics__HH_with_EP_shunt(t2,y2.',V_stim*rectangular_input(t2).', i, Pore1, Pore2, flag1, flag2), num2cell(t2), num2cell(y2,2), 'uni', 0);
    g_shunt_1 = cell2mat(g_shunt_1); g_shunt_2 = cell2mat(g_shunt_2);
    A_p1_tilda = cell2mat(A_p1_tilda); A_p2_tilda = cell2mat(A_p2_tilda);

    gshunt_1 = [gshunt_1; g_shunt_1]; gshunt_2 = [gshunt_2; g_shunt_2]; %#ok<AGROW>
    A_p1_full = [A_p1_full; A_p1_tilda]; A_p2_full = [A_p2_full; A_p2_tilda]; %#ok<AGROW>

    if ~isempty(te)
        warning('run_HHK_case:IRE_t2','Irreversible EP detected during t2 at V_stim=%g', V_stim);
        break;
    end
    if any(A_p1_tilda/A1 > FPA_threshold) || any(A_p2_tilda/A2 > FPA_threshold)
        error('run_HHK_case:FPA_t2','FPA threshold exceeded during t2 at V_stim=%g', V_stim);
    end

    Pore1 = [Pore1; floor(y2(end,9)*A1)]; %#ok<AGROW>
    Pore2 = [Pore2; floor(y2(end,10)*A2)]; %#ok<AGROW>
    if floor(y2(end,9)*A1) ~= 0, y2(end,9) = 1.5e9; end
    if floor(y2(end,10)*A2) ~= 0, y2(end,10) = 1.5e9; end

    t2_full = [t2_full; t2]; %#ok<AGROW>
    y2_full = [y2_full; y2(:,1:10)]; %#ok<AGROW>
    y0_2 = [y2(end,:), r_m, r_m];
end

%% -------------------- t3: RC relaxation, dt_RC-sized launches --------------------
for j = 1:number_of_launches_2-1
    [t3, y3, te1, ~, ~] = ode23s(@(t3,y3) dynamics__HH_with_EP_shunt(t3,y3,V_stim*rectangular_input(t3), j+number_of_launches-1, Pore1, Pore2, flag1, flag2), [tspan3(j) tspan3(j+1)], y0_2, opts_pore);

    [~, g_shunt_1, g_shunt_2, A_p1_tilda, A_p2_tilda] = cellfun(@(t3,y3) dynamics__HH_with_EP_shunt(t3,y3.',V_stim*rectangular_input(t3).', j+number_of_launches-1, Pore1, Pore2, flag1, flag2), num2cell(t3), num2cell(y3,2), 'uni', 0);
    g_shunt_1 = cell2mat(g_shunt_1); g_shunt_2 = cell2mat(g_shunt_2);
    A_p1_tilda = cell2mat(A_p1_tilda); A_p2_tilda = cell2mat(A_p2_tilda);

    gshunt_1 = [gshunt_1; g_shunt_1]; gshunt_2 = [gshunt_2; g_shunt_2]; %#ok<AGROW>
    A_p1_full = [A_p1_full; A_p1_tilda]; A_p2_full = [A_p2_full; A_p2_tilda]; %#ok<AGROW>

    if ~isempty(te1)
        warning('run_HHK_case:IRE_t3','Irreversible EP detected during t3 at V_stim=%g', V_stim);
        break;
    end
    if any(A_p1_full/A1 > FPA_threshold) || any(A_p2_full/A2 > FPA_threshold)
        error('run_HHK_case:FPA_t3','FPA threshold exceeded during t3 at V_stim=%g', V_stim);
    end

    Pore1 = [Pore1; floor(y3(end,9)*A1)]; %#ok<AGROW>
    Pore2 = [Pore2; floor(y3(end,10)*A2)]; %#ok<AGROW>
    if floor(y3(end,9)*A1) ~= 0, y3(end,9) = 1.5e9; end
    if floor(y3(end,10)*A2) ~= 0, y3(end,10) = 1.5e9; end

    t3_full = [t3_full; t3]; %#ok<AGROW>
    y3_full = [y3_full; y3(:,1:10)]; %#ok<AGROW>
    y0_2 = [y3(end,:), r_m, r_m];
end

Pore1_formed = Pore1; Pore2_formed = Pore2;

%% -------------------- Absorb pores below threshold at end of t3 --------------------
tolerance = 1e-12;
radius_vec = y3(end,11:end);
radius_vec_DP = radius_vec(1:2:end);
radius_vec_HP = radius_vec(2:2:end);
idx_DP = find((radius_vec_DP <= (abs_pore_threshold+tolerance)) & (radius_vec_DP ~= 0.8e-9));
idx_HP = find((radius_vec_HP <= (abs_pore_threshold+tolerance)) & (radius_vec_HP ~= 0.8e-9));
y3(end,9)  = y3(end,9)  + sum(Pore1(idx_DP))/A1;
y3(end,10) = y3(end,10) + sum(Pore2(idx_HP))/A2;
radius_vec_DP(idx_DP) = 0.8e-9; radius_vec_HP(idx_HP) = 0.8e-9;
radius_vec(1:2:end) = radius_vec_DP; radius_vec(2:2:end) = radius_vec_HP;
y3(end,11:end) = radius_vec;
y3_full(end,:) = y3(end,1:10);
Pore1(idx_DP) = 0; Pore2(idx_HP) = 0;

%% -------------------- t4: long relaxation, with event-driven pore-absorption loop --------------------
if all(Pore1==0) && all(Pore2==0)
    y0 = y3(end,:);
    [t4, y4] = ode23s(@(t4,y4) dynamics__HH_with_EP_shunt(t4,y4,V_stim*rectangular_input(t4), number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), tspan4, y0);
else
    y0 = y3(end,:);
    opts_absorb = odeset('RelTol', tol.RelTol, 'AbsTol', tol.AbsTol, ...
                          'Events', @(t,y) myEventFcnAbsorb_1(t, y, abs_pore_threshold, Pore1, Pore2));
    [t4, y4, te4, ~, ~] = ode23s(@(t4,y4) dynamics__HH_with_EP_shunt(t4,y4,V_stim*rectangular_input(t4), number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), tspan4, y0, opts_absorb);

    if any(y4(end,11:end) > irr_ep_threshold)
        error('run_HHK_case:IRE_t4','Irreversible EP detected during t4 at V_stim=%g', V_stim);
    end

    n_iter = 0; max_iter = 500; % safety cap for the convergence-test harness
    while ~isempty(te4) && n_iter < max_iter
        n_iter = n_iter + 1;
        radius_vec = y4(end,11:end);
        radius_vec_DP = radius_vec(1:2:end); radius_vec_HP = radius_vec(2:2:end);
        idx_DP = find((radius_vec_DP <= (abs_pore_threshold+tolerance)) & (radius_vec_DP ~= 0.8e-9));
        idx_HP = find((radius_vec_HP <= (abs_pore_threshold+tolerance)) & (radius_vec_HP ~= 0.8e-9));
        y4(end,9)  = y4(end,9)  + sum(Pore1(idx_DP))/A1;
        y4(end,10) = y4(end,10) + sum(Pore2(idx_HP))/A2;
        radius_vec_DP(idx_DP) = 0.8e-9; radius_vec_HP(idx_HP) = 0.8e-9;
        radius_vec(1:2:end) = radius_vec_DP; radius_vec(2:2:end) = radius_vec_HP;
        y4(end,11:end) = radius_vec;
        Pore1(idx_DP) = 0; Pore2(idx_HP) = 0;

        if all(Pore1==0) && all(Pore2==0)
            y0 = y4(end,:);
            [t4_new, y4_new] = ode23s(@(t4,y4) dynamics__HH_with_EP_shunt(t4,y4,V_stim*rectangular_input(t4), number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), [te4(1) tspan4(end)], y0);
            t4 = [t4; t4_new]; y4 = [y4; y4_new];
            break;
        end

        y0 = y4(end,:);
        opts_absorb = odeset('RelTol', tol.RelTol, 'AbsTol', tol.AbsTol, ...
                              'Events', @(t,y) myEventFcnAbsorb_1(t, y, abs_pore_threshold, Pore1, Pore2));
        [t4_new, y4_new, te4, ~, ~] = ode23s(@(t4,y4) dynamics__HH_with_EP_shunt(t4,y4,V_stim*rectangular_input(t4), number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), [te4(1)+eps tspan4(end)], y0, opts_absorb);

        if any(y4_new(end,11:end) > irr_ep_threshold)
            error('run_HHK_case:IRE_t4b','Irreversible EP detected during t4 (post-absorption) at V_stim=%g', V_stim);
        end
        if isempty(te4)
            t4 = [t4; t4_new]; y4 = [y4; y4_new];
            break;
        else
            t4 = [t4; t4_new]; y4 = [y4; y4_new];
        end
    end
end

%% -------------------- Assemble output (same layout as HHK_single_pulse.m) --------------------
t_tot = [t1; t2_full; t3_full; t4];
y_tot = [y1; y2_full; y3_full; y4(:,1:10)];

result.t_tot = t_tot;
result.y_tot = y_tot;
result.Pore1_formed = Pore1_formed;
result.Pore2_formed = Pore2_formed;
result.gshunt_1 = gshunt_1;
result.gshunt_2 = gshunt_2;
result.A_p1_full = A_p1_full;
result.A_p2_full = A_p2_full;
result.ton = ton;
result.toff = toff;

end


%% --------------------- Event Functions (unchanged from HHK_single_pulse.m) ---------------------
function [value, isterminal, direction] = myEventFcn(t, y, irr_ep_threshold)
    value = max(y(11:end-2,1)) - irr_ep_threshold;
    isterminal = 1;
    direction = 1;
end

function [value, isterminal, direction] = myEventFcnAbsorb_1(t, y, abs_pore_threshold, Pore1, Pore2)
    Pore_temp_1 = Pore1(1:end-1);
    Pore_temp_2 = Pore2(1:end-1);
    index_Pore1 = find(Pore_temp_1 ~= 0);
    index_Pore2 = find(Pore_temp_2 ~= 0);
    radius_vec = y(11:end);
    radius_vec_DP = radius_vec(1:2:end,1);
    radius_vec_HP = radius_vec(2:2:end,1);
    radius_vec_DP = radius_vec_DP(index_Pore1);
    radius_vec_HP = radius_vec_HP(index_Pore2);
    abs_pore_value = [radius_vec_DP; radius_vec_HP] - abs_pore_threshold;
    value = abs_pore_value;
    isterminal = ones(length(abs_pore_value),1);
    direction = -ones(length(abs_pore_value),1);
end
