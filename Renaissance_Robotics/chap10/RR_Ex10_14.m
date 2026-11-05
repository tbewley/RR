% script RR_Ex10_14
% CT to DT example, illustrating instability at high gain due to the delay h/2 from zoh
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 10)
%% Copyright 2026 by Thomas Bewley, published under BSD 3-Clause License.

clear; close all; G=RR_tf([],[10 -10],1); D=RR_tf([-10],[-20],380);

figure(1); g_r.K=logspace(-1.5,3,400); g_r.axes=[-40 40 -40 40];
RR_rlocus(G,D,g_r); % print -depsc example_18_14a.eps
pause

L=G*D; figure(2); g_b.omega=logspace(0,2,400); g_b.line=0; g_b.style='b-';  RR_bode(L,g_b);
pause

figure(3); T=G*D/(1+G*D); P=1/RR_evaluate(T,0);
g_s.T=1.5; g_s.h=.01; g_s.styleu='r--'; g_s.styley='k-'; RR_step(P*T,g_s);
pause

h=.02; omega_bar=13; % Now transform to discrete time
[Gz]=RR_C2D_zoh(G,h); [Dz]=RR_C2D_tustin(D,h,omega_bar);
g_r_d.K=logspace(-1.5,3,400); g_r_d.axes=[-1.5 1.5 -1.5 1.5];

figure(4); RR_rlocus(Gz,Dz,g_r_d); hold on; % zgrid;
r=1; c=0; w=c+r*exp(i*[0:pi/50:2*pi]); plot(real(w),imag(w),'b--') % Draw a simple circle
pause

d=h/2; TF_pade_delay=RR_pade(d,2,2); Gd=G*TF_pade_delay;
figure(5); g.K=logspace(-1.5,4.5,300); g.axes=[-400 400 -400 400];
RR_rlocus(Gd,D,g); pause

figure(6); g.K=logspace(-1.5,3,300); g.axes=[-40 40 -40 40];
RR_rlocus(Gd,D,g)





