function b=RR_PolyPower(p,n)
% function b=RR_PolyPower(p,n)
% Compute the convolution of the polynomial p with itself n times.  
% INPUTS: p=vector of polynimal coefficients
%         n=integer power to which the polynomial p is to be raised
% OUTPUT: b=vector of polynimal coefficients of b=p^n
% TEST:   p=[1 2], p2=PolyPower(p,2), p3=PolyPower(p,3)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

if n==0, b=1; else, b=p; for i=2:n, b=RR_PolyConv(b,p); end
end % function RR_PolyPower
