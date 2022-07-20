function p=NR_PolyDiff(p,d,n)
% function p=NR_PolyDiff(p,d,n)
% Recursively compute the d'th derivative of a polynomial p of order n.  
% INPUTS: p= vector of polynimal coefficients
%         d= order of derivative to be taken
%         n= order of polynomial p (optional)
% OUTPUT: p= vector of polynomial coefficients, given by d'th derivative of input polynomial
% TEST:   a=[4 4 4 4], p0=NR_PolyDiff(a,0), p1=NR_PolyDiff(a,1), p2=NR_PolyDiff(a,2), p3=NR_PolyDiff(a,3)
% Numerical Renaissance codebase, Appendix A, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

if nargin<2, d=1; end, if nargin<3, n=length(p)-1; end
if d>0, p=[n:-1:1].*p(1:n); if d>1, p=NR_PolyDiff(p,d-1,n-1); end, end
end % function NR_PolyDiff