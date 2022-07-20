function p=RR_PolyConv(a,b,c,d,e,f,g,h,i,j)
% function p=RR_PolyConv(a,b,c,d,e,f,g,h,i,j)
% Recursively compute the convolution of the two to ten polynomials, given as arguments.  
% INPUT:  a,b,c,d,e,f,g,h,i,j = vectors of polynimal coefficients
% OUTPUT: a = vector of polynomial coefficients, given by convolution of input polynomials
% TEST:   a=[1 2], b=[2 3 4], pab=RR_PolyConv(a,b), pba=RR_PolyConv(b,a)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

if nargin>9, a=RR_PolyConv(a,j); end, if nargin>8, a=RR_PolyConv(a,i); end
if nargin>7, a=RR_PolyConv(a,h); end, if nargin>6, a=RR_PolyConv(a,g); end
if nargin>5, a=RR_PolyConv(a,f); end, if nargin>4, a=RR_PolyConv(a,e); end
if nargin>3, a=RR_PolyConv(a,d); end, if nargin>2, a=RR_PolyConv(a,c); end
m=length(a); n=length(b); p=zeros(1,n+m-1);
for k=0:n-1; p=p+[zeros(1,n-1-k) b(n-k)*a zeros(1,k)]; end
end % function RR_PolyConv
