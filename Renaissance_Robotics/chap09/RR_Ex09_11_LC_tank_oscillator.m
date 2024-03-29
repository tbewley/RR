% script RR_Ex10_11_LC_tank_oscillator
% Solve the equations of an LC tank oscillator.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 9)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% pkg load symbolic  % uncomment this line if running in octave

% Simple LC tank: computation of Vout(s)
clear; syms C1 C2 L3 R4 I Va Vb Vout Vs s
eqn1= I==-s*C2*Va;
eqn2= Va-Vb==s*L3*I;
eqn3= Vb-Vout==R4*I;
eqn4= I==C1*(s*Vout-Vs);
sol=solve(eqn1,eqn2,eqn3,eqn4,I,Va,Vb,Vout); Vout=sol.Vout
pause

% Simple LC tank: compute {B2,B1,B0} in partial fraction expansion
clear; syms B2 B1 B0 b2 b1 b0 sigma omegad
eqn1= b2==B2+B1;
eqn2= b1==B2*2*sigma+B1*sigma+B0*omegad;
eqn3= b0==B2*(sigma^2+omegad^2);
sol=solve(eqn1,eqn2,eqn3,B2,B1,B0); B2=sol.B2, B1=sol.B1, B0=sol.B0