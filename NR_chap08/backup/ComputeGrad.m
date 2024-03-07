function [g] = ComputeGrad(x,N,Compute_f,method,e) 
% function [g] = ComputeGrad(x,N,Compute_f,method,e) 
% Compute gradient of the the function pointed to by the function handle Compute_f by
% computing the directional derivative one element at a time using a 2nd-order FD approach
% if method="FD", or the complex step derivative approach if method="CSD".
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 8.3.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap08">Chapter 8</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help ComputeGradTest">ComputeGradTest</a>.

for k=1:N, switch method
  case 'FD'
    xr=x; xr(k)=xr(k)+e; xl=x; xl(k)=xl(k)-e; g(k,1)=(Compute_f(xr)-Compute_f(xl))/(2*e);
  case 'CSD'
    xe=x; xe(k,1)=xe(k,1)+i*eps; g(k,1)=imag(Compute_f(xe))/eps;
end, end
end % function ComputeGrad