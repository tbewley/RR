function [g,xg,yg] = RR_Bezout(a,b)
% function [g,xg,yg] = RR_Bezout(a,b,g,q,n)
% First solves for the greatest common factor g, and the corresponding quotients q, using Euclid's algorithm, then
% solve for {xg,yg} satisfying the Bezout identity a*xg+b*yg=g using the Extended Euclidian algorithm.
% INPUTS:  a,b = vectors of coefficients of input polynomials, with order of a >= order of b
% OUTPUTS: g   = greatest common factor (GCF) of a,b, solved up to an arbitrary multiplicative constant
%          xg,yg = vectors of coefficients of output polynomials satisfying the Bezout identity a*xg+b*yg=g   
% TEST:    b=[1 -1 -2], a=[1 2 -13 -14 24]
%          [g,xg,yg] = RR_Bezout(a,b)
%          testg=NR_PolyAdd(NR_PolyConv(a,xg),NR_PolyConv(b,yg)); residualg=norm(NR_PolyAdd(g,-testg))
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

[g,q,n] = RR_GCF(a,b); 
x=0; y=1; for j=n-1:-1:1                             % Using the q{i} from the GCF call, compute {xg,yg}
  t=x; x=y; y=RR_PolyAdd(t,-RR_PolyConv(q{j},y));    % via the Extended Euclidean algorithm
end, yg=y(find(y,1):end); xg=x(find(x,1):end);
end % function RR_Bezout
