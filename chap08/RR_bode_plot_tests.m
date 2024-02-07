% script RR_bode_plot_tests
% This script just plots a few Bode plots, for practice.  :)
%% Renaissance Robotics codebase, Chapter 8, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

disp('high-pass, low-pass, band-pass')
figure(1), clf, F_HPa=RR_tf([1 0],[1 1]);          RR_bode(F_HPa)
figure(2), clf, F_LPa=RR_tf([100],[1 100]);        RR_bode(F_LPa)
figure(3), clf, F_BP=F_LPa*F_HPa;                  RR_bode(F_BP), pause

disp('lag, lead, lead-lag')
figure(1), clf, F_lag=RR_tf([1 1],[1 0.1]);        RR_bode(F_lag)
figure(2), clf, F_lead=10*RR_tf([1 100],[1 1000]); RR_bode(F_lead)
figure(3), clf, F_leadlag=F_lead*F_lag;            RR_bode(F_leadlag), pause

disp('PID (fig 1) vs lead-lag (fig 3)')
figure(2), clf, g.log_omega_min=-2; g.log_omega_max=4;
figure(1), clf, F_PID=0.01*RR_tf([1 101 100],[1 0]); RR_bode(F_PID,g), pause

disp('low-pass, high-pass, band-stop')
figure(1), clf, F_LPb=RR_tf(1,[1 1]);              RR_bode(F_LPb)
figure(2), clf, F_HPb=RR_tf([1 0],[1 100]);        RR_bode(F_HPb)
figure(3), clf, F_BS=F_LPb+F_HPb;                  RR_bode(F_BS), pause

disp('Q=0.5 notch (fig 1) vs Q=5 notch (fig 2) vs band-stop (fig 3)')
g.log_omega_min=-1; g.log_omega_max=3;
figure(1), clf, Q=0.5; F_notcha=RR_tf([1 0 100],[1 10/Q 100]); RR_bode(F_notcha,g),
figure(2), clf, Q=5;   F_notchb=RR_tf([1 0 100],[1 10/Q 100]); RR_bode(F_notchb,g), pause

disp('all-pass'), g.log_omega_min=-2; g.log_omega_max=2;
figure(1), clf, F_AP1=   RR_tf([1 -1],[1 1]); RR_bode(F_AP1,g), 
figure(2); clf, F_AP2=-1*RR_tf([1 -1],[1 1]); RR_bode(F_AP2,g),
figure(3); clf, F_AP3=-1*RR_tf([1 1],[1 -1]); RR_bode(F_AP3,g),
