function [f]=RR_Lagrange(x,xd,fd)
% function [f]=RR_Lagrange(x,xd,fd)
% Perform Lagrange interpolation based on the {xd,fd} and evaluate at the points in x.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 7)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.
% See also RR_LinearSpline, RR_CubicSpline.  Trial: RR_LagrangeTest.

n=length(xd); m=length(x); for j=1:m, f(j)=0; for k=1:n
  L=1; for i=1:n, if i~=k, L=L*(x(j)-xd(i))/(xd(k)-xd(i)); end, end, f(j)=f(j)+fd(k)*L;
end, end
end % function RR_Lagrange
