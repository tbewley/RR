function [a3,a4,a5]=RR_Barkhausen(C1,C2,L3,R4,R5,R6,R7)
% function [a3,a4,a5]=RR_Barkhausen(C1,C2,L3,R4,R5,R6,R7)
% Computes a3, a4, a5 (see text) of an opamp drivin Colpitts oscillator.
% The Barkhausen condition for sustained oscillations is given by a4<0.
% EXAMPLE CALL: [a3,a4,a5]=RR_Barkhausen(1e-6,1e-6,1e-3,1,1000,1325,100)
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

a2=(C1*C2*R4*R5*R7 + C1*L3*R7 + C2*L3*R5)/(C1*C2*L3*R5*R7);
a1=(L3 + C2*R4*R5 + C1*R4*R7 + C1*R5*R7 + C2*R5*R7)/(C1*C2*L3*R5*R7);
a0=(R4+R5+R6+R7)/(C1*C2*L3*R5*R7);
q=(3*a1-a2^2)/3; r=(2*a2^3-9*a2*a1+27*a0)/27; d=r^2/4+q^3/27;
a3=a2/3-nthroot(-r/2+sqrt(d),3)-nthroot(-r/2-sqrt(d),3), a4=a2-a3, a5=a0/a3;
res=a4*a3+a5-a1;  % (check: res should work out to be zero)

% C1=1e-6;  C2=1e-6;  L3=1e-3;  R4=1; R5=1000;  R6=1325;  R7=100;
% C1=1e-6;  C2=1e-6;  L3=1e-3;  R4=1; R5=1000;  R6=1325;  R7=100;
% C1=1e-6;  C2=1e-6;  L3=10e-3; R4=1; R5=1000;  R6=1243;  R7=100;
% C1=10e-6; C2=10e-6; L3=1e-3;  R4=1; R5=1000;  R6=1325;  R7=100;
