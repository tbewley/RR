% script RR_Ex10_04_wye_delta
% Computes the Wye Delta transformation, and apply it
% to compute the equivalent resistance of a Wheatstone Bridge of resistors.
% [If you don't use a computer to do such algebra, it gets messy!  Instead,
% just state the equations, as done below, and have the computer solve them!]
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

% The following method of symbolic solution extends easily to many simple
% nonlinear systems of equations.
syms R1 R2 R3 R4 R5 Ra Rb Rc        % <- list constants
eqn1= Ra+Rb==1/(1/R1+1/(R2+R3))     % <- list equations in algebraic form
eqn2= Ra+Rc==1/(1/R2+1/(R1+R3))
eqn3= Rb+Rc==1/(1/R3+1/(R1+R2))
A=solve(eqn1,eqn2,eqn3,Ra,Rb,Rc);   % <- Solve for {Ra,Rb,Rc} in terms of {R1,R2,R3} 
B=solve(eqn1,eqn2,eqn3,R1,R2,R3);   % <- Solve for {R1,R2,R3} in terms of {Ra,Rb,Rc} 
Ra=simplify(A.Ra),Rb=simplify(A.Rb),Rc=simplify(A.Rc)  % <- Simplify resulting expressions
R1=simplify(B.R1),R2=simplify(B.R2),R3=simplify(B.R3)
simplify(Ra + 1/(1/(Rb+R4) + 1/(Rc+R5)))  % <- Solve Fig 10.3d/e
