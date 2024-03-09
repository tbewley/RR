function [g,xg,yg] = RR_IntBezout(a,b)
% function [g,xg,yg] = RR_IntBezout(a,b,g,q,n)
% First solves for the greatest common factor g, and the corresponding quotients q, using Euclid's algorithm, then
% solve for {xg,yg} satisfying the Bezout identity a*xg+b*yg=g using the Extended Euclidian algorithm.
% INPUTS:  a,b = input integers, with a >= b
% OUTPUTS: g   = greatest common factor (GCF) of a,b
%          xg,yg = integers satisfying the Bezout identity a*xg+b*yg=g   
% TEST:    a=int32(385),  b=int32(357), [g,xg,yg]=RR_IntBezout(a,b), residualg=a*xg+b*yg-g
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

[g,q,n] = RR_IntGCF(a,b); 
xg=0; yg=1; for j=n-1:-1:1                  % Using the q{i} from the GCF call, compute {xg,yg}
  t=xg; xg=yg; yg=t-q{j}*yg;                % via the Extended Euclidean algorithm
end
end % function RR_IntBezout
