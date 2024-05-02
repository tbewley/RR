function [g,x,y] = RR_bezout(a,b)
% function [g,x,y] = RR_bezout(a,b)
% First solves for the greatest common factor g, and the corresponding quotients q, using Euclid's algorithm, then
% solve for {xgm,ygm} satisfying the Bezout identity a*xgm+b*ygm=gm using the Extended Euclidian algorithm.
% This algorithm works on (a,b) of the RR_poly class or the RR_int class
% INPUTS:  a,b = can be of RR_poly class or of RR_int class, with a >= b
% OUTPUTS: g  = greatest common factor (GCF) of a,b
%          xg,yg = objects, of the same class as the inputs a,b}, satisfying Bezout identity a*xgm+b*ygm=gm
%          In the cass of working on the RR_poly class, outputs [g,xg,yg] are scaled such that g is monic.
% TESTS:   a=RR_int(385),                  b=RR_int(357),                       % Test over the integers.
%          [g,x,y] = RR_bezout(a,b), test=a*x+b*y, residual=norm(g-test)
%          a=RR_poly([1 2 3 5 7],1), b=RR_poly([1 2 3 4 6],1)                   % Test over the polynomials
%          [g,x,y] = RR_bezout(a,b), test=a*x+b*y, residual=norm(g-test)
% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if b>a & a~=0, disp('ERROR: Need a>=b!'), return, end
[g,q,n] = RR_gcd(a,b);      % Start by calling the GCD algorithm
x=0; y=1; for j=n-1:-1:1    % Using the q{i} and g from the GCF call, compute {xg,yg}
  t=x; x=y; y=t-q{j}*y;     % via the Extended Euclidean algorithm
end
if isa(g,'RR_poly'), c=g.poly(1); g=g/c; x=x/c; y=y/c;
end % function RR_Bezout
