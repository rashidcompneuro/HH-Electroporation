function dX_by_dt=dynamics_HH_with_electroporation(t,X_vec,V_stim)

%---- for RC = 1e-3 ms ------------------------------------------
%--Unpacking X_vec
V1 = X_vec(1); V2 = X_vec(2); % TMPs
m_1 = X_vec(3); n_1 = X_vec(4); h_1 = X_vec(5); % gating variables at DP side
m_2 = X_vec(6); n_2 = X_vec(7); h_2 = X_vec(8); % gating variables at HP side

N1 = X_vec(9); N2 = X_vec(10); % small pore density


%---Parameters for Hodgin-Huxley model
C = 1; % specific capacitance (micofarad/cm^2)
R = 10^-3; % specific intracellular resistance (milliohm. cm^2 )

gk_max=36; gNa_max=120; gL=0.3; % conductances (mS/cm^2)
E_K=-82; E_Na=45; E_L=-59; % Nernst potentials(mV)

%---Parameters for Electroporation
alpha = 1e9; % Creation rate coefficient [1/(m^2.s)]
V_ep = 0.258; % Characteristic voltage of electroporation (V)
N_0 = 1.5*1e9; % Equilibrium pore density at Vm = 0 (1/m^2)
r_star = 0.51e-9; % Minimum radius of hydrophilic pores (m)
r_m = 0.8e-9; % Minimum energy radius at Vm =0 (m)
A1 = 1.26e-9/2; % Area of lipid bilayer depolarized-side (m^2)
A2 = 1.26e-9/2; % Area of lipid bilayer hyperpolarized-side (m^2)
dm = 5e-9; % Membrane thickness (m)

q = (r_m/r_star)^2;
Neq1 = N_0*exp(q*(V1*1e-3/V_ep)^2);
Neq2 = N_0*exp(q*(V2*1e-3/V_ep)^2);

qe = 1.65*1e-19; % Electric charge of an electron
kb = 1.380649e-23; % Boltzman Constant
T = 310; % Absolute temperature (37°C)
w0 = 3.2; % Pore Energy Barrier; 
n0 = 0.15;  % Relative Entrance of pore length
sigma_p = 1.2; % Conductivity of extracellular fluid (S/m)



%---Unused parameters for electroporation
% D=5e-14; %Diffusion coefficient for pore radius
% T=310; %Absolute temperature (37°C)
% kb=1.380649e-23; %Boltzman Constant
% beta= 1.4e-19;  %Steric repulsion energy
% gamma= 1.8e-11;  %Edge energyy
% sig_0= 1e-3; %Tension of the bilayer without pores
% sig_1= 2e-2; %Tension of hydrocarbon-water interface
% F_max=0.70e-9; %Maximum electric force for Vm=1V
% g=2; %Conductivity of the solutionSS

%------------------------------------------------------------------------------
%--Equations for Ion channels
%--for left membrane(V1)
alpha_m_1 = 0.1*(-V1-45)/(exp((-V1/10)-4.5)-1); beta_m_1 = 4*exp((-V1/18)-35/9);
alpha_n_1 = 0.01*(-V1-60)/(exp((-V1/10)-6)-1); beta_n_1 = 0.125*exp((-V1/80)-7/8);
alpha_h_1 = 0.07*exp((-V1/20)-3.5); beta_h_1 = 1/(exp((-V1/10)-4)+1);

%--for right membrane(V2)
alpha_m_2 = 0.1*(-V2-45)/(exp((-V2/10)-4.5)-1); beta_m_2 = 4*exp((-V2/18)-35/9);
alpha_n_2 = 0.01*(-V2-60)/(exp((-V2/10)-6)-1); beta_n_2 = 0.125*exp((-V2/80)-7/8);
alpha_h_2 = 0.07*exp((-V2/20)-3.5); beta_h_2 = 1/(exp((-V2/10)-4)+1);

%--for electroporation
v1=qe*V1*1e-3/(kb*T); v2=qe*V2*1e-3/(kb*T); % non-dimensional TMPs

W11 = (w0*exp(w0 - n0*v1) - n0*v1)*exp(v1) / (w0 - n0*v1);
W12 = (w0*exp(w0 + n0*v1) + n0*v1)/(w0 + n0*v1);

W21 = (w0*exp(w0 - n0*v2) - n0*v2)*exp(v2) / (w0 - n0*v2);
W22 = (w0*exp(w0 + n0*v2) + n0*v2)/(w0 + n0*v2);

%--factor accounting energy barrier in the pore
K1 = (exp(v1)-1)/(W11-W12); % DP side
K2 = (exp(v2)-1)/(W21-W22); % HP side

%--Time-varying conductance due to lipid fluctuations when there is no large pores
g_shunt_1 = sigma_p*K1*(pi*r_m^2)*N1/(dm*10) ; % DP side
g_shunt_2 = sigma_p*K2*(pi*r_m^2)*N2/(dm*10); % HP side
 

%--dynamics of ODEs
dV1_by_dt = (V_stim-V1+V2)/R + 1* (gk_max*n_1^4*(E_K-V1) + gNa_max*m_1^3*h_1*(E_Na-V1) + gL*(E_L-V1) )- g_shunt_1*V1 ; %(mV/ms)
dV2_by_dt = (-V_stim+V1-V2)/R + 1*(gk_max*n_2^4*(E_K-V2) + gNa_max*m_2^3*h_2*(E_Na-V2) + gL*(E_L-V2))- g_shunt_2*V2 ;  %(mV/ms)
dm1_by_dt = alpha_m_1 - m_1*(alpha_m_1+beta_m_1); % 1/ms
dn1_by_dt = alpha_n_1 - n_1*(alpha_n_1+beta_n_1); % 1/ms
dh1_by_dt = alpha_h_1 - h_1*(alpha_h_1+beta_h_1); % 1/ms
dm2_by_dt = alpha_m_2 - m_2*(alpha_m_2+beta_m_2); % 1/ms
dn2_by_dt = alpha_n_2 - n_2*(alpha_n_2+beta_n_2); % 1/ms
dh2_by_dt = alpha_h_2 - h_2*(alpha_h_2+beta_h_2); % 1/ms

dN1_by_dt = 1e-3*alpha*exp(((V1*1e-3)/V_ep)^2)*(1-N1/Neq1); % pores/(m^2. ms)
dN2_by_dt = 1e-3*alpha*exp(((V2*1e-3)/V_ep)^2)*(1-N2/Neq2); % pores/(m^2. ms)


dX_by_dt=[dV1_by_dt; dV2_by_dt; dm1_by_dt; dn1_by_dt; dh1_by_dt; dm2_by_dt; dn2_by_dt; dh2_by_dt; dN1_by_dt; dN2_by_dt];











