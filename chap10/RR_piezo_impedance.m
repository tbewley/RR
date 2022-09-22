% script RR_piezo_impedance
% Computes the currents and intermediate nodal voltages of a Wheatstone Bridge with two capacitors.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under Modified BSD License.

clear; syms s Ii C1 C2 R2 L2;      % <--- list constants
%  I_1 I_2 V_i  V_a V_b              <--- list unknowns
A=[ 1   1   0    0   0    % I_1 + I_2 = Ii     <-- list equations in Ax=b form
   -1   0 s*C1   0   0    % s*C1*Vi - I1 = 0       
    0  -1 s*C2 -s*C2 0    % s*C2*Vi - s*C2*Va - I2 = 0
    0  -R2  0    1  -1    % V_a - V_b - R2*I2 = 0
    0 -s*L2 0    0   1];  % V_b - s*L2*I2 = 0     
b=[Ii; 0; 0; 0; 0]; x=A\b; x(3)  % <-- Solve
R1=1e3; R4=1e3; R3=1e5;   % Apply constants

for crystal=1:2
   switch crystal
      case 1
         C1= 20e-15
         C2=500e-12
         L2=  5e-6
         R2=   1
      case 2         % 6 MHz Quartz oscillator
         C1= 1e-12
         C2= 4e-15
         L2= 200e-3
         R2= 50
   end

   omega_r=1/sqrt(L2*C2)
   zeta_r =R2/(2*omega_r*L2)
   Ca     =C1*C2/(C1+C2)
   omega_a=1/sqrt(L2*Ca)
   zeta_a =R2/(2*omega_a*L2)
   K=1/C1

   bode(tf(K*[1 2*zeta_r*omega_r omega_r^2],[1 2*zeta_a*omega_a omega_a^2 0])) % 

   % g.omega=logspace(log10(3.4e7),log10(3.6e7),100)
   % RR_bode(K*[1 2*zeta_r*omega_r omega_r^2],[1 2*zeta_a*omega_a omega_a^2 0],g) % 

   pause
end
