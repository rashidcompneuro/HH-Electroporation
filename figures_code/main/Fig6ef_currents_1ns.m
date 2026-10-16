addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
%% Plotting Ionic and EP-current
%% RC=1e-5 ms (1e-8s) for 10ns pulse

clear all;
clc;
%%
% Loading the data
% load the 1ns excitation data (14500 mV) HH
load([project_root '/data/raw/excitation_data/HH_1ns_14500mV.mat'])
% load the 1ns excitation data (15500 mV) HH
load([project_root '/data/raw/excitation_data/HH_1ns_15500mV.mat'])

% load the HHK data for 1 ns (13457mV, 14500 mV and 15500 mV)
load([project_root '/data/raw/1ns_RC_1e5/HHK_1ns_1e5.mat'])

%% Maximal conductances and Nernst Potentials
gNa_max = 120;   % mS/cm^2 (example, adjust to your model)
gK_max  = 36;    % mS/cm^2

ENa = 45;        % mV
EK  = -82;       % mV
%Eep = 0;         % mV, electroporation reversal
%% Both regimes: 'RS' -> Fig 6e (Vstim = 14500 mV), 'DB' -> Fig 6f (Vstim = 15500 mV)
for regime_c = {'RS', 'DB'}
regime = regime_c{1};
%% (A) unpack the variables
if strcmp(regime, 'RS')
    t1 = t_tot_1ns_14500mV_HH;  y1 = y_tot_1ns_14500mV_HH; % HH
    k  = 2;                                                % HHK run index
    panel = 'e';
else
    t1 = t_tot_1ns_15500mV_HH;  y1 = y_tot_1ns_15500mV_HH; % HH
    k  = 3;
    panel = 'f';
end
t2 = all_t_tot{k}; y2 = all_y_tot{k}; % HHK
%% Extract variables
% HH-model 
V1_HH = y1(:,1);  V2_HH = y1(:,2); % Membrane potential
m1_HH = y1(:,3);  n1_HH = y1(:,4);  h1_HH = y1(:,5); % DP side
m2_HH = y1(:,6);  n2_HH = y1(:,7);  h2_HH = y1(:,8); % HP side

% HHK-model
V1_HHK = y2(:,1); V2_HHK = y2(:,2); % membrane potential
m1_HHK = y2(:,3); n1_HHK = y2(:,4); h1_HHK = y2(:,5); % DP side
m2_HHK = y2(:,6); n2_HHK = y2(:,7); h2_HHK = y2(:,8); % HP side

%% Electroporation current RS (example, assuming gep available)
% gep1_HH, gep1_HHK must come from your pore dynamics

% EP current at HP side
gshunt = all_gshunt{k};
Iep2_HHK = gshunt(:,2) .* (V2_HHK); % Ep current at HP side

%% Conductance
gNa2_HH = gNa_max .* (m2_HH.^3) .* h2_HH;
gK2_HH  = gK_max  .* (n2_HH.^4);

gNa2_HHK = gNa_max .* (m2_HHK.^3) .* h2_HHK;
gK2_HHK  = gK_max  .* (n2_HHK.^4);

%% Currents
INa2_HH = gNa2_HH .* (V2_HH - ENa);
IK2_HH  = gK2_HH  .* (V2_HH - EK);

INa2_HHK = gNa2_HHK .* (V2_HHK - ENa);
IK2_HHK  = gK2_HHK  .* (V2_HHK - EK);

% Electroporation current (example, assuming gep available)
% gep1_HH, gep1_HHK must come from your pore dynamics

%Iep2_HHK = gshunt2 .* (V2_HHK);

%% Plot Ionic current at HP side
figure; clf; hold on

cmap = lines(4);  % consistent colors for Na and K

% gNa

plot(t2, INa2_HHK, '-', 'Color', cmap(1,:), 'LineWidth', 2); 
plot(t1, INa2_HH,  '--', 'Color', cmap(1,:), 'LineWidth', 2);
% gK
plot(t2, IK2_HHK,  '-', 'Color', cmap(2,:), 'LineWidth', 2);
plot(t1, IK2_HH,   '--', 'Color', cmap(2,:), 'LineWidth', 2);

plot(t2, Iep2_HHK,   '-', 'Color', cmap(4,:), 'LineWidth', 2);

%xline(5,'--k','LineWidth',1);
% Labels and formatting
xlabel('time (ms)', 'Interpreter','latex', 'FontSize', 18);
ylabel(' Current at HP side ($\mu$A/cm$^2$)', 'Interpreter','latex', 'FontSize', 18);
legend({'$I_{\mathrm{Na}}$ HHK', ...
        '$I_{\mathrm{Na}}$ HH', ...
        '$I_{\mathrm{K}}$ HHK', ...
        '$I_{\mathrm{K}}$ HH', ...
        '$I_{\mathrm{ep}}$ HHK'}, ...
       'Interpreter','latex','FontSize',18, ...
       'Box','off','Location','best','NumColumns',3);
if strcmp(regime, 'RS')
    ylim([-1.5e4 0.2e4]);   % Fig 6e
else
    ylim([-6.2e5 0.2e5]);   % Fig 6f
end
xlim([0 50]);
grid on;
%set(gca,'FontSize',25,'FontName','Times','LineWidth',1);
ax = gca;
ax.XAxis.Exponent = 0;
ax.YAxis.Exponent = 5;
% vertical line at pulse onset
set(gca, 'FontSize', 12); 
set(gcf, 'PaperUnits', 'inches');      
set(gcf, 'PaperPosition', [0 0 6 4]);   

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.01 0.01])
%%
% Get axis position in normalized figure units
ax = gca;
axpos = ax.Position;   % [x y width height]

% Compute normalized x-position of t=5 on the axis
x_lim = xlim;
xn = axpos(1) + (5 - x_lim(1)) / (x_lim(2)-x_lim(1)) * axpos(3);

% Arrow tail BELOW the axis, outside plot
xn_tail = xn - 0.00;               % left shift for angle
yn     = axpos(2);                 % x-axis in normalized units
yn_tail = yn - 0.07;               % below the axis

% Draw the arrow
annotation('arrow', [xn_tail xn], [yn_tail yn], ...
           'Color','r','LineWidth',1.6,'HeadLength',10,'HeadWidth',10);

%% Inset: zoom on pulse window
tp = 1e-6; % your pulse duration
inset = axes('Position',[0.55 0.55 0.40 0.40]); % [x y width height]
hold(inset, 'on');


% Repeat same plots inside inset
plot(inset,t2, INa2_HHK, '-', 'Color', cmap(1,:), 'LineWidth', 2);
plot(inset,t1, INa2_HH,  '--', 'Color', cmap(1,:), 'LineWidth', 2);

plot(inset,t2, IK2_HHK,  '-', 'Color', cmap(2,:), 'LineWidth', 2);
plot(inset,t1, IK2_HH,   '--', 'Color', cmap(2,:), 'LineWidth', 2);
plot(inset,t2, Iep2_HHK,   '-', 'Color', cmap(4,:), 'LineWidth', 2);

%xline(5,'--k','LineWidth',1);
% inset limits
xlim(inset,[4 30]);
ylim(inset,[-1500 1200]);

% vertical line at pulse onset

set(inset, 'FontSize', 22, ...
    'FontName', 'Times', ...
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on');

%
%%  saving the fig file as PDF
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path(['main/Fig6' panel '.pdf']);


% Save as PDF
finish_figure(h, save_path);

close all
end  % regime loop
