addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
clc;
clear all;
%% S2 Fig: benchmark of the electroporation model of a single membrane patch
%  against Smith et al. (2004): (a) TMP, (b) number of large pores K,
%  (c) maximum and (d) mean pore radius, for a 20-us pulse of 1.25 V.
%
%  Present work: data/raw/SI_data/Smith2004/euler_with_Gaussian_125.mat, made
%  with model/Smith2004_patch/electroporation_patch.m (explicit Euler,
%  dt = 1e-10 s, pore radii launched from a Gaussian around r_m).
%  Smith et al.: data/raw/SI_data/Smith2004/*_125.csv, digitised from the
%  published plots (time in us; radii in nm; K in units of 10^4 pores).

d = [project_root '/data/raw/SI_data/Smith2004/'];
s = load([d 'euler_with_Gaussian_125.mat']);
t     = s.t_euler_with_Gaussian;      % (s)
Vm    = s.Vm_euler_with_Gaussian;     % (V)
K     = s.K_euler_with_Gaussian;      % number of large pores
rmax  = s.rmax_euler_with_Gaussian;   % (m)
rmean = s.rmean_euler_with_Gaussian;  % (m)

TMP_smith   = csvread([d 'TMP_125.csv']);    % [t (us), Vm (V)]
K_smith     = csvread([d 'Pores_125.csv']);  % [t (us), K (10^4)]
rmax_smith  = csvread([d 'rmax_125.csv']);   % [t (us), rmax (nm)]
rmean_smith = csvread([d 'rmean_125.csv']);  % [t (us), rmean (nm)]

panels = {
%   y (model)  Smith x (s)            Smith y (model units)    y label             panel  ylim        x exponent  legend
    Vm,        1e-6*TMP_smith(:,1),   TMP_smith(:,2),          '$V_m\ (V)$',       'a',   [0 1.5],    -6,         'northeast'
    K,         1e-6*K_smith(:,1),     1e4*K_smith(:,2),        '$K$',              'b',   [0 2e4],    -5,         'east'
    rmax,      1e-6*rmax_smith(:,1),  1e-9*rmax_smith(:,2),    '$r_{max}\ (m)$',   'c',   [0 4e-8],   -6,         'east'
    rmean,     1e-6*rmean_smith(:,1), 1e-9*rmean_smith(:,2),   '$r_{mean}\ (m)$',  'd',   [0 4e-8],   -6,         'east'
};

for k = 1:size(panels, 1)
    figure;
    plot(t, panels{k,1}, 'k', 'LineWidth', 2);
    hold on
    plot(panels{k,2}, panels{k,3}, 'o', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.5);
    hold off
    grid on
    xlim([0 2e-5]);
    ylim(panels{k,6});
    set(gcf,'Position',[15 15 550 420])
    set(gca,'Position',[0.17 0.17 0.80 0.77])
    set(gca,'FontSize',17)
    set(gca,'FontName','Times')
    xlabel('$t\ (s)$','FontSize',22,'Interpreter','Latex')
    ylabel(panels{k,4},'FontSize',25,'Interpreter','Latex')
    set(gca,'LineWidth',1)
    set(gca,'TickLength',[0.02 0.02])
    set(gca,'XMinorTick','on','YMinorTick','on')
    ax = gca; ax.XAxis.Exponent = panels{k,7};
    legend('Present work','Smith et al.(2004)','Location',panels{k,8})

    h = gcf;
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    finish_figure(h, fig_path(['SI/S2_Fig_' panels{k,5} '.pdf']))
end
