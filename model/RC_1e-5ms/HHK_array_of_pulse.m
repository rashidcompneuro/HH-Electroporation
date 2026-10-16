%% ========================================================================
%  SCRIPT: ARRAY OF Vstim SIMULATION – HHK Model 
%
%  Description:
%  This script simulates neuronal excitation coupled with membrane
%  electroporation under an array of applied stimulus Vstim.
%
%  The model integrates:
%     • Hodgkin–Huxley excitation dynamics
%     • Small-pore density evolution (N1, N2)
%     • Pore radius evolution
%
%  RC time constant used:
%     RC = 1e-5 ms
%
%  Required external functions:
%     1. rectangular_input.m
%        -> Generates rectangular pulse input Vstim(t)
%
%     2. dynamics_HH_with_electroporation.m
%        -> Returns time derivatives of:
%             (V1, V2, m1, n1, h1, m2, n2, h2,
%              N1, N2)
%
%     3. dynamics__HH_with_EP_shunt.m
%        -> Returns time derivatives of:
%             (V1, V2, m1, n1, h1, m2, n2, h2,
%              N1, N2, riDP, riHP (i=1 to 20))
%


%  Author: Rashid Ali Faridi
%  Institution: IIT Bombay
%%  ========================================================================
% Reset environment
close all; clear all; clc;

tic

global tp ton toff; % pulse_time, pulse_on_at, pulse_of_at (ms)

%% -------------------- Model Parameters --------------------
%% 1. -------------------- Hodgkin Huxley Parameters --------------------
gk_max = 36; % maximal potassium conductance (mS/cm^2)
gNa_max = 120; % maximal sodium conductance (mS/cm^2)
gL = 0.3; % leaky conductance (mS/cm^2)
E_K = -82; % Potassium nernst potential (mV)
E_Na = 45; % Sodium nernst potential (mV)
E_L = -59; % leaky nernst potential (mV)   

time_constant = 1e-5; % relaxation period - RC (ms)

%% 2. -------------------- Thresholds used Electroporation --------------------
irr_ep_threshold = 100e-9; % Threshold for irreversible electroporation is 100 nm
abs_pore_threshold = 0.83e-9; % Pore gets absorbed into N below this radius
FPA_threshold = 0.0126; % Threshold for FPA, above it sig_eff becomes negative. Pore Formation is not feasible. 

%% 3. -------------------- Size parameters used in Electroporation --------------------
A1 = 1.26e-9/2; % Area of lipid bilayer depolarized-side (m^2)
A2 = 1.26e-9/2; % Area of lipid bilayer hyperpolarized-side (m^2)
r_m = 0.8e-9;   % launching Pore radiust (m)

%% 4. -------------------- Rectangular monopolar pulse (SD) -------------------
%V_stim_values =[17075; 17076];
V_stim_values =[1560;1600;1650;1700; 1750;
               1784; 1800; 1830; 1860; ...                  % around EP onset (4 pts)
                1900; 1940; 1970; 1995];
%V_stim_values = 1485
num_Vstim = length(V_stim_values); 

tp = 1e-4; % Pulse duration (ms)
ton = 5;  % Pulse on (ms)
toff = ton + tp; % Pulse off (ms)

%% 5. -------------------- Flags for EP to get activated --------------------
flag1 = 1; % EP at DP side
flag2 = 1; % EP at HP side

%% 6. -------------------- Simulation Time --------------------
tf = 20000; % total simulation time (ms)

%% 7. -------------------- Time domain discretization --------------------
launch_interval = tp/10; % % subdivisions in pulse duration (t2) (ms)
launch_interval_2 = 1e-6; % subdivisions in RC - (1ns)

number_of_launches = round(tp/launch_interval)+1; % Number of Pore launches in the pulse duration (t2)
number_of_launches_2 = (time_constant)/launch_interval_2 +1; % Number of Pore launches in the relaxation period (t3)
%% 8. -------------------- t1+t2+t3+t4 --------------------
tspan1 = [0 ton]; % Equilibriating period (t1)
tspan2 = [ton: launch_interval: toff]; % Pulse duration (t2)
tspan3 = [toff: launch_interval_2: toff+time_constant]; % Relaxation period after the pulse (t3)
tspan4 = [toff+time_constant tf]; % t4
% poration duration
t_poration = [tspan2(1:end-1) tspan3];

%% -------------------- Preallocate arrays to store results --------------------

all_t_tot = cell(num_Vstim, 1); % cell for storing time vector
all_y_tot = cell(num_Vstim, 1); % cell for storing all the variables vector
all_pores = cell(num_Vstim,1);  % Pore storage
all_gshunt = cell(num_Vstim, 1); % gep (shunt conductance) storage
all_FPA = cell(num_Vstim, 1); % fractional pore area

%see
all_rmax = cell(num_Vstim,1); % maximum pore radii
all_t_rad = cell(num_Vstim,1); 
all_RMAX = zeros(num_Vstim,1)


%%
for v = 1:num_Vstim
    V_stim = V_stim_values(v);

    %--initial condition without evolution of radius.
    y0 = [-70;-70;0.053;0.317;0.596;0.053;0.317;0.596;1.5e9;1.5e9]; 

    % --------------------------- t1 evaluations (Equilibrium Phase) -------------------------------------
    [t1,y1] = ode23s(@(t1,y1) dynamics_HH_with_electroporation(t1,y1,V_stim*rectangular_input(t1), flag1, flag2),tspan1,y0);

    %--Storage t, V,m,n,h and N in t2 and t3 phase
    t2_full = [];  y2_full = []; t3_full = []; y3_full = [];

    y0_2 = [y1(end,:),r_m,r_m]; % Initializing initial condition for t2

    % -------------------- Pore Tracking initialization --------------------
    Pore1 = [floor(y1(end,9)*A1)]; % pores at DP side
    Pore2 = [floor(y1(end,10)*A2)]; % pores at HP side
    
    %--to see
    r_max = [0]; % zeros(length(t1),1);



    % -------------------- Shunt conductance --------------------
    % Since no pores are formed but N1 and N2 evolves
    gep_t1 = 0.0041; % conductance due to lipid fluctuations at RMP
    gshunt_1 = gep_t1*ones(length(t1),1); % gep1 in t1
    gshunt_2 = gep_t1*ones(length(t1),1); % gep2 in t1
    
    % -------------------- Pore Area initialization --------------------
    A_p1_full = zeros(length(t1),1); % No pores in t1 at DP
    A_p2_full = zeros(length(t1),1); % No pores in t1 at HP
    
    % -------------------- t2 evaluations (Pulse duration) --------------------
    
    % Initialize a cell array solutions1 to store the solutions in t2-phase
    solutions1 = cell(1, number_of_launches-1);  % Preallocate based o0n the number of iterations
    
    % -------------------- Solving for 10 subdurations in t2 --------------------
    for i=1:number_of_launches-1
        try
            
            %--Defining tolerences (rel, abs), initial step size, maximum step size,
            %--event for irreversible electroporation detection in the odeset.

            if tp <= 1e-5
                options1 = odeset('RelTol',1e-8,'AbsTol',1e-13,'InitialStep',1e-8,'MaxStep',1e-8,'Events',@(t, y) myEventFcn(t, y, irr_ep_threshold));
            elseif tp < 1e-4  && tp > 1e-5
                options1 = odeset('RelTol',1e-8,'AbsTol',1e-13,'InitialStep',1e-7,'MaxStep',1e-7,'Events',@(t, y) myEventFcn(t, y, irr_ep_threshold));
            elseif tp < 1e-2 && tp >=1e-4
                options1 = odeset('RelTol',1e-8,'AbsTol',1e-12,'InitialStep',1e-6,'MaxStep',1e-6,'Events',@(t, y) myEventFcn(t, y, irr_ep_threshold));
            elseif tp >= 1e-2
                options1 = odeset('RelTol',1e-8,'AbsTol',1e-12,'Events',@(t, y) myEventFcn(t, y, irr_ep_threshold));
            end
            
            %--Solving using ode23s
            [t2, y2,te,ye,ie] = ode23s(@(t2,y2) dynamics__HH_with_EP_shunt(t2,y2,V_stim*rectangular_input(t2), i, Pore1, Pore2, flag1, flag2), [tspan2(i) tspan2(i+1)] , y0_2, options1);

            %--Unpacking shunt conductance and total pore area
            [~, g_shunt_1, g_shunt_2, A_p1_tilda, A_p2_tilda] = cellfun(@(t2, y2) dynamics__HH_with_EP_shunt(t2, y2.', V_stim*rectangular_input(t2).', i, Pore1, Pore2, flag1, flag2), num2cell(t2), num2cell(y2, 2), 'uni', 0);

            % Convert cell arrays to matrices
            g_shunt_1 = cell2mat(g_shunt_1);
            g_shunt_2 = cell2mat(g_shunt_2);
            A_p1_tilda = cell2mat(A_p1_tilda);
            A_p2_tilda = cell2mat(A_p2_tilda);

            % Append results to full arrays
            gshunt_1 = [gshunt_1; g_shunt_1];
            gshunt_2 = [gshunt_2; g_shunt_2];
            A_p1_full = [A_p1_full; A_p1_tilda];
            A_p2_full = [A_p2_full; A_p2_tilda];

            % Check if event occured
            %--Check if event occured (means IRE has occured in t2-phase only)
            if ~isempty(te)
                fprintf('Radius of a pore reached 100 nm at t = %f during the pulse duration.\n Irreversible Electrporation may happen', te);
                break; % exit the for loop
            end
            
            %--Check if Fractional pore area goes above permissible limit
            if any(A_p1_tilda/A1 > FPA_threshold) || any(A_p2_tilda/A2 > FPA_threshold)
                fprintf('Cell destruction: A_p1 or A_p2 exceeded the threshold at time = %f during the pulse duration.\n', t2(find(A_p1_tilda/A1 > FPA_threshold | A_p2_tilda/A2 > FPA_threshold, 1)));
                return;
            end


        catch ME
            fprintf('Error occurred in pulse duration phase (t2): %s\n', ME.message);
            break; % Exit the for loop if there's an error
        end
        
        %--Pore tracking
        %--Pores formed after the subduration is appended into pore1 and pore2
        Pore1 = [Pore1; floor(y2(end,9)*A1)];    
        Pore2 = [Pore2; floor(y2(end,10)*A2)] 


        %--Resetting the Pore Densities to N_0 after launching pores
        %--DP side
        if floor(y2(end,9)*A1) ~= 0
            y2(end,9) = 1.5e9;
        end

        %--HP side
        if floor(y2(end,10)*A2) ~= 0
            y2(end,10) = 1.5e9;
        end
        
        %--Stacking all t2 and y2 for each iteration
        t2_full = [t2_full; t2];
        y2_full = [y2_full; [y2(:,1:10)]];
    
        %--Resetting the initial condition for odesolver after each iteration
        y0_2 = [ y2(end,:), r_m, r_m];
       

        %--Putting all the solutions of each iterations in a cell solutions1
        solutions1{i} = [t2, y2];

        % Saving of rmean and rmax during the pulse and post pulse relaxation
        r_max = [r_max; max(y2(end,11:end))];




        launched_events = i+1   % Launched events
    end
    % -------------------- t3 evaluations (RC duration) --------------------

    % Initialize a cell array solutions2 to store the solutions in t3-phase
    solutions2 = cell(1, number_of_launches_2 + number_of_launches-2);  % Preallocate based on the number of iterations
    
    %--Defining tolerences (rel, abs), initial step size, maximum step size,
    %--event for irreversible electroporation detection in the odeset.
    if time_constant == 1e-3
        options3 = odeset('RelTol',1e-8,'AbsTol',1e-12,'InitialStep',1e-6,'MaxStep',1e-6,'Events',@(t, y) myEventFcn(t, y, irr_ep_threshold)); % options for t3
    elseif time_constant == 1e-5 || time_constant == 1e-4
        options3 = odeset('RelTol',1e-8,'AbsTol',1e-12,'InitialStep',1e-8,'MaxStep',1e-8,'Events',@(t, y) myEventFcn(t, y, irr_ep_threshold)); % options for t3
    end
    
    % -------------------- Solving for 10 subdurations in t3 --------------------
    for j=1:number_of_launches_2-1
        try
            %--Solving using ode23s
            [t3, y3,te1,ye1,ie1] = ode23s(@(t3,y3) dynamics__HH_with_EP_shunt(t3,y3,V_stim*rectangular_input(t3), j+number_of_launches-1, Pore1, Pore2, flag1, flag2), [tspan3(j) tspan3(j+1)] , y0_2, options3);
            
            %--Unpacking shunt conductance and total pore area
            [~,g_shunt_1, g_shunt_2, A_p1_tilda, A_p2_tilda] = cellfun(@(t3,y3)  dynamics__HH_with_EP_shunt(t3,y3.',V_stim*rectangular_input(t3).', j+number_of_launches-1, Pore1, Pore2, flag1, flag2), num2cell(t3), num2cell(y3,2),'uni',0);


            % Convert cell arrays to matrices
            g_shunt_1 = cell2mat(g_shunt_1);
            g_shunt_2 = cell2mat(g_shunt_2);
            A_p1_tilda = cell2mat(A_p1_tilda);
            A_p2_tilda = cell2mat(A_p2_tilda);

            % Append results to full arrays
            gshunt_1 = [gshunt_1; g_shunt_1];
            gshunt_2 = [gshunt_2; g_shunt_2];
            A_p1_full = [A_p1_full; A_p1_tilda];
            A_p2_full = [A_p2_full; A_p2_tilda];


            %--Check if event occured (means IRE has occured in t2-phase only)
            if ~isempty(te1)
                fprintf('Radius of a pore reached 100 nm at t = %f in RC relaxation.\n Irreversible Electrporation may happen', te1);
                break; % exit the for loop-1
            end

            %--Check if Fractional Pore Area goes above permissible limit
            if any(A_p1_full/A1 > FPA_threshold ) || any(A_p2_full/A2 > FPA_threshold)
                fprintf('Cell destruction: A_p1 or A_p2 exceeded the threshold at time = %f during RC relaxation.\n', t3(find(A_p1_tilda/A1 > FPA_threshold | A_p2_tilda/A2 > FPA_threshold, 1)));
                fprintf('FPA1: %f.\n',A_p1_full(end)/A1);
                fprintf('FPA2: %f.\n',A_p2_full(end)/A2);
                return;
            end


        catch ME
            fprintf('Error occurred in RC relaxation (t3): %s\n', ME.message);
            break; % Exit the for loop if there's an error
        end


        %--Pore tracking
        %--Pores formed after the subduration is appended into pore1 and pore2
        Pore1 = [Pore1; floor(y3(end,9)*A1)];   
        Pore2 = [Pore2; floor(y3(end,10)*A2)]; 

        %--Resetting the Pore Densities to N_0 after launching pores
        %--DP side
        if floor(y3(end,9)*A1) ~= 0
        y3(end,9) = 1.5e9;
        end

        %--HP side
        if floor(y3(end,10)*A2) ~= 0
        y3(end,10) = 1.5e9;
        end
        

        %--Stacking all t3 and y3 for each iteration
        t3_full = [t3_full; t3];
        y3_full = [y3_full; y3(:,1:10)];

        %--Putting all the solutions of each iterations in a cell solutions2
        solutions2{j} = [t3, y3];

        %--Resetting the initial condition for odesolver after each iteration
        y0_2 = [y3(end,:),r_m,r_m];

        % Saving of rmean and rmax during the pulse and post pulse relaxation
        r_max = [r_max; max(y3(end,11:end))];





        launched_events= number_of_launches+j % launched events
    end

    % --------- Store the pores formed into a dummy variable ---------------------------
    Pore1_formed = Pore1; Pore2_formed = Pore2; % for book keeping

    % -------- Absorb any pores in to N if they have gone below 0.83 nm after t3 ------------------
    tolerance = 1e-12;

    %---------------------- Update pore population for absorption ----------------------------------
    radius_vec = y3(end,11:end); % radius vector
    radius_vec_DP = radius_vec(1:2:length(radius_vec));% at DP side
    radius_vec_HP = radius_vec(2:2:length(radius_vec)); % at HP side
    
    %--index of launched pores goes below abs but not equal to 0.8nm
    idx_DP = find((radius_vec_DP <= (abs_pore_threshold+  tolerance)) & (radius_vec_DP ~= 0.8e-9)) % DP side
    idx_HP = find((radius_vec_HP <= (abs_pore_threshold + tolerance)) & (radius_vec_HP ~= 0.8e-9))% HP side
    
    %--Converting Large pores into small pore pop.
    y3(end,9) = y3(end,9) + sum(Pore1(idx_DP))/A1; % DP side
    y3(end,10) = y3(end,10) + sum(Pore2(idx_HP))/A2; % HP side
    
    %--Replacing the absorbed pore with 0.8nm
    radius_vec_DP(idx_DP) = 0.8e-9; % DP side
    radius_vec_HP(idx_HP) = 0.8e-9; % HP side
    
    %--Updating radius vector
    radius_vec(1:2:end) =  radius_vec_DP;
    radius_vec(2:2:end) =  radius_vec_HP;
    
    %--All the pores whose radius fell below 0.83 nm absorbed and replaced by 0.8 nm
    y3(end, 11:end) = radius_vec; % Renewed radius vector after adaptation
    
    %--updating the last entry of t3
    solutions2{10} = [t3, y3];

    y3_full(end,:) = y3(end,1:10); % update y3_full

    %--resetting initial conditions
    y0_2 = [y3(end,:),r_m,r_m];


    %--Corresponding pores are removed from Large pore population
    Pore1(idx_DP) = 0; % Absorbing those pores
    Pore2(idx_HP) = 0; %Absorbing those pores


    %--Check if all elements of Pore1 and Pore2 are zero
    %--If all the large pores are absorbed into small pore pop. at both ends, run t4.
    if all(Pore1 == 0) && all(Pore2 == 0)
        disp('All elements of Pore1 and Pore2 are zero after t3. Exiting the loop.');

        %--Integration in t4
        %--Initial conditions for t4
        y0 = y3(end, :);
        %--Solving using ode23s
        [t4, y4] = ode23s(@(t4, y4) dynamics__HH_with_EP_shunt(t4, y4, V_stim * rectangular_input(t4),number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), tspan4, y0);

        %--Unpacking shunt conductance and total pore area
        [~,g_shunt_1, g_shunt_2, A_p1_tilda, A_p2_tilda] = cellfun(@(t4,y4)  dynamics__HH_with_EP_shunt(t4,y4.',V_stim*rectangular_input(t4).', number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), num2cell(t4), num2cell(y4,2),'uni',0);

        %--Convert cell arrays to matrices
        g_shunt_1 = cell2mat(g_shunt_1);
        g_shunt_2 = cell2mat(g_shunt_2);
        A_p1_tilda = cell2mat(A_p1_tilda);
        A_p2_tilda = cell2mat(A_p2_tilda);

        %--Append results to full arrays
        gshunt_1 = [gshunt_1; g_shunt_1];
        gshunt_2 = [gshunt_2; g_shunt_2];
        A_p1_full = [A_p1_full; A_p1_tilda];
        A_p2_full = [A_p2_full; A_p2_tilda];
    end

    %--If some large pores are above 0.83 nm, after t3, they are allowed to shrink 
    %-- The pores may either be in DP or HP side. 
    if any(Pore1~=0) || any(Pore2~=0)

        %Integrate over tspan4 with absorbing pore condition
        y0 = y0_2(1,1:end-2); % initial conditions for t4

        %--event for pores shrinking below 0.83 nm in the odeset.
        options_absorb_1 = odeset('RelTol',1e-8,'AbsTol',1e-12,'Events', @(t, y) myEventFcnAbsorb_1(t, y, abs_pore_threshold, Pore1, Pore2));

        %--Solving using ode23s - 1
        [t4,y4, te4, ye4, ie4] = ode23s(@(t4,y4) dynamics__HH_with_EP_shunt(t4,y4,V_stim*rectangular_input(t4),number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2),tspan4,y0, options_absorb_1);

        %--Unpacking shunt conductance and total pore area
        [~,g_shunt_1, g_shunt_2, A_p1_tilda, A_p2_tilda] = cellfun(@(t4,y4)  dynamics__HH_with_EP_shunt(t4,y4.',V_stim*rectangular_input(t4).', number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), num2cell(t4), num2cell(y4,2),'uni',0);

        %--Convert cell arrays to matrices
        g_shunt_1 = cell2mat(g_shunt_1);
        g_shunt_2 = cell2mat(g_shunt_2);
        A_p1_tilda = cell2mat(A_p1_tilda);
        A_p2_tilda = cell2mat(A_p2_tilda);

        %--Append results to full arrays
        gshunt_1 = [gshunt_1; g_shunt_1];
        gshunt_2 = [gshunt_2; g_shunt_2];
        A_p1_full = [A_p1_full; A_p1_tilda];
        A_p2_full = [A_p2_full; A_p2_tilda];

        %--storing the first absorbing event before entering the while loop
        te4_all= [te4]; % storing the first absorbing event before entering the while loop

        %--variable to store
        t4_new = t4; y4_new = y4;

        %--Manually putting the condition for detecting irreversible EP
        %--Check if any pore goes beyond 100 nm in the t4 time.
        if any(y4(end,11:end) > irr_ep_threshold)
            fprintf('Cell destruction1: Irreversible electroporation as one of pore radius goes beyond 100nm at time = t4');
            return;
        end

        tolerance = 1e-12; % tolerance/error for radius values

        %--Handle absorbing events:
        while ~isempty(te4)
            %--Update pore population for absorption
            radius_vec = y4(end, 11:end); % radius vector
            radius_vec_DP = radius_vec(1:2:length(radius_vec));% at DP side
            radius_vec_HP = radius_vec(2:2:length(radius_vec)); % at HP side

            %--index of launched pores goes below abs but not equal to 0.8nm
            idx_DP = find((radius_vec_DP <= (abs_pore_threshold+  tolerance)) & (radius_vec_DP ~= 0.8e-9)); 
            idx_HP = find((radius_vec_HP <= (abs_pore_threshold + tolerance)) & (radius_vec_HP ~= 0.8e-9));
            
            %--Convering Large pores into small pore pop.
            y4(end,9) = y4(end,9) + sum(Pore1(idx_DP))/A1; 
            y4(end,10) = y4(end,10) + sum(Pore2(idx_HP))/A2; 
 
            %--Replacing the absorbed pore with 0.8nm
            radius_vec_DP(idx_DP) = 0.8e-9; 
            radius_vec_HP(idx_HP) = 0.8e-9;

            %--Updating radius vector
            radius_vec(1:2:end) =  radius_vec_DP;
            radius_vec(2:2:end) =  radius_vec_HP;

            y4(end, 11:end) = radius_vec; % Renewed radius vector after adaptation

            Pore1(idx_DP) = 0; % Absorbing those pores
            Pore2(idx_HP) = 0; %Absorbing those pores



            %--Check if all elements of Pore1 and Pore2 are zero
            %--If all the large pores are absorbed into small pore pop. at both ends, run t4.
            if all(Pore1 == 0) && all(Pore2 == 0)
                disp('All elements of Pore1 and Pore2 are zero during t4. Exiting the loop.');

                %--Integration from the last event till the end of t4.
                %--Initial conditions for t4
                y0 = y4(end, :);
                %--Solving using ode23s - 2
                [t4_new, y4_new] = ode23s(@(t4, y4) dynamics__HH_with_EP_shunt(t4, y4, V_stim * rectangular_input(t4),number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), [te4(1) tspan4(end)], y0);

                %--Unpacking shunt conductance and total pore area
                [~,g_shunt_1, g_shunt_2, A_p1_tilda, A_p2_tilda] = cellfun(@(t4,y4)  dynamics__HH_with_EP_shunt(t4,y4.',V_stim*rectangular_input(t4).', number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), num2cell(t4_new), num2cell(y4_new,2),'uni',0);

                %--Convert cell arrays to matrices
                g_shunt_1 = cell2mat(g_shunt_1);
                g_shunt_2 = cell2mat(g_shunt_2);
                A_p1_tilda = cell2mat(A_p1_tilda);
                A_p2_tilda = cell2mat(A_p2_tilda);

                %--Append results to full arrays
                gshunt_1 = [gshunt_1; g_shunt_1];
                gshunt_2 = [gshunt_2; g_shunt_2];
                A_p1_full = [A_p1_full; A_p1_tilda];
                A_p2_full = [A_p2_full; A_p2_tilda];

                t4 = [t4; t4_new];
                y4 = [y4; y4_new];
                break;
            end

            %--Continue integration from the last point if pore absorption detected
            %--Initial condition
            y0 = y4(end, :); 

            %--Defining tolerences (rel, abs), event for pore absorption detection in the odeset.
            options_absorb_1 = odeset('RelTol',1e-8,'AbsTol',1e-12,'Events', @(t, y) myEventFcnAbsorb_1(t, y, abs_pore_threshold, Pore1, Pore2));
            
            %--Solving using ode23s - 3
            [t4_new, y4_new, te4, ye4, ie4] = ode23s(@(t4, y4) dynamics__HH_with_EP_shunt(t4, y4, V_stim * rectangular_input(t4),number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), [te4(1)+eps tspan4(end)], y0, options_absorb_1);
            
            %--Unpacking shunt conductance and total pore area
            [~,g_shunt_1, g_shunt_2, A_p1_tilda, A_p2_tilda] = cellfun(@(t4,y4)  dynamics__HH_with_EP_shunt(t4,y4.',V_stim*rectangular_input(t4).', number_of_launches+number_of_launches_2-2, Pore1(1:end-1), Pore2(1:end-1), flag1, flag2), num2cell(t4_new), num2cell(y4_new,2),'uni',0);

            %--Convert cell arrays to matrices
            g_shunt_1 = cell2mat(g_shunt_1);
            g_shunt_2 = cell2mat(g_shunt_2);
            A_p1_tilda = cell2mat(A_p1_tilda);
            A_p2_tilda = cell2mat(A_p2_tilda);

            %--Append results to full arrays
            gshunt_1 = [gshunt_1; g_shunt_1];
            gshunt_2 = [gshunt_2; g_shunt_2];
            A_p1_full = [A_p1_full; A_p1_tilda];
            A_p2_full = [A_p2_full; A_p2_tilda];

            %--printing event detection time
            te4

            %--Stacking all the pore absorbing time events
            te4_all=[te4_all; te4] % stacking all the pore absorbing time events

            %--Check if any pore goes beyond 100 nm in the t4 time.
            if any(y4_new(end,11:end) > irr_ep_threshold)
                fprintf('Cell destruction2: Irreversible electroporation as one of pore radius goes beyond 100nm at time = t4');
                return;
            end

            %--if pores absorb events happens only gets stacked. Else upper if-else statement takes care
            if isempty(te4)
                t4 = [t4; t4_new];   % keep the last piece (last absorption event to tf)
                y4 = [y4; y4_new];
                break;
            else
                t4 = [t4; t4_new];
                y4 = [y4; y4_new];
            end

        end

    end
    
   


    % t and y appended across all time span of integration
    t_tot=[t1;t2_full;t3_full; t4];
    y_tot=[y1;y2_full;y3_full; y4(:,1:10)];

    %--rmax in t4 phase
    radius_vector_t4 = y4(:,11:end);
    id = t4 <= 2e4;
    r_max4 = zeros(length(y4(id)),1);

    for i = 1: length(y4(id))
        r_max4(i) = max(radius_vector_t4(i,:));
    end

    % time after the pulse
    t_rad = [tspan2(1:end-1)'-5; tspan3'-5;t4(id)-5]*1e6; % time in ns
    %t_rad = [tspan2(1:end-1)'; tspan3'];
    
    %--finding maximum radius of the pore
    r_max_total = [r_max; r_max4]; % appending the maximum radius 
    RMAX = max(r_max_total)
    all_RMAX(v) = RMAX;
    
    %--fractional pore area for the stimulus
    FPA = [A_p1_full/A1 A_p2_full/A2];
    
    % this is to find max FPA happens at which end (DP or HP)
    [maxFPA, ~] = max(FPA(:)) % Get max value
    [row_fpa, col_fpa] = find(FPA == maxFPA) % Find all occurrences



    %--Concatenate all results for a given stimulus index 'v'
    all_t_tot{v} = t_tot; % storing the time data discretization of stimulation
    all_y_tot{v} = y_tot; % all the 50 variables
    all_pores{v} = [cumsum(Pore1_formed) cumsum(Pore2_formed)]; % Pore Formed in the poration duration
    all_gshunt{v} = [gshunt_1 gshunt_2]; % shunt conductance 
    all_FPA{v} = [A_p1_full/A1 A_p2_full/A2]; % FPA evolution
    all_rmax{v} = [r_max_total]; % i don't this is being used
    all_t_rad{v} = [t_rad]; % % i don't this is being used
end
toc 
%

%%
figure(1)
hold on
for v = 1:num_Vstim
    plot(all_t_tot{v}, all_y_tot{v}(:,1), 'DisplayName', sprintf('V_{stim} = %d mV', V_stim_values(v)),LineWidth=1.5);
end
%yline(-40, '--r', '$-40$ mV', 'Interpreter', 'latex', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left');
%xline(5, '--k', LineWidth=1.2)
text(5.5,1000,'Pulse at 5 ms', 'FontSize',12)
xlabel('time($ms$)',Interpreter='latex',FontSize=10);
ylabel('$V_1($mV$)$', Interpreter='latex',FontSize=14);
%title('Membrane Potential at DP side vs time',Interpreter='latex',FontSize=12);
legend show;


%grid on
set(gca, 'FontSize', 12); % Set axes font size
%set(gca, 'XScale', 'log');  % Set x-axis to logarithmic scale
% Adjust figure properties for high-quality output
set(gcf, 'PaperUnits', 'inches');       % Set units to inches

xlim([4 18])
ylim([-100 100])
set(gcf, 'PaperPosition', [0 0 6 4]);   % Set the figure size [left, bottom, width, height]

%% --------------------- Event Functions to detect Irreversible Electroporation only ---------
function [value, isterminal, direction] = myEventFcn(t, y,irr_ep_threshold )
    %--Event function to stop the integration when y(1) exceeds threshold
    value = max(y(11:end-2,1)) - irr_ep_threshold; % When maximum radius exceeds threshold, value crosses zero
    isterminal = 1; % Stop the integration
    direction = 1; % Detect zero crossing in the positive direction

    % Print message when event is triggered
    if value >= 0
        disp('Irreversible electroporation');
    end

end


%% --------------------- Event Functions to detect pore going below absorption threshold (0.83 nm) ---------
function [value, isterminal, direction] = myEventFcnAbsorb_1(t, y, abs_pore_threshold, Pore1, Pore2)
    
   %--Event function to detect pore absorption
    Pore_temp_1 = Pore1(1:end-1); % Temporary assigning
    Pore_temp_2 = Pore2 (1:end-1); 

    index_Pore1 = find(Pore_temp_1 ~=0);
    index_Pore2 = find(Pore_temp_2 ~=0);

    radius_vec = y(11:end); % radius vector
    radius_vec_DP = radius_vec(1:2:length(radius_vec),1);% at DP side
    radius_vec_HP = radius_vec(2:2:length(radius_vec),1); % at HP side

    radius_vec_DP = radius_vec_DP(index_Pore1) ;
    length_r_DP = length(radius_vec_DP);
    radius_vec_HP = radius_vec_HP(index_Pore2);
    length_r_HP = length(radius_vec_HP);

    % Check for pore absorption
    abs_pore_value = [radius_vec_DP; radius_vec_HP] - abs_pore_threshold; % When min pore radius goes below threshold

    % Define value, isterminal, and direction for event detection
    value = abs_pore_value;
    isterminal = ones(length(abs_pore_value),1); % Halt the integration
    direction = -ones(length(abs_pore_value),1); % Detect zero crossing in the negative direction

   

    % Print message when event is triggered
    if value <= 0
        disp('Pore absorption detected.');
    end
end


