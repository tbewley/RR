function a=NR_PolyAdd(a,b,c,d,e,f,g,h,i,j)
% function a=NR_PolyAdd(a,b,c,d,e,f,g,h,i,j)
% Add two to ten polynomials.  The coefficients of these polynomials are
% stored as vectors, and right justification is used when adding
% INPUT:  a,b,c,d,e,f,g,h,i,j = vectors of polynimal coefficients
% OUTPUT: a = vector of polynomial coefficients, given by sum of input polynomials
% TEST:   a=[1 2 3], b=[1 2 3 4 5 6], c=[1 2], sum=NR_PolyAdd(a,b,c)
% Numerical Renaissance codebase, Appendix A, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

if nargin>9, a=NR_PolyAdd(a,j); end, if nargin>8, a=NR_PolyAdd(a,i); end
if nargin>7, a=NR_PolyAdd(a,h); end, if nargin>6, a=NR_PolyAdd(a,g); end
if nargin>5, a=NR_PolyAdd(a,f); end, if nargin>4, a=NR_PolyAdd(a,e); end
if nargin>3, a=NR_PolyAdd(a,d); end, if nargin>2, a=NR_PolyAdd(a,c); end
m=length(a); n=length(b); a=[zeros(1,n-m) a]+[zeros(1,m-n) b];
end % function NR_PolyAdd
