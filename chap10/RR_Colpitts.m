% script RR_Colpitts
% Solves the equations of an LC tank and an opamp drivin Colpitts oscillator.
% See also RR_LC_tank and RR_Barkhausen for related calculations.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

clear; syms C1 C2 L3 R4 R5 R6 R7 I1 I2 I3 I4 I5 I6 I7 I8 Va Vb Vs Vout Vout0 Va0 I30 s
eqn1=  I2==I3+I5;  eqn5= I6+I8==I7;               eqn9 = Vb-Vout==R4*I4;  
eqn2=  I3==I4;     eqn6= I1==C1*(s*Vout-Vout0);   eqn10= Va==R5*I5;  
eqn3=  I4+I7==I1;  eqn7= I2==-C2*(s*Va-Va0);      eqn11= -Vs==R6*I6;     
eqn4=  I5==I6;     eqn8= Va-Vb==L3*(s*I3-I30);    eqn12= Vs-Vout==R7*I7;
SOL=solve(eqn1,eqn2,eqn3,eqn4,eqn5,eqn6,eqn7,eqn8,eqn9,eqn10,eqn11,eqn12,...
          I1,I2,I3,I4,I5,I6,I7,I8,Va,Vb,Vs,Vout);  SOL.Vout
pause;

C1=1e-6;  C2=1e-6;  L3=1e-3;  R4=1; R5=1000;  R6=1325;  R7=100;
a2=(C1*C2*R4*R5*R7 + C1*L3*R7 + C2*L3*R5)/(C1*C2*L3*R5*R7);
a1=(L3 + C2*R4*R5 + C1*R4*R7 + C1*R5*R7 + C2*R5*R7)/(C1*C2*L3*R5*R7);
a0=(R4+R5+R6+R7)/(C1*C2*L3*R5*R7);
q=(3*a1-a2^2)/3; r=(2*a2^3-9*a2*a1+27*a0)/27; d=r^2/4+q^3/27;
a3=a2/3-nthroot(-r/2+sqrt(d),3)-nthroot(-r/2-sqrt(d),3), a4=a2-a3, a5=a0/a3;
res=a4*a3+a5-a1;  % (check: res should work out to be zero)
