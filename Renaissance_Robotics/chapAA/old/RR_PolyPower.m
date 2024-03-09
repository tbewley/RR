function b=RR_PolyPower(p,n)
% function b=RR_PolyPower(p,n)
% Compute the convolution of the polynomial p with itself n times.  
% INPUTS: p=vector of polynimal coefficients
%         n=integer power to which the polynomial p is to be raised
% OUTPUT: b=vector of polynimal coefficients of b=p^n
% TEST:   p=[1 2], p2=RR_PolyPower(p,2), p3=RR_PolyPower(p,3)
% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if n==0, b=1; else, b=p; for i=2:n, b=RR_PolyProd(b,p); end
end % function RR_PolyPower
