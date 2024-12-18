function [x] = RR_NewtonRaphson(x,n,Compute_f,Compute_A,tol,verbose)         
% function [x] = RR_NewtonRaphson(x,n,Compute_f,Compute_A,tol,verbose)         
% This function solves f(x)=0 using the Newton Raphson method given an initial guess for
% x, where the function f(x) and its Jacobian are defined in Compute_f and Compute_A.
% Take verbose=1 for printing progress reports to screen, or verbose=0 to suppress.
% Trial: <a href="matlab:help NewtonRaphsonTest">NewtonRaphsonTest</a>, which shows how to pass function handles into this code.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

if nargin<5, tol=1e-10; end, residual=2*tol;
if nargin<6, verbose=1; end, if verbose, disp('Convergence:'), end
while (residual>tol)
   f=Compute_f(x);  A=Compute_A(x);  residual=norm(f);  x=x+RR_GaussPP(A,-f,n);
   if verbose, disp(sprintf('%20.13f ',x(1:n),residual)); end
end
end % function RR_NewtonRaphson
