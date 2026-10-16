%% ========================================================================
%  SCRIPT: SINGLE V_stim SIMULATION - HH model without electroporation
%
%  Classical Hodgkin-Huxley model of the planar two-membrane cell (side 1 =
%  depolarised, side 2 = hyperpolarised), used as the EP-free reference in
%  the paper: HH-only traces in Fig 6 and S9-S11 Figs, and the HH-only
%  strength-duration curve in S6 Fig (one run per pulse duration and V_stim).
%  Originally HH_planar_breakode23s_3region.m.
%
%  Phases: rest (0 to ton), pulse (ton to ton + tp), relaxation (to tf).
%  Set V_stim (mV), tp (ms) and tf (ms) below.
%
%  The cell's RC is set by R in dynamics_HH.m (R = 10^-3 -> RC = 1e-6 s,
%  the S6 Fig cell). For the RC = 1e-8 s traces (Fig 6, S9-S11 Figs) set
%  R = 10^-5 there first.
%
%  Required: dynamics_HH.m, rectangular_input.m (this folder).
%  Results are left in the workspace as t_tot and y_tot (columns V1, V2,
%  m1, n1, h1, m2, n2, h2).
%% ========================================================================
clc;close all
clear all
% tic
% Initial conditions and total time span
y0=[-70;-70;0.053;0.317;0.596;0.053;0.317;0.596]; %initial condition; % 
 
global tp ton toff;
tp = 0.0001; % Pulse duration
ton = 5;  toff=ton+tp;

V_stim = 1500; % mV
tf=60; % Inegration time 

tspan1=[0 ton];
tspan2=[ton toff];
tspan3=[toff tf];

options1=odeset('RelTol',1e-8,'AbsTol',1e-12,'InitialStep',1e-9,'MaxStep',1e-9,'Stats','on');
options2=odeset('RelTol',1e-6,'AbsTol',1e-4,'InitialStep',1e-5,'MaxStep',1e-5 );
options2A=odeset('RelTol',1e-7,'AbsTol',1e-5,'InitialStep',1e-6,'MaxStep',1e-6 );
options2B=odeset('RelTol',1e-7,'AbsTol',1e-5,'InitialStep',1e-7,'MaxStep',1e-7 );
options3 = odeset('Stats','on')
%
[t1,y1] = ode23s(@(t1,y1) dynamics_HH(t1,y1,V_stim*rectangular_input(t1)),tspan1,y0);


[t2,y2] = ode23s(@(t2,y2) dynamics_HH(t2,y2,V_stim*rectangular_input(t2)),tspan2,y1(end,:));
stats = odeset('Stats','on');
%

[t3,y3] = ode23s(@(t3,y3) dynamics_HH(t3,y3,V_stim*rectangular_input(t3)),tspan3,y2(end,:),options3);

t_tot=[t1;t2;t3];
y_tot=[y1;y2;y3];


%%

%save('HH_18V','y_tot_HH','t_tot_HH')
figure(1)
subplot(3,1,1);
plot(t_tot,y_tot(:,1),t_tot,y_tot(:,2),LineWidth=1.5);
xlabel('time($mS$)',Interpreter='latex',FontSize=10);
ylabel('$V($mV$)$', Interpreter='latex',FontSize=14);
title('Membrane Potential vs time',Interpreter='latex',FontSize=12);
legend('V1','V2');
grid on

subplot(3,1,2);
plot(t_tot,y_tot(:,3),t_tot,y_tot(:,4),t_tot,y_tot(:,5),LineWidth=1.5);
xlabel('time($mS$)',Interpreter='latex',FontSize=10);
ylabel('$parameters$', Interpreter='latex',FontSize=14);
title('parameters vs time',Interpreter='latex',FontSize=12);
legend('m','n','h');
grid on

subplot(3,1,3);
plot(t_tot,y_tot(:,6),t_tot,y_tot(:,7),t_tot,y_tot(:,8),LineWidth=1.5);
xlabel('time($mS$)',Interpreter='latex',FontSize=10);
ylabel('$parameters$', Interpreter='latex',FontSize=14);
title('parameters vs time',Interpreter='latex',FontSize=12);
legend('m','n','h');
grid on
%%
figure(2)
plot(t_tot,y_tot(:,1),t_tot,y_tot(:,2),LineWidth=1.5);
xlabel('time($mS$)',Interpreter='latex',FontSize=10);
ylabel('$V($mV$)$', Interpreter='latex',FontSize=14);
title('Membrane Potential vs time',Interpreter='latex',FontSize=12);
legend('V1','V2');
%ylim([-100 100])
xlim([0 30])
% 
% 
% % Get axis position in normalized figure units
% ax = gca;
% axpos = ax.Position;   % [x y width height]
% 
% % Compute normalized x-position of t=5 on the axis
% x_lim = xlim;
% xn = axpos(1) + (5 - x_lim(1)) / (x_lim(2)-x_lim(1)) * axpos(3);
% 
% % Arrow tail BELOW the axis, outside plot
% xn_tail = xn - 0.07;               % left shift for angle
% yn     = axpos(2);                 % x-axis in normalized units
% yn_tail = yn - 0.07;               % below the axis
% 
% % Draw the arrow
% annotation('arrow', [xn_tail xn], [yn_tail yn], ...
%            'Color','r','LineWidth',1.6,'HeadLength',10,'HeadWidth',10);
% grid on
% %%
% figure(3)
% plot(t_tot,y_tot(:,3),t_tot,y_tot(:,4),t_tot,y_tot(:,5),LineWidth=1.5);
% xlabel('time($mS$)',Interpreter='latex',FontSize=10);
% ylabel('$parameters$', Interpreter='latex',FontSize=14);
% title('Channel dynamics of depolarized membrane',Interpreter='latex',FontSize=12);
% legend('m','n','h');
% grid on
% 
% figure(4)
% plot(t_tot,y_tot(:,6),t_tot,y_tot(:,7),t_tot,y_tot(:,8),LineWidth=1.5);
% xlabel('time($mS$)',Interpreter='latex',FontSize=10);
% ylabel('$parameters$', Interpreter='latex',FontSize=14);
% title('Channel dynamics of hyperpolarized membrane',Interpreter='latex',FontSize=12);
% legend('m','n','h');
% grid on


%% Saving data code (Uncomment for saving HH data)
% % saving the data into a new variable
% t_tot_1ns_15500mV_HH = t_tot; 
% y_tot_1ns_15500mV_HH = y_tot;
% 
% % saving to directory as .MAT FILE
% folder_path = [project_root '/data/raw/excitation_data/'];
% filename = ['HH_1ns_15500mV.mat'];
% fullpath =fullfile(folder_path, filename);
% 
% save(fullpath,"y_tot_1ns_15500mV_HH","t_tot_1ns_15500mV_HH");
%%
