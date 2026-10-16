addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'utils'));  % repo helpers (figures_code/utils), so the script also runs without setup
clc;
clear all;
%% Fig 10: pore energy landscape W(r) at transmembrane potentials Vm = 0-1 V.
%  W(r) is the smaller of the hydrophobic and hydrophilic pore energies,
%  minus the electrical term pi*eps_w*Vm^2*r^2/(2h), in units of kb*T.
%  Parameter values are those of the model (dynamics__HH_with_EP_shunt.m).

%% Parameters
T = 310;               % Absolute temperature (37°C)
kb = 1.380649e-23;     % Boltzman Constant
h = 5e-9;              % Membrane thickness (m) (dm in the model)
r_star = 0.51e-9;      % Minimum radius of hydrophilic pores (m)
beta = 1.4e-19;        % Steric repulsion energy (J)
gamma = 1.8e-11;       % Edge energy (J/m)
sig_0 = 1e-3;          % Tension of the bilayer without pores (J/m^2)

%% Energy landscape
Vm=[0; 0.3;0.6;0.8;1];
r=[0:0.01:4]*1e-9;
E_hydrophobic=(pi*h*0.05.*r)/(kb*T);
E_hydrophilic=(beta*(r_star./r).^4 + 2*pi*gamma*r - pi*sig_0*r.^2)/(kb*T);
W=min(E_hydrophobic,E_hydrophilic);
figure;
hold on
for i=1:5
plot(r*1e9, W- pi*Vm(i)^2*(78*8.854*1e-12).*(r.^2)/(2*h*kb*T),LineWidth=2);
end
hold off
%legend('Hydrophobic', 'Hydrophilic', ' Energy of pores');
xlabel('$r\ (nm)$',Interpreter='latex');
ylabel('Energy of pores ($k_b T$)',Interpreter='latex');
legend('$0\ V$','$0.3\ V$','$0.6\ V$','$0.8\ V$','$1\ V$',Interpreter='latex')
set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',17)
set(gca,'FontName','Times')
% % xlabel('$V_{stim}\ (mV)$','FontSize',22,'Interpreter','Latex')
% % ylabel('$Delay\ Time (ms)$','FontSize',25,'Interpreter','Latex')
set(gca,'LineWidth',1)
%set(gca,'TickLength',[0.02 0.02])
%set(gca,'XMinorTick','on','YMinorTick','on')
ylim([-300 300])
grid on

%% Save Fig 10
fig = gcf;
set(fig,'Units','Inches');
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
finish_figure(fig, fig_path('main/Fig10.pdf'))
