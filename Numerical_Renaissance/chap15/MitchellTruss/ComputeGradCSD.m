function [g] = ComputeGradCSD(ComputeJ,x,params)
% Complex Step Derivative (CSD) approximation of the gradient of the function that is
% pointed to by the function with handle ComputeJ, evaluated in the vicinity of x.
for k=1:length(x), xe=x; xe(k)=xe(k)+i*1e-30; g(k,1)=imag(ComputeJ(xe,params))/1e-30; end
end % function ComputeGradCSD
