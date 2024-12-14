function RR_LevenbergMarquardtFit
% function RR_LevenbergMarquardtFit
% Tests RR_LevenbergMarquardt on measurements of a Gaussian function, written as the sum of squares of n
% residual components, r(i)=data(i)-Compute_Gaussian(x(i),y(i),p), with f(x)=sum_(i=1)^m r(i)^2; 
% f is build from an r with m elements, and the optimization is performed over a space p with n elements.
% The RR_LevenbergMarquardt optimization algorithm then drives f(x(1),x(2))=r(1)^2+r(2)^2 towards zero;
% to apply it to a different vector of residuals r, just define new Residual and Jacobian functions
% herein, where r has m components and x has n components with m>=n, and rerun.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap03
%% Copyright 2024 by Thomas Bewley, published under the BSD 3-Clause License. 

global data; % data to be fitted

% The following lines generate some data, where p(1:6)={A,a,b,c,x0,y0} in def of Gaussian
p(1)=1; p(2)=.5; p(3)=.2; p(4)=.2; p(5)=0; p(6)=0;
m=20;  for i=1:m; data(i,1)=randn; data(i,2)=randn;  % north and east positions of measurements
	e=data(i,1); n=data(i,2);
	data(i,3)=p(1)*exp(-(p(2)*(e-p(5))^2+2*p(3)*(e-p(5))*(n-p(6))+p(4)*(n-p(6))^2)); % height
end

% The next 3 lines just make a pretty plot of the (1,2) components of the data
e=[-3:.1:3]; n=[-3:.1:3]; [E,N]=meshgrid(e,n); figure(1); clf; hold on, ne=length(e); nn=length(n);
for i=1:ne, for j=1:nn, h(j,i)=Compute_Gaussian(n(i),e(j),p); end, end
surf(e,n,h); hold on; title('Original data and its measurements')
for i=1:m, plot3(data(i,1),data(i,2),data(i,3),'m*','LineWidth',2,'MarkerSize',8), end
pause

title('Levenberg Marquardt fit of several measurements of a Gaussian')

p0=[0.1 1 0 1 -1 -1];                                    % (bad) initial guess for x
p=RR_LevenbergMarquardt(p0,@Residual_Gaussian,@Jacobian_Gaussian) % Perform the optimization
disp('Did we get close?  Actual parameters are at p='); p

end % function RR_LevenbergMarquardtTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h] = Compute_Gaussian(e,n,p)
h=p(1)*exp(-(p(2)*(e-p(5))^2+2*p(3)*(e-p(5))*(n-p(6))+p(4)*(n-p(6))^2));
end % function Compute_Gaussian
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [r] = Residual_Gaussian(p)
global m data
% The function minimized is f=sum_(i=1) r(i)^2
for i=1:m, e=data(i,1); n=data(i,2); r(i)=Compute_Gaussian(e,n,p)-data(i,3);
end % function Residual_Rosenbrock
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [J] = Jacobian_Gaussian(x)
% This is the (analytical) derivative of each component of r w.r.t. each component of p
global m data
for i=1:m, 
J(i,:)=[-1, 0]; 
end
end % function Jacobian_Rosenbrock
