addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%% ================================================================
%  FIGURE 2 (main manuscript): AP features vs V_stim, HH vs HHK
%  Panels: (a) spike latency  (b) T50%  (c) AP amplitude (peak V)
%
%  Reads directly from AP_metrics_summary.mat, produced by
%  S07_Table_AP_metrics.m -- no re-simulation needed.
%
%  Styling follows Fig6bcd_AP_features_1ns.m: HHK = solid black line, HH = dashed black
%  line, open diamond markers (red edge) mark the HHK curve, open square
%  markers (blue edge) mark the HH curve. Every point in this sweep is
%  SAP by construction (V_stim stays below the 2004 mV RS-onset
%  boundary), so no RS/DB marker categories are needed here -- unlike
%  the 1 ns figures, which spanned all three regimes.
%
%  Requires: AP_metrics_summary.mat (run S07_Table_AP_metrics.m first)
%% ================================================================
clear; clc; close all;

S = load([project_root '/data/processed/AP_metrics_summary.mat']);
results = S.results;

is_hhk = results.model == "HHK";
is_hh  = results.model == "HH";

R_hhk = results(is_hhk, :);
R_hh  = results(is_hh, :);

have_hh = height(R_hh) > 0;

if have_hh
    [Vstim_common, ia, ib] = intersect(R_hhk.Vstim, R_hh.Vstim);
    latency_HHK = R_hhk.latency(ia);   latency_HH = R_hh.latency(ib);
    T50_HHK     = R_hhk.T50(ia);       T50_HH     = R_hh.T50(ib);
    amp_HHK     = R_hhk.V_AP(ia);      amp_HH     = R_hh.V_AP(ib);
else
    warning(['No HH rows found in AP_metrics_summary.mat -- plotting HHK only. ' ...
             'Add an HH source to S07_Table_AP_metrics.m and re-run it ' ...
             'to get the HH overlay.']);
    Vstim_common = R_hhk.Vstim;
    latency_HHK = R_hhk.latency;   T50_HHK = R_hhk.T50;   amp_HHK = R_hhk.V_AP;
end

% Sort by V_stim for clean line plots
[Vstim_common, order] = sort(Vstim_common);
latency_HHK = latency_HHK(order); T50_HHK = T50_HHK(order); amp_HHK = amp_HHK(order);
if have_hh
    latency_HH = latency_HH(order); T50_HH = T50_HH(order); amp_HH = amp_HH(order);
end

EP_onset = 1784;

fig = figure('Position',[50 50 1400 420]);

%% -------------------- (a) Spike latency --------------------
subplot(1,3,1); hold on; box on;
plot(Vstim_common, latency_HHK, 'LineWidth',2,'LineStyle','-','Color','k');
if have_hh
    plot(Vstim_common, latency_HH, 'LineWidth',2,'LineStyle','--','Color','k');
end
plot(Vstim_common, latency_HHK, 'd','MarkerSize',9,'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2);
if have_hh
    plot(Vstim_common, latency_HH, 's','MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2);
end
xline(EP_onset, ':', 'EP onset', 'Interpreter','latex','LabelVerticalAlignment','bottom');
xlabel('$V_{\mathrm{stim}}$ (mV)','Interpreter','latex');
ylabel('Spike latency (ms)','Interpreter','latex');
title('(a)','Interpreter','latex');
legend(have_hh_legend(have_hh),'Box','off','Location','best','Interpreter','latex');
set(gca,'FontSize',14,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);

%% -------------------- (b) T50% --------------------
subplot(1,3,2); hold on; box on;
plot(Vstim_common, T50_HHK, 'LineWidth',2,'LineStyle','-','Color','k');
if have_hh
    plot(Vstim_common, T50_HH, 'LineWidth',2,'LineStyle','--','Color','k');
end
plot(Vstim_common, T50_HHK, 'd','MarkerSize',9,'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2);
if have_hh
    plot(Vstim_common, T50_HH, 's','MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2);
end
xline(EP_onset, ':', 'EP onset', 'Interpreter','latex','LabelVerticalAlignment','bottom');
xlabel('$V_{\mathrm{stim}}$ (mV)','Interpreter','latex');
ylabel('$T_{50\%}$ (ms)','Interpreter','latex');
title('(b)','Interpreter','latex');
set(gca,'FontSize',14,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);
% If the EP-driven rise turns out to span more than ~1 order of
% magnitude once real data is in, switch to: set(gca,'YScale','log')

%% -------------------- (c) AP amplitude (peak V) --------------------
subplot(1,3,3); hold on; box on;
plot(Vstim_common, amp_HHK, 'LineWidth',2,'LineStyle','-','Color','k');
if have_hh
    plot(Vstim_common, amp_HH, 'LineWidth',2,'LineStyle','--','Color','k');
end
plot(Vstim_common, amp_HHK, 'd','MarkerSize',9,'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2);
if have_hh
    plot(Vstim_common, amp_HH, 's','MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2);
end
xline(EP_onset, ':', 'EP onset', 'Interpreter','latex','LabelVerticalAlignment','bottom');
xlabel('$V_{\mathrm{stim}}$ (mV)','Interpreter','latex');
ylabel('$V_{\mathrm{peak}}^{\mathrm{AP}}$ (mV)','Interpreter','latex');
title('(c)','Interpreter','latex');
set(gca,'FontSize',14,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);

sgtitle('SAP features vs. $V_{\mathrm{stim}}$: HH (no EP) vs. HHK (EP on)', ...
        'Interpreter','latex','FontSize',15);
%%
fig = figure('Position',[50 50 1400 420]);
%% -------------------- (a) Spike latency --------------------
subplot(1,3,1); hold on; box on;
plot(Vstim_common(2:end), latency_HHK(2:end), 'LineWidth',2,'LineStyle','-','Color','k');
if have_hh
    plot(Vstim_common(2:end), latency_HH(2:end), 'LineWidth',2,'LineStyle','--','Color','k');
end
plot(Vstim_common(2:end), latency_HHK(2:end), 'd','MarkerSize',9,'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2);
if have_hh
    plot(Vstim_common(2:end), latency_HH(2:end), 's','MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2);
end
xline(EP_onset, '-.', 'EP onset', 'Interpreter','latex','LabelVerticalAlignment','top', FontSize=16);
xlabel('$V_{\mathrm{stim}}$ (mV)','Interpreter','latex');
ylabel('Spike latency (ms)','Interpreter','latex');
title('(a)','Interpreter','latex');
legend(have_hh_legend(have_hh),'Box','off','Location','best','Interpreter','latex',FontSize=18);
set(gca,'FontSize',14,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);

%% -------------------- (b) T50% --------------------
subplot(1,3,2); hold on; box on;
plot(Vstim_common(2:end), T50_HHK(2:end), 'LineWidth',2,'LineStyle','-','Color','k');
if have_hh
    plot(Vstim_common(2:end), T50_HH(2:end), 'LineWidth',2,'LineStyle','--','Color','k');
end
plot(Vstim_common(2:end), T50_HHK(2:end), 'd','MarkerSize',9,'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2);
if have_hh
    plot(Vstim_common(2:end), T50_HH(2:end), 's','MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2);
end
xline(EP_onset, '-.', 'EP onset', 'Interpreter','latex','LabelVerticalAlignment','bottom', FontSize=16);
xlabel('$V_{\mathrm{stim}}$ (mV)','Interpreter','latex');
ylabel('$T_{50\%}$ (ms)','Interpreter','latex');
title('(b)','Interpreter','latex');
set(gca,'FontSize',14,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);
% If the EP-driven rise turns out to span more than ~1 order of
% magnitude once real data is in, switch to: set(gca,'YScale','log')

%% -------------------- (c) AP amplitude (peak V) --------------------
subplot(1,3,3); hold on; box on;
plot(Vstim_common(2:end), amp_HHK(2:end), 'LineWidth',2,'LineStyle','-','Color','k');
if have_hh
    plot(Vstim_common(2:end), amp_HH(2:end), 'LineWidth',2,'LineStyle','--','Color','k');
end
plot(Vstim_common(2:end), amp_HHK(2:end), 'd','MarkerSize',9,'MarkerEdgeColor','r','MarkerFaceColor','none','LineWidth',1.2);
if have_hh
    plot(Vstim_common(2:end), amp_HH(2:end), 's','MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor','none','LineWidth',1.2);
end
xline(EP_onset, '-.', 'EP onset', 'Interpreter','latex','LabelVerticalAlignment','bottom', FontSize=16);
xlabel('$V_{\mathrm{stim}}$ (mV)','Interpreter','latex');
ylabel('$V_{\mathrm{peak}}^{\mathrm{AP}}$ (mV)','Interpreter','latex');
title('(c)','Interpreter','latex');
set(gca,'FontSize',14,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);

% sgtitle('SAP features vs. $V_{\mathrm{stim}}$: HH (no EP) vs. HHK (EP on)', ...
%         'Interpreter','latex','FontSize',15);
%%
%% Plot for SAP
% Saving the fig file to PDF
h = gcf;
set(h, 'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [pos(3), pos(4)]);

% Define full path where you want to save
save_path = fig_path('SI/S17_Fig.pdf');


% Save as PDF
finish_figure(h, save_path);

close all
%
%% ================================================================
function lbls = have_hh_legend(have_hh)
    if have_hh
        lbls = {'HHK','HH'};
    else
        lbls = {'HHK'};
    end
end
