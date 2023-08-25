% script RR_Ex10_01_voltage_divider
% Solves the equations of a simple voltage divider.
% This example is very easy to solve by hand, but illustrates how
% to put three linear equations into A*x=b form and solve using Matlab.
% This idea is quite valuable for larger systems of linear equations.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

% pkg load symbolic  % uncomment this line if running in octave

clear, close all, syms s V1 V2 R1 R2

% x={Vmid, I1, I2}  <-- unknown vector   
A  =[  1   R1   0;   % Vmid +I1*R1  = V1
       1    0 -R2;   % Vmid  -I2*R2 = V2
       0    1  -1];  %       I1 -I2 = 0
b  =[ V1;  V2; 0];
x=A\b; Vmid=simplify(x(1))
