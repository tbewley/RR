function RR_LevenbergMarquardtSolve
% function RR_LevenbergMarquardtSolve
% Tests RR_LevenbergMarquardt on minimizing the Rosenbrock function, written as the sum of squares of two
% residual components, r(1)=a-p(1) and r(2)=sqrt(b)*(p(2)-p(1)^2), with f(p(1),p(2))=r(1)^2+r(2)^2; 
% f is build from an r with R=2 elements, and the optimization is performed over a parameter space p with
% P=2 elements.  [See https://en.wikipedia.org/wiki/Rosenbrock_function for this definition of f(p).]
% The RR_LevenbergMarquardt optimization algorithm then drives f(p(1),p(2))=r(1)^2+r(2)^2 towards zero;
% to apply it to a different vector of residuals r, just define new Residual and Jacobian functions
% herein, where r has R components and p has P components with R>=P, and rerun.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap03
%% Copyright 2024 by Thomas Bewley, published under the BSD 3-Clause License. 

global a b; a=1; b=100; % parameters defining the Rosenbrock function being tested

% The next 3 lines just make a pretty plot (only works for the n=2 case, e=east, n=north, h=height)
e=[-2:.01:2]; n=[-1:.01:3]; [E,N]=meshgrid(e,n); figure(1); clf; hold on, ne=length(e); nn=length(n);
for i=1:ne, for j=1:nn, r=Residual_Rosenbrock([e(i); n(j)]); h(j,i)=norm(r); end, end
contour(e,n,h,100); title('Levenberg Marquardt minimization of Rosenbrock')

p0=[-2+2*rand; -1+3*rand];                   % (bad) initial guess for x
p=RR_LevenbergMarquardt(p0,@Residual_Rosenbrock,@Jacobian_Rosenbrock) % Perform the optimization
disp('Actual minimum is at p=[1,1]; did we get close?')

end % function RR_LevenbergMarquardtTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [r] = Residual_Rosenbrock(p)
global a b; 
r=[ a-p(1); sqrt(b)*(p(2)-p(1)^2) ];  % The actual Rosenbrock function is f=r(1)^2+r(2)^2;
end % function Residual_Rosenbrock
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [J] = Jacobian_Rosenbrock(p)
% This is the (analytical) derivative of each component of r w.r.t. each component of p
global a b; 
J=[-1, 0; sqrt(b)*(-1)*p(1), sqrt(b)]; 
end % function Jacobian_Rosenbrock
