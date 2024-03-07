function [fpp,h]=RC_CubicSplineSetup(xd,fd,end_conditions)
% function [fpp,h]=RC_CubicSplineSetup(xd,fd,end_conditions)
% Determine the intervals h and the curvature f'' for constructing the cubic spline
% interpolant of the datapoints {xd,fd}, assuming this data is ordered as ascending in x.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.3.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_Lagrange. Sets up subsequent call to RC_CubicSpline.  Verify with RC_CubicSplineTest.

n=length(xd); h(1:n-1)=xd(2:n)-xd(1:n-1);     % Calculate the h(i) = x(i+1)-x(i)
for i=2:n-1       % Now, set up and solve the tridiagonal system for g at each data point.
  a(i)=h(i-1)/6; b(i)=(h(i-1)+h(i))/3; c(i)=h(i)/6;
  g(i,1)=(fd(i+1)-fd(i))/h(i)-(fd(i)-fd(i-1))/h(i-1);
end 
switch end_conditions
  case {1,'parabolic'}
    b(1)=1;  c(1)=-1;  g(1,1)=0;
    b(n)=1;  a(n)=-1;  g(n,1)=0;        [fpp]=Thomas(a,b,c,g,n);
  case {2,'natural'}
    b(1)=1;  c(1)=0;   g(1,1)=0;
    b(n)=1;  a(n)=0;   g(n,1)=0;        [fpp]=Thomas(a,b,c,g,n);
  case {3,'periodic'}
    a(1)=-1; b(1)=0; c(1)=1; g(1,1)=0;
    a(n)=-1; b(n)=0; c(n)=1; g(n,1)=0;  A=TriDiag(a,b,c), fpp=RC_GaussCP(A,g,n);
end
end % function RC_CubicSplineSetup
