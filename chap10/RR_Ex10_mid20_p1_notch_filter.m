% script RR_Ex10_mid20_p1_notch_filter
% This code implments the equations governing the Notch filter,
% as discussed in problem 1 of the 2020 midterm in MAE40.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License. 

clear; syms s R L C c1 V0      % NOTE: We will solve for V1 as a fn of V0
% x={Ir; Il; Ic; Iload; V1; V2}  <-- unknown vector   
A  =[ 1  -1   0  -1      0   0;   % Ir - Il - Iload = 0  KCL1
      0   1  -1   0      0   0;   % Il - Ic = 0          KCL2
      R   0   0   0      1   0;   % V1 + R*Ir = V0       resistor eqn
      0 -L*s  0   0      1  -1;   % V1 - V2 - L*s*Il = 0 inductor eqn
      0   0   1   0      0 -C*s;  % Ic      - C*s*V2 = 0 capacitor eqn
      0   0   0  R/c1   -1   0];  % Iload*(R/c1) - V1 = 0 load eqn
b  =[ 0;  0; V0; 0; 0; 0];
x=A\b; V1_notch=simplify(x(5))

c1=1;
omega0=10 % = 1/sqrt(L*C)
Q =10;    % = 1/(R*C*omega0) 
F_notch=RR_tf([1 0 omega0^2]/(1+c1),[1 omega0/Q/(1+c1) omega0^2]);
close all; figure(1), RR_bode(F_notch)
