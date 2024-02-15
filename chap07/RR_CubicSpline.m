function [f,fp]=RC_CubicSpline(x,xd,fd,fpp,h)
% function [f,fp]=RC_CubicSpline(x,xd,fd,fpp,h)
% Perform cubic spline interpolation based on the {xd,fd} and evaluate at the points in x.
% Note: the initialization data {fpp,h} must be computed first using RC_CubicSplineSetup.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_Lagrange, RC_LinearSpline. Depends on result from RC_CubicSplineSetup.
% Verify with RC_CubicSplineTest.

n=length(xd); m=length(x); i=1; for j=1:m
  for i=i:n-1, if xd(i+1) > x(j), break, end, end % Find the i such that xd(i)<=x<=xd(i+1)
  f(j)=fpp(i)/6 *((xd(i+1)-x(j))^3/h(i)-h(i)*(xd(i+1)-x(j))) +... % Compute the cubic
     fpp(i+1)/6 *((x(j) - xd(i))^3/h(i)-h(i)*(x(j) - xd(i))) +... % spline approximation 
     (fd(i)*(xd(i+1)-x(j)) + fd(i+1)*(x(j)-xd(i))) / h(i);        % of the function,
  if nargout==2,
     fp(j)=fpp(i)/6*(-3*(xd(i+1)-x(j))^2/h(i)+h(i)) +...          % and (if requested) its
         fpp(i+1)/6*( 3*(x(j) - xd(i))^2/h(i)-h(i)) + (fd(i+1)-fd(i))/h(i);  % derivative.
end, end
end % function RC_CubicSpline