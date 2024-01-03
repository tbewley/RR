function [x,y,r,t] = RR_IntDiophantine(a,b,f)
% function [x,y,r,t] = RR_IntDiophantine(a,b,f)
% Solve the integer Diophantine eqn a*x+b*y=f.  Assumes a>=b, and that f=g*c for some integer c.
% INPUTS:  a,b,f = input integers in the Diophantine eqn
% OUTPUTS: x,y = solution of integer Diophantine eqn, a*x+b*y=f, with the smallest abs value for y
%          r,t (OPTIONAL) = terms used to generate the general solution, {x+r*k,y+t*k} for any integer k.
% TEST:    a=int32(385),  b=int32(357),
%          f1=int32(21), [x1,y1,r,t]=RR_IntDiophantine(a,b,f1), residual1=a*x1+b*y1-f1, disp(''),
%          k=randi([-10 10]), x1k=x1+r*k, y1k=y1+t*k, residual1k=a*x1k+b*y1k-f1
%          f2=int32(25), [x2,y2,r,t]=RR_IntDiophantine(a,b,f2)
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License. 

[g,xg,yg]=RR_IntBezout(a,b); c=idivide(f,g); re=rem(f,g); 
if abs(re)>0, fprintf('ERROR! f=%i must be a multple of the greatest common factor g=%i\n',f,g), return, end
x=xg*c; y=yg*c; r=-idivide(b,g); t=idivide(a,g);
k=idivide(y,t); y=rem(y,t);  x=x-r*k; 
end % function RR_IntDiophantine
