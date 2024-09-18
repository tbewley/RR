function [g,x0,y0] = RR_bezout(a,b)
% function [g,x0,y0] = RR_bezout(a,b)
% First solves for the greatest common factor g, and the corresponding quotients q, using Euclid's algorithm,
% then solve for {x0,y0} satisfying the Bezout identity a*x0+b*y0=g using the Extended Euclidian algorithm.
% This algorithm works on (a,b) of the RR_poly class or the RR_int class
% INPUTS:  a,b = can be of RR_poly class or of RR_int class, with a >= b
% OUTPUTS: g  = greatest common factor (GCF) of a,b
%          x0,y0 = objects, of the same class as the inputs {a,b}, satisfying Bezout identity a*x0+b*y0=g
%          In the cass of working on the RR_poly class, outputs [g,x0,y0] are scaled such that g is monic.
% TESTS:   a=RR_int64(385),                  b=RR_int64(357),                       % Test over the integers.
%          [g,x0,y0] = RR_bezout(a,b), test=a*x0+b*y0, residual=norm(g-test)
%          a=RR_poly([1 2 3 5 7],1), b=RR_poly([1 2 3 4 6],1)                   % Test over the polynomials
%          [g,x0,y0] = RR_bezout(a,b), test=a*x0+b*y0, residual=norm(g-test)
% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if b>a & a~=0, disp('ERROR: Need a>=b!'), return, end
[g,q,n] = RR_gcd(a,b);      % Start by calling the GCD algorithm
x0=0; y0=1; for j=n-1:-1:1    % Using the q{i} and g from the GCF call, compute {xg,yg}
  t=x0; x0=y0; y0=t-q{j}*y0;     % via the Extended Euclidean algorithm
end
if isa(g,'RR_poly'), c=g.poly(1); g=g/c; x0=x0/c; y0=y0/c;
end % function RR_Bezout
