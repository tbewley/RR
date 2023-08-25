% script RR_Ex10_06_Wheatstone_capacitors
% Computes all currents and nodal voltages of a Wheatstone Bridge with two capacitors.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

% pkg load symbolic  % uncomment this line if running in octave

% Set up Ax=b yourself...
syms s C2 C5 Vin; R1=1e3; R3=1e5; R4=1e3;      % <- list constants
%  I0 I1  I2  I3  I4  I5  Va  Vb                 <- list unknowns
A=[1  -1  -1   0   0   0   0   0;    % I0 -I1 -I2        = 0  <- list eqns as Ax=b
   0   1   0  -1  -1   0   0   0;    %  I1 -I3 -I4       = 0       
   0   0   1   1   0  -1   0   0;    %   I2 +I3 -I5      = 0
   0  R1   0   0   0   0   1   0;    %  R1*I1  +Va       = Vin
   0   0   1   0   0   0   0 C2*s;   %   I2 +C2*s*Vb     = C2*s*Vin *CHANGED*
   0   0   0  R3   0   0  -1   1;    %    R3*I3  -Va +Vb = 0
   0   0   0   0  R4   0  -1   0;    %     R4*I4 -Va     = 0
   0   0   0   0   0   1   0 -C5*s]; %      I5 - C5*s*Vb = 0        *CHANGED*
b=[0; 0; 0; Vin; C2*s*Vin; 0; 0; 0]; x=A\b; % solve
F_wheatstone_capacitors1=simplify(x(4)/Vin)  % display result as I3/Vin

% ... or have "solve" do the reorganization work for you - easier!
clear; syms s C2 C5 Vin;          % <- Laplace variable s, parameters, input Vin
R1=1e3; R3=1e5; R4=1e3;
syms I0 I1 I2 I3 I4 I5 Va Vb  % <- unknown variables (output is I3)
eqn1=  R1*I1 == Vin-Va; % R1 eqn
eqn2=  I2 == C2*s*(Vin-Vb); % C2 eqn  *CHANGED*
eqn3=  R3*I3 == Va-Vb;  % R3 eqn
eqn4=  R4*I4 == Va;     % R4 eqn
eqn5=  I5 == C5*s*Vb;       % C5 eqn  *CHANGED*
eqn6=     I0 == I1+I2;  % KCL1
eqn7=     I1 == I3+I4;  % KCL2
eqn8=     I5 == I2+I3;  % KCL3
sol=solve(eqn1,eqn2,eqn3,eqn4,eqn5,eqn6,eqn7,eqn8,I0,I1,I2,I3,I4,I5,Va,Vb);
F_wheatstone_capacitors2=simplify(sol.I3/Vin)   % display result as I3/Vin

% Note: as compared to RR_Ex10_5_Wheatstone_Resistors, only 2 eqns changed.
