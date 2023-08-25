% script RR_Ex10_02_passive_filters
% Solves the basic equations of four simple passive filters.
% These examples are also easy to solve by hand, but illustrate how
% to put a few linear equations into A*x=b form and solve using Matlab.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

% pkg load symbolic  % uncomment this line if running in octave

clear, close all, syms s Vin Vs C L R R1 R2

% First-order low-pass RC filter
% x=[Vout; Ic; Ir]  <-- unknown vector   
A = [ C*s  -1   0;  % C*s*Vout -Ic  = 0
       1    0   R;  % Vout    +R*Ir = Vin
       0    1  -1]; %        Ic -Ir = 0
b =[0; Vin; 0]; x=A\b;
F_LPF1=simplify(x(1)/Vin)  % Define omega1=1/(C*R)
omega1=10; F_LPF1=RR_tf([omega1],[1 omega1]);
figure(1), RR_bode(F_LPF1), pause

% First-order high-pass RC filter
% x=[Vout; Ic; Ir]  <-- unknown vector  
A  =[ C*s   1   0;  % C*s*Vout +Ic  = C*s*Vin
       1    0  -R;  % Vo      -R*Ir = 0
       0    1  -1]; %        Ic -Ir = 0
b  =[C*s*Vin; 0; 0]; x=A\b;
F_HPF1=simplify(x(1)/Vin)  % Define omega1=1/(C*R)
omega1=10; F_HPF1=RR_tf([1 0],[1 omega1]);
figure(2), RR_bode(F_HPF1), pause

% Voltage-biased first-order high-pass RC filter
% x=[Vout; Ic; I1; I2]  <-- unknown vector
A  =[ C*s   1   0   0;  % C*s*Vout +Ic  = C*s*Vin
       1    0  R1   0;  % Vout +R1*I1   = Vs
       1    0   0 -R2;  % Vout -R2*I2   = 0
       0    1   1  -1]; %    Ic +I1 -I2 = 0
b  =[C*s*Vin; Vs; 0; 0];
% (Here, we solve for Vo as a function of both Vi and Vs)
x=A\b; Vo_HPF1biased=simplify(x(1)), pause

% Second-order low-pass LC filter
% x=[Vout; Il; Ic]  <-- unknown vector
A  =[  0    1  -1;  %        Il -Ic = 0
       1   L*s  0;  % Vout +L*s*Il  = Vin
      C*s   0  -1]; % C*s*Vout  -Ic = 0
b  =[ 0; Vin; 0]; x=A\b;
F_LPF2_undamped=simplify(x(1)/Vin) % Define omega3=1/sqrt(C*L)
omega3=10; F_LPF2_undamped=RR_tf([omega3^2],[1 0 omega3^2]);
figure(3), RR_bode(F_LPF2_undamped)
