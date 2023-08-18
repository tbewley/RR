% script RR_Ex10_01_voltage_divider
% Solves the basic equations of a voltage divider.
% This example is easy to solve by hand, but illustrates how
% to put three linear equations into A*x=b form and solve using Matlab.
% This idea is quite valuable for larger systems of linear equations.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

clear, close all, syms s V1 V2 R1 R2

% First-order low-pass RC filter: Solve for V_o as a function of V_i
% x={I1, I2, Vmid}  <-- unknown vector   
A  =[ 1  -1    0;     % I1 - I2 = 0
     R1   0    1;     % I1*R1 + Vmid = V1
      0   R2  -1];    % I2*R2 - Vmid = - V2
b  =[ 0; V1; -V2];
x=A\b; Vmid=simplify(x(3))
