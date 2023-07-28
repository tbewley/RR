function F=RR_Chebyshev_Filter(n,epsilon,omegac)
% function F=RR_Chebyshev_Filter(n,epsilon,omegac)
% INPUTS:  n=order of filter (see, e.g., Figures 9.20b, 9.21b)
%          epsilon=ripple in the passband [between 1/(1+epsilon^2) and 1]
%          omegac=cutoff frequency of filter (OPTIONAL, taken as 1 if omitted)
% OUTPUT:  F=n'th order Chebyshev filter of type RR_tf
% EXAMPLE: F=RR_Chebyshev_Filter(4,0.1,0.1), close all, bode(F)
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

p=i*cos(acos(i/epsilon)/n+[0:n-1]*pi/n); den=RR_poly(p,1)
if nargin>2, for k=1:n+1, den.poly(k)=real(den.poly(k))/omegac^(n-k-1); end, end
num=evaluate(den,0); F=RR_tf(num,den)