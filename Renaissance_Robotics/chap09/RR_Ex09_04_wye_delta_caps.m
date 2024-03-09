% script RR_Ex09_04_wye_delta_caps
% Compute the Wye Delta transformation for capacitors.
% [If you don't use a computer to do such algebra, it can get messy!]
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 9)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% pkg load symbolic  % uncomment this line if running in octave

syms C1 C2 C3 C4 C5 Ca Cb Cc         % <- list constants
eqn1= 1/(1/Ca+1/Cb)==C3+1/(1/C1+1/C2) % <- list equations in algebraic form
eqn2= 1/(1/Ca+1/Cc)==C2+1/(1/C1+1/C3) 
eqn3= 1/(1/Cb+1/Cc)==C1+1/(1/C2+1/C3)
A=solve(eqn1,eqn2,eqn3,Ca,Cb,Cc);   % <- Solve for {Ca,Cb,Cc} in terms of {R1,R2,R3} 
B=solve(eqn1,eqn2,eqn3,C1,C2,C3);   % <- Solve for {C1,C2,C3} in terms of {Ra,Rb,Rc} 
Ca=simplify(A.Ca),Cb=simplify(A.Cb),Cc=simplify(A.Cc)  % <- Simplify resulting expressions
C1=simplify(B.C1),C2=simplify(B.C2),C3=simplify(B.C3)
