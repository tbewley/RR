% script RR_Amplifier_Class_A
% Solves the basic equations of a Class A amplifier.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under Modified BSD License.

clear, syms s V_in V_s alpha C0 R1 R2 R3 R4 V_B

% Part A: Solve for V_B as a function of V_in and V_s.
% x={I_0,I_1,I_2,V_B}   <-- unknown vector (sets I_B=0)
A  =[ 1   0   0  C0*s;
      0  R1   0   1;
      0   0  R2  -1;
      1   1  -1   0];
b  =[ C0*s*V_in; V_s; 0; 0];
x=A\b; simplify(x(4))

% Part B: Solve for V_out as a function of V_B and V_s.
% x={I_C,I_E,V_C,V_E,I_5,V_out}  <-- unknown vector
A  =[-1 alpha  0   0;
      0   0    0   1;
     R3   0    1   0;
      0  R4    0  -1];
b  =[ 0; V_B-0.7; V_s; 0];
x=A\b; simplify(x(3))
