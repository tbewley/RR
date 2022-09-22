% script RR_piezo_impedance
% Computes the currents and intermediate nodal voltages of a Wheatstone Bridge with two capacitors.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under Modified BSD License.

clear; syms Ii C1 C2 L2;           % <--- list constants
%  I_1 I_2 V_i  V_a V_b              <--- list unknowns
A=[ 1   1   0    0   0    % I_1 + I_2 = Ii     <-- list equations in Ax=b form
   -1   0 s*C1   0   0    % s*C1*Vi - I1 = 0       
    0  -1 s*C2 -s*C2 0    % s*C2*Vi - s*C2*Va - I2 = 0
    0  -R2  0    1  -1    % V_a - V_b - R2*I2 = 0
    0 -s*L2 0    0   1];  % V_b - s*L2*I2 = 0     
b=[Ii; 0; 0; 0; 0]; x=A\b; x(3)  % <-- Solve
R1=1e3; R4=1e3; R3=1e5;   % Apply constants
