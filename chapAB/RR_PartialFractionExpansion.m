function [p,d,k,n]=RR_PartialFractionExpansion(num,den,eps)
% function [p,d,k,n]=RR_PartialFractionExpansion(num,den,eps)
% Compute {p,d,k,n} so that Y(s)=num(s)/den(s)=d(1)/(s-p(1))^k(1) +...+ d(n)/(s-p(n))^k(n),
% where order(num)<=order(den) and eps is tolerance when finding repeated roots.
% TEST:  [p,d,k,n]=RR_PartialFractionExpansion([1000 1000],[1 100 1000 1000 0])
% Renaissance Robotics codebase, Appendix B, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

n=length(den)-1; m=length(num)-1; flag=0; if n<1, p=1; k=0; d=num/den; n=1; return, end
if m==n, flag=1; [div,rem]=RR_PolyDiv(num,den); m=m-1; else, rem=num; end
k=ones(n,1); p=roots(den); if n>1, p=NR_SortComplex(p); end, if nargin<3, eps=1e-3; end
for i=1:n-1, if abs(p(i+1)-p(i))<eps, k(i+1)=k(i)+1; end, end, k(n+1,1)=0;
for i=n:-1:1
  if k(i)>=k(i+1), r=k(i); a=1;
    for j=1:i-k(i), a=RR_PolyConv(a,[1 -p(j)]); end
    for j=i+1:n,    a=RR_PolyConv(a,[1 -p(j)]); end
    for j=1:k(i)-1, ad{j}=RR_PolyDiff(a,j); end
  end
  q=r-k(i); d(i,1)=RR_PolyVal(RR_PolyDiff(rem,q),p(i))/RR_Factorial(q);
  for j=q:-1:1, d(i)=d(i)-d(i+j)*RR_PolyVal(ad{j},p(i))/RR_Factorial(j); end
  d(i)=d(i)/RR_PolyVal(a,p(i));
end, if ~flag, k=k(1:n); else, n=n+1; p(n,1)=1; d(n,1)=div; end
end % function RR_PartialFractionExpansion
