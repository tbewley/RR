function [g] = RC_ComputeGrad(x,N,Compute_f,method,e) 
% function [g] = RC_ComputeGrad(x,N,Compute_f,method,e) 
% Compute gradient of the the function pointed to by the function handle Compute_f(x), by
% computing the directional derivative one element at a time using a 2nd-order FD approach
% if method="FD", or the complex step derivative approach if method="CSD".
% INPUTS:  x = point about which the gradient of Compute_f is desired
%          N = order of the vector x
%          Compute_f = function handle pointing to a Matlab function if interest
%          method = 'FD' for 2nd-order finite difference, or 'CSD' for complex step derivative
%          e = value of perturbation to use
% OUTPUTS: g = gradient of the function Compute_f(x) in the vicinity of x
% TEST:    use RC_ComputeGradTest
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Verify with: <a href="matlab:help ComputeGradTest">ComputeGradTest</a>.

for k=1:N, switch method
  case 'FD'
    xr=x; xr(k)=xr(k)+e; xl=x; xl(k)=xl(k)-e; g(k,1)=(Compute_f(xr)-Compute_f(xl))/(2*e);
  case 'CSD'
    xe=x; xe(k,1)=xe(k,1)+i*e; g(k,1)=imag(Compute_f(xe))/e;
end, end
end % function RC_ComputeGrad