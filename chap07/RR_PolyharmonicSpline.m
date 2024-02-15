function [f]=RC_PolyharmonicSpline(x,c,v,w,k)
% function [f]=RC_PolyharmonicSpline(x,c,v,w,k)
% Given the centers c, the order of the radial basis functions k, and the weights {v,w} of
% the polyharmonic splines (as computed by RC_PolyharmonicSplineSetup), compute the
% polyharmonic spline interpolant f at the point x.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_InvDistanceInterp.  Verify with RC_PolyharmonicSplineTest.

N=size(c,2); f=v'*[1; x];
if mod(k,2)==1, for i=1:N
  r=norm(x-c(:,i)); f=f+w(i)*r^k;
end, else, for i=1:N
  r=norm(x-c(:,i)); if r>=1, f=f+w(i)*r^k*log(r); else, f=f+w(i)*r^(k-1)*log(r^r); end
end, end
end % function RC_PolyharmonicSpline
