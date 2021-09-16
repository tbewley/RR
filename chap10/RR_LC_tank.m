% script RR_LC_tank
% Solves the equations of an LC tank.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

% Simple LC tank: computation of Vout(s)
clear; syms C1 C2 L3 R4 I Va Vb Vout Vo s
eqn1= I==-s*C2*Va; eqn2= Va-Vb==s*L3*I; eqn3= Vb-Vout==R4*I; eqn4= I==C1*(s*Vout-Vo);
SOL=solve(eqn1,eqn2,eqn3,eqn4,I,Va,Vb,Vout); SOL.Vout
pause

% Simple LC tank: partial fraction expansion
clear; syms B2 B1 B0 b2 b1 b0 sigma omegad
eqn1= b2==B2+B1; eqn2= b1==B2*2*sigma+B1*sigma+B0*omegad; eqn3= b0==B2*(sigma^2+omegad^2);
SOL=solve(eqn1,eqn2,eqn3,B2,B1,B0); B2=SOL.B2, B1=SOL.B1, B0=SOL.B0
pause, disp(' ')

% Problem 3c - Colpitts oscillator WITH the extra resistor
clear; syms C1 C2 L3 R4 R5 R6 R8 I1 I2 I3 I4 I5 I6 I7 I8 Va Vb Vs Vout Vout0 Va0 I30 s
eqn1= I3==I4;		eqn5= I6+I7==I8;			eqn9 = Va==R5*I5;
eqn2= I5==I6;		eqn6= I2==-C2*(s*Va-Va0);	eqn10= -Vs==R6*I6;
eqn3= I2==I3+I5;	eqn7= Va-Vb==s*L3*I3;		eqn11= I1==C1*(s*Vout-Vout0);
eqn4= I4+I8==I1;	eqn8= Vb-Vout==R4*I4;		eqn12= Vs-Vout==R8*I8;
SOL=solve(eqn1,eqn2,eqn3,eqn4,eqn5,eqn6,eqn7,eqn8,eqn9,eqn10,eqn11,eqn12,...
I1,I2,I3,I4,I5,I6,I7,I8,Va,Vb,Vs,Vout);  SOL.Vout
