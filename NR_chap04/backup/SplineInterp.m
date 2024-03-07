function [f] = RC_SplineInterp(x,x_data,y_data,n,g,delta)
% Compute the cubic spline interpolant at point x, leveraging the spline 
% initialization data determined by RC_SplineSetup.m
for i=1:n-1              % Find the i such that x_data(i) <= x <= x_data(i+1)
   if x_data(i+1) > x, break, end
end
                         % compute the cubic spline approximation of the function.
f=g(i)  /6 *((x_data(i+1)-x)^3/delta(i)-delta(i)*(x_data(i+1)-x)) + ...
  g(i+1)/6 *((x - x_data(i))^3/delta(i)-delta(i)*(x - x_data(i))) + ...
  (y_data(i)*(x_data(i+1)-x) + y_data(i+1)*(x-x_data(i))) / delta(i);
% end function RC_SplineInterp.m
