addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
%  Exploratory plots not in the paper were removed for this release (see the original analysis code).
clear all; clc; 
%Data
RC = [1e-8; 1e-7; 1e-6];  % time constants in seconds
log_RC = log([1e-8; 1e-7; 1e-6]); 

% thresholds in mV
Excitation_threshold = [2451; 11055; 81956]; 
EP_threshold         = [2393; 11178; 94985];
RS_threshold         = [2853; 13424; 117023];
DB_threshold         = [3020; 14234; 124719];
Cell_death           = [4383; 17534; 157796];

% log 
log_Excitation_threshold = log(Excitation_threshold); 
log_EP_threshold         = log(EP_threshold);
log_RS_threshold         = log(RS_threshold);
log_DB_threshold         = log(DB_threshold);
log_Cell_death           = log(Cell_death);
%% PLots
% RC range (log-spaced for better resolution on log-log plot)
RC_vals = logspace(-8, -6, 100);  % From 1e-8 to 1e-6 seconds

% Coefficients from your fit
p1 = [0.762, 0.7994, 0.8067, 0.808, 0.7782];
p2 = [21.7614, 22.705, 22.7929, 22.7948, 22.5846];

% Compute predicted thresholds
Vstim = zeros(length(p1), length(RC_vals));
for i = 1:length(p1)
    a = exp(p2(i));
    b = p1(i);
    Vstim(i, :) = a * RC_vals.^b;
end



% Plot
fig_main = figure;
plot(RC,Excitation_threshold,'^','MarkerFaceColor','g', "MarkerSize",12 )
hold on
plot(RC,EP_threshold,'d','MarkerFaceColor','m', "MarkerSize",12 )
plot(RC,RS_threshold,'>','MarkerFaceColor',[0.5, 0.2, 0.8], "MarkerSize",12  )
plot(RC,DB_threshold,'<','MarkerFaceColor',"#EDB120", "MarkerSize",12  )
plot(RC,Cell_death,'h','MarkerFaceColor','k',"MarkerSize",12 )

% loglog(RC_vals, Vstim(1,:),'Color', 'g','LineWidth', 2, LineStyle='--')
% loglog(RC_vals, Vstim(2,:), 'Color','m','LineWidth', 2,LineStyle='--')
% loglog(RC_vals, Vstim(3,:), 'Color',[0.5, 0.2, 0.8],'LineWidth', 2,LineStyle='--')
% loglog(RC_vals, Vstim(4,:), 'Color',"#EDB120", 'LineWidth', 2,LineStyle='--')
% loglog(RC_vals, Vstim(5,:), 'Color','k', 'LineWidth', 2,LineStyle='--');
hold off

ylabel('Threshold (mV)');

ylim([1e3 3e5]);
xlim([5e-9 1.5e-6]);
grid on;
ax = gca;
ax.TickLabelInterpreter = 'latex';
set(gca,'FontSize',21,'FontName','Times','LineWidth',1,'TickLength',[0.02 0.02]);
set(gca,'XMinorTick','on','YMinorTick','on');
xlabel('$RC$ (s)','FontSize',20,'Interpreter','Latex');
ylabel('Thresholds (mV)','FontSize',20,'Interpreter','Latex');
% %legend({'Excitation threshold', ...
%     'Electroporation threshold','Repetitive spiking','Depolarization block', 'Cell death'}, ...
%     'Location', 'best', 'NumColumns', 2, 'Interpreter','latex','Box', 'off',FontSize=16, FontWeight='bold');

set(gca,'yscale','log')
set(gca,'xscale','log')
grid on;
set(gca, 'FontSize', 12); 
set(gcf, 'PaperUnits', 'inches');      
set(gcf, 'PaperPosition', [0 0 6 4]);   

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',25)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])



% text(3e-8, 4e4, '$\tau=10$ ns', 'Interpreter', 'latex', ...
%      'FontSize', 20, 'FontWeight', 'bold')
grid off
%% %% Legend only (3-column layout)

figure('Color','w');
hold on

% Dummy handles matching the styles in the main figure
h1 = plot(nan,nan,'^', ...
    'Color','g', ...
    'MarkerFaceColor','g', ...
    'LineWidth',2, ...
    'MarkerSize',10);

h2 = plot(nan,nan,'d', ...
    'Color','m', ...
    'MarkerFaceColor','m', ...
    'LineWidth',2, ...
    'MarkerSize',10);

h3 = plot(nan,nan,'>', ...
    'Color',[0.5 0.2 0.8], ...
    'MarkerFaceColor',[0.5 0.2 0.8], ...
    'LineWidth',2, ...
    'MarkerSize',10);

h4 = plot(nan,nan,'<', ...
    'Color',[0.93 0.69 0.13], ...
    'MarkerFaceColor',[0.93 0.69 0.13], ...
    'LineWidth',2, ...
    'MarkerSize',10);

h5 = plot(nan,nan,'h', ...
    'Color','k', ...
    'MarkerFaceColor','k', ...
    'LineWidth',2, ...
    'MarkerSize',10);

% Legend
lgd = legend([h1 h2 h3 h4 h5], ...
    {'Excitation threshold', ...
     'Electroporation threshold', ...
     'Repetitive spiking threshold', ...
     'Depolarization block threshold', ...
     'Cell death threshold'}, ...
    'NumColumns',3, ...
    'Location','northoutside', ...
    'Interpreter','latex', ...
    'FontSize',15, ...
    'Box','off');

% Remove axes
axis off
set(gca,'Visible','off')

% Make figure wide
set(gcf,'Units','inches');
set(gcf,'Position',[1 1 9 1.4]);

% Tight cropping
set(gca,'LooseInset',get(gca,'TightInset'));

% Export as vector PDF
finish_figure(gcf, fig_path('main/Fig7_legend.pdf'), 'vector', ...
    'BackgroundColor','none');
%%
figure(fig_main);  % inset goes on the main figure
% Example for one inset (Excitation - EP difference)
inset_ax = axes('Position',[0.25 0.50 0.25 0.25]); % place inset

% Plot difference
plot(inset_ax, RC, (EP_threshold - Excitation_threshold)./Excitation_threshold,'-s', Color='b', LineWidth=2, MarkerSize=12); hold on

% Zero line reference
yline(inset_ax, 0, 'k--','LineWidth',2);

% Axis formatting
%set(inset_ax,'XScale','log','YScale','linear','FontSize',17,'interpreter','latex')
xlim(inset_ax,[0.5e-8 1.5e-6]); % zoom around RC=1e-8
ylim(inset_ax,[-0.2 0.2]); % zoom around RC=1e-8

ylabel(inset_ax,'(EP - Exc.)/Exc.','Interpreter','latex','FontSize',17)
%xlabel(inset_ax,'$RC$','Interpreter','latex','FontSize',17)

set(inset_ax, 'FontSize', 22, ...
    'FontName', 'Times', ... 
    'TickLabelInterpreter', 'latex', ...
    'Box', 'on', ...
    'LineWidth', 1.5, ...
    'XMinorTick', 'on', 'YMinorTick', 'on','XScale','log','YScale','linear');
ylabel(inset_ax,'(EP - Exc.)/Exc.','Interpreter','latex','FontSize',17)


%%
h = fig_main;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
finish_figure(h, fig_path('main/Fig7a.pdf'));



