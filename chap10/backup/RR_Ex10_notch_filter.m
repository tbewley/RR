% script RR_Ex10_notch_filter
% This code implments the equations governing the notch filter,
% as discussed in problem 1 of the 2020 midterm in MAE40.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License. 

clear; syms s R L C c1 V0      % NOTE: We will solve for V1 as a fn of V0
% x={Ir; Il; Ic; Iload; V1; V2}  <-- unknown vector   
A  =[ 1  -1   0  -1      0   0;   % Ir - Il - Iload = 0   KCL1
      0   1  -1   0      0   0;   % Il - Ic = 0           KCL2
      R   0   0   0      1   0;   % V1 + R*Ir = V0        resistor eqn
      0 -L*s  0   0      1  -1;   % V1 - V2 - L*s*Il = 0  inductor eqn
      0   0   1   0      0 -C*s;  % Ic      - C*s*V2 = 0  capacitor eqn
      0   0   0  R/c1   -1   0];  % Iload*(R/c1) - V1 = 0 load eqn
b  =[ 0;  0; V0; 0; 0; 0];
x=A\b; V1_notch=simplify(x(5))
% DISCUSSION:
% => V1/V0 = (C*L*s^2 + 1)/(C*(1+c1)*L*s^2 + C*R*s + 1+c1)
%          = 1/(1+c1) * (s^2+omega0^2)/(s^2 + (R/L)*s/(1+c1) + omega0^2)
%          = K * (s^2+omega0^2)/(s^2 + 2*zeta*omega0*s + omega0^2) % defines zeta
%          = K * (s^2+omega0^2)/(s^2 + (1/Q) *omega0*s + omega0^2) % defines Q
% where omega0=1/sqrt(L*C), K=1/(1+c1), and
% (R/L)/(1+c1)=2*zeta*omega0 => zeta=R*sqrt(C/L)/(2*(1+c1)),
% (1/Q)=2*zeta               => Q=1/(2*zeta)=(1+c1)*sqrt(L/C)/R.
% Q and zeta are two standard ways to define the sharpness of the notch.
% zeta is called the "damping ratio", and
% Q    is called the "quality" of this notch filter.

c1=1              % Now assume that c1 is this value, and that {R,L,C,c1} are
omega0=10, Q=5    % selected such that omega0 and Q take these values. Then:
K=1/(1+c1); F_notch=RR_tf(K*[1 0 omega0^2],[1 (1/Q)*omega0 omega0^2]);
close all; figure(1), RR_bode(F_notch)
subplot(2,1,1); a=axis; plot([a(1) a(2)],K*0.707*[1 1],'k-')

% Defined another way, Q=omega0/BW, where BW is the range of frequencies in which
% the magnitude of the output is reduced by 3 dB = 0.707 or more, which corresponds
% to the power of the output being reduced by 50% or more.
% Zooming in, in the case of c1=1, omega0=10, Q=5, it is seen that this notch filter
% attenuates by 3 dB between 9.05 rad/s and 11.05 rad/s.  Thus, omega0/BW=10/(11.05-9.05)=5,
% which is exactly the Q factor that the filter is designed for above.  Cool.
