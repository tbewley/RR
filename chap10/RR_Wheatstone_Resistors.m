% script RR_Wheatstone_Resistors
% Computes the currents and intermediate nodal voltages of a Wheatstone Bridge of resistors.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

syms R5; V0=5; R1=1e3; R2=1e3; R4=1e3; R3=1e5;
A=[1 -1 -1 0 0 0 0 0; 0 1 0 -1 -1 0 0 0; 0 0 1 1 0 -1 0 0; 0 R1 0 0 0 0 1 0; ...
   0 0 R2 0 0 0 0 1; 0 0 0 R3 0 0 -1 1; 0 0 0 0 R4 0 -1 0; 0 0 0 0 0 R5 0 -1];
b=[0; 0; 0; V0; V0; 0; 0; 0]; x=A\b
