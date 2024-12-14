function RR_LevenbergMarquardtTest
% function RR_LevenbergMarquardtTest
% Tests RR_LevenbergMarquardt on the Rosenbrock function, written as the sum of squares of two
% residual components, r(1)=a-x(1) and r(2)=sqrt(b)*(x(2)-x(1)^2), with f(x(1),x(2))=r(1)^2+r(2)^2; 
% f is build from an r with m=2 elements, and the optimization is performed over a space x with n=2
% elements.  [See https://en.wikipedia.org/wiki/Rosenbrock_function for this definition of f(x).]
% The RR_LevenbergMarquardt optimization algorithm then drives f(x(1),x(2))=r(1)^2+r(2)^2 towards zero;
% to apply it to a different vector of residuals r, just define new Residual and Jacobian functions
% herein, where r has m components and x has n components with m>=n, and rerun.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap03
%% Copyright 2024 by Thomas Bewley, published under the BSD 3-Clause License. 

global a b; a=1; b=100; % parameters defining the Rosenbrock function being tested

% The next 3 lines just make a pretty plot (only works for the n=2 case)
x=[-2:.01:2]; y=[-1:.01:3]; [X,Y]=meshgrid(x,y); figure(1); clf; hold on, nx=length(x); ny=length(y);
for i=1:nx, for j=1:ny, r=Residual_Rosenbrock([x(i); y(j)]); Z(j,i)=norm(r); end, end
contour(x,y,Z,100); title('Levenberg Marquardt minimization of Rosenbrock')

x0=[-1.5; 0];                   % (bad) initial guess for x
x=RR_LevenbergMarquardt(x0,@Residual_Rosenbrock,@Jacobian_Rosenbrock) % Perform the optimization
disp('Actual minimum is at x=[1,1]; did we get close?')

end % function RR_LevenbergMarquardtTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [r] = Residual_Rosenbrock(x)
global a b; 
r=[ a-x(1); sqrt(b)*(x(2)-x(1)^2) ];  % The actual Rosenbrock function is f=r(1)^2+r(2)^2;
end % function Residual_Rosenbrock
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [J] = Jacobian_Rosenbrock(x)
% This is the (analytical) derivative of each component of r w.r.t. each component of x
global a b; 
J=[-1, 0; sqrt(b)*(-1)*x(1), sqrt(b)]; 
end % function Jacobian_Rosenbrock
