% script RR_Wye_Delta
% Computes the Wye Delta transformation, then applies it
% to compute the equivalent resistance of a Wheatstone Bridge of resistors
% Renaissance Robotics codebase, Chapter 6, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

syms R1 R2 R3 Ra Rb Rc
eqn1='Ra+Rb==1/(1/R1+1/(R2+R3))'
eqn2='Ra+Rc==1/(1/R2+1/(R1+R3))'
eqn3='Rb+Rc==1/(1/R3+1/(R1+R2))'
A=solve(str2sym(eqn1),str2sym(eqn2),str2sym(eqn3),Ra,Rb,Rc);
B=solve(str2sym(eqn1),str2sym(eqn2),str2sym(eqn3),R1,R2,R3);
Ra=simplify(A.Ra),Rb=simplify(A.Rb),Rc=simplify(A.Rc)
R1=simplify(B.R1),R2=simplify(B.R2),R3=simplify(B.R3)
