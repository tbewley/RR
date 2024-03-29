% script RR_Ex09_32_Colpitts_oscillator
% Solves the equations of an an opamp driven Colpitts oscillator.
% See also RR_Ex10_32_Barkhausen_condition for a related calculation.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 9)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% pkg load symbolic  % uncomment this line if running in octave

clear; syms C1 C2 L3 R4 R5 R6 R7 I1 I2 I3 I4 I5 I6 I7 I8 Va Vb Vs Vout Vout0 Va0 I30 s
eqn1= I2==I3+I5;  eqn5= I6+I8==I7;              eqn9 = Vb-Vout==R4*I4;  
eqn2= I3==I4;     eqn6= I1==C1*(s*Vout-Vout0);  eqn10= Va==R5*I5;  
eqn3= I4+I7==I1;  eqn7= I2==-C2*(s*Va-Va0);     eqn11= -Vs==R6*I6;     
eqn4= I5==I6;     eqn8= Va-Vb==L3*(s*I3-I30);   eqn12= Vs-Vout==R7*I7;
SOL=solve(eqn1,eqn2,eqn3,eqn4,eqn5,eqn6,eqn7,eqn8,eqn9,eqn10,eqn11,eqn12,...
          I1,I2,I3,I4,I5,I6,I7,I8,Va,Vb,Vs,Vout);  SOL.Vout
