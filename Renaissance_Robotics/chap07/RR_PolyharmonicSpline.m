function [f]=RR_PolyharmonicSpline(x,c,v,w,k)
% function [f]=RR_PolyharmonicSpline(x,c,v,w,k)
% Given the centers c, the order of the radial basis functions k, and the weights {v,w} of
% the polyharmonic splines (as computed by RR_PolyharmonicSplineSetup), compute the
% polyharmonic spline interpolant f at the point x.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 7)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.
% See also RR_InvDistanceInterp.  Trial: RR_PolyharmonicSplineTest.

N=size(c,2); f=v'*[1; x];
if mod(k,2)==1, for i=1:N
  r=norm(x-c(:,i)); f=f+w(i)*r^k;
end, else, for i=1:N
  r=norm(x-c(:,i)); if r>=1, f=f+w(i)*r^k*log(r); else, f=f+w(i)*r^(k-1)*log(r^r); end
end, end
end % function RR_PolyharmonicSpline
