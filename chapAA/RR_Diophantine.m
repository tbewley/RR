function [x,y,r,t] = RR_Diophantine(a,b,f)
% function [x,y,r,t] = RR_Diophantine(a,b,f)
% Solve the Diophantine eqn a*x+b*y=f.  
% INPUTS:  a,b,f can be of RR_int class or RR_poly class with a >= b, (a,b) must have no common factors
% OUTPUTS: x,y = solution of integer or polynomial Diophantine eqn with the lowest order for y
%          r,t (OPTIONAL) = terms used to generate the general solution, {x+r*k,y-t*k} for any polynomial k.
% TEST:    Test with the <a href="matlab:RR_DiophantineTest">RR_DiophantineTest</a>.
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

[g,xg,yg]=RR_Bezout(a,b);  % Start by calling the Bezout algorithm
[c,rem]=f/g;               % c is found by dividing f by g.
if norm(rem)>1e-9, disp('ERROR: f needs to be a multiple of g!'), end
x=xg*c; y=yg*c;            % Starting point solution {x,y} is simply c times result of Bezout algorithm
r=b/g; t=a/g;              % These {r,t} values can be used to generate other solutions {x+r*k,y-t*k}
[k,y]=y/t; x=x+r*k;        % This "best" solution, which is returned by the algorithm, has the smallest y.
if isa(y,'RR_poly'), x=trim(x); y=trim(y); r=trim(r); t=trim(t); end
end % function RR_Diophantine
