% script RR_Ex10_10_piezo_impedance
% Computes the impedence of a Butterworth/van Dyke circuit model of a piezo.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

clear; syms s I_i Co C1 R1 L1;      % <- list constants
%  I_o I_1  V_i  V_a  V_b             <- list unknowns
A=[ 1   1    0    0    0   % I_o + I_1 = I_i    <- list equations in Ax=b form
   -1   0  s*Co   0    0   % s*Co*Vi - I_o = 0      
    0  -1  s*C1 -s*C1  0   % s*C1*Vi - s*C1*Va - I_1 = 0
    0 -s*L1  0    1   -1   % V_a - V_b  - s*L1*I_1 = 0     
    0  -R1   0    0    1]; % V_b - R1*I_1 = 0
b=[I_i; 0; 0; 0; 0]; x=A\b; x(3)  % <-- Solve
R1=1e3; R4=1e3; R3=1e5;   % Apply constants

for crystal=1:2
   switch crystal
      case 1
         Co=  2e-9;
         C1=0.5e-9;
         L1=  5e-6;
         R1=   1;
         g.log_omega_min=log10(4.99e5);
         g.log_omega_max=7;
         g.omega_N=3000;
         g.Hz=true;
      case 2         % 5.6 MHz Quartz oscillator
         Co=   1e-12;
         C1=   4e-15;
         L1= 200e-3;
         R1=   50;
         g.log_omega_min=log10(5.5499e6);
         g.log_omega_max=log10(5.7e6);
         g.omega_N=3000;
         g.Hz=true;
   end

   omega_r =1/sqrt(L1*C1);  omega_r_Hz=omega_r/(2*pi),  zeta_r=R1/(2*omega_r*L1);
   Ca      =Co*C1/(Co+C1);
   omega_a =1/sqrt(L1*Ca);  omega_a_Hz=omega_a/(2*pi),  zeta_a=R1/(2*omega_a*L1);
   K=1/Co;

   figure(crystal), clf
   G=RR_tf(K*[1 2*zeta_r*omega_r omega_r^2],[1 2*zeta_a*omega_a omega_a^2 0]);
   RR_bode(G,g)
end
