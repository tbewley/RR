function [g] = ComputeGradCSD(x,N,eps)               % Numerical Renaissance Codebase 1.0
% Compute gradient of ComputeJ.m one element at a time using the CSD method
im=sqrt(-1); for k=1:N; xe=x; xe(k,1)=xe(k,1)+im*eps; g(k,1)=imag(ComputeJ(xe))/eps; end
end % function ComputeGradCSD
