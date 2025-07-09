% script RR_Ex06_02_generalization
% generalizes Ex06_02 to 3 eqns in 3 unknowns

clear; syms L1 L2 L3 L4 L5 L6 L7 L8 L9 L10 x y z u
eqn1= L1*x+L2*y+L3*z==L10*u; % assumes control comes into eqn1 only
eqn2= L4*x+L5*y+L6*z==0;
eqn3= L7*x+L8*y+L9*z==0;
sol=solve(eqn1,eqn2,eqn3,x,y,z); G=sol.z/u % assumes output is z variable

% If you have values for the L1 to L10 variables, you can sub them into G
% here in order to find the correponding transfer function from u to x
% Follow the same technique as used in 