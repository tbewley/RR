function [x] = NewtonRaphson(x,tolerance)
% This function solves f(x)=0 using the Newton Raphson method given an initial guess for x.
if nargin<2, tolerance=1e-10; end, residual=2*tolerance;
while (residual>tolerance)
   f=Compute_f(x);  A=Compute_A(x);   residual=norm(f); 
   disp(sprintf('%0.5f %0.5f %0.5f %0.5f %0.5f',x(1),x(2),f(1),f(2),residual));
   x=x-(A\f);                              % Solve system for next x 
end
% end function NewtonRaphson.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f] = Compute_f(x)
f=[ x(1)*x(1)+3*cos(x(2))-1;  x(2)+2*sin(x(1))-2   ]; 
% end function Compute_f.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A] = Compute_A(x)
A=[ 2*x(1), -3*sin(x(2));  2*cos(x(1)),  1 ];
% end function Compute_A.m
