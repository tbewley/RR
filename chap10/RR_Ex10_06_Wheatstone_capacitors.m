% script RR_Ex10_06_Wheatstone_capacitors
% Computes all currents and intermediate nodal voltages of a Wheatstone Bridge with two capacitors.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

syms s C2 C5 Vin; R1=1e3; R3=1e5; R4=1e3;       % <- list constants
% I0  I1  I2  I3  I4  I5  Va  Vb                 <- list unknowns
A=[1  -1  -1   0   0   0   0   0;    % I0 -I1 -I2        = 0  <- list eqns as Ax=b
   0   1   0  -1  -1   0   0   0;    %  I1 -I3 -I4       = 0       
   0   0   1   1   0  -1   0   0;    %   I2 +I3 -I5      = 0
   0  R1   0   0   0   0   1   0;    %  R1*I1  +Va       = Vin
   0   0   1   0   0   0   0 C2*s;   %   I2 +C2*s*Vb     = C2*s*Vin  *CHANGED*
   0   0   0  R3   0   0  -1   1;    %    R3*I3  -Va +Vb = 0
   0   0   0   0  R4   0  -1   0;    %     R4*I4 -Va     = 0
   0   0   0   0   0   1   0 -C5*s]; %      I5 - C5*s*Vb = 0        *CHANGED*
b=[0; 0; 0; Vin; C2*s*Vin; 0; 0; 0]; x=A\b; % solve
I3=simplify(x(4)/Vin)  % display result as I3/Vin

% Note: as compared to RR_Ex10_5_Wheatstone_Resistors, only 2 eqns changed.
