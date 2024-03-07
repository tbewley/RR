function [g] = ComputeGradFD(x,N,e)                  % Numerical Renaissance Codebase 1.0
% Compute gradient of ComputeJ.m one element at a time using the second-order FD method
for k=1:N;
  xr=x; xr(k,1)=xr(k,1)+e; xl=x; xl(k,1)=xl(k,1)-e;
  g(k,1)=(ComputeJ(xr)-ComputeJ(xl))/(2*e);
end
end % function ComputeGradFD