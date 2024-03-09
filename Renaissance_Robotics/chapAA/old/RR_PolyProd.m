  function p=RR_PolyProd(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v)
% function p=RR_PolyProd(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v)
% Recursively compute the convolution of 2 to 20 polynomials, given as arguments.  
% INPUT:  a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v = vectors of polynimal coefficients
% OUTPUT: a = vector of polynomial coefficients, given by product of input polynomials
% TEST:   a=[1 2], b=[2 3 4], pab=RR_PolyProd(a,b), pba=RR_PolyProd(b,a)
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chapAA
% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if nargin>19, a=RR_PolyProd(a,t); end, if nargin>18, a=RR_PolyProd(a,s); end
if nargin>17, a=RR_PolyProd(a,r); end, if nargin>16, a=RR_PolyProd(a,q); end
if nargin>15, a=RR_PolyProd(a,p); end, if nargin>14, a=RR_PolyProd(a,o); end
if nargin>13, a=RR_PolyProd(a,n); end, if nargin>12, a=RR_PolyProd(a,m); end
if nargin>11, a=RR_PolyProd(a,l); end, if nargin>10, a=RR_PolyProd(a,k); end
if nargin>9,  a=RR_PolyProd(a,j); end, if nargin>8,  a=RR_PolyProd(a,i); end
if nargin>7,  a=RR_PolyProd(a,h); end, if nargin>6,  a=RR_PolyProd(a,g); end
if nargin>5,  a=RR_PolyProd(a,f); end, if nargin>4,  a=RR_PolyProd(a,e); end
if nargin>3,  a=RR_PolyProd(a,d); end, if nargin>2,  a=RR_PolyProd(a,c); end
m=length(a); n=length(b); p=zeros(1,n+m-1);
for k=0:n-1; p=p+[zeros(1,n-1-k) b(n-k)*a zeros(1,k)]; end
end % function RR_PolyProd
