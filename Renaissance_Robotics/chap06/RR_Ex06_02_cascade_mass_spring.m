% script RR_Ex06_02_cascade_mass_spring
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 6)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear; syms L1 L2 L3 L4 x1 x2 u
eqn1= L1*x1+L2*x2==u;
eqn2= L3*x1+L4*x2==0;
sol=solve(eqn1,eqn2,x1,x2); G=sol.x2/u
pause;

% Now sub in specific expressions for {L1,L2,L3,L4} and simplify
syms m1 m2 mu1 mu2 g k1 k2 s
G=subs(sol.x2/u,{L1,L2,L3,L4},{m1*s^2+mu1*m1*g*s+k1+k2, -k2, -k2, m2*s^2+mu2*m2*g*s+k2})

% the rest of this (below) is unchanged when you generalize to different problems!
[numG,denG] = numden(G);      % this extracts out the num and den of G
numG=coeffs(numG,s);          % this extracts the powers of s in the num and den
denG=coeffs(denG,s);
numG=simplify(numG/denG(end)); % this makes the den monic
denG=simplify(denG/denG(end));
numG=numG(end:-1:1)   % this reverses the order of the vector of coefficients.
denG=denG(end:-1:1)