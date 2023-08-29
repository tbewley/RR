% script RR_Ex10_antinotch_filter
% This code implments the equations governing the so-called "anti-notch" filter,
% as discussed in problem 1 of the 2023 midterm in MAE40.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License. 

% Set up Ax=b yourself...
clear; syms s R L C c1 Vin    % <- Laplace variable s, parameters, input Vin
% x=[Vout; Va; Ir; Ic; Iload]   <-- unknown vector (output is Vout)    
A  =[ -1   0   R   0    0;   %  -Vout  +R*Ir         = 0   resistor eqn
       0   1   0  L*s   0;   %     Va    +L*s*Ic     = Vin inductor eqn
    -C*s  C*s  0  -1    0;   % -C*s*Vout +C*s*Va -Ic = 0   capacitor eqn
      -1   0   0   0  R/c1;  % -Vout     +Iload*R/c1 = 0   load eqn
       0   0  -1   1   -1];  %        -Ir +Ic -Iload = 0   KCL
b  =[ 0;  Vin; 0; 0; 0];
x=A\b; F_antinotch1=simplify(x(1)/Vin)

% ... or have "solve" do the reorganization work for you
clear; syms s R L C c1 Vin   % <- Laplace variable s, parameters, input Vin
syms Vout Va Ir Ic Iload     % <- unknown variables (output is Vout)
eqn1=     Vout == R*Ir;          % resistor eqn
eqn2=   Vin-Va == L*s*Ic;        % inductor eqn
eqn3=       Ic == C*s*(Va-Vout); % capacitor eqn
eqn4=     Vout == Iload*R/c1;    % load eqn
eqn5=       Ic == Ir + Iload;    % KCL
sol=solve(eqn1,eqn2,eqn3,eqn4,eqn5,Vout,Va,Ir,Ic,Iload); % solve!
F_antinotch2=simplify(sol.Vout/Vin) % transfer fn of filter = Vout/Vin

% DISCUSSION:
% => V1/V0 = C*R*s /( C*L*(1+c1)*s^2 + C*R*s + (1+c1) )
%          = (R/L)/(1+c1) * s /(s^2 + (R/L)*s/(1+c1) + omega0^2)
%          = K*s /(s^2 + 2*zeta*omega0*s + omega0^2) % defines zeta
%          = K*s /(s^2 + (1/Q) *omega0*s + omega0^2) % defines Q
% where omega0=1/sqrt(L*C), K=(R/L)/(1+c1), and
% (R/L)/(1+c1)=2*zeta*omega0 => zeta=R*sqrt(C/L)/(2*(1+c1)),
% (1/Q)=2*zeta               => Q=1/(2*zeta)=(1+c1)*sqrt(L/C)/R.
% [Note: it follows that K=(1/Q)*omega0]
% Q and zeta are two standard ways to define the sharpness of the "anti-notch.
% zeta is called the "damping ratio", and
% Q    is called the "quality" of this "anti-notch" filter.

c1=0            % First assume that c1=0, and that {R,L,C} are selected such that
omega0=10, Q=5  % omega0 and Q take these values. Then:
F_anti_notch_Q5=RR_tf([(1/Q)*omega0 0],[1 (1/Q)*omega0 omega0^2]);
close all; figure(1), RR_bode(F_anti_notch_Q5)
subplot(2,1,1); a=axis; plot([a(1) a(2)],0.707*[1 1],'k-')

c1=1; Q=(1+c1)*Q;  % Then assume that c1 changes, and {R,L,C} are unchanged.  Then
F_anti_notch_Q10=RR_tf([(1/Q)*omega0 0],[1 (1/Q)*omega0 omega0^2]);
g.linestyle='r-.'; RR_bode(F_anti_notch_Q10,g)

% Defined another way, Q=omega0/BW, where BW is the range of frequencies in which
% the magnitude of the output is reduced by 3 dB = 0.707 or more from the peak,
% which corresponds to the power of the output being reduced by 50% or more.
% Zooming in, in the case of c1=0, omega0=10, Q=5, it is seen that this notch filter
% attenuates by 3 dB between 9.05 rad/s and 11.05 rad/s.  Thus, omega0/BW=10/(11.05-9.05)=5,
% which is exactly the Q factor that the filter above is designed for.  Cool.