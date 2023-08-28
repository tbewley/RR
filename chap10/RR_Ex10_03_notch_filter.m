% script RR_Ex10_03_notch_filter.m
% This code implments the equations governing the notch filter,
% as discussed in problem 1 of the 2020 midterm in MAE40.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License. 

% pkg load symbolic  % uncomment this line if running in octave

% In the first code block below, you have to set up Ax=b yourself.
% In the second block the "solve" algorithm does the reorganization work for you,
% which is easier!  Both approaches give the same answer.  Pick your favorite.

clear; syms s R L C c1 Vin      % <- Laplace variable s, parameters, input Vin
% x={Vout; Va; Ir; Ic; Iload}     <- unknown vector  
A  =[  1    0   R   0     0;    % Vout +R*Ir         = Vin   resistor eqn
       1   -1   0 -L*s    0;    % Vout -Va -L*s*Ic   = 0     inductor eqn [note: Ic=IL]
       0 -C*s   0   1     0;    %  -C*s*Va   +Ic     = 0     capacitor eqn
      -1    0   0   0   R/c1;   % -Vout  +Iload*R/c1 = 0     load eqn
       0    0   1  -1    -1];   %     Ir -Ic  -Iload = 0     KCL1  [KCL2 is just Ic=IL]
b  =[ Vin; 0;  0; 0; 0]; x=A\b;
F_notch1=simplify(x(1)/Vin)     % transfer fn of filter = Vout/Vin via Ax=b method.
clear; syms s R L C c1 Vin      % <- Laplace variable s, parameters, input Vin
syms Vout Va Ir Ic Iload        % <- unknown variables
eqn1= Vin-Vout == R*Ir;         % resistor eqn [written here in "easily readable" form]
eqn2=  Vout-Va == L*s*Ic;       % inductor eqn [note: Ic=IL]
eqn3=       Ic == C*s*Va;       % capacitor eqn
eqn4=     Vout == Iload*R/c1;   % load eqn
eqn5=       Ir == Ic + Iload;   % KCL1  [KCL2 is just Ic=IL]
sol=solve(eqn1,eqn2,eqn3,eqn4,eqn5,Vout,Va,Ir,Ic,Iload); % rearrange automatically, solve!
F_notch2=simplify(sol.Vout/Vin) % transfer fn of filter = Vout/Vin via "solve" method.

% DISCUSSION:
% => Vout/Vin = (C*L*s^2 + 1)/(C*(1+c1)*L*s^2 + C*R*s + 1+c1)
%          = 1/(1+c1) * (s^2+omega0^2)/(s^2 + (R/L)*s/(1+c1) + omega0^2)
%          = K * (s^2+omega0^2)/(s^2 + 2*zeta*omega0*s + omega0^2) % defines zeta
%          = K * (s^2+omega0^2)/(s^2 + (1/Q) *omega0*s + omega0^2) % defines Q
% where omega0=1/sqrt(L*C), K=1/(1+c1), and
% (R/L)/(1+c1)=2*zeta*omega0 => zeta=R*sqrt(C/L)/(2*(1+c1)),
% (1/Q)=2*zeta               => Q=1/(2*zeta)=(1+c1)*sqrt(L/C)/R.
% notchQ and zeta are two standard ways to define the sharpness of the notch.
% zeta is called the "damping ratio", and
% Q    is called the "quality" of this notch filter.

c1=0             % Now assume that c1 is this value, and that {R,L,C,c1} are
omega0=10, Q=5   % selected such that omega0 and Q take these values. Then:
F_notch_over_K_Q5=RR_tf([1 0 omega0^2],[1 (1/Q)*omega0 omega0^2]);
close all; figure(1), RR_bode(F_notch_over_K_Q5)
subplot(2,1,1); a=axis; plot([a(1) a(2)],0.707*[1 1],'k-')

c1=1             % Now assume that c1 is this value, and that {R,L,C,c1} are
Q=Q*(1+c1);      % selected the same as before (so omega0 is unchanged). Then:
F_notch_over_K_Q10=RR_tf([1 0 omega0^2],[1 (1/Q)*omega0 omega0^2]);
g.linestyle="r-."; RR_bode(F_notch_over_K_Q10,g)

% Defined another way, Q=omega0/BW, where BW is the range of frequencies in which
% the magnitude of the output is reduced by 3 dB = 0.707 or more, which corresponds
% to the power of the output being reduced by 50% or more.
% Zooming in, in the case of c1=1, omega0=10, Q=5, it is seen that this notch filter
% attenuates by 3 dB between 9.05 rad/s and 11.05 rad/s.  Thus, omega0/BW=10/(11.05-9.05)=5,
% which is exactly the Q factor that the filter above is designed for.  Cool.
