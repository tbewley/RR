function [f]=RC_Lagrange(x,xd,fd)
% function [f]=RC_Lagrange(x,xd,fd)
% Perform RC_Lagrange interpolation based on the {xd,fd} and evaluate at the points in x.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_LinearSpline, RC_CubicSpline.  Verify with RC_LagrangeTest.

n=length(xd); m=length(x); for j=1:m, f(j)=0; for k=1:n
  L=1; for i=1:n, if i~=k, L=L*(x(j)-xd(i))/(xd(k)-xd(i)); end, end, f(j)=f(j)+fd(k)*L;
end, end
end % function RC_Lagrange
