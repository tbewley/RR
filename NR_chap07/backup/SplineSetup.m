function [g,delta] = RC_SplineSetup(x_data,y_data,n)    % Numerical Renaissance Codebase 1.0
% Determine the g=f'' for constructing the cubic spline interpolant of the n datapoints
% {x_data,y_data}, assuming this data is already sorted in ascending order in x.
delta(1:n-1)=x_data(2:n)-x_data(1:n-1);   % Calculate the delta_i = x_(i+1)-x_i
for i=2:n-1    % Set up and solve a tridiagonal system for the g at each data point.
   a(i)=delta(i-1)/6;  b(i)=(delta(i-1)+delta(i))/3;  c(i)=delta(i)/6;
   g(i)=(y_data(i+1)-y_data(i))/delta(i) - (y_data(i)-y_data(i-1))/delta(i-1);
end 
if end_conditions==1       % Parabolic run-out
   b(1)=1;  c(1)=-1;  g(1)=0;
   b(n)=1;  a(n)=-1;  g(n)=0;        [g]=Thomas(a,b,c,g,n);            
elseif end_conditions==2   % Free run-out ("natural" spline)
   b(1)=1;  c(1)=0;   g(1)=0;
   b(n)=1;  a(n)=0;   g(n)=0;        [g]=Thomas(a,b,c,g,n);            
elseif end_conditions==3   % Periodic end conditions
   a(1)=-1; b(1)=0; c(1)=1; g(1)=0;
   a(n)=-1; b(n)=0; c(n)=1; g(n)=0;  [g]=RC_Circulant(a,b,c,g,n); 
end
end % function RC_SplineSetup.m
