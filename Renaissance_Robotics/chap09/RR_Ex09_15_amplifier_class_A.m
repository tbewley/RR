% script RR_Ex10_15_amplifier_class_A
% Solves the equations of a simple Class A amplifier.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 9)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% pkg load symbolic  % uncomment this line if running in octave

clear
% The setup is defined by the following inputs:
Vs=12        % Voltage of the source
Vd=0.7       % Cut-in voltage of diode at V_BE
absK=10      % Desired gain of amplifier
ICmax=50e-3  % Maximum current through R3 and R4
alphaF=0.99  % alphaF of transistor
IB=120e-6    % base current at Q point
fi=10        % frequency of high-pass filter at input
% and you can fiddle some with this (to reach an available C...)
I1=36*IB     % somewhere between 35 and 100 is probably good

syms R1 R2 I2 R3 R4
% Start with analysis of part ii
eqn1= Vs==ICmax*(R3+R4)
eqn2= absK==alphaF*R3/R4
sol=solve(eqn1,eqn2,R3,R4);
R3=eval(sol.R3), R4=eval(sol.R4)

% Given knowledge of R4, we can now do analysis of part i
ICquiescent=ICmax/2, VE=ICquiescent*R4, VB=VE+Vd, omegai=fi*pi/180
eqnA= I1==I2+IB
eqnB= Vs-VB==I1*R1
eqnC= VB==I2*R2
sol=solve(eqnA,eqnB,eqnC,R1,R2,I2);
R1=eval(sol.R1), R2=eval(sol.R2), I2=eval(sol.I2)
Ri=R1*R2/(R1+R2); C=1/(Ri*omegai)
