% script RR_Ex10_05_Wheatstone_resistors
% Computes all currents and nodal voltages in a Wheatstone Bridge of resistors.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

% Note: the following compact method of solution applies only to linear systems.
syms R5; V0=5; R1=1e3; R2=1e3; R3=1e5; R4=1e3; % <- list constants
%  I0 I1  I2  I3  I4  I5  Va  Vb                 <- list unknowns
A=[1  -1  -1   0   0   0   0   0;   % I0 - I1 - I2 = 0  <- list equations in Ax=b form
   0   1   0  -1  -1   0   0   0;   % I1 - I3 - I4 = 0       
   0   0   1   1   0  -1   0   0;   % I2 + I3 - I5 = 0
   0  R1   0   0   0   0   1   0;   % R1*I1 + Va = V0
   0   0  R2   0   0   0   0   1;   % R2*I2 + Vb = V0
   0   0   0  R3   0   0  -1   1;   % R3*I3 - Va + Vb = 0
   0   0   0   0  R4   0  -1   0;   % R4*I4 - Va = 0
   0   0   0   0   0  R5   0  -1];  % R5*I5 - Vb = 0
b=[0; 0; 0; V0; V0; 0; 0; 0]; x=A\b; I3=x(4)  % <- Solve, then display I3