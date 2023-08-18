function [a4,a3,a5]=RR_Ex10_32_Barkhausen_condition(C1,C2,L3,R4,R5,R6,R7)
% function [a3,a4,a5]=RR_Ex10_32_Barkhausen_condition(C1,C2,L3,R4,R5,R6,R7)
% Computes {a3,a4,a5} (see text) of an op amp driven Colpitts oscillator.
% The Barkhausen condition for sustained oscillations is given by a4<0.
% TEST: a4=RR_Ex10_32_Barkhausen_condition(1e-6,1e-6,1e-3,1,1000,1325,100)
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

a2=(C1*C2*R4*R5*R7 + C1*L3*R7 + C2*L3*R5)/(C1*C2*L3*R5*R7);
a1=(L3 + C2*R4*R5 + C1*R4*R7 + C1*R5*R7 + C2*R5*R7)/(C1*C2*L3*R5*R7);
a0=(R4+R5+R6+R7)/(C1*C2*L3*R5*R7);
q=(3*a1-a2^2)/3; r=(2*a2^3-9*a2*a1+27*a0)/27; d=r^2/4+q^3/27;
a3=a2/3-nthroot(-r/2+sqrt(d),3)-nthroot(-r/2-sqrt(d),3); a4=a2-a3; a5=a0/a3;
res=a4*a3+a5-a1  % res should work out to be near zero!
