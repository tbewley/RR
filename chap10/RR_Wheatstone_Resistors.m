% script RR_Wheatstone_Resistors
% Computes the currents and nodal voltages in a Wheatstone Bridge of resistors.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under Modified BSD License.

% The following compact method of solution applies only to linear systems.
syms R5; V0=5; R1=1e3; R2=1e3; R3=1e5; R4=1e3; % <--- list constants
% I_0 I_1 I_2 I_3 I_4 I_5 V_a V_b                <--- list unknowns
A=[1  -1  -1   0   0   0   0   0;   % I_0 - I_1 - I_2 = 0  <-- list equations in Ax=b form
   0   1   0  -1  -1   0   0   0;   % I_1 - I_3 - I_4 = 0       
   0   0   1   1   0  -1   0   0;   % I_2 + I_3 - I_5 = 0
   0  R1   0   0   0   0   1   0;   % R1*I_1 + V_a = V0
   0   0  R2   0   0   0   0   1;   % R2*I_2 + V_b = V0
   0   0   0  R3   0   0  -1   1;   % R3*I_3 - V_a + V_b = 0
   0   0   0   0  R4   0  -1   0;   % R4*I_4 - V_a = 0
   0   0   0   0   0  R5   0  -1];  % R5*I_5 - V_b = 0
b=[0; 0; 0; V0; V0; 0; 0; 0]; x=A\b; x(4)  % <-- Solve, then display component of interest
