% script RR_Amplifier_Class_A
% Solves the basic equations of a Class A amplifier.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under Modified BSD License.

clear, syms s V_in V_s alpha C0 R1 R2 R3 R4 V_B

% Part A: Solve for V_B as a function of V_in and {V_s,C0,R1,R2}.
% x={I_0,I_1,I_2,V_B}  <-- unknown vector (assumes I_B is negligible)
A  =[ 1   1  -1   0;    % I_0 + I_1 - I_2 \approx 0
      1   0   0  C0*s;  % I_0 + C0*s*V_B = C*s*V_in
      0  R1   0   1;    % R1*I_1 + V_B = V_s
      0   0  R2  -1];   % R2*I_2 - V_B = 0
b  =[ 0; C*s*V_in; V_s; 0];
x=A\b; V_B=simplify(x(4))

% Part B: Solve for V_out as a function of V_B and {alpha,V_d,V_s,R3,R4,C5}
% x={I_C,I_B,I_E,V_C,V_B,V_E,I_3,I_5,V_out}  <-- unknown vector
A  =[ 1   1  -1   0   0   0   0   0   0; % I_B+I_C-I_E = 0
     -1   0 alpha 0   0   0   0   0   0;
     


      0   0    0   1;
     R3   0    1   0;
      0  R4    0  -1];
b  =[ 0; V_B-V_d; V_s; 0];
x=A\b; V_out=simplify(x(3))
