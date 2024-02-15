function [w,v]=RC_PolyharmonicSplineSetup(c,y,k)
% function [w,v]=RC_PolyharmonicSplineSetup(c,y,k)
% Given the centers c, the value of the function at these centers, y, and the order of the
% radial basis functions, k, calculate the weights {w,v} of the polyharmonic spline.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_InvDistanceInterp. Sets up subsequent call to RC_PolyharmonicSpline.
% Verify with RC_PolyharmonicSplineTest.

[n,N]=size(c); A=zeros(N,N); V=[ones(1,N); c]; % N=number of points, n=dimension of system
if mod(k,2)==1
  for i=1:N, for j=1:N
    r=norm(c(:,i)-c(:,j)); A(i,j)=r^k;
  end, end
else
  for i=1:N, for j=1:N
    r=norm(c(:,i)-c(:,j)); if r>1, A(i,j)=r^k*log(r); else, A(i,j)=r^(k-1)*log(r^r); end
  end, end
end
x=RC_GaussPP([A V'; V zeros(n+1,n+1)],[y'; zeros(n+1,1)],N+n+1); w=x(1:N); v=x(N+1:N+n+1);
end % function RC_PolyharmonicSplineSetup
