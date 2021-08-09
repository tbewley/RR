% script RR_Wheatstone_Capacitors
% Computes the currents and intermediate nodal voltages of a Wheatstone Bridge with two capacitors.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

syms C2 C5 s V0; R1=1e3; R4=1e3; R3=1e5;
A=[1 -1 -1 0 0 0 0 0; 0 1 0 -1 -1 0 0 0; 0 0 1 1 0 -1 0 0; 0 R1 0 0 0 0 1 0; ...
   0 0 1 0 0 0 0 C2*s; 0 0 0 R3 0 0 -1 1; 0 0 0 0 R4 0 -1 0; 0 0 0 0 0 1 0 -C5*s];
b=[0; 0; 0; V0; C2*s*V0; 0; 0; 0]; x=A\b
