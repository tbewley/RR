function [p] = RR_LevenbergMarquardt(p,Compute_Residual,Compute_Jacobian,tol,verbose)         
% function [p] = RR_LevenbergMarquardt(p,n,Compute_residual,Compute_jacobian,tol,verbose)         
% This function searches for a p such that r(p)~=0 using the Levenberg Marquardt method,
% where the residual r(p) and its Jacobian are defined in Compute_Residual and Compute_Jacobian,
% (handles to provided functions), and where r has m elements and p has n elements with m>=n.
%   INPUTS: p = initial guess for p
%           Compute_Residual = handle to subroutine to compute the residual vector r
%           Compute_Jacobian = handle to subroutine to compute the Jacobian matrix J
%           tol = tolerance for error, after which solver quits [optional, default=1e-10]
%           verbose = 1 (prints stuff to screen) or 0 (quiet)   [optional, default=1]
%   OUTPUT  p = computed value of p that minimizes f(p)=||r(p)||^2
%   TEST:   RR_LevenbergMarquardtTest
% Note that a compact description of the notation/algorithm used herein is available at
%    https://sites.cs.ucsb.edu/~yfwang/courses/cs290i_mvg/pdf/LMA.pdf
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if nargin<5, tol=1e-10; end, if nargin<6, verbose=1; end
lambda=1; % initial value of lambda
r=Compute_Residual(p); error=norm(r); P=length(p)

if verbose, fprintf('Initial error=%0.8g\n',error), % These 2 lines just print and plot
   if P==2, plot3(p(1),p(2),error,'kx','LineWidth',2,'MarkerSize',8), end, end

failed_steps=0; successful_steps=0;
while (error>tol)
   J=Compute_Jacobian(p);
   H=J'*J; y=p-(H+lambda*diag(diag(H)))\(J'*r); % This one line is the core of Levenberg Marquardt.
   r_new=Compute_Residual(y); error_new=norm(r_new);
   if error_new>error                % Then we just manage the updates to p and lambda and repeat.
      lambda=2*lambda;     % increase lambda (by 2x) for each step that fails to reduce error
      if verbose, fprintf('error=%0.8g, increasing lambda to %0.8g\n',error_new,lambda)
        if P==2, plot3(y(1),y(2),error_new,'ro'), pause(0.1), end, end
      failed_steps=failed_steps+1;
   else
      lambda=lambda/5;     % decrease lambda (by 5x) for each step that successfully reduces error
      p=y; r=r_new; error=error_new;            % do the update, but only on the successful steps!
      if verbose, fprintf('error=%0.8g, decreasing lambda to %0.8g\n',error_new,lambda), p'
        if P==2, plot3(p(1),p(2),error,'kx','LineWidth',2,'MarkerSize',8), pause(0.01), end, end
      successful_steps=successful_steps+1;
   end
end
fprintf('\nfailed and successful steps = %0.8g, %0.8g\n',failed_steps,successful_steps)
end % function RR_LevenbergMarquardt