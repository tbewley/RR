function [g,xg,yg] = RR_Bezout(a,b)
% function [gm,xgm,ygm] = RR_Bezout(a,b)
% First solves for the greatest common factor g, and the corresponding quotients q, using Euclid's algorithm, then
% solve for {xgm,ygm} satisfying the Bezout identity a*xgm+b*ygm=gm using the Extended Euclidian algorithm.
% This algorithm works on (a,b) of the RR_poly class or the RR_int class
% INPUTS:  a,b = can be of RR_poly class or of RR_int class, with a >= b
% OUTPUTS: g  = greatest common factor (GCF) of a,b
%          xg,yg = vectors of coefficients of output polynomials satisfying the Bezout identity a*xgm+b*ygm=gm
%          In the cass of working on the RR_poly class, outputs [g,xg,yg] are scaled such that g is monic.
% TESTS:   a=RR_poly([1 2 3 5 7],'roots'), b=RR_poly([1 2 4],'roots')           % Try either this line, for polynomials,
%          a=RR_int(385),                  b=RR_int(357),                       % or this line, for polynomials.
%          [g,xg,yg] = RR_Bezout(a,b), testg=a*xg+b*yg, residualg=norm(g-testg) % In either case, test with this line.
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

if b>a, disp('ERROR: Need a>=b!'), return, end
[g,q,n] = RR_GCF(a,b); 
xg=0; yg=1; for j=n-1:-1:1    % Using the q{i} and g from the GCF call, compute {xg,yg}
  t=xg; xg=yg; yg=t-q{j}*yg;  % via the Extended Euclidean algorithm
end
if isa(g,'RR_poly'), c=g.poly(1); g=g./c; xg=xg./c; yg=yg./c;
end % function RR_Bezout
