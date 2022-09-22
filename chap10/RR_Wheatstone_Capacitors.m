% script RR_Wheatstone_Capacitors
% Computes the currents and intermediate nodal voltages of a Wheatstone Bridge with two capacitors.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under Modified BSD License.

% As compared to RR_Wheatstone_Resistors (Algorithm 10.2), only 2 equations have changed.
syms C2 C5 s V0; R1=1e3; R4=1e3; R3=1e5; % <--- list constants
% I_0 I_1 I_2 I_3 I_4 I_5 V_a V_b          <--- list unknowns
A=[1  -1  -1   0   0   0   0   0;    % I_0 - I_1 - I_2 = 0  <-- list equations in Ax=b form
   0   1   0  -1  -1   0   0   0;    % I_1 - I_3 - I_4 = 0       
   0   0   1   1   0  -1   0   0;    % I_2 + I_3 - I_5 = 0
   0  R1   0   0   0   0   1   0;    % R1*I_1 + V_a = V0
   0   0   1   0   0   0   0 C2*s;   % I_2 + C2*s*V_b = C2*s*V0   ** CHANGED **
   0   0   0  R3   0   0  -1   1;    % R3*I_3 - V_a + V_b = 0
   0   0   0   0  R4   0  -1   0;    % R4*I_4 - V_a = 0
   0   0   0   0   0   1   0 -C5*s]; % I_5 - C5*s*V_b = 0         ** CHANGED **
b=[0; 0; 0; V0; C2*s*V0; 0; 0; 0]; x=A\b; x(4)  % <-- Solve