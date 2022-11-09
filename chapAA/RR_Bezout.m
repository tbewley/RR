function [g,x,y] = RR_Bezout(a,b)
% function [g,x,y] = RR_Bezout(a,b)
% First solves for the greatest common factor g, and the corresponding quotients q, using Euclid's algorithm, then
% solve for {xgm,ygm} satisfying the Bezout identity a*xgm+b*ygm=gm using the Extended Euclidian algorithm.
% This algorithm works on (a,b) of the RR_poly class or the RR_int class
% INPUTS:  a,b = can be of RR_poly class or of RR_int class, with a >= b
% OUTPUTS: g  = greatest common factor (GCF) of a,b
%          xg,yg = objects, of the same class as the inputs a,b}, satisfying Bezout identity a*xgm+b*ygm=gm
%          In the cass of working on the RR_poly class, outputs [g,xg,yg] are scaled such that g is monic.
% TESTS:   a=RR_int(385),                  b=RR_int(357),                       % Test over the integers.
%          [g,x,y] = RR_Bezout(a,b), test=a*x+b*y, residual=norm(g-test)
%          a=RR_poly([1 2 3 5 7],1), b=RR_poly([1 2 3 4 6],1)                   % Test over the polynomials
%          [g,x,y] = RR_Bezout(a,b), test=a*x+b*y, residual=norm(g-test)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

if b>a, disp('ERROR: Need a>=b!'), return, end
[g,q,n] = RR_GCF(a,b);      % Start by calling the GCF algorithm
x=0; y=1; for j=n-1:-1:1    % Using the q{i} and g from the GCF call, compute {xg,yg}
  t=x; x=y; y=t-q{j}*y;     % via the Extended Euclidean algorithm
end
if isa(g,'RR_poly'), c=g.poly(1); g=g./c; x=x./c; y=y./c;
end % function RR_Bezout
