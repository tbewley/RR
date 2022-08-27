function [x,y,r,t] = RR_Diophantine(a,b,f)
% function [x,y,r,t] = RR_Diophantine(a,b,f)
% Solve the polynomial Diophantine eqn a*x+b*y=f.  Assumes (a,b) have no common factors.
% NOTE:    Assumes the input system is proper! [that is, the order of a >= the order of b]
% INPUTS:  a,b,f = coefficients of the a,b,f polynomials in a polynomial Diophantine eqn
% OUTPUTS: x,y = solution of polynomial Diophantine eqn with the lowest order for y
%          r,t (OPTIONAL) = terms used to generate the general solution, {x+r*k,y+t*k} for any polynomial k.
% TEST:    Test with the <a href="matlab:RR_DiophantineTest">RR_DiophantineTest</a>.
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 
% hi there guys

[g,xg,yg]=RR_Bezout(a,b); c=f./g;  x=xg*c; y=yg*c; r=-1*b./g; t=a./g; [k,y]=y./t; x=x-r*k; 
end % function RR_Diophantine
