% script RR_Exam08_24_final.m
% This script solves some of the problem in the 2024 final, focusing on stuff
% from chapter 8 and a bit of stuff from chapter 10.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 8)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, T_I=10; T_D=1; z_p=1/T_I; z_m=1/T_D;
D_PD=RR_tf(RR_poly(-z_m,1),1);
D_PID=RR_tf(RR_poly([-z_m -z_p],1),[1 0]); G=RR_tf(1,[1 0 0])

disp('Problem 1a'), figure(1), clf, RR_bode(D_PD), % print -depsc final_exam_24_1a1.eps
figure(2), clf, RR_bode(D_PID),                    % print -depsc final_exam_24_1a2.eps
pause

disp('Problem 1d'), figure(1), clf, RR_bode(G)     % print -depsc final_exam_24_1d.eps
pause

disp('Problem 4b'), 
K=100, t_r=1.8, omega_g=1.8/t_r, omega_bar=omega_g; h=t_r*pi/180, omega_N=pi/h;
f=2*(1-cos(omega_bar*h))/(omega_bar*h*sin(omega_bar*h))
f_tilde=f*h/2; z_p_tilde=f_tilde*z_p; z_m_tilde=f_tilde*z_m;
a=1+z_p_tilde; b=1-z_p_tilde; c=1+z_m_tilde; d=1-z_m_tilde;
disp('  PID transfer function parameters:'),     b_tilde=b/a, d_tilde=d/c, K_tilde=K*a*c/f_tilde
disp('  PID difference equation coefficients:'), b_0=K_tilde, b_1=-K_tilde*(b_tilde+d_tilde), b_2=K_tilde*b_tilde*d_tilde
pause

omega_c=omega_N/2; K_c=K*omega_c; omega_c_tilde=f_tilde*omega_c; p=1+omega_c_tilde; q=1-omega_c_tilde;
disp('  LPF2_PID transfer function parameters:'),     q_tilde=q/p, K_c_tilde= K*a*c/p
disp('  LPF2_PID difference equation coefficients:'), a_1_bar=1+q_tilde, a_2_bar=-q_tilde
                                                     b_0_bar=K_c_tilde, b_1_bar=-K_c_tilde*(b_tilde+d_tilde), b_2_bar=K_c_tilde*b_tilde*d_tilde
pause

disp('  Root locus plot w.r.t. K in z plane')
Gz=RR_tf([-1],[1 1],h^2/2)
D_LPF2_PID_z=RR_tf([b_tilde d_tilde],[1 q_tilde],K_c_tilde)

figure(1), clf, g.K=logspace(-3,4,2000); RR_rlocus(Gz,D_LPF2_PID_z,g)
axis([-3.5 1.1 -1.75 1.75]), zgrid, % print -vector -depsc final_exam_24_4b1.eps
figure(2), clf, RR_rlocus(Gz,D_LPF2_PID_z,g)
axis([-0.1 1.1 -0.4 .4]), zgrid,    % print -vector -depsc final_exam_24_4b2.eps
