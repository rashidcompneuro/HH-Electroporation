function F_vec=dynamics_HH(t,X_vec,V_stim)

F_vec=zeros(8,1);
%Parameters
C=1;
R=10^-3;
gk_max=36; gNa_max=120; gL=0.3;
E_K=-82; E_Na=45; E_L=-59;


% Equations for Ion channels
%for left membrane(V1)
alpha_m_1=0.1*(-X_vec(1)-45)/(exp((-X_vec(1)/10)-4.5)-1); beta_m_1=4*exp((-X_vec(1)/18)-35/9);
alpha_n_1=0.01*(-X_vec(1)-60)/(exp((-X_vec(1)/10)-6)-1); beta_n_1=0.125*exp((-X_vec(1)/80)-7/8);
alpha_h_1=0.07*exp((-X_vec(1)/20)-3.5); beta_h_1=1/(exp((-X_vec(1)/10)-4)+1);

%for right membrane(V2)
alpha_m_2=0.1*(-X_vec(2)-45)/(exp((-X_vec(2)/10)-4.5)-1); beta_m_2=4*exp((-X_vec(2)/18)-35/9);
alpha_n_2=0.01*(-X_vec(2)-60)/(exp((-X_vec(2)/10)-6)-1); beta_n_2=0.125*exp((-X_vec(2)/80)-7/8);
alpha_h_2=0.07*exp((-X_vec(2)/20)-3.5); beta_h_2=1/(exp((-X_vec(2)/10)-4)+1);

%dynamics of ODEs
F_vec(1)=(V_stim-X_vec(1)+X_vec(2))/R +gk_max*X_vec(4)^4*(E_K-X_vec(1)) + gNa_max*X_vec(3)^3*X_vec(5)*(E_Na-X_vec(1)) + gL*(E_L-X_vec(1));
F_vec(2)=(-V_stim+X_vec(1)-X_vec(2))/R +gk_max*X_vec(7)^4*(E_K-X_vec(2)) + gNa_max*X_vec(6)^3*X_vec(8)*(E_Na-X_vec(2)) + gL*(E_L-X_vec(2));
F_vec(3)=(alpha_m_1 - X_vec(3)*(alpha_m_1+beta_m_1));
F_vec(4)=(alpha_n_1 - X_vec(4)*(alpha_n_1+beta_n_1));
F_vec(5)=alpha_h_1 - X_vec(5)*(alpha_h_1+beta_h_1);
F_vec(6)=alpha_m_2 - X_vec(6)*(alpha_m_2+beta_m_2);
F_vec(7)=(alpha_n_2 - X_vec(7)*(alpha_n_2+beta_n_2));
F_vec(8)=alpha_h_2 - X_vec(8)*(alpha_h_2+beta_h_2);




