function [fpp,h]=RR_CubicSplineSetup(xd,fd,end_conditions)
% function [fpp,h]=RR_CubicSplineSetup(xd,fd,end_conditions)
% Determine the intervals h and the curvature f'' for constructing the cubic spline
% interpolant of the datapoints {xd,fd}, assuming this data is ordered as ascending in x.
%% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.
% See also RR_Lagrange. Sets up subsequent call to RR_CubicSpline.  Verify with RR_CubicSplineTest.

n=length(xd); h(1:n-1)=xd(2:n)-xd(1:n-1);     % Calculate the h(i) = x(i+1)-x(i)
for i=2:n-1       % Now, set up and solve the tridiagonal system for g at each data point.
  a(i)=h(i-1)/6; b(i)=(h(i-1)+h(i))/3; c(i)=h(i)/6;
  g(i,1)=(fd(i+1)-fd(i))/h(i)-(fd(i)-fd(i-1))/h(i-1);
end 
switch end_conditions
  case {1,'parabolic'}
    a(1)=0;  b(1)=1; c(1)=-1; g(1,1)=0;
    a(n)=-1; b(n)=1; c(n)=0;  g(n,1)=0;
  case {2,'natural'}
    a(1)=0;  b(1)=1; c(1)=0;  g(1,1)=0;
    a(n)=0;  b(n)=1; c(n)=0;  g(n,1)=0;
  case {3,'periodic'}
    a(1)=-1; b(1)=0; c(1)=1;  g(1,1)=0;
    a(n)=-1; b(n)=0; c(n)=1;  g(n,1)=0;
end
A=RC_tridiag_matrix(a,b,c); fpp=A\g;
end % function RR_CubicSplineSetup
