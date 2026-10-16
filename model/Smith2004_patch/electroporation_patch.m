%% ========================================================================
%  SCRIPT: Electroporation of a single membrane patch (Smith et al., 2004)
%
%  Asymptotic Smoluchowski electroporation model of one planar bilayer patch
%  in series with the solution resistance Rs (SI Section S1), solved with
%  explicit Euler. Used for the benchmark in S2 Fig: a 1.25 V pulse
%  applied for the whole 20 us.
%
%  Settings of the published run (data/raw/SI_data/Smith2004/
%  euler_with_Gaussian_125.mat): V0 = 1.25 V, tf = 20 us, dt = 1e-10 s,
%  N_0 = 1.5e9 m^-2. Launched pore radii are drawn from a Gaussian around
%  r_m (sd 1e-12 m), so a rerun differs from the saved run only by this
%  randomness (Vm within 1e-7 V); rng(0) makes reruns repeatable.
%  Runtime about 5 min.
%
%  Results are left in the workspace: t (s), Vm (V), K (number of large
%  pores), N (small-pore density), rmax, rmean (m), FPA, Gm.
%  Originally electrporation_test.m.
%% ========================================================================
clc
clear all
rng(0)   % repeatable random launch radii
%Parameters
%global alpha V_ep N_0 r_star r_m D T beta gamma sig_0 sig_1 A F_max r_h r_t Cm Rm Rs h g

tic 

alpha= 1e9;  %Creation rate coefficient
V_ep=0.258;  %Characteristic voltage of electroporation
N_0=1.5e9; %Equilibrium pore density at Vm=0
r_star=0.51e-9; %Minimum radius of hydrophilic pores
r_m=0.8e-9; %Minimum energy radius at Vm =0 
D=5e-14; %Diffusion coefficient for pore radius
T=310; %Absolute temperature (37°C)
kb=1.380649e-23; %Boltzman Constant
beta= 1.4e-19;  %Steric repulsion energy
gamma= 1.8e-11;  %Edge energyy
sig_0= 1e-3; %Tension of the bilayer without pores
sig_1= 2e-2; %Tension of hydrocarbon-water interface
A=1.26e-9; %Total area of lipid bilayer

F_max=0.70e-9; %Maximum electric force for Vm=1V
r_h=0.97e-9; %Constant in Eq. 6 for electric force
r_t=0.31e-9; %Constant in Eq. 6 for electric force
Cm=9.5e-3 ; %Surface capacitance of the membrane
C=Cm*A;
Rm=0.523; %Surface resistance of the membrane
R=Rm/A;
Rs=100; % Series resistance of the experimental setup
h=5e-9; %Membrane thickness
g=2; %Conductivity of the solutionSS
%%

tf=20e-6;
dt=1e-10; % time step (s)
t=0:dt:tf;
n=length(t); 

rmax=zeros(1,n); r_max(1)=0;
rmean=zeros(1,n); r_mean(1)=0;
A_p=zeros(1,n); A_p(1)=pi*r_m^2*0;
%Ip=zeros(1,n)
V0=1.25;
Kl=zeros(1,n);
%Euler_explicit for N calculation
Gm=zeros(1,n);
m1=zeros(1,n);
N=zeros(1,n);N(1)=N_0;
Vm=zeros(1,n);
K=zeros(1,n);
q=(r_m/r_star)^2;
r1=[];
for i=1:n-1
    Neq=N_0*exp(q*(Vm(i)/V_ep)^2);
    N(i+1)=N(i)+dt*alpha*exp((Vm(i)/V_ep)^2)*(1-N(i)/Neq);
    K_launch=floor(N(i+1)*A); %  launched pores as we let the small pores assume the role of large pores
    K(i+1)=K(i)+K_launch;% Number of large Pores
    N(i+1)=N(i+1)-K_launch/A; % Small  pores population after substracting the ones who have become large
    Kl(i+1)=K_launch; 
    
    
   
    
%Launching of Pores
mu=1e-12; %standard deviation when launching pores
r_launch=r_m+mu*randn(K_launch,1); % initial value for radius; same as normrnd(r_m,mu,[K_launch,1])
%rlarge=[rlarge;r_launch];
% rlarge=zeros(K(i+1),1); %creating a coloumn vector containing large pores of different size at a given time step
% rlarge(K(i)+1:K(i+1))=r_launch;

rlarge=[r1;r_launch];



r_dummyL=rlarge(rlarge>r_m);
r_dummyS=rlarge(rlarge<r_m);
sm=length(r_dummyS)+floor(N(i+1)*A);

%Computing Pore Area
A_p(i+1)=pi*sum(r_dummyL.^2)+sm*pi*r_m^2; % Assuming all the sub-rm pores to be rm and find the area of the pores from that.
%Computing efective membrane tension
sig_eff=2*sig_1-(2*sig_1-sig_0)/(1-A_p(i+1)/A)^2;
    
for j=1:K(i+1)

    %updating pore radii
    rlarge(j,1)=rlarge(j,1)+ dt*(D/(kb*T))*(Vm(i)^2*F_max/(1+r_h/(rlarge(j,1)+r_t)) + 4*beta*r_star^4/(rlarge(j,1)^5) -2*pi*gamma +2*pi*sig_eff*rlarge(j,1) );
end

% rnew=[rlarge;r_launch];

%Absorb pores

sp=sum(rlarge<=(r_m));%no. of small pores
% sp=(K+1)-rd; % No. of small pores
K(i+1)=K(i+1)-sp; % updated K value
N(i+1)=N(i+1)+sp/A;

% % %r after removing pores smaller than 
% % rmv=(r_in<r_m);dummyvar=r_in;
% % dummyvar(rmv)=[];
% % r_in=dummyvar;

rsp=rlarge(rlarge<=r_m); %small pore vector
rnew=rlarge(rlarge>r_m);%removal of small pores from launched r

% if length(rsp)+length(rnew)~=length(rlarge)
%     disp('error')
% end

rlarge=rnew;% rnew=[r_large;r];
r1=rlarge;

%max radius calculation
if isempty(rlarge)
    rmax(i+1)=0;
else
rmax(i+1) = max(rlarge);
end

% mean radius calculation
if isempty(rlarge)
    rmean(i+1)=0;
else
rmean(i+1) = mean(rlarge);
end

% Update transmemebrane potential
ip1=zeros(K(i+1),1);
Ri1=zeros(K(i+1),1);
Rp1=zeros(K(i+1),1);
gp1=zeros(K(i+1),1);
for j=1:K(i+1) 
    Ri1(j)=1/(2*g*rlarge(j)); Rp1(j)=h/(pi*g*rlarge(j)^2);
    
    ip1(j)=Vm(i)/(Rp1(j)+Ri1(j)); %current through large pores
    gp1(j)=1/(Rp1(j)+Ri1(j)); %conductance of large pores
end
m1(i+1)=floor(N(i+1)*A);
m=floor(N(i+1)*A);
ip2=zeros(m,1);
Ri2=zeros(m,1);
Rp2=zeros(m,1);
gp2=zeros(m,1);
for jj=1:m
    Ri2(jj)=1/(2*g*r_m); Rp2(jj)=h/(pi*g*r_m^2);

    ip2(jj)=Vm(i)/(Rp2(jj)+Ri2(jj)); %current through small pores
    gp2(jj)=1/(Rp2(jj)+Ri2(jj)); %conductance of small pores
end

ip=[ip1;ip2];
gp=[gp1;gp2];
% Ri=[Ri1;Ri2];
% Rp=[Rp1;Rp2];

Ip=sum(ip); % Total current across the pores
Gm(i+1)=sum(gp); %Total conductance
Vm(i+1) = Vm(i) + dt*(V0/(Rs*C) - ((1/Rs)+(1/R))*Vm(i)/C - Ip/C);

end 
FPA=A_p/A; 

toc

%%
figure('Name','Transmembrane potential')
plot(t,Vm,LineWidth=2);
xlabel('time, $s$', 'FontSize',22, Interpreter='latex');
ylabel('TMP, $V$', 'FontSize',25,Interpreter='latex');
grid on
%%
figure('Name','Number of pores')
plot(t,K,LineWidth=2);
xlabel('time, $s$', 'FontSize',22, Interpreter='latex');
ylabel('No. of pores', 'FontSize',22, Interpreter='latex');
grid on
figure
plot(t,N,LineWidth=2);
xlabel('time, $s$', 'FontSize',22, Interpreter='latex');
ylabel('$N$', 'FontSize',22, Interpreter='latex');
grid on
%%
figure('Name','Maximum and mean radii')
plot(t,1e9*rmean,t,1e9*rmax,LineWidth=2);
xlabel('time, $s$', 'FontSize',25, Interpreter='latex');
ylabel('Radius of the pores, $nm$', 'FontSize',22, Interpreter='latex');
legend('rmean','rmax');
grid on

figure('Name','Fractional pore area')
plot(t,(A_p/A)*100,Linewidth=2);
xlabel('time, $s$', 'FontSize',22, Interpreter='latex');
ylabel(' Fractional pore area', 'FontSize',25, Interpreter='latex');
grid on
%%
figure('Name','Pore Conductance')
plot(t,Gm,LineWidth=2);
xlabel('$t\ (s)$', 'FontSize',22, Interpreter='latex');
ylabel('$G_m$', 'FontSize',25',Interpreter='latex');
%legend('$G_{p1}$','$G_{p2}$',Interpreter='latex');

set(gcf,'Position',[15 15 550 420])
set(gca,'Position',[0.17 0.17 0.80 0.77])
set(gca,'FontSize',17)
set(gca,'FontName','Times')
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02 0.02])
grid on

%% Saving the data (uncomment to save)
% save('my_patch_run.mat','t','Vm','K','N','rmax','rmean','FPA','Gm');
