% script RR_passive_filters
% Solves the basic equations of four simple passive filters.
% These are all quite easily solved by hand, but these examples well illustrate how
% to put a handful of linear equations into A*x=b form and solve using Matlab.
% This general strategy is quite useful, because it easily extends to much larger systems
% of linear equations, which are tedios (and, quite prone to error) if solving by hand.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

clear, syms s V_i V_s C L R R1 R2

% First-order low-pass RC filter: Solve for V_o as a function of V_i
% x={I_C,I_R,V_o}  <-- unknown vector   
A  =[ 1  -1   0;     % I_C - I_R = 0
      1   0 -C*s;    % I_C - C*s*V_o = 0
      0   R   1];    % R*I_R + V_o = V_i
b  =[ 0; 0; V_i];
x=A\b; LPF1=simplify(x(3))

% First-order high-pass RC filter: Solve for V_o as a function of V_i
% x={I_C,I_R,V_o}  <-- unknown vector  
A  =[ 1  -1   0;     % I_C - I_R = 0
      1   0  C*s;    % I_C + C*s*V_o = C*s*V_i
      0   R  -1];    % R*I_R - V_o = 0
b  =[ 0; C*s*V_i; 0];
x=A\b; HPF1=simplify(x(3))

% Voltage-biased first-order high-pass RC filter: Solve for V_o as a function of V_i and V_s
% x={I_0,I_1,I_2,V_o}  <-- unknown vector
A  =[ 1   1  -1   0;   % I_C + I_1 - I_2 = 0
      1   0   0  C*s;  % I_C + C*s*V_o = C*s*V_i
      0  R1   0   1;   % R1*I_1 + V_o = V_s
      0   0  R2  -1];  % R2*I_2 - V_o = 0
b  =[ 0; C*s*V_i; V_s; 0];
x=A\b; HPF1biased=simplify(x(4))

% Second-order low-pass LC filter: Solve for V_o as a function of V_i
% x={I_L,I_C,V_o}  <-- unknown vector
A  =[ 1  -1   0;    % I_L - I_C = 0
     L*s  0   1;    % L*s*I_L + V_o = V_i
      0  -1  C*s];  % C*s*V_o - I_C = 0
b  =[ 0; V_i; 0];
x=A\b; LPF2=simplify(x(3))
