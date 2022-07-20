function [x,y,r,s] = RR_Diophantine(a,b,f)
% function [xt,yt,r,s] = RR_Diophantine(a,b,f)
% Solve the polynomial Diophantine eqn a*x+b*y=f.
% NOTE:    Assumes the input system is proper! [that is, the order of a >= the order of b]
% INPUTS:  a,b,f = coefficients of the a,b,f polynomials in a polynomial Diophantine eqn
% OUTPUTS: x,y = solution of polynomial Diophantine eqn with the lowest order for y
%          r,s (OPTIONAL) = terms used to generate the general solution, {x+r*t,y+s*t} for any polynomial t.
% TEST:    Test with the <a href="matlab:RR_DiophantineTest">RR_DiophantineTest</a>.
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

[g,xg,yg]=RR_Bezout(a,b); c=RR_PolyDiv(f,g);
x=RR_PolyConv(xg,c); y=RR_PolyConv(yg,c); r=-RR_PolyDiv(b,g); s=RR_PolyDiv(a,g);
[k,y]=RR_PolyDiv(y,s);  x=RR_PolyAdd(x,RR_PolyConv(r,-k)); 
y=y(find(abs(y)>1e-8,1):end); x=x(find(abs(x)>1e-8,1):end);
end % function RR_Diophantine
