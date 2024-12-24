function RR_LevenbergMarquardtFit
% function RR_LevenbergMarquardtFit
% Tests RR_LevenbergMarquardt on measurements of a Gaussian function, written as the sum of squares of n
% residual components, r(i)=Compute_Gaussian(e(i),n(i),p)-data(i), with f=sum_(i=1)^R r(i)^2; 
% in this test problem, f is built from an r with R=3*3=9 elements, and the optimization is performed
% over a parameter space p with P=6 elements.
% The RR_LevenbergMarquardt optimization algorithm then drives f towards zero.
% To apply this method to fit a different nonlinear function to data, just define new Residual r and
% Jacobian J functions, where r has R components and p has P components with R>=P, and rerun.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap03
%% Copyright 2024 by Thomas Bewley, published under the BSD 3-Clause License. 

clear; global R data; format short;  % data to be fitted

% The following lines generate some synthetic data, where p(1:6)={A,a,b,c,x0,y0} in def of Gaussian
p=rand(6,1); p(3)=0.25*(p(2)-p(4)); p_actual=p';
R=0;  for e=0:2; for n=0:2; R=R+1; 
    data(R,1)=e; data(R,2)=n;  % north and east positions of measurements
	data(R,3)=p(1)*exp(-(p(2)*(e-p(5))^2+2*p(3)*(e-p(5))*(n-p(6))+p(4)*(n-p(6))^2)); % height
end, end
% The next 4 lines just make a pretty plot of the data, and the gaussian they were taken from
e=[-2:.1:4]; n=[-2:.1:4]; [E,N]=meshgrid(e,n); figure(1), clf, hold on, ne=length(e); nn=length(n);
for i=1:ne, for j=1:nn, h(j,i)=Compute_Gaussian(e(i),n(j),p); end, end
surf(e,n,h); hold on; title('Original gaussian hill, and its available measurements')
for i=1:R, plot3(data(i,1),data(i,2),data(i,3),'m*','LineWidth',2,'MarkerSize',8), end

% (Replace the above with R pieces of actual data, if you have some, with R>=P in your model)

p0=[0.1; 1; 0; 1; -1; -1];        % (very bad) initial guess for p (note: p0 and p are column vectors!)
p=RR_LevenbergMarquardt(p0,@Residual_Gaussian,@Jacobian_Gaussian); % Perform the optimization to find p

p_initial=p0'  % (note: print them out as row vectors, just to save vertical space...)
p_final=p', disp('Did we get close?  Actual parameters defining the gaussian were'); p_actual

% The next 4 lines just make another pretty plot of the data, and the gaussian to which they were fit
figure(2), clf, hold on,
for i=1:ne, for j=1:nn, h(j,i)=Compute_Gaussian(e(i),n(j),p); end, end
surf(e,n,h); hold on; title('Levenberg Marquardt fit of the available measurements')
for i=1:R, plot3(data(i,1),data(i,2),data(i,3),'m*','LineWidth',2,'MarkerSize',8), end

end % function RR_LevenbergMarquardtFit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h] = Compute_Gaussian(e,n,p) % e=east, n=north, p=parameters, h=height
% Each scalar function h depends on 2 arguments in this case (e and n) as well as the
% parameter vector p (with P=6 parameters in this model)
h=p(1)*exp(-p(2)*(p(5)-e)^2-2*p(3)*(p(5)-e)*(p(6)-n)-p(4)*(p(6)-n)^2);
end % function Compute_Gaussian
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [r] = Residual_Gaussian(p)
% This function calculates the residual vector (with m elements).
% The function to be minimized is f=sum_(i=1)^R r(i)^2
global R data
for i=1:R, e=data(i,1); n=data(i,2); r(i,1)=Compute_Gaussian(e,n,p)-data(i,3); end
end % function Residual_Gaussian
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [J] = Jacobian_Gaussian(p)
% This is the (analytical) derivative of each component of r w.r.t. each component of p
% Note: the {i,j} component of the Jacobian J is the derivative of r(i) w.r.t. p(j)
global R data;
for i=1:R, e=data(i,1); n=data(i,2); h(i)=Compute_Gaussian(e,n,p);
	J(i,:)=h(i)*[1/p(1), -(p(5)-e)^2, -2*(p(5)-e)*(p(6)-n), -(p(6)-n)^2, ...
  	             -2*p(2)*(p(5)-e)-2*p(3)*(p(6)-n), -2*p(3)*(p(5)-e)-2*p(4)*(p(6)-n)];
end
end % function Jacobian_Gaussian

% Note: uncomment the following and plug into Matlab to determine the jacobian of r wrt p:
% syms p1 p2 p3 p4 p5 p6 e n
% h=p1*exp(-(p2*(p5-e)^2+2*p3*(p5-e)*(p6-n)+p4*(p6-n)^2))
% jacobian(h,[p1 p2 p3 p4 p5 p6])
