function [f]=RC_LinearSpline(x,xd,fd)
% function [f]=RC_LinearSpline(x,xd,fd)
% Perform linear interpolation based on the {xd,fd} and evaluate at the points in x.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_Lagrange, RC_CubicSpline.  Verify with RC_LinearSplineTest.

n=length(xd); m=length(x); i=1; for j=1:m
  for i=i:n-1, if xd(i+1) > x(j), break, end, end  % Find the i such that xd(i)<=x<=xd(i+1)
  f(j)=(fd(i+1)*(x(j)-xd(i)) + fd(i)*(xd(i+1)-x(j)))/(xd(i+1)-xd(i));
end
end % function RC_LinearSpline
